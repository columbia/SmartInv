1 pragma solidity 0.4.21;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     emit OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: zeppelin-solidity/contracts/ownership/HasNoEther.sol
46 
47 /**
48  * @title Contracts that should not own Ether
49  * @author Remco Bloemen <remco@2π.com>
50  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
51  * in the contract, it will allow the owner to reclaim this ether.
52  * @notice Ether can still be send to this contract by:
53  * calling functions labeled `payable`
54  * `selfdestruct(contract_address)`
55  * mining directly to the contract address
56 */
57 contract HasNoEther is Ownable {
58 
59   address thisContract = this;
60 
61   /**
62   * @dev Constructor that rejects incoming Ether
63   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
64   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
65   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
66   * we could use assembly to access msg.value.
67   */
68   function HasNoEther() public payable {
69     require(msg.value == 0);
70   }
71 
72   /**
73    * @dev Disallows direct send by settings a default function without the `payable` flag.
74    */
75   function() external {
76   }
77 
78   /**
79    * @dev Transfer all Ether held by the contract to the owner.
80    */
81   function reclaimEther() external onlyOwner {
82     assert(owner.send(thisContract.balance));
83   }
84 }
85 
86 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
87 
88 /**
89  * @title ERC20Basic
90  * @dev Simpler version of ERC20 interface
91  * @dev see https://github.com/ethereum/EIPs/issues/179
92  */
93 contract ERC20Basic {
94   function totalSupply() public view returns (uint256);
95   function balanceOf(address who) public view returns (uint256);
96   function transfer(address to, uint256 value) public returns (bool);
97   event Transfer(address indexed from, address indexed to, uint256 value);
98 }
99 
100 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
101 
102 /**
103  * @title ERC20 interface
104  * @dev see https://github.com/ethereum/EIPs/issues/20
105  */
106 contract ERC20 is ERC20Basic {
107   function allowance(address owner, address spender) public view returns (uint256);
108   function transferFrom(address from, address to, uint256 value) public returns (bool);
109   function approve(address spender, uint256 value) public returns (bool);
110   event Approval(address indexed owner, address indexed spender, uint256 value);
111 }
112 
113 // File: zeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
114 
115 /**
116  * @title SafeERC20
117  * @dev Wrappers around ERC20 operations that throw on failure.
118  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
119  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
120  */
121 library SafeERC20 {
122   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
123     assert(token.transfer(to, value));
124   }
125 
126   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
127     assert(token.transferFrom(from, to, value));
128   }
129 
130   function safeApprove(ERC20 token, address spender, uint256 value) internal {
131     assert(token.approve(spender, value));
132   }
133 }
134 
135 // File: zeppelin-solidity/contracts/ownership/CanReclaimToken.sol
136 
137 /**
138  * @title Contracts that should be able to recover tokens
139  * @author SylTi
140  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
141  * This will prevent any accidental loss of tokens.
142  */
143 contract CanReclaimToken is Ownable {
144   using SafeERC20 for ERC20Basic;
145 
146   /**
147    * @dev Reclaim all ERC20Basic compatible tokens
148    * @param token ERC20Basic The address of the token contract
149    */
150   function reclaimToken(ERC20Basic token) external onlyOwner {
151     uint256 balance = token.balanceOf(this);
152     token.safeTransfer(owner, balance);
153   }
154 
155 }
156 
157 // File: zeppelin-solidity/contracts/ownership/HasNoTokens.sol
158 
159 /**
160  * @title Contracts that should not own Tokens
161  * @author Remco Bloemen <remco@2π.com>
162  * @dev This blocks incoming ERC223 tokens to prevent accidental loss of tokens.
163  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
164  * owner to reclaim the tokens.
165  */
166 contract HasNoTokens is CanReclaimToken {
167 
168  /**
169   * @dev Reject all ERC223 compatible tokens
170   * @param from_ address The address that is transferring the tokens
171   * @param value_ uint256 the amount of the specified token
172   * @param data_ Bytes The data passed from the caller.
173   */
174   function tokenFallback(address from_, uint256 value_, bytes data_) external pure {
175     from_;
176     value_;
177     data_;
178     revert();
179   }
180 
181 }
182 
183 // File: zeppelin-solidity/contracts/math/SafeMath.sol
184 
185 /**
186  * @title SafeMath
187  * @dev Math operations with safety checks that throw on error
188  */
189 library SafeMath {
190 
191   /**
192   * @dev Multiplies two numbers, throws on overflow.
193   */
194   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
195     if (a == 0) {
196       return 0;
197     }
198     uint256 c = a * b;
199     assert(c / a == b);
200     return c;
201   }
202 
203   /**
204   * @dev Integer division of two numbers, truncating the quotient.
205   */
206   function div(uint256 a, uint256 b) internal pure returns (uint256) {
207     // assert(b > 0); // Solidity automatically throws when dividing by 0
208     uint256 c = a / b;
209     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
210     return c;
211   }
212 
213   /**
214   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
215   */
216   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
217     assert(b <= a);
218     return a - b;
219   }
220 
221   /**
222   * @dev Adds two numbers, throws on overflow.
223   */
224   function add(uint256 a, uint256 b) internal pure returns (uint256) {
225     uint256 c = a + b;
226     assert(c >= a);
227     return c;
228   }
229 }
230 
231 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
232 
233 /**
234  * @title Basic token
235  * @dev Basic version of StandardToken, with no allowances.
236  */
237 contract BasicToken is ERC20Basic {
238   using SafeMath for uint256;
239 
240   mapping(address => uint256) balances;
241 
242   uint256 totalSupply_;
243 
244   /**
245   * @dev total number of tokens in existence
246   */
247   function totalSupply() public view returns (uint256) {
248     return totalSupply_;
249   }
250 
251   /**
252   * @dev transfer token for a specified address
253   * @param _to The address to transfer to.
254   * @param _value The amount to be transferred.
255   */
256   function transfer(address _to, uint256 _value) public returns (bool) {
257     require(_to != address(0));
258     require(_value <= balances[msg.sender]);
259 
260     // SafeMath.sub will throw if there is not enough balance.
261     balances[msg.sender] = balances[msg.sender].sub(_value);
262     balances[_to] = balances[_to].add(_value);
263     emit Transfer(msg.sender, _to, _value);
264     return true;
265   }
266 
267   /**
268   * @dev Gets the balance of the specified address.
269   * @param _owner The address to query the the balance of.
270   * @return An uint256 representing the amount owned by the passed address.
271   */
272   function balanceOf(address _owner) public view returns (uint256 balance) {
273     return balances[_owner];
274   }
275 
276 }
277 
278 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
279 
280 /**
281  * @title Standard ERC20 token
282  *
283  * @dev Implementation of the basic standard token.
284  * @dev https://github.com/ethereum/EIPs/issues/20
285  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
286  */
287 contract StandardToken is ERC20, BasicToken {
288 
289   mapping (address => mapping (address => uint256)) internal allowed;
290 
291 
292   /**
293    * @dev Transfer tokens from one address to another
294    * @param _from address The address which you want to send tokens from
295    * @param _to address The address which you want to transfer to
296    * @param _value uint256 the amount of tokens to be transferred
297    */
298   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
299     require(_to != address(0));
300     require(_value <= balances[_from]);
301     require(_value <= allowed[_from][msg.sender]);
302 
303     balances[_from] = balances[_from].sub(_value);
304     balances[_to] = balances[_to].add(_value);
305     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
306     emit Transfer(_from, _to, _value);
307     return true;
308   }
309 
310   /**
311    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
312    *
313    * Beware that changing an allowance with this method brings the risk that someone may use both the old
314    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
315    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
316    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
317    * @param _spender The address which will spend the funds.
318    * @param _value The amount of tokens to be spent.
319    */
320   function approve(address _spender, uint256 _value) public returns (bool) {
321     allowed[msg.sender][_spender] = _value;
322     emit Approval(msg.sender, _spender, _value);
323     return true;
324   }
325 
326   /**
327    * @dev Function to check the amount of tokens that an owner allowed to a spender.
328    * @param _owner address The address which owns the funds.
329    * @param _spender address The address which will spend the funds.
330    * @return A uint256 specifying the amount of tokens still available for the spender.
331    */
332   function allowance(address _owner, address _spender) public view returns (uint256) {
333     return allowed[_owner][_spender];
334   }
335 
336   /**
337    * @dev Increase the amount of tokens that an owner allowed to a spender.
338    *
339    * approve should be called when allowed[_spender] == 0. To increment
340    * allowed value is better to use this function to avoid 2 calls (and wait until
341    * the first transaction is mined)
342    * From MonolithDAO Token.sol
343    * @param _spender The address which will spend the funds.
344    * @param _addedValue The amount of tokens to increase the allowance by.
345    */
346   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
347     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
348     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
349     return true;
350   }
351 
352   /**
353    * @dev Decrease the amount of tokens that an owner allowed to a spender.
354    *
355    * approve should be called when allowed[_spender] == 0. To decrement
356    * allowed value is better to use this function to avoid 2 calls (and wait until
357    * the first transaction is mined)
358    * From MonolithDAO Token.sol
359    * @param _spender The address which will spend the funds.
360    * @param _subtractedValue The amount of tokens to decrease the allowance by.
361    */
362   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
363     uint oldValue = allowed[msg.sender][_spender];
364     if (_subtractedValue > oldValue) {
365       allowed[msg.sender][_spender] = 0;
366     } else {
367       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
368     }
369     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
370     return true;
371   }
372 
373 }
374 
375 // File: zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
376 
377 /**
378  * @title Mintable token
379  * @dev Simple ERC20 Token example, with mintable token creation
380  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
381  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
382  */
383 contract MintableToken is StandardToken, Ownable {
384   event Mint(address indexed to, uint256 amount);
385   event MintFinished();
386 
387   bool public mintingFinished = false;
388 
389 
390   modifier canMint() {
391     require(!mintingFinished);
392     _;
393   }
394 
395   /**
396    * @dev Function to mint tokens
397    * @param _to The address that will receive the minted tokens.
398    * @param _amount The amount of tokens to mint.
399    * @return A boolean that indicates if the operation was successful.
400    */
401   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
402     totalSupply_ = totalSupply_.add(_amount);
403     balances[_to] = balances[_to].add(_amount);
404     emit Mint(_to, _amount);
405     emit Transfer(address(0), _to, _amount);
406     return true;
407   }
408 
409   /**
410    * @dev Function to stop minting new tokens.
411    * @return True if the operation was successful.
412    */
413   function finishMinting() onlyOwner canMint public returns (bool) {
414     mintingFinished = true;
415     emit MintFinished();
416     return true;
417   }
418 }
419 
420 // File: zeppelin-solidity/contracts/token/ERC20/CappedToken.sol
421 
422 /**
423  * @title Capped token
424  * @dev Mintable token with a token cap.
425  */
426 contract CappedToken is MintableToken {
427 
428   uint256 public cap;
429 
430   function CappedToken(uint256 _cap) public {
431     require(_cap > 0);
432     cap = _cap;
433   }
434 
435   /**
436    * @dev Function to mint tokens
437    * @param _to The address that will receive the minted tokens.
438    * @param _amount The amount of tokens to mint.
439    * @return A boolean that indicates if the operation was successful.
440    */
441   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
442     require(totalSupply_.add(_amount) <= cap);
443 
444     return super.mint(_to, _amount);
445   }
446 
447 }
448 
449 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
450 
451 /**
452  * @title Pausable
453  * @dev Base contract which allows children to implement an emergency stop mechanism.
454  */
455 contract Pausable is Ownable {
456   event Pause();
457   event Unpause();
458 
459   bool public paused = false;
460 
461 
462   /**
463    * @dev Modifier to make a function callable only when the contract is not paused.
464    */
465   modifier whenNotPaused() {
466     require(!paused);
467     _;
468   }
469 
470   /**
471    * @dev Modifier to make a function callable only when the contract is paused.
472    */
473   modifier whenPaused() {
474     require(paused);
475     _;
476   }
477 
478   /**
479    * @dev called by the owner to pause, triggers stopped state
480    */
481   function pause() onlyOwner whenNotPaused public {
482     paused = true;
483     emit Pause();
484   }
485 
486   /**
487    * @dev called by the owner to unpause, returns to normal state
488    */
489   function unpause() onlyOwner whenPaused public {
490     paused = false;
491     emit Unpause();
492   }
493 }
494 
495 // File: zeppelin-solidity/contracts/token/ERC20/PausableToken.sol
496 
497 /**
498  * @title Pausable token
499  * @dev StandardToken modified with pausable transfers.
500  **/
501 contract PausableToken is StandardToken, Pausable {
502 
503   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
504     return super.transfer(_to, _value);
505   }
506 
507   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
508     return super.transferFrom(_from, _to, _value);
509   }
510 
511   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
512     return super.approve(_spender, _value);
513   }
514 
515   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
516     return super.increaseApproval(_spender, _addedValue);
517   }
518 
519   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
520     return super.decreaseApproval(_spender, _subtractedValue);
521   }
522 }
523 
524 // File: contracts/OWEToken.sol
525 
526 contract OWEToken is CappedToken, PausableToken, HasNoEther, HasNoTokens {
527 
528   string public constant name = "OWE Token";
529   string public constant symbol = "OWE";
530   uint8 public constant decimals = 18;
531   
532   uint256 private constant TWO_HUNDRED_AND_FIFTY_MILLION_TOKENS = 250000000000000000000000000;
533 
534   function OWEToken() public
535     CappedToken(TWO_HUNDRED_AND_FIFTY_MILLION_TOKENS)
536   {
537   }
538 }