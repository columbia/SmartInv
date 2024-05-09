1 pragma solidity ^0.4.24;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that revert on error
5  */
6 library SafeMath {
7 
8   /**
9   * @dev Multiplies two numbers, reverts on overflow.
10   */
11   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
13     // benefit is lost if 'b' is also tested.
14     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15     if (a == 0) {
16       return 0;
17     }
18 
19     uint256 c = a * b;
20     require(c / a == b);
21 
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     require(b > 0); // Solidity only automatically asserts when dividing by 0
30     uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32 
33     return c;
34   }
35 
36   /**
37   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40     require(b <= a);
41     uint256 c = a - b;
42 
43     return c;
44   }
45 
46   /**
47   * @dev Adds two numbers, reverts on overflow.
48   */
49   function add(uint256 a, uint256 b) internal pure returns (uint256) {
50     uint256 c = a + b;
51     require(c >= a);
52 
53     return c;
54   }
55 
56   /**
57   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
58   * reverts when dividing by zero.
59   */
60   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
61     require(b != 0);
62     return a % b;
63   }
64 }
65 
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
98 
99 /**
100  * @title ERC20Detailed token
101  * @dev The decimals are only for visualization purposes.
102  * All the operations are done using the smallest and indivisible token unit,
103  * just as on Ethereum all the operations are done in wei.
104  */
105 contract ERC20Detailed is IERC20 {
106   string private _name;
107   string private _symbol;
108   uint8 private _decimals;
109 
110   constructor(string name, string symbol, uint8 decimals) public {
111     _name = name;
112     _symbol = symbol;
113     _decimals = decimals;
114   }
115 
116   /**
117    * @return the name of the token.
118    */
119   function name() public view returns(string) {
120     return _name;
121   }
122 
123   /**
124    * @return the symbol of the token.
125    */
126   function symbol() public view returns(string) {
127     return _symbol;
128   }
129 
130   /**
131    * @return the number of decimals of the token.
132    */
133   function decimals() public view returns(uint8) {
134     return _decimals;
135   }
136 }
137 
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
193     _transfer(msg.sender, to, value);
194     return true;
195   }
196 
197   /**
198    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
199    * Beware that changing an allowance with this method brings the risk that someone may use both the old
200    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
201    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
202    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
203    * @param spender The address which will spend the funds.
204    * @param value The amount of tokens to be spent.
205    */
206   function approve(address spender, uint256 value) public returns (bool) {
207     require(spender != address(0));
208 
209     _allowed[msg.sender][spender] = value;
210     emit Approval(msg.sender, spender, value);
211     return true;
212   }
213 
214   /**
215    * @dev Transfer tokens from one address to another
216    * @param from address The address which you want to send tokens from
217    * @param to address The address which you want to transfer to
218    * @param value uint256 the amount of tokens to be transferred
219    */
220   function transferFrom(
221     address from,
222     address to,
223     uint256 value
224   )
225     public
226     returns (bool)
227   {
228     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
229     _transfer(from, to, value);
230     return true;
231   }
232 
233   /**
234    * @dev Increase the amount of tokens that an owner allowed to a spender.
235    * approve should be called when allowed_[_spender] == 0. To increment
236    * allowed value is better to use this function to avoid 2 calls (and wait until
237    * the first transaction is mined)
238    * From MonolithDAO Token.sol
239    * @param spender The address which will spend the funds.
240    * @param addedValue The amount of tokens to increase the allowance by.
241    */
242   function increaseAllowance(
243     address spender,
244     uint256 addedValue
245   )
246     public
247     returns (bool)
248   {
249     require(spender != address(0));
250 
251     _allowed[msg.sender][spender] = (
252       _allowed[msg.sender][spender].add(addedValue));
253     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
254     return true;
255   }
256 
257   /**
258    * @dev Decrease the amount of tokens that an owner allowed to a spender.
259    * approve should be called when allowed_[_spender] == 0. To decrement
260    * allowed value is better to use this function to avoid 2 calls (and wait until
261    * the first transaction is mined)
262    * From MonolithDAO Token.sol
263    * @param spender The address which will spend the funds.
264    * @param subtractedValue The amount of tokens to decrease the allowance by.
265    */
266   function decreaseAllowance(
267     address spender,
268     uint256 subtractedValue
269   )
270     public
271     returns (bool)
272   {
273     require(spender != address(0));
274 
275     _allowed[msg.sender][spender] = (
276       _allowed[msg.sender][spender].sub(subtractedValue));
277     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
278     return true;
279   }
280 
281   /**
282   * @dev Transfer token for a specified addresses
283   * @param from The address to transfer from.
284   * @param to The address to transfer to.
285   * @param value The amount to be transferred.
286   */
287   function _transfer(address from, address to, uint256 value) internal {
288     require(to != address(0));
289 
290     _balances[from] = _balances[from].sub(value);
291     _balances[to] = _balances[to].add(value);
292     emit Transfer(from, to, value);
293   }
294 
295   /**
296    * @dev Internal function that mints an amount of the token and assigns it to
297    * an account. This encapsulates the modification of balances such that the
298    * proper events are emitted.
299    * @param account The account that will receive the created tokens.
300    * @param value The amount that will be created.
301    */
302   function _mint(address account, uint256 value) internal {
303     require(account != address(0));
304 
305     _totalSupply = _totalSupply.add(value);
306     _balances[account] = _balances[account].add(value);
307     emit Transfer(address(0), account, value);
308   }
309 
310   /**
311    * @dev Internal function that burns an amount of the token of a given
312    * account.
313    * @param account The account whose tokens will be burnt.
314    * @param value The amount that will be burnt.
315    */
316   function _burn(address account, uint256 value) internal {
317     require(account != address(0));
318 
319     _totalSupply = _totalSupply.sub(value);
320     _balances[account] = _balances[account].sub(value);
321     emit Transfer(account, address(0), value);
322   }
323 
324   /**
325    * @dev Internal function that burns an amount of the token of a given
326    * account, deducting from the sender's allowance for said account. Uses the
327    * internal burn function.
328    * @param account The account whose tokens will be burnt.
329    * @param value The amount that will be burnt.
330    */
331   function _burnFrom(address account, uint256 value) internal {
332     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
333     // this function needs to emit an event with the updated approval.
334     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
335       value);
336     _burn(account, value);
337   }
338 }
339 
340 /**
341  * @title SimpleToken
342  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
343  * Note they can later distribute these tokens as they wish using `transfer` and other
344  * `ERC20` functions.
345  */
346 contract Token is ERC20, ERC20Detailed {
347   /**
348    * @dev Constructor that gives msg.sender all of existing tokens.
349    */
350   constructor() public ERC20Detailed("ABC", "ABC", 18) {
351     _mint(msg.sender, 99999999999*(10**18));
352   }
353 }