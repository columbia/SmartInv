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
32 /**
33  * @title SafeMath
34  * @dev Math operations with safety checks that revert on error
35  */
36 library SafeMath {
37 
38   /**
39   * @dev Multiplies two numbers, reverts on overflow.
40   */
41   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
42     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
43     // benefit is lost if 'b' is also tested.
44     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
45     if (a == 0) {
46       return 0;
47     }
48 
49     uint256 c = a * b;
50     require(c / a == b);
51 
52     return c;
53   }
54 
55   /**
56   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
57   */
58   function div(uint256 a, uint256 b) internal pure returns (uint256) {
59     require(b > 0); // Solidity only automatically asserts when dividing by 0
60     uint256 c = a / b;
61     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
62 
63     return c;
64   }
65 
66   /**
67   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
68   */
69   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
70     require(b <= a);
71     uint256 c = a - b;
72 
73     return c;
74   }
75 
76   /**
77   * @dev Adds two numbers, reverts on overflow.
78   */
79   function add(uint256 a, uint256 b) internal pure returns (uint256) {
80     uint256 c = a + b;
81     require(c >= a);
82 
83     return c;
84   }
85 
86   /**
87   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
88   * reverts when dividing by zero.
89   */
90   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
91     require(b != 0);
92     return a % b;
93   }
94 }
95 
96 /**
97  * @title Standard ERC20 token
98  *
99  * @dev Implementation of the basic standard token.
100  */
101 contract ERC20 is IERC20 {
102   using SafeMath for uint256;
103 
104   mapping (address => uint256) private _balances;
105 
106   mapping (address => mapping (address => uint256)) private _allowed;
107 
108   uint256 private _totalSupply;
109 
110   /**
111   * @dev Total number of tokens in existence
112   */
113   function totalSupply() public view returns (uint256) {
114     return _totalSupply;
115   }
116 
117   /**
118   * @dev Gets the balance of the specified address.
119   * @param owner The address to query the the balance of.
120   * @return An uint256 representing the amount owned by the passed address.
121   */
122   function balanceOf(address owner) public view returns (uint256) {
123     return _balances[owner];
124   }
125 
126   /**
127    * @dev Function to check the amount of tokens that an owner allowed to a spender.
128    * @param owner address The address which owns the funds.
129    * @param spender address The address which will spend the funds.
130    * @return A uint256 specifying the amount of tokens still available for the spender.
131    */
132   function allowance(
133     address owner,
134     address spender
135    )
136     public
137     view
138     returns (uint256)
139   {
140     return _allowed[owner][spender];
141   }
142 
143   /**
144   * @dev Transfer token for a specified address
145   * @param to The address to transfer to.
146   * @param value The amount to be transferred.
147   */
148   function transfer(address to, uint256 value) public returns (bool) {
149     require(value <= _balances[msg.sender]);
150     require(to != address(0));
151 
152     _balances[msg.sender] = _balances[msg.sender].sub(value);
153     _balances[to] = _balances[to].add(value);
154     emit Transfer(msg.sender, to, value);
155     return true;
156   }
157 
158   /**
159    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
160    * Beware that changing an allowance with this method brings the risk that someone may use both the old
161    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
162    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
163    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
164    * @param spender The address which will spend the funds.
165    * @param value The amount of tokens to be spent.
166    */
167   function approve(address spender, uint256 value) public returns (bool) {
168     require(spender != address(0));
169 
170     _allowed[msg.sender][spender] = value;
171     emit Approval(msg.sender, spender, value);
172     return true;
173   }
174 
175   /**
176    * @dev Transfer tokens from one address to another
177    * @param from address The address which you want to send tokens from
178    * @param to address The address which you want to transfer to
179    * @param value uint256 the amount of tokens to be transferred
180    */
181   function transferFrom(
182     address from,
183     address to,
184     uint256 value
185   )
186     public
187     returns (bool)
188   {
189     require(value <= _balances[from]);
190     require(value <= _allowed[from][msg.sender]);
191     require(to != address(0));
192 
193     _balances[from] = _balances[from].sub(value);
194     _balances[to] = _balances[to].add(value);
195     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
196     emit Transfer(from, to, value);
197     return true;
198   }
199 
200   /**
201    * @dev Increase the amount of tokens that an owner allowed to a spender.
202    * approve should be called when allowed_[_spender] == 0. To increment
203    * allowed value is better to use this function to avoid 2 calls (and wait until
204    * the first transaction is mined)
205    * From MonolithDAO Token.sol
206    * @param spender The address which will spend the funds.
207    * @param addedValue The amount of tokens to increase the allowance by.
208    */
209   function increaseAllowance(
210     address spender,
211     uint256 addedValue
212   )
213     public
214     returns (bool)
215   {
216     require(spender != address(0));
217 
218     _allowed[msg.sender][spender] = (
219       _allowed[msg.sender][spender].add(addedValue));
220     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
221     return true;
222   }
223 
224   /**
225    * @dev Decrease the amount of tokens that an owner allowed to a spender.
226    * approve should be called when allowed_[_spender] == 0. To decrement
227    * allowed value is better to use this function to avoid 2 calls (and wait until
228    * the first transaction is mined)
229    * From MonolithDAO Token.sol
230    * @param spender The address which will spend the funds.
231    * @param subtractedValue The amount of tokens to decrease the allowance by.
232    */
233   function decreaseAllowance(
234     address spender,
235     uint256 subtractedValue
236   )
237     public
238     returns (bool)
239   {
240     require(spender != address(0));
241 
242     _allowed[msg.sender][spender] = (
243       _allowed[msg.sender][spender].sub(subtractedValue));
244     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
245     return true;
246   }
247 
248   /**
249    * @dev Internal function that mints an amount of the token and assigns it to
250    * an account. This encapsulates the modification of balances such that the
251    * proper events are emitted.
252    * @param account The account that will receive the created tokens.
253    * @param amount The amount that will be created.
254    */
255   function _mint(address account, uint256 amount) internal {
256     require(account != 0);
257     _totalSupply = _totalSupply.add(amount);
258     _balances[account] = _balances[account].add(amount);
259     emit Transfer(address(0), account, amount);
260   }
261 }
262 
263 contract Remitano is ERC20 {
264 
265   string public constant name = "Remitano";
266   string public constant symbol = "RET";
267   uint8 public constant decimals = 18;
268 
269   uint256 public constant INITIAL_SUPPLY = 40000000 * (10 ** uint256(decimals));
270 
271   /**
272    * @dev Constructor that gives msg.sender all of existing tokens.
273    */
274   constructor() public {
275     _mint(msg.sender, INITIAL_SUPPLY);
276   }
277 
278   /**
279    * @dev Do not accept ETH
280    */
281   function () public payable {
282     revert();
283   }
284 }