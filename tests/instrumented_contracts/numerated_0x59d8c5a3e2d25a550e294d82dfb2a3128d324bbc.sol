1 pragma solidity 0.4.18;
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
25 
26   /**
27    * @dev Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34 
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address newOwner) public onlyOwner {
40     require(newOwner != address(0));
41     OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 
45 }
46 
47 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
48 
49 /**
50  * @title Pausable
51  * @dev Base contract which allows children to implement an emergency stop mechanism.
52  */
53 contract Pausable is Ownable {
54   event Pause();
55   event Unpause();
56 
57   bool public paused = false;
58 
59 
60   /**
61    * @dev Modifier to make a function callable only when the contract is not paused.
62    */
63   modifier whenNotPaused() {
64     require(!paused);
65     _;
66   }
67 
68   /**
69    * @dev Modifier to make a function callable only when the contract is paused.
70    */
71   modifier whenPaused() {
72     require(paused);
73     _;
74   }
75 
76   /**
77    * @dev called by the owner to pause, triggers stopped state
78    */
79   function pause() onlyOwner whenNotPaused public {
80     paused = true;
81     Pause();
82   }
83 
84   /**
85    * @dev called by the owner to unpause, returns to normal state
86    */
87   function unpause() onlyOwner whenPaused public {
88     paused = false;
89     Unpause();
90   }
91 }
92 
93 // File: zeppelin-solidity/contracts/math/SafeMath.sol
94 
95 /**
96  * @title SafeMath
97  * @dev Math operations with safety checks that throw on error
98  */
99 library SafeMath {
100   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
101     if (a == 0) {
102       return 0;
103     }
104     uint256 c = a * b;
105     assert(c / a == b);
106     return c;
107   }
108 
109   function div(uint256 a, uint256 b) internal pure returns (uint256) {
110     // assert(b > 0); // Solidity automatically throws when dividing by 0
111     uint256 c = a / b;
112     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
113     return c;
114   }
115 
116   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
117     assert(b <= a);
118     return a - b;
119   }
120 
121   function add(uint256 a, uint256 b) internal pure returns (uint256) {
122     uint256 c = a + b;
123     assert(c >= a);
124     return c;
125   }
126 }
127 
128 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
129 
130 /**
131  * @title ERC20Basic
132  * @dev Simpler version of ERC20 interface
133  * @dev see https://github.com/ethereum/EIPs/issues/179
134  */
135 contract ERC20Basic {
136   uint256 public totalSupply;
137   function balanceOf(address who) public view returns (uint256);
138   function transfer(address to, uint256 value) public returns (bool);
139   event Transfer(address indexed from, address indexed to, uint256 value);
140 }
141 
142 // File: zeppelin-solidity/contracts/token/BasicToken.sol
143 
144 /**
145  * @title Basic token
146  * @dev Basic version of StandardToken, with no allowances.
147  */
148 contract BasicToken is ERC20Basic {
149   using SafeMath for uint256;
150 
151   mapping(address => uint256) balances;
152 
153   /**
154   * @dev transfer token for a specified address
155   * @param _to The address to transfer to.
156   * @param _value The amount to be transferred.
157   */
158   function transfer(address _to, uint256 _value) public returns (bool) {
159     require(_to != address(0));
160     require(_value <= balances[msg.sender]);
161 
162     // SafeMath.sub will throw if there is not enough balance.
163     balances[msg.sender] = balances[msg.sender].sub(_value);
164     balances[_to] = balances[_to].add(_value);
165     Transfer(msg.sender, _to, _value);
166     return true;
167   }
168 
169   /**
170   * @dev Gets the balance of the specified address.
171   * @param _owner The address to query the the balance of.
172   * @return An uint256 representing the amount owned by the passed address.
173   */
174   function balanceOf(address _owner) public view returns (uint256 balance) {
175     return balances[_owner];
176   }
177 
178 }
179 
180 // File: zeppelin-solidity/contracts/token/ERC20.sol
181 
182 /**
183  * @title ERC20 interface
184  * @dev see https://github.com/ethereum/EIPs/issues/20
185  */
186 contract ERC20 is ERC20Basic {
187   function allowance(address owner, address spender) public view returns (uint256);
188   function transferFrom(address from, address to, uint256 value) public returns (bool);
189   function approve(address spender, uint256 value) public returns (bool);
190   event Approval(address indexed owner, address indexed spender, uint256 value);
191 }
192 
193 // File: zeppelin-solidity/contracts/token/StandardToken.sol
194 
195 /**
196  * @title Standard ERC20 token
197  *
198  * @dev Implementation of the basic standard token.
199  * @dev https://github.com/ethereum/EIPs/issues/20
200  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
201  */
202 contract StandardToken is ERC20, BasicToken {
203 
204   mapping (address => mapping (address => uint256)) internal allowed;
205 
206 
207   /**
208    * @dev Transfer tokens from one address to another
209    * @param _from address The address which you want to send tokens from
210    * @param _to address The address which you want to transfer to
211    * @param _value uint256 the amount of tokens to be transferred
212    */
213   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
214     require(_to != address(0));
215     require(_value <= balances[_from]);
216     require(_value <= allowed[_from][msg.sender]);
217 
218     balances[_from] = balances[_from].sub(_value);
219     balances[_to] = balances[_to].add(_value);
220     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
221     Transfer(_from, _to, _value);
222     return true;
223   }
224 
225   /**
226    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
227    *
228    * Beware that changing an allowance with this method brings the risk that someone may use both the old
229    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
230    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
231    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
232    * @param _spender The address which will spend the funds.
233    * @param _value The amount of tokens to be spent.
234    */
235   function approve(address _spender, uint256 _value) public returns (bool) {
236     allowed[msg.sender][_spender] = _value;
237     Approval(msg.sender, _spender, _value);
238     return true;
239   }
240 
241   /**
242    * @dev Function to check the amount of tokens that an owner allowed to a spender.
243    * @param _owner address The address which owns the funds.
244    * @param _spender address The address which will spend the funds.
245    * @return A uint256 specifying the amount of tokens still available for the spender.
246    */
247   function allowance(address _owner, address _spender) public view returns (uint256) {
248     return allowed[_owner][_spender];
249   }
250 
251   /**
252    * approve should be called when allowed[_spender] == 0. To increment
253    * allowed value is better to use this function to avoid 2 calls (and wait until
254    * the first transaction is mined)
255    * From MonolithDAO Token.sol
256    */
257   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
258     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
259     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
260     return true;
261   }
262 
263   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
264     uint oldValue = allowed[msg.sender][_spender];
265     if (_subtractedValue > oldValue) {
266       allowed[msg.sender][_spender] = 0;
267     } else {
268       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
269     }
270     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
271     return true;
272   }
273 
274 }
275 
276 // File: zeppelin-solidity/contracts/token/PausableToken.sol
277 
278 /**
279  * @title Pausable token
280  *
281  * @dev StandardToken modified with pausable transfers.
282  **/
283 
284 contract PausableToken is StandardToken, Pausable {
285 
286   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
287     return super.transfer(_to, _value);
288   }
289 
290   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
291     return super.transferFrom(_from, _to, _value);
292   }
293 
294   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
295     return super.approve(_spender, _value);
296   }
297 
298   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
299     return super.increaseApproval(_spender, _addedValue);
300   }
301 
302   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
303     return super.decreaseApproval(_spender, _subtractedValue);
304   }
305 }
306 
307 // File: contracts/BrickblockToken.sol
308 
309 contract BrickblockToken is PausableToken {
310 
311   string public constant name = "BrickblockToken";
312   string public constant symbol = "BBK";
313   uint256 public constant initialSupply = 500 * (10 ** 6) * (10 ** uint256(decimals));
314   uint8 public constant contributorsShare = 51;
315   uint8 public constant companyShare = 35;
316   uint8 public constant bonusShare = 14;
317   uint8 public constant decimals = 18;
318   address public bonusDistributionAddress;
319   address public fountainContractAddress;
320   address public successorAddress;
321   address public predecessorAddress;
322   bool public tokenSaleActive;
323   bool public dead;
324 
325   event TokenSaleFinished(uint256 totalSupply, uint256 distributedTokens,  uint256 bonusTokens, uint256 companyTokens);
326   event Burn(address indexed burner, uint256 value);
327   event Upgrade(address successorAddress);
328   event Evacuated(address user);
329   event Rescued(address user, uint256 rescuedBalance, uint256 newBalance);
330 
331   modifier only(address caller) {
332     require(msg.sender == caller);
333     _;
334   }
335 
336   // need to make sure that no more than 51% of total supply is bought
337   modifier supplyAvailable(uint256 _value) {
338     uint256 _distributedTokens = initialSupply.sub(balances[this]);
339     uint256 _maxDistributedAmount = initialSupply.mul(contributorsShare).div(100);
340     require(_distributedTokens.add(_value) <= _maxDistributedAmount);
341     _;
342   }
343 
344   function BrickblockToken(address _predecessorAddress)
345     public
346   {
347     // need to start paused to make sure that there can be no transfers until dictated by company
348     paused = true;
349 
350     // if contract is an upgrade
351     if (_predecessorAddress != address(0)) {
352       // take the initialization variables from predecessor state
353       predecessorAddress = _predecessorAddress;
354       BrickblockToken predecessor = BrickblockToken(_predecessorAddress);
355       balances[this] = predecessor.balanceOf(_predecessorAddress);
356       Transfer(address(0), this, predecessor.balanceOf(_predecessorAddress));
357       // the total supply starts with the balance of the contract itself and rescued funds will be added to this
358       totalSupply = predecessor.balanceOf(_predecessorAddress);
359       tokenSaleActive = predecessor.tokenSaleActive();
360       bonusDistributionAddress = predecessor.bonusDistributionAddress();
361       fountainContractAddress = predecessor.fountainContractAddress();
362       // if contract is NOT an upgrade
363     } else {
364       // first contract, easy setup
365       totalSupply = initialSupply;
366       balances[this] = initialSupply;
367       Transfer(address(0), this, initialSupply);
368       tokenSaleActive = true;
369     }
370   }
371 
372   function unpause()
373     public
374     onlyOwner
375     whenPaused
376   {
377     require(dead == false);
378     super.unpause();
379   }
380 
381   function isContract(address addr)
382     private
383     view
384     returns (bool)
385   {
386     uint _size;
387     assembly { _size := extcodesize(addr) }
388     return _size > 0;
389   }
390 
391   // decide which wallet to use to distribute bonuses at a later date
392   function changeBonusDistributionAddress(address _newAddress)
393     public
394     onlyOwner
395     returns (bool)
396   {
397     require(_newAddress != address(this));
398     bonusDistributionAddress = _newAddress;
399     return true;
400   }
401 
402   // fountain contract might change over time... need to be able to change it
403   function changeFountainContractAddress(address _newAddress)
404     public
405     onlyOwner
406     returns (bool)
407   {
408     require(isContract(_newAddress));
409     require(_newAddress != address(this));
410     require(_newAddress != owner);
411     fountainContractAddress = _newAddress;
412     return true;
413   }
414 
415   // custom transfer function that can be used while paused. Cannot be used after end of token sale
416   function distributeTokens(address _contributor, uint256 _value)
417     public
418     onlyOwner
419     supplyAvailable(_value)
420     returns (bool)
421   {
422     require(tokenSaleActive == true);
423     require(_contributor != address(0));
424     require(_contributor != owner);
425     balances[this] = balances[this].sub(_value);
426     balances[_contributor] = balances[_contributor].add(_value);
427     Transfer(this, _contributor, _value);
428     return true;
429   }
430 
431   // Calculate the shares for company, bonus & contibutors based on the intiial 50mm number - not what is left over after burning
432   function finalizeTokenSale()
433     public
434     onlyOwner
435     returns (bool)
436   {
437     // ensure that sale is active. is set to false at the end. can only be performed once.
438     require(tokenSaleActive == true);
439     // ensure that bonus address has been set
440     require(bonusDistributionAddress != address(0));
441     // ensure that fountainContractAddress has been set
442     require(fountainContractAddress != address(0));
443     uint256 _distributedTokens = initialSupply.sub(balances[this]);
444     // company amount for company (35%)
445     uint256 _companyTokens = initialSupply.mul(companyShare).div(100);
446     // token amount for internal bonuses based on totalSupply (14%)
447     uint256 _bonusTokens = initialSupply.mul(bonusShare).div(100);
448     // need to do this in order to have accurate totalSupply due to integer division
449     uint256 _newTotalSupply = _distributedTokens.add(_bonusTokens.add(_companyTokens));
450     // unpurchased amount of tokens which will be burned
451     uint256 _burnAmount = totalSupply.sub(_newTotalSupply);
452     // distribute bonusTokens to distribution address
453     balances[this] = balances[this].sub(_bonusTokens);
454     balances[bonusDistributionAddress] = balances[bonusDistributionAddress].add(_bonusTokens);
455     Transfer(this, bonusDistributionAddress, _bonusTokens);
456     // leave remaining balance for company to be claimed at later date
457     balances[this] = balances[this].sub(_burnAmount);
458     Burn(this, _burnAmount);
459     // set the company tokens to be allowed by fountain addresse
460     allowed[this][fountainContractAddress] = _companyTokens;
461     Approval(this, fountainContractAddress, _companyTokens);
462     // set new totalSupply
463     totalSupply = _newTotalSupply;
464     // lock out this function from running ever again
465     tokenSaleActive = false;
466     // event showing sale is finished
467     TokenSaleFinished(
468       totalSupply,
469       _distributedTokens,
470       _bonusTokens,
471       _companyTokens
472     );
473     // everything went well return true
474     return true;
475   }
476 
477   // this method will be called by the successor, it can be used to query the token balance,
478   // but the main goal is to remove the data in the now dead contract,
479   // to disable anyone to get rescued more that once
480   // approvals are not included due to data structure
481   function evacuate(address _user)
482     public
483     only(successorAddress)
484     returns (bool)
485   {
486     require(dead);
487     uint256 _balance = balances[_user];
488     balances[_user] = 0;
489     totalSupply = totalSupply.sub(_balance);
490     Evacuated(_user);
491     return true;
492   }
493 
494   // to upgrade our contract
495   // we set the successor, who is allowed to empty out the data
496   // it then will be dead
497   // it will be paused to dissallow transfer of tokens
498   function upgrade(address _successorAddress)
499     public
500     onlyOwner
501     returns (bool)
502   {
503     require(_successorAddress != address(0));
504     require(isContract(_successorAddress));
505     successorAddress = _successorAddress;
506     dead = true;
507     paused = true;
508     Upgrade(successorAddress);
509     return true;
510   }
511 
512   // each user should call rescue once after an upgrade to evacuate his balance from the predecessor
513   // the allowed mapping will be lost
514   // if this is called multiple times it won't throw, but the balance will not change
515   // this enables us to call it befor each method changeing the balances
516   // (this might be a bad idea due to gas-cost and overhead)
517   function rescue()
518     public
519     returns (bool)
520   {
521     require(predecessorAddress != address(0));
522     address _user = msg.sender;
523     BrickblockToken predecessor = BrickblockToken(predecessorAddress);
524     uint256 _oldBalance = predecessor.balanceOf(_user);
525     if (_oldBalance > 0) {
526       balances[_user] = balances[_user].add(_oldBalance);
527       totalSupply = totalSupply.add(_oldBalance);
528       predecessor.evacuate(_user);
529       Rescued(_user, _oldBalance, balances[_user]);
530       return true;
531     }
532     return false;
533   }
534 
535   // fallback function - do not allow any eth transfers to this contract
536   function()
537     public
538   {
539     revert();
540   }
541 
542 }