1 pragma solidity ^0.4.25;
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
32 library SafeMath {
33 
34   /**
35   * @dev Multiplies two numbers, reverts on overflow.
36   */
37   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
38     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
39     // benefit is lost if 'b' is also tested.
40     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
41     if (a == 0) {
42       return 0;
43     }
44 
45     uint256 c = a * b;
46     require(c / a == b);
47 
48     return c;
49   }
50 
51   /**
52   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
53   */
54   function div(uint256 a, uint256 b) internal pure returns (uint256) {
55     require(b > 0); // Solidity only automatically asserts when dividing by 0
56     uint256 c = a / b;
57     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
58 
59     return c;
60   }
61 
62   /**
63   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
64   */
65   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
66     require(b <= a);
67     uint256 c = a - b;
68 
69     return c;
70   }
71 
72   /**
73   * @dev Adds two numbers, reverts on overflow.
74   */
75   function add(uint256 a, uint256 b) internal pure returns (uint256) {
76     uint256 c = a + b;
77     require(c >= a);
78 
79     return c;
80   }
81 
82   /**
83   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
84   * reverts when dividing by zero.
85   */
86   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
87     require(b != 0);
88     return a % b;
89   }
90 }
91 
92 contract ERC20Detailed is IERC20 {
93   string private _name;
94   string private _symbol;
95   uint8 private _decimals;
96 
97   constructor(string name, string symbol, uint8 decimals) public {
98     _name = name;
99     _symbol = symbol;
100     _decimals = decimals;
101   }
102 
103   /**
104    * @return the name of the token.
105    */
106   function name() public view returns(string) {
107     return _name;
108   }
109 
110   /**
111    * @return the symbol of the token.
112    */
113   function symbol() public view returns(string) {
114     return _symbol;
115   }
116 
117   /**
118    * @return the number of decimals of the token.
119    */
120   function decimals() public view returns(uint8) {
121     return _decimals;
122   }
123 }
124 
125 contract ERC20 is IERC20 {
126   using SafeMath for uint256;
127 
128   mapping (address => uint256) private _balances;
129 
130   mapping (address => mapping (address => uint256)) private _allowed;
131 
132   uint256 private _totalSupply;
133 
134   /**
135   * @dev Total number of tokens in existence
136   */
137   function totalSupply() public view returns (uint256) {
138     return _totalSupply;
139   }
140 
141   /**
142   * @dev Gets the balance of the specified address.
143   * @param owner The address to query the balance of.
144   * @return An uint256 representing the amount owned by the passed address.
145   */
146   function balanceOf(address owner) public view returns (uint256) {
147     return _balances[owner];
148   }
149 
150   /**
151    * @dev Function to check the amount of tokens that an owner allowed to a spender.
152    * @param owner address The address which owns the funds.
153    * @param spender address The address which will spend the funds.
154    * @return A uint256 specifying the amount of tokens still available for the spender.
155    */
156   function allowance(
157     address owner,
158     address spender
159    )
160     public
161     view
162     returns (uint256)
163   {
164     return _allowed[owner][spender];
165   }
166 
167   /**
168   * @dev Transfer token for a specified address
169   * @param to The address to transfer to.
170   * @param value The amount to be transferred.
171   */
172   function transfer(address to, uint256 value) public returns (bool) {
173     _transfer(msg.sender, to, value);
174     return true;
175   }
176 
177   /**
178    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
179    * Beware that changing an allowance with this method brings the risk that someone may use both the old
180    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
181    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
182    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
183    * @param spender The address which will spend the funds.
184    * @param value The amount of tokens to be spent.
185    */
186   function approve(address spender, uint256 value) public returns (bool) {
187     require(spender != address(0));
188 
189     _allowed[msg.sender][spender] = value;
190     emit Approval(msg.sender, spender, value);
191     return true;
192   }
193 
194   /**
195    * @dev Transfer tokens from one address to another
196    * @param from address The address which you want to send tokens from
197    * @param to address The address which you want to transfer to
198    * @param value uint256 the amount of tokens to be transferred
199    */
200   function transferFrom(
201     address from,
202     address to,
203     uint256 value
204   )
205     public
206     returns (bool)
207   {
208     require(value <= _allowed[from][msg.sender]);
209 
210     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
211     _transfer(from, to, value);
212     return true;
213   }
214 
215   /**
216    * @dev Increase the amount of tokens that an owner allowed to a spender.
217    * approve should be called when allowed_[_spender] == 0. To increment
218    * allowed value is better to use this function to avoid 2 calls (and wait until
219    * the first transaction is mined)
220    * From MonolithDAO Token.sol
221    * @param spender The address which will spend the funds.
222    * @param addedValue The amount of tokens to increase the allowance by.
223    */
224   function increaseAllowance(
225     address spender,
226     uint256 addedValue
227   )
228     public
229     returns (bool)
230   {
231     require(spender != address(0));
232 
233     _allowed[msg.sender][spender] = (
234       _allowed[msg.sender][spender].add(addedValue));
235     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
236     return true;
237   }
238 
239   /**
240    * @dev Decrease the amount of tokens that an owner allowed to a spender.
241    * approve should be called when allowed_[_spender] == 0. To decrement
242    * allowed value is better to use this function to avoid 2 calls (and wait until
243    * the first transaction is mined)
244    * From MonolithDAO Token.sol
245    * @param spender The address which will spend the funds.
246    * @param subtractedValue The amount of tokens to decrease the allowance by.
247    */
248   function decreaseAllowance(
249     address spender,
250     uint256 subtractedValue
251   )
252     public
253     returns (bool)
254   {
255     require(spender != address(0));
256 
257     _allowed[msg.sender][spender] = (
258       _allowed[msg.sender][spender].sub(subtractedValue));
259     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
260     return true;
261   }
262 
263   /**
264   * @dev Transfer token for a specified addresses
265   * @param from The address to transfer from.
266   * @param to The address to transfer to.
267   * @param value The amount to be transferred.
268   */
269   function _transfer(address from, address to, uint256 value) internal {
270     require(value <= _balances[from]);
271     require(to != address(0));
272 
273     _balances[from] = _balances[from].sub(value);
274     _balances[to] = _balances[to].add(value);
275     emit Transfer(from, to, value);
276   }
277 
278   /**
279    * @dev Internal function that mints an amount of the token and assigns it to
280    * an account. This encapsulates the modification of balances such that the
281    * proper events are emitted.
282    * @param account The account that will receive the created tokens.
283    * @param value The amount that will be created.
284    */
285   function _mint(address account, uint256 value) internal {
286     require(account != 0);
287     _totalSupply = _totalSupply.add(value);
288     _balances[account] = _balances[account].add(value);
289     emit Transfer(address(0), account, value);
290   }
291 
292   /**
293    * @dev Internal function that burns an amount of the token of a given
294    * account.
295    * @param account The account whose tokens will be burnt.
296    * @param value The amount that will be burnt.
297    */
298   function _burn(address account, uint256 value) internal {
299     require(account != 0);
300     require(value <= _balances[account]);
301 
302     _totalSupply = _totalSupply.sub(value);
303     _balances[account] = _balances[account].sub(value);
304     emit Transfer(account, address(0), value);
305   }
306 
307   /**
308    * @dev Internal function that burns an amount of the token of a given
309    * account, deducting from the sender's allowance for said account. Uses the
310    * internal burn function.
311    * @param account The account whose tokens will be burnt.
312    * @param value The amount that will be burnt.
313    */
314   function _burnFrom(address account, uint256 value) internal {
315     require(value <= _allowed[account][msg.sender]);
316 
317     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
318     // this function needs to emit an event with the updated approval.
319     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
320       value);
321     _burn(account, value);
322   }
323 }
324 
325 contract INSNToken is ERC20, ERC20Detailed {
326 
327     constructor() public
328     ERC20Detailed("Insanius Token", "INSN", 18)
329     {
330         _mint(msg.sender,100000000 ether);
331     }
332 }