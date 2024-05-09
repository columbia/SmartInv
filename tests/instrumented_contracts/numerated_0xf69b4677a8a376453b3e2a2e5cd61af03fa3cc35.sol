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
38 // File: node_modules\openzeppelin-solidity\contracts\math\SafeMath.sol
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
106 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\ERC20.sol
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
319 // File: node_modules\openzeppelin-solidity\contracts\access\Roles.sol
320 
321 pragma solidity ^0.4.24;
322 
323 /**
324  * @title Roles
325  * @dev Library for managing addresses assigned to a Role.
326  */
327 library Roles {
328   struct Role {
329     mapping (address => bool) bearer;
330   }
331 
332   /**
333    * @dev give an account access to this role
334    */
335   function add(Role storage role, address account) internal {
336     require(account != address(0));
337     require(!has(role, account));
338 
339     role.bearer[account] = true;
340   }
341 
342   /**
343    * @dev remove an account's access to this role
344    */
345   function remove(Role storage role, address account) internal {
346     require(account != address(0));
347     require(has(role, account));
348 
349     role.bearer[account] = false;
350   }
351 
352   /**
353    * @dev check if an account has this role
354    * @return bool
355    */
356   function has(Role storage role, address account)
357     internal
358     view
359     returns (bool)
360   {
361     require(account != address(0));
362     return role.bearer[account];
363   }
364 }
365 
366 // File: node_modules\openzeppelin-solidity\contracts\access\roles\MinterRole.sol
367 
368 pragma solidity ^0.4.24;
369 
370 
371 contract MinterRole {
372   using Roles for Roles.Role;
373 
374   event MinterAdded(address indexed account);
375   event MinterRemoved(address indexed account);
376 
377   Roles.Role private minters;
378 
379   constructor() internal {
380     _addMinter(msg.sender);
381   }
382 
383   modifier onlyMinter() {
384     require(isMinter(msg.sender));
385     _;
386   }
387 
388   function isMinter(address account) public view returns (bool) {
389     return minters.has(account);
390   }
391 
392   function addMinter(address account) public onlyMinter {
393     _addMinter(account);
394   }
395 
396   function renounceMinter() public {
397     _removeMinter(msg.sender);
398   }
399 
400   function _addMinter(address account) internal {
401     minters.add(account);
402     emit MinterAdded(account);
403   }
404 
405   function _removeMinter(address account) internal {
406     minters.remove(account);
407     emit MinterRemoved(account);
408   }
409 }
410 
411 // File: openzeppelin-solidity\contracts\token\ERC20\ERC20Mintable.sol
412 
413 pragma solidity ^0.4.24;
414 
415 
416 
417 /**
418  * @title ERC20Mintable
419  * @dev ERC20 minting logic
420  */
421 contract ERC20Mintable is ERC20, MinterRole {
422   /**
423    * @dev Function to mint tokens
424    * @param to The address that will receive the minted tokens.
425    * @param value The amount of tokens to mint.
426    * @return A boolean that indicates if the operation was successful.
427    */
428   function mint(
429     address to,
430     uint256 value
431   )
432     public
433     onlyMinter
434     returns (bool)
435   {
436     _mint(to, value);
437     return true;
438   }
439 }
440 
441 // File: openzeppelin-solidity\contracts\token\ERC20\ERC20Burnable.sol
442 
443 pragma solidity ^0.4.24;
444 
445 
446 /**
447  * @title Burnable Token
448  * @dev Token that can be irreversibly burned (destroyed).
449  */
450 contract ERC20Burnable is ERC20 {
451 
452   /**
453    * @dev Burns a specific amount of tokens.
454    * @param value The amount of token to be burned.
455    */
456   function burn(uint256 value) public {
457     _burn(msg.sender, value);
458   }
459 
460   /**
461    * @dev Burns a specific amount of tokens from the target address and decrements allowance
462    * @param from address The address which you want to send tokens from
463    * @param value uint256 The amount of token to be burned
464    */
465   function burnFrom(address from, uint256 value) public {
466     _burnFrom(from, value);
467   }
468 }
469 
470 // File: node_modules\openzeppelin-solidity\contracts\access\roles\PauserRole.sol
471 
472 pragma solidity ^0.4.24;
473 
474 
475 contract PauserRole {
476   using Roles for Roles.Role;
477 
478   event PauserAdded(address indexed account);
479   event PauserRemoved(address indexed account);
480 
481   Roles.Role private pausers;
482 
483   constructor() internal {
484     _addPauser(msg.sender);
485   }
486 
487   modifier onlyPauser() {
488     require(isPauser(msg.sender));
489     _;
490   }
491 
492   function isPauser(address account) public view returns (bool) {
493     return pausers.has(account);
494   }
495 
496   function addPauser(address account) public onlyPauser {
497     _addPauser(account);
498   }
499 
500   function renouncePauser() public {
501     _removePauser(msg.sender);
502   }
503 
504   function _addPauser(address account) internal {
505     pausers.add(account);
506     emit PauserAdded(account);
507   }
508 
509   function _removePauser(address account) internal {
510     pausers.remove(account);
511     emit PauserRemoved(account);
512   }
513 }
514 
515 // File: node_modules\openzeppelin-solidity\contracts\lifecycle\Pausable.sol
516 
517 pragma solidity ^0.4.24;
518 
519 
520 /**
521  * @title Pausable
522  * @dev Base contract which allows children to implement an emergency stop mechanism.
523  */
524 contract Pausable is PauserRole {
525   event Paused(address account);
526   event Unpaused(address account);
527 
528   bool private _paused;
529 
530   constructor() internal {
531     _paused = false;
532   }
533 
534   /**
535    * @return true if the contract is paused, false otherwise.
536    */
537   function paused() public view returns(bool) {
538     return _paused;
539   }
540 
541   /**
542    * @dev Modifier to make a function callable only when the contract is not paused.
543    */
544   modifier whenNotPaused() {
545     require(!_paused);
546     _;
547   }
548 
549   /**
550    * @dev Modifier to make a function callable only when the contract is paused.
551    */
552   modifier whenPaused() {
553     require(_paused);
554     _;
555   }
556 
557   /**
558    * @dev called by the owner to pause, triggers stopped state
559    */
560   function pause() public onlyPauser whenNotPaused {
561     _paused = true;
562     emit Paused(msg.sender);
563   }
564 
565   /**
566    * @dev called by the owner to unpause, returns to normal state
567    */
568   function unpause() public onlyPauser whenPaused {
569     _paused = false;
570     emit Unpaused(msg.sender);
571   }
572 }
573 
574 // File: openzeppelin-solidity\contracts\token\ERC20\ERC20Pausable.sol
575 
576 pragma solidity ^0.4.24;
577 
578 
579 
580 /**
581  * @title Pausable token
582  * @dev ERC20 modified with pausable transfers.
583  **/
584 contract ERC20Pausable is ERC20, Pausable {
585 
586   function transfer(
587     address to,
588     uint256 value
589   )
590     public
591     whenNotPaused
592     returns (bool)
593   {
594     return super.transfer(to, value);
595   }
596 
597   function transferFrom(
598     address from,
599     address to,
600     uint256 value
601   )
602     public
603     whenNotPaused
604     returns (bool)
605   {
606     return super.transferFrom(from, to, value);
607   }
608 
609   function approve(
610     address spender,
611     uint256 value
612   )
613     public
614     whenNotPaused
615     returns (bool)
616   {
617     return super.approve(spender, value);
618   }
619 
620   function increaseAllowance(
621     address spender,
622     uint addedValue
623   )
624     public
625     whenNotPaused
626     returns (bool success)
627   {
628     return super.increaseAllowance(spender, addedValue);
629   }
630 
631   function decreaseAllowance(
632     address spender,
633     uint subtractedValue
634   )
635     public
636     whenNotPaused
637     returns (bool success)
638   {
639     return super.decreaseAllowance(spender, subtractedValue);
640   }
641 }
642 
643 // File: openzeppelin-solidity\contracts\token\ERC20\ERC20Detailed.sol
644 
645 pragma solidity ^0.4.24;
646 
647 
648 /**
649  * @title ERC20Detailed token
650  * @dev The decimals are only for visualization purposes.
651  * All the operations are done using the smallest and indivisible token unit,
652  * just as on Ethereum all the operations are done in wei.
653  */
654 contract ERC20Detailed is IERC20 {
655   string private _name;
656   string private _symbol;
657   uint8 private _decimals;
658 
659   constructor(string name, string symbol, uint8 decimals) public {
660     _name = name;
661     _symbol = symbol;
662     _decimals = decimals;
663   }
664 
665   /**
666    * @return the name of the token.
667    */
668   function name() public view returns(string) {
669     return _name;
670   }
671 
672   /**
673    * @return the symbol of the token.
674    */
675   function symbol() public view returns(string) {
676     return _symbol;
677   }
678 
679   /**
680    * @return the number of decimals of the token.
681    */
682   function decimals() public view returns(uint8) {
683     return _decimals;
684   }
685 }
686 
687 // File: contracts\AsclepiusNetwork.sol
688 
689 pragma solidity >=0.4.21 <0.6.0;
690 
691 
692 
693 
694 
695 
696 contract AsclepiusNetwork is ERC20Mintable, ERC20Burnable, ERC20Pausable, ERC20Detailed {
697     string private _name = "AsclepiusNetwork";
698     string private _symbol = "ASCA";
699     uint8 private _decimals = 7;
700     uint256 private _amount = 551801801;
701 
702     uint256 value = _amount.mul(10 ** uint256(_decimals));
703 
704     constructor()
705         ERC20Detailed(_name, _symbol, _decimals)
706         ERC20Burnable()
707         ERC20Mintable()
708         ERC20Pausable()
709         public
710     {
711         _mint(msg.sender, value);
712     }
713 }