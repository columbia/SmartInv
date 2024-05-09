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
110 
111 /**
112  * @title ERC20Detailed token
113  * @dev The decimals are only for visualization purposes.
114  * All the operations are done using the smallest and indivisible token unit,
115  * just as on Ethereum all the operations are done in wei.
116  */
117 contract ERC20Detailed is IERC20 {
118   string private _name;
119   string private _symbol;
120   uint8 private _decimals;
121 
122   constructor(string name, string symbol, uint8 decimals) public {
123     _name = name;
124     _symbol = symbol;
125     _decimals = decimals;
126   }
127 
128   /**
129    * @return the name of the token.
130    */
131   function name() public view returns(string) {
132     return _name;
133   }
134 
135   /**
136    * @return the symbol of the token.
137    */
138   function symbol() public view returns(string) {
139     return _symbol;
140   }
141 
142   /**
143    * @return the number of decimals of the token.
144    */
145   function decimals() public view returns(uint8) {
146     return _decimals;
147   }
148 }
149 
150 
151 /**
152  * @title SafeMath
153  * @dev Math operations with safety checks that revert on error
154  */
155 library SafeMath {
156 
157   /**
158   * @dev Multiplies two numbers, reverts on overflow.
159   */
160   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
161     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
162     // benefit is lost if 'b' is also tested.
163     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
164     if (a == 0) {
165       return 0;
166     }
167 
168     uint256 c = a * b;
169     require(c / a == b);
170 
171     return c;
172   }
173 
174   /**
175   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
176   */
177   function div(uint256 a, uint256 b) internal pure returns (uint256) {
178     require(b > 0); // Solidity only automatically asserts when dividing by 0
179     uint256 c = a / b;
180     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
181 
182     return c;
183   }
184 
185   /**
186   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
187   */
188   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
189     require(b <= a);
190     uint256 c = a - b;
191 
192     return c;
193   }
194 
195   /**
196   * @dev Adds two numbers, reverts on overflow.
197   */
198   function add(uint256 a, uint256 b) internal pure returns (uint256) {
199     uint256 c = a + b;
200     require(c >= a);
201 
202     return c;
203   }
204 
205   /**
206   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
207   * reverts when dividing by zero.
208   */
209   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
210     require(b != 0);
211     return a % b;
212   }
213 }
214 
215 
216 /**
217  * @title Standard ERC20 token
218  *
219  * @dev Implementation of the basic standard token.
220  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
221  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
222  */
223 contract ERC20 is IERC20 {
224   using SafeMath for uint256;
225 
226   mapping (address => uint256) private _balances;
227 
228   mapping (address => mapping (address => uint256)) private _allowed;
229 
230   uint256 private _totalSupply;
231 
232   /**
233   * @dev Total number of tokens in existence
234   */
235   function totalSupply() public view returns (uint256) {
236     return _totalSupply;
237   }
238 
239   /**
240   * @dev Gets the balance of the specified address.
241   * @param owner The address to query the balance of.
242   * @return An uint256 representing the amount owned by the passed address.
243   */
244   function balanceOf(address owner) public view returns (uint256) {
245     return _balances[owner];
246   }
247 
248   /**
249    * @dev Function to check the amount of tokens that an owner allowed to a spender.
250    * @param owner address The address which owns the funds.
251    * @param spender address The address which will spend the funds.
252    * @return A uint256 specifying the amount of tokens still available for the spender.
253    */
254   function allowance(
255     address owner,
256     address spender
257    )
258     public
259     view
260     returns (uint256)
261   {
262     return _allowed[owner][spender];
263   }
264 
265   /**
266   * @dev Transfer token for a specified address
267   * @param to The address to transfer to.
268   * @param value The amount to be transferred.
269   */
270   function transfer(address to, uint256 value) public returns (bool) {
271     _transfer(msg.sender, to, value);
272     return true;
273   }
274 
275   /**
276    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
277    * Beware that changing an allowance with this method brings the risk that someone may use both the old
278    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
279    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
280    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
281    * @param spender The address which will spend the funds.
282    * @param value The amount of tokens to be spent.
283    */
284   function approve(address spender, uint256 value) public returns (bool) {
285     require(spender != address(0));
286 
287     _allowed[msg.sender][spender] = value;
288     emit Approval(msg.sender, spender, value);
289     return true;
290   }
291 
292   /**
293    * @dev Transfer tokens from one address to another
294    * @param from address The address which you want to send tokens from
295    * @param to address The address which you want to transfer to
296    * @param value uint256 the amount of tokens to be transferred
297    */
298   function transferFrom(
299     address from,
300     address to,
301     uint256 value
302   )
303     public
304     returns (bool)
305   {
306     require(value <= _allowed[from][msg.sender]);
307 
308     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
309     _transfer(from, to, value);
310     return true;
311   }
312 
313   /**
314    * @dev Increase the amount of tokens that an owner allowed to a spender.
315    * approve should be called when allowed_[_spender] == 0. To increment
316    * allowed value is better to use this function to avoid 2 calls (and wait until
317    * the first transaction is mined)
318    * From MonolithDAO Token.sol
319    * @param spender The address which will spend the funds.
320    * @param addedValue The amount of tokens to increase the allowance by.
321    */
322   function increaseAllowance(
323     address spender,
324     uint256 addedValue
325   )
326     public
327     returns (bool)
328   {
329     require(spender != address(0));
330 
331     _allowed[msg.sender][spender] = (
332       _allowed[msg.sender][spender].add(addedValue));
333     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
334     return true;
335   }
336 
337   /**
338    * @dev Decrease the amount of tokens that an owner allowed to a spender.
339    * approve should be called when allowed_[_spender] == 0. To decrement
340    * allowed value is better to use this function to avoid 2 calls (and wait until
341    * the first transaction is mined)
342    * From MonolithDAO Token.sol
343    * @param spender The address which will spend the funds.
344    * @param subtractedValue The amount of tokens to decrease the allowance by.
345    */
346   function decreaseAllowance(
347     address spender,
348     uint256 subtractedValue
349   )
350     public
351     returns (bool)
352   {
353     require(spender != address(0));
354 
355     _allowed[msg.sender][spender] = (
356       _allowed[msg.sender][spender].sub(subtractedValue));
357     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
358     return true;
359   }
360 
361   /**
362   * @dev Transfer token for a specified addresses
363   * @param from The address to transfer from.
364   * @param to The address to transfer to.
365   * @param value The amount to be transferred.
366   */
367   function _transfer(address from, address to, uint256 value) internal {
368     require(value <= _balances[from]);
369     require(to != address(0));
370 
371     _balances[from] = _balances[from].sub(value);
372     _balances[to] = _balances[to].add(value);
373     emit Transfer(from, to, value);
374   }
375 
376   /**
377    * @dev Internal function that mints an amount of the token and assigns it to
378    * an account. This encapsulates the modification of balances such that the
379    * proper events are emitted.
380    * @param account The account that will receive the created tokens.
381    * @param value The amount that will be created.
382    */
383   function _mint(address account, uint256 value) internal {
384     require(account != 0);
385     _totalSupply = _totalSupply.add(value);
386     _balances[account] = _balances[account].add(value);
387     emit Transfer(address(0), account, value);
388   }
389 
390   /**
391    * @dev Internal function that burns an amount of the token of a given
392    * account.
393    * @param account The account whose tokens will be burnt.
394    * @param value The amount that will be burnt.
395    */
396   function _burn(address account, uint256 value) internal {
397     require(account != 0);
398     require(value <= _balances[account]);
399 
400     _totalSupply = _totalSupply.sub(value);
401     _balances[account] = _balances[account].sub(value);
402     emit Transfer(account, address(0), value);
403   }
404 
405   /**
406    * @dev Internal function that burns an amount of the token of a given
407    * account, deducting from the sender's allowance for said account. Uses the
408    * internal burn function.
409    * @param account The account whose tokens will be burnt.
410    * @param value The amount that will be burnt.
411    */
412   function _burnFrom(address account, uint256 value) internal {
413     require(value <= _allowed[account][msg.sender]);
414 
415     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
416     // this function needs to emit an event with the updated approval.
417     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
418       value);
419     _burn(account, value);
420   }
421 }
422 
423 
424 /**
425  * @title Roles
426  * @dev Library for managing addresses assigned to a Role.
427  */
428 library Roles {
429   struct Role {
430     mapping (address => bool) bearer;
431   }
432 
433   /**
434    * @dev give an account access to this role
435    */
436   function add(Role storage role, address account) internal {
437     require(account != address(0));
438     require(!has(role, account));
439 
440     role.bearer[account] = true;
441   }
442 
443   /**
444    * @dev remove an account's access to this role
445    */
446   function remove(Role storage role, address account) internal {
447     require(account != address(0));
448     require(has(role, account));
449 
450     role.bearer[account] = false;
451   }
452 
453   /**
454    * @dev check if an account has this role
455    * @return bool
456    */
457   function has(Role storage role, address account)
458     internal
459     view
460     returns (bool)
461   {
462     require(account != address(0));
463     return role.bearer[account];
464   }
465 }
466 
467 
468 contract PauserRole {
469   using Roles for Roles.Role;
470 
471   event PauserAdded(address indexed account);
472   event PauserRemoved(address indexed account);
473 
474   Roles.Role private pausers;
475 
476   constructor() internal {
477     _addPauser(msg.sender);
478   }
479 
480   modifier onlyPauser() {
481     require(isPauser(msg.sender));
482     _;
483   }
484 
485   function isPauser(address account) public view returns (bool) {
486     return pausers.has(account);
487   }
488 
489   function addPauser(address account) public onlyPauser {
490     _addPauser(account);
491   }
492 
493   function renouncePauser() public {
494     _removePauser(msg.sender);
495   }
496 
497   function _addPauser(address account) internal {
498     pausers.add(account);
499     emit PauserAdded(account);
500   }
501 
502   function _removePauser(address account) internal {
503     pausers.remove(account);
504     emit PauserRemoved(account);
505   }
506 }
507 
508 
509 /**
510  * @title Pausable
511  * @dev Base contract which allows children to implement an emergency stop mechanism.
512  */
513 contract Pausable is PauserRole {
514   event Paused(address account);
515   event Unpaused(address account);
516 
517   bool private _paused;
518 
519   constructor() internal {
520     _paused = false;
521   }
522 
523   /**
524    * @return true if the contract is paused, false otherwise.
525    */
526   function paused() public view returns(bool) {
527     return _paused;
528   }
529 
530   /**
531    * @dev Modifier to make a function callable only when the contract is not paused.
532    */
533   modifier whenNotPaused() {
534     require(!_paused);
535     _;
536   }
537 
538   /**
539    * @dev Modifier to make a function callable only when the contract is paused.
540    */
541   modifier whenPaused() {
542     require(_paused);
543     _;
544   }
545 
546   /**
547    * @dev called by the owner to pause, triggers stopped state
548    */
549   function pause() public onlyPauser whenNotPaused {
550     _paused = true;
551     emit Paused(msg.sender);
552   }
553 
554   /**
555    * @dev called by the owner to unpause, returns to normal state
556    */
557   function unpause() public onlyPauser whenPaused {
558     _paused = false;
559     emit Unpaused(msg.sender);
560   }
561 }
562 
563 
564 /**
565  * @title Pausable token
566  * @dev ERC20 modified with pausable transfers.
567  **/
568 contract ERC20Pausable is ERC20, Pausable {
569 
570   function transfer(
571     address to,
572     uint256 value
573   )
574     public
575     whenNotPaused
576     returns (bool)
577   {
578     return super.transfer(to, value);
579   }
580 
581   function transferFrom(
582     address from,
583     address to,
584     uint256 value
585   )
586     public
587     whenNotPaused
588     returns (bool)
589   {
590     return super.transferFrom(from, to, value);
591   }
592 
593   function approve(
594     address spender,
595     uint256 value
596   )
597     public
598     whenNotPaused
599     returns (bool)
600   {
601     return super.approve(spender, value);
602   }
603 
604   function increaseAllowance(
605     address spender,
606     uint addedValue
607   )
608     public
609     whenNotPaused
610     returns (bool success)
611   {
612     return super.increaseAllowance(spender, addedValue);
613   }
614 
615   function decreaseAllowance(
616     address spender,
617     uint subtractedValue
618   )
619     public
620     whenNotPaused
621     returns (bool success)
622   {
623     return super.decreaseAllowance(spender, subtractedValue);
624   }
625 }
626 
627 contract SignkeysToken is ERC20Pausable, ERC20Detailed, Ownable {
628 
629     uint8 public constant DECIMALS = 18;
630 
631     uint256 public constant INITIAL_SUPPLY = 2E10 * (10 ** uint256(DECIMALS));
632 
633     /**
634      * @dev Constructor that gives msg.sender all of existing tokens.
635      */
636     constructor() public ERC20Detailed("SignkeysToken", "KEYS", DECIMALS) {
637         _mint(owner(), INITIAL_SUPPLY);
638     }
639 
640     function approveAndCall(address _spender, uint256 _value, bytes _data) public payable returns (bool success) {
641         require(_spender != address(this));
642         require(super.approve(_spender, _value));
643         require(_spender.call(_data));
644         return true;
645     }
646 
647     function() payable external {
648         revert();
649     }
650 }
651 
652 contract ReentrancyGuard {
653 
654   /// @dev counter to allow mutex lock with only one SSTORE operation
655   uint256 private _guardCounter;
656 
657   constructor() internal {
658     // The counter starts at one to prevent changing it from zero to a non-zero
659     // value, which is a more expensive operation.
660     _guardCounter = 1;
661   }
662 
663   /**
664    * @dev Prevents a contract from calling itself, directly or indirectly.
665    * Calling a `nonReentrant` function from another `nonReentrant`
666    * function is not supported. It is possible to prevent this from happening
667    * by making the `nonReentrant` function external, and make it call a
668    * `private` function that does the actual work.
669    */
670   modifier nonReentrant() {
671     _guardCounter += 1;
672     uint256 localCounter = _guardCounter;
673     _;
674     require(localCounter == _guardCounter);
675   }
676 
677 }