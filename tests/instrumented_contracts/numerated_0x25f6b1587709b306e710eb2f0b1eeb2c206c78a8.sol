1 pragma solidity ^0.4.24;
2 
3 
4 interface IERC20 {
5   function totalSupply() external view returns (uint256);
6 
7   function balanceOf(address who) external view returns (uint256);
8 
9   function allowance(address owner, address spender)
10     external view returns (uint256);
11 
12   function transfer(address to, uint256 value) external returns (bool);
13 
14   function approve(address spender, uint256 value)
15     external returns (bool);
16 
17   function transferFrom(address from, address to, uint256 value)
18     external returns (bool);
19 
20   event Transfer(
21     address indexed from,
22     address indexed to,
23     uint256 value
24   );
25 
26   event Approval(
27     address indexed owner,
28     address indexed spender,
29     uint256 value
30   );
31 }
32 
33 library SafeMath {
34 
35   /**
36   * @dev Multiplies two numbers, reverts on overflow.
37   */
38   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
39     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
40     // benefit is lost if 'b' is also tested.
41     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
42     if (a == 0) {
43       return 0;
44     }
45 
46     uint256 c = a * b;
47     require(c / a == b);
48 
49     return c;
50   }
51 
52   /**
53   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
54   */
55   function div(uint256 a, uint256 b) internal pure returns (uint256) {
56     require(b > 0); // Solidity only automatically asserts when dividing by 0
57     uint256 c = a / b;
58     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
59 
60     return c;
61   }
62 
63   /**
64   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
65   */
66   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67     require(b <= a);
68     uint256 c = a - b;
69 
70     return c;
71   }
72 
73   /**
74   * @dev Adds two numbers, reverts on overflow.
75   */
76   function add(uint256 a, uint256 b) internal pure returns (uint256) {
77     uint256 c = a + b;
78     require(c >= a);
79 
80     return c;
81   }
82 
83   /**
84   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
85   * reverts when dividing by zero.
86   */
87   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
88     require(b != 0);
89     return a % b;
90   }
91 }
92 
93 contract ERC20 is IERC20 {
94   using SafeMath for uint256;
95 
96   mapping (address => uint256) private _balances;
97 
98   mapping (address => mapping (address => uint256)) private _allowed;
99 
100   uint256 private _totalSupply;
101 
102   /**
103   * @dev Total number of tokens in existence
104   */
105   function totalSupply() public view returns (uint256) {
106     return _totalSupply;
107   }
108 
109   /**
110   * @dev Gets the balance of the specified address.
111   * @param owner The address to query the balance of.
112   * @return An uint256 representing the amount owned by the passed address.
113   */
114   function balanceOf(address owner) public view returns (uint256) {
115     return _balances[owner];
116   }
117 
118   /**
119    * @dev Function to check the amount of tokens that an owner allowed to a spender.
120    * @param owner address The address which owns the funds.
121    * @param spender address The address which will spend the funds.
122    * @return A uint256 specifying the amount of tokens still available for the spender.
123    */
124   function allowance(
125     address owner,
126     address spender
127    )
128     public
129     view
130     returns (uint256)
131   {
132     return _allowed[owner][spender];
133   }
134 
135   /**
136   * @dev Transfer token for a specified address
137   * @param to The address to transfer to.
138   * @param value The amount to be transferred.
139   */
140   function transfer(address to, uint256 value) public returns (bool) {
141     _transfer(msg.sender, to, value);
142     return true;
143   }
144 
145   /**
146    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
147    * Beware that changing an allowance with this method brings the risk that someone may use both the old
148    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
149    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
150    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
151    * @param spender The address which will spend the funds.
152    * @param value The amount of tokens to be spent.
153    */
154   function approve(address spender, uint256 value) public returns (bool) {
155     require(spender != address(0));
156 
157     _allowed[msg.sender][spender] = value;
158     emit Approval(msg.sender, spender, value);
159     return true;
160   }
161 
162   /**
163    * @dev Transfer tokens from one address to another
164    * @param from address The address which you want to send tokens from
165    * @param to address The address which you want to transfer to
166    * @param value uint256 the amount of tokens to be transferred
167    */
168   function transferFrom(
169     address from,
170     address to,
171     uint256 value
172   )
173     public
174     returns (bool)
175   {
176     require(value <= _allowed[from][msg.sender]);
177 
178     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
179     _transfer(from, to, value);
180     return true;
181   }
182 
183   /**
184    * @dev Increase the amount of tokens that an owner allowed to a spender.
185    * approve should be called when allowed_[_spender] == 0. To increment
186    * allowed value is better to use this function to avoid 2 calls (and wait until
187    * the first transaction is mined)
188    * From MonolithDAO Token.sol
189    * @param spender The address which will spend the funds.
190    * @param addedValue The amount of tokens to increase the allowance by.
191    */
192   function increaseAllowance(
193     address spender,
194     uint256 addedValue
195   )
196     public
197     returns (bool)
198   {
199     require(spender != address(0));
200 
201     _allowed[msg.sender][spender] = (
202       _allowed[msg.sender][spender].add(addedValue));
203     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
204     return true;
205   }
206 
207   /**
208    * @dev Decrease the amount of tokens that an owner allowed to a spender.
209    * approve should be called when allowed_[_spender] == 0. To decrement
210    * allowed value is better to use this function to avoid 2 calls (and wait until
211    * the first transaction is mined)
212    * From MonolithDAO Token.sol
213    * @param spender The address which will spend the funds.
214    * @param subtractedValue The amount of tokens to decrease the allowance by.
215    */
216   function decreaseAllowance(
217     address spender,
218     uint256 subtractedValue
219   )
220     public
221     returns (bool)
222   {
223     require(spender != address(0));
224 
225     _allowed[msg.sender][spender] = (
226       _allowed[msg.sender][spender].sub(subtractedValue));
227     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
228     return true;
229   }
230 
231   /**
232   * @dev Transfer token for a specified addresses
233   * @param from The address to transfer from.
234   * @param to The address to transfer to.
235   * @param value The amount to be transferred.
236   */
237   function _transfer(address from, address to, uint256 value) internal {
238     require(value <= _balances[from]);
239     require(to != address(0));
240 
241     _balances[from] = _balances[from].sub(value);
242     _balances[to] = _balances[to].add(value);
243     emit Transfer(from, to, value);
244   }
245 
246   /**
247    * @dev Internal function that mints an amount of the token and assigns it to
248    * an account. This encapsulates the modification of balances such that the
249    * proper events are emitted.
250    * @param account The account that will receive the created tokens.
251    * @param value The amount that will be created.
252    */
253   function _mint(address account, uint256 value) internal {
254     require(account != 0);
255     _totalSupply = _totalSupply.add(value);
256     _balances[account] = _balances[account].add(value);
257     emit Transfer(address(0), account, value);
258   }
259 
260   /**
261    * @dev Internal function that burns an amount of the token of a given
262    * account.
263    * @param account The account whose tokens will be burnt.
264    * @param value The amount that will be burnt.
265    */
266   function _burn(address account, uint256 value) internal {
267     require(account != 0);
268     require(value <= _balances[account]);
269 
270     _totalSupply = _totalSupply.sub(value);
271     _balances[account] = _balances[account].sub(value);
272     emit Transfer(account, address(0), value);
273   }
274 
275   /**
276    * @dev Internal function that burns an amount of the token of a given
277    * account, deducting from the sender's allowance for said account. Uses the
278    * internal burn function.
279    * @param account The account whose tokens will be burnt.
280    * @param value The amount that will be burnt.
281    */
282   function _burnFrom(address account, uint256 value) internal {
283     require(value <= _allowed[account][msg.sender]);
284 
285     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
286     // this function needs to emit an event with the updated approval.
287     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
288       value);
289     _burn(account, value);
290   }
291 }
292 
293 contract ERC20Detailed is IERC20 {
294   string private _name;
295   string private _symbol;
296   uint8 private _decimals;
297 
298   constructor(string name, string symbol, uint8 decimals) public {
299     _name = name;
300     _symbol = symbol;
301     _decimals = decimals;
302   }
303 
304   /**
305    * @return the name of the token.
306    */
307   function name() public view returns(string) {
308     return _name;
309   }
310 
311   /**
312    * @return the symbol of the token.
313    */
314   function symbol() public view returns(string) {
315     return _symbol;
316   }
317 
318   /**
319    * @return the number of decimals of the token.
320    */
321   function decimals() public view returns(uint8) {
322     return _decimals;
323   }
324 }
325 
326 
327 contract Axiscoin is ERC20, ERC20Detailed {
328     
329     string private _name = "AxisCoin";
330     string private _symbol = "AXIS";
331     uint8 private _decimals = 3;
332 
333     address account = msg.sender;
334     uint256 value = 500000000000;
335 
336     constructor() ERC20Detailed(_name, _symbol, _decimals) public {
337         _mint(account, value);
338     }
339 }