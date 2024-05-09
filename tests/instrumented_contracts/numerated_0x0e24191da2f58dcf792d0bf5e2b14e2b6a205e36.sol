1 interface IERC20 {
2   function totalSupply() external view returns (uint256);
3 
4   function balanceOf(address who) external view returns (uint256);
5 
6   function allowance(address owner, address spender)
7     external view returns (uint256);
8 
9   function transfer(address to, uint256 value) external returns (bool);
10 
11   function approve(address spender, uint256 value)
12     external returns (bool);
13 
14   function transferFrom(address from, address to, uint256 value)
15     external returns (bool);
16 
17   event Transfer(
18     address indexed from,
19     address indexed to,
20     uint256 value
21   );
22 
23   event Approval(
24     address indexed owner,
25     address indexed spender,
26     uint256 value
27   );
28 }
29 
30 /**
31  * @title SafeMath
32  * @dev Math operations with safety checks that revert on error
33  */
34 library SafeMath {
35 
36   /**
37   * @dev Multiplies two numbers, reverts on overflow.
38   */
39   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
40     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
41     // benefit is lost if 'b' is also tested.
42     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
43     if (a == 0) {
44       return 0;
45     }
46 
47     uint256 c = a * b;
48     require(c / a == b);
49 
50     return c;
51   }
52 
53   /**
54   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
55   */
56   function div(uint256 a, uint256 b) internal pure returns (uint256) {
57     require(b > 0); // Solidity only automatically asserts when dividing by 0
58     uint256 c = a / b;
59     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
60 
61     return c;
62   }
63 
64   /**
65   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
66   */
67   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
68     require(b <= a);
69     uint256 c = a - b;
70 
71     return c;
72   }
73 
74   /**
75   * @dev Adds two numbers, reverts on overflow.
76   */
77   function add(uint256 a, uint256 b) internal pure returns (uint256) {
78     uint256 c = a + b;
79     require(c >= a);
80 
81     return c;
82   }
83 
84   /**
85   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
86   * reverts when dividing by zero.
87   */
88   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
89     require(b != 0);
90     return a % b;
91   }
92 }
93 
94 /**
95  * @title Standard ERC20 token
96  *
97  * @dev Implementation of the basic standard token.
98  */
99 contract ERC20 is IERC20 {
100   using SafeMath for uint256;
101 
102   mapping (address => uint256) private _balances;
103 
104   mapping (address => mapping (address => uint256)) private _allowed;
105 
106   uint256 private _totalSupply;
107 
108   /**
109   * @dev Total number of tokens in existence
110   */
111   function totalSupply() public view returns (uint256) {
112     return _totalSupply;
113   }
114 
115   /**
116   * @dev Gets the balance of the specified address.
117   * @param owner The address to query the the balance of.
118   * @return An uint256 representing the amount owned by the passed address.
119   */
120   function balanceOf(address owner) public view returns (uint256) {
121     return _balances[owner];
122   }
123 
124   /**
125    * @dev Function to check the amount of tokens that an owner allowed to a spender.
126    * @param owner address The address which owns the funds.
127    * @param spender address The address which will spend the funds.
128    * @return A uint256 specifying the amount of tokens still available for the spender.
129    */
130   function allowance(
131     address owner,
132     address spender
133    )
134     public
135     view
136     returns (uint256)
137   {
138     return _allowed[owner][spender];
139   }
140 
141   /**
142   * @dev Transfer token for a specified address
143   * @param to The address to transfer to.
144   * @param value The amount to be transferred.
145   */
146   function transfer(address to, uint256 value) public returns (bool) {
147     require(value <= _balances[msg.sender]);
148     require(to != address(0));
149 
150     _balances[msg.sender] = _balances[msg.sender].sub(value);
151     _balances[to] = _balances[to].add(value);
152     emit Transfer(msg.sender, to, value);
153     return true;
154   }
155 
156   /**
157    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
158    * Beware that changing an allowance with this method brings the risk that someone may use both the old
159    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
160    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
161    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
162    * @param spender The address which will spend the funds.
163    * @param value The amount of tokens to be spent.
164    */
165   function approve(address spender, uint256 value) public returns (bool) {
166     require(spender != address(0));
167 
168     _allowed[msg.sender][spender] = value;
169     emit Approval(msg.sender, spender, value);
170     return true;
171   }
172 
173   /**
174    * @dev Transfer tokens from one address to another
175    * @param from address The address which you want to send tokens from
176    * @param to address The address which you want to transfer to
177    * @param value uint256 the amount of tokens to be transferred
178    */
179   function transferFrom(
180     address from,
181     address to,
182     uint256 value
183   )
184     public
185     returns (bool)
186   {
187     require(value <= _balances[from]);
188     require(value <= _allowed[from][msg.sender]);
189     require(to != address(0));
190 
191     _balances[from] = _balances[from].sub(value);
192     _balances[to] = _balances[to].add(value);
193     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
194     emit Transfer(from, to, value);
195     return true;
196   }
197 
198   /**
199    * @dev Increase the amount of tokens that an owner allowed to a spender.
200    * approve should be called when allowed_[_spender] == 0. To increment
201    * allowed value is better to use this function to avoid 2 calls (and wait until
202    * the first transaction is mined)
203    * From MonolithDAO Token.sol
204    * @param spender The address which will spend the funds.
205    * @param addedValue The amount of tokens to increase the allowance by.
206    */
207   function increaseAllowance(
208     address spender,
209     uint256 addedValue
210   )
211     public
212     returns (bool)
213   {
214     require(spender != address(0));
215 
216     _allowed[msg.sender][spender] = (
217       _allowed[msg.sender][spender].add(addedValue));
218     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
219     return true;
220   }
221 
222   /**
223    * @dev Decrease the amount of tokens that an owner allowed to a spender.
224    * approve should be called when allowed_[_spender] == 0. To decrement
225    * allowed value is better to use this function to avoid 2 calls (and wait until
226    * the first transaction is mined)
227    * From MonolithDAO Token.sol
228    * @param spender The address which will spend the funds.
229    * @param subtractedValue The amount of tokens to decrease the allowance by.
230    */
231   function decreaseAllowance(
232     address spender,
233     uint256 subtractedValue
234   )
235     public
236     returns (bool)
237   {
238     require(spender != address(0));
239 
240     _allowed[msg.sender][spender] = (
241       _allowed[msg.sender][spender].sub(subtractedValue));
242     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
243     return true;
244   }
245 
246   /**
247    * @dev Internal function that mints an amount of the token and assigns it to
248    * an account. This encapsulates the modification of balances such that the
249    * proper events are emitted.
250    * @param account The account that will receive the created tokens.
251    * @param amount The amount that will be created.
252    */
253   function _mint(address account, uint256 amount) internal {
254     require(account != 0);
255     _totalSupply = _totalSupply.add(amount);
256     _balances[account] = _balances[account].add(amount);
257     emit Transfer(address(0), account, amount);
258   }
259 }
260 
261 contract RemiToken is ERC20 {
262 
263   string public constant name = "Remitano Token";
264   string public constant symbol = "RET";
265   uint8 public constant decimals = 18;
266 
267   uint256 public constant INITIAL_SUPPLY = 1000000 * (10 ** uint256(decimals));
268 
269   /**
270    * @dev Constructor that gives msg.sender all of existing tokens.
271    */
272   constructor() public {
273     _mint(msg.sender, INITIAL_SUPPLY);
274   }
275 }