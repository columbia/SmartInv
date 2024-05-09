1 pragma solidity ^0.4.18;
2 
3 //====== Open Zeppelin Library =====
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 /**
38  * @title ERC20Basic
39  * @dev Simpler version of ERC20 interface
40  * @dev see https://github.com/ethereum/EIPs/issues/179
41  */
42 contract ERC20Basic {
43   uint256 public totalSupply;
44   function balanceOf(address who) public view returns (uint256);
45   function transfer(address to, uint256 value) public returns (bool);
46   event Transfer(address indexed from, address indexed to, uint256 value);
47 }
48 
49 /**
50  * @title ERC20 interface
51  * @dev see https://github.com/ethereum/EIPs/issues/20
52  */
53 contract ERC20 is ERC20Basic {
54   function allowance(address owner, address spender) public view returns (uint256);
55   function transferFrom(address from, address to, uint256 value) public returns (bool);
56   function approve(address spender, uint256 value) public returns (bool);
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
96   function Ownable() public {
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
114   function transferOwnership(address newOwner) public onlyOwner {
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
143  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
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
171   * @param from_ address The address that is transferring the tokens
172   * @param value_ uint256 the amount of the specified token
173   * @param data_ Bytes The data passed from the caller.
174   */
175   function tokenFallback(address from_, uint256 value_, bytes data_) external {
176     from_;
177     value_;
178     data_;
179     revert();
180   }
181 
182 }
183 
184 /**
185  * @title Basic token
186  * @dev Basic version of StandardToken, with no allowances.
187  */
188 contract BasicToken is ERC20Basic {
189   using SafeMath for uint256;
190 
191   mapping(address => uint256) balances;
192 
193   /**
194   * @dev transfer token for a specified address
195   * @param _to The address to transfer to.
196   * @param _value The amount to be transferred.
197   */
198   function transfer(address _to, uint256 _value) public returns (bool) {
199     require(_to != address(0));
200     require(_value <= balances[msg.sender]);
201 
202     // SafeMath.sub will throw if there is not enough balance.
203     balances[msg.sender] = balances[msg.sender].sub(_value);
204     balances[_to] = balances[_to].add(_value);
205     Transfer(msg.sender, _to, _value);
206     return true;
207   }
208 
209   /**
210   * @dev Gets the balance of the specified address.
211   * @param _owner The address to query the the balance of.
212   * @return An uint256 representing the amount owned by the passed address.
213   */
214   function balanceOf(address _owner) public view returns (uint256 balance) {
215     return balances[_owner];
216   }
217 
218 }
219 
220 /**
221  * @title Standard ERC20 token
222  *
223  * @dev Implementation of the basic standard token.
224  * @dev https://github.com/ethereum/EIPs/issues/20
225  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
226  */
227 contract StandardToken is ERC20, BasicToken {
228 
229   mapping (address => mapping (address => uint256)) internal allowed;
230 
231 
232   /**
233    * @dev Transfer tokens from one address to another
234    * @param _from address The address which you want to send tokens from
235    * @param _to address The address which you want to transfer to
236    * @param _value uint256 the amount of tokens to be transferred
237    */
238   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
239     require(_to != address(0));
240     require(_value <= balances[_from]);
241     require(_value <= allowed[_from][msg.sender]);
242 
243     balances[_from] = balances[_from].sub(_value);
244     balances[_to] = balances[_to].add(_value);
245     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
246     Transfer(_from, _to, _value);
247     return true;
248   }
249 
250   /**
251    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
252    *
253    * Beware that changing an allowance with this method brings the risk that someone may use both the old
254    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
255    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
256    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
257    * @param _spender The address which will spend the funds.
258    * @param _value The amount of tokens to be spent.
259    */
260   function approve(address _spender, uint256 _value) public returns (bool) {
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
272   function allowance(address _owner, address _spender) public view returns (uint256) {
273     return allowed[_owner][_spender];
274   }
275 
276   /**
277    * approve should be called when allowed[_spender] == 0. To increment
278    * allowed value is better to use this function to avoid 2 calls (and wait until
279    * the first transaction is mined)
280    * From MonolithDAO Token.sol
281    */
282   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
283     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
284     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
285     return true;
286   }
287 
288   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
289     uint oldValue = allowed[msg.sender][_spender];
290     if (_subtractedValue > oldValue) {
291       allowed[msg.sender][_spender] = 0;
292     } else {
293       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
294     }
295     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
296     return true;
297   }
298 
299 }
300 
301 /**
302  * @title Mintable token
303  * @dev Simple ERC20 Token example, with mintable token creation
304  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
305  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
306  */
307 
308 contract MintableToken is StandardToken, Ownable {
309   event Mint(address indexed to, uint256 amount);
310   event MintFinished();
311 
312   bool public mintingFinished = false;
313 
314 
315   modifier canMint() {
316     require(!mintingFinished);
317     _;
318   }
319 
320   /**
321    * @dev Function to mint tokens
322    * @param _to The address that will receive the minted tokens.
323    * @param _amount The amount of tokens to mint.
324    * @return A boolean that indicates if the operation was successful.
325    */
326   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
327     totalSupply = totalSupply.add(_amount);
328     balances[_to] = balances[_to].add(_amount);
329     Mint(_to, _amount);
330     Transfer(address(0), _to, _amount);
331     return true;
332   }
333 
334   /**
335    * @dev Function to stop minting new tokens.
336    * @return True if the operation was successful.
337    */
338   function finishMinting() onlyOwner canMint public returns (bool) {
339     mintingFinished = true;
340     MintFinished();
341     return true;
342   }
343 }
344 
345 //====== AGRE Contracts =====
346 
347 /**
348 * @title TradeableToken can be bought and sold from/to it's own contract during it's life time
349 * Sold tokens and Ether received to buy tokens are collected during specified period and then time comes
350 * contract owner should specify price for the last period and send tokens/ether to their new owners.
351 */
352 contract TradeableToken is StandardToken, Ownable {
353     using SafeMath for uint256;
354 
355     event Sale(address indexed buyer, uint256 amount);
356     event Redemption(address indexed seller, uint256 amount);
357     event DistributionError(address seller, uint256 amount);
358 
359     /**
360     * State of the contract:
361     * Collecting - collecting ether and tokens
362     * Distribution - distribution of bought tokens and ether is in process
363     */
364     enum State{Collecting, Distribution}
365 
366     State   public currentState;                //Current state of the contract
367     uint256 public previousPeriodRate;          //Previous rate: how many tokens one could receive for 1 ether in the last period
368     uint256 public currentPeriodEndTimestamp;   //Timestamp after which no more trades are accepted and contract is waiting to start distribution
369     uint256 public currentPeriodStartBlock;     //Number of block when current perions was started
370 
371     uint256 public currentPeriodRate;           //Current rate: how much tokens one should receive for 1 ether in current distribution period
372     uint256 public currentPeriodEtherCollected; //How much ether was collected (to buy tokens) during current period and waiting for distribution
373     uint256 public currentPeriodTokenCollected; //How much tokens was collected (to sell tokens) during current period and waiting for distribution
374 
375     mapping(address => uint256) receivedEther;  //maps address of buyer to amount of ether he sent
376     mapping(address => uint256) soldTokens;     //maps address of seller to amount of tokens he sent
377 
378     uint32 constant MILLI_PERCENT_DIVIDER = 100*1000;
379     uint32 public buyFeeMilliPercent;           //The buyer's fee in a thousandth of percent. So, if buyer's fee = 5%, then buyFeeMilliPercent = 5000 and if without buyer shoud receive 200 tokens with fee it will receive 200 - (200 * 5000 / MILLI_PERCENT_DIVIDER)
380     uint32 public sellFeeMilliPercent;          //The seller's fee in a thousandth of percent. (see above)
381 
382     uint256 public minBuyAmount;                //Minimal amount of ether to buy
383     uint256 public minSellAmount;               //Minimal amount of tokens to sell
384 
385     modifier canBuyAndSell() {
386         require(currentState == State.Collecting);
387         require(now < currentPeriodEndTimestamp);
388         _;
389     }
390 
391     function TradeableToken() public {
392         currentState = State.Distribution;
393         //currentPeriodStartBlock = 0;
394         currentPeriodEndTimestamp = now;    //ensure that nothing can be collected until new period is started by owner
395     }
396 
397     /**
398     * @notice Send Ether to buy tokens
399     */
400     function() payable public {
401         require(msg.value > 0);
402         buy(msg.sender, msg.value);
403     }    
404 
405     /**
406     * @notice Transfer or sell tokens
407     * Sells tokens transferred to this contract itself or to zero address
408     * @param _to The address to transfer to or token contract address to burn.
409     * @param _value The amount to be transferred.
410     */
411     function transfer(address _to, uint256 _value) public returns (bool) {
412         if( (_to == address(this)) || (_to == 0) ){
413             return sell(msg.sender, _value);
414         }else{
415             return super.transfer(_to, _value);
416         }
417     }
418 
419     /**
420     * @notice Transfer tokens from one address to another  or sell them if _to is this contract or zero address
421     * @param _from address The address which you want to send tokens from
422     * @param _to address The address which you want to transfer to
423     * @param _value uint256 the amout of tokens to be transfered
424     */
425     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
426         if( (_to == address(this)) || (_to == 0) ){
427             var _allowance = allowed[_from][msg.sender];
428             require (_value <= _allowance);
429             allowed[_from][msg.sender] = _allowance.sub(_value);
430             return sell(_from, _value);
431         }else{
432             return super.transferFrom(_from, _to, _value);
433         }
434     }
435 
436     /**
437     * @dev Fuction called when somebody is buying tokens
438     * @param who The address of buyer (who will own bought tokens)
439     * @param amount The amount to be transferred.
440     */
441     function buy(address who, uint256 amount) canBuyAndSell internal returns(bool){
442         require(amount >= minBuyAmount);
443         currentPeriodEtherCollected = currentPeriodEtherCollected.add(amount);
444         receivedEther[who] = receivedEther[who].add(amount);  //if this is first operation from this address, initial value of receivedEther[to] == 0
445         Sale(who, amount);
446         return true;
447     }
448 
449     /**
450     * @dev Fuction called when somebody is selling his tokens
451     * @param who The address of seller (whose tokens are sold)
452     * @param amount The amount to be transferred.
453     */
454     function sell(address who, uint256 amount) canBuyAndSell internal returns(bool){
455         require(amount >= minSellAmount);
456         currentPeriodTokenCollected = currentPeriodTokenCollected.add(amount);
457         soldTokens[who] = soldTokens[who].add(amount);  //if this is first operation from this address, initial value of soldTokens[to] == 0
458         totalSupply = totalSupply.sub(amount);
459         Redemption(who, amount);
460         Transfer(who, address(0), amount);
461         return true;
462     }
463     /**
464     * @notice Set fee applied when buying tokens
465     * @param _buyFeeMilliPercent fee in thousandth of percent (5% = 5000)
466     */
467     function setBuyFee(uint32 _buyFeeMilliPercent) onlyOwner public {
468         require(_buyFeeMilliPercent < MILLI_PERCENT_DIVIDER);
469         buyFeeMilliPercent = _buyFeeMilliPercent;
470     }
471     /**
472     * @notice Set fee applied when selling tokens
473     * @param _sellFeeMilliPercent fee in thousandth of percent (5% = 5000)
474     */
475     function setSellFee(uint32 _sellFeeMilliPercent) onlyOwner public {
476         require(_sellFeeMilliPercent < MILLI_PERCENT_DIVIDER);
477         sellFeeMilliPercent = _sellFeeMilliPercent;
478     }
479     /**
480     * @notice set minimal amount of ether which can be used to buy tokens
481     * @param _minBuyAmount minimal amount of ether
482     */
483     function setMinBuyAmount(uint256 _minBuyAmount) onlyOwner public {
484         minBuyAmount = _minBuyAmount;
485     }
486     /**
487     * @notice set minimal amount of ether which can be used to buy tokens
488     * @param _minSellAmount minimal amount of tokens
489     */
490     function setMinSellAmount(uint256 _minSellAmount) onlyOwner public {
491         minSellAmount = _minSellAmount;
492     }
493 
494     /**
495     * @notice Collect ether received for token purshases
496     * This is possible both during Collection and Distribution phases
497     */
498     function collectEther(uint256 amount) onlyOwner public {
499         owner.transfer(amount);
500     }
501 
502     /**
503     * @notice Start distribution phase
504     * @param _currentPeriodRate exchange rate for current distribution
505     */
506     function startDistribution(uint256 _currentPeriodRate) onlyOwner public {
507         require(currentState != State.Distribution);    //owner should not be able to change rate after distribution is started, ensures that everyone have the same rate
508         require(_currentPeriodRate != 0);                //something has to be distributed!
509         //require(now >= currentPeriodEndTimestamp)     //DO NOT require period end timestamp passed, because there can be some situations when it is neede to end it sooner. But this should be done with extremal care, because of possible race condition between new sales/purshases and currentPeriodRate definition
510 
511         currentState = State.Distribution;
512         currentPeriodRate = _currentPeriodRate;
513     }
514 
515     /**
516     * @notice Distribute tokens to buyers
517     * @param buyers an array of addresses to pay tokens for their ether. Should be composed from outside by reading Sale events 
518     */
519     function distributeTokens(address[] buyers) onlyOwner public {
520         require(currentState == State.Distribution);
521         require(currentPeriodRate > 0);
522         for(uint256 i=0; i < buyers.length; i++){
523             address buyer = buyers[i];
524             require(buyer != address(0));
525             uint256 etherAmount = receivedEther[buyer];
526             if(etherAmount == 0) continue; //buyer not found or already paid
527             uint256 tokenAmount = etherAmount.mul(currentPeriodRate);
528             uint256 fee = tokenAmount.mul(buyFeeMilliPercent).div(MILLI_PERCENT_DIVIDER);
529             tokenAmount = tokenAmount.sub(fee);
530             
531             receivedEther[buyer] = 0;
532             currentPeriodEtherCollected = currentPeriodEtherCollected.sub(etherAmount);
533             //mint tokens
534             totalSupply = totalSupply.add(tokenAmount);
535             balances[buyer] = balances[buyer].add(tokenAmount);
536             Transfer(address(0), buyer, tokenAmount);
537         }
538     }
539 
540     /**
541     * @notice Distribute ether to sellers
542     * If not enough ether is available on contract ballance
543     * @param sellers an array of addresses to pay ether for their tokens. Should be composed from outside by reading Redemption events 
544     */
545     function distributeEther(address[] sellers) onlyOwner payable public {
546         require(currentState == State.Distribution);
547         require(currentPeriodRate > 0);
548         for(uint256 i=0; i < sellers.length; i++){
549             address seller = sellers[i];
550             require(seller != address(0));
551             uint256 tokenAmount = soldTokens[seller];
552             if(tokenAmount == 0) continue; //seller not found or already paid
553             uint256 etherAmount = tokenAmount.div(currentPeriodRate);
554             uint256 fee = etherAmount.mul(sellFeeMilliPercent).div(MILLI_PERCENT_DIVIDER);
555             etherAmount = etherAmount.sub(fee);
556             
557             soldTokens[seller] = 0;
558             currentPeriodTokenCollected = currentPeriodTokenCollected.sub(tokenAmount);
559             if(!seller.send(etherAmount)){
560                 //in this case we can only log error and let owner to handle it manually
561                 DistributionError(seller, etherAmount);
562                 owner.transfer(etherAmount); //assume this should not fail..., overwise - change owner
563             }
564         }
565     }
566 
567     function startCollecting(uint256 _collectingEndTimestamp) onlyOwner public {
568         require(_collectingEndTimestamp > now);      //Need some time for collection
569         require(currentState == State.Distribution);    //Do not allow to change collection terms after it is started
570         require(currentPeriodEtherCollected == 0);      //All sold tokens are distributed
571         require(currentPeriodTokenCollected == 0);      //All redeemed tokens are paid
572         previousPeriodRate = currentPeriodRate;
573         currentPeriodRate = 0;
574         currentPeriodStartBlock = block.number;
575         currentPeriodEndTimestamp = _collectingEndTimestamp;
576         currentState = State.Collecting;
577     }
578 }
579 
580 contract AGREToken is TradeableToken, MintableToken, HasNoContracts, HasNoTokens { //MintableToken is StandardToken, Ownable
581     string public symbol = "AGRE";
582     string public name = "Aggregate Coin";
583     uint8 public constant decimals = 18;
584 
585     address public founder;    //founder address to allow him transfer tokens while minting
586     function init(address _founder, uint32 _buyFeeMilliPercent, uint32 _sellFeeMilliPercent, uint256 _minBuyAmount, uint256 _minSellAmount) onlyOwner public {
587         founder = _founder;
588         setBuyFee(_buyFeeMilliPercent);
589         setSellFee(_sellFeeMilliPercent);
590         setMinBuyAmount(_minBuyAmount);
591         setMinSellAmount(_minSellAmount);
592     }
593 
594     /**
595      * Allow transfer only after crowdsale finished
596      */
597     modifier canTransfer() {
598         require(mintingFinished || msg.sender == founder);
599         _;
600     }
601     
602     function transfer(address _to, uint256 _value) canTransfer public returns(bool) {
603         return super.transfer(_to, _value);
604     }
605 
606     function transferFrom(address _from, address _to, uint256 _value) canTransfer public returns(bool) {
607         return super.transferFrom(_from, _to, _value);
608     }
609 }