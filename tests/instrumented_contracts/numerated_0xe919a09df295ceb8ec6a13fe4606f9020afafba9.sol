1 pragma solidity ^0.4.24;
2 
3 library Roles {
4   struct Role {
5     mapping (address => bool) bearer;
6   }
7 
8   /**
9    * @dev give an account access to this role
10    */
11   function add(Role storage role, address account) internal {
12     require(account != address(0));
13     role.bearer[account] = true;
14   }
15 
16   /**
17    * @dev remove an account's access to this role
18    */
19   function remove(Role storage role, address account) internal {
20     require(account != address(0));
21     role.bearer[account] = false;
22   }
23 
24   /**
25    * @dev check if an account has this role
26    * @return bool
27    */
28   function has(Role storage role, address account)
29     internal
30     view
31     returns (bool)
32   {
33     require(account != address(0));
34     return role.bearer[account];
35   }
36 }
37 
38 contract PauserRole {
39   using Roles for Roles.Role;
40 
41   event PauserAdded(address indexed account);
42   event PauserRemoved(address indexed account);
43 
44   Roles.Role private pausers;
45 
46   constructor() public {
47     pausers.add(msg.sender);
48   }
49 
50   modifier onlyPauser() {
51     require(isPauser(msg.sender));
52     _;
53   }
54 
55   function isPauser(address account) public view returns (bool) {
56     return pausers.has(account);
57   }
58 
59   function addPauser(address account) public onlyPauser {
60     pausers.add(account);
61     emit PauserAdded(account);
62   }
63 
64   function renouncePauser() public {
65     pausers.remove(msg.sender);
66   }
67 
68   function _removePauser(address account) internal {
69     pausers.remove(account);
70     emit PauserRemoved(account);
71   }
72 }
73 
74 contract Pausable is PauserRole {
75   event Paused();
76   event Unpaused();
77 
78   bool private _paused = false;
79 
80 
81   /**
82    * @return true if the contract is paused, false otherwise.
83    */
84   function paused() public view returns(bool) {
85     return _paused;
86   }
87 
88   /**
89    * @dev Modifier to make a function callable only when the contract is not paused.
90    */
91   modifier whenNotPaused() {
92     require(!_paused);
93     _;
94   }
95 
96   /**
97    * @dev Modifier to make a function callable only when the contract is paused.
98    */
99   modifier whenPaused() {
100     require(_paused);
101     _;
102   }
103 
104   /**
105    * @dev called by the owner to pause, triggers stopped state
106    */
107   function pause() public onlyPauser whenNotPaused {
108     _paused = true;
109     emit Paused();
110   }
111 
112   /**
113    * @dev called by the owner to unpause, returns to normal state
114    */
115   function unpause() public onlyPauser whenPaused {
116     _paused = false;
117     emit Unpaused();
118   }
119 }
120 
121 library SafeMath {
122 
123   /**
124   * @dev Multiplies two numbers, reverts on overflow.
125   */
126   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
127     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
128     // benefit is lost if 'b' is also tested.
129     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
130     if (a == 0) {
131       return 0;
132     }
133 
134     uint256 c = a * b;
135     require(c / a == b);
136 
137     return c;
138   }
139 
140   /**
141   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
142   */
143   function div(uint256 a, uint256 b) internal pure returns (uint256) {
144     require(b > 0); // Solidity only automatically asserts when dividing by 0
145     uint256 c = a / b;
146     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
147 
148     return c;
149   }
150 
151   /**
152   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
153   */
154   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
155     require(b <= a);
156     uint256 c = a - b;
157 
158     return c;
159   }
160 
161   /**
162   * @dev Adds two numbers, reverts on overflow.
163   */
164   function add(uint256 a, uint256 b) internal pure returns (uint256) {
165     uint256 c = a + b;
166     require(c >= a);
167 
168     return c;
169   }
170 
171   /**
172   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
173   * reverts when dividing by zero.
174   */
175   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
176     require(b != 0);
177     return a % b;
178   }
179 }
180 
181 interface IERC20 {
182   function totalSupply() external view returns (uint256);
183 
184   function balanceOf(address who) external view returns (uint256);
185 
186   function allowance(address owner, address spender)
187     external view returns (uint256);
188 
189   function transfer(address to, uint256 value) external returns (bool);
190 
191   function approve(address spender, uint256 value)
192     external returns (bool);
193 
194   function transferFrom(address from, address to, uint256 value)
195     external returns (bool);
196 
197   event Transfer(
198     address indexed from,
199     address indexed to,
200     uint256 value
201   );
202 
203   event Approval(
204     address indexed owner,
205     address indexed spender,
206     uint256 value
207   );
208 }
209 
210 contract ERC20 is IERC20 {
211   using SafeMath for uint256;
212 
213   mapping (address => uint256) private _balances;
214 
215   mapping (address => mapping (address => uint256)) private _allowed;
216 
217   uint256 private _totalSupply;
218 
219   /**
220   * @dev Total number of tokens in existence
221   */
222   function totalSupply() public view returns (uint256) {
223     return _totalSupply;
224   }
225 
226   /**
227   * @dev Gets the balance of the specified address.
228   * @param owner The address to query the the balance of.
229   * @return An uint256 representing the amount owned by the passed address.
230   */
231   function balanceOf(address owner) public view returns (uint256) {
232     return _balances[owner];
233   }
234 
235   /**
236    * @dev Function to check the amount of tokens that an owner allowed to a spender.
237    * @param owner address The address which owns the funds.
238    * @param spender address The address which will spend the funds.
239    * @return A uint256 specifying the amount of tokens still available for the spender.
240    */
241   function allowance(
242     address owner,
243     address spender
244    )
245     public
246     view
247     returns (uint256)
248   {
249     return _allowed[owner][spender];
250   }
251 
252   /**
253   * @dev Transfer token for a specified address
254   * @param to The address to transfer to.
255   * @param value The amount to be transferred.
256   */
257   function transfer(address to, uint256 value) public returns (bool) {
258     require(value <= _balances[msg.sender]);
259     require(to != address(0));
260 
261     _balances[msg.sender] = _balances[msg.sender].sub(value);
262     _balances[to] = _balances[to].add(value);
263     emit Transfer(msg.sender, to, value);
264     return true;
265   }
266 
267   /**
268    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
269    * Beware that changing an allowance with this method brings the risk that someone may use both the old
270    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
271    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
272    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
273    * @param spender The address which will spend the funds.
274    * @param value The amount of tokens to be spent.
275    */
276   function approve(address spender, uint256 value) public returns (bool) {
277     require(spender != address(0));
278 
279     _allowed[msg.sender][spender] = value;
280     emit Approval(msg.sender, spender, value);
281     return true;
282   }
283 
284   /**
285    * @dev Transfer tokens from one address to another
286    * @param from address The address which you want to send tokens from
287    * @param to address The address which you want to transfer to
288    * @param value uint256 the amount of tokens to be transferred
289    */
290   function transferFrom(
291     address from,
292     address to,
293     uint256 value
294   )
295     public
296     returns (bool)
297   {
298     require(value <= _balances[from]);
299     require(value <= _allowed[from][msg.sender]);
300     require(to != address(0));
301 
302     _balances[from] = _balances[from].sub(value);
303     _balances[to] = _balances[to].add(value);
304     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
305     emit Transfer(from, to, value);
306     return true;
307   }
308 
309   /**
310    * @dev Increase the amount of tokens that an owner allowed to a spender.
311    * approve should be called when allowed_[_spender] == 0. To increment
312    * allowed value is better to use this function to avoid 2 calls (and wait until
313    * the first transaction is mined)
314    * From MonolithDAO Token.sol
315    * @param spender The address which will spend the funds.
316    * @param addedValue The amount of tokens to increase the allowance by.
317    */
318   function increaseAllowance(
319     address spender,
320     uint256 addedValue
321   )
322     public
323     returns (bool)
324   {
325     require(spender != address(0));
326 
327     _allowed[msg.sender][spender] = (
328       _allowed[msg.sender][spender].add(addedValue));
329     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
330     return true;
331   }
332 
333   /**
334    * @dev Decrease the amount of tokens that an owner allowed to a spender.
335    * approve should be called when allowed_[_spender] == 0. To decrement
336    * allowed value is better to use this function to avoid 2 calls (and wait until
337    * the first transaction is mined)
338    * From MonolithDAO Token.sol
339    * @param spender The address which will spend the funds.
340    * @param subtractedValue The amount of tokens to decrease the allowance by.
341    */
342   function decreaseAllowance(
343     address spender,
344     uint256 subtractedValue
345   )
346     public
347     returns (bool)
348   {
349     require(spender != address(0));
350 
351     _allowed[msg.sender][spender] = (
352       _allowed[msg.sender][spender].sub(subtractedValue));
353     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
354     return true;
355   }
356 
357   /**
358    * @dev Internal function that mints an amount of the token and assigns it to
359    * an account. This encapsulates the modification of balances such that the
360    * proper events are emitted.
361    * @param account The account that will receive the created tokens.
362    * @param amount The amount that will be created.
363    */
364   function _mint(address account, uint256 amount) internal {
365     require(account != 0);
366     _totalSupply = _totalSupply.add(amount);
367     _balances[account] = _balances[account].add(amount);
368     emit Transfer(address(0), account, amount);
369   }
370 
371   /**
372    * @dev Internal function that burns an amount of the token of a given
373    * account.
374    * @param account The account whose tokens will be burnt.
375    * @param amount The amount that will be burnt.
376    */
377   function _burn(address account, uint256 amount) internal {
378     require(account != 0);
379     require(amount <= _balances[account]);
380 
381     _totalSupply = _totalSupply.sub(amount);
382     _balances[account] = _balances[account].sub(amount);
383     emit Transfer(account, address(0), amount);
384   }
385 
386   /**
387    * @dev Internal function that burns an amount of the token of a given
388    * account, deducting from the sender's allowance for said account. Uses the
389    * internal burn function.
390    * @param account The account whose tokens will be burnt.
391    * @param amount The amount that will be burnt.
392    */
393   function _burnFrom(address account, uint256 amount) internal {
394     require(amount <= _allowed[account][msg.sender]);
395 
396     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
397     // this function needs to emit an event with the updated approval.
398     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
399       amount);
400     _burn(account, amount);
401   }
402 }
403 
404 contract ERC20Burnable is ERC20 {
405 
406   /**
407    * @dev Burns a specific amount of tokens.
408    * @param value The amount of token to be burned.
409    */
410   function burn(uint256 value) public {
411     _burn(msg.sender, value);
412   }
413 
414   /**
415    * @dev Burns a specific amount of tokens from the target address and decrements allowance
416    * @param from address The address which you want to send tokens from
417    * @param value uint256 The amount of token to be burned
418    */
419   function burnFrom(address from, uint256 value) public {
420     _burnFrom(from, value);
421   }
422 
423   /**
424    * @dev Overrides ERC20._burn in order for burn and burnFrom to emit
425    * an additional Burn event.
426    */
427   function _burn(address who, uint256 value) internal {
428     super._burn(who, value);
429   }
430 }
431 
432 contract ERC20Detailed is IERC20 {
433   string private _name;
434   string private _symbol;
435   uint8 private _decimals;
436 
437   constructor(string name, string symbol, uint8 decimals) public {
438     _name = name;
439     _symbol = symbol;
440     _decimals = decimals;
441   }
442 
443   /**
444    * @return the name of the token.
445    */
446   function name() public view returns(string) {
447     return _name;
448   }
449 
450   /**
451    * @return the symbol of the token.
452    */
453   function symbol() public view returns(string) {
454     return _symbol;
455   }
456 
457   /**
458    * @return the number of decimals of the token.
459    */
460   function decimals() public view returns(uint8) {
461     return _decimals;
462   }
463 }
464 
465 contract ERC20Pausable is ERC20, Pausable {
466 
467   function transfer(
468     address to,
469     uint256 value
470   )
471     public
472     whenNotPaused
473     returns (bool)
474   {
475     return super.transfer(to, value);
476   }
477 
478   function transferFrom(
479     address from,
480     address to,
481     uint256 value
482   )
483     public
484     whenNotPaused
485     returns (bool)
486   {
487     return super.transferFrom(from, to, value);
488   }
489 
490   function approve(
491     address spender,
492     uint256 value
493   )
494     public
495     whenNotPaused
496     returns (bool)
497   {
498     return super.approve(spender, value);
499   }
500 
501   function increaseAllowance(
502     address spender,
503     uint addedValue
504   )
505     public
506     whenNotPaused
507     returns (bool success)
508   {
509     return super.increaseAllowance(spender, addedValue);
510   }
511 
512   function decreaseAllowance(
513     address spender,
514     uint subtractedValue
515   )
516     public
517     whenNotPaused
518     returns (bool success)
519   {
520     return super.decreaseAllowance(spender, subtractedValue);
521   }
522 }
523 
524 contract PleaseToken is ERC20, ERC20Detailed, ERC20Burnable, ERC20Pausable {
525 
526   using SafeERC20 for ERC20;
527 
528   string public name = "PleaseToken";
529   string public symbol = "PLS";
530   uint8 public decimals = 18;
531   uint256 private _totalSupply = 1000000000000000000000000000;
532 
533   constructor()
534     ERC20Pausable()
535     ERC20Burnable()
536     ERC20Detailed(name, symbol, decimals)
537     ERC20()
538     public
539   {
540     _mint(msg.sender, _totalSupply);
541     addPauser(msg.sender);
542   }
543 }
544 
545 library SafeERC20 {
546   function safeTransfer(
547     IERC20 token,
548     address to,
549     uint256 value
550   )
551     internal
552   {
553     require(token.transfer(to, value));
554   }
555 
556   function safeTransferFrom(
557     IERC20 token,
558     address from,
559     address to,
560     uint256 value
561   )
562     internal
563   {
564     require(token.transferFrom(from, to, value));
565   }
566 
567   function safeApprove(
568     IERC20 token,
569     address spender,
570     uint256 value
571   )
572     internal
573   {
574     require(token.approve(spender, value));
575   }
576 }