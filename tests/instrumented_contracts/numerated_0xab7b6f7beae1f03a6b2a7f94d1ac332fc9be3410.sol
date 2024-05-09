1 /**
2  *Submitted for verification at Etherscan.io on 2018-10-10
3 */
4 
5 pragma solidity ^0.4.24;
6 
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that revert on error
10  */
11 library SafeMath {
12 
13   /**
14   * @dev Multiplies two numbers, reverts on overflow.
15   */
16   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
18     // benefit is lost if 'b' is also tested.
19     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
20     if (a == 0) {
21       return 0;
22     }
23 
24     uint256 c = a * b;
25     require(c / a == b);
26 
27     return c;
28   }
29 
30   /**
31   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
32   */
33   function div(uint256 a, uint256 b) internal pure returns (uint256) {
34     require(b > 0); // Solidity only automatically asserts when dividing by 0
35     uint256 c = a / b;
36     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37 
38     return c;
39   }
40 
41   /**
42   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
43   */
44   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45     require(b <= a);
46     uint256 c = a - b;
47 
48     return c;
49   }
50 
51   /**
52   * @dev Adds two numbers, reverts on overflow.
53   */
54   function add(uint256 a, uint256 b) internal pure returns (uint256) {
55     uint256 c = a + b;
56     require(c >= a);
57 
58     return c;
59   }
60 
61   /**
62   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
63   * reverts when dividing by zero.
64   */
65   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
66     require(b != 0);
67     return a % b;
68   }
69 }
70 
71 /**
72  * @title ERC20 interface
73  * @dev see https://github.com/ethereum/EIPs/issues/20
74  */
75 interface IERC20 {
76   function totalSupply() external view returns (uint256);
77 
78   function balanceOf(address who) external view returns (uint256);
79 
80   function allowance(address owner, address spender)
81     external view returns (uint256);
82 
83   function transfer(address to, uint256 value) external returns (bool);
84 
85   function approve(address spender, uint256 value)
86     external returns (bool);
87 
88   function transferFrom(address from, address to, uint256 value)
89     external returns (bool);
90 
91   event Transfer(
92     address indexed from,
93     address indexed to,
94     uint256 value
95   );
96 
97   event Approval(
98     address indexed owner,
99     address indexed spender,
100     uint256 value
101   );
102 }
103 
104 /**
105  * @title Standard ERC20 token
106  *
107  * @dev Implementation of the basic standard token.
108  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
109  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
110  */
111 contract ERC20 is IERC20 {
112   using SafeMath for uint256;
113 
114   mapping (address => uint256) private _balances;
115 
116   mapping (address => mapping (address => uint256)) private _allowed;
117 
118   uint256 private _totalSupply;
119 
120   /**
121   * @dev Total number of tokens in existence
122   */
123   function totalSupply() public view returns (uint256) {
124     return _totalSupply;
125   }
126 
127   /**
128   * @dev Gets the balance of the specified address.
129   * @param owner The address to query the balance of.
130   * @return An uint256 representing the amount owned by the passed address.
131   */
132   function balanceOf(address owner) public view returns (uint256) {
133     return _balances[owner];
134   }
135 
136   /**
137    * @dev Function to check the amount of tokens that an owner allowed to a spender.
138    * @param owner address The address which owns the funds.
139    * @param spender address The address which will spend the funds.
140    * @return A uint256 specifying the amount of tokens still available for the spender.
141    */
142   function allowance(
143     address owner,
144     address spender
145    )
146     public
147     view
148     returns (uint256)
149   {
150     return _allowed[owner][spender];
151   }
152 
153   /**
154   * @dev Transfer token for a specified address
155   * @param to The address to transfer to.
156   * @param value The amount to be transferred.
157   */
158   function transfer(address to, uint256 value) public returns (bool) {
159     _transfer(msg.sender, to, value);
160     return true;
161   }
162 
163   /**
164    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
165    * Beware that changing an allowance with this method brings the risk that someone may use both the old
166    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
167    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
168    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
169    * @param spender The address which will spend the funds.
170    * @param value The amount of tokens to be spent.
171    */
172   function approve(address spender, uint256 value) public returns (bool) {
173     require(spender != address(0));
174 
175     _allowed[msg.sender][spender] = value;
176     emit Approval(msg.sender, spender, value);
177     return true;
178   }
179 
180   /**
181    * @dev Transfer tokens from one address to another
182    * @param from address The address which you want to send tokens from
183    * @param to address The address which you want to transfer to
184    * @param value uint256 the amount of tokens to be transferred
185    */
186   function transferFrom(
187     address from,
188     address to,
189     uint256 value
190   )
191     public
192     returns (bool)
193   {
194     require(value <= _allowed[from][msg.sender]);
195 
196     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
197     _transfer(from, to, value);
198     return true;
199   }
200 
201   /**
202    * @dev Increase the amount of tokens that an owner allowed to a spender.
203    * approve should be called when allowed_[_spender] == 0. To increment
204    * allowed value is better to use this function to avoid 2 calls (and wait until
205    * the first transaction is mined)
206    * From MonolithDAO Token.sol
207    * @param spender The address which will spend the funds.
208    * @param addedValue The amount of tokens to increase the allowance by.
209    */
210   function increaseAllowance(
211     address spender,
212     uint256 addedValue
213   )
214     public
215     returns (bool)
216   {
217     require(spender != address(0));
218 
219     _allowed[msg.sender][spender] = (
220       _allowed[msg.sender][spender].add(addedValue));
221     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
222     return true;
223   }
224 
225   /**
226    * @dev Decrease the amount of tokens that an owner allowed to a spender.
227    * approve should be called when allowed_[_spender] == 0. To decrement
228    * allowed value is better to use this function to avoid 2 calls (and wait until
229    * the first transaction is mined)
230    * From MonolithDAO Token.sol
231    * @param spender The address which will spend the funds.
232    * @param subtractedValue The amount of tokens to decrease the allowance by.
233    */
234   function decreaseAllowance(
235     address spender,
236     uint256 subtractedValue
237   )
238     public
239     returns (bool)
240   {
241     require(spender != address(0));
242 
243     _allowed[msg.sender][spender] = (
244       _allowed[msg.sender][spender].sub(subtractedValue));
245     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
246     return true;
247   }
248 
249   /**
250   * @dev Transfer token for a specified addresses
251   * @param from The address to transfer from.
252   * @param to The address to transfer to.
253   * @param value The amount to be transferred.
254   */
255   function _transfer(address from, address to, uint256 value) internal {
256     require(value <= _balances[from]);
257     require(to != address(0));
258 
259     _balances[from] = _balances[from].sub(value);
260     _balances[to] = _balances[to].add(value);
261     emit Transfer(from, to, value);
262   }
263 
264   /**
265    * @dev Internal function that mints an amount of the token and assigns it to
266    * an account. This encapsulates the modification of balances such that the
267    * proper events are emitted.
268    * @param account The account that will receive the created tokens.
269    * @param value The amount that will be created.
270    */
271   function _mint(address account, uint256 value) internal {
272     require(account != 0);
273     _totalSupply = _totalSupply.add(value);
274     _balances[account] = _balances[account].add(value);
275     emit Transfer(address(0), account, value);
276   }
277 
278   /**
279    * @dev Internal function that burns an amount of the token of a given
280    * account.
281    * @param account The account whose tokens will be burnt.
282    * @param value The amount that will be burnt.
283    */
284   function _burn(address account, uint256 value) internal {
285     require(account != 0);
286     require(value <= _balances[account]);
287 
288     _totalSupply = _totalSupply.sub(value);
289     _balances[account] = _balances[account].sub(value);
290     emit Transfer(account, address(0), value);
291   }
292 
293   /**
294    * @dev Internal function that burns an amount of the token of a given
295    * account, deducting from the sender's allowance for said account. Uses the
296    * internal burn function.
297    * @param account The account whose tokens will be burnt.
298    * @param value The amount that will be burnt.
299    */
300   function _burnFrom(address account, uint256 value) internal {
301     require(value <= _allowed[account][msg.sender]);
302 
303     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
304     // this function needs to emit an event with the updated approval.
305     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
306       value);
307     _burn(account, value);
308   }
309 }
310 
311 
312 /**
313  * @title Ownable
314  * @dev The Ownable contract has an owner address, and provides basic authorization control
315  * functions, this simplifies the implementation of "user permissions".
316  */
317 contract Ownable {
318   address private _owner;
319 
320   event OwnershipTransferred(
321     address indexed previousOwner,
322     address indexed newOwner
323   );
324 
325   /**
326    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
327    * account.
328    */
329   constructor() public {
330     _owner = msg.sender;
331     emit OwnershipTransferred(address(0), _owner);
332   }
333 
334   /**
335    * @return the address of the owner.
336    */
337   function owner() public view returns(address) {
338     return _owner;
339   }
340 
341   /**
342    * @dev Throws if called by any account other than the owner.
343    */
344   modifier onlyOwner() {
345     require(isOwner());
346     _;
347   }
348 
349   /**
350    * @return true if `msg.sender` is the owner of the contract.
351    */
352   function isOwner() public view returns(bool) {
353     return msg.sender == _owner;
354   }
355 
356   /**
357    * @dev Allows the current owner to relinquish control of the contract.
358    * @notice Renouncing to ownership will leave the contract without an owner.
359    * It will not be possible to call the functions with the `onlyOwner`
360    * modifier anymore.
361    */
362   function renounceOwnership() public onlyOwner {
363     emit OwnershipTransferred(_owner, address(0));
364     _owner = address(0);
365   }
366 
367   /**
368    * @dev Allows the current owner to transfer control of the contract to a newOwner.
369    * @param newOwner The address to transfer ownership to.
370    */
371   function transferOwnership(address newOwner) public onlyOwner {
372     _transferOwnership(newOwner);
373   }
374 
375   /**
376    * @dev Transfers control of the contract to a newOwner.
377    * @param newOwner The address to transfer ownership to.
378    */
379   function _transferOwnership(address newOwner) internal {
380     require(newOwner != address(0));
381     emit OwnershipTransferred(_owner, newOwner);
382     _owner = newOwner;
383   }
384 }
385 
386 /**
387  * @title ERC20Detailed token
388  * @dev The decimals are only for visualization purposes.
389  * All the operations are done using the smallest and indivisible token unit,
390  * just as on Ethereum all the operations are done in wei.
391  */
392 contract ERC20Detailed is IERC20 {
393     string private _name;
394     string private _symbol;
395     uint8 private _decimals;
396 
397     constructor (string memory name, string memory symbol, uint8 decimals) public {
398         _name = name;
399         _symbol = symbol;
400         _decimals = decimals;
401     }
402 
403     /**
404      * @return the name of the token.
405      */
406     function name() public view returns (string memory) {
407         return _name;
408     }
409 
410     /**
411      * @return the symbol of the token.
412      */
413     function symbol() public view returns (string memory) {
414         return _symbol;
415     }
416 
417     /**
418      * @return the number of decimals of the token.
419      */
420     function decimals() public view returns (uint8) {
421         return _decimals;
422     }
423 }
424 
425 /**
426  * @title Burnable Token
427  * @dev Token that can be irreversibly burned (destroyed).
428  */
429 contract ERC20Burnable is ERC20, Ownable {
430 
431   /**
432    * @dev Burns a specific amount of tokens.
433    * @param value The amount of token to be burned.
434    */
435   function burn(uint256 value) onlyOwner public {
436     _burn(msg.sender, value);
437   }
438 
439   /**
440    * @dev Burns a specific amount of tokens from the target address and decrements allowance
441    * @param from address The address which you want to send tokens from
442    * @param value uint256 The amount of token to be burned
443    */
444   function burnFrom(address from, uint256 value) onlyOwner public {
445     _burnFrom(from, value);
446   }
447 }
448 
449 
450 /**
451  * @title HadaCoinV18
452  */
453 contract CWNToken is ERC20Burnable,ERC20Detailed {
454 
455   uint8 public constant DECIMALS = 18;
456     uint256 public constant INITIAL_SUPPLY = 200000000 * (10 ** uint256(DECIMALS)); 
457 
458     /**
459      * @dev Constructor that gives msg.sender all of existing tokens.
460      */
461     constructor () public ERC20Detailed("CryptoWorldNews Token", "CWN", 18) {
462         _mint(msg.sender, INITIAL_SUPPLY); 
463     }
464 
465 }