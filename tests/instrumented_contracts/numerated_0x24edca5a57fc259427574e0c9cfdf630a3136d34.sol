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
67 /**
68  * @title ERC20 interface
69  * @dev see https://github.com/ethereum/EIPs/issues/20
70  */
71 interface IERC20 {
72   function totalSupply() external view returns (uint256);
73 
74   function balanceOf(address who) external view returns (uint256);
75 
76   function allowance(address owner, address spender)
77     external view returns (uint256);
78 
79   function transfer(address to, uint256 value) external returns (bool);
80 
81   function approve(address spender, uint256 value)
82     external returns (bool);
83 
84   function transferFrom(address from, address to, uint256 value)
85     external returns (bool);
86 
87   event Transfer(
88     address indexed from,
89     address indexed to,
90     uint256 value
91   );
92 
93   event Approval(
94     address indexed owner,
95     address indexed spender,
96     uint256 value
97   );
98 }
99 
100 /**
101  * @title Standard ERC20 token
102  *
103  * @dev Implementation of the basic standard token.
104  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
105  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
106  */
107 contract ERC20 is IERC20 {
108   using SafeMath for uint256;
109 
110   mapping (address => uint256) private _balances;
111 
112   mapping (address => mapping (address => uint256)) private _allowed;
113 
114   uint256 private _totalSupply;
115 
116   /**
117   * @dev Total number of tokens in existence
118   */
119   function totalSupply() public view returns (uint256) {
120     return _totalSupply;
121   }
122 
123   /**
124   * @dev Gets the balance of the specified address.
125   * @param owner The address to query the balance of.
126   * @return An uint256 representing the amount owned by the passed address.
127   */
128   function balanceOf(address owner) public view returns (uint256) {
129     return _balances[owner];
130   }
131 
132   /**
133    * @dev Function to check the amount of tokens that an owner allowed to a spender.
134    * @param owner address The address which owns the funds.
135    * @param spender address The address which will spend the funds.
136    * @return A uint256 specifying the amount of tokens still available for the spender.
137    */
138   function allowance(
139     address owner,
140     address spender
141    )
142     public
143     view
144     returns (uint256)
145   {
146     return _allowed[owner][spender];
147   }
148 
149   /**
150   * @dev Transfer token for a specified address
151   * @param to The address to transfer to.
152   * @param value The amount to be transferred.
153   */
154   function transfer(address to, uint256 value) public returns (bool) {
155     _transfer(msg.sender, to, value);
156     return true;
157   }
158 
159   /**
160    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
161    * Beware that changing an allowance with this method brings the risk that someone may use both the old
162    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
163    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
164    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
165    * @param spender The address which will spend the funds.
166    * @param value The amount of tokens to be spent.
167    */
168   function approve(address spender, uint256 value) public returns (bool) {
169     require(spender != address(0));
170 
171     _allowed[msg.sender][spender] = value;
172     emit Approval(msg.sender, spender, value);
173     return true;
174   }
175 
176   /**
177    * @dev Transfer tokens from one address to another
178    * @param from address The address which you want to send tokens from
179    * @param to address The address which you want to transfer to
180    * @param value uint256 the amount of tokens to be transferred
181    */
182   function transferFrom(
183     address from,
184     address to,
185     uint256 value
186   )
187     public
188     returns (bool)
189   {
190     require(value <= _allowed[from][msg.sender]);
191 
192     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
193     _transfer(from, to, value);
194     return true;
195   }
196 
197   /**
198    * @dev Increase the amount of tokens that an owner allowed to a spender.
199    * approve should be called when allowed_[_spender] == 0. To increment
200    * allowed value is better to use this function to avoid 2 calls (and wait until
201    * the first transaction is mined)
202    * From MonolithDAO Token.sol
203    * @param spender The address which will spend the funds.
204    * @param addedValue The amount of tokens to increase the allowance by.
205    */
206   function increaseAllowance(
207     address spender,
208     uint256 addedValue
209   )
210     public
211     returns (bool)
212   {
213     require(spender != address(0));
214 
215     _allowed[msg.sender][spender] = (
216       _allowed[msg.sender][spender].add(addedValue));
217     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
218     return true;
219   }
220 
221   /**
222    * @dev Decrease the amount of tokens that an owner allowed to a spender.
223    * approve should be called when allowed_[_spender] == 0. To decrement
224    * allowed value is better to use this function to avoid 2 calls (and wait until
225    * the first transaction is mined)
226    * From MonolithDAO Token.sol
227    * @param spender The address which will spend the funds.
228    * @param subtractedValue The amount of tokens to decrease the allowance by.
229    */
230   function decreaseAllowance(
231     address spender,
232     uint256 subtractedValue
233   )
234     public
235     returns (bool)
236   {
237     require(spender != address(0));
238 
239     _allowed[msg.sender][spender] = (
240       _allowed[msg.sender][spender].sub(subtractedValue));
241     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
242     return true;
243   }
244 
245   /**
246   * @dev Transfer token for a specified addresses
247   * @param from The address to transfer from.
248   * @param to The address to transfer to.
249   * @param value The amount to be transferred.
250   */
251   function _transfer(address from, address to, uint256 value) internal {
252     require(value <= _balances[from]);
253     require(to != address(0));
254 
255     _balances[from] = _balances[from].sub(value);
256     _balances[to] = _balances[to].add(value);
257     emit Transfer(from, to, value);
258   }
259 
260   /**
261    * @dev Internal function that mints an amount of the token and assigns it to
262    * an account. This encapsulates the modification of balances such that the
263    * proper events are emitted.
264    * @param account The account that will receive the created tokens.
265    * @param value The amount that will be created.
266    */
267   function _mint(address account, uint256 value) internal {
268     require(account != 0);
269     _totalSupply = _totalSupply.add(value);
270     _balances[account] = _balances[account].add(value);
271     emit Transfer(address(0), account, value);
272   }
273 
274   /**
275    * @dev Internal function that burns an amount of the token of a given
276    * account.
277    * @param account The account whose tokens will be burnt.
278    * @param value The amount that will be burnt.
279    */
280   function _burn(address account, uint256 value) internal {
281     require(account != 0);
282     require(value <= _balances[account]);
283 
284     _totalSupply = _totalSupply.sub(value);
285     _balances[account] = _balances[account].sub(value);
286     emit Transfer(account, address(0), value);
287   }
288 
289   /**
290    * @dev Internal function that burns an amount of the token of a given
291    * account, deducting from the sender's allowance for said account. Uses the
292    * internal burn function.
293    * @param account The account whose tokens will be burnt.
294    * @param value The amount that will be burnt.
295    */
296   function _burnFrom(address account, uint256 value) internal {
297     require(value <= _allowed[account][msg.sender]);
298 
299     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
300     // this function needs to emit an event with the updated approval.
301     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
302       value);
303     _burn(account, value);
304   }
305 }
306 
307 /**
308  * @title Roles
309  * @dev Library for managing addresses assigned to a Role.
310  */
311 library Roles {
312   struct Role {
313     mapping (address => bool) bearer;
314   }
315 
316   /**
317    * @dev give an account access to this role
318    */
319   function add(Role storage role, address account) internal {
320     require(account != address(0));
321     role.bearer[account] = true;
322   }
323 
324   /**
325    * @dev remove an account's access to this role
326    */
327   function remove(Role storage role, address account) internal {
328     require(account != address(0));
329     role.bearer[account] = false;
330   }
331 
332   /**
333    * @dev check if an account has this role
334    * @return bool
335    */
336   function has(Role storage role, address account)
337     internal
338     view
339     returns (bool)
340   {
341     require(account != address(0));
342     return role.bearer[account];
343   }
344 }
345 
346 contract MinterRole {
347   using Roles for Roles.Role;
348 
349   event MinterAdded(address indexed account);
350   event MinterRemoved(address indexed account);
351 
352   Roles.Role private minters;
353 
354   constructor() public {
355     _addMinter(msg.sender);
356   }
357 
358   modifier onlyMinter() {
359     require(isMinter(msg.sender));
360     _;
361   }
362 
363   function isMinter(address account) public view returns (bool) {
364     return minters.has(account);
365   }
366 
367   function addMinter(address account) public onlyMinter {
368     _addMinter(account);
369   }
370 
371   function renounceMinter() public {
372     _removeMinter(msg.sender);
373   }
374 
375   function _addMinter(address account) internal {
376     minters.add(account);
377     emit MinterAdded(account);
378   }
379 
380   function _removeMinter(address account) internal {
381     minters.remove(account);
382     emit MinterRemoved(account);
383   }
384 }
385 
386 /**
387  * @title Ownable
388  * @dev The Ownable contract has an owner address, and provides basic authorization control
389  * functions, this simplifies the implementation of "user permissions".
390  */
391 contract Ownable {
392   address private _owner;
393 
394   event OwnershipTransferred(
395     address indexed previousOwner,
396     address indexed newOwner
397   );
398 
399   /**
400    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
401    * account.
402    */
403   constructor() public {
404     _owner = msg.sender;
405     emit OwnershipTransferred(address(0), _owner);
406   }
407 
408   /**
409    * @return the address of the owner.
410    */
411   function owner() public view returns(address) {
412     return _owner;
413   }
414 
415   /**
416    * @dev Throws if called by any account other than the owner.
417    */
418   modifier onlyOwner() {
419     require(isOwner());
420     _;
421   }
422 
423   /**
424    * @return true if `msg.sender` is the owner of the contract.
425    */
426   function isOwner() public view returns(bool) {
427     return msg.sender == _owner;
428   }
429 
430   /**
431    * @dev Allows the current owner to relinquish control of the contract.
432    * @notice Renouncing to ownership will leave the contract without an owner.
433    * It will not be possible to call the functions with the `onlyOwner`
434    * modifier anymore.
435    */
436   function renounceOwnership() public onlyOwner {
437     emit OwnershipTransferred(_owner, address(0));
438     _owner = address(0);
439   }
440 
441   /**
442    * @dev Allows the current owner to transfer control of the contract to a newOwner.
443    * @param newOwner The address to transfer ownership to.
444    */
445   function transferOwnership(address newOwner) public onlyOwner {
446     _transferOwnership(newOwner);
447   }
448 
449   /**
450    * @dev Transfers control of the contract to a newOwner.
451    * @param newOwner The address to transfer ownership to.
452    */
453   function _transferOwnership(address newOwner) internal {
454     require(newOwner != address(0));
455     emit OwnershipTransferred(_owner, newOwner);
456     _owner = newOwner;
457   }
458 }
459 
460 /**
461  * @title ERC20Mintable
462  * @dev ERC20 minting logic
463  */
464 contract ERC20Mintable is ERC20, MinterRole {
465   /**
466    * @dev Function to mint tokens
467    * @param to The address that will receive the minted tokens.
468    * @param value The amount of tokens to mint.
469    * @return A boolean that indicates if the operation was successful.
470    */
471   function mint(
472     address to,
473     uint256 value
474   )
475     public
476     onlyMinter
477     returns (bool)
478   {
479     _mint(to, value);
480     return true;
481   }
482 }
483 
484 /**
485  * @title Burnable Token
486  * @dev Token that can be irreversibly burned (destroyed).
487  */
488 contract ERC20Burnable is ERC20, Ownable {
489 
490   /**
491    * @dev Burns a specific amount of tokens.
492    * @param value The amount of token to be burned.
493    */
494   function burn(uint256 value) onlyOwner public {
495     _burn(msg.sender, value);
496   }
497 
498   /**
499    * @dev Burns a specific amount of tokens from the target address and decrements allowance
500    * @param from address The address which you want to send tokens from
501    * @param value uint256 The amount of token to be burned
502    */
503   function burnFrom(address from, uint256 value) onlyOwner public {
504     _burnFrom(from, value);
505   }
506 }
507 
508 /**
509  * @title HadaCoinV18
510  */
511 contract HadacoinV18 is ERC20Mintable, ERC20Burnable {
512 
513   string public constant name = "Hada Coin";
514   string public constant symbol = "HADA";
515   uint8 public constant decimals = 6;
516 
517   uint256 public constant INITIAL_SUPPLY = 500000000 * (10 ** uint256(decimals));
518 
519   /**
520    * @dev Constructor that gives msg.sender all of existing tokens.
521    */
522   constructor() public {
523     _mint(msg.sender, INITIAL_SUPPLY);
524   }
525 
526 }