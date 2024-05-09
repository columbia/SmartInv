1 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\IERC20.sol
2 
3 pragma solidity ^0.4.24;
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
38 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\ERC20Detailed.sol
39 
40 pragma solidity ^0.4.24;
41 
42 
43 /**
44  * @title ERC20Detailed token
45  * @dev The decimals are only for visualization purposes.
46  * All the operations are done using the smallest and indivisible token unit,
47  * just as on Ethereum all the operations are done in wei.
48  */
49 contract ERC20Detailed is IERC20 {
50   string private _name;
51   string private _symbol;
52   uint8 private _decimals;
53 
54   constructor(string name, string symbol, uint8 decimals) public {
55     _name = name;
56     _symbol = symbol;
57     _decimals = decimals;
58   }
59 
60   /**
61    * @return the name of the token.
62    */
63   function name() public view returns(string) {
64     return _name;
65   }
66 
67   /**
68    * @return the symbol of the token.
69    */
70   function symbol() public view returns(string) {
71     return _symbol;
72   }
73 
74   /**
75    * @return the number of decimals of the token.
76    */
77   function decimals() public view returns(uint8) {
78     return _decimals;
79   }
80 }
81 
82 
83 /**
84  * @title SafeMath
85  * @dev Math operations with safety checks that revert on error
86  */
87 library SafeMath {
88 
89   /**
90   * @dev Multiplies two numbers, reverts on overflow.
91   */
92   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
93     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
94     // benefit is lost if 'b' is also tested.
95     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
96     if (a == 0) {
97       return 0;
98     }
99 
100     uint256 c = a * b;
101     require(c / a == b);
102 
103     return c;
104   }
105 
106   /**
107   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
108   */
109   function div(uint256 a, uint256 b) internal pure returns (uint256) {
110     require(b > 0); // Solidity only automatically asserts when dividing by 0
111     uint256 c = a / b;
112     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
113 
114     return c;
115   }
116 
117   /**
118   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
119   */
120   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
121     require(b <= a);
122     uint256 c = a - b;
123 
124     return c;
125   }
126 
127   /**
128   * @dev Adds two numbers, reverts on overflow.
129   */
130   function add(uint256 a, uint256 b) internal pure returns (uint256) {
131     uint256 c = a + b;
132     require(c >= a);
133 
134     return c;
135   }
136 
137   /**
138   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
139   * reverts when dividing by zero.
140   */
141   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
142     require(b != 0);
143     return a % b;
144   }
145 }
146 
147 
148 /**
149  * @title Standard ERC20 token
150  *
151  * @dev Implementation of the basic standard token.
152  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
153  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
154  */
155 contract ERC20 is IERC20 {
156   using SafeMath for uint256;
157 
158   mapping (address => uint256) private _balances;
159 
160   mapping (address => mapping (address => uint256)) private _allowed;
161 
162   uint256 private _totalSupply;
163 
164   /**
165   * @dev Total number of tokens in existence
166   */
167   function totalSupply() public view returns (uint256) {
168     return _totalSupply;
169   }
170 
171   /**
172   * @dev Gets the balance of the specified address.
173   * @param owner The address to query the balance of.
174   * @return An uint256 representing the amount owned by the passed address.
175   */
176   function balanceOf(address owner) public view returns (uint256) {
177     return _balances[owner];
178   }
179 
180   /**
181    * @dev Function to check the amount of tokens that an owner allowed to a spender.
182    * @param owner address The address which owns the funds.
183    * @param spender address The address which will spend the funds.
184    * @return A uint256 specifying the amount of tokens still available for the spender.
185    */
186   function allowance(
187     address owner,
188     address spender
189    )
190     public
191     view
192     returns (uint256)
193   {
194     return _allowed[owner][spender];
195   }
196 
197   /**
198   * @dev Transfer token for a specified address
199   * @param to The address to transfer to.
200   * @param value The amount to be transferred.
201   */
202   function transfer(address to, uint256 value) public returns (bool) {
203     //  value = value.mul(1 ether);
204      
205     _transfer(msg.sender, to, value);
206     return true;
207   }
208 
209   /**
210    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
211    * Beware that changing an allowance with this method brings the risk that someone may use both the old
212    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
213    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
214    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
215    * @param spender The address which will spend the funds.
216    * @param value The amount of tokens to be spent.
217    */
218   function approve(address spender, uint256 value) public returns (bool) {
219     require(spender != address(0));
220 
221     // value = value.mul(1 ether);
222     _allowed[msg.sender][spender] = value;
223     emit Approval(msg.sender, spender, value);
224     return true;
225   }
226 
227   /**
228    * @dev Transfer tokens from one address to another
229    * @param from address The address which you want to send tokens from
230    * @param to address The address which you want to transfer to
231    * @param value uint256 the amount of tokens to be transferred
232    */
233   function transferFrom(
234     address from,
235     address to,
236     uint256 value
237   )
238     public
239     returns (bool)
240   {
241     //  value = value.mul(1 ether);
242     require(value <= _allowed[from][msg.sender]);
243 
244     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
245     _transfer(from, to, value);
246     return true;
247   }
248 
249   /**
250    * @dev Increase the amount of tokens that an owner allowed to a spender.
251    * approve should be called when allowed_[_spender] == 0. To increment
252    * allowed value is better to use this function to avoid 2 calls (and wait until
253    * the first transaction is mined)
254    * From MonolithDAO Token.sol
255    * @param spender The address which will spend the funds.
256    * @param addedValue The amount of tokens to increase the allowance by.
257    */
258   function increaseAllowance(
259     address spender,
260     uint256 addedValue
261   )
262     public
263     returns (bool)
264   {
265     require(spender != address(0));
266 
267     // addedValue = addedValue.mul(1 ether);
268     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
269     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
270     return true;
271   }
272 
273   /**
274    * @dev Decrease the amount of tokens that an owner allowed to a spender.
275    * approve should be called when allowed_[_spender] == 0. To decrement
276    * allowed value is better to use this function to avoid 2 calls (and wait until
277    * the first transaction is mined)
278    * From MonolithDAO Token.sol
279    * @param spender The address which will spend the funds.
280    * @param subtractedValue The amount of tokens to decrease the allowance by.
281    */
282   function decreaseAllowance(
283     address spender,
284     uint256 subtractedValue
285   )
286     public
287     returns (bool)
288   {
289     require(spender != address(0));
290 
291     // subtractedValue = subtractedValue.mul(1 ether);
292     _allowed[msg.sender][spender] = (
293       _allowed[msg.sender][spender].sub(subtractedValue));
294     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
295     return true;
296   }
297 
298   /**
299   * @dev Transfer token for a specified addresses
300   * @param from The address to transfer from.
301   * @param to The address to transfer to.
302   * @param value The amount to be transferred.
303   */
304   function _transfer(address from, address to, uint256 value) internal {
305    
306     require(value <= _balances[from]);
307     require(to != address(0));
308 
309     _balances[from] = _balances[from].sub(value);
310     _balances[to] = _balances[to].add(value);
311     emit Transfer(from, to, value);
312   }
313 
314   /**
315    * @dev Internal function that mints an amount of the token and assigns it to
316    * an account. This encapsulates the modification of balances such that the
317    * proper events are emitted.
318    * @param account The account that will receive the created tokens.
319    * @param value The amount that will be created.
320    */
321   function _mint(address account, uint256 value) internal {
322     require(account != 0);
323 
324     _totalSupply = _totalSupply.add(value);
325     _balances[account] = _balances[account].add(value);
326     emit Transfer(address(0), account, value);
327   }
328 
329   /**
330    * @dev Internal function that burns an amount of the token of a given
331    * account.
332    * @param account The account whose tokens will be burnt.
333    * @param value The amount that will be burnt.
334    */
335   function _burn(address account, uint256 value) internal {
336     
337     require(account != 0);
338     require(value <= _balances[account]);
339 
340     _totalSupply = _totalSupply.sub(value);
341     _balances[account] = _balances[account].sub(value);
342     emit Transfer(account, address(0), value);
343   }
344 
345   /**
346    * @dev Internal function that burns an amount of the token of a given
347    * account, deducting from the sender's allowance for said account. Uses the
348    * internal burn function.
349    * @param account The account whose tokens will be burnt.
350    * @param value The amount that will be burnt.
351    */
352   function _burnFrom(address account, uint256 value) internal {
353   
354     require(value <= _allowed[account][msg.sender]);
355 
356     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
357     // this function needs to emit an event with the updated approval.
358     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
359       value);
360     _burn(account, value);
361   }
362 }
363 
364 
365 /**
366  * @title Roles
367  * @dev Library for managing addresses assigned to a Role.
368  */
369 library Roles {
370   struct Role {
371     mapping (address => bool) bearer;
372   }
373 
374   /**
375    * @dev give an account access to this role
376    */
377   function add(Role storage role, address account) internal {
378     require(account != address(0));
379     require(!has(role, account));
380 
381     role.bearer[account] = true;
382   }
383 
384   /**
385    * @dev remove an account's access to this role
386    */
387   function remove(Role storage role, address account) internal {
388     require(account != address(0));
389     require(has(role, account));
390 
391     role.bearer[account] = false;
392   }
393 
394   /**
395    * @dev check if an account has this role
396    * @return bool
397    */
398   function has(Role storage role, address account)
399     internal
400     view
401     returns (bool)
402   {
403     require(account != address(0));
404     return role.bearer[account];
405   }
406 }
407 
408 
409 contract PauserRole {
410   using Roles for Roles.Role;
411 
412   event PauserAdded(address indexed account);
413   event PauserRemoved(address indexed account);
414 
415   Roles.Role private pausers;
416 
417   constructor() internal {
418     _addPauser(msg.sender);
419   }
420 
421   modifier onlyPauser() {
422     require(isPauser(msg.sender));
423     _;
424   }
425 
426   function isPauser(address account) public view returns (bool) {
427     return pausers.has(account);
428   }
429 
430   function addPauser(address account) public onlyPauser {
431     _addPauser(account);
432   }
433 
434   function renouncePauser() public {
435     _removePauser(msg.sender);
436   }
437 
438   function _addPauser(address account) internal {
439     pausers.add(account);
440     emit PauserAdded(account);
441   }
442 
443   function _removePauser(address account) internal {
444     pausers.remove(account);
445     emit PauserRemoved(account);
446   }
447 }
448 
449 
450 
451 /**
452  * @title Pausable
453  * @dev Base contract which allows children to implement an emergency stop mechanism.
454  */
455 contract Pausable is PauserRole {
456   event Paused(address account);
457   event Unpaused(address account);
458 
459   bool private _paused;
460 
461   constructor() internal {
462     _paused = false;
463   }
464 
465   /**
466    * @return true if the contract is paused, false otherwise.
467    */
468   function paused() public view returns(bool) {
469     return _paused;
470   }
471 
472   /**
473    * @dev Modifier to make a function callable only when the contract is not paused.
474    */
475   modifier whenNotPaused() {
476     require(!_paused);
477     _;
478   }
479 
480   /**
481    * @dev Modifier to make a function callable only when the contract is paused.
482    */
483   modifier whenPaused() {
484     require(_paused);
485     _;
486   }
487 
488   /**
489    * @dev called by the owner to pause, triggers stopped state
490    */
491   function pause() public onlyPauser whenNotPaused {
492     _paused = true;
493     emit Paused(msg.sender);
494   }
495 
496   /**
497    * @dev called by the owner to unpause, returns to normal state
498    */
499   function unpause() public onlyPauser whenPaused {
500     _paused = false;
501     emit Unpaused(msg.sender);
502   }
503 }
504 
505 
506 
507 /**
508  * @title Pausable token
509  * @dev ERC20 modified with pausable transfers.
510  **/
511 contract ERC20Pausable is ERC20, Pausable {
512 
513   function transfer(
514     address to,
515     uint256 value
516   )
517     public
518     whenNotPaused
519     returns (bool)
520   {
521     return super.transfer(to, value);
522   }
523 
524   function transferFrom(
525     address from,
526     address to,
527     uint256 value
528   )
529     public
530     whenNotPaused
531     returns (bool)
532   {
533     return super.transferFrom(from, to, value);
534   }
535 
536   function approve(
537     address spender,
538     uint256 value
539   )
540     public
541     whenNotPaused
542     returns (bool)
543   {
544     return super.approve(spender, value);
545   }
546 
547   function increaseAllowance(
548     address spender,
549     uint addedValue
550   )
551     public
552     whenNotPaused
553     returns (bool success)
554   {
555     return super.increaseAllowance(spender, addedValue);
556   }
557 
558   function decreaseAllowance(
559     address spender,
560     uint subtractedValue
561   )
562     public
563     whenNotPaused
564     returns (bool success)
565   {
566     return super.decreaseAllowance(spender, subtractedValue);
567   }
568 }
569 
570 
571 contract MinterRole {
572   using Roles for Roles.Role;
573 
574   event MinterAdded(address indexed account);
575   event MinterRemoved(address indexed account);
576 
577   Roles.Role private minters;
578 
579   constructor() internal {
580     _addMinter(msg.sender);
581   }
582 
583   modifier onlyMinter() {
584     require(isMinter(msg.sender));
585     _;
586   }
587 
588   function isMinter(address account) public view returns (bool) {
589     return minters.has(account);
590   }
591 
592   function addMinter(address account) public onlyMinter {
593     _addMinter(account);
594   }
595 
596   function renounceMinter() public {
597     _removeMinter(msg.sender);
598   }
599 
600   function _addMinter(address account) internal {
601     minters.add(account);
602     emit MinterAdded(account);
603   }
604 
605   function _removeMinter(address account) internal {
606     minters.remove(account);
607     emit MinterRemoved(account);
608   }
609 }
610 
611 
612 /**
613  * @title ERC20Mintable
614  * @dev ERC20 minting logic
615  */
616 contract ERC20Mintable is ERC20, MinterRole, ERC20Pausable {
617   /**
618    * @dev Function to mint tokens
619    * @param to The address that will receive the minted tokens.
620    * @param value The amount of tokens to mint.
621    * @return A boolean that indicates if the operation was successful.
622    */
623   function mint(address to, uint256 value) internal whenNotPaused returns (bool)
624   {
625     _mint(to, value);
626     return true;
627   }
628 
629    function MinterFunc(address to, uint256 value) internal onlyMinter whenNotPaused returns (bool)
630   {
631     _mint(to, value);
632     return true;
633   }
634 }
635 
636 /**
637  * @title Capped token
638  * @dev Mintable token with a token cap.
639  */
640 contract ERC20Capped is ERC20Mintable {
641 
642   uint256 private _cap;
643 
644   constructor(uint256 cap)
645     public
646   {
647     require(cap > 0);
648     _cap = cap;
649   }
650 
651   /**
652    * @return the cap for the token minting.
653    */
654   function cap() public view returns(uint256) {
655     return _cap;
656   }
657 
658   function Mint(address account, uint256 value) internal {
659     require(totalSupply().add(value) <= _cap);
660     super.mint(account, value);
661   }
662 
663   function MinterFunction(address account, uint256 value) public {
664     // value = value.mul(1 ether);
665     require(totalSupply().add(value) <= _cap);
666     super.MinterFunc(account, value);
667   }
668 }
669 
670 
671 /**
672  * @title Burnable Token
673  * @dev Token that can be irreversibly burned (destroyed).
674  */
675 contract ERC20Burnable is ERC20, ERC20Pausable {
676 
677   /**
678    * @dev Burns a specific amount of tokens.
679    * @param value The amount of token to be burned.
680    */
681   function burn(uint256 value) public whenNotPaused {
682     // value = value.mul(1 ether);
683     _burn(msg.sender, value);
684   }
685 
686   /**
687    * @dev Burns a specific amount of tokens from the target address and decrements allowance
688    * @param from address The address which you want to send tokens from
689    * @param value uint256 The amount of token to be burned
690    */
691   function burnFrom(address from, uint256 value) public whenNotPaused {
692     // value = value.mul(1 ether);
693     _burnFrom(from, value);
694   }
695 }
696 
697 /**
698  * @title Ownable
699  * @dev The Ownable contract has an owner address, and provides basic authorization control
700  * functions, this simplifies the implementation of "user permissions".
701  */
702 contract Ownable {
703   address private _owner;
704 
705   event OwnershipTransferred(
706     address indexed previousOwner,
707     address indexed newOwner
708   );
709 
710   /**
711    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
712    * account.
713    */
714   constructor() internal {
715     _owner = msg.sender;
716     emit OwnershipTransferred(address(0), _owner);
717   }
718 
719   /**
720    * @return the address of the owner.
721    */
722   function owner() public view returns(address) {
723     return _owner;
724   }
725 
726   /**
727    * @dev Throws if called by any account other than the owner.
728    */
729   modifier onlyOwner() {
730     require(isOwner());
731     _;
732   }
733 
734   /**
735    * @return true if `msg.sender` is the owner of the contract.
736    */
737   function isOwner() private view returns(bool) {
738     return msg.sender == _owner;
739   }
740 
741   /**
742    * @dev Allows the current owner to relinquish control of the contract.
743    * @notice Renouncing to ownership will leave the contract without an owner.
744    * It will not be possible to call the functions with the `onlyOwner`
745    * modifier anymore.
746    */
747   function renounceOwnership() public onlyOwner {
748     emit OwnershipTransferred(_owner, address(0));
749     _owner = address(0);
750   }
751 
752   /**
753    * @dev Allows the current owner to transfer control of the contract to a newOwner.
754    * @param newOwner The address to transfer ownership to.
755    */
756   function transferOwnership(address newOwner) public onlyOwner {
757     _transferOwnership(newOwner);
758   }
759 
760   /**
761    * @dev Transfers control of the contract to a newOwner.
762    * @param newOwner The address to transfer ownership to.
763    */
764   function _transferOwnership(address newOwner) internal {
765     require(newOwner != address(0));
766     emit OwnershipTransferred(_owner, newOwner);
767     _owner = newOwner;
768   }
769 }
770 
771 
772 /**
773  * @title Helps contracts guard against reentrancy attacks.
774  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
775  * @dev If you mark a function `nonReentrant`, you should also
776  * mark it `external`.
777  */
778 contract ReentrancyGuard {
779 
780   /// @dev counter to allow mutex lock with only one SSTORE operation
781   uint256 private _guardCounter;
782 
783   constructor() internal {
784     // The counter starts at one to prevent changing it from zero to a non-zero
785     // value, which is a more expensive operation.
786     _guardCounter = 1;
787   }
788 
789   /**
790    * @dev Prevents a contract from calling itself, directly or indirectly.
791    * Calling a `nonReentrant` function from another `nonReentrant`
792    * function is not supported. It is possible to prevent this from happening
793    * by making the `nonReentrant` function external, and make it call a
794    * `private` function that does the actual work.
795    */
796   modifier nonReentrant() {
797     _guardCounter += 1;
798     uint256 localCounter = _guardCounter;
799     _;
800     require(localCounter == _guardCounter);
801   }
802 
803 }
804 
805 
806 contract DncToken is ERC20, ERC20Detailed , ERC20Pausable, ERC20Capped , ERC20Burnable, Ownable , ReentrancyGuard {
807 
808     constructor(string _name, string _symbol, uint8 _decimals, uint256 _cap) 
809         ERC20Detailed(_name, _symbol, _decimals)
810         ERC20Capped (_cap * 1 ether)
811         public {
812     }
813 
814     uint256 public _rate=100;
815 
816     uint256 private _weiRaised;
817 
818     address private _wallet = 0x88951e18fEd6D792d619B4A472d5C0D2E5B9b5F0;
819 
820     event TokensPurchased(
821     address indexed purchaser,
822     address indexed beneficiary,
823     uint256 value,
824     uint256 amount
825     );
826 
827     function () external payable {
828         buyTokens(msg.sender);
829     }
830 
831     function ChangeRate(uint256 newRate) public onlyOwner whenNotPaused{
832         _rate = newRate;
833     }
834 
835     function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
836         return weiAmount.mul(_rate);
837     }
838 
839     function weiRaised() public view returns (uint256) {
840         return _weiRaised;
841     }
842 
843     function buyTokens(address beneficiary) public nonReentrant payable {
844         uint256 weiAmount = msg.value;
845 
846         // calculate token amount to be created
847         uint256 tokens = _getTokenAmount(weiAmount);
848 
849         // update state
850         _weiRaised = _weiRaised.add(weiAmount);
851 
852         _preValidatePurchase(beneficiary, weiAmount);
853         _processPurchase(beneficiary, tokens);
854 
855         emit TokensPurchased(
856             msg.sender,
857             beneficiary,
858             weiAmount,
859             tokens
860         );
861 
862     //_updatePurchasingState(beneficiary, weiAmount);
863         _forwardFunds();
864    // _postValidatePurchase(beneficiary, weiAmount);
865     }
866 
867     function _preValidatePurchase (
868         address beneficiary,
869         uint256 weiAmount
870     )
871     internal
872     view
873     {
874         require(beneficiary != address(0));
875         require(weiAmount != 0);
876     }
877 
878     function _processPurchase(
879         address beneficiary,
880         uint256 tokenAmount
881     )
882     internal
883     {
884         _deliverTokens(beneficiary, tokenAmount);
885     }
886 
887     function _deliverTokens (
888         address beneficiary,
889         uint256 tokenAmount
890     )
891     internal
892     {
893         Mint(beneficiary, tokenAmount);
894     }
895 
896     function _forwardFunds() internal {
897         _wallet.transfer(msg.value);
898     }
899 }