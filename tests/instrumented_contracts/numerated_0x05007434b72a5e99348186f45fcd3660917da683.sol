1 /**
2  *Submitted for verification at Etherscan.io on 2019-08-03
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2018-10-10
7 */
8 
9 pragma solidity ^0.4.24;
10 
11 /**
12  * @title SafeMath
13  * @dev Math operations with safety checks that revert on error
14  */
15 library SafeMath {
16 
17   /**
18   * @dev Multiplies two numbers, reverts on overflow.
19   */
20   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
21     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
22     // benefit is lost if 'b' is also tested.
23     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
24     if (a == 0) {
25       return 0;
26     }
27 
28     uint256 c = a * b;
29     require(c / a == b);
30 
31     return c;
32   }
33 
34   /**
35   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
36   */
37   function div(uint256 a, uint256 b) internal pure returns (uint256) {
38     require(b > 0); // Solidity only automatically asserts when dividing by 0
39     uint256 c = a / b;
40     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
41 
42     return c;
43   }
44 
45   /**
46   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
47   */
48   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49     require(b <= a);
50     uint256 c = a - b;
51 
52     return c;
53   }
54 
55   /**
56   * @dev Adds two numbers, reverts on overflow.
57   */
58   function add(uint256 a, uint256 b) internal pure returns (uint256) {
59     uint256 c = a + b;
60     require(c >= a);
61 
62     return c;
63   }
64 
65   /**
66   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
67   * reverts when dividing by zero.
68   */
69   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
70     require(b != 0);
71     return a % b;
72   }
73 }
74 
75 /**
76  * @title ERC20 interface
77  * @dev see https://github.com/ethereum/EIPs/issues/20
78  */
79 interface IERC20 {
80   function totalSupply() external view returns (uint256);
81 
82   function balanceOf(address who) external view returns (uint256);
83 
84   function allowance(address owner, address spender)
85     external view returns (uint256);
86 
87   function transfer(address to, uint256 value) external returns (bool);
88 
89   function approve(address spender, uint256 value)
90     external returns (bool);
91 
92   function transferFrom(address from, address to, uint256 value)
93     external returns (bool);
94 
95   event Transfer(
96     address indexed from,
97     address indexed to,
98     uint256 value
99   );
100 
101   event Approval(
102     address indexed owner,
103     address indexed spender,
104     uint256 value
105   );
106 }
107 
108 /**
109  * @title Standard ERC20 token
110  *
111  * @dev Implementation of the basic standard token.
112  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
113  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
114  */
115 contract ERC20 is IERC20 {
116   using SafeMath for uint256;
117 
118   mapping (address => uint256) private _balances;
119 
120   mapping (address => mapping (address => uint256)) private _allowed;
121 
122   uint256 private _totalSupply;
123 
124   /**
125   * @dev Total number of tokens in existence
126   */
127   function totalSupply() public view returns (uint256) {
128     return _totalSupply;
129   }
130 
131   /**
132   * @dev Gets the balance of the specified address.
133   * @param owner The address to query the balance of.
134   * @return An uint256 representing the amount owned by the passed address.
135   */
136   function balanceOf(address owner) public view returns (uint256) {
137     return _balances[owner];
138   }
139 
140   /**
141    * @dev Function to check the amount of tokens that an owner allowed to a spender.
142    * @param owner address The address which owns the funds.
143    * @param spender address The address which will spend the funds.
144    * @return A uint256 specifying the amount of tokens still available for the spender.
145    */
146   function allowance(
147     address owner,
148     address spender
149    )
150     public
151     view
152     returns (uint256)
153   {
154     return _allowed[owner][spender];
155   }
156 
157   /**
158   * @dev Transfer token for a specified address
159   * @param to The address to transfer to.
160   * @param value The amount to be transferred.
161   */
162   function transfer(address to, uint256 value) public returns (bool) {
163     _transfer(msg.sender, to, value);
164     return true;
165   }
166 
167   /**
168    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
169    * Beware that changing an allowance with this method brings the risk that someone may use both the old
170    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
171    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
172    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
173    * @param spender The address which will spend the funds.
174    * @param value The amount of tokens to be spent.
175    */
176   function approve(address spender, uint256 value) public returns (bool) {
177     require(spender != address(0));
178 
179     _allowed[msg.sender][spender] = value;
180     emit Approval(msg.sender, spender, value);
181     return true;
182   }
183 
184   /**
185    * @dev Transfer tokens from one address to another
186    * @param from address The address which you want to send tokens from
187    * @param to address The address which you want to transfer to
188    * @param value uint256 the amount of tokens to be transferred
189    */
190   function transferFrom(
191     address from,
192     address to,
193     uint256 value
194   )
195     public
196     returns (bool)
197   {
198     require(value <= _allowed[from][msg.sender]);
199 
200     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
201     _transfer(from, to, value);
202     return true;
203   }
204 
205   /**
206    * @dev Increase the amount of tokens that an owner allowed to a spender.
207    * approve should be called when allowed_[_spender] == 0. To increment
208    * allowed value is better to use this function to avoid 2 calls (and wait until
209    * the first transaction is mined)
210    * From MonolithDAO Token.sol
211    * @param spender The address which will spend the funds.
212    * @param addedValue The amount of tokens to increase the allowance by.
213    */
214   function increaseAllowance(
215     address spender,
216     uint256 addedValue
217   )
218     public
219     returns (bool)
220   {
221     require(spender != address(0));
222 
223     _allowed[msg.sender][spender] = (
224       _allowed[msg.sender][spender].add(addedValue));
225     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
226     return true;
227   }
228 
229   /**
230    * @dev Decrease the amount of tokens that an owner allowed to a spender.
231    * approve should be called when allowed_[_spender] == 0. To decrement
232    * allowed value is better to use this function to avoid 2 calls (and wait until
233    * the first transaction is mined)
234    * From MonolithDAO Token.sol
235    * @param spender The address which will spend the funds.
236    * @param subtractedValue The amount of tokens to decrease the allowance by.
237    */
238   function decreaseAllowance(
239     address spender,
240     uint256 subtractedValue
241   )
242     public
243     returns (bool)
244   {
245     require(spender != address(0));
246 
247     _allowed[msg.sender][spender] = (
248       _allowed[msg.sender][spender].sub(subtractedValue));
249     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
250     return true;
251   }
252 
253   /**
254   * @dev Transfer token for a specified addresses
255   * @param from The address to transfer from.
256   * @param to The address to transfer to.
257   * @param value The amount to be transferred.
258   */
259   function _transfer(address from, address to, uint256 value) internal {
260     require(value <= _balances[from]);
261     require(to != address(0));
262 
263     _balances[from] = _balances[from].sub(value);
264     _balances[to] = _balances[to].add(value);
265     emit Transfer(from, to, value);
266   }
267 
268   /**
269    * @dev Internal function that mints an amount of the token and assigns it to
270    * an account. This encapsulates the modification of balances such that the
271    * proper events are emitted.
272    * @param account The account that will receive the created tokens.
273    * @param value The amount that will be created.
274    */
275   function _mint(address account, uint256 value) internal {
276     require(account != 0);
277     _totalSupply = _totalSupply.add(value);
278     _balances[account] = _balances[account].add(value);
279     emit Transfer(address(0), account, value);
280   }
281 
282   /**
283    * @dev Internal function that burns an amount of the token of a given
284    * account.
285    * @param account The account whose tokens will be burnt.
286    * @param value The amount that will be burnt.
287    */
288   function _burn(address account, uint256 value) internal {
289     require(account != 0);
290     require(value <= _balances[account]);
291 
292     _totalSupply = _totalSupply.sub(value);
293     _balances[account] = _balances[account].sub(value);
294     emit Transfer(account, address(0), value);
295   }
296 
297   /**
298    * @dev Internal function that burns an amount of the token of a given
299    * account, deducting from the sender's allowance for said account. Uses the
300    * internal burn function.
301    * @param account The account whose tokens will be burnt.
302    * @param value The amount that will be burnt.
303    */
304   function _burnFrom(address account, uint256 value) internal {
305     require(value <= _allowed[account][msg.sender]);
306 
307     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
308     // this function needs to emit an event with the updated approval.
309     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
310       value);
311     _burn(account, value);
312   }
313 }
314 
315 
316 /**
317  * @title Ownable
318  * @dev The Ownable contract has an owner address, and provides basic authorization control
319  * functions, this simplifies the implementation of "user permissions".
320  */
321 contract Ownable {
322   address private _owner;
323 
324   event OwnershipTransferred(
325     address indexed previousOwner,
326     address indexed newOwner
327   );
328 
329   /**
330    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
331    * account.
332    */
333   constructor() public {
334     _owner = msg.sender;
335     emit OwnershipTransferred(address(0), _owner);
336   }
337 
338   /**
339    * @return the address of the owner.
340    */
341   function owner() public view returns(address) {
342     return _owner;
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
354    * @return true if `msg.sender` is the owner of the contract.
355    */
356   function isOwner() public view returns(bool) {
357     return msg.sender == _owner;
358   }
359 
360   /**
361    * @dev Allows the current owner to relinquish control of the contract.
362    * @notice Renouncing to ownership will leave the contract without an owner.
363    * It will not be possible to call the functions with the `onlyOwner`
364    * modifier anymore.
365    */
366   function renounceOwnership() public onlyOwner {
367     emit OwnershipTransferred(_owner, address(0));
368     _owner = address(0);
369   }
370 
371   /**
372    * @dev Allows the current owner to transfer control of the contract to a newOwner.
373    * @param newOwner The address to transfer ownership to.
374    */
375   function transferOwnership(address newOwner) public onlyOwner {
376     _transferOwnership(newOwner);
377   }
378 
379   /**
380    * @dev Transfers control of the contract to a newOwner.
381    * @param newOwner The address to transfer ownership to.
382    */
383   function _transferOwnership(address newOwner) internal {
384     require(newOwner != address(0));
385     emit OwnershipTransferred(_owner, newOwner);
386     _owner = newOwner;
387   }
388 }
389 
390 /**
391  * @title ERC20Detailed token
392  * @dev The decimals are only for visualization purposes.
393  * All the operations are done using the smallest and indivisible token unit,
394  * just as on Ethereum all the operations are done in wei.
395  */
396 contract ERC20Detailed is IERC20 {
397     string private _name;
398     string private _symbol;
399     uint8 private _decimals;
400 
401     constructor (string memory name, string memory symbol, uint8 decimals) public {
402         _name = name;
403         _symbol = symbol;
404         _decimals = decimals;
405     }
406 
407     /**
408      * @return the name of the token.
409      */
410     function name() public view returns (string memory) {
411         return _name;
412     }
413 
414     /**
415      * @return the symbol of the token.
416      */
417     function symbol() public view returns (string memory) {
418         return _symbol;
419     }
420 
421     /**
422      * @return the number of decimals of the token.
423      */
424     function decimals() public view returns (uint8) {
425         return _decimals;
426     }
427 }
428 
429 /**
430  * @title Burnable Token
431  * @dev Token that can be irreversibly burned (destroyed).
432  */
433 contract ERC20Burnable is ERC20, Ownable {
434 
435   /**
436    * @dev Burns a specific amount of tokens.
437    * @param value The amount of token to be burned.
438    */
439   function burn(uint256 value) onlyOwner public {
440     _burn(msg.sender, value);
441   }
442 
443   /**
444    * @dev Burns a specific amount of tokens from the target address and decrements allowance
445    * @param from address The address which you want to send tokens from
446    * @param value uint256 The amount of token to be burned
447    */
448   function burnFrom(address from, uint256 value) onlyOwner public {
449     _burnFrom(from, value);
450   }
451 }
452 
453 
454 /**
455  * @title HadaCoinV18
456  */
457 contract NightlightToken is ERC20Burnable,ERC20Detailed {
458 
459   uint8 public constant DECIMALS = 18;
460     uint256 public constant INITIAL_SUPPLY = 100000000 * (10 ** uint256(DECIMALS)); 
461 
462     /**
463      * @dev Constructor that gives msg.sender all of existing tokens.
464      */
465     constructor () public ERC20Detailed("NLC Token", "NLC", 18) {
466         _mint(msg.sender, INITIAL_SUPPLY); 
467     }
468 
469 }