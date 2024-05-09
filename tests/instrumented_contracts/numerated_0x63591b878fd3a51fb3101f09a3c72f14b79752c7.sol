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
67 interface IERC20 {
68   function totalSupply() external view returns (uint256);
69 
70   function balanceOf(address who) external view returns (uint256);
71 
72   function allowance(address owner, address spender)
73     external view returns (uint256);
74 
75   function transfer(address to, uint256 value) external returns (bool);
76 
77   function approve(address spender, uint256 value)
78     external returns (bool);
79 
80   function transferFrom(address from, address to, uint256 value)
81     external returns (bool);
82 
83   event Transfer(
84     address indexed from,
85     address indexed to,
86     uint256 value
87   );
88 
89   event Approval(
90     address indexed owner,
91     address indexed spender,
92     uint256 value
93   );
94 }
95 
96 /**
97  * @title Standard ERC20 token
98  *
99  * @dev Implementation of the basic standard token.
100  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
101  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
102  */
103 contract ZUE is IERC20 {
104   using SafeMath for uint256;
105 
106   mapping (address => uint256) private _balances;
107 
108   mapping (address => mapping (address => uint256)) private _allowed;
109 
110   uint256 private _totalSupply;
111   string public name = "ZUEN CAPITAL CHAIN";
112   uint8 public decimals = 18;    
113   string public symbol = "ZUE";    
114     
115   constructor() public {
116          uint256 _initialAmount = 690000000;
117         _totalSupply = _initialAmount * 10 ** uint256(decimals);         
118         _balances[msg.sender] = _totalSupply; 
119  }
120     
121   /**
122   * @dev Total number of tokens in existence
123   */
124   function totalSupply() public view returns (uint256) {
125     return _totalSupply;
126   }
127 
128   /**
129   * @dev Gets the balance of the specified address.
130   * @param owner The address to query the balance of.
131   * @return An uint256 representing the amount owned by the passed address.
132   */
133   function balanceOf(address owner) public view returns (uint256) {
134     return _balances[owner];
135   }
136 
137   /**
138    * @dev Function to check the amount of tokens that an owner allowed to a spender.
139    * @param owner address The address which owns the funds.
140    * @param spender address The address which will spend the funds.
141    * @return A uint256 specifying the amount of tokens still available for the spender.
142    */
143   function allowance(
144     address owner,
145     address spender
146    )
147     public
148     view
149     returns (uint256)
150   {
151     return _allowed[owner][spender];
152   }
153 
154   /**
155   * @dev Transfer token for a specified address
156   * @param to The address to transfer to.
157   * @param value The amount to be transferred.
158   */
159   function transfer(address to, uint256 value) public returns (bool) {
160     require(value <= _balances[msg.sender]);
161     require(to != address(0));
162 
163     _balances[msg.sender] = _balances[msg.sender].sub(value);
164     _balances[to] = _balances[to].add(value);
165     emit Transfer(msg.sender, to, value);
166     return true;
167   }
168 
169   /**
170    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
171    * Beware that changing an allowance with this method brings the risk that someone may use both the old
172    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
173    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
174    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
175    * @param spender The address which will spend the funds.
176    * @param value The amount of tokens to be spent.
177    */
178   function approve(address spender, uint256 value) public returns (bool) {
179     require(spender != address(0));
180 
181     _allowed[msg.sender][spender] = value;
182     emit Approval(msg.sender, spender, value);
183     return true;
184   }
185 
186   /**
187    * @dev Transfer tokens from one address to another
188    * @param from address The address which you want to send tokens from
189    * @param to address The address which you want to transfer to
190    * @param value uint256 the amount of tokens to be transferred
191    */
192   function transferFrom(
193     address from,
194     address to,
195     uint256 value
196   )
197     public
198     returns (bool)
199   {
200     require(value <= _balances[from]);
201     require(value <= _allowed[from][msg.sender]);
202     require(to != address(0));
203 
204     _balances[from] = _balances[from].sub(value);
205     _balances[to] = _balances[to].add(value);
206     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
207     emit Transfer(from, to, value);
208     return true;
209   }
210 
211   /**
212    * @dev Increase the amount of tokens that an owner allowed to a spender.
213    * approve should be called when allowed_[_spender] == 0. To increment
214    * allowed value is better to use this function to avoid 2 calls (and wait until
215    * the first transaction is mined)
216    * From MonolithDAO Token.sol
217    * @param spender The address which will spend the funds.
218    * @param addedValue The amount of tokens to increase the allowance by.
219    */
220   function increaseAllowance(
221     address spender,
222     uint256 addedValue
223   )
224     public
225     returns (bool)
226   {
227     require(spender != address(0));
228 
229     _allowed[msg.sender][spender] = (
230       _allowed[msg.sender][spender].add(addedValue));
231     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
232     return true;
233   }
234 
235   /**
236    * @dev Decrease the amount of tokens that an owner allowed to a spender.
237    * approve should be called when allowed_[_spender] == 0. To decrement
238    * allowed value is better to use this function to avoid 2 calls (and wait until
239    * the first transaction is mined)
240    * From MonolithDAO Token.sol
241    * @param spender The address which will spend the funds.
242    * @param subtractedValue The amount of tokens to decrease the allowance by.
243    */
244   function decreaseAllowance(
245     address spender,
246     uint256 subtractedValue
247   )
248     public
249     returns (bool)
250   {
251     require(spender != address(0));
252 
253     _allowed[msg.sender][spender] = (
254       _allowed[msg.sender][spender].sub(subtractedValue));
255     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
256     return true;
257   }
258 
259   /**
260    * @dev Internal function that mints an amount of the token and assigns it to
261    * an account. This encapsulates the modification of balances such that the
262    * proper events are emitted.
263    * @param account The account that will receive the created tokens.
264    * @param amount The amount that will be created.
265    */
266   function _mint(address account, uint256 amount) internal {
267     require(account != 0);
268     _totalSupply = _totalSupply.add(amount);
269     _balances[account] = _balances[account].add(amount);
270     emit Transfer(address(0), account, amount);
271   }
272 
273   /**
274    * @dev Internal function that burns an amount of the token of a given
275    * account.
276    * @param account The account whose tokens will be burnt.
277    * @param amount The amount that will be burnt.
278    */
279   function _burn(address account, uint256 amount) internal {
280     require(account != 0);
281     require(amount <= _balances[account]);
282 
283     _totalSupply = _totalSupply.sub(amount);
284     _balances[account] = _balances[account].sub(amount);
285     emit Transfer(account, address(0), amount);
286   }
287 
288   /**
289    * @dev Internal function that burns an amount of the token of a given
290    * account, deducting from the sender's allowance for said account. Uses the
291    * internal burn function.
292    * @param account The account whose tokens will be burnt.
293    * @param amount The amount that will be burnt.
294    */
295   function _burnFrom(address account, uint256 amount) internal {
296     require(amount <= _allowed[account][msg.sender]);
297 
298     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
299     // this function needs to emit an event with the updated approval.
300     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
301       amount);
302     _burn(account, amount);
303   }
304 }