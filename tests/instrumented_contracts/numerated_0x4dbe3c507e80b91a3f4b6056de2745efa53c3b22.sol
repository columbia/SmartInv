1 pragma solidity 0.4.24;
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
71 interface IERC20 {
72   function totalSupply() external view returns (uint256);
73 
74   function balanceOf(address who) external view returns (uint256);
75 
76   function allowance(address owner, address spender)
77     external view returns (uint256);
78 
79   function transfer(address to, uint256 value) external returns (bool);
80 
81   function approve(address spender, uint256 value)
82     external returns (bool);
83 
84   function transferFrom(address from, address to, uint256 value)
85     external returns (bool);
86 
87   event Transfer(
88     address indexed from,
89     address indexed to,
90     uint256 value
91   );
92 
93   event Approval(
94     address indexed owner,
95     address indexed spender,
96     uint256 value
97   );
98 }
99 
100 /**
101  * @title Standard ERC20 token
102  *
103  * @dev Implementation of the basic standard token.
104  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
105  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
106  */
107 contract ERC20 is IERC20 {
108   using SafeMath for uint256;
109 
110   mapping (address => uint256) private _balances;
111 
112   mapping (address => mapping (address => uint256)) private _allowed;
113 
114   uint256 private _totalSupply;
115 
116   /**
117   * @dev Total number of tokens in existence
118   */
119   function totalSupply() public view returns (uint256) {
120     return _totalSupply;
121   }
122 
123   /**
124   * @dev Gets the balance of the specified address.
125   * @param owner The address to query the the balance of.
126   * @return An uint256 representing the amount owned by the passed address.
127   */
128   function balanceOf(address owner) public view returns (uint256) {
129     return _balances[owner];
130   }
131 
132   /**
133    * @dev Function to check the amount of tokens that an owner allowed to a spender.
134    * @param owner address The address which owns the funds.
135    * @param spender address The address which will spend the funds.
136    * @return A uint256 specifying the amount of tokens still available for the spender.
137    */
138   function allowance(
139     address owner,
140     address spender
141    )
142     public
143     view
144     returns (uint256)
145   {
146     return _allowed[owner][spender];
147   }
148 
149   /**
150   * @dev Transfer token for a specified address
151   * @param to The address to transfer to.
152   * @param value The amount to be transferred.
153   */
154   function transfer(address to, uint256 value) public returns (bool) {
155     require(value <= _balances[msg.sender]);
156     require(to != address(0));
157 
158     _balances[msg.sender] = _balances[msg.sender].sub(value);
159     _balances[to] = _balances[to].add(value);
160     emit Transfer(msg.sender, to, value);
161     return true;
162   }
163 
164   /**
165    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
166    * Beware that changing an allowance with this method brings the risk that someone may use both the old
167    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
168    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
169    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
170    * @param spender The address which will spend the funds.
171    * @param value The amount of tokens to be spent.
172    */
173   function approve(address spender, uint256 value) public returns (bool) {
174     require(spender != address(0));
175 
176     _allowed[msg.sender][spender] = value;
177     emit Approval(msg.sender, spender, value);
178     return true;
179   }
180 
181   /**
182    * @dev Transfer tokens from one address to another
183    * @param from address The address which you want to send tokens from
184    * @param to address The address which you want to transfer to
185    * @param value uint256 the amount of tokens to be transferred
186    */
187   function transferFrom(
188     address from,
189     address to,
190     uint256 value
191   )
192     public
193     returns (bool)
194   {
195     require(value <= _balances[from]);
196     require(value <= _allowed[from][msg.sender]);
197     require(to != address(0));
198 
199     _balances[from] = _balances[from].sub(value);
200     _balances[to] = _balances[to].add(value);
201     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
202     emit Transfer(from, to, value);
203     return true;
204   }
205 
206   /**
207    * @dev Increase the amount of tokens that an owner allowed to a spender.
208    * approve should be called when allowed_[_spender] == 0. To increment
209    * allowed value is better to use this function to avoid 2 calls (and wait until
210    * the first transaction is mined)
211    * From MonolithDAO Token.sol
212    * @param spender The address which will spend the funds.
213    * @param addedValue The amount of tokens to increase the allowance by.
214    */
215   function increaseAllowance(
216     address spender,
217     uint256 addedValue
218   )
219     public
220     returns (bool)
221   {
222     require(spender != address(0));
223 
224     _allowed[msg.sender][spender] = (
225       _allowed[msg.sender][spender].add(addedValue));
226     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
227     return true;
228   }
229 
230   /**
231    * @dev Decrease the amount of tokens that an owner allowed to a spender.
232    * approve should be called when allowed_[_spender] == 0. To decrement
233    * allowed value is better to use this function to avoid 2 calls (and wait until
234    * the first transaction is mined)
235    * From MonolithDAO Token.sol
236    * @param spender The address which will spend the funds.
237    * @param subtractedValue The amount of tokens to decrease the allowance by.
238    */
239   function decreaseAllowance(
240     address spender,
241     uint256 subtractedValue
242   )
243     public
244     returns (bool)
245   {
246     require(spender != address(0));
247 
248     _allowed[msg.sender][spender] = (
249       _allowed[msg.sender][spender].sub(subtractedValue));
250     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
251     return true;
252   }
253 
254   /**
255    * @dev Internal function that mints an amount of the token and assigns it to
256    * an account. This encapsulates the modification of balances such that the
257    * proper events are emitted.
258    * @param account The account that will receive the created tokens.
259    * @param amount The amount that will be created.
260    */
261   function _mint(address account, uint256 amount) internal {
262     require(account != 0);
263     _totalSupply = _totalSupply.add(amount);
264     _balances[account] = _balances[account].add(amount);
265     emit Transfer(address(0), account, amount);
266   }
267 
268   /**
269    * @dev Internal function that burns an amount of the token of a given
270    * account.
271    * @param account The account whose tokens will be burnt.
272    * @param amount The amount that will be burnt.
273    */
274   function _burn(address account, uint256 amount) internal {
275     require(account != 0);
276     require(amount <= _balances[account]);
277 
278     _totalSupply = _totalSupply.sub(amount);
279     _balances[account] = _balances[account].sub(amount);
280     emit Transfer(account, address(0), amount);
281   }
282 
283   /**
284    * @dev Internal function that burns an amount of the token of a given
285    * account, deducting from the sender's allowance for said account. Uses the
286    * internal burn function.
287    * @param account The account whose tokens will be burnt.
288    * @param amount The amount that will be burnt.
289    */
290   function _burnFrom(address account, uint256 amount) internal {
291     require(amount <= _allowed[account][msg.sender]);
292 
293     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
294     // this function needs to emit an event with the updated approval.
295     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
296       amount);
297     _burn(account, amount);
298   }
299 }
300 
301 /**
302  * @title Burnable Token
303  * @dev Token that can be irreversibly burned (destroyed).
304  */
305 contract ERC20Burnable is ERC20 {
306 
307   /**
308    * @dev Burns a specific amount of tokens.
309    * @param value The amount of token to be burned.
310    */
311   function burn(uint256 value) public {
312     _burn(msg.sender, value);
313   }
314 
315   /**
316    * @dev Burns a specific amount of tokens from the target address and decrements allowance
317    * @param from address The address which you want to send tokens from
318    * @param value uint256 The amount of token to be burned
319    */
320   function burnFrom(address from, uint256 value) public {
321     _burnFrom(from, value);
322   }
323 
324   /**
325    * @dev Overrides ERC20._burn in order for burn and burnFrom to emit
326    * an additional Burn event.
327    */
328   function _burn(address who, uint256 value) internal {
329     super._burn(who, value);
330   }
331 }
332 
333 contract CryptoVilla is ERC20Burnable {
334     string public constant name = "CryptoVilla Token";
335     string public constant symbol = "CVL";
336     uint8 public constant decimals = 18;
337     
338     uint256 public constant INITIAL_SUPPLY = 100000000 * (10 ** uint256(decimals));
339     
340     /**
341      * @dev Constructor that gives msg.sender all of existing tokens.
342      */
343     constructor() public {
344         _mint(msg.sender, INITIAL_SUPPLY);
345     }
346     
347 }