1 pragma solidity 0.4.24;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 // input  /root/code/solidity/xixoio-contracts/flat/IPCOToken.sol
6 // flattened :  Monday, 03-Dec-18 10:34:17 UTC
7 interface IERC20 {
8   function totalSupply() external view returns (uint256);
9 
10   function balanceOf(address who) external view returns (uint256);
11 
12   function allowance(address owner, address spender)
13     external view returns (uint256);
14 
15   function transfer(address to, uint256 value) external returns (bool);
16 
17   function approve(address spender, uint256 value)
18     external returns (bool);
19 
20   function transferFrom(address from, address to, uint256 value)
21     external returns (bool);
22 
23   event Transfer(
24     address indexed from,
25     address indexed to,
26     uint256 value
27   );
28 
29   event Approval(
30     address indexed owner,
31     address indexed spender,
32     uint256 value
33   );
34 }
35 
36 library SafeMath {
37 
38   /**
39   * @dev Multiplies two numbers, reverts on overflow.
40   */
41   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
42     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
43     // benefit is lost if 'b' is also tested.
44     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
45     if (a == 0) {
46       return 0;
47     }
48 
49     uint256 c = a * b;
50     require(c / a == b);
51 
52     return c;
53   }
54 
55   /**
56   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
57   */
58   function div(uint256 a, uint256 b) internal pure returns (uint256) {
59     require(b > 0); // Solidity only automatically asserts when dividing by 0
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
70     require(b <= a);
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
81     require(c >= a);
82 
83     return c;
84   }
85 
86   /**
87   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
88   * reverts when dividing by zero.
89   */
90   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
91     require(b != 0);
92     return a % b;
93   }
94 }
95 
96 contract Ownable {
97   address private _owner;
98 
99   event OwnershipTransferred(
100     address indexed previousOwner,
101     address indexed newOwner
102   );
103 
104   /**
105    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
106    * account.
107    */
108   constructor() internal {
109     _owner = msg.sender;
110     emit OwnershipTransferred(address(0), _owner);
111   }
112 
113   /**
114    * @return the address of the owner.
115    */
116   function owner() public view returns(address) {
117     return _owner;
118   }
119 
120   /**
121    * @dev Throws if called by any account other than the owner.
122    */
123   modifier onlyOwner() {
124     require(isOwner());
125     _;
126   }
127 
128   /**
129    * @return true if `msg.sender` is the owner of the contract.
130    */
131   function isOwner() public view returns(bool) {
132     return msg.sender == _owner;
133   }
134 
135   /**
136    * @dev Allows the current owner to relinquish control of the contract.
137    * @notice Renouncing to ownership will leave the contract without an owner.
138    * It will not be possible to call the functions with the `onlyOwner`
139    * modifier anymore.
140    */
141   function renounceOwnership() public onlyOwner {
142     emit OwnershipTransferred(_owner, address(0));
143     _owner = address(0);
144   }
145 
146   /**
147    * @dev Allows the current owner to transfer control of the contract to a newOwner.
148    * @param newOwner The address to transfer ownership to.
149    */
150   function transferOwnership(address newOwner) public onlyOwner {
151     _transferOwnership(newOwner);
152   }
153 
154   /**
155    * @dev Transfers control of the contract to a newOwner.
156    * @param newOwner The address to transfer ownership to.
157    */
158   function _transferOwnership(address newOwner) internal {
159     require(newOwner != address(0));
160     emit OwnershipTransferred(_owner, newOwner);
161     _owner = newOwner;
162   }
163 }
164 
165 contract ERC20 is IERC20 {
166   using SafeMath for uint256;
167 
168   mapping (address => uint256) private _balances;
169 
170   mapping (address => mapping (address => uint256)) private _allowed;
171 
172   uint256 private _totalSupply;
173 
174   /**
175   * @dev Total number of tokens in existence
176   */
177   function totalSupply() public view returns (uint256) {
178     return _totalSupply;
179   }
180 
181   /**
182   * @dev Gets the balance of the specified address.
183   * @param owner The address to query the balance of.
184   * @return An uint256 representing the amount owned by the passed address.
185   */
186   function balanceOf(address owner) public view returns (uint256) {
187     return _balances[owner];
188   }
189 
190   /**
191    * @dev Function to check the amount of tokens that an owner allowed to a spender.
192    * @param owner address The address which owns the funds.
193    * @param spender address The address which will spend the funds.
194    * @return A uint256 specifying the amount of tokens still available for the spender.
195    */
196   function allowance(
197     address owner,
198     address spender
199    )
200     public
201     view
202     returns (uint256)
203   {
204     return _allowed[owner][spender];
205   }
206 
207   /**
208   * @dev Transfer token for a specified address
209   * @param to The address to transfer to.
210   * @param value The amount to be transferred.
211   */
212   function transfer(address to, uint256 value) public returns (bool) {
213     _transfer(msg.sender, to, value);
214     return true;
215   }
216 
217   /**
218    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
219    * Beware that changing an allowance with this method brings the risk that someone may use both the old
220    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
221    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
222    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
223    * @param spender The address which will spend the funds.
224    * @param value The amount of tokens to be spent.
225    */
226   function approve(address spender, uint256 value) public returns (bool) {
227     require(spender != address(0));
228 
229     _allowed[msg.sender][spender] = value;
230     emit Approval(msg.sender, spender, value);
231     return true;
232   }
233 
234   /**
235    * @dev Transfer tokens from one address to another
236    * @param from address The address which you want to send tokens from
237    * @param to address The address which you want to transfer to
238    * @param value uint256 the amount of tokens to be transferred
239    */
240   function transferFrom(
241     address from,
242     address to,
243     uint256 value
244   )
245     public
246     returns (bool)
247   {
248     require(value <= _allowed[from][msg.sender]);
249 
250     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
251     _transfer(from, to, value);
252     return true;
253   }
254 
255   /**
256    * @dev Increase the amount of tokens that an owner allowed to a spender.
257    * approve should be called when allowed_[_spender] == 0. To increment
258    * allowed value is better to use this function to avoid 2 calls (and wait until
259    * the first transaction is mined)
260    * From MonolithDAO Token.sol
261    * @param spender The address which will spend the funds.
262    * @param addedValue The amount of tokens to increase the allowance by.
263    */
264   function increaseAllowance(
265     address spender,
266     uint256 addedValue
267   )
268     public
269     returns (bool)
270   {
271     require(spender != address(0));
272 
273     _allowed[msg.sender][spender] = (
274       _allowed[msg.sender][spender].add(addedValue));
275     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
276     return true;
277   }
278 
279   /**
280    * @dev Decrease the amount of tokens that an owner allowed to a spender.
281    * approve should be called when allowed_[_spender] == 0. To decrement
282    * allowed value is better to use this function to avoid 2 calls (and wait until
283    * the first transaction is mined)
284    * From MonolithDAO Token.sol
285    * @param spender The address which will spend the funds.
286    * @param subtractedValue The amount of tokens to decrease the allowance by.
287    */
288   function decreaseAllowance(
289     address spender,
290     uint256 subtractedValue
291   )
292     public
293     returns (bool)
294   {
295     require(spender != address(0));
296 
297     _allowed[msg.sender][spender] = (
298       _allowed[msg.sender][spender].sub(subtractedValue));
299     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
300     return true;
301   }
302 
303   /**
304   * @dev Transfer token for a specified addresses
305   * @param from The address to transfer from.
306   * @param to The address to transfer to.
307   * @param value The amount to be transferred.
308   */
309   function _transfer(address from, address to, uint256 value) internal {
310     require(value <= _balances[from]);
311     require(to != address(0));
312 
313     _balances[from] = _balances[from].sub(value);
314     _balances[to] = _balances[to].add(value);
315     emit Transfer(from, to, value);
316   }
317 
318   /**
319    * @dev Internal function that mints an amount of the token and assigns it to
320    * an account. This encapsulates the modification of balances such that the
321    * proper events are emitted.
322    * @param account The account that will receive the created tokens.
323    * @param value The amount that will be created.
324    */
325   function _mint(address account, uint256 value) internal {
326     require(account != 0);
327     _totalSupply = _totalSupply.add(value);
328     _balances[account] = _balances[account].add(value);
329     emit Transfer(address(0), account, value);
330   }
331 
332   /**
333    * @dev Internal function that burns an amount of the token of a given
334    * account.
335    * @param account The account whose tokens will be burnt.
336    * @param value The amount that will be burnt.
337    */
338   function _burn(address account, uint256 value) internal {
339     require(account != 0);
340     require(value <= _balances[account]);
341 
342     _totalSupply = _totalSupply.sub(value);
343     _balances[account] = _balances[account].sub(value);
344     emit Transfer(account, address(0), value);
345   }
346 
347   /**
348    * @dev Internal function that burns an amount of the token of a given
349    * account, deducting from the sender's allowance for said account. Uses the
350    * internal burn function.
351    * @param account The account whose tokens will be burnt.
352    * @param value The amount that will be burnt.
353    */
354   function _burnFrom(address account, uint256 value) internal {
355     require(value <= _allowed[account][msg.sender]);
356 
357     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
358     // this function needs to emit an event with the updated approval.
359     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
360       value);
361     _burn(account, value);
362   }
363 }
364 
365 contract Pausable is Ownable {
366 
367     bool public paused = false;
368 
369     event Pause();
370     event Unpause();
371 
372     /**
373      * @dev Modifier to make a function callable only when the contract is not paused.
374      */
375     modifier whenNotPaused() {
376         require(!paused, "Has to be unpaused");
377         _;
378     }
379 
380     /**
381      * @dev Modifier to make a function callable only when the contract is paused.
382      */
383     modifier whenPaused() {
384         require(paused, "Has to be paused");
385         _;
386     }
387 
388     /**
389      * @dev called by the owner to pause, triggers stopped state
390      */
391     function pause() public onlyOwner whenNotPaused {
392         paused = true;
393         emit Pause();
394     }
395 
396     /**
397      * @dev called by the owner to unpause, returns to normal state
398      */
399     function unpause() public onlyOwner whenPaused {
400         paused = false;
401         emit Unpause();
402     }
403 }
404 
405 contract ERC20Detailed is IERC20 {
406   string private _name;
407   string private _symbol;
408   uint8 private _decimals;
409 
410   constructor(string name, string symbol, uint8 decimals) public {
411     _name = name;
412     _symbol = symbol;
413     _decimals = decimals;
414   }
415 
416   /**
417    * @return the name of the token.
418    */
419   function name() public view returns(string) {
420     return _name;
421   }
422 
423   /**
424    * @return the symbol of the token.
425    */
426   function symbol() public view returns(string) {
427     return _symbol;
428   }
429 
430   /**
431    * @return the number of decimals of the token.
432    */
433   function decimals() public view returns(uint8) {
434     return _decimals;
435   }
436 }
437 
438 contract PausableToken is ERC20, Pausable {
439 
440     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
441         return super.transfer(to, value);
442     }
443 
444     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
445         return super.transferFrom(from, to, value);
446     }
447 
448     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
449         return super.approve(spender, value);
450     }
451 
452     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
453         return super.increaseAllowance(spender, addedValue);
454     }
455 
456     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
457         return super.decreaseAllowance(spender, subtractedValue);
458     }
459 }
460 
461 contract IPCOToken is PausableToken, ERC20Detailed {
462     string public termsUrl = "http://xixoio.com/terms";
463     uint256 public hardCap;
464 
465     /**
466      * Token constructor, newly created token is paused
467      * @dev decimals are hardcoded to 18
468      */
469     constructor(string _name, string _symbol, uint256 _hardCap) ERC20Detailed(_name, _symbol, 18) public {
470         require(_hardCap > 0, "Hard cap can't be zero.");
471         require(bytes(_name).length > 0, "Name must be defined.");
472         require(bytes(_symbol).length > 0, "Symbol must be defined.");
473         hardCap = _hardCap;
474         pause();
475     }
476 
477     /**
478      * Minting function
479      * @dev doesn't allow minting of more tokens than hard cap
480      */
481     function mint(address to, uint256 value) public onlyOwner returns (bool) {
482         require(totalSupply().add(value) <= hardCap, "Mint of this amount would exceed the hard cap.");
483         _mint(to, value);
484         return true;
485     }
486 }