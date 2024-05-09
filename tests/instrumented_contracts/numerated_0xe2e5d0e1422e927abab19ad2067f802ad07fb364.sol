1 pragma solidity ^0.4.16;
2 
3 
4 /// This is the smart contract for the LOTUS TOKEN NETWORK (LTO)
5 /// It covers the deployment of the three (3) Crowdsale periods
6 /// As well as the distribution of:
7 /// (1) Collected Crowdsale fund
8 /// (2) Reserved tokens for Airdrop
9 /// (3) Reserved Token Supply (55% of total supply)
10 /// (4) Unsold tokens during the Crowdsale Period
11 
12 /// Total Supply is 90,000,000 tokens, for test purposes we will use 90,000 tokens
13 /// We've set a standard rate of:
14 /// 1 ETH = 3,000 tokens or 1 x 10^18 wei for ICO price
15 
16 /// Deployments:
17 /// First successful deployment of ETH-Token exchange on 11/01/2017 4AM GMT+8 done by Dondi
18 /// Second successful run based on approved parameters: 11/01/2017 11PM GMT+8
19 /// Done by Michael, Sam, and Mahlory
20 ///
21 /// Final Ticker Symbol will be -- LTO (Lotus Token, Inc.) -- unless already taken.
22 
23 /// Core Members are:
24 /// Joss Morera (Concept Designer) and Jonathan Bate (Lead Coordinator)
25 
26 /// Initial Shareholders are:
27 /// Luke McWright, Claire Zhang, and Wanjiao Nan
28 
29 /// this is a freelance collaborative work of four (4) developers:
30 /// @author DONDI IMPERIAL, MICHAEL DE GUZMAN, SAMUEL SENDON II
31 
32 /// Initital code researched by Michael on 10/26/2017 3PM GMT + 8
33 /// Major coding works by Dondi
34 /// Minor code mods, test deployments and debugging by Samuel
35 /// Additional Deployment Test by Mahlory
36 /// smart contract development compensation is agreed at
37 /// 2% per developer out of the crowdsale token supply and/or funds raised
38 /// All other values are based on Core Team discussions
39 
40 
41 
42 /// SafeMath helps protect against integer overflow or underflow
43 contract SafeMath {
44      function safeMul(uint a, uint b) internal pure returns (uint) {
45           uint c = a * b;
46           assert(a == 0 || c / a == b);
47           return c;
48      }
49 
50      function safeSub(uint a, uint b) internal pure returns (uint) {
51           assert(b <= a);
52           return a - b;
53      }
54 
55      function safeAdd(uint a, uint b) internal pure returns (uint) {
56           uint c = a + b;
57           assert(c>=a && c>=b);
58           return c;
59      }
60 }
61 
62 // Standard token interface (ERC 20)
63 // https://github.com/ethereum/EIPs/issues/20
64 contract Token is SafeMath {
65      // Functions:
66      /// @return total amount of tokens
67 
68      function totalSupply() public constant returns (uint256 supply);
69 
70      /// @param _owner - The address from which the balance will be retrieved
71      /// @return The balance
72 
73      function balanceOf(address _owner) public constant returns (uint256 balance);
74 
75      /// @notice send _value token to _to from msg.sender
76      /// @param _to - The address of the recipient
77      /// @param _value - The amount of token to be transferred
78 
79      function transfer(address _to, uint256 _value) public returns(bool);
80 
81      /// @notice send _value token to _to from _from on the condition it is approved by _from
82      /// @param _from - The address of the sender
83      /// @param _to - The address of the recipient
84      /// @param _value - The amount of token to be transferred
85      /// @return Whether the transfer was successful or not
86 
87      function transferFrom(address _from, address _to, uint256 _value) public returns(bool);
88 
89      /// @notice msg.sender approves _addr to spend _value tokens
90      /// @param _spender - The address of the account able to transfer the tokens
91      /// @param _value - The amount of wei to be approved for transfer
92      /// @return Whether the approval was successful or not
93 
94      function approve(address _spender, uint256 _value) public returns (bool success);
95 
96      /// @param _owner - The address of the account owning tokens
97      /// @param _spender - The address of the account able to transfer the tokens
98      /// @return Amount of remaining tokens allowed to spent
99 
100      function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
101 
102      // Events:
103      event Transfer(address indexed _from, address indexed _to, uint256 _value);
104      event Approval(address indexed _owner, address indexed _spender, uint256 _value);
105 }
106 
107 contract StdToken is Token {
108      // Fields:
109      mapping(address => uint256) balances;
110      mapping (address => mapping (address => uint256)) allowed;
111      uint public supply = 0;  /// initialized supply is zero
112 
113      // Functions:
114      function transfer(address _to, uint256 _value) public returns(bool) {
115           require(balances[msg.sender] >= _value);
116           require(balances[_to] + _value > balances[_to]);
117 
118           balances[msg.sender] = safeSub(balances[msg.sender],_value);
119           balances[_to] = safeAdd(balances[_to],_value);
120 
121           Transfer(msg.sender, _to, _value);
122           return true;
123      }
124 
125      function transferFrom(address _from, address _to, uint256 _value) public returns(bool){
126           require(balances[_from] >= _value);
127           require(allowed[_from][msg.sender] >= _value);
128           require(balances[_to] + _value > balances[_to]);
129 
130           balances[_to] = safeAdd(balances[_to],_value);
131           balances[_from] = safeSub(balances[_from],_value);
132           allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender],_value);
133 
134           Transfer(_from, _to, _value);
135           return true;
136      }
137 
138      function totalSupply() public constant returns (uint256) {
139           return supply;
140      }
141 
142      function balanceOf(address _owner) public constant returns (uint256) {
143           return balances[_owner];
144      }
145 
146      function approve(address _spender, uint256 _value) public returns (bool) {
147           // To change the approve amount you first have to reduce the addresses`
148           //  allowance to zero by calling approve(_spender, 0) if it is not
149           //  already 0 to mitigate the race condition described here:
150           //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
151           require((_value == 0) || (allowed[msg.sender][_spender] == 0));
152 
153           allowed[msg.sender][_spender] = _value;
154           Approval(msg.sender, _spender, _value);
155 
156           return true;
157      }
158 
159      function allowance(address _owner, address _spender) public constant returns (uint256) {
160           return allowed[_owner][_spender];
161      }
162 }
163 
164 
165 
166 contract LotusToken is StdToken {
167     struct Sale {
168         uint tokenLimit;
169         uint tokenPriceInWei;
170         uint tokensSold;
171         uint minPurchaseInWei;
172         uint maxPurchaseInWei;
173         uint saleLimitPerAddress;
174     }
175 
176     struct Signatory {
177         address account;
178         bool signed;
179     }
180 
181     struct SaleTotals {
182         uint earlyAdoptersSold;
183         uint icoOneSold;
184         uint icoTwoSold;
185     }
186 
187     string public name = "Lotus Token Inc";
188     string public symbol = "LTO";
189     uint public decimals = 18;
190 
191     /// The address that owns this contract.
192     /// Only this address is allowed to execute the functions that move the sale through stages.
193     address private owner;
194 
195     /// Vesting parameters
196     /// Vesting cliff. This must be set to some time in the future to allow for proper vesting.
197     uint public cliff = 0;
198     /// Timespan to schedule allocation of vested shares.
199     uint private vestingSchedule = 30 days; // Testing code has this set to 1 minute for the production
200     /// deploy set this to "30 days". <-----<<<<<<<<<
201 
202     /// wallet declarations (added 11/9/2017 1:30PM GMT + 8) by Sam
203     /// venture capitalists (shareholders)
204     address public vc1Wallet4Pct;
205     address public vc2Wallet4Pct;
206     address public vc3Wallet4Pct;
207 
208     /// co-founders
209     address public cf1Wallet2Pct;
210     address public cf2Wallet2Pct;
211 
212     /// dev-team
213     address public dev1Wallet2Pct;
214     address public dev2Wallet2Pct;
215     address public dev3Wallet2Pct;
216     address public dev4Wallet2Pct;
217 
218     /// branding
219     address public preicobrandingWallet1Pct;
220 
221     /// management multi-sig address
222     address public lotusWallet75Pct;
223 
224     /// airdrop contract address
225     address public airdropWallet5Pct;
226 
227     /// tokensSold amount of tokens sold or transferred
228     uint public tokensSold = 0;
229 
230     /// Allocation of collected eth from sale to respective wallets.
231     mapping(address => uint256) internal ethDistribution;
232 
233     /// Allocation of tokens left over from crowdsale. Note that these are reserved under a vesting scheme described in the whitepaper.
234     mapping(address => uint256) private vestingTokens;
235     mapping(address => uint256) private withdrawnVestedTokens;
236 
237     Sale public EARLYADOPTERS;
238     Sale public ICO_ONE;
239     Sale public ICO_TWO;
240 
241     /// Per sale stage ledger. Used to track and set limits on tokens purchased by an address per sale stage.
242     mapping(address => uint256) private earlyAdoptersAddressPurchased;
243     mapping(address => uint256) private icoOneAddressPurchased;
244     mapping(address => uint256) private icoTwoAddressPurchased;
245 
246     enum SaleStage { Waiting, EarlyAdopters, EarlyAdoptersClosed,  IcoOne, IcoOneClosed, IcoTwo, Closed }
247     SaleStage currentStage = SaleStage.Waiting;
248 
249     /// var declarations to get wallet addresses (11/7/2017 1:30PM GMT + 8) by Sam
250     function LotusToken(address _shareholder1Account,
251                         address _shareholder2Account,
252                         address _shareholder3Account,
253 
254                         /// co-founders
255                         address _core1Account,
256                         address _core2Account,
257 
258                         /// dev-team
259                         address _dev1Account,
260                         address _dev2Account,
261                         address _dev3Account,
262                         address _dev4Account,
263 
264                         /// branding
265                         address _brandingAccount,
266 
267                         /// company wallet
268                         address _lotusTokenAccount,
269 
270                         /// airdrop contract address
271                         address _airdropContractAccount
272 
273     ) public {
274         /// The owner is whoever initialized the contract.
275         owner = msg.sender;
276 
277         // Total supply of tokens is fixed at this value (90000000).
278         // Convert to the appropriate decimal place.
279         supply = 90000000 * 10 ** decimals;
280 
281         /// Crowdsale parameters set by Sam (11/7/2017)
282 
283         /// EARLYADOPTERS tokens are 10% of total supply.
284         /// EARLYADOPTERS value: 1 ETH at 5999 tokens
285         /// 1 token = 1 ETH / 6000 = (10^18)/6000
286         /// EARLYADOPTERS value in wei: 166666666666667 weis
287         /// EARLYADOPTERS set tokens sold to zero at contract creation.
288         /// EARLYADOPTERS min purchase in wei: 2 * 10 ** 17 or 0.2 ETH by Dondi
289         /// EARLYADOPTERS max purchase in wei: 1 * 10 ** 18 or 1 ETH by Dondi (test)
290         /// max purchase per transaction in wei: 5 * 10 ** 18 (5 eth on LIVE)
291         /// EARLYADOPTERS max purchase per address for testing purposes: 5999 (1 ether)
292         /// max purchase per address on live deployment: equivalent to 10 ethers
293         /// Max Ethers to raise: 1500 (live); 1.5 ethers (test)
294         uint earlyAdoptersSupply = (supply * 10 / 100); /// - 2000000000000000000;
295         // EARLYADOPTERS = Sale(supply * 10 / 100, 166666666666667, 0);
296         EARLYADOPTERS = Sale(earlyAdoptersSupply, 166666666666667, 0, 2 * 10 ** 17, 5 * 10 ** 18, 59990000000000000000000);
297 
298         /// PRESALE tokens are 15% of total supply.
299         /// ICO1 (PRESALE) value: 1 ETH = 3750 tokens
300         /// 1 token = 1/3750 = (10^18)/3750
301         /// ICO1 value in wei: 266666666666666 changed from 333333333333334
302         /// ICO_ONE set tokens sold to zero at contract creation.
303         /// ICO_ONE min purchase in wei: 2 * 10 ** 17 or 0.2 ETH by Dondi
304         /// ICO_ONE max purchase in wei: 2 * 10 ** 18 or 2 ETH by Dondi (TEST)
305         /// max purchase per transaction in wei: 10 * 10 ** 18 (10 eth on LIVE)
306         /// ICO_ONE max purchase per address for testing purposes: 7500 (2 ethers)
307         /// max purchase per address on live deployment: equivalent to 18 ethers or
308         /// max ethers to raise: 3600 (live); 3.6 (test)
309         ICO_ONE = Sale(supply * 15 / 100, 266666666666666, 0, 2 * 10 ** 17, 10 * 10 ** 18, 67500000000000000000000);
310 
311         /// ICO2 (MAIN ICO) tokens are 15% of total supply.
312         /// ICO2 value: 1 ETH = 3000 tokens instead of 2000
313         ///  1 token = 1/3000 = (10^18)/3000
314         /// ICO2 value in wei: 333333333333334 changed from 500000000000000
315         /// ICO_TWO set tokens sold to zero at contract creation.
316         /// ICO_TWO min purchase in wei: 2 * 10 ** 17 or 0.2 ETH by Dondi
317         /// ICO_TWO max purchase in wei: 3 * 10 ** 18 or 3 ETH by Dondi (test)
318         /// max purchase per transaction in wei: 20 * 10 ** 18 (20 eth on LIVE)
319         /// ICO_TWO max purchase per address for testing purposes: 10000
320         /// max purchase per address on live deployment: equivalent to 25 ethers (75000)
321         /// max ethers to raise: 4,500 (live); 4.5 (test)
322         ICO_TWO = Sale(supply * 15 / 100, 333333333333334, 0, 2 * 10 ** 17, 20 * 10 ** 18, 75000000000000000000000);
323 
324         // Technically this check should  not be required as the limits are computed above as fractions of the total supply.
325         require(safeAdd(safeAdd(EARLYADOPTERS.tokenLimit, ICO_ONE.tokenLimit), ICO_ONE.tokenLimit)  <= supply);
326 
327         /// For safety zero out the allocation for the 0 address.
328         ethDistribution[0X0] = 0;
329 
330         /// venture capitalist
331         vc1Wallet4Pct = _shareholder1Account;
332         vc2Wallet4Pct = _shareholder2Account;
333         vc3Wallet4Pct = _shareholder3Account;
334 
335         /// co-founders
336         cf1Wallet2Pct = _core1Account;
337         cf2Wallet2Pct = _core2Account;
338 
339         /// dev-team
340         dev1Wallet2Pct = _dev1Account;
341         dev2Wallet2Pct = _dev2Account;
342         dev3Wallet2Pct = _dev3Account;
343         dev4Wallet2Pct = _dev4Account;
344 
345         /// branding
346         preicobrandingWallet1Pct = _brandingAccount;
347 
348         lotusWallet75Pct = _lotusTokenAccount; /// this will go to the company controlled multi-sig wallet
349         /// this replaced adminWallet, posticosdWallet, mktgWallet, legalWallet, cntgncyWallet
350         /// it will contain both the 75% of ETHs collected via crowdsale
351         /// it will also contain the unsold tokens via the crowdsale periods
352         /// it will also contain the 55% tokens from total supply
353 
354         airdropWallet5Pct = _airdropContractAccount; /// airdrop wallet contract
355     }
356 
357     /// modifier coded by Dondi
358     modifier mustBeSelling {
359         require(currentStage == SaleStage.EarlyAdopters || currentStage == SaleStage.IcoOne || currentStage == SaleStage.IcoTwo);
360         _;
361     }
362 
363     modifier ownerOnly {
364         require(msg.sender == owner);
365         _;
366     }
367 
368     // function coded by Dondi
369     function () public payable mustBeSelling {
370         // Must have sent some ether.
371         require(msg.value > 0);
372 
373         // Must be purchasing at least the min allowed and not more than the max allowed ETH.
374         require(msg.value >= currentMinPurchase() && msg.value <= currentMaxPurchase());
375 
376 
377         // The price at the current sale stage.
378         uint priceNow = currentSalePriceInWei();
379         // The total amount of tokens for sale at this stage
380         uint currentLimit = currentSaleLimit();
381         // The amount of tokens that have been sold at this sale stage.
382         uint currentSold = currentSaleSold();
383         // The total amount of tokens that a single address can purchase at this sale stage.
384         uint currentLimitPerAddress = currentSaleLimitPerAddress();
385         // The total amount of tokens already purchased by the current buyer.
386         uint currentStageTokensBought = currentStageTokensBoughtByAddress();
387 
388         // Convert msg.value into wei (line added 11/1/2017 11PM)
389         uint priceInWei = msg.value;
390 
391         // change numerator from msg.value into priceInWei 11/01/2017 11PM
392         uint tokensAtPrice = (priceInWei / priceNow) * 10 ** decimals;     // total token equivalent of contributed ETH
393 
394         // make sure the payment does not exceed the supply (11/5/2017 10AM)
395         //  backer with exact ETH sent equivalent to supply left will get accepted
396         require(tokensAtPrice + currentSold <= currentLimit);
397 
398         // Buyer can't exceed the per address limit
399         require(tokensAtPrice + currentStageTokensBought <= currentLimitPerAddress);
400 
401         // remove conditional statements and proceed with credit of tokens to backer (11/5/2017 10AM)
402         balances[msg.sender] = safeAdd(balances[msg.sender], tokensAtPrice);  /// send tokens
403         tokensSold = safeAdd(tokensSold, tokensAtPrice); /// Update total token sold
404 
405         // Update tokens sold for current sale.
406         _addTokensSoldToCurrentSale(tokensAtPrice);
407 
408         // Distribute ether as it arrives.
409         distributeCollectedEther();
410 
411         // Show transaction details on blockchain explorer
412         Transfer(this, msg.sender, tokensAtPrice);
413     }
414 
415     // send ether to the fund collection wallets
416     // override to create custom fund forwarding mechanisms
417     // taken from OpenZeppelin, added 11/7/2017 10AM
418     function distributeCollectedEther() internal {
419 
420     /**
421     /// November 9, 2017
422     /// Distribution details: TotalSupply = 9M tokens
423     /// each core member receives .9% from TotalSupply (9M * 9 / 1000)
424     /// except for branding, which gets .45% (9M * 45 / 10000)
425     /// seed fund venture capitalist receives 1.8% each multiplied by 3 persons (9M * 18 / 1000)
426     /// In Crowdsale values (which is 45% of the TotalSupply), this divides the funds into:
427     /// 25% for all core members and shareholders (10 individuals)
428     /// and 75% to Lotus Post ICO Management
429     **/
430 
431     /// Allocate eth to the appropriate accounts.
432     /// To transfer the share of the collected ETH, accounts need to call the 'withdraw allocation' function from the addresses passed to this contract during deployment.
433     /// Note that due to the implementation below it is not possible to use the same address for multiple recipients. If the same address is used twice or more, only the last allocation will apply.
434 
435     /// TODO: Update the Crowdsale Fund division (11/9/2017)
436     /// Lines 361 to 392 updated on 11/9/2017 by Sam
437     /// shareholders each get 4% of the Crowdsale Fund
438         ethDistribution[vc1Wallet4Pct] = safeAdd(ethDistribution[vc1Wallet4Pct], msg.value * 4 / 100);
439         ethDistribution[vc2Wallet4Pct] = safeAdd(ethDistribution[vc2Wallet4Pct], msg.value * 4 / 100);
440         ethDistribution[vc3Wallet4Pct] = safeAdd(ethDistribution[vc3Wallet4Pct], msg.value * 4 / 100);
441 
442     /// co-founders each get 2% of the Crowdsale Fund
443         ethDistribution[cf1Wallet2Pct] = safeAdd(ethDistribution[cf1Wallet2Pct], msg.value * 2 / 100);
444         ethDistribution[cf2Wallet2Pct] = safeAdd(ethDistribution[cf2Wallet2Pct], msg.value * 2 / 100);
445 
446     /// dev-team members each get 2% of the Crowdsale Fund
447         ethDistribution[dev1Wallet2Pct] = safeAdd(ethDistribution[dev1Wallet2Pct], msg.value * 2 / 100);
448         ethDistribution[dev3Wallet2Pct] = safeAdd(ethDistribution[dev3Wallet2Pct], msg.value * 2 / 100);
449         ethDistribution[dev2Wallet2Pct] = safeAdd(ethDistribution[dev2Wallet2Pct], msg.value * 2 / 100);
450         ethDistribution[dev4Wallet2Pct] = safeAdd(ethDistribution[dev4Wallet2Pct], msg.value * 2 / 100);
451 
452     /// branding developer gets 1% of the Crowdsale Fund
453         ethDistribution[preicobrandingWallet1Pct] = safeAdd(ethDistribution[preicobrandingWallet1Pct], msg.value * 1 / 100);
454 
455     /// management multi-sig address gets 75% of Crowdsale Fund
456         ethDistribution[lotusWallet75Pct] = safeAdd(ethDistribution[lotusWallet75Pct], msg.value * 75 / 100);
457     }
458 
459     /// Distribute the tokens left after the crowdsale to the pre-agreed accounts
460     function distributeRemainingTokens() internal ownerOnly {
461         /// @dev to sam: Remaining tokens are distributed here. (11/8/2017)
462         uint crowdsaleSupply = supply * 40 / 100;
463         uint unsoldTokens = crowdsaleSupply - tokensSold;
464 
465         // lines 400 to 450 updated on 11/9/2017 by Sam
466         // Lotus Wallet gets 75% of the unsoldTokens
467         balances[lotusWallet75Pct] = safeAdd(balances[lotusWallet75Pct], unsoldTokens * 75 / 100);
468         Transfer(this, lotusWallet75Pct, unsoldTokens * 75 / 100);
469 
470         // Shareholders get 4% each (x3) of the unsoldTokens, Core Team (CT) gets 2% each (x6) and Branding gets 1%
471         // Total: 25% of unsoldTokens
472         // Only 25% of the actual allocations are immediately transferred to the recipients, the rest are left over for vesting.
473         // The remaining tokens (75%) are reserved for vesting and are transferred to the Lotus Token Inc wallet contract address.
474         // Shareholder 1: Luke McWright
475         balances[vc1Wallet4Pct] = safeAdd(balances[vc1Wallet4Pct],  unsoldTokens * 4 / 100 * 25 / 100);
476         Transfer(this, vc1Wallet4Pct, unsoldTokens * 4 / 100 * 25 / 100);
477         // Vesting
478         vestingTokens[vc1Wallet4Pct] = safeAdd(vestingTokens[vc1Wallet4Pct], unsoldTokens * 4 / 100 * 75 / 100);
479 
480         // Shareholder 2: Claire Zhang
481         balances[vc2Wallet4Pct] = safeAdd(balances[vc2Wallet4Pct], unsoldTokens * 4 / 100 * 25 / 100);
482         Transfer(this, vc2Wallet4Pct, unsoldTokens * 4 / 100 * 25 / 100);
483         // Vesting
484         vestingTokens[vc2Wallet4Pct] = safeAdd(vestingTokens[vc2Wallet4Pct], unsoldTokens * 4 / 100 * 75 / 100);
485 
486         // Shareholder 3: Wan Jiao Nan
487         balances[vc3Wallet4Pct] = safeAdd(balances[vc3Wallet4Pct], unsoldTokens * 4 / 100 * 25 / 100);
488         Transfer(this, vc3Wallet4Pct, unsoldTokens * 4 / 100 * 25 / 100);
489         // Vesting
490         vestingTokens[vc3Wallet4Pct] = safeAdd(vestingTokens[vc3Wallet4Pct], unsoldTokens * 4 / 100 * 75 / 100);
491 
492         // CT Co-Founder 1: Joss Morera
493         balances[cf1Wallet2Pct] = safeAdd(balances[cf1Wallet2Pct], unsoldTokens * 2 / 100 * 25 / 100);
494         Transfer(this, cf1Wallet2Pct, unsoldTokens * 2 / 100 * 25 / 100);
495         // Vesting
496         vestingTokens[cf1Wallet2Pct] = safeAdd(vestingTokens[cf1Wallet2Pct], unsoldTokens * 2 / 100 * 75 / 100);
497 
498         // CT Co-Founder 2: Jonathan Bate
499         balances[cf2Wallet2Pct] = safeAdd(balances[cf2Wallet2Pct], unsoldTokens * 2 / 100 * 25 / 100);
500         Transfer(this, cf2Wallet2Pct, unsoldTokens * 2 / 100 * 25 / 100);
501         // Vesting
502         vestingTokens[cf2Wallet2Pct] = safeAdd(vestingTokens[cf2Wallet2Pct], unsoldTokens * 2 / 100 * 75 / 100);
503 
504         // CT Dev-Team Leader and Social Media Manager: Michael De Guzman
505         balances[dev1Wallet2Pct] = safeAdd(balances[dev1Wallet2Pct], unsoldTokens * 2 / 100 * 25 / 100);
506         Transfer(this, dev1Wallet2Pct, unsoldTokens * 2 / 100 * 25 / 100);
507         // Vesting
508         vestingTokens[dev1Wallet2Pct] = safeAdd(vestingTokens[dev1Wallet2Pct], unsoldTokens * 2 / 100 * 75 / 100);
509 
510         // CT Senior Solidity Developer:
511         balances[dev2Wallet2Pct] = safeAdd(balances[dev2Wallet2Pct], unsoldTokens * 2 / 100 * 25 / 100);
512         Transfer(this, dev2Wallet2Pct, unsoldTokens * 2 / 100 * 25 / 100);
513         // Vesting
514         vestingTokens[dev2Wallet2Pct] = safeAdd(vestingTokens[dev2Wallet2Pct], unsoldTokens * 2 / 100 * 75 / 100);
515 
516         // CT Server Manager and Junior Developer: Mahlory Ambrosio
517         balances[dev3Wallet2Pct] = safeAdd(balances[dev3Wallet2Pct], unsoldTokens * 2 / 100 * 25 / 100);
518         Transfer(this, dev3Wallet2Pct, unsoldTokens * 2 / 100 * 25 / 100);
519         // Vesting
520         vestingTokens[dev3Wallet2Pct] = safeAdd(vestingTokens[dev3Wallet2Pct], unsoldTokens * 2 / 100 * 75 / 100);
521 
522         // CT Branding - Logo, Whitepaper Design, Website Design: Tamlyn
523         balances[preicobrandingWallet1Pct] = safeAdd(balances[preicobrandingWallet1Pct], unsoldTokens * 1 / 100 * 25 / 100);
524         Transfer(this, preicobrandingWallet1Pct, unsoldTokens * 1 / 100  * 25 / 100);
525         // Vesting
526         vestingTokens[preicobrandingWallet1Pct] = safeAdd(vestingTokens[preicobrandingWallet1Pct], unsoldTokens * 1 / 100 * 75 / 100);
527 
528         // CT Jr Solidity Developer: Samuel T Sendon II
529         balances[dev4Wallet2Pct] = safeAdd(balances[dev4Wallet2Pct], unsoldTokens * 2 / 100 * 25 / 100);
530         Transfer(this, dev4Wallet2Pct, unsoldTokens * 2 / 100 * 25 / 100);
531         // Vesting
532         vestingTokens[dev4Wallet2Pct] = safeAdd(vestingTokens[dev4Wallet2Pct], unsoldTokens * 2 / 100 * 75 / 100);
533 
534         // TODO: At this point all tokens have been allocated.
535         //   1) Should the tokensSold value be updated as well?
536         //   2) Verify that there are no edge cases that will result in inadverdently mining additional tokens.
537         //      One possiblity is to keep a 'tokensIssued' counter and validate against that when issuing (not transfering) tokens.
538 
539         /// transfer the rest of the token supply minus the crowdsale supply to the Lotus Wallet
540         uint reservedSupply = supply * 55 / 100;
541 
542         /// This should be a multi-sig wallet so that each time fund is withdrawn from the smart contract,
543         /// it needs to be executed from within the multi-sig wallet, and each time funds are withdrawn,
544         /// it will need signatures from all signatories
545         balances[lotusWallet75Pct] = safeAdd(balances[lotusWallet75Pct], reservedSupply);
546         Transfer(this, lotusWallet75Pct, reservedSupply);
547 
548         /// transfer the tokens for Airdrop on a wallet contract
549         uint airdropSupply = supply * 5 / 100;
550         /// UNCERTAIN whether this should be multi-sig or not
551         balances[airdropWallet5Pct] = safeAdd(balances[airdropWallet5Pct], airdropSupply);
552         Transfer(this, airdropWallet5Pct, airdropSupply);
553     }
554 
555     function startEarlyAdopters() public ownerOnly {
556         require(currentStage == SaleStage.Waiting);
557         currentStage = SaleStage.EarlyAdopters;
558     }
559 
560     function closeEarlyAdopters() public ownerOnly {
561         require(currentStage == SaleStage.EarlyAdopters);
562         currentStage = SaleStage.EarlyAdoptersClosed;
563     }
564 
565     function startIcoOne() public ownerOnly {
566         require(currentStage == SaleStage.EarlyAdopters || currentStage == SaleStage.EarlyAdoptersClosed);
567         currentStage = SaleStage.IcoOne;
568     }
569 
570     function closeIcoOne() public ownerOnly {
571         require(currentStage == SaleStage.IcoOne);
572         currentStage = SaleStage.IcoOneClosed;
573     }
574 
575     function startIcoTwo() public ownerOnly {
576         require(currentStage == SaleStage.IcoOne || currentStage == SaleStage.IcoOneClosed);
577         currentStage = SaleStage.IcoTwo;
578 
579         /// optional auto exec process condition to endSale
580         /// only if total tokens sold is reached (11/07/2017 3PM GMT + 8)
581         /// if total tokens sold is = to sum of earlyadopters, icoone, icotwo supplies
582 
583     }
584 
585     function closeSale() public ownerOnly {
586         require(currentStage == SaleStage.IcoTwo);
587         currentStage = SaleStage.Closed;
588         distributeRemainingTokens(); // 11/22/2017 by Dondi
589         /// Start countdown to cliff
590         cliff = now + 180 days; // Testing code has this set to "now + 5 minutes"
591         /// in the live deploy set this to "now + 180 days".
592     }
593 
594     modifier doneSelling {
595         require(currentStage == SaleStage.Closed);
596         _;
597     }
598 
599     /// @dev Let the caller withdraw all ether allocated to it during the sale period.
600     function withdrawAllocation() public {
601         // Lifted from: http://solidity.readthedocs.io/en/develop/solidity-by-example.html
602         // It is a good guideline to structure functions that interact
603         // with other contracts (i.e. they call functions or send Ether)
604         // into three phases:
605         // 1. checking conditions
606         // 2. performing actions (potentially changing conditions)
607         // 3. interacting with other contracts
608 
609         // Checking Conditions
610         require(ethDistribution[msg.sender] > 0);
611         // Must be at least after a sale stage but not during a sale.
612         require(currentStage == SaleStage.EarlyAdoptersClosed || currentStage == SaleStage.IcoOneClosed || currentStage == SaleStage.Closed);
613         // 75% allocation can only be withdrawn when the crowd sale has completed
614         require(msg.sender != lotusWallet75Pct || currentStage == SaleStage.Closed);
615 
616 
617         // Performing actions
618         // copy the current value allocated as we will change the saved value later.
619         uint toTransfer = ethDistribution[msg.sender];
620         // Note that in order to avoid re-entrancy the allocation is zeroed BEFORE the actual transfer.
621         ethDistribution[msg.sender] = 0;
622 
623         // (Potentially) interacting with other contracts.
624         msg.sender.transfer(toTransfer);
625     }
626 
627     function currentSalePriceInWei() constant public mustBeSelling returns(uint) {
628         if(currentStage == SaleStage.EarlyAdopters) {
629             return EARLYADOPTERS.tokenPriceInWei;
630         } else if (currentStage == SaleStage.IcoOne) {
631             return ICO_ONE.tokenPriceInWei;
632         } else if (currentStage == SaleStage.IcoTwo) {
633             return ICO_TWO.tokenPriceInWei;
634         }
635     }
636 
637 
638     function currentSaleLimit() constant public mustBeSelling returns(uint) {
639         if(currentStage == SaleStage.EarlyAdopters) {
640             return EARLYADOPTERS.tokenLimit;
641         } else if (currentStage == SaleStage.IcoOne) {
642             return ICO_ONE.tokenLimit;
643         } else if (currentStage == SaleStage.IcoTwo) {
644             return ICO_TWO.tokenLimit;
645         }
646     }
647 
648     function currentSaleSold() constant public mustBeSelling returns(uint) {
649         if(currentStage == SaleStage.EarlyAdopters) {
650             return EARLYADOPTERS.tokensSold;
651         } else if (currentStage == SaleStage.IcoOne) {
652             return ICO_ONE.tokensSold;
653         } else if (currentStage == SaleStage.IcoTwo) {
654             return ICO_TWO.tokensSold;
655         }
656     }
657 
658     function currentMinPurchase() constant public mustBeSelling returns(uint) {
659         if(currentStage == SaleStage.EarlyAdopters) {
660             return EARLYADOPTERS.minPurchaseInWei;
661         } else if (currentStage == SaleStage.IcoOne) {
662             return ICO_ONE.minPurchaseInWei;
663         } else if (currentStage == SaleStage.IcoTwo) {
664             return ICO_TWO.minPurchaseInWei;
665         }
666     }
667 
668     function currentMaxPurchase() constant public mustBeSelling returns(uint) {
669         if(currentStage == SaleStage.EarlyAdopters) {
670             return EARLYADOPTERS.maxPurchaseInWei;
671         } else if (currentStage == SaleStage.IcoOne) {
672             return ICO_ONE.maxPurchaseInWei;
673         } else if (currentStage == SaleStage.IcoTwo) {
674             return ICO_TWO.maxPurchaseInWei;
675         }
676     }
677 
678     function currentSaleLimitPerAddress() constant public mustBeSelling returns(uint) {
679         if(currentStage == SaleStage.EarlyAdopters) {
680             return EARLYADOPTERS.saleLimitPerAddress;
681         } else if (currentStage == SaleStage.IcoOne) {
682             return ICO_ONE.saleLimitPerAddress;
683         } else if (currentStage == SaleStage.IcoTwo) {
684             return ICO_TWO.saleLimitPerAddress;
685         }
686     }
687 
688     function currentStageTokensBoughtByAddress() constant public mustBeSelling returns(uint) {
689         if(currentStage == SaleStage.EarlyAdopters) {
690             return earlyAdoptersAddressPurchased[msg.sender];
691         } else if (currentStage == SaleStage.IcoOne) {
692             return icoOneAddressPurchased[msg.sender];
693         } else if (currentStage == SaleStage.IcoTwo) {
694             return icoTwoAddressPurchased[msg.sender];
695         }
696     }
697 
698     function _addTokensSoldToCurrentSale(uint _additionalTokensSold) internal mustBeSelling {
699         if(currentStage == SaleStage.EarlyAdopters) {
700             EARLYADOPTERS.tokensSold = safeAdd(EARLYADOPTERS.tokensSold, _additionalTokensSold);
701             earlyAdoptersAddressPurchased[msg.sender] = safeAdd(earlyAdoptersAddressPurchased[msg.sender], _additionalTokensSold);
702         } else if (currentStage == SaleStage.IcoOne) {
703             ICO_ONE.tokensSold = safeAdd(ICO_ONE.tokensSold, _additionalTokensSold);
704             icoOneAddressPurchased[msg.sender] = safeAdd(icoOneAddressPurchased[msg.sender], _additionalTokensSold);
705         } else if (currentStage == SaleStage.IcoTwo) {
706             ICO_TWO.tokensSold = safeAdd(ICO_TWO.tokensSold, _additionalTokensSold);
707             icoTwoAddressPurchased[msg.sender] = safeAdd(icoTwoAddressPurchased[msg.sender], _additionalTokensSold);
708         }
709     }
710 
711     function withdrawVestedTokens() public doneSelling {
712         // 1. checking conditions
713         // Cliff must have been previously set (This is set in closeSale).
714         require(cliff > 0);
715         // Must be past the cliff. (and equal or greater than the initial value of cliff upon CloseSale)
716         require(now >= cliff);
717         // Must have some (remaining) vested tokens for withdrawal.
718         require(withdrawnVestedTokens[msg.sender] < vestingTokens[msg.sender]);
719 
720         // 2. performing actions (potentially changing conditions)
721         // How many scheduled allocations have passed.
722         uint schedulesPassed = ((now - cliff) / vestingSchedule) + 1;
723         // Number of tokens available to the user at this point (may include previously already withdrawn tokens).
724         uint vestedTokens = (vestingTokens[msg.sender] / 15) * schedulesPassed;
725         // Actual tokens available for withdrawal at this point.
726         uint availableToWithdraw = vestedTokens - withdrawnVestedTokens[msg.sender];
727         // For contract safety mark tokens as allocated before allocating.
728         withdrawnVestedTokens[msg.sender] = safeAdd(withdrawnVestedTokens[msg.sender], availableToWithdraw);
729         // Allocate tokens
730         balances[msg.sender] = safeAdd(balances[msg.sender], availableToWithdraw);
731         Transfer(this, msg.sender, availableToWithdraw);
732     }
733 }