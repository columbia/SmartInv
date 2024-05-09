1 pragma solidity 0.4.25;
2 
3 /*===========================================================================================*
4 *************************************** https://p4d.io ***************************************
5 *============================================================================================*
6 *   
7 *                            ,-.----.           ,--,              
8 *                            \    /  \        ,--.'|    ,---,     
9 *                            |   :    \    ,--,  | :  .'  .' `\   
10 *                            |   |  .\ :,---.'|  : ',---.'     \  
11 *                            .   :  |: |;   : |  | ;|   |  .`\  | 
12 *                            |   |   \ :|   | : _' |:   : |  '  | 
13 *                            |   : .   /:   : |.'  ||   ' '  ;  : 
14 *                            ;   | |`-' |   ' '  ; :'   | ;  .  | 
15 *                            |   | ;    \   \  .'. ||   | :  |  ' 
16 *                            :   ' |     `---`:  | ''   : | /  ;  
17 *                            :   : :          '  ; ||   | '` ,/   
18 *                            |   | :          |  : ;;   :  .'     
19 *                            `---'.|          '  ,/ |   ,.'       
20 *                              `---`          '--'  '---'         
21 *                _____ _            _   _              __  __ _      _       _     
22 *               |_   _| |          | | | |            / _|/ _(_)    (_)     | |    
23 *                 | | | |__   ___  | | | |_ __   ___ | |_| |_ _  ___ _  __ _| |    
24 *                 | | | '_ \ / _ \ | | | | '_ \ / _ \|  _|  _| |/ __| |/ _` | |    
25 *                 | | | | | |  __/ | |_| | | | | (_) | | | | | | (__| | (_| | |    
26 *                 \_/ |_| |_|\___|  \___/|_| |_|\___/|_| |_| |_|\___|_|\__,_|_|    
27 *                                                                                  
28 *               ______ ___________   _____                           _             
29 *               | ___ \____ |  _  \ |  ___|                         (_)            
30 *               | |_/ /   / / | | | | |____  ___ __   __ _ _ __  ___ _  ___  _ __  
31 *               |  __/    \ \ | | | |  __\ \/ / '_ \ / _` | '_ \/ __| |/ _ \| '_ \ 
32 *               | |   .___/ / |/ /  | |___>  <| |_) | (_| | | | \__ \ | (_) | | | |
33 *               \_|   \____/|___/   \____/_/\_\ .__/ \__,_|_| |_|___/_|\___/|_| |_|
34 *                                             | |                                  
35 *                                             |_| 
36 *                                                       _L/L
37 *                                                     _LT/l_L_
38 *                                                   _LLl/L_T_lL_
39 *                               _T/L              _LT|L/_|__L_|_L_
40 *                             _Ll/l_L_          _TL|_T/_L_|__T__|_l_
41 *                           _TLl/T_l|_L_      _LL|_Tl/_|__l___L__L_|L_
42 *                         _LT_L/L_|_L_l_L_  _'|_|_|T/_L_l__T _ l__|__|L_
43 *                       _Tl_L|/_|__|_|__T _LlT_|_Ll/_l_ _|__[ ]__|__|_l_L_
44 *                ..__ _LT_l_l/|__|__l_T _T_L|_|_|l/___|__ | _l__|_ |__|_T_L_  __
45 *                   _       ___            _                  _       ___       
46 *                  /_\     / __\___  _ __ | |_ _ __ __ _  ___| |_    / __\_   _ 
47 *                 //_\\   / /  / _ \| '_ \| __| '__/ _` |/ __| __|  /__\// | | |
48 *                /  _  \ / /__| (_) | | | | |_| | | (_| | (__| |_  / \/  \ |_| |
49 *                \_/ \_/ \____/\___/|_| |_|\__|_|  \__,_|\___|\__| \_____/\__, |
50 *                                   ╔═╗╔═╗╦      ╔╦╗╔═╗╦  ╦               |___/ 
51 *                                   ╚═╗║ ║║       ║║║╣ ╚╗╔╝
52 *                                   ╚═╝╚═╝╩═╝────═╩╝╚═╝ ╚╝ 
53 *                                      0x736f6c5f646576
54 *                                      ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
55 * 
56 * -> What?
57 * The original autonomous pyramid, improved (again!):
58 *  [x] Developer optimized to include utility functions:
59 *      -> approve(): allow others to transfer on your behalf
60 *      -> approveAndCall(): callback for contracts that want to use approve()
61 *      -> transferFrom(): use your approval allowance to transfer P4D on anothers behalf
62 *      -> transferAndCall(): callback for contracts that want to use transfer()
63 *  [x] Designed to be a bridge for P3D to make the token functional for use in external contracts
64 *  [x] Masternodes are also used in P4D as well as when it buys P3D:
65 *      -> If the referrer has more than 10,000 P4D tokens, they will get 1/3 of the 10% divs
66 *      -> If the referrer also has more than 100 P3D tokens, they will be used as the ref
67 *         on the buy order to P3D and receive 1/3 of the 10% P3D divs upon purchase
68 *  [x] As this contract holds P3D, it will receive ETH dividends proportional to it's
69 *      holdings, this ETH is then distributed to all P4D token holders proportionally
70 *  [x] On top of the ETH divs from P3D, you will also receive P3D divs from buys and sells
71 *      in the P4D exchange
72 *  [x] There's a 10% div tax for buys, a 5% div tax on sells and a 0% tax on transfers
73 *  [x] No auto-transfers for dividends or subdividends, they will all be stored until
74 *      either withdraw() or reinvest() are called, this makes it easier for external
75 *      contracts to calculate how much they received upon a withdraw/reinvest
76 *  [x] Partial withdraws and reinvests for both dividends and subdividends
77 *  [x] Global name registry for all external contracts to use:
78 *      -> Names cost 0.01 ETH to register
79 *      -> Names must be unique and not already owned
80 *      -> You can set an active name out of all the ones you own
81 *      -> You can change your name at any time but still be referred by an old name
82 *      -> All ETH from registrations will be distributed to all P4D holders proportionally
83 *
84 */
85 
86 
87 // P3D interface
88 interface P3D {
89     function buy(address) external payable returns(uint256);
90     function transfer(address, uint256) external returns(bool);
91     function myTokens() external view returns(uint256);
92     function balanceOf(address) external view returns(uint256);
93     function myDividends(bool) external view returns(uint256);
94     function withdraw() external;
95     function calculateTokensReceived(uint256) external view returns(uint256);
96     function stakingRequirement() external view returns(uint256);
97 }
98 
99 // ERC-677 style token transfer callback
100 interface usingP4D {
101     function tokenCallback(address _from, uint256 _value, bytes _data) external returns (bool);
102 }
103 
104 // ERC-20 style approval callback
105 interface controllingP4D {
106     function approvalCallback(address _from, uint256 _value, bytes _data) external returns (bool);
107 }
108 
109 contract P4D {
110 
111     /*=================================
112     =            MODIFIERS            =
113     =================================*/
114     // only people with tokens
115     modifier onlyBagholders() {
116         require(myTokens() > 0);
117         _;
118     }
119 
120     // administrators can:
121     // -> change the name of the contract
122     // -> change the name of the token
123     // -> change the PoS difficulty (how many tokens it costs to hold a masternode, in case it gets crazy high later)
124     // -> allow a contract to accept P4D tokens
125     // they CANNOT:
126     // -> take funds
127     // -> disable withdrawals
128     // -> kill the contract
129     // -> change the price of tokens
130     modifier onlyAdministrator() {
131         require(administrators[msg.sender] || msg.sender == _dev);
132         _;
133     }
134 
135     // ensures that the first tokens in the contract will be equally distributed
136     // meaning, no divine dump will be ever possible
137     // result: healthy longevity.
138     modifier purchaseFilter(address _sender, uint256 _amountETH) {
139 
140         require(!isContract(_sender) || canAcceptTokens_[_sender]);
141         
142         if (now >= ACTIVATION_TIME) {
143             onlyAmbassadors = false;
144         }
145 
146         // are we still in the vulnerable phase?
147         // if so, enact anti early whale protocol
148         if (onlyAmbassadors && ((totalAmbassadorQuotaSpent_ + _amountETH) <= ambassadorQuota_)) {
149             require(
150                 // is the customer in the ambassador list?
151                 ambassadors_[_sender] == true &&
152 
153                 // does the customer purchase exceed the max ambassador quota?
154                 (ambassadorAccumulatedQuota_[_sender] + _amountETH) <= ambassadorMaxPurchase_
155             );
156 
157             // updated the accumulated quota
158             ambassadorAccumulatedQuota_[_sender] = SafeMath.add(ambassadorAccumulatedQuota_[_sender], _amountETH);
159             totalAmbassadorQuotaSpent_ = SafeMath.add(totalAmbassadorQuotaSpent_, _amountETH);
160 
161             // execute
162             _;
163         } else {
164             require(!onlyAmbassadors);
165             _;
166         }
167 
168     }
169 
170     /*==============================
171     =            EVENTS            =
172     ==============================*/
173     event onTokenPurchase(
174         address indexed _customerAddress,
175         uint256 _incomingP3D,
176         uint256 _tokensMinted,
177         address indexed _referredBy
178     );
179 
180     event onTokenSell(
181         address indexed _customerAddress,
182         uint256 _tokensBurned,
183         uint256 _P3D_received
184     );
185 
186     event onReinvestment(
187         address indexed _customerAddress,
188         uint256 _P3D_reinvested,
189         uint256 _tokensMinted
190     );
191 
192     event onSubdivsReinvestment(
193         address indexed _customerAddress,
194         uint256 _ETH_reinvested,
195         uint256 _tokensMinted
196     );
197 
198     event onWithdraw(
199         address indexed _customerAddress,
200         uint256 _P3D_withdrawn
201     );
202 
203     event onSubdivsWithdraw(
204         address indexed _customerAddress,
205         uint256 _ETH_withdrawn
206     );
207 
208     event onNameRegistration(
209         address indexed _customerAddress,
210         string _registeredName
211     );
212 
213     // ERC-20
214     event Transfer(
215         address indexed _from,
216         address indexed _to,
217         uint256 _tokens
218     );
219 
220     event Approval(
221         address indexed _tokenOwner,
222         address indexed _spender,
223         uint256 _tokens
224     );
225 
226 
227     /*=====================================
228     =            CONFIGURABLES            =
229     =====================================*/
230     string public name = "PoWH4D";
231     string public symbol = "P4D";
232     uint256 constant public decimals = 18;
233     uint256 constant internal buyDividendFee_ = 10; // 10% dividend tax on each buy
234     uint256 constant internal sellDividendFee_ = 5; // 5% dividend tax on each sell
235     uint256 internal tokenPriceInitial_; // set in the constructor
236     uint256 constant internal tokenPriceIncremental_ = 1e9; // 1/10th the incremental of P3D
237     uint256 constant internal magnitude = 2**64;
238     uint256 public stakingRequirement = 1e22; // 10,000 P4D
239     uint256 constant internal initialBuyLimitPerTx_ = 1 ether;
240     uint256 constant internal initialBuyLimitCap_ = 100 ether;
241     uint256 internal totalInputETH_ = 0;
242 
243 
244     // ambassador program
245     mapping(address => bool) internal ambassadors_;
246     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
247     uint256 constant internal ambassadorQuota_ = 12 ether;
248     uint256 internal totalAmbassadorQuotaSpent_ = 0;
249     address internal _dev;
250 
251 
252     uint256 public ACTIVATION_TIME;
253 
254 
255    /*================================
256     =            DATASETS            =
257     ================================*/
258     // amount of shares for each address (scaled number)
259     mapping(address => uint256) internal tokenBalanceLedger_;
260     mapping(address => uint256) internal referralBalance_;
261     mapping(address => int256) internal payoutsTo_;
262     mapping(address => uint256) internal dividendsStored_;
263     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
264     uint256 internal tokenSupply_ = 0;
265     uint256 internal profitPerShare_;
266 
267     // administrator list (see above on what they can do)
268     mapping(address => bool) public administrators;
269 
270     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
271     bool public onlyAmbassadors = true;
272 
273     // contracts can interact with the exchange but only approved ones
274     mapping(address => bool) public canAcceptTokens_;
275 
276     // ERC-20 standard
277     mapping(address => mapping (address => uint256)) public allowed;
278 
279     // P3D contract reference
280     P3D internal _P3D;
281 
282     // structure to handle the distribution of ETH divs paid out by the P3D contract
283     struct P3D_dividends {
284         uint256 balance;
285         uint256 lastDividendPoints;
286     }
287     mapping(address => P3D_dividends) internal divsMap_;
288     uint256 internal totalDividendPoints_;
289     uint256 internal lastContractBalance_;
290 
291     // structure to handle the global unique name/vanity registration
292     struct NameRegistry {
293         uint256 activeIndex;
294         bytes32[] registeredNames;
295     }
296     mapping(address => NameRegistry) internal customerNameMap_;
297     mapping(bytes32 => address) internal globalNameMap_;
298     uint256 constant internal nameRegistrationFee = 0.01 ether;
299 
300 
301     /*=======================================
302     =            PUBLIC FUNCTIONS            =
303     =======================================*/
304     /*
305     * -- APPLICATION ENTRY POINTS --
306     */
307     constructor(uint256 _activationTime, address _P3D_address) public {
308 
309         _dev = msg.sender;
310 
311         ACTIVATION_TIME = _activationTime;
312 
313         totalDividendPoints_ = 1; // non-zero value
314 
315         _P3D = P3D(_P3D_address);
316 
317         // virtualized purchase of the entire ambassador quota
318         // calculateTokensReceived() for this contract will return how many tokens can be bought starting at 1e9 P3D per P4D
319         // as the price increases by the incremental each time we can just multiply it out and scale it back to e18
320         //
321         // this is used as the initial P3D-P4D price as it makes it fairer on other investors that aren't ambassadors
322         uint256 _P4D_received;
323         (, _P4D_received) = calculateTokensReceived(ambassadorQuota_);
324         tokenPriceInitial_ = tokenPriceIncremental_ * _P4D_received / 1e18;
325 
326         // admins
327         administrators[_dev] = true;
328         
329         // ambassadors
330         ambassadors_[_dev] = true;
331     }
332 
333 
334     /**
335      * Converts all incoming ethereum to tokens for the caller, and passes down the referral address
336      */
337     function buy(address _referredBy)
338         payable
339         public
340         returns(uint256)
341     {
342         return purchaseInternal(msg.sender, msg.value, _referredBy);
343     }
344 
345     /**
346      * Buy with a registered name as the referrer.
347      * If the name is unregistered, address(0x0) will be the ref
348      */
349     function buyWithNameRef(string memory _nameOfReferrer)
350         payable
351         public
352         returns(uint256)
353     {
354         return purchaseInternal(msg.sender, msg.value, ownerOfName(_nameOfReferrer));
355     }
356 
357     /**
358      * Fallback function to handle ethereum that was sent straight to the contract
359      * Unfortunately we cannot use a referral address this way.
360      */
361     function()
362         payable
363         public
364     {
365         if (msg.sender != address(_P3D)) {
366             purchaseInternal(msg.sender, msg.value, address(0x0));
367         }
368 
369         // all other ETH is from the withdrawn dividends from
370         // the P3D contract, this is distributed out via the
371         // updateSubdivsFor() method
372         // no more computation can be done inside this function
373         // as when you call address.transfer(uint256), only
374         // 2,300 gas is forwarded to this function so no variables
375         // can be mutated with that limit
376         // address(this).balance will represent the total amount
377         // of ETH dividends from the P3D contract (minus the amount
378         // that's already been withdrawn)
379     }
380 
381     /**
382      * Distribute any ETH sent to this method out to all token holders
383      */
384     function donate()
385         payable
386         public
387     {
388         // nothing happens here in order to save gas
389         // all of the ETH sent to this function will be distributed out
390         // via the updateSubdivsFor() method
391         // 
392         // this method is designed for external contracts that have 
393         // extra ETH that they want to evenly distribute to all
394         // P4D token holders
395     }
396 
397     /**
398      * Allows a customer to pay for a global name on the P4D network
399      * There's a 0.01 ETH registration fee per name
400      * All ETH is distributed to P4D token holders via updateSubdivsFor()
401      */
402     function registerName(string memory _name)
403         payable
404         public
405     {
406         address _customerAddress = msg.sender;
407         require(!onlyAmbassadors || ambassadors_[_customerAddress]);
408 
409         require(bytes(_name).length > 0);
410         require(msg.value >= nameRegistrationFee);
411         uint256 excess = SafeMath.sub(msg.value, nameRegistrationFee);
412 
413         bytes32 bytesName = stringToBytes32(_name);
414         require(globalNameMap_[bytesName] == address(0x0));
415 
416         NameRegistry storage customerNamesInfo = customerNameMap_[_customerAddress];
417         customerNamesInfo.registeredNames.push(bytesName);
418         customerNamesInfo.activeIndex = customerNamesInfo.registeredNames.length - 1;
419 
420         globalNameMap_[bytesName] = _customerAddress;
421 
422         if (excess > 0) {
423             _customerAddress.transfer(excess);
424         }
425 
426         // fire event
427         emit onNameRegistration(_customerAddress, _name);
428 
429         // similar to the fallback and donate functions, the ETH cost of
430         // the name registration fee (0.01 ETH) will be distributed out
431         // to all P4D tokens holders via the updateSubdivsFor() method
432     }
433 
434     /**
435      * Change your active name to a name that you've already purchased
436      */
437     function changeActiveNameTo(string memory _name)
438         public
439     {
440         address _customerAddress = msg.sender;
441         require(_customerAddress == ownerOfName(_name));
442 
443         bytes32 bytesName = stringToBytes32(_name);
444         NameRegistry storage customerNamesInfo = customerNameMap_[_customerAddress];
445 
446         uint256 newActiveIndex = 0;
447         for (uint256 i = 0; i < customerNamesInfo.registeredNames.length; i++) {
448             if (bytesName == customerNamesInfo.registeredNames[i]) {
449                 newActiveIndex = i;
450                 break;
451             }
452         }
453 
454         customerNamesInfo.activeIndex = newActiveIndex;
455     }
456 
457     /**
458      * Similar to changeActiveNameTo() without the need to iterate through your name list
459      */
460     function changeActiveNameIndexTo(uint256 _newActiveIndex)
461         public
462     {
463         address _customerAddress = msg.sender;
464         NameRegistry storage customerNamesInfo = customerNameMap_[_customerAddress];
465 
466         require(_newActiveIndex < customerNamesInfo.registeredNames.length);
467         customerNamesInfo.activeIndex = _newActiveIndex;
468     }
469 
470     /**
471      * Converts all of caller's dividends to tokens.
472      * The argument is not used but it allows MetaMask to render
473      * 'Reinvest' in your transactions list once the function sig
474      * is registered to the contract at;
475      * https://etherscan.io/address/0x44691B39d1a75dC4E0A0346CBB15E310e6ED1E86#writeContract
476      */
477     function reinvest(bool)
478         public
479     {
480         // setup data
481         address _customerAddress = msg.sender;
482         withdrawInternal(_customerAddress);
483 
484         uint256 reinvestableDividends = dividendsStored_[_customerAddress];
485         reinvestAmount(reinvestableDividends);
486     }
487 
488     /**
489      * Converts a portion of caller's dividends to tokens.
490      */
491     function reinvestAmount(uint256 _amountOfP3D)
492         public
493     {
494         // setup data
495         address _customerAddress = msg.sender;
496         withdrawInternal(_customerAddress);
497 
498         if (_amountOfP3D > 0 && _amountOfP3D <= dividendsStored_[_customerAddress]) {
499             dividendsStored_[_customerAddress] = SafeMath.sub(dividendsStored_[_customerAddress], _amountOfP3D);
500 
501             // dispatch a buy order with the virtualized "withdrawn dividends"
502             uint256 _tokens = purchaseTokens(_customerAddress, _amountOfP3D, address(0x0));
503 
504             // fire event
505             emit onReinvestment(_customerAddress, _amountOfP3D, _tokens);
506         }
507     }
508 
509     /**
510      * Converts all of caller's subdividends to tokens.
511      * The argument is not used but it allows MetaMask to render
512      * 'Reinvest Subdivs' in your transactions list once the function sig
513      * is registered to the contract at;
514      * https://etherscan.io/address/0x44691B39d1a75dC4E0A0346CBB15E310e6ED1E86#writeContract
515      */
516     function reinvestSubdivs(bool)
517         public
518     {
519         // setup data
520         address _customerAddress = msg.sender;
521         updateSubdivsFor(_customerAddress);
522 
523         uint256 reinvestableSubdividends = divsMap_[_customerAddress].balance;
524         reinvestSubdivsAmount(reinvestableSubdividends);
525     }
526 
527     /**
528      * Converts a portion of caller's subdividends to tokens.
529      */
530     function reinvestSubdivsAmount(uint256 _amountOfETH)
531         public
532     {
533         // setup data
534         address _customerAddress = msg.sender;
535         updateSubdivsFor(_customerAddress);
536 
537         if (_amountOfETH > 0 && _amountOfETH <= divsMap_[_customerAddress].balance) {
538             divsMap_[_customerAddress].balance = SafeMath.sub(divsMap_[_customerAddress].balance, _amountOfETH);
539             lastContractBalance_ = SafeMath.sub(lastContractBalance_, _amountOfETH);
540 
541             // purchase tokens with the ETH subdividends
542             uint256 _tokens = purchaseInternal(_customerAddress, _amountOfETH, address(0x0));
543 
544             // fire event
545             emit onSubdivsReinvestment(_customerAddress, _amountOfETH, _tokens);
546         }
547     }
548 
549     /**
550      * Alias of sell(), withdraw() and withdrawSubdivs().
551      * The argument is not used but it allows MetaMask to render
552      * 'Exit' in your transactions list once the function sig
553      * is registered to the contract at;
554      * https://etherscan.io/address/0x44691B39d1a75dC4E0A0346CBB15E310e6ED1E86#writeContract
555      */
556     function exit(bool)
557         public
558     {
559         // get token count for caller & sell them all
560         address _customerAddress = msg.sender;
561         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
562         if(_tokens > 0) sell(_tokens);
563 
564         // lambo delivery service
565         withdraw(true);
566         withdrawSubdivs(true);
567     }
568 
569     /**
570      * Withdraws all of the callers dividend earnings.
571      * The argument is not used but it allows MetaMask to render
572      * 'Withdraw' in your transactions list once the function sig
573      * is registered to the contract at;
574      * https://etherscan.io/address/0x44691B39d1a75dC4E0A0346CBB15E310e6ED1E86#writeContract
575      */
576     function withdraw(bool)
577         public
578     {
579         // setup data
580         address _customerAddress = msg.sender;
581         withdrawInternal(_customerAddress);
582 
583         uint256 withdrawableDividends = dividendsStored_[_customerAddress];
584         withdrawAmount(withdrawableDividends);
585     }
586 
587     /**
588      * Withdraws a portion of the callers dividend earnings.
589      */
590     function withdrawAmount(uint256 _amountOfP3D)
591         public
592     {
593         // setup data
594         address _customerAddress = msg.sender;
595         withdrawInternal(_customerAddress);
596 
597         if (_amountOfP3D > 0 && _amountOfP3D <= dividendsStored_[_customerAddress]) {
598             dividendsStored_[_customerAddress] = SafeMath.sub(dividendsStored_[_customerAddress], _amountOfP3D);
599             
600             // lambo delivery service
601             require(_P3D.transfer(_customerAddress, _amountOfP3D));
602             // NOTE!
603             // P3D has a 10% transfer tax so even though this is sending your entire
604             // dividend count to you, you will only actually receive 90%.
605 
606             // fire event
607             emit onWithdraw(_customerAddress, _amountOfP3D);
608         }
609     }
610 
611     /**
612      * Withdraws all of the callers subdividend earnings.
613      * The argument is not used but it allows MetaMask to render
614      * 'Withdraw Subdivs' in your transactions list once the function sig
615      * is registered to the contract at;
616      * https://etherscan.io/address/0x44691B39d1a75dC4E0A0346CBB15E310e6ED1E86#writeContract
617      */
618     function withdrawSubdivs(bool)
619         public
620     {
621         // setup data
622         address _customerAddress = msg.sender;
623         updateSubdivsFor(_customerAddress);
624 
625         uint256 withdrawableSubdividends = divsMap_[_customerAddress].balance;
626         withdrawSubdivsAmount(withdrawableSubdividends);
627     }
628 
629     /**
630      * Withdraws a portion of the callers subdividend earnings.
631      */
632     function withdrawSubdivsAmount(uint256 _amountOfETH)
633         public
634     {
635         // setup data
636         address _customerAddress = msg.sender;
637         updateSubdivsFor(_customerAddress);
638 
639         if (_amountOfETH > 0 && _amountOfETH <= divsMap_[_customerAddress].balance) {
640             divsMap_[_customerAddress].balance = SafeMath.sub(divsMap_[_customerAddress].balance, _amountOfETH);
641             lastContractBalance_ = SafeMath.sub(lastContractBalance_, _amountOfETH);
642 
643             // transfer all withdrawable subdividends
644             _customerAddress.transfer(_amountOfETH);
645 
646             // fire event
647             emit onSubdivsWithdraw(_customerAddress, _amountOfETH);
648         }
649     }
650 
651     /**
652      * Liquifies tokens to P3D.
653      */
654     function sell(uint256 _amountOfTokens)
655         onlyBagholders()
656         public
657     {
658         // setup data
659         address _customerAddress = msg.sender;
660         updateSubdivsFor(_customerAddress);
661 
662         // russian hackers BTFO
663         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
664         uint256 _tokens = _amountOfTokens;
665         uint256 _P3D_amount = tokensToP3D_(_tokens);
666         uint256 _dividends = SafeMath.div(SafeMath.mul(_P3D_amount, sellDividendFee_), 100);
667         uint256 _taxedP3D = SafeMath.sub(_P3D_amount, _dividends);
668 
669         // burn the sold tokens
670         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
671         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
672 
673         // update dividends tracker
674         int256 _updatedPayouts = (int256)(profitPerShare_ * _tokens + (_taxedP3D * magnitude));
675         payoutsTo_[_customerAddress] -= _updatedPayouts;
676 
677         // dividing by zero is a bad idea
678         if (tokenSupply_ > 0) {
679             // update the amount of dividends per token
680             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
681         }
682 
683         // fire events
684         emit onTokenSell(_customerAddress, _tokens, _taxedP3D);
685         emit Transfer(_customerAddress, address(0x0), _tokens);
686     }
687 
688     /**
689      * Transfer tokens from the caller to a new holder.
690      * REMEMBER THIS IS 0% TRANSFER FEE
691      */
692     function transfer(address _toAddress, uint256 _amountOfTokens)
693         onlyBagholders()
694         public
695         returns(bool)
696     {
697         address _customerAddress = msg.sender;
698         return transferInternal(_customerAddress, _toAddress, _amountOfTokens);
699     }
700 
701     /**
702      * Transfer token to a specified address and forward the data to recipient
703      * ERC-677 standard
704      * https://github.com/ethereum/EIPs/issues/677
705      * @param _to    Receiver address.
706      * @param _value Amount of tokens that will be transferred.
707      * @param _data  Transaction metadata.
708      */
709     function transferAndCall(address _to, uint256 _value, bytes _data)
710         external
711         returns(bool)
712     {
713         require(canAcceptTokens_[_to]); // approved contracts only
714         require(transfer(_to, _value)); // do a normal token transfer to the contract
715 
716         if (isContract(_to)) {
717             usingP4D receiver = usingP4D(_to);
718             require(receiver.tokenCallback(msg.sender, _value, _data));
719         }
720 
721         return true;
722     }
723 
724     /**
725      * ERC-20 token standard for transferring tokens on anothers behalf
726      */
727     function transferFrom(address _from, address _to, uint256 _amountOfTokens)
728         public
729         returns(bool)
730     {
731         require(allowed[_from][msg.sender] >= _amountOfTokens);
732         allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _amountOfTokens);
733 
734         return transferInternal(_from, _to, _amountOfTokens);
735     }
736 
737     /**
738      * ERC-20 token standard for allowing another address to transfer your tokens
739      * on your behalf up to a certain limit
740      */
741     function approve(address _spender, uint256 _tokens)
742         public
743         returns(bool)
744     {
745         allowed[msg.sender][_spender] = _tokens;
746         emit Approval(msg.sender, _spender, _tokens);
747         return true;
748     }
749 
750     /**
751      * ERC-20 token standard for approving and calling an external
752      * contract with data
753      */
754     function approveAndCall(address _to, uint256 _value, bytes _data)
755         external
756         returns(bool)
757     {
758         require(approve(_to, _value)); // do a normal approval
759 
760         if (isContract(_to)) {
761             controllingP4D receiver = controllingP4D(_to);
762             require(receiver.approvalCallback(msg.sender, _value, _data));
763         }
764 
765         return true;
766     }
767 
768 
769     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
770     /**
771      * In case one of us dies, we need to replace ourselves.
772      */
773     function setAdministrator(address _identifier, bool _status)
774         onlyAdministrator()
775         public
776     {
777         administrators[_identifier] = _status;
778     }
779 
780     /**
781      * Add a new ambassador to the exchange
782      */
783     function setAmbassador(address _identifier, bool _status)
784         onlyAdministrator()
785         public
786     {
787         ambassadors_[_identifier] = _status;
788     }
789 
790     /**
791      * Precautionary measures in case we need to adjust the masternode rate.
792      */
793     function setStakingRequirement(uint256 _amountOfTokens)
794         onlyAdministrator()
795         public
796     {
797         stakingRequirement = _amountOfTokens;
798     }
799 
800     /**
801      * Add a sub-contract, which can accept P4D tokens
802      */
803     function setCanAcceptTokens(address _address)
804         onlyAdministrator()
805         public
806     {
807         require(isContract(_address));
808         canAcceptTokens_[_address] = true; // one way switch
809     }
810 
811     /**
812      * If we want to rebrand, we can.
813      */
814     function setName(string _name)
815         onlyAdministrator()
816         public
817     {
818         name = _name;
819     }
820 
821     /**
822      * If we want to rebrand, we can.
823      */
824     function setSymbol(string _symbol)
825         onlyAdministrator()
826         public
827     {
828         symbol = _symbol;
829     }
830 
831 
832     /*----------  HELPERS AND CALCULATORS  ----------*/
833     /**
834      * Method to view the current P3D tokens stored in the contract
835      */
836     function totalBalance()
837         public
838         view
839         returns(uint256)
840     {
841         return _P3D.myTokens();
842     }
843 
844     /**
845      * Retrieve the total token supply.
846      */
847     function totalSupply()
848         public
849         view
850         returns(uint256)
851     {
852         return tokenSupply_;
853     }
854 
855     /**
856      * Retrieve the tokens owned by the caller.
857      */
858     function myTokens()
859         public
860         view
861         returns(uint256)
862     {
863         address _customerAddress = msg.sender;
864         return balanceOf(_customerAddress);
865     }
866 
867     /**
868      * Retrieve the dividends owned by the caller.
869      * If `_includeReferralBonus` is set to true, the referral bonus will be included in the calculations.
870      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
871      * But in the internal calculations, we want them separate.
872      */
873     function myDividends(bool _includeReferralBonus)
874         public
875         view
876         returns(uint256)
877     {
878         address _customerAddress = msg.sender;
879         return (_includeReferralBonus ? dividendsOf(_customerAddress) + referralDividendsOf(_customerAddress) : dividendsOf(_customerAddress));
880     }
881 
882     /**
883      * Retrieve the subdividend owned by the caller.
884      */
885     function myStoredDividends()
886         public
887         view
888         returns(uint256)
889     {
890         address _customerAddress = msg.sender;
891         return storedDividendsOf(_customerAddress);
892     }
893 
894     /**
895      * Retrieve the subdividend owned by the caller.
896      */
897     function mySubdividends()
898         public
899         view
900         returns(uint256)
901     {
902         address _customerAddress = msg.sender;
903         return subdividendsOf(_customerAddress);
904     }
905 
906     /**
907      * Retrieve the token balance of any single address.
908      */
909     function balanceOf(address _customerAddress)
910         public
911         view
912         returns(uint256)
913     {
914         return tokenBalanceLedger_[_customerAddress];
915     }
916 
917     /**
918      * Retrieve the dividend balance of any single address.
919      */
920     function dividendsOf(address _customerAddress)
921         public
922         view
923         returns(uint256)
924     {
925         return (uint256)((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
926     }
927 
928     /**
929      * Retrieve the referred dividend balance of any single address.
930      */
931     function referralDividendsOf(address _customerAddress)
932         public
933         view
934         returns(uint256)
935     {
936         return referralBalance_[_customerAddress];
937     }
938 
939     /**
940      * Retrieve the stored dividend balance of any single address.
941      */
942     function storedDividendsOf(address _customerAddress)
943         public
944         view
945         returns(uint256)
946     {
947         return dividendsStored_[_customerAddress] + dividendsOf(_customerAddress) + referralDividendsOf(_customerAddress);
948     }
949 
950     /**
951      * Retrieve the subdividend balance owing of any single address.
952      */
953     function subdividendsOwing(address _customerAddress)
954         public
955         view
956         returns(uint256)
957     {
958         return (divsMap_[_customerAddress].lastDividendPoints == 0 ? 0 : (balanceOf(_customerAddress) * (totalDividendPoints_ - divsMap_[_customerAddress].lastDividendPoints)) / magnitude);
959     }
960 
961     /**
962      * Retrieve the subdividend balance of any single address.
963      */
964     function subdividendsOf(address _customerAddress)
965         public
966         view
967         returns(uint256)
968     {
969         return SafeMath.add(divsMap_[_customerAddress].balance, subdividendsOwing(_customerAddress));
970     }
971 
972     /**
973      * Retrieve the allowance of an owner and spender.
974      */
975     function allowance(address _tokenOwner, address _spender) 
976         public
977         view
978         returns(uint256)
979     {
980         return allowed[_tokenOwner][_spender];
981     }
982 
983     /**
984      * Retrieve all name information about a customer
985      */
986     function namesOf(address _customerAddress)
987         public
988         view
989         returns(uint256 activeIndex, string activeName, bytes32[] customerNames)
990     {
991         NameRegistry memory customerNamesInfo = customerNameMap_[_customerAddress];
992 
993         uint256 length = customerNamesInfo.registeredNames.length;
994         customerNames = new bytes32[](length);
995 
996         for (uint256 i = 0; i < length; i++) {
997             customerNames[i] = customerNamesInfo.registeredNames[i];
998         }
999 
1000         activeIndex = customerNamesInfo.activeIndex;
1001         activeName = activeNameOf(_customerAddress);
1002     }
1003 
1004     /**
1005      * Retrieves the address of the owner from the name
1006      */
1007     function ownerOfName(string memory _name)
1008         public
1009         view
1010         returns(address)
1011     {
1012         if (bytes(_name).length > 0) {
1013             bytes32 bytesName = stringToBytes32(_name);
1014             return globalNameMap_[bytesName];
1015         } else {
1016             return address(0x0);
1017         }
1018     }
1019 
1020     /**
1021      * Retrieves the active name of a customer
1022      */
1023     function activeNameOf(address _customerAddress)
1024         public
1025         view
1026         returns(string)
1027     {
1028         NameRegistry memory customerNamesInfo = customerNameMap_[_customerAddress];
1029         if (customerNamesInfo.registeredNames.length > 0) {
1030             bytes32 activeBytesName = customerNamesInfo.registeredNames[customerNamesInfo.activeIndex];
1031             return bytes32ToString(activeBytesName);
1032         } else {
1033             return "";
1034         }
1035     }
1036 
1037     /**
1038      * Return the buy price of 1 individual token.
1039      */
1040     function sellPrice()
1041         public
1042         view
1043         returns(uint256)
1044     {
1045         // our calculation relies on the token supply, so we need supply. Doh.
1046         if(tokenSupply_ == 0){
1047             return tokenPriceInitial_ - tokenPriceIncremental_;
1048         } else {
1049             uint256 _P3D_received = tokensToP3D_(1e18);
1050             uint256 _dividends = SafeMath.div(SafeMath.mul(_P3D_received, sellDividendFee_), 100);
1051             uint256 _taxedP3D = SafeMath.sub(_P3D_received, _dividends);
1052 
1053             return _taxedP3D;
1054         }
1055     }
1056 
1057     /**
1058      * Return the sell price of 1 individual token.
1059      */
1060     function buyPrice()
1061         public
1062         view
1063         returns(uint256)
1064     {
1065         // our calculation relies on the token supply, so we need supply. Doh.
1066         if(tokenSupply_ == 0){
1067             return tokenPriceInitial_ + tokenPriceIncremental_;
1068         } else {
1069             uint256 _P3D_received = tokensToP3D_(1e18);
1070             uint256 _dividends = SafeMath.div(SafeMath.mul(_P3D_received, buyDividendFee_), 100);
1071             uint256 _taxedP3D =  SafeMath.add(_P3D_received, _dividends);
1072             
1073             return _taxedP3D;
1074         }
1075     }
1076 
1077     /**
1078      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
1079      */
1080     function calculateTokensReceived(uint256 _amountOfETH)
1081         public
1082         view
1083         returns(uint256 _P3D_received, uint256 _P4D_received)
1084     {
1085         uint256 P3D_received = _P3D.calculateTokensReceived(_amountOfETH);
1086 
1087         uint256 _dividends = SafeMath.div(SafeMath.mul(P3D_received, buyDividendFee_), 100);
1088         uint256 _taxedP3D = SafeMath.sub(P3D_received, _dividends);
1089         uint256 _amountOfTokens = P3DtoTokens_(_taxedP3D);
1090         
1091         return (P3D_received, _amountOfTokens);
1092     }
1093 
1094     /**
1095      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
1096      */
1097     function calculateAmountReceived(uint256 _tokensToSell)
1098         public
1099         view
1100         returns(uint256)
1101     {
1102         require(_tokensToSell <= tokenSupply_);
1103         uint256 _P3D_received = tokensToP3D_(_tokensToSell);
1104         uint256 _dividends = SafeMath.div(SafeMath.mul(_P3D_received, sellDividendFee_), 100);
1105         uint256 _taxedP3D = SafeMath.sub(_P3D_received, _dividends);
1106         
1107         return _taxedP3D;
1108     }
1109 
1110     /**
1111     * Utility method to expose the P3D address for any child contracts to use
1112     */
1113     function P3D_address()
1114         public
1115         view
1116         returns(address)
1117     {
1118         return address(_P3D);
1119     }
1120 
1121     /**
1122     * Utility method to return all of the data needed for the front end in 1 call
1123     */
1124     function fetchAllDataForCustomer(address _customerAddress)
1125         public
1126         view
1127         returns(uint256 _totalSupply, uint256 _totalBalance, uint256 _buyPrice, uint256 _sellPrice, uint256 _activationTime,
1128                 uint256 _customerTokens, uint256 _customerUnclaimedDividends, uint256 _customerStoredDividends, uint256 _customerSubdividends)
1129     {
1130         _totalSupply = totalSupply();
1131         _totalBalance = totalBalance();
1132         _buyPrice = buyPrice();
1133         _sellPrice = sellPrice();
1134         _activationTime = ACTIVATION_TIME;
1135         _customerTokens = balanceOf(_customerAddress);
1136         _customerUnclaimedDividends = dividendsOf(_customerAddress) + referralDividendsOf(_customerAddress);
1137         _customerStoredDividends = storedDividendsOf(_customerAddress);
1138         _customerSubdividends = subdividendsOf(_customerAddress);
1139     }
1140 
1141 
1142     /*==========================================
1143     =            INTERNAL FUNCTIONS            =
1144     ==========================================*/
1145 
1146     // This function should always be called before a customers P4D balance changes.
1147     // It's responsible for withdrawing any outstanding ETH dividends from the P3D exchange
1148     // as well as distrubuting all of the additional ETH balance since the last update to
1149     // all of the P4D token holders proportionally.
1150     // After this it will move any owed subdividends into the customers withdrawable subdividend balance.
1151     function updateSubdivsFor(address _customerAddress)
1152         internal
1153     {   
1154         // withdraw the P3D dividends first
1155         if (_P3D.myDividends(true) > 0) {
1156             _P3D.withdraw();
1157         }
1158 
1159         // check if we have additional ETH in the contract since the last update
1160         uint256 contractBalance = address(this).balance;
1161         if (contractBalance > lastContractBalance_ && totalSupply() != 0) {
1162             uint256 additionalDivsFromP3D = SafeMath.sub(contractBalance, lastContractBalance_);
1163             totalDividendPoints_ = SafeMath.add(totalDividendPoints_, SafeMath.div(SafeMath.mul(additionalDivsFromP3D, magnitude), totalSupply()));
1164             lastContractBalance_ = contractBalance;
1165         }
1166 
1167         // if this is the very first time this is called for a customer, set their starting point
1168         if (divsMap_[_customerAddress].lastDividendPoints == 0) {
1169             divsMap_[_customerAddress].lastDividendPoints = totalDividendPoints_;
1170         }
1171 
1172         // move any owing subdividends into the customers subdividend balance
1173         uint256 owing = subdividendsOwing(_customerAddress);
1174         if (owing > 0) {
1175             divsMap_[_customerAddress].balance = SafeMath.add(divsMap_[_customerAddress].balance, owing);
1176             divsMap_[_customerAddress].lastDividendPoints = totalDividendPoints_;
1177         }
1178     }
1179 
1180     function withdrawInternal(address _customerAddress)
1181         internal
1182     {
1183         // setup data
1184         // dividendsOf() will return only divs, not the ref. bonus
1185         uint256 _dividends = dividendsOf(_customerAddress); // get ref. bonus later in the code
1186 
1187         // update dividend tracker
1188         payoutsTo_[_customerAddress] += (int256)(_dividends * magnitude);
1189 
1190         // add ref. bonus
1191         _dividends += referralBalance_[_customerAddress];
1192         referralBalance_[_customerAddress] = 0;
1193 
1194         // store the divs
1195         dividendsStored_[_customerAddress] = SafeMath.add(dividendsStored_[_customerAddress], _dividends);
1196     }
1197 
1198     function transferInternal(address _customerAddress, address _toAddress, uint256 _amountOfTokens)
1199         internal
1200         returns(bool)
1201     {
1202         // make sure we have the requested tokens
1203         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
1204         updateSubdivsFor(_customerAddress);
1205         updateSubdivsFor(_toAddress);
1206 
1207         // withdraw and store all outstanding dividends first (if there is any)
1208         if ((dividendsOf(_customerAddress) + referralDividendsOf(_customerAddress)) > 0) withdrawInternal(_customerAddress);
1209 
1210         // exchange tokens
1211         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
1212         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
1213 
1214         // update dividend trackers
1215         payoutsTo_[_customerAddress] -= (int256)(profitPerShare_ * _amountOfTokens);
1216         payoutsTo_[_toAddress] += (int256)(profitPerShare_ * _amountOfTokens);
1217 
1218         // fire event
1219         emit Transfer(_customerAddress, _toAddress, _amountOfTokens);
1220 
1221         // ERC20
1222         return true;
1223     }
1224 
1225     function purchaseInternal(address _sender, uint256 _incomingEthereum, address _referredBy)
1226         purchaseFilter(_sender, _incomingEthereum)
1227         internal
1228         returns(uint256)
1229     {
1230 
1231         uint256 purchaseAmount = _incomingEthereum;
1232         uint256 excess = 0;
1233         if (totalInputETH_ <= initialBuyLimitCap_) { // check if the total input ETH is less than the cap
1234             if (purchaseAmount > initialBuyLimitPerTx_) { // if so check if the transaction is over the initial buy limit per transaction
1235                 purchaseAmount = initialBuyLimitPerTx_;
1236                 excess = SafeMath.sub(_incomingEthereum, purchaseAmount);
1237             }
1238             totalInputETH_ = SafeMath.add(totalInputETH_, purchaseAmount);
1239         }
1240 
1241         // return the excess if there is any
1242         if (excess > 0) {
1243              _sender.transfer(excess);
1244         }
1245 
1246         // buy P3D tokens with the entire purchase amount
1247         // even though _P3D.buy() returns uint256, it was never implemented properly inside the P3D contract
1248         // so in order to find out how much P3D was purchased, you need to check the balance first then compare
1249         // the balance after the purchase and the difference will be the amount purchased
1250         uint256 tmpBalanceBefore = _P3D.myTokens();
1251         _P3D.buy.value(purchaseAmount)(_referredBy);
1252         uint256 purchasedP3D = SafeMath.sub(_P3D.myTokens(), tmpBalanceBefore);
1253 
1254         return purchaseTokens(_sender, purchasedP3D, _referredBy);
1255     }
1256 
1257 
1258     function purchaseTokens(address _sender, uint256 _incomingP3D, address _referredBy)
1259         internal
1260         returns(uint256)
1261     {
1262         updateSubdivsFor(_sender);
1263 
1264         // data setup
1265         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingP3D, buyDividendFee_), 100);
1266         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
1267         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
1268         uint256 _taxedP3D = SafeMath.sub(_incomingP3D, _undividedDividends);
1269         uint256 _amountOfTokens = P3DtoTokens_(_taxedP3D);
1270         uint256 _fee = _dividends * magnitude;
1271 
1272         // no point in continuing execution if OP is a poorfag russian hacker
1273         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
1274         // (or hackers)
1275         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
1276         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_));
1277 
1278         // is the user referred by a masternode?
1279         if (
1280             // is this a referred purchase?
1281             _referredBy != address(0x0) &&
1282 
1283             // no cheating!
1284             _referredBy != _sender &&
1285 
1286             // does the referrer have at least X whole tokens?
1287             // i.e is the referrer a godly chad masternode
1288             tokenBalanceLedger_[_referredBy] >= stakingRequirement
1289         ) {
1290             // wealth redistribution
1291             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
1292         } else {
1293             // no ref purchase
1294             // add the referral bonus back to the global dividends cake
1295             _dividends = SafeMath.add(_dividends, _referralBonus);
1296             _fee = _dividends * magnitude;
1297         }
1298 
1299         // we can't give people infinite P3D
1300         if(tokenSupply_ > 0){
1301 
1302             // add tokens to the pool
1303             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
1304 
1305             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
1306             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
1307 
1308             // calculate the amount of tokens the customer receives over their purchase
1309             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
1310 
1311         } else {
1312             // add tokens to the pool
1313             tokenSupply_ = _amountOfTokens;
1314         }
1315 
1316         // update circulating supply & the ledger address for the customer
1317         tokenBalanceLedger_[_sender] = SafeMath.add(tokenBalanceLedger_[_sender], _amountOfTokens);
1318 
1319         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
1320         // really I know you think you do but you don't
1321         payoutsTo_[_sender] += (int256)((profitPerShare_ * _amountOfTokens) - _fee);
1322 
1323         // fire events
1324         emit onTokenPurchase(_sender, _incomingP3D, _amountOfTokens, _referredBy);
1325         emit Transfer(address(0x0), _sender, _amountOfTokens);
1326 
1327         return _amountOfTokens;
1328     }
1329 
1330     /**
1331      * Calculate token price based on an amount of incoming P3D
1332      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
1333      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
1334      */
1335     function P3DtoTokens_(uint256 _P3D_received)
1336         internal
1337         view
1338         returns(uint256)
1339     {
1340         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
1341         uint256 _tokensReceived =
1342          (
1343             (
1344                 // underflow attempts BTFO
1345                 SafeMath.sub(
1346                     (sqrt
1347                         (
1348                             (_tokenPriceInitial**2)
1349                             +
1350                             (2 * (tokenPriceIncremental_ * 1e18)*(_P3D_received * 1e18))
1351                             +
1352                             (((tokenPriceIncremental_)**2) * (tokenSupply_**2))
1353                             +
1354                             (2 * (tokenPriceIncremental_) * _tokenPriceInitial * tokenSupply_)
1355                         )
1356                     ), _tokenPriceInitial
1357                 )
1358             ) / (tokenPriceIncremental_)
1359         ) - (tokenSupply_);
1360 
1361         return _tokensReceived;
1362     }
1363 
1364     /**
1365      * Calculate token sell value.
1366      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
1367      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
1368      */
1369     function tokensToP3D_(uint256 _P4D_tokens)
1370         internal
1371         view
1372         returns(uint256)
1373     {
1374 
1375         uint256 tokens_ = (_P4D_tokens + 1e18);
1376         uint256 _tokenSupply = (tokenSupply_ + 1e18);
1377         uint256 _P3D_received =
1378         (
1379             // underflow attempts BTFO
1380             SafeMath.sub(
1381                 (
1382                     (
1383                         (
1384                             tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
1385                         ) - tokenPriceIncremental_
1386                     ) * (tokens_ - 1e18)
1387                 ), (tokenPriceIncremental_ * ((tokens_**2 - tokens_) / 1e18)) / 2
1388             )
1389         / 1e18);
1390 
1391         return _P3D_received;
1392     }
1393 
1394 
1395     // This is where all your gas goes, sorry
1396     // Not sorry, you probably only paid 1 gwei
1397     function sqrt(uint x) internal pure returns (uint y) {
1398         uint z = (x + 1) / 2;
1399         y = x;
1400         while (z < y) {
1401             y = z;
1402             z = (x / z + z) / 2;
1403         }
1404     }
1405 
1406     /**
1407      * Additional check that the address we are sending tokens to is a contract
1408      * assemble the given address bytecode. If bytecode exists then the _addr is a contract.
1409      */
1410     function isContract(address _addr)
1411         internal
1412         constant
1413         returns(bool)
1414     {
1415         // retrieve the size of the code on target address, this needs assembly
1416         uint length;
1417         assembly { length := extcodesize(_addr) }
1418         return length > 0;
1419     }
1420 
1421     /**
1422      * Utility method to help store the registered names
1423      */
1424     function stringToBytes32(string memory _s)
1425         internal
1426         pure
1427         returns(bytes32 result)
1428     {
1429         bytes memory tmpEmptyStringTest = bytes(_s);
1430         if (tmpEmptyStringTest.length == 0) {
1431             return 0x0;
1432         }
1433         assembly { result := mload(add(_s, 32)) }
1434     }
1435 
1436     /**
1437      * Utility method to help read the registered names
1438      */
1439     function bytes32ToString(bytes32 _b)
1440         internal
1441         pure
1442         returns(string)
1443     {
1444         bytes memory bytesString = new bytes(32);
1445         uint charCount = 0;
1446         for (uint256 i = 0; i < 32; i++) {
1447             byte char = byte(bytes32(uint(_b) * 2 ** (8 * i)));
1448             if (char != 0) {
1449                 bytesString[charCount++] = char;
1450             }
1451         }
1452         bytes memory bytesStringTrimmed = new bytes(charCount);
1453         for (i = 0; i < charCount; i++) {
1454             bytesStringTrimmed[i] = bytesString[i];
1455         }
1456         return string(bytesStringTrimmed);
1457     }
1458 }
1459 
1460 /**
1461  * @title SafeMath
1462  * @dev Math operations with safety checks that throw on error
1463  */
1464 library SafeMath {
1465 
1466     /**
1467     * @dev Multiplies two numbers, throws on overflow.
1468     */
1469     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1470         if (a == 0) {
1471             return 0;
1472         }
1473         uint256 c = a * b;
1474         assert(c / a == b);
1475         return c;
1476     }
1477 
1478     /**
1479     * @dev Integer division of two numbers, truncating the quotient.
1480     */
1481     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1482         // assert(b > 0); // Solidity automatically throws when dividing by 0
1483         uint256 c = a / b;
1484         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1485         return c;
1486     }
1487 
1488     /**
1489     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1490     */
1491     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1492         assert(b <= a);
1493         return a - b;
1494     }
1495 
1496     /**
1497     * @dev Adds two numbers, throws on overflow.
1498     */
1499     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1500         uint256 c = a + b;
1501         assert(c >= a);
1502         return c;
1503     }
1504 }
1505 
1506 
1507 // 
1508 // pragma solidity ^0.4.25;
1509 // 
1510 // interface P4D {
1511 //     function buy(address) external payable returns(uint256);
1512 //     function sell(uint256) external;
1513 //     function transfer(address, uint256) external returns(bool);
1514 //     function myTokens() external view returns(uint256);
1515 //     function myStoredDividends() external view returns(uint256);
1516 //     function mySubdividends() external view returns(uint256);
1517 //     function reinvest(bool) external;
1518 //     function reinvestSubdivs(bool) external;
1519 //     function withdraw(bool) external;
1520 //     function withdrawSubdivs(bool) external;
1521 //     function exit(bool) external; // sell + withdraw + withdrawSubdivs
1522 //     function P3D_address() external view returns(address);
1523 // }
1524 // 
1525 // contract usingP4D {
1526 // 
1527 //     P4D public tokenContract;
1528 // 
1529 //     constructor(address _P4D_address) public {
1530 //         tokenContract = P4D(_P4D_address);
1531 //     }
1532 // 
1533 //     modifier onlyTokenContract {
1534 //         require(msg.sender == address(tokenContract));
1535 //         _;
1536 //     }
1537 // 
1538 //     function tokenCallback(address _from, uint256 _value, bytes _data) external returns (bool);
1539 // }
1540 // 
1541 // contract YourDapp is usingP4D {
1542 // 
1543 //     constructor(address _P4D_address)
1544 //         public
1545 //         usingP4D(_P4D_address)
1546 //     {
1547 //         //...
1548 //     }
1549 // 
1550 //     function tokenCallback(address _from, uint256 _value, bytes _data)
1551 //         external
1552 //         onlyTokenContract
1553 //         returns (bool)
1554 //     {
1555 //         //...
1556 //         return true;
1557 //     }
1558 //
1559 //     function()
1560 //         payable
1561 //         public
1562 //     {
1563 //         if (msg.sender != address(tokenContract)) {
1564 //             //...
1565 //         }
1566 //     }
1567 // }
1568 //
1569 /*===========================================================================================*
1570 *************************************** https://p4d.io ***************************************
1571 *===========================================================================================*/