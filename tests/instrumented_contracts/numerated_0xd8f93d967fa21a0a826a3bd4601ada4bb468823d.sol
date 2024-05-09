1 pragma solidity ^0.4.24;
2 
3 
4 interface IERC20 {
5   function totalSupply() external view returns (uint256);
6 
7   function balanceOf(address who) external view returns (uint256);
8 
9   function allowance(address owner, address spender)
10     external view returns (uint256);
11 
12   function transfer(address to, uint256 value) external returns (bool);
13 
14   function approve(address spender, uint256 value)
15     external returns (bool);
16 
17   function transferFrom(address from, address to, uint256 value)
18     external returns (bool);
19 
20   event Transfer(
21     address indexed from,
22     address indexed to,
23     uint256 value
24   );
25 
26   event Approval(
27     address indexed owner,
28     address indexed spender,
29     uint256 value
30   );
31 }
32 
33 library SafeMath {
34 
35   /**
36   * @dev Multiplies two numbers, reverts on overflow.
37   */
38   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
39     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
40     // benefit is lost if 'b' is also tested.
41     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
42     if (a == 0) {
43       return 0;
44     }
45 
46     uint256 c = a * b;
47     require(c / a == b);
48 
49     return c;
50   }
51 
52   /**
53   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
54   */
55   function div(uint256 a, uint256 b) internal pure returns (uint256) {
56     require(b > 0); // Solidity only automatically asserts when dividing by 0
57     uint256 c = a / b;
58     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
59 
60     return c;
61   }
62 
63   /**
64   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
65   */
66   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67     require(b <= a);
68     uint256 c = a - b;
69 
70     return c;
71   }
72 
73   /**
74   * @dev Adds two numbers, reverts on overflow.
75   */
76   function add(uint256 a, uint256 b) internal pure returns (uint256) {
77     uint256 c = a + b;
78     require(c >= a);
79 
80     return c;
81   }
82 
83   /**
84   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
85   * reverts when dividing by zero.
86   */
87   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
88     require(b != 0);
89     return a % b;
90   }
91 }
92 
93 contract ERC20 is IERC20 {
94   using SafeMath for uint256;
95 
96   mapping (address => uint256) private _balances;
97 
98   mapping (address => mapping (address => uint256)) private _allowed;
99 
100   uint256 private _totalSupply;
101 
102   /**
103   * @dev Total number of tokens in existence
104   */
105   function totalSupply() public view returns (uint256) {
106     return _totalSupply;
107   }
108 
109   /**
110   * @dev Gets the balance of the specified address.
111   * @param owner The address to query the balance of.
112   * @return An uint256 representing the amount owned by the passed address.
113   */
114   function balanceOf(address owner) public view returns (uint256) {
115     return _balances[owner];
116   }
117 
118   /**
119    * @dev Function to check the amount of tokens that an owner allowed to a spender.
120    * @param owner address The address which owns the funds.
121    * @param spender address The address which will spend the funds.
122    * @return A uint256 specifying the amount of tokens still available for the spender.
123    */
124   function allowance(
125     address owner,
126     address spender
127    )
128     public
129     view
130     returns (uint256)
131   {
132     return _allowed[owner][spender];
133   }
134 
135   /**
136   * @dev Transfer token for a specified address
137   * @param to The address to transfer to.
138   * @param value The amount to be transferred.
139   */
140   function transfer(address to, uint256 value) public returns (bool) {
141     _transfer(msg.sender, to, value);
142     return true;
143   }
144 
145   /**
146    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
147    * Beware that changing an allowance with this method brings the risk that someone may use both the old
148    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
149    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
150    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
151    * @param spender The address which will spend the funds.
152    * @param value The amount of tokens to be spent.
153    */
154   function approve(address spender, uint256 value) public returns (bool) {
155     require(spender != address(0));
156 
157     _allowed[msg.sender][spender] = value;
158     emit Approval(msg.sender, spender, value);
159     return true;
160   }
161 
162   /**
163    * @dev Transfer tokens from one address to another
164    * @param from address The address which you want to send tokens from
165    * @param to address The address which you want to transfer to
166    * @param value uint256 the amount of tokens to be transferred
167    */
168   function transferFrom(
169     address from,
170     address to,
171     uint256 value
172   )
173     public
174     returns (bool)
175   {
176     require(value <= _allowed[from][msg.sender]);
177 
178     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
179     _transfer(from, to, value);
180     return true;
181   }
182 
183   /**
184    * @dev Increase the amount of tokens that an owner allowed to a spender.
185    * approve should be called when allowed_[_spender] == 0. To increment
186    * allowed value is better to use this function to avoid 2 calls (and wait until
187    * the first transaction is mined)
188    * From MonolithDAO Token.sol
189    * @param spender The address which will spend the funds.
190    * @param addedValue The amount of tokens to increase the allowance by.
191    */
192   function increaseAllowance(
193     address spender,
194     uint256 addedValue
195   )
196     public
197     returns (bool)
198   {
199     require(spender != address(0));
200 
201     _allowed[msg.sender][spender] = (
202       _allowed[msg.sender][spender].add(addedValue));
203     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
204     return true;
205   }
206 
207   /**
208    * @dev Decrease the amount of tokens that an owner allowed to a spender.
209    * approve should be called when allowed_[_spender] == 0. To decrement
210    * allowed value is better to use this function to avoid 2 calls (and wait until
211    * the first transaction is mined)
212    * From MonolithDAO Token.sol
213    * @param spender The address which will spend the funds.
214    * @param subtractedValue The amount of tokens to decrease the allowance by.
215    */
216   function decreaseAllowance(
217     address spender,
218     uint256 subtractedValue
219   )
220     public
221     returns (bool)
222   {
223     require(spender != address(0));
224 
225     _allowed[msg.sender][spender] = (
226       _allowed[msg.sender][spender].sub(subtractedValue));
227     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
228     return true;
229   }
230 
231   /**
232   * @dev Transfer token for a specified addresses
233   * @param from The address to transfer from.
234   * @param to The address to transfer to.
235   * @param value The amount to be transferred.
236   */
237   function _transfer(address from, address to, uint256 value) internal {
238     require(value <= _balances[from]);
239     require(to != address(0));
240 
241     _balances[from] = _balances[from].sub(value);
242     _balances[to] = _balances[to].add(value);
243     emit Transfer(from, to, value);
244   }
245 
246   /**
247    * @dev Internal function that mints an amount of the token and assigns it to
248    * an account. This encapsulates the modification of balances such that the
249    * proper events are emitted.
250    * @param account The account that will receive the created tokens.
251    * @param value The amount that will be created.
252    */
253   function _mint(address account, uint256 value) internal {
254     require(account != 0);
255     _totalSupply = _totalSupply.add(value);
256     _balances[account] = _balances[account].add(value);
257     emit Transfer(address(0), account, value);
258   }
259 
260   /**
261    * @dev Internal function that burns an amount of the token of a given
262    * account.
263    * @param account The account whose tokens will be burnt.
264    * @param value The amount that will be burnt.
265    */
266   function _burn(address account, uint256 value) internal {
267     require(account != 0);
268     require(value <= _balances[account]);
269 
270     _totalSupply = _totalSupply.sub(value);
271     _balances[account] = _balances[account].sub(value);
272     emit Transfer(account, address(0), value);
273   }
274 
275   /**
276    * @dev Internal function that burns an amount of the token of a given
277    * account, deducting from the sender's allowance for said account. Uses the
278    * internal burn function.
279    * @param account The account whose tokens will be burnt.
280    * @param value The amount that will be burnt.
281    */
282   function _burnFrom(address account, uint256 value) internal {
283     require(value <= _allowed[account][msg.sender]);
284 
285     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
286     // this function needs to emit an event with the updated approval.
287     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
288       value);
289     _burn(account, value);
290   }
291 }
292 
293 library Roles {
294   struct Role {
295     mapping (address => bool) bearer;
296   }
297 
298   /**
299    * @dev give an account access to this role
300    */
301   function add(Role storage role, address account) internal {
302     require(account != address(0));
303     require(!has(role, account));
304 
305     role.bearer[account] = true;
306   }
307 
308   /**
309    * @dev remove an account's access to this role
310    */
311   function remove(Role storage role, address account) internal {
312     require(account != address(0));
313     require(has(role, account));
314 
315     role.bearer[account] = false;
316   }
317 
318   /**
319    * @dev check if an account has this role
320    * @return bool
321    */
322   function has(Role storage role, address account)
323     internal
324     view
325     returns (bool)
326   {
327     require(account != address(0));
328     return role.bearer[account];
329   }
330 }
331 
332 contract BurnerRole {
333   using Roles for Roles.Role;
334 
335   event BurnerAdded(address indexed account);
336   event BurnerRemoved(address indexed account);
337 
338   Roles.Role private burners;
339 
340   constructor() internal {
341     _addBurner(msg.sender);
342   }
343 
344   modifier onlyBurner() {
345     require(isBurner(msg.sender));
346     _;
347   }
348 
349   function isBurner(address account) public view returns (bool) {
350     return burners.has(account);
351   }
352 
353   function addBurner(address account) public onlyBurner {
354     _addBurner(account);
355   }
356 
357   function renounceBurner() public {
358     _removeBurner(msg.sender);
359   }
360 
361   function _addBurner(address account) internal {
362     burners.add(account);
363     emit BurnerAdded(account);
364   }
365 
366   function _removeBurner(address account) internal {
367     burners.remove(account);
368     emit BurnerRemoved(account);
369   }
370 }
371 
372 contract ERC20Burnable is ERC20, BurnerRole {
373 
374   /**
375    * @dev Burns a specific amount of tokens.
376    * @param value The amount of token to be burned.
377    */
378   function burn(uint256 value) public onlyBurner {
379     _burn(msg.sender, value);
380   }
381 
382 }
383 
384 contract MinterRole {
385   using Roles for Roles.Role;
386 
387   event MinterAdded(address indexed account);
388   event MinterRemoved(address indexed account);
389 
390   Roles.Role private minters;
391 
392   constructor() internal {
393     _addMinter(msg.sender);
394   }
395 
396   modifier onlyMinter() {
397     require(isMinter(msg.sender));
398     _;
399   }
400 
401   function isMinter(address account) public view returns (bool) {
402     return minters.has(account);
403   }
404 
405   function addMinter(address account) public onlyMinter {
406     _addMinter(account);
407   }
408 
409   function renounceMinter() public {
410     _removeMinter(msg.sender);
411   }
412 
413   function _addMinter(address account) internal {
414     minters.add(account);
415     emit MinterAdded(account);
416   }
417 
418   function _removeMinter(address account) internal {
419     minters.remove(account);
420     emit MinterRemoved(account);
421   }
422 }
423 
424 contract ERC20Mintable is ERC20, MinterRole {
425   /**
426    * @dev Function to mint tokens
427    * @param to The address that will receive the minted tokens.
428    * @param value The amount of tokens to mint.
429    * @return A boolean that indicates if the operation was successful.
430    */
431   function mint(
432     address to,
433     uint256 value
434   )
435     public
436     onlyMinter
437     returns (bool)
438   {
439     _mint(to, value);
440     return true;
441   }
442 }
443 
444 contract Ownable {
445   address private _owner;
446 
447   event OwnershipTransferred(
448     address indexed previousOwner,
449     address indexed newOwner
450   );
451 
452   /**
453    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
454    * account.
455    */
456   constructor() internal {
457     _owner = msg.sender;
458     emit OwnershipTransferred(address(0), _owner);
459   }
460 
461   /**
462    * @return the address of the owner.
463    */
464   function owner() public view returns(address) {
465     return _owner;
466   }
467 
468   /**
469    * @dev Throws if called by any account other than the owner.
470    */
471   modifier onlyOwner() {
472     require(isOwner());
473     _;
474   }
475 
476   /**
477    * @return true if `msg.sender` is the owner of the contract.
478    */
479   function isOwner() public view returns(bool) {
480     return msg.sender == _owner;
481   }
482 
483   /**
484    * @dev Allows the current owner to relinquish control of the contract.
485    * @notice Renouncing to ownership will leave the contract without an owner.
486    * It will not be possible to call the functions with the `onlyOwner`
487    * modifier anymore.
488    */
489   function renounceOwnership() public onlyOwner {
490     emit OwnershipTransferred(_owner, address(0));
491     _owner = address(0);
492   }
493 
494   /**
495    * @dev Allows the current owner to transfer control of the contract to a newOwner.
496    * @param newOwner The address to transfer ownership to.
497    */
498   function transferOwnership(address newOwner) public onlyOwner {
499     _transferOwnership(newOwner);
500   }
501 
502   /**
503    * @dev Transfers control of the contract to a newOwner.
504    * @param newOwner The address to transfer ownership to.
505    */
506   function _transferOwnership(address newOwner) internal {
507     require(newOwner != address(0));
508     emit OwnershipTransferred(_owner, newOwner);
509     _owner = newOwner;
510   }
511 }
512 
513 contract KPC8 is ERC20, ERC20Mintable, ERC20Burnable, Ownable {
514     string public name = "KPC8";
515     string public symbol = "KPC8";
516     uint8 public decimals = 18;
517     uint public INITIAL_SUPPLY = 3000000000 * 10 ** uint(decimals);
518 
519     constructor() public {
520         _mint(msg.sender, INITIAL_SUPPLY);
521     }
522 }