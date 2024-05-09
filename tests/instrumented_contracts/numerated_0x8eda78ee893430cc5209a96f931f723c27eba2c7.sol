1 pragma solidity ^0.4.25;
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
36 /**
37  * @title SafeMath
38  * @dev Math operations with safety checks that revert on error
39  */
40 library SafeMath {
41 
42   /**
43   * @dev Multiplies two numbers, reverts on overflow.
44   */
45   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
46     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
47     // benefit is lost if 'b' is also tested.
48     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
49     if (a == 0) {
50       return 0;
51     }
52 
53     uint256 c = a * b;
54     require(c / a == b);
55 
56     return c;
57   }
58 
59   /**
60   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
61   */
62   function div(uint256 a, uint256 b) internal pure returns (uint256) {
63     require(b > 0); // Solidity only automatically asserts when dividing by 0
64     uint256 c = a / b;
65     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
66 
67     return c;
68   }
69 
70   /**
71   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
72   */
73   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
74     require(b <= a);
75     uint256 c = a - b;
76 
77     return c;
78   }
79 
80   /**
81   * @dev Adds two numbers, reverts on overflow.
82   */
83   function add(uint256 a, uint256 b) internal pure returns (uint256) {
84     uint256 c = a + b;
85     require(c >= a);
86 
87     return c;
88   }
89 
90   /**
91   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
92   * reverts when dividing by zero.
93   */
94   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
95     require(b != 0);
96     return a % b;
97   }
98 }
99 
100 /**
101  * @title Standard ERC20 token
102  *
103  * @dev Implementation of the basic standard token.
104  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
105  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
106  */
107 contract ERC20 is IERC20 {
108   using SafeMath for uint256;
109 
110   mapping (address => uint256) private _balances;
111 
112   mapping (address => mapping (address => uint256)) private _allowed;
113 
114   uint256 private _totalSupply;
115 
116   /**
117   * @dev Total number of tokens in existence
118   */
119   function totalSupply() public view returns (uint256) {
120     return _totalSupply;
121   }
122 
123   /**
124   * @dev Gets the balance of the specified address.
125   * @param owner The address to query the balance of.
126   * @return An uint256 representing the amount owned by the passed address.
127   */
128   function balanceOf(address owner) public view returns (uint256) {
129     return _balances[owner];
130   }
131 
132   /**
133    * @dev Function to check the amount of tokens that an owner allowed to a spender.
134    * @param owner address The address which owns the funds.
135    * @param spender address The address which will spend the funds.
136    * @return A uint256 specifying the amount of tokens still available for the spender.
137    */
138   function allowance(
139     address owner,
140     address spender
141    )
142     public
143     view
144     returns (uint256)
145   {
146     return _allowed[owner][spender];
147   }
148 
149   /**
150   * @dev Transfer token for a specified address
151   * @param to The address to transfer to.
152   * @param value The amount to be transferred.
153   */
154   function transfer(address to, uint256 value) public returns (bool) {
155     _transfer(msg.sender, to, value);
156     return true;
157   }
158 
159   /**
160    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
161    * Beware that changing an allowance with this method brings the risk that someone may use both the old
162    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
163    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
164    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
165    * @param spender The address which will spend the funds.
166    * @param value The amount of tokens to be spent.
167    */
168   function approve(address spender, uint256 value) public returns (bool) {
169     require(spender != address(0));
170 
171     _allowed[msg.sender][spender] = value;
172     emit Approval(msg.sender, spender, value);
173     return true;
174   }
175 
176   /**
177    * @dev Transfer tokens from one address to another
178    * @param from address The address which you want to send tokens from
179    * @param to address The address which you want to transfer to
180    * @param value uint256 the amount of tokens to be transferred
181    */
182   function transferFrom(
183     address from,
184     address to,
185     uint256 value
186   )
187     public
188     returns (bool)
189   {
190     require(value <= _allowed[from][msg.sender]);
191 
192     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
193     _transfer(from, to, value);
194     return true;
195   }
196 
197   /**
198    * @dev Increase the amount of tokens that an owner allowed to a spender.
199    * approve should be called when allowed_[_spender] == 0. To increment
200    * allowed value is better to use this function to avoid 2 calls (and wait until
201    * the first transaction is mined)
202    * From MonolithDAO Token.sol
203    * @param spender The address which will spend the funds.
204    * @param addedValue The amount of tokens to increase the allowance by.
205    */
206   function increaseAllowance(
207     address spender,
208     uint256 addedValue
209   )
210     public
211     returns (bool)
212   {
213     require(spender != address(0));
214 
215     _allowed[msg.sender][spender] = (
216       _allowed[msg.sender][spender].add(addedValue));
217     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
218     return true;
219   }
220 
221   /**
222    * @dev Decrease the amount of tokens that an owner allowed to a spender.
223    * approve should be called when allowed_[_spender] == 0. To decrement
224    * allowed value is better to use this function to avoid 2 calls (and wait until
225    * the first transaction is mined)
226    * From MonolithDAO Token.sol
227    * @param spender The address which will spend the funds.
228    * @param subtractedValue The amount of tokens to decrease the allowance by.
229    */
230   function decreaseAllowance(
231     address spender,
232     uint256 subtractedValue
233   )
234     public
235     returns (bool)
236   {
237     require(spender != address(0));
238 
239     _allowed[msg.sender][spender] = (
240       _allowed[msg.sender][spender].sub(subtractedValue));
241     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
242     return true;
243   }
244 
245   /**
246   * @dev Transfer token for a specified addresses
247   * @param from The address to transfer from.
248   * @param to The address to transfer to.
249   * @param value The amount to be transferred.
250   */
251   function _transfer(address from, address to, uint256 value) internal {
252     require(value <= _balances[from]);
253     require(to != address(0));
254 
255     _balances[from] = _balances[from].sub(value);
256     _balances[to] = _balances[to].add(value);
257     emit Transfer(from, to, value);
258   }
259 
260   /**
261    * @dev Internal function that mints an amount of the token and assigns it to
262    * an account. This encapsulates the modification of balances such that the
263    * proper events are emitted.
264    * @param account The account that will receive the created tokens.
265    * @param value The amount that will be created.
266    */
267   function _mint(address account, uint256 value) internal {
268     require(account != 0);
269     _totalSupply = _totalSupply.add(value);
270     _balances[account] = _balances[account].add(value);
271     emit Transfer(address(0), account, value);
272   }
273 
274   /**
275    * @dev Internal function that burns an amount of the token of a given
276    * account.
277    * @param account The account whose tokens will be burnt.
278    * @param value The amount that will be burnt.
279    */
280   function _burn(address account, uint256 value) internal {
281     require(account != 0);
282     require(value <= _balances[account]);
283 
284     _totalSupply = _totalSupply.sub(value);
285     _balances[account] = _balances[account].sub(value);
286     emit Transfer(account, address(0), value);
287   }
288 
289   /**
290    * @dev Internal function that burns an amount of the token of a given
291    * account, deducting from the sender's allowance for said account. Uses the
292    * internal burn function.
293    * @param account The account whose tokens will be burnt.
294    * @param value The amount that will be burnt.
295    */
296   function _burnFrom(address account, uint256 value) internal {
297     require(value <= _allowed[account][msg.sender]);
298 
299     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
300     // this function needs to emit an event with the updated approval.
301     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
302       value);
303     _burn(account, value);
304   }
305 }
306 
307 
308 /**
309  * @title Roles
310  * @dev Library for managing addresses assigned to a Role.
311  */
312 library Roles {
313   struct Role {
314     mapping (address => bool) bearer;
315   }
316 
317   /**
318    * @dev give an account access to this role
319    */
320   function add(Role storage role, address account) internal {
321     require(account != address(0));
322     require(!has(role, account));
323 
324     role.bearer[account] = true;
325   }
326 
327   /**
328    * @dev remove an account's access to this role
329    */
330   function remove(Role storage role, address account) internal {
331     require(account != address(0));
332     require(has(role, account));
333 
334     role.bearer[account] = false;
335   }
336 
337   /**
338    * @dev check if an account has this role
339    * @return bool
340    */
341   function has(Role storage role, address account)
342     internal
343     view
344     returns (bool)
345   {
346     require(account != address(0));
347     return role.bearer[account];
348   }
349 }
350 
351 contract PauserRole {
352   using Roles for Roles.Role;
353 
354   event PauserAdded(address indexed account);
355   event PauserRemoved(address indexed account);
356 
357   Roles.Role private pausers;
358 
359   constructor() internal {
360     _addPauser(msg.sender);
361   }
362 
363   modifier onlyPauser() {
364     require(isPauser(msg.sender));
365     _;
366   }
367 
368   function isPauser(address account) public view returns (bool) {
369     return pausers.has(account);
370   }
371 
372   function addPauser(address account) public onlyPauser {
373     _addPauser(account);
374   }
375 
376   function renouncePauser() public {
377     _removePauser(msg.sender);
378   }
379 
380   function _addPauser(address account) internal {
381     pausers.add(account);
382     emit PauserAdded(account);
383   }
384 
385   function _removePauser(address account) internal {
386     pausers.remove(account);
387     emit PauserRemoved(account);
388   }
389 }
390 
391 /**
392  * @title Pausable
393  * @dev Base contract which allows children to implement an emergency stop mechanism.
394  */
395 contract Pausable is PauserRole {
396   event Paused(address account);
397   event Unpaused(address account);
398 
399   bool private _paused;
400 
401   constructor() internal {
402     _paused = false;
403   }
404 
405   /**
406    * @return true if the contract is paused, false otherwise.
407    */
408   function paused() public view returns(bool) {
409     return _paused;
410   }
411 
412   /**
413    * @dev Modifier to make a function callable only when the contract is not paused.
414    */
415   modifier whenNotPaused() {
416     require(!_paused);
417     _;
418   }
419 
420   /**
421    * @dev Modifier to make a function callable only when the contract is paused.
422    */
423   modifier whenPaused() {
424     require(_paused);
425     _;
426   }
427 
428   /**
429    * @dev called by the owner to pause, triggers stopped state
430    */
431   function pause() public onlyPauser whenNotPaused {
432     _paused = true;
433     emit Paused(msg.sender);
434   }
435 
436   /**
437    * @dev called by the owner to unpause, returns to normal state
438    */
439   function unpause() public onlyPauser whenPaused {
440     _paused = false;
441     emit Unpaused(msg.sender);
442   }
443 }
444 
445 /**
446  * @title Pausable token
447  * @dev ERC20 modified with pausable transfers.
448  **/
449 contract ERC20Pausable is ERC20, Pausable {
450 
451   function transfer(
452     address to,
453     uint256 value
454   )
455     public
456     whenNotPaused
457     returns (bool)
458   {
459     return super.transfer(to, value);
460   }
461 
462   function transferFrom(
463     address from,
464     address to,
465     uint256 value
466   )
467     public
468     whenNotPaused
469     returns (bool)
470   {
471     return super.transferFrom(from, to, value);
472   }
473 
474   function approve(
475     address spender,
476     uint256 value
477   )
478     public
479     whenNotPaused
480     returns (bool)
481   {
482     return super.approve(spender, value);
483   }
484 
485   function increaseAllowance(
486     address spender,
487     uint addedValue
488   )
489     public
490     whenNotPaused
491     returns (bool success)
492   {
493     return super.increaseAllowance(spender, addedValue);
494   }
495 
496   function decreaseAllowance(
497     address spender,
498     uint subtractedValue
499   )
500     public
501     whenNotPaused
502     returns (bool success)
503   {
504     return super.decreaseAllowance(spender, subtractedValue);
505   }
506 }
507 
508 
509 contract MinterRole {
510   using Roles for Roles.Role;
511 
512   event MinterAdded(address indexed account);
513   event MinterRemoved(address indexed account);
514 
515   Roles.Role private minters;
516 
517   constructor() internal {
518     _addMinter(msg.sender);
519   }
520 
521   modifier onlyMinter() {
522     require(isMinter(msg.sender));
523     _;
524   }
525 
526   function isMinter(address account) public view returns (bool) {
527     return minters.has(account);
528   }
529 
530   function addMinter(address account) public onlyMinter {
531     _addMinter(account);
532   }
533 
534   function renounceMinter() public {
535     _removeMinter(msg.sender);
536   }
537 
538   function _addMinter(address account) internal {
539     minters.add(account);
540     emit MinterAdded(account);
541   }
542 
543   function _removeMinter(address account) internal {
544     minters.remove(account);
545     emit MinterRemoved(account);
546   }
547 }
548 
549 /**
550  * @title ERC20Mintable
551  * @dev ERC20 minting logic
552  */
553 contract ERC20Mintable is ERC20, MinterRole {
554   /**
555    * @dev Function to mint tokens
556    * @param to The address that will receive the minted tokens.
557    * @param value The amount of tokens to mint.
558    * @return A boolean that indicates if the operation was successful.
559    */
560   function mint(
561     address to,
562     uint256 value
563   )
564     public
565     onlyMinter
566     returns (bool)
567   {
568     _mint(to, value);
569     return true;
570   }
571 }
572 
573 contract pcpi is ERC20Pausable, ERC20Mintable {
574 
575   string public constant name = "preCharge";
576   string public constant symbol = "pcpi";
577   uint8 public constant decimals = 18;
578 
579 }