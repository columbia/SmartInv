1 pragma solidity 0.4.24;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 contract ERC20 {
8   function totalSupply() public view returns (uint256);
9 
10   function balanceOf(address who) public view returns (uint256);
11 
12   function transfer(address to, uint256 value) public returns (bool);
13 
14   function allowance(address owner, address spender) public view returns (uint256);
15 
16   function transferFrom(address from, address to, uint256 value) public returns (bool);
17 
18   function approve(address spender, uint256 value) public returns (bool);
19 
20   event Transfer(address indexed from, address indexed to, uint256 value);
21 
22   event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 /**
26  * @title SafeMath
27  * @dev Math operations with safety checks that throw on error
28  */
29 library SafeMath {
30 
31   /**
32   * @dev Multiplies two numbers, reverts on overflow.
33   */
34   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
35     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
36     // benefit is lost if 'b' is also tested.
37     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
38     if (a == 0) {
39       return 0;
40     }
41 
42     uint256 c = a * b;
43     require(c / a == b);
44 
45     return c;
46   }
47 
48   /**
49   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
50   */
51   function div(uint256 a, uint256 b) internal pure returns (uint256) {
52     require(b > 0); // Solidity only automatically asserts when dividing by 0
53     uint256 c = a / b;
54     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
55 
56     return c;
57   }
58 
59   /**
60   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
61   */
62   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
63     require(b <= a);
64     uint256 c = a - b;
65 
66     return c;
67   }
68 
69   /**
70   * @dev Adds two numbers, reverts on overflow.
71   */
72   function add(uint256 a, uint256 b) internal pure returns (uint256) {
73     uint256 c = a + b;
74     require(c >= a);
75 
76     return c;
77   }
78 
79   /**
80   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
81   * reverts when dividing by zero.
82   */
83   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
84     require(b != 0);
85     return a % b;
86   }
87 }
88 
89 /**
90  * @title Standard ERC20 token
91  *
92  * @dev Implementation of the basic standard token.
93  * @dev https://github.com/ethereum/EIPs/issues/20
94  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
95  */
96 contract BLOOCYSToken is ERC20 {
97   using SafeMath for uint256;
98 
99   mapping (address => uint256) private _balances;
100 
101   mapping (address => mapping (address => uint256)) private _allowed;
102 
103   string private constant _name = "BLOOCYS"; // solium-disable-line uppercase
104   string private constant _symbol = "CYS"; // solium-disable-line uppercase
105   uint8 private constant _decimals = 18; // solium-disable-line uppercase
106   uint256 private _totalSupply;
107 
108   address private _owner;
109   bool private _paused;
110 
111   event Paused();
112   event Unpaused();
113 
114   event Burn(address indexed burner, uint256 value);
115 
116   constructor() public {
117     _paused = false;
118     _owner = msg.sender;
119     _totalSupply = 1000000000 * (10 ** uint256(_decimals));
120     _balances[msg.sender] = _totalSupply;
121     emit Transfer(address(0), msg.sender, _totalSupply);
122   }
123 
124   /**
125    * @return the name of the token.
126    */
127   function name() public pure returns(string) {
128     return _name;
129   }
130 
131   /**
132    * @return the symbol of the token.
133    */
134   function symbol() public pure returns(string) {
135     return _symbol;
136   }
137 
138   /**
139    * @return the number of decimals of the token.
140    */
141   function decimals() public pure returns(uint8) {
142     return _decimals;
143   }
144 
145   /**
146   * @dev Total number of tokens in existence
147   */
148   function totalSupply() public view returns (uint256) {
149     return _totalSupply;
150   }
151 
152   /**
153   * @dev Gets the balance of the specified address.
154   * @param owner The address to query the balance of.
155   * @return An uint256 representing the amount owned by the passed address.
156   */
157   function balanceOf(address owner) public view returns (uint256) {
158     return _balances[owner];
159   }
160 
161   /**
162    * @dev Function to check the amount of tokens that an owner allowed to a spender.
163    * @param owner address The address which owns the funds.
164    * @param spender address The address which will spend the funds.
165    * @return A uint256 specifying the amount of tokens still available for the spender.
166    */
167   function allowance(address owner, address spender) public view returns (uint256) {
168     return _allowed[owner][spender];
169   }
170 
171   /**
172   * @dev Transfer token for a specified address.
173   *      Similar to transfer, by only can be used by contract owner
174   *      Token owner can use to transfer tokens even when it's paused
175   * @param to The address to transfer to.
176   * @param value The amount to be transferred.
177   */
178   function ownerTransfer(address to, uint256 value) public onlyOwner returns (bool) {
179     _transfer(msg.sender, to, value);
180     return true;
181   }
182 
183   /**
184   * @dev Transfer token for a specified address
185   * @param to The address to transfer to.
186   * @param value The amount to be transferred.
187   */
188   function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
189     _transfer(msg.sender, to, value);
190     return true;
191   }
192 
193   /**
194    * @dev transfer tokens to multiple addresses at the same time
195    * @param tos The addresses to transfer to.
196    * @param values The amounts to be transferred.
197    */
198   function batchTransfer(address[] tos, uint256[] values) public whenNotPaused returns (bool) {
199       require(tos.length == values.length);
200 
201       uint256 arrayLength = tos.length;
202       for(uint256 i = 0; i < arrayLength; i++) {
203         require(transfer(tos[i], values[i]));
204       }
205 
206       return true;
207   }
208 
209   /**
210    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
211    * Beware that changing an allowance with this method brings the risk that someone may use both the old
212    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
213    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
214    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
215    * @param spender The address which will spend the funds.
216    * @param value The amount of tokens to be spent.
217    */
218   function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
219     require(spender != address(0));
220 
221     _allowed[msg.sender][spender] = value;
222     emit Approval(msg.sender, spender, value);
223     return true;
224   }
225 
226   /**
227    * @dev Transfer tokens from one address to another
228    * @param from address The address which you want to send tokens from
229    * @param to address The address which you want to transfer to
230    * @param value uint256 the amount of tokens to be transferred
231    */
232   function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
233     require(value <= _allowed[from][msg.sender]);
234 
235     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
236     _transfer(from, to, value);
237     return true;
238   }
239 
240   /**
241    * @dev Increase the amount of tokens that an owner allowed to a spender.
242    * approve should be called when allowed_[_spender] == 0. To increment
243    * allowed value is better to use this function to avoid 2 calls (and wait until
244    * the first transaction is mined)
245    * From MonolithDAO Token.sol
246    * @param spender The address which will spend the funds.
247    * @param addedValue The amount of tokens to increase the allowance by.
248    */
249   function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
250     require(spender != address(0));
251 
252     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
253     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
254     return true;
255   }
256 
257   /**
258    * @dev Decrease the amount of tokens that an owner allowed to a spender.
259    * approve should be called when allowed_[_spender] == 0. To decrement
260    * allowed value is better to use this function to avoid 2 calls (and wait until
261    * the first transaction is mined)
262    * From MonolithDAO Token.sol
263    * @param spender The address which will spend the funds.
264    * @param subtractedValue The amount of tokens to decrease the allowance by.
265    */
266   function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
267     require(spender != address(0));
268 
269     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
270     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
271     return true;
272   }
273 
274   /**
275   * @dev Transfer token for a specified addresses
276   * @param from The address to transfer from.
277   * @param to The address to transfer to.
278   * @param value The amount to be transferred.
279   */
280   function _transfer(address from, address to, uint256 value) internal {
281     require(value <= _balances[from]);
282     require(to != address(0));
283 
284     _balances[from] = _balances[from].sub(value);
285     _balances[to] = _balances[to].add(value);
286     emit Transfer(from, to, value);
287   }
288 
289   /**
290    * @dev Burns a specific amount of tokens.
291    * @param value The amount of token to be burned.
292    */
293   function burn(uint256 value) public {
294     _burn(msg.sender, value);
295   }
296 
297   /**
298    * @dev Burns a specific amount of tokens from the target address and decrements allowance
299    * @param from address The address which you want to send tokens from
300    * @param value uint256 The amount of token to be burned
301    */
302   function burnFrom(address from, uint256 value) public {
303     _burnFrom(from, value);
304   }
305 
306   /**
307    * @dev Internal function that burns an amount of the token of a given
308    * account.
309    * @param account The account whose tokens will be burnt.
310    * @param value The amount that will be burnt.
311    */
312   function _burn(address account, uint256 value) internal {
313     require(account != 0);
314     require(value <= _balances[account]);
315 
316     _totalSupply = _totalSupply.sub(value);
317     _balances[account] = _balances[account].sub(value);
318     emit Burn(account, value);
319     emit Transfer(account, address(0), value);
320   }
321 
322   /**
323    * @dev Internal function that burns an amount of the token of a given
324    * account, deducting from the sender's allowance for said account. Uses the
325    * internal burn function.
326    * @param account The account whose tokens will be burnt.
327    * @param value The amount that will be burnt.
328    */
329   function _burnFrom(address account, uint256 value) internal {
330     require(value <= _allowed[account][msg.sender]);
331 
332     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
333     // this function needs to emit an event with the updated approval.
334     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
335     _burn(account, value);
336   }
337 
338   /**
339    * @return true if `msg.sender` is the owner of the contract.
340    */
341   function isOwner() public view returns(bool) {
342     return msg.sender == _owner;
343   }
344 
345   /**
346    * @dev Throws if called by any account other than the owner.
347    */
348   modifier onlyOwner() {
349     require(isOwner());
350     _;
351   }
352 
353   /**
354    * @dev Modifier to make a function callable only when the contract is not paused.
355    */
356   modifier whenNotPaused() {
357     require(!_paused);
358     _;
359   }
360 
361   /**
362    * @dev Modifier to make a function callable only when the contract is paused.
363    */
364   modifier whenPaused() {
365     require(_paused);
366     _;
367   }
368 
369   /**
370    * @return true if the contract is paused, false otherwise.
371    */
372   function paused() public view returns(bool) {
373     return _paused;
374   }
375 
376   /**
377    * @dev called by the owner to pause, triggers stopped state
378    */
379   function pause() public onlyOwner whenNotPaused {
380     _paused = true;
381     emit Paused();
382   }
383 
384   /**
385    * @dev called by the owner to unpause, returns to normal state
386    */
387   function unpause() public onlyOwner whenPaused {
388     _paused = false;
389     emit Unpaused();
390   }
391 
392 }