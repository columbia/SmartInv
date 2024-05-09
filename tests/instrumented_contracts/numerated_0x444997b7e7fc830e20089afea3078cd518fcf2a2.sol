1 pragma solidity 0.4.23;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
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
45 // File: openzeppelin-solidity/contracts/ownership/HasNoEther.sol
46 
47 /**
48  * @title Contracts that should not own Ether
49  * @author Remco Bloemen <remco@2π.com>
50  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
51  * in the contract, it will allow the owner to reclaim this ether.
52  * @notice Ether can still be sent to this contract by:
53  * calling functions labeled `payable`
54  * `selfdestruct(contract_address)`
55  * mining directly to the contract address
56  */
57 contract HasNoEther is Ownable {
58 
59   /**
60   * @dev Constructor that rejects incoming Ether
61   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
62   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
63   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
64   * we could use assembly to access msg.value.
65   */
66   function HasNoEther() public payable {
67     require(msg.value == 0);
68   }
69 
70   /**
71    * @dev Disallows direct send by settings a default function without the `payable` flag.
72    */
73   function() external {
74   }
75 
76   /**
77    * @dev Transfer all Ether held by the contract to the owner.
78    */
79   function reclaimEther() external onlyOwner {
80     // solium-disable-next-line security/no-send
81     assert(owner.send(address(this).balance));
82   }
83 }
84 
85 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
86 
87 /**
88  * @title ERC20Basic
89  * @dev Simpler version of ERC20 interface
90  * @dev see https://github.com/ethereum/EIPs/issues/179
91  */
92 contract ERC20Basic {
93   function totalSupply() public view returns (uint256);
94   function balanceOf(address who) public view returns (uint256);
95   function transfer(address to, uint256 value) public returns (bool);
96   event Transfer(address indexed from, address indexed to, uint256 value);
97 }
98 
99 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
100 
101 /**
102  * @title ERC20 interface
103  * @dev see https://github.com/ethereum/EIPs/issues/20
104  */
105 contract ERC20 is ERC20Basic {
106   function allowance(address owner, address spender) public view returns (uint256);
107   function transferFrom(address from, address to, uint256 value) public returns (bool);
108   function approve(address spender, uint256 value) public returns (bool);
109   event Approval(address indexed owner, address indexed spender, uint256 value);
110 }
111 
112 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
113 
114 /**
115  * @title SafeERC20
116  * @dev Wrappers around ERC20 operations that throw on failure.
117  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
118  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
119  */
120 library SafeERC20 {
121   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
122     assert(token.transfer(to, value));
123   }
124 
125   function safeTransferFrom(
126     ERC20 token,
127     address from,
128     address to,
129     uint256 value
130   )
131     internal
132   {
133     assert(token.transferFrom(from, to, value));
134   }
135 
136   function safeApprove(ERC20 token, address spender, uint256 value) internal {
137     assert(token.approve(spender, value));
138   }
139 }
140 
141 // File: openzeppelin-solidity/contracts/ownership/CanReclaimToken.sol
142 
143 /**
144  * @title Contracts that should be able to recover tokens
145  * @author SylTi
146  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
147  * This will prevent any accidental loss of tokens.
148  */
149 contract CanReclaimToken is Ownable {
150   using SafeERC20 for ERC20Basic;
151 
152   /**
153    * @dev Reclaim all ERC20Basic compatible tokens
154    * @param token ERC20Basic The address of the token contract
155    */
156   function reclaimToken(ERC20Basic token) external onlyOwner {
157     uint256 balance = token.balanceOf(this);
158     token.safeTransfer(owner, balance);
159   }
160 
161 }
162 
163 // File: openzeppelin-solidity/contracts/ownership/HasNoTokens.sol
164 
165 /**
166  * @title Contracts that should not own Tokens
167  * @author Remco Bloemen <remco@2π.com>
168  * @dev This blocks incoming ERC223 tokens to prevent accidental loss of tokens.
169  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
170  * owner to reclaim the tokens.
171  */
172 contract HasNoTokens is CanReclaimToken {
173 
174  /**
175   * @dev Reject all ERC223 compatible tokens
176   * @param from_ address The address that is transferring the tokens
177   * @param value_ uint256 the amount of the specified token
178   * @param data_ Bytes The data passed from the caller.
179   */
180   function tokenFallback(address from_, uint256 value_, bytes data_) external {
181     from_;
182     value_;
183     data_;
184     revert();
185   }
186 
187 }
188 
189 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
190 
191 /**
192  * @title SafeMath
193  * @dev Math operations with safety checks that throw on error
194  */
195 library SafeMath {
196 
197   /**
198   * @dev Multiplies two numbers, throws on overflow.
199   */
200   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
201     if (a == 0) {
202       return 0;
203     }
204     c = a * b;
205     assert(c / a == b);
206     return c;
207   }
208 
209   /**
210   * @dev Integer division of two numbers, truncating the quotient.
211   */
212   function div(uint256 a, uint256 b) internal pure returns (uint256) {
213     // assert(b > 0); // Solidity automatically throws when dividing by 0
214     // uint256 c = a / b;
215     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
216     return a / b;
217   }
218 
219   /**
220   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
221   */
222   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
223     assert(b <= a);
224     return a - b;
225   }
226 
227   /**
228   * @dev Adds two numbers, throws on overflow.
229   */
230   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
231     c = a + b;
232     assert(c >= a);
233     return c;
234   }
235 }
236 
237 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
238 
239 /**
240  * @title Basic token
241  * @dev Basic version of StandardToken, with no allowances.
242  */
243 contract BasicToken is ERC20Basic {
244   using SafeMath for uint256;
245 
246   mapping(address => uint256) balances;
247 
248   uint256 totalSupply_;
249 
250   /**
251   * @dev total number of tokens in existence
252   */
253   function totalSupply() public view returns (uint256) {
254     return totalSupply_;
255   }
256 
257   /**
258   * @dev transfer token for a specified address
259   * @param _to The address to transfer to.
260   * @param _value The amount to be transferred.
261   */
262   function transfer(address _to, uint256 _value) public returns (bool) {
263     require(_to != address(0));
264     require(_value <= balances[msg.sender]);
265 
266     balances[msg.sender] = balances[msg.sender].sub(_value);
267     balances[_to] = balances[_to].add(_value);
268     emit Transfer(msg.sender, _to, _value);
269     return true;
270   }
271 
272   /**
273   * @dev Gets the balance of the specified address.
274   * @param _owner The address to query the the balance of.
275   * @return An uint256 representing the amount owned by the passed address.
276   */
277   function balanceOf(address _owner) public view returns (uint256) {
278     return balances[_owner];
279   }
280 
281 }
282 
283 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
284 
285 /**
286  * @title Standard ERC20 token
287  *
288  * @dev Implementation of the basic standard token.
289  * @dev https://github.com/ethereum/EIPs/issues/20
290  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
291  */
292 contract StandardToken is ERC20, BasicToken {
293 
294   mapping (address => mapping (address => uint256)) internal allowed;
295 
296 
297   /**
298    * @dev Transfer tokens from one address to another
299    * @param _from address The address which you want to send tokens from
300    * @param _to address The address which you want to transfer to
301    * @param _value uint256 the amount of tokens to be transferred
302    */
303   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
304     require(_to != address(0));
305     require(_value <= balances[_from]);
306     require(_value <= allowed[_from][msg.sender]);
307 
308     balances[_from] = balances[_from].sub(_value);
309     balances[_to] = balances[_to].add(_value);
310     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
311     emit Transfer(_from, _to, _value);
312     return true;
313   }
314 
315   /**
316    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
317    *
318    * Beware that changing an allowance with this method brings the risk that someone may use both the old
319    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
320    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
321    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
322    * @param _spender The address which will spend the funds.
323    * @param _value The amount of tokens to be spent.
324    */
325   function approve(address _spender, uint256 _value) public returns (bool) {
326     allowed[msg.sender][_spender] = _value;
327     emit Approval(msg.sender, _spender, _value);
328     return true;
329   }
330 
331   /**
332    * @dev Function to check the amount of tokens that an owner allowed to a spender.
333    * @param _owner address The address which owns the funds.
334    * @param _spender address The address which will spend the funds.
335    * @return A uint256 specifying the amount of tokens still available for the spender.
336    */
337   function allowance(address _owner, address _spender) public view returns (uint256) {
338     return allowed[_owner][_spender];
339   }
340 
341   /**
342    * @dev Increase the amount of tokens that an owner allowed to a spender.
343    *
344    * approve should be called when allowed[_spender] == 0. To increment
345    * allowed value is better to use this function to avoid 2 calls (and wait until
346    * the first transaction is mined)
347    * From MonolithDAO Token.sol
348    * @param _spender The address which will spend the funds.
349    * @param _addedValue The amount of tokens to increase the allowance by.
350    */
351   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
352     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
353     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
354     return true;
355   }
356 
357   /**
358    * @dev Decrease the amount of tokens that an owner allowed to a spender.
359    *
360    * approve should be called when allowed[_spender] == 0. To decrement
361    * allowed value is better to use this function to avoid 2 calls (and wait until
362    * the first transaction is mined)
363    * From MonolithDAO Token.sol
364    * @param _spender The address which will spend the funds.
365    * @param _subtractedValue The amount of tokens to decrease the allowance by.
366    */
367   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
368     uint oldValue = allowed[msg.sender][_spender];
369     if (_subtractedValue > oldValue) {
370       allowed[msg.sender][_spender] = 0;
371     } else {
372       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
373     }
374     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
375     return true;
376   }
377 
378 }
379 
380 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
381 
382 /**
383  * @title Mintable token
384  * @dev Simple ERC20 Token example, with mintable token creation
385  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
386  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
387  */
388 contract MintableToken is StandardToken, Ownable {
389   event Mint(address indexed to, uint256 amount);
390   event MintFinished();
391 
392   bool public mintingFinished = false;
393 
394 
395   modifier canMint() {
396     require(!mintingFinished);
397     _;
398   }
399 
400   /**
401    * @dev Function to mint tokens
402    * @param _to The address that will receive the minted tokens.
403    * @param _amount The amount of tokens to mint.
404    * @return A boolean that indicates if the operation was successful.
405    */
406   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
407     totalSupply_ = totalSupply_.add(_amount);
408     balances[_to] = balances[_to].add(_amount);
409     emit Mint(_to, _amount);
410     emit Transfer(address(0), _to, _amount);
411     return true;
412   }
413 
414   /**
415    * @dev Function to stop minting new tokens.
416    * @return True if the operation was successful.
417    */
418   function finishMinting() onlyOwner canMint public returns (bool) {
419     mintingFinished = true;
420     emit MintFinished();
421     return true;
422   }
423 }
424 
425 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
426 
427 /**
428  * @title Pausable
429  * @dev Base contract which allows children to implement an emergency stop mechanism.
430  */
431 contract Pausable is Ownable {
432   event Pause();
433   event Unpause();
434 
435   bool public paused = false;
436 
437 
438   /**
439    * @dev Modifier to make a function callable only when the contract is not paused.
440    */
441   modifier whenNotPaused() {
442     require(!paused);
443     _;
444   }
445 
446   /**
447    * @dev Modifier to make a function callable only when the contract is paused.
448    */
449   modifier whenPaused() {
450     require(paused);
451     _;
452   }
453 
454   /**
455    * @dev called by the owner to pause, triggers stopped state
456    */
457   function pause() onlyOwner whenNotPaused public {
458     paused = true;
459     emit Pause();
460   }
461 
462   /**
463    * @dev called by the owner to unpause, returns to normal state
464    */
465   function unpause() onlyOwner whenPaused public {
466     paused = false;
467     emit Unpause();
468   }
469 }
470 
471 // File: openzeppelin-solidity/contracts/token/ERC20/PausableToken.sol
472 
473 /**
474  * @title Pausable token
475  * @dev StandardToken modified with pausable transfers.
476  **/
477 contract PausableToken is StandardToken, Pausable {
478 
479   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
480     return super.transfer(_to, _value);
481   }
482 
483   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
484     return super.transferFrom(_from, _to, _value);
485   }
486 
487   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
488     return super.approve(_spender, _value);
489   }
490 
491   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
492     return super.increaseApproval(_spender, _addedValue);
493   }
494 
495   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
496     return super.decreaseApproval(_spender, _subtractedValue);
497   }
498 }
499 
500 // File: contracts/EWOToken.sol
501 
502 contract EWOToken is MintableToken, PausableToken, HasNoEther, HasNoTokens {
503 
504   string public constant name = "EWO Token";
505   string public constant symbol = "EWO";
506   uint8 public constant decimals = 18;
507 }