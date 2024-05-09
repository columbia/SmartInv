1 pragma solidity ^0.4.24;
2 
3 // File: contracts/SafeMath.sol
4 
5 library SafeMath {
6   function mul(uint256 a, uint256 b) internal pure returns (uint256){
7     if(a==0){
8       return 0;
9     }
10     uint256 c = a * b;
11     assert(c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal pure returns (uint256) {
16     uint256 c = a / b;
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256){
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256){
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 
31   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
32     require(b != 0);
33     return a % b;
34   }
35 }
36 
37 // File: contracts/AddressUtils.sol
38 
39 //Utility library of inline functions on addresses
40 library AddressUtils {
41   function isContract(address addr) internal view returns (bool) {
42     uint256 size;
43     assembly { size := extcodesize(addr) }
44     return size > 0;
45   }
46 }
47 
48 // File: contracts/ERC165.sol
49 
50 interface ERC165 {
51   function supportsInterface(bytes4 _interfaceId) external view returns (bool);
52 }
53 
54 // File: contracts/ERC721Basic.sol
55 
56 contract ERC721Basic is ERC165 {
57   bytes4 internal constant InterfaceId_ERC721 = 0x80ac58cd;
58   bytes4 internal constant InterfaceId_ERC721Enumerable = 0x780e9d63;
59   bytes4 internal constant InterfaceId_ERC721Metadata = 0x5b5e139f;
60 
61   //Events
62   event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId );
63   event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId );
64   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved );
65   
66   //Required methods
67   function balanceOf(address _owner) public view returns (uint256 balance);
68   function ownerOf(uint256 _tokenId) public view returns (address owner);
69 
70   function approve(address _to, uint256 _tokenId) public;
71   function getApproved(uint256 _tokenId) public view returns (address _operator);
72 
73   function setApprovalForAll(address _operator, bool _approved) public;
74   function isApprovedForAll(address _owner, address _operator) public view returns (bool);
75 
76   function transfer(address _to, uint256 _tokenId) public;
77   function transferFrom(address _from, address _to, uint256 _tokenId) public;
78   function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;
79   function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) public;
80 
81   function implementsERC721() public pure returns(bool);
82 }
83 
84 // File: contracts/ERC721TokenReceiver.sol
85 
86 contract ERC721TokenReceiver {
87   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
88   bytes4 retval;
89   bool reverts;
90 
91   constructor(bytes4 _retval, bool _reverts) public {
92     retval = _retval;
93     reverts = _reverts;
94   }
95 
96   event Received(address _operator, address _from, uint256 _tokenId, bytes _data, uint256 _gas );
97 
98   function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes _data ) public returns(bytes4) {
99     require(!reverts);
100     emit Received(
101       _operator,
102       _from,
103       _tokenId,
104       _data,
105       gasleft()
106     );
107     return retval;
108   }
109 }
110 
111 // File: contracts/SupportsInterfaceWithLookup.sol
112 
113 contract SupportsInterfaceWithLookup is ERC165 {
114   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
115   mapping(bytes4 => bool) internal supportedInterfaces;
116   
117   constructor() public {
118     _registerInterface(InterfaceId_ERC165);
119   }
120 
121   function supportsInterface(bytes4 _interfaceId) external view returns (bool) {
122     return supportedInterfaces[_interfaceId];
123   }
124 
125   function _registerInterface(bytes4 _interfaceId) internal {
126     require(_interfaceId != 0xffffffff);
127     supportedInterfaces[_interfaceId] = true;
128   }
129 }
130 
131 // File: contracts/ERC721BasicToken.sol
132 
133 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic{
134   using SafeMath for uint256;
135   using AddressUtils for address;
136   
137   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
138   mapping (uint256 => address) internal tokenIDToOwner;
139   mapping (uint256 => address) internal tokenIDToApproved;
140   mapping (address => uint256) internal ownershipTokenCount;
141   mapping (address => mapping (address => bool)) internal operatorApprovals;
142 
143   constructor() public {
144     _registerInterface(InterfaceId_ERC721);
145   }
146   function implementsERC721() public pure returns(bool){
147       return true;
148   }
149   function balanceOf(address _owner) public view returns (uint256) {
150     require(_owner != address(0));
151     return ownershipTokenCount[_owner];
152   }
153   function ownerOf(uint256 _tokenId) public view returns (address) {
154     address owner = tokenIDToOwner[_tokenId];
155     require(owner != address(0));
156     return owner;
157   }
158   
159   function getApproved(uint256 _tokenId) public view returns (address) {
160     return tokenIDToApproved[_tokenId];
161   }
162   function setApprovalForAll(address _to, bool _approved) public {
163     require(_to != msg.sender);
164     operatorApprovals[msg.sender][_to] = _approved;
165     emit ApprovalForAll(msg.sender, _to, _approved);
166   }
167   function isApprovedForAll(address _owner, address _operator ) public view returns (bool) {
168     return operatorApprovals[_owner][_operator];
169   }
170   function _exists(uint256 _tokenId) internal view returns (bool) {
171     address owner = tokenIDToOwner[_tokenId];
172     return owner != address(0);
173   }
174   function isApprovedOrOwner(address _spender, uint256 _tokenId ) internal view returns (bool) {
175     address owner = ownerOf(_tokenId);
176     return (
177       _spender == owner || getApproved(_tokenId) == _spender || isApprovedForAll(owner, _spender)
178     );
179   }
180   function checkAndCallSafeTransfer(address _from, address _to, uint256 _tokenId, bytes _data ) internal returns (bool) {
181     if (!_to.isContract()) {
182       return true;
183     }
184     bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
185     return (retval == ERC721_RECEIVED);
186   }
187 }
188 
189 // File: contracts/ERC721Enumerable.sol
190 
191 contract ERC721Enumerable is ERC721Basic {
192     function totalSupply() public view returns (uint256);
193     function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256 _tokenId);
194     function tokenByIndex(uint256 _index) public view returns (uint256);
195 }
196 
197 // File: contracts/ERC721Metadata.sol
198 
199 contract ERC721Metadata is ERC721Basic {
200   function name() external view returns (string _name);
201   function symbol() external view returns (string _symbol);
202   function tokenURI(uint256 _tokenId) public view returns (string);
203 }
204 
205 // File: contracts/ChainDrawingsAccess.sol
206 
207 contract ChainDrawingsAccess{
208   event ContractUpgrade(address newContract);
209 
210   address public owner;
211 
212   bool public paused = false;
213 
214   modifier onlyOwner() {
215     require(msg.sender == owner);
216     _;
217   }
218 
219   function setNewOwner(address _newOwner) public onlyOwner {
220     require(_newOwner != address(0));
221     owner = _newOwner;
222   }
223 
224   function withdrawBalance() external onlyOwner {
225     owner.transfer(address(this).balance);
226   }
227 
228   modifier whenNotPaused() {
229     require(!paused);
230     _;
231   }
232 
233   modifier whenPaused {
234     require(paused);
235     _;
236   }
237  
238   function pause() public onlyOwner whenNotPaused {
239     paused = true;
240   }
241 
242   function unpause() public onlyOwner whenPaused {
243     paused = false;
244   }
245 }
246 
247 // File: contracts/Ownable.sol
248 
249 contract Ownable {
250   address public owner;
251 
252   constructor() public {
253     owner = msg.sender;
254   }
255 
256   modifier onlyOwner() {
257     require(msg.sender == owner);
258     _;
259   }
260 
261   function transferOwnership(address newOwner) public onlyOwner {
262     if(newOwner != address(0)){
263       owner = newOwner;
264     }
265   }
266 }
267 
268 // File: contracts/Pausable.sol
269 
270 contract Pausable is Ownable {
271   event Pause();
272   event Unpause();
273 
274   bool public paused = false;
275 
276   modifier whenNotPaused() {
277     require(!paused);
278     _;
279   }
280 
281   modifier whenPaused {
282     require(paused);
283     _;
284   }
285 
286   function pause() onlyOwner whenNotPaused public returns (bool){
287     paused = true;
288     emit Pause();
289     return true;   
290   }
291 
292   function unpause() onlyOwner whenPaused public returns (bool){
293     paused = false;
294     emit Unpause();
295     return true;   
296   } 
297 }
298 
299 // File: contracts/SaleClockAuction.sol
300 
301 contract SaleClockAuction is Pausable {
302   bool public isSaleClockAuction = true;
303 
304   struct Auction {
305     address seller;
306     uint128 startingPrice;  //wei
307     uint128 endingPrice;    //wei
308     uint64 duration; //秒
309     uint64 startedAt; //出售开始时间，如果出售终止则为0
310   }
311 
312   ERC721Basic public nonFungibleContract;    //NFT 合约地址
313 
314   uint256 public commission;    //交易佣金，按交易总额的百分比收取。0 - 10000 表示0% - 100%
315   mapping (uint256 => Auction) tokenIdToAuction;   //mapping 所有参与竞拍的跑图ID
316   mapping (address => uint256[]) public ownershipAuctionTokenIDs;   //记录用户当前正在拍卖的全部跑图ID
317 
318   event AuctionCreated(uint256 tokenId, uint256 startingPrice, uint256 endingPrice, uint256 duration);
319   event AuctionSuccessful(uint256 tokenId, uint256 totalPrice, address winner);
320   event AuctionCancelled(uint256 tokenId);
321 
322   bytes4 constant InterfaceSignature_ERC721 = 0x80ac58cd;
323 
324   constructor(address _nftAddress, uint256 _commission) public {
325     require(_commission <= 10000);
326     commission = _commission;
327    
328     ERC721Basic candidateContract = ERC721Basic(_nftAddress);
329     require(candidateContract.implementsERC721());
330     require(candidateContract.supportsInterface(InterfaceSignature_ERC721));
331     nonFungibleContract = candidateContract;
332   }
333 
334   function () external {}	//不直接接收数字货币
335 
336   //输入参数合法性校验
337   modifier canBeStoredWith64Bits(uint256 _value){
338     require(_value <= 18446744073709551615);
339     _;
340   }
341 
342   modifier canBeStoredWith128Bits(uint256 _value){
343     require(_value < 340282366920938463463374607431768211455);
344     _;
345   }
346 
347   function _owns(address _claimant, uint256 _tokenId) internal view returns (bool){
348     return (nonFungibleContract.ownerOf(_tokenId) == _claimant);
349   }
350 
351   function _escrow(address _owner, uint256 _tokenId) internal {
352     nonFungibleContract.transferFrom(_owner, this, _tokenId);
353     //增加-保存用户正在拍卖的跑图ID集合
354     ownershipAuctionTokenIDs[_owner].push(_tokenId);
355   }
356 
357   //添加竞拍（会将跑图从当前主人地址转移到拍卖合约账户下，冻结）
358   function _addAuction(uint256 _tokenId, Auction _auction) internal {
359     require(_auction.duration >= 1 minutes);
360 
361     tokenIdToAuction[_tokenId] = _auction;
362 
363     emit AuctionCreated(
364       uint256(_tokenId),
365       uint256(_auction.startingPrice),
366       uint256(_auction.endingPrice),
367       uint256(_auction.duration)
368     );
369   }
370 
371   //取消拍卖
372   function _cancelAuction(uint256 _tokenId, address _seller) internal {
373     _removeAuction(_tokenId);
374     nonFungibleContract.transfer(_seller, _tokenId);
375     //将取消拍卖的tokentID从用户正在拍卖的跑图ID集合列表里删除
376     removeFromOwnershipAuctionTokenIDs(_seller, _tokenId);
377     
378     emit AuctionCancelled(_tokenId);
379   }
380 
381   //从用户正在拍卖的跑图ID集合列表里删除
382   function removeFromOwnershipAuctionTokenIDs(address seller, uint256 tokenId) internal {
383     uint len = ownershipAuctionTokenIDs[seller].length;
384     if(len > 0){
385       bool hasFound = false;
386       for(uint i=0; i<len-1; i++){
387         if(!hasFound && ownershipAuctionTokenIDs[seller][i] == tokenId){
388           hasFound = true;
389           ownershipAuctionTokenIDs[seller][i] = ownershipAuctionTokenIDs[seller][i+1];
390         }else if(hasFound){
391           ownershipAuctionTokenIDs[seller][i] = ownershipAuctionTokenIDs[seller][i+1];
392         }
393       }
394 
395       if(!hasFound && ownershipAuctionTokenIDs[seller][len - 1] == tokenId){  //如果最后一个元素才是要删除的
396         hasFound = true;
397       }
398       
399       if(hasFound){
400         delete ownershipAuctionTokenIDs[seller][len-1];
401         ownershipAuctionTokenIDs[seller].length--; //需要将数组的长度减一
402       }
403     }
404   }
405 
406   function _bid(uint256 _tokenId, uint256 _bidAmount) internal returns(uint256){
407     Auction storage auction = tokenIdToAuction[_tokenId];
408 
409     require(_isOnAuction(auction));
410 
411     uint256 price = _currentPrice(auction);
412     require(_bidAmount >= price);
413 
414     address seller = auction.seller;
415     _removeAuction(_tokenId);
416 
417     //将取消拍卖的tokentID从用户正在拍卖的跑图ID集合列表里删除
418     removeFromOwnershipAuctionTokenIDs(seller, _tokenId);
419     
420     //向出售者支付售卖所得。
421     if(price > 0) {
422       uint256 auctioneerCommission = _computeCommission(price);
423       uint256 sellerProceeds = price - auctioneerCommission;
424 
425       seller.transfer(sellerProceeds);
426     }
427 
428     //将余额还给出售者
429     uint256 bidExcess = _bidAmount - price;
430     msg.sender.transfer(bidExcess);
431 
432     emit AuctionSuccessful(_tokenId, price, msg.sender);
433 
434     return price;
435   } 
436 
437   function _removeAuction(uint256 _tokenId) internal {
438     delete tokenIdToAuction[_tokenId];
439   }
440 
441   function _isOnAuction(Auction storage _auction) internal view returns (bool){
442     return (_auction.startedAt > 0);
443   }
444 
445   function _currentPrice(Auction storage _auction) internal view returns (uint256) {
446     uint256 secondsPassed = 0;
447     
448     if(now > _auction.startedAt){
449       secondsPassed = now - _auction.startedAt;
450     }
451 
452     return _computeCurrentPrice(
453       _auction.startingPrice,
454       _auction.endingPrice,
455       _auction.duration,
456       secondsPassed
457     );
458   }
459 
460   //根据拍卖时间计算当前跑图价格
461   function _computeCurrentPrice(
462     uint256 _startingPrice,
463     uint256 _endingPrice,
464     uint256 _duration,
465     uint256 _secondsPassed
466   ) internal pure returns (uint256){
467     
468     if(_secondsPassed >= _duration){	//如果超过竞拍时间，直接取最小价格
469       return _endingPrice;  
470     } else {
471       int256 totalPriceChange = int256(_endingPrice) - int256(_startingPrice);
472       int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);
473 
474       int256 currentPrice = int256(_startingPrice) + currentPriceChange;
475 
476       return uint256(currentPrice); 
477     }
478   }
479 
480   //计算跑图出售佣金
481   function _computeCommission(uint256 _price) internal view returns (uint256) { 
482     return _price * commission / 10000;
483   }
484 
485   //提取账户资金
486   function withdrawBalance() external {
487     address nftAddress = address(nonFungibleContract);  
488     require(msg.sender == owner || msg.sender == nftAddress);
489 
490     nftAddress.transfer(address(this).balance);
491   }
492 
493   //创建拍卖
494   function createAuction(
495     uint256 _tokenId,
496     uint256 _startingPrice,
497     uint256 _endingPrice,
498     uint256 _duration,
499     address _seller
500   ) public
501     canBeStoredWith128Bits(_startingPrice)
502     canBeStoredWith128Bits(_endingPrice)
503     canBeStoredWith64Bits(_duration)
504   {
505     require(msg.sender == address(nonFungibleContract));
506     require(_owns(_seller, _tokenId));
507     _escrow(_seller, _tokenId);
508     Auction memory auction = Auction(
509       _seller,
510       uint128(_startingPrice),
511       uint128(_endingPrice),
512       uint64(_duration),
513       uint64(now)
514     );
515     _addAuction(_tokenId, auction);
516   }
517 
518   function bid(uint256 _tokenId) public payable whenNotPaused {
519     _bid(_tokenId, msg.value);
520     nonFungibleContract.transfer(msg.sender, _tokenId);
521   }
522 
523   function cancelAuction(uint256 _tokenId) public {
524     Auction storage auction = tokenIdToAuction[_tokenId];
525     require(_isOnAuction(auction));
526     address seller = auction.seller;
527     require(msg.sender == seller);
528 
529     _cancelAuction(_tokenId, seller);
530   }
531 
532   function cancelAuctionWhenPaused(uint256 _tokenId) public onlyOwner whenPaused {
533     Auction storage auction = tokenIdToAuction[_tokenId];
534     require(_isOnAuction(auction));
535     _cancelAuction(_tokenId, auction.seller);
536   }
537 
538   function getAuction(uint256 _tokenId) public view returns(
539     address seller,
540     uint256 startingPrice,
541     uint256 endingPrice,
542     uint256 duration,
543     uint256 startedAt
544   ){
545     Auction storage auction = tokenIdToAuction[_tokenId];
546     require(_isOnAuction(auction));
547     return(
548       auction.seller,
549       auction.startingPrice,
550       auction.endingPrice,
551       auction.duration,
552       auction.startedAt
553     );
554   }
555 
556   function getCurrentPrice(uint256 _tokenId) public view returns (uint256){
557     Auction storage auction = tokenIdToAuction[_tokenId];
558     require(_isOnAuction(auction));
559     return _currentPrice(auction);
560   }
561 
562   function getFund() public view returns (uint256 balance){
563     return address(this).balance;
564   }
565 
566   //获取用户当前所有正在拍卖的跑图ID
567   function getAuctionTokenIDsOfOwner(address owner) public view returns(uint256[]){
568     return ownershipAuctionTokenIDs[owner];
569   }
570 }
571 
572 // File: contracts/ChainDrawingsBase.sol
573 
574 contract ChainDrawingsBase is ChainDrawingsAccess, SupportsInterfaceWithLookup, ERC721BasicToken, ERC721Enumerable, ERC721Metadata {
575   using SafeMath for uint256;
576   using AddressUtils for address;
577 
578   string internal name_ = "LianPaoTu";
579   string internal symbol_ = "LPT";
580   
581   //Event
582   event Create(address owner, uint256 drawingsID, bytes32 chainID);
583 
584   //跑图数据结构-目前保存跑图ID和跑图原创者名称。跑图属性、跑图gps数据、跑图示例图片不适合放在以太坊链，需要放在Fabric或IPFS系统里
585   struct ChainDrawings {
586     bytes32 chainID;		//链跑图ID。（对应链跑图ID、创意跑步App内跑图ID）（utf8转码必须是bytes32 或 bytes）
587     bytes32 author;	//原创者名称
588     uint64 createTime;	//链跑图创建时间
589   }
590 
591   //链跑图数组
592   ChainDrawings[] drawings;
593 
594   mapping (bytes32 => uint256) public chainIDToTokenID;   //chainID对应的链跑图ID，用来方便查找和判断跑图是否已上链 (tokenID)
595   mapping (uint256 => string) internal tokenIDToUri; //Mapping from NFT ID to metadata uri. (tokenID)
596 
597 
598   // ERC721Enumerable
599   mapping(address => uint256[]) internal ownedTokens;  //Mapping from owner to list of owned token IDs(不包含正在拍卖的跑图 tokenID)
600   mapping(uint256 => uint256) internal ownedTokensIndex; //Mapping from token ID to index of the owner tokens list(不包含正在拍卖的跑图 tokenID, index)
601   uint256[] internal allTokens; //Array with all token ids, used for enumeration (tokenID)
602   mapping(uint256 => uint256) internal allTokensIndex;  //Mapping from token id to position in the allTokens array(tokenID, index)
603 
604 
605   SaleClockAuction public saleAuction;
606   
607   constructor() public {
608     _registerInterface(InterfaceId_ERC721Enumerable);
609     _registerInterface(InterfaceId_ERC721Metadata);
610   }
611   
612   // Guarantees that _tokenId is a valid Token.  _tokenId ID of the NFT to validate.
613   modifier validNFToken(uint256 _tokenId) {
614     require(tokenIDToOwner[_tokenId] != address(0));
615     _;
616   }
617   
618   function name() external view returns (string) {
619     return name_;
620   }
621   function symbol() external view returns (string) {
622     return symbol_;
623   }
624   function tokenURI(uint256 _tokenId) public view returns (string) {
625     require(_exists(_tokenId));
626     return tokenIDToUri[_tokenId];
627   }
628   function tokenOfOwnerByIndex(address _owner, uint256 _index ) public view returns (uint256) {
629     require(_index < balanceOf(_owner));
630     return ownedTokens[_owner][_index];
631   }
632   function totalSupply() public view returns (uint256) {
633     return allTokens.length;
634   }
635   function tokenByIndex(uint256 _index) public view returns (uint256) {
636     require(_index < totalSupply());
637     return allTokens[_index];
638   }
639   
640   //拍卖时，token地址会转入拍卖合约 ownershipTokenCount
641   function _transfer(address _from, address _to, uint256 _tokenId) internal {
642     if(_from != address(0)){
643       ownershipTokenCount[_from] = ownershipTokenCount[_from].sub(1);  //旧的跑图拥有者，跑图数量减1
644       delete tokenIDToApproved[_tokenId];
645       removeFromOwnedTokens(_from, _tokenId);
646     }
647 
648     ownershipTokenCount[_to] = ownershipTokenCount[_to].add(1);  //新的拥有者，跑图数量加1
649     tokenIDToOwner[_tokenId] = _to;
650 
651     uint256 length = ownedTokens[_to].push(_tokenId);
652     ownedTokensIndex[_tokenId] = length.sub(1);
653 
654     emit Transfer(_from, _to, _tokenId);
655   }
656   
657   function _owns(address _claimant, uint256 _tokenId) internal view returns (bool){
658     return tokenIDToOwner[_tokenId] == _claimant;
659   }
660 
661   function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {
662     return tokenIDToApproved[_tokenId] == _claimant;
663   }
664 
665   function _approve(uint256 _tokenId, address _approved) internal {
666     tokenIDToApproved[_tokenId] = _approved;
667     emit Approval(msg.sender, _approved, _tokenId);
668   }
669 
670   //Required for ERC-721
671   function approve(address _to, uint256 _tokenId) public whenNotPaused {
672     require(_owns(msg.sender, _tokenId));
673     _approve(_tokenId, _to);
674   }
675 
676   //Required for ERC-721
677   function transfer(address _to, uint256 _tokenId) public whenNotPaused{
678     require(_to != address(0));
679     require(_to != address(this));
680     require(_to != address(saleAuction));
681     require(_owns(msg.sender, _tokenId));
682 
683     _transfer(msg.sender, _to, _tokenId);
684   }
685 
686   //Required for ERC-721
687   function transferFrom(address _from, address _to, uint256 _tokenId) public whenNotPaused{
688     require(_to != address(0));
689     require(_to != address(this));
690     require(_approvedFor(msg.sender, _tokenId));
691     require(_owns(_from, _tokenId));
692     _transfer(_from, _to, _tokenId);
693   }
694   
695   //Optional for ERC-721
696   function safeTransferFrom(address _from, address _to, uint256 _tokenId) public whenNotPaused {
697     _safeTransferFrom(_from, _to, _tokenId, "");
698   }
699   
700   //Optional for ERC-721
701   function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) public whenNotPaused {
702     _safeTransferFrom(_from, _to, _tokenId, _data);
703   }
704   
705   function _safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) internal validNFToken(_tokenId) {
706     transferFrom(_from, _to, _tokenId);
707     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
708   }
709  
710   // Optional method for ERC-721(不包含正在出售的)
711   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens){
712     if(balanceOf(_owner) == 0){
713       return new uint256[](0);
714     }else{
715       return ownedTokens[_owner];
716     }
717   }
718 
719   //创建链跑图
720   function _createDrawings(bytes32 _chainID, bytes32 _author, address _owner, string metaUrl) internal returns(uint) {
721     ChainDrawings memory _drawings = ChainDrawings({
722       chainID: _chainID,
723       author: _author,
724       createTime: uint64(now)
725     });
726 
727     uint256 _tokenId = drawings.push(_drawings);
728     _tokenId = _tokenId.sub(1);
729     chainIDToTokenID[_chainID] = _tokenId;
730     require(_tokenId == uint256(uint32(_tokenId)));
731 
732     allTokensIndex[_tokenId] = allTokens.length;
733     allTokens.push(_tokenId);
734     tokenIDToUri[_tokenId] = metaUrl;
735 
736     //emit
737     emit Create(_owner, _tokenId, _chainID);
738     _transfer(address(0), _owner, _tokenId);
739 
740     return _tokenId;
741   }
742 
743   //从用户跑图列表中删除（ERC721Enumerable）
744   function removeFromOwnedTokens(address _owner, uint256 _tokenId) internal {
745     require(tokenIDToOwner[_tokenId] == _owner);
746     uint len = ownedTokens[_owner].length;
747     assert(len > 0);
748 
749     if(len == 1){
750       delete ownedTokens[_owner];
751       delete ownedTokensIndex[_tokenId];
752       return;
753     }
754 
755     uint256 tokenToRemoveIndex = ownedTokensIndex[_tokenId];
756 
757     if(tokenToRemoveIndex == len.sub(1)){
758       ownedTokens[_owner].length = ownedTokens[_owner].length.sub(1);
759       delete ownedTokensIndex[_tokenId];
760       return;
761     }
762 
763     uint256 lastToken = ownedTokens[_owner][len.sub(1)];
764 
765     ownedTokens[_owner][tokenToRemoveIndex] = lastToken;
766     ownedTokensIndex[lastToken] = tokenToRemoveIndex;
767     ownedTokens[_owner].length = ownedTokens[_owner].length.sub(1);
768     delete ownedTokensIndex[_tokenId];
769   }
770 }
771 
772 // File: contracts/ChainDrawingsAuction.sol
773 
774 contract ChainDrawingsAuction is ChainDrawingsBase {
775 
776   function setSaleAuctionAddress(address _address) public onlyOwner {
777     SaleClockAuction candidateContract = SaleClockAuction(_address);
778     require(candidateContract.isSaleClockAuction());
779 
780     saleAuction = candidateContract;
781   }
782 
783   function createSaleAuction(
784     uint256 _tokenID,
785     uint256 _startingPrice,
786     uint256 _endingPrice,
787     uint256 _duration
788   ) public whenNotPaused {
789 
790     require(_owns(msg.sender, _tokenID));
791     approve(saleAuction, _tokenID);
792     saleAuction.createAuction(_tokenID, _startingPrice, _endingPrice, _duration, msg.sender);
793   }
794 
795   function withdrawAuctionBalances() external onlyOwner {
796     saleAuction.withdrawBalance();
797   }
798 }
799 
800 // File: contracts/ChainDrawingsGeneration.sol
801 
802 contract ChainDrawingsGeneration is ChainDrawingsAuction {
803   //为原创者创建上链跑图
804   function createAuthorDrawings(bytes32 _chainID, 
805                                 bytes32 _author, 
806                                 address _owner, 
807                                 string _metaUrl) public onlyOwner {
808     //通过chainID查找跑图
809     uint256 tokenID = chainIDToTokenID[_chainID];
810     if(tokenID != 0){  //链跑图已存在，仅修改跑图属性
811       ChainDrawings storage drawing = drawings[tokenID];
812       drawing.author = _author;
813 
814       return;
815     }
816 
817     if(_owner == address(0)){
818       _owner = owner;
819     }
820     _createDrawings(_chainID, _author, _owner, _metaUrl);
821   }
822 
823   //为跑地图创建上链跑图(原创者署名为”跑地图“的跑图，即是创意跑步设计作品)
824   function createInternalAuction(bytes32 _chainID, 
825                                 bytes32 _author, 
826                                 uint256 _startingPrice,
827                                 uint256 _endingPrice,
828                                 uint256 _duration, 
829                                 string _metaUrl) public onlyOwner {
830     //通过chainID查找跑图
831     uint256 tokenID  = chainIDToTokenID[_chainID];
832     if(tokenID != 0){  //链跑图已存在，仅修改跑图属性
833       ChainDrawings storage drawing = drawings[tokenID];
834       drawing.author = _author;
835 
836       return;
837     }
838 
839     uint256 newTokenID = _createDrawings(_chainID, _author, address(this), _metaUrl);
840     _approve(newTokenID, saleAuction);
841 
842     saleAuction.createAuction(
843       newTokenID,
844       _startingPrice,
845       _endingPrice,
846       _duration,
847       address(this)
848     );
849   }
850 }
851 
852 // File: contracts/BatchCreateDrawingsInterface.sol
853 
854 // 批量增加链跑图接口
855 contract BatchCreateDrawingsInterface {
856   function isBatchCreateDrawings() public pure returns (bool);
857 
858   // 获取内部链跑图
859   function getInternalDrawings(uint index) public returns (bytes32 _chainID, 
860                                 uint256 _startingPrice,
861                                 uint256 _endingPrice,
862                                 uint256 _duration, 
863                                 string memory _metaUrl);
864 
865   // 获取原创者链跑图
866   function getAuthorDrawings(uint index) public returns (bytes32 _chainID, 
867                                 bytes32 _author, 
868                                 address _owner, 
869                                 string memory _metaUrl);
870 }
871 
872 // File: contracts/ChainDrawingsCore.sol
873 
874 contract ChainDrawingsCore is ChainDrawingsGeneration {
875   address public newContractAddress;
876   BatchCreateDrawingsInterface public batchCreateDrawings;
877   
878   constructor() public {
879     paused = true;
880     owner = msg.sender;
881     _createDrawings("-1",  "-1", address(0), "https://chain.chuangyipaobu.com"); //创建合约的时候，需要把默认的0位排除掉
882   }
883   
884   //设置批量导入合约地址
885   function setBatchCreateDrawingsAddress(address _address) external onlyOwner {
886     BatchCreateDrawingsInterface candidateContract = BatchCreateDrawingsInterface(_address);
887     require(candidateContract.isBatchCreateDrawings());
888 
889     // Set the new contract address
890     batchCreateDrawings = candidateContract;
891   }
892 
893   //批量生成内部链跑图
894   function batchCreateInternalDrawings() internal onlyOwner {
895     require(batchCreateDrawings != address(0));
896 
897     bytes32 chainID;
898     uint256 startingPrice;
899     uint256 endingPrice;
900     uint256 duration;
901     string memory metaUrl;
902     uint index = 0;
903 
904     while(index < 20){	//避免死循环和执行失败，最多一次创建20个链跑图
905       (chainID, startingPrice, endingPrice, duration, metaUrl) = batchCreateDrawings.getInternalDrawings(index++);
906       if(chainID == "0"){
907         return;
908       }
909 
910       if(chainIDToTokenID[chainID] > 0){
911         continue;
912       }
913     
914       createInternalAuction(chainID, "跑地图", startingPrice, endingPrice, duration, metaUrl);
915     }
916   }
917 
918   //批量生成原创者链跑图
919   function batchCreateAuthorDrawings() internal onlyOwner {
920     require(batchCreateDrawings != address(0));
921 
922     bytes32 chainID;
923     bytes32 author;
924     address owner; 
925     string memory metaUrl;
926     uint index = 0;
927 
928     while(index < 20){	//避免死循环和执行失败，最多一次创建20个链跑图
929       (chainID, author, owner, metaUrl) = batchCreateDrawings.getAuthorDrawings(index++);
930       if(chainID == "0"){
931         return;
932       }
933       if(chainIDToTokenID[chainID] > 0){
934         continue;
935       }  
936 
937       createAuthorDrawings(chainID, author, owner, metaUrl);
938     }
939   }
940 
941   //批量生成链跑图
942   function batchCreateDrawings() external onlyOwner {
943     batchCreateInternalDrawings();
944     batchCreateAuthorDrawings();
945   }
946 
947   //永久终止合约
948   function setNewAddress(address _newAddress) external onlyOwner whenPaused {
949     newContractAddress = _newAddress;
950     emit ContractUpgrade(_newAddress);
951   }
952 
953   function() external payable {
954     require(msg.sender == address(saleAuction));
955   }
956 
957   function getChainDrawings(uint256 _id) public view returns(
958       uint256 tokenID,
959       bytes32 chainID,  //链跑图ID。（对应链跑图ID、创意跑步App内跑图ID）
960       bytes32 author,   //原创者名称
961       uint256 createTime
962   ) {
963     ChainDrawings storage drawing = drawings[_id];
964 
965     tokenID = _id;
966     chainID = drawing.chainID;
967     author = drawing.author;
968     createTime = drawing.createTime;
969   }
970 
971   //获取主合约地址
972   function getCoreAddress() external view returns(address){
973     return address(this);
974   }
975 
976   //获取拍卖合约地址
977   function getSaleAuctionAddress() external view returns(address){
978     return address(saleAuction);
979   }
980 
981   //获取批量导入合约地址
982   function getBatchCreateDrawingsAddress() external view returns(address){
983     return address(batchCreateDrawings);
984   }
985 
986   function unpause() public onlyOwner whenPaused {
987     require(saleAuction != address(0));
988     require(newContractAddress == address(0));
989 
990     super.unpause();
991   }
992 
993   //通过跑图chainID，获取链跑图信息
994   function getChainDrawingsByChainID(bytes32 _chainID) external view returns(
995       uint256 tokenID,
996       bytes32 chainID,        //链跑图ID。（对应链跑图ID、创意跑步App内跑图ID）
997       bytes32 author,   //原创者名称
998       uint256 createTime         //链跑图创建时间
999   ){
1000     tokenID = chainIDToTokenID[_chainID];
1001     return getChainDrawings(tokenID);
1002   }
1003 
1004   function getFund() external view returns (uint256 balance){
1005     return address(this).balance;
1006   }
1007 
1008   //获取用户名下所有的TokenID（包含正在出售的）
1009   function getAllTokensOfUser(address _owner) public view returns (uint256[]){
1010     uint256[] memory ownerTokensNonAuction = this.tokensOfOwner(_owner);
1011     uint256[] memory ownerTokensAuction = saleAuction.getAuctionTokenIDsOfOwner(_owner);
1012     
1013     uint length1 = ownerTokensNonAuction.length;
1014     uint length2 = ownerTokensAuction.length;
1015     uint length = length1 + length2;
1016 
1017     if(length == 0) return;
1018 
1019     uint256[] memory result = new uint[](length);
1020     uint index = 0;
1021 
1022     for (uint i=0; i<length2; i++) {
1023       result[index++] = ownerTokensAuction[i];
1024     }
1025     for (uint j=0; j<length1; j++) {
1026       result[index++] = ownerTokensNonAuction[j];
1027     }
1028     
1029     return result;
1030   }
1031   
1032   //获取用户名下所有的ChainID（包含正在出售的）
1033   function getAllChainIDsOfUser(address _owner) external view returns (bytes32[]){
1034     uint256[] memory ownerTokens = this.getAllTokensOfUser(_owner);
1035     uint len = ownerTokens.length;
1036  
1037     if(len == 0) return;
1038 
1039     bytes32[] memory ownerChainIDs = new bytes32[](len);
1040     for (uint i=0; i<len; i++) {
1041       ChainDrawings storage drawing = drawings[ownerTokens[i]];
1042       ownerChainIDs[i] = drawing.chainID;
1043     }
1044     return ownerChainIDs;
1045   }
1046 
1047   //获取用户名下跑图总数（包含正在出售的）
1048   function getTokensCountOfUser(address _owner) external view returns (uint256){
1049     uint256[] memory ownerTokensNonAuction = this.tokensOfOwner(_owner);
1050     uint256[] memory ownerTokensAuction = saleAuction.getAuctionTokenIDsOfOwner(_owner);
1051     
1052     uint length1 = ownerTokensNonAuction.length;
1053     uint length2 = ownerTokensAuction.length;
1054     return length1 + length2;
1055   }
1056 }