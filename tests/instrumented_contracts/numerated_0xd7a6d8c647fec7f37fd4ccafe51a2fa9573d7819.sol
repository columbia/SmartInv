1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that revert on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, reverts on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     uint256 c = a * b;
23     require(c / a == b);
24 
25     return c;
26   }
27 
28   /**
29   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
30   */
31   function div(uint256 a, uint256 b) internal pure returns (uint256) {
32     require(b > 0); // Solidity only automatically asserts when dividing by 0
33     uint256 c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36     return c;
37   }
38 
39   /**
40   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41   */
42   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43     require(b <= a);
44     uint256 c = a - b;
45 
46     return c;
47   }
48 
49   /**
50   * @dev Adds two numbers, reverts on overflow.
51   */
52   function add(uint256 a, uint256 b) internal pure returns (uint256) {
53     uint256 c = a + b;
54     require(c >= a);
55 
56     return c;
57   }
58 
59   /**
60   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
61   * reverts when dividing by zero.
62   */
63   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64     require(b != 0);
65     return a % b;
66   }
67 }
68 
69 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
70 
71 /**
72  * @title ERC20 interface
73  * @dev see https://github.com/ethereum/EIPs/issues/20
74  */
75 interface IERC20 {
76   function totalSupply() external view returns (uint256);
77 
78   function balanceOf(address who) external view returns (uint256);
79 
80   function allowance(address owner, address spender)
81     external view returns (uint256);
82 
83   function transfer(address to, uint256 value) external returns (bool);
84 
85   function approve(address spender, uint256 value)
86     external returns (bool);
87 
88   function transferFrom(address from, address to, uint256 value)
89     external returns (bool);
90 
91   event Transfer(
92     address indexed from,
93     address indexed to,
94     uint256 value
95   );
96 
97   event Approval(
98     address indexed owner,
99     address indexed spender,
100     uint256 value
101   );
102 }
103 
104 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
105 
106 /**
107  * @title Standard ERC20 token
108  *
109  * @dev Implementation of the basic standard token.
110  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
111  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
112  */
113 contract ERC20 is IERC20 {
114   using SafeMath for uint256;
115 
116   mapping (address => uint256) private _balances;
117 
118   mapping (address => mapping (address => uint256)) private _allowed;
119 
120   uint256 private _totalSupply;
121 
122   /**
123   * @dev Total number of tokens in existence
124   */
125   function totalSupply() public view returns (uint256) {
126     return _totalSupply;
127   }
128 
129   /**
130   * @dev Gets the balance of the specified address.
131   * @param owner The address to query the balance of.
132   * @return An uint256 representing the amount owned by the passed address.
133   */
134   function balanceOf(address owner) public view returns (uint256) {
135     return _balances[owner];
136   }
137 
138   /**
139    * @dev Function to check the amount of tokens that an owner allowed to a spender.
140    * @param owner address The address which owns the funds.
141    * @param spender address The address which will spend the funds.
142    * @return A uint256 specifying the amount of tokens still available for the spender.
143    */
144   function allowance(
145     address owner,
146     address spender
147    )
148     public
149     view
150     returns (uint256)
151   {
152     return _allowed[owner][spender];
153   }
154 
155   /**
156   * @dev Transfer token for a specified address
157   * @param to The address to transfer to.
158   * @param value The amount to be transferred.
159   */
160   function transfer(address to, uint256 value) public returns (bool) {
161     _transfer(msg.sender, to, value);
162     return true;
163   }
164 
165   /**
166    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
167    * Beware that changing an allowance with this method brings the risk that someone may use both the old
168    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
169    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
170    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
171    * @param spender The address which will spend the funds.
172    * @param value The amount of tokens to be spent.
173    */
174   function approve(address spender, uint256 value) public returns (bool) {
175     require(spender != address(0));
176 
177     _allowed[msg.sender][spender] = value;
178     emit Approval(msg.sender, spender, value);
179     return true;
180   }
181 
182   /**
183    * @dev Transfer tokens from one address to another
184    * @param from address The address which you want to send tokens from
185    * @param to address The address which you want to transfer to
186    * @param value uint256 the amount of tokens to be transferred
187    */
188   function transferFrom(
189     address from,
190     address to,
191     uint256 value
192   )
193     public
194     returns (bool)
195   {
196     require(value <= _allowed[from][msg.sender]);
197 
198     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
199     _transfer(from, to, value);
200     return true;
201   }
202 
203   /**
204    * @dev Increase the amount of tokens that an owner allowed to a spender.
205    * approve should be called when allowed_[_spender] == 0. To increment
206    * allowed value is better to use this function to avoid 2 calls (and wait until
207    * the first transaction is mined)
208    * From MonolithDAO Token.sol
209    * @param spender The address which will spend the funds.
210    * @param addedValue The amount of tokens to increase the allowance by.
211    */
212   function increaseAllowance(
213     address spender,
214     uint256 addedValue
215   )
216     public
217     returns (bool)
218   {
219     require(spender != address(0));
220 
221     _allowed[msg.sender][spender] = (
222       _allowed[msg.sender][spender].add(addedValue));
223     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
224     return true;
225   }
226 
227   /**
228    * @dev Decrease the amount of tokens that an owner allowed to a spender.
229    * approve should be called when allowed_[_spender] == 0. To decrement
230    * allowed value is better to use this function to avoid 2 calls (and wait until
231    * the first transaction is mined)
232    * From MonolithDAO Token.sol
233    * @param spender The address which will spend the funds.
234    * @param subtractedValue The amount of tokens to decrease the allowance by.
235    */
236   function decreaseAllowance(
237     address spender,
238     uint256 subtractedValue
239   )
240     public
241     returns (bool)
242   {
243     require(spender != address(0));
244 
245     _allowed[msg.sender][spender] = (
246       _allowed[msg.sender][spender].sub(subtractedValue));
247     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
248     return true;
249   }
250 
251   /**
252   * @dev Transfer token for a specified addresses
253   * @param from The address to transfer from.
254   * @param to The address to transfer to.
255   * @param value The amount to be transferred.
256   */
257   function _transfer(address from, address to, uint256 value) internal {
258     require(value <= _balances[from]);
259     require(to != address(0));
260 
261     _balances[from] = _balances[from].sub(value);
262     _balances[to] = _balances[to].add(value);
263     emit Transfer(from, to, value);
264   }
265 
266   /**
267    * @dev Internal function that mints an amount of the token and assigns it to
268    * an account. This encapsulates the modification of balances such that the
269    * proper events are emitted.
270    * @param account The account that will receive the created tokens.
271    * @param value The amount that will be created.
272    */
273   function _mint(address account, uint256 value) internal {
274     require(account != 0);
275     _totalSupply = _totalSupply.add(value);
276     _balances[account] = _balances[account].add(value);
277     emit Transfer(address(0), account, value);
278   }
279 
280   /**
281    * @dev Internal function that burns an amount of the token of a given
282    * account.
283    * @param account The account whose tokens will be burnt.
284    * @param value The amount that will be burnt.
285    */
286   function _burn(address account, uint256 value) internal {
287     require(account != 0);
288     require(value <= _balances[account]);
289 
290     _totalSupply = _totalSupply.sub(value);
291     _balances[account] = _balances[account].sub(value);
292     emit Transfer(account, address(0), value);
293   }
294 
295   /**
296    * @dev Internal function that burns an amount of the token of a given
297    * account, deducting from the sender's allowance for said account. Uses the
298    * internal burn function.
299    * @param account The account whose tokens will be burnt.
300    * @param value The amount that will be burnt.
301    */
302   function _burnFrom(address account, uint256 value) internal {
303     require(value <= _allowed[account][msg.sender]);
304 
305     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
306     // this function needs to emit an event with the updated approval.
307     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
308       value);
309     _burn(account, value);
310   }
311 }
312 
313 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol
314 
315 /**
316  * @title Burnable Token
317  * @dev Token that can be irreversibly burned (destroyed).
318  */
319 contract ERC20Burnable is ERC20 {
320 
321   /**
322    * @dev Burns a specific amount of tokens.
323    * @param value The amount of token to be burned.
324    */
325   function burn(uint256 value) public {
326     _burn(msg.sender, value);
327   }
328 
329   /**
330    * @dev Burns a specific amount of tokens from the target address and decrements allowance
331    * @param from address The address which you want to send tokens from
332    * @param value uint256 The amount of token to be burned
333    */
334   function burnFrom(address from, uint256 value) public {
335     _burnFrom(from, value);
336   }
337 }
338 
339 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
340 
341 /**
342  * @title ERC20Detailed token
343  * @dev The decimals are only for visualization purposes.
344  * All the operations are done using the smallest and indivisible token unit,
345  * just as on Ethereum all the operations are done in wei.
346  */
347 contract ERC20Detailed is IERC20 {
348   string private _name;
349   string private _symbol;
350   uint8 private _decimals;
351 
352   constructor(string name, string symbol, uint8 decimals) public {
353     _name = name;
354     _symbol = symbol;
355     _decimals = decimals;
356   }
357 
358   /**
359    * @return the name of the token.
360    */
361   function name() public view returns(string) {
362     return _name;
363   }
364 
365   /**
366    * @return the symbol of the token.
367    */
368   function symbol() public view returns(string) {
369     return _symbol;
370   }
371 
372   /**
373    * @return the number of decimals of the token.
374    */
375   function decimals() public view returns(uint8) {
376     return _decimals;
377   }
378 }
379 
380 // File: openzeppelin-solidity/contracts/access/Roles.sol
381 
382 /**
383  * @title Roles
384  * @dev Library for managing addresses assigned to a Role.
385  */
386 library Roles {
387   struct Role {
388     mapping (address => bool) bearer;
389   }
390 
391   /**
392    * @dev give an account access to this role
393    */
394   function add(Role storage role, address account) internal {
395     require(account != address(0));
396     require(!has(role, account));
397 
398     role.bearer[account] = true;
399   }
400 
401   /**
402    * @dev remove an account's access to this role
403    */
404   function remove(Role storage role, address account) internal {
405     require(account != address(0));
406     require(has(role, account));
407 
408     role.bearer[account] = false;
409   }
410 
411   /**
412    * @dev check if an account has this role
413    * @return bool
414    */
415   function has(Role storage role, address account)
416     internal
417     view
418     returns (bool)
419   {
420     require(account != address(0));
421     return role.bearer[account];
422   }
423 }
424 
425 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
426 
427 contract PauserRole {
428   using Roles for Roles.Role;
429 
430   event PauserAdded(address indexed account);
431   event PauserRemoved(address indexed account);
432 
433   Roles.Role private pausers;
434 
435   constructor() internal {
436     _addPauser(msg.sender);
437   }
438 
439   modifier onlyPauser() {
440     require(isPauser(msg.sender));
441     _;
442   }
443 
444   function isPauser(address account) public view returns (bool) {
445     return pausers.has(account);
446   }
447 
448   function addPauser(address account) public onlyPauser {
449     _addPauser(account);
450   }
451 
452   function renouncePauser() public {
453     _removePauser(msg.sender);
454   }
455 
456   function _addPauser(address account) internal {
457     pausers.add(account);
458     emit PauserAdded(account);
459   }
460 
461   function _removePauser(address account) internal {
462     pausers.remove(account);
463     emit PauserRemoved(account);
464   }
465 }
466 
467 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
468 
469 /**
470  * @title Pausable
471  * @dev Base contract which allows children to implement an emergency stop mechanism.
472  */
473 contract Pausable is PauserRole {
474   event Paused(address account);
475   event Unpaused(address account);
476 
477   bool private _paused;
478 
479   constructor() internal {
480     _paused = false;
481   }
482 
483   /**
484    * @return true if the contract is paused, false otherwise.
485    */
486   function paused() public view returns(bool) {
487     return _paused;
488   }
489 
490   /**
491    * @dev Modifier to make a function callable only when the contract is not paused.
492    */
493   modifier whenNotPaused() {
494     require(!_paused);
495     _;
496   }
497 
498   /**
499    * @dev Modifier to make a function callable only when the contract is paused.
500    */
501   modifier whenPaused() {
502     require(_paused);
503     _;
504   }
505 
506   /**
507    * @dev called by the owner to pause, triggers stopped state
508    */
509   function pause() public onlyPauser whenNotPaused {
510     _paused = true;
511     emit Paused(msg.sender);
512   }
513 
514   /**
515    * @dev called by the owner to unpause, returns to normal state
516    */
517   function unpause() public onlyPauser whenPaused {
518     _paused = false;
519     emit Unpaused(msg.sender);
520   }
521 }
522 
523 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Pausable.sol
524 
525 /**
526  * @title Pausable token
527  * @dev ERC20 modified with pausable transfers.
528  **/
529 contract ERC20Pausable is ERC20, Pausable {
530 
531   function transfer(
532     address to,
533     uint256 value
534   )
535     public
536     whenNotPaused
537     returns (bool)
538   {
539     return super.transfer(to, value);
540   }
541 
542   function transferFrom(
543     address from,
544     address to,
545     uint256 value
546   )
547     public
548     whenNotPaused
549     returns (bool)
550   {
551     return super.transferFrom(from, to, value);
552   }
553 
554   function approve(
555     address spender,
556     uint256 value
557   )
558     public
559     whenNotPaused
560     returns (bool)
561   {
562     return super.approve(spender, value);
563   }
564 
565   function increaseAllowance(
566     address spender,
567     uint addedValue
568   )
569     public
570     whenNotPaused
571     returns (bool success)
572   {
573     return super.increaseAllowance(spender, addedValue);
574   }
575 
576   function decreaseAllowance(
577     address spender,
578     uint subtractedValue
579   )
580     public
581     whenNotPaused
582     returns (bool success)
583   {
584     return super.decreaseAllowance(spender, subtractedValue);
585   }
586 }
587 
588 // File: contracts/TipToken.sol
589 
590 /**
591  * @title TipToken
592  */
593 contract TipToken is ERC20, ERC20Detailed, ERC20Burnable, ERC20Pausable {
594     uint256 public constant INITIAL_SUPPLY = 100000000 * 100; // 100 M TIP
595 
596     /**
597      * @dev Constructor that gives msg.sender all of existing tokens.
598      */
599     constructor () public ERC20Detailed("Tip Token", "TIP", 2) {
600         _mint(msg.sender, INITIAL_SUPPLY);
601     }
602 }