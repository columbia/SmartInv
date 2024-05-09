1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, reverts on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     uint256 c = a * b;
21     require(c / a == b);
22 
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     require(b > 0); // Solidity only automatically asserts when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34     return c;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     require(b <= a);
42     uint256 c = a - b;
43 
44     return c;
45   }
46 
47   /**
48   * @dev Adds two numbers, reverts on overflow.
49   */
50   function add(uint256 a, uint256 b) internal pure returns (uint256) {
51     uint256 c = a + b;
52     require(c >= a);
53 
54     return c;
55   }
56 
57   /**
58   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
59   * reverts when dividing by zero.
60   */
61   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62     require(b != 0);
63     return a % b;
64   }
65 }
66 
67 
68 
69 /**
70  * @title ERC20 interface
71  * @dev see https://github.com/ethereum/EIPs/issues/20
72  */
73 interface IERC20 {
74   function totalSupply() external view returns (uint256);
75 
76   function balanceOf(address who) external view returns (uint256);
77 
78   function allowance(address owner, address spender)
79   external view returns (uint256);
80 
81   function transfer(address to, uint256 value) external returns (bool);
82 
83   function approve(address spender, uint256 value)
84   external returns (bool);
85 
86   function transferFrom(address from, address to, uint256 value)
87   external returns (bool);
88 
89 
90   event Transfer(
91     address indexed from,
92     address indexed to,
93     uint256 value
94   );
95 
96   event TransferWithData(address indexed from, address indexed to, uint value, bytes data);
97 
98   event Approval(
99     address indexed owner,
100     address indexed spender,
101     uint256 value
102   );
103 }
104 
105 
106 
107 /**
108  * @title Standard ERC20 token
109  *
110  * @dev Implementation of the basic standard token.
111  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
112  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
113  */
114 contract ERC20 is IERC20 {
115   using SafeMath for uint256;
116 
117   mapping (address => uint256) private _balances;
118 
119   mapping (address => mapping (address => uint256)) private _allowed;
120 
121   uint256 private _totalSupply;
122 
123   /**
124   * @dev Total number of tokens in existence
125   */
126   function totalSupply() public view returns (uint256) {
127     return _totalSupply;
128   }
129 
130   /**
131   * @dev Gets the balance of the specified address.
132   * @param owner The address to query the balance of.
133   * @return An uint256 representing the amount owned by the passed address.
134   */
135   function balanceOf(address owner) public view returns (uint256) {
136     return _balances[owner];
137   }
138 
139   /**
140    * @dev Function to check the amount of tokens that an owner allowed to a spender.
141    * @param owner address The address which owns the funds.
142    * @param spender address The address which will spend the funds.
143    * @return A uint256 specifying the amount of tokens still available for the spender.
144    */
145   function allowance(
146     address owner,
147     address spender
148   )
149   public
150   view
151   returns (uint256)
152   {
153     return _allowed[owner][spender];
154   }
155 
156 
157   /**
158    * @dev Transfer the specified amount of tokens to the specified address.
159    *      Invokes the `tokenFallback` function if the recipient is a contract.
160    *      The token transfer fails if the recipient is a contract
161    *      but does not implement the `tokenFallback` function
162    *      or the fallback function to receive funds.
163    *
164    * @param _to    Receiver address.
165    * @param _value Amount of tokens that will be transferred.
166    * @param _data  Transaction metadata.
167    */
168 
169   function transfer(address _to, uint _value, bytes _data) external returns (bool) {
170     // Standard function transfer similar to ERC20 transfer with no _data .
171     // Added due to backwards compatibility reasons .
172     uint codeLength;
173 
174     assembly {
175     // Retrieve the size of the code on target address, this needs assembly .
176       codeLength := extcodesize(_to)
177     }
178 
179     _balances[msg.sender] = _balances[msg.sender].sub(_value);
180     _balances[_to] = _balances[_to].add(_value);
181     if (codeLength > 0) {
182       ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
183 
184       receiver.tokenFallback(msg.sender, _value, _to);
185     }
186     emit TransferWithData(msg.sender, _to, _value, _data);
187     emit Transfer(msg.sender, _to, _value);
188     return true;
189   }
190 
191   /**
192    * @dev Transfer the specified amount of tokens to the specified address.
193    *      This function works the same with the previous one
194    *      but doesn't contain `_data` param.
195    *      Added due to backwards compatibility reasons.
196    *
197    * @param _to    Receiver address.
198    * @param _value Amount of tokens that will be transferred.
199    */
200   function transfer(address _to, uint _value) external returns (bool) {
201     uint codeLength;
202     bytes memory empty;
203 
204     assembly {
205     // Retrieve the size of the code on target address, this needs assembly .
206       codeLength := extcodesize(_to)
207     }
208 
209     _balances[msg.sender] = _balances[msg.sender].sub(_value);
210     _balances[_to] = _balances[_to].add(_value);
211     if (codeLength > 0) {
212       ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
213       receiver.tokenFallback(msg.sender, _value, address(this));
214     }
215 
216     emit Transfer(msg.sender, _to, _value);
217     emit TransferWithData(msg.sender, _to, _value, empty);
218     return true;
219   }
220 
221 
222   /**
223    * @dev Transfer the specified amount of tokens to the specified address.
224    *      This function works the same with the previous one
225    *      but doesn't contain `_data` param.
226    *      Added due to backwards compatibility reasons.
227    *
228    * @param _to    Receiver address.
229    * @param _value Amount of tokens that will be transferred.
230    */
231   function transferByCrowdSale(address _to, uint _value) external returns (bool) {
232     bytes memory empty;
233 
234     _balances[msg.sender] = _balances[msg.sender].sub(_value);
235     _balances[_to] = _balances[_to].add(_value);
236 
237     emit Transfer(msg.sender, _to, _value);
238     emit TransferWithData(msg.sender, _to, _value, empty);
239     return true;
240   }
241 
242   function _transferGasByOwner(address _from, address _to, uint256 _value) internal {
243     _balances[_from] = _balances[_from].sub(_value);
244     _balances[_to] = _balances[_to].add(_value);
245     emit Transfer(_from, _to, _value);
246   }
247 
248 
249   /**
250    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
251    * Beware that changing an allowance with this method brings the risk that someone may use both the old
252    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
253    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
254    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
255    * @param spender The address which will spend the funds.
256    * @param value The amount of tokens to be spent.
257    */
258   function approve(address spender, uint256 value) public returns (bool) {
259     require(spender != address(0));
260 
261     _allowed[msg.sender][spender] = value;
262     emit Approval(msg.sender, spender, value);
263     return true;
264   }
265 
266   /**
267    * @dev Transfer tokens from one address to another
268    * @param from address The address which you want to send tokens from
269    * @param to address The address which you want to transfer to
270    * @param value uint256 the amount of tokens to be transferred
271    */
272   function transferFrom(
273     address from,
274     address to,
275     uint256 value
276   )
277   public
278   returns (bool)
279   {
280     require(value <= _allowed[from][msg.sender]);
281 
282     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
283     _transfer(from, to, value);
284     return true;
285   }
286 
287   /**
288    * @dev Increase the amount of tokens that an owner allowed to a spender.
289    * approve should be called when allowed_[_spender] == 0. To increment
290    * allowed value is better to use this function to avoid 2 calls (and wait until
291    * the first transaction is mined)
292    * From MonolithDAO Token.sol
293    * @param spender The address which will spend the funds.
294    * @param addedValue The amount of tokens to increase the allowance by.
295    */
296   function increaseAllowance(
297     address spender,
298     uint256 addedValue
299   )
300   public
301   returns (bool)
302   {
303     require(spender != address(0));
304 
305     _allowed[msg.sender][spender] = (
306     _allowed[msg.sender][spender].add(addedValue));
307     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
308     return true;
309   }
310 
311   /**
312    * @dev Decrease the amount of tokens that an owner allowed to a spender.
313    * approve should be called when allowed_[_spender] == 0. To decrement
314    * allowed value is better to use this function to avoid 2 calls (and wait until
315    * the first transaction is mined)
316    * From MonolithDAO Token.sol
317    * @param spender The address which will spend the funds.
318    * @param subtractedValue The amount of tokens to decrease the allowance by.
319    */
320   function decreaseAllowance(
321     address spender,
322     uint256 subtractedValue
323   )
324   public
325   returns (bool)
326   {
327     require(spender != address(0));
328 
329     _allowed[msg.sender][spender] = (
330     _allowed[msg.sender][spender].sub(subtractedValue));
331     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
332     return true;
333   }
334 
335   /**
336   * @dev Transfer token for a specified addresses
337   * @param from The address to transfer from.
338   * @param to The address to transfer to.
339   * @param value The amount to be transferred.
340   */
341   function _transfer(address from, address to, uint256 value) internal {
342     require(value <= _balances[from]);
343     require(to != address(0));
344 
345     _balances[from] = _balances[from].sub(value);
346     _balances[to] = _balances[to].add(value);
347     emit TransferWithData(from, to, value, '');
348     emit Transfer(from, to, value);
349   }
350 
351   /**
352    * @dev Internal function that mints an amount of the token and assigns it to
353    * an account. This encapsulates the modification of balances such that the
354    * proper events are emitted.
355    * @param account The account that will receive the created tokens.
356    * @param value The amount that will be created.
357    */
358   function _mint(address account, uint256 value) internal {
359     require(account != 0);
360     _totalSupply = _totalSupply.add(value);
361     _balances[account] = _balances[account].add(value);
362     emit TransferWithData(address(0), account, value, '');
363     emit Transfer(address(0), account, value);
364   }
365 
366   /**
367    * @dev Internal function that burns an amount of the token of a given
368    * account.
369    * @param account The account whose tokens will be burnt.
370    * @param value The amount that will be burnt.
371    */
372   function _burn(address account, uint256 value) internal {
373     require(account != 0);
374     require(value <= _balances[account]);
375 
376     _totalSupply = _totalSupply.sub(value);
377     _balances[account] = _balances[account].sub(value);
378     emit TransferWithData(account, address(0), value, '');
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
401 /**
402  * @title Roles
403  * @dev Library for managing addresses assigned to a Role.
404  */
405 library Roles {
406   struct Role {
407     mapping (address => bool) bearer;
408   }
409 
410   /**
411    * @dev give an account access to this role
412    */
413   function add(Role storage role, address account) internal {
414     require(account != address(0));
415     role.bearer[account] = true;
416   }
417 
418   /**
419    * @dev remove an account's access to this role
420    */
421   function remove(Role storage role, address account) internal {
422     require(account != address(0));
423     role.bearer[account] = false;
424   }
425 
426   /**
427    * @dev check if an account has this role
428    * @return bool
429    */
430   function has(Role storage role, address account)
431   internal
432   view
433   returns (bool)
434   {
435     require(account != address(0));
436     return role.bearer[account];
437   }
438 }
439 
440 
441 contract MinterRole {
442   using Roles for Roles.Role;
443 
444   event MinterAdded(address indexed account);
445   event MinterRemoved(address indexed account);
446 
447   Roles.Role private minters;
448 
449   constructor() public {
450     _addMinter(msg.sender);
451   }
452 
453   modifier onlyMinter() {
454     require(isMinter(msg.sender));
455     _;
456   }
457 
458   function isMinter(address account) public view returns (bool) {
459     return minters.has(account);
460   }
461 
462   function addMinter(address account) public onlyMinter {
463     _addMinter(account);
464   }
465 
466   function renounceMinter() public {
467     _removeMinter(msg.sender);
468   }
469 
470   function _addMinter(address account) internal {
471     minters.add(account);
472     emit MinterAdded(account);
473   }
474 
475   function _removeMinter(address account) internal {
476     minters.remove(account);
477     emit MinterRemoved(account);
478   }
479 }
480 
481 
482 /**
483  * @title ERC20Mintable
484  * @dev ERC20 minting logic
485  */
486 contract ERC20Mintable is ERC20, MinterRole {
487   /**
488    * @dev Function to mint tokens
489    * @param to The address that will receive the minted tokens.
490    * @param value The amount of tokens to mint.
491    * @return A boolean that indicates if the operation was successful.
492    */
493   function mint(
494     address to,
495     uint256 value
496   )
497   public
498   onlyMinter
499   returns (bool)
500   {
501     _mint(to, value);
502     return true;
503   }
504 
505   function transferGasByOwner(address _from, address _to, uint256 _value) public onlyMinter returns (bool) {
506     super._transferGasByOwner(_from, _to, _value);
507     return true;
508   }
509 }
510 
511 contract VmembersCoin is ERC20Mintable {
512 
513   string public constant name = "VMembers Coin";
514   string public constant symbol = "VMC";
515   uint8 public constant decimals = 18;
516 
517   uint256 public constant INITIAL_SUPPLY = 3000000 * (10 ** uint256(decimals));
518 
519   /**
520    * @dev Constructor that gives msg.sender all of existing tokens.
521    */
522   constructor() public {
523     mint(msg.sender, INITIAL_SUPPLY);
524   }
525 
526 }
527 
528 
529 
530 /**
531  * @title Ownable
532  * @dev The Ownable contract has an owner address, and provides basic authorization control
533  * functions, this simplifies the implementation of "user permissions".
534  */
535 contract Ownable {
536   address private _owner;
537 
538   event OwnershipRenounced(address indexed previousOwner);
539   event OwnershipTransferred(
540     address indexed previousOwner,
541     address indexed newOwner
542   );
543 
544   /**
545    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
546    * account.
547    */
548   constructor() public {
549     _owner = msg.sender;
550   }
551 
552   /**
553    * @return the address of the owner.
554    */
555   function owner() public view returns (address) {
556     return _owner;
557   }
558 
559   /**
560    * @dev Throws if called by any account other than the owner.
561    */
562   modifier onlyOwner() {
563     require(isOwner());
564     _;
565   }
566 
567   /**
568    * @return true if `msg.sender` is the owner of the contract.
569    */
570   function isOwner() public view returns (bool) {
571     return msg.sender == _owner;
572   }
573 
574   /**
575    * @dev Allows the current owner to relinquish control of the contract.
576    * @notice Renouncing to ownership will leave the contract without an owner.
577    * It will not be possible to call the functions with the `onlyOwner`
578    * modifier anymore.
579    */
580   function renounceOwnership() public onlyOwner {
581     emit OwnershipRenounced(_owner);
582     _owner = address(0);
583   }
584 
585   /**
586    * @dev Allows the current owner to transfer control of the contract to a newOwner.
587    * @param newOwner The address to transfer ownership to.
588    */
589   function transferOwnership(address newOwner) public onlyOwner {
590     _transferOwnership(newOwner);
591   }
592 
593   /**
594    * @dev Transfers control of the contract to a newOwner.
595    * @param newOwner The address to transfer ownership to.
596    */
597   function _transferOwnership(address newOwner) internal {
598     require(newOwner != address(0));
599     emit OwnershipTransferred(_owner, newOwner);
600     _owner = newOwner;
601   }
602 }
603 
604 /**
605  * @title Crowdsale
606  * @dev Crowdsale is a base contract for managing a token crowdsale,
607  * allowing investors to purchase tokens with ether. This contract implements
608  * such functionality in its most fundamental form and can be extended to provide additional
609  * functionality and/or custom behavior.
610  * The external interface represents the basic interface for purchasing tokens, and conform
611  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
612  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
613  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
614  * behavior.
615  */
616 contract ERC223ReceivingContract is Ownable {
617 
618 
619   function tokenFallback(address _from, uint _value, address _to);
620 
621 }