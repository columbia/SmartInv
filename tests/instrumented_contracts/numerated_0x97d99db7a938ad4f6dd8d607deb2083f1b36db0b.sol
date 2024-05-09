1 pragma solidity 0.4.24;
2 
3 // File: contracts/lib/openzeppelin-solidity/contracts/access/Roles.sol
4 
5 /**
6  * @title Roles
7  * @dev Library for managing addresses assigned to a Role.
8  */
9 library Roles {
10   struct Role {
11     mapping (address => bool) bearer;
12   }
13 
14   /**
15    * @dev give an account access to this role
16    */
17   function add(Role storage role, address account) internal {
18     require(account != address(0));
19     require(!has(role, account));
20 
21     role.bearer[account] = true;
22   }
23 
24   /**
25    * @dev remove an account's access to this role
26    */
27   function remove(Role storage role, address account) internal {
28     require(account != address(0));
29     require(has(role, account));
30 
31     role.bearer[account] = false;
32   }
33 
34   /**
35    * @dev check if an account has this role
36    * @return bool
37    */
38   function has(Role storage role, address account)
39     internal
40     view
41     returns (bool)
42   {
43     require(account != address(0));
44     return role.bearer[account];
45   }
46 }
47 
48 // File: contracts/lib/openzeppelin-solidity/contracts/access/roles/PauserRole.sol
49 
50 contract PauserRole {
51   using Roles for Roles.Role;
52 
53   event PauserAdded(address indexed account);
54   event PauserRemoved(address indexed account);
55 
56   Roles.Role private pausers;
57 
58   constructor() internal {
59     _addPauser(msg.sender);
60   }
61 
62   modifier onlyPauser() {
63     require(isPauser(msg.sender));
64     _;
65   }
66 
67   function isPauser(address account) public view returns (bool) {
68     return pausers.has(account);
69   }
70 
71   function addPauser(address account) public onlyPauser {
72     _addPauser(account);
73   }
74 
75   function renouncePauser() public {
76     _removePauser(msg.sender);
77   }
78 
79   function _addPauser(address account) internal {
80     pausers.add(account);
81     emit PauserAdded(account);
82   }
83 
84   function _removePauser(address account) internal {
85     pausers.remove(account);
86     emit PauserRemoved(account);
87   }
88 }
89 
90 // File: contracts/lib/openzeppelin-solidity/contracts/lifecycle/Pausable.sol
91 
92 /**
93  * @title Pausable
94  * @dev Base contract which allows children to implement an emergency stop mechanism.
95  */
96 contract Pausable is PauserRole {
97   event Paused(address account);
98   event Unpaused(address account);
99 
100   bool private _paused;
101 
102   constructor() internal {
103     _paused = false;
104   }
105 
106   /**
107    * @return true if the contract is paused, false otherwise.
108    */
109   function paused() public view returns(bool) {
110     return _paused;
111   }
112 
113   /**
114    * @dev Modifier to make a function callable only when the contract is not paused.
115    */
116   modifier whenNotPaused() {
117     require(!_paused);
118     _;
119   }
120 
121   /**
122    * @dev Modifier to make a function callable only when the contract is paused.
123    */
124   modifier whenPaused() {
125     require(_paused);
126     _;
127   }
128 
129   /**
130    * @dev called by the owner to pause, triggers stopped state
131    */
132   function pause() public onlyPauser whenNotPaused {
133     _paused = true;
134     emit Paused(msg.sender);
135   }
136 
137   /**
138    * @dev called by the owner to unpause, returns to normal state
139    */
140   function unpause() public onlyPauser whenPaused {
141     _paused = false;
142     emit Unpaused(msg.sender);
143   }
144 }
145 
146 // File: contracts/lib/openzeppelin-solidity/contracts/ownership/Ownable.sol
147 
148 /**
149  * @title Ownable
150  * @dev The Ownable contract has an owner address, and provides basic authorization control
151  * functions, this simplifies the implementation of "user permissions".
152  */
153 contract Ownable {
154   address private _owner;
155 
156   event OwnershipTransferred(
157     address indexed previousOwner,
158     address indexed newOwner
159   );
160 
161   /**
162    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
163    * account.
164    */
165   constructor() internal {
166     _owner = msg.sender;
167     emit OwnershipTransferred(address(0), _owner);
168   }
169 
170   /**
171    * @return the address of the owner.
172    */
173   function owner() public view returns(address) {
174     return _owner;
175   }
176 
177   /**
178    * @dev Throws if called by any account other than the owner.
179    */
180   modifier onlyOwner() {
181     require(isOwner());
182     _;
183   }
184 
185   /**
186    * @return true if `msg.sender` is the owner of the contract.
187    */
188   function isOwner() public view returns(bool) {
189     return msg.sender == _owner;
190   }
191 
192   /**
193    * @dev Allows the current owner to relinquish control of the contract.
194    * @notice Renouncing to ownership will leave the contract without an owner.
195    * It will not be possible to call the functions with the `onlyOwner`
196    * modifier anymore.
197    */
198   function renounceOwnership() public onlyOwner {
199     emit OwnershipTransferred(_owner, address(0));
200     _owner = address(0);
201   }
202 
203   /**
204    * @dev Allows the current owner to transfer control of the contract to a newOwner.
205    * @param newOwner The address to transfer ownership to.
206    */
207   function transferOwnership(address newOwner) public onlyOwner {
208     _transferOwnership(newOwner);
209   }
210 
211   /**
212    * @dev Transfers control of the contract to a newOwner.
213    * @param newOwner The address to transfer ownership to.
214    */
215   function _transferOwnership(address newOwner) internal {
216     require(newOwner != address(0));
217     emit OwnershipTransferred(_owner, newOwner);
218     _owner = newOwner;
219   }
220 }
221 
222 // File: contracts/lib/openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol
223 
224 /**
225  * @title Helps contracts guard against reentrancy attacks.
226  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
227  * @dev If you mark a function `nonReentrant`, you should also
228  * mark it `external`.
229  */
230 contract ReentrancyGuard {
231 
232   /// @dev counter to allow mutex lock with only one SSTORE operation
233   uint256 private _guardCounter;
234 
235   constructor() internal {
236     // The counter starts at one to prevent changing it from zero to a non-zero
237     // value, which is a more expensive operation.
238     _guardCounter = 1;
239   }
240 
241   /**
242    * @dev Prevents a contract from calling itself, directly or indirectly.
243    * Calling a `nonReentrant` function from another `nonReentrant`
244    * function is not supported. It is possible to prevent this from happening
245    * by making the `nonReentrant` function external, and make it call a
246    * `private` function that does the actual work.
247    */
248   modifier nonReentrant() {
249     _guardCounter += 1;
250     uint256 localCounter = _guardCounter;
251     _;
252     require(localCounter == _guardCounter);
253   }
254 
255 }
256 
257 // File: contracts/lib/openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
258 
259 /**
260  * @title ERC20 interface
261  * @dev see https://github.com/ethereum/EIPs/issues/20
262  */
263 interface IERC20 {
264   function totalSupply() external view returns (uint256);
265 
266   function balanceOf(address who) external view returns (uint256);
267 
268   function allowance(address owner, address spender)
269     external view returns (uint256);
270 
271   function transfer(address to, uint256 value) external returns (bool);
272 
273   function approve(address spender, uint256 value)
274     external returns (bool);
275 
276   function transferFrom(address from, address to, uint256 value)
277     external returns (bool);
278 
279   event Transfer(
280     address indexed from,
281     address indexed to,
282     uint256 value
283   );
284 
285   event Approval(
286     address indexed owner,
287     address indexed spender,
288     uint256 value
289   );
290 }
291 
292 // File: contracts/lib/openzeppelin-solidity/contracts/math/SafeMath.sol
293 
294 /**
295  * @title SafeMath
296  * @dev Math operations with safety checks that revert on error
297  */
298 library SafeMath {
299 
300   /**
301   * @dev Multiplies two numbers, reverts on overflow.
302   */
303   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
304     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
305     // benefit is lost if 'b' is also tested.
306     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
307     if (a == 0) {
308       return 0;
309     }
310 
311     uint256 c = a * b;
312     require(c / a == b);
313 
314     return c;
315   }
316 
317   /**
318   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
319   */
320   function div(uint256 a, uint256 b) internal pure returns (uint256) {
321     require(b > 0); // Solidity only automatically asserts when dividing by 0
322     uint256 c = a / b;
323     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
324 
325     return c;
326   }
327 
328   /**
329   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
330   */
331   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
332     require(b <= a);
333     uint256 c = a - b;
334 
335     return c;
336   }
337 
338   /**
339   * @dev Adds two numbers, reverts on overflow.
340   */
341   function add(uint256 a, uint256 b) internal pure returns (uint256) {
342     uint256 c = a + b;
343     require(c >= a);
344 
345     return c;
346   }
347 
348   /**
349   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
350   * reverts when dividing by zero.
351   */
352   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
353     require(b != 0);
354     return a % b;
355   }
356 }
357 
358 // File: contracts/lib/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
359 
360 /**
361  * @title Standard ERC20 token
362  *
363  * @dev Implementation of the basic standard token.
364  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
365  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
366  */
367 contract ERC20 is IERC20 {
368   using SafeMath for uint256;
369 
370   mapping (address => uint256) private _balances;
371 
372   mapping (address => mapping (address => uint256)) private _allowed;
373 
374   uint256 private _totalSupply;
375 
376   /**
377   * @dev Total number of tokens in existence
378   */
379   function totalSupply() public view returns (uint256) {
380     return _totalSupply;
381   }
382 
383   /**
384   * @dev Gets the balance of the specified address.
385   * @param owner The address to query the balance of.
386   * @return An uint256 representing the amount owned by the passed address.
387   */
388   function balanceOf(address owner) public view returns (uint256) {
389     return _balances[owner];
390   }
391 
392   /**
393    * @dev Function to check the amount of tokens that an owner allowed to a spender.
394    * @param owner address The address which owns the funds.
395    * @param spender address The address which will spend the funds.
396    * @return A uint256 specifying the amount of tokens still available for the spender.
397    */
398   function allowance(
399     address owner,
400     address spender
401    )
402     public
403     view
404     returns (uint256)
405   {
406     return _allowed[owner][spender];
407   }
408 
409   /**
410   * @dev Transfer token for a specified address
411   * @param to The address to transfer to.
412   * @param value The amount to be transferred.
413   */
414   function transfer(address to, uint256 value) public returns (bool) {
415     _transfer(msg.sender, to, value);
416     return true;
417   }
418 
419   /**
420    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
421    * Beware that changing an allowance with this method brings the risk that someone may use both the old
422    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
423    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
424    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
425    * @param spender The address which will spend the funds.
426    * @param value The amount of tokens to be spent.
427    */
428   function approve(address spender, uint256 value) public returns (bool) {
429     require(spender != address(0));
430 
431     _allowed[msg.sender][spender] = value;
432     emit Approval(msg.sender, spender, value);
433     return true;
434   }
435 
436   /**
437    * @dev Transfer tokens from one address to another
438    * @param from address The address which you want to send tokens from
439    * @param to address The address which you want to transfer to
440    * @param value uint256 the amount of tokens to be transferred
441    */
442   function transferFrom(
443     address from,
444     address to,
445     uint256 value
446   )
447     public
448     returns (bool)
449   {
450     require(value <= _allowed[from][msg.sender]);
451 
452     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
453     _transfer(from, to, value);
454     return true;
455   }
456 
457   /**
458    * @dev Increase the amount of tokens that an owner allowed to a spender.
459    * approve should be called when allowed_[_spender] == 0. To increment
460    * allowed value is better to use this function to avoid 2 calls (and wait until
461    * the first transaction is mined)
462    * From MonolithDAO Token.sol
463    * @param spender The address which will spend the funds.
464    * @param addedValue The amount of tokens to increase the allowance by.
465    */
466   function increaseAllowance(
467     address spender,
468     uint256 addedValue
469   )
470     public
471     returns (bool)
472   {
473     require(spender != address(0));
474 
475     _allowed[msg.sender][spender] = (
476       _allowed[msg.sender][spender].add(addedValue));
477     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
478     return true;
479   }
480 
481   /**
482    * @dev Decrease the amount of tokens that an owner allowed to a spender.
483    * approve should be called when allowed_[_spender] == 0. To decrement
484    * allowed value is better to use this function to avoid 2 calls (and wait until
485    * the first transaction is mined)
486    * From MonolithDAO Token.sol
487    * @param spender The address which will spend the funds.
488    * @param subtractedValue The amount of tokens to decrease the allowance by.
489    */
490   function decreaseAllowance(
491     address spender,
492     uint256 subtractedValue
493   )
494     public
495     returns (bool)
496   {
497     require(spender != address(0));
498 
499     _allowed[msg.sender][spender] = (
500       _allowed[msg.sender][spender].sub(subtractedValue));
501     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
502     return true;
503   }
504 
505   /**
506   * @dev Transfer token for a specified addresses
507   * @param from The address to transfer from.
508   * @param to The address to transfer to.
509   * @param value The amount to be transferred.
510   */
511   function _transfer(address from, address to, uint256 value) internal {
512     require(value <= _balances[from]);
513     require(to != address(0));
514 
515     _balances[from] = _balances[from].sub(value);
516     _balances[to] = _balances[to].add(value);
517     emit Transfer(from, to, value);
518   }
519 
520   /**
521    * @dev Internal function that mints an amount of the token and assigns it to
522    * an account. This encapsulates the modification of balances such that the
523    * proper events are emitted.
524    * @param account The account that will receive the created tokens.
525    * @param value The amount that will be created.
526    */
527   function _mint(address account, uint256 value) internal {
528     require(account != 0);
529     _totalSupply = _totalSupply.add(value);
530     _balances[account] = _balances[account].add(value);
531     emit Transfer(address(0), account, value);
532   }
533 
534   /**
535    * @dev Internal function that burns an amount of the token of a given
536    * account.
537    * @param account The account whose tokens will be burnt.
538    * @param value The amount that will be burnt.
539    */
540   function _burn(address account, uint256 value) internal {
541     require(account != 0);
542     require(value <= _balances[account]);
543 
544     _totalSupply = _totalSupply.sub(value);
545     _balances[account] = _balances[account].sub(value);
546     emit Transfer(account, address(0), value);
547   }
548 
549   /**
550    * @dev Internal function that burns an amount of the token of a given
551    * account, deducting from the sender's allowance for said account. Uses the
552    * internal burn function.
553    * @param account The account whose tokens will be burnt.
554    * @param value The amount that will be burnt.
555    */
556   function _burnFrom(address account, uint256 value) internal {
557     require(value <= _allowed[account][msg.sender]);
558 
559     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
560     // this function needs to emit an event with the updated approval.
561     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
562       value);
563     _burn(account, value);
564   }
565 }
566 
567 // File: contracts/shop/MCHEMONTGateway.sol
568 
569 contract MCHEMONTGateway is Ownable, Pausable, ReentrancyGuard {
570 
571     ERC20 public EMONT;
572 
573     event EMONTEXCHANGE(
574         address indexed user,
575         address indexed referrer,
576         uint256 value,
577         uint256 at
578     );
579 
580     function setEMONTAddress(ERC20 _EMONTAddress) external onlyOwner() {
581         EMONT = _EMONTAddress;
582     }
583 
584     function withdrawEther() external onlyOwner() {
585         owner().transfer(address(this).balance);
586     }
587 
588     function withdrawEMONT() external onlyOwner() {
589         uint256 EMONTBalance = EMONT.balanceOf(address(this));
590         EMONT.approve(address(this), EMONTBalance);
591         EMONT.transferFrom(address(this), msg.sender, EMONTBalance);
592     }
593 
594     function exchangeEMONTtoGUM(uint256 amount, address _referrer) external whenNotPaused() nonReentrant() {
595         require(amount == 2500000000 || amount == 10000000000 || amount == 50000000000);
596         
597         address referrer;
598         if (_referrer == msg.sender) {
599             referrer = address(0x0);
600         } else {
601             referrer = _referrer;
602         }
603 
604         EMONT.transferFrom(msg.sender, address(this), amount);
605         
606         emit EMONTEXCHANGE(
607             msg.sender,
608             referrer,
609             amount,
610             block.timestamp
611         );
612     }
613     
614     function getEMONTBalance() external view returns (uint256) {
615         return EMONT.balanceOf(address(this));
616     }
617 
618 }