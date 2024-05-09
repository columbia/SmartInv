1 // File: openzeppelin-solidity\contracts\ownership\Ownable.sol
2 
3 pragma solidity ^0.4.24;
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address private _owner;
12 
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18   /**
19    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
20    * account.
21    */
22   constructor() internal {
23     _owner = msg.sender;
24     emit OwnershipTransferred(address(0), _owner);
25   }
26 
27   /**
28    * @return the address of the owner.
29    */
30   function owner() public view returns(address) {
31     return _owner;
32   }
33 
34   /**
35    * @dev Throws if called by any account other than the owner.
36    */
37   modifier onlyOwner() {
38     require(isOwner());
39     _;
40   }
41 
42   /**
43    * @return true if `msg.sender` is the owner of the contract.
44    */
45   function isOwner() public view returns(bool) {
46     return msg.sender == _owner;
47   }
48 
49   /**
50    * @dev Allows the current owner to relinquish control of the contract.
51    * @notice Renouncing to ownership will leave the contract without an owner.
52    * It will not be possible to call the functions with the `onlyOwner`
53    * modifier anymore.
54    */
55   function renounceOwnership() public onlyOwner {
56     emit OwnershipTransferred(_owner, address(0));
57     _owner = address(0);
58   }
59 
60   /**
61    * @dev Allows the current owner to transfer control of the contract to a newOwner.
62    * @param newOwner The address to transfer ownership to.
63    */
64   function transferOwnership(address newOwner) public onlyOwner {
65     _transferOwnership(newOwner);
66   }
67 
68   /**
69    * @dev Transfers control of the contract to a newOwner.
70    * @param newOwner The address to transfer ownership to.
71    */
72   function _transferOwnership(address newOwner) internal {
73     require(newOwner != address(0));
74     emit OwnershipTransferred(_owner, newOwner);
75     _owner = newOwner;
76   }
77 }
78 
79 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\IERC20.sol
80 
81 pragma solidity ^0.4.24;
82 
83 /**
84  * @title ERC20 interface
85  * @dev see https://github.com/ethereum/EIPs/issues/20
86  */
87 interface IERC20 {
88   function totalSupply() external view returns (uint256);
89 
90   function balanceOf(address who) external view returns (uint256);
91 
92   function allowance(address owner, address spender)
93     external view returns (uint256);
94 
95   function transfer(address to, uint256 value) external returns (bool);
96 
97   function approve(address spender, uint256 value)
98     external returns (bool);
99 
100   function transferFrom(address from, address to, uint256 value)
101     external returns (bool);
102 
103   event Transfer(
104     address indexed from,
105     address indexed to,
106     uint256 value
107   );
108 
109   event Approval(
110     address indexed owner,
111     address indexed spender,
112     uint256 value
113   );
114 }
115 
116 // File: node_modules\openzeppelin-solidity\contracts\math\SafeMath.sol
117 
118 pragma solidity ^0.4.24;
119 
120 /**
121  * @title SafeMath
122  * @dev Math operations with safety checks that revert on error
123  */
124 library SafeMath {
125 
126   /**
127   * @dev Multiplies two numbers, reverts on overflow.
128   */
129   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
130     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
131     // benefit is lost if 'b' is also tested.
132     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
133     if (a == 0) {
134       return 0;
135     }
136 
137     uint256 c = a * b;
138     require(c / a == b);
139 
140     return c;
141   }
142 
143   /**
144   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
145   */
146   function div(uint256 a, uint256 b) internal pure returns (uint256) {
147     require(b > 0); // Solidity only automatically asserts when dividing by 0
148     uint256 c = a / b;
149     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
150 
151     return c;
152   }
153 
154   /**
155   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
156   */
157   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
158     require(b <= a);
159     uint256 c = a - b;
160 
161     return c;
162   }
163 
164   /**
165   * @dev Adds two numbers, reverts on overflow.
166   */
167   function add(uint256 a, uint256 b) internal pure returns (uint256) {
168     uint256 c = a + b;
169     require(c >= a);
170 
171     return c;
172   }
173 
174   /**
175   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
176   * reverts when dividing by zero.
177   */
178   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
179     require(b != 0);
180     return a % b;
181   }
182 }
183 
184 // File: openzeppelin-solidity\contracts\token\ERC20\ERC20.sol
185 
186 pragma solidity ^0.4.24;
187 
188 
189 
190 /**
191  * @title Standard ERC20 token
192  *
193  * @dev Implementation of the basic standard token.
194  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
195  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
196  */
197 contract ERC20 is IERC20 {
198   using SafeMath for uint256;
199 
200   mapping (address => uint256) private _balances;
201 
202   mapping (address => mapping (address => uint256)) private _allowed;
203 
204   uint256 private _totalSupply;
205 
206   /**
207   * @dev Total number of tokens in existence
208   */
209   function totalSupply() public view returns (uint256) {
210     return _totalSupply;
211   }
212 
213   /**
214   * @dev Gets the balance of the specified address.
215   * @param owner The address to query the balance of.
216   * @return An uint256 representing the amount owned by the passed address.
217   */
218   function balanceOf(address owner) public view returns (uint256) {
219     return _balances[owner];
220   }
221 
222   /**
223    * @dev Function to check the amount of tokens that an owner allowed to a spender.
224    * @param owner address The address which owns the funds.
225    * @param spender address The address which will spend the funds.
226    * @return A uint256 specifying the amount of tokens still available for the spender.
227    */
228   function allowance(
229     address owner,
230     address spender
231    )
232     public
233     view
234     returns (uint256)
235   {
236     return _allowed[owner][spender];
237   }
238 
239   /**
240   * @dev Transfer token for a specified address
241   * @param to The address to transfer to.
242   * @param value The amount to be transferred.
243   */
244   function transfer(address to, uint256 value) public returns (bool) {
245     _transfer(msg.sender, to, value);
246     return true;
247   }
248 
249   /**
250    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
251    * Beware that changing an allowance with this method brings the risk that someone may use both the old
252    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
253    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
254    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
255    * @param spender The address which will spend the funds.
256    * @param value The amount of tokens to be spent.
257    */
258   function approve(address spender, uint256 value) public returns (bool) {
259     require(spender != address(0));
260 
261     _allowed[msg.sender][spender] = value;
262     emit Approval(msg.sender, spender, value);
263     return true;
264   }
265 
266   /**
267    * @dev Transfer tokens from one address to another
268    * @param from address The address which you want to send tokens from
269    * @param to address The address which you want to transfer to
270    * @param value uint256 the amount of tokens to be transferred
271    */
272   function transferFrom(
273     address from,
274     address to,
275     uint256 value
276   )
277     public
278     returns (bool)
279   {
280     require(value <= _allowed[from][msg.sender]);
281 
282     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
283     _transfer(from, to, value);
284     return true;
285   }
286 
287   /**
288    * @dev Increase the amount of tokens that an owner allowed to a spender.
289    * approve should be called when allowed_[_spender] == 0. To increment
290    * allowed value is better to use this function to avoid 2 calls (and wait until
291    * the first transaction is mined)
292    * From MonolithDAO Token.sol
293    * @param spender The address which will spend the funds.
294    * @param addedValue The amount of tokens to increase the allowance by.
295    */
296   function increaseAllowance(
297     address spender,
298     uint256 addedValue
299   )
300     public
301     returns (bool)
302   {
303     require(spender != address(0));
304 
305     _allowed[msg.sender][spender] = (
306       _allowed[msg.sender][spender].add(addedValue));
307     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
308     return true;
309   }
310 
311   /**
312    * @dev Decrease the amount of tokens that an owner allowed to a spender.
313    * approve should be called when allowed_[_spender] == 0. To decrement
314    * allowed value is better to use this function to avoid 2 calls (and wait until
315    * the first transaction is mined)
316    * From MonolithDAO Token.sol
317    * @param spender The address which will spend the funds.
318    * @param subtractedValue The amount of tokens to decrease the allowance by.
319    */
320   function decreaseAllowance(
321     address spender,
322     uint256 subtractedValue
323   )
324     public
325     returns (bool)
326   {
327     require(spender != address(0));
328 
329     _allowed[msg.sender][spender] = (
330       _allowed[msg.sender][spender].sub(subtractedValue));
331     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
332     return true;
333   }
334 
335   /**
336   * @dev Transfer token for a specified addresses
337   * @param from The address to transfer from.
338   * @param to The address to transfer to.
339   * @param value The amount to be transferred.
340   */
341   function _transfer(address from, address to, uint256 value) internal {
342     require(value <= _balances[from]);
343     require(to != address(0));
344 
345     _balances[from] = _balances[from].sub(value);
346     _balances[to] = _balances[to].add(value);
347     emit Transfer(from, to, value);
348   }
349 
350   /**
351    * @dev Internal function that mints an amount of the token and assigns it to
352    * an account. This encapsulates the modification of balances such that the
353    * proper events are emitted.
354    * @param account The account that will receive the created tokens.
355    * @param value The amount that will be created.
356    */
357   function _mint(address account, uint256 value) internal {
358     require(account != 0);
359     _totalSupply = _totalSupply.add(value);
360     _balances[account] = _balances[account].add(value);
361     emit Transfer(address(0), account, value);
362   }
363 
364   /**
365    * @dev Internal function that burns an amount of the token of a given
366    * account.
367    * @param account The account whose tokens will be burnt.
368    * @param value The amount that will be burnt.
369    */
370   function _burn(address account, uint256 value) internal {
371     require(account != 0);
372     require(value <= _balances[account]);
373 
374     _totalSupply = _totalSupply.sub(value);
375     _balances[account] = _balances[account].sub(value);
376     emit Transfer(account, address(0), value);
377   }
378 
379   /**
380    * @dev Internal function that burns an amount of the token of a given
381    * account, deducting from the sender's allowance for said account. Uses the
382    * internal burn function.
383    * @param account The account whose tokens will be burnt.
384    * @param value The amount that will be burnt.
385    */
386   function _burnFrom(address account, uint256 value) internal {
387     require(value <= _allowed[account][msg.sender]);
388 
389     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
390     // this function needs to emit an event with the updated approval.
391     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
392       value);
393     _burn(account, value);
394   }
395 }
396 
397 // File: contracts\CnusUpToken.sol
398 
399 pragma solidity ^0.4.24;
400 
401 
402 
403 
404 /** @title CnusUp Token
405   * An ERC20-compliant token.
406   */
407 contract CnusUpToken is ERC20, Ownable {
408     using SafeMath for uint256;
409 
410     bool public transfersEnabled = false;
411 
412     string public name = "CoinUs CnusUp";
413     string public symbol = "CNUSUP";
414     uint256 public decimals = 18;
415 
416     event TransfersAllowed(bool _transfersEnabled);
417 
418     modifier transfersAllowed {
419         require(transfersEnabled);
420         _;
421     }
422 
423     // validates an address - currently only checks that it isn't null
424     modifier validAddress(address _address) {
425         require(_address != address(0));
426         _;
427     }
428 
429     // verifies that the address is different than this contract address
430     modifier notThis(address _address) {
431         require(_address != address(this));
432         _;
433     }
434 
435     function disableTransfers(bool _disable) public onlyOwner {
436         transfersEnabled = !_disable;
437         emit TransfersAllowed(transfersEnabled);
438     }
439 
440     function batchIssue(address[] memory _to, uint256[] memory _amount)
441         public
442         onlyOwner
443     {
444         require(_to.length == _amount.length);
445         for(uint i = 0; i < _to.length; i++) {
446             require(_to[i] != address(0));
447             require(_to[i] != address(this));
448             _mint(_to[i], _amount[i]);
449         }
450     }
451 
452     function checkMisplacedTokenBalance(
453         address _tokenAddress
454     )
455     public
456     view
457     returns (uint256)
458     {
459         ERC20 unknownToken = ERC20(_tokenAddress);
460         return unknownToken.balanceOf(address(this));
461     }
462 
463     // Allow transfer of accidentally sent ERC20 tokens
464     function refundMisplacedToken(
465         address _recipient,
466         address _tokenAddress,
467         uint256 _value
468     )
469     public
470     onlyOwner
471     {
472         _transferMisplacedToken(_recipient, _tokenAddress, _value);
473     }
474 
475     function transfer(address _to, uint256 _value) public transfersAllowed returns (bool success) {
476         assert(super.transfer(_to, _value));
477         return true;
478     }
479 
480     function transferFrom(address _from, address _to, uint256 _value) public transfersAllowed returns (bool success) {
481         assert(super.transferFrom(_from, _to, _value));
482         return true;
483     }
484 
485     function _transferMisplacedToken(
486         address _recipient,
487         address _tokenAddress,
488         uint256 _value
489     )
490     internal
491     {
492         require(_recipient != address(0));
493         ERC20 unknownToken = ERC20(_tokenAddress);
494         require(unknownToken.balanceOf(address(this)) >= _value, "Insufficient token balance.");
495         require(unknownToken.transfer(_recipient, _value));
496     }
497 }