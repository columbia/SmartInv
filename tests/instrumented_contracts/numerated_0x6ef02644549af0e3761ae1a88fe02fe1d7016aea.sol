1 pragma solidity ^0.4.24;
2 
3 /*
4 * Wall Street Market presents......
5 
6 .______    __       __    __   _______      ______  __    __   __  .______        _______      ___      .___  ___.  _______ 
7 |   _  \  |  |     |  |  |  | |   ____|    /      ||  |  |  | |  | |   _  \      /  _____|    /   \     |   \/   | |   ____|
8 |  |_)  | |  |     |  |  |  | |  |__      |  ,----'|  |__|  | |  | |  |_)  |    |  |  __     /  ^  \    |  \  /  | |  |__   
9 |   _  <  |  |     |  |  |  | |   __|     |  |     |   __   | |  | |   ___/     |  | |_ |   /  /_\  \   |  |\/|  | |   __|  
10 |  |_)  | |  `----.|  `--'  | |  |____    |  `----.|  |  |  | |  | |  |         |  |__| |  /  _____  \  |  |  |  | |  |____ 
11 |______/  |_______| \______/  |_______|    \______||__|  |__| |__| | _|          \______| /__/     \__\ |__|  |__| |_______|
12                                                                                                                             
13 (BCHIP)
14 
15 website:    https://wallstreetmarket.tk
16 
17 discord:    https://discord.gg/8AFP9gS
18 
19 25% Dividends Fees/Payouts
20 
21 5% of Buy In Fee Will Go into Buying Tokens from the contract for "THE 82" group until 
22 400,000 tokens have been distributed.  25% Fee will apply for these transactions.
23 
24 After this the 5% fee will be reserved for use in additional card and lending games using BCHIP tokens.
25 
26 Referral Program pays out 33% of Buy-in/Sell Fees to user of masternode link
27 
28 */
29 
30 
31 
32 
33 
34 contract AcceptsExchange {
35     BlueChipGame public tokenContract;
36 
37     function AcceptsExchange(address _tokenContract) public {
38         tokenContract = BlueChipGame(_tokenContract);
39     }
40 
41     modifier onlyTokenContract {
42         require(msg.sender == address(tokenContract));
43         _;
44     }
45 
46     /**
47     * @dev Standard ERC677 function that will handle incoming token transfers.
48     *
49     * @param _from  Token sender address.
50     * @param _value Amount of tokens.
51     * @param _data  Transaction metadata.
52     */
53     function tokenFallback(address _from, uint256 _value, bytes _data) external returns (bool);
54     function tokenFallbackExpanded(address _from, uint256 _value, bytes _data, address _sender, address _referrer) external returns (bool);
55 }
56 
57 
58 contract BlueChipGame {
59     /*=================================
60     =            MODIFIERS            =
61     =================================*/
62     // only people with tokens
63     modifier onlyBagholders() {
64         require(myTokens() > 0);
65         _;
66     }
67 
68     // only people with profits
69     modifier onlyStronghands() {
70         require(myDividends(true) > 0);
71         _;
72     }
73 
74     modifier notContract() {
75       require (msg.sender == tx.origin);
76       _;
77     }
78 
79     // administrators can:
80     // -> change the name of the contract
81     // -> change the name of the token
82     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
83     // they CANNOT:
84     // -> take funds
85     // -> disable withdrawals
86     // -> kill the contract
87     // -> change the price of tokens
88     modifier onlyAdministrator(){
89         address _customerAddress = msg.sender;
90         require(administrators[_customerAddress]);
91         _;
92     }
93 
94 
95     modifier onlyActive(){
96         
97         require(boolContractActive);
98         _;
99     }
100 
101  
102     /*==============================
103     =            EVENTS            =
104     ==============================*/
105     event onTokenPurchase(
106         address indexed customerAddress,
107         uint256 incomingEthereum,
108         uint256 tokensMinted,
109         address indexed referredBy
110     );
111 
112     event onTokenSell(
113         address indexed customerAddress,
114         uint256 tokensBurned,
115         uint256 ethereumEarned
116     );
117 
118     event onReinvestment(
119         address indexed customerAddress,
120         uint256 ethereumReinvested,
121         uint256 tokensMinted
122     );
123 
124     event onWithdraw(
125         address indexed customerAddress,
126         uint256 ethereumWithdrawn
127     );
128 
129     // ERC20
130     event Transfer(
131         address indexed from,
132         address indexed to,
133         uint256 tokens
134     );
135 
136 
137     /*=====================================
138     =            CONFIGURABLES            =
139     =====================================*/
140     string public name = "BlueChipExchange";
141     string public symbol = "BCHIP";
142     uint8 constant public decimals = 18;
143 
144     uint256 constant internal tokenPriceInitial_ = 0.00000001 ether;
145     uint256 constant internal tokenPriceIncremental_ = 0.000000001 ether;
146     uint256 constant internal magnitude = 2**64;
147 
148    
149     uint256 public totalEthFundRecieved; // total ETH Bond recieved from this contract
150     uint256 public totalEthFundCollected; // total ETH Bond collected in this contract
151 
152     // proof of stake (defaults at 25 tokens)
153     uint256 public stakingRequirement = 25e18;
154 
155     // ambassador program
156     mapping(address => bool) internal ambassadors_;
157     uint256 constant internal ambassadorMaxPurchase_ = 2.5 ether;
158     uint256 constant internal ambassadorQuota_ = 2.5 ether;
159 
160     uint constant internal total82Tokens = 390148;
161 
162 
163 
164    /*================================
165     =            DATASETS            =
166     ================================*/
167     // amount of shares for each address (scaled number)
168     mapping(address => uint256) internal tokenBalanceLedger_;
169     mapping(address => uint256) internal referralBalance_;
170     mapping(address => int256) internal payoutsTo_;
171     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
172     mapping(uint => address) internal theGroupofEightyTwo;
173     mapping(uint => uint) internal theGroupofEightyTwoAmount;
174 
175     uint256 internal tokenSupply_ = 0;
176     uint256 internal profitPerShare_;
177 
178 
179     uint8 public dividendFee_ = 20; // 20% dividend fee on each buy and sell
180     uint8 public fundFee_ = 0; // 5% bond fund fee on each buy and sell
181     uint8 public altFundFee_ = 5; // Fund fee rate on each buy and sell for future game
182 
183     bool boolPay82 = false;
184     bool bool82Mode = true;
185     bool boolContractActive = true;
186 
187     uint bondFund = 0;
188 
189 
190     // administrator list (see above on what they can do)
191     mapping(address => bool) public administrators;
192 
193     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
194     bool public onlyAmbassadors = true;
195 
196     // Special Wall Street Market Platform control from scam game contracts on Wall Street Market platform
197     mapping(address => bool) public canAcceptTokens_; // contracts, which can accept Wall Street tokens
198 
199     mapping(address => address) public stickyRef;
200 
201      address public bondFundAddress = 0x1822435de9b923a7a8c4fbd2f6d0aa8f743d3010;   //Bond Fund
202      address public altFundAddress = 0x1822435de9b923a7a8c4fbd2f6d0aa8f743d3010;    //Alternate Fund for Future Game
203 
204     /*=======================================
205     =            PUBLIC FUNCTIONS            =
206     =======================================*/
207     /*
208     * -- APPLICATION ENTRY POINTS --
209     */
210     function BlueChipGame()
211         public
212     {
213         // add administrators here
214         administrators[msg.sender] = true;
215 
216     //*  Populate the 82 Mappings 
217         theGroupofEightyTwo[1] = 0x41fe3738b503cbafd01c1fd8dd66b7fe6ec11b01;
218         theGroupofEightyTwo[2] = 0x96762288ebb2560a19f8eadaaa2012504f64278b;
219         theGroupofEightyTwo[3] = 0xc29a6dd21801e58566df9f003b7011e30724543e;
220         theGroupofEightyTwo[4] = 0xc63ea85cc823c440319013d4b30e19b66466642d;
221         theGroupofEightyTwo[5] = 0xc6f827796a2e1937fd7f97c4e0a4906c476794f6;
222         theGroupofEightyTwo[6] = 0xe74b1ea522b9d558c8e8719c3b1c4a9050b531ca;
223         theGroupofEightyTwo[7] = 0x6b90d498062140c607d03fd642377eeaa325703e;
224         theGroupofEightyTwo[8] = 0x5f1088110edcba27fc206cdcc326b413b5867361;
225         theGroupofEightyTwo[9] = 0xc92fd0e554b12eb10f584819eec2394a9a6f3d1d;
226         theGroupofEightyTwo[10] = 0xb62a0ac2338c227748e3ce16d137c6282c9870cf;
227         theGroupofEightyTwo[11] = 0x3f6c42409da6faf117095131168949ab81d5947d;
228         theGroupofEightyTwo[12] = 0xd54c47b3165508fb5418dbdec59a0d2448eeb3d7;
229         theGroupofEightyTwo[13] = 0x285d366834afaa8628226e65913e0dd1aa26b1f8;
230         theGroupofEightyTwo[14] = 0x285d366834afaa8628226e65913e0dd1aa26b1f8;
231         theGroupofEightyTwo[15] = 0x5f5996f9e1960655d6fc00b945fef90672370d9f;
232         theGroupofEightyTwo[16] = 0x3825c8ba07166f34ce9a2cd1e08a68b105c82cb9;
233         theGroupofEightyTwo[17] = 0x7f3e05b4f258e1c15a0ef49894cffa1d89ceb9d3;
234         theGroupofEightyTwo[18] = 0x3191acf877495e5f4e619ec722f6f38839182660;
235         theGroupofEightyTwo[19] = 0x14f981ec7b0f59df6e1c56502e272298f221d763;
236         theGroupofEightyTwo[20] = 0xae817ec70d8b621bb58a047e63c31445f79e20dc;
237         theGroupofEightyTwo[21] = 0xc43af3becac9c810384b69cf061f2d7ec73105c4;
238         theGroupofEightyTwo[22] = 0x0743469569ed5cc44a51216a1bf5ad7e7f90f40e;
239         theGroupofEightyTwo[23] = 0xff6a4d0ed374ba955048664d6ef5448c6cd1d56a;
240         theGroupofEightyTwo[24] = 0x62358a483311b3de29ae987b990e19de6259fa9c;
241         theGroupofEightyTwo[25] = 0xa0fea1bcfa32713afdb73b9908f6cb055022e95f;
242         theGroupofEightyTwo[26] = 0xb2af816608e1a4d0fb12b81028f32bac76256eba;
243         theGroupofEightyTwo[27] = 0x977193d601b364f38ab1a832dbaef69ca7833992;
244         theGroupofEightyTwo[28] = 0xed3547f0ed028361685b39cd139aa841df6629ab;
245         theGroupofEightyTwo[29] = 0xe40ff298079493cba637d92089e3d1db403974cb;
246         theGroupofEightyTwo[30] = 0xae3dc7fa07f9dd030fa56c027e90998ed9fe9d61;
247         theGroupofEightyTwo[31] = 0x2dd35e7a6f5fcc28d146c04be641f969f6d1e403;
248         theGroupofEightyTwo[32] = 0x2afe21ec5114339922d38546a3be7a0b871d3a0d;
249         theGroupofEightyTwo[33] = 0x6696fee394bb224d0154ea6b58737dca827e1960;
250         theGroupofEightyTwo[34] = 0xccdf159b1340a35c3567b669c836a88070051314;
251         theGroupofEightyTwo[35] = 0x1c3416a34c86f9ddcd05c7828bf5693308d19e0b;
252         theGroupofEightyTwo[36] = 0x846dedb19b105edafac2c9410fa2b5e73b596a14;
253         theGroupofEightyTwo[37] = 0x3e9294f9b01bc0bcb91413112c75c3225c65d0b3;
254         theGroupofEightyTwo[38] = 0x3a5ce61c74343dde474bad4210cccf1dac7b1934;
255         theGroupofEightyTwo[39] = 0x38e123f89a7576b2942010ad1f468cc0ea8f9f4b;
256         theGroupofEightyTwo[40] = 0xdcd8bad894035b5c554ad450ca84ae6be0b73122;
257         theGroupofEightyTwo[41] = 0xcfab320d4379a84fe3736eccf56b09916e35097b;
258         theGroupofEightyTwo[42] = 0x12f53c1d7caea0b41010a0e53d89c801ed579b5a;
259         theGroupofEightyTwo[43] = 0x5145a296e1bb9d4cf468d6d97d7b6d15700f39ef;
260         theGroupofEightyTwo[44] = 0xac707a1b4396a309f4ad01e3da4be607bbf14089;
261         theGroupofEightyTwo[45] = 0x38602d1446fe063444b04c3ca5ecde0cba104240;
262         theGroupofEightyTwo[46] = 0xc951d3463ebba4e9ec8ddfe1f42bc5895c46ec8f;
263         theGroupofEightyTwo[47] = 0x69e566a65d00ad5987359db9b3ced7e1cfe9ac69;
264         theGroupofEightyTwo[48] = 0x533b14f6d04ed3c63a68d5e80b7b1f6204fb4213;
265         theGroupofEightyTwo[49] = 0x5fa0b03bee5b4e6643a1762df718c0a4a7c1842f;
266         theGroupofEightyTwo[50] = 0xb74d5f0a81ce99ac1857133e489bc2b4954935ff;
267         theGroupofEightyTwo[51] = 0xc371117e0adfafe2a3b7b6ba71b7c0352ca7789d;
268         theGroupofEightyTwo[52] = 0xcade49e583bc226f19894458f8e2051289f1ac85;
269         theGroupofEightyTwo[53] = 0xe3fc95aba6655619db88b523ab487d5273db484f;
270         theGroupofEightyTwo[54] = 0x22e4d1433377a2a18452e74fd4ba9eea01824f7d;
271         theGroupofEightyTwo[55] = 0x32ae5eff81881a9a70fcacada5bb1925cabca508;
272         theGroupofEightyTwo[56] = 0xb864d177c291368b52a63a95eeff36e3731303c1;
273         theGroupofEightyTwo[57] = 0x46091f77b224576e224796de5c50e8120ad7d764;
274         theGroupofEightyTwo[58] = 0xc6407dd687a179aa11781b8a1e416bd0515923c2;
275         theGroupofEightyTwo[59] = 0x2502ce06dcb61ddf5136171768dfc08d41db0a75;
276         theGroupofEightyTwo[60] = 0x6b80ca9c66cdcecc39893993df117082cc32bb16;
277         theGroupofEightyTwo[61] = 0xa511ddba25ffd74f19a400fa581a15b5044855ce;
278         theGroupofEightyTwo[62] = 0xce81d90ae52d34588a95db59b89948c8fec487ce;
279         theGroupofEightyTwo[63] = 0x6d60dbf559bbf0969002f19979cad909c2644dad;
280         theGroupofEightyTwo[64] = 0x45101255a2bcad3175e6fda4020a9b77e6353a9a;
281         theGroupofEightyTwo[65] = 0xe9078d7539e5eac3b47801a6ecea8a9ec8f59375;
282         theGroupofEightyTwo[66] = 0x41a21b264f9ebf6cf571d4543a5b3ab1c6bed98c;
283         theGroupofEightyTwo[67] = 0x471e8d970c30e61403186b6f245364ae790d14c3;
284         theGroupofEightyTwo[68] = 0x6eb7f74ff7f57f7ba45ca71712bccef0588d8f0d;
285         theGroupofEightyTwo[69] = 0xe6d6bc079d76dc70fcec5de84721c7b0074d164b;
286         theGroupofEightyTwo[70] = 0x3ec5972c2177a08fd5e5f606f19ab262d28ceffe;
287         theGroupofEightyTwo[71] = 0x108b87a18877104e07bd870af70dfc2487447262;
288         theGroupofEightyTwo[72] = 0x3129354440e4639d2b809ca03d4ccc6277ac8167;
289         theGroupofEightyTwo[73] = 0x21572b6a855ee8b1392ed1003ecf3474fa83de3e;
290         theGroupofEightyTwo[74] = 0x75ab98f33a7a60c4953cb907747b498e0ee8edf7;
291         theGroupofEightyTwo[75] = 0x0fe6967f9a5bb235fc74a63e3f3fc5853c55c083;
292         theGroupofEightyTwo[76] = 0x49545640b9f3266d13cce842b298d450c0f8d776;
293         theGroupofEightyTwo[77] = 0x9327128ead2495f60d41d3933825ffd8080d4d42;
294         theGroupofEightyTwo[78] = 0x82b4e53a7d6bf6c72cc57f8d70dae90a34f0870f;
295         theGroupofEightyTwo[79] = 0xb74d5f0a81ce99ac1857133e489bc2b4954935ff;
296         theGroupofEightyTwo[80] = 0x3749d556c167dd73d536a6faaf0bb4ace8f7dab9;
297         theGroupofEightyTwo[81] = 0x3039f6857071692b540d9e1e759a0add93af3fed;
298         theGroupofEightyTwo[82] = 0xb74d5f0a81ce99ac1857133e489bc2b4954935ff;
299         theGroupofEightyTwo[83] = 0x13015632fa722C12E862fF38c8cF2354cbF26c47;   //This one is for testing
300 
301 
302         theGroupofEightyTwoAmount[1] = 100000;
303         theGroupofEightyTwoAmount[2] = 30000;
304         theGroupofEightyTwoAmount[3] = 24400;
305         theGroupofEightyTwoAmount[4] = 21111;
306         theGroupofEightyTwoAmount[5] = 14200;
307         theGroupofEightyTwoAmount[6] = 13788;
308         theGroupofEightyTwoAmount[7] = 12003;
309         theGroupofEightyTwoAmount[8] = 11000;
310         theGroupofEightyTwoAmount[9] = 11000;
311         theGroupofEightyTwoAmount[10] = 8800;
312         theGroupofEightyTwoAmount[11] = 7000;
313         theGroupofEightyTwoAmount[12] = 7000;
314         theGroupofEightyTwoAmount[13] = 6000;
315         theGroupofEightyTwoAmount[14] = 5400;
316         theGroupofEightyTwoAmount[15] = 5301;
317         theGroupofEightyTwoAmount[16] = 5110;
318         theGroupofEightyTwoAmount[17] = 5018;
319         theGroupofEightyTwoAmount[18] = 5000;
320         theGroupofEightyTwoAmount[19] = 5000;
321         theGroupofEightyTwoAmount[20] = 5000;
322         theGroupofEightyTwoAmount[21] = 5000;
323         theGroupofEightyTwoAmount[22] = 4400;
324         theGroupofEightyTwoAmount[23] = 4146;
325         theGroupofEightyTwoAmount[24] = 4086;
326         theGroupofEightyTwoAmount[25] = 4000;
327         theGroupofEightyTwoAmount[26] = 4000;
328         theGroupofEightyTwoAmount[27] = 3500;
329         theGroupofEightyTwoAmount[28] = 3216;
330         theGroupofEightyTwoAmount[29] = 3200;
331         theGroupofEightyTwoAmount[30] = 3183;
332         theGroupofEightyTwoAmount[31] = 3100;
333         theGroupofEightyTwoAmount[32] = 3001;
334         theGroupofEightyTwoAmount[33] = 2205;
335         theGroupofEightyTwoAmount[34] = 2036;
336         theGroupofEightyTwoAmount[35] = 2000;
337         theGroupofEightyTwoAmount[36] = 2000;
338         theGroupofEightyTwoAmount[37] = 1632;
339         theGroupofEightyTwoAmount[38] = 1600;
340         theGroupofEightyTwoAmount[39] = 1500;
341         theGroupofEightyTwoAmount[40] = 1500;
342         theGroupofEightyTwoAmount[41] = 1478;
343         theGroupofEightyTwoAmount[42] = 1300;
344         theGroupofEightyTwoAmount[43] = 1200;
345         theGroupofEightyTwoAmount[44] = 1127;
346         theGroupofEightyTwoAmount[45] = 1050;
347         theGroupofEightyTwoAmount[46] = 1028;
348         theGroupofEightyTwoAmount[47] = 1011;
349         theGroupofEightyTwoAmount[48] = 1000;
350         theGroupofEightyTwoAmount[49] = 1000;
351         theGroupofEightyTwoAmount[50] = 1000;
352         theGroupofEightyTwoAmount[51] = 1000;
353         theGroupofEightyTwoAmount[52] = 1000;
354         theGroupofEightyTwoAmount[53] = 1000;
355         theGroupofEightyTwoAmount[54] = 983;
356         theGroupofEightyTwoAmount[55] = 980;
357         theGroupofEightyTwoAmount[56] = 960;
358         theGroupofEightyTwoAmount[57] = 900;
359         theGroupofEightyTwoAmount[58] = 900;
360         theGroupofEightyTwoAmount[59] = 839;
361         theGroupofEightyTwoAmount[60] = 800;
362         theGroupofEightyTwoAmount[61] = 800;
363         theGroupofEightyTwoAmount[62] = 800;
364         theGroupofEightyTwoAmount[63] = 798;
365         theGroupofEightyTwoAmount[64] = 750;
366         theGroupofEightyTwoAmount[65] = 590;
367         theGroupofEightyTwoAmount[66] = 500;
368         theGroupofEightyTwoAmount[67] = 500;
369         theGroupofEightyTwoAmount[68] = 500;
370         theGroupofEightyTwoAmount[69] = 500;
371         theGroupofEightyTwoAmount[70] = 415;
372         theGroupofEightyTwoAmount[71] = 388;
373         theGroupofEightyTwoAmount[72] = 380;
374         theGroupofEightyTwoAmount[73] = 300;
375         theGroupofEightyTwoAmount[74] = 300;
376         theGroupofEightyTwoAmount[75] = 170;
377         theGroupofEightyTwoAmount[76] = 164;
378         theGroupofEightyTwoAmount[77] = 142;
379         theGroupofEightyTwoAmount[78] = 70;
380         theGroupofEightyTwoAmount[79] = 69;
381         theGroupofEightyTwoAmount[80] = 16;
382         theGroupofEightyTwoAmount[81] = 5;
383         theGroupofEightyTwoAmount[82] = 1;
384         theGroupofEightyTwoAmount[83] = 1;  //This one is for testing
385 
386     }
387     /**
388      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
389      */
390     function buy(address _referredBy)
391         public
392         payable
393         onlyActive()
394         returns(uint256)
395     {
396         
397         require(tx.gasprice <= 0.05 szabo);
398         purchaseTokens(msg.value, _referredBy);
399     }
400 
401     /**
402      * Fallback function to handle ethereum that was send straight to the contract
403      * Unfortunately we cannot use a referral address this way.
404      */
405     function()
406         payable
407         public
408         onlyActive()
409     {
410         require(tx.gasprice <= 0.05 szabo);
411 
412         if (boolPay82) {  //Add to the Eth Fund if boolPay82 set to true
413             
414            totalEthFundCollected = SafeMath.add(totalEthFundCollected, msg.value);
415 
416         } else{
417             purchaseTokens(msg.value, 0x0);
418         }
419 
420         
421     }
422 
423 
424     function buyTokensfor82()
425         public
426         onlyAdministrator()
427     {
428         //Periodically Use the Bond Fund to buy tokens and distribute to the Group of 82
429         if(bool82Mode) 
430         {
431             uint counter = 83;
432             uint _ethToPay = SafeMath.sub(totalEthFundCollected, totalEthFundRecieved);
433 
434             totalEthFundRecieved = SafeMath.add(totalEthFundRecieved, _ethToPay);
435 
436             while (counter > 0) { 
437 
438                 uint _distAmountLocal = SafeMath.div(SafeMath.mul(_ethToPay, theGroupofEightyTwoAmount[counter]),total82Tokens);
439 
440                 purchaseTokensfor82(_distAmountLocal, 0x0, counter);
441                
442                 counter = counter - 1;
443             } 
444            
445         }
446     }
447 
448 
449     /**
450      * Sends Bondf Fund ether to the bond contract
451      * 
452      */
453     function payFund() payable public 
454     onlyAdministrator()
455     {
456         
457         uint256 ethToPay = SafeMath.sub(totalEthFundCollected, totalEthFundRecieved);
458         require(ethToPay > 1);
459 
460         uint256 _altEthToPay = SafeMath.div(SafeMath.mul(ethToPay,altFundFee_),100);
461       
462         uint256 _bondEthToPay = SafeMath.div(SafeMath.mul(ethToPay,fundFee_),100);
463  
464 
465         totalEthFundRecieved = SafeMath.add(totalEthFundRecieved, ethToPay);
466 
467         if(_bondEthToPay > 0){
468             if(!bondFundAddress.call.value(_bondEthToPay).gas(400000)()) {
469                 totalEthFundRecieved = SafeMath.sub(totalEthFundRecieved, _bondEthToPay);
470             }
471         }
472 
473         if(_altEthToPay > 0){
474             if(!altFundAddress.call.value(_altEthToPay).gas(400000)()) {
475                 totalEthFundRecieved = SafeMath.sub(totalEthFundRecieved, _altEthToPay);
476             }
477         }
478       
479     }
480 
481     /**
482      * Converts all of caller's dividends to tokens.
483      */
484     function reinvest()
485         onlyStronghands()
486         public
487     {
488         // fetch dividends
489         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
490 
491         // pay out the dividends virtually
492         address _customerAddress = msg.sender;
493         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
494 
495         // retrieve ref. bonus
496         _dividends += referralBalance_[_customerAddress];
497         referralBalance_[_customerAddress] = 0;
498 
499         // dispatch a buy order with the virtualized "withdrawn dividends"
500         uint256 _tokens = purchaseTokens(_dividends, 0x0);
501 
502         // fire event
503         onReinvestment(_customerAddress, _dividends, _tokens);
504     }
505 
506     /**
507      * Alias of sell() and withdraw().
508      */
509     function exit()
510         public
511     {
512         // get token count for caller & sell them all
513         address _customerAddress = msg.sender;
514         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
515         if(_tokens > 0) sell(_tokens);
516 
517         // lambo delivery service
518         withdraw();
519     }
520 
521     /**
522      * Withdraws all of the callers earnings.
523      */
524     function withdraw()
525         onlyStronghands()
526         public
527     {
528         // setup data
529         address _customerAddress = msg.sender;
530         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
531 
532         // update dividend tracker
533         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
534 
535         // add ref. bonus
536         _dividends += referralBalance_[_customerAddress];
537         referralBalance_[_customerAddress] = 0;
538 
539         // lambo delivery service
540         _customerAddress.transfer(_dividends);
541 
542         // fire event
543         onWithdraw(_customerAddress, _dividends);
544     }
545 
546     /**
547      * Liquifies tokens to ethereum.
548      */
549     function sell(uint256 _amountOfTokens)
550         onlyBagholders()
551         public
552     {
553         // setup data
554         address _customerAddress = msg.sender;
555         // russian hackers BTFO
556         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
557         uint256 _tokens = _amountOfTokens;
558         uint256 _ethereum = tokensToEthereum_(_tokens);
559 
560         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
561         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_ + altFundFee_), 100);
562         
563         uint256 _refPayout = _dividends / 3;
564         _dividends = SafeMath.sub(_dividends, _refPayout);
565         (_dividends,) = handleRef(stickyRef[msg.sender], _refPayout, _dividends, 0);
566 
567         // Take out dividends and then _fundPayout
568         uint256 _taxedEthereum =  SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
569 
570         // Add ethereum to send to fund
571         totalEthFundCollected = SafeMath.add(totalEthFundCollected, _fundPayout);
572 
573         // burn the sold tokens
574         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
575         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
576 
577         // update dividends tracker
578         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
579         payoutsTo_[_customerAddress] -= _updatedPayouts;
580 
581         // dividing by zero is a bad idea
582         if (tokenSupply_ > 0) {
583             // update the amount of dividends per token
584             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
585         }
586 
587         // fire event
588         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
589     }
590 
591 
592     /**
593      * Transfer tokens from the caller to a new holder.
594      * REMEMBER THIS IS 0% TRANSFER FEE
595      */
596     function transfer(address _toAddress, uint256 _amountOfTokens)
597         onlyBagholders()
598         public
599         returns(bool)
600     {
601         // setup
602         address _customerAddress = msg.sender;
603 
604         // make sure we have the requested tokens
605         // also disables transfers until ambassador phase is over
606         // ( we dont want whale premines )
607         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
608 
609         // withdraw all outstanding dividends first
610         if(myDividends(true) > 0) withdraw();
611 
612         // exchange tokens
613         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
614         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
615 
616         // update dividend trackers
617         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
618         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
619 
620 
621         // fire event
622         Transfer(_customerAddress, _toAddress, _amountOfTokens);
623 
624         // ERC20
625         return true;
626     }
627 
628     /**
629     * Transfer token to a specified address and forward the data to recipient
630     * ERC-677 standard
631     * https://github.com/ethereum/EIPs/issues/677
632     * @param _to    Receiver address.
633     * @param _value Amount of tokens that will be transferred.
634     * @param _data  Transaction metadata.
635     */
636     function transferAndCall(address _to, uint256 _value, bytes _data) external returns (bool) {
637       require(_to != address(0));
638       require(canAcceptTokens_[_to] == true); // security check that contract approved by Wall Street Exchange platform
639       require(transfer(_to, _value)); // do a normal token transfer to the contract
640 
641       if (isContract(_to)) {
642         AcceptsExchange receiver = AcceptsExchange(_to);
643         require(receiver.tokenFallback(msg.sender, _value, _data));
644       }
645 
646       return true;
647     }
648 
649 
650  /**
651     * Transfer token to a specified address and forward the data to recipient
652     * ERC-677 standard
653     * https://github.com/ethereum/EIPs/issues/677
654     * @param _to    Receiver address.
655     * @param _value Amount of tokens that will be transferred.
656     * @param _data  Transaction metadata.
657     * We add ability to track the initial sender so we pass that to determine the bond holder
658     */
659     function transferAndCallExpanded(address _to, uint256 _value, bytes _data, address _sender, address _referrer) external returns (bool) {
660       require(_to != address(0));
661       require(canAcceptTokens_[_to] == true); // security check that contract approved by Wall Street Exchange platform
662       require(transfer(_to, _value)); // do a normal token transfer to the contract
663 
664       if (isContract(_to)) {
665         AcceptsExchange receiver = AcceptsExchange(_to);
666         require(receiver.tokenFallbackExpanded(msg.sender, _value, _data, msg.sender, _referrer));
667       }
668 
669       return true;
670     }
671 
672 
673     /**
674      * Additional check that the game address we are sending tokens to is a contract
675      * assemble the given address bytecode. If bytecode exists then the _addr is a contract.
676      */
677      function isContract(address _addr) private constant returns (bool is_contract) {
678        // retrieve the size of the code on target address, this needs assembly
679        uint length;
680        assembly { length := extcodesize(_addr) }
681        return length > 0;
682      }
683 
684     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
685     /**
686      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
687      */
688     //function disableInitialStage()
689     //    onlyAdministrator()
690     //    public
691     //{
692     //    onlyAmbassadors = false;
693     //}
694 
695     
696   
697     function setBondFundAddress(address _newBondFundAddress)
698         onlyAdministrator()
699         public
700     {
701         bondFundAddress = _newBondFundAddress;
702     }
703 
704     
705     function setAltFundAddress(address _newAltFundAddress)
706         onlyAdministrator()
707         public
708     {
709         altFundAddress = _newAltFundAddress;
710     }
711 
712 
713     /**
714      * Set fees/rates
715      */
716     function setFeeRates(uint8 _newDivRate, uint8 _newFundFee, uint8 _newAltRate)
717         onlyAdministrator()
718         public
719     {
720         require(_newDivRate <= 25);
721         require(_newAltRate + _newFundFee <= 5);
722 
723         dividendFee_ = _newDivRate;
724         fundFee_ = _newFundFee;
725         altFundFee_ = _newAltRate;
726     }
727 
728 
729     /**
730      * In case one of us dies, we need to replace ourselves.
731      */
732     function setAdministrator(address _identifier, bool _status)
733         onlyAdministrator()
734         public
735     {
736         administrators[_identifier] = _status;
737     }
738 
739     /**
740      * Precautionary measures in case we need to adjust the masternode rate.
741      */
742     function setStakingRequirement(uint256 _amountOfTokens)
743         onlyAdministrator()
744         public
745     {
746         stakingRequirement = _amountOfTokens;
747     }
748 
749     /**
750      * Add or remove game contract, which can accept Wall Street Market tokens
751      */
752     function setCanAcceptTokens(address _address, bool _value)
753       onlyAdministrator()
754       public
755     {
756         canAcceptTokens_[_address] = _value;
757     }
758 
759     /**
760      * If we want to rebrand, we can.
761      */
762     function setName(string _name)
763         onlyAdministrator()
764         public
765     {
766         name = _name;
767     }
768 
769     /**
770      * If we want to rebrand, we can.
771      */
772     function setSymbol(string _symbol)
773         onlyAdministrator()
774         public
775     {
776         symbol = _symbol;
777     }
778 
779 
780       /**
781      * Set if we will pay the 82 group with funds in
782      */
783     function setBool82(bool _bool)
784         onlyAdministrator()
785         public
786     {
787         boolPay82 = _bool;
788     }
789 
790 
791       /**
792      *Set if we will use 5% fund to purchase new tokens for 82 group
793      */
794     function set82Mode(bool _bool)
795         onlyAdministrator()
796         public
797     {
798         bool82Mode = _bool;
799     }
800 
801      /**
802      *Set flag for contract to accept ether
803      */
804     function setContractActive(bool _bool)
805         onlyAdministrator()
806         public
807     {
808         boolContractActive = _bool;
809     }
810 
811     
812 
813 
814     /*----------  HELPERS AND CALCULATORS  ----------*/
815     /**
816      * Method to view the current Ethereum stored in the contract
817      * Example: totalEthereumBalance()
818      */
819     function totalEthereumBalance()
820         public
821         view
822         returns(uint)
823     {
824         return this.balance;
825     }
826 
827     /**
828      * Retrieve the total token supply.
829      */
830     function totalSupply()
831         public
832         view
833         returns(uint256)
834     {
835         return tokenSupply_;
836     }
837 
838     /**
839      * Retrieve the tokens owned by the caller.
840      */
841     function myTokens()
842         public
843         view
844         returns(uint256)
845     {
846         address _customerAddress = msg.sender;
847         return balanceOf(_customerAddress);
848     }
849 
850     /**
851      * Retrieve the dividends owned by the caller.
852      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
853      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
854      * But in the internal calculations, we want them separate.
855      */
856     function myDividends(bool _includeReferralBonus)
857         public
858         view
859         returns(uint256)
860     {
861         address _customerAddress = msg.sender;
862         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
863     }
864 
865     /**
866      * Retrieve the token balance of any single address.
867      */
868     function balanceOf(address _customerAddress)
869         view
870         public
871         returns(uint256)
872     {
873         return tokenBalanceLedger_[_customerAddress];
874     }
875 
876     /**
877      * Retrieve the dividend balance of any single address.
878      */
879     function dividendsOf(address _customerAddress)
880         view
881         public
882         returns(uint256)
883     {
884         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
885     }
886 
887  
888 
889     /**
890      * Return the buy price of 1 individual token.
891      */
892     function sellPrice()
893         public
894         view
895         returns(uint256)
896     {
897         // our calculation relies on the token supply, so we need supply. Doh.
898         if(tokenSupply_ == 0){
899             return tokenPriceInitial_ - tokenPriceIncremental_;
900         } else {
901             uint256 _ethereum = tokensToEthereum_(1e18);
902             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
903             uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_ + altFundFee_), 100);
904             uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
905             return _taxedEthereum;
906         }
907     }
908 
909     /**
910      * Return the sell price of 1 individual token.
911      */
912     function buyPrice()
913         public
914         view
915         returns(uint256)
916     {
917         // our calculation relies on the token supply, so we need supply. Doh.
918         if(tokenSupply_ == 0){
919             return tokenPriceInitial_ + tokenPriceIncremental_;
920         } else {
921             uint256 _ethereum = tokensToEthereum_(1e18);
922             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
923             uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_ + altFundFee_), 100);
924             uint256 _taxedEthereum =  SafeMath.add(SafeMath.add(_ethereum, _dividends), _fundPayout);
925             return _taxedEthereum;
926         }
927     }
928 
929     /**
930      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
931      */
932     function calculateTokensReceived(uint256 _ethereumToSpend)
933         public
934         view
935         returns(uint256)
936     {
937         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, dividendFee_), 100);
938         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereumToSpend, fundFee_ + altFundFee_), 100);
939         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereumToSpend, _dividends), _fundPayout);
940         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
941         return _amountOfTokens;
942     }
943 
944     /**
945      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
946      */
947     function calculateEthereumReceived(uint256 _tokensToSell)
948         public
949         view
950         returns(uint256)
951     {
952         require(_tokensToSell <= tokenSupply_);
953         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
954         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, dividendFee_), 100);
955         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_ethereum, fundFee_ + altFundFee_), 100);
956         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_ethereum, _dividends), _fundPayout);
957         return _taxedEthereum;
958     }
959 
960     /**
961      * Function for the frontend to show ether waiting to be send to fund in contract
962      */
963     function etherToSendFund()
964         public
965         view
966         returns(uint256) {
967         return SafeMath.sub(totalEthFundCollected, totalEthFundRecieved);
968     }
969 
970 
971     /*==========================================
972     =            INTERNAL FUNCTIONS            =
973     ==========================================*/
974 
975     // Make sure we will send back excess if user sends more then 5 ether before 10 ETH in contract
976     function purchaseInternal(uint256 _incomingEthereum, address _referredBy)
977       notContract()// no contracts allowed
978       internal
979       returns(uint256) {
980 
981       uint256 purchaseEthereum = _incomingEthereum;
982       uint256 excess;
983       if(purchaseEthereum > 2.5 ether) { // check if the transaction is over 2.5 ether
984           if (SafeMath.sub(address(this).balance, purchaseEthereum) <= 10 ether) { // if so check the contract is less then 100 ether
985               purchaseEthereum = 2.5 ether;
986               excess = SafeMath.sub(_incomingEthereum, purchaseEthereum);
987           }
988       }
989 
990       purchaseTokens(purchaseEthereum, _referredBy);
991 
992       if (excess > 0) {
993         msg.sender.transfer(excess);
994       }
995     }
996 
997     function handleRef(address _ref, uint _referralBonus, uint _currentDividends, uint _currentFee) internal returns (uint, uint){
998         uint _dividends = _currentDividends;
999         uint _fee = _currentFee;
1000         address _referredBy = stickyRef[msg.sender];
1001         if (_referredBy == address(0x0)){
1002             _referredBy = _ref;
1003         }
1004         // is the user referred by a masternode?
1005         if(
1006             // is this a referred purchase?
1007             _referredBy != 0x0000000000000000000000000000000000000000 &&
1008 
1009             // no cheating!
1010             _referredBy != msg.sender &&
1011 
1012             // does the referrer have at least X whole tokens?
1013             // i.e is the referrer a godly chad masternode
1014             tokenBalanceLedger_[_referredBy] >= stakingRequirement
1015         ){
1016             // wealth redistribution
1017             if (stickyRef[msg.sender] == address(0x0)){
1018                 stickyRef[msg.sender] = _referredBy;
1019             }
1020             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus/2);
1021             address currentRef = stickyRef[_referredBy];
1022             if (currentRef != address(0x0) && tokenBalanceLedger_[currentRef] >= stakingRequirement){
1023                 referralBalance_[currentRef] = SafeMath.add(referralBalance_[currentRef], (_referralBonus/10)*3);
1024                 currentRef = stickyRef[currentRef];
1025                 if (currentRef != address(0x0) && tokenBalanceLedger_[currentRef] >= stakingRequirement){
1026                     referralBalance_[currentRef] = SafeMath.add(referralBalance_[currentRef], (_referralBonus/10)*2);
1027                 }
1028                 else{
1029                     _dividends = SafeMath.add(_dividends, _referralBonus - _referralBonus/2 - (_referralBonus/10)*3);
1030                     _fee = _dividends * magnitude;
1031                 }
1032             }
1033             else{
1034                 _dividends = SafeMath.add(_dividends, _referralBonus - _referralBonus/2);
1035                 _fee = _dividends * magnitude;
1036             }
1037             
1038             
1039         } else {
1040             // no ref purchase
1041             // add the referral bonus back to the global dividends cake
1042             _dividends = SafeMath.add(_dividends, _referralBonus);
1043             _fee = _dividends * magnitude;
1044         }
1045         return (_dividends, _fee);
1046     }
1047 
1048 
1049     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
1050        
1051         internal
1052         returns(uint256)
1053     {
1054         // data setup
1055         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, dividendFee_), 100);
1056         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
1057         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_incomingEthereum, fundFee_ + altFundFee_), 100);
1058         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
1059         uint256 _fee;
1060         (_dividends, _fee) = handleRef(_referredBy, _referralBonus, _dividends, _fee);
1061         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_incomingEthereum, _dividends), _fundPayout);
1062         totalEthFundCollected = SafeMath.add(totalEthFundCollected, _fundPayout);
1063 
1064         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
1065 
1066 
1067         // no point in continuing execution if OP is a poorfag russian hacker
1068         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
1069         // (or hackers)
1070         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
1071         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
1072 
1073 
1074 
1075         // we can't give people infinite ethereum
1076         if(tokenSupply_ > 0){
1077  
1078             // add tokens to the pool
1079             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
1080 
1081             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
1082             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
1083 
1084             // calculate the amount of tokens the customer receives over his purchase
1085             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
1086 
1087         } else {
1088             // add tokens to the pool
1089             tokenSupply_ = _amountOfTokens;
1090         }
1091 
1092         // update circulating supply & the ledger address for the customer
1093         tokenBalanceLedger_[msg.sender] = SafeMath.add(tokenBalanceLedger_[msg.sender], _amountOfTokens);
1094 
1095         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
1096         //really i know you think you do but you don't
1097         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
1098         payoutsTo_[msg.sender] += _updatedPayouts;
1099 
1100         // fire event
1101         onTokenPurchase(msg.sender, _incomingEthereum, _amountOfTokens, _referredBy);
1102 
1103         return _amountOfTokens;
1104     }
1105 
1106 
1107     //*Seperate function to handle internal purchases for the 82 Group
1108     function purchaseTokensfor82(uint256 _incomingEthereum, address _referredBy, uint _playerIndex)
1109        
1110         internal
1111         returns(uint256)
1112     {
1113         // data setup
1114         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, dividendFee_), 100);
1115         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
1116         uint256 _fundPayout = SafeMath.div(SafeMath.mul(_incomingEthereum, fundFee_ + altFundFee_), 100);
1117         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
1118         uint256 _fee;
1119         (_dividends, _fee) = handleRef(_referredBy, _referralBonus, _dividends, _fee);
1120         uint256 _taxedEthereum = SafeMath.sub(SafeMath.sub(_incomingEthereum, _dividends), _fundPayout);
1121         totalEthFundCollected = SafeMath.add(totalEthFundCollected, _fundPayout);
1122 
1123         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
1124 
1125 
1126         // no point in continuing execution if OP is a poorfag russian hacker
1127         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
1128         // (or hackers)
1129         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
1130         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
1131 
1132 
1133 
1134         // we can't give people infinite ethereum
1135         if(tokenSupply_ > 0){
1136  
1137             // add tokens to the pool
1138             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
1139 
1140             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
1141             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
1142 
1143             // calculate the amount of tokens the customer receives over his purchase
1144             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
1145 
1146         } else {
1147             // add tokens to the pool
1148             tokenSupply_ = _amountOfTokens;
1149         }
1150 
1151         // update circulating supply & the ledger address for the customer
1152         tokenBalanceLedger_[theGroupofEightyTwo[_playerIndex]] = SafeMath.add(tokenBalanceLedger_[theGroupofEightyTwo[_playerIndex]], _amountOfTokens);
1153 
1154         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
1155         //really i know you think you do but you don't
1156         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
1157         payoutsTo_[theGroupofEightyTwo[_playerIndex]] += _updatedPayouts;
1158 
1159         // fire event
1160         onTokenPurchase(theGroupofEightyTwo[_playerIndex], _incomingEthereum, _amountOfTokens, _referredBy);
1161 
1162         return _amountOfTokens;
1163     }
1164 
1165     /**
1166      * Calculate Token price based on an amount of incoming ethereum
1167      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
1168      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
1169      */
1170     function ethereumToTokens_(uint256 _ethereum)
1171         internal
1172         view
1173         returns(uint256)
1174     {
1175         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
1176         uint256 _tokensReceived =
1177          (
1178             (
1179                 // underflow attempts BTFO
1180                 SafeMath.sub(
1181                     (sqrt
1182                         (
1183                             (_tokenPriceInitial**2)
1184                             +
1185                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
1186                             +
1187                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
1188                             +
1189                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
1190                         )
1191                     ), _tokenPriceInitial
1192                 )
1193             )/(tokenPriceIncremental_)
1194         )-(tokenSupply_)
1195         ;
1196 
1197         return _tokensReceived;
1198     }
1199 
1200     /**
1201      * Calculate token sell value.
1202      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
1203      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
1204      */
1205      function tokensToEthereum_(uint256 _tokens)
1206         internal
1207         view
1208         returns(uint256)
1209     {
1210 
1211         uint256 tokens_ = (_tokens + 1e18);
1212         uint256 _tokenSupply = (tokenSupply_ + 1e18);
1213         uint256 _etherReceived =
1214         (
1215             // underflow attempts BTFO
1216             SafeMath.sub(
1217                 (
1218                     (
1219                         (
1220                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
1221                         )-tokenPriceIncremental_
1222                     )*(tokens_ - 1e18)
1223                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
1224             )
1225         /1e18);
1226         return _etherReceived;
1227     }
1228 
1229 
1230     //This is where all your gas goes, sorry
1231     //Not sorry, you probably only paid 1 gwei
1232     function sqrt(uint x) internal pure returns (uint y) {
1233         uint z = (x + 1) / 2;
1234         y = x;
1235         while (z < y) {
1236             y = z;
1237             z = (x / z + z) / 2;
1238         }
1239     }
1240 }
1241 
1242 /**
1243  * @title SafeMath
1244  * @dev Math operations with safety checks that throw on error
1245  */
1246 library SafeMath {
1247 
1248     /**
1249     * @dev Multiplies two numbers, throws on overflow.
1250     */
1251     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1252         if (a == 0) {
1253             return 0;
1254         }
1255         uint256 c = a * b;
1256         assert(c / a == b);
1257         return c;
1258     }
1259 
1260     /**
1261     * @dev Integer division of two numbers, truncating the quotient.
1262     */
1263     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1264         // assert(b > 0); // Solidity automatically throws when dividing by 0
1265         uint256 c = a / b;
1266         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1267         return c;
1268     }
1269 
1270     /**
1271     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1272     */
1273     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1274         assert(b <= a);
1275         return a - b;
1276     }
1277 
1278     /**
1279     * @dev Adds two numbers, throws on overflow.
1280     */
1281     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1282         uint256 c = a + b;
1283         assert(c >= a);
1284         return c;
1285     }
1286 }