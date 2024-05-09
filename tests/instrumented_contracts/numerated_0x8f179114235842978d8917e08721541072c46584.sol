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
66 /**
67  * @title ERC20 interface
68  * @dev see https://github.com/ethereum/EIPs/issues/20
69  */
70 interface IERC20 {
71   function totalSupply() external view returns (uint256);
72 
73   function balanceOf(address who) external view returns (uint256);
74 
75   function allowance(address owner, address spender)
76     external view returns (uint256);
77 
78   function transfer(address to, uint256 value) external returns (bool);
79 
80   function approve(address spender, uint256 value)
81     external returns (bool);
82 
83   function transferFrom(address from, address to, uint256 value)
84     external returns (bool);
85 
86   event Transfer(
87     address indexed from,
88     address indexed to,
89     uint256 value
90   );
91 
92   event Approval(
93     address indexed owner,
94     address indexed spender,
95     uint256 value
96   );
97 }
98 /**
99  * @title Standard ERC20 token
100  *
101  * @dev Implementation of the basic standard token.
102  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
103  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
104  */
105 contract ERC20 is IERC20 {
106   using SafeMath for uint256;
107 
108   mapping (address => uint256) private _balances;
109 
110   mapping (address => mapping (address => uint256)) private _allowed;
111 
112   uint256 private _totalSupply;
113 
114   /**
115   * @dev Total number of tokens in existence
116   */
117   function totalSupply() public view returns (uint256) {
118     return _totalSupply;
119   }
120 
121   /**
122   * @dev Gets the balance of the specified address.
123   * @param owner The address to query the balance of.
124   * @return An uint256 representing the amount owned by the passed address.
125   */
126   function balanceOf(address owner) public view returns (uint256) {
127     return _balances[owner];
128   }
129 
130   /**
131    * @dev Function to check the amount of tokens that an owner allowed to a spender.
132    * @param owner address The address which owns the funds.
133    * @param spender address The address which will spend the funds.
134    * @return A uint256 specifying the amount of tokens still available for the spender.
135    */
136   function allowance(
137     address owner,
138     address spender
139    )
140     public
141     view
142     returns (uint256)
143   {
144     return _allowed[owner][spender];
145   }
146 
147   /**
148   * @dev Transfer token for a specified address
149   * @param to The address to transfer to.
150   * @param value The amount to be transferred.
151   */
152   function transfer(address to, uint256 value) public returns (bool) {
153     _transfer(msg.sender, to, value);
154     return true;
155   }
156 
157   /**
158    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
159    * Beware that changing an allowance with this method brings the risk that someone may use both the old
160    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
161    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
162    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
163    * @param spender The address which will spend the funds.
164    * @param value The amount of tokens to be spent.
165    */
166   function approve(address spender, uint256 value) public returns (bool) {
167     require(spender != address(0));
168 
169     _allowed[msg.sender][spender] = value;
170     emit Approval(msg.sender, spender, value);
171     return true;
172   }
173 
174   /**
175    * @dev Transfer tokens from one address to another
176    * @param from address The address which you want to send tokens from
177    * @param to address The address which you want to transfer to
178    * @param value uint256 the amount of tokens to be transferred
179    */
180   function transferFrom(
181     address from,
182     address to,
183     uint256 value
184   )
185     public
186     returns (bool)
187   {
188     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
189     _transfer(from, to, value);
190     return true;
191   }
192 
193   /**
194    * @dev Increase the amount of tokens that an owner allowed to a spender.
195    * approve should be called when allowed_[_spender] == 0. To increment
196    * allowed value is better to use this function to avoid 2 calls (and wait until
197    * the first transaction is mined)
198    * From MonolithDAO Token.sol
199    * @param spender The address which will spend the funds.
200    * @param addedValue The amount of tokens to increase the allowance by.
201    */
202   function increaseAllowance(
203     address spender,
204     uint256 addedValue
205   )
206     public
207     returns (bool)
208   {
209     require(spender != address(0));
210 
211     _allowed[msg.sender][spender] = (
212       _allowed[msg.sender][spender].add(addedValue));
213     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
214     return true;
215   }
216 
217   /**
218    * @dev Decrease the amount of tokens that an owner allowed to a spender.
219    * approve should be called when allowed_[_spender] == 0. To decrement
220    * allowed value is better to use this function to avoid 2 calls (and wait until
221    * the first transaction is mined)
222    * From MonolithDAO Token.sol
223    * @param spender The address which will spend the funds.
224    * @param subtractedValue The amount of tokens to decrease the allowance by.
225    */
226   function decreaseAllowance(
227     address spender,
228     uint256 subtractedValue
229   )
230     public
231     returns (bool)
232   {
233     require(spender != address(0));
234 
235     _allowed[msg.sender][spender] = (
236       _allowed[msg.sender][spender].sub(subtractedValue));
237     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
238     return true;
239   }
240 
241   /**
242   * @dev Transfer token for a specified addresses
243   * @param from The address to transfer from.
244   * @param to The address to transfer to.
245   * @param value The amount to be transferred.
246   */
247   function _transfer(address from, address to, uint256 value) internal {
248     require(to != address(0));
249 
250     _balances[from] = _balances[from].sub(value);
251     _balances[to] = _balances[to].add(value);
252     emit Transfer(from, to, value);
253   }
254 
255   /**
256    * @dev Internal function that mints an amount of the token and assigns it to
257    * an account. This encapsulates the modification of balances such that the
258    * proper events are emitted.
259    * @param account The account that will receive the created tokens.
260    * @param value The amount that will be created.
261    */
262   function _mint(address account, uint256 value) internal {
263     require(account != address(0));
264 
265     _totalSupply = _totalSupply.add(value);
266     _balances[account] = _balances[account].add(value);
267     emit Transfer(address(0), account, value);
268   }
269 
270   /**
271    * @dev Internal function that burns an amount of the token of a given
272    * account.
273    * @param account The account whose tokens will be burnt.
274    * @param value The amount that will be burnt.
275    */
276   function _burn(address account, uint256 value) internal {
277     require(account != address(0));
278 
279     _totalSupply = _totalSupply.sub(value);
280     _balances[account] = _balances[account].sub(value);
281     emit Transfer(account, address(0), value);
282   }
283 
284   /**
285    * @dev Internal function that burns an amount of the token of a given
286    * account, deducting from the sender's allowance for said account. Uses the
287    * internal burn function.
288    * @param account The account whose tokens will be burnt.
289    * @param value The amount that will be burnt.
290    */
291   function _burnFrom(address account, uint256 value) internal {
292     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
293     // this function needs to emit an event with the updated approval.
294     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
295       value);
296     _burn(account, value);
297   }
298 }
299 /**
300  * @title Burnable Token
301  * @dev Token that can be irreversibly burned (destroyed).
302  */
303 contract ERC20Burnable is ERC20 {
304 
305   /**
306    * @dev Burns a specific amount of tokens.
307    * @param value The amount of token to be burned.
308    */
309   function burn(uint256 value) public {
310     _burn(msg.sender, value);
311   }
312 
313   /**
314    * @dev Burns a specific amount of tokens from the target address and decrements allowance
315    * @param from address The address which you want to send tokens from
316    * @param value uint256 The amount of token to be burned
317    */
318   function burnFrom(address from, uint256 value) public {
319     _burnFrom(from, value);
320   }
321 }
322 /**
323  * @title ERC20Detailed token
324  * @dev The decimals are only for visualization purposes.
325  * All the operations are done using the smallest and indivisible token unit,
326  * just as on Ethereum all the operations are done in wei.
327  */
328 contract ERC20Detailed is IERC20 {
329   string private _name;
330   string private _symbol;
331   uint8 private _decimals;
332 
333   constructor(string name, string symbol, uint8 decimals) public {
334     _name = name;
335     _symbol = symbol;
336     _decimals = decimals;
337   }
338 
339   /**
340    * @return the name of the token.
341    */
342   function name() public view returns(string) {
343     return _name;
344   }
345 
346   /**
347    * @return the symbol of the token.
348    */
349   function symbol() public view returns(string) {
350     return _symbol;
351   }
352 
353   /**
354    * @return the number of decimals of the token.
355    */
356   function decimals() public view returns(uint8) {
357     return _decimals;
358   }
359 }
360 /**
361  * @title Standard ERC20 token
362  *
363  * @dev Implementation of the basic standard token.
364  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
365  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
366  *
367  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
368  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
369  * compliant implementations may not do it.
370  *
371  */
372 contract PPToken is ERC20, ERC20Detailed, ERC20Burnable {
373     uint256 public constant INITIAL_SUPPLY = 1000000000000;
374 
375     /**
376      * @dev Constructor that gives msg.sender all of existing tokens.
377      */
378     constructor () public ERC20Detailed("PointPay Token", "PXP", 3) {
379         _mint(msg.sender, INITIAL_SUPPLY);
380     }
381     function getNow() public view returns(uint256) {
382         return now;
383     }
384 }