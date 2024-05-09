1 pragma solidity ^0.5.0;
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
33   /**
34   * @dev Returns the largest of two numbers.
35   */
36   function max(uint256 a, uint256 b) internal pure returns (uint256) {
37     return a >= b ? a : b;
38   }
39 
40   /**
41   * @dev Returns the smallest of two numbers.
42   */
43   function min(uint256 a, uint256 b) internal pure returns (uint256) {
44     return a < b ? a : b;
45   }
46 
47   /**
48   * @dev Calculates the average of two numbers. Since these are integers,
49   * averages of an even and odd number cannot be represented, and will be
50   * rounded down.
51   */
52   function average(uint256 a, uint256 b) internal pure returns (uint256) {
53     // (a + b) / 2 can overflow, so we distribute
54     return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
55   }
56   /**
57   * @dev Multiplies two numbers, reverts on overflow.
58   */
59   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
60     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
61     // benefit is lost if 'b' is also tested.
62     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
63     if (a == 0) {
64       return 0;
65     }
66 
67     uint256 c = a * b;
68     require(c / a == b);
69 
70     return c;
71   }
72 
73   /**
74   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
75   */
76   function div(uint256 a, uint256 b) internal pure returns (uint256) {
77     require(b > 0); // Solidity only automatically asserts when dividing by 0
78     uint256 c = a / b;
79     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
80 
81     return c;
82   }
83 
84   /**
85   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
86   */
87   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
88     require(b <= a);
89     uint256 c = a - b;
90 
91     return c;
92   }
93 
94   /**
95   * @dev Adds two numbers, reverts on overflow.
96   */
97   function add(uint256 a, uint256 b) internal pure returns (uint256) {
98     uint256 c = a + b;
99     require(c >= a);
100 
101     return c;
102   }
103 
104   /**
105   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
106   * reverts when dividing by zero.
107   */
108   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
109     require(b != 0);
110     return a % b;
111   }
112 }
113 
114 contract ERC20 is IERC20 {
115   using SafeMath for uint256;
116 
117   mapping (address => uint256) private _balances;
118 
119   mapping (address => mapping (address => uint256)) private _allowed;
120 
121   uint256 private _totalSupply;
122 
123   /**
124   * @dev Total number of tokens in existence
125   */
126   function totalSupply() public view returns (uint256) {
127     return _totalSupply;
128   }
129 
130   /**
131   * @dev Gets the balance of the specified address.
132   * @param owner The address to query the balance of.
133   * @return An uint256 representing the amount owned by the passed address.
134   */
135   function balanceOf(address owner) public view returns (uint256) {
136     return _balances[owner];
137   }
138 
139   /**
140    * @dev Function to check the amount of tokens that an owner allowed to a spender.
141    * @param owner address The address which owns the funds.
142    * @param spender address The address which will spend the funds.
143    * @return A uint256 specifying the amount of tokens still available for the spender.
144    */
145   function allowance(
146     address owner,
147     address spender
148    )
149     public
150     view
151     returns (uint256)
152   {
153     return _allowed[owner][spender];
154   }
155 
156   /**
157   * @dev Transfer token for a specified address
158   * @param to The address to transfer to.
159   * @param value The amount to be transferred.
160   */
161   function transfer(address to, uint256 value) public returns (bool) {
162     _transfer(msg.sender, to, value);
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
197     require(value <= _allowed[from][msg.sender]);
198 
199     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
200     _transfer(from, to, value);
201     return true;
202   }
203 
204   /**
205    * @dev Increase the amount of tokens that an owner allowed to a spender.
206    * approve should be called when allowed_[_spender] == 0. To increment
207    * allowed value is better to use this function to avoid 2 calls (and wait until
208    * the first transaction is mined)
209    * From MonolithDAO Token.sol
210    * @param spender The address which will spend the funds.
211    * @param addedValue The amount of tokens to increase the allowance by.
212    */
213   function increaseAllowance(
214     address spender,
215     uint256 addedValue
216   )
217     public
218     returns (bool)
219   {
220     require(spender != address(0));
221 
222     _allowed[msg.sender][spender] = (
223       _allowed[msg.sender][spender].add(addedValue));
224     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
225     return true;
226   }
227 
228   /**
229    * @dev Decrease the amount of tokens that an owner allowed to a spender.
230    * approve should be called when allowed_[_spender] == 0. To decrement
231    * allowed value is better to use this function to avoid 2 calls (and wait until
232    * the first transaction is mined)
233    * From MonolithDAO Token.sol
234    * @param spender The address which will spend the funds.
235    * @param subtractedValue The amount of tokens to decrease the allowance by.
236    */
237   function decreaseAllowance(
238     address spender,
239     uint256 subtractedValue
240   )
241     public
242     returns (bool)
243   {
244     require(spender != address(0));
245 
246     _allowed[msg.sender][spender] = (
247       _allowed[msg.sender][spender].sub(subtractedValue));
248     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
249     return true;
250   }
251 
252   /**
253   * @dev Transfer token for a specified addresses
254   * @param from The address to transfer from.
255   * @param to The address to transfer to.
256   * @param value The amount to be transferred.
257   */
258   function _transfer(address from, address to, uint256 value) internal {
259     require(value <= _balances[from]);
260     require(to != address(0));
261 
262     _balances[from] = _balances[from].sub(value);
263     _balances[to] = _balances[to].add(value);
264     emit Transfer(from, to, value);
265   }
266 
267   /**
268    * @dev Internal function that mints an amount of the token and assigns it to
269    * an account. This encapsulates the modification of balances such that the
270    * proper events are emitted.
271    * @param account The account that will receive the created tokens.
272    * @param value The amount that will be created.
273    */
274   function _mint(address account, uint256 value) internal {
275     require(account != address(0));
276     _totalSupply = _totalSupply.add(value);
277     _balances[account] = _balances[account].add(value);
278     emit Transfer(address(0), account, value);
279   }
280 
281   /**
282    * @dev Internal function that burns an amount of the token of a given
283    * account.
284    * @param account The account whose tokens will be burnt.
285    * @param value The amount that will be burnt.
286    */
287   function _burn(address account, uint256 value) internal {
288     require(account != address(0));
289     require(value <= _balances[account]);
290 
291     _totalSupply = _totalSupply.sub(value);
292     _balances[account] = _balances[account].sub(value);
293     emit Transfer(account, address(0), value);
294   }
295 
296   /**
297    * @dev Internal function that burns an amount of the token of a given
298    * account, deducting from the sender's allowance for said account. Uses the
299    * internal burn function.
300    * @param account The account whose tokens will be burnt.
301    * @param value The amount that will be burnt.
302    */
303   function _burnFrom(address account, uint256 value) internal {
304     require(value <= _allowed[account][msg.sender]);
305 
306     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
307     // this function needs to emit an event with the updated approval.
308     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
309       value);
310     _burn(account, value);
311   }
312 }
313 
314 contract ERC20Detailed is IERC20 {
315   string private _name;
316   string private _symbol;
317   uint8 private _decimals;
318 
319   constructor(string memory name, string memory symbol, uint8 decimals) public {
320     _name = name;
321     _symbol = symbol;
322     _decimals = decimals;
323   }
324 
325   /**
326    * @return the name of the token.
327    */
328   function name() public view returns(string memory) {
329     return _name;
330   }
331 
332   /**
333    * @return the symbol of the token.
334    */
335   function symbol() public view returns(string memory) {
336     return _symbol;
337   }
338 
339   /**
340    * @return the number of decimals of the token.
341    */
342   function decimals() public view returns(uint8) {
343     return _decimals;
344   }
345 }
346 
347 
348 contract Token is ERC20Detailed, ERC20 {
349     constructor(uint256 amount, uint8 decimals,uint256 precision,string memory name, string memory symbol) public ERC20Detailed(name, symbol, decimals) {
350         _mint(msg.sender, amount * (10 ** precision));
351     }
352 }