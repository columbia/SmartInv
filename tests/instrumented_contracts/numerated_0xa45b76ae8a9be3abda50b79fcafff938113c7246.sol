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
89   event Transfer(
90     address indexed from,
91     address indexed to,
92     uint256 value
93   );
94 
95   event Approval(
96     address indexed owner,
97     address indexed spender,
98     uint256 value
99   );
100 }
101 
102 
103 
104 /**
105  * @title Standard ERC20 token
106  *
107  * @dev Implementation of the basic standard token.
108  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
109  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
110  */
111 contract ERC20 is IERC20 {
112   using SafeMath for uint256;
113 
114   mapping (address => uint256) private _balances;
115 
116   mapping (address => mapping (address => uint256)) private _allowed;
117 
118   uint256 private _totalSupply;
119 
120   /**
121   * @dev Total number of tokens in existence
122   */
123   function totalSupply() public view returns (uint256) {
124     return _totalSupply;
125   }
126 
127   /**
128   * @dev Gets the balance of the specified address.
129   * @param owner The address to query the balance of.
130   * @return An uint256 representing the amount owned by the passed address.
131   */
132   function balanceOf(address owner) public view returns (uint256) {
133     return _balances[owner];
134   }
135 
136   /**
137    * @dev Function to check the amount of tokens that an owner allowed to a spender.
138    * @param owner address The address which owns the funds.
139    * @param spender address The address which will spend the funds.
140    * @return A uint256 specifying the amount of tokens still available for the spender.
141    */
142   function allowance(
143     address owner,
144     address spender
145   )
146   public
147   view
148   returns (uint256)
149   {
150     return _allowed[owner][spender];
151   }
152 
153   /**
154   * @dev Transfer token for a specified address
155   * @param to The address to transfer to.
156   * @param value The amount to be transferred.
157   */
158   function transfer(address to, uint256 value) public returns (bool) {
159     _transfer(msg.sender, to, value);
160     return true;
161   }
162 
163   /**
164    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
165    * Beware that changing an allowance with this method brings the risk that someone may use both the old
166    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
167    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
168    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
169    * @param spender The address which will spend the funds.
170    * @param value The amount of tokens to be spent.
171    */
172   function approve(address spender, uint256 value) public returns (bool) {
173     require(spender != address(0));
174 
175     _allowed[msg.sender][spender] = value;
176     emit Approval(msg.sender, spender, value);
177     return true;
178   }
179 
180   /**
181    * @dev Transfer tokens from one address to another
182    * @param from address The address which you want to send tokens from
183    * @param to address The address which you want to transfer to
184    * @param value uint256 the amount of tokens to be transferred
185    */
186   function transferFrom(
187     address from,
188     address to,
189     uint256 value
190   )
191   public
192   returns (bool)
193   {
194     require(value <= _allowed[from][msg.sender]);
195 
196     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
197     _transfer(from, to, value);
198     return true;
199   }
200 
201   /**
202    * @dev Increase the amount of tokens that an owner allowed to a spender.
203    * approve should be called when allowed_[_spender] == 0. To increment
204    * allowed value is better to use this function to avoid 2 calls (and wait until
205    * the first transaction is mined)
206    * From MonolithDAO Token.sol
207    * @param spender The address which will spend the funds.
208    * @param addedValue The amount of tokens to increase the allowance by.
209    */
210   function increaseAllowance(
211     address spender,
212     uint256 addedValue
213   )
214   public
215   returns (bool)
216   {
217     require(spender != address(0));
218 
219     _allowed[msg.sender][spender] = (
220     _allowed[msg.sender][spender].add(addedValue));
221     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
222     return true;
223   }
224 
225   /**
226    * @dev Decrease the amount of tokens that an owner allowed to a spender.
227    * approve should be called when allowed_[_spender] == 0. To decrement
228    * allowed value is better to use this function to avoid 2 calls (and wait until
229    * the first transaction is mined)
230    * From MonolithDAO Token.sol
231    * @param spender The address which will spend the funds.
232    * @param subtractedValue The amount of tokens to decrease the allowance by.
233    */
234   function decreaseAllowance(
235     address spender,
236     uint256 subtractedValue
237   )
238   public
239   returns (bool)
240   {
241     require(spender != address(0));
242 
243     _allowed[msg.sender][spender] = (
244     _allowed[msg.sender][spender].sub(subtractedValue));
245     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
246     return true;
247   }
248 
249   /**
250   * @dev Transfer token for a specified addresses
251   * @param from The address to transfer from.
252   * @param to The address to transfer to.
253   * @param value The amount to be transferred.
254   */
255   function _transfer(address from, address to, uint256 value) internal {
256     require(value <= _balances[from]);
257     require(to != address(0));
258 
259     _balances[from] = _balances[from].sub(value);
260     _balances[to] = _balances[to].add(value);
261     emit Transfer(from, to, value);
262   }
263 
264   /**
265    * @dev Internal function that mints an amount of the token and assigns it to
266    * an account. This encapsulates the modification of balances such that the
267    * proper events are emitted.
268    * @param account The account that will receive the created tokens.
269    * @param value The amount that will be created.
270    */
271   function _mint(address account, uint256 value) internal {
272     require(account != 0);
273     _totalSupply = _totalSupply.add(value);
274     _balances[account] = _balances[account].add(value);
275     emit Transfer(address(0), account, value);
276   }
277 
278   /**
279    * @dev Internal function that burns an amount of the token of a given
280    * account.
281    * @param account The account whose tokens will be burnt.
282    * @param value The amount that will be burnt.
283    */
284   function _burn(address account, uint256 value) internal {
285     require(account != 0);
286     require(value <= _balances[account]);
287 
288     _totalSupply = _totalSupply.sub(value);
289     _balances[account] = _balances[account].sub(value);
290     emit Transfer(account, address(0), value);
291   }
292 
293   /**
294    * @dev Internal function that burns an amount of the token of a given
295    * account, deducting from the sender's allowance for said account. Uses the
296    * internal burn function.
297    * @param account The account whose tokens will be burnt.
298    * @param value The amount that will be burnt.
299    */
300   function _burnFrom(address account, uint256 value) internal {
301     require(value <= _allowed[account][msg.sender]);
302 
303     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
304     // this function needs to emit an event with the updated approval.
305     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
306       value);
307     _burn(account, value);
308   }
309 }
310 
311 
312 /**
313  * @title Roles
314  * @dev Library for managing addresses assigned to a Role.
315  */
316 library Roles {
317   struct Role {
318     mapping (address => bool) bearer;
319   }
320 
321   /**
322    * @dev give an account access to this role
323    */
324   function add(Role storage role, address account) internal {
325     require(account != address(0));
326     role.bearer[account] = true;
327   }
328 
329   /**
330    * @dev remove an account's access to this role
331    */
332   function remove(Role storage role, address account) internal {
333     require(account != address(0));
334     role.bearer[account] = false;
335   }
336 
337   /**
338    * @dev check if an account has this role
339    * @return bool
340    */
341   function has(Role storage role, address account)
342   internal
343   view
344   returns (bool)
345   {
346     require(account != address(0));
347     return role.bearer[account];
348   }
349 }
350 
351 
352 contract MinterRole {
353   using Roles for Roles.Role;
354 
355   event MinterAdded(address indexed account);
356   event MinterRemoved(address indexed account);
357 
358   Roles.Role private minters;
359 
360   constructor() public {
361     _addMinter(msg.sender);
362   }
363 
364   modifier onlyMinter() {
365     require(isMinter(msg.sender));
366     _;
367   }
368 
369   function isMinter(address account) public view returns (bool) {
370     return minters.has(account);
371   }
372 
373   function addMinter(address account) public onlyMinter {
374     _addMinter(account);
375   }
376 
377   function renounceMinter() public {
378     _removeMinter(msg.sender);
379   }
380 
381   function _addMinter(address account) internal {
382     minters.add(account);
383     emit MinterAdded(account);
384   }
385 
386   function _removeMinter(address account) internal {
387     minters.remove(account);
388     emit MinterRemoved(account);
389   }
390 }
391 
392 
393 /**
394  * @title ERC20Mintable
395  * @dev ERC20 minting logic
396  */
397 contract ERC20Mintable is ERC20, MinterRole {
398   /**
399    * @dev Function to mint tokens
400    * @param to The address that will receive the minted tokens.
401    * @param value The amount of tokens to mint.
402    * @return A boolean that indicates if the operation was successful.
403    */
404   function mint(
405     address to,
406     uint256 value
407   )
408   public
409   onlyMinter
410   returns (bool)
411   {
412     _mint(to, value);
413     return true;
414   }
415 }
416 
417 
418 /**
419  * @title Burnable Token
420  * @dev Token that can be irreversibly burned (destroyed).
421  */
422 contract ERC20Burnable is ERC20 {
423 
424   /**
425    * @dev Burns a specific amount of tokens.
426    * @param value The amount of token to be burned.
427    */
428   function burn(uint256 value) public {
429     _burn(msg.sender, value);
430   }
431 
432   /**
433    * @dev Burns a specific amount of tokens from the target address and decrements allowance
434    * @param from address The address which you want to send tokens from
435    * @param value uint256 The amount of token to be burned
436    */
437   function burnFrom(address from, uint256 value) public {
438     _burnFrom(from, value);
439   }
440 }
441 
442 
443 
444 /**
445  * @title SimpleToken
446  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
447  * Note they can later distribute these tokens as they wish using `transfer` and other
448  * `ERC20` functions.
449  */
450 contract TgkGoldCoin is ERC20Burnable, ERC20Mintable {
451 
452   string public constant name = "TGK Gold Coin";
453   string public constant symbol = "TGK";
454   uint8 public constant decimals = 18;
455 
456   uint256 public constant INITIAL_SUPPLY = 3000000000 * (10 ** uint256(decimals));
457 
458   /**
459    * @dev Constructor that gives msg.sender all of existing tokens.
460    */
461   constructor(address _owner) public {
462     _mint(_owner, INITIAL_SUPPLY);
463   }
464 
465 }