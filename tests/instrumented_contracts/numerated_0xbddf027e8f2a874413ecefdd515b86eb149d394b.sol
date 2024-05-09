1 pragma solidity "0.4.24";
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
24   event Approval(
25     address indexed owner,
26     address indexed spender,
27     uint256 value
28   );
29 }
30 
31 library SafeMath {
32 
33   /**
34   * @dev Multiplies two numbers, reverts on overflow.
35   */
36   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
37     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
38     // benefit is lost if 'b' is also tested.
39     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
40     if (a == 0) {
41       return 0;
42     }
43 
44     uint256 c = a * b;
45     require(c / a == b);
46 
47     return c;
48   }
49 
50   /**
51   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
52   */
53   function div(uint256 a, uint256 b) internal pure returns (uint256) {
54     require(b > 0); // Solidity only automatically asserts when dividing by 0
55     uint256 c = a / b;
56     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
57 
58     return c;
59   }
60 
61   /**
62   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
63   */
64   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
65     require(b <= a);
66     uint256 c = a - b;
67 
68     return c;
69   }
70 
71   /**
72   * @dev Adds two numbers, reverts on overflow.
73   */
74   function add(uint256 a, uint256 b) internal pure returns (uint256) {
75     uint256 c = a + b;
76     require(c >= a);
77 
78     return c;
79   }
80 
81   /**
82   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
83   * reverts when dividing by zero.
84   */
85   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
86     require(b != 0);
87     return a % b;
88   }
89 }
90 
91 library Roles {
92   struct Role {
93     mapping (address => bool) bearer;
94   }
95 
96   /**
97    * @dev give an account access to this role
98    */
99   function add(Role storage role, address account) internal {
100     require(account != address(0));
101     role.bearer[account] = true;
102   }
103 
104   /**
105    * @dev remove an account's access to this role
106    */
107   function remove(Role storage role, address account) internal {
108     require(account != address(0));
109     role.bearer[account] = false;
110   }
111 
112   /**
113    * @dev check if an account has this role
114    * @return bool
115    */
116   function has(Role storage role, address account)
117     internal
118     view
119     returns (bool)
120   {
121     require(account != address(0));
122     return role.bearer[account];
123   }
124 }
125 
126 contract Ownable {
127   address private _owner;
128 
129   event OwnershipRenounced(address indexed previousOwner);
130   event OwnershipTransferred(
131     address indexed previousOwner,
132     address indexed newOwner
133   );
134 
135   /**
136    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
137    * account.
138    */
139   constructor() public {
140     _owner = msg.sender;
141   }
142 
143   /**
144    * @return the address of the owner.
145    */
146   function owner() public view returns(address) {
147     return _owner;
148   }
149 
150   /**
151    * @dev Throws if called by any account other than the owner.
152    */
153   modifier onlyOwner() {
154     require(isOwner());
155     _;
156   }
157 
158   /**
159    * @return true if `msg.sender` is the owner of the contract.
160    */
161   function isOwner() public view returns(bool) {
162     return msg.sender == _owner;
163   }
164 
165   /**
166    * @dev Allows the current owner to relinquish control of the contract.
167    * @notice Renouncing to ownership will leave the contract without an owner.
168    * It will not be possible to call the functions with the `onlyOwner`
169    * modifier anymore.
170    */
171   function renounceOwnership() public onlyOwner {
172     emit OwnershipRenounced(_owner);
173     _owner = address(0);
174   }
175 
176   /**
177    * @dev Allows the current owner to transfer control of the contract to a newOwner.
178    * @param newOwner The address to transfer ownership to.
179    */
180   function transferOwnership(address newOwner) public onlyOwner {
181     _transferOwnership(newOwner);
182   }
183 
184   /**
185    * @dev Transfers control of the contract to a newOwner.
186    * @param newOwner The address to transfer ownership to.
187    */
188   function _transferOwnership(address newOwner) internal {
189     require(newOwner != address(0));
190     emit OwnershipTransferred(_owner, newOwner);
191     _owner = newOwner;
192   }
193 }
194 
195 
196 contract ERC20Detailed is IERC20 {
197   string private _name;
198   string private _symbol;
199   uint8 private _decimals;
200 
201   constructor(string name, string symbol, uint8 decimals) public {
202     _name = name;
203     _symbol = symbol;
204     _decimals = decimals;
205   }
206 
207   /**
208    * @return the name of the token.
209    */
210   function name() public view returns(string) {
211     return _name;
212   }
213 
214   /**
215    * @return the symbol of the token.
216    */
217   function symbol() public view returns(string) {
218     return _symbol;
219   }
220 
221   /**
222    * @return the number of decimals of the token.
223    */
224   function decimals() public view returns(uint8) {
225     return _decimals;
226   }
227 }
228 
229 
230 
231 /**
232  * Putting everything together
233  */
234 contract TwerkToken is ERC20Detailed, Ownable {
235 
236     string   constant TOKEN_NAME = "Twerk";
237     string   constant TOKEN_SYMBOL = "TWERK";
238     uint8    constant TOKEN_DECIMALS = 18;
239 
240     uint256  TOTAL_SUPPLY = 21000000  * (10 ** uint256(TOKEN_DECIMALS));
241 
242     mapping(address => uint) balances;
243     mapping(address => mapping(address => uint)) allowed;
244 
245     constructor() public payable
246         ERC20Detailed(TOKEN_NAME, TOKEN_SYMBOL, TOKEN_DECIMALS)
247         Ownable() {
248 
249         _mint(owner(), TOTAL_SUPPLY);
250     }
251     
252     using SafeMath for uint256;
253 
254   mapping (address => uint256) private _balances;
255 
256   mapping (address => mapping (address => uint256)) private _allowed;
257 
258   uint256 private _totalSupply;
259 
260   /**
261   * @dev Total number of tokens in existence
262   */
263   function totalSupply() public view returns (uint256) {
264     return _totalSupply;
265   }
266 
267   /**
268   * @dev Gets the balance of the specified address.
269   * @param owner The address to query the balance of.
270   * @return An uint256 representing the amount owned by the passed address.
271   */
272   function balanceOf(address owner) public view returns (uint256) {
273     return _balances[owner];
274   }
275 
276   /**
277    * @dev Function to check the amount of tokens that an owner allowed to a spender.
278    * @param owner address The address which owns the funds.
279    * @param spender address The address which will spend the funds.
280    * @return A uint256 specifying the amount of tokens still available for the spender.
281    */
282   function allowance(
283     address owner,
284     address spender
285    )
286     public
287     view
288     returns (uint256)
289   {
290     return _allowed[owner][spender];
291   }
292 
293   /**
294   * @dev Transfer token for a specified address
295   * @param to The address to transfer to.
296   * @param value The amount to be transferred.
297   */
298   function transfer(address to, uint256 value) public returns (bool) {
299     require(value <= _balances[msg.sender]);
300     require(to != address(0));
301 
302     _balances[msg.sender] = _balances[msg.sender].sub(value);
303     
304      uint256 onePercent = value / 100;
305      uint256 receivedTokens = value - onePercent;
306     
307     _balances[to] = _balances[to].add(receivedTokens);
308     
309     if(_totalSupply > 0){
310         _totalSupply = _totalSupply - onePercent;
311     } 
312     
313     emit Transfer(msg.sender, to, receivedTokens);
314     return true;
315   }
316 
317   /**
318    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
319    * Beware that changing an allowance with this method brings the risk that someone may use both the old
320    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
321    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
322    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
323    * @param spender The address which will spend the funds.
324    * @param value The amount of tokens to be spent.
325    */
326   function approve(address spender, uint256 value) public returns (bool) {
327     require(spender != address(0));
328 
329     _allowed[msg.sender][spender] = value;
330     emit Approval(msg.sender, spender, value);
331     return true;
332   }
333 
334   /**
335    * @dev Transfer tokens from one address to another
336    * @param from address The address which you want to send tokens from
337    * @param to address The address which you want to transfer to
338    * @param value uint256 the amount of tokens to be transferred
339    */
340   function transferFrom(
341     address from,
342     address to,
343     uint256 value
344   )
345     public
346     returns (bool)
347   {
348     require(value <= _balances[from]);
349     require(value <= _allowed[from][msg.sender]);
350     require(to != address(0));
351 
352     _balances[from] = _balances[from].sub(value);
353     
354      uint256 onePercent = value / 100;
355      uint256 receivedTokens = value - onePercent;
356     
357     _balances[to] = _balances[to].add(receivedTokens);
358     
359     if(_totalSupply > 0){
360         _totalSupply = _totalSupply - onePercent;
361     }
362     
363     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
364     emit Transfer(from, to, receivedTokens);
365     return true;
366   }
367 
368   /**
369    * @dev Increase the amount of tokens that an owner allowed to a spender.
370    * approve should be called when allowed_[_spender] == 0. To increment
371    * allowed value is better to use this function to avoid 2 calls (and wait until
372    * the first transaction is mined)
373    * From MonolithDAO Token.sol
374    * @param spender The address which will spend the funds.
375    * @param addedValue The amount of tokens to increase the allowance by.
376    */
377   function increaseAllowance(
378     address spender,
379     uint256 addedValue
380   )
381     public
382     returns (bool)
383   {
384     require(spender != address(0));
385 
386     _allowed[msg.sender][spender] = (
387       _allowed[msg.sender][spender].add(addedValue));
388     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
389     return true;
390   }
391 
392   /**
393    * @dev Decrease the amount of tokens that an owner allowed to a spender.
394    * approve should be called when allowed_[_spender] == 0. To decrement
395    * allowed value is better to use this function to avoid 2 calls (and wait until
396    * the first transaction is mined)
397    * From MonolithDAO Token.sol
398    * @param spender The address which will spend the funds.
399    * @param subtractedValue The amount of tokens to decrease the allowance by.
400    */
401   function decreaseAllowance(
402     address spender,
403     uint256 subtractedValue
404   )
405     public
406     returns (bool)
407   {
408     require(spender != address(0));
409 
410     _allowed[msg.sender][spender] = (
411       _allowed[msg.sender][spender].sub(subtractedValue));
412     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
413     return true;
414   }
415 
416   /**
417    * @dev Internal function that mints an amount of the token and assigns it to
418    * an account. This encapsulates the modification of balances such that the
419    * proper events are emitted.
420    * @param account The account that will receive the created tokens.
421    * @param amount The amount that will be created.
422    */
423   function _mint(address account, uint256 amount) internal {
424     require(account != 0);
425     _totalSupply = _totalSupply.add(amount);
426     _balances[account] = _balances[account].add(amount);
427     emit Transfer(address(0), account, amount);
428   }
429 
430   /**
431    * @dev Internal function that burns an amount of the token of a given
432    * account.
433    * @param account The account whose tokens will be burnt.
434    * @param amount The amount that will be burnt.
435    */
436   function _burn(address account, uint256 amount) internal {
437     require(account != 0);
438     require(amount <= _balances[account]);
439 
440     _totalSupply = _totalSupply.sub(amount);
441     _balances[account] = _balances[account].sub(amount);
442     emit Transfer(account, address(0), amount);
443   }
444 
445   /**
446    * @dev Internal function that burns an amount of the token of a given
447    * account, deducting from the sender's allowance for said account. Uses the
448    * internal burn function.
449    * @param account The account whose tokens will be burnt.
450    * @param amount The amount that will be burnt.
451    */
452   function _burnFrom(address account, uint256 amount) internal {
453     require(amount <= _allowed[account][msg.sender]);
454 
455     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
456     // this function needs to emit an event with the updated approval.
457     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
458       amount);
459     _burn(account, amount);
460   }
461 }