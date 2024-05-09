1 pragma solidity ^0.4.25;
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
138 
139 /**
140  * @title Standard ERC20 token
141  *
142  * @dev Implementation of the basic standard token.
143  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
144  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
145  */
146 contract ERC20 is IERC20 {
147   using SafeMath for uint256;
148 
149   mapping (address => uint256) private _balances;
150 
151   mapping (address => mapping (address => uint256)) private _allowed;
152 
153   uint256 private _totalSupply;
154 
155   /**
156   * @dev Total number of tokens in existence
157   */
158   function totalSupply() public view returns (uint256) {
159     return _totalSupply;
160   }
161 
162   /**
163   * @dev Gets the balance of the specified address.
164   * @param owner The address to query the balance of.
165   * @return An uint256 representing the amount owned by the passed address.
166   */
167   function balanceOf(address owner) public view returns (uint256) {
168     return _balances[owner];
169   }
170 
171   /**
172    * @dev Function to check the amount of tokens that an owner allowed to a spender.
173    * @param owner address The address which owns the funds.
174    * @param spender address The address which will spend the funds.
175    * @return A uint256 specifying the amount of tokens still available for the spender.
176    */
177   function allowance(
178     address owner,
179     address spender
180    )
181     public
182     view
183     returns (uint256)
184   {
185     return _allowed[owner][spender];
186   }
187 
188   /**
189   * @dev Transfer token for a specified address
190   * @param to The address to transfer to.
191   * @param value The amount to be transferred.
192   */
193   function transfer(address to, uint256 value) public returns (bool) {
194     _transfer(msg.sender, to, value);
195     return true;
196   }
197 
198   /**
199    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
200    * Beware that changing an allowance with this method brings the risk that someone may use both the old
201    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
202    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
203    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
204    * @param spender The address which will spend the funds.
205    * @param value The amount of tokens to be spent.
206    */
207   function approve(address spender, uint256 value) public returns (bool) {
208     require(spender != address(0));
209 
210     _allowed[msg.sender][spender] = value;
211     emit Approval(msg.sender, spender, value);
212     return true;
213   }
214 
215   /**
216    * @dev Transfer tokens from one address to another
217    * @param from address The address which you want to send tokens from
218    * @param to address The address which you want to transfer to
219    * @param value uint256 the amount of tokens to be transferred
220    */
221   function transferFrom(
222     address from,
223     address to,
224     uint256 value
225   )
226     public
227     returns (bool)
228   {
229     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
230     _transfer(from, to, value);
231     return true;
232   }
233 
234   /**
235    * @dev Increase the amount of tokens that an owner allowed to a spender.
236    * approve should be called when allowed_[_spender] == 0. To increment
237    * allowed value is better to use this function to avoid 2 calls (and wait until
238    * the first transaction is mined)
239    * From MonolithDAO Token.sol
240    * @param spender The address which will spend the funds.
241    * @param addedValue The amount of tokens to increase the allowance by.
242    */
243   function increaseAllowance(
244     address spender,
245     uint256 addedValue
246   )
247     public
248     returns (bool)
249   {
250     require(spender != address(0));
251 
252     _allowed[msg.sender][spender] = (
253       _allowed[msg.sender][spender].add(addedValue));
254     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
255     return true;
256   }
257 
258   /**
259    * @dev Decrease the amount of tokens that an owner allowed to a spender.
260    * approve should be called when allowed_[_spender] == 0. To decrement
261    * allowed value is better to use this function to avoid 2 calls (and wait until
262    * the first transaction is mined)
263    * From MonolithDAO Token.sol
264    * @param spender The address which will spend the funds.
265    * @param subtractedValue The amount of tokens to decrease the allowance by.
266    */
267   function decreaseAllowance(
268     address spender,
269     uint256 subtractedValue
270   )
271     public
272     returns (bool)
273   {
274     require(spender != address(0));
275 
276     _allowed[msg.sender][spender] = (
277       _allowed[msg.sender][spender].sub(subtractedValue));
278     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
279     return true;
280   }
281 
282   /**
283   * @dev Transfer token for a specified addresses
284   * @param from The address to transfer from.
285   * @param to The address to transfer to.
286   * @param value The amount to be transferred.
287   */
288   function _transfer(address from, address to, uint256 value) internal {
289     require(to != address(0));
290 
291     _balances[from] = _balances[from].sub(value);
292     _balances[to] = _balances[to].add(value);
293     emit Transfer(from, to, value);
294   }
295 
296   /**
297    * @dev Internal function that mints an amount of the token and assigns it to
298    * an account. This encapsulates the modification of balances such that the
299    * proper events are emitted.
300    * @param account The account that will receive the created tokens.
301    * @param value The amount that will be created.
302    */
303   function _mint(address account, uint256 value) internal {
304     require(account != address(0));
305 
306     _totalSupply = _totalSupply.add(value);
307     _balances[account] = _balances[account].add(value);
308     emit Transfer(address(0), account, value);
309   }
310 
311   /**
312    * @dev Internal function that burns an amount of the token of a given
313    * account.
314    * @param account The account whose tokens will be burnt.
315    * @param value The amount that will be burnt.
316    */
317   function _burn(address account, uint256 value) internal {
318     require(account != address(0));
319 
320     _totalSupply = _totalSupply.sub(value);
321     _balances[account] = _balances[account].sub(value);
322     emit Transfer(account, address(0), value);
323   }
324 
325   /**
326    * @dev Internal function that burns an amount of the token of a given
327    * account, deducting from the sender's allowance for said account. Uses the
328    * internal burn function.
329    * @param account The account whose tokens will be burnt.
330    * @param value The amount that will be burnt.
331    */
332   function _burnFrom(address account, uint256 value) internal {
333     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
334     // this function needs to emit an event with the updated approval.
335     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
336       value);
337     _burn(account, value);
338   }
339 }
340 
341 
342 /**
343  * @title SimpleToken
344  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
345  * Note they can later distribute these tokens as they wish using `transfer` and other
346  * `ERC20` functions.
347  */
348 contract MontexToken is ERC20, ERC20Detailed {
349   uint256 public constant INITIAL_SUPPLY = 2e9 * 10**uint256(8);
350 
351   /**
352    * @dev Constructor that gives msg.sender all of existing tokens.
353    */
354   constructor() public ERC20Detailed("MontexToken", "MON", 8) {
355     _mint(msg.sender, INITIAL_SUPPLY);
356   }
357 
358 }