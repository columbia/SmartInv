1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Roles
5  * @dev Library for managing addresses assigned to a Role.
6  */
7 library Roles {
8   struct Role {
9     mapping (address => bool) bearer;
10   }
11 
12   /**
13    * @dev give an account access to this role
14    */
15   function add(Role storage role, address account) internal {
16     require(account != address(0));
17     require(!has(role, account));
18 
19     role.bearer[account] = true;
20   }
21 
22   /**
23    * @dev remove an account's access to this role
24    */
25   function remove(Role storage role, address account) internal {
26     require(account != address(0));
27     require(has(role, account));
28 
29     role.bearer[account] = false;
30   }
31 
32   /**
33    * @dev check if an account has this role
34    * @return bool
35    */
36   function has(Role storage role, address account)
37     internal
38     view
39     returns (bool)
40   {
41     require(account != address(0));
42     return role.bearer[account];
43   }
44 }
45 
46 
47 /**
48  * @title ERC20 interface
49  * @dev see https://github.com/ethereum/EIPs/issues/20
50  */
51 interface IERC20 {
52   function totalSupply() external view returns (uint256);
53 
54   function balanceOf(address who) external view returns (uint256);
55 
56   function allowance(address owner, address spender)
57     external view returns (uint256);
58 
59   function transfer(address to, uint256 value) external returns (bool);
60 
61   function approve(address spender, uint256 value)
62     external returns (bool);
63 
64   function transferFrom(address from, address to, uint256 value)
65     external returns (bool);
66 
67   event Transfer(
68     address indexed from,
69     address indexed to,
70     uint256 value
71   );
72 
73   event Approval(
74     address indexed owner,
75     address indexed spender,
76     uint256 value
77   );
78 }
79 
80 
81 
82 
83 contract MinterRole {
84   using Roles for Roles.Role;
85 
86   event MinterAdded(address indexed account);
87   event MinterRemoved(address indexed account);
88 
89   Roles.Role private minters;
90 
91   constructor() internal {
92     _addMinter(msg.sender);
93   }
94 
95   modifier onlyMinter() {
96     require(isMinter(msg.sender));
97     _;
98   }
99 
100   function isMinter(address account) public view returns (bool) {
101     return minters.has(account);
102   }
103 
104   function addMinter(address account) public onlyMinter {
105     _addMinter(account);
106   }
107 
108   function renounceMinter() public {
109     _removeMinter(msg.sender);
110   }
111 
112   function _addMinter(address account) internal {
113     minters.add(account);
114     emit MinterAdded(account);
115   }
116 
117   function _removeMinter(address account) internal {
118     minters.remove(account);
119     emit MinterRemoved(account);
120   }
121 }
122 // solium-disable linebreak-style
123 
124  
125 
126 
127 
128 
129 
130 
131 
132 /**
133  * @title SafeMath
134  * @dev Math operations with safety checks that revert on error
135  */
136 library SafeMath {
137 
138   /**
139   * @dev Multiplies two numbers, reverts on overflow.
140   */
141   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
142     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
143     // benefit is lost if 'b' is also tested.
144     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
145     if (a == 0) {
146       return 0;
147     }
148 
149     uint256 c = a * b;
150     require(c / a == b);
151 
152     return c;
153   }
154 
155   /**
156   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
157   */
158   function div(uint256 a, uint256 b) internal pure returns (uint256) {
159     require(b > 0); // Solidity only automatically asserts when dividing by 0
160     uint256 c = a / b;
161     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
162 
163     return c;
164   }
165 
166   /**
167   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
168   */
169   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
170     require(b <= a);
171     uint256 c = a - b;
172 
173     return c;
174   }
175 
176   /**
177   * @dev Adds two numbers, reverts on overflow.
178   */
179   function add(uint256 a, uint256 b) internal pure returns (uint256) {
180     uint256 c = a + b;
181     require(c >= a);
182 
183     return c;
184   }
185 
186   /**
187   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
188   * reverts when dividing by zero.
189   */
190   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
191     require(b != 0);
192     return a % b;
193   }
194 }
195 
196 
197 /**
198  * @title Standard ERC20 token
199  *
200  * @dev Implementation of the basic standard token.
201  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
202  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
203  */
204 contract ERC20 is IERC20 {
205   using SafeMath for uint256;
206 
207   mapping (address => uint256) private _balances;
208 
209   mapping (address => mapping (address => uint256)) private _allowed;
210 
211   uint256 private _totalSupply;
212 
213   /**
214   * @dev Total number of tokens in existence
215   */
216   function totalSupply() public view returns (uint256) {
217     return _totalSupply;
218   }
219 
220   /**
221   * @dev Gets the balance of the specified address.
222   * @param owner The address to query the balance of.
223   * @return An uint256 representing the amount owned by the passed address.
224   */
225   function balanceOf(address owner) public view returns (uint256) {
226     return _balances[owner];
227   }
228 
229   /**
230    * @dev Function to check the amount of tokens that an owner allowed to a spender.
231    * @param owner address The address which owns the funds.
232    * @param spender address The address which will spend the funds.
233    * @return A uint256 specifying the amount of tokens still available for the spender.
234    */
235   function allowance(
236     address owner,
237     address spender
238    )
239     public
240     view
241     returns (uint256)
242   {
243     return _allowed[owner][spender];
244   }
245 
246   /**
247   * @dev Transfer token for a specified address
248   * @param to The address to transfer to.
249   * @param value The amount to be transferred.
250   */
251   function transfer(address to, uint256 value) public returns (bool) {
252     _transfer(msg.sender, to, value);
253     return true;
254   }
255 
256   /**
257    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
258    * Beware that changing an allowance with this method brings the risk that someone may use both the old
259    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
260    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
261    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
262    * @param spender The address which will spend the funds.
263    * @param value The amount of tokens to be spent.
264    */
265   function approve(address spender, uint256 value) public returns (bool) {
266     require(spender != address(0));
267 
268     _allowed[msg.sender][spender] = value;
269     emit Approval(msg.sender, spender, value);
270     return true;
271   }
272 
273   /**
274    * @dev Transfer tokens from one address to another
275    * @param from address The address which you want to send tokens from
276    * @param to address The address which you want to transfer to
277    * @param value uint256 the amount of tokens to be transferred
278    */
279   function transferFrom(
280     address from,
281     address to,
282     uint256 value
283   )
284     public
285     returns (bool)
286   {
287     require(value <= _allowed[from][msg.sender]);
288 
289     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
290     _transfer(from, to, value);
291     return true;
292   }
293 
294   /**
295    * @dev Increase the amount of tokens that an owner allowed to a spender.
296    * approve should be called when allowed_[_spender] == 0. To increment
297    * allowed value is better to use this function to avoid 2 calls (and wait until
298    * the first transaction is mined)
299    * From MonolithDAO Token.sol
300    * @param spender The address which will spend the funds.
301    * @param addedValue The amount of tokens to increase the allowance by.
302    */
303   function increaseAllowance(
304     address spender,
305     uint256 addedValue
306   )
307     public
308     returns (bool)
309   {
310     require(spender != address(0));
311 
312     _allowed[msg.sender][spender] = (
313       _allowed[msg.sender][spender].add(addedValue));
314     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
315     return true;
316   }
317 
318   /**
319    * @dev Decrease the amount of tokens that an owner allowed to a spender.
320    * approve should be called when allowed_[_spender] == 0. To decrement
321    * allowed value is better to use this function to avoid 2 calls (and wait until
322    * the first transaction is mined)
323    * From MonolithDAO Token.sol
324    * @param spender The address which will spend the funds.
325    * @param subtractedValue The amount of tokens to decrease the allowance by.
326    */
327   function decreaseAllowance(
328     address spender,
329     uint256 subtractedValue
330   )
331     public
332     returns (bool)
333   {
334     require(spender != address(0));
335 
336     _allowed[msg.sender][spender] = (
337       _allowed[msg.sender][spender].sub(subtractedValue));
338     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
339     return true;
340   }
341 
342   /**
343   * @dev Transfer token for a specified addresses
344   * @param from The address to transfer from.
345   * @param to The address to transfer to.
346   * @param value The amount to be transferred.
347   */
348   function _transfer(address from, address to, uint256 value) internal {
349     require(value <= _balances[from]);
350     require(to != address(0));
351 
352     _balances[from] = _balances[from].sub(value);
353     _balances[to] = _balances[to].add(value);
354     emit Transfer(from, to, value);
355   }
356 
357   /**
358    * @dev Internal function that mints an amount of the token and assigns it to
359    * an account. This encapsulates the modification of balances such that the
360    * proper events are emitted.
361    * @param account The account that will receive the created tokens.
362    * @param value The amount that will be created.
363    */
364   function _mint(address account, uint256 value) internal {
365     require(account != 0);
366     _totalSupply = _totalSupply.add(value);
367     _balances[account] = _balances[account].add(value);
368     emit Transfer(address(0), account, value);
369   }
370 
371   /**
372    * @dev Internal function that burns an amount of the token of a given
373    * account.
374    * @param account The account whose tokens will be burnt.
375    * @param value The amount that will be burnt.
376    */
377   function _burn(address account, uint256 value) internal {
378     require(account != 0);
379     require(value <= _balances[account]);
380 
381     _totalSupply = _totalSupply.sub(value);
382     _balances[account] = _balances[account].sub(value);
383     emit Transfer(account, address(0), value);
384   }
385 
386   /**
387    * @dev Internal function that burns an amount of the token of a given
388    * account, deducting from the sender's allowance for said account. Uses the
389    * internal burn function.
390    * @param account The account whose tokens will be burnt.
391    * @param value The amount that will be burnt.
392    */
393   function _burnFrom(address account, uint256 value) internal {
394     require(value <= _allowed[account][msg.sender]);
395 
396     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
397     // this function needs to emit an event with the updated approval.
398     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
399       value);
400     _burn(account, value);
401   }
402 }
403 
404 
405 
406 /**
407  * @title ERC20Mintable
408  * @dev ERC20 minting logic
409  */
410 contract ERC20Mintable is ERC20, MinterRole {
411   /**
412    * @dev Function to mint tokens
413    * @param to The address that will receive the minted tokens.
414    * @param value The amount of tokens to mint.
415    * @return A boolean that indicates if the operation was successful.
416    */
417   function mint(
418     address to,
419     uint256 value
420   )
421     public
422     onlyMinter
423     returns (bool)
424   {
425     _mint(to, value);
426     return true;
427   }
428 }
429 
430 
431 
432 
433 
434 /**
435  * @title ERC20Detailed token
436  * @dev The decimals are only for visualization purposes.
437  * All the operations are done using the smallest and indivisible token unit,
438  * just as on Ethereum all the operations are done in wei.
439  */
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
473 
474 
475 /**
476  * @title Ownable
477  * @dev The Ownable contract has an owner address, and provides basic authorization control
478  * functions, this simplifies the implementation of "user permissions".
479  */
480 contract Ownable {
481   address private _owner;
482 
483   event OwnershipTransferred(
484     address indexed previousOwner,
485     address indexed newOwner
486   );
487 
488   /**
489    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
490    * account.
491    */
492   constructor() internal {
493     _owner = msg.sender;
494     emit OwnershipTransferred(address(0), _owner);
495   }
496 
497   /**
498    * @return the address of the owner.
499    */
500   function owner() public view returns(address) {
501     return _owner;
502   }
503 
504   /**
505    * @dev Throws if called by any account other than the owner.
506    */
507   modifier onlyOwner() {
508     require(isOwner());
509     _;
510   }
511 
512   /**
513    * @return true if `msg.sender` is the owner of the contract.
514    */
515   function isOwner() public view returns(bool) {
516     return msg.sender == _owner;
517   }
518 
519   /**
520    * @dev Allows the current owner to relinquish control of the contract.
521    * @notice Renouncing to ownership will leave the contract without an owner.
522    * It will not be possible to call the functions with the `onlyOwner`
523    * modifier anymore.
524    */
525   function renounceOwnership() public onlyOwner {
526     emit OwnershipTransferred(_owner, address(0));
527     _owner = address(0);
528   }
529 
530   /**
531    * @dev Allows the current owner to transfer control of the contract to a newOwner.
532    * @param newOwner The address to transfer ownership to.
533    */
534   function transferOwnership(address newOwner) public onlyOwner {
535     _transferOwnership(newOwner);
536   }
537 
538   /**
539    * @dev Transfers control of the contract to a newOwner.
540    * @param newOwner The address to transfer ownership to.
541    */
542   function _transferOwnership(address newOwner) internal {
543     require(newOwner != address(0));
544     emit OwnershipTransferred(_owner, newOwner);
545     _owner = newOwner;
546   }
547 }
548 
549 
550 /**
551  * @title SampleCrowdsaleToken
552  * @dev Very simple ERC20 Token that can be minted.
553  * It is meant to be used in a crowdsale contract.
554  */
555 contract SampleCrowdsaleToken is ERC20Mintable, ERC20Detailed,Ownable {
556 
557     constructor(string name, string symbol, uint8 decimals,uint256 INITIAL_SUPPLY) 
558     public 
559     ERC20Detailed(name, symbol, decimals) 
560     {  
561         INITIAL_SUPPLY = INITIAL_SUPPLY * (10 ** uint256(decimals));
562         _mint(msg.sender, INITIAL_SUPPLY);
563     }
564 
565 }