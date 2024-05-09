1 pragma solidity ^0.4.18; // solhint-disable-line
2 
3 library SafeMath {
4 
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0) {
7       return 0;
8     }
9     uint256 c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     uint256 c = a / b;
16     return c;
17   }
18 
19   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function add(uint256 a, uint256 b) internal pure returns (uint256) {
25     uint256 c = a + b;
26     assert(c >= a);
27     return c;
28   }
29 }
30 
31 contract ERC721 {
32     function approve(address _to, uint256 _tokenID) public;
33     function balanceOf(address _owner) public view returns (uint256 balance);
34     function implementsERC721() public pure returns (bool);
35     function ownerOf(uint256 _tokenID) public view returns (address addr);
36     function takeOwnership(uint256 _tokenID) public;
37     function totalSupply() public view returns (uint256 total);
38     function transferFrom(address _from, address _to, uint256 _tokenID) public;
39     function transfer(address _to, uint256 _tokenID) public;
40 
41     event Transfer(address indexed from, address indexed to, uint256 tokenID); // solhint-disable-line
42     event Approval(address indexed owner, address indexed approved, uint256 tokenID);
43 
44     function name() public pure returns (string);
45     function symbol() public pure returns (string);
46 }
47 
48 contract Ownable {
49   address public owner;
50 
51   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53   function Ownable() public {
54     owner = msg.sender;
55   }
56 
57   modifier onlyOwner() {
58     require(msg.sender == owner);
59     _;
60   }
61 
62   function transferOwnership(address newOwner) public onlyOwner {
63     require(newOwner != address(0));
64     OwnershipTransferred(owner, newOwner);
65     owner = newOwner;
66   }
67 }
68 
69 contract Manageable is Ownable {
70 
71     address public manager;
72     bool public contractLock;
73 
74     event ManagerTransferred(address indexed previousManager, address indexed newManager);
75     event ContractLockChanged(address admin, bool state);
76 
77     function Manageable() public {
78         manager = msg.sender;
79         contractLock = false;
80     }
81 
82     modifier onlyManager() {
83         require(msg.sender == manager);
84         _;
85     }
86 
87     modifier onlyAdmin() {
88         require((msg.sender == manager) || (msg.sender == owner));
89         _;
90     }
91 
92     modifier isUnlocked() {
93         require(!contractLock);
94         _;
95     }
96 
97     function transferManager(address newManager) public onlyAdmin {
98         require(newManager != address(0));
99         ManagerTransferred(manager, newManager);
100         manager = newManager;
101     }
102 
103     function setContractLock(bool setting) public onlyAdmin {
104         contractLock = setting;
105         ContractLockChanged(msg.sender, setting);
106     }
107 
108     function payout(address _to) public onlyOwner {
109         if (_to == address(0)) {
110             owner.transfer(this.balance);
111         } else {
112             _to.transfer(this.balance);
113         }
114     }
115 
116     function withdrawFunds(address _to, uint256 amount) public onlyOwner {
117         require(this.balance >= amount);
118         if (_to == address(0)) {
119             owner.transfer(amount);
120         } else {
121             _to.transfer(amount);
122         }
123     }
124 }
125 
126 contract TokenLayer is ERC721, Manageable {
127 
128     using SafeMath for uint256;
129 
130 /********************************************** EVENTS **********************************************/
131     event TokenCreated(uint256 tokenId, bytes32 name, uint256 parentId, address owner);
132     event TokenDeleted(uint256 tokenId);
133 
134     event TokenSold(
135         uint256 tokenId, uint256 oldPrice,
136         uint256 newPrice, address prevOwner,
137         address winner, bytes32 name,
138         uint256 parentId
139     );
140 
141     event PriceChanged(uint256 tokenId, uint256 oldPrice, uint256 newPrice);
142     event ParentChanged(uint256 tokenId, uint256 oldParentId, uint256 newParentId);
143     event NameChanged(uint256 tokenId, bytes32 oldName, bytes32 newName);
144     event MetaDataChanged(uint256 tokenId, bytes32 oldMeta, bytes32 newMeta);
145 /****************************************************************************************************/
146 
147 /******************************************** STORAGE ***********************************************/
148     uint256 private constant DEFAULTPARENT = 123456789;
149 
150     mapping (uint256 => Token)   private tokenIndexToToken;
151     mapping (address => uint256) private ownershipTokenCount;
152 
153     address public gameAddress;
154     address public parentAddr;
155 
156     uint256 private totalTokens;
157     uint256 public devFee = 50;
158     uint256 public ownerFee = 200;
159     uint256[10] private chainFees = [10];
160 
161     struct Token {
162         bool exists;
163         address approved;
164         address owner;
165         bytes32 metadata;
166         bytes32 name;
167         uint256 lastBlock;
168         uint256 parentId;
169         uint256 price;
170     }
171 /****************************************************************************************************/
172 
173 /******************************************* MODIFIERS **********************************************/
174     modifier onlySystem() {
175         require((msg.sender == gameAddress) || (msg.sender == manager));
176         _;
177     }
178 /****************************************************************************************************/
179 
180 /****************************************** CONSTRUCTOR *********************************************/
181     function TokenLayer(address _gameAddress, address _parentAddr) public {
182         gameAddress = _gameAddress;
183         parentAddr = _parentAddr;
184     }
185 /****************************************************************************************************/
186 
187 /********************************************** PUBLIC **********************************************/
188     function implementsERC721() public pure returns (bool) {
189         return true;
190     }
191 
192     function name() public pure returns (string) {
193         return "LayerName";
194     }
195 
196     function symbol() public pure returns (string) {
197         return "LayerSymbol";
198     }
199 
200     function approve(address _to, uint256 _tokenId, address _from) public onlySystem {
201         _approve(_to, _tokenId, _from);
202     }
203 
204     function approve(address _to, uint256 _tokenId) public isUnlocked {
205         _approve(_to, _tokenId, msg.sender);
206     }
207 
208     function balanceOf(address _owner) public view returns (uint256 balance) {
209         return ownershipTokenCount[_owner];
210     }
211 
212     function bundleToken(uint256 _tokenId) public view returns(uint256[8] _tokenData) {
213         Token storage token = tokenIndexToToken[_tokenId];
214 
215         uint256[8] memory tokenData;
216 
217         tokenData[0] = uint256(token.name);
218         tokenData[1] = token.parentId;
219         tokenData[2] = token.price;
220         tokenData[3] = uint256(token.owner);
221         tokenData[4] = _getNextPrice(_tokenId);
222         tokenData[5] = devFee+getChainFees(_tokenId);
223         tokenData[6] = uint256(token.approved);
224         tokenData[7] = uint256(token.metadata);
225         return tokenData;
226     }
227 
228     function takeOwnership(uint256 _tokenId, address _to) public onlySystem {
229         _takeOwnership(_tokenId, _to);
230     }
231 
232     function takeOwnership(uint256 _tokenId) public isUnlocked {
233         _takeOwnership(_tokenId, msg.sender);
234     }
235 
236     function tokensOfOwner(address _owner) public view returns (uint256[] ownerTokens) {
237         uint256 tokenCount = balanceOf(_owner);
238         if (tokenCount == 0) {
239             return new uint256[](0);
240         } else {
241             uint256[] memory result = new uint256[](tokenCount);
242             uint256 _totalTokens = totalSupply();
243             uint256 resultIndex = 0;
244 
245             uint256 tokenId = 0;
246             uint256 tokenIndex = 0;
247             while (tokenIndex <= _totalTokens) {
248                 if (exists(tokenId)) {
249                     tokenIndex++;
250                     if (tokenIndexToToken[tokenId].owner == _owner) {
251                         result[resultIndex] = tokenId;
252                         resultIndex++;
253                     }
254                 }
255                 tokenId++;
256             }
257             return result;
258         }
259     }
260 
261     function totalSupply() public view returns (uint256 total) {
262         return totalTokens;
263     }
264 
265     function transfer(address _to, address _from, uint256 _tokenId) public onlySystem {
266         _checkThenTransfer(_from, _to, _tokenId);
267     }
268 
269     function transfer(address _to, uint256 _tokenId) public isUnlocked {
270         _checkThenTransfer(msg.sender, _to, _tokenId);
271     }
272 
273     function transferFrom(address _from, address _to, uint256 _tokenId) public onlySystem {
274         _transferFrom(_from, _to, _tokenId);
275     }
276 
277     function transferFrom(address _from, uint256 _tokenId) public isUnlocked {
278         _transferFrom(_from, msg.sender, _tokenId);
279     }
280 
281     function createToken(
282         uint256 _tokenId, address _owner,
283         bytes32 _name, uint256 _parentId,
284         uint256 _price, bytes32 _metadata
285     ) public onlyAdmin {
286         require(_price > 0);
287         require(_addressNotNull(_owner));
288         require(_tokenId == uint256(uint32(_tokenId)));
289         require(!exists(_tokenId));
290 
291         totalTokens++;
292 
293         Token memory _token = Token({
294             name: _name,
295             parentId: _parentId,
296             exists: true,
297             price: _price,
298             owner: _owner,
299             approved : 0,
300             lastBlock : block.number,
301             metadata : _metadata
302         });
303 
304         tokenIndexToToken[_tokenId] = _token;
305 
306         TokenCreated(_tokenId, _name, _parentId, _owner);
307 
308         _transfer(address(0), _owner, _tokenId);
309     }
310 
311     function createTokens(
312         uint256[] _tokenIds, address[] _owners,
313         bytes32[] _names, uint256[] _parentIds,
314         uint256[] _prices, bytes32[] _metadatas
315     ) public onlyAdmin {
316         for (uint256 id = 0; id < _tokenIds.length; id++) {
317             createToken(
318                 _tokenIds[id], _owners[id], _names[id],
319                 _parentIds[id], _prices[id], _metadatas[id]
320                 );
321         }
322     }
323 
324     function deleteToken(uint256 _tokenId) public onlyAdmin {
325         require(_tokenId == uint256(uint32(_tokenId)));
326         require(exists(_tokenId));
327         totalTokens--;
328 
329         address oldOwner = tokenIndexToToken[_tokenId].owner;
330 
331         ownershipTokenCount[oldOwner] = ownershipTokenCount[oldOwner]--;
332         delete tokenIndexToToken[_tokenId];
333         TokenDeleted(_tokenId);
334     }
335 
336     function incrementPrice(uint256 _tokenId, address _to) public onlySystem {
337         require(exists(_tokenId));
338         uint256 _price = tokenIndexToToken[_tokenId].price;
339         address _owner = tokenIndexToToken[_tokenId].owner;
340         uint256 _totalFees = getChainFees(_tokenId);
341         tokenIndexToToken[_tokenId].price = _price.mul(1000+ownerFee).div(1000-(devFee+_totalFees));
342 
343         TokenSold(
344             _tokenId, _price, tokenIndexToToken[_tokenId].price,
345             _owner, _to, tokenIndexToToken[_tokenId].name,
346             tokenIndexToToken[_tokenId].parentId
347         );
348     }
349 
350     function ownerOf(uint256 _tokenId) public view returns (address _owner) {
351         require(exists(_tokenId));
352         _owner = tokenIndexToToken[_tokenId].owner;
353     }
354 
355     function blocked(uint256 _tokenId) public view returns (bool _blocked) {
356         return (tokenIndexToToken[_tokenId].lastBlock == block.number);
357     }
358 
359     function exists(uint256 _tokenId) public view returns(bool) {
360         return (tokenIndexToToken[_tokenId].exists);
361     }
362 /****************************************************************************************************/
363 
364 /********************************************** SETTERS *********************************************/
365     function setLayerParent(address _parent) public onlyAdmin {
366         parentAddr = _parent;
367     }
368 
369     function setGame(address _gameAddress) public onlyAdmin {
370         gameAddress = _gameAddress;
371     }
372 
373     function setPrice(uint256 _tokenId, uint256 _price, address _owner) public onlySystem {
374         require(_owns(_owner, _tokenId));
375         uint256 oldPrice = tokenIndexToToken[_tokenId].price;
376         tokenIndexToToken[_tokenId].price = _price;
377         PriceChanged(_tokenId, oldPrice, _price);
378     }
379 
380     function setParent(uint256 _tokenId, uint256 _parentId) public onlyAdmin {
381         require(exists(_tokenId));
382         uint256 oldParentId = tokenIndexToToken[_tokenId].parentId;
383         tokenIndexToToken[_tokenId].parentId = _parentId;
384         ParentChanged(_tokenId, oldParentId, _parentId);
385     }
386 
387     function setName(uint256 _tokenId, bytes32 _name) public onlyAdmin {
388         require(exists(_tokenId));
389         bytes32 oldName = tokenIndexToToken[_tokenId].name;
390         tokenIndexToToken[_tokenId].name = _name;
391         NameChanged(_tokenId, oldName, _name);
392     }
393 
394     function setMetadata(uint256 _tokenId, bytes32 _metadata) public onlyAdmin {
395         require(exists(_tokenId));
396         bytes32 oldMeta = tokenIndexToToken[_tokenId].metadata;
397         tokenIndexToToken[_tokenId].metadata = _metadata;
398         MetaDataChanged(_tokenId, oldMeta, _metadata);
399     }
400 
401     function setDevFee(uint256 _devFee) public onlyAdmin {
402         devFee = _devFee;
403     }
404 
405     function setOwnerFee(uint256 _ownerFee) public onlyAdmin {
406         ownerFee = _ownerFee;
407     }
408 
409     function setChainFees(uint256[10] _chainFees) public onlyAdmin {
410         chainFees = _chainFees;
411     }
412 /****************************************************************************************************/
413 
414 /********************************************** GETTERS *********************************************/
415     function getToken(uint256 _tokenId) public view returns
416     (
417         bytes32 tokenName, uint256 parentId, uint256 price,
418         address _owner, uint256 nextPrice, uint256 nextPriceFees,
419         address approved, bytes32 metadata
420     ) {
421         Token storage token = tokenIndexToToken[_tokenId];
422 
423         tokenName = token.name;
424         parentId = token.parentId;
425         price = token.price;
426         _owner = token.owner;
427         nextPrice = _getNextPrice(_tokenId);
428         nextPriceFees = devFee+getChainFees(_tokenId);
429         metadata = token.metadata;
430         approved = token.approved;
431     }
432 
433     function getChainFees(uint256 _tokenId) public view returns (uint256 _total) {
434         uint256 chainLength = _getChainLength(_tokenId);
435         uint256 totalFee = 0;
436         for (uint id = 0; id < chainLength; id++) {
437             totalFee = totalFee + chainFees[id];
438         }
439         return(totalFee);
440     }
441 
442     function getChainFeeArray() public view returns (uint256[10] memory _chainFees) {
443         return(chainFees);
444     }
445 
446     function getPriceOf(uint256 _tokenId) public view returns (uint256 price) {
447         require(exists(_tokenId));
448         return tokenIndexToToken[_tokenId].price;
449     }
450 
451     function getParentOf(uint256 _tokenId) public view returns (uint256 parentId) {
452         require(exists(_tokenId));
453         return tokenIndexToToken[_tokenId].parentId;
454     }
455 
456     function getMetadataOf(uint256 _tokenId) public view returns (bytes32 metadata) {
457         require(exists(_tokenId));
458         return (tokenIndexToToken[_tokenId].metadata);
459     }
460 
461     function getChain(uint256 _tokenId) public view returns (address[10] memory _owners) {
462         require(exists(_tokenId));
463 
464         uint256 _parentId = getParentOf(_tokenId);
465         address _parentAddr = parentAddr;
466 
467         address[10] memory result;
468 
469         if (_parentId != DEFAULTPARENT && _addressNotNull(_parentAddr)) {
470             uint256 resultIndex = 0;
471 
472             TokenLayer layer = TokenLayer(_parentAddr);
473             bool parentExists = layer.exists(_parentId);
474 
475             while ((_parentId != DEFAULTPARENT) && _addressNotNull(_parentAddr) && parentExists) {
476                 parentExists = layer.exists(_parentId);
477                 if (!parentExists) {
478                     return(result);
479                 }
480                 result[resultIndex] = layer.ownerOf(_parentId);
481                 resultIndex++;
482 
483                 _parentId = layer.getParentOf(_parentId);
484                 _parentAddr = layer.parentAddr();
485 
486                 layer = TokenLayer(_parentAddr);
487             }
488 
489             return(result);
490         }
491     }
492 /****************************************************************************************************/
493 
494 /******************************************** PRIVATE ***********************************************/
495     function _addressNotNull(address _to) private pure returns (bool) {
496         return _to != address(0);
497     }
498 
499     function _approved(address _to, uint256 _tokenId) private view returns (bool) {
500         return (tokenIndexToToken[_tokenId].approved == _to);
501     }
502 
503     function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
504         return claimant == tokenIndexToToken[_tokenId].owner;
505     }
506 
507     function _checkThenTransfer(address _from, address _to, uint256 _tokenId) private {
508         require(_owns(_from, _tokenId));
509         require(_addressNotNull(_to));
510         require(exists(_tokenId));
511         _transfer(_from, _to, _tokenId);
512     }
513 
514     function _transfer(address _from, address _to, uint256 _tokenId) private {
515         ownershipTokenCount[_to]++;
516         tokenIndexToToken[_tokenId].owner = _to;
517         tokenIndexToToken[_tokenId].lastBlock = block.number;
518 
519         if (_from != address(0)) {
520             ownershipTokenCount[_from]--;
521             tokenIndexToToken[_tokenId].approved = 0;
522         }
523 
524         Transfer(_from, _to, _tokenId);
525     }
526 
527     function _approve(address _to, uint256 _tokenId, address _from) private {
528         require(_owns(_from, _tokenId));
529 
530         tokenIndexToToken[_tokenId].approved = _to;
531 
532         Approval(_from, _to, _tokenId);
533     }
534 
535     function _takeOwnership(uint256 _tokenId, address _to) private {
536         address newOwner = _to;
537         address oldOwner = tokenIndexToToken[_tokenId].owner;
538 
539         require(_addressNotNull(newOwner));
540         require(_approved(newOwner, _tokenId));
541 
542         _transfer(oldOwner, newOwner, _tokenId);
543     }
544 
545     function _transferFrom(address _from, address _to, uint256 _tokenId) private {
546         require(_owns(_from, _tokenId));
547         require(_approved(_to, _tokenId));
548         require(_addressNotNull(_to));
549 
550         _transfer(_from, _to, _tokenId);
551     }
552 
553     function _getChainLength(uint256 _tokenId) private view returns (uint256 _length) {
554         uint256 length;
555 
556         uint256 _parentId = getParentOf(_tokenId);
557         address _parentAddr = parentAddr;
558         if (_parentId == DEFAULTPARENT || !_addressNotNull(_parentAddr)) {
559             return 0;
560         }
561 
562         TokenLayer layer = TokenLayer(_parentAddr);
563         bool parentExists = layer.exists(_parentId);
564 
565         while ((_parentId != DEFAULTPARENT) && _addressNotNull(_parentAddr) && parentExists) {
566             parentExists = layer.exists(_parentId);
567             if(!parentExists) {
568                     return(length);
569             }
570             _parentId = layer.getParentOf(_parentId);
571             _parentAddr = layer.parentAddr();
572             layer = TokenLayer(_parentAddr);
573             length++;
574         }
575 
576         return(length);
577     }
578 
579     function _getNextPrice(uint256 _tokenId) private view returns (uint256 _nextPrice) {
580         uint256 _price = tokenIndexToToken[_tokenId].price;
581         uint256 _totalFees = getChainFees(_tokenId);
582         _price = _price.mul(1000+ownerFee).div(1000-(devFee+_totalFees));
583         return(_price);
584     }
585 }
586 
587 contract CoreContract is Manageable {
588 
589     using SafeMath for uint256;
590 
591 /******************************************** STORAGE ***********************************************/
592 
593     bool public priceLocked = true;
594     uint256 private constant DEFAULTPARENT = 123456789;
595 
596     uint256 public layerCount;
597     mapping(uint256 => address) public getLayerFromId;
598     mapping(uint256 => bytes32) public getLayerNameFromId;
599     mapping(address => bool) private blacklisted;
600 
601     bool public blackListActive;
602     bool public blockLockActive;
603 
604 
605 /********************************************** PUBLIC **********************************************/
606     function approve(address _to, uint256 _tokenId, uint256 layerId) public isUnlocked {
607         address layerAddr = getLayerFromId[layerId];
608         TokenLayer layer = TokenLayer(layerAddr);
609         layer.approve(_to, _tokenId, msg.sender);
610     }
611 
612     function takeOwnership(uint256 _tokenId, uint256 layerId) public isUnlocked {
613         address layerAddr = getLayerFromId[layerId];
614         TokenLayer layer = TokenLayer(layerAddr);
615         layer.takeOwnership(_tokenId, msg.sender);
616     }
617 
618     function transfer(address _to, uint256 _tokenId, uint256 layerId) public isUnlocked {
619         address layerAddr = getLayerFromId[layerId];
620         TokenLayer layer = TokenLayer(layerAddr);
621         layer.transfer(_to, msg.sender, _tokenId);
622     }
623 
624     function setPrice(uint256 _tokenId, uint256 _price, uint256 layerId) public isUnlocked {
625         address layerAddr = getLayerFromId[layerId];
626         require(!priceLocked);
627         TokenLayer layer = TokenLayer(layerAddr);
628         layer.setPrice(_tokenId, _price, msg.sender);
629     }
630 
631     function transferFrom(address _from, uint256 _tokenId, uint256 layerId) public isUnlocked {
632         address layerAddr = getLayerFromId[layerId];
633         TokenLayer layer = TokenLayer(layerAddr);
634         layer.transferFrom(_from, msg.sender, _tokenId);
635     }
636 
637     function purchase(uint256 _tokenId, uint256 layerId) public payable isUnlocked {
638         if (!_blackListed(msg.sender)) {
639             address layerAddr = getLayerFromId[layerId];
640             TokenLayer layer = TokenLayer(layerAddr);
641 
642             address _owner = layer.ownerOf(_tokenId);
643             uint256 price = layer.getPriceOf(_tokenId);
644 
645             uint256 excess = msg.value.sub(price);
646             require(_owner != msg.sender);
647 
648             require(msg.value >= price);
649 
650             require(!blockLockActive || !layer.blocked(_tokenId));
651 
652             layer.incrementPrice(_tokenId, msg.sender);
653             layer.transfer(msg.sender, _owner, _tokenId);
654 
655             uint256 payment = _updatePayment(_tokenId, layerAddr, price);
656 
657             if (_owner != address(this)) {
658                 _owner.transfer(payment);
659             }
660 
661             _payChain(_tokenId, layerAddr, price);
662 
663             msg.sender.transfer(excess);
664             owner.transfer(this.balance);
665         }
666     }
667 
668     function addLayer(address _layerAddr, uint256 layerId, bytes32 _name) public onlyAdmin {
669         require(!_addressNotNull(getLayerFromId[layerId]));
670         getLayerFromId[layerId] = _layerAddr;
671         getLayerNameFromId[layerId] = _name;
672         layerCount++;
673     }
674 
675     function deleteLayer(uint256 layerId) public onlyAdmin {
676         require(_addressNotNull(getLayerFromId[layerId]));
677         getLayerFromId[layerId] = address(0);
678         getLayerNameFromId[layerId] = "";
679         layerCount--;
680     }
681 
682     function getToken(uint256 _tokenId, uint256 layerId) public view returns(
683             bytes32 tokenName, uint256 parentId, uint256 price,
684             address _owner, uint256 nextPrice, uint256 nextPriceFees,
685             address approved, bytes32 metadata
686         ) {
687         address layerAddr = getLayerFromId[layerId];
688         TokenLayer layer = TokenLayer(layerAddr);
689 
690         uint256[8] memory tokenData = layer.bundleToken(_tokenId);
691 
692         tokenName = bytes32(tokenData[0]);
693         parentId = tokenData[1];
694         price = tokenData[2];
695         _owner = address(tokenData[3]);
696 
697         nextPrice = tokenData[4];
698         nextPriceFees = tokenData[5];
699         approved = address(tokenData[6]);
700         metadata = bytes32(tokenData[7]);
701     }
702 
703     function setPriceLocked(bool setting) public onlyAdmin {
704         priceLocked = setting;
705     }
706 
707     function setBlacklist(bool setting) public onlyAdmin {
708         blackListActive = setting;
709     }
710 
711     function setBlockLock(bool setting) public onlyAdmin {
712         blockLockActive = setting;
713     }
714 
715     function addToBlacklist(address _to) public onlyAdmin {
716         blacklisted[_to] = true;
717     }
718 
719     function removeFromBlacklist(address _to) public onlyAdmin {
720         blacklisted[_to] = false;
721     }
722 /****************************************************************************************************/
723 
724 /******************************************** PRIVATE ***********************************************/
725     function _payChain(uint256 _tokenId, address layerAddr, uint256 _price) public
726     {
727         TokenLayer mainLayer = TokenLayer(layerAddr);
728 
729         uint256[10] memory _chainFees = mainLayer.getChainFeeArray();
730         address[10] memory _owners = mainLayer.getChain(_tokenId);
731 
732         for (uint256 i = 0; i < 10; i++) {
733             if (_addressNotNull(_owners[i])) {
734                 _owners[i].transfer(_price.mul(_chainFees[i]).div(1000));
735             }
736         }
737     }
738 
739     function _updatePayment(uint256 _tokenId, address layerAddr, uint _price) private view returns(uint256 _payment) {
740         TokenLayer layer = TokenLayer(layerAddr);
741 
742         uint256 devFee = layer.devFee();
743         uint256 totalFee = layer.getChainFees(_tokenId);
744 
745         uint256 payment = _price.mul(1000-(devFee+totalFee)).div(1000);
746 
747         return(payment);
748     }
749 
750     function _addressNotNull(address _to) private pure returns (bool) {
751         return _to != address(0);
752     }
753 
754     function _blackListed(address _payer) private view returns (bool) {
755         return (blacklisted[_payer]) && (blackListActive);
756     }
757 }