1 pragma solidity ^0.4.25;
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
48 
49 library Roles {
50   struct Role {
51     mapping (address => bool) bearer;
52   }
53 
54   /**
55    * @dev give an account access to this role
56    */
57   function add(Role storage role, address account) internal {
58     require(account != address(0));
59     require(!has(role, account));
60 
61     role.bearer[account] = true;
62   }
63 
64   /**
65    * @dev remove an account's access to this role
66    */
67   function remove(Role storage role, address account) internal {
68     require(account != address(0));
69     require(has(role, account));
70 
71     role.bearer[account] = false;
72   }
73 
74   /**
75    * @dev check if an account has this role
76    * @return bool
77    */
78   function has(Role storage role, address account)
79     internal
80     view
81     returns (bool)
82   {
83     require(account != address(0));
84     return role.bearer[account];
85   }
86 }  
87   /**
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
150  contract ERC20 is IToken {
151   using SafeMath for uint256;
152 
153   mapping (address => uint256) private _balances;
154 
155   mapping (address => mapping (address => uint256)) private _allowed;
156 
157   uint256 private _totalSupply;
158 
159   /**
160   * @dev Total number of tokens in existence
161   */
162   function totalSupply() public view returns (uint256) {
163     return _totalSupply;
164   }
165 
166   /**
167   * @dev Gets the balance of the specified address.
168   * @param owner The address to query the balance of.
169   * @return An uint256 representing the amount owned by the passed address.
170   */
171   function balanceOf(address owner) public view returns (uint256) {
172     return _balances[owner];
173   }
174 
175   /**
176    * @dev Function to check the amount of tokens that an owner allowed to a spender.
177    * @param owner address The address which owns the funds.
178    * @param spender address The address which will spend the funds.
179    * @return A uint256 specifying the amount of tokens still available for the spender.
180    */
181   function allowance(
182     address owner,
183     address spender
184    )
185     public
186     view
187     returns (uint256)
188   {
189     return _allowed[owner][spender];
190   }
191 
192   /**
193   * @dev Transfer token for a specified address
194   * @param to The address to transfer to.
195   * @param value The amount to be transferred.
196   */
197   function transfer(address to, uint256 value) public returns (bool) {
198     _transfer(msg.sender, to, value);
199     return true;
200   }
201 
202   /**
203    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
204    * Beware that changing an allowance with this method brings the risk that someone may use both the old
205    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
206    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
207    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
208    * @param spender The address which will spend the funds.
209    * @param value The amount of tokens to be spent.
210    */
211   function approve(address spender, uint256 value) public returns (bool) {
212     require(spender != address(0));
213 
214     _allowed[msg.sender][spender] = value;
215     emit Approval(msg.sender, spender, value);
216     return true;
217   }
218 
219   /**
220    * @dev Transfer tokens from one address to another
221    * @param from address The address which you want to send tokens from
222    * @param to address The address which you want to transfer to
223    * @param value uint256 the amount of tokens to be transferred
224    */
225   function transferFrom(
226     address from,
227     address to,
228     uint256 value
229   )
230     public
231     returns (bool)
232   {
233     require(value <= _allowed[from][msg.sender]);
234 
235     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
236     _transfer(from, to, value);
237     return true;
238   }
239 
240   /**
241    * @dev Increase the amount of tokens that an owner allowed to a spender.
242    * approve should be called when allowed_[_spender] == 0. To increment
243    * allowed value is better to use this function to avoid 2 calls (and wait until
244    * the first transaction is mined)
245    * From MonolithDAO Token.sol
246    * @param spender The address which will spend the funds.
247    * @param addedValue The amount of tokens to increase the allowance by.
248    */
249   function increaseAllowance(
250     address spender,
251     uint256 addedValue
252   )
253     public
254     returns (bool)
255   {
256     require(spender != address(0));
257 
258     _allowed[msg.sender][spender] = (
259       _allowed[msg.sender][spender].add(addedValue));
260     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
261     return true;
262   }
263 
264   /**
265    * @dev Decrease the amount of tokens that an owner allowed to a spender.
266    * approve should be called when allowed_[_spender] == 0. To decrement
267    * allowed value is better to use this function to avoid 2 calls (and wait until
268    * the first transaction is mined)
269    * From MonolithDAO Token.sol
270    * @param spender The address which will spend the funds.
271    * @param subtractedValue The amount of tokens to decrease the allowance by.
272    */
273   function decreaseAllowance(
274     address spender,
275     uint256 subtractedValue
276   )
277     public
278     returns (bool)
279   {
280     require(spender != address(0));
281 
282     _allowed[msg.sender][spender] = (
283       _allowed[msg.sender][spender].sub(subtractedValue));
284     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
285     return true;
286   }
287 
288   /**
289   * @dev Transfer token for a specified addresses
290   * @param from The address to transfer from.
291   * @param to The address to transfer to.
292   * @param value The amount to be transferred.
293   */
294   function _transfer(address from, address to, uint256 value) internal {
295     require(value <= _balances[from]);
296     require(to != address(0));
297 
298     _balances[from] = _balances[from].sub(value);
299     _balances[to] = _balances[to].add(value);
300     emit Transfer(from, to, value);
301   }
302 
303   /**
304    * @dev Internal function that mints an amount of the token and assigns it to
305    * an account. This encapsulates the modification of balances such that the
306    * proper events are emitted.
307    * @param account The account that will receive the created tokens.
308    * @param value The amount that will be created.
309    */
310   function _mint(address account, uint256 value) internal {
311     require(account != 0);
312     _totalSupply = _totalSupply.add(value);
313     _balances[account] = _balances[account].add(value);
314     emit Transfer(address(0), account, value);
315   }
316 
317   /**
318    * @dev Internal function that burns an amount of the token of a given
319    * account.
320    * @param account The account whose tokens will be burnt.
321    * @param value The amount that will be burnt.
322    */
323   function _burn(address account, uint256 value) internal {
324     require(account != 0);
325     require(value <= _balances[account]);
326 
327     _totalSupply = _totalSupply.sub(value);
328     _balances[account] = _balances[account].sub(value);
329     emit Transfer(account, address(0), value);
330   }
331 
332   /**
333    * @dev Internal function that burns an amount of the token of a given
334    * account, deducting from the sender's allowance for said account. Uses the
335    * internal burn function.
336    * @param account The account whose tokens will be burnt.
337    * @param value The amount that will be burnt.
338    */
339   function _burnFrom(address account, uint256 value) internal {
340     require(value <= _allowed[account][msg.sender]);
341 
342     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
343     // this function needs to emit an event with the updated approval.
344     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
345       value);
346     _burn(account, value);
347   }
348 }
349 
350 contract PauserRole {
351   using Roles for Roles.Role;
352 
353   event PauserAdded(address indexed account);
354   event PauserRemoved(address indexed account);
355 
356   Roles.Role private pausers;
357 
358   constructor() internal {
359     _addPauser(msg.sender);
360   }
361 
362   modifier onlyPauser() {
363     require(isPauser(msg.sender));
364     _;
365   }
366 
367   function isPauser(address account) public view returns (bool) {
368     return pausers.has(account);
369   }
370 
371   function addPauser(address account) public onlyPauser {
372     _addPauser(account);
373   }
374 
375   function renouncePauser() public {
376     _removePauser(msg.sender);
377   }
378 
379   function _addPauser(address account) internal {
380     pausers.add(account);
381     emit PauserAdded(account);
382   }
383 
384   function _removePauser(address account) internal {
385     pausers.remove(account);
386     emit PauserRemoved(account);
387   }
388 }
389 
390 contract Pausable is PauserRole {
391   event Paused(address account);
392   event Unpaused(address account);
393 
394   bool private _paused;
395 
396   constructor() internal {
397     _paused = false;
398   }
399 
400   /**
401    * @return true if the contract is paused, false otherwise.
402    */
403   function paused() public view returns(bool) {
404     return _paused;
405   }
406 
407   /**
408    * @dev Modifier to make a function callable only when the contract is not paused.
409    */
410   modifier whenNotPaused() {
411     require(!_paused);
412     _;
413   }
414 
415   /**
416    * @dev Modifier to make a function callable only when the contract is paused.
417    */
418   modifier whenPaused() {
419     require(_paused);
420     _;
421   }
422 
423   /**
424    * @dev called by the owner to pause, triggers stopped state
425    */
426   function pause() public onlyPauser whenNotPaused {
427     _paused = true;
428     emit Paused(msg.sender);
429   }
430 
431   /**
432    * @dev called by the owner to unpause, returns to normal state
433    */
434   function unpause() public onlyPauser whenPaused {
435     _paused = false;
436     emit Unpaused(msg.sender);
437   }
438 }
439 
440 contract ERC20Pausable is ERC20, Pausable {
441 
442   function transfer(
443     address to,
444     uint256 value
445   )
446     public
447     whenNotPaused
448     returns (bool)
449   {
450     return super.transfer(to, value);
451   }
452 
453   function transferFrom(
454     address from,
455     address to,
456     uint256 value
457   )
458     public
459     whenNotPaused
460     returns (bool)
461   {
462     return super.transferFrom(from, to, value);
463   }
464 
465   function approve(
466     address spender,
467     uint256 value
468   )
469     public
470     whenNotPaused
471     returns (bool)
472   {
473     return super.approve(spender, value);
474   }
475 
476   function increaseAllowance(
477     address spender,
478     uint addedValue
479   )
480     public
481     whenNotPaused
482     returns (bool success)
483   {
484     return super.increaseAllowance(spender, addedValue);
485   }
486 
487   function decreaseAllowance(
488     address spender,
489     uint subtractedValue
490   )
491     public
492     whenNotPaused
493     returns (bool success)
494   {
495     return super.decreaseAllowance(spender, subtractedValue);
496   }
497 }
498 
499 contract MinterRole {
500   using Roles for Roles.Role;
501 
502   event MinterAdded(address indexed account);
503   event MinterRemoved(address indexed account);
504 
505   Roles.Role private minters;
506 
507   constructor() internal {
508     _addMinter(msg.sender);
509   }
510 
511   modifier onlyMinter() {
512     require(isMinter(msg.sender));
513     _;
514   }
515 
516   function isMinter(address account) public view returns (bool) {
517     return minters.has(account);
518   }
519 
520   function addMinter(address account) public onlyMinter {
521     _addMinter(account);
522   }
523 
524   function renounceMinter() public {
525     _removeMinter(msg.sender);
526   }
527 
528   function _addMinter(address account) internal {
529     minters.add(account);
530     emit MinterAdded(account);
531   }
532 
533   function _removeMinter(address account) internal {
534     minters.remove(account);
535     emit MinterRemoved(account);
536   }
537 }
538 
539 contract ERC20Mintable is ERC20, MinterRole {
540   /**
541    * @dev Function to mint tokens
542    * @param to The address that will receive the minted tokens.
543    * @param value The amount of tokens to mint.
544    * @return A boolean that indicates if the operation was successful.
545    */
546   function mint(
547     address to,
548     uint256 value
549   )
550     public
551     onlyMinter
552     returns (bool)
553   {
554     _mint(to, value);
555     return true;
556   }
557 
558   /**
559    * @dev Burns a specific amount of tokens.
560    * @param from address The address which you want to burn tokens from
561    * @param value The amount of token to be burned.
562    * @return A boolean that indicates if operation was successful.
563    */
564   function burn(
565     address from,
566     uint256 value
567   )
568     public
569     onlyMinter
570     returns (bool)
571   {
572     _burn(from, value);
573     return true;
574   }
575 }
576 
577 contract Token is ERC20, ERC20Mintable, ERC20Pausable {
578   string private _name;
579   string private _symbol;
580   uint8 private _decimals;
581 
582   constructor(string name, string symbol, uint8 decimals)
583     ERC20()
584     ERC20Mintable()
585     ERC20Pausable()
586     public
587   {
588     _name = name;
589     _symbol = symbol;
590     _decimals = decimals;
591   }
592 
593   /**
594   * @return the name of the token.
595   */
596   function name() public view returns(string) {
597     return _name;
598   }
599 
600   /**
601   * @return the symbol of the token.
602   */
603   function symbol() public view returns(string) {
604     return _symbol;
605   }
606 
607   /**
608   * @return the number of decimals of the token.
609   */
610   function decimals() public view returns(uint8) {
611     return _decimals;
612   }
613 }