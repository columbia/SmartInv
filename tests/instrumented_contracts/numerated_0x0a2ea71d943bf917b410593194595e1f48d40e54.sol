1 pragma solidity ^0.4.21;
2 
3 /// @author Luis Freitas, Miguel Amaral (https://repop.world)
4 contract REPOPAccessControl {
5     address public ceoAddress;
6     address public cfoAddress;
7     address public cooAddress;
8 
9     bool public paused = false;
10 
11     modifier onlyCEO() {
12         require(msg.sender == ceoAddress);
13         _;
14     }
15 
16     modifier onlyCFO() {
17         require(msg.sender == cfoAddress);
18         _;
19     }
20 
21     modifier onlyCOO() {
22         require(msg.sender == cooAddress);
23         _;
24     }
25 
26     modifier onlyCLevel() {
27         require(
28             msg.sender == cooAddress ||
29             msg.sender == ceoAddress ||
30             msg.sender == cfoAddress
31         );
32         _;
33     }
34 
35     function setCEO(address _newCEO) external onlyCEO {
36         require(_newCEO != address(0));
37 
38         ceoAddress = _newCEO;
39     }
40 
41     function setCFO(address _newCFO) external onlyCEO {
42         require(_newCFO != address(0));
43 
44         cfoAddress = _newCFO;
45     }
46 
47     function setCOO(address _newCOO) external onlyCEO {
48         require(_newCOO != address(0));
49 
50         cooAddress = _newCOO;
51     }
52 
53     modifier whenNotPaused() {
54         require(!paused);
55         _;
56     }
57 
58     modifier whenPaused {
59         require(paused);
60         _;
61     }
62 
63     function pause() external onlyCLevel whenNotPaused {
64         paused = true;
65     }
66 
67     function unpause() public onlyCEO whenPaused {
68 
69         paused = false;
70     }
71 }
72 
73 contract PullPayment {
74   mapping(address => uint) public payments;
75 
76   function asyncSend(address dest, uint amount) internal {
77     payments[dest] += amount;
78   }
79 
80   function withdrawPayments() external {
81     uint payment = payments[msg.sender];
82     payments[msg.sender] = 0;
83     if (!msg.sender.send(payment)) {
84       payments[msg.sender] = payment;
85     }
86   }
87 }
88 
89 
90 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
91 contract ERC721 {
92 
93   function approve(address _to, uint256 _tokenId) public;
94   function balanceOf(address _owner) public view returns (uint256 balance);
95   function implementsERC721() public pure returns (bool);
96   function ownerOf(uint256 _tokenId) public view returns (address addr);
97   function takeOwnership(uint256 _tokenId) public;
98   function totalSupply() public view returns (uint256 total);
99   function transferFrom(address _from, address _to, uint256 _tokenId) public;
100   function transfer(address _to, uint256 _tokenId) public;
101   function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
102 
103   event Transfer(address indexed from, address indexed to, uint256 tokenId);
104   event Approval(address indexed owner, address indexed approved, uint256 tokenId);
105   function supportsInterface(bytes4 _interfaceID) external view returns (bool);
106 }
107 
108 library SafeMath {
109 
110   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
111     if (a == 0) {
112       return 0;
113     }
114     uint256 c = a * b;
115     assert(c / a == b);
116     return c;
117   }
118 
119   function div(uint256 a, uint256 b) internal pure returns (uint256) {
120     // assert(b > 0); // Solidity automatically throws when dividing by 0
121     uint256 c = a / b;
122     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
123     return c;
124   }
125 
126   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
127     assert(b <= a);
128     return a - b;
129   }
130 
131   function add(uint256 a, uint256 b) internal pure returns (uint256) {
132     uint256 c = a + b;
133     assert(c >= a);
134     return c;
135   }
136 }
137 
138 contract MetadataContract{
139 
140     function getMetadata(uint256 _tokenId) public view returns (bytes32[4] buffer, uint256 count) {
141         buffer[0] = "https://meta.repop.world/";
142         buffer[1] = uintToBytes(_tokenId);
143         count = 64;
144     }
145 
146       function _memcpy(uint _dest, uint _src, uint _len) private view {
147 
148         for(; _len >= 32; _len -= 32) {
149             assembly {
150                 mstore(_dest, mload(_src))
151             }
152             _dest += 32;
153             _src += 32;
154         }
155 
156         uint256 mask = 256 ** (32 - _len) - 1;
157         assembly {
158             let srcpart := and(mload(_src), not(mask))
159             let destpart := and(mload(_dest), mask)
160             mstore(_dest, or(destpart, srcpart))
161         }
162     }
163 
164     function _toString(bytes32[4] _rawBytes, uint256 _stringLength) private view returns (string) {
165         var outputString = new string(_stringLength);
166         uint256 outputPtr;
167         uint256 bytesPtr;
168 
169         assembly {
170             outputPtr := add(outputString, 32)
171             bytesPtr := _rawBytes
172         }
173 
174         _memcpy(outputPtr, bytesPtr, _stringLength);
175 
176         return outputString;
177     }
178 
179     function getMetadataUrl(uint256 _tokenId) external view returns (string infoUrl) {
180         bytes32[4] memory buffer;
181         uint256 count;
182         (buffer, count) = getMetadata(_tokenId);
183 
184         return _toString(buffer, count);
185     }
186 
187     function uintToBytes(uint v) public view returns (bytes32 ret) {
188         if (v == 0) {
189             ret = '0';
190         }
191         else {
192             while (v > 0) {
193                 ret = bytes32(uint(ret) / (2 ** 8));
194                 ret |= bytes32(((v % 10) + 48) * 2 ** (8 * 31));
195                 v /= 10;
196             }
197         }
198         return ret;
199     }
200 }
201 
202 
203 /// @author Luis Freitas, Miguel Amaral (https://repop.world)
204 contract REPOPERC721 is ERC721, REPOPAccessControl{
205 
206   MetadataContract public metadataContract;
207 
208   bytes4 constant InterfaceSignature_ERC165 =
209       bytes4(keccak256('supportsInterface(bytes4)'));
210 
211   bytes4 constant InterfaceSignature_ERC721 =
212       bytes4(keccak256('name()')) ^
213       bytes4(keccak256('symbol()')) ^
214       bytes4(keccak256('totalSupply()')) ^
215       bytes4(keccak256('balanceOf(address)')) ^
216       bytes4(keccak256('ownerOf(uint256)')) ^
217       bytes4(keccak256('approve(address,uint256)')) ^
218       bytes4(keccak256('transfer(address,uint256)')) ^
219       bytes4(keccak256('transferFrom(address,address,uint256)')) ^
220       bytes4(keccak256('tokensOfOwner(address)')) ^
221       bytes4(keccak256('tokenMetadata(uint256)'));
222 
223     function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl) {
224       require(metadataContract != address(0));
225       require(_tokenId >= 0 && _tokenId <= pops.length);
226 
227       return metadataContract.getMetadataUrl(_tokenId);
228     }
229 
230     function setMetadataContractAddress(address contractAddress) public onlyCEO{
231       require(contractAddress != address(0));
232       metadataContract = MetadataContract(contractAddress);
233     }
234 
235     string public constant name = "REPOP WORLD";
236     string public constant symbol = "POP";
237 
238     function supportsInterface(bytes4 _interfaceID) external view returns (bool)
239     {
240         return ((_interfaceID == InterfaceSignature_ERC165) || (_interfaceID == InterfaceSignature_ERC721));
241     }
242 
243     function approve(address _to, uint256 _tokenId) public whenNotPaused{
244 
245         require(_owns(msg.sender, _tokenId));
246 
247         popIndexToApproved[_tokenId] = _to;
248 
249         emit Approval(msg.sender, _to, _tokenId);
250     }
251 
252     function balanceOf(address _owner) public view returns (uint256 balance){
253         return ownershipTokenCount[_owner];
254     }
255 
256     function implementsERC721() public pure returns (bool){
257         return true;
258     }
259 
260     function ownerOf(uint256 _tokenId) public view returns (address owner) {
261         owner = popIndexToOwner[_tokenId];
262         require(owner != address(0));
263     }
264 
265     function takeOwnership(uint256 _tokenId) public {
266         address currentOwner = ownerOf(_tokenId);
267         address newOwner = msg.sender;
268 
269         require(_addressNotNull(newOwner));
270         require(_approved(newOwner, _tokenId));
271 
272         _transfer(newOwner, _tokenId);
273         emit Transfer(currentOwner, newOwner, _tokenId);
274     }
275 
276     function tokensOfOwner(address _owner) external view returns(uint256[] ownerTokens) {
277         uint256 tokenCount = balanceOf(_owner);
278         if (tokenCount == 0) {
279 
280             return new uint256[](0);
281         } else {
282             uint256[] memory result = new uint256[](tokenCount);
283             uint256 totalPops = totalSupply();
284             uint256 resultIndex = 0;
285             uint256 popId;
286 
287             for (popId = 1; popId <= totalPops; popId++) {
288                 if (popIndexToOwner[popId] == _owner) {
289                     result[resultIndex] = popId;
290                     resultIndex++;
291                 }
292             }
293             return result;
294         }
295     }
296 
297     function totalSupply() public view returns (uint256 total) {
298         return pops.length;
299     }
300 
301     function transfer(address _to, uint256 _tokenId ) public whenNotPaused{
302       require(_owns(msg.sender, _tokenId));
303       require(_addressNotNull(_to));
304 
305       _transfer(_to, _tokenId);
306 
307       emit Transfer(msg.sender, _to, _tokenId);
308     }
309 
310     function transferFrom(address _from, address _to, uint256 _tokenId) public whenNotPaused{
311         require(_owns(_from, _tokenId));
312         require(_approved(msg.sender, _tokenId));
313         require(_addressNotNull(_to));
314 
315         _transfer(_to, _tokenId);
316 
317         emit Transfer(_from, _to, _tokenId);
318     }
319 
320 
321     function _addressNotNull(address _to) private pure returns (bool){
322         return _to != address(0);
323     }
324 
325     function _approved(address _to, uint256 _tokenId) private view returns (bool) {
326         return popIndexToApproved[_tokenId] == _to;
327     }
328 
329     function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
330         return claimant == popIndexToOwner[_tokenId];
331     }
332 
333     function _transfer(address _to, uint256 _tokenID) internal {
334         address owner = popIndexToOwner[_tokenID];
335         ownershipTokenCount[owner] = ownershipTokenCount[owner] - 1 ;
336         popIndexToApproved[_tokenID] = 0;
337         popIndexToOwner[_tokenID] = _to;
338         ownershipTokenCount[_to] = ownershipTokenCount[_to] + 1;
339     }
340 
341     event Birth(address owner, uint256 popId, uint256 aParentId, uint256 bParentId, uint256 genes);
342     event Transfer(address from, address to, uint256 tokenId);
343 
344     struct Pop {
345       uint256 genes;
346       uint64 birthTime;
347       uint64 cooldownEndTimestamp;
348       uint32 aParentId;
349       uint32 bParentId;
350       bytes32 popName;
351       uint16 cooldownIndex;
352       uint16 generation;
353     }
354 
355     uint32[14] public cooldowns = [
356         uint32(10 minutes),
357         uint32(20 minutes),
358         uint32(40 minutes),
359         uint32(1 hours),
360         uint32(2 hours),
361         uint32(3 hours),
362         uint32(4 hours),
363         uint32(5 hours),
364         uint32(6 hours),
365         uint32(12 hours),
366         uint32(1 days),
367         uint32(3 days),
368         uint32(5 days),
369         uint32(7 days)
370     ];
371 
372     Pop[] public pops;
373 
374     mapping (uint256 => address) public popIndexToOwner;
375     mapping (address => uint256) public ownershipTokenCount;
376     mapping (uint256 => address) public popIndexToApproved;
377     mapping (uint256 => uint256) public genesToTokenId;
378 
379     function getPop(uint256 _popId) public view
380                     returns (
381                                 bool isReady,
382                                 uint256 genes,
383                                 uint64 birthTime,
384                                 uint64 cooldownEndTimestamp,
385                                 uint32 aParentId,
386                                 uint32 bParentId,
387                                 bytes32 popName,
388                                 uint16 cooldownIndex,
389                                 uint16 generation){
390         Pop memory pop = pops[_popId];
391         return(
392                 isReady = (pop.cooldownEndTimestamp <= now),
393                 pop.genes,
394                 pop.birthTime,
395                 pop.cooldownEndTimestamp,
396                 pop.aParentId,
397                 pop.bParentId,
398                 pop.popName,
399                 pop.cooldownIndex,
400                 pop.generation);
401     }
402 
403 
404     function createNewPop(uint256 genes, string popName) public onlyCLevel whenNotPaused{
405         bytes32 name32 = stringToBytes32(popName);
406         uint256 index = pops.push(Pop(genes,uint64(now),1,0,0,name32,0,0)) -1;
407 
408         emit Birth(msg.sender,index,0,0,genes);
409 
410         genesToTokenId[genes] = index;
411 
412         popIndexToOwner[index] = msg.sender;
413         ownershipTokenCount[msg.sender] = ownershipTokenCount[msg.sender]+1;
414     }
415 
416     function _triggerCooldown(Pop storage _pop) internal {
417         _pop.cooldownEndTimestamp = uint64(now + cooldowns[_pop.cooldownIndex]);
418     }
419 
420     function stringToBytes32(string memory source) internal pure returns (bytes32 result) {
421         bytes memory tempEmptyStringTest = bytes(source);
422         if (tempEmptyStringTest.length == 0) {
423             return 0x0;
424         }
425         assembly {
426             result := mload(add(source, 32))
427         }
428     }
429 
430     function setPopNameOriginal(uint256 popId, string newName) external onlyCLevel{
431       Pop storage pop = pops[popId];
432       require(pop.generation == 0);
433       bytes32 name32 = stringToBytes32(newName);
434       pop.popName = name32;
435     }
436 
437     function setDNA(uint256 popId, uint256 newDna) external onlyCLevel{
438       require(_owns(msg.sender, popId));
439       Pop storage pop = pops[popId];
440       pop.genes = newDna;
441     }
442 
443 }
444 
445 contract CarefulTransfer {
446     uint constant suggestedExtraGasToIncludeWithSends = 23000;
447 
448     function carefulSendWithFixedGas(
449         address _toAddress,
450         uint _valueWei,
451         uint _extraGasIncluded
452     ) internal returns (bool success) {
453         return _toAddress.call.value(_valueWei).gas(_extraGasIncluded)();
454     }
455 }
456 
457 contract MoneyManager is PullPayment, CarefulTransfer, REPOPAccessControl {
458 
459     function _repopTransaction(address _receiver, uint256 _amountWei, uint256 _marginPerThousandForDevelopers) internal {
460         uint256 commissionWei = (_amountWei * _marginPerThousandForDevelopers) / 1000;
461         uint256 compensationWei = _amountWei - commissionWei;
462 
463         if( ! carefulSendWithFixedGas(_receiver,compensationWei,23000)) {
464             asyncSend(_receiver, compensationWei);
465         }
466     }
467 
468     function withdraw(uint amount) external onlyCFO {
469         require(amount < address(this).balance);
470         cfoAddress.transfer(amount);
471     }
472 
473     function getBalance() public view returns (uint256 balance) {
474         return address(this).balance;
475     }
476 }
477 
478 library RoundMoneyNicely {
479     function roundMoneyDownNicely(uint _rawValueWei) internal pure
480     returns (uint nicerValueWei) {
481         if (_rawValueWei < 1 finney) {
482             return _rawValueWei;
483         } else if (_rawValueWei < 10 finney) {
484             return 10 szabo * (_rawValueWei / 10 szabo);
485         } else if (_rawValueWei < 100 finney) {
486             return 100 szabo * (_rawValueWei / 100 szabo);
487         } else if (_rawValueWei < 1 ether) {
488             return 1 finney * (_rawValueWei / 1 finney);
489         } else if (_rawValueWei < 10 ether) {
490             return 10 finney * (_rawValueWei / 10 finney);
491         } else if (_rawValueWei < 100 ether) {
492             return 100 finney * (_rawValueWei / 100 finney);
493         } else if (_rawValueWei < 1000 ether) {
494             return 1 ether * (_rawValueWei / 1 ether);
495         } else if (_rawValueWei < 10000 ether) {
496             return 10 ether * (_rawValueWei / 10 ether);
497         } else {
498             return _rawValueWei;
499         }
500     }
501 
502     function roundMoneyUpToWholeFinney(uint _valueWei) pure internal
503     returns (uint valueFinney) {
504         return (1 finney + _valueWei - 1 wei) / 1 finney;
505     }
506 }
507 
508 contract AuctionManager is MoneyManager {
509     event Bid(address bidder, uint256 bid, uint256 auctionId);
510     event NewAuction( uint256 itemForAuctionID, uint256 durationSeconds, address seller);
511     event NewAuctionWinner(address highestBidder, uint256 auctionId);
512 
513     struct Auction{
514         uint auctionStart;
515         uint auctionEnd;
516         uint highestBid;
517         address highestBidder;
518         bool ended;
519     }
520 
521     bool public isAuctionManager = true;
522     uint256 private marginPerThousandForDevelopers = 50;
523     uint256 private percentageBidIncrease = 33;
524     uint256 private auctionsStartBid = 0.1 ether;
525     address private auctionsStartAddress;
526 
527     mapping (uint256 => uint256) public _itemID2auctionID;
528     mapping (uint256 => uint256) public _auctionID2itemID;
529     Auction[] public _auctionsArray;
530 
531     ERC721 public nonFungibleContract;
532 
533     function AuctionManager() public {
534         ceoAddress = msg.sender;
535         cooAddress = msg.sender;
536         cfoAddress = msg.sender;
537 
538         auctionsStartAddress = msg.sender;
539         _auctionsArray.push(Auction(0,0,0,0,false));
540     }
541 
542     function setERCContract(address candidateAddress) public onlyCEO {
543         ERC721 candidateContract = ERC721(candidateAddress);
544 
545         nonFungibleContract = candidateContract;
546     }
547 
548     function getERCContractAddress() public view returns (address) {
549         return address(nonFungibleContract);
550     }
551 
552     function getAllActiveAuctions()  external view returns (uint256[] popsIDs,uint256[] auctionsIDs,uint256[] sellingPrices, address[] highestBidders, bool[] canBeEnded){
553 
554         uint256[] memory toReturnPopsIDs = new uint256[](_auctionsArray.length);
555         uint256[] memory toReturnAuctionsIDs = new uint256[](_auctionsArray.length);
556         uint256[] memory toReturnSellingPrices = new uint256[](_auctionsArray.length);
557         address[] memory toReturnSellerAddress = new address[](_auctionsArray.length);
558         bool[] memory toReturnCanBeEnded = new bool[](_auctionsArray.length);
559         uint256 index = 0;
560 
561         for(uint256 i = 1; i < _auctionsArray.length; i++){
562             uint256 popId = _auctionID2itemID[i];
563             uint256 price = requiredBid(i);
564 
565             if(_auctionsArray[i].ended == false){
566                 toReturnPopsIDs[index] = popId;
567                 toReturnAuctionsIDs[index] = i;
568                 toReturnSellingPrices[index] = price;
569                 toReturnSellerAddress[index] = _auctionsArray[i].highestBidder;
570                 toReturnCanBeEnded[index] = _auctionsArray[i].auctionEnd < now;
571                 index++;
572             }
573         }
574         return (toReturnPopsIDs,toReturnAuctionsIDs,toReturnSellingPrices,toReturnSellerAddress,toReturnCanBeEnded);
575     }
576 
577     function getAllAuctions()  external view returns (uint256[] popsIDs,uint256[] auctionsIDs,uint256[] sellingPrices){
578 
579         uint256[] memory toReturnPopsIDs = new uint256[](_auctionsArray.length);
580         uint256[] memory toReturnAuctionsIDs = new uint256[](_auctionsArray.length);
581         uint256[] memory toReturnSellingPrices = new uint256[](_auctionsArray.length);
582 
583         uint256 index = 0;
584 
585         for(uint256 i = 1; i < _auctionsArray.length; i++){
586             uint256 popId = _auctionID2itemID[i];
587             uint256 price = requiredBid(i);
588             toReturnPopsIDs[index] = popId;
589             toReturnAuctionsIDs[index] = i;
590             toReturnSellingPrices[index] = price;
591             index++;
592         }
593         return (toReturnPopsIDs,toReturnAuctionsIDs,toReturnSellingPrices);
594     }
595 
596 
597     function createAuction(uint256 _itemForAuctionID, uint256 _auctionDurationSeconds, address _seller) public {
598         require(msg.sender == getERCContractAddress());
599         require(_auctionDurationSeconds >= 20 seconds);
600         require(_auctionDurationSeconds < 45 days);
601         require(_itemForAuctionID != 0);
602         require(_seller != 0);
603 
604         _takeOwnershipOfTokenFrom(_itemForAuctionID,_seller);
605 
606         uint256 auctionEnd = SafeMath.add(now,_auctionDurationSeconds);
607         uint256 auctionID = _itemID2auctionID[_itemForAuctionID];
608         if(auctionID == 0){
609             uint256 index = _auctionsArray.push(Auction(now, auctionEnd, 0, _seller, false)) - 1;
610             _itemID2auctionID[_itemForAuctionID] = index;
611             _auctionID2itemID[index] = _itemForAuctionID;
612         } else {
613             Auction storage previousAuction = _auctionsArray[auctionID];
614             require(previousAuction.ended == true);
615             previousAuction.auctionStart = now;
616             previousAuction.auctionEnd = auctionEnd;
617             previousAuction.highestBidder = _seller;
618             previousAuction.highestBid = 0;
619             previousAuction.ended = false;
620         }
621         emit NewAuction(_itemForAuctionID, _auctionDurationSeconds, _seller);
622     }
623 
624     function bid(uint auctionID) public payable whenNotPaused{
625         require(auctionID != 0);
626         Auction storage auction = _auctionsArray[auctionID];
627         require(auction.ended == false);
628         require(auction.auctionEnd >= now);
629         uint claimBidPrice = requiredBid(auctionID);
630         uint256 bidValue = msg.value;
631         require(bidValue >= claimBidPrice);
632         address previousHighestBidder = auction.highestBidder;
633         auction.highestBid = msg.value;
634         auction.highestBidder = msg.sender;
635         _repopTransaction(previousHighestBidder, msg.value, marginPerThousandForDevelopers);
636         emit Bid(msg.sender, msg.value, auctionID);
637     }
638 
639     function endAuction(uint auctionID) public{
640         require(auctionID != 0);
641         Auction storage auction = _auctionsArray[auctionID];
642         require(auction.ended == false);
643         require(auction.auctionEnd < now);
644         auction.ended = true;
645         nonFungibleContract.transfer(auction.highestBidder, _auctionID2itemID[auctionID]);
646         emit NewAuctionWinner(auction.highestBidder, auctionID);
647     }
648 
649     function requiredBid(uint _auctionID) constant public returns (uint256 amountToOutBid) {
650         require(_auctionID != 0);
651         Auction memory auction = _auctionsArray[_auctionID];
652         if(auction.highestBid == 0){
653             return auctionsStartBid;
654         } else {
655             uint256 amountRequiredToOutBid = (auction.highestBid * (100 + percentageBidIncrease)) / 100;
656             amountRequiredToOutBid = RoundMoneyNicely.roundMoneyDownNicely(amountRequiredToOutBid);
657             return amountRequiredToOutBid;
658         }
659     }
660 
661     function getAuction(uint _itemForAuctionID) external constant returns (uint256 itemID, uint256 auctionStart, uint256 auctionEnd, address highestBidder, uint256 highestBid, bool ended){
662         require(_itemForAuctionID != 0);
663         Auction memory auction = _auctionsArray[_itemID2auctionID[_itemForAuctionID]];
664         if(auction.highestBidder != 0) {
665             itemID = _itemForAuctionID;
666             auctionStart =  auction.auctionStart;
667             auctionEnd =    auction.auctionEnd;
668             highestBidder = auction.highestBidder;
669             highestBid =    auction.highestBid;
670             ended =         auction.ended;
671             return(itemID,auctionStart,auctionEnd,highestBidder,highestBid,ended);
672         } else {
673             revert();
674         }
675     }
676 
677     function getAuctionStartBid() public view returns(uint256){
678       return auctionsStartBid;
679     }
680 
681     function setAuctionStartBid(uint256 _auctionStartBid) public onlyCLevel{
682       auctionsStartBid = _auctionStartBid;
683     }
684 
685     function _addressNotNull(address _to) private pure returns (bool){
686         return _to != address(0);
687     }
688 
689 
690     function _takeOwnershipOfToken(uint256 _itemForAuctionID) internal {
691 
692         nonFungibleContract.takeOwnership(_itemForAuctionID);
693     }
694 
695     function _takeOwnershipOfTokenFrom(uint256 _itemForAuctionID, address previousOwner) internal {
696         nonFungibleContract.transferFrom(previousOwner,this,_itemForAuctionID);
697     }
698 }
699 
700 contract MarketManager is MoneyManager {
701     event PopPurchased(address seller, address buyer, uint256 popId, uint256 sellingPrice);
702     event PopCancelSale(address popOwner, uint256 popId);
703     event PopChangedPrice(address popOwner, uint256 popId, uint256 newPrice);
704 
705     struct Sale {
706         uint256 sellingPrice;
707 
708         address seller;
709     }
710 
711     bool public isMarketManager = true;
712     uint256 private marginPerThousandForDevelopers = 50;
713     uint256 private MAX_SELLING_PRICE = 100000 ether;
714     mapping (uint256 => uint256) public _itemID2saleID;
715     mapping (uint256 => uint256) public _saleID2itemID;
716     Sale[] public _salesArray;
717     ERC721 public nonFungibleContract;
718 
719     function MarketManager() public {
720         ceoAddress = msg.sender;
721         cooAddress = msg.sender;
722         cfoAddress = msg.sender;
723         _salesArray.push(Sale(0,0));
724         _itemID2saleID[0] = 0;
725         _saleID2itemID[0] = 0;
726     }
727 
728     function setERCContract(address candidateAddress) public onlyCEO {
729         require(candidateAddress != address(0));
730         ERC721 candidateContract = ERC721(candidateAddress);
731         nonFungibleContract = candidateContract;
732     }
733 
734     function getERCContractAddress() public view returns (address) {
735         return address(nonFungibleContract);
736     }
737 
738     function getAllActiveSales()  external view returns (uint256[] popsIDs,uint256[] sellingPrices,address[] sellerAddresses){
739 
740         uint256[] memory toReturnPopsIDs = new uint256[](_salesArray.length);
741         uint256[] memory toReturnSellingPrices = new uint256[](_salesArray.length);
742         address[] memory toReturnSellerAddress = new address[](_salesArray.length);
743         uint256 index = 0;
744 
745         for(uint256 i = 1; i < _salesArray.length; i++){
746             uint256 popId = _saleID2itemID[i];
747             uint256 price = _salesArray[i].sellingPrice;
748             address seller = _salesArray[i].seller;
749 
750             if(seller != 0){
751                 toReturnSellerAddress[index] = seller;
752                 toReturnPopsIDs[index] = popId;
753                 toReturnSellingPrices[index] = price;
754                 index++;
755             }
756         }
757         return (toReturnPopsIDs,toReturnSellingPrices,toReturnSellerAddress);
758     }
759 
760     function getAllSalesByAddress(address addr)  external view returns (uint256[] popsIDs,uint256[] sellingPrices,address[] sellerAddresses){
761 
762         uint256[] memory toReturnPopsIDs = new uint256[](_salesArray.length);
763         uint256[] memory toReturnSellingPrices = new uint256[](_salesArray.length);
764         address[] memory toReturnSellerAddress = new address[](_salesArray.length);
765         uint256 index = 0;
766 
767         for(uint256 i = 1; i < _salesArray.length; i++){
768             uint256 popId = _saleID2itemID[i];
769             uint256 price = _salesArray[i].sellingPrice;
770             address seller = _salesArray[i].seller;
771 
772             if(seller == addr){
773                 toReturnSellerAddress[index] = seller;
774                 toReturnPopsIDs[index] = popId;
775                 toReturnSellingPrices[index] = price;
776                 index++;
777             }
778         }
779         return (toReturnPopsIDs,toReturnSellingPrices,toReturnSellerAddress);
780     }
781 
782     function purchasePop(uint256 _popId) public payable whenNotPaused{
783         uint256 saleID = _itemID2saleID[_popId];
784         require(saleID != 0);
785         Sale storage sale = _salesArray[saleID];
786         address popOwner = sale.seller;
787         require(popOwner != 0);
788         address newOwner = msg.sender;
789         uint256 sellingPrice = sale.sellingPrice;
790         require(popOwner != newOwner);
791         require(_addressNotNull(newOwner));
792         require(msg.value == sellingPrice);
793         sale.seller = 0;
794         nonFungibleContract.transfer(newOwner,_popId);
795         _repopTransaction(popOwner, msg.value, marginPerThousandForDevelopers);
796         emit PopPurchased(popOwner, msg.sender, _popId, msg.value);
797     }
798 
799     function sellerOf(uint _popId) public view returns (address) {
800         uint256 saleID = _itemID2saleID[_popId];
801         Sale memory sale = _salesArray[saleID];
802         return sale.seller;
803     }
804 
805     function sellPop(address seller, uint256 _popId, uint256 _sellingPrice) public whenNotPaused{
806         require(_sellingPrice < MAX_SELLING_PRICE);
807         require(msg.sender == getERCContractAddress());
808         require(_sellingPrice > 0);
809         _takeOwnershipOfTokenFrom(_popId,seller);
810         uint256 saleID = _itemID2saleID[_popId];
811         if(saleID == 0) {
812             uint256  index = _salesArray.push(Sale(_sellingPrice,seller)) - 1;
813             _itemID2saleID[_popId] = index;
814             _saleID2itemID[index] = _popId;
815         } else {
816             Sale storage sale = _salesArray[saleID];
817             require(sale.seller == 0);
818             sale.seller = seller;
819             sale.sellingPrice = _sellingPrice;
820         }
821     }
822 
823     function cancelSellPop(uint256 _popId) public {
824         Sale storage sale = _salesArray[_itemID2saleID[_popId]];
825         require(sale.seller == msg.sender);
826         sale.seller = 0;
827         nonFungibleContract.transfer(msg.sender,_popId);
828 
829         emit PopCancelSale(msg.sender, _popId);
830     }
831 
832     function changeSellPOPPrice(uint256 _popId, uint256 _newSellingValue) public whenNotPaused{
833       require(_newSellingValue < MAX_SELLING_PRICE);
834       require(_newSellingValue > 0);
835       Sale storage sale = _salesArray[_itemID2saleID[_popId]];
836       require(sale.seller == msg.sender);
837       sale.sellingPrice = _newSellingValue;
838       emit PopChangedPrice(msg.sender, _popId, _newSellingValue);
839     }
840 
841     function _addressNotNull(address _to) private pure returns (bool){
842         return _to != address(0);
843     }
844 
845     function _takeOwnershipOfToken(uint256 _itemForAuctionID) internal {
846         nonFungibleContract.takeOwnership(_itemForAuctionID);
847     }
848 
849     function _takeOwnershipOfTokenFrom(uint256 _itemForAuctionID, address previousOwner) internal {
850         nonFungibleContract.transferFrom(previousOwner,this,_itemForAuctionID);
851     }
852 }
853 
854 contract CloningInterface{
855   function isGeneScience() public pure returns (bool);
856   function mixGenes(uint256 genes1, uint256 genes2) public returns (uint256);
857 }
858 
859 contract GenesMarket is MoneyManager {
860     event GenesCancelSale(address popOwner, uint256 popId);
861     event GenesPurchased(address buyer, address popOwner, uint256 popId, uint256 amount, uint256 price);
862     event GenesChangedPrice(address popOwner, uint256 popId, uint256 newPrice);
863 
864     struct GeneForSale {
865             uint256 sellingPrice;
866             address currentOwner;
867     }
868 
869     mapping (uint256 => uint256) public _itemID2geneSaleID;
870     mapping (uint256 => uint256) public _geneSaleID2itemID;
871     GeneForSale[] public _genesForSaleArray;
872     uint256 marginPerThousandForDevelopers = 50;
873     uint256 MAX_SELLING_PRICE = 10000 ether;
874 
875     mapping(address => mapping (uint256 => uint256)) _genesOwned;
876     mapping(address => uint256[]) _ownedGenesPopsId;
877     bool public isGenesMarket = true;
878 
879     function GenesMarket() public {
880         ceoAddress = msg.sender;
881         cooAddress = msg.sender;
882         cfoAddress = msg.sender;
883         _genesForSaleArray.push(GeneForSale(0,0));
884     }
885 
886     ERC721 public nonFungibleContract;
887     function setERCContract(address candidateAddress) public onlyCEO() {
888         ERC721 candidateContract = ERC721(candidateAddress);
889         nonFungibleContract = candidateContract;
890     }
891 
892     function getERCContractAddress() public view returns (address) {
893         return address(nonFungibleContract);
894     }
895 
896     function startSellingGenes(uint256 _popId, uint256 _sellingPrice, address _seller) public {
897         require(_sellingPrice < MAX_SELLING_PRICE);
898         require(msg.sender == getERCContractAddress());
899         require(_sellingPrice > 0);
900         _takeOwnershipOfTokenFrom(_popId,_seller);
901         uint256 geneSaleID = _itemID2geneSaleID[_popId];
902         if(geneSaleID == 0){
903 
904             uint256 index = _genesForSaleArray.push(GeneForSale(_sellingPrice,_seller)) - 1;
905             _itemID2geneSaleID[_popId] = index;
906             _geneSaleID2itemID[index] = _popId;
907 
908         }else {
909             GeneForSale storage previousSale = _genesForSaleArray[geneSaleID];
910             previousSale.sellingPrice = _sellingPrice;
911             previousSale.currentOwner = _seller;
912         }
913     }
914 
915     function stopSellingGenes(uint _popId) public {
916         uint256 geneSaleID = _itemID2geneSaleID[_popId];
917         require(geneSaleID != 0);
918         GeneForSale storage gene = _genesForSaleArray[geneSaleID];
919         require(msg.sender == gene.currentOwner);
920         require(gene.sellingPrice != 0);
921         gene.sellingPrice = 0;
922         nonFungibleContract.transfer(gene.currentOwner, _popId);
923 
924         emit GenesCancelSale(msg.sender, _popId);
925     }
926 
927 
928     function sellerOf(uint _popId) public view returns (address) {
929         uint256 geneSaleID = _itemID2geneSaleID[_popId];
930         GeneForSale memory gene = _genesForSaleArray[geneSaleID];
931         if(gene.sellingPrice != 0) {
932             return gene.currentOwner;
933         } else {
934             return 0;
935         }
936     }
937 
938     function useBottle(address _user, uint _popId) external whenNotPaused {
939         require(msg.sender == getERCContractAddress());
940         require(_genesOwned[_user][_popId] > 0);
941         _genesOwned[_user][_popId] = _genesOwned[_user][_popId] - 1;
942     }
943 
944 
945     function purchaseGenes(uint256 _popId, uint256 _amountGenes, bool update) public payable whenNotPaused{
946         require(_amountGenes > 0);
947         uint256 geneSaleID = _itemID2geneSaleID[_popId];
948         GeneForSale memory gene = _genesForSaleArray[geneSaleID];
949         require(gene.sellingPrice != 0);
950         address popOwner = gene.currentOwner;
951         address genesReceiver = msg.sender;
952         uint256 sellingPrice = gene.sellingPrice;
953         require(popOwner != genesReceiver);
954         require(msg.value == SafeMath.mul(sellingPrice, _amountGenes));
955         if( update && _genesOwned[msg.sender][_popId] == 0) {
956             _ownedGenesPopsId[msg.sender].push(_popId);
957         }
958         _genesOwned[msg.sender][_popId] = _genesOwned[msg.sender][_popId] + _amountGenes;
959         _repopTransaction(popOwner, msg.value, marginPerThousandForDevelopers);
960         emit GenesPurchased(msg.sender, popOwner, _popId, _amountGenes, msg.value);
961     }
962 
963     function getGenesForSale() public view returns (uint[] popIDs, uint[] sellingPrices, uint[] geneSaleIDs, address[] sellers){
964         uint256[] memory toReturnPopsIDs = new uint256[](_genesForSaleArray.length);
965         uint256[] memory toReturnSellingPrices = new uint256[](_genesForSaleArray.length);
966         uint256[] memory toReturnGeneSaleID = new uint256[](_genesForSaleArray.length);
967         address[] memory toReturnSellers = new address[](_genesForSaleArray.length);
968         uint256 index = 0;
969 
970         for(uint256 i = 1; i < _genesForSaleArray.length; i++){
971             uint256 popId = _geneSaleID2itemID[i];
972             uint256 price = _genesForSaleArray[i].sellingPrice;
973 
974             if(price != 0){
975                 toReturnGeneSaleID[index] = i;
976                 toReturnPopsIDs[index] = popId;
977                 toReturnSellingPrices[index] = price;
978                 toReturnSellers[index] = _genesForSaleArray[i].currentOwner;
979                 index++;
980             }
981         }
982         return (toReturnPopsIDs,toReturnSellingPrices,toReturnGeneSaleID, toReturnSellers);
983     }
984 
985     function getGenesForSaleBySeller(address seller) public view returns (uint[] popIDs, uint[] sellingPrices, uint[] geneSaleIDs, address[] sellers){
986         uint256[] memory toReturnPopsIDs = new uint256[](_genesForSaleArray.length);
987         uint256[] memory toReturnSellingPrices = new uint256[](_genesForSaleArray.length);
988         uint256[] memory toReturnGeneSaleID = new uint256[](_genesForSaleArray.length);
989         address[] memory toReturnSellers = new address[](_genesForSaleArray.length);
990         uint256 index = 0;
991 
992         for(uint256 i = 1; i < _genesForSaleArray.length; i++){
993             uint256 popId = _geneSaleID2itemID[i];
994             uint256 price = _genesForSaleArray[i].sellingPrice;
995 
996             if(price != 0){
997               if(_genesForSaleArray[i].currentOwner == seller){
998                 toReturnGeneSaleID[index] = i;
999                 toReturnPopsIDs[index] = popId;
1000                 toReturnSellingPrices[index] = price;
1001                 toReturnSellers[index] = _genesForSaleArray[i].currentOwner;
1002                 index++;
1003               }
1004             }
1005         }
1006         return (toReturnPopsIDs,toReturnSellingPrices,toReturnGeneSaleID, toReturnSellers);
1007     }
1008 
1009     function getAmountOfGene(uint _popId) public view returns (uint amount){
1010         return _genesOwned[msg.sender][_popId];
1011     }
1012 
1013     function getMyGenes() public view returns (uint[] popIDs, uint[] amount) {
1014         uint256[] memory toReturnPopsIDs = new uint256[](_ownedGenesPopsId[msg.sender].length);
1015         uint256[] memory toReturnAmount = new uint256[](_ownedGenesPopsId[msg.sender].length);
1016 
1017         for(uint256 i = 0; i < _ownedGenesPopsId[msg.sender].length; i++) {
1018             toReturnPopsIDs[i] = _ownedGenesPopsId[msg.sender][i];
1019             toReturnAmount[i] = _genesOwned[msg.sender][_ownedGenesPopsId[msg.sender][i]];
1020         }
1021         return (toReturnPopsIDs,toReturnAmount);
1022     }
1023 
1024     function changeSellGenesPrice(uint256 _popId, uint256 _newSellingValue) public whenNotPaused{
1025       require(_newSellingValue < MAX_SELLING_PRICE);
1026       require(_newSellingValue > 0);
1027       uint256 geneSaleID = _itemID2geneSaleID[_popId];
1028       require(geneSaleID != 0);
1029 
1030       GeneForSale storage gene = _genesForSaleArray[geneSaleID];
1031 
1032       require(msg.sender == gene.currentOwner);
1033       require(gene.sellingPrice != 0);
1034 
1035       gene.sellingPrice = _newSellingValue;
1036 
1037       emit GenesChangedPrice(msg.sender, _popId, _newSellingValue);
1038     }
1039 
1040     function _takeOwnershipOfTokenFrom(uint256 _popId, address previousOwner) internal {
1041         nonFungibleContract.transferFrom(previousOwner,this,_popId);
1042     }
1043 }
1044 
1045 contract REPOPCore is REPOPERC721, MoneyManager{
1046     uint256 public refresherFee = 0.01 ether;
1047     AuctionManager public auctionManager;
1048     MarketManager public marketManager;
1049     GenesMarket public genesMarket;
1050     CloningInterface public geneScience;
1051 
1052     event CloneWithTwoPops(address creator, uint256 cloneId, uint256 aParentId, uint256 bParentId);
1053     event CloneWithPopAndBottle(address creator, uint256 cloneId, uint256 popId, uint256 bottleId);
1054     event SellingPop(address seller, uint256 popId, uint256 price);
1055     event SellingGenes(address seller, uint256 popId, uint256 price);
1056     event ChangedPopName(address owner, uint256 popId, bytes32 newName);
1057     event CooldownRemoval(uint256 popId, address owner, uint256 paidFee);
1058 
1059     function REPOPCore() public{
1060 
1061       ceoAddress = msg.sender;
1062       cooAddress = msg.sender;
1063       cfoAddress = msg.sender;
1064 
1065       createNewPop(0x0, "Satoshi Nakamoto");
1066     }
1067 
1068     function createNewAuction(uint256 _itemForAuctionID, uint256 _auctionDurationSeconds) public onlyCLevel{
1069         approve(address(auctionManager),_itemForAuctionID);
1070         auctionManager.createAuction(_itemForAuctionID,_auctionDurationSeconds,msg.sender);
1071     }
1072 
1073     function setAuctionManagerAddress(address _address) external onlyCEO {
1074         AuctionManager candidateContract = AuctionManager(_address);
1075 
1076 
1077         require(candidateContract.isAuctionManager());
1078 
1079 
1080         auctionManager = candidateContract;
1081     }
1082 
1083     function getAuctionManagerAddress() public view returns (address) {
1084         return address(auctionManager);
1085     }
1086 
1087     function setMarketManagerAddress(address _address) external onlyCEO {
1088         MarketManager candidateContract = MarketManager(_address);
1089         require(candidateContract.isMarketManager());
1090         marketManager = candidateContract;
1091     }
1092 
1093     function getMarketManagerAddress() public view returns (address) {
1094         return address(marketManager);
1095     }
1096 
1097     function setGeneScienceAddress(address _address) external onlyCEO {
1098       CloningInterface candidateContract = CloningInterface(_address);
1099       require(candidateContract.isGeneScience());
1100       geneScience = candidateContract;
1101     }
1102 
1103     function getGeneScienceAddress() public view returns (address) {
1104         return address(geneScience);
1105     }
1106 
1107     function setGenesMarketAddress(address _address) external onlyCEO {
1108       GenesMarket candidateContract = GenesMarket(_address);
1109       require(candidateContract.isGenesMarket());
1110       genesMarket = candidateContract;
1111     }
1112 
1113     function getGenesMarketAddress() public view returns (address) {
1114         return address(genesMarket);
1115     }
1116 
1117     function sellPop(uint256 _popId, uint256 _price) public {
1118         Pop storage pop = pops[_popId];
1119         require(pop.cooldownEndTimestamp <= now);
1120         approve(address(marketManager),_popId);
1121         marketManager.sellPop(msg.sender,_popId,_price);
1122         emit SellingPop(msg.sender, _popId, _price);
1123     }
1124 
1125     function sellGenes(uint256 _popId, uint256 _price) public {
1126         require(_popId > 0);
1127         approve(address(genesMarket),_popId);
1128         genesMarket.startSellingGenes(_popId,_price,msg.sender);
1129         emit SellingGenes(msg.sender, _popId, _price);
1130     }
1131 
1132     function getOwnerInAnyPlatformById(uint256 popId) public view returns (address){
1133       if(ownerOf(popId) == address(marketManager)){
1134         return marketManager.sellerOf(popId);
1135       }
1136       else if(ownerOf(popId) == address(genesMarket)){
1137         return genesMarket.sellerOf(popId);
1138       }
1139       else if(ownerOf(popId) == address(auctionManager)){
1140         return ceoAddress;
1141       }
1142       else{
1143         return ownerOf(popId);
1144       }
1145       return 0x0;
1146     }
1147 
1148     function setPopName(uint256 popId, string newName) external {
1149       require(_ownerOfPopInAnyPlatform(popId));
1150       Pop storage pop = pops[popId];
1151       require(pop.generation > 0);
1152       bytes32 name32 = stringToBytes32(newName);
1153       pop.popName = name32;
1154       emit ChangedPopName(msg.sender, popId, name32);
1155     }
1156 
1157     function removeCooldown(uint256 popId)
1158       external
1159       payable
1160       {
1161         require(_ownerOfPopInAnyPlatform(popId));
1162         require(msg.value >= refresherFee);
1163         Pop storage pop = pops[popId];
1164         pop.cooldownEndTimestamp = 1;
1165         emit CooldownRemoval(popId, msg.sender, refresherFee);
1166       }
1167 
1168     function _ownerOfPopInAnyPlatform(uint _popId) internal view returns (bool) {
1169       return ownerOf(_popId) == msg.sender || genesMarket.sellerOf(_popId) == msg.sender || marketManager.sellerOf(_popId) == msg.sender;
1170     }
1171 
1172     function getOwnershipForCloning(uint _popId) internal view returns (bool) {
1173         return ownerOf(_popId) == msg.sender || genesMarket.sellerOf(_popId) == msg.sender;
1174     }
1175 
1176     function changeRefresherFee(uint256 _newFee) public onlyCLevel{
1177         refresherFee = _newFee;
1178     }
1179 
1180     function cloneWithTwoPops(uint256 _aParentId, uint256 _bParentId)
1181       external
1182       whenNotPaused
1183       returns (uint256)
1184       {
1185         require(_aParentId > 0);
1186         require(_bParentId > 0);
1187         require(getOwnershipForCloning(_aParentId));
1188         require(getOwnershipForCloning(_bParentId));
1189         Pop storage aParent = pops[_aParentId];
1190 
1191         Pop storage bParent = pops[_bParentId];
1192 
1193         require(aParent.genes != bParent.genes);
1194         require(aParent.cooldownEndTimestamp <= now);
1195         require(bParent.cooldownEndTimestamp <= now);
1196 
1197         uint16 parentGen = aParent.generation;
1198         if (bParent.generation > aParent.generation) {
1199             parentGen = bParent.generation;
1200         }
1201 
1202         uint16 cooldownIndex = parentGen + 1;
1203         if (cooldownIndex > 13) {
1204             cooldownIndex = 13;
1205         }
1206 
1207         uint256 childGenes = geneScience.mixGenes(aParent.genes, bParent.genes);
1208 
1209         _triggerCooldown(aParent);
1210         _triggerCooldown(bParent);
1211 
1212         uint256 index = pops.push(Pop(childGenes,uint64(now), 1, uint32(_aParentId), uint32(_bParentId), 0, cooldownIndex, parentGen + 1)) -1;
1213 
1214         popIndexToOwner[index] = msg.sender;
1215         ownershipTokenCount[msg.sender] = ownershipTokenCount[msg.sender]+1;
1216 
1217         emit CloneWithTwoPops(msg.sender, index, _aParentId, _bParentId);
1218         emit Birth(msg.sender, index, _aParentId, _bParentId,childGenes);
1219 
1220         return index;
1221     }
1222 
1223     function cloneWithPopAndBottle(uint256 _aParentId, uint256 _bParentId_bottle)
1224         external
1225         whenNotPaused
1226         returns (uint256)
1227         {
1228           require(_aParentId > 0);
1229           require(getOwnershipForCloning(_aParentId));
1230           Pop storage aParent = pops[_aParentId];
1231           Pop memory bParent = pops[_bParentId_bottle];
1232 
1233           require(aParent.genes != bParent.genes);
1234           require(aParent.cooldownEndTimestamp <= now);
1235 
1236           uint16 parentGen = aParent.generation;
1237           if (bParent.generation > aParent.generation) {
1238               parentGen = bParent.generation;
1239           }
1240 
1241           uint16 cooldownIndex = parentGen + 1;
1242           if (cooldownIndex > 13) {
1243               cooldownIndex = 13;
1244           }
1245 
1246           genesMarket.useBottle(msg.sender, _bParentId_bottle);
1247 
1248           uint256 childGenes = geneScience.mixGenes(aParent.genes, bParent.genes);
1249 
1250           _triggerCooldown(aParent);
1251 
1252           uint256 index = pops.push(Pop(childGenes,uint64(now), 1, uint32(_aParentId), uint32(_bParentId_bottle), 0, cooldownIndex, parentGen + 1)) -1;
1253 
1254           popIndexToOwner[index] = msg.sender;
1255           ownershipTokenCount[msg.sender] = ownershipTokenCount[msg.sender]+1;
1256 
1257           emit CloneWithPopAndBottle(msg.sender, index, _aParentId, _bParentId_bottle);
1258           emit Birth(msg.sender, index, _aParentId, _bParentId_bottle, childGenes);
1259 
1260           return index;
1261         }
1262 }