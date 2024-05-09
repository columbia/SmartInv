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
112 // File: zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
113 
114 /**
115  * @title Burnable Token
116  * @dev Token that can be irreversibly burned (destroyed).
117  */
118 contract BurnableToken is BasicToken {
119 
120   event Burn(address indexed burner, uint256 value);
121 
122   /**
123    * @dev Burns a specific amount of tokens.
124    * @param _value The amount of token to be burned.
125    */
126   function burn(uint256 _value) public {
127     require(_value <= balances[msg.sender]);
128     // no need to require value <= totalSupply, since that would imply the
129     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
130 
131     address burner = msg.sender;
132     balances[burner] = balances[burner].sub(_value);
133     totalSupply_ = totalSupply_.sub(_value);
134     Burn(burner, _value);
135   }
136 }
137 
138 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
139 
140 /**
141  * @title Ownable
142  * @dev The Ownable contract has an owner address, and provides basic authorization control
143  * functions, this simplifies the implementation of "user permissions".
144  */
145 contract Ownable {
146   address public owner;
147 
148 
149   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
150 
151 
152   /**
153    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
154    * account.
155    */
156   function Ownable() public {
157     owner = msg.sender;
158   }
159 
160   /**
161    * @dev Throws if called by any account other than the owner.
162    */
163   modifier onlyOwner() {
164     require(msg.sender == owner);
165     _;
166   }
167 
168   /**
169    * @dev Allows the current owner to transfer control of the contract to a newOwner.
170    * @param newOwner The address to transfer ownership to.
171    */
172   function transferOwnership(address newOwner) public onlyOwner {
173     require(newOwner != address(0));
174     OwnershipTransferred(owner, newOwner);
175     owner = newOwner;
176   }
177 
178 }
179 
180 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
181 
182 /**
183  * @title Pausable
184  * @dev Base contract which allows children to implement an emergency stop mechanism.
185  */
186 contract Pausable is Ownable {
187   event Pause();
188   event Unpause();
189 
190   bool public paused = false;
191 
192 
193   /**
194    * @dev Modifier to make a function callable only when the contract is not paused.
195    */
196   modifier whenNotPaused() {
197     require(!paused);
198     _;
199   }
200 
201   /**
202    * @dev Modifier to make a function callable only when the contract is paused.
203    */
204   modifier whenPaused() {
205     require(paused);
206     _;
207   }
208 
209   /**
210    * @dev called by the owner to pause, triggers stopped state
211    */
212   function pause() onlyOwner whenNotPaused public {
213     paused = true;
214     Pause();
215   }
216 
217   /**
218    * @dev called by the owner to unpause, returns to normal state
219    */
220   function unpause() onlyOwner whenPaused public {
221     paused = false;
222     Unpause();
223   }
224 }
225 
226 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
227 
228 /**
229  * @title ERC20 interface
230  * @dev see https://github.com/ethereum/EIPs/issues/20
231  */
232 contract ERC20 is ERC20Basic {
233   function allowance(address owner, address spender) public view returns (uint256);
234   function transferFrom(address from, address to, uint256 value) public returns (bool);
235   function approve(address spender, uint256 value) public returns (bool);
236   event Approval(address indexed owner, address indexed spender, uint256 value);
237 }
238 
239 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
240 
241 /**
242  * @title Standard ERC20 token
243  *
244  * @dev Implementation of the basic standard token.
245  * @dev https://github.com/ethereum/EIPs/issues/20
246  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
247  */
248 contract StandardToken is ERC20, BasicToken {
249 
250   mapping (address => mapping (address => uint256)) internal allowed;
251 
252 
253   /**
254    * @dev Transfer tokens from one address to another
255    * @param _from address The address which you want to send tokens from
256    * @param _to address The address which you want to transfer to
257    * @param _value uint256 the amount of tokens to be transferred
258    */
259   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
260     require(_to != address(0));
261     require(_value <= balances[_from]);
262     require(_value <= allowed[_from][msg.sender]);
263 
264     balances[_from] = balances[_from].sub(_value);
265     balances[_to] = balances[_to].add(_value);
266     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
267     Transfer(_from, _to, _value);
268     return true;
269   }
270 
271   /**
272    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
273    *
274    * Beware that changing an allowance with this method brings the risk that someone may use both the old
275    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
276    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
277    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
278    * @param _spender The address which will spend the funds.
279    * @param _value The amount of tokens to be spent.
280    */
281   function approve(address _spender, uint256 _value) public returns (bool) {
282     allowed[msg.sender][_spender] = _value;
283     Approval(msg.sender, _spender, _value);
284     return true;
285   }
286 
287   /**
288    * @dev Function to check the amount of tokens that an owner allowed to a spender.
289    * @param _owner address The address which owns the funds.
290    * @param _spender address The address which will spend the funds.
291    * @return A uint256 specifying the amount of tokens still available for the spender.
292    */
293   function allowance(address _owner, address _spender) public view returns (uint256) {
294     return allowed[_owner][_spender];
295   }
296 
297   /**
298    * @dev Increase the amount of tokens that an owner allowed to a spender.
299    *
300    * approve should be called when allowed[_spender] == 0. To increment
301    * allowed value is better to use this function to avoid 2 calls (and wait until
302    * the first transaction is mined)
303    * From MonolithDAO Token.sol
304    * @param _spender The address which will spend the funds.
305    * @param _addedValue The amount of tokens to increase the allowance by.
306    */
307   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
308     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
309     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
310     return true;
311   }
312 
313   /**
314    * @dev Decrease the amount of tokens that an owner allowed to a spender.
315    *
316    * approve should be called when allowed[_spender] == 0. To decrement
317    * allowed value is better to use this function to avoid 2 calls (and wait until
318    * the first transaction is mined)
319    * From MonolithDAO Token.sol
320    * @param _spender The address which will spend the funds.
321    * @param _subtractedValue The amount of tokens to decrease the allowance by.
322    */
323   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
324     uint oldValue = allowed[msg.sender][_spender];
325     if (_subtractedValue > oldValue) {
326       allowed[msg.sender][_spender] = 0;
327     } else {
328       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
329     }
330     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
331     return true;
332   }
333 
334 }
335 
336 // File: zeppelin-solidity/contracts/token/ERC20/PausableToken.sol
337 
338 /**
339  * @title Pausable token
340  * @dev StandardToken modified with pausable transfers.
341  **/
342 contract PausableToken is StandardToken, Pausable {
343 
344   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
345     return super.transfer(_to, _value);
346   }
347 
348   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
349     return super.transferFrom(_from, _to, _value);
350   }
351 
352   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
353     return super.approve(_spender, _value);
354   }
355 
356   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
357     return super.increaseApproval(_spender, _addedValue);
358   }
359 
360   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
361     return super.decreaseApproval(_spender, _subtractedValue);
362   }
363 }
364 
365 // File: contracts/XcelToken.sol
366 
367 /*
368     Prereq for deploying this contracts
369     1) TokenBuyer address is created
370 
371     To start team vesting
372     1) Create TeamVesting beneficiary address
373     2) Deploy team allocation Vesting contract (StepVesting)
374     3) Call XcelToken.initiateTeamVesting using the contact owner account
375     4) Call assignFoundationSupply to manage founcation allocation via contract
376     5) Call assignReserveSupply to manage reserveFundSupply via contracts
377     6) Set Loyalty wallet address .
378     7) Call allocateLoyaltySpend to move some tokens from loyalty pool to Loyalty wallet as needed
379 
380 */
381 
382 contract XcelToken is PausableToken, BurnableToken  {
383 
384     string public constant name = "XCELTOKEN";
385 
386     string public constant symbol = "XCEL";
387 
388     /* see issue 724 where Vitalik is proposing mandatory 18 decimal places for erc20 tokens
389     https://github.com/ethereum/EIPs/issues/724
390     */
391     uint8 public constant decimals = 18;
392 
393     // 50 Billion tokens
394     uint256 public constant INITIAL_SUPPLY = 50 * (10**9) * (10 ** uint256(decimals));
395 
396     // fundation supply 10%
397     uint256 public constant foundationSupply = 5 * (10**9) * (10 ** uint256(decimals));
398 
399     // founders supply 15%
400     uint256 public constant teamSupply = 7.5 * (10**9) * (10 ** uint256(decimals));
401 
402     // public sale supply 60%
403     uint256 public publicSaleSupply = 30 * (10**9) * (10 ** uint256(decimals));
404 
405     //imp/cmp supply 5%
406     uint256 public loyaltySupply = 2.5 * (10**9) * (10 ** uint256(decimals));
407 
408     //reserve fund supply 10%
409     uint256 public constant reserveFundSupply = 5 * (10**9) * (10 ** uint256(decimals));
410 
411     // Only Address that can buy public sale supply
412     address public tokenBuyerWallet =0x0;
413 
414     //wallet to disperse loyalty points as needed.
415     address public loyaltyWallet = 0x0;
416 
417     //address where team vesting contract will relase the team vested tokens
418     address public teamVestingContractAddress;
419 
420     bool public isTeamVestingInitiated = false;
421 
422     bool public isFoundationSupplyAssigned = false;
423 
424     bool public isReserveSupplyAssigned = false;
425 
426     //Sale from public allocation via tokenBuyerWallet
427     event TokensBought(address indexed _to, uint256 _totalAmount, bytes4 _currency, bytes32 _txHash);
428     event LoyaltySupplyAllocated(address indexed _to, uint256 _totalAmount);
429     event LoyaltyWalletAddressChanged(address indexed _oldAddress, address indexed _newAddress);
430 
431     // Token Buyer has special to transfer from public sale supply
432     modifier onlyTokenBuyer() {
433         require(msg.sender == tokenBuyerWallet);
434         _;
435     }
436 
437     // No zero address transaction
438     modifier nonZeroAddress(address _to) {
439         require(_to != 0x0);
440         _;
441     }
442 
443 
444     function XcelToken(address _tokenBuyerWallet)
445         public
446         nonZeroAddress(_tokenBuyerWallet){
447 
448         tokenBuyerWallet = _tokenBuyerWallet;
449         totalSupply_ = INITIAL_SUPPLY;
450 
451         //mint all tokens
452         balances[msg.sender] = totalSupply_;
453         Transfer(address(0x0), msg.sender, totalSupply_);
454 
455         //Allow  token buyer to transfer public sale allocation
456         //need to revisit to see if this needs to be broken into 3 parts so that
457         //one address does not compromise 60% of token
458         require(approve(tokenBuyerWallet, 0));
459         require(approve(tokenBuyerWallet, publicSaleSupply));
460 
461     }
462 
463     /**
464         Allow contract owner to burn token
465     **/
466     function burn(uint256 _value)
467       public
468       onlyOwner {
469         super.burn(_value);
470     }
471 
472     /**
473     @dev Initiate the team vesting by transferring the teamSupply t0 _teamVestingContractAddress
474     @param _teamVestingContractAddress  address of the team vesting contract alreadt deployed with the
475         beneficiary address
476     */
477     function initiateTeamVesting(address _teamVestingContractAddress)
478     external
479     onlyOwner
480     nonZeroAddress(_teamVestingContractAddress) {
481         require(!isTeamVestingInitiated);
482         teamVestingContractAddress = _teamVestingContractAddress;
483 
484         isTeamVestingInitiated = true;
485         //transfer team supply to team vesting contract
486         require(transfer(_teamVestingContractAddress, teamSupply));
487 
488 
489     }
490 
491     /**
492     @dev allow changing of loyalty wallet as these wallets might be used
493     externally by web apps to dispense loyalty rewards and may get compromised
494     @param _loyaltyWallet new loyalty wallet address
495     **/
496 
497     function setLoyaltyWallet(address _loyaltyWallet)
498     external
499     onlyOwner
500     nonZeroAddress(_loyaltyWallet){
501         require(loyaltyWallet != _loyaltyWallet);
502         loyaltyWallet = _loyaltyWallet;
503         LoyaltyWalletAddressChanged(loyaltyWallet, _loyaltyWallet);
504     }
505 
506     /**
507     @dev allocate loyalty as needed from loyalty pool into the current
508     loyalty wallet to be disbursed. Note only the allocation needed for a disbursment
509     is to be moved to the loyalty wallet as needed.
510     @param _totalWeiAmount  amount to move to the wallet in wei
511     **/
512     function allocateLoyaltySpend(uint256 _totalWeiAmount)
513     external
514     onlyOwner
515     nonZeroAddress(loyaltyWallet)
516     returns(bool){
517         require(_totalWeiAmount > 0 && loyaltySupply >= _totalWeiAmount);
518         loyaltySupply = loyaltySupply.sub(_totalWeiAmount);
519         require(transfer(loyaltyWallet, _totalWeiAmount));
520         LoyaltySupplyAllocated(loyaltyWallet, _totalWeiAmount);
521         return true;
522     }
523 
524     /**
525     @dev assign foundation supply to a contract address
526     @param _foundationContractAddress  contract address to dispense the
527             foundation alloction
528     **/
529     function assignFoundationSupply(address _foundationContractAddress)
530     external
531     onlyOwner
532     nonZeroAddress(_foundationContractAddress){
533         require(!isFoundationSupplyAssigned);
534         isFoundationSupplyAssigned = true;
535         require(transfer(_foundationContractAddress, foundationSupply));
536     }
537 
538     /**
539     @dev assign reserve supply to a contract address
540     @param _reserveContractAddress  contract address to dispense the
541             reserve alloction
542     **/
543     function assignReserveSupply(address _reserveContractAddress)
544     external
545     onlyOwner
546     nonZeroAddress(_reserveContractAddress){
547         require(!isReserveSupplyAssigned);
548         isReserveSupplyAssigned = true;
549         require(transfer(_reserveContractAddress, reserveFundSupply));
550     }
551 
552 /** We don't want to support a payable function as we are not doing ICO and instead doing private
553 sale. Therefore we want to maintain exchange rate that is pegged to USD.
554 **/
555 
556     function buyTokens(address _to, uint256 _totalWeiAmount, bytes4 _currency, bytes32 _txHash)
557     external
558     onlyTokenBuyer
559     nonZeroAddress(_to)
560     returns(bool) {
561         require(_totalWeiAmount > 0 && publicSaleSupply >= _totalWeiAmount);
562         publicSaleSupply = publicSaleSupply.sub(_totalWeiAmount);
563         require(transferFrom(owner,_to, _totalWeiAmount));
564         TokensBought(_to, _totalWeiAmount, _currency, _txHash);
565         return true;
566     }
567 
568     /**
569     @dev This unnamed function is called whenever someone tries to send ether to it  and we don't want payment
570     coming directly to the contracts
571     */
572     function () public payable {
573         revert();
574     }
575 
576 }