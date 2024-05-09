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
36 /**
37  * @title Roles
38  * @dev Library for managing addresses assigned to a Role.
39  */
40 library Roles {
41   struct Role {
42     mapping (address => bool) bearer;
43   }
44 
45   /**
46    * @dev give an account access to this role
47    */
48   function add(Role storage role, address account) internal {
49     require(account != address(0));
50     require(!has(role, account));
51 
52     role.bearer[account] = true;
53   }
54 
55   /**
56    * @dev remove an account's access to this role
57    */
58   function remove(Role storage role, address account) internal {
59     require(account != address(0));
60     require(has(role, account));
61 
62     role.bearer[account] = false;
63   }
64 
65   /**
66    * @dev check if an account has this role
67    * @return bool
68    */
69   function has(Role storage role, address account)
70     internal
71     view
72     returns (bool)
73   {
74     require(account != address(0));
75     return role.bearer[account];
76   }
77 }
78 
79 contract MinterRole {
80   using Roles for Roles.Role;
81 
82   event MinterAdded(address indexed account);
83   event MinterRemoved(address indexed account);
84 
85   Roles.Role private minters;
86 
87   constructor() internal {
88     _addMinter(msg.sender);
89   }
90 
91   modifier onlyMinter() {
92     require(isMinter(msg.sender));
93     _;
94   }
95 
96   function isMinter(address account) public view returns (bool) {
97     return minters.has(account);
98   }
99 
100   function addMinter(address account) public onlyMinter {
101     _addMinter(account);
102   }
103 
104   function renounceMinter() public {
105     _removeMinter(msg.sender);
106   }
107 
108   function _addMinter(address account) internal {
109     minters.add(account);
110     emit MinterAdded(account);
111   }
112 
113   function _removeMinter(address account) internal {
114     minters.remove(account);
115     emit MinterRemoved(account);
116   }
117 }
118 
119 /**
120  * @title SafeMath
121  * @dev Math operations with safety checks that revert on error
122  */
123 library SafeMath {
124 
125   /**
126   * @dev Multiplies two numbers, reverts on overflow.
127   */
128   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
129     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
130     // benefit is lost if 'b' is also tested.
131     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
132     if (a == 0) {
133       return 0;
134     }
135 
136     uint256 c = a * b;
137     require(c / a == b);
138 
139     return c;
140   }
141 
142   /**
143   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
144   */
145   function div(uint256 a, uint256 b) internal pure returns (uint256) {
146     require(b > 0); // Solidity only automatically asserts when dividing by 0
147     uint256 c = a / b;
148     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
149 
150     return c;
151   }
152 
153   /**
154   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
155   */
156   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
157     require(b <= a);
158     uint256 c = a - b;
159 
160     return c;
161   }
162 
163   /**
164   * @dev Adds two numbers, reverts on overflow.
165   */
166   function add(uint256 a, uint256 b) internal pure returns (uint256) {
167     uint256 c = a + b;
168     require(c >= a);
169 
170     return c;
171   }
172 
173   /**
174   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
175   * reverts when dividing by zero.
176   */
177   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
178     require(b != 0);
179     return a % b;
180   }
181 }
182 
183 /**
184  * @title Standard ERC20 token
185  *
186  * @dev Implementation of the basic standard token.
187  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
188  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
189  */
190 contract ERC20 is IERC20 {
191   using SafeMath for uint256;
192 
193   mapping (address => uint256) private _balances;
194 
195   mapping (address => mapping (address => uint256)) private _allowed;
196 
197   uint256 private _totalSupply;
198 
199   /**
200   * @dev Total number of tokens in existence
201   */
202   function totalSupply() public view returns (uint256) {
203     return _totalSupply;
204   }
205 
206   /**
207   * @dev Gets the balance of the specified address.
208   * @param owner The address to query the balance of.
209   * @return An uint256 representing the amount owned by the passed address.
210   */
211   function balanceOf(address owner) public view returns (uint256) {
212     return _balances[owner];
213   }
214 
215   /**
216    * @dev Function to check the amount of tokens that an owner allowed to a spender.
217    * @param owner address The address which owns the funds.
218    * @param spender address The address which will spend the funds.
219    * @return A uint256 specifying the amount of tokens still available for the spender.
220    */
221   function allowance(
222     address owner,
223     address spender
224    )
225     public
226     view
227     returns (uint256)
228   {
229     return _allowed[owner][spender];
230   }
231 
232   /**
233   * @dev Transfer token for a specified address
234   * @param to The address to transfer to.
235   * @param value The amount to be transferred.
236   */
237   function transfer(address to, uint256 value) public returns (bool) {
238     _transfer(msg.sender, to, value);
239     return true;
240   }
241 
242   /**
243    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
244    * Beware that changing an allowance with this method brings the risk that someone may use both the old
245    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
246    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
247    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
248    * @param spender The address which will spend the funds.
249    * @param value The amount of tokens to be spent.
250    */
251   function approve(address spender, uint256 value) public returns (bool) {
252     require(spender != address(0));
253 
254     _allowed[msg.sender][spender] = value;
255     emit Approval(msg.sender, spender, value);
256     return true;
257   }
258 
259   /**
260    * @dev Transfer tokens from one address to another
261    * @param from address The address which you want to send tokens from
262    * @param to address The address which you want to transfer to
263    * @param value uint256 the amount of tokens to be transferred
264    */
265   function transferFrom(
266     address from,
267     address to,
268     uint256 value
269   )
270     public
271     returns (bool)
272   {
273     require(value <= _allowed[from][msg.sender]);
274 
275     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
276     _transfer(from, to, value);
277     return true;
278   }
279 
280   /**
281    * @dev Increase the amount of tokens that an owner allowed to a spender.
282    * approve should be called when allowed_[_spender] == 0. To increment
283    * allowed value is better to use this function to avoid 2 calls (and wait until
284    * the first transaction is mined)
285    * From MonolithDAO Token.sol
286    * @param spender The address which will spend the funds.
287    * @param addedValue The amount of tokens to increase the allowance by.
288    */
289   function increaseAllowance(
290     address spender,
291     uint256 addedValue
292   )
293     public
294     returns (bool)
295   {
296     require(spender != address(0));
297 
298     _allowed[msg.sender][spender] = (
299       _allowed[msg.sender][spender].add(addedValue));
300     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
301     return true;
302   }
303 
304   /**
305    * @dev Decrease the amount of tokens that an owner allowed to a spender.
306    * approve should be called when allowed_[_spender] == 0. To decrement
307    * allowed value is better to use this function to avoid 2 calls (and wait until
308    * the first transaction is mined)
309    * From MonolithDAO Token.sol
310    * @param spender The address which will spend the funds.
311    * @param subtractedValue The amount of tokens to decrease the allowance by.
312    */
313   function decreaseAllowance(
314     address spender,
315     uint256 subtractedValue
316   )
317     public
318     returns (bool)
319   {
320     require(spender != address(0));
321 
322     _allowed[msg.sender][spender] = (
323       _allowed[msg.sender][spender].sub(subtractedValue));
324     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
325     return true;
326   }
327 
328   /**
329   * @dev Transfer token for a specified addresses
330   * @param from The address to transfer from.
331   * @param to The address to transfer to.
332   * @param value The amount to be transferred.
333   */
334   function _transfer(address from, address to, uint256 value) internal {
335     require(value <= _balances[from]);
336     require(to != address(0));
337 
338     _balances[from] = _balances[from].sub(value);
339     _balances[to] = _balances[to].add(value);
340     emit Transfer(from, to, value);
341   }
342 
343   /**
344    * @dev Internal function that mints an amount of the token and assigns it to
345    * an account. This encapsulates the modification of balances such that the
346    * proper events are emitted.
347    * @param account The account that will receive the created tokens.
348    * @param value The amount that will be created.
349    */
350   function _mint(address account, uint256 value) internal {
351     require(account != 0);
352     _totalSupply = _totalSupply.add(value);
353     _balances[account] = _balances[account].add(value);
354     emit Transfer(address(0), account, value);
355   }
356 
357   /**
358    * @dev Internal function that burns an amount of the token of a given
359    * account.
360    * @param account The account whose tokens will be burnt.
361    * @param value The amount that will be burnt.
362    */
363   function _burn(address account, uint256 value) internal {
364     require(account != 0);
365     require(value <= _balances[account]);
366 
367     _totalSupply = _totalSupply.sub(value);
368     _balances[account] = _balances[account].sub(value);
369     emit Transfer(account, address(0), value);
370   }
371 
372   /**
373    * @dev Internal function that burns an amount of the token of a given
374    * account, deducting from the sender's allowance for said account. Uses the
375    * internal burn function.
376    * @param account The account whose tokens will be burnt.
377    * @param value The amount that will be burnt.
378    */
379   function _burnFrom(address account, uint256 value) internal {
380     require(value <= _allowed[account][msg.sender]);
381 
382     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
383     // this function needs to emit an event with the updated approval.
384     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
385       value);
386     _burn(account, value);
387   }
388 }
389 
390 /**
391  * @title ERC20Detailed token
392  * @dev The decimals are only for visualization purposes.
393  * All the operations are done using the smallest and indivisible token unit,
394  * just as on Ethereum all the operations are done in wei.
395  */
396 contract ERC20Detailed is IERC20 {
397   string private _name;
398   string private _symbol;
399   uint8 private _decimals;
400 
401   constructor(string name, string symbol, uint8 decimals) public {
402     _name = name;
403     _symbol = symbol;
404     _decimals = decimals;
405   }
406 
407   /**
408    * @return the name of the token.
409    */
410   function name() public view returns(string) {
411     return _name;
412   }
413 
414   /**
415    * @return the symbol of the token.
416    */
417   function symbol() public view returns(string) {
418     return _symbol;
419   }
420 
421   /**
422    * @return the number of decimals of the token.
423    */
424   function decimals() public view returns(uint8) {
425     return _decimals;
426   }
427 }
428 
429 /**
430  * @title ERC20Mintable
431  * @dev ERC20 minting logic
432  */
433 contract ERC20Mintable is ERC20, MinterRole {
434   /**
435    * @dev Function to mint tokens
436    * @param to The address that will receive the minted tokens.
437    * @param value The amount of tokens to mint.
438    * @return A boolean that indicates if the operation was successful.
439    */
440   function mint(
441     address to,
442     uint256 value
443   )
444     public
445     onlyMinter
446     returns (bool)
447   {
448     _mint(to, value);
449     return true;
450   }
451 }
452 
453 contract Gold is ERC20, ERC20Detailed, ERC20Mintable {
454     constructor(
455         string name,
456         string symbol,
457         uint8 decimals,
458         uint256 initialSupply
459     )
460         ERC20Mintable()
461         ERC20Detailed(name, symbol, decimals)
462         ERC20()
463         public
464     {
465         _mint(msg.sender, initialSupply);
466     }
467 }