1 pragma solidity 0.4.24;
2 
3 // IPCO Token
4 
5 library SafeMath {
6 
7   /**
8   * @dev Multiplies two numbers, reverts on overflow.
9   */
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
12     // benefit is lost if 'b' is also tested.
13     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
14     if (a == 0) {
15       return 0;
16     }
17 
18     uint256 c = a * b;
19     require(c / a == b);
20 
21     return c;
22   }
23 
24   /**
25   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
26   */
27   function div(uint256 a, uint256 b) internal pure returns (uint256) {
28     require(b > 0); // Solidity only automatically asserts when dividing by 0
29     uint256 c = a / b;
30     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31 
32     return c;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     require(b <= a);
40     uint256 c = a - b;
41 
42     return c;
43   }
44 
45   /**
46   * @dev Adds two numbers, reverts on overflow.
47   */
48   function add(uint256 a, uint256 b) internal pure returns (uint256) {
49     uint256 c = a + b;
50     require(c >= a);
51 
52     return c;
53   }
54 
55   /**
56   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
57   * reverts when dividing by zero.
58   */
59   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
60     require(b != 0);
61     return a % b;
62   }
63 }
64 
65 contract Ownable {
66   address private _owner;
67 
68   event OwnershipTransferred(
69     address indexed previousOwner,
70     address indexed newOwner
71   );
72 
73   /**
74    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
75    * account.
76    */
77   constructor() internal {
78     _owner = msg.sender;
79     emit OwnershipTransferred(address(0), _owner);
80   }
81 
82   /**
83    * @return the address of the owner.
84    */
85   function owner() public view returns(address) {
86     return _owner;
87   }
88 
89   /**
90    * @dev Throws if called by any account other than the owner.
91    */
92   modifier onlyOwner() {
93     require(isOwner());
94     _;
95   }
96 
97   /**
98    * @return true if `msg.sender` is the owner of the contract.
99    */
100   function isOwner() public view returns(bool) {
101     return msg.sender == _owner;
102   }
103 
104   /**
105    * @dev Allows the current owner to relinquish control of the contract.
106    * @notice Renouncing to ownership will leave the contract without an owner.
107    * It will not be possible to call the functions with the `onlyOwner`
108    * modifier anymore.
109    */
110   function renounceOwnership() public onlyOwner {
111     emit OwnershipTransferred(_owner, address(0));
112     _owner = address(0);
113   }
114 
115   /**
116    * @dev Allows the current owner to transfer control of the contract to a newOwner.
117    * @param newOwner The address to transfer ownership to.
118    */
119   function transferOwnership(address newOwner) public onlyOwner {
120     _transferOwnership(newOwner);
121   }
122 
123   /**
124    * @dev Transfers control of the contract to a newOwner.
125    * @param newOwner The address to transfer ownership to.
126    */
127   function _transferOwnership(address newOwner) internal {
128     require(newOwner != address(0));
129     emit OwnershipTransferred(_owner, newOwner);
130     _owner = newOwner;
131   }
132 }
133 
134 interface IERC20 {
135   function totalSupply() external view returns (uint256);
136 
137   function balanceOf(address who) external view returns (uint256);
138 
139   function allowance(address owner, address spender)
140     external view returns (uint256);
141 
142   function transfer(address to, uint256 value) external returns (bool);
143 
144   function approve(address spender, uint256 value)
145     external returns (bool);
146 
147   function transferFrom(address from, address to, uint256 value)
148     external returns (bool);
149 
150   event Transfer(
151     address indexed from,
152     address indexed to,
153     uint256 value
154   );
155 
156   event Approval(
157     address indexed owner,
158     address indexed spender,
159     uint256 value
160   );
161 }
162 
163 contract ERC20 is IERC20 {
164   using SafeMath for uint256;
165 
166   mapping (address => uint256) private _balances;
167 
168   mapping (address => mapping (address => uint256)) private _allowed;
169 
170   uint256 private _totalSupply;
171 
172   /**
173   * @dev Total number of tokens in existence
174   */
175   function totalSupply() public view returns (uint256) {
176     return _totalSupply;
177   }
178 
179   /**
180   * @dev Gets the balance of the specified address.
181   * @param owner The address to query the balance of.
182   * @return An uint256 representing the amount owned by the passed address.
183   */
184   function balanceOf(address owner) public view returns (uint256) {
185     return _balances[owner];
186   }
187 
188   /**
189    * @dev Function to check the amount of tokens that an owner allowed to a spender.
190    * @param owner address The address which owns the funds.
191    * @param spender address The address which will spend the funds.
192    * @return A uint256 specifying the amount of tokens still available for the spender.
193    */
194   function allowance(
195     address owner,
196     address spender
197    )
198     public
199     view
200     returns (uint256)
201   {
202     return _allowed[owner][spender];
203   }
204 
205   /**
206   * @dev Transfer token for a specified address
207   * @param to The address to transfer to.
208   * @param value The amount to be transferred.
209   */
210   function transfer(address to, uint256 value) public returns (bool) {
211     _transfer(msg.sender, to, value);
212     return true;
213   }
214 
215   /**
216    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
217    * Beware that changing an allowance with this method brings the risk that someone may use both the old
218    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
219    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
220    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
221    * @param spender The address which will spend the funds.
222    * @param value The amount of tokens to be spent.
223    */
224   function approve(address spender, uint256 value) public returns (bool) {
225     require(spender != address(0));
226 
227     _allowed[msg.sender][spender] = value;
228     emit Approval(msg.sender, spender, value);
229     return true;
230   }
231 
232   /**
233    * @dev Transfer tokens from one address to another
234    * @param from address The address which you want to send tokens from
235    * @param to address The address which you want to transfer to
236    * @param value uint256 the amount of tokens to be transferred
237    */
238   function transferFrom(
239     address from,
240     address to,
241     uint256 value
242   )
243     public
244     returns (bool)
245   {
246     require(value <= _allowed[from][msg.sender]);
247 
248     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
249     _transfer(from, to, value);
250     return true;
251   }
252 
253   /**
254    * @dev Increase the amount of tokens that an owner allowed to a spender.
255    * approve should be called when allowed_[_spender] == 0. To increment
256    * allowed value is better to use this function to avoid 2 calls (and wait until
257    * the first transaction is mined)
258    * From MonolithDAO Token.sol
259    * @param spender The address which will spend the funds.
260    * @param addedValue The amount of tokens to increase the allowance by.
261    */
262   function increaseAllowance(
263     address spender,
264     uint256 addedValue
265   )
266     public
267     returns (bool)
268   {
269     require(spender != address(0));
270 
271     _allowed[msg.sender][spender] = (
272       _allowed[msg.sender][spender].add(addedValue));
273     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
274     return true;
275   }
276 
277   /**
278    * @dev Decrease the amount of tokens that an owner allowed to a spender.
279    * approve should be called when allowed_[_spender] == 0. To decrement
280    * allowed value is better to use this function to avoid 2 calls (and wait until
281    * the first transaction is mined)
282    * From MonolithDAO Token.sol
283    * @param spender The address which will spend the funds.
284    * @param subtractedValue The amount of tokens to decrease the allowance by.
285    */
286   function decreaseAllowance(
287     address spender,
288     uint256 subtractedValue
289   )
290     public
291     returns (bool)
292   {
293     require(spender != address(0));
294 
295     _allowed[msg.sender][spender] = (
296       _allowed[msg.sender][spender].sub(subtractedValue));
297     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
298     return true;
299   }
300 
301   /**
302   * @dev Transfer token for a specified addresses
303   * @param from The address to transfer from.
304   * @param to The address to transfer to.
305   * @param value The amount to be transferred.
306   */
307   function _transfer(address from, address to, uint256 value) internal {
308     require(value <= _balances[from]);
309     require(to != address(0));
310 
311     _balances[from] = _balances[from].sub(value);
312     _balances[to] = _balances[to].add(value);
313     emit Transfer(from, to, value);
314   }
315 
316   /**
317    * @dev Internal function that mints an amount of the token and assigns it to
318    * an account. This encapsulates the modification of balances such that the
319    * proper events are emitted.
320    * @param account The account that will receive the created tokens.
321    * @param value The amount that will be created.
322    */
323   function _mint(address account, uint256 value) internal {
324     require(account != 0);
325     _totalSupply = _totalSupply.add(value);
326     _balances[account] = _balances[account].add(value);
327     emit Transfer(address(0), account, value);
328   }
329 
330   /**
331    * @dev Internal function that burns an amount of the token of a given
332    * account.
333    * @param account The account whose tokens will be burnt.
334    * @param value The amount that will be burnt.
335    */
336   function _burn(address account, uint256 value) internal {
337     require(account != 0);
338     require(value <= _balances[account]);
339 
340     _totalSupply = _totalSupply.sub(value);
341     _balances[account] = _balances[account].sub(value);
342     emit Transfer(account, address(0), value);
343   }
344 
345   /**
346    * @dev Internal function that burns an amount of the token of a given
347    * account, deducting from the sender's allowance for said account. Uses the
348    * internal burn function.
349    * @param account The account whose tokens will be burnt.
350    * @param value The amount that will be burnt.
351    */
352   function _burnFrom(address account, uint256 value) internal {
353     require(value <= _allowed[account][msg.sender]);
354 
355     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
356     // this function needs to emit an event with the updated approval.
357     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
358       value);
359     _burn(account, value);
360   }
361 }
362 
363 contract ERC20Detailed is IERC20 {
364   string private _name;
365   string private _symbol;
366   uint8 private _decimals;
367 
368   constructor(string name, string symbol, uint8 decimals) public {
369     _name = name;
370     _symbol = symbol;
371     _decimals = decimals;
372   }
373 
374   /**
375    * @return the name of the token.
376    */
377   function name() public view returns(string) {
378     return _name;
379   }
380 
381   /**
382    * @return the symbol of the token.
383    */
384   function symbol() public view returns(string) {
385     return _symbol;
386   }
387 
388   /**
389    * @return the number of decimals of the token.
390    */
391   function decimals() public view returns(uint8) {
392     return _decimals;
393   }
394 }
395 
396 contract Pausable is Ownable {
397 
398     bool public paused = false;
399 
400     event Pause();
401     event Unpause();
402 
403     /**
404      * @dev Modifier to make a function callable only when the contract is not paused.
405      */
406     modifier whenNotPaused() {
407         require(!paused, "Has to be unpaused");
408         _;
409     }
410 
411     /**
412      * @dev Modifier to make a function callable only when the contract is paused.
413      */
414     modifier whenPaused() {
415         require(paused, "Has to be paused");
416         _;
417     }
418 
419     /**
420      * @dev called by the owner to pause, triggers stopped state
421      */
422     function pause() public onlyOwner whenNotPaused {
423         paused = true;
424         emit Pause();
425     }
426 
427     /**
428      * @dev called by the owner to unpause, returns to normal state
429      */
430     function unpause() public onlyOwner whenPaused {
431         paused = false;
432         emit Unpause();
433     }
434 }
435 
436 contract PausableToken is ERC20, Pausable {
437 
438     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
439         return super.transfer(to, value);
440     }
441 
442     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
443         return super.transferFrom(from, to, value);
444     }
445 
446     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
447         return super.approve(spender, value);
448     }
449 
450     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
451         return super.increaseAllowance(spender, addedValue);
452     }
453 
454     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
455         return super.decreaseAllowance(spender, subtractedValue);
456     }
457 }
458 
459 contract IPCOToken is PausableToken, ERC20Detailed {
460     string public termsUrl = "http://xixoio.com/terms";
461     uint256 public hardCap;
462 
463     /**
464      * Token constructor, newly created token is paused
465      * @dev decimals are hardcoded to 18
466      */
467     constructor(string _name, string _symbol, uint256 _hardCap) ERC20Detailed(_name, _symbol, 18) public {
468         require(_hardCap > 0, "Hard cap can't be zero.");
469         require(bytes(_name).length > 0, "Name must be defined.");
470         require(bytes(_symbol).length > 0, "Symbol must be defined.");
471         hardCap = _hardCap;
472         pause();
473     }
474 
475     /**
476      * Minting function
477      * @dev doesn't allow minting of more tokens than hard cap
478      */
479     function mint(address to, uint256 value) public onlyOwner returns (bool) {
480         require(totalSupply().add(value) <= hardCap, "Mint of this amount would exceed the hard cap.");
481         _mint(to, value);
482         return true;
483     }
484 }