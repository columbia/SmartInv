1 pragma solidity ^0.4.25;
2 
3 /*
4 
5 
6  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄        ▄▄▄▄▄▄▄▄▄▄▄  ▄            ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄ 
7 ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░▌      ▐░░░░░░░░░░░▌▐░▌          ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌
8 ▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀█░▌     ▐░█▀▀▀▀▀▀▀█░▌▐░▌          ▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀█░▌ ▀▀▀▀█░█▀▀▀▀ 
9 ▐░▌       ▐░▌▐░▌          ▐░▌       ▐░▌     ▐░▌       ▐░▌▐░▌          ▐░▌          ▐░▌       ▐░▌     ▐░▌     
10 ▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄▄▄ ▐░▌       ▐░▌     ▐░█▄▄▄▄▄▄▄█░▌▐░▌          ▐░█▄▄▄▄▄▄▄▄▄ ▐░█▄▄▄▄▄▄▄█░▌     ▐░▌     
11 ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌     ▐░░░░░░░░░░░▌▐░▌          ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌     ▐░▌     
12 ▐░█▀▀▀▀█░█▀▀ ▐░█▀▀▀▀▀▀▀▀▀ ▐░▌       ▐░▌     ▐░█▀▀▀▀▀▀▀█░▌▐░▌          ▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀█░█▀▀      ▐░▌     
13 ▐░▌     ▐░▌  ▐░▌          ▐░▌       ▐░▌     ▐░▌       ▐░▌▐░▌          ▐░▌          ▐░▌     ▐░▌       ▐░▌     
14 ▐░▌      ▐░▌ ▐░█▄▄▄▄▄▄▄▄▄ ▐░█▄▄▄▄▄▄▄█░▌     ▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄▄▄ ▐░█▄▄▄▄▄▄▄▄▄ ▐░▌      ▐░▌      ▐░▌     
15 ▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░▌      ▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌     ▐░▌     
16  ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀        ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀         ▀       ▀      
17                                                                                                              
18 
19 website:    https://redalert.ga
20 
21 discord:    https://discord.gg/8AFP9gS
22 
23 20% Dividends Fees/Payouts for Exchange
24 
25 2.5% Buy Fee for Bomb Shelter Insurance
26 
27 2.5% Buy Fee for Bomb Shelter Card Yield Dividends
28 
29 
30 
31 Bomb Shelter Card Game:
32 
33 While you hold a Bomb Shelter Card you will receive dividend Yield Payouts from the Exchange 
34 and from other Card Transactions.
35 
36 When someone buys your Bomb Shelter Card:
37    - The card price automatically increases by 25%
38    - The previous owner receives the amount the prior card price plus 45% of the price gain
39    - Other card holders receive 40% of the gain split in relation to their yield amounts
40    - 5% of the gain goes to the exchange token holders as dividends
41    - 5% of the gain goes to bomb shelter insurance
42 
43 Every 8 Hours there is a Red Alert Scramble lasting 1 Hour
44 
45 During the alert the Bomb Shelter Card Half Life Time is 25 Minutes
46 
47 During Each 7 Hour All Clear Period the Half Life Time is 5 Hours
48 
49 If you hold a Bomb Shelter Card when it experiences a Half-life Cut:
50 
51    - Your Bomb Shelter Price will reduce by 3%
52    - You will receive 5% of the Shelter Insurance Fund on every Half-Life Cut
53 
54 
55 Referral Program pays out 33% of Exchange Buy-in Fees to user of masternode link
56 
57 */
58 
59 contract AcceptsExchange {
60     redalert public tokenContract;
61 
62     function AcceptsExchange(address _tokenContract) public {
63         tokenContract = redalert(_tokenContract);
64     }
65 
66     modifier onlyTokenContract {
67         require(msg.sender == address(tokenContract));
68         _;
69     }
70 
71     /**
72     * @dev Standard ERC677 function that will handle incoming token transfers.
73     *
74     * @param _from  Token sender address.
75     * @param _value Amount of tokens.
76     * @param _data  Transaction metadata.
77     */
78     function tokenFallback(address _from, uint256 _value, bytes _data) external returns (bool);
79     function tokenFallbackExpanded(address _from, uint256 _value, bytes _data, address _sender, address _referrer) external returns (bool);
80 }
81 
82 contract redalert {
83     /*=================================
84     =            MODIFIERS            =
85     =================================*/
86     // only people with tokens
87     modifier onlyBagholders() {
88         require(myTokens() > 0);
89         _;
90     }
91     
92     // only people with profits
93     modifier onlyStronghands() {
94         require(myDividends(true) > 0 || ownerAccounts[msg.sender] > 0);
95         //require(myDividends(true) > 0);
96         _;
97     }
98     
99       modifier notContract() {
100       require (msg.sender == tx.origin);
101       _;
102     }
103 
104     modifier allowPlayer(){
105         
106         require(boolAllowPlayer);
107         _;
108     }
109 
110     // administrators can:
111     // -> change the name of the contract
112     // -> change the name of the token
113     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
114     // they CANNOT:
115     // -> take funds
116     // -> disable withdrawals
117     // -> kill the contract
118     // -> change the price of tokens
119     modifier onlyAdministrator(){
120         address _customerAddress = msg.sender;
121         require(administrators[_customerAddress]);
122         _;
123     }
124     
125     modifier onlyActive(){
126         require(boolContractActive);
127         _;
128     }
129 
130      modifier onlyCardActive(){
131         require(boolCardActive);
132         _;
133     }
134 
135     
136     // ensures that the first tokens in the contract will be equally distributed
137     // meaning, no divine dump will be ever possible
138     // result: healthy longevity.
139     modifier antiEarlyWhale(uint256 _amountOfEthereum){
140         address _customerAddress = msg.sender;
141         
142         // are we still in the vulnerable phase?
143         // if so, enact anti early whale protocol 
144         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
145             require(
146                 // is the customer in the ambassador list?
147                 (ambassadors_[_customerAddress] == true &&
148                 
149                 // does the customer purchase exceed the max ambassador quota?
150                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_) ||
151 
152                 (_customerAddress == dev)
153                 
154             );
155             
156             // updated the accumulated quota    
157             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
158         
159             // execute
160             _;
161         } else {
162             // in case the ether count drops low, the ambassador phase won't reinitiate
163             onlyAmbassadors = false;
164             _;    
165         }
166         
167     }
168     
169     /*==============================
170     =            EVENTS            =
171     ==============================*/
172 
173     event onCardBuy(
174         address customerAddress,
175         uint256 incomingEthereum,
176         uint256 card,
177         uint256 newPrice,
178         uint256 halfLifeTime
179     );
180 
181     event onInsuranceChange(
182         address customerAddress,
183         uint256 card,
184         uint256 insuranceAmount
185     );
186 
187     event onTokenPurchase(
188         address indexed customerAddress,
189         uint256 incomingEthereum,
190         uint256 tokensMinted,
191         address indexed referredBy
192     );
193     
194     event onTokenSell(
195         address indexed customerAddress,
196         uint256 tokensBurned,
197         uint256 ethereumEarned
198     );
199     
200     event onReinvestment(
201         address indexed customerAddress,
202         uint256 ethereumReinvested,
203         uint256 tokensMinted
204     );
205     
206     event onWithdraw(
207         address indexed customerAddress,
208         uint256 ethereumWithdrawn
209     );
210     
211     // ERC20
212     event Transfer(
213         address indexed from,
214         address indexed to,
215         uint256 tokens
216     );
217     
218        // HalfLife
219     event Halflife(
220         address customerAddress,
221         uint card,
222         uint price,
223         uint newBlockTime,
224         uint insurancePay,
225         uint cardInsurance
226     );
227     
228     /*=====================================
229     =            CONFIGURABLES            =
230     =====================================*/
231     string public name = "RedAlert";
232     string public symbol = "REDS";
233     uint8 constant public decimals = 18;
234     uint256 constant internal tokenPriceInitial_ = 0.00000001 ether;
235     uint256 constant internal tokenPriceIncremental_ = 0.000000001 ether;
236     uint256 constant internal magnitude = 2**64;
237     
238     // proof of stake (defaults at 100 tokens)
239     uint256 public stakingRequirement = 100e18;
240     
241     // ambassador program
242     mapping(address => bool) internal ambassadors_;
243     uint256 constant internal ambassadorMaxPurchase_ = 3 ether;
244     uint256 constant internal ambassadorQuota_ = 100 ether;
245     
246     address dev;
247 
248     uint public nextAvailableCard;
249 
250     address add2 = 0x0;
251 
252     uint public totalCardValue = 0;
253 
254     uint public totalCardInsurance = 0;
255 
256     bool public boolAllowPlayer = false;
257 
258     //TIME
259     struct DateTime {
260         uint16 year;
261         uint8 month;
262         uint8 day;
263         uint8 hour;
264         uint8 minute;
265         uint8 second;
266         uint8 weekday;
267     }
268 
269     uint constant DAY_IN_SECONDS = 86400;
270     uint constant YEAR_IN_SECONDS = 31536000;
271     uint constant LEAP_YEAR_IN_SECONDS = 31622400;
272 
273     uint constant HOUR_IN_SECONDS = 3600;
274     uint constant MINUTE_IN_SECONDS = 60;
275 
276     uint16 constant ORIGIN_YEAR = 1970;
277 
278     
279    /*================================
280     =            DATASETS            =
281     ================================*/
282     // amount of shares for each address (scaled number)
283     mapping(address => uint256) internal tokenBalanceLedger_;
284     mapping(address => uint256) internal referralBalance_;
285     mapping(address => int256) internal payoutsTo_;
286     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
287     uint256 internal tokenSupply_ = 0;
288     uint256 internal profitPerShare_;
289 
290     //CARDS
291     mapping(uint => address) internal cardOwner;
292     mapping(uint => uint) public cardPrice;
293     mapping(uint => uint) public basePrice;
294     mapping(uint => uint) internal cardPreviousPrice;
295     mapping(address => uint) internal ownerAccounts;
296     mapping(uint => uint) internal totalCardDivs;
297     mapping(uint => uint) internal totalCardDivsETH;
298     mapping(uint => string) internal cardName;
299     mapping(uint => uint) internal cardInsurance;
300 
301     uint public cardInsuranceAccount;
302 
303     uint cardPriceIncrement = 1250;   //25% Price Increases
304    
305     uint totalDivsProduced;
306 
307     //card rates
308     uint public ownerDivRate = 450;     //Split to previous card owner  45%
309     uint public distDivRate = 400;      //Split to other card owners  40%
310     uint public devDivRate = 50;        //Dev 5%
311     uint public insuranceDivRate = 50;  //Split to Shelter Insurance Accounts 5%
312     uint public yieldDivRate = 50;      //Split back to Exchange Token Holders 5%
313     uint public referralRate = 50;      //Split to Referrals if allowed 5%
314     
315     mapping(uint => uint) internal cardBlockNumber;
316 
317     uint public halfLifeTime = 5900;            //1 day half life period
318     uint public halfLifeRate = 970;             //cut price by 3% each half life period
319     uint public halfLifeReductionRate = 970;    //cut previous price by 3%
320 
321 
322     uint public halfLifeClear = 1230;     //Half-Life Clear Period(5 Hours)
323     uint public halfLifeAlert = 100;     //Half-Life Alert Period(25 Mins)
324 
325     bool public allowHalfLife = true;  //for cards
326 
327     bool public allowReferral = false;  //for cards
328 
329     uint public insurancePayoutRate = 50; //pay 5% of the remaining insurance fund for that card on each half-life
330 
331     uint8 public dividendFee_ = 150;            
332 
333     uint8 public dividendFeeBuyClear_ = 150;
334     uint8 public dividendFeeSellClear_ = 200;
335 
336     uint8 public dividendFeeBuyAlert_ = 150;
337     uint8 public dividendFeeSellAlert_ = 200;
338 
339     uint8 public cardInsuranceFeeRate_ = 25;    // 2.5% fee rate on each buy and sell for Shelter Card Insurance
340     uint8 public yieldDividendFeeRate_ = 25;    // 2.5% fee rate on each buy and sell for Shelter Card Yield Dividends
341 
342     //uint8 public investorFeeRate_ = 10;//10;  // 1% fee for investors
343 
344     uint public maxCards = 50;
345 
346     bool public boolContractActive = false;
347     bool public boolCardActive = false;
348 
349     // administrator list (see above on what they can do)
350     mapping(address => bool) public administrators;
351     
352     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
353     bool public onlyAmbassadors = true;
354 
355       // Special Wall Street Market Platform control from scam game contracts on Wall Street Market platform
356     mapping(address => bool) public canAcceptTokens_; // contracts, which can accept Wall Street tokens
357 
358     uint public alertTime1 = 0;
359     uint public alertTime2 = 8;
360     uint public alertTime3 = 16;
361 
362     uint public lastHour = 0;
363 
364     bool public boolAlertStatus = false;
365 
366 
367 
368     /*=======================================
369     =            PUBLIC FUNCTIONS            =
370     =======================================*/
371     /*
372     * -- APPLICATION ENTRY POINTS --  
373     */
374     function redalert()
375     public
376     {
377         allowHalfLife = true;
378         allowReferral = false;
379 
380         // add administrators here
381         administrators[msg.sender] = true;
382 
383         dev = msg.sender;
384 
385         ambassadors_[dev] = true;
386         ambassadors_[0x96762288ebb2560a19F8eAdAaa2012504F64278B] = true;
387         ambassadors_[0x5145A296e1bB9d4Cf468d6d97d7B6D15700f39EF] = true;
388         ambassadors_[0xE74b1ea522B9d558C8e8719c3b1C4A9050b531CA] = true;
389         ambassadors_[0xb62A0AC2338C227748E3Ce16d137C6282c9870cF] = true;
390         ambassadors_[0x836e5abac615b371efce0ab399c22a04c1db5ecf] = true;
391         ambassadors_[0xAe3dC7FA07F9dD030fa56C027E90998eD9Fe9D61] = true;
392         ambassadors_[0x38602d1446fe063444B04C3CA5eCDe0cbA104240] = true;
393         ambassadors_[0x3825c8BA07166f34cE9a2cD1e08A68b105c82cB9] = true;
394         ambassadors_[0xa6662191F558e4C611c8f14b50c784EDA9Ace98d] = true;
395         ambassadors_[0xC697BE0b5b82284391A878B226e2f9AfC6B94710] = true;
396         ambassadors_[0x03Ba7aC9fa34E2550dE27B33Cb7eBc8d2618A263] = true;
397         ambassadors_[0x79562dcCFAad8871E2eC1C37172Cb1ce969b04Fd] = true;
398         
399         ambassadors_[0x41fe3738b503cbafd01c1fd8dd66b7fe6ec11b01] = true;
400         ambassadors_[0x96762288ebb2560a19f8eadaaa2012504f64278b] = true;
401         ambassadors_[0xc29a6dd21801e58566df9f003b7011e30724543e] = true;
402         ambassadors_[0xc63ea85cc823c440319013d4b30e19b66466642d] = true;
403         ambassadors_[0xc6f827796a2e1937fd7f97c4e0a4906c476794f6] = true;
404         ambassadors_[0xe74b1ea522b9d558c8e8719c3b1c4a9050b531ca] = true;
405         ambassadors_[0x6b90d498062140c607d03fd642377eeaa325703e] = true;
406         ambassadors_[0x5f1088110edcba27fc206cdcc326b413b5867361] = true;
407         ambassadors_[0xc92fd0e554b12eb10f584819eec2394a9a6f3d1d] = true;
408         ambassadors_[0xb62a0ac2338c227748e3ce16d137c6282c9870cf] = true;
409         ambassadors_[0x3f6c42409da6faf117095131168949ab81d5947d] = true;
410         ambassadors_[0xd54c47b3165508fb5418dbdec59a0d2448eeb3d7] = true;
411         ambassadors_[0x285d366834afaa8628226e65913e0dd1aa26b1f8] = true;
412         ambassadors_[0x285d366834afaa8628226e65913e0dd1aa26b1f8] = true;
413         ambassadors_[0x5f5996f9e1960655d6fc00b945fef90672370d9f] = true;
414         ambassadors_[0x3825c8ba07166f34ce9a2cd1e08a68b105c82cb9] = true;
415         ambassadors_[0x7f3e05b4f258e1c15a0ef49894cffa1d89ceb9d3] = true;
416         ambassadors_[0x3191acf877495e5f4e619ec722f6f38839182660] = true;
417         ambassadors_[0x14f981ec7b0f59df6e1c56502e272298f221d763] = true;
418         ambassadors_[0xae817ec70d8b621bb58a047e63c31445f79e20dc] = true;
419         ambassadors_[0xc43af3becac9c810384b69cf061f2d7ec73105c4] = true;
420         ambassadors_[0x0743469569ed5cc44a51216a1bf5ad7e7f90f40e] = true;
421         ambassadors_[0xff6a4d0ed374ba955048664d6ef5448c6cd1d56a] = true;
422         ambassadors_[0x62358a483311b3de29ae987b990e19de6259fa9c] = true;
423         ambassadors_[0xa0fea1bcfa32713afdb73b9908f6cb055022e95f] = true;
424         ambassadors_[0xb2af816608e1a4d0fb12b81028f32bac76256eba] = true;
425         ambassadors_[0x977193d601b364f38ab1a832dbaef69ca7833992] = true;
426         ambassadors_[0xed3547f0ed028361685b39cd139aa841df6629ab] = true;
427         ambassadors_[0xe40ff298079493cba637d92089e3d1db403974cb] = true;
428         ambassadors_[0xae3dc7fa07f9dd030fa56c027e90998ed9fe9d61] = true;
429         ambassadors_[0x2dd35e7a6f5fcc28d146c04be641f969f6d1e403] = true;
430         ambassadors_[0x2afe21ec5114339922d38546a3be7a0b871d3a0d] = true;
431         ambassadors_[0x6696fee394bb224d0154ea6b58737dca827e1960] = true;
432         ambassadors_[0xccdf159b1340a35c3567b669c836a88070051314] = true;
433         ambassadors_[0x1c3416a34c86f9ddcd05c7828bf5693308d19e0b] = true;
434         ambassadors_[0x846dedb19b105edafac2c9410fa2b5e73b596a14] = true;
435         ambassadors_[0x3e9294f9b01bc0bcb91413112c75c3225c65d0b3] = true;
436         ambassadors_[0x3a5ce61c74343dde474bad4210cccf1dac7b1934] = true;
437         ambassadors_[0x38e123f89a7576b2942010ad1f468cc0ea8f9f4b] = true;
438         ambassadors_[0xdcd8bad894035b5c554ad450ca84ae6be0b73122] = true;
439         ambassadors_[0xcfab320d4379a84fe3736eccf56b09916e35097b] = true;
440         ambassadors_[0x12f53c1d7caea0b41010a0e53d89c801ed579b5a] = true;
441         ambassadors_[0x5145a296e1bb9d4cf468d6d97d7b6d15700f39ef] = true;
442         ambassadors_[0xac707a1b4396a309f4ad01e3da4be607bbf14089] = true;
443         ambassadors_[0x38602d1446fe063444b04c3ca5ecde0cba104240] = true;
444         ambassadors_[0xc951d3463ebba4e9ec8ddfe1f42bc5895c46ec8f] = true;
445         ambassadors_[0x69e566a65d00ad5987359db9b3ced7e1cfe9ac69] = true;
446         ambassadors_[0x533b14f6d04ed3c63a68d5e80b7b1f6204fb4213] = true;
447         ambassadors_[0x5fa0b03bee5b4e6643a1762df718c0a4a7c1842f] = true;
448         ambassadors_[0xb74d5f0a81ce99ac1857133e489bc2b4954935ff] = true;
449         ambassadors_[0xc371117e0adfafe2a3b7b6ba71b7c0352ca7789d] = true;
450         ambassadors_[0xcade49e583bc226f19894458f8e2051289f1ac85] = true;
451         ambassadors_[0xe3fc95aba6655619db88b523ab487d5273db484f] = true;
452         ambassadors_[0x22e4d1433377a2a18452e74fd4ba9eea01824f7d] = true;
453         ambassadors_[0x32ae5eff81881a9a70fcacada5bb1925cabca508] = true;
454         ambassadors_[0xb864d177c291368b52a63a95eeff36e3731303c1] = true;
455         ambassadors_[0x46091f77b224576e224796de5c50e8120ad7d764] = true;
456         ambassadors_[0xc6407dd687a179aa11781b8a1e416bd0515923c2] = true;
457         ambassadors_[0x2502ce06dcb61ddf5136171768dfc08d41db0a75] = true;
458         ambassadors_[0x6b80ca9c66cdcecc39893993df117082cc32bb16] = true;
459         ambassadors_[0xa511ddba25ffd74f19a400fa581a15b5044855ce] = true;
460         ambassadors_[0xce81d90ae52d34588a95db59b89948c8fec487ce] = true;
461         ambassadors_[0x6d60dbf559bbf0969002f19979cad909c2644dad] = true;
462         ambassadors_[0x45101255a2bcad3175e6fda4020a9b77e6353a9a] = true;
463         ambassadors_[0xe9078d7539e5eac3b47801a6ecea8a9ec8f59375] = true;
464         ambassadors_[0x41a21b264f9ebf6cf571d4543a5b3ab1c6bed98c] = true;
465         ambassadors_[0x471e8d970c30e61403186b6f245364ae790d14c3] = true;
466         ambassadors_[0x6eb7f74ff7f57f7ba45ca71712bccef0588d8f0d] = true;
467         ambassadors_[0xe6d6bc079d76dc70fcec5de84721c7b0074d164b] = true;
468         ambassadors_[0x3ec5972c2177a08fd5e5f606f19ab262d28ceffe] = true;
469         ambassadors_[0x108b87a18877104e07bd870af70dfc2487447262] = true;
470         ambassadors_[0x3129354440e4639d2b809ca03d4ccc6277ac8167] = true;
471         ambassadors_[0x21572b6a855ee8b1392ed1003ecf3474fa83de3e] = true;
472         ambassadors_[0x75ab98f33a7a60c4953cb907747b498e0ee8edf7] = true;
473         ambassadors_[0x0fe6967f9a5bb235fc74a63e3f3fc5853c55c083] = true;
474         ambassadors_[0x49545640b9f3266d13cce842b298d450c0f8d776] = true;
475         ambassadors_[0x9327128ead2495f60d41d3933825ffd8080d4d42] = true;
476         ambassadors_[0x82b4e53a7d6bf6c72cc57f8d70dae90a34f0870f] = true;
477         ambassadors_[0xb74d5f0a81ce99ac1857133e489bc2b4954935ff] = true;
478         ambassadors_[0x3749d556c167dd73d536a6faaf0bb4ace8f7dab9] = true;
479         ambassadors_[0x3039f6857071692b540d9e1e759a0add93af3fed] = true;
480         ambassadors_[0xb74d5f0a81ce99ac1857133e489bc2b4954935ff] = true;
481      
482         
483         nextAvailableCard = 13;
484 
485         cardOwner[1] = dev;
486         cardPrice[1] = 5 ether;
487         basePrice[1] = cardPrice[1];
488         cardPreviousPrice[1] = 0;
489 
490         cardOwner[2] = dev;
491         cardPrice[2] = 4 ether;
492         basePrice[2] = cardPrice[2];
493         cardPreviousPrice[2] = 0;
494 
495         cardOwner[3] = dev;
496         cardPrice[3] = 3 ether;
497         basePrice[3] = cardPrice[3];
498         cardPreviousPrice[3] = 0;
499 
500         cardOwner[4] = dev;
501         cardPrice[4] = 2 ether;
502         basePrice[4] = cardPrice[4];
503         cardPreviousPrice[4] = 0;
504 
505         cardOwner[5] = dev;
506         cardPrice[5] = 1.5 ether;
507         basePrice[5] = cardPrice[5];
508         cardPreviousPrice[5] = 0;
509 
510         cardOwner[6] = dev;
511         cardPrice[6] = 1 ether;
512         basePrice[6] = cardPrice[6];
513         cardPreviousPrice[6] = 0;
514 
515         cardOwner[7] = dev;
516         cardPrice[7] = 0.9 ether;
517         basePrice[7] = cardPrice[7];
518         cardPreviousPrice[7] = 0;
519 
520         cardOwner[8] = dev;
521         cardPrice[8] = 0.7 ether;
522         basePrice[8] = cardPrice[8];
523         cardPreviousPrice[8] = 0;
524 
525         cardOwner[9] = 0xAe3dC7FA07F9dD030fa56C027E90998eD9Fe9D61;
526         cardPrice[9] = 0.5 ether;
527         basePrice[9] = cardPrice[9];
528         cardPreviousPrice[9] = 0;
529 
530         cardOwner[10] = dev;
531         cardPrice[10] = 0.4 ether;
532         basePrice[10] = cardPrice[10];
533         cardPreviousPrice[10] = 0;
534 
535         cardOwner[11] = dev;
536         cardPrice[11] = 0.2 ether;
537         basePrice[11] = cardPrice[11];
538         cardPreviousPrice[11] = 0;
539 
540         cardOwner[12] = dev;
541         cardPrice[12] = 0.1 ether;
542         basePrice[12] = cardPrice[12];
543         cardPreviousPrice[12] = 0;
544 
545         getTotalCardValue();
546 
547     }
548     
549      
550     /**
551      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
552      */
553     function buy(address _referredBy)
554         public
555         payable
556         returns(uint256)
557     {
558         purchaseTokens(msg.value, _referredBy);
559     }
560     
561     /**
562      * Fallback function to handle ethereum that was send straight to the contract
563      * Unfortunately we cannot use a referral address this way.
564      */
565     function()
566         payable
567         public
568     {
569         purchaseTokens(msg.value, 0x0);
570     }
571     
572     /**
573      * Converts all of caller's dividends to tokens.
574      */
575     function reinvest()
576         onlyStronghands()
577         public
578     {
579         // fetch dividends
580         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
581         
582         // pay out the dividends virtually
583         address _customerAddress = msg.sender;
584         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
585         
586         // retrieve ref. bonus
587         _dividends += referralBalance_[_customerAddress] + ownerAccounts[_customerAddress];
588         referralBalance_[_customerAddress] = 0;
589         ownerAccounts[_customerAddress] = 0;
590         
591         // dispatch a buy order with the virtualized "withdrawn dividends"
592         uint256 _tokens = purchaseTokens(_dividends, 0x0);
593         
594         // fire event
595         onReinvestment(_customerAddress, _dividends, _tokens);
596         checkHalfLife();
597     }
598     
599     /**
600      * Alias of sell() and withdraw().
601      */
602     function exit()
603         public
604     {
605         // get token count for caller & sell them all
606         address _customerAddress = msg.sender;
607         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
608         if(_tokens > 0) sell(_tokens);
609         
610         // lambo delivery service
611         withdraw();
612         checkHalfLife();
613     }
614 
615     /**
616      * Withdraws all of the callers earnings.
617      */
618     function withdraw()
619         onlyStronghands()
620         public
621     {
622         // setup data
623         address _customerAddress = msg.sender;
624         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
625         
626         // update dividend tracker
627         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
628         
629         // add ref. bonus
630         _dividends += referralBalance_[_customerAddress] + ownerAccounts[_customerAddress];
631         referralBalance_[_customerAddress] = 0;
632         ownerAccounts[_customerAddress] = 0;
633         
634         // lambo delivery service
635         _customerAddress.transfer(_dividends);
636         
637         // fire event
638         onWithdraw(_customerAddress, _dividends);
639         checkHalfLife();
640     }
641     
642     /**
643      * Liquifies tokens to ethereum.
644      */
645     function sell(uint256 _amountOfTokens)
646     
647         onlyBagholders()
648         public
649     {
650         // setup data
651         uint8 localDivFee = 200;
652         lastHour = getHour(block.timestamp);
653         if (getHour(block.timestamp) == alertTime1 || getHour(block.timestamp) == alertTime2 || getHour(block.timestamp) == alertTime3){
654             boolAlertStatus = true;
655             localDivFee = dividendFeeBuyAlert_;
656         }else{
657             boolAlertStatus = false;
658             localDivFee = dividendFeeBuyClear_;
659         }
660 
661         address _customerAddress = msg.sender;
662         // russian hackers BTFO
663         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
664         uint256 _tokens = _amountOfTokens;
665         uint256 _ethereum = tokensToEthereum_(_tokens);
666         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, localDivFee),1000);
667         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
668         
669         // burn the sold tokens
670         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
671         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
672         
673         // update dividends tracker
674         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
675         payoutsTo_[_customerAddress] -= _updatedPayouts;       
676         
677         // dividing by zero is a bad idea
678         if (tokenSupply_ > 0) {
679             // update the amount of dividends per token
680             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
681         }
682 
683         checkHalfLife();
684         
685         // fire event
686         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
687     }
688     
689     
690     /**
691      * Transfer tokens from the caller to a new holder.
692      * Remember, there's a 10% fee here as well.
693      */
694     function transfer(address _toAddress, uint256 _amountOfTokens)
695         onlyBagholders()
696         public
697         returns(bool)
698     {
699         // setup
700         address _customerAddress = msg.sender;
701 
702         uint8 localDivFee = 200;
703         lastHour = getHour(block.timestamp);
704         if (getHour(block.timestamp) == alertTime1 || getHour(block.timestamp) == alertTime2 || getHour(block.timestamp) == alertTime3){
705             boolAlertStatus = true;
706             localDivFee = dividendFeeBuyAlert_;
707         }else{
708             boolAlertStatus = false;
709             localDivFee = dividendFeeBuyClear_;
710         }
711 
712         if (msg.sender == dev){   //exempt the dev from transfer fees so we can do some promo, you'll thank me in the morning
713             localDivFee = 0;
714         }
715 
716         
717         // make sure we have the requested tokens
718         // also disables transfers until ambassador phase is over
719         // ( we dont want whale premines )
720         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
721         
722         // withdraw all outstanding dividends first
723         if(myDividends(true) > 0) withdraw();
724         
725         // liquify 20% of the tokens that are transfered
726         // these are dispersed to shareholders
727         uint256 _tokenFee = SafeMath.div(SafeMath.mul(_amountOfTokens, localDivFee),1000);
728         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
729         uint256 _dividends = tokensToEthereum_(_tokenFee);
730   
731         // burn the fee tokens
732         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
733 
734         // exchange tokens
735         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
736         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
737         
738         // update dividend trackers
739         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
740         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
741         
742         // disperse dividends among holders
743         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
744         
745         // fire event
746         Transfer(_customerAddress, _toAddress, _taxedTokens);
747         checkHalfLife();
748         
749         // ERC20
750         return true;
751        
752     }
753     
754     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
755     /**
756      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
757      */
758     function disableInitialStage()
759         onlyAdministrator()
760         public
761     {
762         onlyAmbassadors = false;
763     }
764     
765     /**
766      * In case one of us dies, we need to replace ourselves.
767      */
768     function setAdministrator(address _identifier, bool _status)
769         onlyAdministrator()
770         public
771     {
772         administrators[_identifier] = _status;
773     }
774 
775     function setAllowHalfLife(bool _allow)
776         onlyAdministrator()
777         public
778     {
779         allowHalfLife = _allow;
780     
781     }
782 
783     function setAllowReferral(bool _allow)
784         onlyAdministrator()
785         public
786     {
787         allowReferral = _allow;  //for cards
788     
789     }
790 
791     /**
792      * Set fees/rates
793      */
794     function setFeeRates(uint8 _newDivRate, uint8 _yieldDivFee, uint8 _newCardFee)
795         onlyAdministrator()
796         public
797     {
798         require(_newDivRate <= 250);  //25%
799         require(_yieldDivFee <= 50);  //5% 
800         require(_newCardFee <= 50);   //5%
801 
802         dividendFee_ = _newDivRate;
803         yieldDividendFeeRate_ = _yieldDivFee;
804         cardInsuranceFeeRate_ = _newCardFee;
805     }
806 
807     /**
808     * Set Exchange Rates
809     */
810     function setExchangeRates(uint8 _newBuyAlert, uint8 _newBuyClear, uint8 _newSellAlert, uint8 _newSellClear)
811         onlyAdministrator()
812         public
813     {
814         require(_newBuyAlert <= 400);   //40%
815         require(_newBuyClear <= 400);   //40%
816         require(_newSellAlert <= 400);  //40%
817         require(_newSellClear <= 400);  //40%
818 
819         dividendFeeBuyClear_ = _newBuyClear;
820         dividendFeeSellClear_ = _newSellClear;
821         dividendFeeBuyAlert_ = _newBuyAlert;
822         dividendFeeSellAlert_ = _newSellAlert;
823 
824     }
825 
826         /**
827     * Set Exchange Rates
828     */
829     function setInsurancePayout(uint8 _newRate)
830         onlyAdministrator()
831         public
832     {
833         require(_newRate <= 200);
834         insurancePayoutRate = _newRate;
835     }
836 
837     
838     /**
839      * Set Alert Times
840      */
841     function setAlertTimes(uint _newAlert1, uint _newAlert2, uint _newAlert3)
842         onlyAdministrator()
843         public
844     {
845         alertTime1 = _newAlert1;
846         alertTime2 = _newAlert2;
847         alertTime3 = _newAlert3;
848     }
849 
850       /**
851      * Set HalfLifePeriods
852      */
853     function setHalfLifePeriods(uint _alert, uint _clear)
854         onlyAdministrator()
855         public
856     {
857         halfLifeAlert = _alert;
858         halfLifeClear = _clear;
859     }
860     
861     /**
862      * In case one of us dies, we need to replace ourselves.
863      */
864     function setContractActive(bool _status)
865         onlyAdministrator()
866         public
867     {
868         boolContractActive = _status;
869     }
870 
871     /**
872      * In case one of us dies, we need to replace ourselves.
873      */
874     function setCardActive(bool _status)
875         onlyAdministrator()
876         public
877     {
878         boolCardActive = _status;
879     }
880     
881 
882     /**
883      * Precautionary measures in case we need to adjust the masternode rate.
884      */
885     function setStakingRequirement(uint256 _amountOfTokens)
886         onlyAdministrator()
887         public
888     {
889         stakingRequirement = _amountOfTokens;
890     }
891     
892     /**
893      * If we want to rebrand, we can.
894      */
895     function setName(string _name)
896         onlyAdministrator()
897         public
898     {
899         name = _name;
900     }
901     
902     /**
903      * If we want to rebrand, we can.
904      */
905     function setSymbol(string _symbol)
906         onlyAdministrator()
907         public
908     {
909         symbol = _symbol;
910     }
911 
912     
913     function setMaxCards(uint _card)  
914         onlyAdministrator()
915         public
916     {
917         maxCards = _card;
918     }
919 
920     function setHalfLifeTime(uint _time)
921         onlyAdministrator()
922         public
923     {
924         halfLifeTime = _time;
925     }
926 
927     function setHalfLifeRate(uint _rate)
928         onlyAdministrator()
929         public
930     {
931         halfLifeRate = _rate;
932     }
933 
934     function addNewCard(uint _price) 
935         onlyAdministrator()
936         public
937     {
938         require(nextAvailableCard < maxCards);
939         cardPrice[nextAvailableCard] = _price;
940         basePrice[nextAvailableCard] = cardPrice[nextAvailableCard];
941         cardOwner[nextAvailableCard] = dev;
942         totalCardDivs[nextAvailableCard] = 0;
943         cardPreviousPrice[nextAvailableCard] = 0;
944         nextAvailableCard = nextAvailableCard + 1;
945         getTotalCardValue();
946         
947     }
948 
949 
950     function addAmbassador(address _newAmbassador) 
951         onlyAdministrator()
952         public
953     {
954         ambassadors_[_newAmbassador] = true;
955     }
956     
957     /*----------  HELPERS AND CALCULATORS  ----------*/
958     /**
959      * Method to view the current Ethereum stored in the contract
960      * Example: totalEthereumBalance()
961      */
962     function totalEthereumBalance()
963         public
964         view
965         returns(uint)
966     {
967         return this.balance;
968     }
969     
970     /**
971      * Retrieve the total token supply.
972      */
973     function totalSupply()
974         public
975         view
976         returns(uint256)
977     {
978         return tokenSupply_;
979     }
980     
981     /**
982      * Retrieve the tokens owned by the caller.
983      */
984     function myTokens()
985         public
986         view
987         returns(uint256)
988     {
989         address _customerAddress = msg.sender;
990         return balanceOf(_customerAddress);
991     }
992     
993     /**
994      * Retrieve the dividends owned by the caller.
995      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
996      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
997      * But in the internal calculations, we want them separate. 
998      */ 
999     function myDividends(bool _includeReferralBonus) 
1000         public 
1001         view 
1002         returns(uint256)
1003     {
1004         address _customerAddress = msg.sender;
1005         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
1006     }
1007 
1008     function myCardDividends()
1009         public
1010         view
1011         returns(uint256)
1012     {
1013         address _customerAddress = msg.sender;
1014         return ownerAccounts[_customerAddress];
1015     }
1016     
1017     /**
1018      * Retrieve the token balance of any single address.
1019      */
1020     function balanceOf(address _customerAddress)
1021         view
1022         public
1023         returns(uint256)
1024     {
1025         return tokenBalanceLedger_[_customerAddress];
1026     }
1027     
1028     /**
1029      * Retrieve the dividend balance of any single address.
1030      */
1031     function dividendsOf(address _customerAddress)
1032         view
1033         public
1034         returns(uint256)
1035     {
1036         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
1037     }
1038     
1039     /**
1040      * Return the buy price of 1 individual token.
1041      */
1042     function sellPrice() 
1043         public 
1044         view 
1045         returns(uint256)
1046     {
1047         // our calculation relies on the token supply, so we need supply. Doh.
1048         if(tokenSupply_ == 0){
1049             return tokenPriceInitial_ - tokenPriceIncremental_;
1050         } else {
1051             uint256 _ethereum = tokensToEthereum_(1e18);
1052             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_  ),1000);
1053             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
1054             return _taxedEthereum;
1055         }
1056     }
1057     
1058     /**
1059      * Return the sell price of 1 individual token.
1060      */
1061     function buyPrice() 
1062         public 
1063         view 
1064         returns(uint256)
1065     {
1066         // our calculation relies on the token supply, so we need supply. Doh.
1067         if(tokenSupply_ == 0){
1068             return tokenPriceInitial_ + tokenPriceIncremental_;
1069         } else {
1070             uint256 _ethereum = tokensToEthereum_(1e18);
1071             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_  ),1000);
1072             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
1073             return _taxedEthereum;
1074         }
1075     }
1076     
1077     /**
1078      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
1079      */
1080     function calculateTokensReceived(uint256 _ethereumToSpend) 
1081         public 
1082         view 
1083         returns(uint256)
1084     {
1085         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, dividendFee_  ),1000);
1086         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
1087         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
1088         
1089         return _amountOfTokens;
1090     }
1091     
1092     /**
1093      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
1094      */
1095     function calculateEthereumReceived(uint256 _tokensToSell) 
1096         public 
1097         view 
1098         returns(uint256)
1099     {
1100         require(_tokensToSell <= tokenSupply_);
1101         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
1102         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_  ),1000);
1103         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
1104         return _taxedEthereum;
1105     }
1106     
1107     
1108     /*==========================================
1109     =            INTERNAL FUNCTIONS            =
1110     ==========================================*/
1111 
1112     function getTotalCardValue()
1113     internal
1114     view
1115     {
1116         uint counter = 1;
1117         uint _totalVal = 0;
1118 
1119         while (counter < nextAvailableCard) { 
1120 
1121             _totalVal = SafeMath.add(_totalVal,cardPrice[counter]);
1122                 
1123             counter = counter + 1;
1124         } 
1125         totalCardValue = _totalVal;
1126             
1127     }
1128 
1129     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
1130         antiEarlyWhale(_incomingEthereum)
1131         onlyActive()
1132         internal
1133         returns(uint256)
1134     {
1135         // data setup
1136 
1137         // setup data
1138         uint8 localDivFee = 200;
1139 
1140         lastHour = getHour(block.timestamp);
1141         if (getHour(block.timestamp) == alertTime1 || getHour(block.timestamp) == alertTime2 || getHour(block.timestamp) == alertTime3){
1142             boolAlertStatus = true;
1143             localDivFee = dividendFeeBuyAlert_;
1144         }else{
1145             boolAlertStatus = false;
1146             localDivFee = dividendFeeBuyClear_;
1147         }
1148 
1149         cardInsuranceAccount = SafeMath.add(cardInsuranceAccount, SafeMath.div(SafeMath.mul(_incomingEthereum, cardInsuranceFeeRate_), 1000));
1150         //uint _distDividends = SafeMath.div(SafeMath.mul(_incomingEthereum,yieldDividendFeeRate_),1000);
1151         distributeYield(SafeMath.div(SafeMath.mul(_incomingEthereum,yieldDividendFeeRate_),1000));
1152         
1153         _incomingEthereum = SafeMath.sub(_incomingEthereum,SafeMath.div(SafeMath.mul(_incomingEthereum, cardInsuranceFeeRate_ + yieldDividendFeeRate_), 1000));
1154 
1155         uint256 _referralBonus = SafeMath.div(SafeMath.div(SafeMath.mul(_incomingEthereum, localDivFee  ),1000), 3);
1156         uint256 _dividends = SafeMath.sub(SafeMath.div(SafeMath.mul(_incomingEthereum, localDivFee  ),1000), _referralBonus);
1157         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, SafeMath.div(SafeMath.mul(_incomingEthereum, localDivFee),1000));
1158         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
1159         uint256 _fee = _dividends * magnitude;
1160 
1161         
1162 
1163  
1164         // no point in continuing execution if OP is a poorfag russian hacker
1165         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
1166         // (or hackers)
1167         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
1168         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
1169         
1170         // is the user referred by a masternode?
1171         if(
1172             // is this a referred purchase?
1173             _referredBy != 0x0000000000000000000000000000000000000000 &&
1174 
1175             // no cheating!
1176             _referredBy != msg.sender &&
1177             
1178             // does the referrer have at least X whole tokens?
1179             // i.e is the referrer a godly chad masternode
1180             tokenBalanceLedger_[_referredBy] >= stakingRequirement
1181         ){
1182             // wealth redistribution
1183             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
1184         } else {
1185             // no ref purchase
1186             // add the referral bonus back to the global dividends cake
1187             _dividends = SafeMath.add(_dividends, _referralBonus);
1188             _fee = _dividends * magnitude;
1189         }
1190         
1191         // we can't give people infinite ethereum
1192         if(tokenSupply_ > 0){
1193             
1194             // add tokens to the pool
1195             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
1196  
1197             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
1198             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
1199             
1200             // calculate the amount of tokens the customer receives over his purchase 
1201             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
1202         
1203         } else {
1204             // add tokens to the pool
1205             tokenSupply_ = _amountOfTokens;
1206         }
1207         
1208         // update circulating supply & the ledger address for the customer
1209         tokenBalanceLedger_[msg.sender] = SafeMath.add(tokenBalanceLedger_[msg.sender], _amountOfTokens);
1210         
1211         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
1212         //really i know you think you do but you don't
1213         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
1214         payoutsTo_[msg.sender] += _updatedPayouts;
1215 
1216         
1217         distributeInsurance();
1218         checkHalfLife();
1219         
1220         // fire event
1221         onTokenPurchase(msg.sender, _incomingEthereum, _amountOfTokens, _referredBy);
1222         
1223         return _amountOfTokens;
1224     }
1225 
1226 
1227 
1228     function buyCard(uint _card, address _referrer)
1229         public
1230         payable
1231         onlyCardActive()
1232     {
1233         require(_card <= nextAvailableCard);
1234         require(_card > 0);
1235         require(msg.value >= cardPrice[_card]);
1236        
1237         cardBlockNumber[_card] = block.number;   //reset block number for this card for half life calculations
1238 
1239 
1240          //Determine the total dividends
1241         uint _baseDividends = msg.value - cardPreviousPrice[_card];
1242         totalDivsProduced = SafeMath.add(totalDivsProduced, _baseDividends);
1243 
1244         //uint _devDividends = SafeMath.div(SafeMath.mul(_baseDividends,devDivRate),100);
1245         uint _ownerDividends = SafeMath.div(SafeMath.mul(_baseDividends,ownerDivRate),1000);
1246         _ownerDividends = SafeMath.add(_ownerDividends,cardPreviousPrice[_card]);  //owner receovers price they paid initially
1247         uint _insuranceDividends = SafeMath.div(SafeMath.mul(_baseDividends,insuranceDivRate),1000);
1248 
1249 
1250         //add dividends to the exchange tokens
1251         uint _exchangeDivs = SafeMath.div(SafeMath.mul(_baseDividends, yieldDivRate),1000);
1252         profitPerShare_ += (_exchangeDivs * magnitude / (tokenSupply_));
1253 
1254         totalCardDivs[_card] = SafeMath.add(totalCardDivs[_card],_ownerDividends);
1255         
1256         cardInsuranceAccount = SafeMath.add(cardInsuranceAccount, _insuranceDividends);
1257             
1258         uint _distDividends = SafeMath.div(SafeMath.mul(_baseDividends,distDivRate),1000);
1259 
1260         if (allowReferral && (_referrer != msg.sender) && (_referrer != 0x0000000000000000000000000000000000000000)) {
1261                 
1262             uint _referralDividends = SafeMath.div(SafeMath.mul(_baseDividends,referralRate),1000);
1263             _distDividends = SafeMath.sub(_distDividends,_referralDividends);
1264             ownerAccounts[_referrer] = SafeMath.add(ownerAccounts[_referrer],_referralDividends);
1265         }
1266             
1267         distributeYield(_distDividends);
1268 
1269         //distribute dividends to accounts
1270         address _previousOwner = cardOwner[_card];
1271         address _newOwner = msg.sender;
1272 
1273         ownerAccounts[_previousOwner] = SafeMath.add(ownerAccounts[_previousOwner],_ownerDividends);
1274         ownerAccounts[dev] = SafeMath.add(ownerAccounts[dev],SafeMath.div(SafeMath.mul(_baseDividends,devDivRate),1000));
1275 
1276         cardOwner[_card] = _newOwner;
1277 
1278         //Increment the card Price
1279         cardPreviousPrice[_card] = msg.value;
1280         cardPrice[_card] = SafeMath.div(SafeMath.mul(msg.value,cardPriceIncrement),1000);
1281   
1282         getTotalCardValue();
1283         distributeInsurance();
1284         checkHalfLife();
1285 
1286         emit onCardBuy(msg.sender, msg.value, _card, SafeMath.div(SafeMath.mul(msg.value,cardPriceIncrement),1000), halfLifeTime + block.number);
1287      
1288     }
1289 
1290 
1291     function distributeInsurance() internal
1292     {
1293         uint counter = 1;
1294         uint _cardDistAmount = cardInsuranceAccount;
1295         cardInsuranceAccount = 0;
1296         uint tempInsurance = 0;
1297 
1298         while (counter < nextAvailableCard) { 
1299   
1300             uint _distAmountLocal = SafeMath.div(SafeMath.mul(_cardDistAmount, cardPrice[counter]),totalCardValue);
1301             
1302             cardInsurance[counter] = SafeMath.add(cardInsurance[counter], _distAmountLocal);
1303             tempInsurance = tempInsurance + cardInsurance[counter];
1304             emit onInsuranceChange(0x0, counter, cardInsurance[counter]);
1305     
1306             counter = counter + 1;
1307         } 
1308         totalCardInsurance = tempInsurance;
1309     }
1310 
1311 
1312     function distributeYield(uint _distDividends) internal
1313     //tokens
1314     {
1315         uint counter = 1;
1316         uint currentBlock = block.number;
1317         uint insurancePayout = 0;
1318 
1319         while (counter < nextAvailableCard) { 
1320 
1321             uint _distAmountLocal = SafeMath.div(SafeMath.mul(_distDividends, cardPrice[counter]),totalCardValue);
1322             ownerAccounts[cardOwner[counter]] = SafeMath.add(ownerAccounts[cardOwner[counter]],_distAmountLocal);
1323             totalCardDivs[counter] = SafeMath.add(totalCardDivs[counter],_distAmountLocal);
1324 
1325             counter = counter + 1;
1326         } 
1327         getTotalCardValue();
1328         checkHalfLife();
1329     }
1330 
1331     function extCheckHalfLife() 
1332     public
1333     {
1334         bool _boolDev = (msg.sender == dev);
1335         if (_boolDev || boolAllowPlayer){
1336             checkHalfLife();
1337         }
1338     }
1339 
1340 
1341     function checkHalfLife() 
1342     internal
1343     
1344     //tokens
1345     {
1346 
1347         uint localHalfLifeTime = 120;
1348         //check whether we are in Alert or All Clear
1349         //set local half life time
1350         lastHour = getHour(block.timestamp);
1351         if (getHour(block.timestamp) == alertTime1 || getHour(block.timestamp) == alertTime2 || getHour(block.timestamp) == alertTime3){
1352             boolAlertStatus = true;
1353             localHalfLifeTime = halfLifeAlert;
1354         }else{
1355             boolAlertStatus = false;
1356             localHalfLifeTime = halfLifeClear;
1357         }
1358 
1359 
1360 
1361 
1362         uint counter = 1;
1363         uint currentBlock = block.number;
1364         uint insurancePayout = 0;
1365         uint tempInsurance = 0;
1366 
1367         while (counter < nextAvailableCard) { 
1368 
1369             //HalfLife Check
1370             if (allowHalfLife) {
1371 
1372                 if (cardPrice[counter] > basePrice[counter]) {
1373                     uint _life = SafeMath.sub(currentBlock, cardBlockNumber[counter]);
1374 
1375                     if (_life > localHalfLifeTime) {
1376                     
1377                         cardBlockNumber[counter] = currentBlock;  //Reset the clock for this card
1378                         if (SafeMath.div(SafeMath.mul(cardPrice[counter], halfLifeRate),1000) < basePrice[counter]){
1379                             
1380                             cardPrice[counter] = basePrice[counter];
1381                             insurancePayout = SafeMath.div(SafeMath.mul(cardInsurance[counter],insurancePayoutRate),1000);
1382                             cardInsurance[counter] = SafeMath.sub(cardInsurance[counter],insurancePayout);
1383                             ownerAccounts[cardOwner[counter]] = SafeMath.add(ownerAccounts[cardOwner[counter]], insurancePayout);
1384                             cardPreviousPrice[counter] = SafeMath.div(SafeMath.mul(cardPrice[counter],halfLifeReductionRate),1000);
1385                             
1386                         }else{
1387 
1388                             cardPrice[counter] = SafeMath.div(SafeMath.mul(cardPrice[counter], halfLifeRate),1000);  
1389                             cardPreviousPrice[counter] = SafeMath.div(SafeMath.mul(cardPreviousPrice[counter],halfLifeReductionRate),1000);
1390                             insurancePayout = SafeMath.div(SafeMath.mul(cardInsurance[counter],insurancePayoutRate),1000);
1391                             cardInsurance[counter] = SafeMath.sub(cardInsurance[counter],insurancePayout);
1392                             ownerAccounts[cardOwner[counter]] = SafeMath.add(ownerAccounts[cardOwner[counter]], insurancePayout);
1393 
1394                         }
1395                         emit onInsuranceChange(0x0, counter, cardInsurance[counter]);
1396                         emit Halflife(cardOwner[counter], counter, cardPrice[counter], localHalfLifeTime + block.number, insurancePayout, cardInsurance[counter]);
1397 
1398                     }
1399                     //HalfLife Check
1400                     
1401                 }
1402                
1403             }
1404             
1405             tempInsurance = tempInsurance + cardInsurance[counter];
1406             counter = counter + 1;
1407         } 
1408         totalCardInsurance = tempInsurance;
1409         getTotalCardValue();
1410 
1411     }
1412 
1413     /**
1414      * Calculate Token price based on an amount of incoming ethereum
1415      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
1416      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
1417      */
1418     function ethereumToTokens_(uint256 _ethereum)
1419         internal
1420         view
1421         returns(uint256)
1422     {
1423         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
1424         uint256 _tokensReceived = 
1425          (
1426             (
1427                 // underflow attempts BTFO
1428                 SafeMath.sub(
1429                     (sqrt
1430                         (
1431                             (_tokenPriceInitial**2)
1432                             +
1433                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
1434                             +
1435                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
1436                             +
1437                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
1438                         )
1439                     ), _tokenPriceInitial
1440                 )
1441             )/(tokenPriceIncremental_)
1442         )-(tokenSupply_)
1443         ;
1444   
1445         return _tokensReceived;
1446     }
1447     
1448     /**
1449      * Calculate token sell value.
1450      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
1451      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
1452      */
1453      function tokensToEthereum_(uint256 _tokens)
1454         internal
1455         view
1456         returns(uint256)
1457     {
1458 
1459         uint256 tokens_ = (_tokens + 1e18);
1460         uint256 _tokenSupply = (tokenSupply_ + 1e18);
1461         uint256 _etherReceived =
1462         (
1463             // underflow attempts BTFO
1464             SafeMath.sub(
1465                 (
1466                     (
1467                         (
1468                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
1469                         )-tokenPriceIncremental_
1470                     )*(tokens_ - 1e18)
1471                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
1472             )
1473         /1e18);
1474         return _etherReceived;
1475     }
1476 
1477 
1478     function getCardPrice(uint _card)
1479         public
1480         view
1481         returns(uint)
1482     {
1483         require(_card <= nextAvailableCard);
1484         return cardPrice[_card];
1485     }
1486 
1487    function getCardInsurance(uint _card)
1488         public
1489         view
1490         returns(uint)
1491     {
1492         require(_card <= nextAvailableCard);
1493         return cardInsurance[_card];
1494     }
1495 
1496 
1497     function getCardOwner(uint _card)
1498         public
1499         view
1500         returns(address)
1501     {
1502         require(_card <= nextAvailableCard);
1503         return cardOwner[_card];
1504     }
1505 
1506     function gettotalCardDivs(uint _card)
1507         public
1508         view
1509         returns(uint)
1510     {
1511         require(_card <= nextAvailableCard);
1512         return totalCardDivs[_card];
1513     }
1514 
1515     function getTotalDivsProduced()
1516         public
1517         view
1518         returns(uint)
1519     {
1520      
1521         return totalDivsProduced;
1522     }
1523     
1524     
1525     //This is where all your gas goes, sorry
1526     //Not sorry, you probably only paid 1 gwei
1527     function sqrt(uint x) internal pure returns (uint y) {
1528         uint z = (x + 1) / 2;
1529         y = x;
1530         while (z < y) {
1531             y = z;
1532             z = (x / z + z) / 2;
1533         }
1534     }
1535 
1536     function isLeapYear(uint16 year) constant returns (bool) {
1537                 if (year % 4 != 0) {
1538                         return false;
1539                 }
1540                 if (year % 100 != 0) {
1541                         return true;
1542                 }
1543                 if (year % 400 != 0) {
1544                         return false;
1545                 }
1546                 return true;
1547         }
1548 
1549     function parseTimestamp(uint timestamp) internal returns (DateTime dt) {
1550         uint secondsAccountedFor = 0;
1551         uint buf;
1552         uint8 i;
1553 
1554         dt.year = ORIGIN_YEAR;
1555 
1556         // Year
1557         while (true) {
1558                 if (isLeapYear(dt.year)) {
1559                         buf = LEAP_YEAR_IN_SECONDS;
1560                 }
1561                 else {
1562                         buf = YEAR_IN_SECONDS;
1563                 }
1564 
1565                 if (secondsAccountedFor + buf > timestamp) {
1566                         break;
1567                 }
1568                 dt.year += 1;
1569                 secondsAccountedFor += buf;
1570         }
1571 
1572         // Month
1573         uint8[12] monthDayCounts;
1574         monthDayCounts[0] = 31;
1575         if (isLeapYear(dt.year)) {
1576                 monthDayCounts[1] = 29;
1577         }
1578         else {
1579                 monthDayCounts[1] = 28;
1580         }
1581         monthDayCounts[2] = 31;
1582         monthDayCounts[3] = 30;
1583         monthDayCounts[4] = 31;
1584         monthDayCounts[5] = 30;
1585         monthDayCounts[6] = 31;
1586         monthDayCounts[7] = 31;
1587         monthDayCounts[8] = 30;
1588         monthDayCounts[9] = 31;
1589         monthDayCounts[10] = 30;
1590         monthDayCounts[11] = 31;
1591 
1592         uint secondsInMonth;
1593         for (i = 0; i < monthDayCounts.length; i++) {
1594             secondsInMonth = DAY_IN_SECONDS * monthDayCounts[i];
1595             if (secondsInMonth + secondsAccountedFor > timestamp) {
1596                 dt.month = i + 1;
1597                 break;
1598             }
1599             secondsAccountedFor += secondsInMonth;
1600         }
1601 
1602         // Day
1603         for (i = 0; i < monthDayCounts[dt.month - 1]; i++) {
1604                 if (DAY_IN_SECONDS + secondsAccountedFor > timestamp) {
1605                         dt.day = i + 1;
1606                         break;
1607                 }
1608                 secondsAccountedFor += DAY_IN_SECONDS;
1609         }
1610 
1611         // Hour
1612                 for (i = 0; i < 24; i++) {
1613                         if (HOUR_IN_SECONDS + secondsAccountedFor > timestamp) {
1614                                 dt.hour = i;
1615                                 break;
1616                         }
1617                         secondsAccountedFor += HOUR_IN_SECONDS;
1618                 }
1619 
1620         // Minute
1621         for (i = 0; i < 60; i++) {
1622                 if (MINUTE_IN_SECONDS + secondsAccountedFor > timestamp) {
1623                         dt.minute = i;
1624                         break;
1625                 }
1626                 secondsAccountedFor += MINUTE_IN_SECONDS;
1627         }
1628 
1629         if (timestamp - secondsAccountedFor > 60) {
1630                 __throw();
1631         }
1632 
1633         // Second
1634         dt.second = uint8(timestamp - secondsAccountedFor);
1635 
1636          // Day of week.
1637         buf = timestamp / DAY_IN_SECONDS;
1638         dt.weekday = uint8((buf + 3) % 7);
1639         }
1640 
1641         function getYear(uint timestamp) constant returns (uint16) {
1642                 return parseTimestamp(timestamp).year;
1643         }
1644 
1645         function getMonth(uint timestamp) constant returns (uint16) {
1646                 return parseTimestamp(timestamp).month;
1647         }
1648 
1649         function getDay(uint timestamp) constant returns (uint16) {
1650                 return parseTimestamp(timestamp).day;
1651         }
1652 
1653         function getHour(uint timestamp) constant returns (uint16) {
1654                 return parseTimestamp(timestamp).hour;
1655         }
1656 
1657         function getMinute(uint timestamp) constant returns (uint16) {
1658                 return parseTimestamp(timestamp).minute;
1659         }
1660 
1661         function getSecond(uint timestamp) constant returns (uint16) {
1662                 return parseTimestamp(timestamp).second;
1663         }
1664 
1665         function getWeekday(uint timestamp) constant returns (uint8) {
1666                 return parseTimestamp(timestamp).weekday;
1667         }
1668 
1669         function toTimestamp(uint16 year, uint8 month, uint8 day) constant returns (uint timestamp) {
1670                 return toTimestamp(year, month, day, 0, 0, 0);
1671         }
1672 
1673         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour) constant returns (uint timestamp) {
1674                 return toTimestamp(year, month, day, hour, 0, 0);
1675         }
1676 
1677         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute) constant returns (uint timestamp) {
1678                 return toTimestamp(year, month, day, hour, minute, 0);
1679         }
1680 
1681         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute, uint8 second) constant returns (uint timestamp) {
1682                 uint16 i;
1683 
1684                 // Year
1685                 for (i = ORIGIN_YEAR; i < year; i++) {
1686                         if (isLeapYear(i)) {
1687                                 timestamp += LEAP_YEAR_IN_SECONDS;
1688                         }
1689                         else {
1690                                 timestamp += YEAR_IN_SECONDS;
1691                         }
1692                 }
1693 
1694                 // Month
1695                 uint8[12] monthDayCounts;
1696                 monthDayCounts[0] = 31;
1697                 if (isLeapYear(year)) {
1698                         monthDayCounts[1] = 29;
1699                 }
1700                 else {
1701                         monthDayCounts[1] = 28;
1702                 }
1703                 monthDayCounts[2] = 31;
1704                 monthDayCounts[3] = 30;
1705                 monthDayCounts[4] = 31;
1706                 monthDayCounts[5] = 30;
1707                 monthDayCounts[6] = 31;
1708                 monthDayCounts[7] = 31;
1709                 monthDayCounts[8] = 30;
1710                 monthDayCounts[9] = 31;
1711                 monthDayCounts[10] = 30;
1712                 monthDayCounts[11] = 31;
1713 
1714                 for (i = 1; i < month; i++) {
1715                         timestamp += DAY_IN_SECONDS * monthDayCounts[i - 1];
1716                 }
1717 
1718                 // Day
1719                 timestamp += DAY_IN_SECONDS * (day - 1);
1720 
1721                 // Hour
1722                 timestamp += HOUR_IN_SECONDS * (hour);
1723 
1724                 // Minute
1725                 timestamp += MINUTE_IN_SECONDS * (minute);
1726 
1727                 // Second
1728                 timestamp += second;
1729 
1730                 return timestamp;
1731         }
1732 
1733         function __throw() {
1734                 uint[] arst;
1735                 arst[1];
1736         }
1737 }
1738 
1739 
1740 
1741 /**
1742  * @title SafeMath
1743  * @dev Math operations with safety checks that throw on error
1744  */
1745 library SafeMath {
1746 
1747     /**
1748     * @dev Multiplies two numbers, throws on overflow.
1749     */
1750     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1751         if (a == 0) {
1752             return 0;
1753         }
1754         uint256 c = a * b;
1755         assert(c / a == b);
1756         return c;
1757     }
1758 
1759     /**
1760     * @dev Integer division of two numbers, truncating the quotient.
1761     */
1762     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1763         // assert(b > 0); // Solidity automatically throws when dividing by 0
1764         uint256 c = a / b;
1765         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1766         return c;
1767     }
1768 
1769     /**
1770     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1771     */
1772     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1773         assert(b <= a);
1774         return a - b;
1775     }
1776 
1777     /**
1778     * @dev Adds two numbers, throws on overflow.
1779     */
1780     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1781         uint256 c = a + b;
1782         assert(c >= a);
1783         return c;
1784     }
1785 }