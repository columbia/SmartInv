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
128 /**
129  * @title ERC20Detailed token
130  * @dev The decimals are only for visualization purposes.
131  * All the operations are done using the smallest and indivisible token unit,
132  * just as on Ethereum all the operations are done in wei.
133  */
134 contract ERC20Detailed is IERC20 {
135   string private _name;
136   string private _symbol;
137   uint8 private _decimals;
138 
139   constructor(string name, string symbol, uint8 decimals) public {
140     _name = name;
141     _symbol = symbol;
142     _decimals = decimals;
143   }
144 
145   /**
146    * @return the name of the token.
147    */
148   function name() public view returns(string) {
149     return _name;
150   }
151 
152   /**
153    * @return the symbol of the token.
154    */
155   function symbol() public view returns(string) {
156     return _symbol;
157   }
158 
159   /**
160    * @return the number of decimals of the token.
161    */
162   function decimals() public view returns(uint8) {
163     return _decimals;
164   }
165 }
166 
167 
168 
169 
170 
171 
172 
173 
174 /**
175  * @title SafeMath
176  * @dev Math operations with safety checks that revert on error
177  */
178 library SafeMath {
179 
180   /**
181   * @dev Multiplies two numbers, reverts on overflow.
182   */
183   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
184     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
185     // benefit is lost if 'b' is also tested.
186     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
187     if (a == 0) {
188       return 0;
189     }
190 
191     uint256 c = a * b;
192     require(c / a == b);
193 
194     return c;
195   }
196 
197   /**
198   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
199   */
200   function div(uint256 a, uint256 b) internal pure returns (uint256) {
201     require(b > 0); // Solidity only automatically asserts when dividing by 0
202     uint256 c = a / b;
203     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
204 
205     return c;
206   }
207 
208   /**
209   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
210   */
211   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
212     require(b <= a);
213     uint256 c = a - b;
214 
215     return c;
216   }
217 
218   /**
219   * @dev Adds two numbers, reverts on overflow.
220   */
221   function add(uint256 a, uint256 b) internal pure returns (uint256) {
222     uint256 c = a + b;
223     require(c >= a);
224 
225     return c;
226   }
227 
228   /**
229   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
230   * reverts when dividing by zero.
231   */
232   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
233     require(b != 0);
234     return a % b;
235   }
236 }
237 
238 
239 /**
240  * @title Standard ERC20 token
241  *
242  * @dev Implementation of the basic standard token.
243  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
244  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
245  */
246 contract ERC20 is IERC20 {
247   using SafeMath for uint256;
248 
249   mapping (address => uint256) private _balances;
250 
251   mapping (address => mapping (address => uint256)) private _allowed;
252 
253   uint256 private _totalSupply;
254 
255   /**
256   * @dev Total number of tokens in existence
257   */
258   function totalSupply() public view returns (uint256) {
259     return _totalSupply;
260   }
261 
262   /**
263   * @dev Gets the balance of the specified address.
264   * @param owner The address to query the balance of.
265   * @return An uint256 representing the amount owned by the passed address.
266   */
267   function balanceOf(address owner) public view returns (uint256) {
268     return _balances[owner];
269   }
270 
271   /**
272    * @dev Function to check the amount of tokens that an owner allowed to a spender.
273    * @param owner address The address which owns the funds.
274    * @param spender address The address which will spend the funds.
275    * @return A uint256 specifying the amount of tokens still available for the spender.
276    */
277   function allowance(
278     address owner,
279     address spender
280    )
281     public
282     view
283     returns (uint256)
284   {
285     return _allowed[owner][spender];
286   }
287 
288   /**
289   * @dev Transfer token for a specified address
290   * @param to The address to transfer to.
291   * @param value The amount to be transferred.
292   */
293   function transfer(address to, uint256 value) public returns (bool) {
294     _transfer(msg.sender, to, value);
295     return true;
296   }
297 
298   /**
299    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
300    * Beware that changing an allowance with this method brings the risk that someone may use both the old
301    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
302    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
303    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
304    * @param spender The address which will spend the funds.
305    * @param value The amount of tokens to be spent.
306    */
307   function approve(address spender, uint256 value) public returns (bool) {
308     require(spender != address(0));
309 
310     _allowed[msg.sender][spender] = value;
311     emit Approval(msg.sender, spender, value);
312     return true;
313   }
314 
315   /**
316    * @dev Transfer tokens from one address to another
317    * @param from address The address which you want to send tokens from
318    * @param to address The address which you want to transfer to
319    * @param value uint256 the amount of tokens to be transferred
320    */
321   function transferFrom(
322     address from,
323     address to,
324     uint256 value
325   )
326     public
327     returns (bool)
328   {
329     require(value <= _allowed[from][msg.sender]);
330 
331     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
332     _transfer(from, to, value);
333     return true;
334   }
335 
336   /**
337    * @dev Increase the amount of tokens that an owner allowed to a spender.
338    * approve should be called when allowed_[_spender] == 0. To increment
339    * allowed value is better to use this function to avoid 2 calls (and wait until
340    * the first transaction is mined)
341    * From MonolithDAO Token.sol
342    * @param spender The address which will spend the funds.
343    * @param addedValue The amount of tokens to increase the allowance by.
344    */
345   function increaseAllowance(
346     address spender,
347     uint256 addedValue
348   )
349     public
350     returns (bool)
351   {
352     require(spender != address(0));
353 
354     _allowed[msg.sender][spender] = (
355       _allowed[msg.sender][spender].add(addedValue));
356     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
357     return true;
358   }
359 
360   /**
361    * @dev Decrease the amount of tokens that an owner allowed to a spender.
362    * approve should be called when allowed_[_spender] == 0. To decrement
363    * allowed value is better to use this function to avoid 2 calls (and wait until
364    * the first transaction is mined)
365    * From MonolithDAO Token.sol
366    * @param spender The address which will spend the funds.
367    * @param subtractedValue The amount of tokens to decrease the allowance by.
368    */
369   function decreaseAllowance(
370     address spender,
371     uint256 subtractedValue
372   )
373     public
374     returns (bool)
375   {
376     require(spender != address(0));
377 
378     _allowed[msg.sender][spender] = (
379       _allowed[msg.sender][spender].sub(subtractedValue));
380     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
381     return true;
382   }
383 
384   /**
385   * @dev Transfer token for a specified addresses
386   * @param from The address to transfer from.
387   * @param to The address to transfer to.
388   * @param value The amount to be transferred.
389   */
390   function _transfer(address from, address to, uint256 value) internal {
391     require(value <= _balances[from]);
392     require(to != address(0));
393 
394     _balances[from] = _balances[from].sub(value);
395     _balances[to] = _balances[to].add(value);
396     emit Transfer(from, to, value);
397   }
398 
399   /**
400    * @dev Internal function that mints an amount of the token and assigns it to
401    * an account. This encapsulates the modification of balances such that the
402    * proper events are emitted.
403    * @param account The account that will receive the created tokens.
404    * @param value The amount that will be created.
405    */
406   function _mint(address account, uint256 value) internal {
407     require(account != 0);
408     _totalSupply = _totalSupply.add(value);
409     _balances[account] = _balances[account].add(value);
410     emit Transfer(address(0), account, value);
411   }
412 
413   /**
414    * @dev Internal function that burns an amount of the token of a given
415    * account.
416    * @param account The account whose tokens will be burnt.
417    * @param value The amount that will be burnt.
418    */
419   function _burn(address account, uint256 value) internal {
420     require(account != 0);
421     require(value <= _balances[account]);
422 
423     _totalSupply = _totalSupply.sub(value);
424     _balances[account] = _balances[account].sub(value);
425     emit Transfer(account, address(0), value);
426   }
427 
428   /**
429    * @dev Internal function that burns an amount of the token of a given
430    * account, deducting from the sender's allowance for said account. Uses the
431    * internal burn function.
432    * @param account The account whose tokens will be burnt.
433    * @param value The amount that will be burnt.
434    */
435   function _burnFrom(address account, uint256 value) internal {
436     require(value <= _allowed[account][msg.sender]);
437 
438     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
439     // this function needs to emit an event with the updated approval.
440     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
441       value);
442     _burn(account, value);
443   }
444 }
445 
446 
447 
448 /**
449  * @title ERC20Mintable
450  * @dev ERC20 minting logic
451  */
452 contract ERC20Mintable is ERC20, MinterRole {
453   /**
454    * @dev Function to mint tokens
455    * @param to The address that will receive the minted tokens.
456    * @param value The amount of tokens to mint.
457    * @return A boolean that indicates if the operation was successful.
458    */
459   function mint(
460     address to,
461     uint256 value
462   )
463     public
464     onlyMinter
465     returns (bool)
466   {
467     _mint(to, value);
468     return true;
469   }
470 }
471 
472 
473 
474 /**
475  * @title ERC20Mintable
476  * @dev ERC20 minting logic
477  */
478  
479 contract W1Coin is ERC20Detailed,ERC20Mintable
480 {
481  
482     
483     
484     Roles.Role private minters1 ;
485   constructor(
486         string name,
487         string symbol,
488         uint8 decimals
489     )
490         ERC20Mintable()
491         ERC20Detailed(name, symbol, decimals)
492         ERC20()
493         public
494     {
495         
496     }
497     
498 }