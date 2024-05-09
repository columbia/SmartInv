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
37 
38 
39 
40 
41 
42 
43 
44 /**
45  * @title SafeMath
46  * @dev Math operations with safety checks that revert on error
47  */
48 library SafeMath {
49 
50   /**
51   * @dev Multiplies two numbers, reverts on overflow.
52   */
53   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
54     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
55     // benefit is lost if 'b' is also tested.
56     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
57     if (a == 0) {
58       return 0;
59     }
60 
61     uint256 c = a * b;
62     require(c / a == b);
63 
64     return c;
65   }
66 
67   /**
68   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
69   */
70   function div(uint256 a, uint256 b) internal pure returns (uint256) {
71     require(b > 0); // Solidity only automatically asserts when dividing by 0
72     uint256 c = a / b;
73     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
74 
75     return c;
76   }
77 
78   /**
79   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
80   */
81   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
82     require(b <= a);
83     uint256 c = a - b;
84 
85     return c;
86   }
87 
88   /**
89   * @dev Adds two numbers, reverts on overflow.
90   */
91   function add(uint256 a, uint256 b) internal pure returns (uint256) {
92     uint256 c = a + b;
93     require(c >= a);
94 
95     return c;
96   }
97 
98   /**
99   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
100   * reverts when dividing by zero.
101   */
102   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
103     require(b != 0);
104     return a % b;
105   }
106 }
107 
108 
109 /**
110  * @title Standard ERC20 token
111  *
112  * @dev Implementation of the basic standard token.
113  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
114  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
115  */
116 contract ERC20 is IERC20 {
117   using SafeMath for uint256;
118 
119   mapping (address => uint256) private _balances;
120 
121   mapping (address => mapping (address => uint256)) private _allowed;
122 
123   uint256 private _totalSupply;
124 
125   /**
126   * @dev Total number of tokens in existence
127   */
128   function totalSupply() public view returns (uint256) {
129     return _totalSupply;
130   }
131 
132   /**
133   * @dev Gets the balance of the specified address.
134   * @param owner The address to query the balance of.
135   * @return An uint256 representing the amount owned by the passed address.
136   */
137   function balanceOf(address owner) public view returns (uint256) {
138     return _balances[owner];
139   }
140 
141   /**
142    * @dev Function to check the amount of tokens that an owner allowed to a spender.
143    * @param owner address The address which owns the funds.
144    * @param spender address The address which will spend the funds.
145    * @return A uint256 specifying the amount of tokens still available for the spender.
146    */
147   function allowance(
148     address owner,
149     address spender
150    )
151     public
152     view
153     returns (uint256)
154   {
155     return _allowed[owner][spender];
156   }
157 
158   /**
159   * @dev Transfer token for a specified address
160   * @param to The address to transfer to.
161   * @param value The amount to be transferred.
162   */
163   function transfer(address to, uint256 value) public returns (bool) {
164     _transfer(msg.sender, to, value);
165     return true;
166   }
167 
168   /**
169    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
170    * Beware that changing an allowance with this method brings the risk that someone may use both the old
171    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
172    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
173    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
174    * @param spender The address which will spend the funds.
175    * @param value The amount of tokens to be spent.
176    */
177   function approve(address spender, uint256 value) public returns (bool) {
178     require(spender != address(0));
179 
180     _allowed[msg.sender][spender] = value;
181     emit Approval(msg.sender, spender, value);
182     return true;
183   }
184 
185   /**
186    * @dev Transfer tokens from one address to another
187    * @param from address The address which you want to send tokens from
188    * @param to address The address which you want to transfer to
189    * @param value uint256 the amount of tokens to be transferred
190    */
191   function transferFrom(
192     address from,
193     address to,
194     uint256 value
195   )
196     public
197     returns (bool)
198   {
199     require(value <= _allowed[from][msg.sender]);
200 
201     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
202     _transfer(from, to, value);
203     return true;
204   }
205 
206   /**
207    * @dev Increase the amount of tokens that an owner allowed to a spender.
208    * approve should be called when allowed_[_spender] == 0. To increment
209    * allowed value is better to use this function to avoid 2 calls (and wait until
210    * the first transaction is mined)
211    * From MonolithDAO Token.sol
212    * @param spender The address which will spend the funds.
213    * @param addedValue The amount of tokens to increase the allowance by.
214    */
215   function increaseAllowance(
216     address spender,
217     uint256 addedValue
218   )
219     public
220     returns (bool)
221   {
222     require(spender != address(0));
223 
224     _allowed[msg.sender][spender] = (
225       _allowed[msg.sender][spender].add(addedValue));
226     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
227     return true;
228   }
229 
230   /**
231    * @dev Decrease the amount of tokens that an owner allowed to a spender.
232    * approve should be called when allowed_[_spender] == 0. To decrement
233    * allowed value is better to use this function to avoid 2 calls (and wait until
234    * the first transaction is mined)
235    * From MonolithDAO Token.sol
236    * @param spender The address which will spend the funds.
237    * @param subtractedValue The amount of tokens to decrease the allowance by.
238    */
239   function decreaseAllowance(
240     address spender,
241     uint256 subtractedValue
242   )
243     public
244     returns (bool)
245   {
246     require(spender != address(0));
247 
248     _allowed[msg.sender][spender] = (
249       _allowed[msg.sender][spender].sub(subtractedValue));
250     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
251     return true;
252   }
253 
254   /**
255   * @dev Transfer token for a specified addresses
256   * @param from The address to transfer from.
257   * @param to The address to transfer to.
258   * @param value The amount to be transferred.
259   */
260   function _transfer(address from, address to, uint256 value) internal {
261     require(value <= _balances[from]);
262     require(to != address(0));
263 
264     _balances[from] = _balances[from].sub(value);
265     _balances[to] = _balances[to].add(value);
266     emit Transfer(from, to, value);
267   }
268 
269   /**
270    * @dev Internal function that mints an amount of the token and assigns it to
271    * an account. This encapsulates the modification of balances such that the
272    * proper events are emitted.
273    * @param account The account that will receive the created tokens.
274    * @param value The amount that will be created.
275    */
276   function _mint(address account, uint256 value) internal {
277     require(account != 0);
278     _totalSupply = _totalSupply.add(value);
279     _balances[account] = _balances[account].add(value);
280     emit Transfer(address(0), account, value);
281   }
282 
283   /**
284    * @dev Internal function that burns an amount of the token of a given
285    * account.
286    * @param account The account whose tokens will be burnt.
287    * @param value The amount that will be burnt.
288    */
289   function _burn(address account, uint256 value) internal {
290     require(account != 0);
291     require(value <= _balances[account]);
292 
293     _totalSupply = _totalSupply.sub(value);
294     _balances[account] = _balances[account].sub(value);
295     emit Transfer(account, address(0), value);
296   }
297 
298   /**
299    * @dev Internal function that burns an amount of the token of a given
300    * account, deducting from the sender's allowance for said account. Uses the
301    * internal burn function.
302    * @param account The account whose tokens will be burnt.
303    * @param value The amount that will be burnt.
304    */
305   function _burnFrom(address account, uint256 value) internal {
306     require(value <= _allowed[account][msg.sender]);
307 
308     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
309     // this function needs to emit an event with the updated approval.
310     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
311       value);
312     _burn(account, value);
313   }
314 }
315 
316 
317 /**
318  * @title Burnable Token
319  * @dev Token that can be irreversibly burned (destroyed).
320  */
321 contract ERC20Burnable is ERC20 {
322 
323   /**
324    * @dev Burns a specific amount of tokens.
325    * @param value The amount of token to be burned.
326    */
327   function burn(uint256 value) public {
328     _burn(msg.sender, value);
329   }
330 
331   /**
332    * @dev Burns a specific amount of tokens from the target address and decrements allowance
333    * @param from address The address which you want to send tokens from
334    * @param value uint256 The amount of token to be burned
335    */
336   function burnFrom(address from, uint256 value) public {
337     _burnFrom(from, value);
338   }
339 }
340 
341 
342 
343 
344 
345 /**
346  * @title ERC20Detailed token
347  * @dev The decimals are only for visualization purposes.
348  * All the operations are done using the smallest and indivisible token unit,
349  * just as on Ethereum all the operations are done in wei.
350  */
351 contract ERC20Detailed is IERC20 {
352   string private _name;
353   string private _symbol;
354   uint8 private _decimals;
355 
356   constructor(string name, string symbol, uint8 decimals) public {
357     _name = name;
358     _symbol = symbol;
359     _decimals = decimals;
360   }
361 
362   /**
363    * @return the name of the token.
364    */
365   function name() public view returns(string) {
366     return _name;
367   }
368 
369   /**
370    * @return the symbol of the token.
371    */
372   function symbol() public view returns(string) {
373     return _symbol;
374   }
375 
376   /**
377    * @return the number of decimals of the token.
378    */
379   function decimals() public view returns(uint8) {
380     return _decimals;
381   }
382 }
383 
384 
385 contract BToken is ERC20Burnable, ERC20Detailed {
386   uint constant private INITIAL_SUPPLY = 10 * 1e24;
387   
388   constructor() ERC20Detailed("BurnToken", "BUTK", 18) public {
389     super._mint(msg.sender, INITIAL_SUPPLY);
390   }
391 }