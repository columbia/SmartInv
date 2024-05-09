1 pragma solidity ^0.4.24;
2 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
3 
4 
5 
6 /**
7  * @title ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/20
9  */
10 interface IERC20 {
11   function totalSupply() external view returns (uint256);
12 
13   function balanceOf(address who) external view returns (uint256);
14 
15   function allowance(address owner, address spender)
16     external view returns (uint256);
17 
18   function transfer(address to, uint256 value) external returns (bool);
19 
20   function approve(address spender, uint256 value)
21     external returns (bool);
22 
23   function transferFrom(address from, address to, uint256 value)
24     external returns (bool);
25 
26   event Transfer(
27     address indexed from,
28     address indexed to,
29     uint256 value
30   );
31 
32   event Approval(
33     address indexed owner,
34     address indexed spender,
35     uint256 value
36   );
37 }
38 
39 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
40 
41 
42 
43 
44 /**
45  * @title ERC20Detailed token
46  * @dev The decimals are only for visualization purposes.
47  * All the operations are done using the smallest and indivisible token unit,
48  * just as on Ethereum all the operations are done in wei.
49  */
50 contract ERC20Detailed is IERC20 {
51   string private _name;
52   string private _symbol;
53   uint8 private _decimals;
54 
55   constructor(string name, string symbol, uint8 decimals) public {
56     _name = name;
57     _symbol = symbol;
58     _decimals = decimals;
59   }
60 
61   /**
62    * @return the name of the token.
63    */
64   function name() public view returns(string) {
65     return _name;
66   }
67 
68   /**
69    * @return the symbol of the token.
70    */
71   function symbol() public view returns(string) {
72     return _symbol;
73   }
74 
75   /**
76    * @return the number of decimals of the token.
77    */
78   function decimals() public view returns(uint8) {
79     return _decimals;
80   }
81 }
82 
83 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
84 
85 
86 
87 /**
88  * @title SafeMath
89  * @dev Math operations with safety checks that revert on error
90  */
91 library SafeMath {
92 
93   /**
94   * @dev Multiplies two numbers, reverts on overflow.
95   */
96   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
97     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
98     // benefit is lost if 'b' is also tested.
99     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
100     if (a == 0) {
101       return 0;
102     }
103 
104     uint256 c = a * b;
105     require(c / a == b);
106 
107     return c;
108   }
109 
110   /**
111   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
112   */
113   function div(uint256 a, uint256 b) internal pure returns (uint256) {
114     require(b > 0); // Solidity only automatically asserts when dividing by 0
115     uint256 c = a / b;
116     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
117 
118     return c;
119   }
120 
121   /**
122   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
123   */
124   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
125     require(b <= a);
126     uint256 c = a - b;
127 
128     return c;
129   }
130 
131   /**
132   * @dev Adds two numbers, reverts on overflow.
133   */
134   function add(uint256 a, uint256 b) internal pure returns (uint256) {
135     uint256 c = a + b;
136     require(c >= a);
137 
138     return c;
139   }
140 
141   /**
142   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
143   * reverts when dividing by zero.
144   */
145   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
146     require(b != 0);
147     return a % b;
148   }
149 }
150 
151 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
152 
153 
154 
155 
156 
157 /**
158  * @title Standard ERC20 token
159  *
160  * @dev Implementation of the basic standard token.
161  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
162  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
163  */
164 contract ERC20 is IERC20 {
165   using SafeMath for uint256;
166 
167   mapping (address => uint256) private _balances;
168 
169   mapping (address => mapping (address => uint256)) private _allowed;
170 
171   uint256 private _totalSupply;
172 
173   /**
174   * @dev Total number of tokens in existence
175   */
176   function totalSupply() public view returns (uint256) {
177     return _totalSupply;
178   }
179 
180   /**
181   * @dev Gets the balance of the specified address.
182   * @param owner The address to query the balance of.
183   * @return An uint256 representing the amount owned by the passed address.
184   */
185   function balanceOf(address owner) public view returns (uint256) {
186     return _balances[owner];
187   }
188 
189   /**
190    * @dev Function to check the amount of tokens that an owner allowed to a spender.
191    * @param owner address The address which owns the funds.
192    * @param spender address The address which will spend the funds.
193    * @return A uint256 specifying the amount of tokens still available for the spender.
194    */
195   function allowance(
196     address owner,
197     address spender
198    )
199     public
200     view
201     returns (uint256)
202   {
203     return _allowed[owner][spender];
204   }
205 
206   /**
207   * @dev Transfer token for a specified address
208   * @param to The address to transfer to.
209   * @param value The amount to be transferred.
210   */
211   function transfer(address to, uint256 value) public returns (bool) {
212     _transfer(msg.sender, to, value);
213     return true;
214   }
215 
216   /**
217    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
218    * Beware that changing an allowance with this method brings the risk that someone may use both the old
219    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
220    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
221    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
222    * @param spender The address which will spend the funds.
223    * @param value The amount of tokens to be spent.
224    */
225   function approve(address spender, uint256 value) public returns (bool) {
226     require(spender != address(0));
227 
228     _allowed[msg.sender][spender] = value;
229     emit Approval(msg.sender, spender, value);
230     return true;
231   }
232 
233   /**
234    * @dev Transfer tokens from one address to another
235    * @param from address The address which you want to send tokens from
236    * @param to address The address which you want to transfer to
237    * @param value uint256 the amount of tokens to be transferred
238    */
239   function transferFrom(
240     address from,
241     address to,
242     uint256 value
243   )
244     public
245     returns (bool)
246   {
247     require(value <= _allowed[from][msg.sender]);
248 
249     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
250     _transfer(from, to, value);
251     return true;
252   }
253 
254   /**
255    * @dev Increase the amount of tokens that an owner allowed to a spender.
256    * approve should be called when allowed_[_spender] == 0. To increment
257    * allowed value is better to use this function to avoid 2 calls (and wait until
258    * the first transaction is mined)
259    * From MonolithDAO Token.sol
260    * @param spender The address which will spend the funds.
261    * @param addedValue The amount of tokens to increase the allowance by.
262    */
263   function increaseAllowance(
264     address spender,
265     uint256 addedValue
266   )
267     public
268     returns (bool)
269   {
270     require(spender != address(0));
271 
272     _allowed[msg.sender][spender] = (
273       _allowed[msg.sender][spender].add(addedValue));
274     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
275     return true;
276   }
277 
278   /**
279    * @dev Decrease the amount of tokens that an owner allowed to a spender.
280    * approve should be called when allowed_[_spender] == 0. To decrement
281    * allowed value is better to use this function to avoid 2 calls (and wait until
282    * the first transaction is mined)
283    * From MonolithDAO Token.sol
284    * @param spender The address which will spend the funds.
285    * @param subtractedValue The amount of tokens to decrease the allowance by.
286    */
287   function decreaseAllowance(
288     address spender,
289     uint256 subtractedValue
290   )
291     public
292     returns (bool)
293   {
294     require(spender != address(0));
295 
296     _allowed[msg.sender][spender] = (
297       _allowed[msg.sender][spender].sub(subtractedValue));
298     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
299     return true;
300   }
301 
302   /**
303   * @dev Transfer token for a specified addresses
304   * @param from The address to transfer from.
305   * @param to The address to transfer to.
306   * @param value The amount to be transferred.
307   */
308   function _transfer(address from, address to, uint256 value) internal {
309     require(value <= _balances[from]);
310     require(to != address(0));
311 
312     _balances[from] = _balances[from].sub(value);
313     _balances[to] = _balances[to].add(value);
314     emit Transfer(from, to, value);
315   }
316 
317   /**
318    * @dev Internal function that mints an amount of the token and assigns it to
319    * an account. This encapsulates the modification of balances such that the
320    * proper events are emitted.
321    * @param account The account that will receive the created tokens.
322    * @param value The amount that will be created.
323    */
324   function _mint(address account, uint256 value) internal {
325     require(account != 0);
326     _totalSupply = _totalSupply.add(value);
327     _balances[account] = _balances[account].add(value);
328     emit Transfer(address(0), account, value);
329   }
330 
331   /**
332    * @dev Internal function that burns an amount of the token of a given
333    * account.
334    * @param account The account whose tokens will be burnt.
335    * @param value The amount that will be burnt.
336    */
337   function _burn(address account, uint256 value) internal {
338     require(account != 0);
339     require(value <= _balances[account]);
340 
341     _totalSupply = _totalSupply.sub(value);
342     _balances[account] = _balances[account].sub(value);
343     emit Transfer(account, address(0), value);
344   }
345 
346   /**
347    * @dev Internal function that burns an amount of the token of a given
348    * account, deducting from the sender's allowance for said account. Uses the
349    * internal burn function.
350    * @param account The account whose tokens will be burnt.
351    * @param value The amount that will be burnt.
352    */
353   function _burnFrom(address account, uint256 value) internal {
354     require(value <= _allowed[account][msg.sender]);
355 
356     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
357     // this function needs to emit an event with the updated approval.
358     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
359       value);
360     _burn(account, value);
361   }
362 }
363 
364 // File: openzeppelin-solidity/contracts/access/Roles.sol
365 
366 
367 
368 /**
369  * @title Roles
370  * @dev Library for managing addresses assigned to a Role.
371  */
372 library Roles {
373   struct Role {
374     mapping (address => bool) bearer;
375   }
376 
377   /**
378    * @dev give an account access to this role
379    */
380   function add(Role storage role, address account) internal {
381     require(account != address(0));
382     require(!has(role, account));
383 
384     role.bearer[account] = true;
385   }
386 
387   /**
388    * @dev remove an account's access to this role
389    */
390   function remove(Role storage role, address account) internal {
391     require(account != address(0));
392     require(has(role, account));
393 
394     role.bearer[account] = false;
395   }
396 
397   /**
398    * @dev check if an account has this role
399    * @return bool
400    */
401   function has(Role storage role, address account)
402     internal
403     view
404     returns (bool)
405   {
406     require(account != address(0));
407     return role.bearer[account];
408   }
409 }
410 
411 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
412 
413 
414 
415 
416 contract PauserRole {
417   using Roles for Roles.Role;
418 
419   event PauserAdded(address indexed account);
420   event PauserRemoved(address indexed account);
421 
422   Roles.Role private pausers;
423 
424   constructor() internal {
425     _addPauser(msg.sender);
426   }
427 
428   modifier onlyPauser() {
429     require(isPauser(msg.sender));
430     _;
431   }
432 
433   function isPauser(address account) public view returns (bool) {
434     return pausers.has(account);
435   }
436 
437   function addPauser(address account) public onlyPauser {
438     _addPauser(account);
439   }
440 
441   function renouncePauser() public {
442     _removePauser(msg.sender);
443   }
444 
445   function _addPauser(address account) internal {
446     pausers.add(account);
447     emit PauserAdded(account);
448   }
449 
450   function _removePauser(address account) internal {
451     pausers.remove(account);
452     emit PauserRemoved(account);
453   }
454 }
455 
456 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
457 
458 
459 
460 
461 /**
462  * @title Pausable
463  * @dev Base contract which allows children to implement an emergency stop mechanism.
464  */
465 contract Pausable is PauserRole {
466   event Paused(address account);
467   event Unpaused(address account);
468 
469   bool private _paused;
470 
471   constructor() internal {
472     _paused = false;
473   }
474 
475   /**
476    * @return true if the contract is paused, false otherwise.
477    */
478   function paused() public view returns(bool) {
479     return _paused;
480   }
481 
482   /**
483    * @dev Modifier to make a function callable only when the contract is not paused.
484    */
485   modifier whenNotPaused() {
486     require(!_paused);
487     _;
488   }
489 
490   /**
491    * @dev Modifier to make a function callable only when the contract is paused.
492    */
493   modifier whenPaused() {
494     require(_paused);
495     _;
496   }
497 
498   /**
499    * @dev called by the owner to pause, triggers stopped state
500    */
501   function pause() public onlyPauser whenNotPaused {
502     _paused = true;
503     emit Paused(msg.sender);
504   }
505 
506   /**
507    * @dev called by the owner to unpause, returns to normal state
508    */
509   function unpause() public onlyPauser whenPaused {
510     _paused = false;
511     emit Unpaused(msg.sender);
512   }
513 }
514 
515 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Pausable.sol
516 
517 
518 
519 
520 
521 /**
522  * @title Pausable token
523  * @dev ERC20 modified with pausable transfers.
524  **/
525 contract ERC20Pausable is ERC20, Pausable {
526 
527   function transfer(
528     address to,
529     uint256 value
530   )
531     public
532     whenNotPaused
533     returns (bool)
534   {
535     return super.transfer(to, value);
536   }
537 
538   function transferFrom(
539     address from,
540     address to,
541     uint256 value
542   )
543     public
544     whenNotPaused
545     returns (bool)
546   {
547     return super.transferFrom(from, to, value);
548   }
549 
550   function approve(
551     address spender,
552     uint256 value
553   )
554     public
555     whenNotPaused
556     returns (bool)
557   {
558     return super.approve(spender, value);
559   }
560 
561   function increaseAllowance(
562     address spender,
563     uint addedValue
564   )
565     public
566     whenNotPaused
567     returns (bool success)
568   {
569     return super.increaseAllowance(spender, addedValue);
570   }
571 
572   function decreaseAllowance(
573     address spender,
574     uint subtractedValue
575   )
576     public
577     whenNotPaused
578     returns (bool success)
579   {
580     return super.decreaseAllowance(spender, subtractedValue);
581   }
582 }
583 
584 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol
585 
586 
587 
588 
589 /**
590  * @title Burnable Token
591  * @dev Token that can be irreversibly burned (destroyed).
592  */
593 contract ERC20Burnable is ERC20 {
594 
595   /**
596    * @dev Burns a specific amount of tokens.
597    * @param value The amount of token to be burned.
598    */
599   function burn(uint256 value) public {
600     _burn(msg.sender, value);
601   }
602 
603   /**
604    * @dev Burns a specific amount of tokens from the target address and decrements allowance
605    * @param from address The address which you want to send tokens from
606    * @param value uint256 The amount of token to be burned
607    */
608   function burnFrom(address from, uint256 value) public {
609     _burnFrom(from, value);
610   }
611 }
612 
613 // File: contracts/token/CelebPlusToken.sol
614 
615 
616 
617 
618 
619 
620 
621 contract CelebPlusToken is ERC20Detailed, ERC20Pausable, ERC20Burnable {
622   /**
623    * @dev constructor to mint initial tokens
624    * @param name string
625    * @param symbol string
626    * @param decimals uint8
627    * @param initialSupply uint256
628    */
629   constructor(
630     string name,
631     string symbol,
632     uint8 decimals,
633     uint256 initialSupply
634   )
635     ERC20Detailed(name, symbol, decimals)
636     public
637   {
638     // Mint the initial supply
639     require(initialSupply > 0, "initialSupply must be greater than zero.");
640     _mint(msg.sender, initialSupply * (10 ** uint256(decimals)));
641   }
642 }