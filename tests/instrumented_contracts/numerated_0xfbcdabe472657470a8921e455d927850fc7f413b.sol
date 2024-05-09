1 pragma solidity ^0.4.24;
2 
3 /*
4   TEST token for tokensubscription.com & wyowaste.com
5  */
6 
7 
8 
9 
10 
11 /**
12  * @title ERC20 interface
13  * @dev see https://github.com/ethereum/EIPs/issues/20
14  */
15 interface IERC20 {
16   function totalSupply() external view returns (uint256);
17 
18   function balanceOf(address who) external view returns (uint256);
19 
20   function allowance(address owner, address spender)
21     external view returns (uint256);
22 
23   function transfer(address to, uint256 value) external returns (bool);
24 
25   function approve(address spender, uint256 value)
26     external returns (bool);
27 
28   function transferFrom(address from, address to, uint256 value)
29     external returns (bool);
30 
31   event Transfer(
32     address indexed from,
33     address indexed to,
34     uint256 value
35   );
36 
37   event Approval(
38     address indexed owner,
39     address indexed spender,
40     uint256 value
41   );
42 }
43 
44 
45 
46 /**
47  * @title SafeMath
48  * @dev Math operations with safety checks that revert on error
49  */
50 library SafeMath {
51 
52   /**
53   * @dev Multiplies two numbers, reverts on overflow.
54   */
55   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
56     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
57     // benefit is lost if 'b' is also tested.
58     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
59     if (a == 0) {
60       return 0;
61     }
62 
63     uint256 c = a * b;
64     require(c / a == b);
65 
66     return c;
67   }
68 
69   /**
70   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
71   */
72   function div(uint256 a, uint256 b) internal pure returns (uint256) {
73     require(b > 0); // Solidity only automatically asserts when dividing by 0
74     uint256 c = a / b;
75     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
76 
77     return c;
78   }
79 
80   /**
81   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
82   */
83   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
84     require(b <= a);
85     uint256 c = a - b;
86 
87     return c;
88   }
89 
90   /**
91   * @dev Adds two numbers, reverts on overflow.
92   */
93   function add(uint256 a, uint256 b) internal pure returns (uint256) {
94     uint256 c = a + b;
95     require(c >= a);
96 
97     return c;
98   }
99 
100   /**
101   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
102   * reverts when dividing by zero.
103   */
104   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
105     require(b != 0);
106     return a % b;
107   }
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
137   * @param owner The address to query the the balance of.
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
153    )
154     public
155     view
156     returns (uint256)
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
167     require(value <= _balances[msg.sender]);
168     require(to != address(0));
169 
170     _balances[msg.sender] = _balances[msg.sender].sub(value);
171     _balances[to] = _balances[to].add(value);
172     emit Transfer(msg.sender, to, value);
173     return true;
174   }
175 
176   /**
177    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
178    * Beware that changing an allowance with this method brings the risk that someone may use both the old
179    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
180    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
181    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
182    * @param spender The address which will spend the funds.
183    * @param value The amount of tokens to be spent.
184    */
185   function approve(address spender, uint256 value) public returns (bool) {
186     require(spender != address(0));
187 
188     _allowed[msg.sender][spender] = value;
189     emit Approval(msg.sender, spender, value);
190     return true;
191   }
192 
193   /**
194    * @dev Transfer tokens from one address to another
195    * @param from address The address which you want to send tokens from
196    * @param to address The address which you want to transfer to
197    * @param value uint256 the amount of tokens to be transferred
198    */
199   function transferFrom(
200     address from,
201     address to,
202     uint256 value
203   )
204     public
205     returns (bool)
206   {
207     require(value <= _balances[from]);
208     require(value <= _allowed[from][msg.sender]);
209     require(to != address(0));
210 
211     _balances[from] = _balances[from].sub(value);
212     _balances[to] = _balances[to].add(value);
213     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
214     emit Transfer(from, to, value);
215     return true;
216   }
217 
218   /**
219    * @dev Increase the amount of tokens that an owner allowed to a spender.
220    * approve should be called when allowed_[_spender] == 0. To increment
221    * allowed value is better to use this function to avoid 2 calls (and wait until
222    * the first transaction is mined)
223    * From MonolithDAO Token.sol
224    * @param spender The address which will spend the funds.
225    * @param addedValue The amount of tokens to increase the allowance by.
226    */
227   function increaseAllowance(
228     address spender,
229     uint256 addedValue
230   )
231     public
232     returns (bool)
233   {
234     require(spender != address(0));
235 
236     _allowed[msg.sender][spender] = (
237       _allowed[msg.sender][spender].add(addedValue));
238     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
239     return true;
240   }
241 
242   /**
243    * @dev Decrease the amount of tokens that an owner allowed to a spender.
244    * approve should be called when allowed_[_spender] == 0. To decrement
245    * allowed value is better to use this function to avoid 2 calls (and wait until
246    * the first transaction is mined)
247    * From MonolithDAO Token.sol
248    * @param spender The address which will spend the funds.
249    * @param subtractedValue The amount of tokens to decrease the allowance by.
250    */
251   function decreaseAllowance(
252     address spender,
253     uint256 subtractedValue
254   )
255     public
256     returns (bool)
257   {
258     require(spender != address(0));
259 
260     _allowed[msg.sender][spender] = (
261       _allowed[msg.sender][spender].sub(subtractedValue));
262     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
263     return true;
264   }
265 
266   /**
267    * @dev Internal function that mints an amount of the token and assigns it to
268    * an account. This encapsulates the modification of balances such that the
269    * proper events are emitted.
270    * @param account The account that will receive the created tokens.
271    * @param amount The amount that will be created.
272    */
273   function _mint(address account, uint256 amount) internal {
274     require(account != 0);
275     _totalSupply = _totalSupply.add(amount);
276     _balances[account] = _balances[account].add(amount);
277     emit Transfer(address(0), account, amount);
278   }
279 
280   /**
281    * @dev Internal function that burns an amount of the token of a given
282    * account.
283    * @param account The account whose tokens will be burnt.
284    * @param amount The amount that will be burnt.
285    */
286   function _burn(address account, uint256 amount) internal {
287     require(account != 0);
288     require(amount <= _balances[account]);
289 
290     _totalSupply = _totalSupply.sub(amount);
291     _balances[account] = _balances[account].sub(amount);
292     emit Transfer(account, address(0), amount);
293   }
294 
295   /**
296    * @dev Internal function that burns an amount of the token of a given
297    * account, deducting from the sender's allowance for said account. Uses the
298    * internal burn function.
299    * @param account The account whose tokens will be burnt.
300    * @param amount The amount that will be burnt.
301    */
302   function _burnFrom(address account, uint256 amount) internal {
303     require(amount <= _allowed[account][msg.sender]);
304 
305     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
306     // this function needs to emit an event with the updated approval.
307     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
308       amount);
309     _burn(account, amount);
310   }
311 }
312 
313 
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
346     internal
347     view
348     returns (bool)
349   {
350     require(account != address(0));
351     return role.bearer[account];
352   }
353 }
354 
355 
356 
357 contract MinterRole {
358   using Roles for Roles.Role;
359 
360   event MinterAdded(address indexed account);
361   event MinterRemoved(address indexed account);
362 
363   Roles.Role private minters;
364 
365   constructor() public {
366     minters.add(msg.sender);
367   }
368 
369   modifier onlyMinter() {
370     require(isMinter(msg.sender));
371     _;
372   }
373 
374   function isMinter(address account) public view returns (bool) {
375     return minters.has(account);
376   }
377 
378   function addMinter(address account) public onlyMinter {
379     minters.add(account);
380     emit MinterAdded(account);
381   }
382 
383   function renounceMinter() public {
384     minters.remove(msg.sender);
385   }
386 
387   function _removeMinter(address account) internal {
388     minters.remove(account);
389     emit MinterRemoved(account);
390   }
391 }
392 
393 
394 
395 /**
396  * @title ERC20Mintable
397  * @dev ERC20 minting logic
398  */
399 contract ERC20Mintable is ERC20, MinterRole {
400   event MintingFinished();
401 
402   bool private _mintingFinished = false;
403 
404   modifier onlyBeforeMintingFinished() {
405     require(!_mintingFinished);
406     _;
407   }
408 
409   /**
410    * @return true if the minting is finished.
411    */
412   function mintingFinished() public view returns(bool) {
413     return _mintingFinished;
414   }
415 
416   /**
417    * @dev Function to mint tokens
418    * @param to The address that will receive the minted tokens.
419    * @param amount The amount of tokens to mint.
420    * @return A boolean that indicates if the operation was successful.
421    */
422   function mint(
423     address to,
424     uint256 amount
425   )
426     public
427     onlyMinter
428     onlyBeforeMintingFinished
429     returns (bool)
430   {
431     _mint(to, amount);
432     return true;
433   }
434 
435   /**
436    * @dev Function to stop minting new tokens.
437    * @return True if the operation was successful.
438    */
439   function finishMinting()
440     public
441     onlyMinter
442     onlyBeforeMintingFinished
443     returns (bool)
444   {
445     _mintingFinished = true;
446     emit MintingFinished();
447     return true;
448   }
449 }
450 
451 
452 contract WasteCoin is ERC20Mintable {
453 
454   string public name = "WasteCoin";
455   string public symbol = "WC";
456   uint8 public decimals = 18;
457 
458   constructor() public { }
459 
460 }