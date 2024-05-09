1 pragma solidity ^0.4.21;
2 
3 contract LuckchemyCrowdsale {
4     using SafeMath for uint256;
5 
6     //  Token for selling
7     LuckchemyToken public token;
8 
9     /*
10     *  Start and End date of investment process
11     */
12 
13     // 2018-04-30 00:00:00 GMT - start time for public sale
14     uint256 public constant START_TIME_SALE = 1525046400;
15 
16     // 2018-07-20 23:59:59 GMT - end time for public sale
17     uint256 public constant END_TIME_SALE = 1532131199;
18 
19     // 2018-04-02 00:00:00 GMT - start time for private sale
20     uint256 public constant START_TIME_PRESALE = 1522627200;
21 
22     // 2018-04-24 23:59:59 GMT - end time for private sale
23     uint256 public constant END_TIME_PRESALE = 1524614399;
24 
25 
26     // amount of already sold tokens
27     uint256 public tokensSold = 0;
28 
29     //supply for crowdSale
30     uint256 public totalSupply = 0;
31     // hard cap
32     uint256 public constant hardCap = 45360 ether;
33     // soft cap
34     uint256 public constant softCap = 2000 ether;
35 
36     // wei representation of collected fiat
37     uint256 public fiatBalance = 0;
38     // ether collected in wei
39     uint256 public ethBalance = 0;
40 
41     //address of serviceAgent (it can calls  payFiat function)
42     address public serviceAgent;
43 
44     // owner of the contract
45     address public owner;
46 
47     //default token rate
48     uint256 public constant RATE = 12500; // Token price in ETH - 0.00008 ETH  1 ETHER = 12500 tokens
49 
50     // 2018/04/30 - 2018/07/22  
51     uint256 public constant DISCOUNT_PRIVATE_PRESALE = 80; // 80 % discount
52 
53     // 2018/04/30 - 2018/07/20
54     uint256 public constant DISCOUNT_STAGE_ONE = 40;  // 40% discount
55 
56     // 2018/04/02 - 2018/04/24   
57     uint256 public constant DISCOUNT_STAGE_TWO = 20; // 20% discount
58 
59     // 2018/04/30 - 2018/07/22  
60     uint256 public constant DISCOUNT_STAGE_THREE = 0;
61 
62 
63 
64 
65     //White list of addresses that are allowed to by a token
66     mapping(address => bool) public whitelist;
67 
68 
69     /**
70      * List of addresses for ICO fund with shares in %
71      * 
72      */
73     uint256 public constant LOTTERY_FUND_SHARE = 40;
74     uint256 public constant OPERATIONS_SHARE = 50;
75     uint256 public constant PARTNERS_SHARE = 10;
76 
77     address public constant LOTTERY_FUND_ADDRESS = 0x84137CB59076a61F3f94B2C39Da8fbCb63B6f096;
78     address public constant OPERATIONS_ADDRESS = 0xEBBeAA0699837De527B29A03ECC914159D939Eea;
79     address public constant PARTNERS_ADDRESS = 0x820502e8c80352f6e11Ce036DF03ceeEBE002642;
80 
81     /**
82      * event for token ETH purchase  logging
83      * @param purchaser who paid for the tokens
84      * @param beneficiary who got the tokens
85      * @param value weis paid for purchase
86      * @param amount amount of tokens purchased
87      */
88     event TokenETHPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
89 
90 
91     /**
92      * event for token FIAT purchase  logging
93      * @param purchaser who paid for the tokens
94      * @param beneficiary who got the tokens
95      * @param amount amount of tokens purchased
96      */
97     event TokenFiatPurchase(address indexed purchaser, address indexed beneficiary, uint256 amount);
98 
99     /*
100      * modifier which gives specific rights to owner
101      */
102     modifier onlyOwner(){
103         require(msg.sender == owner);
104         _;
105     }
106     /*
107      * modifier which gives possibility to call payFiat function
108      */
109     modifier onlyServiceAgent(){
110         require(msg.sender == serviceAgent);
111         _;
112     }
113 
114     /*
115     *
116     *modifier which gives possibility to purchase
117     *
118     */
119     modifier onlyWhiteList(address _address){
120         require(whitelist[_address] == true);
121         _;
122     }
123     /*
124      * Enum which defines stages of ICO
125     */
126 
127     enum Stage {
128         Private,
129         Discount40,
130         Discount20,
131         NoDiscount
132     }
133 
134     //current stage
135     Stage public  currentStage;
136 
137     //pools of token for each stage
138     mapping(uint256 => uint256) public tokenPools;
139 
140     //number of tokens per 1 ether for each stage
141     mapping(uint256 => uint256) public stageRates;
142 
143     /*
144     * deposit is amount in wei , which was sent to the contract
145     * @ address - address of depositor
146     * @ uint256 - amount
147     */
148     mapping(address => uint256) public deposits;
149 
150     /* 
151     * constructor of contract 
152     *  @ _service- address which has rights to call payFiat
153     */
154     function LuckchemyCrowdsale(address _service) public {
155         require(START_TIME_SALE >= now);
156         require(START_TIME_SALE > END_TIME_PRESALE);
157         require(END_TIME_SALE > START_TIME_SALE);
158 
159         require(_service != 0x0);
160 
161         owner = msg.sender;
162         serviceAgent = _service;
163         token = new LuckchemyToken();
164         totalSupply = token.CROWDSALE_SUPPLY();
165 
166         currentStage = Stage.Private;
167 
168         uint256 decimals = uint256(token.decimals());
169 
170         tokenPools[uint256(Stage.Private)] = 70000000 * (10 ** decimals);
171         tokenPools[uint256(Stage.Discount40)] = 105000000 * (10 ** decimals);
172         tokenPools[uint256(Stage.Discount20)] = 175000000 * (10 ** decimals);
173         tokenPools[uint256(Stage.NoDiscount)] = 350000000 * (10 ** decimals);
174 
175         stageRates[uint256(Stage.Private)] = RATE.mul(10 ** decimals).mul(100).div(100 - DISCOUNT_PRIVATE_PRESALE);
176         stageRates[uint256(Stage.Discount40)] = RATE.mul(10 ** decimals).mul(100).div(100 - DISCOUNT_STAGE_ONE);
177         stageRates[uint256(Stage.Discount20)] = RATE.mul(10 ** decimals).mul(100).div(100 - DISCOUNT_STAGE_TWO);
178         stageRates[uint256(Stage.NoDiscount)] = RATE.mul(10 ** decimals).mul(100).div(100 - DISCOUNT_STAGE_THREE);
179 
180     }
181 
182     /*
183      * function to get amount ,which invested by depositor
184      * @depositor - address ,which bought tokens
185     */
186     function depositOf(address depositor) public constant returns (uint256) {
187         return deposits[depositor];
188     }
189     /*
190      * fallback function can be used to buy  tokens
191      */
192     function() public payable {
193         payETH(msg.sender);
194     }
195 
196 
197     /*
198     * function for tracking ethereum purchases
199     * @beneficiary - address ,which received tokens
200     */
201     function payETH(address beneficiary) public onlyWhiteList(beneficiary) payable {
202 
203         require(msg.value >= 0.1 ether);
204         require(beneficiary != 0x0);
205         require(validPurchase());
206         if (isPrivateSale()) {
207             processPrivatePurchase(msg.value, beneficiary);
208         } else {
209             processPublicPurchase(msg.value, beneficiary);
210         }
211 
212 
213     }
214 
215     /*
216      * function for processing purchase in private sale
217      * @weiAmount - amount of wei , which send to the contract
218      * @beneficiary - address for receiving tokens
219      */
220     function processPrivatePurchase(uint256 weiAmount, address beneficiary) private {
221 
222         uint256 stage = uint256(Stage.Private);
223 
224         require(currentStage == Stage.Private);
225         require(tokenPools[stage] > 0);
226 
227         //calculate number tokens
228         uint256 tokensToBuy = (weiAmount.mul(stageRates[stage])).div(1 ether);
229         if (tokensToBuy <= tokenPools[stage]) {
230             //pool has enough tokens
231             payoutTokens(beneficiary, tokensToBuy, weiAmount);
232 
233         } else {
234             //pool doesn't have enough tokens
235             tokensToBuy = tokenPools[stage];
236             //left wei
237             uint256 usedWei = (tokensToBuy.mul(1 ether)).div(stageRates[stage]);
238             uint256 leftWei = weiAmount.sub(usedWei);
239 
240             payoutTokens(beneficiary, tokensToBuy, usedWei);
241 
242             //change stage to Public Sale
243             currentStage = Stage.Discount40;
244 
245             //return left wei to beneficiary and change stage
246             beneficiary.transfer(leftWei);
247         }
248     }
249     /*
250     * function for processing purchase in public sale
251     * @weiAmount - amount of wei , which send to the contract
252     * @beneficiary - address for receiving tokens
253     */
254     function processPublicPurchase(uint256 weiAmount, address beneficiary) private {
255 
256         if (currentStage == Stage.Private) {
257             currentStage = Stage.Discount40;
258             tokenPools[uint256(Stage.Discount40)] = tokenPools[uint256(Stage.Discount40)].add(tokenPools[uint256(Stage.Private)]);
259             tokenPools[uint256(Stage.Private)] = 0;
260         }
261 
262         for (uint256 stage = uint256(currentStage); stage <= 3; stage++) {
263 
264             //calculate number tokens
265             uint256 tokensToBuy = (weiAmount.mul(stageRates[stage])).div(1 ether);
266 
267             if (tokensToBuy <= tokenPools[stage]) {
268                 //pool has enough tokens
269                 payoutTokens(beneficiary, tokensToBuy, weiAmount);
270 
271                 break;
272             } else {
273                 //pool doesn't have enough tokens
274                 tokensToBuy = tokenPools[stage];
275                 //left wei
276                 uint256 usedWei = (tokensToBuy.mul(1 ether)).div(stageRates[stage]);
277                 uint256 leftWei = weiAmount.sub(usedWei);
278 
279                 payoutTokens(beneficiary, tokensToBuy, usedWei);
280 
281                 if (stage == 3) {
282                     //return unused wei when all tokens sold
283                     beneficiary.transfer(leftWei);
284                     break;
285                 } else {
286                     weiAmount = leftWei;
287                     //change current stage
288                     currentStage = Stage(stage + 1);
289                 }
290             }
291         }
292     }
293     /*
294      * function for actual payout in public sale
295      * @beneficiary - address for receiving tokens
296      * @tokenAmount - amount of tokens to payout
297      * @weiAmount - amount of wei used
298      */
299     function payoutTokens(address beneficiary, uint256 tokenAmount, uint256 weiAmount) private {
300         uint256 stage = uint256(currentStage);
301         tokensSold = tokensSold.add(tokenAmount);
302         tokenPools[stage] = tokenPools[stage].sub(tokenAmount);
303         deposits[beneficiary] = deposits[beneficiary].add(weiAmount);
304         ethBalance = ethBalance.add(weiAmount);
305 
306         token.transfer(beneficiary, tokenAmount);
307         TokenETHPurchase(msg.sender, beneficiary, weiAmount, tokenAmount);
308     }
309     /*
310      * function for change btc agent
311      * can be called only by owner of the contract
312      * @_newServiceAgent - new serviceAgent address
313      */
314     function setServiceAgent(address _newServiceAgent) public onlyOwner {
315         serviceAgent = _newServiceAgent;
316     }
317     /*
318      * function for tracking bitcoin purchases received by bitcoin wallet
319      * each transaction and amount of tokens according to rate can be validated on public bitcoin wallet
320      * public key - #
321      * @beneficiary - address, which received tokens
322      * @amount - amount tokens
323      * @stage - number of the stage (80% 40% 20% 0% discount)
324      * can be called only by serviceAgent address
325      */
326     function payFiat(address beneficiary, uint256 amount, uint256 stage) public onlyServiceAgent onlyWhiteList(beneficiary) {
327 
328         require(beneficiary != 0x0);
329         require(tokenPools[stage] >= amount);
330         require(stage == uint256(currentStage));
331 
332         //calculate fiat amount in wei
333         uint256 fiatWei = amount.mul(1 ether).div(stageRates[stage]);
334         fiatBalance = fiatBalance.add(fiatWei);
335         require(validPurchase());
336 
337         tokenPools[stage] = tokenPools[stage].sub(amount);
338         tokensSold = tokensSold.add(amount);
339 
340         token.transfer(beneficiary, amount);
341         TokenFiatPurchase(msg.sender, beneficiary, amount);
342     }
343 
344 
345     /*
346      * function for  checking if crowdsale is finished
347      */
348     function hasEnded() public constant returns (bool) {
349         return now > END_TIME_SALE || tokensSold >= totalSupply;
350     }
351 
352     /*
353      * function for  checking if hardCapReached
354      */
355     function hardCapReached() public constant returns (bool) {
356         return tokensSold >= totalSupply || fiatBalance.add(ethBalance) >= hardCap;
357     }
358     /*
359      * function for  checking if crowdsale goal is reached
360      */
361     function softCapReached() public constant returns (bool) {
362         return fiatBalance.add(ethBalance) >= softCap;
363     }
364 
365     function isPrivateSale() public constant returns (bool) {
366         return now >= START_TIME_PRESALE && now <= END_TIME_PRESALE;
367     }
368 
369     /*
370      * function that call after crowdsale is ended
371      *          releaseTokenTransfer - enable token transfer between users.
372      *          burn tokens which are left on crowsale contract balance
373      *          transfer balance of contract to wallets according to shares.
374      */
375     function forwardFunds() public onlyOwner {
376         require(hasEnded());
377         require(softCapReached());
378 
379         token.releaseTokenTransfer();
380         token.burn(token.balanceOf(this));
381 
382         //transfer token ownership to this owner of crowdsale
383         token.transferOwnership(msg.sender);
384 
385         //transfer funds here
386         uint256 totalBalance = this.balance;
387         LOTTERY_FUND_ADDRESS.transfer((totalBalance.mul(LOTTERY_FUND_SHARE)).div(100));
388         OPERATIONS_ADDRESS.transfer((totalBalance.mul(OPERATIONS_SHARE)).div(100));
389         PARTNERS_ADDRESS.transfer(this.balance); // send the rest to partners (PARTNERS_SHARE)
390     }
391     /*
392      * function that call after crowdsale is ended
393      *          conditions : ico ended and goal isn't reached. amount of depositor > 0.
394      *
395      *          refund eth deposit (fiat refunds will be done manually)
396      */
397     function refund() public {
398         require(hasEnded());
399         require(!softCapReached() || ((now > END_TIME_SALE + 30 days) && !token.released()));
400         uint256 amount = deposits[msg.sender];
401         require(amount > 0);
402         deposits[msg.sender] = 0;
403         msg.sender.transfer(amount);
404 
405     }
406 
407     /*
408         internal functions
409     */
410 
411     /*
412      *  function for checking period of investment and investment amount restriction for ETH purchases
413      */
414     function validPurchase() internal constant returns (bool) {
415         bool withinPeriod = (now >= START_TIME_PRESALE && now <= END_TIME_PRESALE) || (now >= START_TIME_SALE && now <= END_TIME_SALE);
416         return withinPeriod && !hardCapReached();
417     }
418     /*
419      * function for adding address to whitelist
420      * @_whitelistAddress - address to add
421      */
422     function addToWhiteList(address _whitelistAddress) public onlyServiceAgent {
423         whitelist[_whitelistAddress] = true;
424     }
425 
426     /*
427      * function for removing address from whitelist
428      * @_whitelistAddress - address to remove
429      */
430     function removeWhiteList(address _whitelistAddress) public onlyServiceAgent {
431         delete whitelist[_whitelistAddress];
432     }
433 
434 
435 }
436 
437 contract ERC20Basic {
438   function totalSupply() public view returns (uint256);
439   function balanceOf(address who) public view returns (uint256);
440   function transfer(address to, uint256 value) public returns (bool);
441   event Transfer(address indexed from, address indexed to, uint256 value);
442 }
443 
444 contract BasicToken is ERC20Basic {
445   using SafeMath for uint256;
446 
447   mapping(address => uint256) balances;
448 
449   uint256 totalSupply_;
450 
451   /**
452   * @dev total number of tokens in existence
453   */
454   function totalSupply() public view returns (uint256) {
455     return totalSupply_;
456   }
457 
458   /**
459   * @dev transfer token for a specified address
460   * @param _to The address to transfer to.
461   * @param _value The amount to be transferred.
462   */
463   function transfer(address _to, uint256 _value) public returns (bool) {
464     require(_to != address(0));
465     require(_value <= balances[msg.sender]);
466 
467     // SafeMath.sub will throw if there is not enough balance.
468     balances[msg.sender] = balances[msg.sender].sub(_value);
469     balances[_to] = balances[_to].add(_value);
470     Transfer(msg.sender, _to, _value);
471     return true;
472   }
473 
474   /**
475   * @dev Gets the balance of the specified address.
476   * @param _owner The address to query the the balance of.
477   * @return An uint256 representing the amount owned by the passed address.
478   */
479   function balanceOf(address _owner) public view returns (uint256 balance) {
480     return balances[_owner];
481   }
482 
483 }
484 
485 contract BurnableToken is BasicToken {
486 
487   event Burn(address indexed burner, uint256 value);
488 
489   /**
490    * @dev Burns a specific amount of tokens.
491    * @param _value The amount of token to be burned.
492    */
493   function burn(uint256 _value) public {
494     require(_value <= balances[msg.sender]);
495     // no need to require value <= totalSupply, since that would imply the
496     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
497 
498     address burner = msg.sender;
499     balances[burner] = balances[burner].sub(_value);
500     totalSupply_ = totalSupply_.sub(_value);
501     Burn(burner, _value);
502     Transfer(burner, address(0), _value);
503   }
504 }
505 
506 contract ERC20 is ERC20Basic {
507   function allowance(address owner, address spender) public view returns (uint256);
508   function transferFrom(address from, address to, uint256 value) public returns (bool);
509   function approve(address spender, uint256 value) public returns (bool);
510   event Approval(address indexed owner, address indexed spender, uint256 value);
511 }
512 
513 contract StandardToken is ERC20, BasicToken {
514 
515   mapping (address => mapping (address => uint256)) internal allowed;
516 
517 
518   /**
519    * @dev Transfer tokens from one address to another
520    * @param _from address The address which you want to send tokens from
521    * @param _to address The address which you want to transfer to
522    * @param _value uint256 the amount of tokens to be transferred
523    */
524   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
525     require(_to != address(0));
526     require(_value <= balances[_from]);
527     require(_value <= allowed[_from][msg.sender]);
528 
529     balances[_from] = balances[_from].sub(_value);
530     balances[_to] = balances[_to].add(_value);
531     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
532     Transfer(_from, _to, _value);
533     return true;
534   }
535 
536   /**
537    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
538    *
539    * Beware that changing an allowance with this method brings the risk that someone may use both the old
540    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
541    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
542    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
543    * @param _spender The address which will spend the funds.
544    * @param _value The amount of tokens to be spent.
545    */
546   function approve(address _spender, uint256 _value) public returns (bool) {
547     allowed[msg.sender][_spender] = _value;
548     Approval(msg.sender, _spender, _value);
549     return true;
550   }
551 
552   /**
553    * @dev Function to check the amount of tokens that an owner allowed to a spender.
554    * @param _owner address The address which owns the funds.
555    * @param _spender address The address which will spend the funds.
556    * @return A uint256 specifying the amount of tokens still available for the spender.
557    */
558   function allowance(address _owner, address _spender) public view returns (uint256) {
559     return allowed[_owner][_spender];
560   }
561 
562   /**
563    * @dev Increase the amount of tokens that an owner allowed to a spender.
564    *
565    * approve should be called when allowed[_spender] == 0. To increment
566    * allowed value is better to use this function to avoid 2 calls (and wait until
567    * the first transaction is mined)
568    * From MonolithDAO Token.sol
569    * @param _spender The address which will spend the funds.
570    * @param _addedValue The amount of tokens to increase the allowance by.
571    */
572   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
573     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
574     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
575     return true;
576   }
577 
578   /**
579    * @dev Decrease the amount of tokens that an owner allowed to a spender.
580    *
581    * approve should be called when allowed[_spender] == 0. To decrement
582    * allowed value is better to use this function to avoid 2 calls (and wait until
583    * the first transaction is mined)
584    * From MonolithDAO Token.sol
585    * @param _spender The address which will spend the funds.
586    * @param _subtractedValue The amount of tokens to decrease the allowance by.
587    */
588   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
589     uint oldValue = allowed[msg.sender][_spender];
590     if (_subtractedValue > oldValue) {
591       allowed[msg.sender][_spender] = 0;
592     } else {
593       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
594     }
595     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
596     return true;
597   }
598 
599 }
600 
601 contract Ownable {
602   address public owner;
603 
604 
605   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
606 
607 
608   /**
609    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
610    * account.
611    */
612   function Ownable() public {
613     owner = msg.sender;
614   }
615 
616   /**
617    * @dev Throws if called by any account other than the owner.
618    */
619   modifier onlyOwner() {
620     require(msg.sender == owner);
621     _;
622   }
623 
624   /**
625    * @dev Allows the current owner to transfer control of the contract to a newOwner.
626    * @param newOwner The address to transfer ownership to.
627    */
628   function transferOwnership(address newOwner) public onlyOwner {
629     require(newOwner != address(0));
630     OwnershipTransferred(owner, newOwner);
631     owner = newOwner;
632   }
633 
634 }
635 
636 contract Claimable is Ownable {
637   address public pendingOwner;
638 
639   /**
640    * @dev Modifier throws if called by any account other than the pendingOwner.
641    */
642   modifier onlyPendingOwner() {
643     require(msg.sender == pendingOwner);
644     _;
645   }
646 
647   /**
648    * @dev Allows the current owner to set the pendingOwner address.
649    * @param newOwner The address to transfer ownership to.
650    */
651   function transferOwnership(address newOwner) onlyOwner public {
652     pendingOwner = newOwner;
653   }
654 
655   /**
656    * @dev Allows the pendingOwner address to finalize the transfer.
657    */
658   function claimOwnership() onlyPendingOwner public {
659     OwnershipTransferred(owner, pendingOwner);
660     owner = pendingOwner;
661     pendingOwner = address(0);
662   }
663 }
664 
665 contract LuckchemyToken is BurnableToken, StandardToken, Claimable {
666 
667     bool public released = false;
668 
669     string public constant name = "Luckchemy";
670 
671     string public constant symbol = "LUK";
672 
673     uint8 public constant decimals = 8;
674 
675     uint256 public CROWDSALE_SUPPLY;
676 
677     uint256 public OWNERS_AND_PARTNERS_SUPPLY;
678 
679     address public constant OWNERS_AND_PARTNERS_ADDRESS = 0x603a535a1D7C5050021F9f5a4ACB773C35a67602;
680 
681     // Index of unique addresses
682     uint256 public addressCount = 0;
683 
684     // Map of unique addresses
685     mapping(uint256 => address) public addressMap;
686     mapping(address => bool) public addressAvailabilityMap;
687 
688     //blacklist of addresses (product/developers addresses) that are not included in the final Holder lottery
689     mapping(address => bool) public blacklist;
690 
691     // service agent for managing blacklist
692     address public serviceAgent;
693 
694     event Release();
695     event BlacklistAdd(address indexed addr);
696     event BlacklistRemove(address indexed addr);
697 
698     /**
699      * Do not transfer tokens until the crowdsale is over.
700      *
701      */
702     modifier canTransfer() {
703         require(released || msg.sender == owner);
704         _;
705     }
706 
707     /*
708      * modifier which gives specific rights to serviceAgent
709      */
710     modifier onlyServiceAgent(){
711         require(msg.sender == serviceAgent);
712         _;
713     }
714 
715 
716     function LuckchemyToken() public {
717 
718         totalSupply_ = 1000000000 * (10 ** uint256(decimals));
719         CROWDSALE_SUPPLY = 700000000 * (10 ** uint256(decimals));
720         OWNERS_AND_PARTNERS_SUPPLY = 300000000 * (10 ** uint256(decimals));
721 
722         addAddressToUniqueMap(msg.sender);
723         addAddressToUniqueMap(OWNERS_AND_PARTNERS_ADDRESS);
724 
725         balances[msg.sender] = CROWDSALE_SUPPLY;
726 
727         balances[OWNERS_AND_PARTNERS_ADDRESS] = OWNERS_AND_PARTNERS_SUPPLY;
728 
729         owner = msg.sender;
730 
731         Transfer(0x0, msg.sender, CROWDSALE_SUPPLY);
732 
733         Transfer(0x0, OWNERS_AND_PARTNERS_ADDRESS, OWNERS_AND_PARTNERS_SUPPLY);
734     }
735 
736     function transfer(address _to, uint256 _value) public canTransfer returns (bool success) {
737         //Add address to map of unique token owners
738         addAddressToUniqueMap(_to);
739 
740         // Call StandardToken.transfer()
741         return super.transfer(_to, _value);
742     }
743 
744     function transferFrom(address _from, address _to, uint256 _value) public canTransfer returns (bool success) {
745         //Add address to map of unique token owners
746         addAddressToUniqueMap(_to);
747 
748         // Call StandardToken.transferForm()
749         return super.transferFrom(_from, _to, _value);
750     }
751 
752     /**
753     *
754     * Release the tokens to the public.
755     * Can be called only by owner which should be the Crowdsale contract
756     * Should be called if the crowdale is successfully finished
757     *
758     */
759     function releaseTokenTransfer() public onlyOwner {
760         released = true;
761         Release();
762     }
763 
764     /**
765      * Add address to the black list.
766      * Only service agent can do this
767      */
768     function addBlacklistItem(address _blackAddr) public onlyServiceAgent {
769         blacklist[_blackAddr] = true;
770 
771         BlacklistAdd(_blackAddr);
772     }
773 
774     /**
775     * Remove address from the black list.
776     * Only service agent can do this
777     */
778     function removeBlacklistItem(address _blackAddr) public onlyServiceAgent {
779         delete blacklist[_blackAddr];
780     }
781 
782     /**
783     * Add address to unique map if it is not added
784     */
785     function addAddressToUniqueMap(address _addr) private returns (bool) {
786         if (addressAvailabilityMap[_addr] == true) {
787             return true;
788         }
789 
790         addressAvailabilityMap[_addr] = true;
791         addressMap[addressCount++] = _addr;
792 
793         return true;
794     }
795 
796     /**
797     * Get address by index from map of unique addresses
798     */
799     function getUniqueAddressByIndex(uint256 _addressIndex) public view returns (address) {
800         return addressMap[_addressIndex];
801     }
802 
803     /**
804     * Change service agent
805     */
806     function changeServiceAgent(address _addr) public onlyOwner {
807         serviceAgent = _addr;
808     }
809 
810 }
811 
812 library SafeMath {
813 
814   /**
815   * @dev Multiplies two numbers, throws on overflow.
816   */
817   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
818     if (a == 0) {
819       return 0;
820     }
821     uint256 c = a * b;
822     assert(c / a == b);
823     return c;
824   }
825 
826   /**
827   * @dev Integer division of two numbers, truncating the quotient.
828   */
829   function div(uint256 a, uint256 b) internal pure returns (uint256) {
830     // assert(b > 0); // Solidity automatically throws when dividing by 0
831     uint256 c = a / b;
832     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
833     return c;
834   }
835 
836   /**
837   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
838   */
839   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
840     assert(b <= a);
841     return a - b;
842   }
843 
844   /**
845   * @dev Adds two numbers, throws on overflow.
846   */
847   function add(uint256 a, uint256 b) internal pure returns (uint256) {
848     uint256 c = a + b;
849     assert(c >= a);
850     return c;
851   }
852 }