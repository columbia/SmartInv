1 pragma solidity ^0.4.18;
2 //this is just a basic ERC20 token implementation for testing
3 //this contract could be deployed as is but for now just serves as a mock for scratch token
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   /**
33   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 
48 }
49 
50 /////////////////////////////////////////////////////////////////////////////////////////////
51 
52 
53 
54 /**
55  * @title Ownable
56  * @dev The Ownable contract has an owner address, and provides basic authorization control
57  * functions, this simplifies the implementation of "user permissions".
58  */
59 contract Ownable {
60   address public owner;
61 
62 
63   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
64 
65 
66   /**
67    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
68    * account.
69    */
70   function Ownable() public {
71     owner = msg.sender;
72   }
73 
74   /**
75    * @dev Throws if called by any account other than the owner.
76    */
77   modifier onlyOwner() {
78     require(msg.sender == owner);
79     _;
80   }
81 
82   /**
83    * @dev Allows the current owner to transfer control of the contract to a newOwner.
84    * @param newOwner The address to transfer ownership to.
85    */
86   function transferContractOwnership(address newOwner) public onlyOwner {
87     require(newOwner != address(0));
88     emit OwnershipTransferred(owner, newOwner);
89     owner = newOwner;
90   }
91 
92 }
93 /////////////////////////////////////////////////////////////////////////////////////////////
94 /**
95  * @title Claimable
96  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
97  * This allows the new owner to accept the transfer.
98  */
99 contract Claimable is Ownable {
100   address public pendingOwner;
101 
102   /**
103    * @dev Modifier throws if called by any account other than the pendingOwner.
104    */
105   modifier onlyPendingOwner() {
106     require(msg.sender == pendingOwner);
107     _;
108   }
109 
110   /**
111    * @dev Allows the current owner to set the pendingOwner address.
112    * @param newOwner The address to transfer ownership to.
113    */
114   function transferOwnership(address newOwner) onlyOwner public {
115     pendingOwner = newOwner;
116   }
117 
118   /**
119    * @dev Allows the pendingOwner address to finalize the transfer.
120    */
121   function claimOwnership() onlyPendingOwner public {
122    emit OwnershipTransferred(owner, pendingOwner);
123     owner = pendingOwner;
124     pendingOwner = address(0);
125   }
126 }
127 
128 /////////////////////////////////////////////////////////////////////////////////////////////
129 /**
130  * @title Contracts that should be able to recover tokens
131  * @author SylTi
132  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
133  * This will prevent any accidental loss of tokens.
134  */
135 contract CanReclaimToken is Ownable {
136   using SafeERC20 for ERC20Basic;
137 
138   /**
139    * @dev Reclaim all ERC20Basic compatible tokens
140    * @param token ERC20Basic The address of the token contract
141    */
142   function reclaimToken(ERC20Basic token) external onlyOwner {
143     uint256 balance = token.balanceOf(this);
144     token.safeTransfer(owner, balance);
145   }
146 
147 }
148 
149 /////////////////////////////////////////////////////////////////////////////////////////////
150 /**
151  * @title Contactable token
152  * @dev Basic version of a contactable contract, allowing the owner to provide a string with their
153  * contact information.
154  */
155 contract Contactable is Ownable {
156 
157   string public contactInformation;
158 
159   /**
160     * @dev Allows the owner to set a string with their contact information.
161     * @param info The contact information to attach to the contract.
162     */
163   function setContactInformation(string info) onlyOwner public {
164     contactInformation = info;
165   }
166 }
167 /////////////////////////////////////////////////////////////////////////////////////////////
168 /**
169  * @title Contracts that should not own Contracts
170  * @author Remco Bloemen <remco@2π.com>
171  * @dev Should contracts (anything Ownable) end up being owned by this contract, it allows the owner
172  * of this contract to reclaim ownership of the contracts.
173  */
174 contract HasNoContracts is Ownable {
175 
176   /**
177    * @dev Reclaim ownership of Ownable contracts
178    * @param contractAddr The address of the Ownable to be reclaimed.
179    */
180   function reclaimContract(address contractAddr) external onlyOwner {
181     Ownable contractInst = Ownable(contractAddr);
182     contractInst.transferContractOwnership(owner);
183   }
184 }
185 /////////////////////////////////////////////////////////////////////////////////////////////
186 
187 /////////////////////////////////////////////////////////////////////////////////////////////
188 /**
189  * @title Contracts that should not own Tokens
190  * @author Remco Bloemen <remco@2π.com>
191  * @dev This blocks incoming ERC223 tokens to prevent accidental loss of tokens.
192  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
193  * owner to reclaim the tokens.
194  */
195 contract HasNoTokens is CanReclaimToken {
196 
197  /**
198   * @dev Reject all ERC223 compatible tokens
199   * @param from_ address The address that is transferring the tokens
200   * @param value_ uint256 the amount of the specified token
201   * @param data_ Bytes The data passed from the caller.
202   */
203   function tokenFallback(address from_, uint256 value_, bytes data_) pure external {
204     from_;
205     value_;
206     data_;
207     revert();
208   }
209 
210 }
211 /////////////////////////////////////////////////////////////////////////////////////////////
212 /**
213  * @title Destructible
214  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
215  */
216 contract Destructible is Ownable {
217 
218   function Destructible() public payable { }
219 
220   /**
221    * @dev Transfers the current balance to the owner and terminates the contract.
222    */
223   function destroy() onlyOwner public {
224     selfdestruct(owner);
225   }
226 
227   function destroyAndSend(address _recipient) onlyOwner public {
228     selfdestruct(_recipient);
229   }
230 }
231 /////////////////////////////////////////////////////////////////////////////////////////////
232 /**
233  * @title Pausable
234  * @dev Base contract which allows children to implement an emergency stop mechanism.
235  */
236 contract Pausable is Ownable {
237   event Pause();
238   event Unpause();
239 
240   bool public paused = false;
241 
242 
243   /**
244    * @dev Modifier to make a function callable only when the contract is not paused.
245    */
246   modifier whenNotPaused() {
247     require(!paused);
248     _;
249   }
250 
251   /**
252    * @dev Modifier to make a function callable only when the contract is paused.
253    */
254   modifier whenPaused() {
255     require(paused);
256     _;
257   }
258 
259   /**
260    * @dev called by the owner to pause, triggers stopped state
261    */
262   function pause() onlyOwner whenNotPaused public {
263     paused = true;
264     emit Pause();
265   }
266 
267   /**
268    * @dev called by the owner to unpause, returns to normal state
269    */
270   function unpause() onlyOwner whenPaused public {
271     paused = false;
272     emit Unpause();
273   }
274 }
275 /////////////////////////////////////////////////////////////////////////////////////////////
276 contract ERC20Basic {
277   string internal _symbol;
278   string internal _name;
279   uint8 internal _decimals;
280   uint internal _totalSupply;
281   mapping (address => uint) internal _balanceOf;
282 
283   mapping (address => mapping (address => uint)) internal _allowances;
284 
285   function ERC20Basic(string symbol, string name, uint8 decimals, uint totalSupply) public {
286       _symbol = symbol;
287       _name = name;
288       _decimals = decimals;
289       _totalSupply = totalSupply;
290   }
291 
292   function name() public constant returns (string) {
293       return _name;
294   }
295 
296   function symbol() public constant returns (string) {
297       return _symbol;
298   }
299 
300   function decimals() public constant returns (uint8) {
301       return _decimals;
302   }
303 
304   function totalSupply() public constant returns (uint) {
305       return _totalSupply;
306   }
307   function balanceOf(address _addr) public constant returns (uint);
308   function transfer(address _to, uint _value) public returns (bool);
309   event Transfer(address indexed _from, address indexed _to, uint _value);
310 }
311 /////////////////////////////////////////////////////////////////////////////////////////////
312 contract ERC20 is ERC20Basic {
313   function allowance(address owner, address spender) public view returns (uint256);
314   function transferFrom(address from, address to, uint256 value) public returns (bool);
315   function approve(address spender, uint256 value) public returns (bool);
316   event Approval(address indexed owner, address indexed spender, uint256 value);
317 }
318 /////////////////////////////////////////////////////////////////////////////////////////////
319 /**
320  * @title SafeERC20
321  * @dev Wrappers around ERC20 operations that throw on failure.
322  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
323  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
324  */
325 library SafeERC20 {
326   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
327     assert(token.transfer(to, value));
328   }
329 
330   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
331     assert(token.transferFrom(from, to, value));
332   }
333 
334   function safeApprove(ERC20 token, address spender, uint256 value) internal {
335     assert(token.approve(spender, value));
336   }
337 }
338 /////////////////////////////////////////////////////////////////////////////////////////////
339 /**
340  * @title Basic token
341  * @dev Basic version of StandardToken, with no allowances.
342  */
343 contract BasicToken is ERC20Basic, Ownable {
344   using SafeMath for uint256;
345 
346  mapping (address => bool) public frozenAccount;
347  event FrozenFunds(address target, bool frozen);
348 
349   uint256 totalSupply_;
350 
351   /**
352   * @dev total number of tokens in existence
353   */
354   function totalSupply() public view returns (uint256) {
355     return totalSupply_;
356   }
357 
358    function freezeAccount(address target, bool freeze) onlyOwner external {
359          frozenAccount[target] = freeze;
360          emit FrozenFunds(target, freeze);
361          }
362 
363   /**
364   * @dev transfer token for a specified address
365   * @param _to The address to transfer to.
366   * @param _value The amount to be transferred.
367   */
368   function transfer(address _to, uint256 _value) public returns (bool) {
369       require(!frozenAccount[msg.sender]);
370     require(_to != address(0));
371     require(_value <= _balanceOf[msg.sender]);
372 
373     // SafeMath.sub will throw if there is not enough balance.
374     _balanceOf[msg.sender] = _balanceOf[msg.sender].sub(_value);
375     _balanceOf[_to] = _balanceOf[_to].add(_value);
376     emit Transfer(msg.sender, _to, _value);
377     return true;
378   }
379 
380   /**
381   * @dev Gets the balance of the specified address.
382   * @param _owner The address to query the the balance of.
383   * @return An uint256 representing the amount owned by the passed address.
384   */
385   function balanceOf(address _owner) public view returns (uint256 balance) {
386     return _balanceOf[_owner];
387   }
388 
389 }
390 /////////////////////////////////////////////////////////////////////////////////////////////
391 /**
392  * @title Standard ERC20 token
393  *
394  * @dev Implementation of the basic standard token.
395  * @dev https://github.com/ethereum/EIPs/issues/20
396  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
397  */
398 contract StandardToken is ERC20, BasicToken {
399 
400   mapping (address => mapping (address => uint256)) internal allowed;
401 
402 
403   /**
404    * @dev Transfer tokens from one address to another
405    * @param _from address The address which you want to send tokens from
406    * @param _to address The address which you want to transfer to
407    * @param _value uint256 the amount of tokens to be transferred
408    */
409   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
410     require(!frozenAccount[_from] && !frozenAccount[_to] && !frozenAccount[msg.sender]);
411     require(_to != address(0));
412     require(_value <= _balanceOf[_from]);
413     require(_value <= allowed[_from][msg.sender]);
414 
415     _balanceOf[_from] = _balanceOf[_from].sub(_value);
416     _balanceOf[_to] = _balanceOf[_to].add(_value);
417     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
418     emit Transfer(_from, _to, _value);
419     return true;
420   }
421 
422   /**
423    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
424    *
425    * Beware that changing an allowance with this method brings the risk that someone may use both the old
426    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
427    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
428    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
429    * @param _spender The address which will spend the funds.
430    * @param _value The amount of tokens to be spent.
431    */
432   function approve(address _spender, uint256 _value) public returns (bool) {
433     allowed[msg.sender][_spender] = _value;
434     emit Approval(msg.sender, _spender, _value);
435     return true;
436   }
437 
438   /**
439    * @dev Function to check the amount of tokens that an owner allowed to a spender.
440    * @param _owner address The address which owns the funds.
441    * @param _spender address The address which will spend the funds.
442    * @return A uint256 specifying the amount of tokens still available for the spender.
443    */
444   function allowance(address _owner, address _spender) public view returns (uint256) {
445     return allowed[_owner][_spender];
446   }
447 
448   /**
449    * @dev Increase the amount of tokens that an owner allowed to a spender.
450    *
451    * approve should be called when allowed[_spender] == 0. To increment
452    * allowed value is better to use this function to avoid 2 calls (and wait until
453    * the first transaction is mined)
454    * From MonolithDAO Token.sol
455    * @param _spender The address which will spend the funds.
456    * @param _addedValue The amount of tokens to increase the allowance by.
457    */
458   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
459     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
460     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
461     return true;
462   }
463 
464   /**
465    * @dev Decrease the amount of tokens that an owner allowed to a spender.
466    *
467    * approve should be called when allowed[_spender] == 0. To decrement
468    * allowed value is better to use this function to avoid 2 calls (and wait until
469    * the first transaction is mined)
470    * From MonolithDAO Token.sol
471    * @param _spender The address which will spend the funds.
472    * @param _subtractedValue The amount of tokens to decrease the allowance by.
473    */
474   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
475     uint oldValue = allowed[msg.sender][_spender];
476     if (_subtractedValue > oldValue) {
477       allowed[msg.sender][_spender] = 0;
478     } else {
479       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
480     }
481     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
482     return true;
483   }
484 
485 }
486 /////////////////////////////////////////////////////////////////////////////////////////////
487 contract PausableToken is StandardToken, Pausable {
488 
489   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
490     return super.transfer(_to, _value);
491   }
492 
493   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
494     return super.transferFrom(_from, _to, _value);
495   }
496 
497   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
498     return super.approve(_spender, _value);
499   }
500 
501   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
502     return super.increaseApproval(_spender, _addedValue);
503   }
504 
505   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
506     return super.decreaseApproval(_spender, _subtractedValue);
507   }
508 }
509 /////////////////////////////////////////////////////////////////////////////////////////////
510 
511 contract Artis is ERC20Basic("ATS", "Artis", 18, 1000000000000000000000000000),  PausableToken, Destructible, Contactable, HasNoTokens, HasNoContracts {
512 
513     using SafeMath for uint;
514 
515     event Burn(address _from, uint256 _value);
516     event Mint(address _to, uint _value);
517 
518     constructor() public {
519       _balanceOf[msg.sender] = _totalSupply;
520     }
521 
522        function totalSupply() public view returns (uint) {
523            return _totalSupply;
524        }
525 
526        function balanceOf(address _addr) public view returns (uint) {
527            return _balanceOf[_addr];
528        }
529 
530        function burn(address _from, uint256 _value) onlyOwner external {
531         require(_balanceOf[_from] >= 0);
532         _balanceOf[_from] =  _balanceOf[_from].sub(_value);
533         _totalSupply = _totalSupply.sub(_value);
534         emit Burn(_from, _value);
535       }
536 
537 
538         function mintToken(address _to, uint256 _value) onlyOwner external  {
539           require(!frozenAccount[msg.sender] && !frozenAccount[_to]);
540          _balanceOf[_to] = _balanceOf[_to].add(_value);
541          _totalSupply = _totalSupply.add(_value);
542          emit Mint(_to,_value);
543        }
544 
545 
546 }