1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that revert on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, reverts on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     uint256 c = a * b;
23     require(c / a == b);
24 
25     return c;
26   }
27 
28   /**
29   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
30   */
31   function div(uint256 a, uint256 b) internal pure returns (uint256) {
32     require(b > 0); // Solidity only automatically asserts when dividing by 0
33     uint256 c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36     return c;
37   }
38 
39   /**
40   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41   */
42   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43     require(b <= a);
44     uint256 c = a - b;
45 
46     return c;
47   }
48 
49   /**
50   * @dev Adds two numbers, reverts on overflow.
51   */
52   function add(uint256 a, uint256 b) internal pure returns (uint256) {
53     uint256 c = a + b;
54     require(c >= a);
55 
56     return c;
57   }
58 
59   /**
60   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
61   * reverts when dividing by zero.
62   */
63   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64     require(b != 0);
65     return a % b;
66   }
67 }
68 
69 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
70 
71 /**
72  * @title Ownable
73  * @dev The Ownable contract has an owner address, and provides basic authorization control
74  * functions, this simplifies the implementation of "user permissions".
75  */
76 contract Ownable {
77   address private _owner;
78 
79   event OwnershipTransferred(
80     address indexed previousOwner,
81     address indexed newOwner
82   );
83 
84   /**
85    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
86    * account.
87    */
88   constructor() internal {
89     _owner = msg.sender;
90     emit OwnershipTransferred(address(0), _owner);
91   }
92 
93   /**
94    * @return the address of the owner.
95    */
96   function owner() public view returns(address) {
97     return _owner;
98   }
99 
100   /**
101    * @dev Throws if called by any account other than the owner.
102    */
103   modifier onlyOwner() {
104     require(isOwner());
105     _;
106   }
107 
108   /**
109    * @return true if `msg.sender` is the owner of the contract.
110    */
111   function isOwner() public view returns(bool) {
112     return msg.sender == _owner;
113   }
114 
115   /**
116    * @dev Allows the current owner to relinquish control of the contract.
117    * @notice Renouncing to ownership will leave the contract without an owner.
118    * It will not be possible to call the functions with the `onlyOwner`
119    * modifier anymore.
120    */
121   function renounceOwnership() public onlyOwner {
122     emit OwnershipTransferred(_owner, address(0));
123     _owner = address(0);
124   }
125 
126   /**
127    * @dev Allows the current owner to transfer control of the contract to a newOwner.
128    * @param newOwner The address to transfer ownership to.
129    */
130   function transferOwnership(address newOwner) public onlyOwner {
131     _transferOwnership(newOwner);
132   }
133 
134   /**
135    * @dev Transfers control of the contract to a newOwner.
136    * @param newOwner The address to transfer ownership to.
137    */
138   function _transferOwnership(address newOwner) internal {
139     require(newOwner != address(0));
140     emit OwnershipTransferred(_owner, newOwner);
141     _owner = newOwner;
142   }
143 }
144 
145 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
146 
147 /**
148  * @title ERC20 interface
149  * @dev see https://github.com/ethereum/EIPs/issues/20
150  */
151 interface IERC20 {
152   function totalSupply() external view returns (uint256);
153 
154   function balanceOf(address who) external view returns (uint256);
155 
156   function allowance(address owner, address spender)
157     external view returns (uint256);
158 
159   function transfer(address to, uint256 value) external returns (bool);
160 
161   function approve(address spender, uint256 value)
162     external returns (bool);
163 
164   function transferFrom(address from, address to, uint256 value)
165     external returns (bool);
166 
167   event Transfer(
168     address indexed from,
169     address indexed to,
170     uint256 value
171   );
172 
173   event Approval(
174     address indexed owner,
175     address indexed spender,
176     uint256 value
177   );
178 }
179 
180 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
181 
182 /**
183  * @title Standard ERC20 token
184  *
185  * @dev Implementation of the basic standard token.
186  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
187  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
188  */
189 contract ERC20 is IERC20 {
190   using SafeMath for uint256;
191 
192   mapping (address => uint256) private _balances;
193 
194   mapping (address => mapping (address => uint256)) private _allowed;
195 
196   uint256 private _totalSupply;
197 
198   /**
199   * @dev Total number of tokens in existence
200   */
201   function totalSupply() public view returns (uint256) {
202     return _totalSupply;
203   }
204 
205   /**
206   * @dev Gets the balance of the specified address.
207   * @param owner The address to query the balance of.
208   * @return An uint256 representing the amount owned by the passed address.
209   */
210   function balanceOf(address owner) public view returns (uint256) {
211     return _balances[owner];
212   }
213 
214   /**
215    * @dev Function to check the amount of tokens that an owner allowed to a spender.
216    * @param owner address The address which owns the funds.
217    * @param spender address The address which will spend the funds.
218    * @return A uint256 specifying the amount of tokens still available for the spender.
219    */
220   function allowance(
221     address owner,
222     address spender
223    )
224     public
225     view
226     returns (uint256)
227   {
228     return _allowed[owner][spender];
229   }
230 
231   /**
232   * @dev Transfer token for a specified address
233   * @param to The address to transfer to.
234   * @param value The amount to be transferred.
235   */
236   function transfer(address to, uint256 value) public returns (bool) {
237     _transfer(msg.sender, to, value);
238     return true;
239   }
240 
241   /**
242    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
243    * Beware that changing an allowance with this method brings the risk that someone may use both the old
244    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
245    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
246    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
247    * @param spender The address which will spend the funds.
248    * @param value The amount of tokens to be spent.
249    */
250   function approve(address spender, uint256 value) public returns (bool) {
251     require(spender != address(0));
252 
253     _allowed[msg.sender][spender] = value;
254     emit Approval(msg.sender, spender, value);
255     return true;
256   }
257 
258   /**
259    * @dev Transfer tokens from one address to another
260    * @param from address The address which you want to send tokens from
261    * @param to address The address which you want to transfer to
262    * @param value uint256 the amount of tokens to be transferred
263    */
264   function transferFrom(
265     address from,
266     address to,
267     uint256 value
268   )
269     public
270     returns (bool)
271   {
272     require(value <= _allowed[from][msg.sender]);
273 
274     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
275     _transfer(from, to, value);
276     return true;
277   }
278 
279   /**
280    * @dev Increase the amount of tokens that an owner allowed to a spender.
281    * approve should be called when allowed_[_spender] == 0. To increment
282    * allowed value is better to use this function to avoid 2 calls (and wait until
283    * the first transaction is mined)
284    * From MonolithDAO Token.sol
285    * @param spender The address which will spend the funds.
286    * @param addedValue The amount of tokens to increase the allowance by.
287    */
288   function increaseAllowance(
289     address spender,
290     uint256 addedValue
291   )
292     public
293     returns (bool)
294   {
295     require(spender != address(0));
296 
297     _allowed[msg.sender][spender] = (
298       _allowed[msg.sender][spender].add(addedValue));
299     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
300     return true;
301   }
302 
303   /**
304    * @dev Decrease the amount of tokens that an owner allowed to a spender.
305    * approve should be called when allowed_[_spender] == 0. To decrement
306    * allowed value is better to use this function to avoid 2 calls (and wait until
307    * the first transaction is mined)
308    * From MonolithDAO Token.sol
309    * @param spender The address which will spend the funds.
310    * @param subtractedValue The amount of tokens to decrease the allowance by.
311    */
312   function decreaseAllowance(
313     address spender,
314     uint256 subtractedValue
315   )
316     public
317     returns (bool)
318   {
319     require(spender != address(0));
320 
321     _allowed[msg.sender][spender] = (
322       _allowed[msg.sender][spender].sub(subtractedValue));
323     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
324     return true;
325   }
326 
327   /**
328   * @dev Transfer token for a specified addresses
329   * @param from The address to transfer from.
330   * @param to The address to transfer to.
331   * @param value The amount to be transferred.
332   */
333   function _transfer(address from, address to, uint256 value) internal {
334     require(value <= _balances[from]);
335     require(to != address(0));
336 
337     _balances[from] = _balances[from].sub(value);
338     _balances[to] = _balances[to].add(value);
339     emit Transfer(from, to, value);
340   }
341 
342   /**
343    * @dev Internal function that mints an amount of the token and assigns it to
344    * an account. This encapsulates the modification of balances such that the
345    * proper events are emitted.
346    * @param account The account that will receive the created tokens.
347    * @param value The amount that will be created.
348    */
349   function _mint(address account, uint256 value) internal {
350     require(account != 0);
351     _totalSupply = _totalSupply.add(value);
352     _balances[account] = _balances[account].add(value);
353     emit Transfer(address(0), account, value);
354   }
355 
356   /**
357    * @dev Internal function that burns an amount of the token of a given
358    * account.
359    * @param account The account whose tokens will be burnt.
360    * @param value The amount that will be burnt.
361    */
362   function _burn(address account, uint256 value) internal {
363     require(account != 0);
364     require(value <= _balances[account]);
365 
366     _totalSupply = _totalSupply.sub(value);
367     _balances[account] = _balances[account].sub(value);
368     emit Transfer(account, address(0), value);
369   }
370 
371   /**
372    * @dev Internal function that burns an amount of the token of a given
373    * account, deducting from the sender's allowance for said account. Uses the
374    * internal burn function.
375    * @param account The account whose tokens will be burnt.
376    * @param value The amount that will be burnt.
377    */
378   function _burnFrom(address account, uint256 value) internal {
379     require(value <= _allowed[account][msg.sender]);
380 
381     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
382     // this function needs to emit an event with the updated approval.
383     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
384       value);
385     _burn(account, value);
386   }
387 }
388 
389 // File: contracts/TokenDistributor.sol
390 
391 contract TokenDistributor is Ownable {
392   using SafeMath for uint256;
393 
394   // Event
395   event Started();
396   event AssignToken(address indexed account, uint256 value);
397   event ClaimToken(address indexed account, uint256 value);
398 
399   // State
400   ERC20 private _token;
401   bool private _started;
402   mapping (address => uint256) private _tokens;
403   uint256 private _totalToken;
404 
405   constructor(ERC20 token) public {
406     require(token != address(0));
407 
408     _token = token;
409     _started = false;
410   }
411 
412   /**
413    * @dev Modifier to make a function callable only when the contract is started
414    */
415   modifier whenStarted() {
416     require(_started);
417     _;
418   }
419 
420   /**
421    * @dev Modifier to make a function callable only when the contract is not started
422    */
423   modifier whenNotStarted() {
424     require(!_started);
425     _;
426   }
427 
428   /**
429    * @dev Start the distribution
430    */
431   function start() public onlyOwner whenNotStarted {
432     require(_token.balanceOf(address(this)) == _totalToken);
433 
434     _started = true;
435     emit Started();
436   }
437 
438   /**
439    * @dev Check distribution status
440    */
441   function isStarted() public view returns (bool) {
442     return _started;
443   }
444 
445   /**
446    * @dev Total number of tokens to distribution
447    */
448   function totalToken() public view returns (uint256) {
449     return _totalToken;
450   }
451 
452   /**
453    * @dev Get number of token for the specified address
454    * @param account The address to query the balance of.
455    * @return An uint256 representing the distribution amount for the passed address.
456    */
457   function tokenOf(address account) public view returns (uint256) {
458     return _tokens[account];
459   }
460 
461   /**
462    * @dev Assign token to the specified address
463    * @param account The address to be assigned.
464    * @param value The token amount to be distributed.
465    */
466   function assignToken(address account, uint256 value) public onlyOwner whenNotStarted {
467     require(account != address(0));
468     require(_tokens[account] == 0);
469 
470     _totalToken = _totalToken.add(value);
471     _tokens[account] = value;
472 
473     emit AssignToken(account, value);
474   }
475 
476   /**
477    * @dev Multiple assign token to the list of specified address
478    * @param accounts The list of address to be assigned.
479    * @param values The list of token amount to be distributed.
480    */
481   function multipleAssignToken(address[] accounts, uint256[] values) public {
482     require(accounts.length > 0);
483     require(accounts.length == values.length);
484 
485     for (uint256 i = 0; i < accounts.length; i++) {
486       assignToken(accounts[i], values[i]);
487     }
488   }
489 
490   /**
491    * @dev Claim token for current sender
492    */
493   function claimToken() public {
494     claimTokenFor(msg.sender);
495   }
496 
497   /**
498    * @dev Claim token for the specified address
499    * @param account The address to be distributed.
500    */
501   function claimTokenFor(address account) public whenStarted {
502     require(account != address(0));
503 
504     uint256 value = _tokens[account];
505     require(value > 0);
506 
507     _tokens[account] = 0;
508     _token.transfer(account, value);
509 
510     emit ClaimToken(account, value);
511   }
512 
513   /**
514    * @dev Multiple claim token for the list of specified address
515    * @param accounts The list of address to be claimed.
516    */
517   function multipleClaimToken(address[] accounts) public {
518     require(accounts.length > 0);
519 
520     for (uint256 i = 0; i < accounts.length; i++) {
521       claimTokenFor(accounts[i]);
522     }
523   }
524 
525   /**
526    * @dev Withdraw excess token to the specified address
527    * @param account The address to transfer to.
528    */
529   function withdrawExcessToken(address account) public onlyOwner {
530     require(account != address(0));
531 
532     uint256 contractToken = _token.balanceOf(address(this));
533     uint256 excessToken = contractToken.sub(_totalToken);
534     require(excessToken > 0);
535 
536     _token.transfer(account, excessToken);
537   }
538 }