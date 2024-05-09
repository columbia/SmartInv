1 pragma solidity ^0.4.24;
2 
3 interface IERC20 {
4   function totalSupply() external view returns (uint256);
5 
6   function balanceOf(address who) external view returns (uint256);
7 
8   function allowance(address owner, address spender)
9     external view returns (uint256);
10 
11   function transfer(address to, uint256 value) external returns (bool);
12 
13   function approve(address spender, uint256 value)
14     external returns (bool);
15 
16   function transferFrom(address from, address to, uint256 value)
17     external returns (bool);
18 
19   event Transfer(
20     address indexed from,
21     address indexed to,
22     uint256 value
23   );
24 
25   event Approval(
26     address indexed owner,
27     address indexed spender,
28     uint256 value
29   );
30 }
31 
32 
33 
34 /**
35  * @title Standard ERC20 token
36  *
37  * @dev Implementation of the basic standard token.
38  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
39  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
40  */
41 contract ERC20 is IERC20 {
42   using SafeMath for uint256;
43 
44   mapping (address => uint256) private _balances;
45 
46   mapping (address => mapping (address => uint256)) private _allowed;
47 
48   uint256 private _totalSupply;
49 
50   /**
51   * @dev Total number of tokens in existence
52   */
53   function totalSupply() public view returns (uint256) {
54     return _totalSupply;
55   }
56 
57   /**
58   * @dev Gets the balance of the specified address.
59   * @param owner The address to query the balance of.
60   * @return An uint256 representing the amount owned by the passed address.
61   */
62   function balanceOf(address owner) public view returns (uint256) {
63     return _balances[owner];
64   }
65 
66   /**
67    * @dev Function to check the amount of tokens that an owner allowed to a spender.
68    * @param owner address The address which owns the funds.
69    * @param spender address The address which will spend the funds.
70    * @return A uint256 specifying the amount of tokens still available for the spender.
71    */
72   function allowance(
73     address owner,
74     address spender
75    )
76     public
77     view
78     returns (uint256)
79   {
80     return _allowed[owner][spender];
81   }
82 
83   /**
84   * @dev Transfer token for a specified address
85   * @param to The address to transfer to.
86   * @param value The amount to be transferred.
87   */
88   function transfer(address to, uint256 value) public returns (bool) {
89     _transfer(msg.sender, to, value);
90     return true;
91   }
92 
93   /**
94    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
95    * Beware that changing an allowance with this method brings the risk that someone may use both the old
96    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
97    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
98    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
99    * @param spender The address which will spend the funds.
100    * @param value The amount of tokens to be spent.
101    */
102   function approve(address spender, uint256 value) public returns (bool) {
103     require(spender != address(0));
104 
105     _allowed[msg.sender][spender] = value;
106     emit Approval(msg.sender, spender, value);
107     return true;
108   }
109 
110   /**
111    * @dev Transfer tokens from one address to another
112    * @param from address The address which you want to send tokens from
113    * @param to address The address which you want to transfer to
114    * @param value uint256 the amount of tokens to be transferred
115    */
116   function transferFrom(
117     address from,
118     address to,
119     uint256 value
120   )
121     public
122     returns (bool)
123   {
124     require(value <= _allowed[from][msg.sender]);
125 
126     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
127     _transfer(from, to, value);
128     return true;
129   }
130 
131   /**
132    * @dev Increase the amount of tokens that an owner allowed to a spender.
133    * approve should be called when allowed_[_spender] == 0. To increment
134    * allowed value is better to use this function to avoid 2 calls (and wait until
135    * the first transaction is mined)
136    * From MonolithDAO Token.sol
137    * @param spender The address which will spend the funds.
138    * @param addedValue The amount of tokens to increase the allowance by.
139    */
140   function increaseAllowance(
141     address spender,
142     uint256 addedValue
143   )
144     public
145     returns (bool)
146   {
147     require(spender != address(0));
148 
149     _allowed[msg.sender][spender] = (
150       _allowed[msg.sender][spender].add(addedValue));
151     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
152     return true;
153   }
154 
155   /**
156    * @dev Decrease the amount of tokens that an owner allowed to a spender.
157    * approve should be called when allowed_[_spender] == 0. To decrement
158    * allowed value is better to use this function to avoid 2 calls (and wait until
159    * the first transaction is mined)
160    * From MonolithDAO Token.sol
161    * @param spender The address which will spend the funds.
162    * @param subtractedValue The amount of tokens to decrease the allowance by.
163    */
164   function decreaseAllowance(
165     address spender,
166     uint256 subtractedValue
167   )
168     public
169     returns (bool)
170   {
171     require(spender != address(0));
172 
173     _allowed[msg.sender][spender] = (
174       _allowed[msg.sender][spender].sub(subtractedValue));
175     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
176     return true;
177   }
178 
179   /**
180   * @dev Transfer token for a specified addresses
181   * @param from The address to transfer from.
182   * @param to The address to transfer to.
183   * @param value The amount to be transferred.
184   */
185   function _transfer(address from, address to, uint256 value) internal {
186     require(value <= _balances[from]);
187     require(to != address(0));
188 
189     _balances[from] = _balances[from].sub(value);
190     _balances[to] = _balances[to].add(value);
191     emit Transfer(from, to, value);
192   }
193 
194   /**
195    * @dev Internal function that mints an amount of the token and assigns it to
196    * an account. This encapsulates the modification of balances such that the
197    * proper events are emitted.
198    * @param account The account that will receive the created tokens.
199    * @param value The amount that will be created.
200    */
201   function _mint(address account, uint256 value) internal {
202     require(account != 0);
203     _totalSupply = _totalSupply.add(value);
204     _balances[account] = _balances[account].add(value);
205     emit Transfer(address(0), account, value);
206   }
207 
208   /**
209    * @dev Internal function that burns an amount of the token of a given
210    * account.
211    * @param account The account whose tokens will be burnt.
212    * @param value The amount that will be burnt.
213    */
214   function _burn(address account, uint256 value) internal {
215     require(account != 0);
216     require(value <= _balances[account]);
217 
218     _totalSupply = _totalSupply.sub(value);
219     _balances[account] = _balances[account].sub(value);
220     emit Transfer(account, address(0), value);
221   }
222 
223   /**
224    * @dev Internal function that burns an amount of the token of a given
225    * account, deducting from the sender's allowance for said account. Uses the
226    * internal burn function.
227    * @param account The account whose tokens will be burnt.
228    * @param value The amount that will be burnt.
229    */
230   function _burnFrom(address account, uint256 value) internal {
231     require(value <= _allowed[account][msg.sender]);
232 
233     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
234     // this function needs to emit an event with the updated approval.
235     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
236       value);
237     _burn(account, value);
238   }
239 }
240 
241 
242 
243 /**
244  * @title SafeERC20
245  * @dev Wrappers around ERC20 operations that throw on failure.
246  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
247  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
248  */
249 library SafeERC20 {
250   function safeTransfer(
251     IERC20 token,
252     address to,
253     uint256 value
254   )
255     internal
256   {
257     require(token.transfer(to, value));
258   }
259 
260   function safeTransferFrom(
261     IERC20 token,
262     address from,
263     address to,
264     uint256 value
265   )
266     internal
267   {
268     require(token.transferFrom(from, to, value));
269   }
270 
271   function safeApprove(
272     IERC20 token,
273     address spender,
274     uint256 value
275   )
276     internal
277   {
278     require(token.approve(spender, value));
279   }
280 }
281 
282 
283 
284 
285 
286 
287 
288 /**
289  * @title SafeMath
290  * @dev Math operations with safety checks that revert on error
291  */
292 library SafeMath {
293 
294   /**
295   * @dev Multiplies two numbers, reverts on overflow.
296   */
297   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
298     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
299     // benefit is lost if 'b' is also tested.
300     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
301     if (a == 0) {
302       return 0;
303     }
304 
305     uint256 c = a * b;
306     require(c / a == b);
307 
308     return c;
309   }
310 
311   /**
312   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
313   */
314   function div(uint256 a, uint256 b) internal pure returns (uint256) {
315     require(b > 0); // Solidity only automatically asserts when dividing by 0
316     uint256 c = a / b;
317     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
318 
319     return c;
320   }
321 
322   /**
323   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
324   */
325   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
326     require(b <= a);
327     uint256 c = a - b;
328 
329     return c;
330   }
331 
332   /**
333   * @dev Adds two numbers, reverts on overflow.
334   */
335   function add(uint256 a, uint256 b) internal pure returns (uint256) {
336     uint256 c = a + b;
337     require(c >= a);
338 
339     return c;
340   }
341 
342   /**
343   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
344   * reverts when dividing by zero.
345   */
346   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
347     require(b != 0);
348     return a % b;
349   }
350 }
351 
352 
353 contract BurnContract{
354 
355   IERC20 public cVToken;
356   address public constant burnAddress = address(1);
357   uint256 private AmountBurned;
358 
359   uint256 private previousBurnBalance;
360 
361   using SafeMath for uint256;
362   using SafeERC20 for IERC20;
363 
364   constructor(IERC20 _cVToken)public{
365     AmountBurned = 0;
366     cVToken = _cVToken;
367     previousBurnBalance = 0;
368   }
369 
370   event Burn(uint256 amount);
371 
372   function burn() public returns(bool){
373 
374     uint256 contractBalance = cVToken.balanceOf(address(this)); //Take current t
375     cVToken.safeTransfer(burnAddress, contractBalance);
376 
377     uint256 currentBurnBalance = cVToken.balanceOf(burnAddress);
378 
379     uint256 BurnedAmount = currentBurnBalance.sub(previousBurnBalance);
380 
381     emit Burn(BurnedAmount);
382 
383     AmountBurned = currentBurnBalance;
384     previousBurnBalance = AmountBurned;
385 
386     return true;
387 
388   }
389 
390   function getToken()public view returns(IERC20){
391     return cVToken;
392   }
393 
394   function getAmountBurned()public view returns(uint256){
395     return cVToken.balanceOf(burnAddress);
396   }
397 
398   function getAddress()public view returns(address){
399     return address(this);
400   }
401 
402   function getBurnAddress()public view returns(address){
403     return address(burnAddress);
404   }
405 
406   function getAdjustedTotalSupply()public view returns(uint256){
407     uint256 originalTotalSupply = cVToken.totalSupply();
408     uint256 amountBurned = getAmountBurned();
409 
410     uint256 adjustedTotalSupply = originalTotalSupply.sub(amountBurned);
411 
412     return adjustedTotalSupply;
413   }
414 
415 }