1 pragma solidity 0.4.25;
2 
3 contract E2D {
4     /*=================================
5     =            MODIFIERS            =
6     =================================*/
7     // only people with tokens
8     modifier onlyBagholders() {
9         require(myTokens() > 0);
10         _;
11     }
12 
13     // only people with profits
14     modifier onlyStronghands() {
15         require(myDividends() > 0);
16         _;
17     }
18 
19     // owner can:
20     // -> change the name of the contract
21     // -> change the name of the token
22     // they CANNOT:
23     // -> take funds
24     // -> disable withdrawals
25     // -> kill the contract
26     // -> change the price of tokens
27     modifier onlyOwner(){
28         require(ownerAddr == msg.sender || OWNER_ADDRESS_2 == msg.sender, "only owner can perform this!");
29         _;
30     }
31 
32     modifier onlyInitialInvestors(){
33         if(initialState) {
34             require(initialInvestors[msg.sender] == true, "only allowed investor can invest!");
35             _;
36         } else {
37             _;
38         }
39     }
40 
41     /*==============================
42     =            EVENTS            =
43     ==============================*/
44     event onTokenPurchase(
45         address indexed customerAddress,
46         uint256 incomingEthereum,
47         uint256 tokensMinted
48     );
49 
50     event onTokenSell(
51         address indexed customerAddress,
52         uint256 tokensBurned,
53         uint256 ethereumEarned
54     );
55 
56     event onReinvestment(
57         address indexed customerAddress,
58         uint256 ethereumReinvested,
59         uint256 tokensMinted
60     );
61 
62     event onWithdraw(
63         address indexed customerAddress,
64         uint256 ethereumWithdrawn
65     );
66 
67     event onPayDividends(
68         uint256 dividends,
69         uint256 profitPerShare
70     );
71 
72     // ERC20
73     event Transfer(
74         address indexed from,
75         address indexed to,
76         uint256 tokens
77     );
78 
79     /*=====================================
80     =            CONFIGURABLES            =
81     =====================================*/
82     string public name = "E2D";
83     string public symbol = "E2D";
84     uint8 constant public decimals = 18;
85     uint8 constant internal dividendFee_ = 10;
86     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
87     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
88     uint256 constant internal magnitude = 2**64;
89     address constant internal OWNER_ADDRESS = address(0x508b828440D72B0De506c86DB79D9E2c19810442);
90     address constant internal OWNER_ADDRESS_2 = address(0x508b828440D72B0De506c86DB79D9E2c19810442);
91     uint256 constant public INVESTOR_QUOTA = 0.01 ether;
92 
93    /*================================
94     =            DATASETS            =
95     ================================*/
96     // amount of shares for each address (scaled number)
97     mapping(address => uint256) internal tokenBalanceLedger_;
98     mapping(address => int256) internal payoutsTo_;
99     uint256 internal tokenSupply_ = 0;
100     uint256 internal profitPerShare_;
101     uint256 internal totalInvestment_ = 0;
102     uint256 internal totalGameDividends_ = 0;
103 
104     // smart contract owner address (see above on what they can do)
105     address public ownerAddr;
106 
107     // initial investor list who can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
108     mapping(address => bool) public initialInvestors;
109 
110     // when this is set to true, only allowed initialInvestors can purchase tokens.
111     bool public initialState = true;
112 
113     /*=======================================
114     =            PUBLIC FUNCTIONS            =
115     =======================================*/
116     /*
117     * -- APPLICATION ENTRY POINTS --  
118     */
119 
120     constructor() public {
121         // add initialInvestors here
122         ownerAddr = OWNER_ADDRESS;
123         initialInvestors[OWNER_ADDRESS] = true;
124         initialInvestors[OWNER_ADDRESS_2] = true;
125     }
126 
127     /**
128      * Converts all incoming ethereum to tokens for the caller
129      */
130     function buy() public payable returns(uint256) {
131         purchaseTokens(msg.value);
132     }
133 
134     /**
135      * Fallback function to handle ethereum that was send straight to the contract
136      */
137     function() public payable {
138         purchaseTokens(msg.value);
139     }
140 
141     /**
142      * Converts all of caller's dividends to tokens.
143      */
144     function reinvest() public onlyStronghands() {
145         // fetch dividends
146         uint256 _dividends = myDividends();
147 
148         // pay out the dividends virtually
149         address _customerAddress = msg.sender;
150         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
151 
152         // dispatch a buy order with the virtualized "withdrawn dividends"
153         uint256 _tokens = purchaseTokens(_dividends);
154 
155         // fire event
156         emit onReinvestment(_customerAddress, _dividends, _tokens);
157     }
158 
159     /**
160      * Alias of sell() and withdraw().
161      */
162     function exit() public {
163         // get token count for caller & sell them all
164         address _customerAddress = msg.sender;
165         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
166         if(_tokens > 0) sell(_tokens);
167 
168         // lambo delivery service
169         withdraw();
170     }
171 
172     /**
173      * Withdraws all of the callers earnings.
174      */
175     function withdraw() public onlyStronghands() {
176         // setup data
177         address _customerAddress = msg.sender;
178         uint256 _dividends = myDividends();
179 
180         // update dividend tracker
181         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
182 
183         // lambo delivery service
184         _customerAddress.transfer(_dividends);
185 
186         // fire event
187         emit onWithdraw(_customerAddress, _dividends);
188     }
189 
190     /**
191      * Liquifies tokens to ethereum.
192      */
193     function sell(uint256 _amountOfTokens) public onlyBagholders() {
194         // setup data
195         address _customerAddress = msg.sender;
196         // russian hackers BTFO
197         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress], "token to sell should be less then balance!");
198         uint256 _tokens = _amountOfTokens;
199         uint256 _ethereum = tokensToEthereum_(_tokens);
200         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
201         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
202 
203         // burn the sold tokens
204         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
205         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
206 
207         // update dividends tracker
208         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
209         payoutsTo_[_customerAddress] -= _updatedPayouts;      
210 
211         // dividing by zero is a bad idea
212         if (tokenSupply_ > 0) {
213             // update the amount of dividends per token
214             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
215         }
216 
217         // fire event
218         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum);
219     }
220 
221     /**
222      * Transfer tokens from the caller to a new holder.
223      * Remember, there's a 10% fee here as well.
224      */
225     function transfer(address _toAddress, uint256 _amountOfTokens) public onlyBagholders() returns(bool) {
226         // setup
227         address _customerAddress = msg.sender;
228 
229         // make sure we have the requested tokens
230         // also disables transfers until adminstrator phase is over
231         require(!initialState && (_amountOfTokens <= tokenBalanceLedger_[_customerAddress]), "initial state or token > balance!");
232 
233         // withdraw all outstanding dividends first
234         if(myDividends() > 0) withdraw();
235 
236         // liquify 10% of the tokens that are transfered
237         // these are dispersed to shareholders
238         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
239         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
240         uint256 _dividends = tokensToEthereum_(_tokenFee);
241   
242         // burn the fee tokens
243         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
244 
245         // exchange tokens
246         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
247         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
248 
249         // update dividend trackers
250         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
251         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
252 
253         // disperse dividends among holders
254         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
255 
256         // fire event
257         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
258 
259         // ERC20
260         return true;
261     }
262 
263     function payDividends() external payable {
264         uint256 _dividends = msg.value;
265         require(_dividends > 0, "dividends should be greater then 0!");
266         // dividing by zero is a bad idea
267         if (tokenSupply_ > 0) {
268             // update the amount of dividends per token
269             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
270             totalGameDividends_ = SafeMath.add(totalGameDividends_, _dividends);
271             // fire event
272             emit onPayDividends(_dividends, profitPerShare_);
273         }
274     }
275 
276     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
277     /**
278      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
279      */
280     function disableInitialStage() public onlyOwner() {
281         require(initialState == true, "initial stage is already false!");
282         initialState = false;
283     }
284 
285     /**
286      * In case one of us dies, we need to replace ourselves.
287      */
288     function setInitialInvestors(address _addr, bool _status) public onlyOwner() {
289         initialInvestors[_addr] = _status;
290     }
291 
292     /**
293      * If we want to rebrand, we can.
294      */
295     function setName(string _name) public onlyOwner() {
296         name = _name;
297     }
298 
299     /**
300      * If we want to rebrand, we can.
301      */
302     function setSymbol(string _symbol) public onlyOwner() {
303         symbol = _symbol;
304     }
305 
306     /*----------  HELPERS AND CALCULATORS  ----------*/
307     /**
308      * Method to view the current Ethereum stored in the contract
309      * Example: totalEthereumBalance()
310      */
311     function totalEthereumBalance() public view returns(uint) {
312         return address(this).balance;
313     }
314 
315     /**
316      * Retrieve the total token supply.
317      */
318     function totalSupply() public view returns(uint256) {
319         return tokenSupply_;
320     }
321 
322     /**
323      * Retrieve the total Investment.
324      */
325     function totalInvestment() public view returns(uint256) {
326         return totalInvestment_;
327     }
328 
329     /**
330      * Retrieve the total Game Dividends Paid.
331      */
332     function totalGameDividends() public view returns(uint256) {
333         return totalGameDividends_;
334     }
335 
336     /**
337      * Retrieve the tokens owned by the caller.
338      */
339     function myTokens() public view returns(uint256) {
340         address _customerAddress = msg.sender;
341         return balanceOf(_customerAddress);
342     }
343 
344     /**
345      * Retrieve the dividends owned by the caller.
346      */ 
347     function myDividends() public view returns(uint256) {
348         address _customerAddress = msg.sender;
349         return dividendsOf(_customerAddress) ;
350     }
351 
352     /**
353      * Retrieve the token balance of any single address.
354      */
355     function balanceOf(address _customerAddress) public view returns(uint256) {
356         return tokenBalanceLedger_[_customerAddress];
357     }
358 
359     /**
360      * Retrieve the dividend balance of any single address.
361      */
362     function dividendsOf(address _customerAddress) public view returns(uint256) {
363         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
364     }
365 
366     /**
367      * Return the sell price of 1 individual token.
368      */
369     function sellPrice() public view returns(uint256) {
370         // our calculation relies on the token supply, so we need supply.
371         if(tokenSupply_ == 0){
372             return 0;
373         } else {
374             uint256 _ethereum = tokensToEthereum_(1e18);
375             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
376             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
377             return _taxedEthereum;
378         }
379     }
380 
381     /**
382      * Return the buy price of 1 individual token.
383      */
384     function buyPrice() public view returns(uint256) {
385         // our calculation relies on the token supply, so we need supply.
386         if(tokenSupply_ == 0){
387             return tokenPriceInitial_ + tokenPriceIncremental_;
388         } else {
389             uint256 _ethereum = tokensToEthereum_(1e18);
390             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
391             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
392             return _taxedEthereum;
393         }
394     }
395 
396     /**
397      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
398      */
399     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns(uint256) {
400         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
401         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
402         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
403         return _amountOfTokens;
404     }
405 
406     /**
407      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
408      */
409     function calculateEthereumReceived(uint256 _tokensToSell) public view returns(uint256) {
410         require(_tokensToSell <= tokenSupply_, "token to sell should be less then total supply!");
411         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
412         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
413         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
414         return _taxedEthereum;
415     }
416 
417     /*==========================================
418     =            INTERNAL FUNCTIONS            =
419     ==========================================*/
420     function purchaseTokens(uint256 _incomingEthereum) internal onlyInitialInvestors() returns(uint256) {
421         // data setup
422         address _customerAddress = msg.sender;
423         uint256 _dividends = SafeMath.div(_incomingEthereum, dividendFee_);
424         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _dividends);
425         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
426         uint256 _fee = _dividends * magnitude;
427 
428         require((_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_)), "token should be > 0!");
429 
430         // we can't give people infinite ethereum
431         if(tokenSupply_ > 0) {
432 
433             // add tokens to the pool
434             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
435  
436             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
437             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
438 
439             // calculate the amount of tokens the customer receives over his purchase 
440             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
441         } else {
442             // add tokens to the pool
443             tokenSupply_ = _amountOfTokens;
444         }
445 
446         totalInvestment_ = SafeMath.add(totalInvestment_, _incomingEthereum);
447 
448         // update circulating supply & the ledger address for the customer
449         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
450 
451         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
452         //really i know you think you do but you don't
453         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
454         payoutsTo_[_customerAddress] += _updatedPayouts;
455 
456         // disable initial stage if investor quota of 0.01 eth is reached
457         if(address(this).balance >= INVESTOR_QUOTA) {
458             initialState = false;
459         }
460 
461         // fire event
462         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens);
463 
464         return _amountOfTokens;
465     }
466 
467     /**
468      * Calculate Token price based on an amount of incoming ethereum
469      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
470      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
471      */
472     function ethereumToTokens_(uint256 _ethereum) internal view returns(uint256) {
473         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
474         uint256 _tokensReceived = 
475          (
476             (
477                 // underflow attempts BTFO
478                 SafeMath.sub(
479                     (sqrt
480                         (
481                             (_tokenPriceInitial**2)
482                             +
483                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
484                             +
485                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
486                             +
487                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
488                         )
489                     ), _tokenPriceInitial
490                 )
491             )/(tokenPriceIncremental_)
492         )-(tokenSupply_);
493         return _tokensReceived;
494     }
495 
496     /**
497      * Calculate token sell value.
498      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
499      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
500      */
501     function tokensToEthereum_(uint256 _tokens) internal view returns(uint256) {
502         uint256 tokens_ = (_tokens + 1e18);
503         uint256 _tokenSupply = (tokenSupply_ + 1e18);
504         uint256 _etherReceived =
505         (
506             // underflow attempts BTFO
507             SafeMath.sub(
508                 (
509                     (
510                         (
511                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
512                         )-tokenPriceIncremental_
513                     )*(tokens_ - 1e18)
514                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
515             )
516         /1e18);
517         return _etherReceived;
518     }
519 
520     //This is where all your gas goes, sorry
521     //Not sorry, you probably only paid 1 gwei
522     function sqrt(uint x) internal pure returns (uint y) {
523         uint z = (x + 1) / 2;
524         y = x;
525         while (z < y) {
526             y = z;
527             z = (x / z + z) / 2;
528         }
529     }
530 }
531 
532 /**
533  * @title SafeMath
534  * @dev Math operations with safety checks that throw on error
535  */
536 library SafeMath {
537     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
538     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
539     // benefit is lost if 'b' is also tested.
540     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
541         if (_a == 0) {
542             return 0;
543         }
544         uint256 c = _a * _b;
545         require(c / _a == _b);
546         return c;
547     }
548 
549     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
550         require(_b > 0); // Solidity only automatically asserts when dividing by 0
551         uint256 c = _a / _b;
552         return c;
553     }
554 
555     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
556         require(_b <= _a);
557         uint256 c = _a - _b;
558         return c;
559     }
560 
561     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
562         uint256 c = _a + _b;
563         require(c >= _a);
564         return c;
565     }
566 
567     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
568         require(b != 0);
569         return a % b;
570     }
571 }
572 
573 contract Constants {
574     address internal constant OWNER_WALLET_ADDR = address(0x508b828440D72B0De506c86DB79D9E2c19810442);
575     address internal constant COMPANY_WALLET_ADDR = address(0xEE50069c177721fdB06755427Fd19853681E86a2);
576     address internal constant LAST10_WALLET_ADDR = address(0xe7d8Bf9B85EAE450f2153C66cdFDfD31D56750d0);
577     address internal constant FEE_WALLET_ADDR = address(0x6Ba3B9E117F58490eC0e68cf3e48d606C2f2475b);
578     uint internal constant LAST_10_MIN_INVESTMENT = 2 ether;
579 }
580 
581 contract InvestorsStorage {
582     using SafeMath for uint;
583     using Percent for Percent.percent;
584     struct investor {
585         uint keyIndex;
586         uint value;
587         uint paymentTime;
588         uint refs;
589         uint refBonus;
590         uint pendingPayout;
591         uint pendingPayoutTime;
592     }
593     struct recordStats {
594         uint investors;
595         uint invested;
596     }
597     struct itmap {
598         mapping(uint => recordStats) stats;
599         mapping(address => investor) data;
600         address[] keys;
601     }
602     itmap private s;
603 
604     address private owner;
605     
606     Percent.percent private _percent = Percent.percent(1,100);
607 
608     event LogOwnerForInvestorContract(address addr);
609 
610     modifier onlyOwner() {
611         require(msg.sender == owner, "access denied");
612         _;
613     }
614 
615     constructor() public {
616         owner = msg.sender;
617         emit LogOwnerForInvestorContract(msg.sender);
618         s.keys.length++;
619     }
620     
621     function getDividendsPercent(address addr) public view returns(uint num, uint den) {
622         uint amount = s.data[addr].value.add(s.data[addr].refBonus);
623         if(amount <= 10*10**18) { //10 ETH
624             return (15, 1000);
625         } else if(amount <= 50*10**18) { //50 ETH
626             return (16, 1000);
627         } else if(amount <= 100*10**18) { //100 ETH
628             return (17, 1000);
629         } else if(amount <= 300*10**18) { //300 ETH
630             return (185, 10000); //Extra zero for two digits after decimal
631         } else {
632             return (2, 100);
633         }
634     }
635 
636     function insert(address addr, uint value) public onlyOwner returns (bool) {
637         uint keyIndex = s.data[addr].keyIndex;
638         if (keyIndex != 0) return false;
639         s.data[addr].value = value;
640         keyIndex = s.keys.length++;
641         s.data[addr].keyIndex = keyIndex;
642         s.keys[keyIndex] = addr;
643         return true;
644     }
645 
646     function investorFullInfo(address addr) public view returns(uint, uint, uint, uint, uint, uint, uint) {
647         return (
648         s.data[addr].keyIndex,
649         s.data[addr].value,
650         s.data[addr].paymentTime,
651         s.data[addr].refs,
652         s.data[addr].refBonus,
653         s.data[addr].pendingPayout,
654         s.data[addr].pendingPayoutTime
655         );
656     }
657 
658     function investorBaseInfo(address addr) public view returns(uint, uint, uint, uint, uint, uint) {
659         return (
660         s.data[addr].value,
661         s.data[addr].paymentTime,
662         s.data[addr].refs,
663         s.data[addr].refBonus,
664         s.data[addr].pendingPayout,
665         s.data[addr].pendingPayoutTime
666         );
667     }
668 
669     function investorShortInfo(address addr) public view returns(uint, uint) {
670         return (
671         s.data[addr].value,
672         s.data[addr].refBonus
673         );
674     }
675 
676     function addRefBonus(address addr, uint refBonus, uint dividendsPeriod) public onlyOwner returns (bool) {
677         if (s.data[addr].keyIndex == 0) {
678             assert(insert(addr, 0));
679         }
680 
681         uint time;
682         if (s.data[addr].pendingPayoutTime == 0) {
683             time = s.data[addr].paymentTime;
684         } else {
685             time = s.data[addr].pendingPayoutTime;
686         }
687 
688         if(time != 0) {
689             uint value = 0;
690             uint256 daysAfter = now.sub(time).div(dividendsPeriod);
691             if(daysAfter > 0) {
692                 value = _getValueForAddr(addr, daysAfter);
693             }
694             s.data[addr].refBonus += refBonus;
695             uint256 hoursAfter = now.sub(time).mod(dividendsPeriod);
696             if(hoursAfter > 0) {
697                 uint dailyDividends = _getValueForAddr(addr, 1);
698                 uint hourlyDividends = dailyDividends.div(dividendsPeriod).mul(hoursAfter);
699                 value = value.add(hourlyDividends);
700             }
701             if (s.data[addr].pendingPayoutTime == 0) {
702                 s.data[addr].pendingPayout = value;
703             } else {
704                 s.data[addr].pendingPayout = s.data[addr].pendingPayout.add(value);
705             }
706         } else {
707             s.data[addr].refBonus += refBonus;
708             s.data[addr].refs++;
709         }
710         assert(setPendingPayoutTime(addr, now));
711         return true;
712     }
713 
714     function _getValueForAddr(address addr, uint daysAfter) internal returns (uint value) {
715         (uint num, uint den) = getDividendsPercent(addr);
716         _percent = Percent.percent(num, den);
717         value = _percent.mul(s.data[addr].value.add(s.data[addr].refBonus)) * daysAfter;
718     }
719 
720     function addRefBonusWithRefs(address addr, uint refBonus, uint dividendsPeriod) public onlyOwner returns (bool) {
721         if (s.data[addr].keyIndex == 0) {
722             assert(insert(addr, 0));
723         }
724 
725         uint time;
726         if (s.data[addr].pendingPayoutTime == 0) {
727             time = s.data[addr].paymentTime;
728         } else {
729             time = s.data[addr].pendingPayoutTime;
730         }
731 
732         if(time != 0) {
733             uint value = 0;
734             uint256 daysAfter = now.sub(time).div(dividendsPeriod);
735             if(daysAfter > 0) {
736                 value = _getValueForAddr(addr, daysAfter);
737             }
738             s.data[addr].refBonus += refBonus;
739             s.data[addr].refs++;
740             uint256 hoursAfter = now.sub(time).mod(dividendsPeriod);
741             if(hoursAfter > 0) {
742                 uint dailyDividends = _getValueForAddr(addr, 1);
743                 uint hourlyDividends = dailyDividends.div(dividendsPeriod).mul(hoursAfter);
744                 value = value.add(hourlyDividends);
745             }
746             if (s.data[addr].pendingPayoutTime == 0) {
747                 s.data[addr].pendingPayout = value;
748             } else {
749                 s.data[addr].pendingPayout = s.data[addr].pendingPayout.add(value);
750             }
751         } else {
752             s.data[addr].refBonus += refBonus;
753             s.data[addr].refs++;
754         }
755         assert(setPendingPayoutTime(addr, now));
756         return true;
757     }
758 
759     function addValue(address addr, uint value) public onlyOwner returns (bool) {
760         if (s.data[addr].keyIndex == 0) return false;
761         s.data[addr].value += value;       
762         return true;
763     }
764 
765     function updateStats(uint dt, uint invested, uint investors) public {
766         s.stats[dt].invested += invested;
767         s.stats[dt].investors += investors;
768     }
769     
770     function stats(uint dt) public view returns (uint invested, uint investors) {
771         return ( 
772         s.stats[dt].invested,
773         s.stats[dt].investors
774         );
775     }
776 
777     function setPaymentTime(address addr, uint paymentTime) public onlyOwner returns (bool) {
778         if (s.data[addr].keyIndex == 0) return false;
779         s.data[addr].paymentTime = paymentTime;
780         return true;
781     }
782 
783     function setPendingPayoutTime(address addr, uint payoutTime) public onlyOwner returns (bool) {
784         if (s.data[addr].keyIndex == 0) return false;
785         s.data[addr].pendingPayoutTime = payoutTime;
786         return true;
787     }
788 
789     function setPendingPayout(address addr, uint payout) public onlyOwner returns (bool) {
790         if (s.data[addr].keyIndex == 0) return false;
791         s.data[addr].pendingPayout = payout;
792         return true;
793     }
794     
795     function contains(address addr) public view returns (bool) {
796         return s.data[addr].keyIndex > 0;
797     }
798 
799     function size() public view returns (uint) {
800         return s.keys.length;
801     }
802 
803     function iterStart() public pure returns (uint) {
804         return 1;
805     }
806 }
807 
808 contract DT {
809     struct DateTime {
810         uint16 year;
811         uint8 month;
812         uint8 day;
813         uint8 hour;
814         uint8 minute;
815         uint8 second;
816         uint8 weekday;
817     }
818 
819     uint private constant DAY_IN_SECONDS = 86400;
820     uint private constant YEAR_IN_SECONDS = 31536000;
821     uint private constant LEAP_YEAR_IN_SECONDS = 31622400;
822 
823     uint16 private constant ORIGIN_YEAR = 1970;
824 
825     function isLeapYear(uint16 year) internal pure returns (bool) {
826         if (year % 4 != 0) {
827             return false;
828         }
829         if (year % 100 != 0) {
830             return true;
831         }
832         if (year % 400 != 0) {
833             return false;
834         }
835         return true;
836     }
837 
838     function leapYearsBefore(uint year) internal pure returns (uint) {
839         year -= 1;
840         return year / 4 - year / 100 + year / 400;
841     }
842 
843     function getDaysInMonth(uint8 month, uint16 year) internal pure returns (uint8) {
844         if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
845             return 31;
846         } else if (month == 4 || month == 6 || month == 9 || month == 11) {
847             return 30;
848         } else if (isLeapYear(year)) {
849             return 29;
850         } else {
851             return 28;
852         }
853     }
854 
855     function parseTimestamp(uint timestamp) internal pure returns (DateTime dt) {
856         uint secondsAccountedFor = 0;
857         uint buf;
858         uint8 i;
859 
860         // Year
861         dt.year = getYear(timestamp);
862         buf = leapYearsBefore(dt.year) - leapYearsBefore(ORIGIN_YEAR);
863 
864         secondsAccountedFor += LEAP_YEAR_IN_SECONDS * buf;
865         secondsAccountedFor += YEAR_IN_SECONDS * (dt.year - ORIGIN_YEAR - buf);
866 
867         // Month
868         uint secondsInMonth;
869         for (i = 1; i <= 12; i++) {
870             secondsInMonth = DAY_IN_SECONDS * getDaysInMonth(i, dt.year);
871             if (secondsInMonth + secondsAccountedFor > timestamp) {
872                 dt.month = i;
873                 break;
874             }
875             secondsAccountedFor += secondsInMonth;
876         }
877 
878         // Day
879         for (i = 1; i <= getDaysInMonth(dt.month, dt.year); i++) {
880             if (DAY_IN_SECONDS + secondsAccountedFor > timestamp) {
881                 dt.day = i;
882                 break;
883             }
884             secondsAccountedFor += DAY_IN_SECONDS;
885         }
886     }
887 
888         
889     function getYear(uint timestamp) internal pure returns (uint16) {
890         uint secondsAccountedFor = 0;
891         uint16 year;
892         uint numLeapYears;
893 
894         // Year
895         year = uint16(ORIGIN_YEAR + timestamp / YEAR_IN_SECONDS);
896         numLeapYears = leapYearsBefore(year) - leapYearsBefore(ORIGIN_YEAR);
897 
898         secondsAccountedFor += LEAP_YEAR_IN_SECONDS * numLeapYears;
899         secondsAccountedFor += YEAR_IN_SECONDS * (year - ORIGIN_YEAR - numLeapYears);
900 
901         while (secondsAccountedFor > timestamp) {
902             if (isLeapYear(uint16(year - 1))) {
903                 secondsAccountedFor -= LEAP_YEAR_IN_SECONDS;
904             }
905             else {
906                 secondsAccountedFor -= YEAR_IN_SECONDS;
907             }
908             year -= 1;
909         }
910         return year;
911     }
912 
913     function getMonth(uint timestamp) internal pure returns (uint8) {
914         return parseTimestamp(timestamp).month;
915     }
916 
917     function getDay(uint timestamp) internal pure returns (uint8) {
918         return parseTimestamp(timestamp).day;
919     }
920 }
921 
922 contract _200eth is DT, Constants {
923     using Percent for Percent.percent;
924     using SafeMath for uint;
925     using Zero for *;
926     using ToAddress for *;
927     using Convert for *;
928 
929     // investors storage - iterable map;
930     InvestorsStorage private m_investors = new InvestorsStorage();
931     mapping(address => address) public m_referrals;
932     mapping(address => bool) public m_isInvestor;
933     bool public m_nextWave = false;
934 
935     // last 10 storage who's investment >= 2 ether
936     struct Last10Struct {
937         uint value;
938         uint index;
939     }
940     address[] private m_last10InvestorAddr;
941     mapping(address => Last10Struct) private m_last10Investor;
942 
943     // automatically generates getters
944     address public ownerAddr;
945     uint public totalInvestments = 0;
946     uint public totalInvested = 0;
947     uint public constant minInvesment = 10 finney; // 0.01 eth
948     uint public constant dividendsPeriod = 5 minutes; //5 minutes
949     uint private gasFee = 0;
950     uint private last10 = 0;
951 
952     //Pyramid Coin instance required to send dividends to coin holders.
953     E2D public e2d;
954 
955     // percents 
956     Percent.percent private m_companyPercent = Percent.percent(10, 100); // 10/100*100% = 10%
957     Percent.percent private m_refPercent1 = Percent.percent(3, 100); // 3/100*100% = 3%
958     Percent.percent private m_refPercent2 = Percent.percent(2, 100); // 2/100*100% = 2%
959     Percent.percent private m_fee = Percent.percent(1, 100); // 1/100*100% = 1%
960     Percent.percent private m_coinHolders = Percent.percent(5, 100); // 5/100*100% = 5%
961     Percent.percent private m_last10 = Percent.percent(4, 100); // 4/100*100% = 4%
962     Percent.percent private _percent = Percent.percent(1,100);
963 
964     // more events for easy read from blockchain
965     event LogNewInvestor(address indexed addr, uint when, uint value);
966     event LogNewInvesment(address indexed addr, uint when, uint value);
967     event LogNewReferral(address indexed addr, uint when, uint value);
968     event LogPayDividends(address indexed addr, uint when, uint value);
969     event LogBalanceChanged(uint when, uint balance);
970     event LogNextWave(uint when);
971     event LogPayLast10(address addr, uint percent, uint amount);
972 
973     modifier balanceChanged {
974         _;
975         emit LogBalanceChanged(now, address(this).balance.sub(last10).sub(gasFee));
976     }
977 
978     constructor(address _tokenAddress) public {
979         ownerAddr = OWNER_WALLET_ADDR;
980         e2d = E2D(_tokenAddress);
981         setup();
982     }
983 
984     function isContract(address _addr) private view returns (bool isWalletAddress){
985         uint32 size;
986         assembly{
987             size := extcodesize(_addr)
988         }
989         return (size > 0);
990     }
991 
992     function setup() internal {
993         m_investors = new InvestorsStorage();
994         totalInvestments = 0;
995         totalInvested = 0;
996         gasFee = 0;
997         last10 = 0;
998         for (uint i = 0; i < m_last10InvestorAddr.length; i++) {
999             delete m_last10Investor[m_last10InvestorAddr[i]];
1000         }
1001         m_last10InvestorAddr.length = 1;
1002     }
1003 
1004     // start the next round of game only after previous is completed.
1005     function startNewWave() public {
1006         require(m_nextWave == true, "Game is not stopped yet.");
1007         require(msg.sender == ownerAddr, "Only Owner can call this function");
1008         m_nextWave = false;
1009     }
1010 
1011     function() public payable {
1012         // investor get him dividends
1013         if (msg.value == 0) {
1014             getMyDividends();
1015             return;
1016         }
1017         // sender do invest
1018         address refAddr = msg.data.toAddr();
1019         doInvest(refAddr);
1020     }
1021 
1022     function investorsNumber() public view returns(uint) {
1023         return m_investors.size() - 1;
1024         // -1 because see InvestorsStorage constructor where keys.length++ 
1025     }
1026 
1027     function balanceETH() public view returns(uint) {
1028         return address(this).balance.sub(last10).sub(gasFee);
1029     }
1030 
1031     function dividendsPercent() public view returns(uint numerator, uint denominator) {
1032         (uint num, uint den) = m_investors.getDividendsPercent(msg.sender);
1033         (numerator, denominator) = (num,den);
1034     }
1035 
1036     function companyPercent() public view returns(uint numerator, uint denominator) {
1037         (numerator, denominator) = (m_companyPercent.num, m_companyPercent.den);
1038     }
1039 
1040     function coinHolderPercent() public view returns(uint numerator, uint denominator) {
1041         (numerator, denominator) = (m_coinHolders.num, m_coinHolders.den);
1042     }
1043 
1044     function last10Percent() public view returns(uint numerator, uint denominator) {
1045         (numerator, denominator) = (m_last10.num, m_last10.den);
1046     }
1047 
1048     function feePercent() public view returns(uint numerator, uint denominator) {
1049         (numerator, denominator) = (m_fee.num, m_fee.den);
1050     }
1051 
1052     function referrer1Percent() public view returns(uint numerator, uint denominator) {
1053         (numerator, denominator) = (m_refPercent1.num, m_refPercent1.den);
1054     }
1055 
1056     function referrer2Percent() public view returns(uint numerator, uint denominator) {
1057         (numerator, denominator) = (m_refPercent2.num, m_refPercent2.den);
1058     }
1059 
1060     function stats(uint date) public view returns(uint invested, uint investors) {
1061         (invested, investors) = m_investors.stats(date);
1062     }
1063 
1064     function last10Addr() public view returns(address[]) {
1065         return m_last10InvestorAddr;
1066     }
1067 
1068     function last10Info(address addr) public view returns(uint value, uint index) {
1069         return (
1070             m_last10Investor[addr].value,
1071             m_last10Investor[addr].index
1072         );
1073     }
1074 
1075     function investorInfo(address addr) public view returns(uint value, uint paymentTime, uint refsCount, uint refBonus,
1076      uint pendingPayout, uint pendingPayoutTime, bool isReferral, uint dividends) {
1077         (value, paymentTime, refsCount, refBonus, pendingPayout, pendingPayoutTime) = m_investors.investorBaseInfo(addr);
1078         isReferral = m_referrals[addr].notZero();
1079         dividends = checkDividends(addr);
1080     }
1081 
1082     function checkDividends(address addr) internal view returns (uint) {
1083         InvestorsStorage.investor memory investor = getMemInvestor(addr);
1084         if(investor.keyIndex <= 0){
1085             return 0;
1086         }
1087         uint256 time;
1088         uint256 value = 0;
1089         if(investor.pendingPayoutTime == 0) {
1090             time = investor.paymentTime;
1091         } else {
1092             time = investor.pendingPayoutTime;
1093             value = investor.pendingPayout;
1094         }
1095         // calculate days after payout time
1096         uint256 daysAfter = now.sub(time).div(dividendsPeriod);
1097         if(daysAfter > 0){
1098             uint256 totalAmount = investor.value.add(investor.refBonus);
1099             (uint num, uint den) = m_investors.getDividendsPercent(addr);
1100             value = value.add((totalAmount*num/den) * daysAfter);
1101         }
1102         return value;
1103     }
1104 
1105     function _getMyDividents(bool withoutThrow) private {
1106         address addr = msg.sender;
1107         require(!isContract(addr),"msg.sender must wallet");
1108         // check investor info
1109         InvestorsStorage.investor memory investor = getMemInvestor(addr);
1110         if(investor.keyIndex <= 0){
1111             if(withoutThrow){
1112                 return;
1113             }
1114             revert("sender is not investor");
1115         }
1116         uint256 time;
1117         uint256 value = 0;
1118         if(investor.pendingPayoutTime == 0) {
1119             time = investor.paymentTime;
1120         } else {
1121             time = investor.pendingPayoutTime;
1122             value = investor.pendingPayout;
1123         }
1124 
1125         // calculate days after payout time
1126         uint256 daysAfter = now.sub(time).div(dividendsPeriod);
1127         if(daysAfter > 0){
1128             uint256 totalAmount = investor.value.add(investor.refBonus);
1129             (uint num, uint den) = m_investors.getDividendsPercent(addr);
1130             value = value.add((totalAmount*num/den) * daysAfter);
1131         }
1132         if(value == 0) {
1133             if(withoutThrow){
1134                 return;
1135             }
1136             revert("the latest payment was earlier than dividents period");
1137         } else {
1138             if (checkBalanceState(addr, value)) {
1139                 return;
1140             }
1141         }
1142 
1143         assert(m_investors.setPaymentTime(msg.sender, now));
1144 
1145         assert(m_investors.setPendingPayoutTime(msg.sender, 0));
1146 
1147         assert(m_investors.setPendingPayout(msg.sender, 0));
1148 
1149         sendDividends(msg.sender, value);
1150     }
1151 
1152     function checkBalanceState(address addr, uint value) private returns(bool) {
1153         uint checkBal = address(this).balance.sub(last10).sub(gasFee);
1154         if(checkBal < value) {
1155             sendDividends(addr, checkBal);
1156             return true;
1157         }
1158         return false;
1159     }
1160 
1161     function getMyDividends() public balanceChanged {
1162         _getMyDividents(false);
1163     }
1164 
1165     function doInvest(address _ref) public payable balanceChanged {
1166         require(!isContract(msg.sender),"msg.sender must wallet address");
1167         require(msg.value >= minInvesment, "msg.value must be >= minInvesment");
1168         require(!m_nextWave, "no further investment in this pool");
1169         uint value = msg.value;
1170         //ref system works only once for sender-referral
1171         if ((!m_isInvestor[msg.sender] && !m_referrals[msg.sender].notZero()) || 
1172         (m_isInvestor[msg.sender] && m_referrals[msg.sender].notZero())) {
1173             address ref = m_referrals[msg.sender].notZero() ? m_referrals[msg.sender] : _ref;
1174             // level 1
1175             if(notZeroNotSender(ref) && m_isInvestor[ref]) {
1176                 // referrer 1 bonus
1177                 uint reward = m_refPercent1.mul(value);
1178                 if(m_referrals[msg.sender].notZero()) {
1179                     assert(m_investors.addRefBonus(ref, reward, dividendsPeriod));
1180                 } else {
1181                     assert(m_investors.addRefBonusWithRefs(ref, reward, dividendsPeriod));
1182                     m_referrals[msg.sender] = ref;
1183                 }
1184                 emit LogNewReferral(msg.sender, now, value); 
1185                 // level 2
1186                 if (notZeroNotSender(m_referrals[ref]) && m_isInvestor[m_referrals[ref]] && ref != m_referrals[ref]) { 
1187                     reward = m_refPercent2.mul(value);
1188                     assert(m_investors.addRefBonus(m_referrals[ref], reward, dividendsPeriod)); // referrer 2 bonus
1189                 }
1190             }
1191         }
1192 
1193         checkLast10(value);
1194 
1195         // company commission
1196         COMPANY_WALLET_ADDR.transfer(m_companyPercent.mul(value));
1197          // coin holder commission
1198         e2d.payDividends.value(m_coinHolders.mul(value))();
1199          // reserved for last 10 distribution
1200         last10 = last10.add(m_last10.mul(value));
1201         //reserved for gas fee
1202         gasFee = gasFee.add(m_fee.mul(value));
1203 
1204         _getMyDividents(true);
1205 
1206         DT.DateTime memory dt = parseTimestamp(now);
1207         uint today = dt.year.uintToString().strConcat((dt.month<10 ? "0":""), dt.month.uintToString(), (dt.day<10 ? "0":""), dt.day.uintToString()).stringToUint();
1208 
1209         //write to investors storage
1210         if (m_investors.contains(msg.sender)) {
1211             assert(m_investors.addValue(msg.sender, value));
1212             m_investors.updateStats(today, value, 0);
1213         } else {
1214             assert(m_investors.insert(msg.sender, value));
1215             m_isInvestor[msg.sender] = true;
1216             m_investors.updateStats(today, value, 1);
1217             emit LogNewInvestor(msg.sender, now, value); 
1218         }
1219 
1220         assert(m_investors.setPaymentTime(msg.sender, now));
1221 
1222         emit LogNewInvesment(msg.sender, now, value);   
1223         totalInvestments++;
1224         totalInvested += msg.value;
1225     }
1226 
1227     function checkLast10(uint value) internal {
1228         //check if value is >= 2 then add to last 10 
1229         if(value >= LAST_10_MIN_INVESTMENT) {
1230             if(m_last10Investor[msg.sender].index != 0) {
1231                 uint index = m_last10Investor[msg.sender].index;
1232                 removeFromLast10AtIndex(index);
1233             } else if(m_last10InvestorAddr.length == 11) {
1234                 delete m_last10Investor[m_last10InvestorAddr[1]];
1235                 removeFromLast10AtIndex(1);
1236             }
1237             m_last10InvestorAddr.push(msg.sender);
1238             m_last10Investor[msg.sender].index = m_last10InvestorAddr.length - 1;
1239             m_last10Investor[msg.sender].value = value;
1240         }
1241     }
1242 
1243     function removeFromLast10AtIndex(uint index) internal {
1244         for (uint i = index; i < m_last10InvestorAddr.length-1; i++){
1245             m_last10InvestorAddr[i] = m_last10InvestorAddr[i+1];
1246             m_last10Investor[m_last10InvestorAddr[i]].index = i;
1247         }
1248         delete m_last10InvestorAddr[m_last10InvestorAddr.length-1];
1249         m_last10InvestorAddr.length--;
1250     }
1251 
1252     function getMemInvestor(address addr) internal view returns(InvestorsStorage.investor) {
1253         (uint a, uint b, uint c, uint d, uint e, uint f, uint g) = m_investors.investorFullInfo(addr);
1254         return InvestorsStorage.investor(a, b, c, d, e, f, g);
1255     }
1256 
1257     function notZeroNotSender(address addr) internal view returns(bool) {
1258         return addr.notZero() && addr != msg.sender;
1259     }
1260 
1261     function sendDividends(address addr, uint value) private {
1262         if (addr.send(value)) {
1263             emit LogPayDividends(addr, now, value);
1264             if(address(this).balance.sub(gasFee).sub(last10) <= 0.005 ether) {
1265                 nextWave();
1266                 return;
1267             }
1268         }
1269     }
1270 
1271     function sendToLast10() private {
1272         uint lastPos = m_last10InvestorAddr.length - 1;
1273         uint index = 0;
1274         uint distributed = 0;
1275         for (uint pos = lastPos; pos > 0 ; pos--) {
1276             _percent = getPercentByPosition(index);
1277             uint amount = _percent.mul(last10);
1278             if( (!isContract(m_last10InvestorAddr[pos]))){
1279                 m_last10InvestorAddr[pos].transfer(amount);
1280                 emit LogPayLast10(m_last10InvestorAddr[pos], _percent.num, amount);
1281                 distributed = distributed.add(amount);
1282             }
1283             index++;
1284         }
1285 
1286         last10 = last10.sub(distributed);
1287         //check if amount is left in last10 and transfer 
1288         if(last10 > 0) {
1289             LAST10_WALLET_ADDR.transfer(last10);
1290             last10 = 0;
1291         }
1292     }
1293 
1294     function getPercentByPosition(uint position) internal pure returns(Percent.percent) {
1295         if(position == 0) {
1296             return Percent.percent(40, 100); // 40%
1297         } else if(position == 1) {
1298             return Percent.percent(25, 100); // 25%
1299         } else if(position == 2) {
1300             return Percent.percent(15, 100); // 15%
1301         } else if(position == 3) {
1302             return Percent.percent(8, 100); // 8%
1303         } else if(position == 4) {
1304             return Percent.percent(5, 100); // 5%
1305         } else if(position == 5) {
1306             return Percent.percent(2, 100); // 2%
1307         } else if(position == 6) {
1308             return Percent.percent(2, 100); // 2%
1309         } else if(position == 7) {
1310             return Percent.percent(15, 1000); // 1.5%
1311         } else if(position == 8) {
1312             return Percent.percent(1, 100); // 1%
1313         } else if(position == 9) {
1314             return Percent.percent(5, 1000); // 0.5%
1315         }
1316     }
1317 
1318     function nextWave() private {
1319         if(m_nextWave) {
1320             return; 
1321         }
1322         m_nextWave = true;
1323         sendToLast10();
1324         //send gas fee to wallet
1325         FEE_WALLET_ADDR.transfer(gasFee);
1326         //send remaining contract balance to company wallet
1327         COMPANY_WALLET_ADDR.transfer(address(this).balance);
1328         setup();
1329         emit LogNextWave(now);
1330     }
1331 }
1332 
1333 library Percent {
1334   // Solidity automatically throws when dividing by 0
1335     struct percent {
1336         uint num;
1337         uint den;
1338     }
1339     function mul(percent storage p, uint a) internal view returns (uint) {
1340         if (a == 0) {
1341             return 0;
1342         }
1343         return a*p.num/p.den;
1344     }
1345     
1346     function div(percent storage p, uint a) internal view returns (uint) {
1347         return a/p.num*p.den;
1348     }
1349 
1350     function sub(percent storage p, uint a) internal view returns (uint) {
1351         uint b = mul(p, a);
1352         if (b >= a) return 0;
1353         return a - b;
1354     }
1355 
1356     function add(percent storage p, uint a) internal view returns (uint) {
1357         return a + mul(p, a);
1358     }
1359 }
1360 
1361 library Zero {
1362     function requireNotZero(uint a) internal pure {
1363         require(a != 0, "require not zero");
1364     }
1365 
1366     function requireNotZero(address addr) internal pure {
1367         require(addr != address(0), "require not zero address");
1368     }
1369 
1370     function notZero(address addr) internal pure returns(bool) {
1371         return !(addr == address(0));
1372     }
1373 
1374     function isZero(address addr) internal pure returns(bool) {
1375         return addr == address(0);
1376     }
1377 }
1378 
1379 library ToAddress {
1380     function toAddr(uint source) internal pure returns(address) {
1381         return address(source);
1382     }
1383 
1384     function toAddr(bytes source) internal pure returns(address addr) {
1385         assembly { addr := mload(add(source,0x14)) }
1386         return addr;
1387     }
1388 }
1389 
1390 library Convert {
1391     function stringToUint(string s) internal pure returns (uint) {
1392         bytes memory b = bytes(s);
1393         uint result = 0;
1394         for (uint i = 0; i < b.length; i++) { // c = b[i] was not needed
1395             if (b[i] >= 48 && b[i] <= 57) {
1396                 result = result * 10 + (uint(b[i]) - 48); // bytes and int are not compatible with the operator -.
1397             }
1398         }
1399         return result; // this was missing
1400     }
1401 
1402     function uintToString(uint v) internal pure returns (string) {
1403         uint maxlength = 100;
1404         bytes memory reversed = new bytes(maxlength);
1405         uint i = 0;
1406         while (v != 0) {
1407             uint remainder = v % 10;
1408             v = v / 10;
1409             reversed[i++] = byte(48 + remainder);
1410         }
1411         bytes memory s = new bytes(i); // i + 1 is inefficient
1412         for (uint j = 0; j < i; j++) {
1413             s[j] = reversed[i - j - 1]; // to avoid the off-by-one error
1414         }
1415         string memory str = string(s);  // memory isn't implicitly convertible to storage
1416         return str; // this was missing
1417     }
1418 
1419     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string){
1420         bytes memory _ba = bytes(_a);
1421         bytes memory _bb = bytes(_b);
1422         bytes memory _bc = bytes(_c);
1423         bytes memory _bd = bytes(_d);
1424         bytes memory _be = bytes(_e);
1425         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
1426         bytes memory babcde = bytes(abcde);
1427         uint k = 0;
1428         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
1429         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
1430         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
1431         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
1432         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
1433         return string(babcde);
1434     }
1435     
1436     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
1437         return strConcat(_a, _b, _c, _d, "");
1438     }
1439     
1440     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
1441         return strConcat(_a, _b, _c, "", "");
1442     }
1443     
1444     function strConcat(string _a, string _b) internal pure returns (string) {
1445         return strConcat(_a, _b, "", "", "");
1446     }
1447 }