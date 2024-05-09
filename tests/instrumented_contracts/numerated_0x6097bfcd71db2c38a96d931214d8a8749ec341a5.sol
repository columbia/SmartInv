1 pragma solidity ^0.4.24;
2 
3 /**
4  * Virtuse exchange - Where Crypto and Capital Markets Meet. A revolutionarily inclusive, tokenized financial asset platform, democratizing access to investment with the help of the blockchain.
5  */
6 
7 /**
8  * @title ERC20 interface
9  * @dev see https://github.com/ethereum/EIPs/issues/20
10  */
11 interface IERC20 {
12   function totalSupply() external view returns (uint256);
13 
14   function balanceOf(address who) external view returns (uint256);
15 
16   function allowance(address owner, address spender)
17     external view returns (uint256);
18 
19   function transfer(address to, uint256 value) external returns (bool);
20 
21   function approve(address spender, uint256 value)
22     external returns (bool);
23 
24   function transferFrom(address from, address to, uint256 value)
25     external returns (bool);
26 
27   event Transfer(
28     address indexed from,
29     address indexed to,
30     uint256 value
31   );
32 
33   event Approval(
34     address indexed owner,
35     address indexed spender,
36     uint256 value
37   );
38 }
39 
40 /**
41  * @title SafeMath
42  * @dev Math operations with safety checks that revert on error
43  */
44 library SafeMath {
45 
46   /**
47   * @dev Multiplies two numbers, reverts on overflow.
48   */
49   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
50     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
51     // benefit is lost if 'b' is also tested.
52     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
53     if (a == 0) {
54       return 0;
55     }
56 
57     uint256 c = a * b;
58     require(c / a == b);
59 
60     return c;
61   }
62 
63   /**
64   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
65   */
66   function div(uint256 a, uint256 b) internal pure returns (uint256) {
67     require(b > 0); // Solidity only automatically asserts when dividing by 0
68     uint256 c = a / b;
69     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70 
71     return c;
72   }
73 
74   /**
75   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
76   */
77   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
78     require(b <= a);
79     uint256 c = a - b;
80 
81     return c;
82   }
83 
84   /**
85   * @dev Adds two numbers, reverts on overflow.
86   */
87   function add(uint256 a, uint256 b) internal pure returns (uint256) {
88     uint256 c = a + b;
89     require(c >= a);
90 
91     return c;
92   }
93 
94   /**
95   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
96   * reverts when dividing by zero.
97   */
98   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
99     require(b != 0);
100     return a % b;
101   }
102 }
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
145    )
146     public
147     view
148     returns (uint256)
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
191     public
192     returns (bool)
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
214     public
215     returns (bool)
216   {
217     require(spender != address(0));
218 
219     _allowed[msg.sender][spender] = (
220       _allowed[msg.sender][spender].add(addedValue));
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
238     public
239     returns (bool)
240   {
241     require(spender != address(0));
242 
243     _allowed[msg.sender][spender] = (
244       _allowed[msg.sender][spender].sub(subtractedValue));
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
311 /**
312  * @title Roles
313  * @dev Library for managing addresses assigned to a Role.
314  */
315 library Roles {
316   struct Role {
317     mapping (address => bool) bearer;
318   }
319 
320   /**
321    * @dev give an account access to this role
322    */
323   function add(Role storage role, address account) internal {
324     require(account != address(0));
325     require(!has(role, account));
326 
327     role.bearer[account] = true;
328   }
329 
330   /**
331    * @dev remove an account's access to this role
332    */
333   function remove(Role storage role, address account) internal {
334     require(account != address(0));
335     require(has(role, account));
336 
337     role.bearer[account] = false;
338   }
339 
340   /**
341    * @dev check if an account has this role
342    * @return bool
343    */
344   function has(Role storage role, address account)
345     internal
346     view
347     returns (bool)
348   {
349     require(account != address(0));
350     return role.bearer[account];
351   }
352 }
353 
354 contract MinterRole {
355   using Roles for Roles.Role;
356 
357   event MinterAdded(address indexed account);
358   event MinterRemoved(address indexed account);
359 
360   Roles.Role private minters;
361 
362   constructor() internal {
363     _addMinter(msg.sender);
364   }
365 
366   modifier onlyMinter() {
367     require(isMinter(msg.sender));
368     _;
369   }
370 
371   function isMinter(address account) public view returns (bool) {
372     return minters.has(account);
373   }
374 
375   function addMinter(address account) public onlyMinter {
376     _addMinter(account);
377   }
378 
379   function renounceMinter() public {
380     _removeMinter(msg.sender);
381   }
382 
383   function _addMinter(address account) internal {
384     minters.add(account);
385     emit MinterAdded(account);
386   }
387 
388   function _removeMinter(address account) internal {
389     minters.remove(account);
390     emit MinterRemoved(account);
391   }
392 }
393 
394 /**
395  * @title ERC20Mintable
396  * @dev ERC20 minting logic
397  */
398 contract ERC20Mintable is ERC20, MinterRole {
399   /**
400    * @dev Function to mint tokens
401    * @param to The address that will receive the minted tokens.
402    * @param value The amount of tokens to mint.
403    * @return A boolean that indicates if the operation was successful.
404    */
405   function mint(
406     address to,
407     uint256 value
408   )
409     public
410     onlyMinter
411     returns (bool)
412   {
413     _mint(to, value);
414     return true;
415   }
416 }
417 
418 /**
419  * @title Capped token
420  * @dev Mintable token with a token cap.
421  */
422 contract ERC20Capped is ERC20Mintable {
423 
424   uint256 private _cap;
425 
426   constructor(uint256 cap)
427     public
428   {
429     require(cap > 0);
430     _cap = cap;
431   }
432 
433   /**
434    * @return the cap for the token minting.
435    */
436   function cap() public view returns(uint256) {
437     return _cap;
438   }
439 
440   function _mint(address account, uint256 value) internal {
441     require(totalSupply().add(value) <= _cap);
442     super._mint(account, value);
443   }
444 }
445 
446 contract VIRT is ERC20Capped {
447   string public constant name = "VIRT";
448   string public constant symbol = "VIRT";
449   uint8 public constant decimals = 18;
450   string public constant creator = "Virtuse Exchange";
451 
452   /**
453    * @dev Constructor that gives msg.sender all of existing tokens.
454    */
455   constructor(uint256 cap)
456     public
457     ERC20Capped(cap)
458   {
459     //
460   }
461 }