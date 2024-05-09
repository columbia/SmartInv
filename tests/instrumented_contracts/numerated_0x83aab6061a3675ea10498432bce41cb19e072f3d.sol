1 pragma solidity 0.4.25;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address private _owner;
10 
11   event OwnershipTransferred(
12     address indexed previousOwner,
13     address indexed newOwner
14   );
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   constructor() internal {
21     _owner = msg.sender;
22     emit OwnershipTransferred(address(0), _owner);
23   }
24 
25   /**
26    * @return the address of the owner.
27    */
28   function owner() public view returns(address) {
29     return _owner;
30   }
31 
32   /**
33    * @dev Throws if called by any account other than the owner.
34    */
35   modifier onlyOwner() {
36     require(isOwner());
37     _;
38   }
39 
40   /**
41    * @return true if `msg.sender` is the owner of the contract.
42    */
43   function isOwner() public view returns(bool) {
44     return msg.sender == _owner;
45   }
46 
47   /**
48    * @dev Allows the current owner to relinquish control of the contract.
49    * @notice Renouncing to ownership will leave the contract without an owner.
50    * It will not be possible to call the functions with the `onlyOwner`
51    * modifier anymore.
52    */
53   function renounceOwnership() public onlyOwner {
54     emit OwnershipTransferred(_owner, address(0));
55     _owner = address(0);
56   }
57 
58   /**
59    * @dev Allows the current owner to transfer control of the contract to a newOwner.
60    * @param newOwner The address to transfer ownership to.
61    */
62   function transferOwnership(address newOwner) public onlyOwner {
63     _transferOwnership(newOwner);
64   }
65 
66   /**
67    * @dev Transfers control of the contract to a newOwner.
68    * @param newOwner The address to transfer ownership to.
69    */
70   function _transferOwnership(address newOwner) internal {
71     require(newOwner != address(0));
72     emit OwnershipTransferred(_owner, newOwner);
73     _owner = newOwner;
74   }
75 }
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
87     external view returns (uint256);
88 
89   function transfer(address to, uint256 value) external returns (bool);
90 
91   function approve(address spender, uint256 value)
92     external returns (bool);
93 
94   function transferFrom(address from, address to, uint256 value)
95     external returns (bool);
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
111 /**
112  * @title SafeMath
113  * @dev Math operations with safety checks that revert on error
114  */
115 library SafeMath {
116 
117   /**
118   * @dev Multiplies two numbers, reverts on overflow.
119   */
120   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
121     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
122     // benefit is lost if 'b' is also tested.
123     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
124     if (a == 0) {
125       return 0;
126     }
127 
128     uint256 c = a * b;
129     require(c / a == b);
130 
131     return c;
132   }
133 
134   /**
135   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
136   */
137   function div(uint256 a, uint256 b) internal pure returns (uint256) {
138     require(b > 0); // Solidity only automatically asserts when dividing by 0
139     uint256 c = a / b;
140     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
141 
142     return c;
143   }
144 
145   /**
146   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
147   */
148   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
149     require(b <= a);
150     uint256 c = a - b;
151 
152     return c;
153   }
154 
155   /**
156   * @dev Adds two numbers, reverts on overflow.
157   */
158   function add(uint256 a, uint256 b) internal pure returns (uint256) {
159     uint256 c = a + b;
160     require(c >= a);
161 
162     return c;
163   }
164 
165   /**
166   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
167   * reverts when dividing by zero.
168   */
169   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
170     require(b != 0);
171     return a % b;
172   }
173 }
174 
175 
176 /**
177  * @title Standard ERC20 token
178  *
179  * @dev Implementation of the basic standard token.
180  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
181  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
182  */
183 contract ERC20 is IERC20 {
184   using SafeMath for uint256;
185 
186   mapping (address => uint256) private _balances;
187 
188   mapping (address => mapping (address => uint256)) private _allowed;
189 
190   uint256 private _totalSupply;
191 
192   /**
193   * @dev Total number of tokens in existence
194   */
195   function totalSupply() public view returns (uint256) {
196     return _totalSupply;
197   }
198 
199   /**
200   * @dev Gets the balance of the specified address.
201   * @param owner The address to query the balance of.
202   * @return An uint256 representing the amount owned by the passed address.
203   */
204   function balanceOf(address owner) public view returns (uint256) {
205     return _balances[owner];
206   }
207 
208   /**
209    * @dev Function to check the amount of tokens that an owner allowed to a spender.
210    * @param owner address The address which owns the funds.
211    * @param spender address The address which will spend the funds.
212    * @return A uint256 specifying the amount of tokens still available for the spender.
213    */
214   function allowance(
215     address owner,
216     address spender
217    )
218     public
219     view
220     returns (uint256)
221   {
222     return _allowed[owner][spender];
223   }
224 
225   /**
226   * @dev Transfer token for a specified address
227   * @param to The address to transfer to.
228   * @param value The amount to be transferred.
229   */
230   function transfer(address to, uint256 value) public returns (bool) {
231     _transfer(msg.sender, to, value);
232     return true;
233   }
234 
235   /**
236    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
237    * Beware that changing an allowance with this method brings the risk that someone may use both the old
238    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
239    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
240    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
241    * @param spender The address which will spend the funds.
242    * @param value The amount of tokens to be spent.
243    */
244   function approve(address spender, uint256 value) public returns (bool) {
245     require(spender != address(0));
246 
247     _allowed[msg.sender][spender] = value;
248     emit Approval(msg.sender, spender, value);
249     return true;
250   }
251 
252   /**
253    * @dev Transfer tokens from one address to another
254    * @param from address The address which you want to send tokens from
255    * @param to address The address which you want to transfer to
256    * @param value uint256 the amount of tokens to be transferred
257    */
258   function transferFrom(
259     address from,
260     address to,
261     uint256 value
262   )
263     public
264     returns (bool)
265   {
266     require(value <= _allowed[from][msg.sender]);
267 
268     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
269     _transfer(from, to, value);
270     return true;
271   }
272 
273   /**
274    * @dev Increase the amount of tokens that an owner allowed to a spender.
275    * approve should be called when allowed_[_spender] == 0. To increment
276    * allowed value is better to use this function to avoid 2 calls (and wait until
277    * the first transaction is mined)
278    * From MonolithDAO Token.sol
279    * @param spender The address which will spend the funds.
280    * @param addedValue The amount of tokens to increase the allowance by.
281    */
282   function increaseAllowance(
283     address spender,
284     uint256 addedValue
285   )
286     public
287     returns (bool)
288   {
289     require(spender != address(0));
290 
291     _allowed[msg.sender][spender] = (
292       _allowed[msg.sender][spender].add(addedValue));
293     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
294     return true;
295   }
296 
297   /**
298    * @dev Decrease the amount of tokens that an owner allowed to a spender.
299    * approve should be called when allowed_[_spender] == 0. To decrement
300    * allowed value is better to use this function to avoid 2 calls (and wait until
301    * the first transaction is mined)
302    * From MonolithDAO Token.sol
303    * @param spender The address which will spend the funds.
304    * @param subtractedValue The amount of tokens to decrease the allowance by.
305    */
306   function decreaseAllowance(
307     address spender,
308     uint256 subtractedValue
309   )
310     public
311     returns (bool)
312   {
313     require(spender != address(0));
314 
315     _allowed[msg.sender][spender] = (
316       _allowed[msg.sender][spender].sub(subtractedValue));
317     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
318     return true;
319   }
320 
321   /**
322   * @dev Transfer token for a specified addresses
323   * @param from The address to transfer from.
324   * @param to The address to transfer to.
325   * @param value The amount to be transferred.
326   */
327   function _transfer(address from, address to, uint256 value) internal {
328     require(value <= _balances[from]);
329     require(to != address(0));
330 
331     _balances[from] = _balances[from].sub(value);
332     _balances[to] = _balances[to].add(value);
333     emit Transfer(from, to, value);
334   }
335 
336   /**
337    * @dev Internal function that mints an amount of the token and assigns it to
338    * an account. This encapsulates the modification of balances such that the
339    * proper events are emitted.
340    * @param account The account that will receive the created tokens.
341    * @param value The amount that will be created.
342    */
343   function _mint(address account, uint256 value) internal {
344     require(account != 0);
345     _totalSupply = _totalSupply.add(value);
346     _balances[account] = _balances[account].add(value);
347     emit Transfer(address(0), account, value);
348   }
349 
350   /**
351    * @dev Internal function that burns an amount of the token of a given
352    * account.
353    * @param account The account whose tokens will be burnt.
354    * @param value The amount that will be burnt.
355    */
356   function _burn(address account, uint256 value) internal {
357     require(account != 0);
358     require(value <= _balances[account]);
359 
360     _totalSupply = _totalSupply.sub(value);
361     _balances[account] = _balances[account].sub(value);
362     emit Transfer(account, address(0), value);
363   }
364 
365   /**
366    * @dev Internal function that burns an amount of the token of a given
367    * account, deducting from the sender's allowance for said account. Uses the
368    * internal burn function.
369    * @param account The account whose tokens will be burnt.
370    * @param value The amount that will be burnt.
371    */
372   function _burnFrom(address account, uint256 value) internal {
373     require(value <= _allowed[account][msg.sender]);
374 
375     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
376     // this function needs to emit an event with the updated approval.
377     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
378       value);
379     _burn(account, value);
380   }
381 }
382 
383 
384 contract CUSD is ERC20, Ownable {
385 
386   /* --- EVENTS --- */
387 
388   event NewSupportedToken(address token);
389   event DisableDeposit(address token);
390   event EnableDeposit(address token);
391   event Deposit(address indexed token, address indexed from, uint amount);
392   event Withdraw(address indexed token, address indexed to, uint amount);
393 
394   /* --- FIELDS / CONSTANTS --- */
395 
396   string public constant name = "ContractLand USD Token";
397   string public constant symbol = "CUSD";
398   uint8 public constant decimals = 18;
399 
400   address[] public supportedTokens;
401   mapping(address => bool) public supported;
402   mapping(address => bool) public disabled;
403 
404   /* --- PUBLIC/EXTERNAL FUNCTIONS --- */
405 
406   function deposit(address token, uint256 value) public {
407     require(supported[token], "Token is not supported");
408     require(!disabled[token], "Token is disabled for deposit");
409     require(IERC20(token).transferFrom(msg.sender, this, value), "Failed to transfer token from user for deposit");
410     _mint(msg.sender, value);
411     emit Deposit(token, msg.sender, value);
412   }
413 
414   function withdraw(address token, uint256 value) public {
415     require(supported[token], "Token is not supported");
416     _burn(msg.sender, value);
417     require(IERC20(token).transfer(msg.sender, value), "Failed to transfer token to user for withdraw");
418     emit Withdraw(token, msg.sender, value);
419   }
420 
421   function addNewSupportedToken(address newToken) public onlyOwner {
422     require(!supported[newToken], "Token already supported");
423     supported[newToken] = true;
424     supportedTokens.push(newToken);
425     emit NewSupportedToken(newToken);
426   }
427 
428   function disableDeposit(address token) public onlyOwner {
429     disabled[token] = true;
430     emit DisableDeposit(token);
431   }
432 
433   function enableDeposit(address token) public onlyOwner {
434     disabled[token] = false;
435     emit EnableDeposit(token);
436   }
437 
438   function getSupportedTokenCount() public view returns (uint) {
439     return supportedTokens.length;
440   }
441 
442   function getContractBalanceOf(address token) public view returns (uint) {
443     return IERC20(token).balanceOf(this);
444   }
445 
446   function getUserBalanceOf(address token, address user) public view returns (uint) {
447     return IERC20(token).balanceOf(user);
448   }
449 }