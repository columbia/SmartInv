1 pragma solidity ^0.4.12;
2 /* MatreXa ICO contracts. version 2017-09-11 */
3 
4 //======  OpenZeppelin libraray =====
5 
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
12     uint256 c = a * b;
13     assert(a == 0 || c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal constant returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal constant returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 
37 /**
38  * @title ERC20Basic
39  * @dev Simpler version of ERC20 interface
40  * @dev see https://github.com/ethereum/EIPs/issues/179
41  */
42 contract ERC20Basic {
43   uint256 public totalSupply;
44   function balanceOf(address who) constant returns (uint256);
45   function transfer(address to, uint256 value) returns (bool);
46   event Transfer(address indexed from, address indexed to, uint256 value);
47 }
48 
49 /**
50  * @title ERC20 interface
51  * @dev see https://github.com/ethereum/EIPs/issues/20
52  */
53 contract ERC20 is ERC20Basic {
54   function allowance(address owner, address spender) constant returns (uint256);
55   function transferFrom(address from, address to, uint256 value) returns (bool);
56   function approve(address spender, uint256 value) returns (bool);
57   event Approval(address indexed owner, address indexed spender, uint256 value);
58 }
59 
60 /**
61  * @title SafeERC20
62  * @dev Wrappers around ERC20 operations that throw on failure.
63  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
64  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
65  */
66 library SafeERC20 {
67   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
68     assert(token.transfer(to, value));
69   }
70 
71   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
72     assert(token.transferFrom(from, to, value));
73   }
74 
75   function safeApprove(ERC20 token, address spender, uint256 value) internal {
76     assert(token.approve(spender, value));
77   }
78 }
79 
80 /**
81  * @title Ownable
82  * @dev The Ownable contract has an owner address, and provides basic authorization control
83  * functions, this simplifies the implementation of "user permissions".
84  */
85 contract Ownable {
86   address public owner;
87 
88 
89   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
90 
91 
92   /**
93    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
94    * account.
95    */
96   function Ownable() {
97     owner = msg.sender;
98   }
99 
100 
101   /**
102    * @dev Throws if called by any account other than the owner.
103    */
104   modifier onlyOwner() {
105     require(msg.sender == owner);
106     _;
107   }
108 
109 
110   /**
111    * @dev Allows the current owner to transfer control of the contract to a newOwner.
112    * @param newOwner The address to transfer ownership to.
113    */
114   function transferOwnership(address newOwner) onlyOwner {
115     require(newOwner != address(0));      
116     OwnershipTransferred(owner, newOwner);
117     owner = newOwner;
118   }
119 
120 }
121 
122 /** 
123  * @title Contracts that should not own Contracts
124  * @author Remco Bloemen <remco@2π.com>
125  * @dev Should contracts (anything Ownable) end up being owned by this contract, it allows the owner
126  * of this contract to reclaim ownership of the contracts.
127  */
128 contract HasNoContracts is Ownable {
129 
130   /**
131    * @dev Reclaim ownership of Ownable contracts
132    * @param contractAddr The address of the Ownable to be reclaimed.
133    */
134   function reclaimContract(address contractAddr) external onlyOwner {
135     Ownable contractInst = Ownable(contractAddr);
136     contractInst.transferOwnership(owner);
137   }
138 }
139 
140 /**
141  * @title Contracts that should be able to recover tokens
142  * @author SylTi
143  * @dev This allow a contract to recover any ERC20 token received in a contract by transfering the balance to the contract owner.
144  * This will prevent any accidental loss of tokens.
145  */
146 contract CanReclaimToken is Ownable {
147   using SafeERC20 for ERC20Basic;
148 
149   /**
150    * @dev Reclaim all ERC20Basic compatible tokens
151    * @param token ERC20Basic The address of the token contract
152    */
153   function reclaimToken(ERC20Basic token) external onlyOwner {
154     uint256 balance = token.balanceOf(this);
155     token.safeTransfer(owner, balance);
156   }
157 
158 }
159 
160 /**
161  * @title Contracts that should not own Tokens
162  * @author Remco Bloemen <remco@2π.com>
163  * @dev This blocks incoming ERC23 tokens to prevent accidental loss of tokens.
164  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
165  * owner to reclaim the tokens.
166  */
167 contract HasNoTokens is CanReclaimToken {
168 
169  /**
170   * @dev Reject all ERC23 compatible tokens
171   * param from_ address The address that is transferring the tokens
172   * param value_ uint256 the amount of the specified token
173   * param data_ Bytes The data passed from the caller.
174   */
175   function tokenFallback(address /*from_*/, uint256 /*value_*/, bytes /*data_*/) external {
176     revert();
177   }
178 
179 }
180 
181 /**
182  * @title Basic token
183  * @dev Basic version of StandardToken, with no allowances. 
184  */
185 contract BasicToken is ERC20Basic {
186   using SafeMath for uint256;
187 
188   mapping(address => uint256) balances;
189 
190   /**
191   * @dev transfer token for a specified address
192   * @param _to The address to transfer to.
193   * @param _value The amount to be transferred.
194   */
195   function transfer(address _to, uint256 _value) returns (bool) {
196     require(_to != address(0));
197 
198     // SafeMath.sub will throw if there is not enough balance.
199     balances[msg.sender] = balances[msg.sender].sub(_value);
200     balances[_to] = balances[_to].add(_value);
201     Transfer(msg.sender, _to, _value);
202     return true;
203   }
204 
205   /**
206   * @dev Gets the balance of the specified address.
207   * @param _owner The address to query the the balance of. 
208   * @return An uint256 representing the amount owned by the passed address.
209   */
210   function balanceOf(address _owner) constant returns (uint256 balance) {
211     return balances[_owner];
212   }
213 
214 }
215 
216 /**
217  * @title Standard ERC20 token
218  *
219  * @dev Implementation of the basic standard token.
220  * @dev https://github.com/ethereum/EIPs/issues/20
221  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
222  */
223 contract StandardToken is ERC20, BasicToken {
224 
225   mapping (address => mapping (address => uint256)) allowed;
226 
227 
228   /**
229    * @dev Transfer tokens from one address to another
230    * @param _from address The address which you want to send tokens from
231    * @param _to address The address which you want to transfer to
232    * @param _value uint256 the amount of tokens to be transferred
233    */
234   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
235     require(_to != address(0));
236 
237     var _allowance = allowed[_from][msg.sender];
238 
239     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
240     // require (_value <= _allowance);
241 
242     balances[_from] = balances[_from].sub(_value);
243     balances[_to] = balances[_to].add(_value);
244     allowed[_from][msg.sender] = _allowance.sub(_value);
245     Transfer(_from, _to, _value);
246     return true;
247   }
248 
249   /**
250    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
251    * @param _spender The address which will spend the funds.
252    * @param _value The amount of tokens to be spent.
253    */
254   function approve(address _spender, uint256 _value) returns (bool) {
255 
256     // To change the approve amount you first have to reduce the addresses`
257     //  allowance to zero by calling `approve(_spender, 0)` if it is not
258     //  already 0 to mitigate the race condition described here:
259     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
260     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
261 
262     allowed[msg.sender][_spender] = _value;
263     Approval(msg.sender, _spender, _value);
264     return true;
265   }
266 
267   /**
268    * @dev Function to check the amount of tokens that an owner allowed to a spender.
269    * @param _owner address The address which owns the funds.
270    * @param _spender address The address which will spend the funds.
271    * @return A uint256 specifying the amount of tokens still available for the spender.
272    */
273   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
274     return allowed[_owner][_spender];
275   }
276   
277   /**
278    * approve should be called when allowed[_spender] == 0. To increment
279    * allowed value is better to use this function to avoid 2 calls (and wait until 
280    * the first transaction is mined)
281    * From MonolithDAO Token.sol
282    */
283   function increaseApproval (address _spender, uint _addedValue) 
284     returns (bool success) {
285     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
286     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
287     return true;
288   }
289 
290   function decreaseApproval (address _spender, uint _subtractedValue) 
291     returns (bool success) {
292     uint oldValue = allowed[msg.sender][_spender];
293     if (_subtractedValue > oldValue) {
294       allowed[msg.sender][_spender] = 0;
295     } else {
296       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
297     }
298     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
299     return true;
300   }
301 
302 }
303 
304 /**
305  * @title Mintable token
306  * @dev Simple ERC20 Token example, with mintable token creation
307  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
308  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
309  */
310 
311 contract MintableToken is StandardToken, Ownable {
312   event Mint(address indexed to, uint256 amount);
313   event MintFinished();
314 
315   bool public mintingFinished = false;
316 
317 
318   modifier canMint() {
319     require(!mintingFinished);
320     _;
321   }
322 
323   /**
324    * @dev Function to mint tokens
325    * @param _to The address that will receive the minted tokens.
326    * @param _amount The amount of tokens to mint.
327    * @return A boolean that indicates if the operation was successful.
328    */
329   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
330     totalSupply = totalSupply.add(_amount);
331     balances[_to] = balances[_to].add(_amount);
332     Mint(_to, _amount);
333     Transfer(0x0, _to, _amount);
334     return true;
335   }
336 
337   /**
338    * @dev Function to stop minting new tokens.
339    * @return True if the operation was successful.
340    */
341   function finishMinting() onlyOwner returns (bool) {
342     mintingFinished = true;
343     MintFinished();
344     return true;
345   }
346 }
347 
348 //======  MatreXa =====
349 
350 contract BurnableToken is StandardToken {
351     using SafeMath for uint256;
352 
353     event Burn(address indexed from, uint256 amount);
354     event BurnRewardIncreased(address indexed from, uint256 value);
355 
356     /**
357     * @dev Sending ether to contract increases burning reward 
358     */
359     function() payable {
360         if(msg.value > 0){
361             BurnRewardIncreased(msg.sender, msg.value);    
362         }
363     }
364 
365     /**
366      * @dev Calculates how much ether one will receive in reward for burning tokens
367      * @param _amount of tokens to be burned
368      */
369     function burnReward(uint256 _amount) public constant returns(uint256){
370         return this.balance.mul(_amount).div(totalSupply);
371     }
372 
373     /**
374     * @dev Burns tokens and send reward
375     * This is internal function because it DOES NOT check 
376     * if _from has allowance to burn tokens.
377     * It is intended to be used in transfer() and transferFrom() which do this check.
378     * @param _from The address which you want to burn tokens from
379     * @param _amount of tokens to be burned
380     */
381     function burn(address _from, uint256 _amount) internal returns(bool){
382         require(balances[_from] >= _amount);
383         
384         uint256 reward = burnReward(_amount);
385         assert(this.balance - reward > 0);
386 
387         balances[_from] = balances[_from].sub(_amount);
388         totalSupply = totalSupply.sub(_amount);
389         //assert(totalSupply >= 0); //Check is not needed because totalSupply.sub(value) will already throw if this condition is not met
390         
391         _from.transfer(reward);
392         Transfer(_from, 0x0, _amount);
393         Burn(_from, _amount);
394         return true;
395     }
396 
397     /**
398     * @dev Transfers or burns tokens
399     * Burns tokens transferred to this contract itself or to zero address
400     * @param _to The address to transfer to or token contract address to burn.
401     * @param _value The amount to be transferred.
402     */
403     function transfer(address _to, uint256 _value) returns (bool) {
404         if( (_to == address(this)) || (_to == 0) ){
405             return burn(msg.sender, _value);
406         }else{
407             return super.transfer(_to, _value);
408         }
409     }
410 
411     /**
412     * @dev Transfer tokens from one address to another 
413     * or burns them if _to is this contract or zero address
414     * @param _from address The address which you want to send tokens from
415     * @param _to address The address which you want to transfer to
416     * @param _value uint256 the amout of tokens to be transfered
417     */
418     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
419         if( (_to == address(this)) || (_to == 0) ){
420             var _allowance = allowed[_from][msg.sender];
421             //require (_value <= _allowance); //Check is not needed because _allowance.sub(_value) will already throw if this condition is not met
422             allowed[_from][msg.sender] = _allowance.sub(_value);
423             return burn(_from, _value);
424         }else{
425             return super.transferFrom(_from, _to, _value);
426         }
427     }
428 
429 }
430 
431 /**
432  * @title MatreXa Token
433  */
434 contract MatreXaToken is BurnableToken, MintableToken, HasNoContracts, HasNoTokens { //MintableToken is StandardToken, Ownable
435     using SafeMath for uint256;
436 
437     string public name = "MatreXa";
438     string public symbol = "MTRX";
439     uint256 public decimals = 18;
440 
441     address public founder;
442     uint256 public allowTransferTimestamp = 0;
443 
444     /**
445     * We dissable token transfer during ICO and some time after ICO.
446     * But we allow founder to transfer his tokens to pay bounties, etc.
447     */
448     modifier canTransfer() {
449         if(msg.sender != founder) {
450             require(mintingFinished);
451             require(now > allowTransferTimestamp);
452         }
453         _;
454     }
455     /**
456     * @dev set Founder address
457     * Only owner allowed to do this
458     */
459     function setFounder(address _founder) onlyOwner {
460         founder = _founder;
461     }    
462     
463     /**
464     * @dev set the timestamp when trasfers will be allowed
465     * Only owner allowed to do this
466     * This is allowed only once to prevent owner to pause transfers at will
467     */
468     function setAllowTransferTimestamp(uint256 _allowTransferTimestamp) onlyOwner {
469         require(allowTransferTimestamp == 0);
470         allowTransferTimestamp = _allowTransferTimestamp;
471     }
472     
473     function transfer(address _to, uint256 _value) canTransfer returns (bool) {
474         BurnableToken.transfer(_to, _value);
475     }
476 
477     function transferFrom(address _from, address _to, uint256 _value) canTransfer returns (bool) {
478         BurnableToken.transferFrom(_from, _to, _value);
479     }
480 
481 }
482 
483 /**
484  * @title MatreXa Crowdsale
485  */
486 contract MatreXaCrowdsale is Ownable, HasNoContracts, HasNoTokens {
487     using SafeMath for uint256;
488 
489     //use https://www.myetherwallet.com/helpers.html for simple coversion to/from wei
490     uint256 constant public MAX_GAS_PRICE  = 50000000000 wei;    //Maximum gas price for contribution transactions
491     uint256 public goal;                                         //Amount of ether (in wei) to receive for crowdsale to be successful
492 
493     MatreXaToken public mtrx;
494 
495     uint256 public availableSupply;     //tokens left to sale
496     uint256 public startTimestamp;      //start crowdsale timestamp
497     uint256 public endTimestamp;        //after this timestamp no contributions will be accepted and if minimum cap not reached refunds may be claimed
498     uint256 public totalCollected;      //total amount of collected funds (in ethereum wei)
499     uint256[] public periods;           //periods of crowdsale with different prices
500     uint256[] public prices;            //prices of each crowdsale periods
501     bool public finalized;              //crowdsale is finalized
502     
503     mapping(address => uint256) contributions; //amount of ether (in wei)received from a contributor
504 
505     /**
506     * event for token purchase logging
507     * @param purchaser who paid for the tokens
508     * @param value weis paid for purchase
509     * @param amount amount of tokens purchased
510     */ 
511     event TokenPurchase(address indexed purchaser, uint256 value, uint256 amount);
512 
513     /**
514      * @dev Asserts crowdsale goal is reached
515      */
516     modifier goalReached(){
517         require(totalCollected >= goal);
518         _;
519     }
520 
521     /**
522      * @dev Asserts crowdsale is finished, but goal not reached 
523      */
524     modifier crowdsaleFailed(){
525         require(totalCollected < goal);
526         require(now > endTimestamp);
527         _;
528     }
529 
530     /**
531      * Throws if crowdsale is not running: not started, ended or max cap reached
532      */
533     modifier crowdsaleIsRunning(){
534         // require(now > startTimestamp);
535         // require(now <= endTimestamp);
536         // require(availableSupply > 0);
537         // require(!finalized);
538         require(crowdsaleRunning());
539         _;
540     }
541 
542     /**
543     * verifies that the gas price is lower than 50 gwei
544     */
545     modifier validGasPrice() {
546         assert(tx.gasprice <= MAX_GAS_PRICE);
547         _;
548     }
549 
550     /**
551      * @dev MatreXa Crowdsale Contract
552      * @param _startTimestamp Start crowdsale timestamp
553      * @param _periods Array of timestamps when a corresponding price is no longer valid. Last timestamp is the last date of ICO
554      * @param _prices Array of prices (how many token units one will receive per wei) corrsponding to thresholds.
555      * @param _goal Amount of ether (in wei) to receive for crowdsale to be successful
556      * @param _ownerTokens Amount of MTRX tokens (in wei) minted to owner
557      * @param _availableSupply Amount of MTRX tokens (in wei) to distribute during ICO
558      * @param _allowTransferTimestamp timestamp after wich transfer of tokens should be allowed
559      */
560     function MatreXaCrowdsale(
561         uint256 _startTimestamp, 
562         uint256[] _periods,
563         uint256[] _prices, 
564         uint256 _goal,
565         uint256 _ownerTokens,
566         uint256 _availableSupply,
567         uint256 _allowTransferTimestamp
568     ) {
569 
570         require(_periods.length > 0);                   //There should be at least one period
571         require(_startTimestamp < _periods[0]);         //Start should be before first period end
572         require(_prices.length == _periods.length);     //Each period should have corresponding price
573 
574         startTimestamp = _startTimestamp;
575         endTimestamp = _periods[_periods.length - 1];
576         periods = _periods;
577         prices = _prices;
578 
579         goal = _goal;
580         availableSupply = _availableSupply;
581         
582         uint256 reachableCap = availableSupply.mul(_prices[0]);   //find how much ether can be collected in first period
583         require(reachableCap > goal);           //Check if it is possible to reach minimumCap (not accurate check, but it's ok) 
584 
585         mtrx = new MatreXaToken();
586         mtrx.setAllowTransferTimestamp(_allowTransferTimestamp);
587         mtrx.setFounder(owner);
588         mtrx.mint(owner, _ownerTokens);
589     }
590 
591     /**
592     * @dev Calculates current price rate (how many MTRX you get for 1 ETH)
593     * @return calculated price or zero if crodsale not started or finished
594     */
595     function currentPrice() constant public returns(uint256) {
596         if( (now < startTimestamp) || finalized) return 0;
597         for(uint i=0; i < periods.length; i++){
598             if(now < periods[i]){
599                 return prices[i];
600             }
601         }
602         return 0;
603     }
604     /**
605     * @dev Shows if crowdsale is running
606     */ 
607     function crowdsaleRunning() constant public returns(bool){
608         return  (now > startTimestamp) &&  (now <= endTimestamp) && (availableSupply > 0) && !finalized;
609     }
610     /**
611     * @dev Buy MatreXa tokens
612     */
613     function() payable validGasPrice crowdsaleIsRunning {
614         require(msg.value > 0);
615         uint256 price = currentPrice();
616         assert(price > 0);
617         uint256 tokens = price.mul(msg.value);
618         assert(tokens > 0);
619         require(availableSupply - tokens >= 0);
620 
621         contributions[msg.sender] = contributions[msg.sender].add(msg.value);
622         totalCollected = totalCollected.add(msg.value);
623         availableSupply = availableSupply.sub(tokens);
624         mtrx.mint(msg.sender, tokens);
625         TokenPurchase(msg.sender, msg.value, tokens);
626     } 
627 
628     /**
629     * @dev Sends all contributed ether back if minimum cap is not reached by the end of crowdsale
630     */
631     function claimRefund() public crowdsaleFailed {
632         require(contributions[msg.sender] > 0);
633 
634         uint256 refund = contributions[msg.sender];
635         contributions[msg.sender] = 0;
636         msg.sender.transfer(refund);
637     }
638 
639     /**
640     * @dev Sends collected funds to owner
641     * May be executed only if goal reached and no refunds are possible
642     */
643     function withdrawFunds(uint256 amount) public onlyOwner goalReached {
644         msg.sender.transfer(amount);
645     }
646 
647     /**
648     * @dev Finalizes ICO when one of conditions met:
649     * - end time reached OR
650     * - no more tokens available (cap reached) OR
651     * - message sent by owner
652     */
653     function finalizeCrowdfunding() public {
654         require ( (now > endTimestamp) || (availableSupply == 0) || (msg.sender == owner) );
655         finalized = mtrx.finishMinting();
656         mtrx.transferOwnership(owner);
657     } 
658 
659 }