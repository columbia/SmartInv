1 pragma solidity ^0.4.24;
2 
3 // File: contracts/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * See https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: contracts/SafeMath.sol
18 
19 /**
20  * @title SafeMath
21  * @dev Math operations with safety checks that throw on error
22  */
23 library SafeMath {
24 
25   /**
26   * @dev Multiplies two numbers, throws on overflow.
27   */
28   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
29     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
30     // benefit is lost if 'b' is also tested.
31     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
32     if (a == 0) {
33       return 0;
34     }
35 
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
69 // File: contracts/BasicToken.sol
70 
71 /**
72  * @title Basic token
73  * @dev Basic version of StandardToken, with no allowances.
74  */
75 contract BasicToken is ERC20Basic {
76   using SafeMath for uint256;
77 
78   mapping(address => uint256) balances;
79 
80   uint256 totalSupply_;
81 
82   /**
83   * @dev Total number of tokens in existence
84   */
85   function totalSupply() public view returns (uint256) {
86     return totalSupply_;
87   }
88 
89   /**
90   * @dev Transfer token for a specified address
91   * @param _to The address to transfer to.
92   * @param _value The amount to be transferred.
93   */
94   function transfer(address _to, uint256 _value) public returns (bool) {
95     require(_to != address(0));
96     require(_value <= balances[msg.sender]);
97 
98     balances[msg.sender] = balances[msg.sender].sub(_value);
99     balances[_to] = balances[_to].add(_value);
100     emit Transfer(msg.sender, _to, _value);
101     return true;
102   }
103 
104   /**
105   * @dev Gets the balance of the specified address.
106   * @param _owner The address to query the the balance of.
107   * @return An uint256 representing the amount owned by the passed address.
108   */
109   function balanceOf(address _owner) public view returns (uint256) {
110     return balances[_owner];
111   }
112 
113 }
114 
115 // File: contracts/ERC20.sol
116 
117 /**
118  * @title ERC20 interface
119  * @dev see https://github.com/ethereum/EIPs/issues/20
120  */
121 contract ERC20 is ERC20Basic {
122     function allowance(address owner, address spender)
123     public view returns (uint256);
124 
125     function transferFrom(address from, address to, uint256 value)
126     public returns (bool);
127 
128     function approve(address spender, uint256 value) public returns (bool);
129     event Approval(
130         address indexed owner,
131         address indexed spender,
132         uint256 value
133     );
134 }
135 
136 // File: contracts/StandardToken.sol
137 
138 /**
139  * @title Standard ERC20 token
140  *
141  * @dev Implementation of the basic standard token.
142  * https://github.com/ethereum/EIPs/issues/20
143  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
144  */
145 contract StandardToken is ERC20, BasicToken {
146 
147   mapping (address => mapping (address => uint256)) internal allowed;
148 
149 
150   /**
151    * @dev Transfer tokens from one address to another
152    * @param _from address The address which you want to send tokens from
153    * @param _to address The address which you want to transfer to
154    * @param _value uint256 the amount of tokens to be transferred
155    */
156   function transferFrom(
157     address _from,
158     address _to,
159     uint256 _value
160   )
161     public
162     returns (bool)
163   {
164     require(_to != address(0));
165     require(_value <= balances[_from]);
166     require(_value <= allowed[_from][msg.sender]);
167 
168     balances[_from] = balances[_from].sub(_value);
169     balances[_to] = balances[_to].add(_value);
170     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
171     emit Transfer(_from, _to, _value);
172     return true;
173   }
174 
175   /**
176    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
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
196   function allowance(
197     address _owner,
198     address _spender
199    )
200     public
201     view
202     returns (uint256)
203   {
204     return allowed[_owner][_spender];
205   }
206 
207   /**
208    * @dev Increase the amount of tokens that an owner allowed to a spender.
209    * approve should be called when allowed[_spender] == 0. To increment
210    * allowed value is better to use this function to avoid 2 calls (and wait until
211    * the first transaction is mined)
212    * From MonolithDAO Token.sol
213    * @param _spender The address which will spend the funds.
214    * @param _addedValue The amount of tokens to increase the allowance by.
215    */
216   function increaseApproval(
217     address _spender,
218     uint256 _addedValue
219   )
220     public
221     returns (bool)
222   {
223     allowed[msg.sender][_spender] = (
224       allowed[msg.sender][_spender].add(_addedValue));
225     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226     return true;
227   }
228 
229   /**
230    * @dev Decrease the amount of tokens that an owner allowed to a spender.
231    * approve should be called when allowed[_spender] == 0. To decrement
232    * allowed value is better to use this function to avoid 2 calls (and wait until
233    * the first transaction is mined)
234    * From MonolithDAO Token.sol
235    * @param _spender The address which will spend the funds.
236    * @param _subtractedValue The amount of tokens to decrease the allowance by.
237    */
238   function decreaseApproval(
239     address _spender,
240     uint256 _subtractedValue
241   )
242     public
243     returns (bool)
244   {
245     uint256 oldValue = allowed[msg.sender][_spender];
246     if (_subtractedValue > oldValue) {
247       allowed[msg.sender][_spender] = 0;
248     } else {
249       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
250     }
251     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
252     return true;
253   }
254 
255 }
256 
257 // File: contracts/Ownable.sol
258 
259 /**
260  * @title Ownable
261  * @dev The Ownable contract has an owner address, and provides basic authorization control
262  * functions, this simplifies the implementation of "user permissions".
263  */
264 contract Ownable {
265   address public owner;
266 
267 
268   event OwnershipRenounced(address indexed previousOwner);
269   event OwnershipTransferred(
270     address indexed previousOwner,
271     address indexed newOwner
272   );
273 
274 
275   /**
276    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
277    * account.
278    */
279   constructor() public {
280     owner = msg.sender;
281   }
282 
283   /**
284    * @dev Throws if called by any account other than the owner.
285    */
286   modifier onlyOwner() {
287     require(msg.sender == owner);
288     _;
289   }
290 
291   /**
292    * @dev Allows the current owner to relinquish control of the contract.
293    * @notice Renouncing to ownership will leave the contract without an owner.
294    * It will not be possible to call the functions with the `onlyOwner`
295    * modifier anymore.
296    */
297   function renounceOwnership() public onlyOwner {
298     emit OwnershipRenounced(owner);
299     owner = address(0);
300   }
301 
302   /**
303    * @dev Allows the current owner to transfer control of the contract to a newOwner.
304    * @param _newOwner The address to transfer ownership to.
305    */
306   function transferOwnership(address _newOwner) public onlyOwner {
307     _transferOwnership(_newOwner);
308   }
309 
310   /**
311    * @dev Transfers control of the contract to a newOwner.
312    * @param _newOwner The address to transfer ownership to.
313    */
314   function _transferOwnership(address _newOwner) internal {
315     require(_newOwner != address(0));
316     emit OwnershipTransferred(owner, _newOwner);
317     owner = _newOwner;
318   }
319 }
320 
321 // File: contracts/MintableToken.sol
322 
323 /**
324  * @title Mintable token
325  * @dev Simple ERC20 Token example, with mintable token creation
326  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
327  */
328 contract MintableToken is StandardToken, Ownable {
329   event Mint(address indexed to, uint256 amount);
330   event MintFinished();
331 
332   bool public mintingFinished = false;
333 
334 
335   modifier canMint() {
336     require(!mintingFinished);
337     _;
338   }
339 
340   modifier hasMintPermission() {
341     require(msg.sender == owner);
342     _;
343   }
344 
345   /**
346    * @dev Function to mint tokens
347    * @param _to The address that will receive the minted tokens.
348    * @param _amount The amount of tokens to mint.
349    * @return A boolean that indicates if the operation was successful.
350    */
351   function mint(
352     address _to,
353     uint256 _amount
354   )
355     hasMintPermission
356     canMint
357     public
358     returns (bool)
359   {
360     totalSupply_ = totalSupply_.add(_amount);
361     balances[_to] = balances[_to].add(_amount);
362     emit Mint(_to, _amount);
363     emit Transfer(address(0), _to, _amount);
364     return true;
365   }
366 
367   /**
368    * @dev Function to stop minting new tokens.
369    * @return True if the operation was successful.
370    */
371   function finishMinting() onlyOwner canMint public returns (bool) {
372     mintingFinished = true;
373     emit MintFinished();
374     return true;
375   }
376 }
377 
378 // File: contracts/Owned.sol
379 
380 contract Owned {
381     address public owner;
382 
383     constructor() public {
384         owner = msg.sender;
385     }
386 
387     modifier onlyOwner {
388         require(msg.sender == owner);
389         _;
390     }
391 
392     function transferOwnership(address newOwner) onlyOwner public {
393         owner = newOwner;
394     }
395 }
396 
397 // File: contracts/TokenExchange.sol
398 
399 contract TokenExchange is Owned {
400 
401     uint256 internal  constant initialBuyPrice = 1400000000000000;
402 
403 
404     uint256 internal  priceIncrement =         550000000;
405     uint256 internal  buyPrice;
406 
407     StandardToken internal  token;
408 
409     event BuyEvent(
410         address wallet,
411         uint256 amount
412     );
413 
414     /* Initializes contract with initial supply tokens to the creator of the contract */
415     constructor() public {
416         buyPrice = initialBuyPrice;
417     }
418 
419     function setCurrency(address _tokenContract) public onlyOwner {
420         token = StandardToken(_tokenContract);
421     }
422 
423     function withdraw() onlyOwner public {
424         owner.transfer(address(this).balance);
425     }
426 
427     /// @notice Allow users to buy tokens for `newBuyPrice` eth
428     /// @param newBuyPrice Price users can buy from the contract
429     function setBuyPrice(uint256 newBuyPrice) onlyOwner public {
430         buyPrice = newBuyPrice;
431     }
432 
433     function setPriceIncrement(uint256 _newPriceIncrement) onlyOwner public{
434         priceIncrement=_newPriceIncrement;
435     }
436 
437     /// @notice Buy tokens from contract by sending ether
438     function buy(uint256 amount) payable public {
439         require(msg.value == getTotalCost(amount));
440         token.increaseApproval(this, amount);
441         token.transferFrom(this, msg.sender, amount);
442         // makes the transfers
443         buyPrice = SafeMath.add(buyPrice, SafeMath.mul(priceIncrement, amount));
444         emit BuyEvent(msg.sender, amount);
445     }
446 
447 
448     // calculate the amount of ETH needed to buy "amount" of token
449     function getTotalCost(uint256 amount) public view returns (uint256){
450         return SafeMath.add(
451             SafeMath.mul(buyPrice, amount),
452             SafeMath.div(SafeMath.mul(priceIncrement, SafeMath.mul(SafeMath.add(amount, 1), amount)), 2));
453     }
454 
455     // calculate the amount of ETH received after selling "amount" of token
456 
457     function getBuyPrice() view public returns (uint){
458         return buyPrice;
459     }
460 
461 
462     function getBalance() view public returns (uint ethBalance, uint tokenBalance){
463         return (address(this).balance, token.balanceOf(this));
464     }
465 }
466 
467 // File: contracts/PurchaseRuleManager.sol
468 
469 contract PurchaseRuleManager is Owned {
470 
471 
472     TokenExchange priceProvider;
473     StandardToken internal  token;
474 
475     uint256 unlockPrice = 320000000000000000;
476     mapping(address=>bool) unlocked;
477 
478     constructor() public {
479     }
480 
481     function unlock(address tokenOwner) public onlyOwner {
482         unlocked[tokenOwner]=true;
483     }
484 
485     function lock(address tokenOwner) public onlyOwner {
486         unlocked[tokenOwner]=false;
487     }
488 
489     function setCurrency(address _tokenContract) public onlyOwner {
490         token = StandardToken(_tokenContract);
491     }
492 
493     function isUnlocked(address tokenOwner) public view returns (bool){
494         return unlocked[tokenOwner];
495     }
496 
497     function setPriceProvider(address _gameContract) public onlyOwner{
498         priceProvider=TokenExchange(_gameContract);
499     }
500 
501     function buyUnlock(address _buyerAddress) public payable{
502         require(!unlocked[_buyerAddress]);
503         require(msg.value==unlockPrice);
504         unlocked[_buyerAddress]=true;
505         uint distributed=SafeMath.div(msg.value,priceProvider.getBuyPrice());
506         token.transfer(_buyerAddress,distributed);
507     }
508 
509     function getUnlockPrice() public view returns (uint256){
510         return unlockPrice;
511     }
512 
513     function setUnlockPrice(uint256 _value) public onlyOwner{
514         unlockPrice=_value;
515     }
516 
517     function withdraw() onlyOwner public returns (bool){
518         owner.transfer(address(this).balance);
519         return true;
520     }
521 }
522 
523 // File: contracts/NeonToken.sol
524 
525 contract NeonToken is Owned, MintableToken {
526     // Public variables of the token
527     string public name="NeonToken";
528     string public symbol="NET";
529     uint8 public decimals = 0;
530 
531     PurchaseRuleManager ruleProvider;
532 
533     /* Initializes contract with initial supply tokens to the creator of the contract */
534     constructor() public {
535     }
536 
537     function setRuleProvider(address _contract) public onlyOwner{
538         ruleProvider=PurchaseRuleManager(_contract);
539     }
540 
541     function transfer(address to, uint256 value) public returns (bool){
542         require(ruleProvider!=address(0x0));
543         require(ruleProvider.isUnlocked(msg.sender));
544         return super.transfer(to,value);
545     }
546 
547     function transferFrom(address _from, address _to, uint256 _value) public returns (bool){
548         require(ruleProvider!=address(0x0));
549         require(ruleProvider.isUnlocked(_from));
550         return super.transferFrom(_from,_to,_value);
551     }
552 
553 }