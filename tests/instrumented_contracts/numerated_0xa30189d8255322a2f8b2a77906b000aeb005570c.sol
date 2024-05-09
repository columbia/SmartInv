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
68  * @title ERC20 interface
69  * @dev see https://github.com/ethereum/EIPs/issues/20
70  */
71  interface IERC20 {
72    function totalSupply() external view returns (uint256);
73 
74    function balanceOf(address who) external view returns (uint256);
75 
76    function allowance(address owner, address spender)
77      external view returns (uint256);
78 
79    function transfer(address to, uint256 value) external returns (bool);
80 
81    function approve(address spender, uint256 value)
82      external returns (bool);
83 
84    function transferFrom(address from, address to, uint256 value)
85      external returns (bool);
86 
87    event Transfer(
88      address indexed from,
89      address indexed to,
90      uint256 value
91    );
92 
93    event Approval(
94      address indexed owner,
95      address indexed spender,
96      uint256 value
97    );
98  }
99 
100 contract ERC20 is IERC20 {
101   using SafeMath for uint256;
102 
103   mapping (address => uint256) private _balances;
104 
105   mapping (address => mapping (address => uint256)) private _allowed;
106 
107   uint256 private _totalSupply;
108   string private _name;
109   string private _symbol;
110   uint8 private _decimals;
111 
112   constructor(string name, string symbol, uint8 decimals, uint256 totalSupply) public {
113     _name = name;
114     _symbol = symbol;
115     _decimals = decimals;
116     _totalSupply = totalSupply;
117     _balances[msg.sender] = _balances[msg.sender].add(_totalSupply);
118     emit Transfer(address(0), msg.sender, totalSupply);
119   }
120 
121   /**
122    * @return the name of the token.
123    */
124   function name() public view returns(string) {
125     return _name;
126   }
127 
128   /**
129    * @return the symbol of the token.
130    */
131   function symbol() public view returns(string) {
132     return _symbol;
133   }
134 
135   /**
136    * @return the number of decimals of the token.
137    */
138   function decimals() public view returns(uint8) {
139     return _decimals;
140   }
141 
142   /**
143   * @dev Total number of tokens in existence
144   */
145   function totalSupply() public view returns (uint256) {
146     return _totalSupply;
147   }
148 
149   /**
150   * @dev Gets the balance of the specified address.
151   * @param owner The address to query the balance of.
152   * @return An uint256 representing the amount owned by the passed address.
153   */
154   function balanceOf(address owner) public view returns (uint256) {
155     return _balances[owner];
156   }
157 
158   /**
159    * @dev Function to check the amount of tokens that an owner allowed to a spender.
160    * @param owner address The address which owns the funds.
161    * @param spender address The address which will spend the funds.
162    * @return A uint256 specifying the amount of tokens still available for the spender.
163    */
164   function allowance(
165     address owner,
166     address spender
167    )
168     public
169     view
170     returns (uint256)
171   {
172     return _allowed[owner][spender];
173   }
174 
175   /**
176   * @dev Transfer token for a specified address
177   * @param to The address to transfer to.
178   * @param value The amount to be transferred.
179   */
180   function transfer(address to, uint256 value) public returns (bool) {
181     _transfer(msg.sender, to, value);
182     return true;
183   }
184 
185   /**
186    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
187    * Beware that changing an allowance with this method brings the risk that someone may use both the old
188    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
189    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
190    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
191    * @param spender The address which will spend the funds.
192    * @param value The amount of tokens to be spent.
193    */
194   function approve(address spender, uint256 value) public returns (bool) {
195     require(spender != address(0));
196 
197     _allowed[msg.sender][spender] = value;
198     emit Approval(msg.sender, spender, value);
199     return true;
200   }
201 
202   /**
203    * @dev Transfer tokens from one address to another
204    * @param from address The address which you want to send tokens from
205    * @param to address The address which you want to transfer to
206    * @param value uint256 the amount of tokens to be transferred
207    */
208   function transferFrom(
209     address from,
210     address to,
211     uint256 value
212   )
213     public
214     returns (bool)
215   {
216     require(value <= _allowed[from][msg.sender]);
217 
218     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
219     _transfer(from, to, value);
220     return true;
221   }
222 
223   /**
224    * @dev Increase the amount of tokens that an owner allowed to a spender.
225    * approve should be called when allowed_[_spender] == 0. To increment
226    * allowed value is better to use this function to avoid 2 calls (and wait until
227    * the first transaction is mined)
228    * From MonolithDAO Token.sol
229    * @param spender The address which will spend the funds.
230    * @param addedValue The amount of tokens to increase the allowance by.
231    */
232   function increaseAllowance(
233     address spender,
234     uint256 addedValue
235   )
236     public
237     returns (bool)
238   {
239     require(spender != address(0));
240 
241     _allowed[msg.sender][spender] = (
242       _allowed[msg.sender][spender].add(addedValue));
243     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
244     return true;
245   }
246 
247   /**
248    * @dev Decrease the amount of tokens that an owner allowed to a spender.
249    * approve should be called when allowed_[_spender] == 0. To decrement
250    * allowed value is better to use this function to avoid 2 calls (and wait until
251    * the first transaction is mined)
252    * From MonolithDAO Token.sol
253    * @param spender The address which will spend the funds.
254    * @param subtractedValue The amount of tokens to decrease the allowance by.
255    */
256   function decreaseAllowance(
257     address spender,
258     uint256 subtractedValue
259   )
260     public
261     returns (bool)
262   {
263     require(spender != address(0));
264 
265     _allowed[msg.sender][spender] = (
266       _allowed[msg.sender][spender].sub(subtractedValue));
267     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
268     return true;
269   }
270 
271   /**
272   * @dev Transfer token for a specified addresses
273   * @param from The address to transfer from.
274   * @param to The address to transfer to.
275   * @param value The amount to be transferred.
276   */
277   function _transfer(address from, address to, uint256 value) internal {
278     require(value <= _balances[from]);
279     require(to != address(0));
280 
281     _balances[from] = _balances[from].sub(value);
282     _balances[to] = _balances[to].add(value);
283     emit Transfer(from, to, value);
284   }
285 }