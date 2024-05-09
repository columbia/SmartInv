1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 interface IERC20 {
8   function totalSupply() external view returns (uint256);
9 
10   function balanceOf(address who) external view returns (uint256);
11 
12   function allowance(address owner, address spender)
13     external view returns (uint256);
14 
15   function transfer(address to, uint256 value) external returns (bool);
16 
17   function approve(address spender, uint256 value)
18     external returns (bool);
19 
20   function transferFrom(address from, address to, uint256 value)
21     external returns (bool);
22 
23   event Transfer(
24     address indexed from,
25     address indexed to,
26     uint256 value
27   );
28 
29   event Approval(
30     address indexed owner,
31     address indexed spender,
32     uint256 value
33   );
34 }
35 
36 
37 /**
38  * @title Roles
39  * @dev Library for managing addresses assigned to a Role.
40  */
41 library Roles {
42   struct Role {
43     mapping (address => bool) bearer;
44   }
45 
46   /**
47    * @dev give an account access to this role
48    */
49   function add(Role storage role, address account) internal {
50     require(account != address(0));
51     require(!has(role, account));
52 
53     role.bearer[account] = true;
54   }
55 
56   /**
57    * @dev remove an account's access to this role
58    */
59   function remove(Role storage role, address account) internal {
60     require(account != address(0));
61     require(has(role, account));
62 
63     role.bearer[account] = false;
64   }
65 
66   /**
67    * @dev check if an account has this role
68    * @return bool
69    */
70   function has(Role storage role, address account)
71     internal
72     view
73     returns (bool)
74   {
75     require(account != address(0));
76     return role.bearer[account];
77   }
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
122 
123 
124 
125 
126 
127 
128 
129 
130 
131 
132 
133 /**
134  * @title SafeMath
135  * @dev Math operations with safety checks that revert on error
136  */
137 library SafeMath {
138 
139   /**
140   * @dev Multiplies two numbers, reverts on overflow.
141   */
142   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
143     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
144     // benefit is lost if 'b' is also tested.
145     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
146     if (a == 0) {
147       return 0;
148     }
149 
150     uint256 c = a * b;
151     require(c / a == b);
152 
153     return c;
154   }
155 
156   /**
157   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
158   */
159   function div(uint256 a, uint256 b) internal pure returns (uint256) {
160     require(b > 0); // Solidity only automatically asserts when dividing by 0
161     uint256 c = a / b;
162     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
163 
164     return c;
165   }
166 
167   /**
168   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
169   */
170   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
171     require(b <= a);
172     uint256 c = a - b;
173 
174     return c;
175   }
176 
177   /**
178   * @dev Adds two numbers, reverts on overflow.
179   */
180   function add(uint256 a, uint256 b) internal pure returns (uint256) {
181     uint256 c = a + b;
182     require(c >= a);
183 
184     return c;
185   }
186 
187   /**
188   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
189   * reverts when dividing by zero.
190   */
191   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
192     require(b != 0);
193     return a % b;
194   }
195 }
196 
197 
198 /**
199  * @title Standard ERC20 token
200  *
201  * @dev Implementation of the basic standard token.
202  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
203  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
204  */
205 contract ERC20 is IERC20 {
206   using SafeMath for uint256;
207 
208   mapping (address => uint256) private _balances;
209 
210   mapping (address => mapping (address => uint256)) private _allowed;
211 
212   uint256 private _totalSupply;
213 
214   /**
215   * @dev Total number of tokens in existence
216   */
217   function totalSupply() public view returns (uint256) {
218     return _totalSupply;
219   }
220 
221   /**
222   * @dev Gets the balance of the specified address.
223   * @param owner The address to query the balance of.
224   * @return An uint256 representing the amount owned by the passed address.
225   */
226   function balanceOf(address owner) public view returns (uint256) {
227     return _balances[owner];
228   }
229 
230   /**
231    * @dev Function to check the amount of tokens that an owner allowed to a spender.
232    * @param owner address The address which owns the funds.
233    * @param spender address The address which will spend the funds.
234    * @return A uint256 specifying the amount of tokens still available for the spender.
235    */
236   function allowance(
237     address owner,
238     address spender
239    )
240     public
241     view
242     returns (uint256)
243   {
244     return _allowed[owner][spender];
245   }
246 
247   /**
248   * @dev Transfer token for a specified address
249   * @param to The address to transfer to.
250   * @param value The amount to be transferred.
251   */
252   function transfer(address to, uint256 value) public returns (bool) {
253     _transfer(msg.sender, to, value);
254     return true;
255   }
256 
257   /**
258    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
259    * Beware that changing an allowance with this method brings the risk that someone may use both the old
260    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
261    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
262    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
263    * @param spender The address which will spend the funds.
264    * @param value The amount of tokens to be spent.
265    */
266   function approve(address spender, uint256 value) public returns (bool) {
267     require(spender != address(0));
268 
269     _allowed[msg.sender][spender] = value;
270     emit Approval(msg.sender, spender, value);
271     return true;
272   }
273 
274   /**
275    * @dev Transfer tokens from one address to another
276    * @param from address The address which you want to send tokens from
277    * @param to address The address which you want to transfer to
278    * @param value uint256 the amount of tokens to be transferred
279    */
280   function transferFrom(
281     address from,
282     address to,
283     uint256 value
284   )
285     public
286     returns (bool)
287   {
288     require(value <= _allowed[from][msg.sender]);
289 
290     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
291     _transfer(from, to, value);
292     return true;
293   }
294 
295   /**
296    * @dev Increase the amount of tokens that an owner allowed to a spender.
297    * approve should be called when allowed_[_spender] == 0. To increment
298    * allowed value is better to use this function to avoid 2 calls (and wait until
299    * the first transaction is mined)
300    * From MonolithDAO Token.sol
301    * @param spender The address which will spend the funds.
302    * @param addedValue The amount of tokens to increase the allowance by.
303    */
304   function increaseAllowance(
305     address spender,
306     uint256 addedValue
307   )
308     public
309     returns (bool)
310   {
311     require(spender != address(0));
312 
313     _allowed[msg.sender][spender] = (
314       _allowed[msg.sender][spender].add(addedValue));
315     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
316     return true;
317   }
318 
319   /**
320    * @dev Decrease the amount of tokens that an owner allowed to a spender.
321    * approve should be called when allowed_[_spender] == 0. To decrement
322    * allowed value is better to use this function to avoid 2 calls (and wait until
323    * the first transaction is mined)
324    * From MonolithDAO Token.sol
325    * @param spender The address which will spend the funds.
326    * @param subtractedValue The amount of tokens to decrease the allowance by.
327    */
328   function decreaseAllowance(
329     address spender,
330     uint256 subtractedValue
331   )
332     public
333     returns (bool)
334   {
335     require(spender != address(0));
336 
337     _allowed[msg.sender][spender] = (
338       _allowed[msg.sender][spender].sub(subtractedValue));
339     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
340     return true;
341   }
342 
343   /**
344   * @dev Transfer token for a specified addresses
345   * @param from The address to transfer from.
346   * @param to The address to transfer to.
347   * @param value The amount to be transferred.
348   */
349   function _transfer(address from, address to, uint256 value) internal {
350     require(value <= _balances[from]);
351     require(to != address(0));
352 
353     _balances[from] = _balances[from].sub(value);
354     _balances[to] = _balances[to].add(value);
355     emit Transfer(from, to, value);
356   }
357 
358   /**
359    * @dev Internal function that mints an amount of the token and assigns it to
360    * an account. This encapsulates the modification of balances such that the
361    * proper events are emitted.
362    * @param account The account that will receive the created tokens.
363    * @param value The amount that will be created.
364    */
365   function _mint(address account, uint256 value) internal {
366     require(account != 0);
367     _totalSupply = _totalSupply.add(value);
368     _balances[account] = _balances[account].add(value);
369     emit Transfer(address(0), account, value);
370   }
371 
372   /**
373    * @dev Internal function that burns an amount of the token of a given
374    * account.
375    * @param account The account whose tokens will be burnt.
376    * @param value The amount that will be burnt.
377    */
378   function _burn(address account, uint256 value) internal {
379     require(account != 0);
380     require(value <= _balances[account]);
381 
382     _totalSupply = _totalSupply.sub(value);
383     _balances[account] = _balances[account].sub(value);
384     emit Transfer(account, address(0), value);
385   }
386 
387   /**
388    * @dev Internal function that burns an amount of the token of a given
389    * account, deducting from the sender's allowance for said account. Uses the
390    * internal burn function.
391    * @param account The account whose tokens will be burnt.
392    * @param value The amount that will be burnt.
393    */
394   function _burnFrom(address account, uint256 value) internal {
395     require(value <= _allowed[account][msg.sender]);
396 
397     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
398     // this function needs to emit an event with the updated approval.
399     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
400       value);
401     _burn(account, value);
402   }
403 }
404 
405 
406 
407 /**
408  * @title ERC20Mintable
409  * @dev ERC20 minting logic
410  */
411 contract ERC20Mintable is ERC20, MinterRole {
412   /**
413    * @dev Function to mint tokens
414    * @param to The address that will receive the minted tokens.
415    * @param value The amount of tokens to mint.
416    * @return A boolean that indicates if the operation was successful.
417    */
418   function mint(
419     address to,
420     uint256 value
421   )
422     public
423     onlyMinter
424     returns (bool)
425   {
426     _mint(to, value);
427     return true;
428   }
429 }
430 
431 
432 /**
433  * @title Capped token
434  * @dev Mintable token with a token cap.
435  */
436 contract ERC20Capped is ERC20Mintable {
437 
438   uint256 private _cap;
439 
440   constructor(uint256 cap)
441     public
442   {
443     require(cap > 0);
444     _cap = cap;
445   }
446 
447   /**
448    * @return the cap for the token minting.
449    */
450   function cap() public view returns(uint256) {
451     return _cap;
452   }
453 
454   function _mint(address account, uint256 value) internal {
455     require(totalSupply().add(value) <= _cap);
456     super._mint(account, value);
457   }
458 }
459 
460 
461 
462 
463 
464 /**
465  * @title ERC20Detailed token
466  * @dev The decimals are only for visualization purposes.
467  * All the operations are done using the smallest and indivisible token unit,
468  * just as on Ethereum all the operations are done in wei.
469  */
470 contract ERC20Detailed is IERC20 {
471   string private _name;
472   string private _symbol;
473   uint8 private _decimals;
474 
475   constructor(string name, string symbol, uint8 decimals) public {
476     _name = name;
477     _symbol = symbol;
478     _decimals = decimals;
479   }
480 
481   /**
482    * @return the name of the token.
483    */
484   function name() public view returns(string) {
485     return _name;
486   }
487 
488   /**
489    * @return the symbol of the token.
490    */
491   function symbol() public view returns(string) {
492     return _symbol;
493   }
494 
495   /**
496    * @return the number of decimals of the token.
497    */
498   function decimals() public view returns(uint8) {
499     return _decimals;
500   }
501 }
502 
503 
504 
505 /**
506  * @title Ownable
507  * @dev The Ownable contract has an owner address, and provides basic authorization control
508  * functions, this simplifies the implementation of "user permissions".
509  */
510 contract Ownable {
511   address private _owner;
512 
513   event OwnershipTransferred(
514     address indexed previousOwner,
515     address indexed newOwner
516   );
517 
518   /**
519    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
520    * account.
521    */
522   constructor() internal {
523     _owner = msg.sender;
524     emit OwnershipTransferred(address(0), _owner);
525   }
526 
527   /**
528    * @return the address of the owner.
529    */
530   function owner() public view returns(address) {
531     return _owner;
532   }
533 
534   /**
535    * @dev Throws if called by any account other than the owner.
536    */
537   modifier onlyOwner() {
538     require(isOwner());
539     _;
540   }
541 
542   /**
543    * @return true if `msg.sender` is the owner of the contract.
544    */
545   function isOwner() public view returns(bool) {
546     return msg.sender == _owner;
547   }
548 
549   /**
550    * @dev Allows the current owner to relinquish control of the contract.
551    * @notice Renouncing to ownership will leave the contract without an owner.
552    * It will not be possible to call the functions with the `onlyOwner`
553    * modifier anymore.
554    */
555   function renounceOwnership() public onlyOwner {
556     emit OwnershipTransferred(_owner, address(0));
557     _owner = address(0);
558   }
559 
560   /**
561    * @dev Allows the current owner to transfer control of the contract to a newOwner.
562    * @param newOwner The address to transfer ownership to.
563    */
564   function transferOwnership(address newOwner) public onlyOwner {
565     _transferOwnership(newOwner);
566   }
567 
568   /**
569    * @dev Transfers control of the contract to a newOwner.
570    * @param newOwner The address to transfer ownership to.
571    */
572   function _transferOwnership(address newOwner) internal {
573     require(newOwner != address(0));
574     emit OwnershipTransferred(_owner, newOwner);
575     _owner = newOwner;
576   }
577 }
578 
579 
580 contract FavorCoin is ERC20Capped, ERC20Detailed, Ownable {
581   constructor()
582   ERC20Capped(35000000)
583   ERC20Detailed('FavorCoin', 'FAVR', 0)
584   public {
585 
586   }
587 }