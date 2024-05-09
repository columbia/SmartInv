1 /**
2  *Submitted for verification at Etherscan.io on 2019-05-03
3 */
4 
5 pragma solidity ^0.4.24;
6 
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that revert on error
10  */
11 library SafeMath {
12 
13   /**
14   * @dev Multiplies two numbers, reverts on overflow.
15   */
16   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
18     // benefit is lost if 'b' is also tested.
19     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
20     if (a == 0) {
21       return 0;
22     }
23 
24     uint256 c = a * b;
25     require(c / a == b);
26 
27     return c;
28   }
29 
30   /**
31   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
32   */
33   function div(uint256 a, uint256 b) internal pure returns (uint256) {
34     require(b > 0); // Solidity only automatically asserts when dividing by 0
35     uint256 c = a / b;
36     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37 
38     return c;
39   }
40 
41   /**
42   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
43   */
44   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45     require(b <= a);
46     uint256 c = a - b;
47 
48     return c;
49   }
50 
51   /**
52   * @dev Adds two numbers, reverts on overflow.
53   */
54   function add(uint256 a, uint256 b) internal pure returns (uint256) {
55     uint256 c = a + b;
56     require(c >= a);
57 
58     return c;
59   }
60 
61   /**
62   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
63   * reverts when dividing by zero.
64   */
65   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
66     require(b != 0);
67     return a % b;
68   }
69 }
70 
71 
72 
73 /**
74  * @title ERC20 interface
75  * @dev see https://github.com/ethereum/EIPs/issues/20
76  */
77 interface IERC20 {
78   function totalSupply() external view returns (uint256);
79 
80   function balanceOf(address who) external view returns (uint256);
81 
82   function allowance(address owner, address spender)
83   external view returns (uint256);
84 
85   function transfer(address to, uint256 value) external returns (bool);
86 
87   function approve(address spender, uint256 value)
88   external returns (bool);
89 
90   function transferFrom(address from, address to, uint256 value)
91   external returns (bool);
92 
93   event Transfer(
94     address indexed from,
95     address indexed to,
96     uint256 value
97   );
98 
99   event Approval(
100     address indexed owner,
101     address indexed spender,
102     uint256 value
103   );
104 }
105 
106 
107 
108 /**
109  * @title Standard ERC20 token
110  *
111  * @dev Implementation of the basic standard token.
112  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
113  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
114  */
115 contract ERC20 is IERC20 {
116   using SafeMath for uint256;
117 
118   mapping (address => uint256) private _balances;
119 
120   mapping (address => mapping (address => uint256)) private _allowed;
121 
122   uint256 private _totalSupply;
123 
124   /**
125   * @dev Total number of tokens in existence
126   */
127   function totalSupply() public view returns (uint256) {
128     return _totalSupply;
129   }
130 
131   /**
132   * @dev Gets the balance of the specified address.
133   * @param owner The address to query the balance of.
134   * @return An uint256 representing the amount owned by the passed address.
135   */
136   function balanceOf(address owner) public view returns (uint256) {
137     return _balances[owner];
138   }
139 
140   /**
141    * @dev Function to check the amount of tokens that an owner allowed to a spender.
142    * @param owner address The address which owns the funds.
143    * @param spender address The address which will spend the funds.
144    * @return A uint256 specifying the amount of tokens still available for the spender.
145    */
146   function allowance(
147     address owner,
148     address spender
149   )
150   public
151   view
152   returns (uint256)
153   {
154     return _allowed[owner][spender];
155   }
156 
157   /**
158   * @dev Transfer token for a specified address
159   * @param to The address to transfer to.
160   * @param value The amount to be transferred.
161   */
162   function transfer(address to, uint256 value) public returns (bool) {
163     _transfer(msg.sender, to, value);
164     return true;
165   }
166 
167   /**
168    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
169    * Beware that changing an allowance with this method brings the risk that someone may use both the old
170    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
171    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
172    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
173    * @param spender The address which will spend the funds.
174    * @param value The amount of tokens to be spent.
175    */
176   function approve(address spender, uint256 value) public returns (bool) {
177     require(spender != address(0));
178 
179     _allowed[msg.sender][spender] = value;
180     emit Approval(msg.sender, spender, value);
181     return true;
182   }
183 
184   /**
185    * @dev Transfer tokens from one address to another
186    * @param from address The address which you want to send tokens from
187    * @param to address The address which you want to transfer to
188    * @param value uint256 the amount of tokens to be transferred
189    */
190   function transferFrom(
191     address from,
192     address to,
193     uint256 value
194   )
195   public
196   returns (bool)
197   {
198     require(value <= _allowed[from][msg.sender]);
199 
200     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
201     _transfer(from, to, value);
202     return true;
203   }
204 
205   /**
206    * @dev Increase the amount of tokens that an owner allowed to a spender.
207    * approve should be called when allowed_[_spender] == 0. To increment
208    * allowed value is better to use this function to avoid 2 calls (and wait until
209    * the first transaction is mined)
210    * From MonolithDAO Token.sol
211    * @param spender The address which will spend the funds.
212    * @param addedValue The amount of tokens to increase the allowance by.
213    */
214   function increaseAllowance(
215     address spender,
216     uint256 addedValue
217   )
218   public
219   returns (bool)
220   {
221     require(spender != address(0));
222 
223     _allowed[msg.sender][spender] = (
224     _allowed[msg.sender][spender].add(addedValue));
225     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
226     return true;
227   }
228 
229   /**
230    * @dev Decrease the amount of tokens that an owner allowed to a spender.
231    * approve should be called when allowed_[_spender] == 0. To decrement
232    * allowed value is better to use this function to avoid 2 calls (and wait until
233    * the first transaction is mined)
234    * From MonolithDAO Token.sol
235    * @param spender The address which will spend the funds.
236    * @param subtractedValue The amount of tokens to decrease the allowance by.
237    */
238   function decreaseAllowance(
239     address spender,
240     uint256 subtractedValue
241   )
242   public
243   returns (bool)
244   {
245     require(spender != address(0));
246 
247     _allowed[msg.sender][spender] = (
248     _allowed[msg.sender][spender].sub(subtractedValue));
249     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
250     return true;
251   }
252 
253   /**
254   * @dev Transfer token for a specified addresses
255   * @param from The address to transfer from.
256   * @param to The address to transfer to.
257   * @param value The amount to be transferred.
258   */
259   function _transfer(address from, address to, uint256 value) internal {
260     require(value <= _balances[from]);
261     require(to != address(0));
262 
263     _balances[from] = _balances[from].sub(value);
264     _balances[to] = _balances[to].add(value);
265     emit Transfer(from, to, value);
266   }
267 
268   /**
269    * @dev Internal function that mints an amount of the token and assigns it to
270    * an account. This encapsulates the modification of balances such that the
271    * proper events are emitted.
272    * @param account The account that will receive the created tokens.
273    * @param value The amount that will be created.
274    */
275   function _mint(address account, uint256 value) internal {
276     require(account != 0);
277     _totalSupply = _totalSupply.add(value);
278     _balances[account] = _balances[account].add(value);
279     emit Transfer(address(0), account, value);
280   }
281 
282   /**
283    * @dev Internal function that burns an amount of the token of a given
284    * account.
285    * @param account The account whose tokens will be burnt.
286    * @param value The amount that will be burnt.
287    */
288   function _burn(address account, uint256 value) internal {
289     require(account != 0);
290     require(value <= _balances[account]);
291 
292     _totalSupply = _totalSupply.sub(value);
293     _balances[account] = _balances[account].sub(value);
294     emit Transfer(account, address(0), value);
295   }
296 
297   /**
298    * @dev Internal function that burns an amount of the token of a given
299    * account, deducting from the sender's allowance for said account. Uses the
300    * internal burn function.
301    * @param account The account whose tokens will be burnt.
302    * @param value The amount that will be burnt.
303    */
304   function _burnFrom(address account, uint256 value) internal {
305     require(value <= _allowed[account][msg.sender]);
306 
307     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
308     // this function needs to emit an event with the updated approval.
309     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
310       value);
311     _burn(account, value);
312   }
313 }
314 
315 
316 /**
317  * @title Roles
318  * @dev Library for managing addresses assigned to a Role.
319  */
320 library Roles {
321   struct Role {
322     mapping (address => bool) bearer;
323   }
324 
325   /**
326    * @dev give an account access to this role
327    */
328   function add(Role storage role, address account) internal {
329     require(account != address(0));
330     role.bearer[account] = true;
331   }
332 
333   /**
334    * @dev remove an account's access to this role
335    */
336   function remove(Role storage role, address account) internal {
337     require(account != address(0));
338     role.bearer[account] = false;
339   }
340 
341   /**
342    * @dev check if an account has this role
343    * @return bool
344    */
345   function has(Role storage role, address account)
346   internal
347   view
348   returns (bool)
349   {
350     require(account != address(0));
351     return role.bearer[account];
352   }
353 }
354 
355 
356 contract MinterRole {
357   using Roles for Roles.Role;
358 
359   event MinterAdded(address indexed account);
360   event MinterRemoved(address indexed account);
361 
362   Roles.Role private minters;
363 
364   constructor() public {
365     _addMinter(msg.sender);
366   }
367 
368   modifier onlyMinter() {
369     require(isMinter(msg.sender));
370     _;
371   }
372 
373   function isMinter(address account) public view returns (bool) {
374     return minters.has(account);
375   }
376 
377   function addMinter(address account) public onlyMinter {
378     _addMinter(account);
379   }
380 
381   function renounceMinter() public {
382     _removeMinter(msg.sender);
383   }
384 
385   function _addMinter(address account) internal {
386     minters.add(account);
387     emit MinterAdded(account);
388   }
389 
390   function _removeMinter(address account) internal {
391     minters.remove(account);
392     emit MinterRemoved(account);
393   }
394 }
395 
396 
397 /**
398  * @title ERC20Mintable
399  * @dev ERC20 minting logic
400  */
401 contract ERC20Mintable is ERC20, MinterRole {
402   /**
403    * @dev Function to mint tokens
404    * @param to The address that will receive the minted tokens.
405    * @param value The amount of tokens to mint.
406    * @return A boolean that indicates if the operation was successful.
407    */
408   function mint(
409     address to,
410     uint256 value
411   )
412   public
413   onlyMinter
414   returns (bool)
415   {
416     _mint(to, value);
417     return true;
418   }
419 }
420 
421 
422 /**
423  * @title Burnable Token
424  * @dev Token that can be irreversibly burned (destroyed).
425  */
426 contract ERC20Burnable is ERC20 {
427 
428   /**
429    * @dev Burns a specific amount of tokens.
430    * @param value The amount of token to be burned.
431    */
432   function burn(uint256 value) public {
433     _burn(msg.sender, value);
434   }
435 
436   /**
437    * @dev Burns a specific amount of tokens from the target address and decrements allowance
438    * @param from address The address which you want to send tokens from
439    * @param value uint256 The amount of token to be burned
440    */
441   function burnFrom(address from, uint256 value) public {
442     _burnFrom(from, value);
443   }
444 }
445 
446 
447 
448 /**
449  * @title SimpleToken
450  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
451  * Note they can later distribute these tokens as they wish using `transfer` and other
452  * `ERC20` functions.
453  */
454 contract PANVIS is ERC20Burnable, ERC20Mintable {
455 
456   string public constant name = "PANVIS";
457   string public constant symbol = "PAN";
458   uint8 public constant decimals = 18;
459 
460   uint256 public constant INITIAL_SUPPLY = 100000000 * (10 ** uint256(decimals));
461 
462   /**
463    * @dev Constructor that gives msg.sender all of existing tokens.
464    */
465   constructor(address _owner) public {
466     _mint(_owner, INITIAL_SUPPLY);
467   }
468 
469 }