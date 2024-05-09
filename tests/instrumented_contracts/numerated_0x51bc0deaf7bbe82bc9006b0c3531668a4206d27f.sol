1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 interface IERC20 {
8   function totalSupply() external view returns (uint256);
9 
10   function balanceOf(address who) external view returns (uint256);
11 
12   function allowance(address owner, address spender)
13     external view returns (uint256);
14 
15   function transfer(address to, uint256 value) external returns (bool);
16 
17   function approve(address spender, uint256 value)
18     external returns (bool);
19 
20   function transferFrom(address from, address to, uint256 value)
21     external returns (bool);
22 
23   event Transfer(
24     address indexed from,
25     address indexed to,
26     uint256 value
27   );
28 
29   event Approval(
30     address indexed owner,
31     address indexed spender,
32     uint256 value
33   );
34 }
35 
36 
37 /**
38  * @title SafeMath
39  * @dev Math operations with safety checks that revert on error
40  */
41 library SafeMath {
42 
43   /**
44   * @dev Multiplies two numbers, reverts on overflow.
45   */
46   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
47     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
48     // benefit is lost if 'b' is also tested.
49     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
50     if (a == 0) {
51       return 0;
52     }
53 
54     uint256 c = a * b;
55     require(c / a == b);
56 
57     return c;
58   }
59 
60   /**
61   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
62   */
63   function div(uint256 a, uint256 b) internal pure returns (uint256) {
64     require(b > 0); // Solidity only automatically asserts when dividing by 0
65     uint256 c = a / b;
66     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
67 
68     return c;
69   }
70 
71   /**
72   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
73   */
74   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
75     require(b <= a);
76     uint256 c = a - b;
77 
78     return c;
79   }
80 
81   /**
82   * @dev Adds two numbers, reverts on overflow.
83   */
84   function add(uint256 a, uint256 b) internal pure returns (uint256) {
85     uint256 c = a + b;
86     require(c >= a);
87 
88     return c;
89   }
90 
91   /**
92   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
93   * reverts when dividing by zero.
94   */
95   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
96     require(b != 0);
97     return a % b;
98   }
99 }
100 
101 
102 /**
103  * @title Standard ERC20 token
104  *
105  * @dev Implementation of the basic standard token.
106  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
107  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
108  */
109 contract ERC20 is IERC20 {
110   using SafeMath for uint256;
111 
112   mapping (address => uint256) private _balances;
113 
114   mapping (address => mapping (address => uint256)) private _allowed;
115 
116   uint256 private _totalSupply;
117 
118   /**
119   * @dev Total number of tokens in existence
120   */
121   function totalSupply() public view returns (uint256) {
122     return _totalSupply;
123   }
124 
125   /**
126   * @dev Gets the balance of the specified address.
127   * @param owner The address to query the balance of.
128   * @return An uint256 representing the amount owned by the passed address.
129   */
130   function balanceOf(address owner) public view returns (uint256) {
131     return _balances[owner];
132   }
133 
134   /**
135    * @dev Function to check the amount of tokens that an owner allowed to a spender.
136    * @param owner address The address which owns the funds.
137    * @param spender address The address which will spend the funds.
138    * @return A uint256 specifying the amount of tokens still available for the spender.
139    */
140   function allowance(
141     address owner,
142     address spender
143    )
144     public
145     view
146     returns (uint256)
147   {
148     return _allowed[owner][spender];
149   }
150 
151   /**
152   * @dev Transfer token for a specified address
153   * @param to The address to transfer to.
154   * @param value The amount to be transferred.
155   */
156   function transfer(address to, uint256 value) public returns (bool) {
157     _transfer(msg.sender, to, value);
158     return true;
159   }
160 
161   /**
162    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
163    * Beware that changing an allowance with this method brings the risk that someone may use both the old
164    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
165    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
166    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
167    * @param spender The address which will spend the funds.
168    * @param value The amount of tokens to be spent.
169    */
170   function approve(address spender, uint256 value) public returns (bool) {
171     require(spender != address(0));
172 
173     _allowed[msg.sender][spender] = value;
174     emit Approval(msg.sender, spender, value);
175     return true;
176   }
177 
178   /**
179    * @dev Transfer tokens from one address to another
180    * @param from address The address which you want to send tokens from
181    * @param to address The address which you want to transfer to
182    * @param value uint256 the amount of tokens to be transferred
183    */
184   function transferFrom(
185     address from,
186     address to,
187     uint256 value
188   )
189     public
190     returns (bool)
191   {
192     require(value <= _allowed[from][msg.sender]);
193 
194     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
195     _transfer(from, to, value);
196     return true;
197   }
198 
199   /**
200    * @dev Increase the amount of tokens that an owner allowed to a spender.
201    * approve should be called when allowed_[_spender] == 0. To increment
202    * allowed value is better to use this function to avoid 2 calls (and wait until
203    * the first transaction is mined)
204    * From MonolithDAO Token.sol
205    * @param spender The address which will spend the funds.
206    * @param addedValue The amount of tokens to increase the allowance by.
207    */
208   function increaseAllowance(
209     address spender,
210     uint256 addedValue
211   )
212     public
213     returns (bool)
214   {
215     require(spender != address(0));
216 
217     _allowed[msg.sender][spender] = (
218       _allowed[msg.sender][spender].add(addedValue));
219     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
220     return true;
221   }
222 
223   /**
224    * @dev Decrease the amount of tokens that an owner allowed to a spender.
225    * approve should be called when allowed_[_spender] == 0. To decrement
226    * allowed value is better to use this function to avoid 2 calls (and wait until
227    * the first transaction is mined)
228    * From MonolithDAO Token.sol
229    * @param spender The address which will spend the funds.
230    * @param subtractedValue The amount of tokens to decrease the allowance by.
231    */
232   function decreaseAllowance(
233     address spender,
234     uint256 subtractedValue
235   )
236     public
237     returns (bool)
238   {
239     require(spender != address(0));
240 
241     _allowed[msg.sender][spender] = (
242       _allowed[msg.sender][spender].sub(subtractedValue));
243     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
244     return true;
245   }
246 
247   /**
248   * @dev Transfer token for a specified addresses
249   * @param from The address to transfer from.
250   * @param to The address to transfer to.
251   * @param value The amount to be transferred.
252   */
253   function _transfer(address from, address to, uint256 value) internal {
254     require(value <= _balances[from]);
255     require(to != address(0));
256 
257     _balances[from] = _balances[from].sub(value);
258     _balances[to] = _balances[to].add(value);
259     emit Transfer(from, to, value);
260   }
261 
262   /**
263    * @dev Internal function that mints an amount of the token and assigns it to
264    * an account. This encapsulates the modification of balances such that the
265    * proper events are emitted.
266    * @param account The account that will receive the created tokens.
267    * @param value The amount that will be created.
268    */
269   function _mint(address account, uint256 value) internal {
270     require(account != 0);
271     _totalSupply = _totalSupply.add(value);
272     _balances[account] = _balances[account].add(value);
273     emit Transfer(address(0), account, value);
274   }
275 
276   /**
277    * @dev Internal function that burns an amount of the token of a given
278    * account.
279    * @param account The account whose tokens will be burnt.
280    * @param value The amount that will be burnt.
281    */
282   function _burn(address account, uint256 value) internal {
283     require(account != 0);
284     require(value <= _balances[account]);
285 
286     _totalSupply = _totalSupply.sub(value);
287     _balances[account] = _balances[account].sub(value);
288     emit Transfer(account, address(0), value);
289   }
290 
291   /**
292    * @dev Internal function that burns an amount of the token of a given
293    * account, deducting from the sender's allowance for said account. Uses the
294    * internal burn function.
295    * @param account The account whose tokens will be burnt.
296    * @param value The amount that will be burnt.
297    */
298   function _burnFrom(address account, uint256 value) internal {
299     require(value <= _allowed[account][msg.sender]);
300 
301     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
302     // this function needs to emit an event with the updated approval.
303     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
304       value);
305     _burn(account, value);
306   }
307 }
308 
309 
310 /**
311  * @title ERC20Detailed token
312  * @dev The decimals are only for visualization purposes.
313  * All the operations are done using the smallest and indivisible token unit,
314  * just as on Ethereum all the operations are done in wei.
315  */
316 contract ERC20Detailed is IERC20 {
317   string private _name;
318   string private _symbol;
319   uint8 private _decimals;
320 
321   constructor(string name, string symbol, uint8 decimals) public {
322     _name = name;
323     _symbol = symbol;
324     _decimals = decimals;
325   }
326 
327   /**
328    * @return the name of the token.
329    */
330   function name() public view returns(string) {
331     return _name;
332   }
333 
334   /**
335    * @return the symbol of the token.
336    */
337   function symbol() public view returns(string) {
338     return _symbol;
339   }
340 
341   /**
342    * @return the number of decimals of the token.
343    */
344   function decimals() public view returns(uint8) {
345     return _decimals;
346   }
347 }
348 
349 
350 /**
351  * @title Roles
352  * @dev Library for managing addresses assigned to a Role.
353  */
354 library Roles {
355   struct Role {
356     mapping (address => bool) bearer;
357   }
358 
359   /**
360    * @dev give an account access to this role
361    */
362   function add(Role storage role, address account) internal {
363     require(account != address(0));
364     require(!has(role, account));
365 
366     role.bearer[account] = true;
367   }
368 
369   /**
370    * @dev remove an account's access to this role
371    */
372   function remove(Role storage role, address account) internal {
373     require(account != address(0));
374     require(has(role, account));
375 
376     role.bearer[account] = false;
377   }
378 
379   /**
380    * @dev check if an account has this role
381    * @return bool
382    */
383   function has(Role storage role, address account)
384     internal
385     view
386     returns (bool)
387   {
388     require(account != address(0));
389     return role.bearer[account];
390   }
391 }
392 
393 
394 contract PauserRole {
395   using Roles for Roles.Role;
396 
397   event PauserAdded(address indexed account);
398   event PauserRemoved(address indexed account);
399 
400   Roles.Role private pausers;
401 
402   constructor() internal {
403     _addPauser(msg.sender);
404   }
405 
406   modifier onlyPauser() {
407     require(isPauser(msg.sender));
408     _;
409   }
410 
411   function isPauser(address account) public view returns (bool) {
412     return pausers.has(account);
413   }
414 
415   function addPauser(address account) public onlyPauser {
416     _addPauser(account);
417   }
418 
419   function renouncePauser() public {
420     _removePauser(msg.sender);
421   }
422 
423   function _addPauser(address account) internal {
424     pausers.add(account);
425     emit PauserAdded(account);
426   }
427 
428   function _removePauser(address account) internal {
429     pausers.remove(account);
430     emit PauserRemoved(account);
431   }
432 }
433 
434 
435 /**
436  * @title Pausable
437  * @dev Base contract which allows children to implement an emergency stop mechanism.
438  */
439 contract Pausable is PauserRole {
440   event Paused(address account);
441   event Unpaused(address account);
442 
443   bool private _paused;
444 
445   constructor() internal {
446     _paused = false;
447   }
448 
449   /**
450    * @return true if the contract is paused, false otherwise.
451    */
452   function paused() public view returns(bool) {
453     return _paused;
454   }
455 
456   /**
457    * @dev Modifier to make a function callable only when the contract is not paused.
458    */
459   modifier whenNotPaused() {
460     require(!_paused);
461     _;
462   }
463 
464   /**
465    * @dev Modifier to make a function callable only when the contract is paused.
466    */
467   modifier whenPaused() {
468     require(_paused);
469     _;
470   }
471 
472   /**
473    * @dev called by the owner to pause, triggers stopped state
474    */
475   function pause() public onlyPauser whenNotPaused {
476     _paused = true;
477     emit Paused(msg.sender);
478   }
479 
480   /**
481    * @dev called by the owner to unpause, returns to normal state
482    */
483   function unpause() public onlyPauser whenPaused {
484     _paused = false;
485     emit Unpaused(msg.sender);
486   }
487 }
488 
489 
490 /**
491  * @title Pausable token
492  * @dev ERC20 modified with pausable transfers.
493  **/
494 contract ERC20Pausable is ERC20, Pausable {
495 
496   function transfer(
497     address to,
498     uint256 value
499   )
500     public
501     whenNotPaused
502     returns (bool)
503   {
504     return super.transfer(to, value);
505   }
506 
507   function transferFrom(
508     address from,
509     address to,
510     uint256 value
511   )
512     public
513     whenNotPaused
514     returns (bool)
515   {
516     return super.transferFrom(from, to, value);
517   }
518 
519   function approve(
520     address spender,
521     uint256 value
522   )
523     public
524     whenNotPaused
525     returns (bool)
526   {
527     return super.approve(spender, value);
528   }
529 
530   function increaseAllowance(
531     address spender,
532     uint addedValue
533   )
534     public
535     whenNotPaused
536     returns (bool success)
537   {
538     return super.increaseAllowance(spender, addedValue);
539   }
540 
541   function decreaseAllowance(
542     address spender,
543     uint subtractedValue
544   )
545     public
546     whenNotPaused
547     returns (bool success)
548   {
549     return super.decreaseAllowance(spender, subtractedValue);
550   }
551 }
552 
553 
554 contract MinterRole {
555   using Roles for Roles.Role;
556 
557   event MinterAdded(address indexed account);
558   event MinterRemoved(address indexed account);
559 
560   Roles.Role private minters;
561 
562   constructor() internal {
563     _addMinter(msg.sender);
564   }
565 
566   modifier onlyMinter() {
567     require(isMinter(msg.sender));
568     _;
569   }
570 
571   function isMinter(address account) public view returns (bool) {
572     return minters.has(account);
573   }
574 
575   function addMinter(address account) public onlyMinter {
576     _addMinter(account);
577   }
578 
579   function renounceMinter() public {
580     _removeMinter(msg.sender);
581   }
582 
583   function _addMinter(address account) internal {
584     minters.add(account);
585     emit MinterAdded(account);
586   }
587 
588   function _removeMinter(address account) internal {
589     minters.remove(account);
590     emit MinterRemoved(account);
591   }
592 }
593 
594 
595 /**
596  * @title ERC20Mintable
597  * @dev ERC20 minting logic
598  */
599 contract ERC20Mintable is ERC20, MinterRole {
600   /**
601    * @dev Function to mint tokens
602    * @param to The address that will receive the minted tokens.
603    * @param value The amount of tokens to mint.
604    * @return A boolean that indicates if the operation was successful.
605    */
606   function mint(
607     address to,
608     uint256 value
609   )
610     public
611     onlyMinter
612     returns (bool)
613   {
614     _mint(to, value);
615     return true;
616   }
617 }
618 
619 
620 /**
621  * @title Ownable
622  * @dev The Ownable contract has an owner address, and provides basic authorization control
623  * functions, this simplifies the implementation of "user permissions".
624  */
625 contract Ownable {
626   address private _owner;
627 
628   event OwnershipTransferred(
629     address indexed previousOwner,
630     address indexed newOwner
631   );
632 
633   /**
634    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
635    * account.
636    */
637   constructor() internal {
638     _owner = msg.sender;
639     emit OwnershipTransferred(address(0), _owner);
640   }
641 
642   /**
643    * @return the address of the owner.
644    */
645   function owner() public view returns(address) {
646     return _owner;
647   }
648 
649   /**
650    * @dev Throws if called by any account other than the owner.
651    */
652   modifier onlyOwner() {
653     require(isOwner());
654     _;
655   }
656 
657   /**
658    * @return true if `msg.sender` is the owner of the contract.
659    */
660   function isOwner() public view returns(bool) {
661     return msg.sender == _owner;
662   }
663 
664   /**
665    * @dev Allows the current owner to relinquish control of the contract.
666    * @notice Renouncing to ownership will leave the contract without an owner.
667    * It will not be possible to call the functions with the `onlyOwner`
668    * modifier anymore.
669    */
670   function renounceOwnership() public onlyOwner {
671     emit OwnershipTransferred(_owner, address(0));
672     _owner = address(0);
673   }
674 
675   /**
676    * @dev Allows the current owner to transfer control of the contract to a newOwner.
677    * @param newOwner The address to transfer ownership to.
678    */
679   function transferOwnership(address newOwner) public onlyOwner {
680     _transferOwnership(newOwner);
681   }
682 
683   /**
684    * @dev Transfers control of the contract to a newOwner.
685    * @param newOwner The address to transfer ownership to.
686    */
687   function _transferOwnership(address newOwner) internal {
688     require(newOwner != address(0));
689     emit OwnershipTransferred(_owner, newOwner);
690     _owner = newOwner;
691   }
692 }
693 
694 
695 /**
696  * @title RakunCoin
697  * @dev extends Pausable, Mintable, Ownable
698  */
699 contract RakunCoin is ERC20, ERC20Detailed, ERC20Pausable, ERC20Mintable, Ownable {
700 
701   uint8 public constant DECIMALS = 18;
702   // 10
703   uint256 public constant INITIAL_SUPPLY = 10 * (10 ** uint256(DECIMALS));
704 
705   /**
706    * @dev Constructor that gives msg.sender all of existing tokens.
707    */
708   constructor() public ERC20Detailed("RAKUN", "RAKU", DECIMALS) {
709     _mint(msg.sender, INITIAL_SUPPLY);
710   }
711 
712   /**
713    * @dev remove an account's access to Mint
714    * @param account minter
715    */
716   function removeMinter(address account) public onlyOwner {
717     _removeMinter(account);
718   }
719 
720   /**
721    * @dev remove an account's access to Pause
722    * @param account pauser
723    */
724   function removePauser(address account) public onlyOwner {
725     _removePauser(account);
726   }
727 }