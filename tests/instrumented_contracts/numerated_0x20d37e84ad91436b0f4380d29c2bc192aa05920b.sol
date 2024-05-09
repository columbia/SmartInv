1 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
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
38 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
39 
40 pragma solidity ^0.4.24;
41 
42 /**
43  * @title SafeMath
44  * @dev Math operations with safety checks that revert on error
45  */
46 library SafeMath {
47 
48   /**
49   * @dev Multiplies two numbers, reverts on overflow.
50   */
51   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
52     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
53     // benefit is lost if 'b' is also tested.
54     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
55     if (a == 0) {
56       return 0;
57     }
58 
59     uint256 c = a * b;
60     require(c / a == b);
61 
62     return c;
63   }
64 
65   /**
66   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
67   */
68   function div(uint256 a, uint256 b) internal pure returns (uint256) {
69     require(b > 0); // Solidity only automatically asserts when dividing by 0
70     uint256 c = a / b;
71     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
72 
73     return c;
74   }
75 
76   /**
77   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
78   */
79   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
80     require(b <= a);
81     uint256 c = a - b;
82 
83     return c;
84   }
85 
86   /**
87   * @dev Adds two numbers, reverts on overflow.
88   */
89   function add(uint256 a, uint256 b) internal pure returns (uint256) {
90     uint256 c = a + b;
91     require(c >= a);
92 
93     return c;
94   }
95 
96   /**
97   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
98   * reverts when dividing by zero.
99   */
100   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
101     require(b != 0);
102     return a % b;
103   }
104 }
105 
106 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
107 
108 pragma solidity ^0.4.24;
109 
110 
111 
112 /**
113  * @title Standard ERC20 token
114  *
115  * @dev Implementation of the basic standard token.
116  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
117  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
118  */
119 contract ERC20 is IERC20 {
120   using SafeMath for uint256;
121 
122   mapping (address => uint256) private _balances;
123 
124   mapping (address => mapping (address => uint256)) private _allowed;
125 
126   uint256 private _totalSupply;
127 
128   /**
129   * @dev Total number of tokens in existence
130   */
131   function totalSupply() public view returns (uint256) {
132     return _totalSupply;
133   }
134 
135   /**
136   * @dev Gets the balance of the specified address.
137   * @param owner The address to query the balance of.
138   * @return An uint256 representing the amount owned by the passed address.
139   */
140   function balanceOf(address owner) public view returns (uint256) {
141     return _balances[owner];
142   }
143 
144   /**
145    * @dev Function to check the amount of tokens that an owner allowed to a spender.
146    * @param owner address The address which owns the funds.
147    * @param spender address The address which will spend the funds.
148    * @return A uint256 specifying the amount of tokens still available for the spender.
149    */
150   function allowance(
151     address owner,
152     address spender
153    )
154     public
155     view
156     returns (uint256)
157   {
158     return _allowed[owner][spender];
159   }
160 
161   /**
162   * @dev Transfer token for a specified address
163   * @param to The address to transfer to.
164   * @param value The amount to be transferred.
165   */
166   function transfer(address to, uint256 value) public returns (bool) {
167     _transfer(msg.sender, to, value);
168     return true;
169   }
170 
171   /**
172    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
173    * Beware that changing an allowance with this method brings the risk that someone may use both the old
174    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
175    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
176    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
177    * @param spender The address which will spend the funds.
178    * @param value The amount of tokens to be spent.
179    */
180   function approve(address spender, uint256 value) public returns (bool) {
181     require(spender != address(0));
182 
183     _allowed[msg.sender][spender] = value;
184     emit Approval(msg.sender, spender, value);
185     return true;
186   }
187 
188   /**
189    * @dev Transfer tokens from one address to another
190    * @param from address The address which you want to send tokens from
191    * @param to address The address which you want to transfer to
192    * @param value uint256 the amount of tokens to be transferred
193    */
194   function transferFrom(
195     address from,
196     address to,
197     uint256 value
198   )
199     public
200     returns (bool)
201   {
202     require(value <= _allowed[from][msg.sender]);
203 
204     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
205     _transfer(from, to, value);
206     return true;
207   }
208 
209   /**
210    * @dev Increase the amount of tokens that an owner allowed to a spender.
211    * approve should be called when allowed_[_spender] == 0. To increment
212    * allowed value is better to use this function to avoid 2 calls (and wait until
213    * the first transaction is mined)
214    * From MonolithDAO Token.sol
215    * @param spender The address which will spend the funds.
216    * @param addedValue The amount of tokens to increase the allowance by.
217    */
218   function increaseAllowance(
219     address spender,
220     uint256 addedValue
221   )
222     public
223     returns (bool)
224   {
225     require(spender != address(0));
226 
227     _allowed[msg.sender][spender] = (
228       _allowed[msg.sender][spender].add(addedValue));
229     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
230     return true;
231   }
232 
233   /**
234    * @dev Decrease the amount of tokens that an owner allowed to a spender.
235    * approve should be called when allowed_[_spender] == 0. To decrement
236    * allowed value is better to use this function to avoid 2 calls (and wait until
237    * the first transaction is mined)
238    * From MonolithDAO Token.sol
239    * @param spender The address which will spend the funds.
240    * @param subtractedValue The amount of tokens to decrease the allowance by.
241    */
242   function decreaseAllowance(
243     address spender,
244     uint256 subtractedValue
245   )
246     public
247     returns (bool)
248   {
249     require(spender != address(0));
250 
251     _allowed[msg.sender][spender] = (
252       _allowed[msg.sender][spender].sub(subtractedValue));
253     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
254     return true;
255   }
256 
257   /**
258   * @dev Transfer token for a specified addresses
259   * @param from The address to transfer from.
260   * @param to The address to transfer to.
261   * @param value The amount to be transferred.
262   */
263   function _transfer(address from, address to, uint256 value) internal {
264     require(value <= _balances[from]);
265     require(to != address(0));
266 
267     _balances[from] = _balances[from].sub(value);
268     _balances[to] = _balances[to].add(value);
269     emit Transfer(from, to, value);
270   }
271 
272   /**
273    * @dev Internal function that mints an amount of the token and assigns it to
274    * an account. This encapsulates the modification of balances such that the
275    * proper events are emitted.
276    * @param account The account that will receive the created tokens.
277    * @param value The amount that will be created.
278    */
279   function _mint(address account, uint256 value) internal {
280     require(account != 0);
281     _totalSupply = _totalSupply.add(value);
282     _balances[account] = _balances[account].add(value);
283     emit Transfer(address(0), account, value);
284   }
285 
286   /**
287    * @dev Internal function that burns an amount of the token of a given
288    * account.
289    * @param account The account whose tokens will be burnt.
290    * @param value The amount that will be burnt.
291    */
292   function _burn(address account, uint256 value) internal {
293     require(account != 0);
294     require(value <= _balances[account]);
295 
296     _totalSupply = _totalSupply.sub(value);
297     _balances[account] = _balances[account].sub(value);
298     emit Transfer(account, address(0), value);
299   }
300 
301   /**
302    * @dev Internal function that burns an amount of the token of a given
303    * account, deducting from the sender's allowance for said account. Uses the
304    * internal burn function.
305    * @param account The account whose tokens will be burnt.
306    * @param value The amount that will be burnt.
307    */
308   function _burnFrom(address account, uint256 value) internal {
309     require(value <= _allowed[account][msg.sender]);
310 
311     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
312     // this function needs to emit an event with the updated approval.
313     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
314       value);
315     _burn(account, value);
316   }
317 }
318 
319 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
320 
321 pragma solidity ^0.4.24;
322 
323 
324 /**
325  * @title ERC20Detailed token
326  * @dev The decimals are only for visualization purposes.
327  * All the operations are done using the smallest and indivisible token unit,
328  * just as on Ethereum all the operations are done in wei.
329  */
330 contract ERC20Detailed is IERC20 {
331   string private _name;
332   string private _symbol;
333   uint8 private _decimals;
334 
335   constructor(string name, string symbol, uint8 decimals) public {
336     _name = name;
337     _symbol = symbol;
338     _decimals = decimals;
339   }
340 
341   /**
342    * @return the name of the token.
343    */
344   function name() public view returns(string) {
345     return _name;
346   }
347 
348   /**
349    * @return the symbol of the token.
350    */
351   function symbol() public view returns(string) {
352     return _symbol;
353   }
354 
355   /**
356    * @return the number of decimals of the token.
357    */
358   function decimals() public view returns(uint8) {
359     return _decimals;
360   }
361 }
362 
363 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol
364 
365 pragma solidity ^0.4.24;
366 
367 
368 /**
369  * @title Burnable Token
370  * @dev Token that can be irreversibly burned (destroyed).
371  */
372 contract ERC20Burnable is ERC20 {
373 
374   /**
375    * @dev Burns a specific amount of tokens.
376    * @param value The amount of token to be burned.
377    */
378   function burn(uint256 value) public {
379     _burn(msg.sender, value);
380   }
381 
382   /**
383    * @dev Burns a specific amount of tokens from the target address and decrements allowance
384    * @param from address The address which you want to send tokens from
385    * @param value uint256 The amount of token to be burned
386    */
387   function burnFrom(address from, uint256 value) public {
388     _burnFrom(from, value);
389   }
390 }
391 
392 // File: openzeppelin-solidity/contracts/access/Roles.sol
393 
394 pragma solidity ^0.4.24;
395 
396 /**
397  * @title Roles
398  * @dev Library for managing addresses assigned to a Role.
399  */
400 library Roles {
401   struct Role {
402     mapping (address => bool) bearer;
403   }
404 
405   /**
406    * @dev give an account access to this role
407    */
408   function add(Role storage role, address account) internal {
409     require(account != address(0));
410     require(!has(role, account));
411 
412     role.bearer[account] = true;
413   }
414 
415   /**
416    * @dev remove an account's access to this role
417    */
418   function remove(Role storage role, address account) internal {
419     require(account != address(0));
420     require(has(role, account));
421 
422     role.bearer[account] = false;
423   }
424 
425   /**
426    * @dev check if an account has this role
427    * @return bool
428    */
429   function has(Role storage role, address account)
430     internal
431     view
432     returns (bool)
433   {
434     require(account != address(0));
435     return role.bearer[account];
436   }
437 }
438 
439 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
440 
441 pragma solidity ^0.4.24;
442 
443 
444 contract PauserRole {
445   using Roles for Roles.Role;
446 
447   event PauserAdded(address indexed account);
448   event PauserRemoved(address indexed account);
449 
450   Roles.Role private pausers;
451 
452   constructor() internal {
453     _addPauser(msg.sender);
454   }
455 
456   modifier onlyPauser() {
457     require(isPauser(msg.sender));
458     _;
459   }
460 
461   function isPauser(address account) public view returns (bool) {
462     return pausers.has(account);
463   }
464 
465   function addPauser(address account) public onlyPauser {
466     _addPauser(account);
467   }
468 
469   function renouncePauser() public {
470     _removePauser(msg.sender);
471   }
472 
473   function _addPauser(address account) internal {
474     pausers.add(account);
475     emit PauserAdded(account);
476   }
477 
478   function _removePauser(address account) internal {
479     pausers.remove(account);
480     emit PauserRemoved(account);
481   }
482 }
483 
484 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
485 
486 pragma solidity ^0.4.24;
487 
488 
489 /**
490  * @title Pausable
491  * @dev Base contract which allows children to implement an emergency stop mechanism.
492  */
493 contract Pausable is PauserRole {
494   event Paused(address account);
495   event Unpaused(address account);
496 
497   bool private _paused;
498 
499   constructor() internal {
500     _paused = false;
501   }
502 
503   /**
504    * @return true if the contract is paused, false otherwise.
505    */
506   function paused() public view returns(bool) {
507     return _paused;
508   }
509 
510   /**
511    * @dev Modifier to make a function callable only when the contract is not paused.
512    */
513   modifier whenNotPaused() {
514     require(!_paused);
515     _;
516   }
517 
518   /**
519    * @dev Modifier to make a function callable only when the contract is paused.
520    */
521   modifier whenPaused() {
522     require(_paused);
523     _;
524   }
525 
526   /**
527    * @dev called by the owner to pause, triggers stopped state
528    */
529   function pause() public onlyPauser whenNotPaused {
530     _paused = true;
531     emit Paused(msg.sender);
532   }
533 
534   /**
535    * @dev called by the owner to unpause, returns to normal state
536    */
537   function unpause() public onlyPauser whenPaused {
538     _paused = false;
539     emit Unpaused(msg.sender);
540   }
541 }
542 
543 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
544 
545 pragma solidity ^0.4.24;
546 
547 /**
548  * @title Ownable
549  * @dev The Ownable contract has an owner address, and provides basic authorization control
550  * functions, this simplifies the implementation of "user permissions".
551  */
552 contract Ownable {
553   address private _owner;
554 
555   event OwnershipTransferred(
556     address indexed previousOwner,
557     address indexed newOwner
558   );
559 
560   /**
561    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
562    * account.
563    */
564   constructor() internal {
565     _owner = msg.sender;
566     emit OwnershipTransferred(address(0), _owner);
567   }
568 
569   /**
570    * @return the address of the owner.
571    */
572   function owner() public view returns(address) {
573     return _owner;
574   }
575 
576   /**
577    * @dev Throws if called by any account other than the owner.
578    */
579   modifier onlyOwner() {
580     require(isOwner());
581     _;
582   }
583 
584   /**
585    * @return true if `msg.sender` is the owner of the contract.
586    */
587   function isOwner() public view returns(bool) {
588     return msg.sender == _owner;
589   }
590 
591   /**
592    * @dev Allows the current owner to relinquish control of the contract.
593    * @notice Renouncing to ownership will leave the contract without an owner.
594    * It will not be possible to call the functions with the `onlyOwner`
595    * modifier anymore.
596    */
597   function renounceOwnership() public onlyOwner {
598     emit OwnershipTransferred(_owner, address(0));
599     _owner = address(0);
600   }
601 
602   /**
603    * @dev Allows the current owner to transfer control of the contract to a newOwner.
604    * @param newOwner The address to transfer ownership to.
605    */
606   function transferOwnership(address newOwner) public onlyOwner {
607     _transferOwnership(newOwner);
608   }
609 
610   /**
611    * @dev Transfers control of the contract to a newOwner.
612    * @param newOwner The address to transfer ownership to.
613    */
614   function _transferOwnership(address newOwner) internal {
615     require(newOwner != address(0));
616     emit OwnershipTransferred(_owner, newOwner);
617     _owner = newOwner;
618   }
619 }
620 
621 // File: contracts/ERC20PausableNonOwner.sol
622 
623 pragma solidity 0.4.25;
624 
625 /**
626  * Copyright (c) 2016 Smart Contract Solutions, Inc.
627  * Released under the MIT license.
628  * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/LICENSE
629 */
630 
631 
632 
633 
634 /**
635  * @title Pausable custom token
636  * @dev ERC20 modified with pausable transfers other than Owner.
637  */
638 contract ERC20PausableNonOwner is ERC20, Pausable, Ownable {
639 
640     modifier whenNotPausedNonOwner() {
641         if (isOwner() == false) {
642           require(!paused());
643         }
644         _;
645     }
646 
647     function transfer(address to, uint256 value) public whenNotPausedNonOwner returns (bool) {
648         return super.transfer(to, value);
649     }
650 
651     function transferFrom(address from, address to, uint256 value) public whenNotPausedNonOwner returns (bool) {
652         return super.transferFrom(from, to, value);
653     }
654 
655     function approve(address spender, uint256 value) public whenNotPausedNonOwner returns (bool) {
656         return super.approve(spender, value);
657     }
658 
659     function increaseAllowance(address spender, uint addedValue) public whenNotPausedNonOwner returns (bool success) {
660         return super.increaseAllowance(spender, addedValue);
661     }
662 
663     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPausedNonOwner returns (bool success) {
664         return super.decreaseAllowance(spender, subtractedValue);
665     }
666 }
667 
668 // File: contracts/BELLCOIN.sol
669 
670 pragma solidity 0.4.25;
671 
672 
673 
674 
675 
676 /**
677  * @title BELLCOIN
678  * @dev extends BurnableToken, ERC20PausableNonOwner, Ownable
679  */
680 contract BELLCOIN is ERC20, ERC20Detailed, ERC20Burnable, ERC20PausableNonOwner {
681 
682   uint8 public constant DECIMALS = 8;
683   // 10 billion
684   uint256 public constant INITIAL_SUPPLY = 10000000000 * (10 ** uint256(DECIMALS));
685 
686   /**
687    * @dev Constructor that gives msg.sender all of existing tokens.
688    */
689   constructor() public ERC20Detailed("BELLCOIN", "BLL", DECIMALS) {
690     _mint(msg.sender, INITIAL_SUPPLY);
691   }
692 
693   /**
694    * @dev remove an account's access to Pause
695    * @param account pauser
696    */
697   function removePauser(address account) public onlyOwner {
698     _removePauser(account);
699   }
700 }