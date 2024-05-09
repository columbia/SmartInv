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
38  * @title SafeMath
39  * @dev Math operations with safety checks that revert on error
40  */
41 library SafeMath {
42 
43   /**
44   * @dev Multiplies two numbers, reverts on overflow.
45   */
46   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
47     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
48     // benefit is lost if 'b' is also tested.
49     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
50     if (a == 0) {
51       return 0;
52     }
53 
54     uint256 c = a * b;
55     require(c / a == b);
56 
57     return c;
58   }
59 
60   /**
61   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
62   */
63   function div(uint256 a, uint256 b) internal pure returns (uint256) {
64     require(b > 0); // Solidity only automatically asserts when dividing by 0
65     uint256 c = a / b;
66     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
67 
68     return c;
69   }
70 
71   /**
72   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
73   */
74   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
75     require(b <= a);
76     uint256 c = a - b;
77 
78     return c;
79   }
80 
81   /**
82   * @dev Adds two numbers, reverts on overflow.
83   */
84   function add(uint256 a, uint256 b) internal pure returns (uint256) {
85     uint256 c = a + b;
86     require(c >= a);
87 
88     return c;
89   }
90 
91   /**
92   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
93   * reverts when dividing by zero.
94   */
95   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
96     require(b != 0);
97     return a % b;
98   }
99 }
100 
101 
102 /**
103  * @title Standard ERC20 token
104  *
105  * @dev Implementation of the basic standard token.
106  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
107  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
108  */
109 contract ERC20 is IERC20 {
110   using SafeMath for uint256;
111 
112   mapping (address => uint256) private _balances;
113 
114   mapping (address => mapping (address => uint256)) private _allowed;
115 
116   uint256 private _totalSupply;
117 
118   /**
119   * @dev Total number of tokens in existence
120   */
121   function totalSupply() public view returns (uint256) {
122     return _totalSupply;
123   }
124 
125   /**
126   * @dev Gets the balance of the specified address.
127   * @param owner The address to query the the balance of.
128   * @return An uint256 representing the amount owned by the passed address.
129   */
130   function balanceOf(address owner) public view returns (uint256) {
131     return _balances[owner];
132   }
133 
134   /**
135    * @dev Function to check the amount of tokens that an owner allowed to a spender.
136    * @param owner address The address which owns the funds.
137    * @param spender address The address which will spend the funds.
138    * @return A uint256 specifying the amount of tokens still available for the spender.
139    */
140   function allowance(
141     address owner,
142     address spender
143    )
144     public
145     view
146     returns (uint256)
147   {
148     return _allowed[owner][spender];
149   }
150 
151   /**
152   * @dev Transfer token for a specified address
153   * @param to The address to transfer to.
154   * @param value The amount to be transferred.
155   */
156   function transfer(address to, uint256 value) public returns (bool) {
157     require(value <= _balances[msg.sender]);
158     require(to != address(0));
159 
160     _balances[msg.sender] = _balances[msg.sender].sub(value);
161     _balances[to] = _balances[to].add(value);
162     emit Transfer(msg.sender, to, value);
163     return true;
164   }
165 
166   /**
167    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
168    * Beware that changing an allowance with this method brings the risk that someone may use both the old
169    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
170    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
171    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
172    * @param spender The address which will spend the funds.
173    * @param value The amount of tokens to be spent.
174    */
175   function approve(address spender, uint256 value) public returns (bool) {
176     require(spender != address(0));
177 
178     _allowed[msg.sender][spender] = value;
179     emit Approval(msg.sender, spender, value);
180     return true;
181   }
182 
183   /**
184    * @dev Transfer tokens from one address to another
185    * @param from address The address which you want to send tokens from
186    * @param to address The address which you want to transfer to
187    * @param value uint256 the amount of tokens to be transferred
188    */
189   function transferFrom(
190     address from,
191     address to,
192     uint256 value
193   )
194     public
195     returns (bool)
196   {
197     require(value <= _balances[from]);
198     require(value <= _allowed[from][msg.sender]);
199     require(to != address(0));
200 
201     _balances[from] = _balances[from].sub(value);
202     _balances[to] = _balances[to].add(value);
203     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
204     emit Transfer(from, to, value);
205     return true;
206   }
207 
208   /**
209    * @dev Increase the amount of tokens that an owner allowed to a spender.
210    * approve should be called when allowed_[_spender] == 0. To increment
211    * allowed value is better to use this function to avoid 2 calls (and wait until
212    * the first transaction is mined)
213    * From MonolithDAO Token.sol
214    * @param spender The address which will spend the funds.
215    * @param addedValue The amount of tokens to increase the allowance by.
216    */
217   function increaseAllowance(
218     address spender,
219     uint256 addedValue
220   )
221     public
222     returns (bool)
223   {
224     require(spender != address(0));
225 
226     _allowed[msg.sender][spender] = (
227       _allowed[msg.sender][spender].add(addedValue));
228     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
229     return true;
230   }
231 
232   /**
233    * @dev Decrease the amount of tokens that an owner allowed to a spender.
234    * approve should be called when allowed_[_spender] == 0. To decrement
235    * allowed value is better to use this function to avoid 2 calls (and wait until
236    * the first transaction is mined)
237    * From MonolithDAO Token.sol
238    * @param spender The address which will spend the funds.
239    * @param subtractedValue The amount of tokens to decrease the allowance by.
240    */
241   function decreaseAllowance(
242     address spender,
243     uint256 subtractedValue
244   )
245     public
246     returns (bool)
247   {
248     require(spender != address(0));
249 
250     _allowed[msg.sender][spender] = (
251       _allowed[msg.sender][spender].sub(subtractedValue));
252     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
253     return true;
254   }
255 
256   /**
257    * @dev Internal function that mints an amount of the token and assigns it to
258    * an account. This encapsulates the modification of balances such that the
259    * proper events are emitted.
260    * @param account The account that will receive the created tokens.
261    * @param amount The amount that will be created.
262    */
263   function _mint(address account, uint256 amount) internal {
264     require(account != 0);
265     _totalSupply = _totalSupply.add(amount);
266     _balances[account] = _balances[account].add(amount);
267     emit Transfer(address(0), account, amount);
268   }
269 
270   /**
271    * @dev Internal function that burns an amount of the token of a given
272    * account.
273    * @param account The account whose tokens will be burnt.
274    * @param amount The amount that will be burnt.
275    */
276   function _burn(address account, uint256 amount) internal {
277     require(account != 0);
278     require(amount <= _balances[account]);
279 
280     _totalSupply = _totalSupply.sub(amount);
281     _balances[account] = _balances[account].sub(amount);
282     emit Transfer(account, address(0), amount);
283   }
284 
285   /**
286    * @dev Internal function that burns an amount of the token of a given
287    * account, deducting from the sender's allowance for said account. Uses the
288    * internal burn function.
289    * @param account The account whose tokens will be burnt.
290    * @param amount The amount that will be burnt.
291    */
292   function _burnFrom(address account, uint256 amount) internal {
293     require(amount <= _allowed[account][msg.sender]);
294 
295     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
296     // this function needs to emit an event with the updated approval.
297     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
298       amount);
299     _burn(account, amount);
300   }
301 }
302 
303 
304 /**
305  * @title Burnable Token
306  * @dev Token that can be irreversibly burned (destroyed).
307  */
308 contract ERC20Burnable is ERC20 {
309 
310   /**
311    * @dev Burns a specific amount of tokens.
312    * @param value The amount of token to be burned.
313    */
314   function burn(uint256 value) public {
315     _burn(msg.sender, value);
316   }
317 
318   /**
319    * @dev Burns a specific amount of tokens from the target address and decrements allowance
320    * @param from address The address which you want to send tokens from
321    * @param value uint256 The amount of token to be burned
322    */
323   function burnFrom(address from, uint256 value) public {
324     _burnFrom(from, value);
325   }
326 
327   /**
328    * @dev Overrides ERC20._burn in order for burn and burnFrom to emit
329    * an additional Burn event.
330    */
331   function _burn(address who, uint256 value) internal {
332     super._burn(who, value);
333   }
334 }
335 
336 contract LKDToken is ERC20Burnable {
337     string public name = "LakeDiamond Token";
338     string public symbol = "LKD";
339     uint256 public decimals = 0;
340 
341     constructor() public {
342         _mint(msg.sender, 141120000);
343     }
344 }