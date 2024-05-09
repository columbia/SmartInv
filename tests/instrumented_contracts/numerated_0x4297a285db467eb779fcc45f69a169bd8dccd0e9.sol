1 //File: node_modules/zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
2 pragma solidity ^0.4.18;
3 
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 //File: node_modules/zeppelin-solidity/contracts/math/SafeMath.sol
18 pragma solidity ^0.4.18;
19 
20 
21 /**
22  * @title SafeMath
23  * @dev Math operations with safety checks that throw on error
24  */
25 library SafeMath {
26 
27   /**
28   * @dev Multiplies two numbers, throws on overflow.
29   */
30   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
31     if (a == 0) {
32       return 0;
33     }
34     uint256 c = a * b;
35     assert(c / a == b);
36     return c;
37   }
38 
39   /**
40   * @dev Integer division of two numbers, truncating the quotient.
41   */
42   function div(uint256 a, uint256 b) internal pure returns (uint256) {
43     // assert(b > 0); // Solidity automatically throws when dividing by 0
44     uint256 c = a / b;
45     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
46     return c;
47   }
48 
49   /**
50   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
51   */
52   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
53     assert(b <= a);
54     return a - b;
55   }
56 
57   /**
58   * @dev Adds two numbers, throws on overflow.
59   */
60   function add(uint256 a, uint256 b) internal pure returns (uint256) {
61     uint256 c = a + b;
62     assert(c >= a);
63     return c;
64   }
65 }
66 
67 //File: node_modules/zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
68 pragma solidity ^0.4.18;
69 
70 
71 
72 
73 
74 
75 /**
76  * @title Basic token
77  * @dev Basic version of StandardToken, with no allowances.
78  */
79 contract BasicToken is ERC20Basic {
80   using SafeMath for uint256;
81 
82   mapping(address => uint256) balances;
83 
84   uint256 totalSupply_;
85 
86   /**
87   * @dev total number of tokens in existence
88   */
89   function totalSupply() public view returns (uint256) {
90     return totalSupply_;
91   }
92 
93   /**
94   * @dev transfer token for a specified address
95   * @param _to The address to transfer to.
96   * @param _value The amount to be transferred.
97   */
98   function transfer(address _to, uint256 _value) public returns (bool) {
99     require(_to != address(0));
100     require(_value <= balances[msg.sender]);
101 
102     // SafeMath.sub will throw if there is not enough balance.
103     balances[msg.sender] = balances[msg.sender].sub(_value);
104     balances[_to] = balances[_to].add(_value);
105     Transfer(msg.sender, _to, _value);
106     return true;
107   }
108 
109   /**
110   * @dev Gets the balance of the specified address.
111   * @param _owner The address to query the the balance of.
112   * @return An uint256 representing the amount owned by the passed address.
113   */
114   function balanceOf(address _owner) public view returns (uint256 balance) {
115     return balances[_owner];
116   }
117 
118 }
119 
120 //File: node_modules/zeppelin-solidity/contracts/token/ERC20/ERC20.sol
121 pragma solidity ^0.4.18;
122 
123 
124 
125 
126 /**
127  * @title ERC20 interface
128  * @dev see https://github.com/ethereum/EIPs/issues/20
129  */
130 contract ERC20 is ERC20Basic {
131   function allowance(address owner, address spender) public view returns (uint256);
132   function transferFrom(address from, address to, uint256 value) public returns (bool);
133   function approve(address spender, uint256 value) public returns (bool);
134   event Approval(address indexed owner, address indexed spender, uint256 value);
135 }
136 
137 //File: node_modules/zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
138 pragma solidity ^0.4.18;
139 
140 
141 
142 
143 
144 /**
145  * @title Standard ERC20 token
146  *
147  * @dev Implementation of the basic standard token.
148  * @dev https://github.com/ethereum/EIPs/issues/20
149  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
150  */
151 contract StandardToken is ERC20, BasicToken {
152 
153   mapping (address => mapping (address => uint256)) internal allowed;
154 
155 
156   /**
157    * @dev Transfer tokens from one address to another
158    * @param _from address The address which you want to send tokens from
159    * @param _to address The address which you want to transfer to
160    * @param _value uint256 the amount of tokens to be transferred
161    */
162   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
163     require(_to != address(0));
164     require(_value <= balances[_from]);
165     require(_value <= allowed[_from][msg.sender]);
166 
167     balances[_from] = balances[_from].sub(_value);
168     balances[_to] = balances[_to].add(_value);
169     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
170     Transfer(_from, _to, _value);
171     return true;
172   }
173 
174   /**
175    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
176    *
177    * Beware that changing an allowance with this method brings the risk that someone may use both the old
178    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
179    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
180    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
181    * @param _spender The address which will spend the funds.
182    * @param _value The amount of tokens to be spent.
183    */
184   function approve(address _spender, uint256 _value) public returns (bool) {
185     allowed[msg.sender][_spender] = _value;
186     Approval(msg.sender, _spender, _value);
187     return true;
188   }
189 
190   /**
191    * @dev Function to check the amount of tokens that an owner allowed to a spender.
192    * @param _owner address The address which owns the funds.
193    * @param _spender address The address which will spend the funds.
194    * @return A uint256 specifying the amount of tokens still available for the spender.
195    */
196   function allowance(address _owner, address _spender) public view returns (uint256) {
197     return allowed[_owner][_spender];
198   }
199 
200   /**
201    * @dev Increase the amount of tokens that an owner allowed to a spender.
202    *
203    * approve should be called when allowed[_spender] == 0. To increment
204    * allowed value is better to use this function to avoid 2 calls (and wait until
205    * the first transaction is mined)
206    * From MonolithDAO Token.sol
207    * @param _spender The address which will spend the funds.
208    * @param _addedValue The amount of tokens to increase the allowance by.
209    */
210   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
211     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
212     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
213     return true;
214   }
215 
216   /**
217    * @dev Decrease the amount of tokens that an owner allowed to a spender.
218    *
219    * approve should be called when allowed[_spender] == 0. To decrement
220    * allowed value is better to use this function to avoid 2 calls (and wait until
221    * the first transaction is mined)
222    * From MonolithDAO Token.sol
223    * @param _spender The address which will spend the funds.
224    * @param _subtractedValue The amount of tokens to decrease the allowance by.
225    */
226   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
227     uint oldValue = allowed[msg.sender][_spender];
228     if (_subtractedValue > oldValue) {
229       allowed[msg.sender][_spender] = 0;
230     } else {
231       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
232     }
233     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
234     return true;
235   }
236 
237 }
238 
239 //File: node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol
240 pragma solidity ^0.4.18;
241 
242 
243 /**
244  * @title Ownable
245  * @dev The Ownable contract has an owner address, and provides basic authorization control
246  * functions, this simplifies the implementation of "user permissions".
247  */
248 contract Ownable {
249   address public owner;
250 
251 
252   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
253 
254 
255   /**
256    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
257    * account.
258    */
259   function Ownable() public {
260     owner = msg.sender;
261   }
262 
263   /**
264    * @dev Throws if called by any account other than the owner.
265    */
266   modifier onlyOwner() {
267     require(msg.sender == owner);
268     _;
269   }
270 
271   /**
272    * @dev Allows the current owner to transfer control of the contract to a newOwner.
273    * @param newOwner The address to transfer ownership to.
274    */
275   function transferOwnership(address newOwner) public onlyOwner {
276     require(newOwner != address(0));
277     OwnershipTransferred(owner, newOwner);
278     owner = newOwner;
279   }
280 
281 }
282 
283 //File: node_modules/zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
284 pragma solidity ^0.4.18;
285 
286 
287 
288 
289 
290 /**
291  * @title Mintable token
292  * @dev Simple ERC20 Token example, with mintable token creation
293  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
294  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
295  */
296 contract MintableToken is StandardToken, Ownable {
297   event Mint(address indexed to, uint256 amount);
298   event MintFinished();
299 
300   bool public mintingFinished = false;
301 
302 
303   modifier canMint() {
304     require(!mintingFinished);
305     _;
306   }
307 
308   /**
309    * @dev Function to mint tokens
310    * @param _to The address that will receive the minted tokens.
311    * @param _amount The amount of tokens to mint.
312    * @return A boolean that indicates if the operation was successful.
313    */
314   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
315     totalSupply_ = totalSupply_.add(_amount);
316     balances[_to] = balances[_to].add(_amount);
317     Mint(_to, _amount);
318     Transfer(address(0), _to, _amount);
319     return true;
320   }
321 
322   /**
323    * @dev Function to stop minting new tokens.
324    * @return True if the operation was successful.
325    */
326   function finishMinting() onlyOwner canMint public returns (bool) {
327     mintingFinished = true;
328     MintFinished();
329     return true;
330   }
331 }
332 
333 //File: node_modules/zeppelin-solidity/contracts/lifecycle/Pausable.sol
334 pragma solidity ^0.4.18;
335 
336 
337 
338 
339 
340 /**
341  * @title Pausable
342  * @dev Base contract which allows children to implement an emergency stop mechanism.
343  */
344 contract Pausable is Ownable {
345   event Pause();
346   event Unpause();
347 
348   bool public paused = false;
349 
350 
351   /**
352    * @dev Modifier to make a function callable only when the contract is not paused.
353    */
354   modifier whenNotPaused() {
355     require(!paused);
356     _;
357   }
358 
359   /**
360    * @dev Modifier to make a function callable only when the contract is paused.
361    */
362   modifier whenPaused() {
363     require(paused);
364     _;
365   }
366 
367   /**
368    * @dev called by the owner to pause, triggers stopped state
369    */
370   function pause() onlyOwner whenNotPaused public {
371     paused = true;
372     Pause();
373   }
374 
375   /**
376    * @dev called by the owner to unpause, returns to normal state
377    */
378   function unpause() onlyOwner whenPaused public {
379     paused = false;
380     Unpause();
381   }
382 }
383 
384 //File: node_modules/zeppelin-solidity/contracts/token/ERC20/PausableToken.sol
385 pragma solidity ^0.4.18;
386 
387 
388 
389 
390 
391 /**
392  * @title Pausable token
393  * @dev StandardToken modified with pausable transfers.
394  **/
395 contract PausableToken is StandardToken, Pausable {
396 
397   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
398     return super.transfer(_to, _value);
399   }
400 
401   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
402     return super.transferFrom(_from, _to, _value);
403   }
404 
405   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
406     return super.approve(_spender, _value);
407   }
408 
409   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
410     return super.increaseApproval(_spender, _addedValue);
411   }
412 
413   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
414     return super.decreaseApproval(_spender, _subtractedValue);
415   }
416 }
417 
418 //File: node_modules/zeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
419 pragma solidity ^0.4.18;
420 
421 
422 
423 
424 
425 /**
426  * @title SafeERC20
427  * @dev Wrappers around ERC20 operations that throw on failure.
428  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
429  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
430  */
431 library SafeERC20 {
432   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
433     assert(token.transfer(to, value));
434   }
435 
436   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
437     assert(token.transferFrom(from, to, value));
438   }
439 
440   function safeApprove(ERC20 token, address spender, uint256 value) internal {
441     assert(token.approve(spender, value));
442   }
443 }
444 
445 //File: node_modules/zeppelin-solidity/contracts/ownership/CanReclaimToken.sol
446 pragma solidity ^0.4.18;
447 
448 
449 
450 
451 
452 
453 /**
454  * @title Contracts that should be able to recover tokens
455  * @author SylTi
456  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
457  * This will prevent any accidental loss of tokens.
458  */
459 contract CanReclaimToken is Ownable {
460   using SafeERC20 for ERC20Basic;
461 
462   /**
463    * @dev Reclaim all ERC20Basic compatible tokens
464    * @param token ERC20Basic The address of the token contract
465    */
466   function reclaimToken(ERC20Basic token) external onlyOwner {
467     uint256 balance = token.balanceOf(this);
468     token.safeTransfer(owner, balance);
469   }
470 
471 }
472 
473 //File: src/contracts/ico/UacToken.sol
474 /**
475  * @title Ubiatar Coin token
476  *
477  * @version 1.0
478  * @author Validity Labs AG <info@validitylabs.org>
479  */
480 pragma solidity ^0.4.19;
481 
482 
483 
484 
485 
486 contract UacToken is CanReclaimToken, MintableToken, PausableToken {
487     string public constant name = "Ubiatar Coin";
488     string public constant symbol = "UAC";
489     uint8 public constant decimals = 18;
490 
491     /**
492      * @dev Constructor of UacToken that instantiates a new Mintable Pausable Token
493      */
494     function UacToken() public {
495         // token should not be transferrable until after all tokens have been issued
496         paused = true;
497     }
498 }