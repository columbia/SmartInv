1 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
2 
3 pragma solidity ^0.4.21;
4 
5 
6 /**
7  * @title ERC20Basic
8  * @dev Simpler version of ERC20 interface
9  * @dev see https://github.com/ethereum/EIPs/issues/179
10  */
11 contract ERC20Basic {
12   function totalSupply() public view returns (uint256);
13   function balanceOf(address who) public view returns (uint256);
14   function transfer(address to, uint256 value) public returns (bool);
15   event Transfer(address indexed from, address indexed to, uint256 value);
16 }
17 
18 // File: zeppelin-solidity/contracts/math/SafeMath.sol
19 
20 pragma solidity ^0.4.21;
21 
22 
23 /**
24  * @title SafeMath
25  * @dev Math operations with safety checks that throw on error
26  */
27 library SafeMath {
28 
29   /**
30   * @dev Multiplies two numbers, throws on overflow.
31   */
32   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
33     if (a == 0) {
34       return 0;
35     }
36     c = a * b;
37     assert(c / a == b);
38     return c;
39   }
40 
41   /**
42   * @dev Integer division of two numbers, truncating the quotient.
43   */
44   function div(uint256 a, uint256 b) internal pure returns (uint256) {
45     // assert(b > 0); // Solidity automatically throws when dividing by 0
46     // uint256 c = a / b;
47     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
48     return a / b;
49   }
50 
51   /**
52   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
53   */
54   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55     assert(b <= a);
56     return a - b;
57   }
58 
59   /**
60   * @dev Adds two numbers, throws on overflow.
61   */
62   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
63     c = a + b;
64     assert(c >= a);
65     return c;
66   }
67 }
68 
69 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
70 
71 pragma solidity ^0.4.21;
72 
73 
74 
75 
76 /**
77  * @title Basic token
78  * @dev Basic version of StandardToken, with no allowances.
79  */
80 contract BasicToken is ERC20Basic {
81   using SafeMath for uint256;
82 
83   mapping(address => uint256) balances;
84 
85   uint256 totalSupply_;
86 
87   /**
88   * @dev total number of tokens in existence
89   */
90   function totalSupply() public view returns (uint256) {
91     return totalSupply_;
92   }
93 
94   /**
95   * @dev transfer token for a specified address
96   * @param _to The address to transfer to.
97   * @param _value The amount to be transferred.
98   */
99   function transfer(address _to, uint256 _value) public returns (bool) {
100     require(_to != address(0));
101     require(_value <= balances[msg.sender]);
102 
103     balances[msg.sender] = balances[msg.sender].sub(_value);
104     balances[_to] = balances[_to].add(_value);
105     emit Transfer(msg.sender, _to, _value);
106     return true;
107   }
108 
109   /**
110   * @dev Gets the balance of the specified address.
111   * @param _owner The address to query the the balance of.
112   * @return An uint256 representing the amount owned by the passed address.
113   */
114   function balanceOf(address _owner) public view returns (uint256) {
115     return balances[_owner];
116   }
117 
118 }
119 
120 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
121 
122 pragma solidity ^0.4.21;
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
137 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
138 
139 pragma solidity ^0.4.21;
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
170     emit Transfer(_from, _to, _value);
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
186     emit Approval(msg.sender, _spender, _value);
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
212     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
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
233     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
234     return true;
235   }
236 
237 }
238 
239 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
240 
241 pragma solidity ^0.4.21;
242 
243 
244 /**
245  * @title Ownable
246  * @dev The Ownable contract has an owner address, and provides basic authorization control
247  * functions, this simplifies the implementation of "user permissions".
248  */
249 contract Ownable {
250   address public owner;
251 
252 
253   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
254 
255 
256   /**
257    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
258    * account.
259    */
260   function Ownable() public {
261     owner = msg.sender;
262   }
263 
264   /**
265    * @dev Throws if called by any account other than the owner.
266    */
267   modifier onlyOwner() {
268     require(msg.sender == owner);
269     _;
270   }
271 
272   /**
273    * @dev Allows the current owner to transfer control of the contract to a newOwner.
274    * @param newOwner The address to transfer ownership to.
275    */
276   function transferOwnership(address newOwner) public onlyOwner {
277     require(newOwner != address(0));
278     emit OwnershipTransferred(owner, newOwner);
279     owner = newOwner;
280   }
281 
282 }
283 
284 // File: zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
285 
286 pragma solidity ^0.4.21;
287 
288 
289 
290 
291 /**
292  * @title Mintable token
293  * @dev Simple ERC20 Token example, with mintable token creation
294  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
295  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
296  */
297 contract MintableToken is StandardToken, Ownable {
298   event Mint(address indexed to, uint256 amount);
299   event MintFinished();
300 
301   bool public mintingFinished = false;
302 
303 
304   modifier canMint() {
305     require(!mintingFinished);
306     _;
307   }
308 
309   /**
310    * @dev Function to mint tokens
311    * @param _to The address that will receive the minted tokens.
312    * @param _amount The amount of tokens to mint.
313    * @return A boolean that indicates if the operation was successful.
314    */
315   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
316     totalSupply_ = totalSupply_.add(_amount);
317     balances[_to] = balances[_to].add(_amount);
318     emit Mint(_to, _amount);
319     emit Transfer(address(0), _to, _amount);
320     return true;
321   }
322 
323   /**
324    * @dev Function to stop minting new tokens.
325    * @return True if the operation was successful.
326    */
327   function finishMinting() onlyOwner canMint public returns (bool) {
328     mintingFinished = true;
329     emit MintFinished();
330     return true;
331   }
332 }
333 
334 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
335 
336 pragma solidity ^0.4.21;
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
372     emit Pause();
373   }
374 
375   /**
376    * @dev called by the owner to unpause, returns to normal state
377    */
378   function unpause() onlyOwner whenPaused public {
379     paused = false;
380     emit Unpause();
381   }
382 }
383 
384 // File: zeppelin-solidity/contracts/token/ERC20/PausableToken.sol
385 
386 pragma solidity ^0.4.21;
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
418 // File: zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
419 
420 pragma solidity ^0.4.21;
421 
422 
423 
424 /**
425  * @title Burnable Token
426  * @dev Token that can be irreversibly burned (destroyed).
427  */
428 contract BurnableToken is BasicToken {
429 
430   event Burn(address indexed burner, uint256 value);
431 
432   /**
433    * @dev Burns a specific amount of tokens.
434    * @param _value The amount of token to be burned.
435    */
436   function burn(uint256 _value) public {
437     _burn(msg.sender, _value);
438   }
439 
440   function _burn(address _who, uint256 _value) internal {
441     require(_value <= balances[_who]);
442     // no need to require value <= totalSupply, since that would imply the
443     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
444 
445     balances[_who] = balances[_who].sub(_value);
446     totalSupply_ = totalSupply_.sub(_value);
447     emit Burn(_who, _value);
448     emit Transfer(_who, address(0), _value);
449   }
450 }
451 
452 // File: contracts/Token/ICOToken.sol
453 
454 pragma solidity ^0.4.23;
455 
456 
457 
458 
459 
460 /**
461  * @title ICOToken
462  * @dev Very simple ERC20 Token example.
463  * `StandardToken` functions.
464  */
465 contract ICOToken is MintableToken, PausableToken, BurnableToken {
466 
467     string public constant name = "Mycro Token";
468     string public constant symbol = "MYO";
469     uint8 public constant decimals = 18;
470 
471 
472     /**
473      * @dev Constructor that gives msg.sender all of existing tokens.
474      */
475     constructor() public {
476     }
477 }