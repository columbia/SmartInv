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
68  * @title Roles
69  * @dev Library for managing addresses assigned to a Role.
70  */
71 library Roles {
72   struct Role {
73     mapping (address => bool) bearer;
74   }
75 
76   /**
77    * @dev give an account access to this role
78    */
79   function add(Role storage role, address account) internal {
80     require(account != address(0));
81     require(!has(role, account));
82 
83     role.bearer[account] = true;
84   }
85 
86   /**
87    * @dev remove an account's access to this role
88    */
89   function remove(Role storage role, address account) internal {
90     require(account != address(0));
91     require(has(role, account));
92 
93     role.bearer[account] = false;
94   }
95 
96   /**
97    * @dev check if an account has this role
98    * @return bool
99    */
100   function has(Role storage role, address account)
101     internal
102     view
103     returns (bool)
104   {
105     require(account != address(0));
106     return role.bearer[account];
107   }
108 }
109 
110 /**
111  * @title ERC20 interface
112  * @dev see https://github.com/ethereum/EIPs/issues/20
113  */
114  interface IERC20 {
115    function totalSupply() external view returns (uint256);
116 
117    function balanceOf(address who) external view returns (uint256);
118 
119    function allowance(address owner, address spender)
120      external view returns (uint256);
121 
122    function transfer(address to, uint256 value) external returns (bool);
123 
124    function approve(address spender, uint256 value)
125      external returns (bool);
126 
127    function transferFrom(address from, address to, uint256 value)
128      external returns (bool);
129 
130    event Transfer(
131      address indexed from,
132      address indexed to,
133      uint256 value
134    );
135 
136    event Approval(
137      address indexed owner,
138      address indexed spender,
139      uint256 value
140    );
141  }
142 
143 contract ERC20 is IERC20 {
144   using SafeMath for uint256;
145   using Roles for Roles.Role;
146 
147   event PauserAdded(address indexed account);
148   event PauserRemoved(address indexed account);
149   event Paused(address account);
150   event Unpaused(address account);
151 
152   Roles.Role private pausers;
153 
154   mapping (address => uint256) private _balances;
155 
156   mapping (address => mapping (address => uint256)) private _allowed;
157 
158   uint256 private _totalSupply;
159   string private _name;
160   string private _symbol;
161   uint8 private _decimals;
162   bool private _paused;
163 
164   modifier onlyPauser() {
165     require(isPauser(msg.sender));
166     _;
167   }
168 
169   constructor(string name, string symbol, uint8 decimals, uint256 totalSupply) public {
170     _name = name;
171     _symbol = symbol;
172     _decimals = decimals;
173     _totalSupply = totalSupply;
174     _balances[msg.sender] = _balances[msg.sender].add(_totalSupply);
175     _addPauser(msg.sender);
176     _paused = false;
177     emit Transfer(address(0), msg.sender, totalSupply);
178   }
179 
180 
181   /**
182    * @return true if the contract is paused, false otherwise.
183    */
184   function paused() public view returns(bool) {
185     return _paused;
186   }
187 
188   /**
189    * @dev Modifier to make a function callable only when the contract is not paused.
190    */
191   modifier whenNotPaused() {
192     require(!_paused);
193     _;
194   }
195 
196   /**
197    * @dev Modifier to make a function callable only when the contract is paused.
198    */
199   modifier whenPaused() {
200     require(_paused);
201     _;
202   }
203 
204   /**
205    * @dev called by the owner to pause, triggers stopped state
206    */
207   function pause() public onlyPauser whenNotPaused {
208     _paused = true;
209     emit Paused(msg.sender);
210   }
211 
212   /**
213    * @dev called by the owner to unpause, returns to normal state
214    */
215   function unpause() public onlyPauser whenPaused {
216     _paused = false;
217     emit Unpaused(msg.sender);
218   }
219 
220   function isPauser(address account) public view returns (bool) {
221     return pausers.has(account);
222   }
223 
224   function addPauser(address account) public onlyPauser {
225     _addPauser(account);
226   }
227 
228   function renouncePauser() public {
229     _removePauser(msg.sender);
230   }
231 
232   function _addPauser(address account) internal {
233     pausers.add(account);
234     emit PauserAdded(account);
235   }
236 
237   function _removePauser(address account) internal {
238     pausers.remove(account);
239     emit PauserRemoved(account);
240   }
241 
242   /**
243    * @return the name of the token.
244    */
245   function name() public view returns(string) {
246     return _name;
247   }
248 
249   /**
250    * @return the symbol of the token.
251    */
252   function symbol() public view returns(string) {
253     return _symbol;
254   }
255 
256   /**
257    * @return the number of decimals of the token.
258    */
259   function decimals() public view returns(uint8) {
260     return _decimals;
261   }
262 
263   /**
264   * @dev Total number of tokens in existence
265   */
266   function totalSupply() public view returns (uint256) {
267     return _totalSupply;
268   }
269 
270   /**
271   * @dev Gets the balance of the specified address.
272   * @param owner The address to query the balance of.
273   * @return An uint256 representing the amount owned by the passed address.
274   */
275   function balanceOf(address owner) public view returns (uint256) {
276     return _balances[owner];
277   }
278 
279   /**
280    * @dev Function to check the amount of tokens that an owner allowed to a spender.
281    * @param owner address The address which owns the funds.
282    * @param spender address The address which will spend the funds.
283    * @return A uint256 specifying the amount of tokens still available for the spender.
284    */
285   function allowance(
286     address owner,
287     address spender
288    )
289     public
290     view
291     returns (uint256)
292   {
293     return _allowed[owner][spender];
294   }
295 
296   /**
297   * @dev Transfer token for a specified address
298   * @param to The address to transfer to.
299   * @param value The amount to be transferred.
300   */
301   function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
302     _transfer(msg.sender, to, value);
303     return true;
304   }
305 
306   /**
307    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
308    * Beware that changing an allowance with this method brings the risk that someone may use both the old
309    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
310    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
311    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
312    * @param spender The address which will spend the funds.
313    * @param value The amount of tokens to be spent.
314    */
315   function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
316     require(spender != address(0));
317 
318     _allowed[msg.sender][spender] = value;
319     emit Approval(msg.sender, spender, value);
320     return true;
321   }
322 
323   /**
324    * @dev Transfer tokens from one address to another
325    * @param from address The address which you want to send tokens from
326    * @param to address The address which you want to transfer to
327    * @param value uint256 the amount of tokens to be transferred
328    */
329   function transferFrom(
330     address from,
331     address to,
332     uint256 value
333   )
334     public
335     whenNotPaused
336     returns (bool)
337   {
338     require(value <= _allowed[from][msg.sender]);
339 
340     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
341     _transfer(from, to, value);
342     return true;
343   }
344 
345   /**
346    * @dev Increase the amount of tokens that an owner allowed to a spender.
347    * approve should be called when allowed_[_spender] == 0. To increment
348    * allowed value is better to use this function to avoid 2 calls (and wait until
349    * the first transaction is mined)
350    * From MonolithDAO Token.sol
351    * @param spender The address which will spend the funds.
352    * @param addedValue The amount of tokens to increase the allowance by.
353    */
354   function increaseAllowance(
355     address spender,
356     uint256 addedValue
357   )
358     public
359     whenNotPaused
360     returns (bool)
361   {
362     require(spender != address(0));
363 
364     _allowed[msg.sender][spender] = (
365       _allowed[msg.sender][spender].add(addedValue));
366     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
367     return true;
368   }
369 
370   /**
371    * @dev Decrease the amount of tokens that an owner allowed to a spender.
372    * approve should be called when allowed_[_spender] == 0. To decrement
373    * allowed value is better to use this function to avoid 2 calls (and wait until
374    * the first transaction is mined)
375    * From MonolithDAO Token.sol
376    * @param spender The address which will spend the funds.
377    * @param subtractedValue The amount of tokens to decrease the allowance by.
378    */
379   function decreaseAllowance(
380     address spender,
381     uint256 subtractedValue
382   )
383     public
384     whenNotPaused
385     returns (bool)
386   {
387     require(spender != address(0));
388 
389     _allowed[msg.sender][spender] = (
390       _allowed[msg.sender][spender].sub(subtractedValue));
391     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
392     return true;
393   }
394 
395   /**
396   * @dev Transfer token for a specified addresses
397   * @param from The address to transfer from.
398   * @param to The address to transfer to.
399   * @param value The amount to be transferred.
400   */
401   function _transfer(address from, address to, uint256 value) internal {
402     require(value <= _balances[from]);
403     require(to != address(0));
404 
405     _balances[from] = _balances[from].sub(value);
406     _balances[to] = _balances[to].add(value);
407     emit Transfer(from, to, value);
408   }
409 }