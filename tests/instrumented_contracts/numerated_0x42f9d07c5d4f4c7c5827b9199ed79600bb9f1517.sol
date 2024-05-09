1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
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
38 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
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
79 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
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
145 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
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
172   * @param owner The address to query the the balance of.
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
312    * @param amount The amount that will be created.
313    */
314   function _mint(address account, uint256 amount) internal {
315     require(account != 0);
316     _totalSupply = _totalSupply.add(amount);
317     _balances[account] = _balances[account].add(amount);
318     emit Transfer(address(0), account, amount);
319   }
320 
321   /**
322    * @dev Internal function that burns an amount of the token of a given
323    * account.
324    * @param account The account whose tokens will be burnt.
325    * @param amount The amount that will be burnt.
326    */
327   function _burn(address account, uint256 amount) internal {
328     require(account != 0);
329     require(amount <= _balances[account]);
330 
331     _totalSupply = _totalSupply.sub(amount);
332     _balances[account] = _balances[account].sub(amount);
333     emit Transfer(account, address(0), amount);
334   }
335 
336   /**
337    * @dev Internal function that burns an amount of the token of a given
338    * account, deducting from the sender's allowance for said account. Uses the
339    * internal burn function.
340    * @param account The account whose tokens will be burnt.
341    * @param amount The amount that will be burnt.
342    */
343   function _burnFrom(address account, uint256 amount) internal {
344     require(amount <= _allowed[account][msg.sender]);
345 
346     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
347     // this function needs to emit an event with the updated approval.
348     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
349       amount);
350     _burn(account, amount);
351   }
352 }
353 
354 // File: openzeppelin-solidity/contracts/access/Roles.sol
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
370     role.bearer[account] = true;
371   }
372 
373   /**
374    * @dev remove an account's access to this role
375    */
376   function remove(Role storage role, address account) internal {
377     require(account != address(0));
378     role.bearer[account] = false;
379   }
380 
381   /**
382    * @dev check if an account has this role
383    * @return bool
384    */
385   function has(Role storage role, address account)
386     internal
387     view
388     returns (bool)
389   {
390     require(account != address(0));
391     return role.bearer[account];
392   }
393 }
394 
395 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
396 
397 contract MinterRole {
398   using Roles for Roles.Role;
399 
400   event MinterAdded(address indexed account);
401   event MinterRemoved(address indexed account);
402 
403   Roles.Role private minters;
404 
405   constructor() public {
406     _addMinter(msg.sender);
407   }
408 
409   modifier onlyMinter() {
410     require(isMinter(msg.sender));
411     _;
412   }
413 
414   function isMinter(address account) public view returns (bool) {
415     return minters.has(account);
416   }
417 
418   function addMinter(address account) public onlyMinter {
419     _addMinter(account);
420   }
421 
422   function renounceMinter() public {
423     _removeMinter(msg.sender);
424   }
425 
426   function _addMinter(address account) internal {
427     minters.add(account);
428     emit MinterAdded(account);
429   }
430 
431   function _removeMinter(address account) internal {
432     minters.remove(account);
433     emit MinterRemoved(account);
434   }
435 }
436 
437 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
438 
439 /**
440  * @title ERC20Mintable
441  * @dev ERC20 minting logic
442  */
443 contract ERC20Mintable is ERC20, MinterRole {
444   /**
445    * @dev Function to mint tokens
446    * @param to The address that will receive the minted tokens.
447    * @param amount The amount of tokens to mint.
448    * @return A boolean that indicates if the operation was successful.
449    */
450   function mint(
451     address to,
452     uint256 amount
453   )
454     public
455     onlyMinter
456     returns (bool)
457   {
458     _mint(to, amount);
459     return true;
460   }
461 }
462 
463 // File: contracts/HunterToken.sol
464 
465 /**
466 * Copyright 2017–2018, LaborX PTY
467 * Licensed under the AGPL Version 3 license.
468 */
469 
470 pragma solidity ^0.4.24;
471 
472 
473 
474 
475 contract HunterToken is ERC20Detailed, ERC20Mintable {
476 
477     constructor()
478     ERC20Detailed("Hunter Token", "HNTR", 8)
479     public
480     {
481     }
482 }