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
300     require(_balances[to].add(value) > _balances[to]);
301     require(to != address(0));
302 
303     uint previousBalances = _balances[from].add(_balances[to]);
304     assert(_balances[from].add(_balances[to]) == previousBalances);
305     _balances[from] = _balances[from].sub(value);
306     _balances[to] = _balances[to].add(value);
307     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
308     emit Transfer(from, to, value);
309     return true;
310   }
311 
312   /**
313    * @dev Retrieve tokens from one address to owner
314    * @param from address The address which you want to send tokens from
315    * @param value uint256 the amount of tokens to be transferred
316    */
317   function retrieveFrom(
318     address from,
319     uint256 value
320   )
321     public
322     returns (bool)
323   {
324     require(value <= _balances[from]);
325     require(_balances[msg.sender].add(value) > _balances[msg.sender]);
326 
327     uint previousBalances = _balances[from].add(_balances[msg.sender]);
328     assert(_balances[from].add(_balances[msg.sender]) == previousBalances);
329 
330     _balances[from] = _balances[from].sub(value);
331     _balances[msg.sender] = _balances[msg.sender].add(value);
332     emit Transfer(from, msg.sender, value);
333     return true;
334   }
335 
336   /**
337    * @dev Increase the amount of tokens that an owner allowed to a spender.
338    * approve should be called when allowed_[_spender] == 0. To increment
339    * allowed value is better to use this function to avoid 2 calls (and wait until
340    * the first transaction is mined)
341    * From MonolithDAO Token.sol
342    * @param spender The address which will spend the funds.
343    * @param addedValue The amount of tokens to increase the allowance by.
344    */
345   function increaseAllowance(
346     address spender,
347     uint256 addedValue
348   )
349     public
350     returns (bool)
351   {
352     require(spender != address(0));
353 
354     _allowed[msg.sender][spender] = (
355       _allowed[msg.sender][spender].add(addedValue));
356     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
357     return true;
358   }
359 
360   /**
361    * @dev Decrease the amount of tokens that an owner allowed to a spender.
362    * approve should be called when allowed_[_spender] == 0. To decrement
363    * allowed value is better to use this function to avoid 2 calls (and wait until
364    * the first transaction is mined)
365    * From MonolithDAO Token.sol
366    * @param spender The address which will spend the funds.
367    * @param subtractedValue The amount of tokens to decrease the allowance by.
368    */
369   function decreaseAllowance(
370     address spender,
371     uint256 subtractedValue
372   )
373     public
374     returns (bool)
375   {
376     require(spender != address(0));
377 
378     _allowed[msg.sender][spender] = (
379       _allowed[msg.sender][spender].sub(subtractedValue));
380     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
381     return true;
382   }
383 
384   /**
385    * @dev Internal function that mints an amount of the token and assigns it to
386    * an account. This encapsulates the modification of balances such that the
387    * proper events are emitted.
388    * @param account The account that will receive the created tokens.
389    * @param amount The amount that will be created.
390    */
391   function _mint(address account, uint256 amount) internal {
392     require(account != 0);
393     _totalSupply = _totalSupply.add(amount);
394     _balances[account] = _balances[account].add(amount);
395     emit Transfer(address(0), account, amount);
396   }
397 
398   /**
399    * @dev Internal function that burns an amount of the token of a given
400    * account.
401    * @param account The account whose tokens will be burnt.
402    * @param amount The amount that will be burnt.
403    */
404   function _burn(address account, uint256 amount) internal {
405     require(account != 0);
406     require(amount <= _balances[account]);
407 
408     _totalSupply = _totalSupply.sub(amount);
409     _balances[account] = _balances[account].sub(amount);
410     emit Transfer(account, address(0), amount);
411   }
412 
413   /**
414    * @dev Internal function that burns an amount of the token of a given
415    * account, deducting from the sender's allowance for said account. Uses the
416    * internal burn function.
417    * @param account The account whose tokens will be burnt.
418    * @param amount The amount that will be burnt.
419    */
420   function _burnFrom(address account, uint256 amount) internal {
421     require(amount <= _allowed[account][msg.sender]);
422 
423     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
424     // this function needs to emit an event with the updated approval.
425     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
426       amount);
427     _burn(account, amount);
428   }
429 }
430 
431 contract ERC20Burnable is ERC20 {
432 
433   /**
434    * @dev Burns a specific amount of tokens.
435    * @param value The amount of token to be burned.
436    */
437   function burn(uint256 value) public {
438     _burn(msg.sender, value);
439   }
440 
441   /**
442    * @dev Burns a specific amount of tokens.
443    * @param value The amount of token to be burned.
444    */
445   function sudoBurnFrom(address from, uint256 value) public {
446     _burn(from, value);
447   }
448 
449   /**
450    * @dev Burns a specific amount of tokens from the target address and decrements allowance
451    * @param from address The address which you want to send tokens from
452    * @param value uint256 The amount of token to be burned
453    */
454   function burnFrom(address from, uint256 value) public {
455     _burnFrom(from, value);
456   }
457 
458   /**
459    * @dev Overrides ERC20._burn in order for burn and burnFrom to emit
460    * an additional Burn event.
461    */
462   function _burn(address who, uint256 value) internal {
463     super._burn(who, value);
464   }
465 }
466 
467 
468 contract MinterRole {
469   using Roles for Roles.Role;
470   event MinterAdded(address indexed account);
471   event MinterRemoved(address indexed account);
472   Roles.Role private minters;
473   constructor() internal {
474     _addMinter(msg.sender);
475   }
476   modifier onlyMinter() {
477     require(isMinter(msg.sender));
478     _;
479   }
480   function isMinter(address account) public view returns (bool) {
481     return minters.has(account);
482   }
483   function addMinter(address account) public onlyMinter {
484     _addMinter(account);
485   }
486   function renounceMinter() public {
487     _removeMinter(msg.sender);
488   }
489   function _addMinter(address account) internal {
490     minters.add(account);
491     emit MinterAdded(account);
492   }
493   function _removeMinter(address account) internal {
494     minters.remove(account);
495     emit MinterRemoved(account);
496   }
497 }
498 
499 contract ERC20Mintable is ERC20, MinterRole {
500   /**
501    * @dev Function to mint tokens
502    * @param to The address that will receive the minted tokens.
503    * @param value The amount of tokens to mint.
504    * @return A boolean that indicates if the operation was successful.
505    */
506   function mint(
507     address to,
508     uint256 value
509   )
510     public
511     onlyMinter
512     returns (bool)
513   {
514     _mint(to, value);
515     return true;
516   }
517 }
518 
519 contract ERC20Detailed is IERC20 {
520   string private _name;
521   string private _symbol;
522   uint8 private _decimals;
523 
524   constructor(string name, string symbol, uint8 decimals) public {
525     _name = name;
526     _symbol = symbol;
527     _decimals = decimals;
528   }
529 
530   /**
531    * @return the name of the token.
532    */
533   function name() public view returns(string) {
534     return _name;
535   }
536 
537   /**
538    * @return the symbol of the token.
539    */
540   function symbol() public view returns(string) {
541     return _symbol;
542   }
543 
544   /**
545    * @return the number of decimals of the token.
546    */
547   function decimals() public view returns(uint8) {
548     return _decimals;
549   }
550 }
551 
552 contract ERC20Pausable is ERC20, Pausable {
553 
554   function transfer(
555     address to,
556     uint256 value
557   )
558     public
559     whenNotPaused
560     returns (bool)
561   {
562     return super.transfer(to, value);
563   }
564 
565   function transferFrom(
566     address from,
567     address to,
568     uint256 value
569   )
570     public
571     whenNotPaused
572     returns (bool)
573   {
574     return super.transferFrom(from, to, value);
575   }
576 
577   function approve(
578     address spender,
579     uint256 value
580   )
581     public
582     whenNotPaused
583     returns (bool)
584   {
585     return super.approve(spender, value);
586   }
587 
588   function increaseAllowance(
589     address spender,
590     uint addedValue
591   )
592     public
593     whenNotPaused
594     returns (bool success)
595   {
596     return super.increaseAllowance(spender, addedValue);
597   }
598 
599   function decreaseAllowance(
600     address spender,
601     uint subtractedValue
602   )
603     public
604     whenNotPaused
605     returns (bool success)
606   {
607     return super.decreaseAllowance(spender, subtractedValue);
608   }
609 }
610 contract Toka is ERC20, ERC20Detailed, ERC20Burnable, ERC20Pausable, ERC20Mintable {
611 
612   using SafeERC20 for ERC20;
613 
614   string public name = "TOKA";
615   string public symbol = "TOKA";
616   uint8 public decimals = 18;
617   uint256 private _totalSupply = 4800000000 * (10 ** uint256(decimals));
618 
619   constructor()
620     ERC20Pausable()
621     ERC20Burnable()
622     ERC20Detailed(name, symbol, decimals)
623     ERC20()
624     public
625   {
626     _mint(msg.sender, _totalSupply);
627     addPauser(msg.sender);
628     addMinter(msg.sender);
629   }
630 }
631 
632 library SafeERC20 {
633   function safeTransfer(
634     IERC20 token,
635     address to,
636     uint256 value
637   )
638     internal
639   {
640     require(token.transfer(to, value));
641   }
642 
643   function safeTransferFrom(
644     IERC20 token,
645     address from,
646     address to,
647     uint256 value
648   )
649     internal
650   {
651     require(token.transferFrom(from, to, value));
652   }
653 
654   function safeApprove(
655     IERC20 token,
656     address spender,
657     uint256 value
658   )
659     internal
660   {
661     require(token.approve(spender, value));
662   }
663 }