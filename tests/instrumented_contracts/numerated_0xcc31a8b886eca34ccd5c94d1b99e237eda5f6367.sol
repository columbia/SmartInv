1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, reverts on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     uint256 c = a * b;
21     require(c / a == b);
22 
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     require(b > 0); // Solidity only automatically asserts when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34     return c;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     require(b <= a);
42     uint256 c = a - b;
43 
44     return c;
45   }
46 
47   /**
48   * @dev Adds two numbers, reverts on overflow.
49   */
50   function add(uint256 a, uint256 b) internal pure returns (uint256) {
51     uint256 c = a + b;
52     require(c >= a);
53 
54     return c;
55   }
56 
57   /**
58   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
59   * reverts when dividing by zero.
60   */
61   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62     require(b != 0);
63     return a % b;
64   }
65 }
66 
67 
68 /**
69  * @title ERC20 interface
70  * @dev see https://github.com/ethereum/EIPs/issues/20
71  */
72 interface IERC20 {
73   function totalSupply() external view returns (uint256);
74 
75   function balanceOf(address who) external view returns (uint256);
76 
77   function allowance(address owner, address spender)
78     external view returns (uint256);
79 
80   function transfer(address to, uint256 value) external returns (bool);
81 
82   function approve(address spender, uint256 value)
83     external returns (bool);
84 
85   function transferFrom(address from, address to, uint256 value)
86     external returns (bool);
87 
88   event Transfer(
89     address indexed from,
90     address indexed to,
91     uint256 value
92   );
93 
94   event Approval(
95     address indexed owner,
96     address indexed spender,
97     uint256 value
98   );
99 }
100 
101 
102 /**
103  * @title Roles
104  * @dev Library for managing addresses assigned to a Role.
105  */
106 library Roles {
107   struct Role {
108     mapping (address => bool) bearer;
109   }
110 
111   /**
112    * @dev give an account access to this role
113    */
114   function add(Role storage role, address account) internal {
115     require(account != address(0));
116     require(!has(role, account));
117 
118     role.bearer[account] = true;
119   }
120 
121   /**
122    * @dev remove an account's access to this role
123    */
124   function remove(Role storage role, address account) internal {
125     require(account != address(0));
126     require(has(role, account));
127 
128     role.bearer[account] = false;
129   }
130 
131   /**
132    * @dev check if an account has this role
133    * @return bool
134    */
135   function has(Role storage role, address account)
136     internal
137     view
138     returns (bool)
139   {
140     require(account != address(0));
141     return role.bearer[account];
142   }
143 }
144 
145 
146 
147 
148 contract PauserRole {
149   using Roles for Roles.Role;
150 
151   event PauserAdded(address indexed account);
152   event PauserRemoved(address indexed account);
153 
154   Roles.Role private pausers;
155 
156   constructor() internal {
157     _addPauser(msg.sender);
158   }
159 
160   modifier onlyPauser() {
161     require(isPauser(msg.sender));
162     _;
163   }
164 
165   function isPauser(address account) public view returns (bool) {
166     return pausers.has(account);
167   }
168 
169   function addPauser(address account) public onlyPauser {
170     _addPauser(account);
171   }
172 
173   function renouncePauser() public {
174     _removePauser(msg.sender);
175   }
176 
177   function _addPauser(address account) internal {
178     pausers.add(account);
179     emit PauserAdded(account);
180   }
181 
182   function _removePauser(address account) internal {
183     pausers.remove(account);
184     emit PauserRemoved(account);
185   }
186 }
187 
188 
189 
190 
191 
192 
193 /**
194  * @title Pausable
195  * @dev Base contract which allows children to implement an emergency stop mechanism.
196  */
197 contract Pausable is PauserRole {
198   event Paused(address account);
199   event Unpaused(address account);
200 
201   bool private _paused;
202 
203   constructor() internal {
204     _paused = false;
205   }
206 
207   /**
208    * @return true if the contract is paused, false otherwise.
209    */
210   function paused() public view returns(bool) {
211     return _paused;
212   }
213 
214   /**
215    * @dev Modifier to make a function callable only when the contract is not paused.
216    */
217   modifier whenNotPaused() {
218     require(!_paused);
219     _;
220   }
221 
222   /**
223    * @dev Modifier to make a function callable only when the contract is paused.
224    */
225   modifier whenPaused() {
226     require(_paused);
227     _;
228   }
229 
230   /**
231    * @dev called by the owner to pause, triggers stopped state
232    */
233   function pause() public onlyPauser whenNotPaused {
234     _paused = true;
235     emit Paused(msg.sender);
236   }
237 
238   /**
239    * @dev called by the owner to unpause, returns to normal state
240    */
241   function unpause() public onlyPauser whenPaused {
242     _paused = false;
243     emit Unpaused(msg.sender);
244   }
245 }
246 
247 
248 
249 /**
250  * @title Ownable
251  * @dev The Ownable contract has an owner address, and provides basic authorization control
252  * functions, this simplifies the implementation of "user permissions".
253  */
254 contract Ownable {
255   address private _owner;
256 
257   event OwnershipTransferred(
258     address indexed previousOwner,
259     address indexed newOwner
260   );
261 
262   /**
263    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
264    * account.
265    */
266   constructor() internal {
267     _owner = msg.sender;
268     emit OwnershipTransferred(address(0), _owner);
269   }
270 
271   /**
272    * @return the address of the owner.
273    */
274   function owner() public view returns(address) {
275     return _owner;
276   }
277 
278   /**
279    * @dev Throws if called by any account other than the owner.
280    */
281   modifier onlyOwner() {
282     require(isOwner());
283     _;
284   }
285 
286   /**
287    * @return true if `msg.sender` is the owner of the contract.
288    */
289   function isOwner() public view returns(bool) {
290     return msg.sender == _owner;
291   }
292 
293   /**
294    * @dev Allows the current owner to relinquish control of the contract.
295    * @notice Renouncing to ownership will leave the contract without an owner.
296    * It will not be possible to call the functions with the `onlyOwner`
297    * modifier anymore.
298    */
299   function renounceOwnership() public onlyOwner {
300     emit OwnershipTransferred(_owner, address(0));
301     _owner = address(0);
302   }
303 
304   /**
305    * @dev Allows the current owner to transfer control of the contract to a newOwner.
306    * @param newOwner The address to transfer ownership to.
307    */
308   function transferOwnership(address newOwner) public onlyOwner {
309     _transferOwnership(newOwner);
310   }
311 
312   /**
313    * @dev Transfers control of the contract to a newOwner.
314    * @param newOwner The address to transfer ownership to.
315    */
316   function _transferOwnership(address newOwner) internal {
317     require(newOwner != address(0));
318     emit OwnershipTransferred(_owner, newOwner);
319     _owner = newOwner;
320   }
321 }
322 
323 
324 
325 
326 
327 /**
328  * @title Elliptic curve signature operations
329  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
330  * TODO Remove this library once solidity supports passing a signature to ecrecover.
331  * See https://github.com/ethereum/solidity/issues/864
332  */
333 
334 library ECDSA {
335 
336   /**
337    * @dev Recover signer address from a message by using their signature
338    * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
339    * @param signature bytes signature, the signature is generated using web3.eth.sign()
340    */
341   function recover(bytes32 hash, bytes signature)
342     internal
343     pure
344     returns (address)
345   {
346     bytes32 r;
347     bytes32 s;
348     uint8 v;
349 
350     // Check the signature length
351     if (signature.length != 65) {
352       return (address(0));
353     }
354 
355     // Divide the signature in r, s and v variables
356     // ecrecover takes the signature parameters, and the only way to get them
357     // currently is to use assembly.
358     // solium-disable-next-line security/no-inline-assembly
359     assembly {
360       r := mload(add(signature, 0x20))
361       s := mload(add(signature, 0x40))
362       v := byte(0, mload(add(signature, 0x60)))
363     }
364 
365     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
366     if (v < 27) {
367       v += 27;
368     }
369 
370     // If the version is correct return the signer address
371     if (v != 27 && v != 28) {
372       return (address(0));
373     } else {
374       // solium-disable-next-line arg-overflow
375       return ecrecover(hash, v, r, s);
376     }
377   }
378 
379   /**
380    * toEthSignedMessageHash
381    * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
382    * and hash the result
383    */
384   function toEthSignedMessageHash(bytes32 hash)
385     internal
386     pure
387     returns (bytes32)
388   {
389     // 32 is the length in bytes of hash,
390     // enforced by the type signature above
391     return keccak256(
392       abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
393     );
394   }
395 }
396 
397 
398 
399 
400 
401 
402 
403 
404 
405 
406 
407 
408 /**
409  * @title Standard ERC20 token
410  *
411  * @dev Implementation of the basic standard token.
412  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
413  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
414  */
415 contract ERC20 is IERC20 {
416   using SafeMath for uint256;
417 
418   mapping (address => uint256) private _balances;
419 
420   mapping (address => mapping (address => uint256)) private _allowed;
421 
422   uint256 private _totalSupply;
423 
424   /**
425   * @dev Total number of tokens in existence
426   */
427   function totalSupply() public view returns (uint256) {
428     return _totalSupply;
429   }
430 
431   /**
432   * @dev Gets the balance of the specified address.
433   * @param owner The address to query the balance of.
434   * @return An uint256 representing the amount owned by the passed address.
435   */
436   function balanceOf(address owner) public view returns (uint256) {
437     return _balances[owner];
438   }
439 
440   /**
441    * @dev Function to check the amount of tokens that an owner allowed to a spender.
442    * @param owner address The address which owns the funds.
443    * @param spender address The address which will spend the funds.
444    * @return A uint256 specifying the amount of tokens still available for the spender.
445    */
446   function allowance(
447     address owner,
448     address spender
449    )
450     public
451     view
452     returns (uint256)
453   {
454     return _allowed[owner][spender];
455   }
456 
457   /**
458   * @dev Transfer token for a specified address
459   * @param to The address to transfer to.
460   * @param value The amount to be transferred.
461   */
462   function transfer(address to, uint256 value) public returns (bool) {
463     _transfer(msg.sender, to, value);
464     return true;
465   }
466 
467   /**
468    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
469    * Beware that changing an allowance with this method brings the risk that someone may use both the old
470    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
471    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
472    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
473    * @param spender The address which will spend the funds.
474    * @param value The amount of tokens to be spent.
475    */
476   function approve(address spender, uint256 value) public returns (bool) {
477     require(spender != address(0));
478 
479     _allowed[msg.sender][spender] = value;
480     emit Approval(msg.sender, spender, value);
481     return true;
482   }
483 
484   /**
485    * @dev Transfer tokens from one address to another
486    * @param from address The address which you want to send tokens from
487    * @param to address The address which you want to transfer to
488    * @param value uint256 the amount of tokens to be transferred
489    */
490   function transferFrom(
491     address from,
492     address to,
493     uint256 value
494   )
495     public
496     returns (bool)
497   {
498     require(value <= _allowed[from][msg.sender]);
499 
500     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
501     _transfer(from, to, value);
502     return true;
503   }
504 
505   /**
506    * @dev Increase the amount of tokens that an owner allowed to a spender.
507    * approve should be called when allowed_[_spender] == 0. To increment
508    * allowed value is better to use this function to avoid 2 calls (and wait until
509    * the first transaction is mined)
510    * From MonolithDAO Token.sol
511    * @param spender The address which will spend the funds.
512    * @param addedValue The amount of tokens to increase the allowance by.
513    */
514   function increaseAllowance(
515     address spender,
516     uint256 addedValue
517   )
518     public
519     returns (bool)
520   {
521     require(spender != address(0));
522 
523     _allowed[msg.sender][spender] = (
524       _allowed[msg.sender][spender].add(addedValue));
525     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
526     return true;
527   }
528 
529   /**
530    * @dev Decrease the amount of tokens that an owner allowed to a spender.
531    * approve should be called when allowed_[_spender] == 0. To decrement
532    * allowed value is better to use this function to avoid 2 calls (and wait until
533    * the first transaction is mined)
534    * From MonolithDAO Token.sol
535    * @param spender The address which will spend the funds.
536    * @param subtractedValue The amount of tokens to decrease the allowance by.
537    */
538   function decreaseAllowance(
539     address spender,
540     uint256 subtractedValue
541   )
542     public
543     returns (bool)
544   {
545     require(spender != address(0));
546 
547     _allowed[msg.sender][spender] = (
548       _allowed[msg.sender][spender].sub(subtractedValue));
549     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
550     return true;
551   }
552 
553   /**
554   * @dev Transfer token for a specified addresses
555   * @param from The address to transfer from.
556   * @param to The address to transfer to.
557   * @param value The amount to be transferred.
558   */
559   function _transfer(address from, address to, uint256 value) internal {
560     require(value <= _balances[from]);
561     require(to != address(0));
562 
563     _balances[from] = _balances[from].sub(value);
564     _balances[to] = _balances[to].add(value);
565     emit Transfer(from, to, value);
566   }
567 
568   /**
569    * @dev Internal function that mints an amount of the token and assigns it to
570    * an account. This encapsulates the modification of balances such that the
571    * proper events are emitted.
572    * @param account The account that will receive the created tokens.
573    * @param value The amount that will be created.
574    */
575   function _mint(address account, uint256 value) internal {
576     require(account != 0);
577     _totalSupply = _totalSupply.add(value);
578     _balances[account] = _balances[account].add(value);
579     emit Transfer(address(0), account, value);
580   }
581 
582   /**
583    * @dev Internal function that burns an amount of the token of a given
584    * account.
585    * @param account The account whose tokens will be burnt.
586    * @param value The amount that will be burnt.
587    */
588   function _burn(address account, uint256 value) internal {
589     require(account != 0);
590     require(value <= _balances[account]);
591 
592     _totalSupply = _totalSupply.sub(value);
593     _balances[account] = _balances[account].sub(value);
594     emit Transfer(account, address(0), value);
595   }
596 
597   /**
598    * @dev Internal function that burns an amount of the token of a given
599    * account, deducting from the sender's allowance for said account. Uses the
600    * internal burn function.
601    * @param account The account whose tokens will be burnt.
602    * @param value The amount that will be burnt.
603    */
604   function _burnFrom(address account, uint256 value) internal {
605     require(value <= _allowed[account][msg.sender]);
606 
607     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
608     // this function needs to emit an event with the updated approval.
609     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
610       value);
611     _burn(account, value);
612   }
613 }
614 
615 
616 /**
617  * @title Burnable Token
618  * @dev Token that can be irreversibly burned (destroyed).
619  */
620 contract ERC20Burnable is ERC20 {
621 
622   /**
623    * @dev Burns a specific amount of tokens.
624    * @param value The amount of token to be burned.
625    */
626   function burn(uint256 value) public {
627     _burn(msg.sender, value);
628   }
629 
630   /**
631    * @dev Burns a specific amount of tokens from the target address and decrements allowance
632    * @param from address The address which you want to send tokens from
633    * @param value uint256 The amount of token to be burned
634    */
635   function burnFrom(address from, uint256 value) public {
636     _burnFrom(from, value);
637   }
638 }
639 
640 
641 
642 
643 
644 /**
645  * @title ERC20Detailed token
646  * @dev The decimals are only for visualization purposes.
647  * All the operations are done using the smallest and indivisible token unit,
648  * just as on Ethereum all the operations are done in wei.
649  */
650 contract ERC20Detailed is IERC20 {
651   string private _name;
652   string private _symbol;
653   uint8 private _decimals;
654 
655   constructor(string name, string symbol, uint8 decimals) public {
656     _name = name;
657     _symbol = symbol;
658     _decimals = decimals;
659   }
660 
661   /**
662    * @return the name of the token.
663    */
664   function name() public view returns(string) {
665     return _name;
666   }
667 
668   /**
669    * @return the symbol of the token.
670    */
671   function symbol() public view returns(string) {
672     return _symbol;
673   }
674 
675   /**
676    * @return the number of decimals of the token.
677    */
678   function decimals() public view returns(uint8) {
679     return _decimals;
680   }
681 }
682 
683 
684 contract BToken is ERC20Burnable, ERC20Detailed {
685   uint constant private INITIAL_SUPPLY = 10 * 1e24;
686   
687   constructor() ERC20Detailed("BurnToken", "BUTK", 18) public {
688     super._mint(msg.sender, INITIAL_SUPPLY);
689   }
690 }
691 
692 contract BMng is Pausable, Ownable {
693   using SafeMath for uint256;
694 
695   enum TokenStatus {
696     Unknown,
697     Active,
698     Suspended
699   }
700 
701   struct Token {
702     TokenStatus status;
703     uint256 rewardRateNumerator;
704     uint256 rewardRateDenominator;
705     uint256 burned;
706     uint256 burnedAccumulator;
707     uint256 bTokensRewarded;
708     uint256 totalSupplyInit; // provided during registration
709   }
710 
711   event Auth(
712     address indexed burner,
713     address indexed partner
714   );
715 
716   event Burn(
717     address indexed token,
718     address indexed burner,
719     address partner,
720     uint256 value,
721     uint256 bValue,
722     uint256 bValuePartner
723   );
724 
725   event DiscountUpdate(
726     uint256 discountNumerator,
727     uint256 discountDenominator,
728     uint256 balanceThreshold
729   );
730 
731   string public name;
732   address constant burnAddress = 0x000000000000000000000000000000000000dEaD;
733   address registrator;
734   address defaultPartner;
735   
736   uint256 partnerBonusRateNumerator;
737   uint256 partnerBonusRateDenominator;
738 
739   uint256 constant discountNumeratorMul = 95;
740   uint256 constant discountDenominatorMul = 100;
741 
742   uint256 discountNumerator;
743   uint256 discountDenominator;
744   uint256 balanceThreshold;
745 
746   mapping (address => Token) public tokens;
747 
748   // Emails registered
749   mapping (address => address) referalPartners;
750 
751   // Counters
752   mapping (address => mapping (address => uint256)) burntByTokenUser;
753   // mapping (address => uint256) burntByTokenTotal;
754   
755   // Reference codes
756   mapping (bytes8 => address) refLookup;
757 
758   // Bonuses
759   mapping (address => bool) public shouldGetBonus;
760 
761   BToken bToken;
762   uint256 public initialBlockNumber;
763 
764   constructor(
765     address _bTokenAddress, 
766     address _registrator, 
767     address _defaultPartner,
768     uint256 _initialBalance
769   ) 
770   public 
771   {
772     name = "Burn Token Management Contract v0.2";
773     registrator = _registrator;
774     defaultPartner = _defaultPartner;
775     bToken = BToken(_bTokenAddress);
776     initialBlockNumber = block.number;
777     // Formal referals
778     referalPartners[_registrator] = burnAddress;
779     referalPartners[_defaultPartner] = burnAddress;
780     // Bonus rate
781     partnerBonusRateNumerator = 15; // 15% default
782     partnerBonusRateDenominator = 100;
783     discountNumerator = 1;
784     discountDenominator = 1;
785     balanceThreshold = _initialBalance.mul(discountNumeratorMul).div(discountDenominatorMul);
786   }
787 
788   // --------------------------------------------------------------------------
789   // Administration fuctionality
790   
791   function claimBurnTokensBack(address _to) public onlyOwner {
792     // This is necessary to finalize the contract lifecicle 
793     uint256 remainingBalance = bToken.balanceOf(this);
794     bToken.transfer(_to, remainingBalance);
795   }
796 
797   function register(
798     address tokenAddress, 
799     uint256 totalSupply,
800     uint256 _rewardRateNumerator,
801     uint256 _rewardRateDenominator,
802     bool activate
803   ) 
804     public 
805     onlyOwner 
806   {
807     require(tokens[tokenAddress].status == TokenStatus.Unknown, "Cannot register more than one time");
808     Token memory _token;
809     if (activate) {
810       _token.status = TokenStatus.Active;
811     } else {
812       _token.status = TokenStatus.Suspended;
813     }    
814     _token.rewardRateNumerator = _rewardRateNumerator;
815     _token.rewardRateDenominator = _rewardRateDenominator;
816     _token.totalSupplyInit = totalSupply;
817     tokens[tokenAddress] = _token;
818   }
819 
820   function changeRegistrator(address _newRegistrator) public onlyOwner {
821     registrator = _newRegistrator;
822   }
823 
824   function changeDefaultPartnerAddress(address _newDefaultPartner) public onlyOwner {
825     defaultPartner = _newDefaultPartner;
826   }
827 
828   
829   function setRewardRateForToken(
830     address tokenAddress,
831     uint256 _rewardRateNumerator,
832     uint256 _rewardRateDenominator
833   )
834     public 
835     onlyOwner 
836   {
837     require(tokens[tokenAddress].status != TokenStatus.Unknown, "Token should be registered first");
838     tokens[tokenAddress].rewardRateNumerator = _rewardRateNumerator;
839     tokens[tokenAddress].rewardRateDenominator = _rewardRateDenominator;
840   }
841   
842 
843   function setPartnerBonusRate(
844     uint256 _partnerBonusRateNumerator,
845     uint256 _partnerBonusRateDenominator
846   )
847     public 
848     onlyOwner 
849   {
850     partnerBonusRateNumerator = _partnerBonusRateNumerator;
851     partnerBonusRateDenominator = _partnerBonusRateDenominator;
852   }
853 
854   function suspend(address tokenAddress) public onlyOwner {
855     require(tokens[tokenAddress].status != TokenStatus.Unknown, "Token should be registered first");
856     tokens[tokenAddress].status = TokenStatus.Suspended;
857   }
858 
859   function unSuspend(address tokenAddress) public onlyOwner {
860     require(tokens[tokenAddress].status != TokenStatus.Unknown, "Token should be registered first");
861     tokens[tokenAddress].status = TokenStatus.Active;
862     tokens[tokenAddress].burnedAccumulator = 0;
863   }
864 
865   function activate(address tokenAddress) public onlyOwner {
866     require(tokens[tokenAddress].status != TokenStatus.Unknown, "Token should be registered first");
867     tokens[tokenAddress].status = TokenStatus.Active;
868   }
869 
870   // END of Administration fuctionality
871   // --------------------------------------------------------------------------
872 
873   function isAuthorized(address _who) public view whenNotPaused returns (bool) {
874     address partner = referalPartners[_who];
875     return partner != address(0);
876   }
877 
878   function amountBurnedTotal(address token) public view returns (uint256) {
879     return tokens[token].burned;
880   }
881 
882   function amountBurnedByUser(address token, address _who) public view returns (uint256) {
883     return burntByTokenUser[token][_who];
884   }
885 
886   // Ref code
887   function getRefByAddress(address _who) public pure returns (bytes6) {
888     /* 
889       We use Base58 encoding and want refcode length to be 8 symbols 
890       bits = log2(58) * 8 = 46.86384796102058 = 40 + 6.86384796102058
891       2^(40 + 6.86384796102058) = 0x100^5 * 116.4726943 ~ 0x100^5 * 116
892       CEIL(47 / 8) = 6
893       Output: bytes6 (48 bits)
894       In such case for 10^6 records we have 0.39% hash collision probability 
895       (see: https://preshing.com/20110504/hash-collision-probabilities/)
896     */ 
897     bytes32 dataHash = keccak256(abi.encodePacked(_who, "BUTK"));
898     return bytes6(uint256(dataHash) % uint256(116 * 0x10000000000));
899   }
900 
901   function getAddressByRef(bytes6 ref) public view returns (address) {
902     return refLookup[ref];
903   }
904 
905   function saveRef(address _who) private returns (bool) {
906     require(_who != address(0), "Should not be zero address");
907     bytes6 ref = getRefByAddress(_who);
908     refLookup[ref] = _who;
909     return true;
910   }
911 
912   function checkSignature(bytes sig, address _who) public view returns (bool) {
913     bytes32 dataHash = keccak256(abi.encodePacked(_who));
914     return (ECDSA.recover(dataHash, sig) == registrator);
915   }
916 
917   function authorizeAddress(bytes authSignature, bytes6 ref) public whenNotPaused returns (bool) {
918     // require(false, "Test fail");
919     require(checkSignature(authSignature, msg.sender) == true, "Authorization should be signed by registrator");
920     require(isAuthorized(msg.sender) == false, "No need to authorize more then once");
921     address refAddress = getAddressByRef(ref);
922     address partner = (refAddress == address(0)) ? defaultPartner : refAddress;
923 
924     // Create ref code (register as a partner)
925     saveRef(msg.sender);
926 
927     referalPartners[msg.sender] = partner;
928 
929     // Only if ref code is used authorized to get extra bonus
930     if (partner != defaultPartner) {
931       shouldGetBonus[msg.sender] = true;
932     }
933 
934     emit Auth(msg.sender, partner);
935 
936     return true;
937   }
938 
939   function suspendIfNecessary(
940     address tokenAddress
941   )
942     private returns (bool) 
943   {
944     // When 10% of totalSupply is burnt suspend the token just in case 
945     // there is a chance that its contract is broken
946     if (tokens[tokenAddress].burnedAccumulator > tokens[tokenAddress].totalSupplyInit.div(10)) {
947       tokens[tokenAddress].status = TokenStatus.Suspended;
948       return true;
949     }
950     return false;
951   }
952 
953   // Discount
954   function discountCorrectionIfNecessary(
955     uint256 balance
956   ) 
957     private returns (bool)
958   {
959     if (balance < balanceThreshold) {
960       // Update discountNumerator, discountDenominator and balanceThreshold
961       // we multiply discount coefficient by 0.9
962       discountNumerator = discountNumerator * discountNumeratorMul;
963       discountDenominator = discountDenominator * discountDenominatorMul;
964       balanceThreshold = balanceThreshold.mul(discountNumeratorMul).div(discountDenominatorMul);
965       emit DiscountUpdate(discountNumerator, discountDenominator, balanceThreshold);
966       return true;
967     }
968     return false;
969   }
970 
971   // Helpers
972   function getAllTokenData(
973     address tokenAddress,
974     address _who
975   )
976     public view returns (uint256, uint256, uint256, uint256, bool) 
977   {
978     IERC20 tokenContract = IERC20(tokenAddress);
979     uint256 balance = tokenContract.balanceOf(_who);
980     uint256 allowance = tokenContract.allowance(_who, this);
981     bool isActive = (tokens[tokenAddress].status == TokenStatus.Active);
982     uint256 burnedByUser = amountBurnedByUser(tokenAddress, _who);
983     uint256 burnedTotal = amountBurnedTotal(tokenAddress);
984     return (balance, allowance, burnedByUser, burnedTotal, isActive);
985   }
986 
987   function getBTokenValue(
988     address tokenAddress, 
989     uint256 value
990   )
991     public view returns (uint256) 
992   {
993     Token memory tokenRec = tokens[tokenAddress];
994     require(tokenRec.status == TokenStatus.Active, "Token should be in active state");
995     uint256 denominator = tokenRec.rewardRateDenominator;
996     require(denominator > 0, "Reward denominator should not be zero");
997     uint256 numerator = tokenRec.rewardRateNumerator;
998     uint256 bTokenValue = value.mul(numerator).div(denominator);
999     // Discount
1000     uint256 discountedBTokenValue = bTokenValue.mul(discountNumerator).div(discountDenominator);
1001     return discountedBTokenValue;
1002   } 
1003 
1004   function getPartnerReward(uint256 bTokenValue) public view returns (uint256) {
1005     return bTokenValue.mul(partnerBonusRateNumerator).div(partnerBonusRateDenominator);
1006   }
1007 
1008   function burn(
1009     address tokenAddress, 
1010     uint256 value
1011   ) 
1012     public 
1013     whenNotPaused 
1014     returns (bool) 
1015   {
1016     address partner = referalPartners[msg.sender];
1017     require(partner != address(0), "Burner should be registered");
1018     IERC20 tokenContract = IERC20(tokenAddress);
1019     require(tokenContract.allowance(msg.sender, this) >= value, "Should be allowed");
1020  
1021     uint256 bTokenValueFin;
1022     uint256 bTokenValue = getBTokenValue(tokenAddress, value);
1023     uint256 currentBalance = bToken.balanceOf(this);
1024     require(bTokenValue < currentBalance.div(100), "Cannot reward more than 1% of the balance");
1025 
1026     uint256 bTokenPartnerBonus = getPartnerReward(bTokenValue);
1027     uint256 bTokenTotal = bTokenValue.add(bTokenPartnerBonus);
1028     
1029     // Update counters
1030     tokens[tokenAddress].burned = tokens[tokenAddress].burned.add(value);
1031     tokens[tokenAddress].burnedAccumulator = tokens[tokenAddress].burnedAccumulator.add(value);
1032     tokens[tokenAddress].bTokensRewarded = tokens[tokenAddress].bTokensRewarded.add(bTokenTotal);
1033     burntByTokenUser[tokenAddress][msg.sender] = burntByTokenUser[tokenAddress][msg.sender].add(value);
1034 
1035     tokenContract.transferFrom(msg.sender, burnAddress, value); // burn shit-token
1036     
1037     discountCorrectionIfNecessary(currentBalance.sub(bTokenValue).sub(bTokenPartnerBonus));
1038     
1039     suspendIfNecessary(tokenAddress);
1040 
1041     bToken.transfer(partner, bTokenPartnerBonus);
1042 
1043     if (shouldGetBonus[msg.sender]) {
1044       // give bonus once
1045       shouldGetBonus[msg.sender] = false;
1046       bTokenValueFin = bTokenValue.mul(6).div(5); // +20%
1047     } else {
1048       bTokenValueFin = bTokenValue;
1049     }
1050 
1051     bToken.transfer(msg.sender, bTokenValueFin);
1052     emit Burn(tokenAddress, msg.sender, partner, value, bTokenValueFin, bTokenPartnerBonus);
1053   }
1054 }