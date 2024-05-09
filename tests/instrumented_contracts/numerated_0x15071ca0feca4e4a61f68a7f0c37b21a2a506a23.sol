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
185  * @title Destructible
186  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
187  */
188 contract Destructible is Ownable {
189 
190   function Destructible() public payable { }
191 
192   /**
193    * @dev Transfers the current balance to the owner and terminates the contract.
194    */
195   function destroy() onlyOwner public {
196     selfdestruct(owner);
197   }
198 
199   function destroyAndSend(address _recipient) onlyOwner public {
200     selfdestruct(_recipient);
201   }
202 }
203 
204 /**
205  * @title Basic token
206  * @dev Basic version of StandardToken, with no allowances.
207  */
208 contract BasicToken is ERC20Basic {
209   using SafeMath for uint256;
210 
211   mapping(address => uint256) balances;
212 
213   /**
214   * @dev transfer token for a specified address
215   * @param _to The address to transfer to.
216   * @param _value The amount to be transferred.
217   */
218   function transfer(address _to, uint256 _value) public returns (bool) {
219     require(_to != address(0));
220     require(_value <= balances[msg.sender]);
221 
222     // SafeMath.sub will throw if there is not enough balance.
223     balances[msg.sender] = balances[msg.sender].sub(_value);
224     balances[_to] = balances[_to].add(_value);
225     Transfer(msg.sender, _to, _value);
226     return true;
227   }
228 
229   /**
230   * @dev Gets the balance of the specified address.
231   * @param _owner The address to query the the balance of.
232   * @return An uint256 representing the amount owned by the passed address.
233   */
234   function balanceOf(address _owner) public view returns (uint256 balance) {
235     return balances[_owner];
236   }
237 
238 }
239 
240 /**
241  * @title Standard ERC20 token
242  *
243  * @dev Implementation of the basic standard token.
244  * @dev https://github.com/ethereum/EIPs/issues/20
245  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
246  */
247 contract StandardToken is ERC20, BasicToken {
248 
249   mapping (address => mapping (address => uint256)) internal allowed;
250 
251 
252   /**
253    * @dev Transfer tokens from one address to another
254    * @param _from address The address which you want to send tokens from
255    * @param _to address The address which you want to transfer to
256    * @param _value uint256 the amount of tokens to be transferred
257    */
258   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
259     require(_to != address(0));
260     require(_value <= balances[_from]);
261     require(_value <= allowed[_from][msg.sender]);
262 
263     balances[_from] = balances[_from].sub(_value);
264     balances[_to] = balances[_to].add(_value);
265     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
266     Transfer(_from, _to, _value);
267     return true;
268   }
269 
270   /**
271    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
272    *
273    * Beware that changing an allowance with this method brings the risk that someone may use both the old
274    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
275    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
276    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
277    * @param _spender The address which will spend the funds.
278    * @param _value The amount of tokens to be spent.
279    */
280   function approve(address _spender, uint256 _value) public returns (bool) {
281     allowed[msg.sender][_spender] = _value;
282     Approval(msg.sender, _spender, _value);
283     return true;
284   }
285 
286   /**
287    * @dev Function to check the amount of tokens that an owner allowed to a spender.
288    * @param _owner address The address which owns the funds.
289    * @param _spender address The address which will spend the funds.
290    * @return A uint256 specifying the amount of tokens still available for the spender.
291    */
292   function allowance(address _owner, address _spender) public view returns (uint256) {
293     return allowed[_owner][_spender];
294   }
295 
296   /**
297    * approve should be called when allowed[_spender] == 0. To increment
298    * allowed value is better to use this function to avoid 2 calls (and wait until
299    * the first transaction is mined)
300    * From MonolithDAO Token.sol
301    */
302   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
303     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
304     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
305     return true;
306   }
307 
308   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
309     uint oldValue = allowed[msg.sender][_spender];
310     if (_subtractedValue > oldValue) {
311       allowed[msg.sender][_spender] = 0;
312     } else {
313       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
314     }
315     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
316     return true;
317   }
318 
319 }
320 
321 /**
322  * @title Mintable token
323  * @dev Simple ERC20 Token example, with mintable token creation
324  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
325  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
326  */
327 
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
340   /**
341    * @dev Function to mint tokens
342    * @param _to The address that will receive the minted tokens.
343    * @param _amount The amount of tokens to mint.
344    * @return A boolean that indicates if the operation was successful.
345    */
346   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
347     totalSupply = totalSupply.add(_amount);
348     balances[_to] = balances[_to].add(_amount);
349     Mint(_to, _amount);
350     Transfer(address(0), _to, _amount);
351     return true;
352   }
353 
354   /**
355    * @dev Function to stop minting new tokens.
356    * @return True if the operation was successful.
357    */
358   function finishMinting() onlyOwner canMint public returns (bool) {
359     mintingFinished = true;
360     MintFinished();
361     return true;
362   }
363 }
364 
365 //====== AGRE Contracts =====
366 
367 /**
368 * @title TradeableToken can be bought and sold from/to it's own contract during it's life time
369 * Sold tokens and Ether received to buy tokens are collected during specified period and then time comes
370 * contract owner should specify price for the last period and send tokens/ether to their new owners.
371 */
372 contract TradeableToken is StandardToken, Ownable {
373     using SafeMath for uint256;
374 
375     event Sale(address indexed buyer, uint256 amount);
376     event Redemption(address indexed seller, uint256 amount);
377     event DistributionError(address seller, uint256 amount);
378 
379     /**
380     * State of the contract:
381     * Collecting - collecting ether and tokens
382     * Distribution - distribution of bought tokens and ether is in process
383     */
384     enum State{Collecting, Distribution}
385 
386     State   public currentState;                //Current state of the contract
387     uint256 public previousPeriodRate;          //Previous rate: how many tokens one could receive for 1 ether in the last period
388     uint256 public currentPeriodEndTimestamp;   //Timestamp after which no more trades are accepted and contract is waiting to start distribution
389     uint256 public currentPeriodStartBlock;     //Number of block when current perions was started
390 
391     uint256 public currentPeriodRate;           //Current rate: how much tokens one should receive for 1 ether in current distribution period
392     uint256 public currentPeriodEtherCollected; //How much ether was collected (to buy tokens) during current period and waiting for distribution
393     uint256 public currentPeriodTokenCollected; //How much tokens was collected (to sell tokens) during current period and waiting for distribution
394 
395     mapping(address => uint256) receivedEther;  //maps address of buyer to amount of ether he sent
396     mapping(address => uint256) soldTokens;     //maps address of seller to amount of tokens he sent
397 
398     uint32 constant MILLI_PERCENT_DIVIDER = 100*1000;
399     uint32 public buyFeeMilliPercent;           //The buyer's fee in a thousandth of percent. So, if buyer's fee = 5%, then buyFeeMilliPercent = 5000 and if without buyer shoud receive 200 tokens with fee it will receive 200 - (200 * 5000 / MILLI_PERCENT_DIVIDER)
400     uint32 public sellFeeMilliPercent;          //The seller's fee in a thousandth of percent. (see above)
401 
402     uint256 public minBuyAmount;                //Minimal amount of ether to buy
403     uint256 public minSellAmount;               //Minimal amount of tokens to sell
404 
405     modifier canBuyAndSell() {
406         require(currentState == State.Collecting);
407         require(now < currentPeriodEndTimestamp);
408         _;
409     }
410 
411     function TradeableToken() public {
412         currentState = State.Distribution;
413         //currentPeriodStartBlock = 0;
414         currentPeriodEndTimestamp = now;    //ensure that nothing can be collected until new period is started by owner
415     }
416 
417     /**
418     * @notice Send Ether to buy tokens
419     */
420     function() payable public {
421         require(msg.value > 0);
422         buy(msg.sender, msg.value);
423     }    
424 
425     /**
426     * @notice Transfer or sell tokens
427     * Sells tokens transferred to this contract itself or to zero address
428     * @param _to The address to transfer to or token contract address to burn.
429     * @param _value The amount to be transferred.
430     */
431     function transfer(address _to, uint256 _value) public returns (bool) {
432         if( (_to == address(this)) || (_to == 0) ){
433             return sell(msg.sender, _value);
434         }else{
435             return super.transfer(_to, _value);
436         }
437     }
438 
439     /**
440     * @notice Transfer tokens from one address to another  or sell them if _to is this contract or zero address
441     * @param _from address The address which you want to send tokens from
442     * @param _to address The address which you want to transfer to
443     * @param _value uint256 the amout of tokens to be transfered
444     */
445     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
446         if( (_to == address(this)) || (_to == 0) ){
447             var _allowance = allowed[_from][msg.sender];
448             require (_value <= _allowance);
449             allowed[_from][msg.sender] = _allowance.sub(_value);
450             return sell(_from, _value);
451         }else{
452             return super.transferFrom(_from, _to, _value);
453         }
454     }
455 
456     /**
457     * @dev Fuction called when somebody is buying tokens
458     * @param who The address of buyer (who will own bought tokens)
459     * @param amount The amount to be transferred.
460     */
461     function buy(address who, uint256 amount) canBuyAndSell internal returns(bool){
462         require(amount >= minBuyAmount);
463         currentPeriodEtherCollected = currentPeriodEtherCollected.add(amount);
464         receivedEther[who] = receivedEther[who].add(amount);  //if this is first operation from this address, initial value of receivedEther[to] == 0
465         Sale(who, amount);
466         return true;
467     }
468 
469     /**
470     * @dev Fuction called when somebody is selling his tokens
471     * @param who The address of seller (whose tokens are sold)
472     * @param amount The amount to be transferred.
473     */
474     function sell(address who, uint256 amount) canBuyAndSell internal returns(bool){
475         require(amount >= minSellAmount);
476         currentPeriodTokenCollected = currentPeriodTokenCollected.add(amount);
477         soldTokens[who] = soldTokens[who].add(amount);  //if this is first operation from this address, initial value of soldTokens[to] == 0
478         totalSupply = totalSupply.sub(amount);
479         Redemption(who, amount);
480         Transfer(who, address(0), amount);
481         return true;
482     }
483     /**
484     * @notice Set fee applied when buying tokens
485     * @param _buyFeeMilliPercent fee in thousandth of percent (5% = 5000)
486     */
487     function setBuyFee(uint32 _buyFeeMilliPercent) onlyOwner public {
488         require(_buyFeeMilliPercent < MILLI_PERCENT_DIVIDER);
489         buyFeeMilliPercent = _buyFeeMilliPercent;
490     }
491     /**
492     * @notice Set fee applied when selling tokens
493     * @param _sellFeeMilliPercent fee in thousandth of percent (5% = 5000)
494     */
495     function setSellFee(uint32 _sellFeeMilliPercent) onlyOwner public {
496         require(_sellFeeMilliPercent < MILLI_PERCENT_DIVIDER);
497         sellFeeMilliPercent = _sellFeeMilliPercent;
498     }
499     /**
500     * @notice set minimal amount of ether which can be used to buy tokens
501     * @param _minBuyAmount minimal amount of ether
502     */
503     function setMinBuyAmount(uint256 _minBuyAmount) onlyOwner public {
504         minBuyAmount = _minBuyAmount;
505     }
506     /**
507     * @notice set minimal amount of ether which can be used to buy tokens
508     * @param _minSellAmount minimal amount of tokens
509     */
510     function setMinSellAmount(uint256 _minSellAmount) onlyOwner public {
511         minSellAmount = _minSellAmount;
512     }
513 
514     /**
515     * @notice Collect ether received for token purshases
516     * This is possible both during Collection and Distribution phases
517     */
518     function collectEther(uint256 amount) onlyOwner public {
519         owner.transfer(amount);
520     }
521 
522     /**
523     * @notice Start distribution phase
524     * @param _currentPeriodRate exchange rate for current distribution
525     */
526     function startDistribution(uint256 _currentPeriodRate) onlyOwner public {
527         require(currentState != State.Distribution);    //owner should not be able to change rate after distribution is started, ensures that everyone have the same rate
528         require(_currentPeriodRate != 0);                //something has to be distributed!
529         //require(now >= currentPeriodEndTimestamp)     //DO NOT require period end timestamp passed, because there can be some situations when it is neede to end it sooner. But this should be done with extremal care, because of possible race condition between new sales/purshases and currentPeriodRate definition
530 
531         currentState = State.Distribution;
532         currentPeriodRate = _currentPeriodRate;
533     }
534 
535     /**
536     * @notice Distribute tokens to buyers
537     * @param buyers an array of addresses to pay tokens for their ether. Should be composed from outside by reading Sale events 
538     */
539     function distributeTokens(address[] buyers) onlyOwner public {
540         require(currentState == State.Distribution);
541         require(currentPeriodRate > 0);
542         for(uint256 i=0; i < buyers.length; i++){
543             address buyer = buyers[i];
544             require(buyer != address(0));
545             uint256 etherAmount = receivedEther[buyer];
546             if(etherAmount == 0) continue; //buyer not found or already paid
547             uint256 tokenAmount = etherAmount.mul(currentPeriodRate);
548             uint256 fee = tokenAmount.mul(buyFeeMilliPercent).div(MILLI_PERCENT_DIVIDER);
549             tokenAmount = tokenAmount.sub(fee);
550             
551             receivedEther[buyer] = 0;
552             currentPeriodEtherCollected = currentPeriodEtherCollected.sub(etherAmount);
553             //mint tokens
554             totalSupply = totalSupply.add(tokenAmount);
555             balances[buyer] = balances[buyer].add(tokenAmount);
556             Transfer(address(0), buyer, tokenAmount);
557         }
558     }
559 
560     /**
561     * @notice Distribute ether to sellers
562     * If not enough ether is available on contract ballance
563     * @param sellers an array of addresses to pay ether for their tokens. Should be composed from outside by reading Redemption events 
564     */
565     function distributeEther(address[] sellers) onlyOwner payable public {
566         require(currentState == State.Distribution);
567         require(currentPeriodRate > 0);
568         for(uint256 i=0; i < sellers.length; i++){
569             address seller = sellers[i];
570             require(seller != address(0));
571             uint256 tokenAmount = soldTokens[seller];
572             if(tokenAmount == 0) continue; //seller not found or already paid
573             uint256 etherAmount = tokenAmount.div(currentPeriodRate);
574             uint256 fee = etherAmount.mul(sellFeeMilliPercent).div(MILLI_PERCENT_DIVIDER);
575             etherAmount = etherAmount.sub(fee);
576             
577             soldTokens[seller] = 0;
578             currentPeriodTokenCollected = currentPeriodTokenCollected.sub(tokenAmount);
579             if(!seller.send(etherAmount)){
580                 //in this case we can only log error and let owner to handle it manually
581                 DistributionError(seller, etherAmount);
582                 owner.transfer(etherAmount); //assume this should not fail..., overwise - change owner
583             }
584         }
585     }
586 
587     function startCollecting(uint256 _collectingEndTimestamp) onlyOwner public {
588         require(_collectingEndTimestamp > now);      //Need some time for collection
589         require(currentState == State.Distribution);    //Do not allow to change collection terms after it is started
590         require(currentPeriodEtherCollected == 0);      //All sold tokens are distributed
591         require(currentPeriodTokenCollected == 0);      //All redeemed tokens are paid
592         previousPeriodRate = currentPeriodRate;
593         currentPeriodRate = 0;
594         currentPeriodStartBlock = block.number;
595         currentPeriodEndTimestamp = _collectingEndTimestamp;
596         currentState = State.Collecting;
597     }
598 }
599 
600 contract AGREToken is TradeableToken, MintableToken, HasNoContracts, HasNoTokens { //MintableToken is StandardToken, Ownable
601     string public symbol = "AGRE";
602     string public name = "Aggregate Coin";
603     uint8 public constant decimals = 18;
604 
605     address public founder;    //founder address to allow him transfer tokens while minting
606     function init(address _founder, uint32 _buyFeeMilliPercent, uint32 _sellFeeMilliPercent, uint256 _minBuyAmount, uint256 _minSellAmount) onlyOwner public {
607         founder = _founder;
608         setBuyFee(_buyFeeMilliPercent);
609         setSellFee(_sellFeeMilliPercent);
610         setMinBuyAmount(_minBuyAmount);
611         setMinSellAmount(_minSellAmount);
612     }
613 
614     /**
615      * Allow transfer only after crowdsale finished
616      */
617     modifier canTransfer() {
618         require(mintingFinished || msg.sender == founder);
619         _;
620     }
621     
622     function transfer(address _to, uint256 _value) canTransfer public returns(bool) {
623         return super.transfer(_to, _value);
624     }
625 
626     function transferFrom(address _from, address _to, uint256 _value) canTransfer public returns(bool) {
627         return super.transferFrom(_from, _to, _value);
628     }
629 }
630 
631 contract AGRECrowdsale is Ownable, Destructible {
632     using SafeMath for uint256;    
633 
634     uint256 public maxGasPrice  = 50000000000 wei;      //Maximum gas price for contribution transactions
635 
636     uint256 public startTimestamp;     //when crowdsal starts
637     uint256 public endTimestamp;       //when crowdsal ends
638     uint256 public rate;               //how many tokens will be minted for 1 ETH (like 300 CPM for 1 ETH)
639     uint256 public hardCap;            //maximum amount of ether to collect
640 
641     AGREToken public token;
642     uint256 public collectedEther;
643 
644     /**
645     * verifies that the gas price is lower than maxGasPrice
646     */
647     modifier validGasPrice() {
648         require(tx.gasprice <= maxGasPrice);
649         _;
650     }
651     /**
652     * @notice Create a crowdsale contract, a token and initialize them
653     * @param _ownerTokens Amount of tokens that will be mint to owner during the sale
654     */
655     function AGRECrowdsale(uint256 _startTimestamp, uint256 _endTimestamp, uint256 _rate, uint256 _hardCap, 
656         uint256 _ownerTokens, uint32 _buyFeeMilliPercent, uint32 _sellFeeMilliPercent, uint256 _minBuyAmount, uint256 _minSellAmount) public {
657         require(_startTimestamp < _endTimestamp);
658         require(_rate > 0);
659 
660         startTimestamp = _startTimestamp;
661         endTimestamp = _endTimestamp;
662         rate = _rate;
663         hardCap = _hardCap;
664 
665         token = new AGREToken();
666         token.init(msg.sender, _buyFeeMilliPercent, _sellFeeMilliPercent, _minBuyAmount, _minSellAmount);
667         token.mint(msg.sender, _ownerTokens);
668     }
669 
670     function () payable validGasPrice public {
671         require(crowdsaleOpen());
672         require(msg.value > 0);
673         require(collectedEther.add(msg.value) <= hardCap);
674 
675         collectedEther = collectedEther.add(msg.value);
676         uint256 buyerTokens = rate.mul(msg.value);
677         token.mint(msg.sender, buyerTokens);
678     }
679 
680     function crowdsaleOpen() public constant returns(bool){
681         return (rate > 0) && (collectedEther < hardCap) && (startTimestamp <= now) && (now <= endTimestamp);
682     }
683 
684     /**
685     * @notice Updates max gas price for crowdsale transactions
686     */
687     function setMaxGasPrice(uint256 _maxGasPrice) public onlyOwner  {
688         maxGasPrice = _maxGasPrice;
689     }
690 
691     /**
692     * @notice Closes crowdsale, finishes minting (allowing token transfers), transfers token ownership to the owner
693     */
694     function finalizeCrowdsale() public onlyOwner {
695         rate = 0;   //this makes crowdsaleOpen() return false;
696         token.finishMinting();
697         token.transferOwnership(owner);
698         if(this.balance > 0) owner.transfer(this.balance);    
699     }
700     /**
701     * @notice Claim collected ether without closing crowdsale
702     */
703     function claimEther() public onlyOwner {
704         if(this.balance > 0) owner.transfer(this.balance);
705     }
706 
707 }