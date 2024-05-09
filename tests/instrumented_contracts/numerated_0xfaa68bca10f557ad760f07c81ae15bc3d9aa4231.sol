1 pragma solidity ^0.4.19;
2 
3 // File: zeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return c;
31   }
32 
33   /**
34   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
52 
53 /**
54  * @title ERC20Basic
55  * @dev Simpler version of ERC20 interface
56  * @dev see https://github.com/ethereum/EIPs/issues/179
57  */
58 contract ERC20Basic {
59   function totalSupply() public view returns (uint256);
60   function balanceOf(address who) public view returns (uint256);
61   function transfer(address to, uint256 value) public returns (bool);
62   event Transfer(address indexed from, address indexed to, uint256 value);
63 }
64 
65 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
66 
67 /**
68  * @title Basic token
69  * @dev Basic version of StandardToken, with no allowances.
70  */
71 contract BasicToken is ERC20Basic {
72   using SafeMath for uint256;
73 
74   mapping(address => uint256) balances;
75 
76   uint256 totalSupply_;
77 
78   /**
79   * @dev total number of tokens in existence
80   */
81   function totalSupply() public view returns (uint256) {
82     return totalSupply_;
83   }
84 
85   /**
86   * @dev transfer token for a specified address
87   * @param _to The address to transfer to.
88   * @param _value The amount to be transferred.
89   */
90   function transfer(address _to, uint256 _value) public returns (bool) {
91     require(_to != address(0));
92     require(_value <= balances[msg.sender]);
93 
94     // SafeMath.sub will throw if there is not enough balance.
95     balances[msg.sender] = balances[msg.sender].sub(_value);
96     balances[_to] = balances[_to].add(_value);
97     Transfer(msg.sender, _to, _value);
98     return true;
99   }
100 
101   /**
102   * @dev Gets the balance of the specified address.
103   * @param _owner The address to query the the balance of.
104   * @return An uint256 representing the amount owned by the passed address.
105   */
106   function balanceOf(address _owner) public view returns (uint256 balance) {
107     return balances[_owner];
108   }
109 
110 }
111 
112 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
113 
114 /**
115  * @title ERC20 interface
116  * @dev see https://github.com/ethereum/EIPs/issues/20
117  */
118 contract ERC20 is ERC20Basic {
119   function allowance(address owner, address spender) public view returns (uint256);
120   function transferFrom(address from, address to, uint256 value) public returns (bool);
121   function approve(address spender, uint256 value) public returns (bool);
122   event Approval(address indexed owner, address indexed spender, uint256 value);
123 }
124 
125 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
126 
127 /**
128  * @title Standard ERC20 token
129  *
130  * @dev Implementation of the basic standard token.
131  * @dev https://github.com/ethereum/EIPs/issues/20
132  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
133  */
134 contract StandardToken is ERC20, BasicToken {
135 
136   mapping (address => mapping (address => uint256)) internal allowed;
137 
138 
139   /**
140    * @dev Transfer tokens from one address to another
141    * @param _from address The address which you want to send tokens from
142    * @param _to address The address which you want to transfer to
143    * @param _value uint256 the amount of tokens to be transferred
144    */
145   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
146     require(_to != address(0));
147     require(_value <= balances[_from]);
148     require(_value <= allowed[_from][msg.sender]);
149 
150     balances[_from] = balances[_from].sub(_value);
151     balances[_to] = balances[_to].add(_value);
152     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
153     Transfer(_from, _to, _value);
154     return true;
155   }
156 
157   /**
158    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
159    *
160    * Beware that changing an allowance with this method brings the risk that someone may use both the old
161    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
162    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
163    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
164    * @param _spender The address which will spend the funds.
165    * @param _value The amount of tokens to be spent.
166    */
167   function approve(address _spender, uint256 _value) public returns (bool) {
168     allowed[msg.sender][_spender] = _value;
169     Approval(msg.sender, _spender, _value);
170     return true;
171   }
172 
173   /**
174    * @dev Function to check the amount of tokens that an owner allowed to a spender.
175    * @param _owner address The address which owns the funds.
176    * @param _spender address The address which will spend the funds.
177    * @return A uint256 specifying the amount of tokens still available for the spender.
178    */
179   function allowance(address _owner, address _spender) public view returns (uint256) {
180     return allowed[_owner][_spender];
181   }
182 
183   /**
184    * @dev Increase the amount of tokens that an owner allowed to a spender.
185    *
186    * approve should be called when allowed[_spender] == 0. To increment
187    * allowed value is better to use this function to avoid 2 calls (and wait until
188    * the first transaction is mined)
189    * From MonolithDAO Token.sol
190    * @param _spender The address which will spend the funds.
191    * @param _addedValue The amount of tokens to increase the allowance by.
192    */
193   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
194     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
195     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
196     return true;
197   }
198 
199   /**
200    * @dev Decrease the amount of tokens that an owner allowed to a spender.
201    *
202    * approve should be called when allowed[_spender] == 0. To decrement
203    * allowed value is better to use this function to avoid 2 calls (and wait until
204    * the first transaction is mined)
205    * From MonolithDAO Token.sol
206    * @param _spender The address which will spend the funds.
207    * @param _subtractedValue The amount of tokens to decrease the allowance by.
208    */
209   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
210     uint oldValue = allowed[msg.sender][_spender];
211     if (_subtractedValue > oldValue) {
212       allowed[msg.sender][_spender] = 0;
213     } else {
214       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
215     }
216     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
217     return true;
218   }
219 
220 }
221 
222 // File: contracts/DisableSelfTransfer.sol
223 
224 contract DisableSelfTransfer is StandardToken {
225 
226   function transfer(address _to, uint256 _value) public returns (bool) {
227     require(_to != address(this));
228     return super.transfer(_to, _value);
229   }
230 
231   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
232     require(_to != address(this));
233     return super.transferFrom(_from, _to, _value);
234   }
235 
236 }
237 
238 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
239 
240 /**
241  * @title Ownable
242  * @dev The Ownable contract has an owner address, and provides basic authorization control
243  * functions, this simplifies the implementation of "user permissions".
244  */
245 contract Ownable {
246   address public owner;
247 
248 
249   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
250 
251 
252   /**
253    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
254    * account.
255    */
256   function Ownable() public {
257     owner = msg.sender;
258   }
259 
260   /**
261    * @dev Throws if called by any account other than the owner.
262    */
263   modifier onlyOwner() {
264     require(msg.sender == owner);
265     _;
266   }
267 
268   /**
269    * @dev Allows the current owner to transfer control of the contract to a newOwner.
270    * @param newOwner The address to transfer ownership to.
271    */
272   function transferOwnership(address newOwner) public onlyOwner {
273     require(newOwner != address(0));
274     OwnershipTransferred(owner, newOwner);
275     owner = newOwner;
276   }
277 
278 }
279 
280 // File: contracts/OwnerContract.sol
281 
282 contract OwnerContract is Ownable {
283   mapping (address => bool) internal contracts;
284 
285   // New modifier to be used in place of OWNER ONLY activity
286   // Eventually this will be owned by a controller contract and not a private wallet
287   // (Voting needs to be implemented)
288   modifier justOwner() {
289     require(msg.sender == owner);
290     _;
291   }
292 
293   // Allow contracts to have ownership without taking full custody of the token
294   // (Until voting is fully implemented)
295   modifier onlyOwner() {
296     if (msg.sender == address(0) || (msg.sender != owner && !contracts[msg.sender])) {
297       revert(); // error for uncontrolled request
298     }
299     _;
300   }
301 
302   // Stops owner from gaining access to all functionality
303   modifier onlyContract() {
304     require(msg.sender != address(0));
305     require(contracts[msg.sender]);
306     _;
307   }
308 
309   // new owner only activity.
310   // (Voting to be implemented for owner replacement)
311   function removeController(address controllerToRemove) public justOwner {
312     require(contracts[controllerToRemove]);
313     contracts[controllerToRemove] = false;
314   }
315   // new owner only activity.
316   // (Voting to be implemented for owner replacement)
317   function addController(address newController) public justOwner {
318     contracts[newController] = true;
319   }
320 
321 }
322 
323 // File: zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
324 
325 /**
326  * @title Burnable Token
327  * @dev Token that can be irreversibly burned (destroyed).
328  */
329 contract BurnableToken is BasicToken {
330 
331   event Burn(address indexed burner, uint256 value);
332 
333   /**
334    * @dev Burns a specific amount of tokens.
335    * @param _value The amount of token to be burned.
336    */
337   function burn(uint256 _value) public {
338     require(_value <= balances[msg.sender]);
339     // no need to require value <= totalSupply, since that would imply the
340     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
341 
342     address burner = msg.sender;
343     balances[burner] = balances[burner].sub(_value);
344     totalSupply_ = totalSupply_.sub(_value);
345     Burn(burner, _value);
346   }
347 }
348 
349 // File: zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
350 
351 /**
352  * @title Mintable token
353  * @dev Simple ERC20 Token example, with mintable token creation
354  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
355  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
356  */
357 contract MintableToken is StandardToken, Ownable {
358   event Mint(address indexed to, uint256 amount);
359   event MintFinished();
360 
361   bool public mintingFinished = false;
362 
363 
364   modifier canMint() {
365     require(!mintingFinished);
366     _;
367   }
368 
369   /**
370    * @dev Function to mint tokens
371    * @param _to The address that will receive the minted tokens.
372    * @param _amount The amount of tokens to mint.
373    * @return A boolean that indicates if the operation was successful.
374    */
375   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
376     totalSupply_ = totalSupply_.add(_amount);
377     balances[_to] = balances[_to].add(_amount);
378     Mint(_to, _amount);
379     Transfer(address(0), _to, _amount);
380     return true;
381   }
382 
383   /**
384    * @dev Function to stop minting new tokens.
385    * @return True if the operation was successful.
386    */
387   function finishMinting() onlyOwner canMint public returns (bool) {
388     mintingFinished = true;
389     MintFinished();
390     return true;
391   }
392 }
393 
394 // File: contracts/MintableContractOwnerToken.sol
395 
396 contract MintableContractOwnerToken is MintableToken, BurnableToken, OwnerContract, DisableSelfTransfer {
397 
398   bool burnAllowed = false;
399 
400   // Fired when an approved contract calls restartMint
401   event MintRestarted();
402   // Fired when a transfer is initiated from the contract rather than the owning wallet.
403   event ContractTransfer(address from, address to, uint value);
404 
405   // Fired when burning status changes
406   event BurningStateChange(bool canBurn);
407 
408   // opposite of canMint used for restarting the mint
409   modifier cantMint() {
410     require(mintingFinished);
411     _;
412   }
413 
414   // Require Burn to be turned on
415   modifier canBurn() {
416     require(burnAllowed);
417     _;
418   }
419 
420   // Require that burning is turned off
421   modifier cantBurn() {
422     require(!burnAllowed);
423     _;
424   }
425 
426   // Enable Burning Only if Burning is Off
427   function enableBurning() public onlyContract cantBurn {
428     burnAllowed = true;
429     BurningStateChange(burnAllowed);
430   }
431 
432   // Disable Burning Only if Burning is On
433   function disableBurning() public onlyContract canBurn {
434     burnAllowed = false;
435     BurningStateChange(burnAllowed);
436   }
437 
438   // Override parent burn function to provide canBurn limitation
439   function burn(uint256 _value) public canBurn {
440     super.burn(_value);
441   }
442 
443 
444   // Allow the contract to approve the mint restart
445   // (Voting will be essential in these actions)
446   function restartMinting() onlyContract cantMint public returns (bool) {
447     mintingFinished = false;
448     MintRestarted(); // Notify the blockchain that the coin minting was restarted
449     return true;
450   }
451 
452   // Allow owner or contract to finish minting.
453   function finishMinting() onlyOwner canMint public returns (bool) {
454     return super.finishMinting();
455   }
456 
457   // Allow the system to create transactions for transfers when appropriate.
458   // (e.g. upgrading the token for everyone, voting to recover accounts for lost private keys,
459   //    allowing the system to pay for transactions on someones behalf, allowing transaction automations)
460   // (Must be voted for on an approved contract to gain access to this function)
461   function contractTransfer(address _from, address _to, uint256 _value) public onlyContract returns (bool) {
462     require(_from != address(0));
463     require(_to != address(0));
464     require(_value > 0);
465     require(_value <= balances[_from]);
466 
467     balances[_from] = balances[_from].sub(_value);
468     balances[_to] = balances[_to].add(_value);
469     ContractTransfer(_from, _to, _value); // Notify blockchain the following transaction was contract initiated
470     Transfer(_from, _to, _value); // Call original transfer event to maintain compatibility with stardard transaction systems
471     return true;
472   }
473 
474 }
475 
476 // File: contracts/LazyCoderCoin.sol
477 
478 contract LazyCoderCoin is MintableContractOwnerToken {
479   string public name = "LazyCoder Coin";
480   string public symbol = "TLC";
481   uint8 public decimals = 18;
482 
483   function LazyCoderCoin() public {
484   }
485 
486 }