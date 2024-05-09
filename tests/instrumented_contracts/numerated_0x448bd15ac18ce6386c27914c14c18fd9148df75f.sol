1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/20
7  */
8 interface IERC20 {
9   function totalSupply() external view returns (uint256);
10 
11   function balanceOf(address who) external view returns (uint256);
12 
13   function allowance(address owner, address spender)
14     external view returns (uint256);
15 
16   function transfer(address to, uint256 value) external returns (bool);
17 
18   function approve(address spender, uint256 value)
19     external returns (bool);
20 
21   function transferFrom(address from, address to, uint256 value)
22     external returns (bool);
23 
24   event Transfer(
25     address indexed from,
26     address indexed to,
27     uint256 value
28   );
29 
30   event Approval(
31     address indexed owner,
32     address indexed spender,
33     uint256 value
34   );
35 }
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
110 contract XS2Token is IERC20 {
111   using SafeMath for uint256;
112   
113   string private _name;
114   string private _symbol;
115   uint8 private _decimals;
116 
117   mapping (address => uint256) private _balances;
118 
119   mapping (address => mapping (address => uint256)) private _allowed;
120 
121   uint256 private _totalSupply;
122 
123   constructor() public {
124     _name = "XS2 Token";
125     _symbol = "XS2";
126     _decimals = 18;
127     _mint(msg.sender, 20000000000000000000000000); // 20 Million Tokens
128   }
129 
130   /**
131    * @return the name of the token.
132    */
133   function name() public view returns(string) {
134     return _name;
135   }
136 
137   /**
138    * @return the symbol of the token.
139    */
140   function symbol() public view returns(string) {
141     return _symbol;
142   }
143 
144   /**
145    * @return the number of decimals of the token.
146    */
147   function decimals() public view returns(uint8) {
148     return _decimals;
149   }  
150 
151   /**
152   * @dev Total number of tokens in existence
153   */
154   function totalSupply() public view returns (uint256) {
155     return _totalSupply;
156   }
157 
158   /**
159   * @dev Gets the balance of the specified address.
160   * @param owner The address to query the balance of.
161   * @return An uint256 representing the amount owned by the passed address.
162   */
163   function balanceOf(address owner) public view returns (uint256) {
164     return _balances[owner];
165   }
166 
167   /**
168    * @dev Function to check the amount of tokens that an owner allowed to a spender.
169    * @param owner address The address which owns the funds.
170    * @param spender address The address which will spend the funds.
171    * @return A uint256 specifying the amount of tokens still available for the spender.
172    */
173   function allowance(
174     address owner,
175     address spender
176    )
177     public
178     view
179     returns (uint256)
180   {
181     return _allowed[owner][spender];
182   }
183 
184   /**
185   * @dev Transfer token for a specified address
186   * @param to The address to transfer to.
187   * @param value The amount to be transferred.
188   */
189   function transfer(address to, uint256 value) public returns (bool) {
190     require(value <= _balances[msg.sender]);
191     require(to != address(0));
192 
193     _balances[msg.sender] = _balances[msg.sender].sub(value);
194     _balances[to] = _balances[to].add(value);
195     emit Transfer(msg.sender, to, value);
196     return true;
197   }
198 
199   /**
200    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
201    * Beware that changing an allowance with this method brings the risk that someone may use both the old
202    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
203    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
204    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
205    * @param spender The address which will spend the funds.
206    * @param value The amount of tokens to be spent.
207    */
208   function approve(address spender, uint256 value) public returns (bool) {
209     require(spender != address(0));
210 
211     _allowed[msg.sender][spender] = value;
212     emit Approval(msg.sender, spender, value);
213     return true;
214   }
215 
216   /**
217    * @dev Transfer tokens from one address to another
218    * @param from address The address which you want to send tokens from
219    * @param to address The address which you want to transfer to
220    * @param value uint256 the amount of tokens to be transferred
221    */
222   function transferFrom(
223     address from,
224     address to,
225     uint256 value
226   )
227     public
228     returns (bool)
229   {
230     require(value <= _balances[from]);
231     require(value <= _allowed[from][msg.sender]);
232     require(to != address(0));
233 
234     _balances[from] = _balances[from].sub(value);
235     _balances[to] = _balances[to].add(value);
236     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
237     emit Transfer(from, to, value);
238     return true;
239   }
240 
241   /**
242    * @dev Increase the amount of tokens that an owner allowed to a spender.
243    * approve should be called when allowed_[_spender] == 0. To increment
244    * allowed value is better to use this function to avoid 2 calls (and wait until
245    * the first transaction is mined)
246    * From MonolithDAO Token.sol
247    * @param spender The address which will spend the funds.
248    * @param addedValue The amount of tokens to increase the allowance by.
249    */
250   function increaseAllowance(
251     address spender,
252     uint256 addedValue
253   )
254     public
255     returns (bool)
256   {
257     require(spender != address(0));
258 
259     _allowed[msg.sender][spender] = (
260       _allowed[msg.sender][spender].add(addedValue));
261     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
262     return true;
263   }
264 
265   /**
266    * @dev Decrease the amount of tokens that an owner allowed to a spender.
267    * approve should be called when allowed_[_spender] == 0. To decrement
268    * allowed value is better to use this function to avoid 2 calls (and wait until
269    * the first transaction is mined)
270    * From MonolithDAO Token.sol
271    * @param spender The address which will spend the funds.
272    * @param subtractedValue The amount of tokens to decrease the allowance by.
273    */
274   function decreaseAllowance(
275     address spender,
276     uint256 subtractedValue
277   )
278     public
279     returns (bool)
280   {
281     require(spender != address(0));
282 
283     _allowed[msg.sender][spender] = (
284       _allowed[msg.sender][spender].sub(subtractedValue));
285     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
286     return true;
287   }
288 
289   /**
290    * @dev Internal function that mints an amount of the token and assigns it to
291    * an account. This encapsulates the modification of balances such that the
292    * proper events are emitted.
293    * @param account The account that will receive the created tokens.
294    * @param amount The amount that will be created.
295    */
296   function _mint(address account, uint256 amount) internal {
297     require(account != 0);
298     _totalSupply = _totalSupply.add(amount);
299     _balances[account] = _balances[account].add(amount);
300     emit Transfer(address(0), account, amount);
301   }
302 
303   /**
304    * @dev Internal function that burns an amount of the token of a given
305    * account.
306    * @param account The account whose tokens will be burnt.
307    * @param amount The amount that will be burnt.
308    */
309   function _burn(address account, uint256 amount) internal {
310     require(account != 0);
311     require(amount <= _balances[account]);
312 
313     _totalSupply = _totalSupply.sub(amount);
314     _balances[account] = _balances[account].sub(amount);
315     emit Transfer(account, address(0), amount);
316   }
317 
318   /**
319    * @dev Burns a specific amount of tokens.
320    * @param value The amount of token to be burned.
321    */
322   function burn(uint256 value) public {
323     _burn(msg.sender, value);
324   }
325 }