1 pragma solidity ^0.4.25;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, reverts on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
10     // benefit is lost if 'b' is also tested.
11     // @dev See: https://givingtoken.github.io
12     // @dev See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
13     if (a == 0) {
14       return 0;
15     }
16 
17     uint256 c = a * b;
18     require(c / a == b);
19 
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     require(b > 0); // Solidity only automatically asserts when dividing by 0
28     uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30 
31     return c;
32   }
33 
34   /**
35   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
36   */
37   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38     require(b <= a);
39     uint256 c = a - b;
40 
41     return c;
42   }
43 
44   /**
45   * @dev Adds two numbers, reverts on overflow.
46   */
47   function add(uint256 a, uint256 b) internal pure returns (uint256) {
48     uint256 c = a + b;
49     require(c >= a);
50 
51     return c;
52   }
53 
54   /**
55   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
56   * reverts when dividing by zero.
57   */
58   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
59     require(b != 0);
60     return a % b;
61   }
62 }
63 
64 interface IERC20 {
65   function totalSupply() external view returns (uint256);
66 
67   function balanceOf(address who) external view returns (uint256);
68 
69   function allowance(address owner, address spender)
70     external view returns (uint256);
71 
72   function transfer(address to, uint256 value) external returns (bool);
73 
74   function approve(address spender, uint256 value)
75     external returns (bool);
76 
77   function transferFrom(address from, address to, uint256 value)
78     external returns (bool);
79 
80   event Transfer(
81     address indexed from,
82     address indexed to,
83     uint256 value
84   );
85 
86   event Approval(
87     address indexed owner,
88     address indexed spender,
89     uint256 value
90   );
91 }
92 
93 contract PauserRole {
94   using Roles for Roles.Role;
95 
96   event PauserAdded(address indexed account);
97   event PauserRemoved(address indexed account);
98 
99   Roles.Role private pausers;
100 
101   constructor() internal {
102     _addPauser(msg.sender);
103   }
104 
105   modifier onlyPauser() {
106     require(isPauser(msg.sender));
107     _;
108   }
109 
110   function isPauser(address account) public view returns (bool) {
111     return pausers.has(account);
112   }
113 
114   function addPauser(address account) public onlyPauser {
115     _addPauser(account);
116   }
117 
118   function renouncePauser() public {
119     _removePauser(msg.sender);
120   }
121 
122   function _addPauser(address account) internal {
123     pausers.add(account);
124     emit PauserAdded(account);
125   }
126 
127   function _removePauser(address account) internal {
128     pausers.remove(account);
129     emit PauserRemoved(account);
130   }
131 }
132 
133 contract ERC20 is IERC20 {
134   using SafeMath for uint256;
135 
136   mapping (address => uint256) private _balances;
137 
138   mapping (address => mapping (address => uint256)) private _allowed;
139 
140   uint256 private _totalSupply;
141 
142   /**
143   * @dev Total number of tokens in existence
144   */
145   function totalSupply() public view returns (uint256) {
146     return _totalSupply;
147   }
148 
149   /**
150   * @dev Gets the balance of the specified address.
151   * @param owner The address to query the balance of.
152   * @return An uint256 representing the amount owned by the passed address.
153   */
154   function balanceOf(address owner) public view returns (uint256) {
155     return _balances[owner];
156   }
157 
158   /**
159    * @dev Function to check the amount of tokens that an owner allowed to a spender.
160    * @param owner address The address which owns the funds.
161    * @param spender address The address which will spend the funds.
162    * @return A uint256 specifying the amount of tokens still available for the spender.
163    */
164   function allowance(
165     address owner,
166     address spender
167    )
168     public
169     view
170     returns (uint256)
171   {
172     return _allowed[owner][spender];
173   }
174 
175   /**
176   * @dev Transfer token for a specified address
177   * @param to The address to transfer to.
178   * @param value The amount to be transferred.
179   */
180   function transfer(address to, uint256 value) public returns (bool) {
181     _transfer(msg.sender, to, value);
182     return true;
183   }
184 
185   /**
186    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
187    * Beware that changing an allowance with this method brings the risk that someone may use both the old
188    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
189    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
190    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
191    * @param spender The address which will spend the funds.
192    * @param value The amount of tokens to be spent.
193    */
194   function approve(address spender, uint256 value) public returns (bool) {
195     require(spender != address(0));
196 
197     _allowed[msg.sender][spender] = value;
198     emit Approval(msg.sender, spender, value);
199     return true;
200   }
201 
202   /**
203    * @dev Transfer tokens from one address to another
204    * @param from address The address which you want to send tokens from
205    * @param to address The address which you want to transfer to
206    * @param value uint256 the amount of tokens to be transferred
207    */
208   function transferFrom(
209     address from,
210     address to,
211     uint256 value
212   )
213     public
214     returns (bool)
215   {
216     require(value <= _allowed[from][msg.sender]);
217 
218     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
219     _transfer(from, to, value);
220     return true;
221   }
222 
223   /**
224    * @dev Increase the amount of tokens that an owner allowed to a spender.
225    * approve should be called when allowed_[_spender] == 0. To increment
226    * allowed value is better to use this function to avoid 2 calls (and wait until
227    * the first transaction is mined)
228    * From MonolithDAO Token.sol
229    * @param spender The address which will spend the funds.
230    * @param addedValue The amount of tokens to increase the allowance by.
231    */
232   function increaseAllowance(
233     address spender,
234     uint256 addedValue
235   )
236     public
237     returns (bool)
238   {
239     require(spender != address(0));
240 
241     _allowed[msg.sender][spender] = (
242       _allowed[msg.sender][spender].add(addedValue));
243     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
244     return true;
245   }
246 
247   /**
248    * @dev Decrease the amount of tokens that an owner allowed to a spender.
249    * approve should be called when allowed_[_spender] == 0. To decrement
250    * allowed value is better to use this function to avoid 2 calls (and wait until
251    * the first transaction is mined)
252    * From MonolithDAO Token.sol
253    * @param spender The address which will spend the funds.
254    * @param subtractedValue The amount of tokens to decrease the allowance by.
255    */
256   function decreaseAllowance(
257     address spender,
258     uint256 subtractedValue
259   )
260     public
261     returns (bool)
262   {
263     require(spender != address(0));
264 
265     _allowed[msg.sender][spender] = (
266       _allowed[msg.sender][spender].sub(subtractedValue));
267     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
268     return true;
269   }
270 
271   /**
272   * @dev Transfer token for a specified addresses
273   * @param from The address to transfer from.
274   * @param to The address to transfer to.
275   * @param value The amount to be transferred.
276   */
277   function _transfer(address from, address to, uint256 value) internal {
278     require(value <= _balances[from]);
279     require(to != address(0));
280 
281     _balances[from] = _balances[from].sub(value);
282     _balances[to] = _balances[to].add(value);
283     emit Transfer(from, to, value);
284   }
285 
286   /**
287    * @dev Internal function that mints an amount of the token and assigns it to
288    * an account. This encapsulates the modification of balances such that the
289    * proper events are emitted.
290    * @param account The account that will receive the created tokens.
291    * @param value The amount that will be created.
292    */
293   function _mint(address account, uint256 value) internal {
294     require(account != 0);
295     _totalSupply = _totalSupply.add(value);
296     _balances[account] = _balances[account].add(value);
297     emit Transfer(address(0), account, value);
298   }
299 
300   /**
301    * @dev Internal function that burns an amount of the token of a given
302    * account.
303    * @param account The account whose tokens will be burnt.
304    * @param value The amount that will be burnt.
305    */
306   function _burn(address account, uint256 value) internal {
307     require(account != 0);
308     require(value <= _balances[account]);
309 
310     _totalSupply = _totalSupply.sub(value);
311     _balances[account] = _balances[account].sub(value);
312     emit Transfer(account, address(0), value);
313   }
314 
315   /**
316    * @dev Internal function that burns an amount of the token of a given
317    * account, deducting from the sender's allowance for said account. Uses the
318    * internal burn function.
319    * @param account The account whose tokens will be burnt.
320    * @param value The amount that will be burnt.
321    */
322   function _burnFrom(address account, uint256 value) internal {
323     require(value <= _allowed[account][msg.sender]);
324 
325     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
326     // this function needs to emit an event with the updated approval.
327     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
328       value);
329     _burn(account, value);
330   }
331 }
332 
333 contract ERC20Burnable is ERC20 {
334 
335   /**
336    * @dev Burns a specific amount of tokens.
337    * @param value The amount of token to be burned.
338    */
339   function burn(uint256 value) public {
340     _burn(msg.sender, value);
341   }
342 
343   /**
344    * @dev Burns a specific amount of tokens from the target address and decrements allowance
345    * @param from address The address which you want to send tokens from
346    * @param value uint256 The amount of token to be burned
347    */
348   function burnFrom(address from, uint256 value) public {
349     _burnFrom(from, value);
350   }
351 }
352 
353 contract Pausable is PauserRole {
354   event Paused(address account);
355   event Unpaused(address account);
356 
357   bool private _paused;
358 
359   constructor() internal {
360     _paused = false;
361   }
362 
363   /**
364    * @return true if the contract is paused, false otherwise.
365    */
366   function paused() public view returns(bool) {
367     return _paused;
368   }
369 
370   /**
371    * @dev Modifier to make a function callable only when the contract is not paused.
372    */
373   modifier whenNotPaused() {
374     require(!_paused);
375     _;
376   }
377 
378   /**
379    * @dev Modifier to make a function callable only when the contract is paused.
380    */
381   modifier whenPaused() {
382     require(_paused);
383     _;
384   }
385 
386   /**
387    * @dev called by the owner to pause, triggers stopped state
388    */
389   function pause() public onlyPauser whenNotPaused {
390     _paused = true;
391     emit Paused(msg.sender);
392   }
393 
394   /**
395    * @dev called by the owner to unpause, returns to normal state
396    */
397   function unpause() public onlyPauser whenPaused {
398     _paused = false;
399     emit Unpaused(msg.sender);
400   }
401 }
402 
403 contract ERC20Pausable is ERC20, Pausable {
404 
405   function transfer(
406     address to,
407     uint256 value
408   )
409     public
410     whenNotPaused
411     returns (bool)
412   {
413     return super.transfer(to, value);
414   }
415 
416   function transferFrom(
417     address from,
418     address to,
419     uint256 value
420   )
421     public
422     whenNotPaused
423     returns (bool)
424   {
425     return super.transferFrom(from, to, value);
426   }
427 
428   function approve(
429     address spender,
430     uint256 value
431   )
432     public
433     whenNotPaused
434     returns (bool)
435   {
436     return super.approve(spender, value);
437   }
438 
439   function increaseAllowance(
440     address spender,
441     uint addedValue
442   )
443     public
444     whenNotPaused
445     returns (bool success)
446   {
447     return super.increaseAllowance(spender, addedValue);
448   }
449 
450   function decreaseAllowance(
451     address spender,
452     uint subtractedValue
453   )
454     public
455     whenNotPaused
456     returns (bool success)
457   {
458     return super.decreaseAllowance(spender, subtractedValue);
459   }
460 }
461 
462 contract GivingToken is ERC20, ERC20Burnable, ERC20Pausable{
463 
464   string public constant name = "Giving Token";
465   string public constant symbol = "GIVING";
466   uint8 public constant decimals = 18;
467 
468   uint256 public constant INITIAL_SUPPLY = 75000000000 * (10 ** uint256(decimals));
469 
470   /**
471    * @dev Constructor that gives msg.sender all of existing tokens.
472    */
473   constructor() public {
474     _mint(msg.sender, INITIAL_SUPPLY);
475   }
476 
477 }
478 
479 library Roles {
480   struct Role {
481     mapping (address => bool) bearer;
482   }
483 
484   /**
485    * @dev give an account access to this role
486    */
487   function add(Role storage role, address account) internal {
488     require(account != address(0));
489     require(!has(role, account));
490 
491     role.bearer[account] = true;
492   }
493 
494   /**
495    * @dev remove an account's access to this role
496    */
497   function remove(Role storage role, address account) internal {
498     require(account != address(0));
499     require(has(role, account));
500 
501     role.bearer[account] = false;
502   }
503 
504   /**
505    * @dev check if an account has this role
506    * @return bool
507    */
508   function has(Role storage role, address account)
509     internal
510     view
511     returns (bool)
512   {
513     require(account != address(0));
514     return role.bearer[account];
515   }
516 }