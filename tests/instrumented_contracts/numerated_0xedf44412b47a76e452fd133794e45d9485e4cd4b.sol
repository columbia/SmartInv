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
11     // @dev See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
12     if (a == 0) {
13       return 0;
14     }
15 
16     uint256 c = a * b;
17     require(c / a == b);
18 
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     require(b > 0); // Solidity only automatically asserts when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29 
30     return c;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     require(b <= a);
38     uint256 c = a - b;
39 
40     return c;
41   }
42 
43   /**
44   * @dev Adds two numbers, reverts on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256) {
47     uint256 c = a + b;
48     require(c >= a);
49 
50     return c;
51   }
52 
53   /**
54   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
55   * reverts when dividing by zero.
56   */
57   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
58     require(b != 0);
59     return a % b;
60   }
61 }
62 
63 interface IERC20 {
64   function totalSupply() external view returns (uint256);
65 
66   function balanceOf(address who) external view returns (uint256);
67 
68   function allowance(address owner, address spender)
69     external view returns (uint256);
70 
71   function transfer(address to, uint256 value) external returns (bool);
72 
73   function approve(address spender, uint256 value)
74     external returns (bool);
75 
76   function transferFrom(address from, address to, uint256 value)
77     external returns (bool);
78 
79   event Transfer(
80     address indexed from,
81     address indexed to,
82     uint256 value
83   );
84 
85   event Approval(
86     address indexed owner,
87     address indexed spender,
88     uint256 value
89   );
90 }
91 
92 contract PauserRole {
93   using Roles for Roles.Role;
94 
95   event PauserAdded(address indexed account);
96   event PauserRemoved(address indexed account);
97 
98   Roles.Role private pausers;
99 
100   constructor() internal {
101     _addPauser(msg.sender);
102   }
103 
104   modifier onlyPauser() {
105     require(isPauser(msg.sender));
106     _;
107   }
108 
109   function isPauser(address account) public view returns (bool) {
110     return pausers.has(account);
111   }
112 
113   function addPauser(address account) public onlyPauser {
114     _addPauser(account);
115   }
116 
117   function renouncePauser() public {
118     _removePauser(msg.sender);
119   }
120 
121   function _addPauser(address account) internal {
122     pausers.add(account);
123     emit PauserAdded(account);
124   }
125 
126   function _removePauser(address account) internal {
127     pausers.remove(account);
128     emit PauserRemoved(account);
129   }
130 }
131 
132 contract ERC20 is IERC20 {
133   using SafeMath for uint256;
134 
135   mapping (address => uint256) private _balances;
136 
137   mapping (address => mapping (address => uint256)) private _allowed;
138 
139   uint256 private _totalSupply;
140 
141   /**
142   * @dev Total number of tokens in existence
143   */
144   function totalSupply() public view returns (uint256) {
145     return _totalSupply;
146   }
147 
148   /**
149   * @dev Gets the balance of the specified address.
150   * @param owner The address to query the balance of.
151   * @return An uint256 representing the amount owned by the passed address.
152   */
153   function balanceOf(address owner) public view returns (uint256) {
154     return _balances[owner];
155   }
156 
157   /**
158    * @dev Function to check the amount of tokens that an owner allowed to a spender.
159    * @param owner address The address which owns the funds.
160    * @param spender address The address which will spend the funds.
161    * @return A uint256 specifying the amount of tokens still available for the spender.
162    */
163   function allowance(
164     address owner,
165     address spender
166    )
167     public
168     view
169     returns (uint256)
170   {
171     return _allowed[owner][spender];
172   }
173 
174   /**
175   * @dev Transfer token for a specified address
176   * @param to The address to transfer to.
177   * @param value The amount to be transferred.
178   */
179   function transfer(address to, uint256 value) public returns (bool) {
180     _transfer(msg.sender, to, value);
181     return true;
182   }
183 
184   /**
185    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
186    * Beware that changing an allowance with this method brings the risk that someone may use both the old
187    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
188    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
189    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
190    * @param spender The address which will spend the funds.
191    * @param value The amount of tokens to be spent.
192    */
193   function approve(address spender, uint256 value) public returns (bool) {
194     require(spender != address(0));
195 
196     _allowed[msg.sender][spender] = value;
197     emit Approval(msg.sender, spender, value);
198     return true;
199   }
200 
201   /**
202    * @dev Transfer tokens from one address to another
203    * @param from address The address which you want to send tokens from
204    * @param to address The address which you want to transfer to
205    * @param value uint256 the amount of tokens to be transferred
206    */
207   function transferFrom(
208     address from,
209     address to,
210     uint256 value
211   )
212     public
213     returns (bool)
214   {
215     require(value <= _allowed[from][msg.sender]);
216 
217     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
218     _transfer(from, to, value);
219     return true;
220   }
221 
222   /**
223    * @dev Increase the amount of tokens that an owner allowed to a spender.
224    * approve should be called when allowed_[_spender] == 0. To increment
225    * allowed value is better to use this function to avoid 2 calls (and wait until
226    * the first transaction is mined)
227    * From MonolithDAO Token.sol
228    * @param spender The address which will spend the funds.
229    * @param addedValue The amount of tokens to increase the allowance by.
230    */
231   function increaseAllowance(
232     address spender,
233     uint256 addedValue
234   )
235     public
236     returns (bool)
237   {
238     require(spender != address(0));
239 
240     _allowed[msg.sender][spender] = (
241       _allowed[msg.sender][spender].add(addedValue));
242     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
243     return true;
244   }
245 
246   /**
247    * @dev Decrease the amount of tokens that an owner allowed to a spender.
248    * approve should be called when allowed_[_spender] == 0. To decrement
249    * allowed value is better to use this function to avoid 2 calls (and wait until
250    * the first transaction is mined)
251    * From MonolithDAO Token.sol
252    * @param spender The address which will spend the funds.
253    * @param subtractedValue The amount of tokens to decrease the allowance by.
254    */
255   function decreaseAllowance(
256     address spender,
257     uint256 subtractedValue
258   )
259     public
260     returns (bool)
261   {
262     require(spender != address(0));
263 
264     _allowed[msg.sender][spender] = (
265       _allowed[msg.sender][spender].sub(subtractedValue));
266     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
267     return true;
268   }
269 
270   /**
271   * @dev Transfer token for a specified addresses
272   * @param from The address to transfer from.
273   * @param to The address to transfer to.
274   * @param value The amount to be transferred.
275   */
276   function _transfer(address from, address to, uint256 value) internal {
277     require(value <= _balances[from]);
278     require(to != address(0));
279 
280     _balances[from] = _balances[from].sub(value);
281     _balances[to] = _balances[to].add(value);
282     emit Transfer(from, to, value);
283   }
284 
285   /**
286    * @dev Internal function that mints an amount of the token and assigns it to
287    * an account. This encapsulates the modification of balances such that the
288    * proper events are emitted.
289    * @param account The account that will receive the created tokens.
290    * @param value The amount that will be created.
291    */
292   function _mint(address account, uint256 value) internal {
293     require(account != 0);
294     _totalSupply = _totalSupply.add(value);
295     _balances[account] = _balances[account].add(value);
296     emit Transfer(address(0), account, value);
297   }
298 
299   /**
300    * @dev Internal function that burns an amount of the token of a given
301    * account.
302    * @param account The account whose tokens will be burnt.
303    * @param value The amount that will be burnt.
304    */
305   function _burn(address account, uint256 value) internal {
306     require(account != 0);
307     require(value <= _balances[account]);
308 
309     _totalSupply = _totalSupply.sub(value);
310     _balances[account] = _balances[account].sub(value);
311     emit Transfer(account, address(0), value);
312   }
313 
314   /**
315    * @dev Internal function that burns an amount of the token of a given
316    * account, deducting from the sender's allowance for said account. Uses the
317    * internal burn function.
318    * @param account The account whose tokens will be burnt.
319    * @param value The amount that will be burnt.
320    */
321   function _burnFrom(address account, uint256 value) internal {
322     require(value <= _allowed[account][msg.sender]);
323 
324     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
325     // this function needs to emit an event with the updated approval.
326     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
327       value);
328     _burn(account, value);
329   }
330 }
331 
332 contract ERC20Burnable is ERC20 {
333 
334   /**
335    * @dev Burns a specific amount of tokens.
336    * @param value The amount of token to be burned.
337    */
338   function burn(uint256 value) public {
339     _burn(msg.sender, value);
340   }
341 
342   /**
343    * @dev Burns a specific amount of tokens from the target address and decrements allowance
344    * @param from address The address which you want to send tokens from
345    * @param value uint256 The amount of token to be burned
346    */
347   function burnFrom(address from, uint256 value) public {
348     _burnFrom(from, value);
349   }
350 }
351 
352 contract Pausable is PauserRole {
353   event Paused(address account);
354   event Unpaused(address account);
355 
356   bool private _paused;
357 
358   constructor() internal {
359     _paused = false;
360   }
361 
362   /**
363    * @return true if the contract is paused, false otherwise.
364    */
365   function paused() public view returns(bool) {
366     return _paused;
367   }
368 
369   /**
370    * @dev Modifier to make a function callable only when the contract is not paused.
371    */
372   modifier whenNotPaused() {
373     require(!_paused);
374     _;
375   }
376 
377   /**
378    * @dev Modifier to make a function callable only when the contract is paused.
379    */
380   modifier whenPaused() {
381     require(_paused);
382     _;
383   }
384 
385   /**
386    * @dev called by the owner to pause, triggers stopped state
387    */
388   function pause() public onlyPauser whenNotPaused {
389     _paused = true;
390     emit Paused(msg.sender);
391   }
392 
393   /**
394    * @dev called by the owner to unpause, returns to normal state
395    */
396   function unpause() public onlyPauser whenPaused {
397     _paused = false;
398     emit Unpaused(msg.sender);
399   }
400 }
401 
402 contract ERC20Pausable is ERC20, Pausable {
403 
404   function transfer(
405     address to,
406     uint256 value
407   )
408     public
409     whenNotPaused
410     returns (bool)
411   {
412     return super.transfer(to, value);
413   }
414 
415   function transferFrom(
416     address from,
417     address to,
418     uint256 value
419   )
420     public
421     whenNotPaused
422     returns (bool)
423   {
424     return super.transferFrom(from, to, value);
425   }
426 
427   function approve(
428     address spender,
429     uint256 value
430   )
431     public
432     whenNotPaused
433     returns (bool)
434   {
435     return super.approve(spender, value);
436   }
437 
438   function increaseAllowance(
439     address spender,
440     uint addedValue
441   )
442     public
443     whenNotPaused
444     returns (bool success)
445   {
446     return super.increaseAllowance(spender, addedValue);
447   }
448 
449   function decreaseAllowance(
450     address spender,
451     uint subtractedValue
452   )
453     public
454     whenNotPaused
455     returns (bool success)
456   {
457     return super.decreaseAllowance(spender, subtractedValue);
458   }
459 }
460 
461 contract Kingcuan is ERC20, ERC20Burnable, ERC20Pausable{
462 
463   string public constant name = "Kingcuan";
464   string public constant symbol = "CUAN";
465   uint8 public constant decimals = 18;
466 
467   uint256 public constant INITIAL_SUPPLY = 12000000000 * (10 ** uint256(decimals));
468 
469   /**
470    * @dev Constructor that gives msg.sender all of existing tokens.
471    */
472   constructor() public {
473     _mint(msg.sender, INITIAL_SUPPLY);
474   }
475 
476 }
477 
478 library Roles {
479   struct Role {
480     mapping (address => bool) bearer;
481   }
482 
483   /**
484    * @dev give an account access to this role
485    */
486   function add(Role storage role, address account) internal {
487     require(account != address(0));
488     require(!has(role, account));
489 
490     role.bearer[account] = true;
491   }
492 
493   /**
494    * @dev remove an account's access to this role
495    */
496   function remove(Role storage role, address account) internal {
497     require(account != address(0));
498     require(has(role, account));
499 
500     role.bearer[account] = false;
501   }
502 
503   /**
504    * @dev check if an account has this role
505    * @return bool
506    */
507   function has(Role storage role, address account)
508     internal
509     view
510     returns (bool)
511   {
512     require(account != address(0));
513     return role.bearer[account];
514   }
515 }