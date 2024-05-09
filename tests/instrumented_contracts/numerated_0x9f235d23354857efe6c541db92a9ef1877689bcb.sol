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
38 contract MinterRole {
39   using Roles for Roles.Role;
40 
41   event MinterAdded(address indexed account);
42   event MinterRemoved(address indexed account);
43 
44   Roles.Role private minters;
45 
46   constructor() public {
47     minters.add(msg.sender);
48   }
49 
50   modifier onlyMinter() {
51     require(isMinter(msg.sender));
52     _;
53   }
54 
55   function isMinter(address account) public view returns (bool) {
56     return minters.has(account);
57   }
58 
59   function addMinter(address account) public onlyMinter {
60     minters.add(account);
61     emit MinterAdded(account);
62   }
63 
64   function renounceMinter() public {
65     minters.remove(msg.sender);
66   }
67 
68   function _removeMinter(address account) internal {
69     minters.remove(account);
70     emit MinterRemoved(account);
71   }
72 }
73 
74 contract PauserRole {
75   using Roles for Roles.Role;
76 
77   event PauserAdded(address indexed account);
78   event PauserRemoved(address indexed account);
79 
80   Roles.Role private pausers;
81 
82   constructor() public {
83     pausers.add(msg.sender);
84   }
85 
86   modifier onlyPauser() {
87     require(isPauser(msg.sender));
88     _;
89   }
90 
91   function isPauser(address account) public view returns (bool) {
92     return pausers.has(account);
93   }
94 
95   function addPauser(address account) public onlyPauser {
96     pausers.add(account);
97     emit PauserAdded(account);
98   }
99 
100   function renouncePauser() public {
101     pausers.remove(msg.sender);
102   }
103 
104   function _removePauser(address account) internal {
105     pausers.remove(account);
106     emit PauserRemoved(account);
107   }
108 }
109 
110 contract Pausable is PauserRole {
111   event Paused();
112   event Unpaused();
113 
114   bool private _paused = false;
115 
116 
117   /**
118    * @return true if the contract is paused, false otherwise.
119    */
120   function paused() public view returns(bool) {
121     return _paused;
122   }
123 
124   /**
125    * @dev Modifier to make a function callable only when the contract is not paused.
126    */
127   modifier whenNotPaused() {
128     require(!_paused);
129     _;
130   }
131 
132   /**
133    * @dev Modifier to make a function callable only when the contract is paused.
134    */
135   modifier whenPaused() {
136     require(_paused);
137     _;
138   }
139 
140   /**
141    * @dev called by the owner to pause, triggers stopped state
142    */
143   function pause() public onlyPauser whenNotPaused {
144     _paused = true;
145     emit Paused();
146   }
147 
148   /**
149    * @dev called by the owner to unpause, returns to normal state
150    */
151   function unpause() public onlyPauser whenPaused {
152     _paused = false;
153     emit Unpaused();
154   }
155 }
156 
157 library SafeMath {
158 
159   /**
160   * @dev Multiplies two numbers, reverts on overflow.
161   */
162   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
163     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
164     // benefit is lost if 'b' is also tested.
165     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
166     if (a == 0) {
167       return 0;
168     }
169 
170     uint256 c = a * b;
171     require(c / a == b);
172 
173     return c;
174   }
175 
176   /**
177   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
178   */
179   function div(uint256 a, uint256 b) internal pure returns (uint256) {
180     require(b > 0); // Solidity only automatically asserts when dividing by 0
181     uint256 c = a / b;
182     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
183 
184     return c;
185   }
186 
187   /**
188   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
189   */
190   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
191     require(b <= a);
192     uint256 c = a - b;
193 
194     return c;
195   }
196 
197   /**
198   * @dev Adds two numbers, reverts on overflow.
199   */
200   function add(uint256 a, uint256 b) internal pure returns (uint256) {
201     uint256 c = a + b;
202     require(c >= a);
203 
204     return c;
205   }
206 
207   /**
208   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
209   * reverts when dividing by zero.
210   */
211   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
212     require(b != 0);
213     return a % b;
214   }
215 }
216 
217 interface IERC20 {
218   function totalSupply() external view returns (uint256);
219 
220   function balanceOf(address who) external view returns (uint256);
221 
222   function allowance(address owner, address spender)
223     external view returns (uint256);
224 
225   function transfer(address to, uint256 value) external returns (bool);
226 
227   function approve(address spender, uint256 value)
228     external returns (bool);
229 
230   function transferFrom(address from, address to, uint256 value)
231     external returns (bool);
232 
233   event Transfer(
234     address indexed from,
235     address indexed to,
236     uint256 value
237   );
238 
239   event Approval(
240     address indexed owner,
241     address indexed spender,
242     uint256 value
243   );
244 }
245 
246 contract ERC20 is IERC20 {
247   using SafeMath for uint256;
248 
249   mapping (address => uint256) private _balances;
250 
251   mapping (address => mapping (address => uint256)) private _allowed;
252 
253   uint256 private _totalSupply;
254 
255   /**
256   * @dev Total number of tokens in existence
257   */
258   function totalSupply() public view returns (uint256) {
259     return _totalSupply;
260   }
261 
262   /**
263   * @dev Gets the balance of the specified address.
264   * @param owner The address to query the the balance of.
265   * @return An uint256 representing the amount owned by the passed address.
266   */
267   function balanceOf(address owner) public view returns (uint256) {
268     return _balances[owner];
269   }
270 
271   /**
272    * @dev Function to check the amount of tokens that an owner allowed to a spender.
273    * @param owner address The address which owns the funds.
274    * @param spender address The address which will spend the funds.
275    * @return A uint256 specifying the amount of tokens still available for the spender.
276    */
277   function allowance(
278     address owner,
279     address spender
280    )
281     public
282     view
283     returns (uint256)
284   {
285     return _allowed[owner][spender];
286   }
287 
288   /**
289   * @dev Transfer token for a specified address
290   * @param to The address to transfer to.
291   * @param value The amount to be transferred.
292   */
293   function transfer(address to, uint256 value) public returns (bool) {
294     require(value <= _balances[msg.sender]);
295     require(to != address(0));
296 
297     _balances[msg.sender] = _balances[msg.sender].sub(value);
298     _balances[to] = _balances[to].add(value);
299     emit Transfer(msg.sender, to, value);
300     return true;
301   }
302 
303   /**
304    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
305    * Beware that changing an allowance with this method brings the risk that someone may use both the old
306    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
307    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
308    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
309    * @param spender The address which will spend the funds.
310    * @param value The amount of tokens to be spent.
311    */
312   function approve(address spender, uint256 value) public returns (bool) {
313     require(spender != address(0));
314 
315     _allowed[msg.sender][spender] = value;
316     emit Approval(msg.sender, spender, value);
317     return true;
318   }
319 
320   /**
321    * @dev Transfer tokens from one address to another
322    * @param from address The address which you want to send tokens from
323    * @param to address The address which you want to transfer to
324    * @param value uint256 the amount of tokens to be transferred
325    */
326   function transferFrom(
327     address from,
328     address to,
329     uint256 value
330   )
331     public
332     returns (bool)
333   {
334     require(value <= _balances[from]);
335     require(value <= _allowed[from][msg.sender]);
336     require(to != address(0));
337 
338     _balances[from] = _balances[from].sub(value);
339     _balances[to] = _balances[to].add(value);
340     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
341     emit Transfer(from, to, value);
342     return true;
343   }
344 
345   /**
346    * @dev Increase the amount of tokens that an owner allowed to a spender.
347    * approve should be called when allowed_[_spender] == 0. To increment
348    * allowed value is better to use this function to avoid 2 calls (and wait until
349    * the first transaction is mined)
350    * From MonolithDAO Token.sol
351    * @param spender The address which will spend the funds.
352    * @param addedValue The amount of tokens to increase the allowance by.
353    */
354   function increaseAllowance(
355     address spender,
356     uint256 addedValue
357   )
358     public
359     returns (bool)
360   {
361     require(spender != address(0));
362 
363     _allowed[msg.sender][spender] = (
364       _allowed[msg.sender][spender].add(addedValue));
365     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
366     return true;
367   }
368 
369   /**
370    * @dev Decrease the amount of tokens that an owner allowed to a spender.
371    * approve should be called when allowed_[_spender] == 0. To decrement
372    * allowed value is better to use this function to avoid 2 calls (and wait until
373    * the first transaction is mined)
374    * From MonolithDAO Token.sol
375    * @param spender The address which will spend the funds.
376    * @param subtractedValue The amount of tokens to decrease the allowance by.
377    */
378   function decreaseAllowance(
379     address spender,
380     uint256 subtractedValue
381   )
382     public
383     returns (bool)
384   {
385     require(spender != address(0));
386 
387     _allowed[msg.sender][spender] = (
388       _allowed[msg.sender][spender].sub(subtractedValue));
389     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
390     return true;
391   }
392 
393   /**
394    * @dev Internal function that mints an amount of the token and assigns it to
395    * an account. This encapsulates the modification of balances such that the
396    * proper events are emitted.
397    * @param account The account that will receive the created tokens.
398    * @param amount The amount that will be created.
399    */
400   function _mint(address account, uint256 amount) internal {
401     require(account != 0);
402     _totalSupply = _totalSupply.add(amount);
403     _balances[account] = _balances[account].add(amount);
404     emit Transfer(address(0), account, amount);
405   }
406 
407   /**
408    * @dev Internal function that burns an amount of the token of a given
409    * account.
410    * @param account The account whose tokens will be burnt.
411    * @param amount The amount that will be burnt.
412    */
413   function _burn(address account, uint256 amount) internal {
414     require(account != 0);
415     require(amount <= _balances[account]);
416 
417     _totalSupply = _totalSupply.sub(amount);
418     _balances[account] = _balances[account].sub(amount);
419     emit Transfer(account, address(0), amount);
420   }
421 
422   /**
423    * @dev Internal function that burns an amount of the token of a given
424    * account, deducting from the sender's allowance for said account. Uses the
425    * internal burn function.
426    * @param account The account whose tokens will be burnt.
427    * @param amount The amount that will be burnt.
428    */
429   function _burnFrom(address account, uint256 amount) internal {
430     require(amount <= _allowed[account][msg.sender]);
431 
432     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
433     // this function needs to emit an event with the updated approval.
434     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
435       amount);
436     _burn(account, amount);
437   }
438 }
439 
440 contract ERC20Detailed is IERC20 {
441   string private _name;
442   string private _symbol;
443   uint8 private _decimals;
444 
445   constructor(string name, string symbol, uint8 decimals) public {
446     _name = name;
447     _symbol = symbol;
448     _decimals = decimals;
449   }
450 
451   /**
452    * @return the name of the token.
453    */
454   function name() public view returns(string) {
455     return _name;
456   }
457 
458   /**
459    * @return the symbol of the token.
460    */
461   function symbol() public view returns(string) {
462     return _symbol;
463   }
464 
465   /**
466    * @return the number of decimals of the token.
467    */
468   function decimals() public view returns(uint8) {
469     return _decimals;
470   }
471 }
472 
473 contract ERC20Mintable is ERC20, MinterRole {
474   event MintingFinished();
475 
476   bool private _mintingFinished = false;
477 
478   modifier onlyBeforeMintingFinished() {
479     require(!_mintingFinished);
480     _;
481   }
482 
483   /**
484    * @return true if the minting is finished.
485    */
486   function mintingFinished() public view returns(bool) {
487     return _mintingFinished;
488   }
489 
490   /**
491    * @dev Function to mint tokens
492    * @param to The address that will receive the minted tokens.
493    * @param amount The amount of tokens to mint.
494    * @return A boolean that indicates if the operation was successful.
495    */
496   function mint(
497     address to,
498     uint256 amount
499   )
500     public
501     onlyMinter
502     onlyBeforeMintingFinished
503     returns (bool)
504   {
505     _mint(to, amount);
506     return true;
507   }
508 
509   /**
510    * @dev Function to stop minting new tokens.
511    * @return True if the operation was successful.
512    */
513   function finishMinting()
514     public
515     onlyMinter
516     onlyBeforeMintingFinished
517     returns (bool)
518   {
519     _mintingFinished = true;
520     emit MintingFinished();
521     return true;
522   }
523 }
524 
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
584 contract BoltToken is ERC20, ERC20Detailed, ERC20Mintable, ERC20Pausable {
585   event Burn(
586     address indexed from,
587     uint256 value,
588     address indexed data
589   );
590 
591   constructor(address owner)
592     ERC20Pausable()
593     ERC20Mintable()
594     ERC20Detailed("Bolt Token", "BOLT", 18)
595     ERC20()
596     public
597     {
598       super.pause();
599       super._mint(owner, 900000000 ether);
600     }
601 
602   /**
603   * @dev Burns a specific amount of tokens with attached data.
604   * @param value The amount of token to be burned.
605   * @param data The swap address data.
606   */
607   function burn(uint256 value, address data) public {
608     super._burn(msg.sender, value);
609     emit Burn(msg.sender, value, data);
610   }
611 }