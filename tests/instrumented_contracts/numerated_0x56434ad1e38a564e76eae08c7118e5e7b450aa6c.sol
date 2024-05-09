1 pragma solidity ^0.4.23;
2 
3 /*
4 * The Blockchain Football network presents....
5 * https://fantasyfootballfund.co/
6 * https://discord.gg/qPjA6Tx
7 *
8 * Build your fantasy player portfolio. Earn crypto daily based on player performance.
9 *
10 * 4 Ways to earn
11 * [1] Price Fluctuations - buy and sell at the right moments
12 * [2] Match day Divs - allocated to shareholders of top performing players every day
13 * [3] Fame Divs - allocated to shareholders of infamous players on non-match days
14 * [4] Original Owner - allocated to owners of original player cards on blockchainfootball.co (2% per share sold)
15 */
16 
17 contract ERC20 {
18     function totalSupply() public view returns (uint);
19     function balanceOf(address tokenOwner) public view returns (uint balance);
20     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
21     function transfer(address to, uint tokens) public returns (bool success);
22     function approve(address spender, uint tokens) public returns (bool success);
23     function transferFrom(address from, address to, uint tokens) public returns (bool success);
24 
25     event Transfer(address indexed from, address indexed to, uint tokens);
26     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
27 }
28 
29 contract PlayerToken is ERC20 {
30 
31     // Ownable
32     address public owner;
33     bool public paused = false;
34 
35     // Events
36     event PlayerTokenBuy(address indexed buyer, address indexed referrer, uint tokens, uint cost, string symbol);
37     event PlayerTokenSell(address indexed seller, uint tokens, uint value, string symbol);
38 
39     // Libs
40     using SafeMath for uint256;
41 
42     // Core token attributes
43     uint256 public initialTokenPrice_;  // Typically = 1 Finney (0.001 Ether)
44     uint256 public incrementalTokenPrice_; // Typically = 0.01 Finney (0.00001 Ether)
45 
46     // Token Properties - set via the constructor for each player
47     string public name;
48     string public symbol;
49     uint8 public constant decimals = 0;
50 
51     // Exchange Contract - used to hold the dividend pool across all ERC20 player contracts
52     // when shares are brought or sold the dividend fee gets transfered here
53     address public exchangeContract_;
54     
55     // Blockchainfootball.co attributes - if this is set the owner receieves a fee for owning the original card
56     BCFMain bcfContract_ = BCFMain(0x6abF810730a342ADD1374e11F3e97500EE774D1F);
57     uint256 public playerId_;
58     address public originalOwner_;
59 
60     // Fees - denoted in %
61     uint8 constant internal processingFee_ = 5; // inc. fees to cover DAILY gas usage to assign divs to token holders
62     uint8 constant internal originalOwnerFee_ = 2; // of all token buys per original player owned + set on blockchainfootball.co
63     uint8 internal dividendBuyPoolFee_ = 15; // buys AND sells go into the div pool to promote gameplay - can be updated
64     uint8 internal dividendSellPoolFee_ = 20;
65     uint8 constant internal referrerFee_ = 1; // for all token buys (but not sells)
66 
67     // ERC20 data structures
68     mapping(address => uint256) balances;
69     mapping(address => mapping (address => uint256)) internal allowed;
70 
71     // Player Exchange Data Structures
72     address[] public tokenHolders;
73     mapping(address => uint256) public addressToTokenHolderIndex; // Helps to gas-efficiently remove shareholders, by swapping last index
74     mapping(address => int256) public totalCost; // To hold the total expenditure of each address, profit tracking
75 
76     // ERC20 Properties
77     uint256 totalSupply_;
78 
79     // Additional accessors
80     modifier onlyOwner() {
81         require(msg.sender == owner);
82         _;
83     }
84 
85     modifier onlyOwnerOrExchange() {
86         require(msg.sender == owner || msg.sender == exchangeContract_);
87         _;
88     }
89 
90     modifier whenNotPaused() {
91         require(!paused);
92         _;
93     }
94 
95     modifier whenPaused() {
96         require(paused);
97         _;
98     }
99 
100     // Constructor
101     constructor(
102         string _name, 
103         string _symbol, 
104         uint _startPrice, 
105         uint _incrementalPrice, 
106         address _owner, 
107         address _exchangeContract, 
108         uint256 _playerId,
109         uint8 _promoSharesQuantity
110     ) 
111         public
112         payable
113     {
114         require(_exchangeContract != address(0));
115         require(_owner != address(0));
116 
117         exchangeContract_ = _exchangeContract;
118         playerId_ = _playerId;
119 
120         // Set initial starting exchange values
121         initialTokenPrice_ = _startPrice;
122         incrementalTokenPrice_ = _incrementalPrice; // In most cases this will be 1 finney, 0.001 ETH
123 
124         // Initial token properties
125         paused = true;
126         owner = _owner;
127         name = _name;
128         symbol = _symbol;
129 
130         // Purchase promotional player shares - we purchase initial shares (the same way users do) as prizes for promos/competitions/giveaways
131         if (_promoSharesQuantity > 0) {
132             _buyTokens(msg.value, _promoSharesQuantity, _owner, address(0));
133         }
134     }
135 
136     // **External Exchange**
137     function buyTokens(uint8 _amount, address _referredBy) payable external whenNotPaused {
138         require(_amount > 0 && _amount <= 100, "Valid token amount required between 1 and 100");
139         require(msg.value > 0, "Provide a valid fee"); 
140         // solium-disable-next-line security/no-tx-origin
141         require(msg.sender == tx.origin, "Only valid users are allowed to buy tokens"); 
142         _buyTokens(msg.value, _amount, msg.sender, _referredBy);
143     }
144 
145     function sellTokens(uint8 _amount) external {
146         require(_amount > 0, "Valid sell amount required");
147         require(_amount <= balances[msg.sender]);
148         _sellTokens(_amount, msg.sender);
149     }
150 
151     // **Internal Exchange**
152     function _buyTokens(uint _ethSent, uint8 _amount, address _buyer, address _referredBy) internal {
153         
154         uint _totalCost;
155         uint _processingFee;
156         uint _originalOwnerFee;
157         uint _dividendPoolFee;
158         uint _referrerFee;
159 
160         (_totalCost, _processingFee, _originalOwnerFee, _dividendPoolFee, _referrerFee) = calculateTokenBuyPrice(_amount);
161 
162         require(_ethSent >= _totalCost, "Invalid fee to buy tokens");
163 
164         // Send to original card owner if available
165         // If we don't have an original owner we move this fee into the dividend pool
166         if (originalOwner_ != address(0)) {
167             originalOwner_.transfer(_originalOwnerFee);
168         } else {
169             _dividendPoolFee = _dividendPoolFee.add(_originalOwnerFee);
170         }
171 
172         // Send to the referrer - if we don't have a referrer we move this fee into the dividend pool
173         if (_referredBy != address(0)) {
174             _referredBy.transfer(_referrerFee);
175         } else {
176             _dividendPoolFee = _dividendPoolFee.add(_referrerFee);
177         }
178 
179         // These will always be available
180         owner.transfer(_processingFee);
181         exchangeContract_.transfer(_dividendPoolFee);
182 
183         // Refund excess
184         uint excess = _ethSent.sub(_totalCost);
185         _buyer.transfer(excess);
186 
187         // Track ownership of token holders - only if this is the first time the user is buying these player shares
188         if (balanceOf(_buyer) == 0) {
189             tokenHolders.push(_buyer);
190             addressToTokenHolderIndex[_buyer] = tokenHolders.length - 1;
191         }
192         
193         // Provide users with the shares
194         _allocatePlayerTokensTo(_buyer, _amount);
195 
196         // Track costs
197         totalCost[_buyer] = totalCost[_buyer] + int256(_totalCost); // No need for safe maths here, just holds profit tracking
198 
199         // Event tracking
200         emit PlayerTokenBuy(_buyer, _referredBy, _amount, _totalCost, symbol);
201     }
202 
203     function _sellTokens(uint8 _amount, address _seller) internal {
204         
205         uint _totalSellerProceeds;
206         uint _processingFee;
207         uint _dividendPoolFee;
208 
209         (_totalSellerProceeds, _processingFee, _dividendPoolFee) = calculateTokenSellPrice(_amount);
210 
211         // Burn the sellers shares
212         _burnPlayerTokensFrom(_seller, _amount);
213 
214         // Track ownership of token holders if the user no longer has tokens let's remove them
215         // we do this semi-efficently by swapping the last index
216         if (balanceOf(_seller) == 0) {
217             removeFromTokenHolders(_seller);
218         }
219 
220         // Transfer to processor, seller and dividend pool
221         owner.transfer(_processingFee);
222         _seller.transfer(_totalSellerProceeds);
223         exchangeContract_.transfer(_dividendPoolFee);
224 
225         // Track costs
226         totalCost[_seller] = totalCost[_seller] - int256(_totalSellerProceeds); // No need for safe maths here, just holds profit tracking
227 
228         // Event tracking
229         emit PlayerTokenSell(_seller, _amount, _totalSellerProceeds, symbol);
230     }
231 
232     // **Calculations - these factor in all fees**
233     function calculateTokenBuyPrice(uint _amount) 
234         public 
235         view 
236         returns (
237         uint _totalCost, 
238         uint _processingFee, 
239         uint _originalOwnerFee, 
240         uint _dividendPoolFee, 
241         uint _referrerFee
242     ) {    
243         uint tokenCost = calculateTokenOnlyBuyPrice(_amount);
244 
245         // We now need to apply fees on top of this
246         // In all cases we apply fees - but if there's no original owner or referrer
247         // these go into the dividend pool
248         _processingFee = SafeMath.div(SafeMath.mul(tokenCost, processingFee_), 100);
249         _originalOwnerFee = SafeMath.div(SafeMath.mul(tokenCost, originalOwnerFee_), 100);
250         _dividendPoolFee = SafeMath.div(SafeMath.mul(tokenCost, dividendBuyPoolFee_), 100);
251         _referrerFee = SafeMath.div(SafeMath.mul(tokenCost, referrerFee_), 100);
252 
253         _totalCost = tokenCost.add(_processingFee).add(_originalOwnerFee).add(_dividendPoolFee).add(_referrerFee);
254     }
255 
256     function calculateTokenSellPrice(uint _amount) 
257         public 
258         view 
259         returns (
260         uint _totalSellerProceeds,
261         uint _processingFee,
262         uint _dividendPoolFee
263     ) {
264         uint tokenSellCost = calculateTokenOnlySellPrice(_amount);
265 
266         // We remove the processing and dividend fees on the final sell price
267         // this represents the difference between the buy and sell price on the UI
268         _processingFee = SafeMath.div(SafeMath.mul(tokenSellCost, processingFee_), 100);
269         _dividendPoolFee = SafeMath.div(SafeMath.mul(tokenSellCost, dividendSellPoolFee_), 100);
270 
271         _totalSellerProceeds = tokenSellCost.sub(_processingFee).sub(_dividendPoolFee);
272     }
273 
274     // **Calculate total cost of tokens without fees**
275     function calculateTokenOnlyBuyPrice(uint _amount) public view returns(uint) {
276         
277         // We use a simple arithmetic progression series, summing the incremental prices
278 	    // ((n / 2) * (2 * a + (n - 1) * d))
279 	    // a = starting value (1st term), d = price increment (diff.), n = amount of shares (no. of terms)
280 
281         // NOTE: we use a mutiplier to avoid issues with an odd number of shares, dividing and limited fixed point support in Solidity
282         uint8 multiplier = 10;
283         uint amountMultiplied = _amount * multiplier; 
284         uint startingPrice = initialTokenPrice_ + (totalSupply_ * incrementalTokenPrice_);
285         uint totalBuyPrice = (amountMultiplied / 2) * (2 * startingPrice + (_amount - 1) * incrementalTokenPrice_) / multiplier;
286 
287         // Should never *concievably* occur, but more effecient than Safemaths on the entire formula
288         assert(totalBuyPrice >= startingPrice); 
289         return totalBuyPrice;
290     }
291 
292     function calculateTokenOnlySellPrice(uint _amount) public view returns(uint) {
293         // Similar to calculateTokenBuyPrice, but we abs() the incrementalTokenPrice so we get a reverse arithmetic series
294         uint8 multiplier = 10;
295         uint amountMultiplied = _amount * multiplier; 
296         uint startingPrice = initialTokenPrice_ + ((totalSupply_-1) * incrementalTokenPrice_);
297         int absIncrementalTokenPrice = int(incrementalTokenPrice_) * -1;
298         uint totalSellPrice = uint((int(amountMultiplied) / 2) * (2 * int(startingPrice) + (int(_amount) - 1) * absIncrementalTokenPrice) / multiplier);
299         return totalSellPrice;
300     }
301 
302     // **UI Helpers**
303     function buySellPrices() public view returns(uint _buyPrice, uint _sellPrice) {
304         (_buyPrice,,,,) = calculateTokenBuyPrice(1);
305         (_sellPrice,,) = calculateTokenSellPrice(1);
306     }
307 
308     function portfolioSummary(address _address) public view returns(uint _tokenBalance, int _cost, uint _value) {
309         _tokenBalance = balanceOf(_address);
310         _cost = totalCost[_address];
311         (_value,,) = calculateTokenSellPrice(_tokenBalance);       
312     }
313 
314     function totalTokenHolders() public view returns(uint) {
315         return tokenHolders.length;
316     }
317 
318     function tokenHoldersByIndex() public view returns(address[] _addresses, uint[] _shares) {
319         
320         // This will only be called offchain to take snapshots of share count at cut off points for divs
321         uint tokenHolderCount = tokenHolders.length;
322         address[] memory addresses = new address[](tokenHolderCount);
323         uint[] memory shares = new uint[](tokenHolderCount);
324 
325         for (uint i = 0; i < tokenHolderCount; i++) {
326             addresses[i] = tokenHolders[i];
327             shares[i] = balanceOf(tokenHolders[i]);
328         }
329 
330         return (addresses, shares);
331     }
332 
333     // In cases where there's bugs in the exchange contract we need a way to re-point
334     function setExchangeContractAddress(address _exchangeContract) external onlyOwner {
335         exchangeContract_ = _exchangeContract;
336     }
337 
338     // **Blockchainfootball.co Support**
339     function setBCFContractAddress(address _address) external onlyOwner {
340         BCFMain candidateContract = BCFMain(_address);
341         require(candidateContract.implementsERC721());
342         bcfContract_ = candidateContract;
343     }
344 
345     function setPlayerId(uint256 _playerId) external onlyOwner {
346         playerId_ = _playerId;
347     }
348 
349     function setSellDividendPercentageFee(uint8 _dividendPoolFee) external onlyOwnerOrExchange {
350         // We'll need some flexibility to alter this as the right dividend structure helps promote gameplay
351         // This pushes users to buy players who are performing well to grab divs rather than just getting in early to new players being released
352         require(_dividendPoolFee <= 50, "Max of 50% is assignable to the pool");
353         dividendSellPoolFee_ = _dividendPoolFee;
354     }
355 
356     function setBuyDividendPercentageFee(uint8 _dividendPoolFee) external onlyOwnerOrExchange {
357         require(_dividendPoolFee <= 50, "Max of 50% is assignable to the pool");
358         dividendBuyPoolFee_ = _dividendPoolFee;
359     }
360 
361     // Can be called by anyone, in which case we could use a another contract to set the original owner whenever it changes on blockchainfootball.co
362     function setOriginalOwner(uint256 _playerCardId, address _address) external {
363         require(playerId_ > 0, "Player ID must be set on the contract");
364         
365         // As we call .transfer() on buys to send original owners divs we need to make sure this can't be DOS'd through setting the
366         // original owner as a smart contract and then reverting any transfer() calls
367         // while it would be silly to reject divs it is a valid DOS scenario
368         // solium-disable-next-line security/no-tx-origin
369         require(msg.sender == tx.origin, "Only valid users are able to set original ownership"); 
370        
371         address _cardOwner;
372         uint256 _playerId;
373         bool _isFirstGeneration;
374 
375         (_playerId,_cardOwner,,_isFirstGeneration) = bcfContract_.playerCards(_playerCardId);
376 
377         require(_isFirstGeneration, "Card must be an original");
378         require(_playerId == playerId_, "Card must tbe the same player this contract relates to");
379         require(_cardOwner == _address, "Card must be owned by the address provided");
380         
381         // All good, set the address as the original owner, happy div day \o/
382         originalOwner_ = _address;
383     }
384 
385     // ** Internal Token Handling - validation completed by callers **
386     function _allocatePlayerTokensTo(address _to, uint256 _amount) internal {
387         totalSupply_ = totalSupply_.add(_amount);
388         balances[_to] = balances[_to].add(_amount);
389         emit Transfer(address(0), _to, _amount);
390     }
391 
392     function _burnPlayerTokensFrom(address _from, uint256 _amount) internal {
393         balances[_from] = balances[_from].sub(_amount);
394         totalSupply_ = totalSupply_.sub(_amount);
395         emit Transfer(_from, address(0), _amount);
396     }
397 
398     function removeFromTokenHolders(address _seller) internal {
399         
400         uint256 tokenIndex = addressToTokenHolderIndex[_seller];
401         uint256 lastAddressIndex = tokenHolders.length.sub(1);
402         address lastAddress = tokenHolders[lastAddressIndex];
403         
404         tokenHolders[tokenIndex] = lastAddress;
405         tokenHolders[lastAddressIndex] = address(0);
406         tokenHolders.length--;
407 
408         addressToTokenHolderIndex[lastAddress] = tokenIndex;
409     }
410 
411     // ** ERC20 Support **
412     function totalSupply() public view returns (uint256) {
413         return totalSupply_;
414     }
415 
416     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
417         require(_to != address(0));
418         require(_value > 0);
419         require(_value <= balances[msg.sender]);
420 
421         // Track ownership of token holders - only if this is the first time the user is buying these player shares
422         if (balanceOf(_to) == 0) {
423             tokenHolders.push(_to);
424             addressToTokenHolderIndex[_to] = tokenHolders.length - 1;
425         }
426 
427         balances[msg.sender] = balances[msg.sender].sub(_value);
428         balances[_to] = balances[_to].add(_value);
429 
430         // Track ownership of token holders if the user no longer has tokens let's remove them
431         // we do this semi-efficently by swapping the last index
432         if (balanceOf(msg.sender) == 0) {
433             removeFromTokenHolders(msg.sender);
434         }
435 
436         emit Transfer(msg.sender, _to, _value);
437         return true;
438     }
439 
440     function balanceOf(address _owner) public view returns (uint256) {
441         return balances[_owner];
442     }
443 
444     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
445         require(_to != address(0));
446         require(_value > 0);
447         require(_value <= balances[_from]);
448         require(_value <= allowed[_from][msg.sender]);
449 
450         // Track ownership of token holders - only if this is the first time the user is buying these player shares
451         if (balanceOf(_to) == 0) {
452             tokenHolders.push(_to);
453             addressToTokenHolderIndex[_to] = tokenHolders.length - 1;
454         }
455 
456         balances[_from] = balances[_from].sub(_value);
457         balances[_to] = balances[_to].add(_value);
458         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
459 
460         // Track ownership of token holders if the user no longer has tokens let's remove them
461         // we do this semi-efficently by swapping the last index
462         if (balanceOf(_from) == 0) {
463             removeFromTokenHolders(_from);
464         }
465 
466         emit Transfer(_from, _to, _value);
467         return true;
468     }
469 
470     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
471         allowed[msg.sender][_spender] = _value;
472         emit Approval(msg.sender, _spender, _value);
473         return true;
474     }
475 
476     function allowance(address _owner, address _spender) public view returns (uint256){
477         return allowed[_owner][_spender];
478     }
479 
480     // Utilities
481     function setOwner(address newOwner) public onlyOwner {
482         require(newOwner != address(0));
483         owner = newOwner;
484     }
485 
486     function pause() onlyOwnerOrExchange whenNotPaused public {
487         paused = true;
488     }
489 
490     function unpause() onlyOwnerOrExchange whenPaused public {
491         paused = false;
492     }
493 }
494 
495 contract BCFMain {
496     function playerCards(uint256 playerCardId) public view returns (uint256 playerId, address owner, address approvedForTransfer, bool isFirstGeneration);
497     function implementsERC721() public pure returns (bool);
498 }
499 
500 library SafeMath {
501 
502     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
503         if (a == 0) {
504             return 0;
505         }
506         c = a * b;
507         assert(c / a == b);
508         return c;
509     }
510 
511     function div(uint256 a, uint256 b) internal pure returns (uint256) {
512         return a / b;
513     }
514 
515     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
516         assert(b <= a);
517         return a - b;
518     }
519 
520     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
521         c = a + b;
522         assert(c >= a);
523         return c;
524     }
525 }
526 
527 contract PlayerExchangeCore {
528 
529     // Events
530     event InitialPlayerOffering(address indexed contractAddress, string name, string symbol);
531     event DividendWithdrawal(address indexed user, uint amount);
532 
533     // Libs
534     using SafeMath for uint256;
535 
536     // Ownership
537     address public owner;
538     address public referee; // Used to pay out divs and initiate an IPO
539 
540     // Structs
541     struct DividendWinner {
542         uint playerTokenContractId;
543         uint perTokenEthValue;
544         uint totalTokens;
545         uint tokensProcessed; // So we can determine when all tokens have been allocated divs + settled
546     }
547 
548     // State management
549     uint internal balancePendingWithdrawal_; // this.balance - balancePendingWithdrawal_ = div prize pool
550 
551     // Data Store
552     PlayerToken[] public playerTokenContracts_; // Holds a list of all player token contracts
553     DividendWinner[] public dividendWinners_; // Holds a list of dividend winners (player contract id's, not users)
554     mapping(address => uint256) public addressToDividendBalance;
555 
556     // Modifiers
557     modifier onlyOwner() {
558         require(msg.sender == owner);
559         _;
560     }
561 
562     modifier onlyReferee() {
563         require(msg.sender == referee);
564         _;
565     }
566 
567     modifier onlyOwnerOrReferee() {
568         require(msg.sender == owner || msg.sender == referee);
569         _;
570     }
571 
572     function setOwner(address newOwner) public onlyOwner {
573         require(newOwner != address(0));
574         owner = newOwner;
575     }
576 
577     function setReferee(address newReferee) public onlyOwner {
578         require(newReferee != address(0));
579         referee = newReferee;
580     }
581 
582     constructor(address _owner, address _referee) public {
583         owner = _owner;
584         referee = _referee;
585     }
586 
587     // Create new instances of a PlayerToken contract and pass along msg.value (so the referee pays and not the contract)
588     function newInitialPlayerOffering(
589         string _name, 
590         string _symbol, 
591         uint _startPrice, 
592         uint _incrementalPrice, 
593         address _owner,
594         uint256 _playerId,
595         uint8 _promoSharesQuantity
596     ) 
597         external 
598         onlyOwnerOrReferee
599         payable
600     {
601         PlayerToken playerTokenContract = (new PlayerToken).value(msg.value)(
602             _name, 
603             _symbol, 
604             _startPrice, 
605             _incrementalPrice, 
606             _owner, 
607             address(this), 
608             _playerId, 
609             _promoSharesQuantity
610         );
611 
612         // Add it to a local storage so we can iterate over it to pull portfolio stats
613         playerTokenContracts_.push(playerTokenContract);
614 
615         // Event handling
616         emit InitialPlayerOffering(address(playerTokenContract), _name, _symbol);
617     }
618 
619     // Empty fallback - any Ether here just goes straight into the Dividend pool
620     // this is useful as it provides a mechanism for the other blockchain football games
621     // to top the fund up for special events / promotions
622     function() payable public { }
623 
624     function getTotalDividendPool() public view returns (uint) {
625         return address(this).balance.sub(balancePendingWithdrawal_);
626     }
627 
628     function totalPlayerTokenContracts() public view returns (uint) {
629         return playerTokenContracts_.length;
630     }
631 
632     function totalDividendWinners() public view returns (uint) {
633         return dividendWinners_.length;
634     }
635 
636     // Called off-chain to manage UI state so no gas concerns - also never likely to be more than 50-200ish player contracts
637     function allPlayerTokenContracts() external view returns (address[]) {
638         uint playerContractCount = totalPlayerTokenContracts();
639         address[] memory addresses = new address[](playerContractCount);
640 
641         for (uint i = 0; i < playerContractCount; i++) {
642             addresses[i] = address(playerTokenContracts_[i]);
643         }
644 
645         return addresses;
646     }
647 
648     /* Safeguard function to quickly pause a stack of contracts */
649     function pausePlayerContracts(uint startIndex, uint endIndex) onlyOwnerOrReferee external {
650         for (uint i = startIndex; i < endIndex; i++) {
651             PlayerToken playerTokenContract = playerTokenContracts_[i];
652             if (!playerTokenContract.paused()) {
653                 playerTokenContract.pause();
654             }
655         }
656     }
657 
658     function unpausePlayerContracts(uint startIndex, uint endIndex) onlyOwnerOrReferee external {
659         for (uint i = startIndex; i < endIndex; i++) {
660             PlayerToken playerTokenContract = playerTokenContracts_[i];
661             if (playerTokenContract.paused()) {
662                 playerTokenContract.unpause();
663             }
664         }
665     }
666 
667     function setSellDividendPercentageFee(uint8 _fee, uint startIndex, uint endIndex) onlyOwner external {
668         for (uint i = startIndex; i < endIndex; i++) {
669             PlayerToken playerTokenContract = playerTokenContracts_[i];
670             playerTokenContract.setSellDividendPercentageFee(_fee);
671         }
672     }
673 
674     function setBuyDividendPercentageFee(uint8 _fee, uint startIndex, uint endIndex) onlyOwner external {
675         for (uint i = startIndex; i < endIndex; i++) {
676             PlayerToken playerTokenContract = playerTokenContracts_[i];
677             playerTokenContract.setBuyDividendPercentageFee(_fee);
678         }
679     }
680 
681     /* Portfolio Support */
682     // Only called offchain - so we can omit additional pagination/optimizations here
683     function portfolioSummary(address _address) 
684         external 
685         view 
686     returns (
687         uint[] _playerTokenContractId, 
688         uint[] _totalTokens, 
689         int[] _totalCost, 
690         uint[] _totalValue) 
691     {
692         uint playerContractCount = totalPlayerTokenContracts();
693 
694         uint[] memory playerTokenContractIds = new uint[](playerContractCount);
695         uint[] memory totalTokens = new uint[](playerContractCount);
696         int[] memory totalCost = new int[](playerContractCount);
697         uint[] memory totalValue = new uint[](playerContractCount);
698 
699         PlayerToken playerTokenContract;
700 
701         for (uint i = 0; i < playerContractCount; i++) {
702             playerTokenContract = playerTokenContracts_[i];
703             playerTokenContractIds[i] = i;
704             (totalTokens[i], totalCost[i], totalValue[i]) = playerTokenContract.portfolioSummary(_address);
705         }
706 
707         return (playerTokenContractIds, totalTokens, totalCost, totalValue);
708     }
709 
710     /* Dividend Handling */
711     // These are all handled based on their corresponding index
712     // Takes a snapshot of the current dividend pool balance and allocates a per share div award
713     function setDividendWinners(
714         uint[] _playerContractIds, 
715         uint[] _totalPlayerTokens, 
716         uint8[] _individualPlayerAllocationPcs, 
717         uint _totalPrizePoolAllocationPc
718     ) 
719         external 
720         onlyOwnerOrReferee 
721     {
722         require(_playerContractIds.length > 0, "Must have valid player contracts to award divs to");
723         require(_playerContractIds.length == _totalPlayerTokens.length);
724         require(_totalPlayerTokens.length == _individualPlayerAllocationPcs.length);
725         require(_totalPrizePoolAllocationPc > 0);
726         require(_totalPrizePoolAllocationPc <= 100);
727         
728         // Calculate how much dividends we have allocated
729         uint dailyDivPrizePool = SafeMath.div(SafeMath.mul(getTotalDividendPool(), _totalPrizePoolAllocationPc), 100);
730 
731         // Iteration here should be fine as there should concievably only ever be 3 or 4 winning players each day
732         uint8 totalPlayerAllocationPc = 0;
733         for (uint8 i = 0; i < _playerContractIds.length; i++) {
734             totalPlayerAllocationPc += _individualPlayerAllocationPcs[i];
735 
736             // Calculate from the total daily pool how much is assigned to owners of this player
737             // e.g. a typical day might = Total Dividend pool: 100 ETH, _totalPrizePoolAllocationPc: 20 (%)
738             // therefore the total dailyDivPrizePool = 20 ETH
739             // Which could be allocated as follows
740             // 1. 50% MVP Player - (Attacker) (10 ETH total)
741             // 2. 25% Player - (Midfielder) (5 ETH total)
742             // 3. 25% Player - (Defender) (5 ETH total)
743             uint playerPrizePool = SafeMath.div(SafeMath.mul(dailyDivPrizePool, _individualPlayerAllocationPcs[i]), 100);
744 
745             // Calculate total div-per-share
746             uint totalPlayerTokens = _totalPlayerTokens[i];
747             uint perTokenEthValue = playerPrizePool.div(totalPlayerTokens);
748 
749             // Add to the winners array so it can then be picked up by the div payment processor
750             DividendWinner memory divWinner = DividendWinner({
751                 playerTokenContractId: _playerContractIds[i],
752                 perTokenEthValue: perTokenEthValue,
753                 totalTokens: totalPlayerTokens,
754                 tokensProcessed: 0
755             });
756 
757             dividendWinners_.push(divWinner);
758         }
759 
760         // We need to make sure we are allocating a valid set of dividend totals (i.e. not more than 100%)
761         // this is just to cover us for basic errors, this should never occur
762         require(totalPlayerAllocationPc == 100);
763     }
764 
765     function allocateDividendsToWinners(uint _dividendWinnerId, address[] _winners, uint[] _tokenAllocation) external onlyOwnerOrReferee {
766         DividendWinner storage divWinner = dividendWinners_[_dividendWinnerId];
767         require(divWinner.totalTokens > 0); // Basic check to make sure we don't access a 0'd struct
768         require(divWinner.tokensProcessed < divWinner.totalTokens);
769         require(_winners.length == _tokenAllocation.length);
770 
771         uint totalEthAssigned;
772         uint totalTokensAllocatedEth;
773         uint ethAllocation;
774         address winner;
775 
776         for (uint i = 0; i < _winners.length; i++) {
777             winner = _winners[i];
778             ethAllocation = _tokenAllocation[i].mul(divWinner.perTokenEthValue);
779             addressToDividendBalance[winner] = addressToDividendBalance[winner].add(ethAllocation);
780             totalTokensAllocatedEth = totalTokensAllocatedEth.add(_tokenAllocation[i]);
781             totalEthAssigned = totalEthAssigned.add(ethAllocation);
782         }
783 
784         // Update balancePendingWithdrawal_ - this allows us to get an accurate reflection of the div pool
785         balancePendingWithdrawal_ = balancePendingWithdrawal_.add(totalEthAssigned);
786 
787         // As we will likely cause this function in batches this allows us to make sure we don't oversettle (failsafe)
788         divWinner.tokensProcessed = divWinner.tokensProcessed.add(totalTokensAllocatedEth);
789 
790         // This should never occur, but a failsafe for when automated div payments are rolled out
791         require(divWinner.tokensProcessed <= divWinner.totalTokens);
792     }
793 
794     function withdrawDividends() external {
795         require(addressToDividendBalance[msg.sender] > 0, "Must have a valid dividend balance");
796         uint senderBalance = addressToDividendBalance[msg.sender];
797         addressToDividendBalance[msg.sender] = 0;
798         balancePendingWithdrawal_ = balancePendingWithdrawal_.sub(senderBalance);
799         msg.sender.transfer(senderBalance);
800         emit DividendWithdrawal(msg.sender, senderBalance);
801     }
802 }