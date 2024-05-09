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
78  * @title SafeMath
79  * @dev Math operations with safety checks that revert on error
80  */
81 library SafeMath {
82 
83   /**
84   * @dev Multiplies two numbers, reverts on overflow.
85   */
86   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
87     if (a == 0) {
88       return 0;
89     }
90 
91     uint256 c = a * b;
92     require(c / a == b);
93 
94     return c;
95   }
96 
97   /**
98   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
99   */
100   function div(uint256 a, uint256 b) internal pure returns (uint256) {
101     require(b > 0);
102     uint256 c = a / b;
103 
104     return c;
105   }
106 
107   /**
108   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
109   */
110   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
111     require(b <= a);
112     uint256 c = a - b;
113 
114     return c;
115   }
116 
117   /**
118   * @dev Adds two numbers, reverts on overflow.
119   */
120   function add(uint256 a, uint256 b) internal pure returns (uint256) {
121     uint256 c = a + b;
122     require(c >= a);
123 
124     return c;
125   }
126 
127   /**
128   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
129   * reverts when dividing by zero.
130   */
131   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
132     require(b != 0);
133     return a % b;
134   }
135 }
136 
137 /**
138  * @title ERC20 interface
139  * @dev see https://github.com/ethereum/EIPs/issues/20
140  */
141 interface IERC20 {
142   function totalSupply() external view returns (uint256);
143 
144   function balanceOf(address who) external view returns (uint256);
145 
146   function allowance(address owner, address spender)
147     external view returns (uint256);
148 
149   function transfer(address to, uint256 value) external returns (bool);
150 
151   function approve(address spender, uint256 value)
152     external returns (bool);
153 
154   function transferFrom(address from, address to, uint256 value)
155     external returns (bool);
156 
157   event Transfer(
158     address indexed from,
159     address indexed to,
160     uint256 value
161   );
162 
163   event Approval(
164     address indexed owner,
165     address indexed spender,
166     uint256 value
167   );
168 }
169 
170 /**
171  * @title Standard ERC20 token
172  * @dev Implementation of the basic standard token.
173  */
174 contract ERC20 is IERC20 {
175   using SafeMath for uint256;
176 
177   mapping (address => uint256) private _balances;
178 
179   mapping (address => mapping (address => uint256)) private _allowed;
180 
181   uint256 private _totalSupply;
182 
183   /**
184   * @dev Total number of tokens in existence
185   */
186   function totalSupply() public view returns (uint256) {
187     return _totalSupply;
188   }
189 
190   /**
191   * @dev Gets the balance of the specified address.
192   * @param owner The address to query the balance of.
193   * @return An uint256 representing the amount owned by the passed address.
194   */
195   function balanceOf(address owner) public view returns (uint256) {
196     return _balances[owner];
197   }
198 
199   /**
200    * @dev Function to check the amount of tokens that an owner allowed to a spender.
201    * @param owner address The address which owns the funds.
202    * @param spender address The address which will spend the funds.
203    * @return A uint256 specifying the amount of tokens still available for the spender.
204    */
205   function allowance(
206     address owner,
207     address spender
208    )
209     public
210     view
211     returns (uint256)
212   {
213     return _allowed[owner][spender];
214   }
215 
216   /**
217   * @dev Transfer token for a specified address
218   * @param to The address to transfer to.
219   * @param value The amount to be transferred.
220   */
221   function transfer(address to, uint256 value) public returns (bool) {
222     _transfer(msg.sender, to, value);
223     return true;
224   }
225 
226   /**
227    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
228    * @param spender The address which will spend the funds.
229    * @param value The amount of tokens to be spent.
230    */
231   function approve(address spender, uint256 value) public returns (bool) {
232     require(spender != address(0));
233 
234     _allowed[msg.sender][spender] = value;
235     emit Approval(msg.sender, spender, value);
236     return true;
237   }
238 
239   /**
240    * @dev Transfer tokens from one address to another
241    * @param from address The address which you want to send tokens from
242    * @param to address The address which you want to transfer to
243    * @param value uint256 the amount of tokens to be transferred
244    */
245   function transferFrom(
246     address from,
247     address to,
248     uint256 value
249   )
250     public
251     returns (bool)
252   {
253     require(value <= _allowed[from][msg.sender]);
254 
255     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
256     _transfer(from, to, value);
257     return true;
258   }
259 
260   /**
261    * @dev Increase the amount of tokens that an owner allowed to a spender.
262    * @param spender The address which will spend the funds.
263    * @param addedValue The amount of tokens to increase the allowance by.
264    */
265   function increaseAllowance(
266     address spender,
267     uint256 addedValue
268   )
269     public
270     returns (bool)
271   {
272     require(spender != address(0));
273 
274     _allowed[msg.sender][spender] = (
275       _allowed[msg.sender][spender].add(addedValue));
276     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
277     return true;
278   }
279 
280   /**
281    * @dev Decrease the amount of tokens that an owner allowed to a spender.
282    * @param spender The address which will spend the funds.
283    * @param subtractedValue The amount of tokens to decrease the allowance by.
284    */
285   function decreaseAllowance(
286     address spender,
287     uint256 subtractedValue
288   )
289     public
290     returns (bool)
291   {
292     require(spender != address(0));
293 
294     _allowed[msg.sender][spender] = (
295       _allowed[msg.sender][spender].sub(subtractedValue));
296     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
297     return true;
298   }
299 
300   /**
301   * @dev Transfer token for a specified addresses
302   * @param from The address to transfer from.
303   * @param to The address to transfer to.
304   * @param value The amount to be transferred.
305   */
306   function _transfer(address from, address to, uint256 value) internal {
307     require(value <= _balances[from]);
308     require(to != address(0));
309 
310     _balances[from] = _balances[from].sub(value);
311     _balances[to] = _balances[to].add(value);
312     emit Transfer(from, to, value);
313   }
314 
315   /**
316    * @dev Internal function that mints an amount of the token and assigns it to
317    * an account. This encapsulates the modification of balances such that the
318    * proper events are emitted.
319    * @param account The account that will receive the created tokens.
320    * @param value The amount that will be created.
321    */
322   function _mint(address account, uint256 value) internal {
323     require(account != 0);
324     _totalSupply = _totalSupply.add(value);
325     _balances[account] = _balances[account].add(value);
326     emit Transfer(address(0), account, value);
327   }
328 
329   /**
330    * @dev Internal function that burns an amount of the token of a given
331    * account.
332    * @param account The account whose tokens will be burnt.
333    * @param value The amount that will be burnt.
334    */
335   function _burn(address account, uint256 value) internal {
336     require(account != 0);
337     require(value <= _balances[account]);
338 
339     _totalSupply = _totalSupply.sub(value);
340     _balances[account] = _balances[account].sub(value);
341     emit Transfer(account, address(0), value);
342   }
343 
344   /**
345    * @dev Internal function that burns an amount of the token of a given
346    * account, deducting from the sender's allowance for said account. Uses the
347    * internal burn function.
348    * @param account The account whose tokens will be burnt.
349    * @param value The amount that will be burnt.
350    */
351   function _burnFrom(address account, uint256 value) internal {
352     require(value <= _allowed[account][msg.sender]);
353     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
354       value);
355     _burn(account, value);
356   }
357 }
358 
359 /**
360  * @title DetailedERC20 token
361  * @dev The decimals are only for visualization purposes.
362  * All the operations are done using the smallest and indivisible token unit,
363  * just as on Ethereum all the operations are done in wei.
364  */
365 contract DetailedERC20 is ERC20 {
366   string public name = "Genesis Finote";
367   string public symbol= "GXFN";
368   uint8 public decimals= 18;
369 
370 }
371 
372 /**
373  * @title Roles
374  * @dev Library for managing addresses assigned to a Role.
375  */
376 library Roles {
377   struct Role {
378     mapping (address => bool) bearer;
379   }
380 
381   /**
382    * @dev give an account access to this role
383    */
384   function add(Role storage role, address account) internal {
385     require(account != address(0));
386     require(!has(role, account));
387 
388     role.bearer[account] = true;
389   }
390 
391   /**
392    * @dev remove an account's access to this role
393    */
394   function remove(Role storage role, address account) internal {
395     require(account != address(0));
396     require(has(role, account));
397 
398     role.bearer[account] = false;
399   }
400 
401   /**
402    * @dev check if an account has this role
403    * @return bool
404    */
405   function has(Role storage role, address account)
406     internal
407     view
408     returns (bool)
409   {
410     require(account != address(0));
411     return role.bearer[account];
412   }
413 }
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
455 contract PauserRole {
456   using Roles for Roles.Role;
457 
458   event PauserAdded(address indexed account);
459   event PauserRemoved(address indexed account);
460 
461   Roles.Role private pausers;
462 
463   constructor() internal {
464     _addPauser(msg.sender);
465   }
466 
467   modifier onlyPauser() {
468     require(isPauser(msg.sender));
469     _;
470   }
471 
472   function isPauser(address account) public view returns (bool) {
473     return pausers.has(account);
474   }
475 
476   function addPauser(address account) public onlyPauser {
477     _addPauser(account);
478   }
479 
480   function renouncePauser() public {
481     _removePauser(msg.sender);
482   }
483 
484   function _addPauser(address account) internal {
485     pausers.add(account);
486     emit PauserAdded(account);
487   }
488 
489   function _removePauser(address account) internal {
490     pausers.remove(account);
491     emit PauserRemoved(account);
492   }
493 }
494 
495 /**
496  * @title ERC20Mintable
497  * @dev ERC20 minting logic
498  */
499 contract ERC20Mintable is DetailedERC20, MinterRole {
500   /**
501    * @dev Function to mint tokens
502    * @param to The address that will receive the minted tokens.
503    * @param value The amount of tokens to mint.
504    * @return A boolean that indicates if the operation was successful.
505    */
506   function mint(
507     address to,
508     uint256 value
509   )
510     public
511     onlyMinter
512     returns (bool)
513   {
514     _mint(to, value);
515     return true;
516   }
517 }
518 
519 /**
520  * @title Pausable
521  * @dev Base contract which allows children to implement an emergency stop mechanism.
522  */
523 contract Pausable is PauserRole {
524   event Paused(address account);
525   event Unpaused(address account);
526 
527   bool private _paused;
528 
529   constructor() internal {
530     _paused = false;
531   }
532 
533   /**
534    * @return true if the contract is paused, false otherwise.
535    */
536   function paused() public view returns(bool) {
537     return _paused;
538   }
539 
540   /**
541    * @dev Modifier to make a function callable only when the contract is not paused.
542    */
543   modifier whenNotPaused() {
544     require(!_paused);
545     _;
546   }
547 
548   /**
549    * @dev Modifier to make a function callable only when the contract is paused.
550    */
551   modifier whenPaused() {
552     require(_paused);
553     _;
554   }
555 
556   /**
557    * @dev called by the owner to pause, triggers stopped state
558    */
559   function pause() public onlyPauser whenNotPaused {
560     _paused = true;
561     emit Paused(msg.sender);
562   }
563 
564   /**
565    * @dev called by the owner to unpause, returns to normal state
566    */
567   function unpause() public onlyPauser whenPaused {
568     _paused = false;
569     emit Unpaused(msg.sender);
570   }
571 }
572 
573 /**
574  * @title Pausable token
575  * @dev ERC20 modified with pausable transfers.
576  **/
577 contract ERC20Pausable is ERC20Mintable, Pausable, Ownable {
578 
579   function transfer(
580     address to,
581     uint256 value
582   )
583     public
584     whenNotPaused
585     returns (bool)
586   {
587     return super.transfer(to, value);
588   }
589 
590   function transferFrom(
591     address from,
592     address to,
593     uint256 value
594   )
595     public
596     whenNotPaused
597     returns (bool)
598   {
599     return super.transferFrom(from, to, value);
600   }
601 
602   function approve(
603     address spender,
604     uint256 value
605   )
606     public
607     whenNotPaused
608     returns (bool)
609   {
610     return super.approve(spender, value);
611   }
612 
613   function increaseAllowance(
614     address spender,
615     uint addedValue
616   )
617     public
618     whenNotPaused
619     returns (bool success)
620   {
621     return super.increaseAllowance(spender, addedValue);
622   }
623 
624   function decreaseAllowance(
625     address spender,
626     uint subtractedValue
627   )
628     public
629     whenNotPaused
630     returns (bool success)
631   {
632     return super.decreaseAllowance(spender, subtractedValue);
633   }
634 }