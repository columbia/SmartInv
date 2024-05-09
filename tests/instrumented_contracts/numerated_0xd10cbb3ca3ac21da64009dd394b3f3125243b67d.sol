1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title Ownable
51  * @dev The Ownable contract has an owner address, and provides basic authorization control
52  * functions, this simplifies the implementation of "user permissions".
53  */
54 contract Ownable {
55   address public owner;
56 
57 
58   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60 
61   /**
62    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
63    * account.
64    */
65   function Ownable() public {
66     owner = msg.sender;
67   }
68 
69   /**
70    * @dev Throws if called by any account other than the owner.
71    */
72   modifier onlyOwner() {
73     require(msg.sender == owner);
74     _;
75   }
76 
77   /**
78    * @dev Allows the current owner to transfer control of the contract to a newOwner.
79    * @param newOwner The address to transfer ownership to.
80    */
81   function transferOwnership(address newOwner) public onlyOwner {
82     require(newOwner != address(0));
83     OwnershipTransferred(owner, newOwner);
84     owner = newOwner;
85   }
86 
87 }
88 
89 /**
90  * @title Pausable
91  * @dev Base contract which allows children to implement an emergency stop mechanism.
92  */
93 contract Pausable is Ownable {
94   event Pause();
95   event Unpause();
96 
97   bool public paused = false;
98 
99 
100   /**
101    * @dev Modifier to make a function callable only when the contract is not paused.
102    */
103   modifier whenNotPaused() {
104     require(!paused);
105     _;
106   }
107 
108   /**
109    * @dev Modifier to make a function callable only when the contract is paused.
110    */
111   modifier whenPaused() {
112     require(paused);
113     _;
114   }
115 
116   /**
117    * @dev called by the owner to pause, triggers stopped state
118    */
119   function pause() onlyOwner whenNotPaused public {
120     paused = true;
121     Pause();
122   }
123 
124   /**
125    * @dev called by the owner to unpause, returns to normal state
126    */
127   function unpause() onlyOwner whenPaused public {
128     paused = false;
129     Unpause();
130   }
131 }
132 
133 /**
134  * @title Lockable
135  * @dev Base contract which allows children to lock and unlock the ability for addresses to make transfers
136  */
137 contract Lockable is Ownable {
138 
139   mapping (address => bool) public lockStates;   // map between addresses and their lock state.
140 
141   event Lock(address indexed accountAddress);
142   event Unlock(address indexed accountAddress);
143 
144 
145   /**
146    * @dev Modifier to make a function callable only when the account is in unlocked state
147    */
148   modifier whenNotLocked(address _address) {
149     require(!lockStates[_address]);
150     _;
151   }
152 
153   /**
154    * @dev Modifier to make a function callable only when the acount is in locked state
155    */
156   modifier whenLocked(address _address) {
157     require(lockStates[_address]);
158     _;
159   }
160 
161   /**
162    * @dev called by the owner to lock the ability for an address to make transfers
163    */
164   function lock(address _address) onlyOwner public {
165       lockWorker(_address);
166   }
167 
168   function lockMultiple(address[] _addresses) onlyOwner public {
169       for (uint i=0; i < _addresses.length; i++) {
170           lock(_addresses[i]);
171       }
172   }
173 
174   function lockWorker(address _address) internal {
175       require(_address != owner);
176       require(this != _address);
177 
178       lockStates[_address] = true;
179       Lock(_address);
180   }
181 
182   /**
183    * @dev called by the owner to unlock an address in order for it to be able to make transfers
184    */
185   function unlock(address _address) onlyOwner public {
186       unlockWorker(_address);
187   }
188 
189   function unlockMultiple(address[] _addresses) onlyOwner public {
190       for (uint i=0; i < _addresses.length; i++) {
191           unlock(_addresses[i]);
192       }
193   }
194 
195   function unlockWorker(address _address) internal {
196       lockStates[_address] = false;
197       Unlock(_address);
198   }
199 }
200 
201 contract ERC20Basic {
202   function totalSupply() public view returns (uint256);
203   function balanceOf(address who) public view returns (uint256);
204   function transfer(address to, uint256 value) public returns (bool);
205   event Transfer(address indexed from, address indexed to, uint256 value);
206 }
207 
208 contract ERC20 is ERC20Basic {
209   function allowance(address owner, address spender) public view returns (uint256);
210   function transferFrom(address from, address to, uint256 value) public returns (bool);
211   function approve(address spender, uint256 value) public returns (bool);
212   event Approval(address indexed owner, address indexed spender, uint256 value);
213 }
214 
215 /**
216  * @title Basic token
217  * @dev Basic version of StandardToken, with no allowances.
218  */
219 contract BasicToken is ERC20Basic, Ownable {
220   using SafeMath for uint256;
221 
222   mapping(address => uint256) balances;
223 
224   uint256 totalSupply_;
225 
226   /**
227   * @dev total number of tokens in existence
228   */
229   function totalSupply() public view returns (uint256) {
230     return totalSupply_;
231   }
232 
233   /**
234   * @dev transfer token for a specified address
235   * @param _to The address to transfer to.
236   * @param _value The amount to be transferred.
237   */
238   function transfer(address _to, uint256 _value) public returns (bool) {
239     require(_to != address(0));
240     require(_value <= balances[msg.sender]);
241 
242     // SafeMath.sub will throw if there is not enough balance.
243     balances[msg.sender] = balances[msg.sender].sub(_value);
244     balances[_to] = balances[_to].add(_value);
245     Transfer(msg.sender, _to, _value);
246     return true;
247   }
248 
249   /**
250   * @dev Gets the balance of the specified address.
251   * @param _owner The address to query the the balance of.
252   * @return An uint256 representing the amount owned by the passed address.
253   */
254   function balanceOf(address _owner) public view returns (uint256 balance) {
255     return balances[_owner];
256   }
257 }
258 
259 /**
260  * @title Burnable Token
261  * @dev Token that can be irreversibly burned (destroyed).
262  */
263 contract BurnableToken is BasicToken {
264 
265   event Burn(address indexed burner, uint256 value);
266 
267   /**
268    * @dev Burns a specific amount of tokens.
269    * @param _value The amount of token to be burned.
270    */
271   function burn(uint256 _value) public {
272     require(_value <= balances[msg.sender]);
273     // no need to require value <= totalSupply, since that would imply the
274     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
275 
276     address burner = msg.sender;
277     balances[burner] = balances[burner].sub(_value);
278     totalSupply_ = totalSupply_.sub(_value);
279     Burn(burner, _value);
280   }
281 }
282 
283 /**
284  * @title Standard ERC20 token
285  *
286  * @dev Implementation of the basic standard token.
287  * @dev https://github.com/ethereum/EIPs/issues/20
288  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
289  */
290 contract StandardToken is ERC20, BasicToken {
291 
292   mapping (address => mapping (address => uint256)) internal allowed;
293 
294 
295   /**
296    * @dev Transfer tokens from one address to another
297    * @param _from address The address which you want to send tokens from
298    * @param _to address The address which you want to transfer to
299    * @param _value uint256 the amount of tokens to be transferred
300    */
301   function transferFrom(address _from, address _to, uint256 _value)  public returns (bool) {
302     require(_to != address(0));
303     require(_value <= balances[_from]);
304     require(_value <= allowed[_from][msg.sender]);
305 
306     balances[_from] = balances[_from].sub(_value);
307     balances[_to] = balances[_to].add(_value);
308     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
309     Transfer(_from, _to, _value);
310     return true;
311   }
312 
313   /**
314    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
315    *
316    * Beware that changing an allowance with this method brings the risk that someone may use both the old
317    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
318    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
319    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
320    * @param _spender The address which will spend the funds.
321    * @param _value The amount of tokens to be spent.
322    */
323   function approve(address _spender, uint256 _value) public returns  (bool) {
324     allowed[msg.sender][_spender] = _value;
325     Approval(msg.sender, _spender, _value);
326     return true;
327   }
328 
329   /**
330    * @dev Function to check the amount of tokens that an owner allowed to a spender.
331    * @param _owner address The address which owns the funds.
332    * @param _spender address The address which will spend the funds.
333    * @return A uint256 specifying the amount of tokens still available for the spender.
334    */
335   function allowance(address _owner, address _spender) public view returns (uint256) {
336     return allowed[_owner][_spender];
337   }
338 
339   /**
340    * @dev Increase the amount of tokens that an owner allowed to a spender.
341    *
342    * approve should be called when allowed[_spender] == 0. To increment
343    * allowed value is better to use this function to avoid 2 calls (and wait until
344    * the first transaction is mined)
345    * From MonolithDAO Token.sol
346    * @param _spender The address which will spend the funds.
347    * @param _addedValue The amount of tokens to increase the allowance by.
348    */
349   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
350     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
351     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
352     return true;
353   }
354 
355   /**
356    * @dev Decrease the amount of tokens that an owner allowed to a spender.
357    *
358    * approve should be called when allowed[_spender] == 0. To decrement
359    * allowed value is better to use this function to avoid 2 calls (and wait until
360    * the first transaction is mined)
361    * From MonolithDAO Token.sol
362    * @param _spender The address which will spend the funds.
363    * @param _subtractedValue The amount of tokens to decrease the allowance by.
364    */
365   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
366     uint oldValue = allowed[msg.sender][_spender];
367     if (_subtractedValue > oldValue) {
368       allowed[msg.sender][_spender] = 0;
369     } else {
370       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
371     }
372     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
373     return true;
374   }
375 
376 }
377 
378 /**
379  * @title Pausable token
380  * @dev StandardToken modified with pausable transfers.
381  **/
382 contract PausableToken is StandardToken, Pausable {
383 
384   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
385     return super.transfer(_to, _value);
386   }
387 
388   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
389     return super.transferFrom(_from, _to, _value);
390   }
391 
392   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
393     return super.approve(_spender, _value);
394   }
395 
396   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
397     return super.increaseApproval(_spender, _addedValue);
398   }
399 
400   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
401     return super.decreaseApproval(_spender, _subtractedValue);
402   }
403 }
404 
405 /*
406   ERC20 TAB Token smart contract implementation
407 */
408 contract TabToken is PausableToken, Lockable {
409 
410   event Burn(address indexed burner, uint256 value);
411   event EtherReceived(address indexed sender, uint256 weiAmount);
412   event EtherSent(address indexed receiver, uint256 weiAmount);
413   event EtherAddressChanged(address indexed previousAddress, address newAddress);
414 
415   
416   string public constant name = "Accounting Blockchain Token";
417   string public constant symbol = "TAB";
418   uint8 public constant decimals = 18;
419 
420 
421   address internal _etherAddress = 0x90CD914C827a12703D485E9E5fA69977E3ea866B;
422 
423   //This is already exposed from BasicToken.sol as part of the standard
424   uint256 internal constant INITIAL_SUPPLY = 22000000000000000000000000000;
425 
426   /**
427    * @dev Constructor that gives msg.sender all of existing tokens.
428    */
429   function TabToken() public {
430     totalSupply_ = INITIAL_SUPPLY;
431 
432     //Give all initial supply to the contract.
433     balances[this] = INITIAL_SUPPLY;
434     Transfer(0x0, this, INITIAL_SUPPLY);
435 
436     //From now onwards, we MUST always use transfer functions
437   }
438 
439   //Fallback function - just revert any payments
440   function () payable public {
441     revert();
442   }
443 
444   //Function which allows us to fund the contract with ether
445   function fund() payable public onlyOwner {
446     require(msg.sender != 0x0);
447     require(msg.value > 0);
448 
449     EtherReceived(msg.sender, msg.value);
450   }
451 
452   //Function which allows sending ether from contract to the hard wallet address
453   function sendEther() payable public onlyOwner {
454     require(msg.value > 0);
455     assert(_etherAddress != address(0));     //This should never happen
456 
457     EtherSent(_etherAddress, msg.value);
458     _etherAddress.transfer(msg.value);
459   }
460 
461   //Get the total wei in contract
462   function totalBalance() view public returns (uint256) {
463     return this.balance;
464   }
465   
466   function transferFromContract(address[] _addresses, uint256[] _values) public onlyOwner returns (bool) {
467     require(_addresses.length == _values.length);
468     
469     for (uint i=0; i < _addresses.length; i++) {
470       require(_addresses[i] != address(0));
471       require(_values[i] <= balances[this]);
472 
473       // SafeMath.sub will throw if there is not enough balance.
474       balances[this] = balances[this].sub(_values[i]);
475       balances[_addresses[i]] = balances[_addresses[i]].add(_values[i]);
476       Transfer(msg.sender, _addresses[i], _values[i]);
477 
478     }
479     
480     return true;
481   }
482 
483   function remainingSupply() public view returns(uint256) {
484     return balances[this];
485   }
486 
487   /**
488    * @dev Burns a specific amount of tokens from the contract
489    * @param amount The amount of token to be burned.
490    */
491   function burnFromContract(uint256 amount) public onlyOwner {
492     require(amount <= balances[this]);
493     // no need to require value <= totalSupply, since that would imply the
494     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
495 
496     address burner = this;
497     balances[burner] = balances[burner].sub(amount);
498     totalSupply_ = totalSupply_.sub(amount);
499     Burn(burner, amount);
500   } 
501 
502   function etherAddress() public view onlyOwner returns(address) {
503     return _etherAddress;
504   }
505 
506   //Function which enables owner to change address which is storing the ether
507   function setEtherAddress(address newAddress) public onlyOwner {
508     require(newAddress != address(0));
509     EtherAddressChanged(_etherAddress, newAddress);
510     _etherAddress = newAddress;
511   }
512 }