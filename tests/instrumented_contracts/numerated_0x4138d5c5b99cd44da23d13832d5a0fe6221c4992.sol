1 pragma solidity ^0.4.23;
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
101 
102 /**
103  * @title Standard ERC20 token
104  *
105  * @dev Implementation of the basic standard token.
106  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
107  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
108  */
109 contract ERC20 is IERC20 {
110   using SafeMath for uint256;
111 
112   mapping (address => uint256) private _balances;
113 
114   mapping (address => mapping (address => uint256)) private _allowed;
115 
116   uint256 private _totalSupply;
117 
118   /**
119   * @dev Total number of tokens in existence
120   */
121   function totalSupply() public view returns (uint256) {
122     return _totalSupply;
123   }
124 
125   /**
126   * @dev Gets the balance of the specified address.
127   * @param owner The address to query the balance of.
128   * @return An uint256 representing the amount owned by the passed address.
129   */
130   function balanceOf(address owner) public view returns (uint256) {
131     return _balances[owner];
132   }
133 
134   /**
135    * @dev Function to check the amount of tokens that an owner allowed to a spender.
136    * @param owner address The address which owns the funds.
137    * @param spender address The address which will spend the funds.
138    * @return A uint256 specifying the amount of tokens still available for the spender.
139    */
140   function allowance(
141     address owner,
142     address spender
143    )
144     public
145     view
146     returns (uint256)
147   {
148     return _allowed[owner][spender];
149   }
150 
151   /**
152   * @dev Transfer token for a specified address
153   * @param to The address to transfer to.
154   * @param value The amount to be transferred.
155   */
156   function transfer(address to, uint256 value) public returns (bool) {
157     _transfer(msg.sender, to, value);
158     return true;
159   }
160 
161   /**
162    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
163    * Beware that changing an allowance with this method brings the risk that someone may use both the old
164    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
165    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
166    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
167    * @param spender The address which will spend the funds.
168    * @param value The amount of tokens to be spent.
169    */
170   function approve(address spender, uint256 value) public returns (bool) {
171     require(spender != address(0));
172 
173     _allowed[msg.sender][spender] = value;
174     emit Approval(msg.sender, spender, value);
175     return true;
176   }
177 
178   /**
179    * @dev Transfer tokens from one address to another
180    * @param from address The address which you want to send tokens from
181    * @param to address The address which you want to transfer to
182    * @param value uint256 the amount of tokens to be transferred
183    */
184   function transferFrom(
185     address from,
186     address to,
187     uint256 value
188   )
189     public
190     returns (bool)
191   {
192     require(value <= _allowed[from][msg.sender]);
193 
194     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
195     _transfer(from, to, value);
196     return true;
197   }
198 
199   /**
200    * @dev Increase the amount of tokens that an owner allowed to a spender.
201    * approve should be called when allowed_[_spender] == 0. To increment
202    * allowed value is better to use this function to avoid 2 calls (and wait until
203    * the first transaction is mined)
204    * From MonolithDAO Token.sol
205    * @param spender The address which will spend the funds.
206    * @param addedValue The amount of tokens to increase the allowance by.
207    */
208   function increaseAllowance(
209     address spender,
210     uint256 addedValue
211   )
212     public
213     returns (bool)
214   {
215     require(spender != address(0));
216 
217     _allowed[msg.sender][spender] = (
218       _allowed[msg.sender][spender].add(addedValue));
219     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
220     return true;
221   }
222 
223   /**
224    * @dev Decrease the amount of tokens that an owner allowed to a spender.
225    * approve should be called when allowed_[_spender] == 0. To decrement
226    * allowed value is better to use this function to avoid 2 calls (and wait until
227    * the first transaction is mined)
228    * From MonolithDAO Token.sol
229    * @param spender The address which will spend the funds.
230    * @param subtractedValue The amount of tokens to decrease the allowance by.
231    */
232   function decreaseAllowance(
233     address spender,
234     uint256 subtractedValue
235   )
236     public
237     returns (bool)
238   {
239     require(spender != address(0));
240 
241     _allowed[msg.sender][spender] = (
242       _allowed[msg.sender][spender].sub(subtractedValue));
243     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
244     return true;
245   }
246 
247   /**
248   * @dev Transfer token for a specified addresses
249   * @param from The address to transfer from.
250   * @param to The address to transfer to.
251   * @param value The amount to be transferred.
252   */
253   function _transfer(address from, address to, uint256 value) internal {
254     require(value <= _balances[from]);
255     require(to != address(0));
256 
257     _balances[from] = _balances[from].sub(value);
258     _balances[to] = _balances[to].add(value);
259     emit Transfer(from, to, value);
260   }
261 
262   /**
263    * @dev Internal function that mints an amount of the token and assigns it to
264    * an account. This encapsulates the modification of balances such that the
265    * proper events are emitted.
266    * @param account The account that will receive the created tokens.
267    * @param value The amount that will be created.
268    */
269   function _mint(address account, uint256 value) internal {
270     require(account != 0);
271     _totalSupply = _totalSupply.add(value);
272     _balances[account] = _balances[account].add(value);
273     emit Transfer(address(0), account, value);
274   }
275 
276   /**
277    * @dev Internal function that burns an amount of the token of a given
278    * account.
279    * @param account The account whose tokens will be burnt.
280    * @param value The amount that will be burnt.
281    */
282   function _burn(address account, uint256 value) internal {
283     require(account != 0);
284     require(value <= _balances[account]);
285 
286     _totalSupply = _totalSupply.sub(value);
287     _balances[account] = _balances[account].sub(value);
288     emit Transfer(account, address(0), value);
289   }
290 
291   /**
292    * @dev Internal function that burns an amount of the token of a given
293    * account, deducting from the sender's allowance for said account. Uses the
294    * internal burn function.
295    * @param account The account whose tokens will be burnt.
296    * @param value The amount that will be burnt.
297    */
298   function _burnFrom(address account, uint256 value) internal {
299     require(value <= _allowed[account][msg.sender]);
300 
301     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
302     // this function needs to emit an event with the updated approval.
303     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
304       value);
305     _burn(account, value);
306   }
307 }
308 
309 /**
310  * @title ERC20Detailed token
311  * @dev The decimals are only for visualization purposes.
312  * All the operations are done using the smallest and indivisible token unit,
313  * just as on Ethereum all the operations are done in wei.
314  */
315 contract ERC20Detailed is IERC20 {
316   string private _name;
317   string private _symbol;
318   uint8 private _decimals;
319 
320   constructor(string name, string symbol, uint8 decimals) public {
321     _name = name;
322     _symbol = symbol;
323     _decimals = decimals;
324   }
325 
326   /**
327    * @return the name of the token.
328    */
329   function name() public view returns(string) {
330     return _name;
331   }
332 
333   /**
334    * @return the symbol of the token.
335    */
336   function symbol() public view returns(string) {
337     return _symbol;
338   }
339 
340   /**
341    * @return the number of decimals of the token.
342    */
343   function decimals() public view returns(uint8) {
344     return _decimals;
345   }
346 }
347 
348 
349 contract OctopusToken is ERC20, ERC20Detailed {
350 
351     constructor()
352         ERC20Detailed("Octopus Token", "OCT", 0)
353         ERC20()
354         public
355     {
356         _mint(msg.sender, 88888888);
357     }
358 }