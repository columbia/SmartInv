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
40 
41 /**
42  * @title ERC20Detailed token
43  * @dev The decimals are only for visualization purposes.
44  * All the operations are done using the smallest and indivisible token unit,
45  * just as on Ethereum all the operations are done in wei.
46  */
47 contract ERC20Detailed is IERC20 {
48   string private _name;
49   string private _symbol;
50   uint8 private _decimals;
51 
52   constructor(string name, string symbol, uint8 decimals) public {
53     _name = name;
54     _symbol = symbol;
55     _decimals = decimals;
56   }
57 
58   /**
59    * @return the name of the token.
60    */
61   function name() public view returns(string) {
62     return _name;
63   }
64 
65   /**
66    * @return the symbol of the token.
67    */
68   function symbol() public view returns(string) {
69     return _symbol;
70   }
71 
72   /**
73    * @return the number of decimals of the token.
74    */
75   function decimals() public view returns(uint8) {
76     return _decimals;
77   }
78 }
79 
80 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
81 
82 /**
83  * @title SafeMath
84  * @dev Math operations with safety checks that revert on error
85  */
86 
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
147 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
148 
149 
150 
151 /**
152  * @title Standard ERC20 token
153  *
154  * @dev Implementation of the basic standard token.
155  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
156  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
157  */
158 contract ERC20 is IERC20 {
159   using SafeMath for uint256;
160 
161   mapping (address => uint256) private _balances;
162 
163   mapping (address => mapping (address => uint256)) private _allowed;
164 
165   uint256 private _totalSupply;
166 
167   /**
168   * @dev Total number of tokens in existence
169   */
170   function totalSupply() public view returns (uint256) {
171     return _totalSupply;
172   }
173 
174   /**
175   * @dev Gets the balance of the specified address.
176   * @param owner The address to query the balance of.
177   * @return An uint256 representing the amount owned by the passed address.
178   */
179   function balanceOf(address owner) public view returns (uint256) {
180     return _balances[owner];
181   }
182 
183   /**
184    * @dev Function to check the amount of tokens that an owner allowed to a spender.
185    * @param owner address The address which owns the funds.
186    * @param spender address The address which will spend the funds.
187    * @return A uint256 specifying the amount of tokens still available for the spender.
188    */
189   function allowance(
190     address owner,
191     address spender
192    )
193     public
194     view
195     returns (uint256)
196   {
197     return _allowed[owner][spender];
198   }
199 
200   /**
201   * @dev Transfer token for a specified address
202   * @param to The address to transfer to.
203   * @param value The amount to be transferred.
204   */
205   function transfer(address to, uint256 value) public returns (bool) {
206     _transfer(msg.sender, to, value);
207     return true;
208   }
209 
210   /**
211    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
212    * Beware that changing an allowance with this method brings the risk that someone may use both the old
213    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
214    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
215    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
216    * @param spender The address which will spend the funds.
217    * @param value The amount of tokens to be spent.
218    */
219   function approve(address spender, uint256 value) public returns (bool) {
220     require(spender != address(0)); 
221 
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
241     require(value <= _allowed[from][msg.sender]);
242 
243     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
244     _transfer(from, to, value);
245     return true;
246   }
247 
248   /**
249    * @dev Increase the amount of tokens that an owner allowed to a spender.
250    * approve should be called when allowed_[_spender] == 0. To increment
251    * allowed value is better to use this function to avoid 2 calls (and wait until
252    * the first transaction is mined)
253    * From MonolithDAO Token.sol
254    * @param spender The address which will spend the funds.
255    * @param addedValue The amount of tokens to increase the allowance by.
256    */
257   function increaseAllowance(
258     address spender,
259     uint256 addedValue
260   )
261     public
262     returns (bool)
263   {
264     require(spender != address(0));
265 
266     _allowed[msg.sender][spender] = (
267       _allowed[msg.sender][spender].add(addedValue));
268     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
269     return true;
270   }
271 
272   /**
273    * @dev Decrease the amount of tokens that an owner allowed to a spender.
274    * approve should be called when allowed_[_spender] == 0. To decrement
275    * allowed value is better to use this function to avoid 2 calls (and wait until
276    * the first transaction is mined)
277    * From MonolithDAO Token.sol
278    * @param spender The address which will spend the funds.
279    * @param subtractedValue The amount of tokens to decrease the allowance by.
280    */
281   function decreaseAllowance(
282     address spender,
283     uint256 subtractedValue
284   )
285     public
286     returns (bool)
287   {
288     require(spender != address(0));
289 
290     _allowed[msg.sender][spender] = (
291       _allowed[msg.sender][spender].sub(subtractedValue));
292     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
293     return true;
294   }
295 
296   /**
297   * @dev Transfer token for a specified addresses
298   * @param from The address to transfer from.
299   * @param to The address to transfer to.
300   * @param value The amount to be transferred.
301   */
302   function _transfer(address from, address to, uint256 value) internal {
303     require(value <= _balances[from]);
304     require(to != address(0)); 
305 
306     _balances[from] = _balances[from].sub(value);
307     _balances[to] = _balances[to].add(value);
308     emit Transfer(from, to, value);
309   }
310 
311   /**
312    * @dev Internal function that mints an amount of the token and assigns it to
313    * an account. This encapsulates the modification of balances such that the
314    * proper events are emitted.
315    * @param account The account that will receive the created tokens.
316    * @param value The amount that will be created.
317    */
318   function _mint(address account, uint256 value) internal {
319     require(account != 0); 
320     _totalSupply = _totalSupply.add(value);
321     _balances[account] = _balances[account].add(value);
322     emit Transfer(address(0), account, value);
323   }
324 
325   /**
326    * @dev Internal function that burns an amount of the token of a given
327    * account.
328    * @param account The account whose tokens will be burnt.
329    * @param value The amount that will be burnt.
330    */
331   function _burn(address account, uint256 value) internal {
332     require(account != 0);
333     require(value <= _balances[account]);
334 
335     _totalSupply = _totalSupply.sub(value);
336     _balances[account] = _balances[account].sub(value);
337     emit Transfer(account, address(0), value);
338   }
339 
340   /**
341    * @dev Internal function that burns an amount of the token of a given
342    * account, deducting from the sender's allowance for said account. Uses the
343    * internal burn function.
344    * @param account The account whose tokens will be burnt.
345    * @param value The amount that will be burnt.
346    */
347   function _burnFrom(address account, uint256 value) internal {
348     require(value <= _allowed[account][msg.sender]);
349 
350     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
351     // this function needs to emit an event with the updated approval.
352     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
353       value);
354     _burn(account, value);
355   }
356 }
357 
358 // File: openzeppelin-solidity/contracts/access/Roles.sol
359 
360 /**
361  * @title Roles
362  * @dev Library for managing addresses assigned to a Role.
363  */
364 library Roles {
365   struct Role {
366     mapping (address => bool) bearer;
367   }
368 
369   /**
370    * @dev give an account access to this role
371    */
372   function add(Role storage role, address account) internal {
373     require(account != address(0));
374     require(!has(role, account));
375 
376     role.bearer[account] = true;
377   }
378 
379   /**
380    * @dev remove an account's access to this role
381    */
382   function remove(Role storage role, address account) internal {
383     require(account != address(0));
384     require(has(role, account));
385 
386     role.bearer[account] = false;
387   }
388 
389   /**
390    * @dev check if an account has this role
391    * @return bool
392    */
393   function has(Role storage role, address account)
394     internal
395     view
396     returns (bool)
397   {
398     require(account != address(0));
399     return role.bearer[account];
400   }
401 }
402 
403 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
404 
405 
406 contract PauserRole {
407   using Roles for Roles.Role;
408 
409   event PauserAdded(address indexed account);
410   event PauserRemoved(address indexed account);
411 
412   Roles.Role private pausers;
413 
414   constructor() internal {
415     _addPauser(msg.sender);
416   }
417 
418   modifier onlyPauser() {
419     require(isPauser(msg.sender));
420     _;
421   }
422 
423   function isPauser(address account) public view returns (bool) {
424     return pausers.has(account);
425   }
426 
427   function addPauser(address account) public onlyPauser {
428     _addPauser(account);
429   }
430   
431   function renouncePauser() public {
432     _removePauser(msg.sender);
433   }
434 
435   function _addPauser(address account) internal {
436     pausers.add(account);
437     emit PauserAdded(account);
438   }
439 
440   function _removePauser(address account) internal {
441     pausers.remove(account);
442     emit PauserRemoved(account);
443   }
444 }
445 
446 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
447 
448 
449 /**
450  * @title Pausable
451  * @dev Base contract which allows children to implement an emergency stop mechanism.
452  */
453 contract Pausable is PauserRole {
454   event Paused(address account);
455   event Unpaused(address account);
456 
457   bool private _paused;
458 
459   constructor() internal {
460     _paused = false;
461   }
462 
463   /**
464    * @return true if the contract is paused, false otherwise.
465    */
466   function paused() public view returns(bool) {
467     return _paused;
468   }
469 
470   /**
471    * @dev Modifier to make a function callable only when the contract is not paused.
472    */
473   modifier whenNotPaused() {
474     require(!_paused);
475     _;
476   }
477 
478   /**
479    * @dev Modifier to make a function callable only when the contract is paused.
480    */
481   modifier whenPaused() {
482     require(_paused);
483     _;
484   }
485 
486   /**
487    * @dev called by the owner to pause, triggers stopped state
488    */
489   function pause() public onlyPauser whenNotPaused {
490     _paused = true;
491     emit Paused(msg.sender);
492   }
493 
494   /**
495    * @dev called by the owner to unpause, returns to normal state
496    */
497   function unpause() public onlyPauser whenPaused {
498     _paused = false;
499     emit Unpaused(msg.sender);
500   }
501 }
502 
503 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Pausable.sol
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
570 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol
571 
572 /**
573  * @title Burnable Token
574  * @dev Token that can be irreversibly burned (destroyed).
575  */
576 contract ERC20Burnable is ERC20 {
577 
578   /**
579    * @dev Burns a specific amount of tokens.
580    * @param value The amount of token to be burned.
581    */
582 
583   function burn(uint256 value) public {
584     _burn(msg.sender, value);
585   }
586 
587   /**
588    * @dev Burns a specific amount of tokens from the target address and decrements allowance
589    * @param from address The address which you want to send tokens from
590    * @param value uint256 The amount of token to be burned
591    */
592 
593   function burnFrom(address from, uint256 value) public {
594     _burnFrom(from, value);
595   }
596 }
597 
598 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
599 
600 
601 contract MinterRole {
602   using Roles for Roles.Role;
603 
604   event MinterAdded(address indexed account);
605   event MinterRemoved(address indexed account);
606 
607   Roles.Role private minters;
608 
609   constructor() internal {
610     _addMinter(msg.sender);
611   }
612 
613   modifier onlyMinter() {
614     require(isMinter(msg.sender));
615     _;
616   }
617 
618   function isMinter(address account) public view returns (bool) {
619     return minters.has(account);
620   }
621 
622   function addMinter(address account) public onlyMinter {
623     _addMinter(account);
624   }
625   
626   function renounceMinter() public {
627     _removeMinter(msg.sender);
628   }
629 
630   function _addMinter(address account) internal {
631     minters.add(account);
632     emit MinterAdded(account);
633   }
634 
635   function _removeMinter(address account) internal {
636     minters.remove(account);
637     emit MinterRemoved(account);
638   }
639 }
640 
641 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
642 
643 /**
644  * @title ERC20Mintable
645  * @dev ERC20 minting logic
646  */
647 contract ERC20Mintable is ERC20, MinterRole {
648   /**
649    * @dev Function to mint tokens
650    * @param to The address that will receive the minted tokens.
651    * @param value The amount of tokens to mint.
652    * @return A boolean that indicates if the operation was successful.
653    */
654   
655   function mint(
656     address to,
657     uint256 value
658   )
659     public
660     onlyMinter
661     returns (bool)
662   {
663     _mint(to, value);
664     return true;
665   }
666 }
667 
668 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Capped.sol
669 
670 /**
671  * @title Capped token
672  * @dev Mintable token with a token cap.
673  */
674 contract ERC20Capped is ERC20Mintable {
675   
676   uint256 private _cap;
677 
678   constructor(uint256 cap)
679     public
680   {
681     require(cap > 0);
682     _cap = cap;
683   }
684 
685   /**
686    * @return the cap for the token minting.
687    */
688   function cap() public view returns(uint256) {
689     return _cap;
690   }
691 
692   function _mint(address account, uint256 value) internal {
693     require(totalSupply().add(value) <= _cap);
694     super._mint(account, value);
695   }
696 }
697 
698 // File: contracts/Token.sol
699 
700 
701 contract Token is ERC20Detailed, ERC20Pausable, ERC20Burnable, ERC20Capped {
702     // per-user timelock
703     mapping (address => uint256) lockedUntil;
704 
705     uint256 private maxTotalSupply = 394100000000000000;
706     address public lock_address;
707     bool private issued = false;
708 
709     constructor(address _address)
710     ERC20Detailed("PayProtocol", "PCI", 8)
711     ERC20Pausable()
712     ERC20Burnable()
713     ERC20Capped(maxTotalSupply)
714     public {
715         require(issued == false);
716         require(_address != msg.sender);
717         lock_address = _address;
718         super.mint(msg.sender, maxTotalSupply * 10 / 100);
719         mintWithTimelock(lock_address, maxTotalSupply * 90 / 100);
720         issued = true;
721     }
722 
723     // per-user timelock
724     modifier unLocked(address _address) {
725         require(block.timestamp >= lockedUntil[_address], 'timelocked');
726         _;
727     }
728 
729     // Overrides
730     function transfer(address to, uint256 value) public unLocked(msg.sender) returns (bool) {
731         require(value > 0);
732         return super.transfer(to, value);
733     }
734 
735     // Overrides
736     function transferFrom(address from, address to, uint256 value) public unLocked(from) returns (bool) {
737         require(value > 0);
738         return super.transferFrom(from, to, value);
739     }
740     
741     function mintWithTimelock(address to, uint value) internal {
742         super.mint(to, value);
743         lockedUntil[to] = 1587312000; // 2020-04-20 00:00:00
744     }
745     
746 
747     function burn(uint256 value) public unLocked(msg.sender) {
748         super.burn(value);
749     }
750 
751     function burnFrom(address from, uint256 value) public unLocked(from){
752         super.burnFrom(from, value);
753     }
754 
755     function timelockOf(address owner) public view returns (uint256) {
756         return lockedUntil[owner];
757     }
758 
759 }