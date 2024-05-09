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
38 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
39 
40 /**
41  * @title SafeMath
42  * @dev Math operations with safety checks that revert on error
43  */
44 library SafeMath {
45 
46   /**
47   * @dev Multiplies two numbers, reverts on overflow.
48   */
49   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
50     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
51     // benefit is lost if 'b' is also tested.
52     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
53     if (a == 0) {
54       return 0;
55     }
56 
57     uint256 c = a * b;
58     require(c / a == b);
59 
60     return c;
61   }
62 
63   /**
64   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
65   */
66   function div(uint256 a, uint256 b) internal pure returns (uint256) {
67     require(b > 0); // Solidity only automatically asserts when dividing by 0
68     uint256 c = a / b;
69     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70 
71     return c;
72   }
73 
74   /**
75   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
76   */
77   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
78     require(b <= a);
79     uint256 c = a - b;
80 
81     return c;
82   }
83 
84   /**
85   * @dev Adds two numbers, reverts on overflow.
86   */
87   function add(uint256 a, uint256 b) internal pure returns (uint256) {
88     uint256 c = a + b;
89     require(c >= a);
90 
91     return c;
92   }
93 
94   /**
95   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
96   * reverts when dividing by zero.
97   */
98   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
99     require(b != 0);
100     return a % b;
101   }
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
313 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
314 
315 /**
316  * @title ERC20Detailed token
317  * @dev The decimals are only for visualization purposes.
318  * All the operations are done using the smallest and indivisible token unit,
319  * just as on Ethereum all the operations are done in wei.
320  */
321 contract ERC20Detailed is IERC20 {
322   string private _name;
323   string private _symbol;
324   uint8 private _decimals;
325 
326   constructor(string name, string symbol, uint8 decimals) public {
327     _name = name;
328     _symbol = symbol;
329     _decimals = decimals;
330   }
331 
332   /**
333    * @return the name of the token.
334    */
335   function name() public view returns(string) {
336     return _name;
337   }
338 
339   /**
340    * @return the symbol of the token.
341    */
342   function symbol() public view returns(string) {
343     return _symbol;
344   }
345 
346   /**
347    * @return the number of decimals of the token.
348    */
349   function decimals() public view returns(uint8) {
350     return _decimals;
351   }
352 }
353 
354 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol
355 
356 /**
357  * @title Burnable Token
358  * @dev Token that can be irreversibly burned (destroyed).
359  */
360 contract ERC20Burnable is ERC20 {
361 
362   /**
363    * @dev Burns a specific amount of tokens.
364    * @param value The amount of token to be burned.
365    */
366   function burn(uint256 value) public {
367     _burn(msg.sender, value);
368   }
369 
370   /**
371    * @dev Burns a specific amount of tokens from the target address and decrements allowance
372    * @param from address The address which you want to send tokens from
373    * @param value uint256 The amount of token to be burned
374    */
375   function burnFrom(address from, uint256 value) public {
376     _burnFrom(from, value);
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
588 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
589 
590 /**
591  * @title SafeERC20
592  * @dev Wrappers around ERC20 operations that throw on failure.
593  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
594  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
595  */
596 library SafeERC20 {
597 
598   using SafeMath for uint256;
599 
600   function safeTransfer(
601     IERC20 token,
602     address to,
603     uint256 value
604   )
605     internal
606   {
607     require(token.transfer(to, value));
608   }
609 
610   function safeTransferFrom(
611     IERC20 token,
612     address from,
613     address to,
614     uint256 value
615   )
616     internal
617   {
618     require(token.transferFrom(from, to, value));
619   }
620 
621   function safeApprove(
622     IERC20 token,
623     address spender,
624     uint256 value
625   )
626     internal
627   {
628     // safeApprove should only be called when setting an initial allowance, 
629     // or when resetting it to zero. To increase and decrease it, use 
630     // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
631     require((value == 0) || (token.allowance(msg.sender, spender) == 0));
632     require(token.approve(spender, value));
633   }
634 
635   function safeIncreaseAllowance(
636     IERC20 token,
637     address spender,
638     uint256 value
639   )
640     internal
641   {
642     uint256 newAllowance = token.allowance(address(this), spender).add(value);
643     require(token.approve(spender, newAllowance));
644   }
645 
646   function safeDecreaseAllowance(
647     IERC20 token,
648     address spender,
649     uint256 value
650   )
651     internal
652   {
653     uint256 newAllowance = token.allowance(address(this), spender).sub(value);
654     require(token.approve(spender, newAllowance));
655   }
656 }
657 
658 // File: contracts/VXToken.sol
659 
660 contract VXToken is ERC20, ERC20Detailed, ERC20Burnable, ERC20Pausable {
661   using SafeERC20 for ERC20;
662 
663   string private constant TOKEN_NAME = "VX Network";
664   string private constant TOKEN_SYMBOL = "VX";
665   uint8 private constant TOKEN_DECIMALS = 18;
666   uint256 private constant TOKEN_INITIAL_SUPPLY = 1000000000 * (uint256(10)**TOKEN_DECIMALS);
667 
668   constructor() ERC20Detailed(TOKEN_NAME, TOKEN_SYMBOL, TOKEN_DECIMALS) public {
669     _mint(address(msg.sender), TOKEN_INITIAL_SUPPLY);
670   }
671 }