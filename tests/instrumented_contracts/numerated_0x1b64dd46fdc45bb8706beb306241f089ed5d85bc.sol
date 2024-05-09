1 pragma solidity ^0.4.24;
2 
3 // File: contracts/token/ERC20/IERC20.sol
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
8  */
9 interface IERC20 {
10   function totalSupply() external view returns (uint256);
11 
12   function balanceOf(address who) external view returns (uint256);
13 
14   function allowance(address owner, address spender)
15     external view returns (uint256);
16 
17   function transfer(address to, uint256 value) external returns (bool);
18 
19   function approve(address spender, uint256 value)
20     external returns (bool);
21 
22   function transferFrom(address from, address to, uint256 value)
23     external returns (bool);
24 
25   event Transfer(
26     address indexed from,
27     address indexed to,
28     uint256 value
29   );
30 
31   event Approval(
32     address indexed owner,
33     address indexed spender,
34     uint256 value
35   );
36 }
37 
38 // File: contracts/token/ERC20/ERC20Detailed.sol
39 
40 /**
41  * @title ERC20Detailed token
42  * @dev The decimals are only for visualization purposes.
43  * All the operations are done using the smallest and indivisible token unit,
44  * just as on Ethereum all the operations are done in wei.
45  */
46 contract ERC20Detailed is IERC20 {
47   string private _name;
48   string private _symbol;
49   uint8 private _decimals;
50 
51   constructor(string name, string symbol, uint8 decimals) public {
52     _name = name;
53     _symbol = symbol;
54     _decimals = decimals;
55   }
56 
57   /**
58    * @return the name of the token.
59    */
60   function name() public view returns(string) {
61     return _name;
62   }
63 
64   /**
65    * @return the symbol of the token.
66    */
67   function symbol() public view returns(string) {
68     return _symbol;
69   }
70 
71   /**
72    * @return the number of decimals of the token.
73    */
74   function decimals() public view returns(uint8) {
75     return _decimals;
76   }
77 }
78 
79 // File: contracts/math/SafeMath.sol
80 
81 /**
82  * @title SafeMath
83  * @dev Math operations with safety checks that revert on error
84  */
85 library SafeMath {
86 
87   /**
88   * @dev Multiplies two numbers, reverts on overflow.
89   */
90   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
91     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
92     // benefit is lost if 'b' is also tested.
93     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
94     if (a == 0) {
95       return 0;
96     }
97 
98     uint256 c = a * b;
99     require(c / a == b);
100 
101     return c;
102   }
103 
104   /**
105   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
106   */
107   function div(uint256 a, uint256 b) internal pure returns (uint256) {
108     require(b > 0); // Solidity only automatically asserts when dividing by 0
109     uint256 c = a / b;
110     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
111 
112     return c;
113   }
114 
115   /**
116   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
117   */
118   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
119     require(b <= a);
120     uint256 c = a - b;
121 
122     return c;
123   }
124 
125   /**
126   * @dev Adds two numbers, reverts on overflow.
127   */
128   function add(uint256 a, uint256 b) internal pure returns (uint256) {
129     uint256 c = a + b;
130     require(c >= a);
131 
132     return c;
133   }
134 
135   /**
136   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
137   * reverts when dividing by zero.
138   */
139   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
140     require(b != 0);
141     return a % b;
142   }
143 }
144 
145 // File: contracts/token/ERC20/ERC20.sol
146 
147 /**
148  * @title Standard ERC20 token
149  *
150  * @dev Implementation of the basic standard token.
151  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
152  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
153  */
154 contract ERC20 is IERC20 {
155   using SafeMath for uint256;
156 
157   mapping (address => uint256) private _balances;
158 
159   mapping (address => mapping (address => uint256)) private _allowed;
160 
161   uint256 private _totalSupply;
162 
163   /**
164   * @dev Total number of tokens in existence
165   */
166   function totalSupply() public view returns (uint256) {
167     return _totalSupply;
168   }
169 
170   /**
171   * @dev Gets the balance of the specified address.
172   * @param owner The address to query the balance of.
173   * @return An uint256 representing the amount owned by the passed address.
174   */
175   function balanceOf(address owner) public view returns (uint256) {
176     return _balances[owner];
177   }
178 
179   /**
180    * @dev Function to check the amount of tokens that an owner allowed to a spender.
181    * @param owner address The address which owns the funds.
182    * @param spender address The address which will spend the funds.
183    * @return A uint256 specifying the amount of tokens still available for the spender.
184    */
185   function allowance(
186     address owner,
187     address spender
188    )
189     public
190     view
191     returns (uint256)
192   {
193     return _allowed[owner][spender];
194   }
195 
196   /**
197   * @dev Transfer token for a specified address
198   * @param to The address to transfer to.
199   * @param value The amount to be transferred.
200   */
201   function transfer(address to, uint256 value) public returns (bool) {
202     _transfer(msg.sender, to, value);
203     return true;
204   }
205 
206   /**
207    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
208    * Beware that changing an allowance with this method brings the risk that someone may use both the old
209    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
210    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
211    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
212    * @param spender The address which will spend the funds.
213    * @param value The amount of tokens to be spent.
214    */
215   function approve(address spender, uint256 value) public returns (bool) {
216     require(spender != address(0));
217 
218     _allowed[msg.sender][spender] = value;
219     emit Approval(msg.sender, spender, value);
220     return true;
221   }
222 
223   /**
224    * @dev Transfer tokens from one address to another
225    * @param from address The address which you want to send tokens from
226    * @param to address The address which you want to transfer to
227    * @param value uint256 the amount of tokens to be transferred
228    */
229   function transferFrom(
230     address from,
231     address to,
232     uint256 value
233   )
234     public
235     returns (bool)
236   {
237     require(value <= _allowed[from][msg.sender]);
238 
239     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
240     _transfer(from, to, value);
241     return true;
242   }
243 
244   /**
245    * @dev Increase the amount of tokens that an owner allowed to a spender.
246    * approve should be called when allowed_[_spender] == 0. To increment
247    * allowed value is better to use this function to avoid 2 calls (and wait until
248    * the first transaction is mined)
249    * From MonolithDAO Token.sol
250    * @param spender The address which will spend the funds.
251    * @param addedValue The amount of tokens to increase the allowance by.
252    */
253   function increaseAllowance(
254     address spender,
255     uint256 addedValue
256   )
257     public
258     returns (bool)
259   {
260     require(spender != address(0));
261 
262     _allowed[msg.sender][spender] = (
263       _allowed[msg.sender][spender].add(addedValue));
264     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
265     return true;
266   }
267 
268   /**
269    * @dev Decrease the amount of tokens that an owner allowed to a spender.
270    * approve should be called when allowed_[_spender] == 0. To decrement
271    * allowed value is better to use this function to avoid 2 calls (and wait until
272    * the first transaction is mined)
273    * From MonolithDAO Token.sol
274    * @param spender The address which will spend the funds.
275    * @param subtractedValue The amount of tokens to decrease the allowance by.
276    */
277   function decreaseAllowance(
278     address spender,
279     uint256 subtractedValue
280   )
281     public
282     returns (bool)
283   {
284     require(spender != address(0));
285 
286     _allowed[msg.sender][spender] = (
287       _allowed[msg.sender][spender].sub(subtractedValue));
288     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
289     return true;
290   }
291 
292   /**
293   * @dev Transfer token for a specified addresses
294   * @param from The address to transfer from.
295   * @param to The address to transfer to.
296   * @param value The amount to be transferred.
297   */
298   function _transfer(address from, address to, uint256 value) internal {
299     require(value <= _balances[from]);
300     require(to != address(0));
301 
302     _balances[from] = _balances[from].sub(value);
303     _balances[to] = _balances[to].add(value);
304     emit Transfer(from, to, value);
305   }
306 
307   /**
308    * @dev Internal function that mints an amount of the token and assigns it to
309    * an account. This encapsulates the modification of balances such that the
310    * proper events are emitted.
311    * @param account The account that will receive the created tokens.
312    * @param value The amount that will be created.
313    */
314   function _mint(address account, uint256 value) internal {
315     require(account != 0);
316     _totalSupply = _totalSupply.add(value);
317     _balances[account] = _balances[account].add(value);
318     emit Transfer(address(0), account, value);
319   }
320 
321   /**
322    * @dev Internal function that burns an amount of the token of a given
323    * account.
324    * @param account The account whose tokens will be burnt.
325    * @param value The amount that will be burnt.
326    */
327   function _burn(address account, uint256 value) internal {
328     require(account != 0);
329     require(value <= _balances[account]);
330 
331     _totalSupply = _totalSupply.sub(value);
332     _balances[account] = _balances[account].sub(value);
333     emit Transfer(account, address(0), value);
334   }
335 
336   /**
337    * @dev Internal function that burns an amount of the token of a given
338    * account, deducting from the sender's allowance for said account. Uses the
339    * internal burn function.
340    * @param account The account whose tokens will be burnt.
341    * @param value The amount that will be burnt.
342    */
343   function _burnFrom(address account, uint256 value) internal {
344     require(value <= _allowed[account][msg.sender]);
345 
346     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
347     // this function needs to emit an event with the updated approval.
348     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
349       value);
350     _burn(account, value);
351   }
352 }
353 
354 // File: contracts/access/Roles.sol
355 
356 /**
357  * @title Roles
358  * @dev Library for managing addresses assigned to a Role.
359  */
360 library Roles {
361   struct Role {
362     mapping (address => bool) bearer;
363   }
364 
365   /**
366    * @dev give an account access to this role
367    */
368   function add(Role storage role, address account) internal {
369     require(account != address(0));
370     require(!has(role, account));
371 
372     role.bearer[account] = true;
373   }
374 
375   /**
376    * @dev remove an account's access to this role
377    */
378   function remove(Role storage role, address account) internal {
379     require(account != address(0));
380     require(has(role, account));
381 
382     role.bearer[account] = false;
383   }
384 
385   /**
386    * @dev check if an account has this role
387    * @return bool
388    */
389   function has(Role storage role, address account)
390     internal
391     view
392     returns (bool)
393   {
394     require(account != address(0));
395     return role.bearer[account];
396   }
397 }
398 
399 // File: contracts/access/roles/MinterRole.sol
400 
401 contract MinterRole {
402   using Roles for Roles.Role;
403 
404   event MinterAdded(address indexed account);
405   event MinterRemoved(address indexed account);
406 
407   Roles.Role private minters;
408 
409   constructor() internal {
410     _addMinter(msg.sender);
411   }
412 
413   modifier onlyMinter() {
414     require(isMinter(msg.sender));
415     _;
416   }
417 
418   function isMinter(address account) public view returns (bool) {
419     return minters.has(account);
420   }
421 
422   function addMinter(address account) public onlyMinter {
423     _addMinter(account);
424   }
425 
426   function renounceMinter() public {
427     _removeMinter(msg.sender);
428   }
429 
430   function _addMinter(address account) internal {
431     minters.add(account);
432     emit MinterAdded(account);
433   }
434 
435   function _removeMinter(address account) internal {
436     minters.remove(account);
437     emit MinterRemoved(account);
438   }
439 }
440 
441 // File: contracts/token/ERC20/ERC20Mintable.sol
442 
443 /**
444  * @title ERC20Mintable
445  * @dev ERC20 minting logic
446  */
447 contract ERC20Mintable is ERC20, MinterRole {
448   /**
449    * @dev Function to mint tokens
450    * @param to The address that will receive the minted tokens.
451    * @param value The amount of tokens to mint.
452    * @return A boolean that indicates if the operation was successful.
453    */
454   function mint(
455     address to,
456     uint256 value
457   )
458     public
459     onlyMinter
460     returns (bool)
461   {
462     _mint(to, value);
463     return true;
464   }
465 }
466 
467 // File: contracts/token/ERC20/ERC20Burnable.sol
468 
469 /**
470  * @title Burnable Token
471  * @dev Token that can be irreversibly burned (destroyed).
472  */
473 contract ERC20Burnable is ERC20 {
474 
475   /**
476    * @dev Burns a specific amount of tokens.
477    * @param value The amount of token to be burned.
478    */
479   function burn(uint256 value) public {
480     _burn(msg.sender, value);
481   }
482 
483   /**
484    * @dev Burns a specific amount of tokens from the target address and decrements allowance
485    * @param from address The address which you want to send tokens from
486    * @param value uint256 The amount of token to be burned
487    */
488   function burnFrom(address from, uint256 value) public {
489     _burnFrom(from, value);
490   }
491 }
492 
493 // File: contracts/ownership/Ownable.sol
494 
495 /**
496  * @title Ownable
497  * @dev The Ownable contract has an owner address, and provides basic authorization control
498  * functions, this simplifies the implementation of "user permissions".
499  */
500 contract Ownable {
501   address private _owner;
502 
503   event OwnershipTransferred(
504     address indexed previousOwner,
505     address indexed newOwner
506   );
507 
508   /**
509    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
510    * account.
511    */
512   constructor() internal {
513     _owner = msg.sender;
514     emit OwnershipTransferred(address(0), _owner);
515   }
516 
517   /**
518    * @return the address of the owner.
519    */
520   function owner() public view returns(address) {
521     return _owner;
522   }
523 
524   /**
525    * @dev Throws if called by any account other than the owner.
526    */
527   modifier onlyOwner() {
528     require(isOwner());
529     _;
530   }
531 
532   /**
533    * @return true if `msg.sender` is the owner of the contract.
534    */
535   function isOwner() public view returns(bool) {
536     return msg.sender == _owner;
537   }
538 
539   /**
540    * @dev Allows the current owner to relinquish control of the contract.
541    * @notice Renouncing to ownership will leave the contract without an owner.
542    * It will not be possible to call the functions with the `onlyOwner`
543    * modifier anymore.
544    */
545   function renounceOwnership() public onlyOwner {
546     emit OwnershipTransferred(_owner, address(0));
547     _owner = address(0);
548   }
549 
550   /**
551    * @dev Allows the current owner to transfer control of the contract to a newOwner.
552    * @param newOwner The address to transfer ownership to.
553    */
554   function transferOwnership(address newOwner) public onlyOwner {
555     _transferOwnership(newOwner);
556   }
557 
558   /**
559    * @dev Transfers control of the contract to a newOwner.
560    * @param newOwner The address to transfer ownership to.
561    */
562   function _transferOwnership(address newOwner) internal {
563     require(newOwner != address(0));
564     emit OwnershipTransferred(_owner, newOwner);
565     _owner = newOwner;
566   }
567 }
568 
569 // File: contracts/ERC223ReceivingContract.sol
570 
571 contract ERC223ReceivingContract { 
572     function tokenFallback(address _from, uint _value, bytes _data) public;
573 }
574 
575 // File: contracts/Carati.sol
576 
577 //ERC223 compatible safe token
578 contract Carati is ERC20Detailed, ERC20Mintable, ERC20Burnable, Ownable {
579     constructor (string _name, string _symbol, uint8 _decimals) public
580         ERC20Detailed(_name, _symbol, _decimals)
581     {}
582 
583     mapping (address => uint256) public balances;
584 
585     // Overridden transfer method with _data param for transaction data (ERC223 Specification)
586     function transfer(address _to, uint _value, bytes _data) public {
587         uint codeLength;
588 
589         assembly {
590             codeLength := extcodesize(_to)
591         }
592 
593         balances[msg.sender] = balances[msg.sender].sub(_value);
594         balances[_to] = balances[_to].add(_value);
595         // Check to see if receiver is contract
596         if(codeLength>0) {
597             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
598             receiver.tokenFallback(msg.sender, _value, _data);
599         }
600         emit Transfer(msg.sender, _to, _value);
601     }
602     
603     // Overridden Backwards compatible transfer method without _data param (ERC223 Specification)
604     function transfer(address _to, uint _value) public returns (bool) {
605         uint codeLength;
606         bytes memory empty;
607 
608         assembly {
609             codeLength := extcodesize(_to)
610         }
611 
612         balances[msg.sender] = balances[msg.sender].sub(_value);
613         balances[_to] = balances[_to].add(_value);
614         // Check to see if receiver is contract
615         if(codeLength>0) {
616             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
617             receiver.tokenFallback(msg.sender, _value, empty);
618         }
619         emit Transfer(msg.sender, _to, _value);
620     }
621 }