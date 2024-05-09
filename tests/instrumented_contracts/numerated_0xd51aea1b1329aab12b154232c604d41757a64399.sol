1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that revert on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, reverts on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (a == 0) {
18       return 0;
19     }
20 
21     uint256 c = a * b;
22     require(c / a == b);
23 
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     require(b > 0); // Solidity only automatically asserts when dividing by 0
32     uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34 
35     return c;
36   }
37 
38   /**
39   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
40   */
41   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42     require(b <= a);
43     uint256 c = a - b;
44 
45     return c;
46   }
47 
48   /**
49   * @dev Adds two numbers, reverts on overflow.
50   */
51   function add(uint256 a, uint256 b) internal pure returns (uint256) {
52     uint256 c = a + b;
53     require(c >= a);
54 
55     return c;
56   }
57 
58   /**
59   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
60   * reverts when dividing by zero.
61   */
62   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
63     require(b != 0);
64     return a % b;
65   }
66 }
67 
68 /**
69  * @title ERC20 interface
70  * @dev see https://github.com/ethereum/EIPs/issues/20
71  */
72 interface IERC20 {
73   function totalSupply() external view returns (uint256);
74 
75   function balanceOf(address who) external view returns (uint256);
76 
77   function allowance(address owner, address spender)
78     external view returns (uint256);
79 
80   function transfer(address to, uint256 value) external returns (bool);
81 
82   function approve(address spender, uint256 value)
83     external returns (bool);
84 
85   function transferFrom(address from, address to, uint256 value)
86     external returns (bool);
87 
88   event Transfer(
89     address indexed from,
90     address indexed to,
91     uint256 value
92   );
93 
94   event Approval(
95     address indexed owner,
96     address indexed spender,
97     uint256 value
98   );
99 }
100 
101 /**
102  * @title Standard ERC20 token
103  *
104  * @dev Implementation of the basic standard token.
105  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
106  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
107  */
108 contract ERC20 is IERC20 {
109   using SafeMath for uint256;
110 
111   mapping (address => uint256) private _balances;
112 
113   mapping (address => mapping (address => uint256)) private _allowed;
114 
115   uint256 private _totalSupply;
116 
117   /**
118   * @dev Total number of tokens in existence
119   */
120   function totalSupply() public view returns (uint256) {
121     return _totalSupply;
122   }
123 
124   /**
125   * @dev Gets the balance of the specified address.
126   * @param owner The address to query the the balance of.
127   * @return An uint256 representing the amount owned by the passed address.
128   */
129   function balanceOf(address owner) public view returns (uint256) {
130     return _balances[owner];
131   }
132 
133   /**
134    * @dev Function to check the amount of tokens that an owner allowed to a spender.
135    * @param owner address The address which owns the funds.
136    * @param spender address The address which will spend the funds.
137    * @return A uint256 specifying the amount of tokens still available for the spender.
138    */
139   function allowance(
140     address owner,
141     address spender
142    )
143     public
144     view
145     returns (uint256)
146   {
147     return _allowed[owner][spender];
148   }
149 
150   /**
151   * @dev Transfer token for a specified address
152   * @param to The address to transfer to.
153   * @param value The amount to be transferred.
154   */
155   function transfer(address to, uint256 value) public returns (bool) {
156     require(value <= _balances[msg.sender]);
157     require(to != address(0));
158 
159     _balances[msg.sender] = _balances[msg.sender].sub(value);
160     _balances[to] = _balances[to].add(value);
161     emit Transfer(msg.sender, to, value);
162     return true;
163   }
164 
165   /**
166    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
167    * Beware that changing an allowance with this method brings the risk that someone may use both the old
168    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
169    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
170    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
171    * @param spender The address which will spend the funds.
172    * @param value The amount of tokens to be spent.
173    */
174   function approve(address spender, uint256 value) public returns (bool) {
175     require(spender != address(0));
176 
177     _allowed[msg.sender][spender] = value;
178     emit Approval(msg.sender, spender, value);
179     return true;
180   }
181 
182   /**
183    * @dev Transfer tokens from one address to another
184    * @param from address The address which you want to send tokens from
185    * @param to address The address which you want to transfer to
186    * @param value uint256 the amount of tokens to be transferred
187    */
188   function transferFrom(
189     address from,
190     address to,
191     uint256 value
192   )
193     public
194     returns (bool)
195   {
196     require(value <= _balances[from]);
197     require(value <= _allowed[from][msg.sender]);
198     require(to != address(0));
199 
200     _balances[from] = _balances[from].sub(value);
201     _balances[to] = _balances[to].add(value);
202     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
203     emit Transfer(from, to, value);
204     return true;
205   }
206 
207   /**
208    * @dev Increase the amount of tokens that an owner allowed to a spender.
209    * approve should be called when allowed_[_spender] == 0. To increment
210    * allowed value is better to use this function to avoid 2 calls (and wait until
211    * the first transaction is mined)
212    * From MonolithDAO Token.sol
213    * @param spender The address which will spend the funds.
214    * @param addedValue The amount of tokens to increase the allowance by.
215    */
216   function increaseAllowance(
217     address spender,
218     uint256 addedValue
219   )
220     public
221     returns (bool)
222   {
223     require(spender != address(0));
224 
225     _allowed[msg.sender][spender] = (
226       _allowed[msg.sender][spender].add(addedValue));
227     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
228     return true;
229   }
230 
231   /**
232    * @dev Decrease the amount of tokens that an owner allowed to a spender.
233    * approve should be called when allowed_[_spender] == 0. To decrement
234    * allowed value is better to use this function to avoid 2 calls (and wait until
235    * the first transaction is mined)
236    * From MonolithDAO Token.sol
237    * @param spender The address which will spend the funds.
238    * @param subtractedValue The amount of tokens to decrease the allowance by.
239    */
240   function decreaseAllowance(
241     address spender,
242     uint256 subtractedValue
243   )
244     public
245     returns (bool)
246   {
247     require(spender != address(0));
248 
249     _allowed[msg.sender][spender] = (
250       _allowed[msg.sender][spender].sub(subtractedValue));
251     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
252     return true;
253   }
254 
255   /**
256    * @dev Internal function that mints an amount of the token and assigns it to
257    * an account. This encapsulates the modification of balances such that the
258    * proper events are emitted.
259    * @param account The account that will receive the created tokens.
260    * @param amount The amount that will be created.
261    */
262   function _mint(address account, uint256 amount) internal {
263     require(account != 0);
264     _totalSupply = _totalSupply.add(amount);
265     _balances[account] = _balances[account].add(amount);
266     emit Transfer(address(0), account, amount);
267   }
268 
269  
270 }
271 
272 contract Richclassic is ERC20 { 
273   string public name="Richclassic";
274   string public symbol="RRGC";
275   uint8 public decimals=18;
276   uint256 public constant INITIAL_SUPPLY = 100000000 * (10 ** uint256(18));
277 
278   /**
279    * @dev Constructor that gives msg.sender all of existing tokens.
280    */
281   constructor() public {
282     _mint(msg.sender, INITIAL_SUPPLY);
283   }
284 
285 }