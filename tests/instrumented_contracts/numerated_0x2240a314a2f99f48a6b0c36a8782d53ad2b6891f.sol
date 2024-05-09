1 pragma solidity ^0.4.24;
2 
3 interface IToken {
4   function name() external view returns(string);
5 
6   function symbol() external view returns(string);
7 
8   function decimals() external view returns(uint8);
9 
10   function totalSupply() external view returns (uint256);
11 
12   function balanceOf(address who) external view returns (uint256);
13 
14   function allowance(address owner, address spender) external view returns (uint256);
15 
16   function transfer(address to, uint256 value) external returns (bool);
17 
18   function approve(address spender, uint256 value) external returns (bool);
19 
20   function transferFrom(address from, address to, uint256 value) external returns (bool);
21 
22   function increaseAllowance(address spender, uint256 addedValue) external returns (bool);
23 
24   function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool);
25 
26   function mint(address to, uint256 value) external returns (bool);
27 
28   function burn(address from, uint256 value) external returns (bool);
29 
30   function isMinter(address account) external returns (bool);
31 
32   event Transfer(
33     address indexed from,
34     address indexed to,
35     uint256 value
36   );
37 
38   event Approval(
39     address indexed owner,
40     address indexed spender,
41     uint256 value
42   );
43 
44   event Paused(address account);
45   event Unpaused(address account);
46 }
47 
48 /**
49  * @title SafeMath
50  * @dev Math operations with safety checks that revert on error
51  */
52 library SafeMath {
53 
54   /**
55   * @dev Multiplies two numbers, reverts on overflow.
56   */
57   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
58     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
59     // benefit is lost if 'b' is also tested.
60     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
61     if (a == 0) {
62       return 0;
63     }
64 
65     uint256 c = a * b;
66     require(c / a == b);
67 
68     return c;
69   }
70 
71   /**
72   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
73   */
74   function div(uint256 a, uint256 b) internal pure returns (uint256) {
75     require(b > 0); // Solidity only automatically asserts when dividing by 0
76     uint256 c = a / b;
77     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
78 
79     return c;
80   }
81 
82   /**
83   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
84   */
85   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
86     require(b <= a);
87     uint256 c = a - b;
88 
89     return c;
90   }
91 
92   /**
93   * @dev Adds two numbers, reverts on overflow.
94   */
95   function add(uint256 a, uint256 b) internal pure returns (uint256) {
96     uint256 c = a + b;
97     require(c >= a);
98 
99     return c;
100   }
101 
102   /**
103   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
104   * reverts when dividing by zero.
105   */
106   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
107     require(b != 0);
108     return a % b;
109   }
110 }
111 
112 library Roles {
113   struct Role {
114     mapping (address => bool) bearer;
115   }
116 
117   /**
118    * @dev give an account access to this role
119    */
120   function add(Role storage role, address account) internal {
121     require(account != address(0));
122     require(!has(role, account));
123 
124     role.bearer[account] = true;
125   }
126 
127   /**
128    * @dev remove an account's access to this role
129    */
130   function remove(Role storage role, address account) internal {
131     require(account != address(0));
132     require(has(role, account));
133 
134     role.bearer[account] = false;
135   }
136 
137   /**
138    * @dev check if an account has this role
139    * @return bool
140    */
141   function has(Role storage role, address account)
142     internal
143     view
144     returns (bool)
145   {
146     require(account != address(0));
147     return role.bearer[account];
148   }
149 }
150 
151 contract ERC20 is IToken {
152   using SafeMath for uint256;
153 
154   mapping (address => uint256) private _balances;
155 
156   mapping (address => mapping (address => uint256)) private _allowed;
157 
158   uint256 private _totalSupply;
159 
160   /**
161   * @dev Total number of tokens in existence
162   */
163   function totalSupply() public view returns (uint256) {
164     return _totalSupply;
165   }
166 
167   /**
168   * @dev Gets the balance of the specified address.
169   * @param owner The address to query the balance of.
170   * @return An uint256 representing the amount owned by the passed address.
171   */
172   function balanceOf(address owner) public view returns (uint256) {
173     return _balances[owner];
174   }
175 
176   /**
177    * @dev Function to check the amount of tokens that an owner allowed to a spender.
178    * @param owner address The address which owns the funds.
179    * @param spender address The address which will spend the funds.
180    * @return A uint256 specifying the amount of tokens still available for the spender.
181    */
182   function allowance(
183     address owner,
184     address spender
185    )
186     public
187     view
188     returns (uint256)
189   {
190     return _allowed[owner][spender];
191   }
192 
193   /**
194   * @dev Transfer token for a specified address
195   * @param to The address to transfer to.
196   * @param value The amount to be transferred.
197   */
198   function transfer(address to, uint256 value) public returns (bool) {
199     _transfer(msg.sender, to, value);
200     return true;
201   }
202 
203   /**
204    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
205    * Beware that changing an allowance with this method brings the risk that someone may use both the old
206    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
207    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
208    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
209    * @param spender The address which will spend the funds.
210    * @param value The amount of tokens to be spent.
211    */
212   function approve(address spender, uint256 value) public returns (bool) {
213     require(spender != address(0));
214 
215     _allowed[msg.sender][spender] = value;
216     emit Approval(msg.sender, spender, value);
217     return true;
218   }
219 
220   /**
221    * @dev Transfer tokens from one address to another
222    * @param from address The address which you want to send tokens from
223    * @param to address The address which you want to transfer to
224    * @param value uint256 the amount of tokens to be transferred
225    */
226   function transferFrom(
227     address from,
228     address to,
229     uint256 value
230   )
231     public
232     returns (bool)
233   {
234     require(value <= _allowed[from][msg.sender]);
235 
236     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
237     _transfer(from, to, value);
238     return true;
239   }
240 
241   /**
242    * @dev Increase the amount of tokens that an owner allowed to a spender.
243    * approve should be called when allowed_[_spender] == 0. To increment
244    * allowed value is better to use this function to avoid 2 calls (and wait until
245    * the first transaction is mined)
246    * From MonolithDAO Token.sol
247    * @param spender The address which will spend the funds.
248    * @param addedValue The amount of tokens to increase the allowance by.
249    */
250   function increaseAllowance(
251     address spender,
252     uint256 addedValue
253   )
254     public
255     returns (bool)
256   {
257     require(spender != address(0));
258 
259     _allowed[msg.sender][spender] = (
260       _allowed[msg.sender][spender].add(addedValue));
261     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
262     return true;
263   }
264 
265   /**
266    * @dev Decrease the amount of tokens that an owner allowed to a spender.
267    * approve should be called when allowed_[_spender] == 0. To decrement
268    * allowed value is better to use this function to avoid 2 calls (and wait until
269    * the first transaction is mined)
270    * From MonolithDAO Token.sol
271    * @param spender The address which will spend the funds.
272    * @param subtractedValue The amount of tokens to decrease the allowance by.
273    */
274   function decreaseAllowance(
275     address spender,
276     uint256 subtractedValue
277   )
278     public
279     returns (bool)
280   {
281     require(spender != address(0));
282 
283     _allowed[msg.sender][spender] = (
284       _allowed[msg.sender][spender].sub(subtractedValue));
285     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
286     return true;
287   }
288 
289   /**
290   * @dev Transfer token for a specified addresses
291   * @param from The address to transfer from.
292   * @param to The address to transfer to.
293   * @param value The amount to be transferred.
294   */
295   function _transfer(address from, address to, uint256 value) internal {
296     require(value <= _balances[from]);
297     require(to != address(0));
298 
299     _balances[from] = _balances[from].sub(value);
300     _balances[to] = _balances[to].add(value);
301     emit Transfer(from, to, value);
302   }
303 
304   /**
305    * @dev Internal function that mints an amount of the token and assigns it to
306    * an account. This encapsulates the modification of balances such that the
307    * proper events are emitted.
308    * @param account The account that will receive the created tokens.
309    * @param value The amount that will be created.
310    */
311   function _mint(address account, uint256 value) internal {
312     require(account != 0);
313     _totalSupply = _totalSupply.add(value);
314     _balances[account] = _balances[account].add(value);
315     emit Transfer(address(0), account, value);
316   }
317 
318   /**
319    * @dev Internal function that burns an amount of the token of a given
320    * account.
321    * @param account The account whose tokens will be burnt.
322    * @param value The amount that will be burnt.
323    */
324   function _burn(address account, uint256 value) internal {
325     require(account != 0);
326     require(value <= _balances[account]);
327 
328     _totalSupply = _totalSupply.sub(value);
329     _balances[account] = _balances[account].sub(value);
330     emit Transfer(account, address(0), value);
331   }
332 
333   /**
334    * @dev Internal function that burns an amount of the token of a given
335    * account, deducting from the sender's allowance for said account. Uses the
336    * internal burn function.
337    * @param account The account whose tokens will be burnt.
338    * @param value The amount that will be burnt.
339    */
340   function _burnFrom(address account, uint256 value) internal {
341     require(value <= _allowed[account][msg.sender]);
342 
343     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
344     // this function needs to emit an event with the updated approval.
345     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
346       value);
347     _burn(account, value);
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
391 contract Pausable is PauserRole {
392   event Paused(address account);
393   event Unpaused(address account);
394 
395   bool private _paused;
396 
397   constructor() internal {
398     _paused = false;
399   }
400 
401   /**
402    * @return true if the contract is paused, false otherwise.
403    */
404   function paused() public view returns(bool) {
405     return _paused;
406   }
407 
408   /**
409    * @dev Modifier to make a function callable only when the contract is not paused.
410    */
411   modifier whenNotPaused() {
412     require(!_paused);
413     _;
414   }
415 
416   /**
417    * @dev Modifier to make a function callable only when the contract is paused.
418    */
419   modifier whenPaused() {
420     require(_paused);
421     _;
422   }
423 
424   /**
425    * @dev called by the owner to pause, triggers stopped state
426    */
427   function pause() public onlyPauser whenNotPaused {
428     _paused = true;
429     emit Paused(msg.sender);
430   }
431 
432   /**
433    * @dev called by the owner to unpause, returns to normal state
434    */
435   function unpause() public onlyPauser whenPaused {
436     _paused = false;
437     emit Unpaused(msg.sender);
438   }
439 }
440 
441 contract ERC20Pausable is ERC20, Pausable {
442 
443   function transfer(
444     address to,
445     uint256 value
446   )
447     public
448     whenNotPaused
449     returns (bool)
450   {
451     return super.transfer(to, value);
452   }
453 
454   function transferFrom(
455     address from,
456     address to,
457     uint256 value
458   )
459     public
460     whenNotPaused
461     returns (bool)
462   {
463     return super.transferFrom(from, to, value);
464   }
465 
466   function approve(
467     address spender,
468     uint256 value
469   )
470     public
471     whenNotPaused
472     returns (bool)
473   {
474     return super.approve(spender, value);
475   }
476 
477   function increaseAllowance(
478     address spender,
479     uint addedValue
480   )
481     public
482     whenNotPaused
483     returns (bool success)
484   {
485     return super.increaseAllowance(spender, addedValue);
486   }
487 
488   function decreaseAllowance(
489     address spender,
490     uint subtractedValue
491   )
492     public
493     whenNotPaused
494     returns (bool success)
495   {
496     return super.decreaseAllowance(spender, subtractedValue);
497   }
498 }
499 
500 contract MinterRole {
501   using Roles for Roles.Role;
502 
503   event MinterAdded(address indexed account);
504   event MinterRemoved(address indexed account);
505 
506   Roles.Role private minters;
507 
508   constructor() internal {
509     _addMinter(msg.sender);
510   }
511 
512   modifier onlyMinter() {
513     require(isMinter(msg.sender));
514     _;
515   }
516 
517   function isMinter(address account) public view returns (bool) {
518     return minters.has(account);
519   }
520 
521   function addMinter(address account) public onlyMinter {
522     _addMinter(account);
523   }
524 
525   function renounceMinter() public {
526     _removeMinter(msg.sender);
527   }
528 
529   function _addMinter(address account) internal {
530     minters.add(account);
531     emit MinterAdded(account);
532   }
533 
534   function _removeMinter(address account) internal {
535     minters.remove(account);
536     emit MinterRemoved(account);
537   }
538 }
539 
540 contract ERC20Mintable is ERC20, MinterRole {
541   /**
542    * @dev Function to mint tokens
543    * @param to The address that will receive the minted tokens.
544    * @param value The amount of tokens to mint.
545    * @return A boolean that indicates if the operation was successful.
546    */
547   function mint(
548     address to,
549     uint256 value
550   )
551     public
552     onlyMinter
553     returns (bool)
554   {
555     _mint(to, value);
556     return true;
557   }
558 
559   /**
560    * @dev Burns a specific amount of tokens.
561    * @param from address The address which you want to burn tokens from
562    * @param value The amount of token to be burned.
563    * @return A boolean that indicates if operation was successful.
564    */
565   function burn(
566     address from,
567     uint256 value
568   )
569     public
570     onlyMinter
571     returns (bool)
572   {
573     _burn(from, value);
574     return true;
575   }
576 }
577 
578 contract Token is ERC20, ERC20Mintable, ERC20Pausable {
579   string private _name;
580   string private _symbol;
581   uint8 private _decimals;
582 
583   constructor(string name, string symbol, uint8 decimals)
584     ERC20()
585     ERC20Mintable()
586     ERC20Pausable()
587     public
588   {
589     _name = name;
590     _symbol = symbol;
591     _decimals = decimals;
592   }
593 
594   /**
595   * @return the name of the token.
596   */
597   function name() public view returns(string) {
598     return _name;
599   }
600 
601   /**
602   * @return the symbol of the token.
603   */
604   function symbol() public view returns(string) {
605     return _symbol;
606   }
607 
608   /**
609   * @return the number of decimals of the token.
610   */
611   function decimals() public view returns(uint8) {
612     return _decimals;
613   }
614 }