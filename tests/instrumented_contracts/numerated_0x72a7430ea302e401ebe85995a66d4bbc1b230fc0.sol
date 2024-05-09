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
125   * @param owner The address to query the balance of.
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
155     _transfer(msg.sender, to, value);
156     return true;
157   }
158 
159   /**
160    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
161    * Beware that changing an allowance with this method brings the risk that someone may use both the old
162    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
163    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
164    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
165    * @param spender The address which will spend the funds.
166    * @param value The amount of tokens to be spent.
167    */
168   function approve(address spender, uint256 value) public returns (bool) {
169     require(spender != address(0));
170 
171     _allowed[msg.sender][spender] = value;
172     emit Approval(msg.sender, spender, value);
173     return true;
174   }
175 
176   /**
177    * @dev Transfer tokens from one address to another
178    * @param from address The address which you want to send tokens from
179    * @param to address The address which you want to transfer to
180    * @param value uint256 the amount of tokens to be transferred
181    */
182   function transferFrom(
183     address from,
184     address to,
185     uint256 value
186   )
187     public
188     returns (bool)
189   {
190     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
191     _transfer(from, to, value);
192     return true;
193   }
194 
195   /**
196    * @dev Increase the amount of tokens that an owner allowed to a spender.
197    * approve should be called when allowed_[_spender] == 0. To increment
198    * allowed value is better to use this function to avoid 2 calls (and wait until
199    * the first transaction is mined)
200    * From MonolithDAO Token.sol
201    * @param spender The address which will spend the funds.
202    * @param addedValue The amount of tokens to increase the allowance by.
203    */
204   function increaseAllowance(
205     address spender,
206     uint256 addedValue
207   )
208     public
209     returns (bool)
210   {
211     require(spender != address(0));
212 
213     _allowed[msg.sender][spender] = (
214       _allowed[msg.sender][spender].add(addedValue));
215     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
216     return true;
217   }
218 
219   /**
220    * @dev Decrease the amount of tokens that an owner allowed to a spender.
221    * approve should be called when allowed_[_spender] == 0. To decrement
222    * allowed value is better to use this function to avoid 2 calls (and wait until
223    * the first transaction is mined)
224    * From MonolithDAO Token.sol
225    * @param spender The address which will spend the funds.
226    * @param subtractedValue The amount of tokens to decrease the allowance by.
227    */
228   function decreaseAllowance(
229     address spender,
230     uint256 subtractedValue
231   )
232     public
233     returns (bool)
234   {
235     require(spender != address(0));
236 
237     _allowed[msg.sender][spender] = (
238       _allowed[msg.sender][spender].sub(subtractedValue));
239     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
240     return true;
241   }
242 
243   /**
244   * @dev Transfer token for a specified addresses
245   * @param from The address to transfer from.
246   * @param to The address to transfer to.
247   * @param value The amount to be transferred.
248   */
249   function _transfer(address from, address to, uint256 value) internal {
250     require(to != address(0));
251 
252     _balances[from] = _balances[from].sub(value);
253     _balances[to] = _balances[to].add(value);
254     emit Transfer(from, to, value);
255   }
256 
257   /**
258    * @dev Internal function that mints an amount of the token and assigns it to
259    * an account. This encapsulates the modification of balances such that the
260    * proper events are emitted.
261    * @param account The account that will receive the created tokens.
262    * @param value The amount that will be created.
263    */
264   function _mint(address account, uint256 value) internal {
265     require(account != address(0));
266 
267     _totalSupply = _totalSupply.add(value);
268     _balances[account] = _balances[account].add(value);
269     emit Transfer(address(0), account, value);
270   }
271 
272   /**
273    * @dev Internal function that burns an amount of the token of a given
274    * account.
275    * @param account The account whose tokens will be burnt.
276    * @param value The amount that will be burnt.
277    */
278   function _burn(address account, uint256 value) internal {
279     require(account != address(0));
280 
281     _totalSupply = _totalSupply.sub(value);
282     _balances[account] = _balances[account].sub(value);
283     emit Transfer(account, address(0), value);
284   }
285 
286   /**
287    * @dev Internal function that burns an amount of the token of a given
288    * account, deducting from the sender's allowance for said account. Uses the
289    * internal burn function.
290    * @param account The account whose tokens will be burnt.
291    * @param value The amount that will be burnt.
292    */
293   function _burnFrom(address account, uint256 value) internal {
294     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
295     // this function needs to emit an event with the updated approval.
296     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
297       value);
298     _burn(account, value);
299   }
300 }
301 
302 /**
303  * @title Burnable Token
304  * @dev Token that can be irreversibly burned (destroyed).
305  */
306 contract ERC20Burnable is ERC20 {
307 
308   /**
309    * @dev Burns a specific amount of tokens.
310    * @param value The amount of token to be burned.
311    */
312   function burn(uint256 value) public {
313     _burn(msg.sender, value);
314   }
315 
316   /**
317    * @dev Burns a specific amount of tokens from the target address and decrements allowance
318    * @param from address The address which you want to send tokens from
319    * @param value uint256 The amount of token to be burned
320    */
321   function burnFrom(address from, uint256 value) public {
322     _burnFrom(from, value);
323   }
324 }
325 
326 contract StockusToken is ERC20Burnable {
327 
328   string public constant name = "Stockus Token";
329   string public constant symbol = "STT";
330   uint8 public constant decimals = 5;
331 
332   uint256 public constant INITIAL_SUPPLY = 15000000 * (10 ** uint256(decimals));
333 
334   constructor(address minter) public {
335     _mint(minter, INITIAL_SUPPLY);
336   }
337 
338 }