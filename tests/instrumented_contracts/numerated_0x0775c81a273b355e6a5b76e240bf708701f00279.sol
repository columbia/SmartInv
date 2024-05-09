1 // © Bulleon. All Rights Reserved
2 // https://bulleon.io
3 // Contact: info@bulleon.io
4 
5 pragma solidity ^0.4.21;
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
19 /**
20  * @title ERC20 interface
21  * @dev see https://github.com/ethereum/EIPs/issues/20
22  */
23 contract ERC20 is ERC20Basic {
24   function allowance(address owner, address spender) public view returns (uint256);
25   function transferFrom(address from, address to, uint256 value) public returns (bool);
26   function approve(address spender, uint256 value) public returns (bool);
27   event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 /**
31  * @title SafeERC20
32  * @dev Wrappers around ERC20 operations that throw on failure.
33  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
34  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
35  */
36 library SafeERC20 {
37   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
38     assert(token.transfer(to, value));
39   }
40 
41   function safeTransferFrom(
42     ERC20 token,
43     address from,
44     address to,
45     uint256 value
46   )
47     internal
48   {
49     assert(token.transferFrom(from, to, value));
50   }
51 
52   function safeApprove(ERC20 token, address spender, uint256 value) internal {
53     assert(token.approve(spender, value));
54   }
55 }
56 
57 /**
58  * @title Ownable
59  * @dev The Ownable contract has an owner address, and provides basic authorization control
60  * functions, this simplifies the implementation of "user permissions".
61  */
62 contract Ownable {
63   address public owner;
64 
65 
66   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
67 
68 
69   /**
70    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
71    * account.
72    */
73   constructor() public {
74     owner = msg.sender;
75   }
76 
77   /**
78    * @dev Throws if called by any account other than the owner.
79    */
80   modifier onlyOwner() {
81     require(msg.sender == owner);
82     _;
83   }
84 
85   /**
86    * @dev Allows the current owner to transfer control of the contract to a newOwner.
87    * @param newOwner The address to transfer ownership to.
88    */
89   function transferOwnership(address newOwner) public onlyOwner {
90     require(newOwner != address(0));
91     emit OwnershipTransferred(owner, newOwner);
92     owner = newOwner;
93   }
94 
95 }
96 
97 /**
98  * @title SafeMath
99  * @dev Math operations with safety checks that throw on error
100  */
101 library SafeMath {
102 
103   /**
104   * @dev Multiplies two numbers, throws on overflow.
105   */
106   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
107     if (a == 0) {
108       return 0;
109     }
110     c = a * b;
111     assert(c / a == b);
112     return c;
113   }
114 
115   /**
116   * @dev Integer division of two numbers, truncating the quotient.
117   */
118   function div(uint256 a, uint256 b) internal pure returns (uint256) {
119     // assert(b > 0); // Solidity automatically throws when dividing by 0
120     // uint256 c = a / b;
121     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
122     return a / b;
123   }
124 
125   /**
126   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
127   */
128   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
129     assert(b <= a);
130     return a - b;
131   }
132 
133   /**
134   * @dev Adds two numbers, throws on overflow.
135   */
136   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
137     c = a + b;
138     assert(c >= a);
139     return c;
140   }
141 }
142 
143 /**
144  * @title Basic token
145  * @dev Basic version of StandardToken, with no allowances.
146  */
147 contract BasicToken is ERC20Basic {
148   using SafeMath for uint256;
149 
150   mapping(address => uint256) balances;
151 
152   uint256 totalSupply_;
153 
154   /**
155   * @dev total number of tokens in existence
156   */
157   function totalSupply() public view returns (uint256) {
158     return totalSupply_;
159   }
160 
161   /**
162   * @dev transfer token for a specified address
163   * @param _to The address to transfer to.
164   * @param _value The amount to be transferred.
165   */
166   function transfer(address _to, uint256 _value) public returns (bool) {
167     require(_to != address(0));
168     require(_value <= balances[msg.sender]);
169 
170     balances[msg.sender] = balances[msg.sender].sub(_value);
171     balances[_to] = balances[_to].add(_value);
172     emit Transfer(msg.sender, _to, _value);
173     return true;
174   }
175 
176   /**
177   * @dev Gets the balance of the specified address.
178   * @param _owner The address to query the the balance of.
179   * @return An uint256 representing the amount owned by the passed address.
180   */
181   function balanceOf(address _owner) public view returns (uint256) {
182     return balances[_owner];
183   }
184 
185 }
186 
187 /**
188  * @title Burnable Token
189  * @dev Token that can be irreversibly burned (destroyed).
190  */
191 contract BurnableToken is BasicToken {
192 
193   event Burn(address indexed burner, uint256 value);
194 
195   /**
196    * @dev Burns a specific amount of tokens.
197    * @param _value The amount of token to be burned.
198    */
199   function burn(uint256 _value) public {
200     _burn(msg.sender, _value);
201   }
202 
203   function _burn(address _who, uint256 _value) internal {
204     require(_value <= balances[_who]);
205     // no need to require value <= totalSupply, since that would imply the
206     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
207 
208     balances[_who] = balances[_who].sub(_value);
209     totalSupply_ = totalSupply_.sub(_value);
210     emit Burn(_who, _value);
211     emit Transfer(_who, address(0), _value);
212   }
213 }
214 
215 /**
216  * @title Standard ERC20 token
217  *
218  * @dev Implementation of the basic standard token.
219  * @dev https://github.com/ethereum/EIPs/issues/20
220  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
221  */
222 contract StandardToken is ERC20, BasicToken {
223 
224   mapping (address => mapping (address => uint256)) internal allowed;
225 
226 
227   /**
228    * @dev Transfer tokens from one address to another
229    * @param _from address The address which you want to send tokens from
230    * @param _to address The address which you want to transfer to
231    * @param _value uint256 the amount of tokens to be transferred
232    */
233   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
234     require(_to != address(0));
235     require(_value <= balances[_from]);
236     require(_value <= allowed[_from][msg.sender]);
237 
238     balances[_from] = balances[_from].sub(_value);
239     balances[_to] = balances[_to].add(_value);
240     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
241     emit Transfer(_from, _to, _value);
242     return true;
243   }
244 
245   /**
246    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
247    *
248    * Beware that changing an allowance with this method brings the risk that someone may use both the old
249    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
250    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
251    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
252    * @param _spender The address which will spend the funds.
253    * @param _value The amount of tokens to be spent.
254    */
255   function approve(address _spender, uint256 _value) public returns (bool) {
256     allowed[msg.sender][_spender] = _value;
257     emit Approval(msg.sender, _spender, _value);
258     return true;
259   }
260 
261   /**
262    * @dev Function to check the amount of tokens that an owner allowed to a spender.
263    * @param _owner address The address which owns the funds.
264    * @param _spender address The address which will spend the funds.
265    * @return A uint256 specifying the amount of tokens still available for the spender.
266    */
267   function allowance(address _owner, address _spender) public view returns (uint256) {
268     return allowed[_owner][_spender];
269   }
270 
271   /**
272    * @dev Increase the amount of tokens that an owner allowed to a spender.
273    *
274    * approve should be called when allowed[_spender] == 0. To increment
275    * allowed value is better to use this function to avoid 2 calls (and wait until
276    * the first transaction is mined)
277    * From MonolithDAO Token.sol
278    * @param _spender The address which will spend the funds.
279    * @param _addedValue The amount of tokens to increase the allowance by.
280    */
281   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
282     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
283     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
284     return true;
285   }
286 
287   /**
288    * @dev Decrease the amount of tokens that an owner allowed to a spender.
289    *
290    * approve should be called when allowed[_spender] == 0. To decrement
291    * allowed value is better to use this function to avoid 2 calls (and wait until
292    * the first transaction is mined)
293    * From MonolithDAO Token.sol
294    * @param _spender The address which will spend the funds.
295    * @param _subtractedValue The amount of tokens to decrease the allowance by.
296    */
297   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
298     uint oldValue = allowed[msg.sender][_spender];
299     if (_subtractedValue > oldValue) {
300       allowed[msg.sender][_spender] = 0;
301     } else {
302       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
303     }
304     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
305     return true;
306   }
307 
308 }
309 
310 
311 /**
312  * @title Standard Burnable Token
313  * @dev Adds burnFrom method to ERC20 implementations
314  */
315 contract StandardBurnableToken is BurnableToken, StandardToken {
316 
317   /**
318    * @dev Burns a specific amount of tokens from the target address and decrements allowance
319    * @param _from address The address which you want to send tokens from
320    * @param _value uint256 The amount of token to be burned
321    */
322   function burnFrom(address _from, uint256 _value) public {
323     require(_value <= allowed[_from][msg.sender]);
324     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
325     // this function needs to emit an event with the updated approval.
326     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
327     _burn(_from, _value);
328   }
329 }
330 
331 /**
332  * @title Pausable
333  * @dev Base contract which allows children to implement an emergency stop mechanism.
334  */
335 contract Pausable is Ownable {
336   event Pause();
337   event Unpause();
338 
339   bool public paused = false;
340 
341 
342   /**
343    * @dev Modifier to make a function callable only when the contract is not paused.
344    */
345   modifier whenNotPaused() {
346     require(!paused);
347     _;
348   }
349 
350   /**
351    * @dev Modifier to make a function callable only when the contract is paused.
352    */
353   modifier whenPaused() {
354     require(paused);
355     _;
356   }
357 
358   /**
359    * @dev called by the owner to pause, triggers stopped state
360    */
361   function pause() onlyOwner whenNotPaused public {
362     paused = true;
363     emit Pause();
364   }
365 
366   /**
367    * @dev called by the owner to unpause, returns to normal state
368    */
369   function unpause() onlyOwner whenPaused public {
370     paused = false;
371     emit Unpause();
372   }
373 }
374 
375 /**
376  * @title Pausable token
377  * @dev StandardToken modified with pausable transfers.
378  **/
379 contract PausableToken is StandardToken, Pausable {
380 
381   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
382     return super.transfer(_to, _value);
383   }
384 
385   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
386     return super.transferFrom(_from, _to, _value);
387   }
388 
389   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
390     return super.approve(_spender, _value);
391   }
392 
393   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
394     return super.increaseApproval(_spender, _addedValue);
395   }
396 
397   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
398     return super.decreaseApproval(_spender, _subtractedValue);
399   }
400 }
401 
402 /**
403  * @title Claimable
404  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
405  * This allows the new owner to accept the transfer.
406  */
407 contract Claimable is Ownable {
408   address public pendingOwner;
409 
410   /**
411    * @dev Modifier throws if called by any account other than the pendingOwner.
412    */
413   modifier onlyPendingOwner() {
414     require(msg.sender == pendingOwner);
415     _;
416   }
417 
418   /**
419    * @dev Allows the current owner to set the pendingOwner address.
420    * @param newOwner The address to transfer ownership to.
421    */
422   function transferOwnership(address newOwner) onlyOwner public {
423     pendingOwner = newOwner;
424   }
425 
426   /**
427    * @dev Allows the pendingOwner address to finalize the transfer.
428    */
429   function claimOwnership() onlyPendingOwner public {
430     emit OwnershipTransferred(owner, pendingOwner);
431     owner = pendingOwner;
432     pendingOwner = address(0);
433   }
434 }
435 
436 /**
437  * @title Contracts that should be able to recover tokens
438  * @author SylTi
439  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
440  * This will prevent any accidental loss of tokens.
441  */
442 contract CanReclaimToken is Ownable {
443   using SafeERC20 for ERC20Basic;
444 
445   /**
446    * @dev Reclaim all ERC20Basic compatible tokens
447    * @param token ERC20Basic The address of the token contract
448    */
449   function reclaimToken(ERC20Basic token) external onlyOwner {
450     uint256 balance = token.balanceOf(this);
451     token.safeTransfer(owner, balance);
452   }
453 
454 }
455 
456 interface CrowdsaleContract {
457   function isActive() public view returns(bool);
458 }
459 
460 contract BulleonToken is StandardBurnableToken, PausableToken, Claimable {
461   /* Additional events */
462   event AddedToWhitelist(address wallet);
463   event RemoveWhitelist(address wallet);
464 
465   /* Base params */
466   string public constant name = "Bulleon"; /* solium-disable-line uppercase */
467   string public constant symbol = "BUL"; /* solium-disable-line uppercase */
468   uint8 public constant decimals = 18; /* solium-disable-line uppercase */
469   uint256 constant exchangersBalance = 39991750231582759746295 + 14715165984103328399573 + 1846107707643607869274; // YoBit + Etherdelta + IDEX
470 
471   /* Premine and start balance settings */
472   address constant premineWallet = 0x286BE9799488cA4543399c2ec964e7184077711C;
473   uint256 constant premineAmount = 178420 * (10 ** uint256(decimals));
474 
475   /* Additional params */
476   address public CrowdsaleAddress;
477   CrowdsaleContract crowdsale;
478   mapping(address=>bool) whitelist; // Users that may transfer tokens before ICO ended
479 
480   /**
481    * @dev Constructor that gives msg.sender all availabel of existing tokens.
482    */
483   constructor() public {
484     totalSupply_ = 7970000 * (10 ** uint256(decimals));
485     balances[msg.sender] = totalSupply_;
486     transfer(premineWallet, premineAmount.add(exchangersBalance));
487 
488     addToWhitelist(msg.sender);
489     addToWhitelist(premineWallet);
490     paused = true; // Lock token at start
491   }
492 
493   /**
494    * @dev Sets crowdsale contract address (used for checking ICO status)
495    */
496   function setCrowdsaleAddress(address _ico) public onlyOwner {
497     CrowdsaleAddress = _ico;
498     crowdsale = CrowdsaleContract(CrowdsaleAddress);
499     addToWhitelist(CrowdsaleAddress);
500   }
501 
502   /**
503    * @dev called by user the to pause, triggers stopped state
504    * not actualy used
505    */
506   function pause() onlyOwner whenNotPaused public {
507     revert();
508   }
509 
510   /**
511    * @dev Modifier to make a function callable only when the contract is not paused or when sender is whitelisted.
512    */
513   modifier whenNotPaused() {
514     require(!paused || whitelist[msg.sender]);
515     _;
516   }
517 
518   /**
519    * @dev called by the user to unpause at ICO end or by owner, returns token to unlocked state
520    */
521   function unpause() whenPaused public {
522     require(!crowdsale.isActive() || msg.sender == owner); // Checks that ICO is ended
523     paused = false;
524     emit Unpause();
525   }
526 
527   /**
528    * @dev Add wallet address to transfer whitelist (may transfer tokens before ICO ended)
529    */
530   function addToWhitelist(address wallet) public onlyOwner {
531     require(!whitelist[wallet]);
532     whitelist[wallet] = true;
533     emit AddedToWhitelist(wallet);
534   }
535 
536   /**
537    * @dev Delete wallet address to transfer whitelist (may transfer tokens before ICO ended)
538    */
539   function delWhitelist(address wallet) public onlyOwner {
540     require(whitelist[wallet]);
541     whitelist[wallet] = false;
542     emit RemoveWhitelist(wallet);
543   }
544 
545 }