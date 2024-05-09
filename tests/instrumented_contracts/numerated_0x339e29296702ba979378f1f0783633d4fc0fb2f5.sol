1 pragma solidity 0.4.25;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, reverts on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
10     // benefit is lost if 'b' is also tested.
11     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
12     if (a == 0) {
13       return 0;
14     }
15 
16     uint256 c = a * b;
17     require(c / a == b);
18 
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     require(b > 0); // Solidity only automatically asserts when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29 
30     return c;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     require(b <= a);
38     uint256 c = a - b;
39 
40     return c;
41   }
42 
43   /**
44   * @dev Adds two numbers, reverts on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256) {
47     uint256 c = a + b;
48     require(c >= a);
49 
50     return c;
51   }
52 
53   /**
54   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
55   * reverts when dividing by zero.
56   */
57   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
58     require(b != 0);
59     return a % b;
60   }
61 }
62 
63 interface IERC20 {
64   function totalSupply() external view returns (uint256);
65 
66   function balanceOf(address who) external view returns (uint256);
67 
68   function allowance(address owner, address spender)
69     external view returns (uint256);
70 
71   function transfer(address to, uint256 value) external returns (bool);
72 
73   function approve(address spender, uint256 value)
74     external returns (bool);
75 
76   function transferFrom(address from, address to, uint256 value)
77     external returns (bool);
78 
79   event Transfer(
80     address indexed from,
81     address indexed to,
82     uint256 value
83   );
84 
85   event Approval(
86     address indexed owner,
87     address indexed spender,
88     uint256 value
89   );
90 }
91 
92 contract ERC20 is IERC20 {
93   using SafeMath for uint256;
94 
95   mapping (address => uint256) private _balances;
96 
97   mapping (address => mapping (address => uint256)) private _allowed;
98 
99   uint256 private _totalSupply;
100 
101   /**
102   * @dev Total number of tokens in existence
103   */
104   function totalSupply() public view returns (uint256) {
105     return _totalSupply;
106   }
107 
108   /**
109   * @dev Gets the balance of the specified address.
110   * @param owner The address to query the balance of.
111   * @return An uint256 representing the amount owned by the passed address.
112   */
113   function balanceOf(address owner) public view returns (uint256) {
114     return _balances[owner];
115   }
116 
117   /**
118    * @dev Function to check the amount of tokens that an owner allowed to a spender.
119    * @param owner address The address which owns the funds.
120    * @param spender address The address which will spend the funds.
121    * @return A uint256 specifying the amount of tokens still available for the spender.
122    */
123   function allowance(
124     address owner,
125     address spender
126    )
127     public
128     view
129     returns (uint256)
130   {
131     return _allowed[owner][spender];
132   }
133 
134   /**
135   * @dev Transfer token for a specified address
136   * @param to The address to transfer to.
137   * @param value The amount to be transferred.
138   */
139   function transfer(address to, uint256 value) public returns (bool) {
140     _transfer(msg.sender, to, value);
141     return true;
142   }
143 
144   /**
145    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
146    * Beware that changing an allowance with this method brings the risk that someone may use both the old
147    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
148    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
149    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
150    * @param spender The address which will spend the funds.
151    * @param value The amount of tokens to be spent.
152    */
153   function approve(address spender, uint256 value) public returns (bool) {
154     require(spender != address(0));
155 
156     _allowed[msg.sender][spender] = value;
157     emit Approval(msg.sender, spender, value);
158     return true;
159   }
160 
161   /**
162    * @dev Transfer tokens from one address to another
163    * @param from address The address which you want to send tokens from
164    * @param to address The address which you want to transfer to
165    * @param value uint256 the amount of tokens to be transferred
166    */
167   function transferFrom(
168     address from,
169     address to,
170     uint256 value
171   )
172     public
173     returns (bool)
174   {
175     require(value <= _allowed[from][msg.sender]);
176 
177     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
178     _transfer(from, to, value);
179     return true;
180   }
181 
182   /**
183    * @dev Increase the amount of tokens that an owner allowed to a spender.
184    * approve should be called when allowed_[_spender] == 0. To increment
185    * allowed value is better to use this function to avoid 2 calls (and wait until
186    * the first transaction is mined)
187    * From MonolithDAO Token.sol
188    * @param spender The address which will spend the funds.
189    * @param addedValue The amount of tokens to increase the allowance by.
190    */
191   function increaseAllowance(
192     address spender,
193     uint256 addedValue
194   )
195     public
196     returns (bool)
197   {
198     require(spender != address(0));
199 
200     _allowed[msg.sender][spender] = (
201       _allowed[msg.sender][spender].add(addedValue));
202     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
203     return true;
204   }
205 
206   /**
207    * @dev Decrease the amount of tokens that an owner allowed to a spender.
208    * approve should be called when allowed_[_spender] == 0. To decrement
209    * allowed value is better to use this function to avoid 2 calls (and wait until
210    * the first transaction is mined)
211    * From MonolithDAO Token.sol
212    * @param spender The address which will spend the funds.
213    * @param subtractedValue The amount of tokens to decrease the allowance by.
214    */
215   function decreaseAllowance(
216     address spender,
217     uint256 subtractedValue
218   )
219     public
220     returns (bool)
221   {
222     require(spender != address(0));
223 
224     _allowed[msg.sender][spender] = (
225       _allowed[msg.sender][spender].sub(subtractedValue));
226     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
227     return true;
228   }
229 
230   /**
231   * @dev Transfer token for a specified addresses
232   * @param from The address to transfer from.
233   * @param to The address to transfer to.
234   * @param value The amount to be transferred.
235   */
236   function _transfer(address from, address to, uint256 value) internal {
237     require(value <= _balances[from]);
238     require(to != address(0));
239 
240     _balances[from] = _balances[from].sub(value);
241     _balances[to] = _balances[to].add(value);
242     emit Transfer(from, to, value);
243   }
244 
245   /**
246    * @dev Internal function that mints an amount of the token and assigns it to
247    * an account. This encapsulates the modification of balances such that the
248    * proper events are emitted.
249    * @param account The account that will receive the created tokens.
250    * @param value The amount that will be created.
251    */
252   function _mint(address account, uint256 value) internal {
253     require(account != 0);
254     _totalSupply = _totalSupply.add(value);
255     _balances[account] = _balances[account].add(value);
256     emit Transfer(address(0), account, value);
257   }
258 
259   /**
260    * @dev Internal function that burns an amount of the token of a given
261    * account.
262    * @param account The account whose tokens will be burnt.
263    * @param value The amount that will be burnt.
264    */
265   function _burn(address account, uint256 value) internal {
266     require(account != 0);
267     require(value <= _balances[account]);
268 
269     _totalSupply = _totalSupply.sub(value);
270     _balances[account] = _balances[account].sub(value);
271     emit Transfer(account, address(0), value);
272   }
273 
274   /**
275    * @dev Internal function that burns an amount of the token of a given
276    * account, deducting from the sender's allowance for said account. Uses the
277    * internal burn function.
278    * @param account The account whose tokens will be burnt.
279    * @param value The amount that will be burnt.
280    */
281   function _burnFrom(address account, uint256 value) internal {
282     require(value <= _allowed[account][msg.sender]);
283 
284     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
285     // this function needs to emit an event with the updated approval.
286     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
287       value);
288     _burn(account, value);
289   }
290 }
291 
292 contract CNG is ERC20 {
293   string public name = "Change equity-like token";
294   string public symbol = "CNG";
295   uint256 public constant decimals = 18;
296 
297   uint256 public constant INITIAL_SUPPLY = 79184115 * (10 ** decimals);
298 
299   constructor() public {
300     _mint(msg.sender, INITIAL_SUPPLY);
301   }
302 }