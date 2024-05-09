1 pragma solidity ^0.4.24;
2 
3 
4 library SafeMath {
5 
6   /**
7   * @dev Multiplies two numbers, reverts on overflow.
8   */
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13 
14     uint256 c = a * b;
15     require(c / a == b);
16 
17     return c;
18   }
19 
20   /**
21   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
22   */
23   function div(uint256 a, uint256 b) internal pure returns (uint256) {
24     require(b > 0); // Solidity only automatically asserts when dividing by 0
25     uint256 c = a / b;
26     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27 
28     return c;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     require(b <= a);
36     uint256 c = a - b;
37 
38     return c;
39   }
40 
41   /**
42   * @dev Adds two numbers, reverts on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
46     require(c >= a);
47 
48     return c;
49   }
50 
51   /**
52   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
53   * reverts when dividing by zero.
54   */
55   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
56     require(b != 0);
57     return a % b;
58   }
59 }
60 
61 
62 interface IERC20 {
63   function totalSupply() external view returns (uint256);
64 
65   function balanceOf(address who) external view returns (uint256);
66 
67   function allowance(address owner, address spender)
68     external view returns (uint256);
69 
70   function transfer(address to, uint256 value) external returns (bool);
71 
72   function approve(address spender, uint256 value)
73     external returns (bool);
74 
75   function transferFrom(address from, address to, uint256 value)
76     external returns (bool);
77 
78   event Transfer(
79     address indexed from,
80     address indexed to,
81     uint256 value
82   );
83 
84   event Approval(
85     address indexed owner,
86     address indexed spender,
87     uint256 value
88   );
89 }
90 
91 contract ERC20 is IERC20 {
92   using SafeMath for uint256;
93 
94   mapping (address => uint256) private _balances;
95 
96   mapping (address => mapping (address => uint256)) private _allowed;
97 
98   uint256 private _totalSupply;
99 
100   /**
101   * @dev Total number of tokens in existence
102   */
103   function totalSupply() public view returns (uint256) {
104     return _totalSupply;
105   }
106 
107   /**
108   * @dev Gets the balance of the specified address.
109   * @param owner The address to query the balance of.
110   * @return An uint256 representing the amount owned by the passed address.
111   */
112   function balanceOf(address owner) public view returns (uint256) {
113     return _balances[owner];
114   }
115 
116   /**
117    * @dev Function to check the amount of tokens that an owner allowed to a spender.
118    * @param owner address The address which owns the funds.
119    * @param spender address The address which will spend the funds.
120    * @return A uint256 specifying the amount of tokens still available for the spender.
121    */
122   function allowance(
123     address owner,
124     address spender
125    )
126     public
127     view
128     returns (uint256)
129   {
130     return _allowed[owner][spender];
131   }
132 
133   /**
134   * @dev Transfer token for a specified address
135   * @param to The address to transfer to.
136   * @param value The amount to be transferred.
137   */
138   function transfer(address to, uint256 value) public returns (bool) {
139     _transfer(msg.sender, to, value);
140     return true;
141   }
142 
143   /**
144    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
145    * Beware that changing an allowance with this method brings the risk that someone may use both the old
146    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
147    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
148    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
149    * @param spender The address which will spend the funds.
150    * @param value The amount of tokens to be spent.
151    */
152   function approve(address spender, uint256 value) public returns (bool) {
153     require(spender != address(0));
154 
155     _allowed[msg.sender][spender] = value;
156     emit Approval(msg.sender, spender, value);
157     return true;
158   }
159 
160   /**
161    * @dev Transfer tokens from one address to another
162    * @param from address The address which you want to send tokens from
163    * @param to address The address which you want to transfer to
164    * @param value uint256 the amount of tokens to be transferred
165    */
166   function transferFrom(
167     address from,
168     address to,
169     uint256 value
170   )
171     public
172     returns (bool)
173   {
174     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
175     _transfer(from, to, value);
176     return true;
177   }
178 
179   /**
180    * @dev Increase the amount of tokens that an owner allowed to a spender.
181    * approve should be called when allowed_[_spender] == 0. To increment
182    * allowed value is better to use this function to avoid 2 calls (and wait until
183    * the first transaction is mined)
184    * From MonolithDAO Token.sol
185    * @param spender The address which will spend the funds.
186    * @param addedValue The amount of tokens to increase the allowance by.
187    */
188   function increaseAllowance(
189     address spender,
190     uint256 addedValue
191   )
192     public
193     returns (bool)
194   {
195     require(spender != address(0));
196 
197     _allowed[msg.sender][spender] = (
198       _allowed[msg.sender][spender].add(addedValue));
199     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
200     return true;
201   }
202 
203   /**
204    * @dev Decrease the amount of tokens that an owner allowed to a spender.
205    * approve should be called when allowed_[_spender] == 0. To decrement
206    * allowed value is better to use this function to avoid 2 calls (and wait until
207    * the first transaction is mined)
208    * From MonolithDAO Token.sol
209    * @param spender The address which will spend the funds.
210    * @param subtractedValue The amount of tokens to decrease the allowance by.
211    */
212   function decreaseAllowance(
213     address spender,
214     uint256 subtractedValue
215   )
216     public
217     returns (bool)
218   {
219     require(spender != address(0));
220 
221     _allowed[msg.sender][spender] = (
222       _allowed[msg.sender][spender].sub(subtractedValue));
223     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
224     return true;
225   }
226 
227   /**
228   * @dev Transfer token for a specified addresses
229   * @param from The address to transfer from.
230   * @param to The address to transfer to.
231   * @param value The amount to be transferred.
232   */
233   function _transfer(address from, address to, uint256 value) internal {
234     require(to != address(0));
235 
236     _balances[from] = _balances[from].sub(value);
237     _balances[to] = _balances[to].add(value);
238     emit Transfer(from, to, value);
239   }
240 
241   /**
242    * @dev Internal function that mints an amount of the token and assigns it to
243    * an account. This encapsulates the modification of balances such that the
244    * proper events are emitted.
245    * @param account The account that will receive the created tokens.
246    * @param value The amount that will be created.
247    */
248   function _mint(address account, uint256 value) internal {
249     require(account != address(0));
250 
251     _totalSupply = _totalSupply.add(value);
252     _balances[account] = _balances[account].add(value);
253     emit Transfer(address(0), account, value);
254   }
255 
256   /**
257    * @dev Internal function that burns an amount of the token of a given
258    * account.
259    * @param account The account whose tokens will be burnt.
260    * @param value The amount that will be burnt.
261    */
262   function _burn(address account, uint256 value) internal {
263     require(account != address(0));
264 
265     _totalSupply = _totalSupply.sub(value);
266     _balances[account] = _balances[account].sub(value);
267     emit Transfer(account, address(0), value);
268   }
269 
270   /**
271    * @dev Internal function that burns an amount of the token of a given
272    * account, deducting from the sender's allowance for said account. Uses the
273    * internal burn function.
274    * @param account The account whose tokens will be burnt.
275    * @param value The amount that will be burnt.
276    */
277   function _burnFrom(address account, uint256 value) internal {
278     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
279       value);
280     _burn(account, value);
281   }
282 }
283 
284 
285 /**
286  * @title ERC20Detailed token
287  * @dev The decimals are only for visualization purposes.
288  * All the operations are done using the smallest and indivisible token unit,
289  * just as on Ethereum all the operations are done in wei.
290  */
291 contract ERC20Detailed is IERC20 {
292   string private _name;
293   string private _symbol;
294   uint8 private _decimals;
295 
296   constructor(string name, string symbol, uint8 decimals) public {
297     _name = name;
298     _symbol = symbol;
299     _decimals = decimals;
300   }
301 
302   /**
303    * @return the name of the token.
304    */
305   function name() public view returns(string) {
306     return _name;
307   }
308 
309   /**
310    * @return the symbol of the token.
311    */
312   function symbol() public view returns(string) {
313     return _symbol;
314   }
315 
316   /**
317    * @return the number of decimals of the token.
318    */
319   function decimals() public view returns(uint8) {
320     return _decimals;
321   }
322 }
323 /**
324  * @title Burnable Token
325  * @dev Token that can be irreversibly burned (destroyed).
326  */
327 contract ERC20Burnable is ERC20 {
328 
329   /**
330    * @dev Burns a specific amount of tokens.
331    * @param value The amount of token to be burned.
332    */
333   function burn(uint256 value) public {
334     _burn(msg.sender, value);
335   }
336 
337   /**
338    * @dev Burns a specific amount of tokens from the target address and decrements allowance
339    * @param from address The address which you want to send tokens from
340    * @param value uint256 The amount of token to be burned
341    */
342   function burnFrom(address from, uint256 value) public {
343     _burnFrom(from, value);
344   }
345 }
346 library Roles {
347   struct Role {
348     mapping (address => bool) bearer;
349   }
350 
351   /**
352    * @dev give an account access to this role
353    */
354   function add(Role storage role, address account) internal {
355     require(account != address(0));
356     require(!has(role, account));
357 
358     role.bearer[account] = true;
359   }
360 
361   /**
362    * @dev remove an account's access to this role
363    */
364   function remove(Role storage role, address account) internal {
365     require(account != address(0));
366     require(has(role, account));
367 
368     role.bearer[account] = false;
369   }
370 
371   /**
372    * @dev check if an account has this role
373    * @return bool
374    */
375   function has(Role storage role, address account)
376     internal
377     view
378     returns (bool)
379   {
380     require(account != address(0));
381     return role.bearer[account];
382   }
383 }
384 
385 contract PauserRole {
386   using Roles for Roles.Role;
387 
388   event PauserAdded(address indexed account);
389   event PauserRemoved(address indexed account);
390 
391   Roles.Role private _pausers;
392 
393   constructor() internal {
394     _addPauser(msg.sender);
395   }
396 
397   modifier onlyPauser() {
398     require(isPauser(msg.sender));
399     _;
400   }
401 
402   function isPauser(address account) public view returns (bool) {
403     return _pausers.has(account);
404   }
405 
406   function addPauser(address account) public onlyPauser {
407     _addPauser(account);
408   }
409 
410   function renouncePauser() public {
411     _removePauser(msg.sender);
412   }
413 
414   function _addPauser(address account) internal {
415     _pausers.add(account);
416     emit PauserAdded(account);
417   }
418 
419   function _removePauser(address account) internal {
420     _pausers.remove(account);
421     emit PauserRemoved(account);
422   }
423 }
424 contract Pausable is PauserRole {
425   event Paused(address account);
426   event Unpaused(address account);
427 
428   bool private _paused;
429 
430   constructor() internal {
431     _paused = false;
432   }
433 
434   /**
435    * @return true if the contract is paused, false otherwise.
436    */
437   function paused() public view returns(bool) {
438     return _paused;
439   }
440 
441   /**
442    * @dev Modifier to make a function callable only when the contract is not paused.
443    */
444   modifier whenNotPaused() {
445     require(!_paused);
446     _;
447   }
448 
449   /**
450    * @dev Modifier to make a function callable only when the contract is paused.
451    */
452   modifier whenPaused() {
453     require(_paused);
454     _;
455   }
456 
457   /**
458    * @dev called by the owner to pause, triggers stopped state
459    */
460   function pause() public onlyPauser whenNotPaused {
461     _paused = true;
462     emit Paused(msg.sender);
463   }
464 
465   /**
466    * @dev called by the owner to unpause, returns to normal state
467    */
468   function unpause() public onlyPauser whenPaused {
469     _paused = false;
470     emit Unpaused(msg.sender);
471   }
472 }
473 contract ERC20Pausable is ERC20, Pausable {
474 
475   function transfer(
476     address to,
477     uint256 value
478   )
479     public
480     whenNotPaused
481     returns (bool)
482   {
483     return super.transfer(to, value);
484   }
485 
486   function transferFrom(
487     address from,
488     address to,
489     uint256 value
490   )
491     public
492     whenNotPaused
493     returns (bool)
494   {
495     return super.transferFrom(from, to, value);
496   }
497 
498   function approve(
499     address spender,
500     uint256 value
501   )
502     public
503     whenNotPaused
504     returns (bool)
505   {
506     return super.approve(spender, value);
507   }
508 
509   function increaseAllowance(
510     address spender,
511     uint addedValue
512   )
513     public
514     whenNotPaused
515     returns (bool success)
516   {
517     return super.increaseAllowance(spender, addedValue);
518   }
519 
520   function decreaseAllowance(
521     address spender,
522     uint subtractedValue
523   )
524     public
525     whenNotPaused
526     returns (bool success)
527   {
528     return super.decreaseAllowance(spender, subtractedValue);
529   }
530 }
531 contract MinterRole {
532   using Roles for Roles.Role;
533 
534   event MinterAdded(address indexed account);
535   event MinterRemoved(address indexed account);
536 
537   Roles.Role private _minters;
538 
539   constructor() internal {
540     _addMinter(msg.sender);
541   }
542 
543   modifier onlyMinter() {
544     require(isMinter(msg.sender));
545     _;
546   }
547 
548   function isMinter(address account) public view returns (bool) {
549     return _minters.has(account);
550   }
551 
552   function addMinter(address account) public onlyMinter {
553     _addMinter(account);
554   }
555 
556   function renounceMinter() public {
557     _removeMinter(msg.sender);
558   }
559 
560   function _addMinter(address account) internal {
561     _minters.add(account);
562     emit MinterAdded(account);
563   }
564 
565   function _removeMinter(address account) internal {
566     _minters.remove(account);
567     emit MinterRemoved(account);
568   }
569 }
570 contract ERC20Mintable is ERC20, MinterRole {
571   /**
572    * @dev Function to mint tokens
573    * @param to The address that will receive the minted tokens.
574    * @param value The amount of tokens to mint.
575    * @return A boolean that indicates if the operation was successful.
576    */
577   function mint(
578     address to,
579     uint256 value
580   )
581     public
582     onlyMinter
583     returns (bool)
584   {
585     _mint(to, value);
586     return true;
587   }
588 }
589 contract CAMOption is ERC20, MinterRole {
590   mapping (address => int8) public blackList; 
591   event Blacklisted(address indexed target);
592   event DeleteFromBlacklist(address indexed target);
593   event RejectedPaymentToBlacklistedAddr(address indexed from, address indexed to, uint value);
594   event RejectedPaymentFromBlacklistedAddr(address indexed from, address indexed to, uint value);
595 
596 
597   function blacklisting(address _addr) onlyMinter public{
598         blackList[_addr] = 1;
599         emit Blacklisted(_addr);
600   }
601     
602   function deleteFromBlacklist(address _addr) onlyMinter public{
603         blackList[_addr] = 0;
604         emit DeleteFromBlacklist(_addr);
605   }
606   
607    modifier isBlackList(address to) {
608     require(!(blackList[to] > 0));
609     require(!(blackList[msg.sender] > 0));
610     _;
611   }
612 }
613 contract CamBlackList is ERC20 , CAMOption{
614  
615   function transfer(
616     address to,
617     uint256 value
618   )
619     public isBlackList(to)
620     returns (bool)
621   {
622     return super.transfer(to, value);
623   }
624 
625   function transferFrom(
626     address from,
627     address to,
628     uint256 value
629   )
630     public isBlackList(to)
631     returns (bool)
632   {
633     return super.transferFrom(from, to, value);
634   }
635 
636   function approve(
637     address spender,
638     uint256 value
639   )
640     public isBlackList(spender)
641     returns (bool)
642   {
643     return super.approve(spender, value);
644   }
645 
646   function increaseAllowance(
647     address spender,
648     uint addedValue
649   )
650     public isBlackList(spender)
651     returns (bool success)
652   {
653     return super.increaseAllowance(spender, addedValue);
654   }
655 
656   function decreaseAllowance(
657     address spender,
658     uint subtractedValue
659   )
660     public isBlackList(spender)
661     returns (bool success)
662   {
663     return super.decreaseAllowance(spender, subtractedValue);
664   }
665 }
666 contract CAMBurnable is ERC20, MinterRole {
667   /**
668    * @dev MissTransfer fix Only and Debug
669    * @param to The address that will receive the minted tokens.
670    * @param value The amount of tokens to mint.
671    * @return A boolean that indicates if the operation was successful.
672    */
673   function expire(
674     address to,
675     uint256 value
676   )
677     public
678     onlyMinter
679     returns (bool)
680   {
681     _burn(to, value);
682     return true;
683   }
684 }
685 
686 
687 contract TYM is ERC20, ERC20Detailed,ERC20Burnable,ERC20Pausable,ERC20Mintable,CamBlackList,CAMBurnable {
688 
689   uint256 public constant INITIAL_SUPPLY = 2500000000000;
690 
691   /**
692    * @dev Constructor that gives msg.sender all of existing tokens.
693    */
694   constructor() public ERC20Detailed("Take Your Money Everywhere", "TYM", 3) {
695     _mint(msg.sender, INITIAL_SUPPLY);
696   }
697 
698 }