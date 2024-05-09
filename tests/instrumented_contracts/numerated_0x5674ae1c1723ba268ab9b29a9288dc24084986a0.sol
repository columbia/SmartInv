1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address private _owner;
12 
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18   /**
19    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
20    * account.
21    */
22   constructor() internal {
23     _owner = msg.sender;
24     emit OwnershipTransferred(address(0), _owner);
25   }
26 
27   /**
28    * @return the address of the owner.
29    */
30   function owner() public view returns(address) {
31     return _owner;
32   }
33 
34   /**
35    * @dev Throws if called by any account other than the owner.
36    */
37   modifier onlyOwner() {
38     require(isOwner());
39     _;
40   }
41 
42   /**
43    * @return true if `msg.sender` is the owner of the contract.
44    */
45   function isOwner() public view returns(bool) {
46     return msg.sender == _owner;
47   }
48 
49   /**
50    * @dev Allows the current owner to relinquish control of the contract.
51    * @notice Renouncing to ownership will leave the contract without an owner.
52    * It will not be possible to call the functions with the `onlyOwner`
53    * modifier anymore.
54    */
55   function renounceOwnership() public onlyOwner {
56     emit OwnershipTransferred(_owner, address(0));
57     _owner = address(0);
58   }
59 
60   /**
61    * @dev Allows the current owner to transfer control of the contract to a newOwner.
62    * @param newOwner The address to transfer ownership to.
63    */
64   function transferOwnership(address newOwner) public onlyOwner {
65     _transferOwnership(newOwner);
66   }
67 
68   /**
69    * @dev Transfers control of the contract to a newOwner.
70    * @param newOwner The address to transfer ownership to.
71    */
72   function _transferOwnership(address newOwner) internal {
73     require(newOwner != address(0));
74     emit OwnershipTransferred(_owner, newOwner);
75     _owner = newOwner;
76   }
77 }
78 
79 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
80 
81 /**
82  * @title ERC20 interface
83  * @dev see https://github.com/ethereum/EIPs/issues/20
84  */
85 interface IERC20 {
86   function totalSupply() external view returns (uint256);
87 
88   function balanceOf(address who) external view returns (uint256);
89 
90   function allowance(address owner, address spender)
91     external view returns (uint256);
92 
93   function transfer(address to, uint256 value) external returns (bool);
94 
95   function approve(address spender, uint256 value)
96     external returns (bool);
97 
98   function transferFrom(address from, address to, uint256 value)
99     external returns (bool);
100 
101   event Transfer(
102     address indexed from,
103     address indexed to,
104     uint256 value
105   );
106 
107   event Approval(
108     address indexed owner,
109     address indexed spender,
110     uint256 value
111   );
112 }
113 
114 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
115 
116 /**
117  * @title ERC20Detailed token
118  * @dev The decimals are only for visualization purposes.
119  * All the operations are done using the smallest and indivisible token unit,
120  * just as on Ethereum all the operations are done in wei.
121  */
122 contract ERC20Detailed is IERC20 {
123   string private _name;
124   string private _symbol;
125   uint8 private _decimals;
126 
127   constructor(string name, string symbol, uint8 decimals) public {
128     _name = name;
129     _symbol = symbol;
130     _decimals = decimals;
131   }
132 
133   /**
134    * @return the name of the token.
135    */
136   function name() public view returns(string) {
137     return _name;
138   }
139 
140   /**
141    * @return the symbol of the token.
142    */
143   function symbol() public view returns(string) {
144     return _symbol;
145   }
146 
147   /**
148    * @return the number of decimals of the token.
149    */
150   function decimals() public view returns(uint8) {
151     return _decimals;
152   }
153 }
154 
155 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
156 
157 /**
158  * @title SafeMath
159  * @dev Math operations with safety checks that revert on error
160  */
161 library SafeMath {
162 
163   /**
164   * @dev Multiplies two numbers, reverts on overflow.
165   */
166   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
167     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
168     // benefit is lost if 'b' is also tested.
169     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
170     if (a == 0) {
171       return 0;
172     }
173 
174     uint256 c = a * b;
175     require(c / a == b);
176 
177     return c;
178   }
179 
180   /**
181   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
182   */
183   function div(uint256 a, uint256 b) internal pure returns (uint256) {
184     require(b > 0); // Solidity only automatically asserts when dividing by 0
185     uint256 c = a / b;
186     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
187 
188     return c;
189   }
190 
191   /**
192   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
193   */
194   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
195     require(b <= a);
196     uint256 c = a - b;
197 
198     return c;
199   }
200 
201   /**
202   * @dev Adds two numbers, reverts on overflow.
203   */
204   function add(uint256 a, uint256 b) internal pure returns (uint256) {
205     uint256 c = a + b;
206     require(c >= a);
207 
208     return c;
209   }
210 
211   /**
212   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
213   * reverts when dividing by zero.
214   */
215   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
216     require(b != 0);
217     return a % b;
218   }
219 }
220 
221 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
222 
223 /**
224  * @title Standard ERC20 token
225  *
226  * @dev Implementation of the basic standard token.
227  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
228  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
229  */
230 contract ERC20 is IERC20 {
231   using SafeMath for uint256;
232 
233   mapping (address => uint256) private _balances;
234 
235   mapping (address => mapping (address => uint256)) private _allowed;
236 
237   uint256 private _totalSupply;
238 
239   /**
240   * @dev Total number of tokens in existence
241   */
242   function totalSupply() public view returns (uint256) {
243     return _totalSupply;
244   }
245 
246   /**
247   * @dev Gets the balance of the specified address.
248   * @param owner The address to query the balance of.
249   * @return An uint256 representing the amount owned by the passed address.
250   */
251   function balanceOf(address owner) public view returns (uint256) {
252     return _balances[owner];
253   }
254 
255   /**
256    * @dev Function to check the amount of tokens that an owner allowed to a spender.
257    * @param owner address The address which owns the funds.
258    * @param spender address The address which will spend the funds.
259    * @return A uint256 specifying the amount of tokens still available for the spender.
260    */
261   function allowance(
262     address owner,
263     address spender
264    )
265     public
266     view
267     returns (uint256)
268   {
269     return _allowed[owner][spender];
270   }
271 
272   /**
273   * @dev Transfer token for a specified address
274   * @param to The address to transfer to.
275   * @param value The amount to be transferred.
276   */
277   function transfer(address to, uint256 value) public returns (bool) {
278     _transfer(msg.sender, to, value);
279     return true;
280   }
281 
282   /**
283    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
284    * Beware that changing an allowance with this method brings the risk that someone may use both the old
285    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
286    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
287    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
288    * @param spender The address which will spend the funds.
289    * @param value The amount of tokens to be spent.
290    */
291   function approve(address spender, uint256 value) public returns (bool) {
292     require(spender != address(0));
293 
294     _allowed[msg.sender][spender] = value;
295     emit Approval(msg.sender, spender, value);
296     return true;
297   }
298 
299   /**
300    * @dev Transfer tokens from one address to another
301    * @param from address The address which you want to send tokens from
302    * @param to address The address which you want to transfer to
303    * @param value uint256 the amount of tokens to be transferred
304    */
305   function transferFrom(
306     address from,
307     address to,
308     uint256 value
309   )
310     public
311     returns (bool)
312   {
313     require(value <= _allowed[from][msg.sender]);
314 
315     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
316     _transfer(from, to, value);
317     return true;
318   }
319 
320   /**
321    * @dev Increase the amount of tokens that an owner allowed to a spender.
322    * approve should be called when allowed_[_spender] == 0. To increment
323    * allowed value is better to use this function to avoid 2 calls (and wait until
324    * the first transaction is mined)
325    * From MonolithDAO Token.sol
326    * @param spender The address which will spend the funds.
327    * @param addedValue The amount of tokens to increase the allowance by.
328    */
329   function increaseAllowance(
330     address spender,
331     uint256 addedValue
332   )
333     public
334     returns (bool)
335   {
336     require(spender != address(0));
337 
338     _allowed[msg.sender][spender] = (
339       _allowed[msg.sender][spender].add(addedValue));
340     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
341     return true;
342   }
343 
344   /**
345    * @dev Decrease the amount of tokens that an owner allowed to a spender.
346    * approve should be called when allowed_[_spender] == 0. To decrement
347    * allowed value is better to use this function to avoid 2 calls (and wait until
348    * the first transaction is mined)
349    * From MonolithDAO Token.sol
350    * @param spender The address which will spend the funds.
351    * @param subtractedValue The amount of tokens to decrease the allowance by.
352    */
353   function decreaseAllowance(
354     address spender,
355     uint256 subtractedValue
356   )
357     public
358     returns (bool)
359   {
360     require(spender != address(0));
361 
362     _allowed[msg.sender][spender] = (
363       _allowed[msg.sender][spender].sub(subtractedValue));
364     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
365     return true;
366   }
367 
368   /**
369   * @dev Transfer token for a specified addresses
370   * @param from The address to transfer from.
371   * @param to The address to transfer to.
372   * @param value The amount to be transferred.
373   */
374   function _transfer(address from, address to, uint256 value) internal {
375     require(value <= _balances[from]);
376     require(to != address(0));
377 
378     _balances[from] = _balances[from].sub(value);
379     _balances[to] = _balances[to].add(value);
380     emit Transfer(from, to, value);
381   }
382 
383   /**
384    * @dev Internal function that mints an amount of the token and assigns it to
385    * an account. This encapsulates the modification of balances such that the
386    * proper events are emitted.
387    * @param account The account that will receive the created tokens.
388    * @param value The amount that will be created.
389    */
390   function _mint(address account, uint256 value) internal {
391     require(account != 0);
392     _totalSupply = _totalSupply.add(value);
393     _balances[account] = _balances[account].add(value);
394     emit Transfer(address(0), account, value);
395   }
396 
397   /**
398    * @dev Internal function that burns an amount of the token of a given
399    * account.
400    * @param account The account whose tokens will be burnt.
401    * @param value The amount that will be burnt.
402    */
403   function _burn(address account, uint256 value) internal {
404     require(account != 0);
405     require(value <= _balances[account]);
406 
407     _totalSupply = _totalSupply.sub(value);
408     _balances[account] = _balances[account].sub(value);
409     emit Transfer(account, address(0), value);
410   }
411 
412   /**
413    * @dev Internal function that burns an amount of the token of a given
414    * account, deducting from the sender's allowance for said account. Uses the
415    * internal burn function.
416    * @param account The account whose tokens will be burnt.
417    * @param value The amount that will be burnt.
418    */
419   function _burnFrom(address account, uint256 value) internal {
420     require(value <= _allowed[account][msg.sender]);
421 
422     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
423     // this function needs to emit an event with the updated approval.
424     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
425       value);
426     _burn(account, value);
427   }
428 }
429 
430 // File: openzeppelin-solidity/contracts/access/Roles.sol
431 
432 /**
433  * @title Roles
434  * @dev Library for managing addresses assigned to a Role.
435  */
436 library Roles {
437   struct Role {
438     mapping (address => bool) bearer;
439   }
440 
441   /**
442    * @dev give an account access to this role
443    */
444   function add(Role storage role, address account) internal {
445     require(account != address(0));
446     require(!has(role, account));
447 
448     role.bearer[account] = true;
449   }
450 
451   /**
452    * @dev remove an account's access to this role
453    */
454   function remove(Role storage role, address account) internal {
455     require(account != address(0));
456     require(has(role, account));
457 
458     role.bearer[account] = false;
459   }
460 
461   /**
462    * @dev check if an account has this role
463    * @return bool
464    */
465   function has(Role storage role, address account)
466     internal
467     view
468     returns (bool)
469   {
470     require(account != address(0));
471     return role.bearer[account];
472   }
473 }
474 
475 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
476 
477 contract PauserRole {
478   using Roles for Roles.Role;
479 
480   event PauserAdded(address indexed account);
481   event PauserRemoved(address indexed account);
482 
483   Roles.Role private pausers;
484 
485   constructor() internal {
486     _addPauser(msg.sender);
487   }
488 
489   modifier onlyPauser() {
490     require(isPauser(msg.sender));
491     _;
492   }
493 
494   function isPauser(address account) public view returns (bool) {
495     return pausers.has(account);
496   }
497 
498   function addPauser(address account) public onlyPauser {
499     _addPauser(account);
500   }
501 
502   function renouncePauser() public {
503     _removePauser(msg.sender);
504   }
505 
506   function _addPauser(address account) internal {
507     pausers.add(account);
508     emit PauserAdded(account);
509   }
510 
511   function _removePauser(address account) internal {
512     pausers.remove(account);
513     emit PauserRemoved(account);
514   }
515 }
516 
517 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
518 
519 /**
520  * @title Pausable
521  * @dev Base contract which allows children to implement an emergency stop mechanism.
522  */
523 contract Pausable is PauserRole {
524   event Paused(address account);
525   event Unpaused(address account);
526 
527   bool private _paused;
528 
529   constructor() internal {
530     _paused = false;
531   }
532 
533   /**
534    * @return true if the contract is paused, false otherwise.
535    */
536   function paused() public view returns(bool) {
537     return _paused;
538   }
539 
540   /**
541    * @dev Modifier to make a function callable only when the contract is not paused.
542    */
543   modifier whenNotPaused() {
544     require(!_paused);
545     _;
546   }
547 
548   /**
549    * @dev Modifier to make a function callable only when the contract is paused.
550    */
551   modifier whenPaused() {
552     require(_paused);
553     _;
554   }
555 
556   /**
557    * @dev called by the owner to pause, triggers stopped state
558    */
559   function pause() public onlyPauser whenNotPaused {
560     _paused = true;
561     emit Paused(msg.sender);
562   }
563 
564   /**
565    * @dev called by the owner to unpause, returns to normal state
566    */
567   function unpause() public onlyPauser whenPaused {
568     _paused = false;
569     emit Unpaused(msg.sender);
570   }
571 }
572 
573 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Pausable.sol
574 
575 /**
576  * @title Pausable token
577  * @dev ERC20 modified with pausable transfers.
578  **/
579 contract ERC20Pausable is ERC20, Pausable {
580 
581   function transfer(
582     address to,
583     uint256 value
584   )
585     public
586     whenNotPaused
587     returns (bool)
588   {
589     return super.transfer(to, value);
590   }
591 
592   function transferFrom(
593     address from,
594     address to,
595     uint256 value
596   )
597     public
598     whenNotPaused
599     returns (bool)
600   {
601     return super.transferFrom(from, to, value);
602   }
603 
604   function approve(
605     address spender,
606     uint256 value
607   )
608     public
609     whenNotPaused
610     returns (bool)
611   {
612     return super.approve(spender, value);
613   }
614 
615   function increaseAllowance(
616     address spender,
617     uint addedValue
618   )
619     public
620     whenNotPaused
621     returns (bool success)
622   {
623     return super.increaseAllowance(spender, addedValue);
624   }
625 
626   function decreaseAllowance(
627     address spender,
628     uint subtractedValue
629   )
630     public
631     whenNotPaused
632     returns (bool success)
633   {
634     return super.decreaseAllowance(spender, subtractedValue);
635   }
636 }
637 
638 // File: contracts/SignkeysToken.sol
639 
640 contract SignkeysToken is ERC20Pausable, ERC20Detailed, Ownable {
641 
642     uint8 public constant DECIMALS = 18;
643 
644     uint256 public constant INITIAL_SUPPLY = 2E10 * (10 ** uint256(DECIMALS));
645 
646     /**
647      * @dev Constructor that gives msg.sender all of existing tokens.
648      */
649     constructor() public ERC20Detailed("SignkeysToken", "KEYS", DECIMALS) {
650         _mint(owner(), INITIAL_SUPPLY);
651     }
652 
653     function approveAndCall(address _spender, uint256 _value, bytes _data) public payable returns (bool success) {
654         require(_spender != address(this));
655         require(super.approve(_spender, _value));
656         require(_spender.call(_data));
657         return true;
658     }
659 
660     function() payable external {
661         revert();
662     }
663 }
664 
665 contract ReentrancyGuard {
666 
667   /// @dev counter to allow mutex lock with only one SSTORE operation
668   uint256 private _guardCounter;
669 
670   constructor() internal {
671     // The counter starts at one to prevent changing it from zero to a non-zero
672     // value, which is a more expensive operation.
673     _guardCounter = 1;
674   }
675 
676   /**
677    * @dev Prevents a contract from calling itself, directly or indirectly.
678    * Calling a `nonReentrant` function from another `nonReentrant`
679    * function is not supported. It is possible to prevent this from happening
680    * by making the `nonReentrant` function external, and make it call a
681    * `private` function that does the actual work.
682    */
683   modifier nonReentrant() {
684     _guardCounter += 1;
685     uint256 localCounter = _guardCounter;
686     _;
687     require(localCounter == _guardCounter);
688   }
689 
690 }
691 
692 contract SignkeysCrowdsale is Ownable, ReentrancyGuard {
693     using SafeMath for uint256;
694 
695     uint256 public INITIAL_TOKEN_PRICE_CENTS = 10;
696 
697     /* Token contract */
698     SignkeysToken public signkeysToken;
699 
700     /* Bonus program contract*/
701     SignkeysBonusProgram public signkeysBonusProgram;
702 
703     /* signer address, can be set by owner only */
704     address public signer;
705 
706     /* ETH funds will be transferred to this address */
707     address public wallet;
708 
709     /* Current token price in cents */
710     uint256 public tokenPriceCents;
711 
712     // Buyer bought the amount of tokens with tokenPrice
713     event BuyTokens(
714         address indexed buyer,
715         address indexed tokenReceiver,
716         uint256 tokenPrice,
717         uint256 amount
718     );
719 
720     // Wallet changed
721     event WalletChanged(address newWallet);
722 
723     // Signer changed
724     event CrowdsaleSignerChanged(address newSigner);
725 
726     // Token price changed
727     event TokenPriceChanged(uint256 oldPrice, uint256 newPrice);
728 
729     constructor(
730         address _token,
731         address _bonusProgram,
732         address _wallet,
733         address _signer
734     ) public {
735         require(_token != 0x0, "Token contract for crowdsale must be set");
736         require(_bonusProgram != 0x0, "Referrer smart contract for crowdsale must be set");
737 
738         require(_wallet != 0x0, "Wallet for fund transferring must be set");
739         require(_signer != 0x0, "Signer must be set");
740 
741         signkeysToken = SignkeysToken(_token);
742         signkeysBonusProgram = SignkeysBonusProgram(_bonusProgram);
743 
744         signer = _signer;
745         wallet = _wallet;
746 
747         tokenPriceCents = INITIAL_TOKEN_PRICE_CENTS;
748     }
749 
750     function setSignerAddress(address _signer) external onlyOwner {
751         signer = _signer;
752         emit CrowdsaleSignerChanged(_signer);
753     }
754 
755     function setWalletAddress(address _wallet) external onlyOwner {
756         wallet = _wallet;
757         emit WalletChanged(_wallet);
758     }
759 
760     function setBonusProgram(address _bonusProgram) external onlyOwner {
761         signkeysBonusProgram = SignkeysBonusProgram(_bonusProgram);
762     }
763 
764     function setTokenPriceCents(uint256 _tokenPriceCents) external onlyOwner {
765         emit TokenPriceChanged(tokenPriceCents, _tokenPriceCents);
766         tokenPriceCents = _tokenPriceCents;
767     }
768 
769     /**
770      * @dev Make an investment.
771      *
772      * @param _tokenReceiver address where the tokens need to be transfered
773      * @param _referrer address of user that invited _tokenReceiver for this purchase
774      * @param _tokenPrice price per one token including decimals
775      * @param _minWei minimal amount of wei buyer should invest
776      * @param _expiration expiration on token
777      */
778     function buyTokens(
779         address _tokenReceiver,
780         address _referrer,
781         uint256 _couponCampaignId, // starts with 1 if there is some, 0 means no coupon
782         uint256 _tokenPrice,
783         uint256 _minWei,
784         uint256 _expiration,
785         uint8 _v,
786         bytes32 _r,
787         bytes32 _s
788     ) payable external nonReentrant {
789         require(_expiration >= now, "Signature expired");
790         require(_tokenReceiver != 0x0, "Token receiver must be provided");
791         require(_minWei > 0, "Minimal amount to purchase must be greater than 0");
792 
793         require(wallet != 0x0, "Wallet must be set");
794         require(msg.value >= _minWei, "Purchased amount is less than min amount to invest");
795 
796         address receivedSigner = ecrecover(
797             keccak256(
798                 abi.encodePacked(
799                     _tokenPrice, _minWei, _tokenReceiver, _referrer, _couponCampaignId, _expiration
800                 )
801             ), _v, _r, _s);
802 
803         require(receivedSigner == signer, "Something wrong with signature");
804 
805         uint256 tokensAmount = msg.value.mul(10 ** uint256(signkeysToken.decimals())).div(_tokenPrice);
806         require(signkeysToken.balanceOf(this) >= tokensAmount, "Not enough tokens in sale contract");
807 
808         // Eliminating stackTooDeep error: tokensAmount.mul(signkeysVesting.percentageToLock()).div(100) is amount for vesting
809         signkeysToken.transfer(_tokenReceiver, tokensAmount);
810 
811         // send bonuses according to signkeys bonus program
812         signkeysBonusProgram.sendBonus(
813             _referrer,
814             _tokenReceiver,
815             tokensAmount,
816             (tokensAmount.mul(tokenPriceCents).div(10 ** uint256(signkeysToken.decimals()))),
817             _couponCampaignId);
818 
819         // Pocket the money, or fail the crowdsale if we for some reason cannot send the money to our wallet
820         wallet.transfer(msg.value);
821 
822         emit BuyTokens(msg.sender, _tokenReceiver, _tokenPrice, tokensAmount);
823     }
824 
825     /**
826      * Don't expect to just send in money and get tokens.
827      */
828     function() payable external {
829         revert();
830     }
831 
832     function withdrawTokens() external onlyOwner {
833         uint256 amount = signkeysToken.balanceOf(this);
834         address tokenOwner = signkeysToken.owner();
835         signkeysToken.transfer(tokenOwner, amount);
836     }
837 }
838 
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
860         require(msg.sender == address(bonusProgram), "Bonus program rewards state may be changed only by ");
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
889 contract SignkeysBonusProgram is Ownable {
890     using SafeMath for uint256;
891 
892     /* Token contract */
893     SignkeysToken token;
894 
895     /* Crowdsale contract */
896     SignkeysCrowdsale crowdsale;
897 
898     /* SignkeysBonusProgramRewards contract to keep bonus state */
899     SignkeysBonusProgramRewards bonusProgramRewards;
900 
901     uint256[] public referralBonusTokensAmountRanges = [199, 1000, 10000, 100000, 1000000, 10000000];
902     uint256[] public referrerRewards = [5, 50, 500, 5000, 50000];
903     uint256[] public buyerRewards = [5, 50, 500, 5000, 50000];
904 
905     uint256[] public purchaseAmountRangesInCents = [2000, 1000000, 10000000];
906     uint256[] public purchaseRewardsPercents = [10, 15, 20];
907 
908     event BonusSent(
909         address indexed referrerAddress,
910         uint256 referrerBonus,
911         address indexed buyerAddress,
912         uint256 buyerBonus,
913         uint256 purchaseBonus,
914         uint256 couponBonus
915     );
916 
917     constructor(address _token, address _bonusProgramRewards) public {
918         token = SignkeysToken(_token);
919         bonusProgramRewards = SignkeysBonusProgramRewards(_bonusProgramRewards);
920     }
921 
922     function setCrowdsaleContract(address _crowdsale) public onlyOwner {
923         crowdsale = SignkeysCrowdsale(_crowdsale);
924     }
925 
926     function setBonusProgramRewardsContract(address _bonusProgramRewards) public onlyOwner {
927         bonusProgramRewards = SignkeysBonusProgramRewards(_bonusProgramRewards);
928     }
929 
930     function calcBonus(uint256 tokensAmount, uint256[] rewards) private view returns (uint256) {
931         uint256 multiplier = 10 ** uint256(token.decimals());
932         if (tokensAmount <= multiplier.mul(referralBonusTokensAmountRanges[0])) {
933             return 0;
934         }
935         for (uint i = 1; i < referralBonusTokensAmountRanges.length; i++) {
936             uint min = referralBonusTokensAmountRanges[i - 1];
937             uint max = referralBonusTokensAmountRanges[i];
938             if (tokensAmount > min.mul(multiplier) && tokensAmount <= max.mul(multiplier)) {
939                 return multiplier.mul(rewards[i - 1]);
940             }
941         }
942     }
943 
944     function calcPurchaseBonus(uint256 amountCents, uint256 tokensAmount) private view returns (uint256) {
945         if (amountCents < purchaseAmountRangesInCents[0]) {
946             return 0;
947         }
948         for (uint i = 1; i < purchaseAmountRangesInCents.length; i++) {
949             if (amountCents >= purchaseAmountRangesInCents[i - 1] && amountCents < purchaseAmountRangesInCents[i]) {
950                 return tokensAmount.mul(purchaseRewardsPercents[i - 1]).div(100);
951             }
952         }
953         if (amountCents >= purchaseAmountRangesInCents[purchaseAmountRangesInCents.length - 1]) {
954             return tokensAmount.mul(purchaseRewardsPercents[purchaseAmountRangesInCents.length - 1]).div(100);
955         }
956     }
957 
958 
959     function sendBonus(address referrer, address buyer, uint256 _tokensAmount, uint256 _valueCents, uint256 _couponCampaignId) external returns (uint256)  {
960         require(msg.sender == address(crowdsale), "Bonus may be sent only by crowdsale contract");
961 
962         uint256 referrerBonus = 0;
963         uint256 buyerBonus = 0;
964         uint256 purchaseBonus = 0;
965         uint256 couponBonus = 0;
966 
967         uint256 referrerBonusAmount = calcBonus(_tokensAmount, referrerRewards);
968         uint256 buyerBonusAmount = calcBonus(_tokensAmount, buyerRewards);
969         uint256 purchaseBonusAmount = calcPurchaseBonus(_valueCents, _tokensAmount);
970 
971         if (referrer != 0x0 && !bonusProgramRewards.areReferralBonusesSent(buyer)) {
972             if (referrerBonusAmount > 0 && token.balanceOf(this) > referrerBonusAmount) {
973                 token.transfer(referrer, referrerBonusAmount);
974                 bonusProgramRewards.setReferralBonusesSent(buyer, true);
975                 referrerBonus = referrerBonusAmount;
976             }
977 
978             if (buyerBonusAmount > 0 && token.balanceOf(this) > buyerBonusAmount) {
979                 bonusProgramRewards.setReferralBonusesSent(buyer, true);
980                 buyerBonus = buyerBonusAmount;
981             }
982         }
983 
984         if (token.balanceOf(this) > purchaseBonusAmount.add(buyerBonus)) {
985             purchaseBonus = purchaseBonusAmount;
986         }
987 
988         if (_couponCampaignId > 0 && !bonusProgramRewards.isCouponUsed(buyer, _couponCampaignId)) {
989             if (
990                 token.balanceOf(this) > purchaseBonusAmount
991                 .add(buyerBonus)
992                 .add(bonusProgramRewards.getCouponCampaignBonusTokensAmount(_couponCampaignId))
993             ) {
994                 bonusProgramRewards.setCouponUsed(buyer, _couponCampaignId, true);
995                 couponBonus = bonusProgramRewards.getCouponCampaignBonusTokensAmount(_couponCampaignId);
996             }
997         }
998 
999         if (buyerBonus > 0 || purchaseBonus > 0 || couponBonus > 0) {
1000             token.transfer(buyer, buyerBonus.add(purchaseBonus).add(couponBonus));
1001         }
1002 
1003         emit BonusSent(referrer, referrerBonus, buyer, buyerBonus, purchaseBonus, couponBonus);
1004     }
1005 
1006     function getReferralBonusTokensAmountRanges() public view returns (uint256[]) {
1007         return referralBonusTokensAmountRanges;
1008     }
1009 
1010     function getReferrerRewards() public view returns (uint256[]) {
1011         return referrerRewards;
1012     }
1013 
1014     function getBuyerRewards() public view returns (uint256[]) {
1015         return buyerRewards;
1016     }
1017 
1018     function getPurchaseRewardsPercents() public view returns (uint256[]) {
1019         return purchaseRewardsPercents;
1020     }
1021 
1022     function getPurchaseAmountRangesInCents() public view returns (uint256[]) {
1023         return purchaseAmountRangesInCents;
1024     }
1025 
1026     function setReferralBonusTokensAmountRanges(uint[] ranges) public onlyOwner {
1027         referralBonusTokensAmountRanges = ranges;
1028     }
1029 
1030     function setReferrerRewards(uint[] rewards) public onlyOwner {
1031         require(rewards.length == referralBonusTokensAmountRanges.length - 1);
1032         referrerRewards = rewards;
1033     }
1034 
1035     function setBuyerRewards(uint[] rewards) public onlyOwner {
1036         require(rewards.length == referralBonusTokensAmountRanges.length - 1);
1037         buyerRewards = rewards;
1038     }
1039 
1040     function setPurchaseAmountRangesInCents(uint[] ranges) public onlyOwner {
1041         purchaseAmountRangesInCents = ranges;
1042     }
1043 
1044     function setPurchaseRewardsPercents(uint[] rewards) public onlyOwner {
1045         require(rewards.length == purchaseAmountRangesInCents.length);
1046         purchaseRewardsPercents = rewards;
1047     }
1048 
1049     function withdrawTokens() external onlyOwner {
1050         uint256 amount = token.balanceOf(this);
1051         address tokenOwner = token.owner();
1052         token.transfer(tokenOwner, amount);
1053     }
1054 }
1055 
1056 
1057 contract SignkeysVesting is Ownable {
1058     using SafeMath for uint256;
1059 
1060     uint256 public INITIAL_VESTING_CLIFF_SECONDS = 180 days;
1061     uint256 public INITIAL_PERCENTAGE_TO_LOCK = 50; // 50%
1062 
1063     // The token to which we add the vesting restrictions
1064     SignkeysToken public signkeysToken;
1065 
1066     // the start date of crowdsale
1067     uint public vestingStartDateTime;
1068 
1069     // the date after which user is able to sell all his tokens
1070     uint public vestingCliffDateTime;
1071 
1072     // the percentage of tokens to lock immediately after buying
1073     uint256 public percentageToLock;
1074 
1075     /* The amount of locked tokens for each user */
1076     mapping(address => uint256) private _balances;
1077 
1078     event TokensLocked(address indexed user, uint amount);
1079     event TokensReleased(address indexed user, uint amount);
1080 
1081     constructor() public{
1082         vestingStartDateTime = now;
1083         vestingCliffDateTime = SafeMath.add(now, INITIAL_VESTING_CLIFF_SECONDS);
1084         percentageToLock = INITIAL_PERCENTAGE_TO_LOCK;
1085     }
1086 
1087     function setToken(address token) external onlyOwner {
1088         signkeysToken = SignkeysToken(token);
1089     }
1090 
1091     function balanceOf(address tokenHolder) external view returns (uint256) {
1092         return _balances[tokenHolder];
1093     }
1094 
1095     function lock(address _user, uint256 _amount) external returns (uint256)  {
1096         signkeysToken.transferFrom(msg.sender, this, _amount);
1097 
1098         _balances[_user] = _balances[_user].add(_amount);
1099 
1100         emit TokensLocked(_user, _amount);
1101 
1102         return _balances[_user];
1103     }
1104 
1105     /**
1106      * @notice Transfers vested tokens back to user.
1107      * @param _user user that asks to release his tokens
1108      */
1109     function release(address _user) private {
1110         require(vestingCliffDateTime <= now, "Cannot release vested tokens until vesting cliff date");
1111         uint256 unreleased = _balances[_user];
1112 
1113         if (unreleased > 0) {
1114             signkeysToken.transfer(_user, unreleased);
1115             _balances[_user] = _balances[_user].sub(unreleased);
1116         }
1117 
1118         emit TokensReleased(_user, unreleased);
1119     }
1120 
1121     function release() public {
1122         release(msg.sender);
1123     }
1124 
1125     function setVestingStartDateTime(uint _vestingStartDateTime) external onlyOwner {
1126         require(_vestingStartDateTime <= vestingCliffDateTime, "Start date should be less or equal than cliff date");
1127         vestingStartDateTime = _vestingStartDateTime;
1128     }
1129 
1130     function setVestingCliffDateTime(uint _vestingCliffDateTime) external onlyOwner {
1131         require(vestingStartDateTime <= _vestingCliffDateTime, "Cliff date should be greater or equal than start date");
1132         vestingCliffDateTime = _vestingCliffDateTime;
1133     }
1134 
1135     function setPercentageToLock(uint256 percentage) external onlyOwner {
1136         require(percentage >= 0 && percentage <= 100, "Percentage must be in range [0, 100]");
1137         percentageToLock = percentage;
1138     }
1139 
1140 
1141 }