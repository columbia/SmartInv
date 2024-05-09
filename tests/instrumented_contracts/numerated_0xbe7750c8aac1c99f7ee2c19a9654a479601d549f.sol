1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Roles
5  * @dev Library for managing addresses assigned to a Role.
6  */
7 library Roles {
8     struct Role {
9         mapping (address => bool) bearer;
10     }
11   /**
12    * @dev give an account access to this role
13    */
14   function add(Role storage role, address account) internal {
15     require(account != address(0));
16     require(!has(role, account));
17 
18     role.bearer[account] = true;
19   }
20 
21   /**
22    * @dev remove an account's access to this role
23    */
24   function remove(Role storage role, address account) internal {
25     require(account != address(0));
26     require(has(role, account));
27 
28     role.bearer[account] = false;
29   }
30 
31   /**
32    * @dev check if an account has this role
33    * @return bool
34    */
35   function has(Role storage role, address account)
36     internal
37     view
38     returns (bool)
39   {
40     require(account != address(0));
41     return role.bearer[account];
42   }
43 }
44 
45 
46 
47 
48 contract PauserRole {
49   using Roles for Roles.Role;
50 
51   event PauserAdded(address indexed account);
52   event PauserRemoved(address indexed account);
53 
54   Roles.Role private pausers;
55 
56   constructor() internal {
57     _addPauser(msg.sender);
58   }
59 
60   modifier onlyPauser() {
61     require(isPauser(msg.sender));
62     _;
63   }
64 
65   function isPauser(address account) public view returns (bool) {
66     return pausers.has(account);
67   }
68 
69   function addPauser(address account) public onlyPauser {
70     _addPauser(account);
71   }
72 
73   function renouncePauser() public {
74     _removePauser(msg.sender);
75   }
76 
77   function _addPauser(address account) internal {
78     pausers.add(account);
79     emit PauserAdded(account);
80   }
81 
82   function _removePauser(address account) internal {
83     pausers.remove(account);
84     emit PauserRemoved(account);
85   }
86 }
87 
88 
89 /**
90  * @title ERC20 interface
91  * @dev see https://github.com/ethereum/EIPs/issues/20
92  */
93 interface IERC20 {
94   function totalSupply() external view returns (uint256);
95 
96   function balanceOf(address who) external view returns (uint256);
97 
98   function allowance(address owner, address spender)
99     external view returns (uint256);
100 
101   function transfer(address to, uint256 value) external returns (bool);
102 
103   function approve(address spender, uint256 value)
104     external returns (bool);
105 
106   function transferFrom(address from, address to, uint256 value)
107     external returns (bool);
108 
109   event Transfer(
110     address indexed from,
111     address indexed to,
112     uint256 value
113   );
114 
115   event Approval(
116     address indexed owner,
117     address indexed spender,
118     uint256 value
119   );
120 }
121 
122 
123 
124 
125 
126 
127 
128 /**
129  * @title SafeMath
130  * @dev Math operations with safety checks that revert on error
131  */
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
192 
193 /**
194  * @title Standard ERC20 token
195  *
196  * @dev Implementation of the basic standard token.
197  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
198  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
199  */
200 contract ERC20 is IERC20 {
201   using SafeMath for uint256;
202 
203   mapping (address => uint256) private _balances;
204 
205   mapping (address => mapping (address => uint256)) private _allowed;
206 
207   uint256 private _totalSupply;
208 
209   /**
210   * @dev Total number of tokens in existence
211   */
212   function totalSupply() public view returns (uint256) {
213     return _totalSupply;
214   }
215 
216   /**
217   * @dev Gets the balance of the specified address.
218   * @param owner The address to query the balance of.
219   * @return An uint256 representing the amount owned by the passed address.
220   */
221   function balanceOf(address owner) public view returns (uint256) {
222     return _balances[owner];
223   }
224 
225   /**
226    * @dev Function to check the amount of tokens that an owner allowed to a spender.
227    * @param owner address The address which owns the funds.
228    * @param spender address The address which will spend the funds.
229    * @return A uint256 specifying the amount of tokens still available for the spender.
230    */
231   function allowance(
232     address owner,
233     address spender
234    )
235     public
236     view
237     returns (uint256)
238   {
239     return _allowed[owner][spender];
240   }
241 
242   /**
243   * @dev Transfer token for a specified address
244   * @param to The address to transfer to.
245   * @param value The amount to be transferred.
246   */
247   function transfer(address to, uint256 value) public returns (bool) {
248     _transfer(msg.sender, to, value);
249     return true;
250   }
251 
252   /**
253    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
254    * Beware that changing an allowance with this method brings the risk that someone may use both the old
255    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
256    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
257    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
258    * @param spender The address which will spend the funds.
259    * @param value The amount of tokens to be spent.
260    */
261   function approve(address spender, uint256 value) public returns (bool) {
262     require(spender != address(0));
263 
264     _allowed[msg.sender][spender] = value;
265     emit Approval(msg.sender, spender, value);
266     return true;
267   }
268 
269   /**
270    * @dev Transfer tokens from one address to another
271    * @param from address The address which you want to send tokens from
272    * @param to address The address which you want to transfer to
273    * @param value uint256 the amount of tokens to be transferred
274    */
275   function transferFrom(
276     address from,
277     address to,
278     uint256 value
279   )
280     public
281     returns (bool)
282   {
283     require(value <= _allowed[from][msg.sender]);
284 
285     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
286     _transfer(from, to, value);
287     return true;
288   }
289 
290   /**
291    * @dev Increase the amount of tokens that an owner allowed to a spender.
292    * approve should be called when allowed_[_spender] == 0. To increment
293    * allowed value is better to use this function to avoid 2 calls (and wait until
294    * the first transaction is mined)
295    * From MonolithDAO Token.sol
296    * @param spender The address which will spend the funds.
297    * @param addedValue The amount of tokens to increase the allowance by.
298    */
299   function increaseAllowance(
300     address spender,
301     uint256 addedValue
302   )
303     public
304     returns (bool)
305   {
306     require(spender != address(0));
307 
308     _allowed[msg.sender][spender] = (
309       _allowed[msg.sender][spender].add(addedValue));
310     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
311     return true;
312   }
313 
314   /**
315    * @dev Decrease the amount of tokens that an owner allowed to a spender.
316    * approve should be called when allowed_[_spender] == 0. To decrement
317    * allowed value is better to use this function to avoid 2 calls (and wait until
318    * the first transaction is mined)
319    * From MonolithDAO Token.sol
320    * @param spender The address which will spend the funds.
321    * @param subtractedValue The amount of tokens to decrease the allowance by.
322    */
323   function decreaseAllowance(
324     address spender,
325     uint256 subtractedValue
326   )
327     public
328     returns (bool)
329   {
330     require(spender != address(0));
331 
332     _allowed[msg.sender][spender] = (
333       _allowed[msg.sender][spender].sub(subtractedValue));
334     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
335     return true;
336   }
337 
338   /**
339   * @dev Transfer token for a specified addresses
340   * @param from The address to transfer from.
341   * @param to The address to transfer to.
342   * @param value The amount to be transferred.
343   */
344   function _transfer(address from, address to, uint256 value) internal {
345     require(value <= _balances[from]);
346     require(to != address(0));
347 
348     _balances[from] = _balances[from].sub(value);
349     _balances[to] = _balances[to].add(value);
350     emit Transfer(from, to, value);
351   }
352 
353   /**
354    * @dev Internal function that mints an amount of the token and assigns it to
355    * an account. This encapsulates the modification of balances such that the
356    * proper events are emitted.
357    * @param account The account that will receive the created tokens.
358    * @param value The amount that will be created.
359    */
360   function _mint(address account, uint256 value) internal {
361     require(account != 0);
362     _totalSupply = _totalSupply.add(value);
363     _balances[account] = _balances[account].add(value);
364     emit Transfer(address(0), account, value);
365   }
366 
367   /**
368    * @dev Internal function that burns an amount of the token of a given
369    * account.
370    * @param account The account whose tokens will be burnt.
371    * @param value The amount that will be burnt.
372    */
373   function _burn(address account, uint256 value) internal {
374     require(account != 0);
375     require(value <= _balances[account]);
376 
377     _totalSupply = _totalSupply.sub(value);
378     _balances[account] = _balances[account].sub(value);
379     emit Transfer(account, address(0), value);
380   }
381 
382   /**
383    * @dev Internal function that burns an amount of the token of a given
384    * account, deducting from the sender's allowance for said account. Uses the
385    * internal burn function.
386    * @param account The account whose tokens will be burnt.
387    * @param value The amount that will be burnt.
388    */
389   function _burnFrom(address account, uint256 value) internal {
390     require(value <= _allowed[account][msg.sender]);
391 
392     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
393     // this function needs to emit an event with the updated approval.
394     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
395       value);
396     _burn(account, value);
397   }
398 }
399 
400 
401 
402 
403 
404 /**
405  * @title ERC20Detailed token
406  * @dev The decimals are only for visualization purposes.
407  * All the operations are done using the smallest and indivisible token unit,
408  * just as on Ethereum all the operations are done in wei.
409  */
410 contract ERC20Detailed is IERC20 {
411   string private _name;
412   string private _symbol;
413   uint8 private _decimals;
414 
415   constructor(string name, string symbol, uint8 decimals) public {
416     _name = name;
417     _symbol = symbol;
418     _decimals = decimals;
419   }
420 
421   /**
422    * @return the name of the token.
423    */
424   function name() public view returns(string) {
425     return _name;
426   }
427 
428   /**
429    * @return the symbol of the token.
430    */
431   function symbol() public view returns(string) {
432     return _symbol;
433   }
434 
435   /**
436    * @return the number of decimals of the token.
437    */
438   function decimals() public view returns(uint8) {
439     return _decimals;
440   }
441 }
442 
443 
444 
445 
446 
447 
448 
449 
450 /**
451  * @title Pausable
452  * @dev Base contract which allows children to implement an emergency stop mechanism.
453  */
454 contract Pausable is PauserRole {
455   event Paused(address account);
456   event Unpaused(address account);
457 
458   bool private _paused;
459 
460   constructor() internal {
461     _paused = false;
462   }
463 
464   /**
465    * @return true if the contract is paused, false otherwise.
466    */
467   function paused() public view returns(bool) {
468     return _paused;
469   }
470 
471   /**
472    * @dev Modifier to make a function callable only when the contract is not paused.
473    */
474   modifier whenNotPaused() {
475     require(!_paused);
476     _;
477   }
478 
479   /**
480    * @dev Modifier to make a function callable only when the contract is paused.
481    */
482   modifier whenPaused() {
483     require(_paused);
484     _;
485   }
486 
487   /**
488    * @dev called by the owner to pause, triggers stopped state
489    */
490   function pause() public onlyPauser whenNotPaused {
491     _paused = true;
492     emit Paused(msg.sender);
493   }
494 
495   /**
496    * @dev called by the owner to unpause, returns to normal state
497    */
498   function unpause() public onlyPauser whenPaused {
499     _paused = false;
500     emit Unpaused(msg.sender);
501   }
502 }
503 
504 
505 /**
506  * @title Pausable token
507  * @dev ERC20 modified with pausable transfers.
508  **/
509 contract ERC20Pausable is ERC20, Pausable {
510 
511   function transfer(
512     address to,
513     uint256 value
514   )
515     public
516     whenNotPaused
517     returns (bool)
518   {
519     return super.transfer(to, value);
520   }
521 
522   function transferFrom(
523     address from,
524     address to,
525     uint256 value
526   )
527     public
528     whenNotPaused
529     returns (bool)
530   {
531     return super.transferFrom(from, to, value);
532   }
533 
534   function approve(
535     address spender,
536     uint256 value
537   )
538     public
539     whenNotPaused
540     returns (bool)
541   {
542     return super.approve(spender, value);
543   }
544 
545   function increaseAllowance(
546     address spender,
547     uint addedValue
548   )
549     public
550     whenNotPaused
551     returns (bool success)
552   {
553     return super.increaseAllowance(spender, addedValue);
554   }
555 
556   function decreaseAllowance(
557     address spender,
558     uint subtractedValue
559   )
560     public
561     whenNotPaused
562     returns (bool success)
563   {
564     return super.decreaseAllowance(spender, subtractedValue);
565   }
566 }
567 
568 
569 
570 /**
571  * @title Ownable
572  * @dev The Ownable contract has an owner address, and provides basic authorization control
573  * functions, this simplifies the implementation of "user permissions".
574  */
575 contract Ownable {
576   address private _owner;
577 
578   event OwnershipTransferred(
579     address indexed previousOwner,
580     address indexed newOwner
581   );
582 
583   /**
584    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
585    * account.
586    */
587   constructor() internal {
588     _owner = msg.sender;
589     emit OwnershipTransferred(address(0), _owner);
590   }
591 
592   /**
593    * @return the address of the owner.
594    */
595   function owner() public view returns(address) {
596     return _owner;
597   }
598 
599   /**
600    * @dev Throws if called by any account other than the owner.
601    */
602   modifier onlyOwner() {
603     require(isOwner());
604     _;
605   }
606 
607   /**
608    * @return true if `msg.sender` is the owner of the contract.
609    */
610   function isOwner() public view returns(bool) {
611     return msg.sender == _owner;
612   }
613 
614   /**
615    * @dev Allows the current owner to relinquish control of the contract.
616    * @notice Renouncing to ownership will leave the contract without an owner.
617    * It will not be possible to call the functions with the `onlyOwner`
618    * modifier anymore.
619    */
620   function renounceOwnership() public onlyOwner {
621     emit OwnershipTransferred(_owner, address(0));
622     _owner = address(0);
623   }
624 
625   /**
626    * @dev Allows the current owner to transfer control of the contract to a newOwner.
627    * @param newOwner The address to transfer ownership to.
628    */
629   function transferOwnership(address newOwner) public onlyOwner {
630     _transferOwnership(newOwner);
631   }
632 
633   /**
634    * @dev Transfers control of the contract to a newOwner.
635    * @param newOwner The address to transfer ownership to.
636    */
637   function _transferOwnership(address newOwner) internal {
638     require(newOwner != address(0));
639     emit OwnershipTransferred(_owner, newOwner);
640     _owner = newOwner;
641   }
642 }
643 
644 
645 contract ARFREYRToken is ERC20, ERC20Detailed, ERC20Pausable, Ownable {
646     string private constant _name = "ARFREYR";
647     string private constant _symbol = "FRY";
648     uint8 private constant _decimals = 18;
649     
650     //Initialise total supply of our tokens
651     uint256 private constant _totalSupply = 7500 * 10 ** 24;
652 
653     uint256 private constant _crowdsaleSupply = 3825 * 10 ** 24;
654 
655     uint256 private constant _bountySupply = 315 * 10 ** 24;  
656 
657     constructor (address _crowdsaleWallet, address _bountyWallet, address _siteAccount) 
658     	ERC20Detailed(_name, _symbol, _decimals) public {
659         require(_crowdsaleWallet != address(0), "Crowdsale wallet not provided");
660         require(_bountyWallet != address(0), "Bounty wallet not provided");
661         require(_siteAccount != address(0), "Site Account wallet not provided");
662     		
663         _mint(_crowdsaleWallet, _crowdsaleSupply);
664         _mint(_bountyWallet, _bountySupply);
665         _mint(_siteAccount, _totalSupply - (_crowdsaleSupply + _bountySupply));
666     }
667 
668   /**
669    * @dev Burns a specific amount of tokens.
670    * @param value The amount of token to be burned.
671    */
672     function burn(uint256 value) public onlyOwner {
673         require(value <= balanceOf(msg.sender), "Error, trying to burn more than available balance");
674         // no need to require value <= totalSupply, since that would imply the
675         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
676         _burn(msg.sender, value);
677     }
678 }