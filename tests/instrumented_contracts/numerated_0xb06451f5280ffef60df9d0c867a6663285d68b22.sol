1 pragma solidity ^0.4.18;
2 
3 // @author - vivekjibw@gmail.com
4 // Website: http://CryptoStockMarket.co
5 // Only CEO can change CEO and CFO address
6 
7 contract CompanyAccessControl {
8     
9     address public ceoAddress;
10     address public cfoAddress;
11 
12     bool public paused = false;
13 
14     modifier onlyCEO() {
15         require(msg.sender == ceoAddress);
16         _;
17     }
18 
19     modifier onlyCFO() {
20         require(msg.sender == cfoAddress);
21         _;
22     }
23 
24     modifier onlyCLevel() {
25         require(
26             msg.sender == ceoAddress ||
27             msg.sender == cfoAddress
28         );
29         _;
30     }
31 
32     function setCEO(address _newCEO) 
33     onlyCEO 
34     external {
35         require(_newCEO != address(0));
36         ceoAddress = _newCEO;
37     }
38 
39     function setCFO(address _newCFO) 
40     onlyCEO 
41     external {
42         require(_newCFO != address(0));
43         cfoAddress = _newCFO;
44     }
45 
46     modifier whenNotPaused() {
47         require(!paused);
48         _;
49     }
50 
51     modifier whenPaused {
52         require(paused);
53         _;
54     }
55 
56     function pause() 
57     onlyCLevel
58     external 
59     whenNotPaused {
60         paused = true;
61     }
62 
63     function unpause() 
64     onlyCLevel 
65     whenPaused 
66     external {
67         paused = false;
68     }
69 }
70 
71 // Keeps a mapping of onwerAddress to the number of shares owned
72 contract BookKeeping {
73     
74     struct ShareHolders {
75         mapping(address => uint) ownerAddressToShares;
76         uint numberOfShareHolders;
77     }
78     
79     // _amount should be greator than 0
80     function _sharesBought(ShareHolders storage _shareHolders, address _owner, uint _amount) 
81     internal {
82         // If user didn't have shares earlier, he is now a share holder!
83         if (_shareHolders.ownerAddressToShares[_owner] == 0) {
84             _shareHolders.numberOfShareHolders += 1;
85         }
86         _shareHolders.ownerAddressToShares[_owner] += _amount;
87         
88     }
89 
90     // _amount should be greator or equal to what user already have, otherwise will result in underflow
91     function _sharesSold(ShareHolders storage _shareHolders, address _owner, uint _amount) 
92     internal {
93         _shareHolders.ownerAddressToShares[_owner] -= _amount;
94         
95         // if user sold all his tokens, then there is one less share holder
96         if (_shareHolders.ownerAddressToShares[_owner] == 0) {
97             _shareHolders.numberOfShareHolders -= 1;
98         }
99     }
100 }
101 
102 
103 contract CompanyConstants {
104     // Days after which trading volume competiton result will be annouced
105     uint constant TRADING_COMPETITION_PERIOD = 5 days;
106     
107     // Max Percentage of shares that can be released per cycle
108     uint constant MAX_PERCENTAGE_SHARE_RELEASE = 5;
109     
110     uint constant MAX_CLAIM_SHARES_PERCENTAGE = 5;
111     
112     // Release cycle! Every company needs to wait for "at least" 10 days
113     // before releasing next set of shares!
114     uint constant MIN_COOLDOWN_TIME = 10; // in days
115     uint constant MAX_COOLDOWN_TIME = 255;
116     
117     // A company can start with min 100 tokens or max 10K tokens
118     // and min(10%, 500) new tokens will be released every x days where
119     // x >= 10;
120     uint constant INIT_MAX_SHARES_IN_CIRCULATION = 10000;
121     uint constant INIT_MIN_SHARES_IN_CIRCULATION = 100;
122     uint constant MAX_SHARES_RELEASE_IN_ONE_CYCLE = 500;
123     
124     // Company will take a cut of 10% from the share sales!
125     uint constant SALES_CUT = 10;
126     
127     // Company will take a cut of 2% when an order is claimed.
128     uint constant ORDER_CUT = 2;
129     
130     // Type of orders
131     enum OrderType {Buy, Sell}
132     
133     // A new company is listed!
134     event Listed(uint companyId, string companyName, uint sharesInCirculation, uint pricePerShare,
135     uint percentageSharesToRelease, uint nextSharesReleaseTime, address owner);
136     
137     // Tokens are claimed!
138     event Claimed(uint companyId, uint numberOfShares, address owner);
139     
140     // Tokens are transfered
141     event Transfer(uint companyId, address from, address to, uint numberOfShares);
142     
143     // There is a new CEO of the company
144     event CEOChanged(uint companyId, address previousCEO, address newCEO);
145     
146     // Shares are relased for the company
147     event SharesReleased(uint companyId, address ceo, uint numberOfShares, uint nextSharesReleaseTime);
148     
149     // A new order is placed
150     event OrderPlaced(uint companyId, uint orderIndex, uint amount, uint pricePerShare, OrderType orderType, address owner);
151     
152     // An order is claimed!
153     event OrderFilled(uint companyId, uint orderIndex, uint amount, address buyer);
154     
155     // A placed order is cancelled!
156     event OrderCancelled(uint companyId, uint orderIndex);
157     
158     event TradingWinnerAnnounced(uint companyId, address winner, uint sharesAwarded);
159 }
160 
161 contract CompanyBase is BookKeeping, CompanyConstants {
162 
163     struct Company {
164         // Company names are stored as hashes to save gas cost during execution
165         bytes32 companyNameHash;
166 
167         // Percentage of shares to release
168         // will be less than maxPercentageSharesRelease
169         uint32 percentageSharesToRelease;
170 
171         // The time of the release cycle in days. If it is set to 10
172         // then it means shares can only be released every 10 days 
173         // Min values is 10
174         uint32 coolDownTime;
175         
176         // Total number of shares that are in circulation right now!
177         uint32 sharesInCirculation; 
178 
179         // Total number of shares that are still with the company and can be claimed by paying the price
180         uint32 unclaimedShares; 
181         
182         // Address of the person who owns more tha 50% shares of the company.
183         address ceoOfCompany; 
184 
185         // Address of person who registered this company and will receive money from the share sales.
186         address ownedBy; 
187         
188         // The exact time in future before which shares can't be released!
189         // if shares are just released then nextSharesReleaseTime will be (now + coolDownTime);
190         uint nextSharesReleaseTime; 
191 
192         // Price of one share as set by the company
193         uint pricePerShare; 
194 
195         // Share holders of the company
196         ShareHolders shareHolders;
197     }
198 
199     Company[] companies;
200     
201     function getCompanyDetails(uint _companyId) 
202     view
203     external 
204     returns (
205         bytes32 companyNameHash,
206         uint percentageSharesToRelease,
207         uint coolDownTime,
208         uint nextSharesReleaseTime,
209         uint sharesInCirculation,
210         uint unclaimedShares,
211         uint pricePerShare,
212         uint sharesRequiredToBeCEO,
213         address ceoOfCompany,     
214         address owner,
215         uint numberOfShareHolders) {
216 
217         Company storage company = companies[_companyId];
218 
219         companyNameHash = company.companyNameHash;
220         percentageSharesToRelease = company.percentageSharesToRelease;
221         coolDownTime = company.coolDownTime;
222         nextSharesReleaseTime = company.nextSharesReleaseTime;
223         sharesInCirculation = company.sharesInCirculation;
224         unclaimedShares = company.unclaimedShares;
225         pricePerShare = company.pricePerShare; 
226         sharesRequiredToBeCEO = (sharesInCirculation/2) + 1;
227         ceoOfCompany = company.ceoOfCompany;
228         owner = company.ownedBy;
229         numberOfShareHolders = company.shareHolders.numberOfShareHolders;
230     }
231 
232     function getNumberOfShareHolders(uint _companyId) 
233     view
234     external
235     returns (uint) {
236         return companies[_companyId].shareHolders.numberOfShareHolders;
237     }
238 
239     function getNumberOfSharesForAddress(uint _companyId, address _user) 
240     view
241     external 
242     returns(uint) {
243         return companies[_companyId].shareHolders.ownerAddressToShares[_user];
244     }
245     
246     function getTotalNumberOfRegisteredCompanies()
247     view
248     external
249     returns (uint) {
250         return companies.length;
251     }
252 }
253 
254 contract TradingVolume is CompanyConstants {
255     
256     struct Traders {
257         uint relaseTime;
258         address winningTrader;
259         mapping (address => uint) sharesTraded;
260     }
261     
262     mapping (uint => Traders) companyIdToTraders;
263     
264     // unique _companyId
265     function _addNewCompanyTraders(uint _companyId) 
266     internal {
267         Traders memory traders = Traders({
268             winningTrader : 0x0,
269             relaseTime : now + TRADING_COMPETITION_PERIOD 
270         });
271         
272         companyIdToTraders[_companyId] = traders;
273     }
274     
275     // _from!=_to , _amount > 0
276     function _updateTradingVolume(Traders storage _traders, address _from, address _to, uint _amount) 
277     internal {
278         _traders.sharesTraded[_from] += _amount;
279         _traders.sharesTraded[_to] += _amount;
280         
281         if (_traders.sharesTraded[_from] > _traders.sharesTraded[_traders.winningTrader]) {
282             _traders.winningTrader = _from;
283         } 
284         
285         if (_traders.sharesTraded[_to] > _traders.sharesTraded[_traders.winningTrader]) {
286             _traders.winningTrader = _to;
287         } 
288     }
289     
290     // Get reference of winningTrader before clearing
291     function _clearWinner(Traders storage _traders) 
292     internal {
293         delete _traders.sharesTraded[_traders.winningTrader];
294         delete _traders.winningTrader;
295         _traders.relaseTime = now + TRADING_COMPETITION_PERIOD;
296     }
297 }
298 
299 contract ApprovalContract is CompanyAccessControl {
300     // Approver who are approved to launch a company a particular name
301     // the bytes32 hash is the hash of the company name!
302     mapping(bytes32 => address) public approvedToLaunch;
303     
304     // Make sure that we don't add two companies with same name
305     mapping(bytes32 => bool) public registredCompanyNames;
306     
307     // Approve addresses to launch a company with the given name
308     // Only ceo or cfo can approve a company;
309     // the owner who launched the company would receive 90% from the sales of
310     // shares and 10% will be kept by the contract!
311     function addApprover(address _owner, string _companyName) 
312     onlyCLevel
313     whenNotPaused
314     external {
315         approvedToLaunch[keccak256(_companyName)] = _owner;
316     }
317 }
318 
319 contract CompanyMain is CompanyBase, ApprovalContract, TradingVolume {
320     uint public withdrawableBalance;
321     
322     // The cut contract takes from the share sales of an approved company.
323     // price is in wei
324     function _computeSalesCut(uint _price) 
325     pure
326     internal 
327     returns (uint) {
328         return (_price * SALES_CUT)/100;
329     }
330     
331     // Whenever there is transfer of tokens from _from to _to, CEO of company might get changed!
332     function _updateCEOIfRequired(Company storage _company, uint _companyId, address _to) 
333     internal {
334         uint sharesRequiredToBecomeCEO = (_company.sharesInCirculation/2 ) + 1;
335         address currentCEO = _company.ceoOfCompany;
336         
337         if (_company.shareHolders.ownerAddressToShares[currentCEO] >= sharesRequiredToBecomeCEO) {
338             return;
339         } 
340         
341         if (_to != address(this) && _company.shareHolders.ownerAddressToShares[_to] >= sharesRequiredToBecomeCEO) {
342             _company.ceoOfCompany = _to;
343             emit CEOChanged(_companyId, currentCEO, _to);
344             return;
345         }
346         
347         if (currentCEO == 0x0) {
348             return;
349         }
350         _company.ceoOfCompany = 0x0;
351         emit CEOChanged(_companyId, currentCEO, 0x0);
352     }
353     
354 
355     /// Transfer tokens from _from to _to and verify if CEO of company has changed!
356     // _from should have enough tokens before calling this functions!
357     // _numberOfTokens should be greator than 0
358     function _transfer(uint _companyId, address _from, address _to, uint _numberOfTokens) 
359     internal {
360         Company storage company = companies[_companyId];
361         
362         _sharesSold(company.shareHolders, _from, _numberOfTokens);
363         _sharesBought(company.shareHolders, _to, _numberOfTokens);
364 
365         _updateCEOIfRequired(company, _companyId, _to);
366         
367         emit Transfer(_companyId, _from, _to, _numberOfTokens);
368     }
369     
370     function transferPromotionalShares(uint _companyId, address _to, uint _amount)
371     onlyCLevel
372     whenNotPaused
373     external
374     {
375         Company storage company = companies[_companyId];
376         // implies a promotional company
377         require(company.pricePerShare == 0);
378         require(companies[_companyId].shareHolders.ownerAddressToShares[msg.sender] >= _amount);
379         _transfer(_companyId, msg.sender, _to, _amount);
380     }
381     
382     function addPromotionalCompany(string _companyName, uint _precentageSharesToRelease, uint _coolDownTime, uint _sharesInCirculation)
383     onlyCLevel
384     whenNotPaused 
385     external
386     {
387         bytes32 companyNameHash = keccak256(_companyName);
388         
389         // There shouldn't be a company that is already registered with same name!
390         require(registredCompanyNames[companyNameHash] == false);
391         
392         // Max 10% shares can be released in one release cycle, to control liquidation
393         // and uncontrolled issuing of new tokens. Furthermore the max shares that can
394         // be released in one cycle can only be upto 500.
395         require(_precentageSharesToRelease <= MAX_PERCENTAGE_SHARE_RELEASE);
396         
397         // The min release cycle should be at least 10 days
398         require(_coolDownTime >= MIN_COOLDOWN_TIME && _coolDownTime <= MAX_COOLDOWN_TIME);
399 
400         uint _companyId = companies.length;
401         uint _nextSharesReleaseTime = now + _coolDownTime * 1 days;
402         
403         Company memory company = Company({
404             companyNameHash: companyNameHash,
405             
406             percentageSharesToRelease : uint32(_precentageSharesToRelease),
407             coolDownTime : uint32(_coolDownTime),
408             
409             sharesInCirculation : uint32(_sharesInCirculation),
410             nextSharesReleaseTime : _nextSharesReleaseTime,
411             unclaimedShares : 0,
412             
413             pricePerShare : 0,
414             
415             ceoOfCompany : 0x0,
416             ownedBy : msg.sender,
417             shareHolders : ShareHolders({numberOfShareHolders : 0})
418             });
419 
420         companies.push(company);
421         _addNewCompanyTraders(_companyId);
422         // Register company name
423         registredCompanyNames[companyNameHash] = true;
424         _sharesBought(companies[_companyId].shareHolders, msg.sender, _sharesInCirculation);
425         emit Listed(_companyId, _companyName, _sharesInCirculation, 0, _precentageSharesToRelease, _nextSharesReleaseTime, msg.sender);
426     }
427 
428     // Add a new company with the given name  
429     function addNewCompany(string _companyName, uint _precentageSharesToRelease, uint _coolDownTime, uint _sharesInCirculation, uint _pricePerShare) 
430     external 
431     whenNotPaused 
432     {
433         bytes32 companyNameHash = keccak256(_companyName);
434         
435         // There shouldn't be a company that is already registered with same name!
436         require(registredCompanyNames[companyNameHash] == false);
437         
438         // Owner have the permissions to launch the company
439         require(approvedToLaunch[companyNameHash] == msg.sender);
440         
441         // Max 10% shares can be released in one release cycle, to control liquidation
442         // and uncontrolled issuing of new tokens. Furthermore the max shares that can
443         // be released in one cycle can only be upto 500.
444         require(_precentageSharesToRelease <= MAX_PERCENTAGE_SHARE_RELEASE);
445         
446         // The min release cycle should be at least 10 days
447         require(_coolDownTime >= MIN_COOLDOWN_TIME && _coolDownTime <= MAX_COOLDOWN_TIME);
448         
449         require(_sharesInCirculation >= INIT_MIN_SHARES_IN_CIRCULATION &&
450         _sharesInCirculation <= INIT_MAX_SHARES_IN_CIRCULATION);
451 
452         uint _companyId = companies.length;
453         uint _nextSharesReleaseTime = now + _coolDownTime * 1 days;
454 
455         Company memory company = Company({
456             companyNameHash: companyNameHash,
457             
458             percentageSharesToRelease : uint32(_precentageSharesToRelease),
459             nextSharesReleaseTime : _nextSharesReleaseTime,
460             coolDownTime : uint32(_coolDownTime),
461             
462             sharesInCirculation : uint32(_sharesInCirculation),
463             unclaimedShares : uint32(_sharesInCirculation),
464             
465             pricePerShare : _pricePerShare,
466             
467             ceoOfCompany : 0x0,
468             ownedBy : msg.sender,
469             shareHolders : ShareHolders({numberOfShareHolders : 0})
470             });
471 
472         companies.push(company);
473         _addNewCompanyTraders(_companyId);
474         // Register company name
475         registredCompanyNames[companyNameHash] = true;
476         emit Listed(_companyId, _companyName, _sharesInCirculation, _pricePerShare, _precentageSharesToRelease, _nextSharesReleaseTime, msg.sender);
477     }
478     
479     // People can claim shares from the company! 
480     // The share price is fixed. However, once bought the users can place buy/sell
481     // orders of any amount!
482     function claimShares(uint _companyId, uint _numberOfShares) 
483     whenNotPaused
484     external 
485     payable {
486         Company storage company = companies[_companyId];
487         
488         require (_numberOfShares > 0 &&
489             _numberOfShares <= (company.sharesInCirculation * MAX_CLAIM_SHARES_PERCENTAGE)/100);
490 
491         require(company.unclaimedShares >= _numberOfShares);
492         
493         uint totalPrice = company.pricePerShare * _numberOfShares;
494         require(msg.value >= totalPrice);
495 
496         company.unclaimedShares -= uint32(_numberOfShares);
497 
498         _sharesBought(company.shareHolders, msg.sender, _numberOfShares);
499         _updateCEOIfRequired(company, _companyId, msg.sender);
500 
501         if (totalPrice > 0) {
502             uint salesCut = _computeSalesCut(totalPrice);
503             withdrawableBalance += salesCut;
504             uint sellerProceeds = totalPrice - salesCut;
505 
506             company.ownedBy.transfer(sellerProceeds);
507         } 
508 
509         emit Claimed(_companyId, _numberOfShares, msg.sender);
510     }
511     
512     // Company's next shares can be released only by the CEO of the company! 
513     // So there should exist a CEO first
514     function releaseNextShares(uint _companyId) 
515     external 
516     whenNotPaused {
517 
518         Company storage company = companies[_companyId];
519         
520         require(company.ceoOfCompany == msg.sender);
521         
522         // If there are unclaimedShares with the company, then new shares can't be relased!
523         require(company.unclaimedShares == 0 );
524         
525         require(now >= company.nextSharesReleaseTime);
526 
527         company.nextSharesReleaseTime = now + company.coolDownTime * 1 days;
528         
529         // In worst case, we will be relasing max 500 tokens every 10 days! 
530         // If we will start with max(10K) tokens, then on average we will be adding
531         // 18000 tokens every year! In 100 years, it will be 1.8 millions. Multiplying it
532         // by 10 makes it 18 millions. There is no way we can overflow the multiplication here!
533         uint sharesToRelease = (company.sharesInCirculation * company.percentageSharesToRelease)/100;
534         
535         // Max 500 tokens can be relased
536         if (sharesToRelease > MAX_SHARES_RELEASE_IN_ONE_CYCLE) {
537             sharesToRelease = MAX_SHARES_RELEASE_IN_ONE_CYCLE;
538         }
539         
540         if (sharesToRelease > 0) {
541             company.sharesInCirculation += uint32(sharesToRelease);
542             _sharesBought(company.shareHolders, company.ceoOfCompany, sharesToRelease);
543             emit SharesReleased(_companyId, company.ceoOfCompany, sharesToRelease, company.nextSharesReleaseTime);
544         }
545     }
546     
547     function _updateTradingVolume(uint _companyId, address _from, address _to, uint _amount) 
548     internal {
549         Traders storage traders = companyIdToTraders[_companyId];
550         _updateTradingVolume(traders, _from, _to, _amount);
551         
552         if (now < traders.relaseTime) {
553             return;
554         }
555         
556         Company storage company = companies[_companyId];
557         uint _newShares = company.sharesInCirculation/100;
558         if (_newShares > MAX_SHARES_RELEASE_IN_ONE_CYCLE) {
559             _newShares = 100;
560         }
561         company.sharesInCirculation += uint32(_newShares);
562          _sharesBought(company.shareHolders, traders.winningTrader, _newShares);
563         _updateCEOIfRequired(company, _companyId, traders.winningTrader);
564         emit TradingWinnerAnnounced(_companyId, traders.winningTrader, _newShares);
565         _clearWinner(traders);
566     }
567 }
568 
569 contract MarketBase is CompanyMain {
570     
571     function MarketBase() public {
572         ceoAddress = msg.sender;
573         cfoAddress = msg.sender;
574     }
575     
576     struct Order {
577         // Owner who placed the order
578         address owner;
579                 
580         // Total number of tokens in order
581         uint32 amount;
582         
583         // Amount of tokens that are already bought/sold by other people
584         uint32 amountFilled;
585         
586         // Type of the order
587         OrderType orderType;
588         
589         // Price of one share
590         uint pricePerShare;
591     }
592     
593     // A mapping of companyId to orders
594     mapping (uint => Order[]) companyIdToOrders;
595     
596     // _amount > 0
597     function _createOrder(uint _companyId, uint _amount, uint _pricePerShare, OrderType _orderType) 
598     internal {
599         Order memory order = Order({
600             owner : msg.sender,
601             pricePerShare : _pricePerShare,
602             amount : uint32(_amount),
603             amountFilled : 0,
604             orderType : _orderType
605         });
606         
607         uint index = companyIdToOrders[_companyId].push(order) - 1;
608         emit OrderPlaced(_companyId, index, order.amount, order.pricePerShare, order.orderType, msg.sender);
609     }
610     
611     // Place a sell request if seller have enough tokens!
612     function placeSellRequest(uint _companyId, uint _amount, uint _pricePerShare) 
613     whenNotPaused
614     external {
615         require (_amount > 0);
616         require (_pricePerShare > 0);
617 
618         // Seller should have enough tokens to place a sell order!
619         _verifyOwnershipOfTokens(_companyId, msg.sender, _amount);
620 
621         _transfer(_companyId, msg.sender, this, _amount);
622         _createOrder(_companyId, _amount, _pricePerShare, OrderType.Sell);
623     }
624     
625     // Place a request to buy shares of a particular company!
626     function placeBuyRequest(uint _companyId, uint _amount, uint _pricePerShare) 
627     external 
628     payable 
629     whenNotPaused {
630         require(_amount > 0);
631         require(_pricePerShare > 0);
632         require(_amount == uint(uint32(_amount)));
633         
634         // Should have enough eth!
635         require(msg.value >= _amount * _pricePerShare);
636 
637         _createOrder(_companyId, _amount, _pricePerShare, OrderType.Buy);
638     }
639     
640     // Cancel a placed order!
641     function cancelRequest(uint _companyId, uint _orderIndex) 
642     external {        
643         Order storage order = companyIdToOrders[_companyId][_orderIndex];
644         
645         require(order.owner == msg.sender);
646         
647         uint sharesRemaining = _getRemainingSharesInOrder(order);
648         
649         require(sharesRemaining > 0);
650 
651         order.amountFilled += uint32(sharesRemaining);
652         
653         if (order.orderType == OrderType.Buy) {
654 
655              // If its a buy order, transfer the ether back to owner;
656             uint price = _getTotalPrice(order, sharesRemaining);
657             
658             // Sends money back to owner!
659             msg.sender.transfer(price);
660         } else {
661             
662             // Send the tokens back to the owner
663             _transfer(_companyId, this, msg.sender, sharesRemaining);
664         }
665 
666         emit OrderCancelled(_companyId, _orderIndex);
667     }
668     
669     // Fill the sell order!
670     function fillSellOrder(uint _companyId, uint _orderIndex, uint _amount) 
671     whenNotPaused
672     external 
673     payable {
674         require(_amount > 0);
675         
676         Order storage order = companyIdToOrders[_companyId][_orderIndex];
677         require(order.orderType == OrderType.Sell);
678         
679         require(msg.sender != order.owner);
680        
681         _verifyRemainingSharesInOrder(order, _amount);
682 
683         uint price = _getTotalPrice(order, _amount);
684         require(msg.value >= price);
685 
686         order.amountFilled += uint32(_amount);
687         
688         // transfer tokens to the buyer
689         _transfer(_companyId, this, msg.sender, _amount);
690         
691         // send money to seller after taking a small share
692         _transferOrderMoney(price, order.owner);  
693         
694         _updateTradingVolume(_companyId, msg.sender, order.owner, _amount);
695         
696         emit OrderFilled(_companyId, _orderIndex, _amount, msg.sender);
697     }
698     
699     // Fill the sell order!
700     function fillSellOrderPartially(uint _companyId, uint _orderIndex, uint _maxAmount) 
701     whenNotPaused
702     external 
703     payable {
704         require(_maxAmount > 0);
705         
706         Order storage order = companyIdToOrders[_companyId][_orderIndex];
707         require(order.orderType == OrderType.Sell);
708         
709         require(msg.sender != order.owner);
710        
711         uint buyableShares = _getRemainingSharesInOrder(order);
712         require(buyableShares > 0);
713         
714         if (buyableShares > _maxAmount) {
715             buyableShares = _maxAmount;
716         }
717 
718         uint price = _getTotalPrice(order, buyableShares);
719         require(msg.value >= price);
720 
721         order.amountFilled += uint32(buyableShares);
722         
723         // transfer tokens to the buyer
724         _transfer(_companyId, this, msg.sender, buyableShares);
725         
726         // send money to seller after taking a small share
727         _transferOrderMoney(price, order.owner); 
728         
729         _updateTradingVolume(_companyId, msg.sender, order.owner, buyableShares);
730         
731         uint buyerProceeds = msg.value - price;
732         msg.sender.transfer(buyerProceeds);
733         
734         emit OrderFilled(_companyId, _orderIndex, buyableShares, msg.sender);
735     }
736 
737     // Fill the buy order!
738     function fillBuyOrder(uint _companyId, uint _orderIndex, uint _amount) 
739     whenNotPaused
740     external {
741         require(_amount > 0);
742         
743         Order storage order = companyIdToOrders[_companyId][_orderIndex];
744         require(order.orderType == OrderType.Buy);
745         
746         require(msg.sender != order.owner);
747         
748         // There should exist enought shares to fulfill the request!
749         _verifyRemainingSharesInOrder(order, _amount);
750         
751         // The seller have enought tokens to fulfill the request!
752         _verifyOwnershipOfTokens(_companyId, msg.sender, _amount);
753         
754         order.amountFilled += uint32(_amount);
755         
756         // transfer the tokens from the seller to the buyer!
757         _transfer(_companyId, msg.sender, order.owner, _amount);
758         
759         uint price = _getTotalPrice(order, _amount);
760         
761         // transfer the money from this contract to the seller
762         _transferOrderMoney(price , msg.sender);
763         
764         _updateTradingVolume(_companyId, msg.sender, order.owner, _amount);
765 
766         emit OrderFilled(_companyId, _orderIndex, _amount, msg.sender);
767     }
768     
769     // Fill buy order partially if possible!
770     function fillBuyOrderPartially(uint _companyId, uint _orderIndex, uint _maxAmount) 
771     whenNotPaused
772     external {
773         require(_maxAmount > 0);
774         
775         Order storage order = companyIdToOrders[_companyId][_orderIndex];
776         require(order.orderType == OrderType.Buy);
777         
778         require(msg.sender != order.owner);
779         
780         // There should exist enought shares to fulfill the request!
781         uint buyableShares = _getRemainingSharesInOrder(order);
782         require(buyableShares > 0);
783         
784         if ( buyableShares > _maxAmount) {
785             buyableShares = _maxAmount;
786         }
787         
788         // The seller have enought tokens to fulfill the request!
789         _verifyOwnershipOfTokens(_companyId, msg.sender, buyableShares);
790         
791         order.amountFilled += uint32(buyableShares);
792         
793         // transfer the tokens from the seller to the buyer!
794         _transfer(_companyId, msg.sender, order.owner, buyableShares);
795         
796         uint price = _getTotalPrice(order, buyableShares);
797         
798         // transfer the money from this contract to the seller
799         _transferOrderMoney(price , msg.sender);
800         
801         _updateTradingVolume(_companyId, msg.sender, order.owner, buyableShares);
802 
803         emit OrderFilled(_companyId, _orderIndex, buyableShares, msg.sender);
804     }
805 
806     // transfer money to the owner!
807     function _transferOrderMoney(uint _price, address _owner) 
808     internal {
809         uint priceCut = (_price * ORDER_CUT)/100;
810         _owner.transfer(_price - priceCut);
811         withdrawableBalance += priceCut;
812     }
813 
814     // Returns the price for _amount tokens for the given order
815     // _amount > 0
816     // order should be verified
817     function _getTotalPrice(Order storage _order, uint _amount) 
818     view
819     internal 
820     returns (uint) {
821         return _amount * _order.pricePerShare;
822     }
823     
824     // Gets the number of remaining shares that can be bought or sold under this order
825     function _getRemainingSharesInOrder(Order storage _order) 
826     view
827     internal 
828     returns (uint) {
829         return _order.amount - _order.amountFilled;
830     }
831 
832     // Verifies if the order have _amount shares to buy/sell
833     // _amount > 0
834     function _verifyRemainingSharesInOrder(Order storage _order, uint _amount) 
835     view
836     internal {
837         require(_getRemainingSharesInOrder(_order) >= _amount);
838     }
839 
840     // Checks if the owner have at least '_amount' shares of the company
841     // _amount > 0
842     function _verifyOwnershipOfTokens(uint _companyId, address _owner, uint _amount) 
843     view
844     internal {
845         require(companies[_companyId].shareHolders.ownerAddressToShares[_owner] >= _amount);
846     }
847     
848     // Returns the length of array! All orders might not be active
849     function getNumberOfOrders(uint _companyId) 
850     view
851     external 
852     returns (uint numberOfOrders) {
853         numberOfOrders = companyIdToOrders[_companyId].length;
854     }
855 
856     function getOrderDetails(uint _comanyId, uint _orderIndex) 
857     view
858     external 
859     returns (address _owner,
860         uint _pricePerShare,
861         uint _amount,
862         uint _amountFilled,
863         OrderType _orderType) {
864             Order storage order =  companyIdToOrders[_comanyId][_orderIndex];
865             
866             _owner = order.owner;
867             _pricePerShare = order.pricePerShare;
868             _amount = order.amount;
869             _amountFilled = order.amountFilled;
870             _orderType = order.orderType;
871     }
872     
873     function withdrawBalance(address _address) 
874     onlyCLevel
875     external {
876         require(_address != 0x0);
877         uint balance = withdrawableBalance;
878         withdrawableBalance = 0;
879         _address.transfer(balance);
880     }
881     
882     // Only when the contract is paused and there is a subtle bug!
883     function kill(address _address) 
884     onlyCLevel
885     whenPaused
886     external {
887         require(_address != 0x0);
888         selfdestruct(_address);
889     }
890 }