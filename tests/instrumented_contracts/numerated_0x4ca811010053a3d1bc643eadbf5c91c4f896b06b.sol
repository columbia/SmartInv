1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, reverts on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     uint256 c = a * b;
21     require(c / a == b);
22 
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     require(b > 0); // Solidity only automatically asserts when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34     return c;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     require(b <= a);
42     uint256 c = a - b;
43 
44     return c;
45   }
46 
47   /**
48   * @dev Adds two numbers, reverts on overflow.
49   */
50   function add(uint256 a, uint256 b) internal pure returns (uint256) {
51     uint256 c = a + b;
52     require(c >= a);
53 
54     return c;
55   }
56 
57   /**
58   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
59   * reverts when dividing by zero.
60   */
61   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62     require(b != 0);
63     return a % b;
64   }
65 }
66 
67 /**
68  * @title SafeERC20
69  * @dev Wrappers around ERC20 operations that throw on failure.
70  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
71  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
72  */
73 library SafeERC20 {
74   function safeTransfer(
75     IERC20 token,
76     address to,
77     uint256 value
78   )
79     internal
80   {
81     require(token.transfer(to, value));
82   }
83 
84   function safeTransferFrom(
85     IERC20 token,
86     address from,
87     address to,
88     uint256 value
89   )
90     internal
91   {
92     require(token.transferFrom(from, to, value));
93   }
94 
95   function safeApprove(
96     IERC20 token,
97     address spender,
98     uint256 value
99   )
100     internal
101   {
102     require(token.approve(spender, value));
103   }
104 }
105 
106 /**
107  * @title ERC20 interface
108  * @dev see https://github.com/ethereum/EIPs/issues/20
109  */
110 interface IERC20 {
111   function totalSupply() external view returns (uint256);
112 
113   function balanceOf(address who) external view returns (uint256);
114 
115   function allowance(address owner, address spender)
116     external view returns (uint256);
117 
118   function transfer(address to, uint256 value) external returns (bool);
119 
120   function approve(address spender, uint256 value)
121     external returns (bool);
122 
123   function transferFrom(address from, address to, uint256 value)
124     external returns (bool);
125 
126   event Transfer(
127     address indexed from,
128     address indexed to,
129     uint256 value
130   );
131 
132   event Approval(
133     address indexed owner,
134     address indexed spender,
135     uint256 value
136   );
137 }
138 /**
139  * @title Standard ERC20 token
140  *
141  * @dev Implementation of the basic standard token.
142  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
143  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
144  */
145 contract ERC20 is IERC20 {
146   using SafeMath for uint256;
147 
148   mapping (address => uint256) private _balances;
149 
150   mapping (address => mapping (address => uint256)) private _allowed;
151 
152   uint256 private _totalSupply;
153 
154   /**
155   * @dev Total number of tokens in existence
156   */
157   function totalSupply() public view returns (uint256) {
158     return _totalSupply;
159   }
160 
161   /**
162   * @dev Gets the balance of the specified address.
163   * @param owner The address to query the balance of.
164   * @return An uint256 representing the amount owned by the passed address.
165   */
166   function balanceOf(address owner) public view returns (uint256) {
167     return _balances[owner];
168   }
169 
170   /**
171    * @dev Function to check the amount of tokens that an owner allowed to a spender.
172    * @param owner address The address which owns the funds.
173    * @param spender address The address which will spend the funds.
174    * @return A uint256 specifying the amount of tokens still available for the spender.
175    */
176   function allowance(
177     address owner,
178     address spender
179    )
180     public
181     view
182     returns (uint256)
183   {
184     return _allowed[owner][spender];
185   }
186 
187   /**
188   * @dev Transfer token for a specified address
189   * @param to The address to transfer to.
190   * @param value The amount to be transferred.
191   */
192   function transfer(address to, uint256 value) public returns (bool) {
193     require(value <= _balances[msg.sender]);
194     require(to != address(0));
195 
196     _balances[msg.sender] = _balances[msg.sender].sub(value);
197     _balances[to] = _balances[to].add(value);
198     emit Transfer(msg.sender, to, value);
199     return true;
200   }
201 
202   /**
203    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
204    * Beware that changing an allowance with this method brings the risk that someone may use both the old
205    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
206    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
207    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
208    * @param spender The address which will spend the funds.
209    * @param value The amount of tokens to be spent.
210    */
211   function approve(address spender, uint256 value) public returns (bool) {
212     require(spender != address(0));
213 
214     _allowed[msg.sender][spender] = value;
215     emit Approval(msg.sender, spender, value);
216     return true;
217   }
218 
219   /**
220    * @dev Transfer tokens from one address to another
221    * @param from address The address which you want to send tokens from
222    * @param to address The address which you want to transfer to
223    * @param value uint256 the amount of tokens to be transferred
224    */
225   function transferFrom(
226     address from,
227     address to,
228     uint256 value
229   )
230     public
231     returns (bool)
232   {
233     require(value <= _balances[from]);
234     require(value <= _allowed[from][msg.sender]);
235     require(to != address(0));
236 
237     _balances[from] = _balances[from].sub(value);
238     _balances[to] = _balances[to].add(value);
239     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
240     emit Transfer(from, to, value);
241     return true;
242   }
243 
244   /**
245    * @dev Increase the amount of tokens that an owner allowed to a spender.
246    * approve should be called when allowed_[_spender] == 0. To increment
247    * allowed value is better to use this function to avoid 2 calls (and wait until
248    * the first transaction is mined)
249    * From MonolithDAO Token.sol
250    * @param spender The address which will spend the funds.
251    * @param addedValue The amount of tokens to increase the allowance by.
252    */
253   function increaseAllowance(
254     address spender,
255     uint256 addedValue
256   )
257     public
258     returns (bool)
259   {
260     require(spender != address(0));
261 
262     _allowed[msg.sender][spender] = (
263       _allowed[msg.sender][spender].add(addedValue));
264     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
265     return true;
266   }
267 
268   /**
269    * @dev Decrease the amount of tokens that an owner allowed to a spender.
270    * approve should be called when allowed_[_spender] == 0. To decrement
271    * allowed value is better to use this function to avoid 2 calls (and wait until
272    * the first transaction is mined)
273    * From MonolithDAO Token.sol
274    * @param spender The address which will spend the funds.
275    * @param subtractedValue The amount of tokens to decrease the allowance by.
276    */
277   function decreaseAllowance(
278     address spender,
279     uint256 subtractedValue
280   )
281     public
282     returns (bool)
283   {
284     require(spender != address(0));
285 
286     _allowed[msg.sender][spender] = (
287       _allowed[msg.sender][spender].sub(subtractedValue));
288     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
289     return true;
290   }
291 
292   /**
293    * @dev Internal function that mints an amount of the token and assigns it to
294    * an account. This encapsulates the modification of balances such that the
295    * proper events are emitted.
296    * @param account The account that will receive the created tokens.
297    * @param amount The amount that will be created.
298    */
299   function _mint(address account, uint256 amount) internal {
300     require(account != 0);
301     _totalSupply = _totalSupply.add(amount);
302     _balances[account] = _balances[account].add(amount);
303     emit Transfer(address(0), account, amount);
304   }
305 
306   /**
307    * @dev Internal function that burns an amount of the token of a given
308    * account.
309    * @param account The account whose tokens will be burnt.
310    * @param amount The amount that will be burnt.
311    */
312   function _burn(address account, uint256 amount) internal {
313     require(account != 0);
314     require(amount <= _balances[account]);
315 
316     _totalSupply = _totalSupply.sub(amount);
317     _balances[account] = _balances[account].sub(amount);
318     emit Transfer(account, address(0), amount);
319   }
320 
321   /**
322    * @dev Internal function that burns an amount of the token of a given
323    * account, deducting from the sender's allowance for said account. Uses the
324    * internal burn function.
325    * @param account The account whose tokens will be burnt.
326    * @param amount The amount that will be burnt.
327    */
328   function _burnFrom(address account, uint256 amount) internal {
329     require(amount <= _allowed[account][msg.sender]);
330 
331     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
332     // this function needs to emit an event with the updated approval.
333     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
334       amount);
335     _burn(account, amount);
336   }
337 }
338 
339 /**
340  * @title ERC20Detailed token
341  * @dev The decimals are only for visualization purposes.
342  * All the operations are done using the smallest and indivisible token unit,
343  * just as on Ethereum all the operations are done in wei.
344  */
345 contract ERC20Detailed is IERC20 {
346   string private _name;
347   string private _symbol;
348   uint8 private _decimals;
349 
350   constructor(string name, string symbol, uint8 decimals) public {
351     _name = name;
352     _symbol = symbol;
353     _decimals = decimals;
354   }
355 
356   /**
357    * @return the name of the token.
358    */
359   function name() public view returns(string) {
360     return _name;
361   }
362 
363   /**
364    * @return the symbol of the token.
365    */
366   function symbol() public view returns(string) {
367     return _symbol;
368   }
369 
370   /**
371    * @return the number of decimals of the token.
372    */
373   function decimals() public view returns(uint8) {
374     return _decimals;
375   }
376 }
377 
378 /**
379  * @title Burnable Token
380  * @dev Token that can be irreversibly burned (destroyed).
381  */
382 contract ERC20Burnable is ERC20 {
383 
384   /**
385    * @dev Burns a specific amount of tokens.
386    * @param value The amount of token to be burned.
387    */
388   function burn(uint256 value) public {
389     _burn(msg.sender, value);
390   }
391 
392   /**
393    * @dev Burns a specific amount of tokens from the target address and decrements allowance
394    * @param from address The address which you want to send tokens from
395    * @param value uint256 The amount of token to be burned
396    */
397   function burnFrom(address from, uint256 value) public {
398     _burnFrom(from, value);
399   }
400 
401   /**
402    * @dev Overrides ERC20._burn in order for burn and burnFrom to emit
403    * an additional Burn event.
404    */
405   function _burn(address who, uint256 value) internal {
406     super._burn(who, value);
407   }
408 }
409 
410 contract Ejob is ERC20, ERC20Detailed, ERC20Burnable {
411     using SafeERC20 for ERC20;
412 
413     constructor()
414         ERC20Burnable()
415         ERC20Detailed('Ejob', 'EJOB', 18)
416         ERC20()
417         public
418     {
419         _mint(0x653fdd77a87ad48180BDC2Dc9beA5A17e2420CF6, 60000000000 * (10 ** uint256(18)));
420     }
421 }