1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   /**
28   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 library SafeERC20 {
46     function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
47         assert(token.transfer(to, value));
48     }
49 
50     function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
51         assert(token.transferFrom(from, to, value));
52     }
53 
54     function safeApprove(ERC20 token, address spender, uint256 value) internal {
55         assert(token.approve(spender, value));
56     }
57 }
58 
59 contract Ownable {
60   address public owner;
61 
62 
63   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
64 
65 
66   /**
67    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
68    * account.
69    */
70   function Ownable() public {
71     owner = msg.sender;
72   }
73 
74   /**
75    * @dev Throws if called by any account other than the owner.
76    */
77   modifier onlyOwner() {
78     require(msg.sender == owner);
79     _;
80   }
81 
82   /**
83    * @dev Allows the current owner to transfer control of the contract to a newOwner.
84    * @param newOwner The address to transfer ownership to.
85    */
86   function transferOwnership(address newOwner) public onlyOwner {
87     require(newOwner != address(0));
88     emit OwnershipTransferred(owner, newOwner);
89     owner = newOwner;
90   }
91 
92 }
93 
94 contract Discountable is Ownable {
95     struct DiscStruct {
96         uint256 amount;
97         uint256 disc;
98     }
99     uint256 descPrecision = 1e2;
100     uint256 defaultCoef = 200;
101     DiscStruct[] public discounts;
102 
103     function addDiscount(uint256 _amount, uint256 _disc) onlyOwner public{
104         discounts.push(DiscStruct(_amount, _disc));
105     }
106 
107     function editDiscount(uint256 num, uint256 _amount, uint256 _disc) onlyOwner public{
108         discounts[num] = DiscStruct(_amount, _disc);
109     }
110 
111     function getDiscountsAmount() public view returns(uint256 amount_){
112         return discounts.length;
113     }
114 
115     function getDiscountByAmount(uint256 amount) internal view returns(uint256 disc_){
116         uint256 arrayLength = discounts.length;
117         if (amount < discounts[0].amount){
118             return defaultCoef;
119         }
120         for (uint8 i=0; i<arrayLength; i++) {
121             if(i == arrayLength - 1){
122                 return discounts[arrayLength - 1].disc;
123             }
124             if (amount < discounts[i+1].amount){
125                 return discounts[i].disc;
126             }
127         }
128         return defaultCoef;
129     }
130 
131 }
132 
133 contract TransferStatistics {
134     using SafeMath for uint256;
135 
136     uint256 private stat_tokensBoughtBack = 0;
137     uint256 private stat_timesBoughtBack = 0;
138     uint256 private stat_tokensPurchased = 0;
139     uint256 private stat_timesPurchased = 0;
140 
141     uint256 private stat_ethSent = 0;
142     uint256 private stat_ethReceived = 0;
143 
144     uint256 private stat_tokensSpend = 0;
145     uint256 private stat_timesSpend = 0;
146 
147     uint256 private oddSent = 0;
148     uint256 private feeSent = 0;
149 
150     function trackPurchase(uint256 tokens, uint256 sum) internal {
151         stat_tokensPurchased = stat_tokensPurchased.add(tokens);
152         stat_timesPurchased = stat_timesPurchased.add(1);
153         stat_ethSent = stat_ethSent.add(sum);
154     }
155 
156     function trackBuyBack(uint256 tokens, uint256 sum) internal {
157         stat_tokensBoughtBack = stat_tokensBoughtBack.add(tokens);
158         stat_timesBoughtBack = stat_timesBoughtBack.add(1);
159         stat_ethReceived = stat_ethReceived.add(sum);
160     }
161 
162     function trackSpend(uint256 tokens) internal{
163         stat_tokensSpend = stat_tokensSpend.add(tokens);
164         stat_timesSpend = stat_timesSpend.add(1);
165     }
166 
167     function trackOdd(uint256 odd) internal {
168         oddSent = oddSent.add(odd);
169     }
170 
171     function trackFee(uint256 fee) internal {
172         feeSent = feeSent.add(fee);
173     }
174 
175     function getStatistics() internal view returns(
176         uint256 tokensBoughtBack_, uint256 timesBoughtBack_,
177         uint256 tokensPurchased_, uint256 timesPurchased_,
178         uint256 ethSent_, uint256 ethReceived_,
179         uint256 tokensSpend_, uint256 timesSpend_,
180         uint256 oddSent_, uint256 feeSent_) {
181         return (stat_tokensBoughtBack, stat_timesBoughtBack,
182         stat_tokensPurchased, stat_timesPurchased,
183         stat_ethSent, stat_ethReceived,
184         stat_tokensSpend, stat_timesSpend,
185         oddSent, feeSent);
186     }
187 }
188 
189 contract Haltable is Ownable {
190     bool public halted;
191 
192     modifier stopInEmergency {
193         require(!halted);
194         _;
195     }
196 
197 
198     modifier onlyInEmergency {
199         require(halted);
200         _;
201     }
202 
203 
204     /// @dev called by the owner on emergency, triggers stopped state
205     function halt() external onlyOwner {
206         halted = true;
207     }
208 
209 
210     /// @dev called by the owner on end of emergency, returns to normal state
211     function unhalt() external onlyOwner onlyInEmergency {
212         halted = false;
213     }
214 
215 }
216 
217 contract ERC20Basic {
218   function totalSupply() public view returns (uint256);
219   function balanceOf(address who) public view returns (uint256);
220   function transfer(address to, uint256 value) public returns (bool);
221   event Transfer(address indexed from, address indexed to, uint256 value);
222 }
223 
224 contract BasicToken is ERC20Basic {
225   using SafeMath for uint256;
226 
227   mapping(address => uint256) balances;
228 
229   uint256 totalSupply_;
230 
231   /**
232   * @dev total number of tokens in existence
233   */
234   function totalSupply() public view returns (uint256) {
235     return totalSupply_;
236   }
237 
238   /**
239   * @dev transfer token for a specified address
240   * @param _to The address to transfer to.
241   * @param _value The amount to be transferred.
242   */
243   function transfer(address _to, uint256 _value) public returns (bool) {
244     require(_to != address(0));
245     require(_value <= balances[msg.sender]);
246 
247     // SafeMath.sub will throw if there is not enough balance.
248     balances[msg.sender] = balances[msg.sender].sub(_value);
249     balances[_to] = balances[_to].add(_value);
250     emit Transfer(msg.sender, _to, _value);
251     return true;
252   }
253 
254   /**
255   * @dev Gets the balance of the specified address.
256   * @param _owner The address to query the the balance of.
257   * @return An uint256 representing the amount owned by the passed address.
258   */
259   function balanceOf(address _owner) public view returns (uint256 balance) {
260     return balances[_owner];
261   }
262 
263 }
264 
265 contract BurnableToken is BasicToken, Ownable {
266 
267   event Burn(address indexed burner, uint256 value);
268 
269   /**
270    * @dev Burns a specific amount of tokens.
271    * @param _value The amount of token to be burned.
272    */
273   function burn(uint256 _value) public onlyOwner{
274     require(_value <= balances[msg.sender]);
275     // no need to require value <= totalSupply, since that would imply the
276     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
277 
278     address burner = msg.sender;
279     balances[burner] = balances[burner].sub(_value);
280     totalSupply_ = totalSupply_.sub(_value);
281     emit Burn(burner, _value);
282   }
283 }
284 
285 contract ERC20 is ERC20Basic {
286   function allowance(address owner, address spender) public view returns (uint256);
287   function transferFrom(address from, address to, uint256 value) public returns (bool);
288   function approve(address spender, uint256 value) public returns (bool);
289   event Approval(address indexed owner, address indexed spender, uint256 value);
290 }
291 
292 contract OMPxContract is BasicToken, Haltable, Discountable, TransferStatistics {
293     using SafeMath for uint256;
294     using SafeERC20 for ERC20Basic;
295     using SafeERC20 for OMPxToken;
296     /// @dev Token
297     OMPxToken public token;
298     Distribution public feeReceiverContract;    
299     uint256 private feeBalance = 0;
300 
301     event TransferMoneyBack(address indexed to, uint256 value);
302     event Donation(address indexed donator, uint256 value);
303     event Spend(address indexed spender, uint256 tokensAmount, bytes32 indexed orderId);
304     event Purchase(address indexed received, uint256 tokensAmount, uint256 value);
305     event BuyBack(address indexed received, uint256 tokensAmount, uint256 value);
306     event NewReceiverSet(address newReceiver);
307 
308     function OMPxContract() public payable{
309         addDiscount(1000 * 1e18,198);
310         addDiscount(5000 * 1e18,190);
311         addDiscount(20000 * 1e18,180);
312         addDiscount(100000 * 1e18,150);
313 
314         token = new OMPxToken();
315         token.mint(owner, token.initialSupply());
316     }
317 
318     // payable fallback
319 
320     function() public payable {
321         emit Donation(msg.sender, msg.value);
322     }
323 
324     function setFeeReceiver(address newReceiver) public onlyOwner {
325         require(newReceiver != address(0));
326         feeReceiverContract = Distribution(newReceiver);
327         emit NewReceiverSet(newReceiver);
328     }
329 
330     function getFee() public {
331         if(feeBalance > 1e15){
332             feeReceiverContract.receiveFunds.value(feeBalance).gas(150000)();
333             trackFee(feeBalance);
334             feeBalance = 0;
335         }
336     }
337 
338     function totalTokenSupply() public view returns(uint256 totalSupply_) {
339         return token.totalSupply();
340     }
341 
342     function balanceOf(address _owner) public view returns (uint256 balance_) {
343         return token.balanceOf(_owner);
344     }
345 
346     // base price. How much eth-wui for 1e18 of wui-tokens (1 real token).
347     function getBuyBackPrice(uint256 buyBackValue) public view returns(uint256 price_) {
348         if (address(this).balance==0) {
349             return 0;
350         }
351         uint256 eth;
352         uint256 tokens = token.totalSupply();
353         if (buyBackValue > 0) {
354             eth = address(this).balance.sub(buyBackValue);
355         } else {
356             eth = address(this).balance;
357         }
358         return (eth.sub(feeBalance)).mul(1e18).div(tokens);
359     }
360 
361 
362     function getPurchasePrice(uint256 purchaseValue, uint256 amount) public view returns(uint256 price_) {
363         require(purchaseValue >= 0);
364         require(amount >= 0);
365         uint256 buyerContributionCoefficient = getDiscountByAmount(amount);
366         uint256 price = getBuyBackPrice(purchaseValue).mul(buyerContributionCoefficient).div(descPrecision);
367         if (price <= 0) {price = 1e11;}
368         return price;
369     }
370 
371 
372     // Purchase tokens to user.
373     // Money back should happens if current price is lower, then expected
374     function purchase(uint256 tokensToPurchase, uint256 maxPrice) public payable returns(uint256 tokensBought_) {
375         require(tokensToPurchase > 0);
376         require(msg.value > 0);
377         return purchaseSafe(tokensToPurchase, maxPrice);
378     }
379 
380     function purchaseSafe(uint256 tokensToPurchase, uint256 maxPrice) internal returns(uint256 tokensBought_){
381         require(maxPrice >= 0);
382 
383         uint256 currentPrice = getPurchasePrice(msg.value, tokensToPurchase);
384         require(currentPrice <= maxPrice);
385 
386         uint256 tokensWuiAvailableByCurrentPrice = msg.value.mul(1e18).div(currentPrice);
387         if(tokensWuiAvailableByCurrentPrice > tokensToPurchase) {
388             tokensWuiAvailableByCurrentPrice = tokensToPurchase;
389         }
390         uint256 totalDealPrice = currentPrice.mul(tokensWuiAvailableByCurrentPrice).div(1e18);
391         require(msg.value >= tokensToPurchase.mul(maxPrice).div(1e18));
392         require(msg.value >= totalDealPrice);
393 
394         // 9% system support fee
395         feeBalance = feeBalance + totalDealPrice.div(9);
396 
397         //mint tokens to sender
398         uint256 availableTokens = token.balanceOf(this);
399         if (availableTokens < tokensWuiAvailableByCurrentPrice) {
400             uint256 tokensToMint = tokensWuiAvailableByCurrentPrice.sub(availableTokens);
401             token.mint(this, tokensToMint);
402         }
403         token.safeTransfer(msg.sender, tokensWuiAvailableByCurrentPrice);
404 
405         // money back
406         if (totalDealPrice < msg.value) {
407             //            uint256 tokensToRefund = tokensToPurchase.sub(tokensWuiAvailableByCurrentPrice);
408             uint256 oddEthers = msg.value.sub(totalDealPrice);
409             if (oddEthers > 0) {
410                 require(oddEthers < msg.value);
411                 emit TransferMoneyBack(msg.sender, oddEthers);
412                 msg.sender.transfer(oddEthers);
413                 trackOdd(oddEthers);
414             }
415         }
416         emit Purchase(msg.sender, tokensToPurchase, totalDealPrice);
417         trackPurchase(tokensWuiAvailableByCurrentPrice, totalDealPrice);
418         return tokensWuiAvailableByCurrentPrice;
419     }
420 
421     // buyback tokens from user
422     function buyBack(uint256 tokensToBuyBack, uint256 minPrice) public {
423         uint currentPrice = getBuyBackPrice(0);
424         require(currentPrice >= minPrice);
425         uint256 totalPrice = tokensToBuyBack.mul(currentPrice).div(1e18);
426         require(tokensToBuyBack > 0);
427         require(tokensToBuyBack <= token.balanceOf(msg.sender));
428 
429         token.safeTransferFrom(msg.sender, this, tokensToBuyBack);
430 
431         emit BuyBack(msg.sender, tokensToBuyBack, totalPrice);
432         trackBuyBack(tokensToBuyBack, totalPrice);
433         // send out eth
434         msg.sender.transfer(totalPrice);
435     }
436 
437     // spend available tokens
438     function spend(uint256 tokensToSpend, bytes32 orderId) public {
439         token.safeTransferFrom(msg.sender, this, tokensToSpend);
440         token.burn(tokensToSpend);
441         trackSpend(tokensToSpend);
442         emit Spend(msg.sender, tokensToSpend, orderId);
443     }
444 
445     // spend available and purchase up more if not enough
446     function purchaseUpAndSpend(uint256 tokensToSpend, uint256 maxPrice, bytes32 orderId) public payable returns(uint256 tokensSpent_){
447         uint256 tokensToPurchaseUp = tokensToSpend.sub(token.balanceOf(msg.sender));
448         uint256 currentPrice = getPurchasePrice(msg.value, tokensToPurchaseUp);
449         uint256 tokensAvailableByCurrentPrice = msg.value.mul(1e18).div(currentPrice);
450         require(tokensToPurchaseUp <= tokensAvailableByCurrentPrice);
451 
452         if (tokensToPurchaseUp>0) {
453             purchase(tokensToPurchaseUp, maxPrice);
454         }
455         spend(tokensToSpend, orderId);
456         return tokensToSpend;
457     }
458 
459     function getStat() onlyOwner public view returns(
460         uint256 tokensBoughtBack_, uint256 timesBoughtBack_,
461         uint256 tokensPurchased_, uint256 timesPurchased_,
462         uint256 ethSent_, uint256 ethReceived_,
463         uint256 tokensSpend_, uint256 timesSpend_,
464         uint256 oddSent_, uint256 feeSent_) {
465         return getStatistics();
466     }
467 }
468 
469 contract Distribution is Ownable {
470     using SafeMath for uint256;
471 
472     struct Recipient {
473         address addr;
474         uint256 share;
475         uint256 balance;
476         uint256 received;
477     }
478 
479     uint256 sharesSum;
480     uint8 constant maxRecsAmount = 12;
481     mapping(address => Recipient) public recs;
482     address[maxRecsAmount] public recsLookUpTable; //to iterate
483 
484     event Payment(address indexed to, uint256 value);
485     event AddShare(address to, uint256 value);
486     event ChangeShare(address to, uint256 value);
487     event DeleteShare(address to);
488     event ChangeAddessShare(address newAddress);
489     event FoundsReceived(uint256 value);
490 
491     function Distribution() public {
492         sharesSum = 0;
493     }
494 
495     function receiveFunds() public payable {
496         emit FoundsReceived(msg.value);
497         for (uint8 i = 0; i < maxRecsAmount; i++) {
498             Recipient storage rec = recs[recsLookUpTable[i]];
499             uint ethAmount = (rec.share.mul(msg.value)).div(sharesSum);
500             rec.balance = rec.balance + ethAmount;
501         }
502     }
503 
504     modifier onlyMembers(){
505         require(recs[msg.sender].addr != address(0));
506         _;
507     }
508 
509     function doPayments() public {
510         Recipient storage rec = recs[msg.sender];
511         require(rec.balance >= 1e12);
512         rec.addr.transfer(rec.balance);
513         emit Payment(rec.addr, rec.balance);
514         rec.received = (rec.received).add(rec.balance);
515         rec.balance = 0;
516     }
517 
518     function addShare(address _rec, uint256 share) public onlyOwner {
519         require(_rec != address(0));
520         require(share > 0);
521         require(recs[_rec].addr == address(0));
522         recs[_rec].addr = _rec;
523         recs[_rec].share = share;
524         recs[_rec].received = 0;
525         for(uint8 i = 0; i < maxRecsAmount; i++ ) {
526             if (recsLookUpTable[i] == address(0)) {
527                 recsLookUpTable[i] = _rec;
528                 break;
529             }
530         }
531         sharesSum = sharesSum.add(share);
532         emit AddShare(_rec, share);
533     }
534 
535     function changeShare(address _rec, uint share) public onlyOwner {
536         require(_rec != address(0));
537         require(share > 0);
538         require(recs[_rec].addr != address(0));
539         Recipient storage rec = recs[_rec];
540         sharesSum = sharesSum.sub(rec.share).add(share);
541         rec.share = share;
542         emit ChangeShare(_rec, share);
543     }
544 
545     function deleteShare(address _rec) public onlyOwner {
546         require(_rec != address(0));
547         require(recs[_rec].addr != address(0));
548         sharesSum = sharesSum.sub(recs[_rec].share);
549         for(uint8 i = 0; i < maxRecsAmount; i++ ) {
550             if (recsLookUpTable[i] == recs[_rec].addr) {
551                 recsLookUpTable[i] = address(0);
552                 break;
553             }
554         }
555         delete recs[_rec];
556         emit DeleteShare(msg.sender);
557     }
558 
559     function changeRecipientAddress(address _newRec) public {
560         require(msg.sender != address(0));
561         require(_newRec != address(0));
562         require(recs[msg.sender].addr != address(0));
563         require(recs[_newRec].addr == address(0));
564         require(recs[msg.sender].addr != _newRec);
565 
566         Recipient storage rec = recs[msg.sender];
567         uint256 prevBalance = rec.balance;
568         addShare(_newRec, rec.share);
569         emit ChangeAddessShare(_newRec);
570         deleteShare(msg.sender);
571         recs[_newRec].balance = prevBalance;
572         emit DeleteShare(msg.sender);
573 
574     }
575 
576     function getMyBalance() public view returns(uint256) {
577         return recs[msg.sender].balance;
578     }
579 }
580 
581 contract StandardToken is ERC20, BasicToken {
582 
583   mapping (address => mapping (address => uint256)) internal allowed;
584   address internal owner;
585 
586   function StandardToken() public {
587     // tokens available to sale
588     owner = msg.sender;
589   }
590   /**
591    * @dev Transfer tokens from one address to another
592    * @param _from address The address which you want to send tokens from
593    * @param _to address The address which you want to transfer to
594    * @param _value uint256 the amount of tokens to be transferred
595    */
596   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
597     require(_to != address(0));
598     require(_value <= balances[_from]);
599     require(_value <= allowed[_from][msg.sender] || msg.sender == owner);
600 
601     balances[_from] = balances[_from].sub(_value);
602     balances[_to] = balances[_to].add(_value);
603     if (msg.sender != owner) {
604       allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
605     }
606     emit Transfer(_from, _to, _value);
607     return true;
608   }
609 
610   /**
611    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
612    *
613    * Beware that changing an allowance with this method brings the risk that someone may use both the old
614    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
615    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
616    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
617    * @param _spender The address which will spend the funds.
618    * @param _value The amount of tokens to be spent.
619    */
620   function approve(address _spender, uint256 _value) public returns (bool) {
621     allowed[msg.sender][_spender] = _value;
622     emit Approval(msg.sender, _spender, _value);
623     return true;
624   }
625 
626   /**
627    * @dev Function to check the amount of tokens that an owner allowed to a spender.
628    * @param _owner address The address which owns the funds.
629    * @param _spender address The address which will spend the funds.
630    * @return A uint256 specifying the amount of tokens still available for the spender.
631    */
632   function allowance(address _owner, address _spender) public view returns (uint256) {
633     return allowed[_owner][_spender];
634   }
635 
636   /**
637    * @dev Increase the amount of tokens that an owner allowed to a spender.
638    *
639    * approve should be called when allowed[_spender] == 0. To increment
640    * allowed value is better to use this function to avoid 2 calls (and wait until
641    * the first transaction is mined)
642    * From MonolithDAO Token.sol
643    * @param _spender The address which will spend the funds.
644    * @param _addedValue The amount of tokens to increase the allowance by.
645    */
646   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
647     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
648     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
649     return true;
650   }
651 
652   /**
653    * @dev Decrease the amount of tokens that an owner allowed to a spender.
654    *
655    * approve should be called when allowed[_spender] == 0. To decrement
656    * allowed value is better to use this function to avoid 2 calls (and wait until
657    * the first transaction is mined)
658    * From MonolithDAO Token.sol
659    * @param _spender The address which will spend the funds.
660    * @param _subtractedValue The amount of tokens to decrease the allowance by.
661    */
662   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
663     uint oldValue = allowed[msg.sender][_spender];
664     if (_subtractedValue > oldValue) {
665       allowed[msg.sender][_spender] = 0;
666     } else {
667       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
668     }
669     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
670     return true;
671   }
672 
673 }
674 
675 contract MintableToken is StandardToken, Ownable {
676   event Mint(address indexed to, uint256 amount);
677   event MintFinished();
678 
679   bool public mintingFinished = false;
680 
681 
682   modifier canMint() {
683     require(!mintingFinished);
684     _;
685   }
686 
687   /**
688    * @dev Function to mint tokens
689    * @param _to The address that will receive the minted tokens.
690    * @param _amount The amount of tokens to mint.
691    * @return A boolean that indicates if the operation was successful.
692    */
693   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
694     totalSupply_ = totalSupply_.add(_amount);
695     balances[_to] = balances[_to].add(_amount);
696     emit Mint(_to, _amount);
697     emit Transfer(address(0), _to, _amount);
698     return true;
699   }
700 
701   /**
702    * @dev Function to stop minting new tokens.
703    * @return True if the operation was successful.
704    */
705   function finishMinting() onlyOwner canMint public returns (bool) {
706     mintingFinished = true;
707     emit MintFinished();
708     return true;
709   }
710 }
711 
712 contract OMPxToken is BurnableToken, MintableToken{
713     using SafeMath for uint256;
714     uint32 public constant decimals = 18;
715     uint256 public constant initialSupply = 1e24;
716 
717     string public constant name = "OMPx Token";
718     string public constant symbol = "OMPX";
719 }