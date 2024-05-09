1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() public {
21     owner = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) public onlyOwner {
37     require(newOwner != address(0));
38     OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 
42 }
43 
44 
45 /**
46  * @title SafeMath
47  * @dev Math operations with safety checks that throw on error
48  */
49 library SafeMath {
50 
51   /**
52   * @dev Multiplies two numbers, throws on overflow.
53   */
54   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
55     if (a == 0) {
56       return 0;
57     }
58     uint256 c = a * b;
59     assert(c / a == b);
60     return c;
61   }
62 
63   /**
64   * @dev Integer division of two numbers, truncating the quotient.
65   */
66   function div(uint256 a, uint256 b) internal pure returns (uint256) {
67     // assert(b > 0); // Solidity automatically throws when dividing by 0
68     uint256 c = a / b;
69     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70     return c;
71   }
72 
73   /**
74   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
75   */
76   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
77     assert(b <= a);
78     return a - b;
79   }
80 
81   /**
82   * @dev Adds two numbers, throws on overflow.
83   */
84   function add(uint256 a, uint256 b) internal pure returns (uint256) {
85     uint256 c = a + b;
86     assert(c >= a);
87     return c;
88   }
89 }
90 
91 
92 /**
93  * @title ERC20Basic
94  * @dev Simpler version of ERC20 interface
95  * @dev see https://github.com/ethereum/EIPs/issues/179
96  */
97 contract ERC20Basic {
98   function totalSupply() public view returns (uint256);
99   function balanceOf(address who) public view returns (uint256);
100   function transfer(address to, uint256 value) public returns (bool);
101   event Transfer(address indexed from, address indexed to, uint256 value);
102 }
103 
104 
105 
106 
107 /**
108  * @title Basic token
109  * @dev Basic version of StandardToken, with no allowances.
110  */
111 contract BasicToken is ERC20Basic {
112   using SafeMath for uint256;
113 
114   mapping(address => uint256) balances;
115 
116   uint256 totalSupply_;
117 
118   /**
119   * @dev total number of tokens in existence
120   */
121   function totalSupply() public view returns (uint256) {
122     return totalSupply_;
123   }
124 
125   /**
126   * @dev transfer token for a specified address
127   * @param _to The address to transfer to.
128   * @param _value The amount to be transferred.
129   */
130   function transfer(address _to, uint256 _value) public returns (bool) {
131     require(_to != address(0));
132     require(_value <= balances[msg.sender]);
133 
134     // SafeMath.sub will throw if there is not enough balance.
135     balances[msg.sender] = balances[msg.sender].sub(_value);
136     balances[_to] = balances[_to].add(_value);
137     Transfer(msg.sender, _to, _value);
138     return true;
139   }
140 
141   /**
142   * @dev Gets the balance of the specified address.
143   * @param _owner The address to query the the balance of.
144   * @return An uint256 representing the amount owned by the passed address.
145   */
146   function balanceOf(address _owner) public view returns (uint256 balance) {
147     return balances[_owner];
148   }
149 
150 }
151 
152 
153 
154 /**
155  * @title ERC20 interface
156  * @dev see https://github.com/ethereum/EIPs/issues/20
157  */
158 contract ERC20 is ERC20Basic {
159   function allowance(address owner, address spender) public view returns (uint256);
160   function transferFrom(address from, address to, uint256 value) public returns (bool);
161   function approve(address spender, uint256 value) public returns (bool);
162   event Approval(address indexed owner, address indexed spender, uint256 value);
163 }
164 
165 
166 
167 /**
168  * @title Standard ERC20 token
169  *
170  * @dev Implementation of the basic standard token.
171  * @dev https://github.com/ethereum/EIPs/issues/20
172  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
173  */
174 contract StandardToken is ERC20, BasicToken {
175 
176   mapping (address => mapping (address => uint256)) internal allowed;
177 
178 
179   /**
180    * @dev Transfer tokens from one address to another
181    * @param _from address The address which you want to send tokens from
182    * @param _to address The address which you want to transfer to
183    * @param _value uint256 the amount of tokens to be transferred
184    */
185   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
186     require(_to != address(0));
187     require(_value <= balances[_from]);
188     require(_value <= allowed[_from][msg.sender]);
189 
190     balances[_from] = balances[_from].sub(_value);
191     balances[_to] = balances[_to].add(_value);
192     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
193     Transfer(_from, _to, _value);
194     return true;
195   }
196 
197   /**
198    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
199    *
200    * Beware that changing an allowance with this method brings the risk that someone may use both the old
201    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
202    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
203    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
204    * @param _spender The address which will spend the funds.
205    * @param _value The amount of tokens to be spent.
206    */
207   function approve(address _spender, uint256 _value) public returns (bool) {
208     allowed[msg.sender][_spender] = _value;
209     Approval(msg.sender, _spender, _value);
210     return true;
211   }
212 
213   /**
214    * @dev Function to check the amount of tokens that an owner allowed to a spender.
215    * @param _owner address The address which owns the funds.
216    * @param _spender address The address which will spend the funds.
217    * @return A uint256 specifying the amount of tokens still available for the spender.
218    */
219   function allowance(address _owner, address _spender) public view returns (uint256) {
220     return allowed[_owner][_spender];
221   }
222 
223   /**
224    * @dev Increase the amount of tokens that an owner allowed to a spender.
225    *
226    * approve should be called when allowed[_spender] == 0. To increment
227    * allowed value is better to use this function to avoid 2 calls (and wait until
228    * the first transaction is mined)
229    * From MonolithDAO Token.sol
230    * @param _spender The address which will spend the funds.
231    * @param _addedValue The amount of tokens to increase the allowance by.
232    */
233   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
234     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
235     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
236     return true;
237   }
238 
239   /**
240    * @dev Decrease the amount of tokens that an owner allowed to a spender.
241    *
242    * approve should be called when allowed[_spender] == 0. To decrement
243    * allowed value is better to use this function to avoid 2 calls (and wait until
244    * the first transaction is mined)
245    * From MonolithDAO Token.sol
246    * @param _spender The address which will spend the funds.
247    * @param _subtractedValue The amount of tokens to decrease the allowance by.
248    */
249   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
250     uint oldValue = allowed[msg.sender][_spender];
251     if (_subtractedValue > oldValue) {
252       allowed[msg.sender][_spender] = 0;
253     } else {
254       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
255     }
256     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
257     return true;
258   }
259 
260 }
261 
262 
263 
264 /**
265  * @title Mintable token
266  * @dev Simple ERC20 Token example, with mintable token creation
267  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
268  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
269  */
270 contract MintableToken is StandardToken, Ownable {
271   event Mint(address indexed to, uint256 amount);
272   event MintFinished();
273 
274   bool public mintingFinished = false;
275 
276 
277   modifier canMint() {
278     require(!mintingFinished);
279     _;
280   }
281 
282   /**
283    * @dev Function to mint tokens
284    * @param _to The address that will receive the minted tokens.
285    * @param _amount The amount of tokens to mint.
286    * @return A boolean that indicates if the operation was successful.
287    */
288   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
289     totalSupply_ = totalSupply_.add(_amount);
290     balances[_to] = balances[_to].add(_amount);
291     Mint(_to, _amount);
292     Transfer(address(0), _to, _amount);
293     return true;
294   }
295 
296   /**
297    * @dev Function to stop minting new tokens.
298    * @return True if the operation was successful.
299    */
300   function finishMinting() onlyOwner canMint public returns (bool) {
301     mintingFinished = true;
302     MintFinished();
303     return true;
304   }
305 }
306 
307 
308 
309 /**
310  * @title Pausable
311  * @dev Base contract which allows children to implement an emergency stop mechanism.
312  */
313 contract Pausable is Ownable {
314   event Pause();
315   event Unpause();
316 
317   bool public paused = false;
318 
319 
320   /**
321    * @dev Modifier to make a function callable only when the contract is not paused.
322    */
323   modifier whenNotPaused() {
324     require(!paused);
325     _;
326   }
327 
328   /**
329    * @dev Modifier to make a function callable only when the contract is paused.
330    */
331   modifier whenPaused() {
332     require(paused);
333     _;
334   }
335 
336   /**
337    * @dev called by the owner to pause, triggers stopped state
338    */
339   function pause() onlyOwner whenNotPaused public {
340     paused = true;
341     Pause();
342   }
343 
344   /**
345    * @dev called by the owner to unpause, returns to normal state
346    */
347   function unpause() onlyOwner whenPaused public {
348     paused = false;
349     Unpause();
350   }
351 }
352 
353 
354 
355 
356 /**
357  * @title Destructible
358  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
359  */
360 contract Destructible is Ownable {
361 
362   function Destructible() public payable { }
363 
364   /**
365    * @dev Transfers the current balance to the owner and terminates the contract.
366    */
367   function destroy() onlyOwner public {
368     selfdestruct(owner);
369   }
370 
371   function destroyAndSend(address _recipient) onlyOwner public {
372     selfdestruct(_recipient);
373   }
374 }
375 
376 
377 
378 /**
379  * @title MintableMasterToken token
380  * @dev Simple ERC20 Token example, with mintable token creation
381  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
382  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
383  */
384 
385 contract MintableMasterToken is MintableToken {
386     event MintMasterTransferred(address indexed previousMaster, address indexed newMaster);
387     address public mintMaster;
388 
389     modifier onlyMintMasterOrOwner() {
390         require(msg.sender == mintMaster || msg.sender == owner);
391         _;
392     }
393     function MintableMasterToken() {
394         mintMaster = msg.sender;
395     }
396 
397     function transferMintMaster(address newMaster) onlyOwner public {
398         require(newMaster != address(0));
399         MintMasterTransferred(mintMaster, newMaster);
400         mintMaster = newMaster;
401     }
402 
403     /**
404      * @dev Function to mint tokens
405      * @param _to The address that will receive the minted tokens.
406      * @param _amount The amount of tokens to mint.
407      * @return A boolean that indicates if the operation was successful.
408      */
409     function mint(address _to, uint256 _amount) onlyMintMasterOrOwner canMint public returns (bool) {
410         address oldOwner = owner;
411         owner = msg.sender;
412 
413         bool result = super.mint(_to, _amount);
414 
415         owner = oldOwner;
416 
417         return result;
418     }
419 
420 }
421 
422 
423 
424 /**
425  * @title Pausable token
426  * @dev StandardToken modified with pausable transfers.
427  **/
428 contract PausableToken is StandardToken, Pausable {
429 
430   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
431     return super.transfer(_to, _value);
432   }
433 
434   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
435     return super.transferFrom(_from, _to, _value);
436   }
437 
438   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
439     return super.approve(_spender, _value);
440   }
441 
442   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
443     return super.increaseApproval(_spender, _addedValue);
444   }
445 
446   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
447     return super.decreaseApproval(_spender, _subtractedValue);
448   }
449 }
450 
451 
452 
453 /**
454 * @dev Pre main BoutsPro token ERC20 contract
455 * Based on references from OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity
456 */
457 contract BTSPToken is MintableMasterToken, PausableToken {
458     
459     // Metadata
460     string public constant symbol = "BOUTS";
461     string public constant name = "BoutsPro";
462     uint8 public constant decimals = 18;
463     string public constant version = "1.0";
464 
465     function mintToAddresses(address[] addresses, uint256 amount) public onlyMintMasterOrOwner canMint {
466         for (uint i = 0; i < addresses.length; i++) {
467             require(mint(addresses[i], amount));
468         }
469     }
470 
471     function mintToAddressesAndAmounts(address[] addresses, uint256[] amounts) public onlyMintMasterOrOwner canMint {
472         require(addresses.length == amounts.length);
473         for (uint i = 0; i < addresses.length; i++) {
474             require(mint(addresses[i], amounts[i]));
475         }
476     }
477 
478     /**
479     * @dev Override MintableTokenn.finishMinting() to add canMint modifier
480     */
481     function finishMinting() onlyOwner canMint public returns(bool) {
482         return super.finishMinting();
483     }
484 
485 }
486 
487 
488 
489 /**
490 * @dev Main BoutsPro PreBOU token ERC20 contract
491 * Based on references from OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity
492 */
493 contract PreBOUToken is BTSPToken, Destructible {
494 
495     // Metadata
496     string public constant symbol = "BOUTS";
497     string public constant name = "BoutsPro";
498     uint8 public constant decimals = 18;
499     string public constant version = "1.0";
500 
501     // Overrided destructor
502     function destroy() public onlyOwner {
503         require(mintingFinished);
504         super.destroy();
505     }
506 
507     // Overrided destructor companion
508     function destroyAndSend(address _recipient) public onlyOwner {
509         require(mintingFinished);
510         super.destroyAndSend(_recipient);
511     }
512 
513 }