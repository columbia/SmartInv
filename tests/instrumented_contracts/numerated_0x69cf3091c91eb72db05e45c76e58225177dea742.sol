1 pragma solidity ^0.4.13;
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
13     require(!has(role, account));
14 
15     role.bearer[account] = true;
16   }
17 
18   /**
19    * @dev remove an account's access to this role
20    */
21   function remove(Role storage role, address account) internal {
22     require(account != address(0));
23     require(has(role, account));
24 
25     role.bearer[account] = false;
26   }
27 
28   /**
29    * @dev check if an account has this role
30    * @return bool
31    */
32   function has(Role storage role, address account)
33     internal
34     view
35     returns (bool)
36   {
37     require(account != address(0));
38     return role.bearer[account];
39   }
40 }
41 
42 contract PauserRole {
43   using Roles for Roles.Role;
44 
45   event PauserAdded(address indexed account);
46   event PauserRemoved(address indexed account);
47 
48   Roles.Role private pausers;
49 
50   constructor() internal {
51     _addPauser(msg.sender);
52   }
53 
54   modifier onlyPauser() {
55     require(isPauser(msg.sender));
56     _;
57   }
58 
59   function isPauser(address account) public view returns (bool) {
60     return pausers.has(account);
61   }
62 
63   function addPauser(address account) public onlyPauser {
64     _addPauser(account);
65   }
66 
67   function renouncePauser() public {
68     _removePauser(msg.sender);
69   }
70 
71   function _addPauser(address account) internal {
72     pausers.add(account);
73     emit PauserAdded(account);
74   }
75 
76   function _removePauser(address account) internal {
77     pausers.remove(account);
78     emit PauserRemoved(account);
79   }
80 }
81 
82 contract Pausable is PauserRole {
83   event Paused(address account);
84   event Unpaused(address account);
85 
86   bool private _paused;
87 
88   constructor() internal {
89     _paused = false;
90   }
91 
92   /**
93    * @return true if the contract is paused, false otherwise.
94    */
95   function paused() public view returns(bool) {
96     return _paused;
97   }
98 
99   /**
100    * @dev Modifier to make a function callable only when the contract is not paused.
101    */
102   modifier whenNotPaused() {
103     require(!_paused);
104     _;
105   }
106 
107   /**
108    * @dev Modifier to make a function callable only when the contract is paused.
109    */
110   modifier whenPaused() {
111     require(_paused);
112     _;
113   }
114 
115   /**
116    * @dev called by the owner to pause, triggers stopped state
117    */
118   function pause() public onlyPauser whenNotPaused {
119     _paused = true;
120     emit Paused(msg.sender);
121   }
122 
123   /**
124    * @dev called by the owner to unpause, returns to normal state
125    */
126   function unpause() public onlyPauser whenPaused {
127     _paused = false;
128     emit Unpaused(msg.sender);
129   }
130 }
131 
132 library SafeMath {
133 
134   /**
135   * @dev Multiplies two numbers, reverts on overflow.
136   */
137   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
138     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
139     // benefit is lost if 'b' is also tested.
140     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
141     if (a == 0) {
142       return 0;
143     }
144 
145     uint256 c = a * b;
146     require(c / a == b);
147 
148     return c;
149   }
150 
151   /**
152   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
153   */
154   function div(uint256 a, uint256 b) internal pure returns (uint256) {
155     require(b > 0); // Solidity only automatically asserts when dividing by 0
156     uint256 c = a / b;
157     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
158 
159     return c;
160   }
161 
162   /**
163   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
164   */
165   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
166     require(b <= a);
167     uint256 c = a - b;
168 
169     return c;
170   }
171 
172   /**
173   * @dev Adds two numbers, reverts on overflow.
174   */
175   function add(uint256 a, uint256 b) internal pure returns (uint256) {
176     uint256 c = a + b;
177     require(c >= a);
178 
179     return c;
180   }
181 
182   /**
183   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
184   * reverts when dividing by zero.
185   */
186   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
187     require(b != 0);
188     return a % b;
189   }
190 }
191 
192 contract Ownable {
193   address private _owner;
194 
195   event OwnershipTransferred(
196     address indexed previousOwner,
197     address indexed newOwner
198   );
199 
200   /**
201    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
202    * account.
203    */
204   constructor() internal {
205     _owner = msg.sender;
206     emit OwnershipTransferred(address(0), _owner);
207   }
208 
209   /**
210    * @return the address of the owner.
211    */
212   function owner() public view returns(address) {
213     return _owner;
214   }
215 
216   /**
217    * @dev Throws if called by any account other than the owner.
218    */
219   modifier onlyOwner() {
220     require(isOwner());
221     _;
222   }
223 
224   /**
225    * @return true if `msg.sender` is the owner of the contract.
226    */
227   function isOwner() public view returns(bool) {
228     return msg.sender == _owner;
229   }
230 
231   /**
232    * @dev Allows the current owner to relinquish control of the contract.
233    * @notice Renouncing to ownership will leave the contract without an owner.
234    * It will not be possible to call the functions with the `onlyOwner`
235    * modifier anymore.
236    */
237   function renounceOwnership() public onlyOwner {
238     emit OwnershipTransferred(_owner, address(0));
239     _owner = address(0);
240   }
241 
242   /**
243    * @dev Allows the current owner to transfer control of the contract to a newOwner.
244    * @param newOwner The address to transfer ownership to.
245    */
246   function transferOwnership(address newOwner) public onlyOwner {
247     _transferOwnership(newOwner);
248   }
249 
250   /**
251    * @dev Transfers control of the contract to a newOwner.
252    * @param newOwner The address to transfer ownership to.
253    */
254   function _transferOwnership(address newOwner) internal {
255     require(newOwner != address(0));
256     emit OwnershipTransferred(_owner, newOwner);
257     _owner = newOwner;
258   }
259 }
260 
261 interface IERC20 {
262   function totalSupply() external view returns (uint256);
263 
264   function balanceOf(address who) external view returns (uint256);
265 
266   function allowance(address owner, address spender)
267     external view returns (uint256);
268 
269   function transfer(address to, uint256 value) external returns (bool);
270 
271   function approve(address spender, uint256 value)
272     external returns (bool);
273 
274   function transferFrom(address from, address to, uint256 value)
275     external returns (bool);
276 
277   event Transfer(
278     address indexed from,
279     address indexed to,
280     uint256 value
281   );
282 
283   event Approval(
284     address indexed owner,
285     address indexed spender,
286     uint256 value
287   );
288 }
289 
290 contract ERC20 is IERC20 {
291   using SafeMath for uint256;
292 
293   mapping (address => uint256) private _balances;
294 
295   mapping (address => mapping (address => uint256)) private _allowed;
296 
297   uint256 private _totalSupply;
298 
299   /**
300   * @dev Total number of tokens in existence
301   */
302   function totalSupply() public view returns (uint256) {
303     return _totalSupply;
304   }
305 
306   /**
307   * @dev Gets the balance of the specified address.
308   * @param owner The address to query the balance of.
309   * @return An uint256 representing the amount owned by the passed address.
310   */
311   function balanceOf(address owner) public view returns (uint256) {
312     return _balances[owner];
313   }
314 
315   /**
316    * @dev Function to check the amount of tokens that an owner allowed to a spender.
317    * @param owner address The address which owns the funds.
318    * @param spender address The address which will spend the funds.
319    * @return A uint256 specifying the amount of tokens still available for the spender.
320    */
321   function allowance(
322     address owner,
323     address spender
324    )
325     public
326     view
327     returns (uint256)
328   {
329     return _allowed[owner][spender];
330   }
331 
332   /**
333   * @dev Transfer token for a specified address
334   * @param to The address to transfer to.
335   * @param value The amount to be transferred.
336   */
337   function transfer(address to, uint256 value) public returns (bool) {
338     _transfer(msg.sender, to, value);
339     return true;
340   }
341 
342   /**
343    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
344    * Beware that changing an allowance with this method brings the risk that someone may use both the old
345    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
346    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
347    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
348    * @param spender The address which will spend the funds.
349    * @param value The amount of tokens to be spent.
350    */
351   function approve(address spender, uint256 value) public returns (bool) {
352     require(spender != address(0));
353 
354     _allowed[msg.sender][spender] = value;
355     emit Approval(msg.sender, spender, value);
356     return true;
357   }
358 
359   /**
360    * @dev Transfer tokens from one address to another
361    * @param from address The address which you want to send tokens from
362    * @param to address The address which you want to transfer to
363    * @param value uint256 the amount of tokens to be transferred
364    */
365   function transferFrom(
366     address from,
367     address to,
368     uint256 value
369   )
370     public
371     returns (bool)
372   {
373     require(value <= _allowed[from][msg.sender]);
374 
375     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
376     _transfer(from, to, value);
377     return true;
378   }
379 
380   /**
381    * @dev Increase the amount of tokens that an owner allowed to a spender.
382    * approve should be called when allowed_[_spender] == 0. To increment
383    * allowed value is better to use this function to avoid 2 calls (and wait until
384    * the first transaction is mined)
385    * From MonolithDAO Token.sol
386    * @param spender The address which will spend the funds.
387    * @param addedValue The amount of tokens to increase the allowance by.
388    */
389   function increaseAllowance(
390     address spender,
391     uint256 addedValue
392   )
393     public
394     returns (bool)
395   {
396     require(spender != address(0));
397 
398     _allowed[msg.sender][spender] = (
399       _allowed[msg.sender][spender].add(addedValue));
400     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
401     return true;
402   }
403 
404   /**
405    * @dev Decrease the amount of tokens that an owner allowed to a spender.
406    * approve should be called when allowed_[_spender] == 0. To decrement
407    * allowed value is better to use this function to avoid 2 calls (and wait until
408    * the first transaction is mined)
409    * From MonolithDAO Token.sol
410    * @param spender The address which will spend the funds.
411    * @param subtractedValue The amount of tokens to decrease the allowance by.
412    */
413   function decreaseAllowance(
414     address spender,
415     uint256 subtractedValue
416   )
417     public
418     returns (bool)
419   {
420     require(spender != address(0));
421 
422     _allowed[msg.sender][spender] = (
423       _allowed[msg.sender][spender].sub(subtractedValue));
424     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
425     return true;
426   }
427 
428   /**
429   * @dev Transfer token for a specified addresses
430   * @param from The address to transfer from.
431   * @param to The address to transfer to.
432   * @param value The amount to be transferred.
433   */
434   function _transfer(address from, address to, uint256 value) internal {
435     require(value <= _balances[from]);
436     require(to != address(0));
437 
438     _balances[from] = _balances[from].sub(value);
439     _balances[to] = _balances[to].add(value);
440     emit Transfer(from, to, value);
441   }
442 
443   /**
444    * @dev Internal function that mints an amount of the token and assigns it to
445    * an account. This encapsulates the modification of balances such that the
446    * proper events are emitted.
447    * @param account The account that will receive the created tokens.
448    * @param value The amount that will be created.
449    */
450   function _mint(address account, uint256 value) internal {
451     require(account != 0);
452     _totalSupply = _totalSupply.add(value);
453     _balances[account] = _balances[account].add(value);
454     emit Transfer(address(0), account, value);
455   }
456 
457   /**
458    * @dev Internal function that burns an amount of the token of a given
459    * account.
460    * @param account The account whose tokens will be burnt.
461    * @param value The amount that will be burnt.
462    */
463   function _burn(address account, uint256 value) internal {
464     require(account != 0);
465     require(value <= _balances[account]);
466 
467     _totalSupply = _totalSupply.sub(value);
468     _balances[account] = _balances[account].sub(value);
469     emit Transfer(account, address(0), value);
470   }
471 
472   /**
473    * @dev Internal function that burns an amount of the token of a given
474    * account, deducting from the sender's allowance for said account. Uses the
475    * internal burn function.
476    * @param account The account whose tokens will be burnt.
477    * @param value The amount that will be burnt.
478    */
479   function _burnFrom(address account, uint256 value) internal {
480     require(value <= _allowed[account][msg.sender]);
481 
482     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
483     // this function needs to emit an event with the updated approval.
484     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
485       value);
486     _burn(account, value);
487   }
488 }
489 
490 contract ERC20Burnable is ERC20 {
491 
492   /**
493    * @dev Burns a specific amount of tokens.
494    * @param value The amount of token to be burned.
495    */
496   function burn(uint256 value) public {
497     _burn(msg.sender, value);
498   }
499 
500   /**
501    * @dev Burns a specific amount of tokens from the target address and decrements allowance
502    * @param from address The address which you want to send tokens from
503    * @param value uint256 The amount of token to be burned
504    */
505   function burnFrom(address from, uint256 value) public {
506     _burnFrom(from, value);
507   }
508 }
509 
510 contract ERC20Detailed is IERC20 {
511   string private _name;
512   string private _symbol;
513   uint8 private _decimals;
514 
515   constructor(string name, string symbol, uint8 decimals) public {
516     _name = name;
517     _symbol = symbol;
518     _decimals = decimals;
519   }
520 
521   /**
522    * @return the name of the token.
523    */
524   function name() public view returns(string) {
525     return _name;
526   }
527 
528   /**
529    * @return the symbol of the token.
530    */
531   function symbol() public view returns(string) {
532     return _symbol;
533   }
534 
535   /**
536    * @return the number of decimals of the token.
537    */
538   function decimals() public view returns(uint8) {
539     return _decimals;
540   }
541 }
542 
543 contract ERC20Pausable is ERC20, Pausable {
544 
545   function transfer(
546     address to,
547     uint256 value
548   )
549     public
550     whenNotPaused
551     returns (bool)
552   {
553     return super.transfer(to, value);
554   }
555 
556   function transferFrom(
557     address from,
558     address to,
559     uint256 value
560   )
561     public
562     whenNotPaused
563     returns (bool)
564   {
565     return super.transferFrom(from, to, value);
566   }
567 
568   function approve(
569     address spender,
570     uint256 value
571   )
572     public
573     whenNotPaused
574     returns (bool)
575   {
576     return super.approve(spender, value);
577   }
578 
579   function increaseAllowance(
580     address spender,
581     uint addedValue
582   )
583     public
584     whenNotPaused
585     returns (bool success)
586   {
587     return super.increaseAllowance(spender, addedValue);
588   }
589 
590   function decreaseAllowance(
591     address spender,
592     uint subtractedValue
593   )
594     public
595     whenNotPaused
596     returns (bool success)
597   {
598     return super.decreaseAllowance(spender, subtractedValue);
599   }
600 }
601 
602 contract CZToken is ERC20Detailed,ERC20Pausable,Ownable,ERC20Burnable {
603 
604   uint256 public INITIAL_SUPPLY = 1000000000 * 10**18; // initial quantity of total_token supply
605   /**
606 
607     * @dev Constructor that gives all existing tokens to the sender.
608 
609     */
610 
611     constructor () public ERC20Detailed("CoinZoom", "ZOOM", 18) {
612 
613         _mint(msg.sender, INITIAL_SUPPLY);
614 
615     }
616 
617 }