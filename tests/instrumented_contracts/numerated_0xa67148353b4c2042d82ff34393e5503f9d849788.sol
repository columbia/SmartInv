1 pragma solidity ^0.4.23;
2 
3 // © Bulleon. All Rights Reserved
4 // https://bulleon.io
5 // Contact: info@bulleon.io
6 
7 /**
8  * @title ERC20Basic
9  * @dev Simpler version of ERC20 interface
10  * @dev see https://github.com/ethereum/EIPs/issues/179
11  */
12 contract ERC20Basic {
13   function totalSupply() public view returns (uint256);
14   function balanceOf(address who) public view returns (uint256);
15   function transfer(address to, uint256 value) public returns (bool);
16   event Transfer(address indexed from, address indexed to, uint256 value);
17 }
18 
19 
20 
21 /**
22  * @title Ownable
23  * @dev The Ownable contract has an owner address, and provides basic authorization control
24  * functions, this simplifies the implementation of "user permissions".
25  */
26 contract Ownable {
27   address public owner;
28 
29 
30   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
31 
32 
33   /**
34    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
35    * account.
36    */
37   constructor() public {
38     owner = msg.sender;
39   }
40 
41   /**
42    * @dev Throws if called by any account other than the owner.
43    */
44   modifier onlyOwner() {
45     require(msg.sender == owner);
46     _;
47   }
48 
49   /**
50    * @dev Allows the current owner to transfer control of the contract to a newOwner.
51    * @param newOwner The address to transfer ownership to.
52    */
53   function transferOwnership(address newOwner) public onlyOwner {
54     require(newOwner != address(0));
55     emit OwnershipTransferred(owner, newOwner);
56     owner = newOwner;
57   }
58 
59 }
60 
61 /**
62  * @title SafeMath
63  * @dev Math operations with safety checks that throw on error
64  */
65 library SafeMath {
66 
67   /**
68   * @dev Multiplies two numbers, throws on overflow.
69   */
70   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
71     if (a == 0) {
72       return 0;
73     }
74     c = a * b;
75     assert(c / a == b);
76     return c;
77   }
78 
79   /**
80   * @dev Integer division of two numbers, truncating the quotient.
81   */
82   function div(uint256 a, uint256 b) internal pure returns (uint256) {
83     // assert(b > 0); // Solidity automatically throws when dividing by 0
84     // uint256 c = a / b;
85     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
86     return a / b;
87   }
88 
89   /**
90   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
91   */
92   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
93     assert(b <= a);
94     return a - b;
95   }
96 
97   /**
98   * @dev Adds two numbers, throws on overflow.
99   */
100   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
101     c = a + b;
102     assert(c >= a);
103     return c;
104   }
105 }
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
134     balances[msg.sender] = balances[msg.sender].sub(_value);
135     balances[_to] = balances[_to].add(_value);
136     emit Transfer(msg.sender, _to, _value);
137     return true;
138   }
139 
140   /**
141   * @dev Gets the balance of the specified address.
142   * @param _owner The address to query the the balance of.
143   * @return An uint256 representing the amount owned by the passed address.
144   */
145   function balanceOf(address _owner) public view returns (uint256) {
146     return balances[_owner];
147   }
148 
149 }
150 
151 /**
152  * @title Burnable Token
153  * @dev Token that can be irreversibly burned (destroyed).
154  */
155 contract BurnableToken is BasicToken {
156 
157   event Burn(address indexed burner, uint256 value);
158 
159   /**
160    * @dev Burns a specific amount of tokens.
161    * @param _value The amount of token to be burned.
162    */
163   function burn(uint256 _value) public {
164     _burn(msg.sender, _value);
165   }
166 
167   function _burn(address _who, uint256 _value) internal {
168     require(_value <= balances[_who]);
169     // no need to require value <= totalSupply, since that would imply the
170     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
171 
172     balances[_who] = balances[_who].sub(_value);
173     totalSupply_ = totalSupply_.sub(_value);
174     emit Burn(_who, _value);
175     emit Transfer(_who, address(0), _value);
176   }
177 }
178 
179 /**
180  * @title ERC20 interface
181  * @dev see https://github.com/ethereum/EIPs/issues/20
182  */
183 contract ERC20 is ERC20Basic {
184   function allowance(address owner, address spender) public view returns (uint256);
185   function transferFrom(address from, address to, uint256 value) public returns (bool);
186   function approve(address spender, uint256 value) public returns (bool);
187   event Approval(address indexed owner, address indexed spender, uint256 value);
188 }
189 
190 /**
191  * @title Standard ERC20 token
192  *
193  * @dev Implementation of the basic standard token.
194  * @dev https://github.com/ethereum/EIPs/issues/20
195  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
196  */
197 contract StandardToken is ERC20, BasicToken {
198 
199   mapping (address => mapping (address => uint256)) internal allowed;
200 
201 
202   /**
203    * @dev Transfer tokens from one address to another
204    * @param _from address The address which you want to send tokens from
205    * @param _to address The address which you want to transfer to
206    * @param _value uint256 the amount of tokens to be transferred
207    */
208   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
209     require(_to != address(0));
210     require(_value <= balances[_from]);
211     require(_value <= allowed[_from][msg.sender]);
212 
213     balances[_from] = balances[_from].sub(_value);
214     balances[_to] = balances[_to].add(_value);
215     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
216     emit Transfer(_from, _to, _value);
217     return true;
218   }
219 
220   /**
221    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
222    *
223    * Beware that changing an allowance with this method brings the risk that someone may use both the old
224    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
225    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
226    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
227    * @param _spender The address which will spend the funds.
228    * @param _value The amount of tokens to be spent.
229    */
230   function approve(address _spender, uint256 _value) public returns (bool) {
231     allowed[msg.sender][_spender] = _value;
232     emit Approval(msg.sender, _spender, _value);
233     return true;
234   }
235 
236   /**
237    * @dev Function to check the amount of tokens that an owner allowed to a spender.
238    * @param _owner address The address which owns the funds.
239    * @param _spender address The address which will spend the funds.
240    * @return A uint256 specifying the amount of tokens still available for the spender.
241    */
242   function allowance(address _owner, address _spender) public view returns (uint256) {
243     return allowed[_owner][_spender];
244   }
245 
246   /**
247    * @dev Increase the amount of tokens that an owner allowed to a spender.
248    *
249    * approve should be called when allowed[_spender] == 0. To increment
250    * allowed value is better to use this function to avoid 2 calls (and wait until
251    * the first transaction is mined)
252    * From MonolithDAO Token.sol
253    * @param _spender The address which will spend the funds.
254    * @param _addedValue The amount of tokens to increase the allowance by.
255    */
256   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
257     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
258     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
259     return true;
260   }
261 
262   /**
263    * @dev Decrease the amount of tokens that an owner allowed to a spender.
264    *
265    * approve should be called when allowed[_spender] == 0. To decrement
266    * allowed value is better to use this function to avoid 2 calls (and wait until
267    * the first transaction is mined)
268    * From MonolithDAO Token.sol
269    * @param _spender The address which will spend the funds.
270    * @param _subtractedValue The amount of tokens to decrease the allowance by.
271    */
272   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
273     uint oldValue = allowed[msg.sender][_spender];
274     if (_subtractedValue > oldValue) {
275       allowed[msg.sender][_spender] = 0;
276     } else {
277       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
278     }
279     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
280     return true;
281   }
282 
283 }
284 
285 
286 /**
287  * @title Standard Burnable Token
288  * @dev Adds burnFrom method to ERC20 implementations
289  */
290 contract StandardBurnableToken is BurnableToken, StandardToken {
291 
292   /**
293    * @dev Burns a specific amount of tokens from the target address and decrements allowance
294    * @param _from address The address which you want to send tokens from
295    * @param _value uint256 The amount of token to be burned
296    */
297   function burnFrom(address _from, uint256 _value) public {
298     require(_value <= allowed[_from][msg.sender]);
299     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
300     // this function needs to emit an event with the updated approval.
301     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
302     _burn(_from, _value);
303   }
304 }
305 
306 /**
307  * @title Pausable
308  * @dev Base contract which allows children to implement an emergency stop mechanism.
309  */
310 contract Pausable is Ownable {
311   event Pause();
312   event Unpause();
313 
314   bool public paused = false;
315 
316 
317   /**
318    * @dev Modifier to make a function callable only when the contract is not paused.
319    */
320   modifier whenNotPaused() {
321     require(!paused);
322     _;
323   }
324 
325   /**
326    * @dev Modifier to make a function callable only when the contract is paused.
327    */
328   modifier whenPaused() {
329     require(paused);
330     _;
331   }
332 
333   /**
334    * @dev called by the owner to pause, triggers stopped state
335    */
336   function pause() onlyOwner whenNotPaused public {
337     paused = true;
338     emit Pause();
339   }
340 
341   /**
342    * @dev called by the owner to unpause, returns to normal state
343    */
344   function unpause() onlyOwner whenPaused public {
345     paused = false;
346     emit Unpause();
347   }
348 }
349 
350 /**
351  * @title Pausable token
352  * @dev StandardToken modified with pausable transfers.
353  **/
354 contract PausableToken is StandardToken, Pausable {
355 
356   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
357     return super.transfer(_to, _value);
358   }
359 
360   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
361     return super.transferFrom(_from, _to, _value);
362   }
363 
364   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
365     return super.approve(_spender, _value);
366   }
367 
368   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
369     return super.increaseApproval(_spender, _addedValue);
370   }
371 
372   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
373     return super.decreaseApproval(_spender, _subtractedValue);
374   }
375 }
376 
377 /**
378  * @title Claimable
379  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
380  * This allows the new owner to accept the transfer.
381  */
382 contract Claimable is Ownable {
383   address public pendingOwner;
384 
385   /**
386    * @dev Modifier throws if called by any account other than the pendingOwner.
387    */
388   modifier onlyPendingOwner() {
389     require(msg.sender == pendingOwner);
390     _;
391   }
392 
393   /**
394    * @dev Allows the current owner to set the pendingOwner address.
395    * @param newOwner The address to transfer ownership to.
396    */
397   function transferOwnership(address newOwner) onlyOwner public {
398     pendingOwner = newOwner;
399   }
400 
401   /**
402    * @dev Allows the pendingOwner address to finalize the transfer.
403    */
404   function claimOwnership() onlyPendingOwner public {
405     emit OwnershipTransferred(owner, pendingOwner);
406     owner = pendingOwner;
407     pendingOwner = address(0);
408   }
409 }
410 
411 interface CrowdsaleContract {
412   function isActive() public view returns(bool);
413 }
414 
415 contract BulleonToken is StandardBurnableToken, PausableToken, Claimable {
416   /* Additional events */
417   event AddedToWhitelist(address wallet);
418   event RemoveWhitelist(address wallet);
419 
420   /* Base params */
421   string public constant name = "Bulleon"; /* solium-disable-line uppercase */
422   string public constant symbol = "BUL"; /* solium-disable-line uppercase */
423   uint8 public constant decimals = 18; /* solium-disable-line uppercase */
424   uint256 constant exchangersBalance = 39991750231582759746295 + 14715165984103328399573 + 1846107707643607869274; // YoBit + Etherdelta + IDEX
425 
426   /* Premine and start balance settings */
427   address constant premineWallet = 0x286BE9799488cA4543399c2ec964e7184077711C;
428   uint256 constant premineAmount = 178420 * (10 ** uint256(decimals));
429 
430   /* Additional params */
431   address public CrowdsaleAddress;
432   CrowdsaleContract crowdsale;
433   mapping(address=>bool) whitelist; // Users that may transfer tokens before ICO ended
434 
435   /**
436    * @dev Constructor that gives msg.sender all availabel of existing tokens.
437    */
438   constructor() public {
439     totalSupply_ = 7970000 * (10 ** uint256(decimals));
440     balances[msg.sender] = totalSupply_;
441     transfer(premineWallet, premineAmount.add(exchangersBalance));
442 
443     addToWhitelist(msg.sender);
444     addToWhitelist(premineWallet);
445     paused = true; // Lock token at start
446   }
447 
448   /**
449    * @dev Sets crowdsale contract address (used for checking ICO status)
450    */
451   function setCrowdsaleAddress(address _ico) public onlyOwner {
452     CrowdsaleAddress = _ico;
453     crowdsale = CrowdsaleContract(CrowdsaleAddress);
454     addToWhitelist(CrowdsaleAddress);
455   }
456 
457   /**
458    * @dev called by user the to pause, triggers stopped state
459    * not actualy used
460    */
461   function pause() onlyOwner whenNotPaused public {
462     revert();
463   }
464 
465   /**
466    * @dev Modifier to make a function callable only when the contract is not paused or when sender is whitelisted.
467    */
468   modifier whenNotPaused() {
469     require(!paused || whitelist[msg.sender]);
470     _;
471   }
472 
473   /**
474    * @dev called by the user to unpause at ICO end or by owner, returns token to unlocked state
475    */
476   function unpause() whenPaused public {
477     require(!crowdsale.isActive() || msg.sender == owner); // Checks that ICO is ended
478     paused = false;
479     emit Unpause();
480   }
481 
482   /**
483    * @dev Add wallet address to transfer whitelist (may transfer tokens before ICO ended)
484    */
485   function addToWhitelist(address wallet) public onlyOwner {
486     require(!whitelist[wallet]);
487     whitelist[wallet] = true;
488     emit AddedToWhitelist(wallet);
489   }
490 
491   /**
492    * @dev Delete wallet address to transfer whitelist (may transfer tokens before ICO ended)
493    */
494   function delWhitelist(address wallet) public onlyOwner {
495     require(whitelist[wallet]);
496     whitelist[wallet] = false;
497     emit RemoveWhitelist(wallet);
498   }
499 }