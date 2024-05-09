1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 interface IERC20 {
8   function totalSupply() external view returns (uint256);
9 
10   function balanceOf(address who) external view returns (uint256);
11 
12   function allowance(address owner, address spender)
13     external view returns (uint256);
14 
15   function transfer(address to, uint256 value) external returns (bool);
16 
17   function approve(address spender, uint256 value)
18     external returns (bool);
19 
20   function transferFrom(address from, address to, uint256 value)
21     external returns (bool);
22 
23   event Transfer(
24     address indexed from,
25     address indexed to,
26     uint256 value
27   );
28 
29   event Approval(
30     address indexed owner,
31     address indexed spender,
32     uint256 value
33   );
34 }
35 
36 
37 
38 /**
39  * @title SafeMath
40  * @dev Math operations with safety checks that revert on error
41  */
42 library SafeMath {
43 
44   /**
45   * @dev Multiplies two numbers, reverts on overflow.
46   */
47   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
48     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
49     // benefit is lost if 'b' is also tested.
50     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
51     if (a == 0) {
52       return 0;
53     }
54 
55     uint256 c = a * b;
56     require(c / a == b);
57 
58     return c;
59   }
60 
61   /**
62   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
63   */
64   function div(uint256 a, uint256 b) internal pure returns (uint256) {
65     require(b > 0); // Solidity only automatically asserts when dividing by 0
66     uint256 c = a / b;
67     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
68 
69     return c;
70   }
71 
72   /**
73   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
74   */
75   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
76     require(b <= a);
77     uint256 c = a - b;
78 
79     return c;
80   }
81 
82   /**
83   * @dev Adds two numbers, reverts on overflow.
84   */
85   function add(uint256 a, uint256 b) internal pure returns (uint256) {
86     uint256 c = a + b;
87     require(c >= a);
88 
89     return c;
90   }
91 
92   /**
93   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
94   * reverts when dividing by zero.
95   */
96   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
97     require(b != 0);
98     return a % b;
99   }
100 }
101 
102 
103 /**
104  * @title Standard ERC20 token
105  *
106  * @dev Implementation of the basic standard token.
107  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
108  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
109  */
110 contract ERC20 is IERC20 {
111   using SafeMath for uint256;
112 
113   mapping (address => uint256) private _balances;
114 
115   mapping (address => mapping (address => uint256)) private _allowed;
116 
117   uint256 private _totalSupply;
118 
119   /**
120   * @dev Total number of tokens in existence
121   */
122   function totalSupply() public view returns (uint256) {
123     return _totalSupply;
124   }
125 
126   /**
127   * @dev Gets the balance of the specified address.
128   * @param owner The address to query the balance of.
129   * @return An uint256 representing the amount owned by the passed address.
130   */
131   function balanceOf(address owner) public view returns (uint256) {
132     return _balances[owner];
133   }
134 
135   /**
136    * @dev Function to check the amount of tokens that an owner allowed to a spender.
137    * @param owner address The address which owns the funds.
138    * @param spender address The address which will spend the funds.
139    * @return A uint256 specifying the amount of tokens still available for the spender.
140    */
141   function allowance(
142     address owner,
143     address spender
144    )
145     public
146     view
147     returns (uint256)
148   {
149     return _allowed[owner][spender];
150   }
151 
152   /**
153   * @dev Transfer token for a specified address
154   * @param to The address to transfer to.
155   * @param value The amount to be transferred.
156   */
157   function transfer(address to, uint256 value) public returns (bool) {
158     require(value <= _balances[msg.sender]);
159     require(to != address(0));
160 
161     _balances[msg.sender] = _balances[msg.sender].sub(value);
162     _balances[to] = _balances[to].add(value);
163     emit Transfer(msg.sender, to, value);
164     return true;
165   }
166 
167   /**
168    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
169    * Beware that changing an allowance with this method brings the risk that someone may use both the old
170    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
171    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
172    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
173    * @param spender The address which will spend the funds.
174    * @param value The amount of tokens to be spent.
175    */
176   function approve(address spender, uint256 value) public returns (bool) {
177     require(spender != address(0));
178 
179     _allowed[msg.sender][spender] = value;
180     emit Approval(msg.sender, spender, value);
181     return true;
182   }
183 
184   /**
185    * @dev Transfer tokens from one address to another
186    * @param from address The address which you want to send tokens from
187    * @param to address The address which you want to transfer to
188    * @param value uint256 the amount of tokens to be transferred
189    */
190   function transferFrom(
191     address from,
192     address to,
193     uint256 value
194   )
195     public
196     returns (bool)
197   {
198     require(value <= _balances[from]);
199     require(value <= _allowed[from][msg.sender]);
200     require(to != address(0));
201 
202     _balances[from] = _balances[from].sub(value);
203     _balances[to] = _balances[to].add(value);
204     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
205     emit Transfer(from, to, value);
206     return true;
207   }
208 
209   /**
210    * @dev Increase the amount of tokens that an owner allowed to a spender.
211    * approve should be called when allowed_[_spender] == 0. To increment
212    * allowed value is better to use this function to avoid 2 calls (and wait until
213    * the first transaction is mined)
214    * From MonolithDAO Token.sol
215    * @param spender The address which will spend the funds.
216    * @param addedValue The amount of tokens to increase the allowance by.
217    */
218   function increaseAllowance(
219     address spender,
220     uint256 addedValue
221   )
222     public
223     returns (bool)
224   {
225     require(spender != address(0));
226 
227     _allowed[msg.sender][spender] = (
228       _allowed[msg.sender][spender].add(addedValue));
229     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
230     return true;
231   }
232 
233   /**
234    * @dev Decrease the amount of tokens that an owner allowed to a spender.
235    * approve should be called when allowed_[_spender] == 0. To decrement
236    * allowed value is better to use this function to avoid 2 calls (and wait until
237    * the first transaction is mined)
238    * From MonolithDAO Token.sol
239    * @param spender The address which will spend the funds.
240    * @param subtractedValue The amount of tokens to decrease the allowance by.
241    */
242   function decreaseAllowance(
243     address spender,
244     uint256 subtractedValue
245   )
246     public
247     returns (bool)
248   {
249     require(spender != address(0));
250 
251     _allowed[msg.sender][spender] = (
252       _allowed[msg.sender][spender].sub(subtractedValue));
253     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
254     return true;
255   }
256 
257   /**
258    * @dev Internal function that mints an amount of the token and assigns it to
259    * an account. This encapsulates the modification of balances such that the
260    * proper events are emitted.
261    * @param account The account that will receive the created tokens.
262    * @param amount The amount that will be created.
263    */
264   function _mint(address account, uint256 amount) internal {
265     require(account != 0);
266     _totalSupply = _totalSupply.add(amount);
267     _balances[account] = _balances[account].add(amount);
268     emit Transfer(address(0), account, amount);
269   }
270 
271   /**
272    * @dev Internal function that burns an amount of the token of a given
273    * account.
274    * @param account The account whose tokens will be burnt.
275    * @param amount The amount that will be burnt.
276    */
277   function _burn(address account, uint256 amount) internal {
278     require(account != 0);
279     require(amount <= _balances[account]);
280 
281     _totalSupply = _totalSupply.sub(amount);
282     _balances[account] = _balances[account].sub(amount);
283     emit Transfer(account, address(0), amount);
284   }
285 
286   /**
287    * @dev Internal function that burns an amount of the token of a given
288    * account, deducting from the sender's allowance for said account. Uses the
289    * internal burn function.
290    * @param account The account whose tokens will be burnt.
291    * @param amount The amount that will be burnt.
292    */
293   function _burnFrom(address account, uint256 amount) internal {
294     require(amount <= _allowed[account][msg.sender]);
295 
296     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
297     // this function needs to emit an event with the updated approval.
298     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
299       amount);
300     _burn(account, amount);
301   }
302 }
303 
304 
305 /**
306  * @title IPChainToken
307  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
308  * Note they can later distribute these tokens as they wish using `transfer` and other
309  * `ERC20` functions.
310  */
311 contract VCTToken is ERC20 {
312 
313   string public constant name = "VCTToken";
314   string public constant symbol = "VCT";
315   uint8 public constant decimals = 18;
316 
317   uint256 public constant INITIAL_SUPPLY = 2100000000 * (10 ** uint256(decimals));
318 
319   /**
320    * @dev Constructor that gives msg.sender all of existing tokens.
321    */
322   constructor() public {
323     _mint(msg.sender, INITIAL_SUPPLY);
324   }
325 
326 }