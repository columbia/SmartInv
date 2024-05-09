1 pragma solidity ^0.4.16;
2 
3 // SafeMath Taken From FirstBlood
4 contract SafeMath {
5     function safeMul(uint a, uint b) internal returns (uint) {
6         uint c = a * b;
7         assert(a == 0 || c / a == b);
8         return c;
9     }
10 
11     function safeDiv(uint a, uint b) internal returns (uint) {
12         assert(b > 0);
13         uint c = a / b;
14         assert(a == b * c + a % b);
15         return c;
16     }
17 
18     function safeSub(uint a, uint b) internal returns (uint) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function safeAdd(uint a, uint b) internal returns (uint) {
24         uint c = a + b;
25         assert(c>=a && c>=b);
26         return c;
27     }
28 }
29 
30 // Ownership
31 contract Owned {
32 
33     address public owner;
34     address public newOwner;
35     modifier onlyOwner { assert(msg.sender == owner); _; }
36 
37     event OwnerUpdate(address _prevOwner, address _newOwner);
38 
39     function Owned() {
40         owner = msg.sender;
41     }
42 
43     function transferOwnership(address _newOwner) public onlyOwner {
44         require(_newOwner != owner);
45         newOwner = _newOwner;
46     }
47 
48     function acceptOwnership() public {
49         require(msg.sender == newOwner);
50         OwnerUpdate(owner, newOwner);
51         owner = newOwner;
52         newOwner = 0x0;
53     }
54 }
55 
56 // ERC20 Interface
57 contract ERC20 {
58     function totalSupply() constant returns (uint _totalSupply);
59     function balanceOf(address _owner) constant returns (uint balance);
60     function transfer(address _to, uint _value) returns (bool success);
61     function transferFrom(address _from, address _to, uint _value) returns (bool success);
62     function approve(address _spender, uint _value) returns (bool success);
63     function allowance(address _owner, address _spender) constant returns (uint remaining);
64     event Transfer(address indexed _from, address indexed _to, uint _value);
65     event Approval(address indexed _owner, address indexed _spender, uint _value);
66 }
67 
68 // ERC20Token
69 contract ERC20Token is ERC20, SafeMath {
70 
71     mapping(address => uint256) balances;
72     mapping (address => mapping (address => uint256)) allowed;
73     uint256 public totalTokens; 
74 
75     function transfer(address _to, uint256 _value) returns (bool success) {
76         if (balances[msg.sender] >= _value && _value > 0) {
77             balances[msg.sender] = safeSub(balances[msg.sender], _value);
78             balances[_to] = safeAdd(balances[_to], _value);
79             Transfer(msg.sender, _to, _value);
80             return true;
81         } else {
82             return false;
83         }
84     }
85 
86     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
87         var _allowance = allowed[_from][msg.sender];
88         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
89             balances[_to] = safeAdd(balances[_to], _value);
90             balances[_from] = safeSub(balances[_from], _value);
91             allowed[_from][msg.sender] = safeSub(_allowance, _value);
92             Transfer(_from, _to, _value);
93             return true;
94         } else {
95             return false;
96         }
97     }
98 
99     function totalSupply() constant returns (uint256) {
100         return totalTokens;
101     }
102 
103     function balanceOf(address _owner) constant returns (uint256 balance) {
104         return balances[_owner];
105     }
106 
107     function approve(address _spender, uint256 _value) returns (bool success) {
108         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
109         allowed[msg.sender][_spender] = _value;
110         Approval(msg.sender, _spender, _value);
111         return true;
112     }
113 
114     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
115         return allowed[_owner][_spender];
116     }
117 }
118 
119 contract Wolk is ERC20Token, Owned {
120 
121     // TOKEN INFO
122     string  public constant name = "Wolk Protocol Token";
123     string  public constant symbol = "WOLK";
124     uint256 public constant decimals = 18;
125 
126     // RESERVE
127     uint256 public reserveBalance = 0; 
128     uint8  public constant percentageETHReserve = 15;
129 
130     // CONTRACT OWNER
131     address public multisigWallet;
132 
133 
134     // WOLK SETTLERS
135     mapping (address => bool) settlers;
136     modifier onlySettler { assert(settlers[msg.sender] == true); _; }
137 
138     // TOKEN GENERATION CONTROL
139     address public wolkSale;
140     bool    public allSaleCompleted = false;
141     bool    public openSaleCompleted = false;
142     modifier isTransferable { require(allSaleCompleted); _; }
143     modifier onlyWolk { assert(msg.sender == wolkSale); _; }
144 
145     // TOKEN GENERATION EVENTLOG
146     event WolkCreated(address indexed _to, uint256 _tokenCreated);
147     event WolkDestroyed(address indexed _from, uint256 _tokenDestroyed);
148     event LogRefund(address indexed _to, uint256 _value);
149 }
150 
151 contract WolkTGE is Wolk {
152 
153     // TOKEN GENERATION EVENT
154     mapping (address => uint256) contribution;
155     mapping (address => uint256) presaleLimit;
156     mapping (address => bool) presaleContributor;
157     uint256 public constant tokenGenerationMin = 50 * 10**6 * 10**decimals;
158     uint256 public constant tokenGenerationMax = 150 * 10**6 * 10**decimals;
159     uint256 public presale_start_block; 
160     uint256 public start_block;
161     uint256 public end_block;
162 
163     // @param _presaleStartBlock
164     // @param _startBlock
165     // @param _endBlock
166     // @param _wolkWallet
167     // @param _wolkSale
168     // @return success
169     // @dev Wolk Genesis Event [only accessible by Contract Owner]
170     function wolkGenesis(uint256 _presaleStartBlock, uint256 _startBlock, uint256 _endBlock, address _wolkWallet, address _wolkSale) onlyOwner returns (bool success){
171         require((totalTokens < 1) && (block.number <= _startBlock) && (_endBlock > _startBlock) && (_startBlock > _presaleStartBlock));
172         presale_start_block = _presaleStartBlock;
173         start_block = _startBlock;
174         end_block = _endBlock;
175         multisigWallet = _wolkWallet;
176         wolkSale = _wolkSale;
177         settlers[msg.sender] = true;
178         return true;
179     }
180 
181     // @param _presaleParticipants
182     // @return success
183     // @dev Adds addresses that are allowed to take part in presale [only accessible by current Contract Owner]
184     function addParticipant(address[] _presaleParticipants, uint256[] _contributionLimits) onlyOwner returns (bool success) {
185         require(_presaleParticipants.length == _contributionLimits.length);         
186         for (uint cnt = 0; cnt < _presaleParticipants.length; cnt++){           
187             presaleContributor[_presaleParticipants[cnt]] = true;
188             presaleLimit[_presaleParticipants[cnt]] =  safeMul(_contributionLimits[cnt], 10**decimals);       
189         }
190         return true;
191     } 
192 
193     // @param _presaleParticipants
194     // @return success
195     // @dev Revoke designated presale contributors [only accessible by current Contract Owner]
196     function removeParticipant(address[] _presaleParticipants) onlyOwner returns (bool success){         
197         for (uint cnt = 0; cnt < _presaleParticipants.length; cnt++){           
198             presaleContributor[_presaleParticipants[cnt]] = false;
199             presaleLimit[_presaleParticipants[cnt]] = 0;      
200         }
201         return true;
202     }
203 
204     // @param _participant
205     // @return remainingAllocation
206     // @dev return PresaleLimit allocated to given address
207     function participantBalance(address _participant) constant returns (uint256 remainingAllocation) {
208         return presaleLimit[_participant];
209     }
210     
211 
212     // @param _participant
213     // @dev use tokenGenerationEvent to handle Pre-sale and Open-sale
214     function tokenGenerationEvent(address _participant) payable external {
215         require( presaleContributor[_participant] && !openSaleCompleted && !allSaleCompleted && (block.number <= end_block) && msg.value > 0);
216 
217         /* Early Participation Discount (rounded to the nearest integer)
218         ---------------------------------
219         | Token Issued | Rate | Discount|
220         ---------------------------------
221         |   0  -  50MM | 1177 |  15.0%  |
222         | 50MM -  60MM | 1143 |  12.5%  |
223         | 60MM -  70MM | 1111 |  10.0%  |
224         | 70MM -  80MM | 1081 |   7.5%  |
225         | 80MM -  90MM | 1053 |   5.0%  |         
226         | 90MM - 100MM | 1026 |   2.5%  |
227         |    100MM+    | 1000 |   0.0%  |
228         ---------------------------------
229         */
230 
231         uint256 rate = 1000;  // Default Rate
232 
233         if ( totalTokens < (50 * 10**6 * 10**decimals) ) {  
234             rate = 1177;
235         } else if ( totalTokens < (60 * 10**6 * 10**decimals) ) {  
236             rate = 1143;
237         } else if ( totalTokens < (70 * 10**6 * 10**decimals) ) {  
238             rate = 1111;
239         } else if ( totalTokens < (80 * 10**6 * 10**decimals) ) {  
240             rate = 1081;
241         } else if ( totalTokens < (90 * 10**6 * 10**decimals) ) {  
242             rate = 1053;
243         } else if ( totalTokens < (100 * 10**6 * 10**decimals) ) {  
244             rate = 1026;
245         }else{
246             rate = 1000;
247         }
248 
249         if ((block.number < start_block) && (block.number >= presale_start_block))  { 
250             require(presaleLimit[_participant] >= msg.value);
251             presaleLimit[_participant] = safeSub(presaleLimit[_participant], msg.value);
252         } else {
253             require(block.number >= start_block) ;
254         }
255 
256         uint256 tokens = safeMul(msg.value, rate);
257         uint256 checkedSupply = safeAdd(totalTokens, tokens);
258         require(checkedSupply <= tokenGenerationMax);
259 
260         totalTokens = checkedSupply;
261         Transfer(address(this), _participant, tokens);
262         balances[_participant] = safeAdd(balances[_participant], tokens);
263         contribution[_participant] = safeAdd(contribution[_participant], msg.value);
264         WolkCreated(_participant, tokens); // logs token creation
265     }
266 
267 
268     // @dev If Token Generation Minimum is Not Met, TGE Participants can call this func and request for refund
269     function refund() external {
270         require((contribution[msg.sender] > 0) && (!allSaleCompleted) && (totalTokens < tokenGenerationMin) && (block.number > end_block));
271         uint256 tokenBalance = balances[msg.sender];
272         uint256 refundBalance = contribution[msg.sender];
273         balances[msg.sender] = 0;
274         contribution[msg.sender] = 0;
275         totalTokens = safeSub(totalTokens, tokenBalance);
276         WolkDestroyed(msg.sender, tokenBalance);
277         LogRefund(msg.sender, refundBalance);
278         msg.sender.transfer(refundBalance); 
279     }
280 
281     // @dev Finalizing the Open-Sale for Token Generation Event. 15% of Eth will be kept in contract to provide liquidity
282     function finalizeOpenSale() onlyOwner {
283         require((!openSaleCompleted) && (totalTokens >= tokenGenerationMin));
284         openSaleCompleted = true;
285         end_block = block.number;
286         reserveBalance = safeDiv(safeMul(totalTokens, percentageETHReserve), 100000);
287         var withdrawalBalance = safeSub(this.balance, reserveBalance);
288         msg.sender.transfer(withdrawalBalance);
289     }
290 
291     // @dev Finalizing the Private-Sale. Entire Eth will be kept in contract to provide liquidity. This func will conclude the entire sale.
292     function finalize() onlyWolk payable external {
293         require((openSaleCompleted) && (!allSaleCompleted));                                                                                                    
294         uint256 privateSaleTokens =  safeDiv(safeMul(msg.value, 100000), percentageETHReserve);
295         uint256 checkedSupply = safeAdd(totalTokens, privateSaleTokens);                                                                                                
296         totalTokens = checkedSupply;                                                                                                                         
297         reserveBalance = safeAdd(reserveBalance, msg.value);                                                                                                 
298         Transfer(address(this), wolkSale, privateSaleTokens);                                                                                                              
299         balances[wolkSale] = safeAdd(balances[wolkSale], privateSaleTokens);                                                                                                  
300         WolkCreated(wolkSale, privateSaleTokens); // logs token creation for Presale events                                                                                                 
301         allSaleCompleted = true;                                                                                                                                
302     }
303 }
304 
305 contract IBurnFormula {
306     function calculateWolkToBurn(uint256 _value) public constant returns (uint256);
307 }
308 
309 contract IFeeFormula {
310     function calculateProviderFee(uint256 _value) public constant returns (uint256);
311 }
312 
313 contract WolkProtocol is Wolk {
314 
315     // WOLK NETWORK PROTOCOL
316     address public burnFormula;
317     bool    public settlementIsRunning = true;
318     uint256 public burnBasisPoints = 500;  // Burn rate (in BP) when Service Provider withdraws from data buyers' accounts
319     mapping (address => mapping (address => bool)) authorized; // holds which accounts have approved which Service Providers
320     mapping (address => uint256) feeBasisPoints;   // Fee (in BP) earned by Service Provider when depositing to data seller
321     mapping (address => address) feeFormulas;      // Provider's customizable Fee mormula
322     modifier isSettleable { require(settlementIsRunning); _; }
323 
324 
325     // WOLK PROTOCOL Events:
326     event AuthorizeServiceProvider(address indexed _owner, address _serviceProvider);
327     event DeauthorizeServiceProvider(address indexed _owner, address _serviceProvider);
328     event SetServiceProviderFee(address indexed _serviceProvider, uint256 _feeBasisPoints);
329     event BurnTokens(address indexed _from, address indexed _serviceProvider, uint256 _value);
330 
331     // @param  _burnBasisPoints
332     // @return success
333     // @dev Set BurnRate on Wolk Protocol -- only Wolk can set this, affects Service Provider settleBuyer
334     function setBurnRate(uint256 _burnBasisPoints) onlyOwner returns (bool success) {
335         require((_burnBasisPoints > 0) && (_burnBasisPoints <= 1000));
336         burnBasisPoints = _burnBasisPoints;
337         return true;
338     }
339     
340     // @param  _newBurnFormula
341     // @return success
342     // @dev Set the formula to use for burning -- only Wolk  can set this
343     function setBurnFormula(address _newBurnFormula) onlyOwner returns (bool success){
344         uint256 testBurning = estWolkToBurn(_newBurnFormula, 10 ** 18);
345         require(testBurning > (5 * 10 ** 13));
346         burnFormula = _newBurnFormula;
347         return true;
348     }
349     
350     // @param  _newFeeFormula
351     // @return success
352     // @dev Set the formula to use for settlement -- settler can customize its fee  
353     function setFeeFormula(address _newFeeFormula) onlySettler returns (bool success){
354         uint256 testSettling = estProviderFee(_newFeeFormula, 10 ** 18);
355         require(testSettling > (5 * 10 ** 13));
356         feeFormulas[msg.sender] = _newFeeFormula;
357         return true;
358     }
359     
360     // @param  _isRunning
361     // @return success
362     // @dev upating settlement status -- only Wolk can set this
363     function updateSettlementStatus(bool _isRunning) onlyOwner returns (bool success){
364         settlementIsRunning = _isRunning;
365         return true;
366     }
367     
368     // @param  _serviceProvider
369     // @param  _feeBasisPoints
370     // @return success
371     // @dev Set Service Provider fee -- only Contract Owner can do this, affects Service Provider settleSeller
372     function setServiceFee(address _serviceProvider, uint256 _feeBasisPoints) onlyOwner returns (bool success) {
373         if (_feeBasisPoints <= 0 || _feeBasisPoints > 4000){
374             // revoke Settler privilege
375             settlers[_serviceProvider] = false;
376             feeBasisPoints[_serviceProvider] = 0;
377             return false;
378         }else{
379             feeBasisPoints[_serviceProvider] = _feeBasisPoints;
380             settlers[_serviceProvider] = true;
381             SetServiceProviderFee(_serviceProvider, _feeBasisPoints);
382             return true;
383         }
384     }
385 
386     // @param  _serviceProvider
387     // @return _feeBasisPoints
388     // @dev Check service Fee (in BP) for a given provider
389     function checkServiceFee(address _serviceProvider) constant returns (uint256 _feeBasisPoints) {
390         return feeBasisPoints[_serviceProvider];
391     }
392 
393     // @param _serviceProvider
394     // @return _formulaAddress
395     // @dev Returns the contract address of the Service Provider's fee formula
396     function checkFeeSchedule(address _serviceProvider) constant returns (address _formulaAddress) {
397         return feeFormulas[_serviceProvider];
398     }
399     
400     // @param _value
401     // @return wolkBurnt
402     // @dev Returns estimate of Wolk to burn 
403     function estWolkToBurn(address _burnFormula, uint256 _value) constant internal returns (uint256){
404         if(_burnFormula != 0x0){
405             uint256 wolkBurnt = IBurnFormula(_burnFormula).calculateWolkToBurn(_value);
406             return wolkBurnt;    
407         }else{
408             return 0; 
409         }
410     }
411     
412     // @param _value
413     // @param _serviceProvider
414     // @return estFee
415     // @dev Returns estimate of Service Provider's fee 
416     function estProviderFee(address _serviceProvider, uint256 _value) constant internal returns (uint256){
417         address ProviderFeeFormula = feeFormulas[_serviceProvider];
418         if (ProviderFeeFormula != 0x0){
419             uint256 estFee = IFeeFormula(ProviderFeeFormula).calculateProviderFee(_value);
420             return estFee;      
421         }else{
422             return 0;  
423         }
424     }
425     
426     // @param  _buyer
427     // @param  _value
428     // @return success
429     // @dev Service Provider Settlement with Buyer: a small percent is burnt (set in setBurnRate, stored in burnBasisPoints) when funds are transferred from buyer to Service Provider [only accessible by settlers]
430     function settleBuyer(address _buyer, uint256 _value) onlySettler isSettleable returns (bool success) {
431         require((burnBasisPoints > 0) && (burnBasisPoints <= 1000) && authorized[_buyer][msg.sender]); // Buyer must authorize Service Provider 
432         require(balances[_buyer] >= _value && _value > 0);
433         var WolkToBurn = estWolkToBurn(burnFormula, _value);
434         var burnCap = safeDiv(safeMul(_value, burnBasisPoints), 10000); //can not burn more than this
435 
436         // If burn formula not found, use default burn rate. If Est to burn exceeds BurnCap, cut back to the cap
437         if (WolkToBurn < 1) WolkToBurn = burnCap;
438         if (WolkToBurn > burnCap) WolkToBurn = burnCap;
439             
440         var transferredToServiceProvider = safeSub(_value, WolkToBurn);
441         balances[_buyer] = safeSub(balances[_buyer], _value);
442         balances[msg.sender] = safeAdd(balances[msg.sender], transferredToServiceProvider);
443         totalTokens = safeSub(totalTokens, WolkToBurn);
444         Transfer(_buyer, msg.sender, transferredToServiceProvider);
445         Transfer(_buyer, 0x00000000000000000000, WolkToBurn);
446         BurnTokens(_buyer, msg.sender, WolkToBurn);
447         return true;
448     } 
449 
450     // @param  _seller
451     // @param  _value
452     // @return success
453     // @dev Service Provider Settlement with Seller: a small percent is kept by Service Provider (set in setServiceFee, stored in feeBasisPoints) when funds are transferred from Service Provider to seller [only accessible by settlers]
454     function settleSeller(address _seller, uint256 _value) onlySettler isSettleable returns (bool success) {
455         // Service Providers have a % max fee (e.g. 20%)
456         var serviceProviderBP = feeBasisPoints[msg.sender];
457         require((serviceProviderBP > 0) && (serviceProviderBP <= 4000) && (_value > 0));
458         var seviceFee = estProviderFee(msg.sender, _value);
459         var Maximumfee = safeDiv(safeMul(_value, serviceProviderBP), 10000);
460         
461         // If provider's fee formula not set, use default burn rate. If Est fee exceeds Maximumfee, cut back to the fee
462         if (seviceFee < 1) seviceFee = Maximumfee;  
463         if (seviceFee > Maximumfee) seviceFee = Maximumfee;
464         var transferredToSeller = safeSub(_value, seviceFee);
465         require(balances[msg.sender] >= transferredToSeller );
466         balances[_seller] = safeAdd(balances[_seller], transferredToSeller);
467         Transfer(msg.sender, _seller, transferredToSeller);
468         return true;
469     }
470 
471     // @param _providerToAdd
472     // @return success
473     // @dev Buyer authorizes the Service Provider (to call settleBuyer). For security reason, _providerToAdd needs to be whitelisted by Wolk Inc first
474     function authorizeProvider(address _providerToAdd) returns (bool success) {
475         require(settlers[_providerToAdd]);
476         authorized[msg.sender][_providerToAdd] = true;
477         AuthorizeServiceProvider(msg.sender, _providerToAdd);
478         return true;
479     }
480 
481     // @param _providerToRemove
482     // @return success
483     // @dev Buyer deauthorizes the Service Provider (from calling settleBuyer)
484     function deauthorizeProvider(address _providerToRemove) returns (bool success) {
485         authorized[msg.sender][_providerToRemove] = false;
486         DeauthorizeServiceProvider(msg.sender, _providerToRemove);
487         return true;
488     }
489 
490     // @param _owner
491     // @param _serviceProvider
492     // @return authorizationStatus
493     // @dev Check authorization between account and Service Provider
494     function checkAuthorization(address _owner, address _serviceProvider) constant returns (bool authorizationStatus) {
495         return authorized[_owner][_serviceProvider];
496     }
497 
498     // @param _owner
499     // @param _providerToAdd
500     // @return authorizationStatus
501     // @dev Grant authorization between account and Service Provider on buyers' behalf [only accessible by Contract Owner]
502     // @note Explicit permission from balance owner MUST be obtained beforehand
503     function grantService(address _owner, address _providerToAdd) onlyOwner returns (bool authorizationStatus) {
504         var isPreauthorized = authorized[_owner][msg.sender];
505         if (isPreauthorized && settlers[_providerToAdd]) {
506             authorized[_owner][_providerToAdd] = true;
507             AuthorizeServiceProvider(msg.sender, _providerToAdd);
508             return true;
509         }else{
510             return false;
511         }
512     }
513 
514     // @param _owner
515     // @param _providerToRemove
516     // @return authorization_status
517     // @dev Revoke authorization between account and Service Provider on buyers' behalf [only accessible by Contract Owner]
518     // @note Explicit permission from balance owner are NOT required for disabling ill-intent Service Provider
519     function removeService(address _owner, address _providerToRemove) onlyOwner returns (bool authorizationStatus) {
520         authorized[_owner][_providerToRemove] = false;
521         DeauthorizeServiceProvider(_owner, _providerToRemove);
522         return true;
523     }
524 }
525 
526 // Taken from https://github.com/bancorprotocol/contracts/blob/master/solidity/contracts/BancorFormula.sol
527 contract IBancorFormula {
528     function calculatePurchaseReturn(uint256 _supply, uint256 _reserveBalance, uint8 _reserveRatio, uint256 _depositAmount) public constant returns (uint256);
529     function calculateSaleReturn(uint256 _supply, uint256 _reserveBalance, uint8 _reserveRatio, uint256 _sellAmount) public constant returns (uint256);
530 }
531 
532 contract WolkExchange is WolkProtocol, WolkTGE {
533 
534     uint256 public maxPerExchangeBP = 50;
535     address public exchangeFormula;
536     bool    public exchangeIsRunning = false;
537     modifier isExchangable { require(exchangeIsRunning && allSaleCompleted); _; }
538     
539     // @param  _newExchangeformula
540     // @return success
541     // @dev Set the bancor formula to use -- only Wolk Inc can set this
542     function setExchangeFormula(address _newExchangeformula) onlyOwner returns (bool success){
543         require(sellWolkEstimate(10**decimals, _newExchangeformula) > 0);
544         require(purchaseWolkEstimate(10**decimals, _newExchangeformula) > 0);
545         exchangeIsRunning = false;
546         exchangeFormula = _newExchangeformula;
547         return true;
548     }
549     
550     // @param  _isRunning
551     // @return success
552     // @dev upating exchange status -- only Wolk Inc can set this
553     function updateExchangeStatus(bool _isRunning) onlyOwner returns (bool success){
554         if (_isRunning){
555             require(sellWolkEstimate(10**decimals, exchangeFormula) > 0);
556             require(purchaseWolkEstimate(10**decimals, exchangeFormula) > 0);   
557         }
558         exchangeIsRunning = _isRunning;
559         return true;
560     }
561     
562     // @param  _maxPerExchange
563     // @return success
564     // @dev Set max sell token amount per transaction -- only Wolk Inc can set this
565     function setMaxPerExchange(uint256 _maxPerExchange) onlyOwner returns (bool success) {
566         require((_maxPerExchange >= 10) && (_maxPerExchange <= 100));
567         maxPerExchangeBP = _maxPerExchange;
568         return true;
569     }
570 
571     // @return Estimated Liquidation Cap
572     // @dev Liquidation Cap per transaction is used to ensure proper price discovery for Wolk Exchange 
573     function estLiquidationCap() public constant returns (uint256) {
574         if (openSaleCompleted){
575             var liquidationMax  = safeDiv(safeMul(totalTokens, maxPerExchangeBP), 10000);
576             if (liquidationMax < 100 * 10**decimals){ 
577                 liquidationMax = 100 * 10**decimals;
578             }
579             return liquidationMax;   
580         }else{
581             return 0;
582         }
583     }
584 
585     function sellWolkEstimate(uint256 _wolkAmountest, address _formula) internal returns(uint256) {
586         uint256 ethReceivable =  IBancorFormula(_formula).calculateSaleReturn(totalTokens, reserveBalance, percentageETHReserve, _wolkAmountest);
587         return ethReceivable;
588     }
589     
590     function purchaseWolkEstimate(uint256 _ethAmountest, address _formula) internal returns(uint256) {
591         uint256 wolkReceivable = IBancorFormula(_formula).calculatePurchaseReturn(totalTokens, reserveBalance, percentageETHReserve, _ethAmountest);
592         return wolkReceivable;
593     }
594     
595     // @param _wolkAmount
596     // @return ethReceivable
597     // @dev send Wolk into contract in exchange for eth, at an exchange rate based on the Bancor Protocol derivation and decrease totalSupply accordingly
598     function sellWolk(uint256 _wolkAmount) isExchangable() returns(uint256) {
599         uint256 sellCap = estLiquidationCap();
600         require((balances[msg.sender] >= _wolkAmount));
601         require(sellCap >= _wolkAmount);
602         uint256 ethReceivable = sellWolkEstimate(_wolkAmount,exchangeFormula);
603         require(this.balance > ethReceivable);
604         balances[msg.sender] = safeSub(balances[msg.sender], _wolkAmount);
605         totalTokens = safeSub(totalTokens, _wolkAmount);
606         reserveBalance = safeSub(this.balance, ethReceivable);
607         WolkDestroyed(msg.sender, _wolkAmount);
608         Transfer(msg.sender, 0x00000000000000000000, _wolkAmount);
609         msg.sender.transfer(ethReceivable);
610         return ethReceivable;     
611     }
612 
613     // @return wolkReceivable    
614     // @dev send eth into contract in exchange for Wolk tokens, at an exchange rate based on the Bancor Protocol derivation and increase totalSupply accordingly
615     function purchaseWolk(address _buyer) isExchangable() payable returns(uint256){
616         require(msg.value > 0);
617         uint256 wolkReceivable = purchaseWolkEstimate(msg.value, exchangeFormula);
618         require(wolkReceivable > 0);
619         totalTokens = safeAdd(totalTokens, wolkReceivable);
620         balances[_buyer] = safeAdd(balances[_buyer], wolkReceivable);
621         reserveBalance = safeAdd(reserveBalance, msg.value);
622         WolkCreated(_buyer, wolkReceivable);
623         Transfer(address(this),_buyer,wolkReceivable);
624         return wolkReceivable;
625     }
626 
627     // @dev  fallback function for purchase
628     // @note Automatically fallback to tokenGenerationEvent before sale is completed. After the token generation event, fallback to purchaseWolk. Liquidity exchange will be enabled through updateExchangeStatus  
629     function () payable {
630         require(msg.value > 0);
631         if(!openSaleCompleted){
632             this.tokenGenerationEvent.value(msg.value)(msg.sender);
633         }else if (block.number >= end_block){
634             this.purchaseWolk.value(msg.value)(msg.sender);
635         }else{
636             revert();
637         }
638     }
639 }