1 pragma solidity 0.5.6;
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
13   external view returns (uint256);
14 
15   function transfer(address to, uint256 value) external returns (bool);
16 
17   function approve(address spender, uint256 value)
18   external returns (bool);
19 
20   function transferFrom(address from, address to, uint256 value)
21   external returns (bool);
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
37  * @title SafeMath
38  * @dev Unsigned math operations with safety checks that revert on error
39  */
40 library SafeMath {
41   /**
42    * @dev Multiplies two unsigned integers, reverts on overflow.
43    */
44   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
45     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
46     // benefit is lost if 'b' is also tested.
47     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
48     if (a == 0) {
49       return 0;
50     }
51 
52     uint256 c = a * b;
53     require(c / a == b);
54 
55     return c;
56   }
57 
58   /**
59    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
60    */
61   function div(uint256 a, uint256 b) internal pure returns (uint256) {
62     // Solidity only automatically asserts when dividing by 0
63     require(b > 0);
64     uint256 c = a / b;
65     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
66 
67     return c;
68   }
69 
70   /**
71    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
72    */
73   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
74     require(b <= a);
75     uint256 c = a - b;
76 
77     return c;
78   }
79 
80   /**
81    * @dev Adds two unsigned integers, reverts on overflow.
82    */
83   function add(uint256 a, uint256 b) internal pure returns (uint256) {
84     uint256 c = a + b;
85     require(c >= a);
86 
87     return c;
88   }
89 
90   /**
91    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
92    * reverts when dividing by zero.
93    */
94   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
95     require(b != 0);
96     return a % b;
97   }
98 }
99 
100 /**
101  * @title Standard ERC20 token
102  *
103  * @dev Implementation of the basic standard token.
104  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
105  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
106  */
107 contract ERC20 is IERC20 {
108   using SafeMath for uint256;
109 
110   mapping (address => uint256) private _balances;
111 
112   mapping (address => mapping (address => uint256)) private _allowed;
113 
114   uint256 private _totalSupply;
115 
116   /**
117   * @dev Total number of tokens in existence
118   */
119   function totalSupply() public view returns (uint256) {
120     return _totalSupply;
121   }
122 
123   /**
124   * @dev Gets the balance of the specified address.
125   * @param owner The address to query the balance of.
126   * @return An uint256 representing the amount owned by the passed address.
127   */
128   function balanceOf(address owner) public view returns (uint256) {
129     return _balances[owner];
130   }
131 
132   /**
133    * @dev Function to check the amount of tokens that an owner allowed to a spender.
134    * @param owner address The address which owns the funds.
135    * @param spender address The address which will spend the funds.
136    * @return A uint256 specifying the amount of tokens still available for the spender.
137    */
138   function allowance(
139     address owner,
140     address spender
141   )
142   public
143   view
144   returns (uint256)
145   {
146     return _allowed[owner][spender];
147   }
148 
149   /**
150   * @dev Transfer token for a specified address
151   * @param to The address to transfer to.
152   * @param value The amount to be transferred.
153   */
154   function transfer(address to, uint256 value) public returns (bool) {
155     _transfer(msg.sender, to, value);
156 
157     return true;
158   }
159 
160   /**
161    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
162    * Beware that changing an allowance with this method brings the risk that someone may use both the old
163    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
164    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
165    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
166    * @param spender The address which will spend the funds.
167    * @param value The amount of tokens to be spent.
168    */
169   function approve(address spender, uint256 value) public returns (bool) {
170     require(spender != address(0));
171 
172     _allowed[msg.sender][spender] = value;
173 
174     emit Approval(msg.sender, spender, value);
175 
176     return true;
177   }
178 
179   /**
180    * @dev Transfer tokens from one address to another
181    * @param from address The address which you want to send tokens from
182    * @param to address The address which you want to transfer to
183    * @param value uint256 the amount of tokens to be transferred
184    */
185   function transferFrom(
186     address from,
187     address to,
188     uint256 value
189   )
190   public
191   returns (bool)
192   {
193     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
194     _transfer(from, to, value);
195 
196     return true;
197   }
198 
199   /**
200    * @dev Increase the amount of tokens that an owner allowed to a spender.
201    * approve should be called when allowed_[_spender] == 0. To increment
202    * allowed value is better to use this function to avoid 2 calls (and wait until
203    * the first transaction is mined)
204    * From MonolithDAO Token.sol
205    * @param spender The address which will spend the funds.
206    * @param addedValue The amount of tokens to increase the allowance by.
207    */
208   function increaseAllowance(
209     address spender,
210     uint256 addedValue
211   )
212   public
213   returns (bool)
214   {
215     require(spender != address(0));
216 
217     _allowed[msg.sender][spender] = (
218     _allowed[msg.sender][spender].add(addedValue));
219 
220     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
221 
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
245 
246     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
247 
248     return true;
249   }
250 
251   /**
252   * @dev Transfer token for a specified addresses
253   * @param from The address to transfer from.
254   * @param to The address to transfer to.
255   * @param value The amount to be transferred.
256   */
257   function _transfer(address from, address to, uint256 value) internal {
258     require(to != address(0));
259 
260     _balances[from] = _balances[from].sub(value);
261     _balances[to] = _balances[to].add(value);
262 
263     emit Transfer(from, to, value);
264   }
265 
266   /**
267    * @dev Internal function that mints an amount of the token and assigns it to
268    * an account. This encapsulates the modification of balances such that the
269    * proper events are emitted.
270    * @param account The account that will receive the created tokens.
271    * @param value The amount that will be created.
272    */
273   function _mint(address account, uint256 value) internal {
274     require(account != address(0));
275 
276     _totalSupply = _totalSupply.add(value);
277     _balances[account] = _balances[account].add(value);
278 
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
289     require(account != address(0));
290 
291     _totalSupply = _totalSupply.sub(value);
292     _balances[account] = _balances[account].sub(value);
293 
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
305     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
306     // this function needs to emit an event with the updated approval.
307     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
308       value);
309     _burn(account, value);
310   }
311 }
312 
313 /**
314  * @title SafeERC20
315  * @dev Wrappers around ERC20 operations that throw on failure.
316  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
317  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
318  */
319 library SafeERC20 {
320 
321   using SafeMath for uint256;
322 
323   function safeTransfer(
324     IERC20 token,
325     address to,
326     uint256 value
327   )
328   internal
329   {
330     require(token.transfer(to, value));
331   }
332 
333   function safeTransferFrom(
334     IERC20 token,
335     address from,
336     address to,
337     uint256 value
338   )
339   internal
340   {
341     require(token.transferFrom(from, to, value));
342   }
343 
344   function safeApprove(
345     IERC20 token,
346     address spender,
347     uint256 value
348   )
349   internal
350   {
351     // safeApprove should only be called when setting an initial allowance,
352     // or when resetting it to zero. To increase and decrease it, use
353     // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
354     require((value == 0) || (token.allowance(msg.sender, spender) == 0));
355     require(token.approve(spender, value));
356   }
357 
358   function safeIncreaseAllowance(
359     IERC20 token,
360     address spender,
361     uint256 value
362   )
363   internal
364   {
365     uint256 newAllowance = token.allowance(address(this), spender).add(value);
366     require(token.approve(spender, newAllowance));
367   }
368 
369   function safeDecreaseAllowance(
370     IERC20 token,
371     address spender,
372     uint256 value
373   )
374   internal
375   {
376     uint256 newAllowance = token.allowance(address(this), spender).sub(value);
377     require(token.approve(spender, newAllowance));
378   }
379 }
380 
381 /**
382  * @title ERC20Detailed token
383  * @dev The decimals are only for visualization purposes.
384  * All the operations are done using the smallest and indivisible token unit,
385  * just as on Ethereum all the operations are done in wei.
386  */
387 contract ERC20Detailed is IERC20 {
388   string private _name;
389   string private _symbol;
390   uint8 private _decimals;
391 
392   constructor(string memory name, string memory symbol, uint8 decimals) public {
393     _name = name;
394     _symbol = symbol;
395     _decimals = decimals;
396   }
397 
398   /**
399    * @return the name of the token.
400    */
401   function name() public view returns(string memory) {
402     return _name;
403   }
404 
405   /**
406    * @return the symbol of the token.
407    */
408   function symbol() public view returns(string memory) {
409     return _symbol;
410   }
411 
412   /**
413    * @return the number of decimals of the token.
414    */
415   function decimals() public view returns(uint8) {
416     return _decimals;
417   }
418 }
419 
420 contract Ownable {
421   address payable public owner;
422   /**
423    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
424    * account.
425    */
426   constructor() public {
427     owner = msg.sender;
428   }
429   /**
430    * @dev Throws if called by any account other than the owner.
431    */
432   modifier onlyOwner() {
433     require(msg.sender == owner);
434     _;
435   }
436   function transferOwnership(address payable newOwner) public onlyOwner {
437     require(newOwner != address(0));
438     owner = newOwner;
439   }
440 }
441 
442 
443 
444 contract GameWave is ERC20, ERC20Detailed, Ownable {
445 
446   uint paymentsTime = block.timestamp;
447   uint totalPaymentAmount;
448   uint lastTotalPaymentAmount;
449   uint minted = 20000000;
450 
451   mapping (address => uint256) lastWithdrawTime;
452 
453   /**
454    * @dev The GW constructor sets the original variables
455    * specified in the contract ERC20Detailed.
456    */
457   constructor() public ERC20Detailed("Game wave token", "GWT", 18) {
458     _mint(msg.sender, minted * (10 ** uint256(decimals())));
459   }
460 
461   /**
462     * Fallback function
463     *
464     * The function without name is the default function that is called whenever anyone sends funds to a contract.
465     */
466   function () payable external {
467     if (msg.value == 0){
468       withdrawDividends(msg.sender);
469     }
470   }
471 
472   /**
473     * @notice This function allows the investor to see the amount of dividends available for withdrawal.
474     * @param _holder this is the address of the investor, where you can see the number of diverders available for withdrawal.
475     * @return An uint the value available for the removal of dividends.
476     */
477   function getDividends(address _holder) view public returns(uint) {
478     if (paymentsTime >= lastWithdrawTime[_holder]){
479       return totalPaymentAmount.mul(balanceOf(_holder)).div(minted * (10 ** uint256(decimals())));
480     } else {
481       return 0;
482     }
483   }
484 
485   /**
486     * @notice This function allows the investor to withdraw dividends available for withdrawal.
487     * @param _holder this is the address of the investor, by which there is a withdrawal available to dividend.
488     * @return An uint value of removed dividends.
489     */
490   function withdrawDividends(address payable _holder) public returns(uint) {
491     uint dividends = getDividends(_holder);
492     lastWithdrawTime[_holder] = block.timestamp;
493     lastTotalPaymentAmount = lastTotalPaymentAmount.add(dividends);
494     _holder.transfer(dividends);
495   }
496 
497   /**
498   * @notice This function initializes payments with a period of 30 days.
499   *
500   */
501 
502   function startPayments() public {
503     require(block.timestamp >= paymentsTime + 30 days);
504     owner.transfer(totalPaymentAmount.sub(lastTotalPaymentAmount));
505     totalPaymentAmount = address(this).balance;
506     paymentsTime = block.timestamp;
507     lastTotalPaymentAmount = 0;
508   }
509 }