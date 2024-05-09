1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/20
7  */
8 interface IERC20 {
9   function totalSupply() external view returns (uint256);
10 
11   function balanceOf(address who) external view returns (uint256);
12 
13   function allowance(address owner, address spender)
14     external view returns (uint256);
15 
16   function transfer(address to, uint256 value) external returns (bool);
17 
18   function approve(address spender, uint256 value)
19     external returns (bool);
20 
21   function transferFrom(address from, address to, uint256 value)
22     external returns (bool);
23 
24   event Transfer(
25     address indexed from,
26     address indexed to,
27     uint256 value
28   );
29 
30   event Approval(
31     address indexed owner,
32     address indexed spender,
33     uint256 value
34   );
35 }
36 
37 
38 
39 /**
40  * @title Roles
41  * @dev Library for managing addresses assigned to a Role.
42  */
43 library Roles {
44   struct Role {
45     mapping (address => bool) bearer;
46   }
47 
48   /**
49    * @dev give an account access to this role
50    */
51   function add(Role storage role, address account) internal {
52     require(account != address(0));
53     role.bearer[account] = true;
54   }
55 
56   /**
57    * @dev remove an account's access to this role
58    */
59   function remove(Role storage role, address account) internal {
60     require(account != address(0));
61     role.bearer[account] = false;
62   }
63 
64   /**
65    * @dev check if an account has this role
66    * @return bool
67    */
68   function has(Role storage role, address account)
69     internal
70     view
71     returns (bool)
72   {
73     require(account != address(0));
74     return role.bearer[account];
75   }
76 }
77 
78 
79 
80 
81 
82 contract MinterRole {
83   using Roles for Roles.Role;
84 
85   event MinterAdded(address indexed account);
86   event MinterRemoved(address indexed account);
87 
88   Roles.Role private minters;
89 
90   constructor() public {
91     _addMinter(msg.sender);
92   }
93 
94   modifier onlyMinter() {
95     require(isMinter(msg.sender));
96     _;
97   }
98 
99   function isMinter(address account) public view returns (bool) {
100     return minters.has(account);
101   }
102 
103   function addMinter(address account) public onlyMinter {
104     _addMinter(account);
105   }
106 
107   function renounceMinter() public {
108     _removeMinter(msg.sender);
109   }
110 
111   function _addMinter(address account) internal {
112     minters.add(account);
113     emit MinterAdded(account);
114   }
115 
116   function _removeMinter(address account) internal {
117     minters.remove(account);
118     emit MinterRemoved(account);
119   }
120 }
121 
122 
123 
124 
125 
126 
127 
128 
129 
130 
131 /**
132  * @title SafeMath
133  * @dev Math operations with safety checks that revert on error
134  */
135 library SafeMath {
136 
137   /**
138   * @dev Multiplies two numbers, reverts on overflow.
139   */
140   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
141     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
142     // benefit is lost if 'b' is also tested.
143     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
144     if (a == 0) {
145       return 0;
146     }
147 
148     uint256 c = a * b;
149     require(c / a == b);
150 
151     return c;
152   }
153 
154   /**
155   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
156   */
157   function div(uint256 a, uint256 b) internal pure returns (uint256) {
158     require(b > 0); // Solidity only automatically asserts when dividing by 0
159     uint256 c = a / b;
160     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
161 
162     return c;
163   }
164 
165   /**
166   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
167   */
168   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
169     require(b <= a);
170     uint256 c = a - b;
171 
172     return c;
173   }
174 
175   /**
176   * @dev Adds two numbers, reverts on overflow.
177   */
178   function add(uint256 a, uint256 b) internal pure returns (uint256) {
179     uint256 c = a + b;
180     require(c >= a);
181 
182     return c;
183   }
184 
185   /**
186   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
187   * reverts when dividing by zero.
188   */
189   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
190     require(b != 0);
191     return a % b;
192   }
193 }
194 
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
222   * @param owner The address to query the the balance of.
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
362    * @param amount The amount that will be created.
363    */
364   function _mint(address account, uint256 amount) internal {
365     require(account != 0);
366     _totalSupply = _totalSupply.add(amount);
367     _balances[account] = _balances[account].add(amount);
368     emit Transfer(address(0), account, amount);
369   }
370 
371   /**
372    * @dev Internal function that burns an amount of the token of a given
373    * account.
374    * @param account The account whose tokens will be burnt.
375    * @param amount The amount that will be burnt.
376    */
377   function _burn(address account, uint256 amount) internal {
378     require(account != 0);
379     require(amount <= _balances[account]);
380 
381     _totalSupply = _totalSupply.sub(amount);
382     _balances[account] = _balances[account].sub(amount);
383     emit Transfer(account, address(0), amount);
384   }
385 
386   /**
387    * @dev Internal function that burns an amount of the token of a given
388    * account, deducting from the sender's allowance for said account. Uses the
389    * internal burn function.
390    * @param account The account whose tokens will be burnt.
391    * @param amount The amount that will be burnt.
392    */
393   function _burnFrom(address account, uint256 amount) internal {
394     require(amount <= _allowed[account][msg.sender]);
395 
396     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
397     // this function needs to emit an event with the updated approval.
398     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
399       amount);
400     _burn(account, amount);
401   }
402 }
403 
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
415    * @param amount The amount of tokens to mint.
416    * @return A boolean that indicates if the operation was successful.
417    */
418   function mint(
419     address to,
420     uint256 amount
421   )
422     public
423     onlyMinter
424     returns (bool)
425   {
426     _mint(to, amount);
427     return true;
428   }
429 }
430 
431 
432 contract FreeMintCoin is ERC20Mintable {
433     string private _name = "__FreeMintCoin__";
434     string private _symbol = "FMC";
435     uint8 private _decimals = 18;
436 
437 
438     ////
439     // Everyone can mint!!!
440     ////
441     function mint(address _to, uint256 _amount) public returns (bool)
442     {
443         _mint(_to, _amount);
444         return true;
445     }
446 }