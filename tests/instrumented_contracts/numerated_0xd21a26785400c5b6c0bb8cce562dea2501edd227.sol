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
36 /**
37  * @title Standard ERC20 token
38  *
39  * @dev Implementation of the basic standard token.
40  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
41  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
42  */
43 contract ERC20 is IERC20 {
44   using SafeMath for uint256;
45 
46   mapping (address => uint256) private _balances;
47 
48   mapping (address => mapping (address => uint256)) private _allowed;
49 
50   uint256 private _totalSupply;
51 
52   /**
53   * @dev Total number of tokens in existence
54   */
55   function totalSupply() public view returns (uint256) {
56     return _totalSupply;
57   }
58 
59   /**
60   * @dev Gets the balance of the specified address.
61   * @param owner The address to query the balance of.
62   * @return An uint256 representing the amount owned by the passed address.
63   */
64   function balanceOf(address owner) public view returns (uint256) {
65     return _balances[owner];
66   }
67 
68   /**
69    * @dev Function to check the amount of tokens that an owner allowed to a spender.
70    * @param owner address The address which owns the funds.
71    * @param spender address The address which will spend the funds.
72    * @return A uint256 specifying the amount of tokens still available for the spender.
73    */
74   function allowance(
75     address owner,
76     address spender
77    )
78     public
79     view
80     returns (uint256)
81   {
82     return _allowed[owner][spender];
83   }
84 
85   /**
86   * @dev Transfer token for a specified address
87   * @param to The address to transfer to.
88   * @param value The amount to be transferred.
89   */
90   function transfer(address to, uint256 value) public returns (bool) {
91     _transfer(msg.sender, to, value);
92     return true;
93   }
94 
95   /**
96    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
97    * Beware that changing an allowance with this method brings the risk that someone may use both the old
98    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
99    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
100    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
101    * @param spender The address which will spend the funds.
102    * @param value The amount of tokens to be spent.
103    */
104   function approve(address spender, uint256 value) public returns (bool) {
105     require(spender != address(0));
106 
107     _allowed[msg.sender][spender] = value;
108     emit Approval(msg.sender, spender, value);
109     return true;
110   }
111 
112   /**
113    * @dev Transfer tokens from one address to another
114    * @param from address The address which you want to send tokens from
115    * @param to address The address which you want to transfer to
116    * @param value uint256 the amount of tokens to be transferred
117    */
118   function transferFrom(
119     address from,
120     address to,
121     uint256 value
122   )
123     public
124     returns (bool)
125   {
126     require(value <= _allowed[from][msg.sender]);
127 
128     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
129     _transfer(from, to, value);
130     return true;
131   }
132 
133   /**
134    * @dev Increase the amount of tokens that an owner allowed to a spender.
135    * approve should be called when allowed_[_spender] == 0. To increment
136    * allowed value is better to use this function to avoid 2 calls (and wait until
137    * the first transaction is mined)
138    * From MonolithDAO Token.sol
139    * @param spender The address which will spend the funds.
140    * @param addedValue The amount of tokens to increase the allowance by.
141    */
142   function increaseAllowance(
143     address spender,
144     uint256 addedValue
145   )
146     public
147     returns (bool)
148   {
149     require(spender != address(0));
150 
151     _allowed[msg.sender][spender] = (
152       _allowed[msg.sender][spender].add(addedValue));
153     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
154     return true;
155   }
156 
157   /**
158    * @dev Decrease the amount of tokens that an owner allowed to a spender.
159    * approve should be called when allowed_[_spender] == 0. To decrement
160    * allowed value is better to use this function to avoid 2 calls (and wait until
161    * the first transaction is mined)
162    * From MonolithDAO Token.sol
163    * @param spender The address which will spend the funds.
164    * @param subtractedValue The amount of tokens to decrease the allowance by.
165    */
166   function decreaseAllowance(
167     address spender,
168     uint256 subtractedValue
169   )
170     public
171     returns (bool)
172   {
173     require(spender != address(0));
174 
175     _allowed[msg.sender][spender] = (
176       _allowed[msg.sender][spender].sub(subtractedValue));
177     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
178     return true;
179   }
180 
181   /**
182   * @dev Transfer token for a specified addresses
183   * @param from The address to transfer from.
184   * @param to The address to transfer to.
185   * @param value The amount to be transferred.
186   */
187   function _transfer(address from, address to, uint256 value) internal {
188     require(value <= _balances[from]);
189     require(to != address(0));
190 
191     _balances[from] = _balances[from].sub(value);
192     _balances[to] = _balances[to].add(value);
193     emit Transfer(from, to, value);
194   }
195 
196   /**
197    * @dev Internal function that mints an amount of the token and assigns it to
198    * an account. This encapsulates the modification of balances such that the
199    * proper events are emitted.
200    * @param account The account that will receive the created tokens.
201    * @param value The amount that will be created.
202    */
203   function _mint(address account, uint256 value) internal {
204     require(account != 0);
205     _totalSupply = _totalSupply.add(value);
206     _balances[account] = _balances[account].add(value);
207     emit Transfer(address(0), account, value);
208   }
209 
210   /**
211    * @dev Internal function that burns an amount of the token of a given
212    * account.
213    * @param account The account whose tokens will be burnt.
214    * @param value The amount that will be burnt.
215    */
216   function _burn(address account, uint256 value) internal {
217     require(account != 0);
218     require(value <= _balances[account]);
219 
220     _totalSupply = _totalSupply.sub(value);
221     _balances[account] = _balances[account].sub(value);
222     emit Transfer(account, address(0), value);
223   }
224 
225   /**
226    * @dev Internal function that burns an amount of the token of a given
227    * account, deducting from the sender's allowance for said account. Uses the
228    * internal burn function.
229    * @param account The account whose tokens will be burnt.
230    * @param value The amount that will be burnt.
231    */
232   function _burnFrom(address account, uint256 value) internal {
233     require(value <= _allowed[account][msg.sender]);
234 
235     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
236     // this function needs to emit an event with the updated approval.
237     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
238       value);
239     _burn(account, value);
240   }
241 }
242 
243 /**
244  * @title SafeMath
245  * @dev Math operations with safety checks that revert on error
246  */
247 library SafeMath {
248 
249   /**
250   * @dev Multiplies two numbers, reverts on overflow.
251   */
252   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
253     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
254     // benefit is lost if 'b' is also tested.
255     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
256     if (a == 0) {
257       return 0;
258     }
259 
260     uint256 c = a * b;
261     require(c / a == b);
262 
263     return c;
264   }
265 
266   /**
267   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
268   */
269   function div(uint256 a, uint256 b) internal pure returns (uint256) {
270     require(b > 0); // Solidity only automatically asserts when dividing by 0
271     uint256 c = a / b;
272     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
273 
274     return c;
275   }
276 
277   /**
278   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
279   */
280   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
281     require(b <= a);
282     uint256 c = a - b;
283 
284     return c;
285   }
286 
287   /**
288   * @dev Adds two numbers, reverts on overflow.
289   */
290   function add(uint256 a, uint256 b) internal pure returns (uint256) {
291     uint256 c = a + b;
292     require(c >= a);
293 
294     return c;
295   }
296 
297   /**
298   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
299   * reverts when dividing by zero.
300   */
301   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
302     require(b != 0);
303     return a % b;
304   }
305 }
306 
307 /**
308  * @title SixCoin
309  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
310  * Note they can later distribute these tokens as they wish using `transfer` and other
311  * `ERC20` functions.
312  */
313 contract SixCoin is ERC20 {
314 
315   string public constant name = "666Coin";
316   string public constant symbol = "666";
317   uint8 public constant decimals = 18;
318 
319   uint256 public constant INITIAL_SUPPLY = 100000000 * (10 ** uint256(decimals));
320 
321   /**
322    * @dev Constructor that gives msg.sender all of existing tokens.
323    */
324   constructor() public {
325     _mint(0xf0EeC8C518e399E4BA26656A31bDC442A5c456FA, 50000000 * (10 ** uint256(decimals)));
326     _mint(0x7d5253EF9bfe1Ec1D0DB7bCA774396F6A06bF675, 50000000 * (10 ** uint256(decimals)));
327   }
328 
329 }