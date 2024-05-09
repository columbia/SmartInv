1 pragma solidity ^0.5.6;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error.
6  */
7 library SafeMath {
8   /**
9    * @dev Multiplies two unsigned integers, reverts on overflow.
10    */
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
26    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
27    */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // Solidity only automatically asserts when dividing by 0
30     require(b > 0);
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34     return c;
35   }
36 
37   /**
38    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39    */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     require(b <= a);
42     uint256 c = a - b;
43 
44     return c;
45   }
46 
47   /**
48    * @dev Adds two unsigned integers, reverts on overflow.
49    */
50   function add(uint256 a, uint256 b) internal pure returns (uint256) {
51     uint256 c = a + b;
52     require(c >= a);
53 
54     return c;
55   }
56 
57   /**
58    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
59    * reverts when dividing by zero.
60    */
61   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62     require(b != 0);
63     return a % b;
64   }
65 }
66 
67 /**
68  * @title ERC20 interface
69  * @dev see https://eips.ethereum.org/EIPS/eip-20
70  */
71 interface IERC20 {
72   function transfer(address to, uint256 value) external returns (bool);
73 
74   function approve(address spender, uint256 value) external returns (bool);
75 
76   function transferFrom(address from, address to, uint256 value)
77     external
78     returns (bool);
79 
80   function totalSupply() external view returns (uint256);
81 
82   function balanceOf(address who) external view returns (uint256);
83 
84   function allowance(address owner, address spender)
85     external
86     view
87     returns (uint256);
88 
89   event Transfer(address indexed from, address indexed to, uint256 value);
90 
91   event Approval(address indexed owner, address indexed spender, uint256 value);
92 }
93 
94 /**
95  * @title Standard ERC20 token
96  *
97  * @dev Implementation of the basic standard token.
98  * https://eips.ethereum.org/EIPS/eip-20
99  * Originally based on OpenZeppelin implementation
100  * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/ERC20.sol
101  *
102  * This implementation is meant to be a migration of the original AURA token. On deployment
103  * the total supply is set to equal that of AURA and locked in the new contract. New tokens
104  * can only be obtained by calling the swap function
105  */
106 contract IDEX is IERC20 {
107   using SafeMath for uint256;
108 
109   mapping(address => uint256) private _balances;
110   mapping(address => mapping(address => uint256)) private _allowed;
111   uint256 private _totalSupply;
112   string private _name;
113   string private _symbol;
114   uint8 private _decimals;
115   IERC20 _oldToken;
116 
117   event Swap(address indexed owner, uint256 value);
118 
119   constructor(
120     string memory name,
121     string memory symbol,
122     uint8 decimals,
123     IERC20 oldToken
124   ) public {
125     _name = name;
126     _symbol = symbol;
127     _decimals = decimals;
128     _totalSupply = oldToken.totalSupply();
129     _balances[address(this)] = _totalSupply;
130     _oldToken = oldToken;
131 
132     emit Transfer(address(0), address(this), _totalSupply);
133   }
134 
135   function swap(uint256 value) external returns (bool) {
136     require(
137       _oldToken.transferFrom(msg.sender, address(this), value),
138       "AURA transfer failed"
139     );
140     require(this.transfer(msg.sender, value), "IDEX transfer failed");
141 
142     emit Swap(msg.sender, value);
143 
144     return true;
145   }
146 
147   /**
148    * @return the name of the token.
149    */
150   function name() public view returns (string memory) {
151     return _name;
152   }
153 
154   /**
155    * @return the symbol of the token.
156    */
157   function symbol() public view returns (string memory) {
158     return _symbol;
159   }
160 
161   /**
162    * @return the number of decimals of the token.
163    */
164   function decimals() public view returns (uint8) {
165     return _decimals;
166   }
167 
168   /**
169    * @dev Total number of tokens in existence.
170    */
171   function totalSupply() public view returns (uint256) {
172     return _totalSupply;
173   }
174 
175   /**
176    * @dev Gets the balance of the specified address.
177    * @param owner The address to query the balance of.
178    * @return A uint256 representing the amount owned by the passed address.
179    */
180   function balanceOf(address owner) public view returns (uint256) {
181     return _balances[owner];
182   }
183 
184   /**
185    * @dev Function to check the amount of tokens that an owner allowed to a spender.
186    * @param owner address The address which owns the funds.
187    * @param spender address The address which will spend the funds.
188    * @return A uint256 specifying the amount of tokens still available for the spender.
189    */
190   function allowance(address owner, address spender)
191     public
192     view
193     returns (uint256)
194   {
195     return _allowed[owner][spender];
196   }
197 
198   /**
199    * @dev Transfer token to a specified address.
200    * @param to The address to transfer to.
201    * @param value The amount to be transferred.
202    */
203   function transfer(address to, uint256 value) public returns (bool) {
204     _transfer(msg.sender, to, value);
205     return true;
206   }
207 
208   /**
209    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
210    * Beware that changing an allowance with this method brings the risk that someone may use both the old
211    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
212    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
213    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
214    * @param spender The address which will spend the funds.
215    * @param value The amount of tokens to be spent.
216    */
217   function approve(address spender, uint256 value) public returns (bool) {
218     _approve(msg.sender, spender, value);
219     return true;
220   }
221 
222   /**
223    * @dev Transfer tokens from one address to another.
224    * Note that while this function emits an Approval event, this is not required as per the specification,
225    * and other compliant implementations may not emit the event.
226    * @param from address The address which you want to send tokens from
227    * @param to address The address which you want to transfer to
228    * @param value uint256 the amount of tokens to be transferred
229    */
230   function transferFrom(address from, address to, uint256 value)
231     public
232     returns (bool)
233   {
234     _transfer(from, to, value);
235     _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
236     return true;
237   }
238 
239   /**
240    * @dev Increase the amount of tokens that an owner allowed to a spender.
241    * approve should be called when _allowed[msg.sender][spender] == 0. To increment
242    * allowed value is better to use this function to avoid 2 calls (and wait until
243    * the first transaction is mined)
244    * From MonolithDAO Token.sol
245    * Emits an Approval event.
246    * @param spender The address which will spend the funds.
247    * @param addedValue The amount of tokens to increase the allowance by.
248    */
249   function increaseAllowance(address spender, uint256 addedValue)
250     public
251     returns (bool)
252   {
253     _approve(
254       msg.sender,
255       spender,
256       _allowed[msg.sender][spender].add(addedValue)
257     );
258     return true;
259   }
260 
261   /**
262    * @dev Decrease the amount of tokens that an owner allowed to a spender.
263    * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
264    * allowed value is better to use this function to avoid 2 calls (and wait until
265    * the first transaction is mined)
266    * From MonolithDAO Token.sol
267    * Emits an Approval event.
268    * @param spender The address which will spend the funds.
269    * @param subtractedValue The amount of tokens to decrease the allowance by.
270    */
271   function decreaseAllowance(address spender, uint256 subtractedValue)
272     public
273     returns (bool)
274   {
275     _approve(
276       msg.sender,
277       spender,
278       _allowed[msg.sender][spender].sub(subtractedValue)
279     );
280     return true;
281   }
282 
283   /**
284    * @dev Transfer token for a specified addresses.
285    * @param from The address to transfer from.
286    * @param to The address to transfer to.
287    * @param value The amount to be transferred.
288    */
289   function _transfer(address from, address to, uint256 value) internal {
290     require(from != address(0), "Invalid from");
291     require(to != address(0), "Invalid to");
292 
293     _balances[from] = _balances[from].sub(value);
294     _balances[to] = _balances[to].add(value);
295     emit Transfer(from, to, value);
296   }
297 
298   /**
299    * @dev Approve an address to spend another addresses' tokens.
300    * @param owner The address that owns the tokens.
301    * @param spender The address that will spend the tokens.
302    * @param value The number of tokens that can be spent.
303    */
304   function _approve(address owner, address spender, uint256 value) internal {
305     require(spender != address(0), "Invalid spender");
306 
307     _allowed[owner][spender] = value;
308     emit Approval(owner, spender, value);
309   }
310 }