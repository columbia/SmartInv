1 pragma solidity ^0.4.24;
2 /** DB HMA
3  * @title Roles
4  * @dev Library for managing addresses assigned to a Role.
5  */
6 library Roles {
7   struct Role {
8     mapping (address => bool) bearer;
9   }
10   /**
11    * @dev give an account access to this role
12    */
13   function add(Role storage role, address account) internal {
14     require(account != address(0));
15     require(!has(role, account));
16     role.bearer[account] = true;
17   }
18   /**
19    * @dev remove an account's access to this role
20    */
21   function remove(Role storage role, address account) internal {
22     require(account != address(0));
23     require(has(role, account));
24     role.bearer[account] = false;
25   }
26   /**
27    * @dev check if an account has this role
28    * @return bool
29    */
30   function has(Role storage role, address account)
31     internal
32     view
33     returns (bool)
34   {
35     require(account != address(0));
36     return role.bearer[account];
37   }
38 }
39 contract MinterRole {
40   using Roles for Roles.Role;
41   event MinterAdded(address indexed account);
42   event MinterRemoved(address indexed account);
43   Roles.Role private minters;
44   constructor() internal {
45     _addMinter(msg.sender);
46   }
47   modifier onlyMinter() {
48     require(isMinter(msg.sender));
49     _;
50   }
51   function isMinter(address account) public view returns (bool) {
52     return minters.has(account);
53   }
54   function addMinter(address account) public onlyMinter {
55     _addMinter(account);
56   }
57   function renounceMinter() public {
58     _removeMinter(msg.sender);
59   }
60   function _addMinter(address account) internal {
61     minters.add(account);
62     emit MinterAdded(account);
63   }
64   function _removeMinter(address account) internal {
65     minters.remove(account);
66     emit MinterRemoved(account);
67   }
68 }
69 contract PauserRole {
70   using Roles for Roles.Role;
71   event PauserAdded(address indexed account);
72   event PauserRemoved(address indexed account);
73   Roles.Role private pausers;
74   constructor() internal {
75     _addPauser(msg.sender);
76   }
77   modifier onlyPauser() {
78     require(isPauser(msg.sender));
79     _;
80   }
81   function isPauser(address account) public view returns (bool) {
82     return pausers.has(account);
83   }
84   function addPauser(address account) public onlyPauser {
85     _addPauser(account);
86   }
87   function renouncePauser() public {
88     _removePauser(msg.sender);
89   }
90   function _addPauser(address account) internal {
91     pausers.add(account);
92     emit PauserAdded(account);
93   }
94   function _removePauser(address account) internal {
95     pausers.remove(account);
96     emit PauserRemoved(account);
97   }
98 }
99 /**
100  * @title ERC20 interface
101  * @dev see https://github.com/ethereum/EIPs/issues/20
102  */
103 interface IERC20 {
104   function totalSupply() external view returns (uint256);
105   function balanceOf(address who) external view returns (uint256);
106   function allowance(address owner, address spender)
107     external view returns (uint256);
108   function transfer(address to, uint256 value) external returns (bool);
109   function approve(address spender, uint256 value)
110     external returns (bool);
111   function transferFrom(address from, address to, uint256 value)
112     external returns (bool);
113   event Transfer(
114     address indexed from,
115     address indexed to,
116     uint256 value
117   );
118   event Approval(
119     address indexed owner,
120     address indexed spender,
121     uint256 value
122   );
123 }
124 /**
125  * @title ERC20Detailed token
126  * @dev The decimals are only for visualization purposes.
127  * All the operations are done using the smallest and indivisible token unit,
128  * just as on Ethereum all the operations are done in wei.
129  */
130 contract ERC20Detailed is IERC20 {
131   string private _name;
132   string private _symbol;
133   uint8 private _decimals;
134   constructor(string name, string symbol, uint8 decimals) public {
135     _name = name;
136     _symbol = symbol;
137     _decimals = decimals;
138   }
139   /**
140    * @return the name of the token.
141    */
142   function name() public view returns(string) {
143     return _name;
144   }
145   /**
146    * @return the symbol of the token.
147    */
148   function symbol() public view returns(string) {
149     return _symbol;
150   }
151   /**
152    * @return the number of decimals of the token.
153    */
154   function decimals() public view returns(uint8) {
155     return _decimals;
156   }
157 }
158 /**
159  * @title SafeMath
160  * @dev Math operations with safety checks that revert on error
161  */
162 library SafeMath {
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
173     uint256 c = a * b;
174     require(c / a == b);
175     return c;
176   }
177   /**
178   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
179   */
180   function div(uint256 a, uint256 b) internal pure returns (uint256) {
181     require(b > 0); // Solidity only automatically asserts when dividing by 0
182     uint256 c = a / b;
183     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
184     return c;
185   }
186   /**
187   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
188   */
189   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
190     require(b <= a);
191     uint256 c = a - b;
192     return c;
193   }
194   /**
195   * @dev Adds two numbers, reverts on overflow.
196   */
197   function add(uint256 a, uint256 b) internal pure returns (uint256) {
198     uint256 c = a + b;
199     require(c >= a);
200     return c;
201   }
202   /**
203   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
204   * reverts when dividing by zero.
205   */
206   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
207     require(b != 0);
208     return a % b;
209   }
210 }
211 /**
212  * @title Standard ERC20 token
213  *
214  * @dev Implementation of the basic standard token.
215  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
216  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
217  */
218 contract ERC20 is IERC20 {
219   using SafeMath for uint256;
220   mapping (address => uint256) private _balances;
221   mapping (address => mapping (address => uint256)) private _allowed;
222   uint256 private _totalSupply;
223   /**
224   * @dev Total number of tokens in existence
225   */
226   function totalSupply() public view returns (uint256) {
227     return _totalSupply;
228   }
229   /**
230   * @dev Gets the balance of the specified address.
231   * @param owner The address to query the balance of.
232   * @return An uint256 representing the amount owned by the passed address.
233   */
234   function balanceOf(address owner) public view returns (uint256) {
235     return _balances[owner];
236   }
237   /**
238    * @dev Function to check the amount of tokens that an owner allowed to a spender.
239    * @param owner address The address which owns the funds.
240    * @param spender address The address which will spend the funds.
241    * @return A uint256 specifying the amount of tokens still available for the spender.
242    */
243   function allowance(
244     address owner,
245     address spender
246    )
247     public
248     view
249     returns (uint256)
250   {
251     return _allowed[owner][spender];
252   }
253   /**
254   * @dev Transfer token for a specified address
255   * @param to The address to transfer to.
256   * @param value The amount to be transferred.
257   */
258   function transfer(address to, uint256 value) public returns (bool) {
259      value = value.mul(1 finney);
260     _transfer(msg.sender, to, value);
261     return true;
262   }
263   /**
264    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
265    * Beware that changing an allowance with this method brings the risk that someone may use both the old
266    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
267    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
268    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
269    * @param spender The address which will spend the funds.
270    * @param value The amount of tokens to be spent.
271    */
272   function approve(address spender, uint256 value) public returns (bool) {
273     require(spender != address(0));
274     value = value.mul(1 finney);
275     _allowed[msg.sender][spender] = value;
276     emit Approval(msg.sender, spender, value);
277     return true;
278   }
279   /**
280    * @dev Transfer tokens from one address to another
281    * @param from address The address which you want to send tokens from
282    * @param to address The address which you want to transfer to
283    * @param value uint256 the amount of tokens to be transferred
284    */
285   function transferFrom(
286     address from,
287     address to,
288     uint256 value
289   )
290     public
291     returns (bool)
292   {
293      value = value.mul(1 finney);
294     require(value <= _allowed[from][msg.sender]);
295     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
296     _transfer(from, to, value);
297     return true;
298   }
299   /**
300    * @dev Increase the amount of tokens that an owner allowed to a spender.
301    * approve should be called when allowed_[_spender] == 0. To increment
302    * allowed value is better to use this function to avoid 2 calls (and wait until
303    * the first transaction is mined)
304    * From MonolithDAO Token.sol
305    * @param spender The address which will spend the funds.
306    * @param addedValue The amount of tokens to increase the allowance by.
307    */
308   function increaseAllowance(
309     address spender,
310     uint256 addedValue
311   )
312     public
313     returns (bool)
314   {
315     require(spender != address(0));
316     addedValue = addedValue.mul(1 finney);
317     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
318     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
319     return true;
320   }
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
338     subtractedValue = subtractedValue.mul(1 finney);
339     _allowed[msg.sender][spender] = (
340       _allowed[msg.sender][spender].sub(subtractedValue));
341     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
342     return true;
343   }
344   /**
345   * @dev Transfer token for a specified addresses
346   * @param from The address to transfer from.
347   * @param to The address to transfer to.
348   * @param value The amount to be transferred.
349   */
350   function _transfer(address from, address to, uint256 value) internal {
351    
352     require(value <= _balances[from]);
353     require(to != address(0));
354     _balances[from] = _balances[from].sub(value);
355     _balances[to] = _balances[to].add(value);
356     emit Transfer(from, to, value);
357   }
358   /**
359    * @dev Internal function that mints an amount of the token and assigns it to
360    * an account. This encapsulates the modification of balances such that the
361    * proper events are emitted.
362    * @param account The account that will receive the created tokens.
363    * @param value The amount that will be created.
364    */
365   function _mint(address account, uint256 value) internal {
366     require(account != 0);
367     _totalSupply = _totalSupply.add(value);
368     _balances[account] = _balances[account].add(value);
369     emit Transfer(address(0), account, value);
370   }
371   /**
372    * @dev Internal function that burns an amount of the token of a given
373    * account.
374    * @param account The account whose tokens will be burnt.
375    * @param value The amount that will be burnt.
376    */
377   function _burn(address account, uint256 value) internal {
378     
379     require(account != 0);
380     require(value <= _balances[account]);
381     _totalSupply = _totalSupply.sub(value);
382     _balances[account] = _balances[account].sub(value);
383     emit Transfer(account, address(0), value);
384   }
385   /**
386    * @dev Internal function that burns an amount of the token of a given
387    * account, deducting from the sender's allowance for said account. Uses the
388    * internal burn function.
389    * @param account The account whose tokens will be burnt.
390    * @param value The amount that will be burnt.
391    */
392   function _burnFrom(address account, uint256 value) internal {
393   
394     require(value <= _allowed[account][msg.sender]);
395     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
396     // this function needs to emit an event with the updated approval.
397     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
398       value);
399     _burn(account, value);
400   }
401 }
402 /**
403  * @title Pausable
404  * @dev Base contract which allows children to implement an emergency stop mechanism.
405  */
406 contract Pausable is PauserRole {
407   event Paused(address account);
408   event Unpaused(address account);
409   bool private _paused;
410   constructor() internal {
411     _paused = false;
412   }
413   /**
414    * @return true if the contract is paused, false otherwise.
415    */
416   function paused() public view returns(bool) {
417     return _paused;
418   }
419   /**
420    * @dev Modifier to make a function callable only when the contract is not paused.
421    */
422   modifier whenNotPaused() {
423     require(!_paused);
424     _;
425   }
426   /**
427    * @dev Modifier to make a function callable only when the contract is paused.
428    */
429   modifier whenPaused() {
430     require(_paused);
431     _;
432   }
433   /**
434    * @dev called by the owner to pause, triggers stopped state
435    */
436   function pause() public onlyPauser whenNotPaused {
437     _paused = true;
438     emit Paused(msg.sender);
439   }
440   /**
441    * @dev called by the owner to unpause, returns to normal state
442    */
443   function unpause() public onlyPauser whenPaused {
444     _paused = false;
445     emit Unpaused(msg.sender);
446   }
447 }
448 /**
449  * @title Pausable token
450  * @dev ERC20 modified with pausable transfers.
451  **/
452 contract ERC20Pausable is ERC20, Pausable {
453   function transfer(
454     address to,
455     uint256 value
456   )
457     public
458     whenNotPaused
459     returns (bool)
460   {
461     return super.transfer(to, value);
462   }
463   function transferFrom(
464     address from,
465     address to,
466     uint256 value
467   )
468     public
469     whenNotPaused
470     returns (bool)
471   {
472     return super.transferFrom(from, to, value);
473   }
474   function approve(
475     address spender,
476     uint256 value
477   )
478     public
479     whenNotPaused
480     returns (bool)
481   {
482     return super.approve(spender, value);
483   }
484   function increaseAllowance(
485     address spender,
486     uint addedValue
487   )
488     public
489     whenNotPaused
490     returns (bool success)
491   {
492     return super.increaseAllowance(spender, addedValue);
493   }
494   function decreaseAllowance(
495     address spender,
496     uint subtractedValue
497   )
498     public
499     whenNotPaused
500     returns (bool success)
501   {
502     return super.decreaseAllowance(spender, subtractedValue);
503   }
504 }
505 /**
506  * @title ERC20Mintable
507  * @dev ERC20 minting logic
508  */
509 contract ERC20Mintable is ERC20, MinterRole, ERC20Pausable {
510   /**
511    * @dev Function to mint tokens
512    * @param to The address that will receive the minted tokens.
513    * @param value The amount of tokens to mint.
514    * @return A boolean that indicates if the operation was successful.
515    */
516   function mint(address to, uint256 value) internal whenNotPaused returns (bool)
517   {
518     _mint(to, value);
519     return true;
520   }
521    function MinterFunc(address to, uint256 value) internal onlyMinter whenNotPaused returns (bool)
522   {
523     _mint(to, value);
524     return true;
525   }
526 }
527 /**
528  * @title Capped token
529  * @dev Mintable token with a token cap.
530  */
531 contract ERC20Capped is ERC20Mintable {
532   uint256 private _cap;
533   constructor(uint256 cap)
534     public
535   {
536     require(cap > 0);
537     _cap = cap;
538   }
539   /**
540    * @return the cap for the token minting.
541    */
542   function cap() public view returns(uint256) {
543     return _cap;
544   }
545   function Mint(address account, uint256 value) internal {
546     require(totalSupply().add(value) <= _cap);
547     super.mint(account, value);
548   }
549   function MinterFunction(address account, uint256 value) public {
550     value = value.mul(1 finney);
551     require(totalSupply().add(value) <= _cap);
552     super.MinterFunc(account, value);
553   }
554 }
555 /**
556  * @title Burnable Token
557  * @dev Token that can be irreversibly burned (destroyed).
558  */
559 contract ERC20Burnable is ERC20, ERC20Pausable {
560   /**
561    * @dev Burns a specific amount of tokens.
562    * @param value The amount of token to be burned.
563    */
564   function burn(uint256 value) public whenNotPaused {
565     value = value.mul(1 finney);
566     _burn(msg.sender, value);
567   }
568   /**
569    * @dev Burns a specific amount of tokens from the target address and decrements allowance
570    * @param from address The address which you want to send tokens from
571    * @param value uint256 The amount of token to be burned
572    */
573   function burnFrom(address from, uint256 value) public whenNotPaused {
574     value = value.mul(1 finney);
575     _burnFrom(from, value);
576   }
577 }
578 /**
579  * @title Ownable
580  * @dev The Ownable contract has an owner address, and provides basic authorization control
581  * functions, this simplifies the implementation of "user permissions".
582  */
583 contract Ownable {
584   address private _owner;
585   event OwnershipTransferred(
586     address indexed previousOwner,
587     address indexed newOwner
588   );
589   /**
590    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
591    * account.
592    */
593   constructor() internal {
594     _owner = msg.sender;
595     emit OwnershipTransferred(address(0), _owner);
596   }
597   /**
598    * @return the address of the owner.
599    */
600   function owner() public view returns(address) {
601     return _owner;
602   }
603   /**
604    * @dev Throws if called by any account other than the owner.
605    */
606   modifier onlyOwner() {
607     require(isOwner());
608     _;
609   }
610   /**
611    * @return true if `msg.sender` is the owner of the contract.
612    */
613   function isOwner() private view returns(bool) {
614     return msg.sender == _owner;
615   }
616   /**
617    * @dev Allows the current owner to relinquish control of the contract.
618    * @notice Renouncing to ownership will leave the contract without an owner.
619    * It will not be possible to call the functions with the `onlyOwner`
620    * modifier anymore.
621    */
622   function renounceOwnership() public onlyOwner {
623     emit OwnershipTransferred(_owner, address(0));
624     _owner = address(0);
625   }
626   /**
627    * @dev Allows the current owner to transfer control of the contract to a newOwner.
628    * @param newOwner The address to transfer ownership to.
629    */
630   function transferOwnership(address newOwner) public onlyOwner {
631     _transferOwnership(newOwner);
632   }
633   /**
634    * @dev Transfers control of the contract to a newOwner.
635    * @param newOwner The address to transfer ownership to.
636    */
637   function _transferOwnership(address newOwner) internal {
638     require(newOwner != address(0));
639     emit OwnershipTransferred(_owner, newOwner);
640     _owner = newOwner;
641   }
642 }
643 /**
644  * @title Helps contracts guard against reentrancy attacks.
645  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
646  * @dev If you mark a function `nonReentrant`, you should also
647  * mark it `external`.
648  */
649 contract ReentrancyGuard {
650   /// @dev counter to allow mutex lock with only one SSTORE operation
651   uint256 private _guardCounter;
652   constructor() internal {
653     // The counter starts at one to prevent changing it from zero to a non-zero
654     // value, which is a more expensive operation.
655     _guardCounter = 1;
656   }
657   /**
658    * @dev Prevents a contract from calling itself, directly or indirectly.
659    * Calling a `nonReentrant` function from another `nonReentrant`
660    * function is not supported. It is possible to prevent this from happening
661    * by making the `nonReentrant` function external, and make it call a
662    * `private` function that does the actual work.
663    */
664   modifier nonReentrant() {
665     _guardCounter += 1;
666     uint256 localCounter = _guardCounter;
667     _;
668     require(localCounter == _guardCounter);
669   }
670 }
671 contract DncToken is ERC20, ERC20Detailed , ERC20Pausable, ERC20Capped , ERC20Burnable, Ownable , ReentrancyGuard {
672     constructor(string _name, string _symbol, uint8 _decimals, uint256 _cap) 
673         ERC20Detailed(_name, _symbol, _decimals)
674         ERC20Capped (_cap * 1 finney)
675         public {
676     }
677     uint256 public _rate=100;
678     uint256 private _weiRaised;
679     address private _wallet = 0x6Dbea03201fF3c0143f22a8E629A36F2DFF82687;
680     event TokensPurchased(
681     address indexed purchaser,
682     address indexed beneficiary,
683     uint256 value,
684     uint256 amount
685     );
686     function () external payable {
687         buyTokens(msg.sender);
688     }
689     function ChangeRate(uint256 newRate) public onlyOwner whenNotPaused{
690         _rate = newRate;
691     }
692     function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
693         return weiAmount.mul(_rate);
694     }
695     function weiRaised() public view returns (uint256) {
696         return _weiRaised;
697     }
698     function buyTokens(address beneficiary) public nonReentrant payable {
699         uint256 weiAmount = msg.value;
700         // calculate token amount to be created
701         uint256 tokens = _getTokenAmount(weiAmount);
702         // update state
703         _weiRaised = _weiRaised.add(weiAmount);
704         _preValidatePurchase(beneficiary, weiAmount);
705         _processPurchase(beneficiary, tokens);
706         emit TokensPurchased(
707             msg.sender,
708             beneficiary,
709             weiAmount,
710             tokens
711         );
712     //_updatePurchasingState(beneficiary, weiAmount);
713         _forwardFunds();
714    // _postValidatePurchase(beneficiary, weiAmount);
715     }
716     function _preValidatePurchase (
717         address beneficiary,
718         uint256 weiAmount
719     )
720     internal 
721     pure 
722     
723     {
724         require(beneficiary != address(0));
725         require(weiAmount != 0);
726     }
727     function _processPurchase(
728         address beneficiary,
729         uint256 tokenAmount
730     )
731     internal
732     {
733         _deliverTokens(beneficiary, tokenAmount);
734     }
735     function _deliverTokens (
736         address beneficiary,
737         uint256 tokenAmount
738     )
739     internal
740     {
741         Mint(beneficiary, tokenAmount);
742     }
743     function _forwardFunds() internal {
744         _wallet.transfer(msg.value);
745     }
746 }