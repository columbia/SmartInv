1 pragma solidity ^0.4.12;
2 
3 //======  OpenZeppelin libraray =====
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
11     uint256 c = a * b;
12     assert(a == 0 || c / a == b);
13     return c;
14   }
15 
16   function div(uint256 a, uint256 b) internal constant returns (uint256) {
17     // assert(b > 0); // Solidity automatically throws when dividing by 0
18     uint256 c = a / b;
19     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal constant returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 }
34 
35 
36 /**
37  * @title ERC20Basic
38  * @dev Simpler version of ERC20 interface
39  * @dev see https://github.com/ethereum/EIPs/issues/179
40  */
41 contract ERC20Basic {
42   uint256 public totalSupply;
43   function balanceOf(address who) constant returns (uint256);
44   function transfer(address to, uint256 value) returns (bool);
45   event Transfer(address indexed from, address indexed to, uint256 value);
46 }
47 
48 /**
49  * @title ERC20 interface
50  * @dev see https://github.com/ethereum/EIPs/issues/20
51  */
52 contract ERC20 is ERC20Basic {
53   function allowance(address owner, address spender) constant returns (uint256);
54   function transferFrom(address from, address to, uint256 value) returns (bool);
55   function approve(address spender, uint256 value) returns (bool);
56   event Approval(address indexed owner, address indexed spender, uint256 value);
57 }
58 
59 /**
60  * @title SafeERC20
61  * @dev Wrappers around ERC20 operations that throw on failure.
62  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
63  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
64  */
65 library SafeERC20 {
66   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
67     assert(token.transfer(to, value));
68   }
69 
70   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
71     assert(token.transferFrom(from, to, value));
72   }
73 
74   function safeApprove(ERC20 token, address spender, uint256 value) internal {
75     assert(token.approve(spender, value));
76   }
77 }
78 
79 /**
80  * @title Ownable
81  * @dev The Ownable contract has an owner address, and provides basic authorization control
82  * functions, this simplifies the implementation of "user permissions".
83  */
84 contract Ownable {
85   address public owner;
86 
87 
88   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
89 
90 
91   /**
92    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
93    * account.
94    */
95   function Ownable() {
96     owner = msg.sender;
97   }
98 
99 
100   /**
101    * @dev Throws if called by any account other than the owner.
102    */
103   modifier onlyOwner() {
104     require(msg.sender == owner);
105     _;
106   }
107 
108 
109   /**
110    * @dev Allows the current owner to transfer control of the contract to a newOwner.
111    * @param newOwner The address to transfer ownership to.
112    */
113   function transferOwnership(address newOwner) onlyOwner {
114     require(newOwner != address(0));      
115     OwnershipTransferred(owner, newOwner);
116     owner = newOwner;
117   }
118 
119 }
120 
121 /** 
122  * @title Contracts that should not own Contracts
123  * @author Remco Bloemen <remco@2π.com>
124  * @dev Should contracts (anything Ownable) end up being owned by this contract, it allows the owner
125  * of this contract to reclaim ownership of the contracts.
126  */
127 contract HasNoContracts is Ownable {
128 
129   /**
130    * @dev Reclaim ownership of Ownable contracts
131    * @param contractAddr The address of the Ownable to be reclaimed.
132    */
133   function reclaimContract(address contractAddr) external onlyOwner {
134     Ownable contractInst = Ownable(contractAddr);
135     contractInst.transferOwnership(owner);
136   }
137 }
138 
139 /**
140  * @title Contracts that should be able to recover tokens
141  * @author SylTi
142  * @dev This allow a contract to recover any ERC20 token received in a contract by transfering the balance to the contract owner.
143  * This will prevent any accidental loss of tokens.
144  */
145 contract CanReclaimToken is Ownable {
146   using SafeERC20 for ERC20Basic;
147 
148   /**
149    * @dev Reclaim all ERC20Basic compatible tokens
150    * @param token ERC20Basic The address of the token contract
151    */
152   function reclaimToken(ERC20Basic token) external onlyOwner {
153     uint256 balance = token.balanceOf(this);
154     token.safeTransfer(owner, balance);
155   }
156 
157 }
158 
159 /**
160  * @title Contracts that should not own Tokens
161  * @author Remco Bloemen <remco@2π.com>
162  * @dev This blocks incoming ERC23 tokens to prevent accidental loss of tokens.
163  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
164  * owner to reclaim the tokens.
165  */
166 contract HasNoTokens is CanReclaimToken {
167 
168  /**
169   * @dev Reject all ERC23 compatible tokens
170   * param from_ address The address that is transferring the tokens
171   * param value_ uint256 the amount of the specified token
172   * param data_ Bytes The data passed from the caller.
173   */
174   function tokenFallback(address /*from_*/, uint256 /*value_*/, bytes /*data_*/) external {
175     revert();
176   }
177 
178 }
179 
180 /**
181  * @title Basic token
182  * @dev Basic version of StandardToken, with no allowances. 
183  */
184 contract BasicToken is ERC20Basic {
185   using SafeMath for uint256;
186 
187   mapping(address => uint256) balances;
188 
189   /**
190   * @dev transfer token for a specified address
191   * @param _to The address to transfer to.
192   * @param _value The amount to be transferred.
193   */
194   function transfer(address _to, uint256 _value) returns (bool) {
195     require(_to != address(0));
196 
197     // SafeMath.sub will throw if there is not enough balance.
198     balances[msg.sender] = balances[msg.sender].sub(_value);
199     balances[_to] = balances[_to].add(_value);
200     Transfer(msg.sender, _to, _value);
201     return true;
202   }
203 
204   /**
205   * @dev Gets the balance of the specified address.
206   * @param _owner The address to query the the balance of. 
207   * @return An uint256 representing the amount owned by the passed address.
208   */
209   function balanceOf(address _owner) constant returns (uint256 balance) {
210     return balances[_owner];
211   }
212 
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
224   mapping (address => mapping (address => uint256)) allowed;
225 
226 
227   /**
228    * @dev Transfer tokens from one address to another
229    * @param _from address The address which you want to send tokens from
230    * @param _to address The address which you want to transfer to
231    * @param _value uint256 the amount of tokens to be transferred
232    */
233   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
234     require(_to != address(0));
235 
236     var _allowance = allowed[_from][msg.sender];
237 
238     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
239     // require (_value <= _allowance);
240 
241     balances[_from] = balances[_from].sub(_value);
242     balances[_to] = balances[_to].add(_value);
243     allowed[_from][msg.sender] = _allowance.sub(_value);
244     Transfer(_from, _to, _value);
245     return true;
246   }
247 
248   /**
249    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
250    * @param _spender The address which will spend the funds.
251    * @param _value The amount of tokens to be spent.
252    */
253   function approve(address _spender, uint256 _value) returns (bool) {
254 
255     // To change the approve amount you first have to reduce the addresses`
256     //  allowance to zero by calling `approve(_spender, 0)` if it is not
257     //  already 0 to mitigate the race condition described here:
258     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
259     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
260 
261     allowed[msg.sender][_spender] = _value;
262     Approval(msg.sender, _spender, _value);
263     return true;
264   }
265 
266   /**
267    * @dev Function to check the amount of tokens that an owner allowed to a spender.
268    * @param _owner address The address which owns the funds.
269    * @param _spender address The address which will spend the funds.
270    * @return A uint256 specifying the amount of tokens still available for the spender.
271    */
272   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
273     return allowed[_owner][_spender];
274   }
275   
276   /**
277    * approve should be called when allowed[_spender] == 0. To increment
278    * allowed value is better to use this function to avoid 2 calls (and wait until 
279    * the first transaction is mined)
280    * From MonolithDAO Token.sol
281    */
282   function increaseApproval (address _spender, uint _addedValue) 
283     returns (bool success) {
284     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
285     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
286     return true;
287   }
288 
289   function decreaseApproval (address _spender, uint _subtractedValue) 
290     returns (bool success) {
291     uint oldValue = allowed[msg.sender][_spender];
292     if (_subtractedValue > oldValue) {
293       allowed[msg.sender][_spender] = 0;
294     } else {
295       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
296     }
297     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
298     return true;
299   }
300 
301 }
302 
303 /**
304  * @title Mintable token
305  * @dev Simple ERC20 Token example, with mintable token creation
306  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
307  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
308  */
309 
310 contract MintableToken is StandardToken, Ownable {
311   event Mint(address indexed to, uint256 amount);
312   event MintFinished();
313 
314   bool public mintingFinished = false;
315 
316 
317   modifier canMint() {
318     require(!mintingFinished);
319     _;
320   }
321 
322   /**
323    * @dev Function to mint tokens
324    * @param _to The address that will receive the minted tokens.
325    * @param _amount The amount of tokens to mint.
326    * @return A boolean that indicates if the operation was successful.
327    */
328   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
329     totalSupply = totalSupply.add(_amount);
330     balances[_to] = balances[_to].add(_amount);
331     Mint(_to, _amount);
332     Transfer(0x0, _to, _amount);
333     return true;
334   }
335 
336   /**
337    * @dev Function to stop minting new tokens.
338    * @return True if the operation was successful.
339    */
340   function finishMinting() onlyOwner returns (bool) {
341     mintingFinished = true;
342     MintFinished();
343     return true;
344   }
345 }
346 
347 //======  MatreXa =====
348 
349 contract BurnableToken is StandardToken {
350     using SafeMath for uint256;
351 
352     event Burn(address indexed from, uint256 amount);
353     event BurnRewardIncreased(address indexed from, uint256 value);
354 
355     /**
356     * @dev Sending ether to contract increases burning reward 
357     */
358     function() payable {
359         if(msg.value > 0){
360             BurnRewardIncreased(msg.sender, msg.value);    
361         }
362     }
363 
364     /**
365      * @dev Calculates how much ether one will receive in reward for burning tokens
366      * @param _amount of tokens to be burned
367      */
368     function burnReward(uint256 _amount) public constant returns(uint256){
369         return this.balance.mul(_amount).div(totalSupply);
370     }
371 
372     /**
373     * @dev Burns tokens and send reward
374     * This is internal function because it DOES NOT check 
375     * if _from has allowance to burn tokens.
376     * It is intended to be used in transfer() and transferFrom() which do this check.
377     * @param _from The address which you want to burn tokens from
378     * @param _amount of tokens to be burned
379     */
380     function burn(address _from, uint256 _amount) internal returns(bool){
381         require(balances[_from] >= _amount);
382         
383         uint256 reward = burnReward(_amount);
384         assert(this.balance - reward > 0);
385 
386         balances[_from] = balances[_from].sub(_amount);
387         totalSupply = totalSupply.sub(_amount);
388         //assert(totalSupply >= 0); //Check is not needed because totalSupply.sub(value) will already throw if this condition is not met
389         
390         _from.transfer(reward);
391         Burn(_from, _amount);
392         return true;
393     }
394 
395     /**
396     * @dev Transfers or burns tokens
397     * Burns tokens transferred to this contract itself or to zero address
398     * @param _to The address to transfer to or token contract address to burn.
399     * @param _value The amount to be transferred.
400     */
401     function transfer(address _to, uint256 _value) returns (bool) {
402         if( (_to == address(this)) || (_to == 0) ){
403             return burn(msg.sender, _value);
404         }else{
405             return super.transfer(_to, _value);
406         }
407     }
408 
409     /**
410     * @dev Transfer tokens from one address to another 
411     * or burns them if _to is this contract or zero address
412     * @param _from address The address which you want to send tokens from
413     * @param _to address The address which you want to transfer to
414     * @param _value uint256 the amout of tokens to be transfered
415     */
416     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
417         if( (_to == address(this)) || (_to == 0) ){
418             var _allowance = allowed[_from][msg.sender];
419             //require (_value <= _allowance); //Check is not needed because _allowance.sub(_value) will already throw if this condition is not met
420             allowed[_from][msg.sender] = _allowance.sub(_value);
421             return burn(_from, _value);
422         }else{
423             return super.transferFrom(_from, _to, _value);
424         }
425     }
426 
427 }
428 
429 /**
430  * @title MatreXa Token
431  */
432 contract MatreXaToken is BurnableToken, MintableToken, HasNoContracts, HasNoTokens { //MintableToken is StandardToken, Ownable
433     using SafeMath for uint256;
434 
435     string public name = "MatreXa";
436     string public symbol = "MTRX";
437     uint256 public decimals = 18;
438 
439     uint256 public allowTransferTimestamp = 0;
440 
441     modifier canTransfer() {
442         require(mintingFinished);
443         require(now > allowTransferTimestamp);
444         _;
445     }
446 
447     function setAllowTransferTimestamp(uint256 _allowTransferTimestamp) onlyOwner {
448         require(allowTransferTimestamp == 0);
449         allowTransferTimestamp = _allowTransferTimestamp;
450     }
451     
452     function transfer(address _to, uint256 _value) canTransfer returns (bool) {
453         BurnableToken.transfer(_to, _value);
454     }
455 
456     function transferFrom(address _from, address _to, uint256 _value) canTransfer returns (bool) {
457         BurnableToken.transferFrom(_from, _to, _value);
458     }
459 
460 }
461 
462 /**
463  * @title MatreXa Crowdsale
464  */
465 contract MatreXaCrowdsale is Ownable, HasNoContracts, HasNoTokens {
466     using SafeMath for uint256;
467 
468     //use https://www.myetherwallet.com/helpers.html for simple coversion to/from wei
469     uint256 constant public MAX_GAS_PRICE  = 50000000000 wei;    //Maximum gas price for contribution transactions
470     uint256 public goal;                                         //Amount of ether (in wei) to receive for crowdsale to be successful
471 
472     MatreXaToken public mtrx;
473 
474     uint256 public availableSupply;     //tokens left to sale
475     uint256 public startTimestamp;      //start crowdsale timestamp
476     uint256 public endTimestamp;        //after this timestamp no contributions will be accepted and if minimum cap not reached refunds may be claimed
477     uint256 public totalCollected;      //total amount of collected funds (in ethereum wei)
478     uint256[] public periods;           //periods of crowdsale with different prices
479     uint256[] public prices;            //prices of each crowdsale periods
480     bool public finalized;              //crowdsale is finalized
481     
482     mapping(address => uint256) contributions; //amount of ether (in wei)received from a contributor
483 
484     event LogSale(address indexed to, uint256 eth, uint256 tokens);
485 
486     /**
487      * @dev Asserts crowdsale goal is reached
488      */
489     modifier goalReached(){
490         require(totalCollected >= goal);
491         _;
492     }
493 
494     /**
495      * @dev Asserts crowdsale is finished, but goal not reached 
496      */
497     modifier crowdsaleFailed(){
498         require(totalCollected < goal);
499         require(now > endTimestamp);
500         _;
501     }
502 
503     /**
504      * Throws if crowdsale is not running: not started, ended or max cap reached
505      */
506     modifier crowdsaleIsRunning(){
507         // require(now > startTimestamp);
508         // require(now <= endTimestamp);
509         // require(availableSupply > 0);
510         // require(!finalized);
511         require(crowdsaleRunning());
512         _;
513     }
514 
515     /**
516     * verifies that the gas price is lower than 50 gwei
517     */
518     modifier validGasPrice() {
519         assert(tx.gasprice <= MAX_GAS_PRICE);
520         _;
521     }
522 
523     /**
524      * @dev MatreXa Crowdsale Contract
525      * @param _startTimestamp Start crowdsale timestamp
526      * @param _periods Array of timestamps when a corresponding price is no longer valid. Last timestamp is the last date of ICO
527      * @param _prices Array of prices (how many token units one will receive per wei) corrsponding to thresholds.
528      * @param _goal Amount of ether (in wei) to receive for crowdsale to be successful
529      * @param _ownerTokens Amount of MTRX tokens (in wei) minted to owner
530      * @param _availableSupply Amount of MTRX tokens (in wei) to distribute during ICO
531      * @param _allowTransferTimestamp timestamp after wich transfer of tokens should be allowed
532      */
533     function MatreXaCrowdsale(
534         uint256 _startTimestamp, 
535         uint256[] _periods,
536         uint256[] _prices, 
537         uint256 _goal,
538         uint256 _ownerTokens,
539         uint256 _availableSupply,
540         uint256 _allowTransferTimestamp
541     ) {
542 
543         require(_periods.length > 0);                   //There should be at least one period
544         require(_startTimestamp < _periods[0]);         //Start should be before first period end
545         require(_prices.length == _periods.length);     //Each period should have corresponding price
546 
547         startTimestamp = _startTimestamp;
548         endTimestamp = _periods[_periods.length - 1];
549         periods = _periods;
550         prices = _prices;
551 
552         goal = _goal;
553         availableSupply = _availableSupply;
554         
555         uint256 reachableCap = availableSupply.mul(_prices[0]);   //find how much ether can be collected in first period
556         require(reachableCap > goal);           //Check if it is possible to reach minimumCap (not accurate check, but it's ok) 
557 
558         mtrx = new MatreXaToken();
559         mtrx.setAllowTransferTimestamp(_allowTransferTimestamp);
560         mtrx.mint(owner, _ownerTokens);
561     }
562 
563     /**
564     * @dev Calculates current price rate (how many MTRX you get for 1 ETH)
565     * @return calculated price or zero if crodsale not started or finished
566     */
567     function currentPrice() constant public returns(uint256) {
568         if( (now < startTimestamp) || finalized) return 0;
569         for(uint i=0; i < periods.length; i++){
570             if(now < periods[i]){
571                 return prices[i];
572             }
573         }
574         return 0;
575     }
576     /**
577     * @dev Shows if crowdsale is running
578     */ 
579     function crowdsaleRunning() constant public returns(bool){
580         return  (now > startTimestamp) &&  (now <= endTimestamp) && (availableSupply > 0) && !finalized;
581     }
582     /**
583     * @dev Buy MatreXa tokens
584     */
585     function() payable validGasPrice crowdsaleIsRunning {
586         require(msg.value > 0);
587         uint256 price = currentPrice();
588         assert(price > 0);
589         uint256 tokens = price.mul(msg.value);
590         assert(tokens > 0);
591         require(availableSupply - tokens >= 0);
592 
593         contributions[msg.sender] = contributions[msg.sender].add(msg.value);
594         totalCollected = totalCollected.add(msg.value);
595         availableSupply = availableSupply.sub(tokens);
596         mtrx.mint(msg.sender, tokens);
597         LogSale(msg.sender, msg.value, tokens);
598     } 
599 
600     /**
601     * @dev Sends all contributed ether back if minimum cap is not reached by the end of crowdsale
602     */
603     function claimRefund() public crowdsaleFailed {
604         require(contributions[msg.sender] > 0);
605 
606         uint256 refund = contributions[msg.sender];
607         contributions[msg.sender] = 0;
608         msg.sender.transfer(refund);
609     }
610 
611     /**
612     * @dev Sends collected funds to owner
613     * May be executed only if goal reached and no refunds are possible
614     */
615     function withdrawFunds(uint256 amount) public onlyOwner goalReached {
616         msg.sender.transfer(amount);
617     }
618 
619     /**
620     * @dev Finalizes ICO when one of conditions met:
621     * - end time reached OR
622     * - no more tokens available (cap reached) OR
623     * - message sent by owner
624     */
625     function finalizeCrowdfunding() public {
626         require ( (now > endTimestamp) || (availableSupply == 0) || (msg.sender == owner) );
627         finalized = mtrx.finishMinting();
628         mtrx.transferOwnership(owner);
629     } 
630 
631 }