1 pragma solidity ^0.4.18; // solhint-disable-line
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) {
7             return 0;
8         }
9         uint256 c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         uint256 c = a / b;
16         return c;
17     }
18 
19     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20         assert(b <= a);
21         return a - b;
22     }
23 
24     function add(uint256 a, uint256 b) internal pure returns (uint256) {
25         uint256 c = a + b;
26         assert(c >= a);
27         return c;
28     }
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
49     address public owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     function Ownable() public {
54         owner = msg.sender;
55     }
56 
57     modifier onlyOwner() {
58         require(msg.sender == owner);
59         _;
60     }
61 
62     function transferOwnership(address newOwner) public onlyOwner {
63         require(newOwner != address(0));
64         OwnershipTransferred(owner, newOwner);
65         owner = newOwner;
66     }
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
130     /********************************************** EVENTS **********************************************/
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
145 
146     /******************************************** STORAGE ***********************************************/
147     uint256 private constant DEFAULTPARENT = 123456789;
148 
149     mapping (uint256 => Token)   private tokenIndexToToken;
150     mapping (address => uint256) private ownershipTokenCount;
151 
152     address public gameAddress;
153     address public parentAddr;
154 
155     uint256 private totalTokens;
156     uint256 public devFee = 50;
157     uint256 public ownerFee = 200;
158     uint256[10] private chainFees = [10];
159 
160     struct Token {
161         bool exists;
162         address approved;
163         address owner;
164         bytes32 metadata;
165         bytes32 name;
166         uint256 lastBlock;
167         uint256 parentId;
168         uint256 price;
169     }
170 
171     /******************************************* MODIFIERS **********************************************/
172     modifier onlySystem() {
173         require((msg.sender == gameAddress) || (msg.sender == manager));
174         _;
175     }
176 
177     /****************************************** CONSTRUCTOR *********************************************/
178     function TokenLayer(address _gameAddress, address _parentAddr) public {
179         gameAddress = _gameAddress;
180         parentAddr = _parentAddr;
181     }
182 
183     /********************************************** PUBLIC **********************************************/
184     function implementsERC721() public pure returns (bool) {
185         return true;
186     }
187 
188     function name() public pure returns (string) {
189         return "CryptoJintori";
190     }
191 
192     function symbol() public pure returns (string) {
193         return "PrefectureToken";
194     }
195 
196     function approve(address _to, uint256 _tokenId, address _from) public onlySystem {
197         _approve(_to, _tokenId, _from);
198     }
199 
200     function approve(address _to, uint256 _tokenId) public isUnlocked {
201         _approve(_to, _tokenId, msg.sender);
202     }
203 
204     function balanceOf(address _owner) public view returns (uint256 balance) {
205         return ownershipTokenCount[_owner];
206     }
207 
208     function bundleToken(uint256 _tokenId) public view returns(uint256[8] _tokenData) {
209         Token storage token = tokenIndexToToken[_tokenId];
210 
211         uint256[8] memory tokenData;
212 
213         tokenData[0] = uint256(token.name);
214         tokenData[1] = token.parentId;
215         tokenData[2] = token.price;
216         tokenData[3] = uint256(token.owner);
217         tokenData[4] = _getNextPrice(_tokenId);
218         tokenData[5] = devFee+getChainFees(_tokenId);
219         tokenData[6] = uint256(token.approved);
220         tokenData[7] = uint256(token.metadata);
221         return tokenData;
222     }
223 
224     function takeOwnership(uint256 _tokenId, address _to) public onlySystem {
225         _takeOwnership(_tokenId, _to);
226     }
227 
228     function takeOwnership(uint256 _tokenId) public isUnlocked {
229         _takeOwnership(_tokenId, msg.sender);
230     }
231 
232     function tokensOfOwner(address _owner) public view returns (uint256[] ownerTokens) {
233         uint256 tokenCount = balanceOf(_owner);
234         if (tokenCount == 0) {
235             return new uint256[](0);
236         } else {
237             uint256[] memory result = new uint256[](tokenCount);
238             uint256 _totalTokens = totalSupply();
239             uint256 resultIndex = 0;
240 
241             uint256 tokenId = 0;
242             uint256 tokenIndex = 0;
243             while (tokenIndex <= _totalTokens) {
244                 if (exists(tokenId)) {
245                     tokenIndex++;
246                     if (tokenIndexToToken[tokenId].owner == _owner) {
247                         result[resultIndex] = tokenId;
248                         resultIndex++;
249                     }
250                 }
251                 tokenId++;
252             }
253             return result;
254         }
255     }
256 
257     function totalSupply() public view returns (uint256 total) {
258         return totalTokens;
259     }
260 
261     function transfer(address _to, address _from, uint256 _tokenId) public onlySystem {
262         _checkThenTransfer(_from, _to, _tokenId);
263     }
264 
265     function transfer(address _to, uint256 _tokenId) public isUnlocked {
266         _checkThenTransfer(msg.sender, _to, _tokenId);
267     }
268 
269     function transferFrom(address _from, address _to, uint256 _tokenId) public onlySystem {
270         _transferFrom(_from, _to, _tokenId);
271     }
272 
273     function transferFrom(address _from, uint256 _tokenId) public isUnlocked {
274         _transferFrom(_from, msg.sender, _tokenId);
275     }
276 
277     function createToken(
278         uint256 _tokenId, address _owner,
279         bytes32 _name, uint256 _parentId,
280         uint256 _price, bytes32 _metadata
281     ) public onlyAdmin {
282         require(_price > 0);
283         require(_addressNotNull(_owner));
284         require(_tokenId == uint256(uint32(_tokenId)));
285         require(!exists(_tokenId));
286 
287         totalTokens++;
288 
289         Token memory _token = Token({
290             name: _name,
291             parentId: _parentId,
292             exists: true,
293             price: _price,
294             owner: _owner,
295             approved : 0,
296             lastBlock : block.number,
297             metadata : _metadata
298         });
299 
300         tokenIndexToToken[_tokenId] = _token;
301 
302         TokenCreated(_tokenId, _name, _parentId, _owner);
303 
304         _transfer(address(0), _owner, _tokenId);
305     }
306 
307     function createTokens(
308         uint256[] _tokenIds, address[] _owners,
309         bytes32[] _names, uint256[] _parentIds,
310         uint256[] _prices, bytes32[] _metadatas
311     ) public onlyAdmin {
312         for (uint256 id = 0; id < _tokenIds.length; id++) {
313             createToken(
314                 _tokenIds[id], _owners[id], _names[id],
315                 _parentIds[id], _prices[id], _metadatas[id]
316                 );
317         }
318     }
319 
320     function deleteToken(uint256 _tokenId) public onlyAdmin {
321         require(_tokenId == uint256(uint32(_tokenId)));
322         require(exists(_tokenId));
323         totalTokens--;
324 
325         address oldOwner = tokenIndexToToken[_tokenId].owner;
326 
327         ownershipTokenCount[oldOwner] = ownershipTokenCount[oldOwner]--;
328         delete tokenIndexToToken[_tokenId];
329         TokenDeleted(_tokenId);
330     }
331 
332     function incrementPrice(uint256 _tokenId, address _to) public onlySystem {
333         require(exists(_tokenId));
334         uint256 _price = tokenIndexToToken[_tokenId].price;
335         address _owner = tokenIndexToToken[_tokenId].owner;
336         uint256 _totalFees = getChainFees(_tokenId);
337         tokenIndexToToken[_tokenId].price = _price.mul(1000+ownerFee).div(1000-(devFee+_totalFees));
338 
339         TokenSold(
340             _tokenId, _price, tokenIndexToToken[_tokenId].price,
341             _owner, _to, tokenIndexToToken[_tokenId].name,
342             tokenIndexToToken[_tokenId].parentId
343         );
344     }
345 
346     function ownerOf(uint256 _tokenId) public view returns (address _owner) {
347         require(exists(_tokenId));
348         _owner = tokenIndexToToken[_tokenId].owner;
349     }
350 
351     function blocked(uint256 _tokenId) public view returns (bool _blocked) {
352         return (tokenIndexToToken[_tokenId].lastBlock == block.number);
353     }
354 
355     function exists(uint256 _tokenId) public view returns(bool) {
356         return (tokenIndexToToken[_tokenId].exists);
357     }
358 
359     /********************************************** SETTERS *********************************************/
360     function setLayerParent(address _parent) public onlyAdmin {
361         parentAddr = _parent;
362     }
363 
364     function setGame(address _gameAddress) public onlyAdmin {
365         gameAddress = _gameAddress;
366     }
367 
368     function setPrice(uint256 _tokenId, uint256 _price, address _owner) public onlySystem {
369         require(_owns(_owner, _tokenId));
370         uint256 oldPrice = tokenIndexToToken[_tokenId].price;
371         tokenIndexToToken[_tokenId].price = _price;
372         PriceChanged(_tokenId, oldPrice, _price);
373     }
374 
375     function setParent(uint256 _tokenId, uint256 _parentId) public onlyAdmin {
376         require(exists(_tokenId));
377         uint256 oldParentId = tokenIndexToToken[_tokenId].parentId;
378         tokenIndexToToken[_tokenId].parentId = _parentId;
379         ParentChanged(_tokenId, oldParentId, _parentId);
380     }
381 
382     function setName(uint256 _tokenId, bytes32 _name) public onlyAdmin {
383         require(exists(_tokenId));
384         bytes32 oldName = tokenIndexToToken[_tokenId].name;
385         tokenIndexToToken[_tokenId].name = _name;
386         NameChanged(_tokenId, oldName, _name);
387     }
388 
389     function setMetadata(uint256 _tokenId, bytes32 _metadata) public onlyAdmin {
390         require(exists(_tokenId));
391         bytes32 oldMeta = tokenIndexToToken[_tokenId].metadata;
392         tokenIndexToToken[_tokenId].metadata = _metadata;
393         MetaDataChanged(_tokenId, oldMeta, _metadata);
394     }
395 
396     function setDevFee(uint256 _devFee) public onlyAdmin {
397         devFee = _devFee;
398     }
399 
400     function setOwnerFee(uint256 _ownerFee) public onlyAdmin {
401         ownerFee = _ownerFee;
402     }
403 
404     function setChainFees(uint256[10] _chainFees) public onlyAdmin {
405         chainFees = _chainFees;
406     }
407 
408     /********************************************** GETTERS *********************************************/
409     function getToken(uint256 _tokenId) public view returns
410     (
411         bytes32 tokenName, uint256 parentId, uint256 price,
412         address _owner, uint256 nextPrice, uint256 nextPriceFees,
413         address approved, bytes32 metadata
414     ) {
415         Token storage token = tokenIndexToToken[_tokenId];
416 
417         tokenName = token.name;
418         parentId = token.parentId;
419         price = token.price;
420         _owner = token.owner;
421         nextPrice = _getNextPrice(_tokenId);
422         nextPriceFees = devFee+getChainFees(_tokenId);
423         metadata = token.metadata;
424         approved = token.approved;
425     }
426 
427     function getChainFees(uint256 _tokenId) public view returns (uint256 _total) {
428         uint256 chainLength = _getChainLength(_tokenId);
429         uint256 totalFee = 0;
430         for (uint id = 0; id < chainLength; id++) {
431             totalFee = totalFee + chainFees[id];
432         }
433         return(totalFee);
434     }
435 
436     function getChainFeeArray() public view returns (uint256[10] memory _chainFees) {
437         return(chainFees);
438     }
439 
440     function getPriceOf(uint256 _tokenId) public view returns (uint256 price) {
441         require(exists(_tokenId));
442         return tokenIndexToToken[_tokenId].price;
443     }
444 
445     function getParentOf(uint256 _tokenId) public view returns (uint256 parentId) {
446         require(exists(_tokenId));
447         return tokenIndexToToken[_tokenId].parentId;
448     }
449 
450     function getMetadataOf(uint256 _tokenId) public view returns (bytes32 metadata) {
451         require(exists(_tokenId));
452         return (tokenIndexToToken[_tokenId].metadata);
453     }
454 
455     function getChain(uint256 _tokenId) public view returns (address[10] memory _owners) {
456         require(exists(_tokenId));
457 
458         uint256 _parentId = getParentOf(_tokenId);
459         address _parentAddr = parentAddr;
460 
461         address[10] memory result;
462 
463         if (_parentId != DEFAULTPARENT && _addressNotNull(_parentAddr)) {
464             uint256 resultIndex = 0;
465 
466             TokenLayer layer = TokenLayer(_parentAddr);
467             bool parentExists = layer.exists(_parentId);
468 
469             while ((_parentId != DEFAULTPARENT) && _addressNotNull(_parentAddr) && parentExists) {
470                 parentExists = layer.exists(_parentId);
471                 if (!parentExists) {
472                     return(result);
473                 }
474                 result[resultIndex] = layer.ownerOf(_parentId);
475                 resultIndex++;
476 
477                 _parentId = layer.getParentOf(_parentId);
478                 _parentAddr = layer.parentAddr();
479 
480                 layer = TokenLayer(_parentAddr);
481             }
482 
483             return(result);
484         }
485     }
486 
487     /******************************************** PRIVATE ***********************************************/
488     function _addressNotNull(address _to) private pure returns (bool) {
489         return _to != address(0);
490     }
491 
492     function _approved(address _to, uint256 _tokenId) private view returns (bool) {
493         return (tokenIndexToToken[_tokenId].approved == _to);
494     }
495 
496     function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
497         return claimant == tokenIndexToToken[_tokenId].owner;
498     }
499 
500     function _checkThenTransfer(address _from, address _to, uint256 _tokenId) private {
501         require(_owns(_from, _tokenId));
502         require(_addressNotNull(_to));
503         require(exists(_tokenId));
504         _transfer(_from, _to, _tokenId);
505     }
506 
507     function _transfer(address _from, address _to, uint256 _tokenId) private {
508         ownershipTokenCount[_to]++;
509         tokenIndexToToken[_tokenId].owner = _to;
510         tokenIndexToToken[_tokenId].lastBlock = block.number;
511 
512         if (_from != address(0)) {
513             ownershipTokenCount[_from]--;
514             tokenIndexToToken[_tokenId].approved = 0;
515         }
516 
517         Transfer(_from, _to, _tokenId);
518     }
519 
520     function _approve(address _to, uint256 _tokenId, address _from) private {
521         require(_owns(_from, _tokenId));
522 
523         tokenIndexToToken[_tokenId].approved = _to;
524 
525         Approval(_from, _to, _tokenId);
526     }
527 
528     function _takeOwnership(uint256 _tokenId, address _to) private {
529         address newOwner = _to;
530         address oldOwner = tokenIndexToToken[_tokenId].owner;
531 
532         require(_addressNotNull(newOwner));
533         require(_approved(newOwner, _tokenId));
534 
535         _transfer(oldOwner, newOwner, _tokenId);
536     }
537 
538     function _transferFrom(address _from, address _to, uint256 _tokenId) private {
539         require(_owns(_from, _tokenId));
540         require(_approved(_to, _tokenId));
541         require(_addressNotNull(_to));
542 
543         _transfer(_from, _to, _tokenId);
544     }
545 
546     function _getChainLength(uint256 _tokenId) private view returns (uint256 _length) {
547         uint256 length;
548 
549         uint256 _parentId = getParentOf(_tokenId);
550         address _parentAddr = parentAddr;
551         if (_parentId == DEFAULTPARENT || !_addressNotNull(_parentAddr)) {
552             return 0;
553         }
554 
555         TokenLayer layer = TokenLayer(_parentAddr);
556         bool parentExists = layer.exists(_parentId);
557 
558         while ((_parentId != DEFAULTPARENT) && _addressNotNull(_parentAddr) && parentExists) {
559             parentExists = layer.exists(_parentId);
560             if(!parentExists) {
561                     return(length);
562             }
563             _parentId = layer.getParentOf(_parentId);
564             _parentAddr = layer.parentAddr();
565             layer = TokenLayer(_parentAddr);
566             length++;
567         }
568 
569         return(length);
570     }
571 
572     function _getNextPrice(uint256 _tokenId) private view returns (uint256 _nextPrice) {
573         uint256 _price = tokenIndexToToken[_tokenId].price;
574         uint256 _totalFees = getChainFees(_tokenId);
575         _price = _price.mul(1000+ownerFee).div(1000-(devFee+_totalFees));
576         return(_price);
577     }
578 }