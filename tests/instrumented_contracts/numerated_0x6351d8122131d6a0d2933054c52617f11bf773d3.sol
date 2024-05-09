1 // CGT IS THE BEST DISCORD EVER!
2 // https://discord.gg/jbHKHTS
3 // LOVE FROM ETHERGUY
4 
5 pragma solidity ^0.4.24;
6 
7 /**
8  * @title ERC20 interface
9  * @dev see https://github.com/ethereum/EIPs/issues/20
10  */
11 interface IERC20 {
12   function totalSupply() external view returns (uint256);
13 
14   function balanceOf(address who) external view returns (uint256);
15 
16   function allowance(address owner, address spender)
17     external view returns (uint256);
18 
19   function transfer(address to, uint256 value) external returns (bool);
20 
21   function approve(address spender, uint256 value)
22     external returns (bool);
23 
24   function transferFrom(address from, address to, uint256 value)
25     external returns (bool);
26 
27   event Transfer(
28     address indexed from,
29     address indexed to,
30     uint256 value
31   );
32 
33   event Approval(
34     address indexed owner,
35     address indexed spender,
36     uint256 value
37   );
38 }
39 
40 /**
41  * @title Standard ERC20 token
42  *
43  * @dev Implementation of the basic standard token.
44  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
45  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
46  */
47 contract SCAMTOKENBYETHERGUY_CGT_BEST_DISCORD is IERC20 {
48   using SafeMath for uint256;
49 
50   mapping (address => uint256) private _balances;
51 
52   mapping (address => mapping (address => uint256)) private _allowed;
53 
54   uint256 private _totalSupply;
55    
56   string public name = "SCAM";
57   string public symbol = "SCAM";
58 
59   /**
60   * @dev Total number of tokens in existence
61   */
62   function totalSupply() public view returns (uint256) {
63     return _totalSupply;
64   }
65 
66   /**
67   * @dev Gets the balance of the specified address.
68   * @param owner The address to query the balance of.
69   * @return An uint256 representing the amount owned by the passed address.
70   */
71   function balanceOf(address owner) public view returns (uint256) {
72     return _balances[owner];
73   }
74 
75   /**
76    * @dev Function to check the amount of tokens that an owner allowed to a spender.
77    * @param owner address The address which owns the funds.
78    * @param spender address The address which will spend the funds.
79    * @return A uint256 specifying the amount of tokens still available for the spender.
80    */
81   function allowance(
82     address owner,
83     address spender
84    )
85     public
86     view
87     returns (uint256)
88   {
89     return _allowed[owner][spender];
90   }
91 
92   /**
93   * @dev Transfer token for a specified address
94   * @param to The address to transfer to.
95   * @param value The amount to be transferred.
96   */
97   function transfer(address to, uint256 value) public returns (bool) {
98     require(value <= _balances[msg.sender]);
99     require(to != address(0));
100 
101     _balances[msg.sender] = _balances[msg.sender].sub(value);
102     _balances[to] = _balances[to].add(value);
103     emit Transfer(msg.sender, to, value);
104     return true;
105   }
106 
107   /**
108    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
109    * Beware that changing an allowance with this method brings the risk that someone may use both the old
110    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
111    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
112    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
113    * @param spender The address which will spend the funds.
114    * @param value The amount of tokens to be spent.
115    */
116   function approve(address spender, uint256 value) public returns (bool) {
117     require(spender != address(0));
118 
119     _allowed[msg.sender][spender] = value;
120     emit Approval(msg.sender, spender, value);
121     return true;
122   }
123 
124   /**
125    * @dev Transfer tokens from one address to another
126    * @param from address The address which you want to send tokens from
127    * @param to address The address which you want to transfer to
128    * @param value uint256 the amount of tokens to be transferred
129    */
130   function transferFrom(
131     address from,
132     address to,
133     uint256 value
134   )
135     public
136     returns (bool)
137   {
138     require(value <= _balances[from]);
139     require(value <= _allowed[from][msg.sender]);
140     require(to != address(0));
141 
142     _balances[from] = _balances[from].sub(value);
143     _balances[to] = _balances[to].add(value);
144     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
145     emit Transfer(from, to, value);
146     return true;
147   }
148 
149   /**
150    * @dev Increase the amount of tokens that an owner allowed to a spender.
151    * approve should be called when allowed_[_spender] == 0. To increment
152    * allowed value is better to use this function to avoid 2 calls (and wait until
153    * the first transaction is mined)
154    * From MonolithDAO Token.sol
155    * @param spender The address which will spend the funds.
156    * @param addedValue The amount of tokens to increase the allowance by.
157    */
158   function increaseAllowance(
159     address spender,
160     uint256 addedValue
161   )
162     public
163     returns (bool)
164   {
165     require(spender != address(0));
166 
167     _allowed[msg.sender][spender] = (
168       _allowed[msg.sender][spender].add(addedValue));
169     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
170     return true;
171   }
172 
173   /**
174    * @dev Decrease the amount of tokens that an owner allowed to a spender.
175    * approve should be called when allowed_[_spender] == 0. To decrement
176    * allowed value is better to use this function to avoid 2 calls (and wait until
177    * the first transaction is mined)
178    * From MonolithDAO Token.sol
179    * @param spender The address which will spend the funds.
180    * @param subtractedValue The amount of tokens to decrease the allowance by.
181    */
182   function decreaseAllowance(
183     address spender,
184     uint256 subtractedValue
185   )
186     public
187     returns (bool)
188   {
189     require(spender != address(0));
190 
191     _allowed[msg.sender][spender] = (
192       _allowed[msg.sender][spender].sub(subtractedValue));
193     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
194     return true;
195   }
196 
197   /**
198    * @dev Internal function that mints an amount of the token and assigns it to
199    * an account. This encapsulates the modification of balances such that the
200    * proper events are emitted.
201    * @param account The account that will receive the created tokens.
202    * @param amount The amount that will be created.
203    */
204   function mint(address account, uint256 amount) public {
205     require(account != 0);
206     _totalSupply = _totalSupply.add(amount);
207     _balances[account] = _balances[account].add(amount);
208     emit Transfer(address(0), account, amount);
209   }
210 
211   /**
212    * @dev Internal function that burns an amount of the token of a given
213    * account.
214    * @param account The account whose tokens will be burnt.
215    * @param amount The amount that will be burnt.
216    */
217   function _burn(address account, uint256 amount) internal {
218     require(account != 0);
219     require(amount <= _balances[account]);
220 
221     _totalSupply = _totalSupply.sub(amount);
222     _balances[account] = _balances[account].sub(amount);
223     emit Transfer(account, address(0), amount);
224   }
225 
226   /**
227    * @dev Internal function that burns an amount of the token of a given
228    * account, deducting from the sender's allowance for said account. Uses the
229    * internal burn function.
230    * @param account The account whose tokens will be burnt.
231    * @param amount The amount that will be burnt.
232    */
233   function _burnFrom(address account, uint256 amount) internal {
234     require(amount <= _allowed[account][msg.sender]);
235 
236     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
237     // this function needs to emit an event with the updated approval.
238     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
239       amount);
240     _burn(account, amount);
241   }
242 }
243 
244 
245 /**
246  * @title SafeMath
247  * @dev Math operations with safety checks that revert on error
248  */
249 library SafeMath {
250 
251   /**
252   * @dev Multiplies two numbers, reverts on overflow.
253   */
254   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
255     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
256     // benefit is lost if 'b' is also tested.
257     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
258     if (a == 0) {
259       return 0;
260     }
261 
262     uint256 c = a * b;
263     require(c / a == b);
264 
265     return c;
266   }
267 
268   /**
269   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
270   */
271   function div(uint256 a, uint256 b) internal pure returns (uint256) {
272     require(b > 0); // Solidity only automatically asserts when dividing by 0
273     uint256 c = a / b;
274     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
275 
276     return c;
277   }
278 
279   /**
280   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
281   */
282   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
283     require(b <= a);
284     uint256 c = a - b;
285 
286     return c;
287   }
288 
289   /**
290   * @dev Adds two numbers, reverts on overflow.
291   */
292   function add(uint256 a, uint256 b) internal pure returns (uint256) {
293     uint256 c = a + b;
294     require(c >= a);
295 
296     return c;
297   }
298 
299   /**
300   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
301   * reverts when dividing by zero.
302   */
303   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
304     require(b != 0);
305     return a % b;
306   }
307 }