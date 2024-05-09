1 pragma solidity ^0.4.24;
2 
3 
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
38 
39 /**
40  * @title ERC20Detailed token
41  * @dev The decimals are only for visualization purposes.
42  * All the operations are done using the smallest and indivisible token unit,
43  * just as on Ethereum all the operations are done in wei.
44  */
45 contract ERC20Detailed is IERC20 {
46   string private _name;
47   string private _symbol;
48   uint8 private _decimals;
49 
50   constructor(string name, string symbol, uint8 decimals) public {
51     _name = name;
52     _symbol = symbol;
53     _decimals = decimals;
54   }
55 
56   /**
57    * @return the name of the token.
58    */
59   function name() public view returns(string) {
60     return _name;
61   }
62 
63   /**
64    * @return the symbol of the token.
65    */
66   function symbol() public view returns(string) {
67     return _symbol;
68   }
69 
70   /**
71    * @return the number of decimals of the token.
72    */
73   function decimals() public view returns(uint8) {
74     return _decimals;
75   }
76 }
77 /**
78  * @title SafeMath
79  * @dev Math operations with safety checks that revert on error
80  */
81 library SafeMath {
82 
83   /**
84   * @dev Multiplies two numbers, reverts on overflow.
85   */
86   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
87     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
88     // benefit is lost if 'b' is also tested.
89     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
90     if (a == 0) {
91       return 0;
92     }
93 
94     uint256 c = a * b;
95     require(c / a == b);
96 
97     return c;
98   }
99 
100   /**
101   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
102   */
103   function div(uint256 a, uint256 b) internal pure returns (uint256) {
104     require(b > 0); // Solidity only automatically asserts when dividing by 0
105     uint256 c = a / b;
106     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
107 
108     return c;
109   }
110 
111   /**
112   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
113   */
114   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
115     require(b <= a);
116     uint256 c = a - b;
117 
118     return c;
119   }
120 
121   /**
122   * @dev Adds two numbers, reverts on overflow.
123   */
124   function add(uint256 a, uint256 b) internal pure returns (uint256) {
125     uint256 c = a + b;
126     require(c >= a);
127 
128     return c;
129   }
130 
131   /**
132   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
133   * reverts when dividing by zero.
134   */
135   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
136     require(b != 0);
137     return a % b;
138   }
139 }
140 
141 
142 /**
143  * @title Standard ERC20 token
144  *
145  * @dev Implementation of the basic standard token.
146  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
147  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
148  */
149 contract ERC20 is IERC20 {
150   using SafeMath for uint256;
151 
152   mapping (address => uint256) private _balances;
153 
154   mapping (address => mapping (address => uint256)) private _allowed;
155 
156   uint256 private _totalSupply;
157 
158   /**
159   * @dev Total number of tokens in existence
160   */
161   function totalSupply() public view returns (uint256) {
162     return _totalSupply;
163   }
164 
165   /**
166   * @dev Gets the balance of the specified address.
167   * @param owner The address to query the balance of.
168   * @return An uint256 representing the amount owned by the passed address.
169   */
170   function balanceOf(address owner) public view returns (uint256) {
171     return _balances[owner];
172   }
173 
174   /**
175    * @dev Function to check the amount of tokens that an owner allowed to a spender.
176    * @param owner address The address which owns the funds.
177    * @param spender address The address which will spend the funds.
178    * @return A uint256 specifying the amount of tokens still available for the spender.
179    */
180   function allowance(
181     address owner,
182     address spender
183    )
184     public
185     view
186     returns (uint256)
187   {
188     return _allowed[owner][spender];
189   }
190 
191   /**
192   * @dev Transfer token for a specified address
193   * @param to The address to transfer to.
194   * @param value The amount to be transferred.
195   */
196   function transfer(address to, uint256 value) public returns (bool) {
197     require(value <= _balances[msg.sender]);
198     require(to != address(0));
199 
200     _balances[msg.sender] = _balances[msg.sender].sub(value);
201     _balances[to] = _balances[to].add(value);
202     emit Transfer(msg.sender, to, value);
203     return true;
204   }
205 
206   /**
207    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
208    * Beware that changing an allowance with this method brings the risk that someone may use both the old
209    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
210    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
211    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
212    * @param spender The address which will spend the funds.
213    * @param value The amount of tokens to be spent.
214    */
215   function approve(address spender, uint256 value) public returns (bool) {
216     require(spender != address(0));
217 
218     _allowed[msg.sender][spender] = value;
219     emit Approval(msg.sender, spender, value);
220     return true;
221   }
222 
223   /**
224    * @dev Transfer tokens from one address to another
225    * @param from address The address which you want to send tokens from
226    * @param to address The address which you want to transfer to
227    * @param value uint256 the amount of tokens to be transferred
228    */
229   function transferFrom(
230     address from,
231     address to,
232     uint256 value
233   )
234     public
235     returns (bool)
236   {
237     require(value <= _balances[from]);
238     require(value <= _allowed[from][msg.sender]);
239     require(to != address(0));
240 
241     _balances[from] = _balances[from].sub(value);
242     _balances[to] = _balances[to].add(value);
243     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
244     emit Transfer(from, to, value);
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
297    * @dev Internal function that mints an amount of the token and assigns it to
298    * an account. This encapsulates the modification of balances such that the
299    * proper events are emitted.
300    * @param account The account that will receive the created tokens.
301    * @param amount The amount that will be created.
302    */
303   function _mint(address account, uint256 amount) internal {
304     require(account != 0);
305     _totalSupply = _totalSupply.add(amount);
306     _balances[account] = _balances[account].add(amount);
307     emit Transfer(address(0), account, amount);
308   }
309 
310   /**
311    * @dev Internal function that burns an amount of the token of a given
312    * account.
313    * @param account The account whose tokens will be burnt.
314    * @param amount The amount that will be burnt.
315    */
316   function _burn(address account, uint256 amount) internal {
317     require(account != 0);
318     require(amount <= _balances[account]);
319 
320     _totalSupply = _totalSupply.sub(amount);
321     _balances[account] = _balances[account].sub(amount);
322     emit Transfer(account, address(0), amount);
323   }
324 
325   /**
326    * @dev Internal function that burns an amount of the token of a given
327    * account, deducting from the sender's allowance for said account. Uses the
328    * internal burn function.
329    * @param account The account whose tokens will be burnt.
330    * @param amount The amount that will be burnt.
331    */
332   function _burnFrom(address account, uint256 amount) internal {
333     require(amount <= _allowed[account][msg.sender]);
334 
335     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
336     // this function needs to emit an event with the updated approval.
337     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
338       amount);
339     _burn(account, amount);
340   }
341 }
342 /**
343  * @title Roles
344  * @dev Library for managing addresses assigned to a Role.
345  */
346 library Roles {
347   struct Role {
348     mapping (address => bool) bearer;
349   }
350 
351   /**
352    * @dev give an account access to this role
353    */
354   function add(Role storage role, address account) internal {
355     require(account != address(0));
356     role.bearer[account] = true;
357   }
358 
359   /**
360    * @dev remove an account's access to this role
361    */
362   function remove(Role storage role, address account) internal {
363     require(account != address(0));
364     role.bearer[account] = false;
365   }
366 
367   /**
368    * @dev check if an account has this role
369    * @return bool
370    */
371   function has(Role storage role, address account)
372     internal
373     view
374     returns (bool)
375   {
376     require(account != address(0));
377     return role.bearer[account];
378   }
379 }
380 
381 
382 contract MinterRole {
383   using Roles for Roles.Role;
384 
385   event MinterAdded(address indexed account);
386   event MinterRemoved(address indexed account);
387 
388   Roles.Role private minters;
389 
390   constructor() public {
391     minters.add(msg.sender);
392   }
393 
394   modifier onlyMinter() {
395     require(isMinter(msg.sender));
396     _;
397   }
398 
399   function isMinter(address account) public view returns (bool) {
400     return minters.has(account);
401   }
402 
403   function addMinter(address account) public onlyMinter {
404     minters.add(account);
405     emit MinterAdded(account);
406   }
407 
408   function renounceMinter() public {
409     minters.remove(msg.sender);
410   }
411 
412   function _removeMinter(address account) internal {
413     minters.remove(account);
414     emit MinterRemoved(account);
415   }
416 }
417 
418 
419 /**
420  * @title ERC20Mintable
421  * @dev ERC20 minting logic
422  */
423 contract ERC20Mintable is ERC20, MinterRole {
424   event MintingFinished();
425 
426   bool private _mintingFinished = false;
427 
428   modifier onlyBeforeMintingFinished() {
429     require(!_mintingFinished);
430     _;
431   }
432 
433   /**
434    * @return true if the minting is finished.
435    */
436   function mintingFinished() public view returns(bool) {
437     return _mintingFinished;
438   }
439 
440   /**
441    * @dev Function to mint tokens
442    * @param to The address that will receive the minted tokens.
443    * @param amount The amount of tokens to mint.
444    * @return A boolean that indicates if the operation was successful.
445    */
446   function mint(
447     address to,
448     uint256 amount
449   )
450     public
451     onlyMinter
452     onlyBeforeMintingFinished
453     returns (bool)
454   {
455     _mint(to, amount);
456     return true;
457   }
458 
459   /**
460    * @dev Function to stop minting new tokens.
461    * @return True if the operation was successful.
462    */
463   function finishMinting()
464     public
465     onlyMinter
466     onlyBeforeMintingFinished
467     returns (bool)
468   {
469     _mintingFinished = true;
470     emit MintingFinished();
471     return true;
472   }
473 }
474 
475 
476 /**
477  * @title Capped token
478  * @dev Mintable token with a token cap.
479  */
480 contract ERC20Capped is ERC20Mintable {
481 
482   uint256 private _cap;
483 
484   constructor(uint256 cap)
485     public
486   {
487     require(cap > 0);
488     _cap = cap;
489   }
490 
491   /**
492    * @return the cap for the token minting.
493    */
494   function cap() public view returns(uint256) {
495     return _cap;
496   }
497 
498   /**
499    * @dev Function to mint tokens
500    * @param to The address that will receive the minted tokens.
501    * @param amount The amount of tokens to mint.
502    * @return A boolean that indicates if the operation was successful.
503    */
504   function mint(
505     address to,
506     uint256 amount
507   )
508     public
509     returns (bool)
510   {
511     require(totalSupply().add(amount) <= _cap);
512 
513     return super.mint(to, amount);
514   }
515 
516 }
517 contract PauserRole {
518   using Roles for Roles.Role;
519 
520   event PauserAdded(address indexed account);
521   event PauserRemoved(address indexed account);
522 
523   Roles.Role private pausers;
524 
525   constructor() public {
526     pausers.add(msg.sender);
527   }
528 
529   modifier onlyPauser() {
530     require(isPauser(msg.sender));
531     _;
532   }
533 
534   function isPauser(address account) public view returns (bool) {
535     return pausers.has(account);
536   }
537 
538   function addPauser(address account) public onlyPauser {
539     pausers.add(account);
540     emit PauserAdded(account);
541   }
542 
543   function renouncePauser() public {
544     pausers.remove(msg.sender);
545   }
546 
547   function _removePauser(address account) internal {
548     pausers.remove(account);
549     emit PauserRemoved(account);
550   }
551 }
552 
553 
554 /**
555  * @title Pausable
556  * @dev Base contract which allows children to implement an emergency stop mechanism.
557  */
558 contract Pausable is PauserRole {
559   event Paused();
560   event Unpaused();
561 
562   bool private _paused = false;
563 
564 
565   /**
566    * @return true if the contract is paused, false otherwise.
567    */
568   function paused() public view returns(bool) {
569     return _paused;
570   }
571 
572   /**
573    * @dev Modifier to make a function callable only when the contract is not paused.
574    */
575   modifier whenNotPaused() {
576     require(!_paused);
577     _;
578   }
579 
580   /**
581    * @dev Modifier to make a function callable only when the contract is paused.
582    */
583   modifier whenPaused() {
584     require(_paused);
585     _;
586   }
587 
588   /**
589    * @dev called by the owner to pause, triggers stopped state
590    */
591   function pause() public onlyPauser whenNotPaused {
592     _paused = true;
593     emit Paused();
594   }
595 
596   /**
597    * @dev called by the owner to unpause, returns to normal state
598    */
599   function unpause() public onlyPauser whenPaused {
600     _paused = false;
601     emit Unpaused();
602   }
603 }
604 
605 
606 /**
607  * @title Pausable token
608  * @dev ERC20 modified with pausable transfers.
609  **/
610 contract ERC20Pausable is ERC20, Pausable {
611 
612   function transfer(
613     address to,
614     uint256 value
615   )
616     public
617     whenNotPaused
618     returns (bool)
619   {
620     return super.transfer(to, value);
621   }
622 
623   function transferFrom(
624     address from,
625     address to,
626     uint256 value
627   )
628     public
629     whenNotPaused
630     returns (bool)
631   {
632     return super.transferFrom(from, to, value);
633   }
634 
635   function approve(
636     address spender,
637     uint256 value
638   )
639     public
640     whenNotPaused
641     returns (bool)
642   {
643     return super.approve(spender, value);
644   }
645 
646   function increaseAllowance(
647     address spender,
648     uint addedValue
649   )
650     public
651     whenNotPaused
652     returns (bool success)
653   {
654     return super.increaseAllowance(spender, addedValue);
655   }
656 
657   function decreaseAllowance(
658     address spender,
659     uint subtractedValue
660   )
661     public
662     whenNotPaused
663     returns (bool success)
664   {
665     return super.decreaseAllowance(spender, subtractedValue);
666   }
667 }
668 
669 
670 contract TAIBToken is ERC20Detailed("TAIB", "TAIB", 18), ERC20Capped(190000000 * 10 ** 18), ERC20Pausable {
671     constructor() public {
672         _mint(msg.sender, 190000000 * 10 ** 18);
673     }
674 }