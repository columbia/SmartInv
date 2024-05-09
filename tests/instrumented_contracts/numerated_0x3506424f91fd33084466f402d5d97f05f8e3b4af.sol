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
313 // File: openzeppelin-solidity/contracts/access/Roles.sol
314 
315 /**
316  * @title Roles
317  * @dev Library for managing addresses assigned to a Role.
318  */
319 library Roles {
320   struct Role {
321     mapping (address => bool) bearer;
322   }
323 
324   /**
325    * @dev give an account access to this role
326    */
327   function add(Role storage role, address account) internal {
328     require(account != address(0));
329     require(!has(role, account));
330 
331     role.bearer[account] = true;
332   }
333 
334   /**
335    * @dev remove an account's access to this role
336    */
337   function remove(Role storage role, address account) internal {
338     require(account != address(0));
339     require(has(role, account));
340 
341     role.bearer[account] = false;
342   }
343 
344   /**
345    * @dev check if an account has this role
346    * @return bool
347    */
348   function has(Role storage role, address account)
349     internal
350     view
351     returns (bool)
352   {
353     require(account != address(0));
354     return role.bearer[account];
355   }
356 }
357 
358 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
359 
360 contract PauserRole {
361   using Roles for Roles.Role;
362 
363   event PauserAdded(address indexed account);
364   event PauserRemoved(address indexed account);
365 
366   Roles.Role private pausers;
367 
368   constructor() internal {
369     _addPauser(msg.sender);
370   }
371 
372   modifier onlyPauser() {
373     require(isPauser(msg.sender));
374     _;
375   }
376 
377   function isPauser(address account) public view returns (bool) {
378     return pausers.has(account);
379   }
380 
381   function addPauser(address account) public onlyPauser {
382     _addPauser(account);
383   }
384 
385   function renouncePauser() public {
386     _removePauser(msg.sender);
387   }
388 
389   function _addPauser(address account) internal {
390     pausers.add(account);
391     emit PauserAdded(account);
392   }
393 
394   function _removePauser(address account) internal {
395     pausers.remove(account);
396     emit PauserRemoved(account);
397   }
398 }
399 
400 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
401 
402 /**
403  * @title Pausable
404  * @dev Base contract which allows children to implement an emergency stop mechanism.
405  */
406 contract Pausable is PauserRole {
407   event Paused(address account);
408   event Unpaused(address account);
409 
410   bool private _paused;
411 
412   constructor() internal {
413     _paused = false;
414   }
415 
416   /**
417    * @return true if the contract is paused, false otherwise.
418    */
419   function paused() public view returns(bool) {
420     return _paused;
421   }
422 
423   /**
424    * @dev Modifier to make a function callable only when the contract is not paused.
425    */
426   modifier whenNotPaused() {
427     require(!_paused);
428     _;
429   }
430 
431   /**
432    * @dev Modifier to make a function callable only when the contract is paused.
433    */
434   modifier whenPaused() {
435     require(_paused);
436     _;
437   }
438 
439   /**
440    * @dev called by the owner to pause, triggers stopped state
441    */
442   function pause() public onlyPauser whenNotPaused {
443     _paused = true;
444     emit Paused(msg.sender);
445   }
446 
447   /**
448    * @dev called by the owner to unpause, returns to normal state
449    */
450   function unpause() public onlyPauser whenPaused {
451     _paused = false;
452     emit Unpaused(msg.sender);
453   }
454 }
455 
456 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Pausable.sol
457 
458 /**
459  * @title Pausable token
460  * @dev ERC20 modified with pausable transfers.
461  **/
462 contract ERC20Pausable is ERC20, Pausable {
463 
464   function transfer(
465     address to,
466     uint256 value
467   )
468     public
469     whenNotPaused
470     returns (bool)
471   {
472     return super.transfer(to, value);
473   }
474 
475   function transferFrom(
476     address from,
477     address to,
478     uint256 value
479   )
480     public
481     whenNotPaused
482     returns (bool)
483   {
484     return super.transferFrom(from, to, value);
485   }
486 
487   function approve(
488     address spender,
489     uint256 value
490   )
491     public
492     whenNotPaused
493     returns (bool)
494   {
495     return super.approve(spender, value);
496   }
497 
498   function increaseAllowance(
499     address spender,
500     uint addedValue
501   )
502     public
503     whenNotPaused
504     returns (bool success)
505   {
506     return super.increaseAllowance(spender, addedValue);
507   }
508 
509   function decreaseAllowance(
510     address spender,
511     uint subtractedValue
512   )
513     public
514     whenNotPaused
515     returns (bool success)
516   {
517     return super.decreaseAllowance(spender, subtractedValue);
518   }
519 }
520 
521 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
522 
523 /**
524  * @title ERC20Detailed token
525  * @dev The decimals are only for visualization purposes.
526  * All the operations are done using the smallest and indivisible token unit,
527  * just as on Ethereum all the operations are done in wei.
528  */
529 contract ERC20Detailed is IERC20 {
530   string private _name;
531   string private _symbol;
532   uint8 private _decimals;
533 
534   constructor(string name, string symbol, uint8 decimals) public {
535     _name = name;
536     _symbol = symbol;
537     _decimals = decimals;
538   }
539 
540   /**
541    * @return the name of the token.
542    */
543   function name() public view returns(string) {
544     return _name;
545   }
546 
547   /**
548    * @return the symbol of the token.
549    */
550   function symbol() public view returns(string) {
551     return _symbol;
552   }
553 
554   /**
555    * @return the number of decimals of the token.
556    */
557   function decimals() public view returns(uint8) {
558     return _decimals;
559   }
560 }
561 
562 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
563 
564 /**
565  * @title SafeERC20
566  * @dev Wrappers around ERC20 operations that throw on failure.
567  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
568  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
569  */
570 library SafeERC20 {
571 
572   using SafeMath for uint256;
573 
574   function safeTransfer(
575     IERC20 token,
576     address to,
577     uint256 value
578   )
579     internal
580   {
581     require(token.transfer(to, value));
582   }
583 
584   function safeTransferFrom(
585     IERC20 token,
586     address from,
587     address to,
588     uint256 value
589   )
590     internal
591   {
592     require(token.transferFrom(from, to, value));
593   }
594 
595   function safeApprove(
596     IERC20 token,
597     address spender,
598     uint256 value
599   )
600     internal
601   {
602     // safeApprove should only be called when setting an initial allowance, 
603     // or when resetting it to zero. To increase and decrease it, use 
604     // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
605     require((value == 0) || (token.allowance(msg.sender, spender) == 0));
606     require(token.approve(spender, value));
607   }
608 
609   function safeIncreaseAllowance(
610     IERC20 token,
611     address spender,
612     uint256 value
613   )
614     internal
615   {
616     uint256 newAllowance = token.allowance(address(this), spender).add(value);
617     require(token.approve(spender, newAllowance));
618   }
619 
620   function safeDecreaseAllowance(
621     IERC20 token,
622     address spender,
623     uint256 value
624   )
625     internal
626   {
627     uint256 newAllowance = token.allowance(address(this), spender).sub(value);
628     require(token.approve(spender, newAllowance));
629   }
630 }
631 
632 // File: contracts/Chiliz-with-imports.sol
633 
634 contract chiliZ is ERC20, ERC20Detailed, ERC20Pausable {
635    using SafeERC20 for ERC20;
636 
637    constructor()
638        ERC20()
639        ERC20Detailed("chiliZ", "CHZ", 18)
640        ERC20Pausable()
641        public
642    {
643        _mint(msg.sender, 8888888888 * (uint256(10) ** 18));
644    }
645 }