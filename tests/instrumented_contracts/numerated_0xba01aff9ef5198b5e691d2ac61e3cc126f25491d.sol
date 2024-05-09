1 /**
2  *  GUT is a transitional token for PERSONO.ID
3  *  For details open site().
4  *  GUT token crowdsale address: 0xdbf411f0125839bE53aC7cc5c8c3a8f185075df7
5 **/
6 
7 pragma solidity ^0.4.24;
8 
9 /**
10  * @title ERC20 interface
11  */
12 interface IERC20 {
13   function totalSupply() external view returns (uint256);
14 
15   function balanceOf(address who) external view returns (uint256);
16 
17   function allowance(address owner, address spender)
18     external view returns (uint256);
19 
20   function transfer(address to, uint256 value) external returns (bool);
21 
22   function approve(address spender, uint256 value)
23     external returns (bool);
24 
25   function transferFrom(address from, address to, uint256 value)
26     external returns (bool);
27 
28   event Transfer(
29     address indexed from,
30     address indexed to,
31     uint256 value
32   );
33 
34   event Approval(
35     address indexed owner,
36     address indexed spender,
37     uint256 value
38   );
39 }
40 
41 
42 //Math operations with safety checks that revert on error
43 library SafeMath {
44 
45   //Multiplies two numbers, reverts on overflow.
46   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
47     if (a == 0) {
48       return 0;
49     }
50 
51     uint256 c = a * b;
52     require(c / a == b);
53 
54     return c;
55   }
56 
57   
58   //Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
59   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
60     require(b <= a);
61     uint256 c = a - b;
62 
63     return c;
64   }
65 
66   //Adds two numbers, reverts on overflow.
67   function add(uint256 a, uint256 b) internal pure returns (uint256) {
68     uint256 c = a + b;
69     require(c >= a);
70 
71     return c;
72   }
73 }
74 
75 /**
76  * @title Standard ERC20 token
77  */
78 contract ERC20 is IERC20 {
79   using SafeMath for uint256;
80 
81   mapping (address => uint256) private _balances;
82 
83   mapping (address => mapping (address => uint256)) private _allowed;
84 
85   uint256 private _totalSupply;
86 
87 
88   //Total number of tokens in existence
89   function totalSupply() public view returns (uint256) {
90     return _totalSupply;
91   }
92 
93   /**
94   * Gets the balance of the specified address.
95   * @param owner The address to query the balance of.
96   * @return An uint256 representing the amount owned by the passed address.
97   */
98   function balanceOf(address owner) public view returns (uint256) {
99     return _balances[owner];
100   }
101 
102   /**
103    * Function to check the amount of tokens that an owner allowed to a spender.
104    * @param owner address The address which owns the funds.
105    * @param spender address The address which will spend the funds.
106    * @return A uint256 specifying the amount of tokens still available for the spender.
107    */
108   function allowance(
109     address owner,
110     address spender
111    )
112     public
113     view
114     returns (uint256)
115   {
116     return _allowed[owner][spender];
117   }
118 
119   /**
120   * Transfer token for a specified address
121   * @param to The address to transfer to.
122   * @param value The amount to be transferred.
123   */
124   function transfer(address to, uint256 value) public returns (bool) {
125     _transfer(msg.sender, to, value);
126     return true;
127   }
128 
129   /**
130    * Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
131    * @notice WARNING! For security reasons change allowance in two steps (two transactions): 
132    * 1. set value to 0 
133    * 2. set the new value
134    * @param spender The address which will spend the funds.
135    * @param value The amount of tokens to be spent.
136    */
137   function approve(address spender, uint256 value) public returns (bool) {
138     require(spender != address(0));
139 
140     _allowed[msg.sender][spender] = value;
141     emit Approval(msg.sender, spender, value);
142     return true;
143   }
144 
145   /**
146    * Transfer tokens from one address to another
147    * @param from address The address which you want to send tokens from
148    * @param to address The address which you want to transfer to
149    * @param value uint256 the amount of tokens to be transferred
150    */
151   function transferFrom(
152     address from,
153     address to,
154     uint256 value
155   )
156     public
157     returns (bool)
158   {
159     require(value <= _allowed[from][msg.sender]);
160 
161     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
162     _transfer(from, to, value);
163     return true;
164   }
165 
166   /**
167    * Increase the amount of tokens that an owner allowed to a spender.
168    * Use only when allowed_[_spender] > 0. Otherwise call approve(). 
169    * @param spender The address which will spend the funds.
170    * @param addedValue The amount of tokens to increase the allowance by.
171    */
172   function increaseAllowance(
173     address spender,
174     uint256 addedValue
175   )
176     public
177     returns (bool)
178   {
179     require(spender != address(0));
180 
181     _allowed[msg.sender][spender] = (
182       _allowed[msg.sender][spender].add(addedValue));
183     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
184     return true;
185   }
186 
187   /**
188    * Decrease the amount of tokens that an owner allowed to a spender.
189    * Use only when allowed_[_spender] > 0. Otherwise call approve().
190    * @param spender The address which will spend the funds.
191    * @param subtractedValue The amount of tokens to decrease the allowance by.
192    */
193   function decreaseAllowance(
194     address spender,
195     uint256 subtractedValue
196   )
197     public
198     returns (bool)
199   {
200     require(spender != address(0));
201 
202     _allowed[msg.sender][spender] = (
203       _allowed[msg.sender][spender].sub(subtractedValue));
204     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
205     return true;
206   }
207 
208   /**
209   * Transfer token for a specified addresses
210   * @param from The address to transfer from.
211   * @param to The address to transfer to.
212   * @param value The amount to be transferred.
213   */
214   function _transfer(address from, address to, uint256 value) internal {
215     require(value <= _balances[from]);
216     require(to != address(0));
217 
218     _balances[from] = _balances[from].sub(value);
219     _balances[to] = _balances[to].add(value);
220     emit Transfer(from, to, value);
221   }
222 
223   /**
224    * Internal function that mints an amount of the token and assigns it to
225    * an account. This encapsulates the modification of balances such that the
226    * proper events are emitted.
227    * @param account The account that will receive the created tokens.
228    * @param value The amount that will be created.
229    */
230   function _mint(address account, uint256 value) internal {
231     require(account != 0);
232     _totalSupply = _totalSupply.add(value);
233     _balances[account] = _balances[account].add(value);
234     emit Transfer(address(0), account, value);
235   }
236 
237   /**
238    * Internal function that burns an amount of the token of a given
239    * account. It is here for security should anything go wrong. 
240    * Anyway your tokens are safe: all legal transactions thus balances will be restored from the events.
241    * @param account The account whose tokens will be burnt.
242    * @param value The amount that will be burnt.
243    */
244   function _burn(address account, uint256 value) internal {
245     require(account != 0);
246     require(value <= _balances[account]);
247 
248     _totalSupply = _totalSupply.sub(value);
249     _balances[account] = _balances[account].sub(value);
250     emit Transfer(account, address(0), value);
251   }
252 
253   /**
254    * Internal function that burns an amount of the token of a given
255    * account, deducting from the sender's allowance for said account. Uses the
256    * internal burn function.
257    * @param account The account whose tokens will be burnt.
258    * @param value The amount that will be burnt.
259    */
260   function _burnFrom(address account, uint256 value) internal {
261     require(value <= _allowed[account][msg.sender]);
262 
263     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
264       value);
265     _burn(account, value);
266   }
267 }
268 
269 /**
270  * @title Roles
271  * Library for managing addresses assigned to a Role.
272  */
273 library Roles {
274   struct Role {
275     mapping (address => bool) bearer;
276   }
277 
278   /**
279    * Assigns this role to the account, empowering the account with the given role's priviledges
280    */
281   function add(Role storage role, address account) internal {
282     require(account != address(0));
283     require(!has(role, account));
284 
285     role.bearer[account] = true;
286   }
287 
288   /**
289    * Removes the role from the account: no more role's priviledges for the account
290    */
291   function remove(Role storage role, address account) internal {
292     require(account != address(0));
293     require(has(role, account));
294 
295     role.bearer[account] = false;
296   }
297 
298   //Check if the given account has this role
299   function has(Role storage role, address account)
300     internal
301     view
302     returns (bool)
303   {
304     require(account != address(0));
305     return role.bearer[account];
306   }
307 }
308 
309 /**
310  * @title MinterRole
311  * MinterRole to be assigned to the addresses eligible to emit (mint) new tokens
312  */
313 contract MinterRole {
314   using Roles for Roles.Role;
315 
316   event MinterAdded(address indexed account);
317   event MinterRemoved(address indexed account);
318 
319   Roles.Role private minters;
320 
321   constructor() internal {
322     _addMinter(msg.sender);
323   }
324 
325   modifier onlyMinter() {
326     require(isMinter(msg.sender));
327     _;
328   }
329 
330   function isMinter(address account) public view returns (bool) {
331     return minters.has(account);
332   }
333 
334   function addMinter(address account) public onlyMinter {
335     _addMinter(account);
336   }
337 
338   function renounceMinter() public {
339     _removeMinter(msg.sender);
340   }
341 
342   function _addMinter(address account) internal {
343     minters.add(account);
344     emit MinterAdded(account);
345   }
346 
347   function _removeMinter(address account) internal {
348     minters.remove(account);
349     emit MinterRemoved(account);
350   }
351 }
352 
353 /**
354  * @title ERC20Mintable
355  * @dev ERC20 minting logic
356  */
357 contract ERC20Mintable is ERC20, MinterRole {
358   /**
359    * Function to mint tokens
360    * @param to The address that will receive the minted tokens.
361    * @param value The amount of tokens to mint.
362    * @return A boolean that indicates if the operation was successful.
363    */
364   function mint(
365     address to,
366     uint256 value
367   )
368     public
369     onlyMinter
370     returns (bool)
371   {
372     _mint(to, value);
373     return true;
374   }
375 }
376 
377 /**
378  * @notice PauserRole role to be assigned to the addresses eligible to pause contracts in case of emergency
379  */
380 contract PauserRole {
381   using Roles for Roles.Role;
382 
383   event PauserAdded(address indexed account);
384   event PauserRemoved(address indexed account);
385 
386   Roles.Role private pausers;
387 
388   constructor() internal {
389     _addPauser(msg.sender);
390   }
391 
392   modifier onlyPauser() {
393     require(isPauser(msg.sender));
394     _;
395   }
396 
397   function isPauser(address account) public view returns (bool) {
398     return pausers.has(account);
399   }
400 
401   function addPauser(address account) public onlyPauser {
402     _addPauser(account);
403   }
404 
405   function renouncePauser() public {
406     _removePauser(msg.sender);
407   }
408 
409   function _addPauser(address account) internal {
410     pausers.add(account);
411     emit PauserAdded(account);
412   }
413 
414   function _removePauser(address account) internal {
415     pausers.remove(account);
416     emit PauserRemoved(account);
417   }
418 }
419 
420 /**
421  * @title Pausable
422  * Base contract which allows children to implement an emergency stop mechanism.
423  */
424 contract Pausable is PauserRole {
425   event Paused(address indexed account);
426   event Unpaused(address indexed account);
427 
428   bool private _paused;
429 
430   constructor() internal {
431     _paused = false;
432   }
433 
434   /**
435    * @return true if the contract is paused, false otherwise.
436    */
437   function paused() public view returns(bool) {
438     return _paused;
439   }
440 
441   // Modifier to make a function callable only when the contract is not paused.
442   modifier whenNotPaused() {
443     require(!_paused);
444     _;
445   }
446 
447   // Modifier to make a function callable only when the contract is paused.
448   modifier whenPaused() {
449     require(_paused);
450     _;
451   }
452 
453   // Called by a Pauser to pause, triggers stopped state.
454   function pause() public onlyPauser whenNotPaused {
455     _paused = true;
456     emit Paused(msg.sender);
457   }
458 
459   // Called by a Pauser to unpause, returns to normal state.
460   function unpause() public onlyPauser whenPaused {
461     _paused = false;
462     emit Unpaused(msg.sender);
463   }
464 }
465 
466 /**
467  * @title Pausable token 
468  * ERC20 modified with pausable transfers.
469  **/
470 contract ERC20Pausable is ERC20, Pausable {
471 
472   function transfer(
473     address to,
474     uint256 value
475   )
476     public
477     whenNotPaused
478     returns (bool)
479   {
480     return super.transfer(to, value);
481   }
482 
483   function transferFrom(
484     address from,
485     address to,
486     uint256 value
487   )
488     public
489     whenNotPaused
490     returns (bool)
491   {
492     return super.transferFrom(from, to, value);
493   }
494 
495   function approve(
496     address spender,
497     uint256 value
498   )
499     public
500     whenNotPaused
501     returns (bool)
502   {
503     return super.approve(spender, value);
504   }
505 
506   function increaseAllowance(
507     address spender,
508     uint addedValue
509   )
510     public
511     whenNotPaused
512     returns (bool success)
513   {
514     return super.increaseAllowance(spender, addedValue);
515   }
516 
517   function decreaseAllowance(
518     address spender,
519     uint subtractedValue
520   )
521     public
522     whenNotPaused
523     returns (bool success)
524   {
525     return super.decreaseAllowance(spender, subtractedValue);
526   }
527 }
528 
529 /**
530  * @title ERC20Detailed token
531  * @dev The decimals are only for visualization purposes.
532  * All the operations are done using the smallest and indivisible token unit,
533  * just as on Ethereum all the operations are done in wei.
534  */
535 contract ERC20Detailed is IERC20 {
536   string private _name;
537   string private _symbol;
538   uint8 private _decimals;
539 
540   constructor(string name, string symbol, uint8 decimals) public {
541     _name = name;
542     _symbol = symbol;
543     _decimals = decimals;
544   }
545 
546   /**
547    * @return the name of the token.
548    */
549   function name() public view returns(string) {
550     return _name;
551   }
552 
553   /**
554    * @return the symbol of the token.
555    */
556   function symbol() public view returns(string) {
557     return _symbol;
558   }
559 
560   /**
561    * @return the number of decimals of the token.
562    */
563   function decimals() public view returns(uint8) {
564     return _decimals;
565   }
566 }
567 
568 /**
569  * @title Burnable Token
570  * Token that can be irreversibly burned (destroyed).
571  */
572 contract ERC20Burnable is ERC20 {
573 
574   /**
575    * Burns a specific amount of tokens.
576    * @param value The amount of token to be burned.
577    */
578   function burn(uint256 value) public {
579     _burn(msg.sender, value);
580   }
581 
582   /**
583    * Burns a specific amount of tokens from the target address and decrements allowance
584    * @param from address The address which you want to send tokens from
585    * @param value uint256 The amount of token to be burned
586    */
587   function burnFrom(address from, uint256 value) public {
588     _burnFrom(from, value);
589   }
590 }
591 
592 /**
593  * @title Keeper role
594  * Used for some administrative tasks
595  */
596 contract KeeperRole {
597   using Roles for Roles.Role;
598 
599   event KeeperAdded(address indexed account);
600   event KeeperRemoved(address indexed account);
601 
602   Roles.Role private keepers;
603 
604   constructor() internal {
605     _addKeeper(msg.sender);
606   }
607 
608   modifier onlyKeeper() {
609     require(isKeeper(msg.sender), 'Only Keeper is allowed');
610     _;
611   }
612 
613   function isKeeper(address account) public view returns (bool) {
614     return keepers.has(account);
615   }
616 
617   function addKeeper(address account) public onlyKeeper {
618     _addKeeper(account);
619   }
620 
621   function renounceKeeper() public {
622     _removeKeeper(msg.sender);
623   }
624 
625   function _addKeeper(address account) internal {
626     keepers.add(account);
627     emit KeeperAdded(account);
628   }
629 
630   function _removeKeeper(address account) internal {
631     keepers.remove(account);
632     emit KeeperRemoved(account);
633   }
634 }
635 
636 /**
637  * @title GUT token. Persono.id forerunner
638  * Please, visit GutToken.site() for details
639  */
640 contract GutToken is KeeperRole, ERC20Pausable, ERC20Burnable, ERC20Mintable {
641   string public constant name = "GUT Token";
642   string public constant description = "GUT token is persono.id forerunner. Please visit GutToken.site().";
643   string public constant symbol = "GUT"; //==10**18 guttin. 1 guttin to GUT is the same as wei to Ether
644   uint8 public constant decimals = 18; 
645   uint256 public constant INITIAL_SUPPLY = 100000000 * (10 ** uint256(decimals)); //reserved for persono.id foundation
646   string public site;
647 
648   /**
649    * @notice Initially 100 mln GUT are charged to the creators' account. Guttin is the smallest part.
650    */
651   constructor() public {
652     site = "http://persono.id";
653     mint(msg.sender, INITIAL_SUPPLY);
654   }
655   
656   /**
657    * To keep site address up to date
658    */
659   function setSite(string _site) public onlyKeeper {
660     site = _site;
661   }
662 
663   /**
664    * @notice Protection from loosing GUTs by sending them accidentally to token's (this contract's) address
665    * @param to The address the tokens are sent to
666    */
667   modifier validDestination(address to) {
668     require(to != address(this),"Sending to the token's address is not allowed");
669     _;
670   }
671 
672   /**
673    * @notice Protection from transferring to GUT contract's address
674    * @param to The tokens are transferred to this address
675    * @param value The token amount transferred in guttins (10**18 guttin = 1 GUT)
676    */
677   function transfer(address to, uint256 value) public validDestination(to) returns (bool) {
678       return super.transfer(to, value);
679   }
680 }