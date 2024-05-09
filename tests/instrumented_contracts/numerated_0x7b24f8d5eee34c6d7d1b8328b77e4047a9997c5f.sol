1 pragma solidity ^0.4.25;
2 
3 interface IERC20 {
4   function totalSupply() external view returns (uint256);
5 
6   function balanceOf(address who) external view returns (uint256);
7 
8   function allowance(address owner, address spender)
9     external view returns (uint256);
10 
11   function transfer(address to, uint256 value) external returns (bool);
12 
13   function approve(address spender, uint256 value)
14     external returns (bool);
15 
16   function transferFrom(address from, address to, uint256 value)
17     external returns (bool);
18 
19   event Transfer(
20     address indexed from,
21     address indexed to,
22     uint256 value
23   );
24 
25   event Approval(
26     address indexed owner,
27     address indexed spender,
28     uint256 value
29   );
30 }
31 
32 /**
33  * @title SafeMath
34  * @dev Math operations with safety checks that revert on error
35  */
36 library SafeMath {
37   /**
38   * @dev Multiplies two numbers, reverts on overflow.
39   */
40   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
41     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
42     // benefit is lost if 'b' is also tested.
43     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
44     if (a == 0) {
45       return 0;
46     }
47 
48     uint256 c = a * b;
49     require(c / a == b, "overflow in multiplies operation.");
50 
51     return c;
52   }
53 
54   /**
55   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
56   */
57   function div(uint256 a, uint256 b) internal pure returns (uint256) {
58     // Solidity only automatically asserts when dividing by 0
59     require(b > 0, "b must be greater than zero.");
60     uint256 c = a / b;
61     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
62 
63     return c;
64   }
65 
66   /**
67   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
68   */
69   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
70     require(b <= a, "a must be greater than b or equal to b.");
71     uint256 c = a - b;
72 
73     return c;
74   }
75 
76   /**
77   * @dev Adds two numbers, reverts on overflow.
78   */
79   function add(uint256 a, uint256 b) internal pure returns (uint256) {
80     uint256 c = a + b;
81     require(c >= a, "c must be greater than b or equal to a.");
82 
83     return c;
84   }
85 
86   /**
87   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
88   * reverts when dividing by zero.
89   */
90   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
91     require(b != 0, "b must not be zero.");
92     return a % b;
93   }
94 }
95 
96 /**
97  * @title Ownable
98  * @dev The Ownable contract has an owner address, and provides basic authorization control
99  * functions, this simplifies the implementation of "user permissions".
100  */
101 contract Ownable {
102   address public owner;
103 
104   event OwnershipTransferred(
105     address indexed previousOwner,
106     address indexed newOwner
107   );
108 
109   /**
110    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
111    * account.
112    */
113   constructor() public {
114     owner = msg.sender;
115   }
116 
117   /**
118    * @dev Throws if called by any account other than the owner.
119    */
120   modifier onlyOwner() {
121     require(msg.sender == owner, "only for owner.");
122     _;
123   }
124 
125   /**
126    * @dev Allows the current owner to transfer control of the contract to a newOwner.
127    * @param newOwner The address to transfer ownership to.
128    */
129   function transferOwnership(address newOwner) public onlyOwner {
130     require(newOwner != address(0), "address is zero.");
131     emit OwnershipTransferred(owner, newOwner);
132     owner = newOwner;
133   }
134 }
135 
136 
137 /**
138  * @title Pausable
139  * @dev Base contract which allows children to implement an emergency stop mechanism.
140  */
141 contract Pausable is Ownable {
142   event Paused(address account);
143   event Unpaused(address account);
144 
145   bool private _paused;
146 
147   constructor() internal {
148     _paused = false;
149   }
150 
151   /**
152    * @return true if the contract is paused, false otherwise.
153    */
154   function paused() public view returns(bool) {
155     return _paused;
156   }
157 
158   /**
159    * @dev Modifier to make a function callable only when the contract is not paused.
160    */
161   modifier whenNotPaused() {
162     require(!_paused, "Paused.");
163     _;
164   }
165 
166   /**
167    * @dev Modifier to make a function callable only when the contract is paused.
168    */
169   modifier whenPaused() {
170     require(_paused, "Not paused.");
171     _;
172   }
173 
174   /**
175    * @dev called by the owner to pause, triggers stopped state
176    */
177   function pause() public onlyOwner whenNotPaused {
178     _paused = true;
179     emit Paused(msg.sender);
180   }
181 
182   /**
183    * @dev called by the owner to unpause, returns to normal state
184    */
185   function unpause() public onlyOwner whenPaused {
186     _paused = false;
187     emit Unpaused(msg.sender);
188   }
189 }
190 
191 contract Token is IERC20, Pausable {
192   using SafeMath for uint256;
193 
194   string private _name;
195 
196   string private _symbol;
197 
198   uint8 private _decimals;
199 
200   mapping (address => uint256) private _balances;
201 
202   mapping (address => mapping (address => uint256)) private _allowed;
203 
204   uint256 private _totalSupply;
205 
206   constructor(
207     uint256 initialSupply,
208     string memory tokenName,
209     string memory tokenSymbol,
210     uint8 tokenDecimals
211   ) public {
212     // Set the name for display purposes
213     _name = tokenName;
214     // Set the symbol for display purposes
215     _symbol = tokenSymbol;
216     // Set the decimal for display purposes
217     _decimals = tokenDecimals;
218 
219     // Update total supply with the decimal amount
220     _totalSupply = initialSupply * (10 ** uint256(_decimals));
221     // Give the creator all initial tokens
222     _balances[msg.sender] = _totalSupply;
223   }
224 
225   /**
226    * @return the name of the token.
227    */
228   function name() public view returns(string memory) {
229     return _name;
230   }
231 
232   /**
233    * @return the symbol of the token.
234    */
235   function symbol() public view returns(string memory) {
236     return _symbol;
237   }
238 
239   /**
240    * @return the number of decimals of the token.
241    */
242   function decimals() public view returns(uint8) {
243     return _decimals;
244   }
245 
246   /**
247   * @dev Total number of tokens in existence
248   */
249   function totalSupply() public view returns (uint256) {
250     return _totalSupply;
251   }
252 
253   /**
254   * @dev Gets the balance of the specified address.
255   * @param owner The address to query the balance of.
256   * @return An uint256 representing the amount owned by the passed address.
257   */
258   function balanceOf(address owner) public view returns (uint256) {
259     return _balances[owner];
260   }
261 
262   /**
263    * @dev Function to check the amount of tokens that an owner allowed to a spender.
264    * @param owner address The address which owns the funds.
265    * @param spender address The address which will spend the funds.
266    * @return A uint256 specifying the amount of tokens still available for the spender.
267    */
268   function allowance(
269     address owner,
270     address spender
271    )
272     public
273     view
274     returns (uint256)
275   {
276     return _allowed[owner][spender];
277   }
278 
279   /**
280   * @dev Transfer token for a specified address
281   * @param to The address to transfer to.
282   * @param value The amount to be transferred.
283   */
284   function transfer(
285     address to,
286     uint256 value
287     )
288       public
289       whenNotPaused
290       returns (bool)
291   {
292     _transfer(msg.sender, to, value);
293     return true;
294   }
295 
296   /**
297    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
298    * Beware that changing an allowance with this method brings the risk that someone may use both the old
299    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
300    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
301    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
302    * @param spender The address which will spend the funds.
303    * @param value The amount of tokens to be spent.
304    */
305   function approve(
306     address spender,
307     uint256 value
308     )
309       public
310       whenNotPaused
311       returns (bool)
312   {
313     require(spender != address(0), "address is zero.");
314 
315     _allowed[msg.sender][spender] = value;
316     emit Approval(msg.sender, spender, value);
317     return true;
318   }
319 
320   /**
321    * @dev Transfer tokens from one address to another
322    * @param from address The address which you want to send tokens from
323    * @param to address The address which you want to transfer to
324    * @param value uint256 the amount of tokens to be transferred
325    */
326   function transferFrom(
327     address from,
328     address to,
329     uint256 value
330     )
331     public
332     whenNotPaused
333     returns (bool)
334   {
335     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
336     _transfer(from, to, value);
337     return true;
338   }
339 
340   /**
341    * @dev Increase the amount of tokens that an owner allowed to a spender.
342    * approve should be called when allowed_[_spender] == 0. To increment
343    * allowed value is better to use this function to avoid 2 calls (and wait until
344    * the first transaction is mined)
345    * From MonolithDAO Token.sol
346    * @param spender The address which will spend the funds.
347    * @param addedValue The amount of tokens to increase the allowance by.
348    */
349   function increaseAllowance(
350     address spender,
351     uint256 addedValue
352     )
353     public
354     whenNotPaused
355     returns (bool)
356   {
357     require(spender != address(0), "address is zero.");
358 
359     _allowed[msg.sender][spender] = (
360       _allowed[msg.sender][spender].add(addedValue));
361     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
362     return true;
363   }
364 
365   /**
366    * @dev Decrease the amount of tokens that an owner allowed to a spender.
367    * approve should be called when allowed_[_spender] == 0. To decrement
368    * allowed value is better to use this function to avoid 2 calls (and wait until
369    * the first transaction is mined)
370    * From MonolithDAO Token.sol
371    * @param spender The address which will spend the funds.
372    * @param subtractedValue The amount of tokens to decrease the allowance by.
373    */
374   function decreaseAllowance(
375     address spender,
376     uint256 subtractedValue
377     )
378     public
379     whenNotPaused
380     returns (bool)
381   {
382     require(spender != address(0), "address is zero.");
383 
384     _allowed[msg.sender][spender] = (
385       _allowed[msg.sender][spender].sub(subtractedValue));
386     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
387     return true;
388   }
389 
390   /**
391   * @dev Transfer token for a specified addresses
392   * @param from The address to transfer from.
393   * @param to The address to transfer to.
394   * @param value The amount to be transferred.
395   */
396   function _transfer(address from, address to, uint256 value) internal {
397     require(to != address(0), "address is zero.");
398 
399     _balances[from] = _balances[from].sub(value);
400     _balances[to] = _balances[to].add(value);
401     emit Transfer(from, to, value);
402   }
403 }