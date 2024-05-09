1 pragma solidity ^0.4.2;
2 
3 /**************************************
4  * @title ERC721
5  * @dev ethereum "standard" interface
6  **************************************/ 
7 contract ERC721 {
8     event Transfer(address _from, address _to, uint256 _tokenId);
9     event Approval(address _owner, address _approved, uint256 _tokenId);
10     
11     function balanceOf(address _owner) public view returns (uint256 _balance);
12     function ownerOf(uint256 _tokenId) public view returns (address _owner);
13     function transfer(address _to, uint256 _tokenId) public;
14     function approve(address _to, uint256 _tokenId) public;
15     function transferFrom(address _from, address _to, uint256 _tokenId) public;
16     function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);
17     function totalSupply() constant returns (uint256 totalSupply);
18     
19     function tokenMetadata(uint256 _tokenId) constant returns (string infoUrl);
20     
21     function name() constant returns (string name);
22     function symbol() constant returns (string symbol);
23 }
24 
25 /**************************************
26  * @title Ownable
27  * @dev The Ownable contract has an owner address, and provides basic authorization control
28  * functions, this simplifies the implementation of "user permissions".
29  **************************************/ 
30 contract Ownable {
31   address public owner;
32 
33 event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34 
35   function Ownable() public {
36     owner = msg.sender;
37   }
38 
39   modifier onlyOwner() {
40     require(msg.sender == owner);
41     _;
42   }
43 
44   function transferOwnership(address newOwner) public onlyOwner {
45     require(newOwner != address(0));
46     OwnershipTransferred(owner, newOwner);
47     owner = newOwner;
48   }
49 }
50 
51 /**************************************
52  * @title Config
53  * @dev all necessary setups for contracts
54  **************************************/ 
55 contract Config is Ownable {
56     event Setup(uint8 _patchVersion, uint256 _cardPrice, uint8 _percentage1, uint8 _percentage2);
57     event Gift(uint256 _count, address _from, address _to);
58     uint256 internal randomNonce = 0;
59     uint256 internal cardPrice = 0;
60     uint256 internal patchTimestamp;
61     uint8   internal patchVersion = 0;
62     uint8   internal level = 1;
63     uint32  internal constantTime = (6048 * 100) + 1; // 7 days
64     uint8   internal percentage1 = 60;
65     uint8   internal percentage2 = 80;
66     uint8   internal auctionMarge = 5;
67     uint128  internal levelUp = 8 * 10 ** 15; // 0.008 ether + levelUp
68     uint128 internal levelUpVIP =4 * 10 **15; // 0.004 ether
69 	uint128 internal VIPCost = 99 * 10 ** 16; // 0.99 ether
70 	string internal URL = "https://www.etherchicks.com/card/";
71     
72 
73    struct User{
74         uint256 gifts;
75         bool vip;
76         bool exists;
77     }
78     mapping (address => User) userProfile;
79     
80     function giftFor(address _from, address _target, uint256 _count) internal{
81         uint256 giftCount = _count;
82         if(userProfile[_target].exists)
83         {
84             if(userProfile[_target].vip)
85             {
86                 giftCount += 1;
87             }
88             userProfile[_target].gifts += giftCount;
89             Gift(giftCount, _from, _target);
90         }
91     }
92     
93     function setUser(address _id, address _target, bool _vip) internal
94     {
95         if(!userProfile[_id].exists){
96             giftFor(_id, _target, 1);
97             
98             User memory user = User(
99                0,
100                _vip,
101                true
102             );
103             userProfile[_id] = user;
104         }
105         else if(_vip == true){
106            userProfile[_id].vip = _vip; 
107         }
108         
109         
110     }
111     
112     function getUser(address _id) external view returns (uint256 Gifts, bool VIP, bool Exists)
113     {
114         return (userProfile[_id].gifts, userProfile[_id].vip, userProfile[_id].exists);
115     }
116     
117     mapping (address => uint8) participant;
118     mapping (uint8 => address) participantIndex;
119     uint8 internal numberOfParticipants = 0;
120     
121     function setPatch(uint256 _cardPrice, uint8 _percentage1, uint8 _percentage2) public onlyOwner {
122         patchVersion++;
123         cardPrice = _cardPrice;
124         patchTimestamp = now;
125         
126         if(_percentage1 != 0 && _percentage2 != 0){
127             percentage1 = _percentage1;
128             percentage2 = _percentage2;
129         }
130         
131         Setup(patchVersion, cardPrice, percentage1, percentage2);
132     }
133     
134       function percentage(uint256 cost, uint8 _percentage) internal pure returns(uint256)
135       {
136           require(_percentage < 100);
137           return (cost * _percentage) / 100;
138       }
139       
140       function setACmarge(uint8 _auctionMarge) external onlyOwner {
141           auctionMarge = _auctionMarge;
142       }
143       function setUrl(string _url) external onlyOwner {
144           URL = _url;
145       }
146     
147     function addParticipant(address _participant, uint8 _portion) external onlyOwner {
148         participantIndex[numberOfParticipants] = _participant;
149         participant[_participant] = _portion;
150         numberOfParticipants++;
151     }
152     function removeParticipant(uint8 _index) external onlyOwner
153     {
154         delete participant[participantIndex[_index]];
155         delete participantIndex[_index];
156         numberOfParticipants--;
157     }
158     function getAllParticipants() external view onlyOwner returns(address[], uint8[]) {
159         address[] memory addresses = new address[](numberOfParticipants);
160         uint8[] memory portions   = new uint8[](numberOfParticipants);
161         for(uint8 i=0; i<numberOfParticipants; i++)
162         {
163             addresses[i] =participantIndex[i];
164             portions[i] = participant[participantIndex[i]];
165         }
166         return (addresses, portions);
167     }
168     
169     
170 }
171 
172 /**************************************
173  * @title CardCore
174  * @dev this contract contains basic definition of cards and also 
175  * generates new cards
176  **************************************/
177 contract CardCore is Config {
178 
179     event Birth(address userAddress, uint256 cardId, uint256 code, uint8 level, uint8 patch);
180     event Update(address userAddress, uint256 cardId, uint8 level);
181     event VIP(address userAddress);
182 
183     // one card is defined single uint256
184     struct Card{
185         uint256 code;
186         uint8 level;
187         uint8 patch;
188     }
189 
190     Card[] public cards;
191 
192     // standard mapping
193     mapping (uint256 => address) cardToOwner;
194     mapping (address => uint256) ownerCardCount;
195 
196     modifier cardOwner(uint256 _cardId) {
197         require(msg.sender == cardToOwner[_cardId]);
198         _;
199     }
200     
201 
202     function _generateCode(address _userAddress, uint256 _blockNr) internal returns (uint256){
203         randomNonce++;
204         uint256 newCode = uint256(keccak256(_userAddress, _blockNr, randomNonce));
205         return newCode;
206     }
207     
208     function _updateCard(address _userAddress, uint256 _cardId) internal{
209         require(_owns(_userAddress, _cardId));
210         Card storage storedCard = cards[_cardId];
211         if(storedCard.level < 9)
212         {
213             storedCard.level++;
214             // raise event Updated
215             Update(_userAddress, _cardId, storedCard.level);
216         }
217     }
218     
219     function _beingVIP(address _userAddress) internal{
220         setUser(msg.sender, address(0), true);
221         VIP(_userAddress);
222     }
223     
224     function _owns(address _userAddress, uint256 _cardId) internal view returns (bool) {
225         return cardToOwner[_cardId] == _userAddress;
226     }
227     
228     function _getCards(uint8 numberOfCards, address _userAddress) internal{
229         // number of card in pack must be higher as 0
230         require(numberOfCards > 0);
231         require(numberOfCards < 11);
232         // init local variable
233         uint256 cardId;
234         uint256 cardCode;
235         Card memory c;
236         uint256 _blockNr = uint256(keccak256(block.blockhash(block.number-1)));
237         for(uint8 i = 0; i < numberOfCards; i++)
238         {
239             cardCode = _generateCode(_userAddress, _blockNr);
240             c = Card(cardCode, level, patchVersion);
241             cardId = cards.push(c) - 1;
242             
243             // association id to address
244             cardToOwner[cardId] = _userAddress;
245             ownerCardCount[_userAddress]++;
246             // raise event Birth
247             Birth(_userAddress, cardId, cardCode, level, patchVersion);
248         }
249     }
250 
251 
252 }
253 
254 
255 /**************************************
256  * @title CardOwnership
257  * @dev erc721 compatible provides function from inherited interface
258  **************************************/
259  
260 contract CardOwnership is CardCore, ERC721 {
261 
262     /// @notice Name and symbol of the non fungible token, as defined in ERC721.
263 
264     mapping (uint256 => address) cardApprovals;
265 	/// internal, private
266 
267     
268     function _transfer(address _from, address _to, uint256 _tokenId) internal {
269         ownerCardCount[_to]++;
270         // transfer ownership
271         cardToOwner[_tokenId] = _to;
272 
273         ownerCardCount[_from]--;
274         // clear any previously approved ownership exchange
275         
276         delete cardApprovals[_tokenId];
277        
278         // Emit the transfer event.
279         Transfer(_from, _to, _tokenId);
280     }
281 
282     function balanceOf(address _owner) public view returns (uint256 count) {
283         return ownerCardCount[_owner];
284     }
285 
286     function transfer(address _to, uint256 _tokenId) public cardOwner(_tokenId)
287     {
288         // no init address no contract address
289         require(_to != address(0));
290         require(_to != address(this));
291         require(cardApprovals[_tokenId] == address(0));
292 
293         // Reassign ownership, clear pending approvals, emit Transfer event.
294         _transfer(msg.sender, _to, _tokenId);
295     }
296       function name() constant returns (string name){
297         return "Etherchicks";
298       }
299        function symbol() constant returns (string symbol){
300         return "ETCS";
301       }
302       
303   
304     // Only an owner can grant transfer approval.
305     function approve(address _to, uint256 _tokenId) public cardOwner(_tokenId) 
306     {
307         // Register the approval (replacing any previous approval).
308         cardApprovals[_tokenId] = _to;
309         Approval(msg.sender, _to, _tokenId);
310     }
311 
312 
313     /// return all erc721 ents unit
314     function totalSupply() public view returns (uint) {
315         return cards.length - 1;
316     }
317 
318     function ownerOf(uint256 _tokenId)
319         public
320         view
321         returns (address _owner)
322     {
323         return cardToOwner[_tokenId];
324     }
325     
326       function transferFrom(
327         address _from,
328         address _to,
329         uint256 _tokenId
330     )
331         public
332     {       
333         require(_to != address(0));
334         require(_to != address(this));
335         require(cardApprovals[_tokenId] == address(this));
336 
337         // Reassign ownership (also clears pending approvals and emits Transfer event).
338         _transfer(_from, _to, _tokenId);
339     }
340 
341     /// expensive call count of all tokens per owner
342     function tokensOfOwner(address _owner) external view returns(uint256[] ownerTokens) {
343         uint256 tokenCount = balanceOf(_owner);
344 
345         if (tokenCount == 0) {
346             // Return an empty array
347             return new uint256[](0);
348         } else {
349             uint256[] memory result = new uint256[](tokenCount);
350             uint256 totalCards = totalSupply();
351             uint256 resultIndex = 0;
352 
353             // We count on the fact that all cats have IDs starting at 1 and increasing
354             // sequentially up to the totalCat count.
355             uint256 tokId;
356 
357             for (tokId = 1; tokId <= totalCards ; tokId++) {
358                 if (cardToOwner[tokId] == _owner) {
359                     result[resultIndex] = tokId;
360                     resultIndex++;
361                 }
362             }
363 
364             return result;
365         }
366     }
367     function appendUintToString(string inStr, uint256 v) constant internal returns (string str) {
368         uint maxlength = 100;
369         bytes memory reversed = new bytes(maxlength);
370         uint i = 0;
371         while (v != 0) {
372             uint remainder = v % 10;
373             v = v / 10;
374             reversed[i++] = byte(48 + remainder);
375         }
376         bytes memory inStrb = bytes(inStr);
377         bytes memory s = new bytes(inStrb.length + i + 1);
378         uint j;
379         for (j = 0; j < inStrb.length; j++) {
380             s[j] = inStrb[j];
381         }
382         for (j = 0; j <= i; j++) {
383             s[j + inStrb.length] = reversed[i - j];
384         }
385         str = string(s);
386         return str;
387     }
388     
389     function tokenMetadata(uint256 _tokenId) constant returns (string infoUrl) 
390     {
391         return appendUintToString(URL, _tokenId);
392     }
393     
394 
395 }
396 
397 /**************************************
398  * @title AuctionHouse
399  * @dev provides simple auction of NFT tokens
400  **************************************/
401 contract AuctionHouse is CardOwnership {
402     
403     event AuctionStarted(uint256 tokenId, uint128 startPrice, uint128 finalPrice, uint256 timestamp);
404     event AuctionEnded(address winner, uint256 tokenId);
405     struct Auction {
406         address seller;
407         uint128 startPrice;
408         uint128 finalPrice;
409         uint256 timestamp;
410     }
411     mapping (uint256 => Auction) public tokenIdToAuction;
412 	// max auction time for token is 7 days..
413       
414     function _isAuctionAble(uint256 _timestamp) internal view returns(bool)
415     {
416        return (_timestamp + constantTime >= now);
417     }
418   
419     function createAuction(
420         uint256 _tokenId,
421         uint128 _startPrice,
422         uint128 _finalPrice
423     ) external cardOwner(_tokenId){
424 	    require(!_isAuctionAble(tokenIdToAuction[_tokenId].timestamp));
425         // then approve for this
426         approve( this, _tokenId);
427          
428         Auction memory auction = Auction(
429             msg.sender,
430             _startPrice,
431             _finalPrice,
432             now
433         );
434         
435         tokenIdToAuction[_tokenId] = auction;
436         AuctionStarted(_tokenId, _startPrice, _finalPrice, now);
437     }
438 	
439     function buyout(uint256 _tokenId) external payable {
440         Auction storage auction = tokenIdToAuction[_tokenId];
441         
442         require(_isAuctionAble(auction.timestamp));
443         
444         uint256 price = _currentPrice(auction);
445         
446         require(msg.value >= price);
447         
448         address seller = tokenIdToAuction[_tokenId].seller;
449         
450         uint256 auctionCost = percentage(msg.value, auctionMarge); 
451         
452         _removeAuction(_tokenId);
453         //send money to seller
454          seller.transfer(msg.value - auctionCost);
455          // do transfer token
456         transferFrom(seller, msg.sender, _tokenId);
457         AuctionEnded(msg.sender, _tokenId);
458 
459     }
460     
461     function _currentPrice(Auction storage _auction)
462         internal
463         view
464         returns (uint256)
465     {
466         uint256 secondsPassed = 0;
467 
468         if (now > _auction.timestamp) {
469             secondsPassed = now - _auction.timestamp;
470         }
471 
472         return _computeCurrentPrice(
473             _auction.startPrice,
474             _auction.finalPrice,
475             secondsPassed,
476             constantTime
477         );
478     }
479     function _computeCurrentPrice(
480         uint256 _startingPrice,
481         uint256 _endingPrice,
482         uint256 _secondsPassed,
483         uint32 _sevenDays
484     )
485         internal
486         pure
487         returns (uint256)
488     {
489     
490         if (_secondsPassed >= _sevenDays) {
491             return _endingPrice;
492         } 
493         else 
494         {
495             int256 totalPriceChange = int256(_endingPrice) - int256(_startingPrice);
496             int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_sevenDays);
497             int256 currentPrice = int256(_startingPrice) + currentPriceChange;
498 
499             return uint256(currentPrice);
500         }
501     }
502 
503 
504 	function cancelAuction(uint256 _tokenId)
505         external cardOwner(_tokenId)
506     {
507         Auction storage auction = tokenIdToAuction[_tokenId];
508         require(auction.timestamp > 0);
509         require(msg.sender == auction.seller);
510         
511         _removeAuction(_tokenId);
512         delete cardApprovals[_tokenId];
513         AuctionEnded(address(0), _tokenId);
514     }
515 
516     function _removeAuction(uint256 _tokenId) internal {
517         delete tokenIdToAuction[_tokenId];
518     }
519     function getCurrentPrice(uint256 _tokenId)
520         external
521         view
522         returns (uint256)
523     {
524         Auction storage auction = tokenIdToAuction[_tokenId];
525         require(_isAuctionAble(auction.timestamp));
526         return _currentPrice(auction);
527     }
528 
529 
530 }
531 
532 
533 /**************************************
534  * @title Etherchicks
535  * @dev call constructor, implements payable mechanism
536  **************************************/
537 contract Etherchicks is AuctionHouse {
538       
539     function Etherchicks() public {
540         // init setup #1
541        setPatch(3 * 10 ** 16,  0, 0 );
542        _beingVIP(msg.sender);
543     }
544 
545     function getCard(uint256 _id)
546         external
547         view
548         returns (
549         uint256 code,
550         uint8  level,
551         uint8   patch
552     ) {               
553         Card storage card = cards[_id];
554         code = uint256(card.code);
555         level = uint8(card.level);
556         patch = uint8(card.patch);
557         
558     }
559     function _calculateDiscount(uint8 _nr, address _user) internal view returns (uint256){       
560       uint256 _cardPrice = cardPrice * _nr;      
561       if(uint256(constantTime + patchTimestamp) >= now)
562       {
563           _cardPrice = percentage(_cardPrice, percentage1);
564       }
565       else if(uint256((constantTime * 2) + patchTimestamp) >= now)
566       {
567           _cardPrice = percentage(_cardPrice, percentage2);
568       }    
569       
570       if(userProfile[_user].exists && userProfile[_user].vip)
571       {
572           _cardPrice = percentage(_cardPrice, 50);
573       }
574       return _cardPrice;
575   }
576      
577     function getMarketPrice(uint8 _nr) external view returns(uint256){
578         return _calculateDiscount(_nr, msg.sender);
579     }  
580   function buyCardsAndSendGift(uint8 _nr, address _referral) external payable{
581       require(_calculateDiscount(_nr, msg.sender) <= msg.value);
582         _getCards(_nr, msg.sender);
583         setUser(msg.sender, _referral, false);
584   }
585   
586   function buyCards(uint8 _nr) external payable
587   {
588       require(_calculateDiscount(_nr, msg.sender) <= msg.value);
589         _getCards(_nr, msg.sender);
590         setUser(msg.sender, address(0), false);
591   }
592   function sendGift(address _targetAddress, uint256 _count) external onlyOwner
593   {
594       giftFor(address(0), _targetAddress, _count);
595   }
596   function withdrawGift() external{
597       if(userProfile[msg.sender].gifts > 0)
598       {
599         _getCards(1, msg.sender);
600         userProfile[msg.sender].gifts--;
601       }
602   }
603   
604   function beingVIP() external payable{
605       require(VIPCost <= msg.value);
606       _beingVIP(msg.sender);
607   }
608     
609     function updateCard(uint256 _cardId) external payable{        
610         // is not in auction
611         require(cardApprovals[_cardId] == address(0));
612         uint128 cost = getLevelUpCost(msg.sender); 
613         require(cost <= msg.value);
614         _updateCard(msg.sender, _cardId);
615   }
616   
617   function getLevelUpCost(address _address) public view returns (uint128){
618         uint128 cost = levelUp;  
619         if(userProfile[_address].vip)
620         {
621             cost = levelUpVIP;
622         }
623         return cost;
624   }
625   
626     // withdrawal function is called monthly
627     function withdrawBalance(uint256 _amount) external onlyOwner  {
628         uint256 amount = this.balance;
629 		if(_amount <= amount)
630 		{
631 		    amount = participantsFirst(_amount);
632 			owner.transfer(_amount);
633 		}
634 		else
635 		{
636 		    amount = participantsFirst(amount);
637 		    owner.transfer(amount);
638 		}
639     }
640     
641     function participantsFirst(uint256 _amount) internal returns(uint256){
642         uint256 provision;
643         uint256 amount = _amount;
644         for(uint8 i=0; i < numberOfParticipants; i++)
645         {
646             provision = percentage(_amount, participant[participantIndex[i]]);
647             amount = amount - provision;
648             participantIndex[i].transfer(provision);
649         }
650         return amount;
651     }
652 }