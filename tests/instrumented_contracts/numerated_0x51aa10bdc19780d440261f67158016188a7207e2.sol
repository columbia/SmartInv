1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
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
40 /**
41  * @title ERC20Detailed token
42  * @dev The decimals are only for visualization purposes.
43  * All the operations are done using the smallest and indivisible token unit,
44  * just as on Ethereum all the operations are done in wei.
45  */
46 contract ERC20Detailed is IERC20 {
47   string private _name;
48   string private _symbol;
49   uint8 private _decimals;
50 
51   constructor(string name, string symbol, uint8 decimals) public {
52     _name = name;
53     _symbol = symbol;
54     _decimals = decimals;
55   }
56 
57   /**
58    * @return the name of the token.
59    */
60   function name() public view returns(string) {
61     return _name;
62   }
63 
64   /**
65    * @return the symbol of the token.
66    */
67   function symbol() public view returns(string) {
68     return _symbol;
69   }
70 
71   /**
72    * @return the number of decimals of the token.
73    */
74   function decimals() public view returns(uint8) {
75     return _decimals;
76   }
77 }
78 
79 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
80 
81 /**
82  * @title SafeMath
83  * @dev Math operations with safety checks that revert on error
84  */
85 library SafeMath {
86 
87   /**
88   * @dev Multiplies two numbers, reverts on overflow.
89   */
90   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
91     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
92     // benefit is lost if 'b' is also tested.
93     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
94     if (a == 0) {
95       return 0;
96     }
97 
98     uint256 c = a * b;
99     require(c / a == b);
100 
101     return c;
102   }
103 
104   /**
105   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
106   */
107   function div(uint256 a, uint256 b) internal pure returns (uint256) {
108     require(b > 0); // Solidity only automatically asserts when dividing by 0
109     uint256 c = a / b;
110     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
111 
112     return c;
113   }
114 
115   /**
116   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
117   */
118   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
119     require(b <= a);
120     uint256 c = a - b;
121 
122     return c;
123   }
124 
125   /**
126   * @dev Adds two numbers, reverts on overflow.
127   */
128   function add(uint256 a, uint256 b) internal pure returns (uint256) {
129     uint256 c = a + b;
130     require(c >= a);
131 
132     return c;
133   }
134 
135   /**
136   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
137   * reverts when dividing by zero.
138   */
139   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
140     require(b != 0);
141     return a % b;
142   }
143 }
144 
145 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
146 
147 /**
148  * @title Standard ERC20 token
149  *
150  * @dev Implementation of the basic standard token.
151  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
152  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
153  */
154 contract ERC20 is IERC20 {
155   using SafeMath for uint256;
156 
157   mapping (address => uint256) private _balances;
158 
159   mapping (address => mapping (address => uint256)) private _allowed;
160 
161   uint256 private _totalSupply;
162 
163   /**
164   * @dev Total number of tokens in existence
165   */
166   function totalSupply() public view returns (uint256) {
167     return _totalSupply;
168   }
169 
170   /**
171   * @dev Gets the balance of the specified address.
172   * @param owner The address to query the the balance of.
173   * @return An uint256 representing the amount owned by the passed address.
174   */
175   function balanceOf(address owner) public view returns (uint256) {
176     return _balances[owner];
177   }
178 
179   /**
180    * @dev Function to check the amount of tokens that an owner allowed to a spender.
181    * @param owner address The address which owns the funds.
182    * @param spender address The address which will spend the funds.
183    * @return A uint256 specifying the amount of tokens still available for the spender.
184    */
185   function allowance(
186     address owner,
187     address spender
188    )
189     public
190     view
191     returns (uint256)
192   {
193     return _allowed[owner][spender];
194   }
195 
196   /**
197   * @dev Transfer token for a specified address
198   * @param to The address to transfer to.
199   * @param value The amount to be transferred.
200   */
201   function transfer(address to, uint256 value) public returns (bool) {
202     require(value <= _balances[msg.sender]);
203     require(to != address(0));
204 
205     _balances[msg.sender] = _balances[msg.sender].sub(value);
206     _balances[to] = _balances[to].add(value);
207     emit Transfer(msg.sender, to, value);
208     return true;
209   }
210 
211   /**
212    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
213    * Beware that changing an allowance with this method brings the risk that someone may use both the old
214    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
215    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
216    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
217    * @param spender The address which will spend the funds.
218    * @param value The amount of tokens to be spent.
219    */
220   function approve(address spender, uint256 value) public returns (bool) {
221     require(spender != address(0));
222 
223     _allowed[msg.sender][spender] = value;
224     emit Approval(msg.sender, spender, value);
225     return true;
226   }
227 
228   /**
229    * @dev Transfer tokens from one address to another
230    * @param from address The address which you want to send tokens from
231    * @param to address The address which you want to transfer to
232    * @param value uint256 the amount of tokens to be transferred
233    */
234   function transferFrom(
235     address from,
236     address to,
237     uint256 value
238   )
239     public
240     returns (bool)
241   {
242     require(value <= _balances[from]);
243     require(value <= _allowed[from][msg.sender]);
244     require(to != address(0));
245 
246     _balances[from] = _balances[from].sub(value);
247     _balances[to] = _balances[to].add(value);
248     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
249     emit Transfer(from, to, value);
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
302    * @dev Internal function that mints an amount of the token and assigns it to
303    * an account. This encapsulates the modification of balances such that the
304    * proper events are emitted.
305    * @param account The account that will receive the created tokens.
306    * @param amount The amount that will be created.
307    */
308   function _mint(address account, uint256 amount) internal {
309     require(account != 0);
310     _totalSupply = _totalSupply.add(amount);
311     _balances[account] = _balances[account].add(amount);
312     emit Transfer(address(0), account, amount);
313   }
314 
315   /**
316    * @dev Internal function that burns an amount of the token of a given
317    * account.
318    * @param account The account whose tokens will be burnt.
319    * @param amount The amount that will be burnt.
320    */
321   function _burn(address account, uint256 amount) internal {
322     require(account != 0);
323     require(amount <= _balances[account]);
324 
325     _totalSupply = _totalSupply.sub(amount);
326     _balances[account] = _balances[account].sub(amount);
327     emit Transfer(account, address(0), amount);
328   }
329 
330   /**
331    * @dev Internal function that burns an amount of the token of a given
332    * account, deducting from the sender's allowance for said account. Uses the
333    * internal burn function.
334    * @param account The account whose tokens will be burnt.
335    * @param amount The amount that will be burnt.
336    */
337   function _burnFrom(address account, uint256 amount) internal {
338     require(amount <= _allowed[account][msg.sender]);
339 
340     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
341     // this function needs to emit an event with the updated approval.
342     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
343       amount);
344     _burn(account, amount);
345   }
346 }
347 
348 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol
349 
350 /**
351  * @title Burnable Token
352  * @dev Token that can be irreversibly burned (destroyed).
353  */
354 contract ERC20Burnable is ERC20 {
355 
356   /**
357    * @dev Burns a specific amount of tokens.
358    * @param value The amount of token to be burned.
359    */
360   function burn(uint256 value) public {
361     _burn(msg.sender, value);
362   }
363 
364   /**
365    * @dev Burns a specific amount of tokens from the target address and decrements allowance
366    * @param from address The address which you want to send tokens from
367    * @param value uint256 The amount of token to be burned
368    */
369   function burnFrom(address from, uint256 value) public {
370     _burnFrom(from, value);
371   }
372 
373   /**
374    * @dev Overrides ERC20._burn in order for burn and burnFrom to emit
375    * an additional Burn event.
376    */
377   function _burn(address who, uint256 value) internal {
378     super._burn(who, value);
379   }
380 }
381 
382 // File: openzeppelin-solidity/contracts/access/Roles.sol
383 
384 /**
385  * @title Roles
386  * @dev Library for managing addresses assigned to a Role.
387  */
388 library Roles {
389   struct Role {
390     mapping (address => bool) bearer;
391   }
392 
393   /**
394    * @dev give an account access to this role
395    */
396   function add(Role storage role, address account) internal {
397     require(account != address(0));
398     role.bearer[account] = true;
399   }
400 
401   /**
402    * @dev remove an account's access to this role
403    */
404   function remove(Role storage role, address account) internal {
405     require(account != address(0));
406     role.bearer[account] = false;
407   }
408 
409   /**
410    * @dev check if an account has this role
411    * @return bool
412    */
413   function has(Role storage role, address account)
414     internal
415     view
416     returns (bool)
417   {
418     require(account != address(0));
419     return role.bearer[account];
420   }
421 }
422 
423 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
424 
425 contract MinterRole {
426   using Roles for Roles.Role;
427 
428   event MinterAdded(address indexed account);
429   event MinterRemoved(address indexed account);
430 
431   Roles.Role private minters;
432 
433   constructor() public {
434     minters.add(msg.sender);
435   }
436 
437   modifier onlyMinter() {
438     require(isMinter(msg.sender));
439     _;
440   }
441 
442   function isMinter(address account) public view returns (bool) {
443     return minters.has(account);
444   }
445 
446   function addMinter(address account) public onlyMinter {
447     minters.add(account);
448     emit MinterAdded(account);
449   }
450 
451   function renounceMinter() public {
452     minters.remove(msg.sender);
453   }
454 
455   function _removeMinter(address account) internal {
456     minters.remove(account);
457     emit MinterRemoved(account);
458   }
459 }
460 
461 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
462 
463 /**
464  * @title ERC20Mintable
465  * @dev ERC20 minting logic
466  */
467 contract ERC20Mintable is ERC20, MinterRole {
468   event MintingFinished();
469 
470   bool private _mintingFinished = false;
471 
472   modifier onlyBeforeMintingFinished() {
473     require(!_mintingFinished);
474     _;
475   }
476 
477   /**
478    * @return true if the minting is finished.
479    */
480   function mintingFinished() public view returns(bool) {
481     return _mintingFinished;
482   }
483 
484   /**
485    * @dev Function to mint tokens
486    * @param to The address that will receive the minted tokens.
487    * @param amount The amount of tokens to mint.
488    * @return A boolean that indicates if the operation was successful.
489    */
490   function mint(
491     address to,
492     uint256 amount
493   )
494     public
495     onlyMinter
496     onlyBeforeMintingFinished
497     returns (bool)
498   {
499     _mint(to, amount);
500     return true;
501   }
502 
503   /**
504    * @dev Function to stop minting new tokens.
505    * @return True if the operation was successful.
506    */
507   function finishMinting()
508     public
509     onlyMinter
510     onlyBeforeMintingFinished
511     returns (bool)
512   {
513     _mintingFinished = true;
514     emit MintingFinished();
515     return true;
516   }
517 }
518 
519 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
520 
521 contract PauserRole {
522   using Roles for Roles.Role;
523 
524   event PauserAdded(address indexed account);
525   event PauserRemoved(address indexed account);
526 
527   Roles.Role private pausers;
528 
529   constructor() public {
530     pausers.add(msg.sender);
531   }
532 
533   modifier onlyPauser() {
534     require(isPauser(msg.sender));
535     _;
536   }
537 
538   function isPauser(address account) public view returns (bool) {
539     return pausers.has(account);
540   }
541 
542   function addPauser(address account) public onlyPauser {
543     pausers.add(account);
544     emit PauserAdded(account);
545   }
546 
547   function renouncePauser() public {
548     pausers.remove(msg.sender);
549   }
550 
551   function _removePauser(address account) internal {
552     pausers.remove(account);
553     emit PauserRemoved(account);
554   }
555 }
556 
557 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
558 
559 /**
560  * @title Pausable
561  * @dev Base contract which allows children to implement an emergency stop mechanism.
562  */
563 contract Pausable is PauserRole {
564   event Paused();
565   event Unpaused();
566 
567   bool private _paused = false;
568 
569 
570   /**
571    * @return true if the contract is paused, false otherwise.
572    */
573   function paused() public view returns(bool) {
574     return _paused;
575   }
576 
577   /**
578    * @dev Modifier to make a function callable only when the contract is not paused.
579    */
580   modifier whenNotPaused() {
581     require(!_paused);
582     _;
583   }
584 
585   /**
586    * @dev Modifier to make a function callable only when the contract is paused.
587    */
588   modifier whenPaused() {
589     require(_paused);
590     _;
591   }
592 
593   /**
594    * @dev called by the owner to pause, triggers stopped state
595    */
596   function pause() public onlyPauser whenNotPaused {
597     _paused = true;
598     emit Paused();
599   }
600 
601   /**
602    * @dev called by the owner to unpause, returns to normal state
603    */
604   function unpause() public onlyPauser whenPaused {
605     _paused = false;
606     emit Unpaused();
607   }
608 }
609 
610 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Pausable.sol
611 
612 /**
613  * @title Pausable token
614  * @dev ERC20 modified with pausable transfers.
615  **/
616 contract ERC20Pausable is ERC20, Pausable {
617 
618   function transfer(
619     address to,
620     uint256 value
621   )
622     public
623     whenNotPaused
624     returns (bool)
625   {
626     return super.transfer(to, value);
627   }
628 
629   function transferFrom(
630     address from,
631     address to,
632     uint256 value
633   )
634     public
635     whenNotPaused
636     returns (bool)
637   {
638     return super.transferFrom(from, to, value);
639   }
640 
641   function approve(
642     address spender,
643     uint256 value
644   )
645     public
646     whenNotPaused
647     returns (bool)
648   {
649     return super.approve(spender, value);
650   }
651 
652   function increaseAllowance(
653     address spender,
654     uint addedValue
655   )
656     public
657     whenNotPaused
658     returns (bool success)
659   {
660     return super.increaseAllowance(spender, addedValue);
661   }
662 
663   function decreaseAllowance(
664     address spender,
665     uint subtractedValue
666   )
667     public
668     whenNotPaused
669     returns (bool success)
670   {
671     return super.decreaseAllowance(spender, subtractedValue);
672   }
673 }
674 
675 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Capped.sol
676 
677 /**
678  * @title Capped token
679  * @dev Mintable token with a token cap.
680  */
681 contract ERC20Capped is ERC20Mintable {
682 
683   uint256 private _cap;
684 
685   constructor(uint256 cap)
686     public
687   {
688     require(cap > 0);
689     _cap = cap;
690   }
691 
692   /**
693    * @return the cap for the token minting.
694    */
695   function cap() public view returns(uint256) {
696     return _cap;
697   }
698 
699   /**
700    * @dev Function to mint tokens
701    * @param to The address that will receive the minted tokens.
702    * @param amount The amount of tokens to mint.
703    * @return A boolean that indicates if the operation was successful.
704    */
705   function mint(
706     address to,
707     uint256 amount
708   )
709     public
710     returns (bool)
711   {
712     require(totalSupply().add(amount) <= _cap);
713 
714     return super.mint(to, amount);
715   }
716 
717 }
718 
719 // File: contracts/PlazaToken.sol
720 
721 contract PlazaToken is ERC20, ERC20Detailed, ERC20Mintable, ERC20Burnable, ERC20Pausable, ERC20Capped {
722 
723     /* Initializes contract with initial supply tokens to the creator of the contract */
724     constructor(
725         string name,
726         string symbol,
727         uint8 decimals,
728         uint256 cap
729     )
730     ERC20Burnable()
731     ERC20Mintable()
732     ERC20Pausable()
733     ERC20Capped(cap)
734     ERC20Detailed(name, symbol, decimals)
735     ERC20()
736     public
737     {}
738 }