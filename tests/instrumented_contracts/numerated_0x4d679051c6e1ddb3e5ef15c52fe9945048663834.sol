1 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
2 
3 pragma solidity ^0.4.24;
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
81 pragma solidity ^0.4.24;
82 
83 /**
84  * @title ERC20 interface
85  * @dev see https://github.com/ethereum/EIPs/issues/20
86  */
87 interface IERC20 {
88   function totalSupply() external view returns (uint256);
89 
90   function balanceOf(address who) external view returns (uint256);
91 
92   function allowance(address owner, address spender)
93     external view returns (uint256);
94 
95   function transfer(address to, uint256 value) external returns (bool);
96 
97   function approve(address spender, uint256 value)
98     external returns (bool);
99 
100   function transferFrom(address from, address to, uint256 value)
101     external returns (bool);
102 
103   event Transfer(
104     address indexed from,
105     address indexed to,
106     uint256 value
107   );
108 
109   event Approval(
110     address indexed owner,
111     address indexed spender,
112     uint256 value
113   );
114 }
115 
116 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
117 
118 pragma solidity ^0.4.24;
119 
120 
121 /**
122  * @title ERC20Detailed token
123  * @dev The decimals are only for visualization purposes.
124  * All the operations are done using the smallest and indivisible token unit,
125  * just as on Ethereum all the operations are done in wei.
126  */
127 contract ERC20Detailed is IERC20 {
128   string private _name;
129   string private _symbol;
130   uint8 private _decimals;
131 
132   constructor(string name, string symbol, uint8 decimals) public {
133     _name = name;
134     _symbol = symbol;
135     _decimals = decimals;
136   }
137 
138   /**
139    * @return the name of the token.
140    */
141   function name() public view returns(string) {
142     return _name;
143   }
144 
145   /**
146    * @return the symbol of the token.
147    */
148   function symbol() public view returns(string) {
149     return _symbol;
150   }
151 
152   /**
153    * @return the number of decimals of the token.
154    */
155   function decimals() public view returns(uint8) {
156     return _decimals;
157   }
158 }
159 
160 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
161 
162 pragma solidity ^0.4.24;
163 
164 /**
165  * @title SafeMath
166  * @dev Math operations with safety checks that revert on error
167  */
168 library SafeMath {
169 
170   /**
171   * @dev Multiplies two numbers, reverts on overflow.
172   */
173   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
174     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
175     // benefit is lost if 'b' is also tested.
176     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
177     if (a == 0) {
178       return 0;
179     }
180 
181     uint256 c = a * b;
182     require(c / a == b);
183 
184     return c;
185   }
186 
187   /**
188   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
189   */
190   function div(uint256 a, uint256 b) internal pure returns (uint256) {
191     require(b > 0); // Solidity only automatically asserts when dividing by 0
192     uint256 c = a / b;
193     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
194 
195     return c;
196   }
197 
198   /**
199   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
200   */
201   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
202     require(b <= a);
203     uint256 c = a - b;
204 
205     return c;
206   }
207 
208   /**
209   * @dev Adds two numbers, reverts on overflow.
210   */
211   function add(uint256 a, uint256 b) internal pure returns (uint256) {
212     uint256 c = a + b;
213     require(c >= a);
214 
215     return c;
216   }
217 
218   /**
219   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
220   * reverts when dividing by zero.
221   */
222   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
223     require(b != 0);
224     return a % b;
225   }
226 }
227 
228 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
229 
230 pragma solidity ^0.4.24;
231 
232 
233 
234 /**
235  * @title Standard ERC20 token
236  *
237  * @dev Implementation of the basic standard token.
238  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
239  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
240  */
241 contract ERC20 is IERC20 {
242   using SafeMath for uint256;
243 
244   mapping (address => uint256) private _balances;
245 
246   mapping (address => mapping (address => uint256)) private _allowed;
247 
248   uint256 private _totalSupply;
249 
250   /**
251   * @dev Total number of tokens in existence
252   */
253   function totalSupply() public view returns (uint256) {
254     return _totalSupply;
255   }
256 
257   /**
258   * @dev Gets the balance of the specified address.
259   * @param owner The address to query the balance of.
260   * @return An uint256 representing the amount owned by the passed address.
261   */
262   function balanceOf(address owner) public view returns (uint256) {
263     return _balances[owner];
264   }
265 
266   /**
267    * @dev Function to check the amount of tokens that an owner allowed to a spender.
268    * @param owner address The address which owns the funds.
269    * @param spender address The address which will spend the funds.
270    * @return A uint256 specifying the amount of tokens still available for the spender.
271    */
272   function allowance(
273     address owner,
274     address spender
275    )
276     public
277     view
278     returns (uint256)
279   {
280     return _allowed[owner][spender];
281   }
282 
283   /**
284   * @dev Transfer token for a specified address
285   * @param to The address to transfer to.
286   * @param value The amount to be transferred.
287   */
288   function transfer(address to, uint256 value) public returns (bool) {
289     _transfer(msg.sender, to, value);
290     return true;
291   }
292 
293   /**
294    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
295    * Beware that changing an allowance with this method brings the risk that someone may use both the old
296    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
297    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
298    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
299    * @param spender The address which will spend the funds.
300    * @param value The amount of tokens to be spent.
301    */
302   function approve(address spender, uint256 value) public returns (bool) {
303     require(spender != address(0));
304 
305     _allowed[msg.sender][spender] = value;
306     emit Approval(msg.sender, spender, value);
307     return true;
308   }
309 
310   /**
311    * @dev Transfer tokens from one address to another
312    * @param from address The address which you want to send tokens from
313    * @param to address The address which you want to transfer to
314    * @param value uint256 the amount of tokens to be transferred
315    */
316   function transferFrom(
317     address from,
318     address to,
319     uint256 value
320   )
321     public
322     returns (bool)
323   {
324     require(value <= _allowed[from][msg.sender]);
325 
326     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
327     _transfer(from, to, value);
328     return true;
329   }
330 
331   /**
332    * @dev Increase the amount of tokens that an owner allowed to a spender.
333    * approve should be called when allowed_[_spender] == 0. To increment
334    * allowed value is better to use this function to avoid 2 calls (and wait until
335    * the first transaction is mined)
336    * From MonolithDAO Token.sol
337    * @param spender The address which will spend the funds.
338    * @param addedValue The amount of tokens to increase the allowance by.
339    */
340   function increaseAllowance(
341     address spender,
342     uint256 addedValue
343   )
344     public
345     returns (bool)
346   {
347     require(spender != address(0));
348 
349     _allowed[msg.sender][spender] = (
350       _allowed[msg.sender][spender].add(addedValue));
351     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
352     return true;
353   }
354 
355   /**
356    * @dev Decrease the amount of tokens that an owner allowed to a spender.
357    * approve should be called when allowed_[_spender] == 0. To decrement
358    * allowed value is better to use this function to avoid 2 calls (and wait until
359    * the first transaction is mined)
360    * From MonolithDAO Token.sol
361    * @param spender The address which will spend the funds.
362    * @param subtractedValue The amount of tokens to decrease the allowance by.
363    */
364   function decreaseAllowance(
365     address spender,
366     uint256 subtractedValue
367   )
368     public
369     returns (bool)
370   {
371     require(spender != address(0));
372 
373     _allowed[msg.sender][spender] = (
374       _allowed[msg.sender][spender].sub(subtractedValue));
375     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
376     return true;
377   }
378 
379   /**
380   * @dev Transfer token for a specified addresses
381   * @param from The address to transfer from.
382   * @param to The address to transfer to.
383   * @param value The amount to be transferred.
384   */
385   function _transfer(address from, address to, uint256 value) internal {
386     require(value <= _balances[from]);
387     require(to != address(0));
388 
389     _balances[from] = _balances[from].sub(value);
390     _balances[to] = _balances[to].add(value);
391     emit Transfer(from, to, value);
392   }
393 
394   /**
395    * @dev Internal function that mints an amount of the token and assigns it to
396    * an account. This encapsulates the modification of balances such that the
397    * proper events are emitted.
398    * @param account The account that will receive the created tokens.
399    * @param value The amount that will be created.
400    */
401   function _mint(address account, uint256 value) internal {
402     require(account != 0);
403     _totalSupply = _totalSupply.add(value);
404     _balances[account] = _balances[account].add(value);
405     emit Transfer(address(0), account, value);
406   }
407 
408   /**
409    * @dev Internal function that burns an amount of the token of a given
410    * account.
411    * @param account The account whose tokens will be burnt.
412    * @param value The amount that will be burnt.
413    */
414   function _burn(address account, uint256 value) internal {
415     require(account != 0);
416     require(value <= _balances[account]);
417 
418     _totalSupply = _totalSupply.sub(value);
419     _balances[account] = _balances[account].sub(value);
420     emit Transfer(account, address(0), value);
421   }
422 
423   /**
424    * @dev Internal function that burns an amount of the token of a given
425    * account, deducting from the sender's allowance for said account. Uses the
426    * internal burn function.
427    * @param account The account whose tokens will be burnt.
428    * @param value The amount that will be burnt.
429    */
430   function _burnFrom(address account, uint256 value) internal {
431     require(value <= _allowed[account][msg.sender]);
432 
433     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
434     // this function needs to emit an event with the updated approval.
435     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
436       value);
437     _burn(account, value);
438   }
439 }
440 
441 // File: openzeppelin-solidity/contracts/access/Roles.sol
442 
443 pragma solidity ^0.4.24;
444 
445 /**
446  * @title Roles
447  * @dev Library for managing addresses assigned to a Role.
448  */
449 library Roles {
450   struct Role {
451     mapping (address => bool) bearer;
452   }
453 
454   /**
455    * @dev give an account access to this role
456    */
457   function add(Role storage role, address account) internal {
458     require(account != address(0));
459     require(!has(role, account));
460 
461     role.bearer[account] = true;
462   }
463 
464   /**
465    * @dev remove an account's access to this role
466    */
467   function remove(Role storage role, address account) internal {
468     require(account != address(0));
469     require(has(role, account));
470 
471     role.bearer[account] = false;
472   }
473 
474   /**
475    * @dev check if an account has this role
476    * @return bool
477    */
478   function has(Role storage role, address account)
479     internal
480     view
481     returns (bool)
482   {
483     require(account != address(0));
484     return role.bearer[account];
485   }
486 }
487 
488 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
489 
490 pragma solidity ^0.4.24;
491 
492 
493 contract PauserRole {
494   using Roles for Roles.Role;
495 
496   event PauserAdded(address indexed account);
497   event PauserRemoved(address indexed account);
498 
499   Roles.Role private pausers;
500 
501   constructor() internal {
502     _addPauser(msg.sender);
503   }
504 
505   modifier onlyPauser() {
506     require(isPauser(msg.sender));
507     _;
508   }
509 
510   function isPauser(address account) public view returns (bool) {
511     return pausers.has(account);
512   }
513 
514   function addPauser(address account) public onlyPauser {
515     _addPauser(account);
516   }
517 
518   function renouncePauser() public {
519     _removePauser(msg.sender);
520   }
521 
522   function _addPauser(address account) internal {
523     pausers.add(account);
524     emit PauserAdded(account);
525   }
526 
527   function _removePauser(address account) internal {
528     pausers.remove(account);
529     emit PauserRemoved(account);
530   }
531 }
532 
533 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
534 
535 pragma solidity ^0.4.24;
536 
537 
538 /**
539  * @title Pausable
540  * @dev Base contract which allows children to implement an emergency stop mechanism.
541  */
542 contract Pausable is PauserRole {
543   event Paused(address account);
544   event Unpaused(address account);
545 
546   bool private _paused;
547 
548   constructor() internal {
549     _paused = false;
550   }
551 
552   /**
553    * @return true if the contract is paused, false otherwise.
554    */
555   function paused() public view returns(bool) {
556     return _paused;
557   }
558 
559   /**
560    * @dev Modifier to make a function callable only when the contract is not paused.
561    */
562   modifier whenNotPaused() {
563     require(!_paused);
564     _;
565   }
566 
567   /**
568    * @dev Modifier to make a function callable only when the contract is paused.
569    */
570   modifier whenPaused() {
571     require(_paused);
572     _;
573   }
574 
575   /**
576    * @dev called by the owner to pause, triggers stopped state
577    */
578   function pause() public onlyPauser whenNotPaused {
579     _paused = true;
580     emit Paused(msg.sender);
581   }
582 
583   /**
584    * @dev called by the owner to unpause, returns to normal state
585    */
586   function unpause() public onlyPauser whenPaused {
587     _paused = false;
588     emit Unpaused(msg.sender);
589   }
590 }
591 
592 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Pausable.sol
593 
594 pragma solidity ^0.4.24;
595 
596 
597 
598 /**
599  * @title Pausable token
600  * @dev ERC20 modified with pausable transfers.
601  **/
602 contract ERC20Pausable is ERC20, Pausable {
603 
604   function transfer(
605     address to,
606     uint256 value
607   )
608     public
609     whenNotPaused
610     returns (bool)
611   {
612     return super.transfer(to, value);
613   }
614 
615   function transferFrom(
616     address from,
617     address to,
618     uint256 value
619   )
620     public
621     whenNotPaused
622     returns (bool)
623   {
624     return super.transferFrom(from, to, value);
625   }
626 
627   function approve(
628     address spender,
629     uint256 value
630   )
631     public
632     whenNotPaused
633     returns (bool)
634   {
635     return super.approve(spender, value);
636   }
637 
638   function increaseAllowance(
639     address spender,
640     uint addedValue
641   )
642     public
643     whenNotPaused
644     returns (bool success)
645   {
646     return super.increaseAllowance(spender, addedValue);
647   }
648 
649   function decreaseAllowance(
650     address spender,
651     uint subtractedValue
652   )
653     public
654     whenNotPaused
655     returns (bool success)
656   {
657     return super.decreaseAllowance(spender, subtractedValue);
658   }
659 }
660 
661 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
662 
663 pragma solidity ^0.4.24;
664 
665 
666 contract MinterRole {
667   using Roles for Roles.Role;
668 
669   event MinterAdded(address indexed account);
670   event MinterRemoved(address indexed account);
671 
672   Roles.Role private minters;
673 
674   constructor() internal {
675     _addMinter(msg.sender);
676   }
677 
678   modifier onlyMinter() {
679     require(isMinter(msg.sender));
680     _;
681   }
682 
683   function isMinter(address account) public view returns (bool) {
684     return minters.has(account);
685   }
686 
687   function addMinter(address account) public onlyMinter {
688     _addMinter(account);
689   }
690 
691   function renounceMinter() public {
692     _removeMinter(msg.sender);
693   }
694 
695   function _addMinter(address account) internal {
696     minters.add(account);
697     emit MinterAdded(account);
698   }
699 
700   function _removeMinter(address account) internal {
701     minters.remove(account);
702     emit MinterRemoved(account);
703   }
704 }
705 
706 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
707 
708 pragma solidity ^0.4.24;
709 
710 
711 
712 /**
713  * @title ERC20Mintable
714  * @dev ERC20 minting logic
715  */
716 contract ERC20Mintable is ERC20, MinterRole {
717   /**
718    * @dev Function to mint tokens
719    * @param to The address that will receive the minted tokens.
720    * @param value The amount of tokens to mint.
721    * @return A boolean that indicates if the operation was successful.
722    */
723   function mint(
724     address to,
725     uint256 value
726   )
727     public
728     onlyMinter
729     returns (bool)
730   {
731     _mint(to, value);
732     return true;
733   }
734 }
735 
736 // File: contracts/InterpinesToken.sol
737 
738 pragma solidity ^0.4.25;
739 
740 
741 
742 
743 
744 contract InterpinesToken is ERC20Detailed, ERC20Mintable, ERC20Pausable, Ownable {
745     using SafeMath for uint256;
746 
747     constructor(
748         string _name,
749         string _symbol,
750         uint8 _decimals,
751         uint256 _amount
752     )
753     ERC20Detailed(_name, _symbol, _decimals)
754     public {
755         require(_amount > 0, "amount have to be greater than 0");
756         uint256 initialBalance = _amount.mul(10 ** uint256(_decimals));
757         _mint(msg.sender, initialBalance);
758     }
759 
760     function burn(uint256 value) public onlyOwner {
761         _burn(msg.sender, value);
762     }
763 }