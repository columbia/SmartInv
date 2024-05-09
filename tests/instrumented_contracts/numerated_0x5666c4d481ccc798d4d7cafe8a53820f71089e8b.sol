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