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
38 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
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
82 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
83 
84 pragma solidity ^0.4.24;
85 
86 /**
87  * @title SafeMath
88  * @dev Math operations with safety checks that revert on error
89  */
90 library SafeMath {
91 
92   /**
93   * @dev Multiplies two numbers, reverts on overflow.
94   */
95   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
96     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
97     // benefit is lost if 'b' is also tested.
98     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
99     if (a == 0) {
100       return 0;
101     }
102 
103     uint256 c = a * b;
104     require(c / a == b);
105 
106     return c;
107   }
108 
109   /**
110   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
111   */
112   function div(uint256 a, uint256 b) internal pure returns (uint256) {
113     require(b > 0); // Solidity only automatically asserts when dividing by 0
114     uint256 c = a / b;
115     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
116 
117     return c;
118   }
119 
120   /**
121   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
122   */
123   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
124     require(b <= a);
125     uint256 c = a - b;
126 
127     return c;
128   }
129 
130   /**
131   * @dev Adds two numbers, reverts on overflow.
132   */
133   function add(uint256 a, uint256 b) internal pure returns (uint256) {
134     uint256 c = a + b;
135     require(c >= a);
136 
137     return c;
138   }
139 
140   /**
141   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
142   * reverts when dividing by zero.
143   */
144   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
145     require(b != 0);
146     return a % b;
147   }
148 }
149 
150 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
151 
152 pragma solidity ^0.4.24;
153 
154 
155 
156 /**
157  * @title Standard ERC20 token
158  *
159  * @dev Implementation of the basic standard token.
160  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
161  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
162  */
163 contract ERC20 is IERC20 {
164   using SafeMath for uint256;
165 
166   mapping (address => uint256) private _balances;
167 
168   mapping (address => mapping (address => uint256)) private _allowed;
169 
170   uint256 private _totalSupply;
171 
172   /**
173   * @dev Total number of tokens in existence
174   */
175   function totalSupply() public view returns (uint256) {
176     return _totalSupply;
177   }
178 
179   /**
180   * @dev Gets the balance of the specified address.
181   * @param owner The address to query the balance of.
182   * @return An uint256 representing the amount owned by the passed address.
183   */
184   function balanceOf(address owner) public view returns (uint256) {
185     return _balances[owner];
186   }
187 
188   /**
189    * @dev Function to check the amount of tokens that an owner allowed to a spender.
190    * @param owner address The address which owns the funds.
191    * @param spender address The address which will spend the funds.
192    * @return A uint256 specifying the amount of tokens still available for the spender.
193    */
194   function allowance(
195     address owner,
196     address spender
197    )
198     public
199     view
200     returns (uint256)
201   {
202     return _allowed[owner][spender];
203   }
204 
205   /**
206   * @dev Transfer token for a specified address
207   * @param to The address to transfer to.
208   * @param value The amount to be transferred.
209   */
210   function transfer(address to, uint256 value) public returns (bool) {
211     _transfer(msg.sender, to, value);
212     return true;
213   }
214 
215   /**
216    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
217    * Beware that changing an allowance with this method brings the risk that someone may use both the old
218    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
219    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
220    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
221    * @param spender The address which will spend the funds.
222    * @param value The amount of tokens to be spent.
223    */
224   function approve(address spender, uint256 value) public returns (bool) {
225     require(spender != address(0));
226 
227     _allowed[msg.sender][spender] = value;
228     emit Approval(msg.sender, spender, value);
229     return true;
230   }
231 
232   /**
233    * @dev Transfer tokens from one address to another
234    * @param from address The address which you want to send tokens from
235    * @param to address The address which you want to transfer to
236    * @param value uint256 the amount of tokens to be transferred
237    */
238   function transferFrom(
239     address from,
240     address to,
241     uint256 value
242   )
243     public
244     returns (bool)
245   {
246     require(value <= _allowed[from][msg.sender]);
247 
248     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
249     _transfer(from, to, value);
250     return true;
251   }
252 
253   /**
254    * @dev Increase the amount of tokens that an owner allowed to a spender.
255    * approve should be called when allowed_[_spender] == 0. To increment
256    * allowed value is better to use this function to avoid 2 calls (and wait until
257    * the first transaction is mined)
258    * From MonolithDAO Token.sol
259    * @param spender The address which will spend the funds.
260    * @param addedValue The amount of tokens to increase the allowance by.
261    */
262   function increaseAllowance(
263     address spender,
264     uint256 addedValue
265   )
266     public
267     returns (bool)
268   {
269     require(spender != address(0));
270 
271     _allowed[msg.sender][spender] = (
272       _allowed[msg.sender][spender].add(addedValue));
273     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
274     return true;
275   }
276 
277   /**
278    * @dev Decrease the amount of tokens that an owner allowed to a spender.
279    * approve should be called when allowed_[_spender] == 0. To decrement
280    * allowed value is better to use this function to avoid 2 calls (and wait until
281    * the first transaction is mined)
282    * From MonolithDAO Token.sol
283    * @param spender The address which will spend the funds.
284    * @param subtractedValue The amount of tokens to decrease the allowance by.
285    */
286   function decreaseAllowance(
287     address spender,
288     uint256 subtractedValue
289   )
290     public
291     returns (bool)
292   {
293     require(spender != address(0));
294 
295     _allowed[msg.sender][spender] = (
296       _allowed[msg.sender][spender].sub(subtractedValue));
297     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
298     return true;
299   }
300 
301   /**
302   * @dev Transfer token for a specified addresses
303   * @param from The address to transfer from.
304   * @param to The address to transfer to.
305   * @param value The amount to be transferred.
306   */
307   function _transfer(address from, address to, uint256 value) internal {
308     require(value <= _balances[from]);
309     require(to != address(0));
310 
311     _balances[from] = _balances[from].sub(value);
312     _balances[to] = _balances[to].add(value);
313     emit Transfer(from, to, value);
314   }
315 
316   /**
317    * @dev Internal function that mints an amount of the token and assigns it to
318    * an account. This encapsulates the modification of balances such that the
319    * proper events are emitted.
320    * @param account The account that will receive the created tokens.
321    * @param value The amount that will be created.
322    */
323   function _mint(address account, uint256 value) internal {
324     require(account != 0);
325     _totalSupply = _totalSupply.add(value);
326     _balances[account] = _balances[account].add(value);
327     emit Transfer(address(0), account, value);
328   }
329 
330   /**
331    * @dev Internal function that burns an amount of the token of a given
332    * account.
333    * @param account The account whose tokens will be burnt.
334    * @param value The amount that will be burnt.
335    */
336   function _burn(address account, uint256 value) internal {
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
353     require(value <= _allowed[account][msg.sender]);
354 
355     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
356     // this function needs to emit an event with the updated approval.
357     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
358       value);
359     _burn(account, value);
360   }
361 }
362 
363 // File: openzeppelin-solidity/contracts/access/Roles.sol
364 
365 pragma solidity ^0.4.24;
366 
367 /**
368  * @title Roles
369  * @dev Library for managing addresses assigned to a Role.
370  */
371 library Roles {
372   struct Role {
373     mapping (address => bool) bearer;
374   }
375 
376   /**
377    * @dev give an account access to this role
378    */
379   function add(Role storage role, address account) internal {
380     require(account != address(0));
381     require(!has(role, account));
382 
383     role.bearer[account] = true;
384   }
385 
386   /**
387    * @dev remove an account's access to this role
388    */
389   function remove(Role storage role, address account) internal {
390     require(account != address(0));
391     require(has(role, account));
392 
393     role.bearer[account] = false;
394   }
395 
396   /**
397    * @dev check if an account has this role
398    * @return bool
399    */
400   function has(Role storage role, address account)
401     internal
402     view
403     returns (bool)
404   {
405     require(account != address(0));
406     return role.bearer[account];
407   }
408 }
409 
410 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
411 
412 pragma solidity ^0.4.24;
413 
414 
415 contract MinterRole {
416   using Roles for Roles.Role;
417 
418   event MinterAdded(address indexed account);
419   event MinterRemoved(address indexed account);
420 
421   Roles.Role private minters;
422 
423   constructor() internal {
424     _addMinter(msg.sender);
425   }
426 
427   modifier onlyMinter() {
428     require(isMinter(msg.sender));
429     _;
430   }
431 
432   function isMinter(address account) public view returns (bool) {
433     return minters.has(account);
434   }
435 
436   function addMinter(address account) public onlyMinter {
437     _addMinter(account);
438   }
439 
440   function renounceMinter() public {
441     _removeMinter(msg.sender);
442   }
443 
444   function _addMinter(address account) internal {
445     minters.add(account);
446     emit MinterAdded(account);
447   }
448 
449   function _removeMinter(address account) internal {
450     minters.remove(account);
451     emit MinterRemoved(account);
452   }
453 }
454 
455 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
456 
457 pragma solidity ^0.4.24;
458 
459 
460 
461 /**
462  * @title ERC20Mintable
463  * @dev ERC20 minting logic
464  */
465 contract ERC20Mintable is ERC20, MinterRole {
466   /**
467    * @dev Function to mint tokens
468    * @param to The address that will receive the minted tokens.
469    * @param value The amount of tokens to mint.
470    * @return A boolean that indicates if the operation was successful.
471    */
472   function mint(
473     address to,
474     uint256 value
475   )
476     public
477     onlyMinter
478     returns (bool)
479   {
480     _mint(to, value);
481     return true;
482   }
483 }
484 
485 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
486 
487 pragma solidity ^0.4.24;
488 
489 
490 contract PauserRole {
491   using Roles for Roles.Role;
492 
493   event PauserAdded(address indexed account);
494   event PauserRemoved(address indexed account);
495 
496   Roles.Role private pausers;
497 
498   constructor() internal {
499     _addPauser(msg.sender);
500   }
501 
502   modifier onlyPauser() {
503     require(isPauser(msg.sender));
504     _;
505   }
506 
507   function isPauser(address account) public view returns (bool) {
508     return pausers.has(account);
509   }
510 
511   function addPauser(address account) public onlyPauser {
512     _addPauser(account);
513   }
514 
515   function renouncePauser() public {
516     _removePauser(msg.sender);
517   }
518 
519   function _addPauser(address account) internal {
520     pausers.add(account);
521     emit PauserAdded(account);
522   }
523 
524   function _removePauser(address account) internal {
525     pausers.remove(account);
526     emit PauserRemoved(account);
527   }
528 }
529 
530 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
531 
532 pragma solidity ^0.4.24;
533 
534 
535 /**
536  * @title Pausable
537  * @dev Base contract which allows children to implement an emergency stop mechanism.
538  */
539 contract Pausable is PauserRole {
540   event Paused(address account);
541   event Unpaused(address account);
542 
543   bool private _paused;
544 
545   constructor() internal {
546     _paused = false;
547   }
548 
549   /**
550    * @return true if the contract is paused, false otherwise.
551    */
552   function paused() public view returns(bool) {
553     return _paused;
554   }
555 
556   /**
557    * @dev Modifier to make a function callable only when the contract is not paused.
558    */
559   modifier whenNotPaused() {
560     require(!_paused);
561     _;
562   }
563 
564   /**
565    * @dev Modifier to make a function callable only when the contract is paused.
566    */
567   modifier whenPaused() {
568     require(_paused);
569     _;
570   }
571 
572   /**
573    * @dev called by the owner to pause, triggers stopped state
574    */
575   function pause() public onlyPauser whenNotPaused {
576     _paused = true;
577     emit Paused(msg.sender);
578   }
579 
580   /**
581    * @dev called by the owner to unpause, returns to normal state
582    */
583   function unpause() public onlyPauser whenPaused {
584     _paused = false;
585     emit Unpaused(msg.sender);
586   }
587 }
588 
589 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Pausable.sol
590 
591 pragma solidity ^0.4.24;
592 
593 
594 
595 /**
596  * @title Pausable token
597  * @dev ERC20 modified with pausable transfers.
598  **/
599 contract ERC20Pausable is ERC20, Pausable {
600 
601   function transfer(
602     address to,
603     uint256 value
604   )
605     public
606     whenNotPaused
607     returns (bool)
608   {
609     return super.transfer(to, value);
610   }
611 
612   function transferFrom(
613     address from,
614     address to,
615     uint256 value
616   )
617     public
618     whenNotPaused
619     returns (bool)
620   {
621     return super.transferFrom(from, to, value);
622   }
623 
624   function approve(
625     address spender,
626     uint256 value
627   )
628     public
629     whenNotPaused
630     returns (bool)
631   {
632     return super.approve(spender, value);
633   }
634 
635   function increaseAllowance(
636     address spender,
637     uint addedValue
638   )
639     public
640     whenNotPaused
641     returns (bool success)
642   {
643     return super.increaseAllowance(spender, addedValue);
644   }
645 
646   function decreaseAllowance(
647     address spender,
648     uint subtractedValue
649   )
650     public
651     whenNotPaused
652     returns (bool success)
653   {
654     return super.decreaseAllowance(spender, subtractedValue);
655   }
656 }
657 
658 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol
659 
660 pragma solidity ^0.4.24;
661 
662 
663 /**
664  * @title Burnable Token
665  * @dev Token that can be irreversibly burned (destroyed).
666  */
667 contract ERC20Burnable is ERC20 {
668 
669   /**
670    * @dev Burns a specific amount of tokens.
671    * @param value The amount of token to be burned.
672    */
673   function burn(uint256 value) public {
674     _burn(msg.sender, value);
675   }
676 
677   /**
678    * @dev Burns a specific amount of tokens from the target address and decrements allowance
679    * @param from address The address which you want to send tokens from
680    * @param value uint256 The amount of token to be burned
681    */
682   function burnFrom(address from, uint256 value) public {
683     _burnFrom(from, value);
684   }
685 }
686 
687 // File: contracts/token/SpinToken.sol
688 
689 pragma solidity ^0.4.24;
690 
691 
692 
693 
694 
695 
696 contract SpinToken is ERC20Detailed, ERC20Mintable, ERC20Pausable, ERC20Burnable {
697   /**
698    * @dev constructor to mint initial tokens
699    * @param name string
700    * @param symbol string
701    * @param decimals uint8
702    * @param initialSupply uint256
703    */
704   constructor(
705     string name,
706     string symbol,
707     uint8 decimals,
708     uint256 initialSupply
709   )
710     ERC20Detailed(name, symbol, decimals)
711     public
712   {
713     // Mint the initial supply
714     require(initialSupply > 0, "initialSupply must be greater than zero.");
715     mint(msg.sender, initialSupply * (10 ** uint256(decimals)));
716   }
717 }