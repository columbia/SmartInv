1 //File: node_modules\openzeppelin-solidity\contracts\token\ERC20\IERC20.sol
2 pragma solidity ^0.4.24;
3 
4 /**
5  * @title ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/20
7  */
8 interface IERC20 {
9   function totalSupply() external view returns (uint256);
10 
11   function balanceOf(address who) external view returns (uint256);
12 
13   function allowance(address owner, address spender)
14     external view returns (uint256);
15 
16   function transfer(address to, uint256 value) external returns (bool);
17 
18   function approve(address spender, uint256 value)
19     external returns (bool);
20 
21   function transferFrom(address from, address to, uint256 value)
22     external returns (bool);
23 
24   event Transfer(
25     address indexed from,
26     address indexed to,
27     uint256 value
28   );
29 
30   event Approval(
31     address indexed owner,
32     address indexed spender,
33     uint256 value
34   );
35 }
36 
37 //File: node_modules\openzeppelin-solidity\contracts\math\SafeMath.sol
38 pragma solidity ^0.4.24;
39 
40 /**
41  * @title SafeMath
42  * @dev Math operations with safety checks that revert on error
43  */
44 library SafeMath {
45 
46   /**
47   * @dev Multiplies two numbers, reverts on overflow.
48   */
49   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
50     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
51     // benefit is lost if 'b' is also tested.
52     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
53     if (a == 0) {
54       return 0;
55     }
56 
57     uint256 c = a * b;
58     require(c / a == b);
59 
60     return c;
61   }
62 
63   /**
64   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
65   */
66   function div(uint256 a, uint256 b) internal pure returns (uint256) {
67     require(b > 0); // Solidity only automatically asserts when dividing by 0
68     uint256 c = a / b;
69     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70 
71     return c;
72   }
73 
74   /**
75   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
76   */
77   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
78     require(b <= a);
79     uint256 c = a - b;
80 
81     return c;
82   }
83 
84   /**
85   * @dev Adds two numbers, reverts on overflow.
86   */
87   function add(uint256 a, uint256 b) internal pure returns (uint256) {
88     uint256 c = a + b;
89     require(c >= a);
90 
91     return c;
92   }
93 
94   /**
95   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
96   * reverts when dividing by zero.
97   */
98   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
99     require(b != 0);
100     return a % b;
101   }
102 }
103 
104 //File: node_modules\openzeppelin-solidity\contracts\token\ERC20\ERC20.sol
105 pragma solidity ^0.4.24;
106 
107 
108 
109 
110 /**
111  * @title Standard ERC20 token
112  *
113  * @dev Implementation of the basic standard token.
114  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
115  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
116  */
117 contract ERC20 is IERC20 {
118   using SafeMath for uint256;
119 
120   mapping (address => uint256) private _balances;
121 
122   mapping (address => mapping (address => uint256)) private _allowed;
123 
124   uint256 private _totalSupply;
125 
126   /**
127   * @dev Total number of tokens in existence
128   */
129   function totalSupply() public view returns (uint256) {
130     return _totalSupply;
131   }
132 
133   /**
134   * @dev Gets the balance of the specified address.
135   * @param owner The address to query the balance of.
136   * @return An uint256 representing the amount owned by the passed address.
137   */
138   function balanceOf(address owner) public view returns (uint256) {
139     return _balances[owner];
140   }
141 
142   /**
143    * @dev Function to check the amount of tokens that an owner allowed to a spender.
144    * @param owner address The address which owns the funds.
145    * @param spender address The address which will spend the funds.
146    * @return A uint256 specifying the amount of tokens still available for the spender.
147    */
148   function allowance(
149     address owner,
150     address spender
151    )
152     public
153     view
154     returns (uint256)
155   {
156     return _allowed[owner][spender];
157   }
158 
159   /**
160   * @dev Transfer token for a specified address
161   * @param to The address to transfer to.
162   * @param value The amount to be transferred.
163   */
164   function transfer(address to, uint256 value) public returns (bool) {
165     _transfer(msg.sender, to, value);
166     return true;
167   }
168 
169   /**
170    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
171    * Beware that changing an allowance with this method brings the risk that someone may use both the old
172    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
173    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
174    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
175    * @param spender The address which will spend the funds.
176    * @param value The amount of tokens to be spent.
177    */
178   function approve(address spender, uint256 value) public returns (bool) {
179     require(spender != address(0));
180 
181     _allowed[msg.sender][spender] = value;
182     emit Approval(msg.sender, spender, value);
183     return true;
184   }
185 
186   /**
187    * @dev Transfer tokens from one address to another
188    * @param from address The address which you want to send tokens from
189    * @param to address The address which you want to transfer to
190    * @param value uint256 the amount of tokens to be transferred
191    */
192   function transferFrom(
193     address from,
194     address to,
195     uint256 value
196   )
197     public
198     returns (bool)
199   {
200     require(value <= _allowed[from][msg.sender]);
201 
202     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
203     _transfer(from, to, value);
204     return true;
205   }
206 
207   /**
208    * @dev Increase the amount of tokens that an owner allowed to a spender.
209    * approve should be called when allowed_[_spender] == 0. To increment
210    * allowed value is better to use this function to avoid 2 calls (and wait until
211    * the first transaction is mined)
212    * From MonolithDAO Token.sol
213    * @param spender The address which will spend the funds.
214    * @param addedValue The amount of tokens to increase the allowance by.
215    */
216   function increaseAllowance(
217     address spender,
218     uint256 addedValue
219   )
220     public
221     returns (bool)
222   {
223     require(spender != address(0));
224 
225     _allowed[msg.sender][spender] = (
226       _allowed[msg.sender][spender].add(addedValue));
227     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
228     return true;
229   }
230 
231   /**
232    * @dev Decrease the amount of tokens that an owner allowed to a spender.
233    * approve should be called when allowed_[_spender] == 0. To decrement
234    * allowed value is better to use this function to avoid 2 calls (and wait until
235    * the first transaction is mined)
236    * From MonolithDAO Token.sol
237    * @param spender The address which will spend the funds.
238    * @param subtractedValue The amount of tokens to decrease the allowance by.
239    */
240   function decreaseAllowance(
241     address spender,
242     uint256 subtractedValue
243   )
244     public
245     returns (bool)
246   {
247     require(spender != address(0));
248 
249     _allowed[msg.sender][spender] = (
250       _allowed[msg.sender][spender].sub(subtractedValue));
251     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
252     return true;
253   }
254 
255   /**
256   * @dev Transfer token for a specified addresses
257   * @param from The address to transfer from.
258   * @param to The address to transfer to.
259   * @param value The amount to be transferred.
260   */
261   function _transfer(address from, address to, uint256 value) internal {
262     require(value <= _balances[from]);
263     require(to != address(0));
264 
265     _balances[from] = _balances[from].sub(value);
266     _balances[to] = _balances[to].add(value);
267     emit Transfer(from, to, value);
268   }
269 
270   /**
271    * @dev Internal function that mints an amount of the token and assigns it to
272    * an account. This encapsulates the modification of balances such that the
273    * proper events are emitted.
274    * @param account The account that will receive the created tokens.
275    * @param value The amount that will be created.
276    */
277   function _mint(address account, uint256 value) internal {
278     require(account != 0);
279     _totalSupply = _totalSupply.add(value);
280     _balances[account] = _balances[account].add(value);
281     emit Transfer(address(0), account, value);
282   }
283 
284   /**
285    * @dev Internal function that burns an amount of the token of a given
286    * account.
287    * @param account The account whose tokens will be burnt.
288    * @param value The amount that will be burnt.
289    */
290   function _burn(address account, uint256 value) internal {
291     require(account != 0);
292     require(value <= _balances[account]);
293 
294     _totalSupply = _totalSupply.sub(value);
295     _balances[account] = _balances[account].sub(value);
296     emit Transfer(account, address(0), value);
297   }
298 
299   /**
300    * @dev Internal function that burns an amount of the token of a given
301    * account, deducting from the sender's allowance for said account. Uses the
302    * internal burn function.
303    * @param account The account whose tokens will be burnt.
304    * @param value The amount that will be burnt.
305    */
306   function _burnFrom(address account, uint256 value) internal {
307     require(value <= _allowed[account][msg.sender]);
308 
309     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
310     // this function needs to emit an event with the updated approval.
311     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
312       value);
313     _burn(account, value);
314   }
315 }
316 
317 //File: node_modules\openzeppelin-solidity\contracts\ownership\Ownable.sol
318 pragma solidity ^0.4.24;
319 
320 /**
321  * @title Ownable
322  * @dev The Ownable contract has an owner address, and provides basic authorization control
323  * functions, this simplifies the implementation of "user permissions".
324  */
325 contract Ownable {
326   address private _owner;
327 
328   event OwnershipTransferred(
329     address indexed previousOwner,
330     address indexed newOwner
331   );
332 
333   /**
334    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
335    * account.
336    */
337   constructor() internal {
338     _owner = msg.sender;
339     emit OwnershipTransferred(address(0), _owner);
340   }
341 
342   /**
343    * @return the address of the owner.
344    */
345   function owner() public view returns(address) {
346     return _owner;
347   }
348 
349   /**
350    * @dev Throws if called by any account other than the owner.
351    */
352   modifier onlyOwner() {
353     require(isOwner());
354     _;
355   }
356 
357   /**
358    * @return true if `msg.sender` is the owner of the contract.
359    */
360   function isOwner() public view returns(bool) {
361     return msg.sender == _owner;
362   }
363 
364   /**
365    * @dev Allows the current owner to relinquish control of the contract.
366    * @notice Renouncing to ownership will leave the contract without an owner.
367    * It will not be possible to call the functions with the `onlyOwner`
368    * modifier anymore.
369    */
370   function renounceOwnership() public onlyOwner {
371     emit OwnershipTransferred(_owner, address(0));
372     _owner = address(0);
373   }
374 
375   /**
376    * @dev Allows the current owner to transfer control of the contract to a newOwner.
377    * @param newOwner The address to transfer ownership to.
378    */
379   function transferOwnership(address newOwner) public onlyOwner {
380     _transferOwnership(newOwner);
381   }
382 
383   /**
384    * @dev Transfers control of the contract to a newOwner.
385    * @param newOwner The address to transfer ownership to.
386    */
387   function _transferOwnership(address newOwner) internal {
388     require(newOwner != address(0));
389     emit OwnershipTransferred(_owner, newOwner);
390     _owner = newOwner;
391   }
392 }
393 
394 //File: contracts\RKRToken.sol
395 /**
396  * @title RKR token
397  *
398  * @version 1.0
399  * @author Rockerchain
400  */
401 pragma solidity ^0.4.21;
402 
403 
404 
405 
406 
407 
408 contract RKRToken is ERC20, Ownable {
409     using SafeMath for uint256;
410     
411     string public constant name = "RKRToken";
412     string public constant symbol = "RKR";
413     uint8 public constant decimals = 18;
414     uint256 public constant UNLOCKED_SUPPLY = 36e6 * 1e18;
415     uint256 public constant TEAM_SUPPLY = 10e6 * 1e18;
416     uint256 public constant ADVISOR_SUPPLY = 10e6 * 1e18;
417     uint256 public constant RESERVED_SUPPLY = 44e6 * 1e18;
418     bool public ADVISOR_SUPPLY_INITIALIZED;
419     bool public TEAM_SUPPLY_INITIALIZED;
420     bool public RESERVED_SUPPLY_INITIALIZED;
421 
422      /**
423      * @dev Constructor of RKRToken 
424      */
425     constructor() public {
426         _mint(msg.sender, UNLOCKED_SUPPLY);
427         ADVISOR_SUPPLY_INITIALIZED = false;
428         TEAM_SUPPLY_INITIALIZED = false;
429         RESERVED_SUPPLY_INITIALIZED = false;
430     }
431 
432      /**
433      * @dev Mints and initialize Advisor reserve 
434      */
435     function initializeAdvisorVault(address advisorVault) public onlyOwner {
436         require(ADVISOR_SUPPLY_INITIALIZED == false);
437         ADVISOR_SUPPLY_INITIALIZED = true;
438         _mint(advisorVault, ADVISOR_SUPPLY);
439     }
440 
441      /**
442      * @dev Mints and initialize Team reserve 
443      */
444     function initializeTeamVault(address teamVault) public onlyOwner {
445         require(TEAM_SUPPLY_INITIALIZED == false);
446         TEAM_SUPPLY_INITIALIZED = true;
447         _mint(teamVault, TEAM_SUPPLY);
448     }
449 
450      /**
451      * @dev Mints and initialize Reserved reserve 
452      */
453     function initializeReservedVault(address reservedVault) public onlyOwner {
454         require(RESERVED_SUPPLY_INITIALIZED == false);
455         RESERVED_SUPPLY_INITIALIZED = true;
456         _mint(reservedVault, RESERVED_SUPPLY);
457     }
458 
459 }