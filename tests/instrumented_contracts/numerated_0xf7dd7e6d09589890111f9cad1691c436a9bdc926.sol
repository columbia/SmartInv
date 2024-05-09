1 /**
2  *Submitted for verification at Etherscan.io on 2019-08-05
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2019-05-03
7 */
8 
9 pragma solidity ^0.4.24;
10 
11 /**
12  * @title SafeMath
13  * @dev Math operations with safety checks that revert on error
14  */
15 library SafeMath {
16 
17   /**
18   * @dev Multiplies two numbers, reverts on overflow.
19   */
20   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
21     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
22     // benefit is lost if 'b' is also tested.
23     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
24     if (a == 0) {
25       return 0;
26     }
27 
28     uint256 c = a * b;
29     require(c / a == b);
30 
31     return c;
32   }
33 
34   /**
35   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
36   */
37   function div(uint256 a, uint256 b) internal pure returns (uint256) {
38     require(b > 0); // Solidity only automatically asserts when dividing by 0
39     uint256 c = a / b;
40     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
41 
42     return c;
43   }
44 
45   /**
46   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
47   */
48   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49     require(b <= a);
50     uint256 c = a - b;
51 
52     return c;
53   }
54 
55   /**
56   * @dev Adds two numbers, reverts on overflow.
57   */
58   function add(uint256 a, uint256 b) internal pure returns (uint256) {
59     uint256 c = a + b;
60     require(c >= a);
61 
62     return c;
63   }
64 
65   /**
66   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
67   * reverts when dividing by zero.
68   */
69   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
70     require(b != 0);
71     return a % b;
72   }
73 }
74 
75 
76 
77 /**
78  * @title ERC20 interface
79  * @dev see https://github.com/ethereum/EIPs/issues/20
80  */
81 interface IERC20 {
82   function totalSupply() external view returns (uint256);
83 
84   function balanceOf(address who) external view returns (uint256);
85 
86   function allowance(address owner, address spender)
87   external view returns (uint256);
88 
89   function transfer(address to, uint256 value) external returns (bool);
90 
91   function approve(address spender, uint256 value)
92   external returns (bool);
93 
94   function transferFrom(address from, address to, uint256 value)
95   external returns (bool);
96 
97   event Transfer(
98     address indexed from,
99     address indexed to,
100     uint256 value
101   );
102 
103   event Approval(
104     address indexed owner,
105     address indexed spender,
106     uint256 value
107   );
108 }
109 
110 
111 
112 /**
113  * @title Standard ERC20 token
114  *
115  * @dev Implementation of the basic standard token.
116  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
117  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
118  */
119 contract ERC20 is IERC20 {
120   using SafeMath for uint256;
121 
122   mapping (address => uint256) private _balances;
123 
124   mapping (address => mapping (address => uint256)) private _allowed;
125 
126   uint256 private _totalSupply;
127 
128   /**
129   * @dev Total number of tokens in existence
130   */
131   function totalSupply() public view returns (uint256) {
132     return _totalSupply;
133   }
134 
135   /**
136   * @dev Gets the balance of the specified address.
137   * @param owner The address to query the balance of.
138   * @return An uint256 representing the amount owned by the passed address.
139   */
140   function balanceOf(address owner) public view returns (uint256) {
141     return _balances[owner];
142   }
143 
144   /**
145    * @dev Function to check the amount of tokens that an owner allowed to a spender.
146    * @param owner address The address which owns the funds.
147    * @param spender address The address which will spend the funds.
148    * @return A uint256 specifying the amount of tokens still available for the spender.
149    */
150   function allowance(
151     address owner,
152     address spender
153   )
154   public
155   view
156   returns (uint256)
157   {
158     return _allowed[owner][spender];
159   }
160 
161   /**
162   * @dev Transfer token for a specified address
163   * @param to The address to transfer to.
164   * @param value The amount to be transferred.
165   */
166   function transfer(address to, uint256 value) public returns (bool) {
167     _transfer(msg.sender, to, value);
168     return true;
169   }
170 
171   /**
172    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
173    * Beware that changing an allowance with this method brings the risk that someone may use both the old
174    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
175    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
176    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
177    * @param spender The address which will spend the funds.
178    * @param value The amount of tokens to be spent.
179    */
180   function approve(address spender, uint256 value) public returns (bool) {
181     require(spender != address(0));
182 
183     _allowed[msg.sender][spender] = value;
184     emit Approval(msg.sender, spender, value);
185     return true;
186   }
187 
188   /**
189    * @dev Transfer tokens from one address to another
190    * @param from address The address which you want to send tokens from
191    * @param to address The address which you want to transfer to
192    * @param value uint256 the amount of tokens to be transferred
193    */
194   function transferFrom(
195     address from,
196     address to,
197     uint256 value
198   )
199   public
200   returns (bool)
201   {
202     require(value <= _allowed[from][msg.sender]);
203 
204     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
205     _transfer(from, to, value);
206     return true;
207   }
208 
209   /**
210    * @dev Increase the amount of tokens that an owner allowed to a spender.
211    * approve should be called when allowed_[_spender] == 0. To increment
212    * allowed value is better to use this function to avoid 2 calls (and wait until
213    * the first transaction is mined)
214    * From MonolithDAO Token.sol
215    * @param spender The address which will spend the funds.
216    * @param addedValue The amount of tokens to increase the allowance by.
217    */
218   function increaseAllowance(
219     address spender,
220     uint256 addedValue
221   )
222   public
223   returns (bool)
224   {
225     require(spender != address(0));
226 
227     _allowed[msg.sender][spender] = (
228     _allowed[msg.sender][spender].add(addedValue));
229     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
230     return true;
231   }
232 
233   /**
234    * @dev Decrease the amount of tokens that an owner allowed to a spender.
235    * approve should be called when allowed_[_spender] == 0. To decrement
236    * allowed value is better to use this function to avoid 2 calls (and wait until
237    * the first transaction is mined)
238    * From MonolithDAO Token.sol
239    * @param spender The address which will spend the funds.
240    * @param subtractedValue The amount of tokens to decrease the allowance by.
241    */
242   function decreaseAllowance(
243     address spender,
244     uint256 subtractedValue
245   )
246   public
247   returns (bool)
248   {
249     require(spender != address(0));
250 
251     _allowed[msg.sender][spender] = (
252     _allowed[msg.sender][spender].sub(subtractedValue));
253     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
254     return true;
255   }
256 
257   /**
258   * @dev Transfer token for a specified addresses
259   * @param from The address to transfer from.
260   * @param to The address to transfer to.
261   * @param value The amount to be transferred.
262   */
263   function _transfer(address from, address to, uint256 value) internal {
264     require(value <= _balances[from]);
265     require(to != address(0));
266 
267     _balances[from] = _balances[from].sub(value);
268     _balances[to] = _balances[to].add(value);
269     emit Transfer(from, to, value);
270   }
271 
272   /**
273    * @dev Internal function that mints an amount of the token and assigns it to
274    * an account. This encapsulates the modification of balances such that the
275    * proper events are emitted.
276    * @param account The account that will receive the created tokens.
277    * @param value The amount that will be created.
278    */
279   function _mint(address account, uint256 value) internal {
280     require(account != 0);
281     _totalSupply = _totalSupply.add(value);
282     _balances[account] = _balances[account].add(value);
283     emit Transfer(address(0), account, value);
284   }
285 
286   /**
287    * @dev Internal function that burns an amount of the token of a given
288    * account.
289    * @param account The account whose tokens will be burnt.
290    * @param value The amount that will be burnt.
291    */
292   function _burn(address account, uint256 value) internal {
293     require(account != 0);
294     require(value <= _balances[account]);
295 
296     _totalSupply = _totalSupply.sub(value);
297     _balances[account] = _balances[account].sub(value);
298     emit Transfer(account, address(0), value);
299   }
300 
301   /**
302    * @dev Internal function that burns an amount of the token of a given
303    * account, deducting from the sender's allowance for said account. Uses the
304    * internal burn function.
305    * @param account The account whose tokens will be burnt.
306    * @param value The amount that will be burnt.
307    */
308   function _burnFrom(address account, uint256 value) internal {
309     require(value <= _allowed[account][msg.sender]);
310 
311     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
312     // this function needs to emit an event with the updated approval.
313     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
314       value);
315     _burn(account, value);
316   }
317 }
318 
319 
320 /**
321  * @title Roles
322  * @dev Library for managing addresses assigned to a Role.
323  */
324 library Roles {
325   struct Role {
326     mapping (address => bool) bearer;
327   }
328 
329   /**
330    * @dev give an account access to this role
331    */
332   function add(Role storage role, address account) internal {
333     require(account != address(0));
334     role.bearer[account] = true;
335   }
336 
337   /**
338    * @dev remove an account's access to this role
339    */
340   function remove(Role storage role, address account) internal {
341     require(account != address(0));
342     role.bearer[account] = false;
343   }
344 
345   /**
346    * @dev check if an account has this role
347    * @return bool
348    */
349   function has(Role storage role, address account)
350   internal
351   view
352   returns (bool)
353   {
354     require(account != address(0));
355     return role.bearer[account];
356   }
357 }
358 
359 
360 contract MinterRole {
361   using Roles for Roles.Role;
362 
363   event MinterAdded(address indexed account);
364   event MinterRemoved(address indexed account);
365 
366   Roles.Role private minters;
367 
368   constructor() public {
369     _addMinter(msg.sender);
370   }
371 
372   modifier onlyMinter() {
373     require(isMinter(msg.sender));
374     _;
375   }
376 
377   function isMinter(address account) public view returns (bool) {
378     return minters.has(account);
379   }
380 
381   function addMinter(address account) public onlyMinter {
382     _addMinter(account);
383   }
384 
385   function renounceMinter() public {
386     _removeMinter(msg.sender);
387   }
388 
389   function _addMinter(address account) internal {
390     minters.add(account);
391     emit MinterAdded(account);
392   }
393 
394   function _removeMinter(address account) internal {
395     minters.remove(account);
396     emit MinterRemoved(account);
397   }
398 }
399 
400 
401 /**
402  * @title ERC20Mintable
403  * @dev ERC20 minting logic
404  */
405 contract ERC20Mintable is ERC20, MinterRole {
406   /**
407    * @dev Function to mint tokens
408    * @param to The address that will receive the minted tokens.
409    * @param value The amount of tokens to mint.
410    * @return A boolean that indicates if the operation was successful.
411    */
412   function mint(
413     address to,
414     uint256 value
415   )
416   public
417   onlyMinter
418   returns (bool)
419   {
420     _mint(to, value);
421     return true;
422   }
423 }
424 
425 
426 /**
427  * @title Burnable Token
428  * @dev Token that can be irreversibly burned (destroyed).
429  */
430 contract ERC20Burnable is ERC20 {
431 
432   /**
433    * @dev Burns a specific amount of tokens.
434    * @param value The amount of token to be burned.
435    */
436   function burn(uint256 value) public {
437     _burn(msg.sender, value);
438   }
439 
440   /**
441    * @dev Burns a specific amount of tokens from the target address and decrements allowance
442    * @param from address The address which you want to send tokens from
443    * @param value uint256 The amount of token to be burned
444    */
445   function burnFrom(address from, uint256 value) public {
446     _burnFrom(from, value);
447   }
448 }
449 
450 
451 
452 /**
453  * @title SimpleToken
454  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
455  * Note they can later distribute these tokens as they wish using `transfer` and other
456  * `ERC20` functions.
457  */
458 contract HupayX is ERC20Burnable, ERC20Mintable {
459 
460   string public constant name = "HUPAYX";
461   string public constant symbol = "HUP";
462   uint8 public constant decimals = 18;
463 
464   uint256 public constant INITIAL_SUPPLY = 10000000000 * (10 ** uint256(decimals));
465 
466   /**
467    * @dev Constructor that gives msg.sender all of existing tokens.
468    */
469   constructor(address _owner) public {
470     _mint(_owner, INITIAL_SUPPLY);
471   }
472 
473 }