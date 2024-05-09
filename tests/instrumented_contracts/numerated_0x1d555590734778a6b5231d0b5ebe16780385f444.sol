1 pragma solidity >=0.4.22 <0.6.0;
2 
3 contract CryptoConstellationAccessControl  {
4     
5     address public ceoAddress;
6     address public ctoAddress;
7     address public cfoAddress;
8     address public cooAddress;
9 
10     bool public paused = false;
11     
12     mapping (address => string) public userNickName;
13 
14     modifier onlyCEO() {
15         require(msg.sender == ceoAddress);
16         _;
17     }
18     
19     modifier onlyCTO() {
20         require(msg.sender == ctoAddress);
21         _;
22     }
23 
24     modifier onlyCFO() {
25         require(msg.sender == cfoAddress);
26         _;
27     }
28 
29     modifier onlyCOO() {
30         require(msg.sender == cooAddress);
31         _;
32     }
33 
34     modifier onlyCLevel() {
35         require(
36             msg.sender == cooAddress ||
37             msg.sender == ceoAddress ||
38             msg.sender == cfoAddress ||
39             msg.sender == ctoAddress
40         );
41         _;
42     }
43     
44     function setCEO(address _newCEO) external onlyCEO {
45         require(_newCEO != address(0));
46         ceoAddress = _newCEO;
47     }
48     
49     function setCTO(address _newCTO) external onlyCEO {
50         require(_newCTO != address(0));
51         ctoAddress = _newCTO;
52     }
53 
54     function setCFO(address _newCFO) external onlyCEO {
55         require(_newCFO != address(0));
56         cfoAddress = _newCFO;
57     }
58 
59     function setCOO(address _newCOO) external onlyCEO {
60         require(_newCOO != address(0));
61         cooAddress = _newCOO;
62     }
63 
64     function setNickName(address _user, string calldata _nickName) external returns (bool) {
65         require(_user != address(0));
66         userNickName[_user] = _nickName;
67     }
68 
69     function getNickName(address _user) external view returns (string memory _nickname) {
70         require(_user != address(0));
71 
72         _nickname = userNickName[_user];
73     }
74     
75     modifier whenNotPaused() {
76         require(!paused);
77         _;
78     }
79 
80     modifier whenPaused {
81         require(paused);
82         _;
83     }
84 
85     function pause() external onlyCLevel whenNotPaused {
86         paused = true;
87     }
88     
89     function unpause() external onlyCEO whenPaused {
90         // can't unpause if contract was upgraded
91         paused = false;
92     }
93 }
94 
95 library SafeMath {
96     
97     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
98         if (a == 0) {
99             return 0;
100         }
101         uint256 c = a * b;
102         assert(c / a == b);
103         return c;
104     }
105 
106     function div(uint256 a, uint256 b) internal pure returns (uint256) {
107         // assert(b > 0); // Solidity automatically throws when dividing by 0
108         uint256 c = a / b;
109         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
110         return c;
111     }
112 
113     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
114         assert(b <= a);
115         return a - b;
116     }
117 
118     function add(uint256 a, uint256 b) internal pure returns (uint256) {
119         uint256 c = a + b;
120         assert(c >= a);
121         return c;
122     }
123 }
124 
125 contract CryptoConstellationBase is CryptoConstellationAccessControl {
126 
127     using SafeMath for uint256;
128     
129     event ConstellationCreation(address indexed _owner, uint256 indexed _tokenId);
130     
131     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
132 
133     event Bought (uint256 indexed _tokenId, address indexed _owner, uint256 _price);
134 
135     event Sold (uint256 indexed _tokenId, address indexed _owner, uint256 _price);
136     
137     struct Constellation {
138         string name;
139         string description;
140         string ipfsHash;
141         uint64 creationTimestamp;
142     }
143 
144     
145     uint256 internal increaseLimit1 = 0.02 ether;
146     uint256 internal increaseLimit2 = 0.5 ether;
147     uint256 internal increaseLimit3 = 2.0 ether;
148     uint256 internal increaseLimit4 = 5.0 ether;
149     
150     Constellation[] constellations;
151     
152     mapping (uint256 => address) public constellationCurrentOwner;
153     
154     mapping (address => uint256) internal ownershipTokenCount;
155 
156     mapping (uint256 => uint256) internal startingPriceOfConstellation;
157 
158     mapping (uint256 => uint256) internal priceOfConstellation;
159 
160     mapping (uint256 => address) internal approvedOfConstellation;
161     
162     
163     modifier onlyOwner(uint _propId) {
164 		require(constellationCurrentOwner[_propId] == msg.sender);
165 		_;
166 	}
167 
168     function _transfer(address _from, address _to, uint256 _tokenId) internal {
169         
170         // Since the number of assets is capped to 2^32 we can't overflow this
171         ownershipTokenCount[_to]++;
172         // transfer ownership
173         constellationCurrentOwner[_tokenId] = _to;
174 
175         approvedOfConstellation[_tokenId] = address(0);
176         // When creating new kittens _from is 0x0, but we can't account that address.
177         if (_from != address(0)) {
178             ownershipTokenCount[_from]--;
179         }
180         // Emit the transfer event.
181         emit Transfer(_from, _to, _tokenId);
182     }
183     
184     
185     function calculateNextPrice (uint256 _price) public view returns (uint256 _nextPrice) {
186         if (_price < increaseLimit1) {
187             return _price.mul(200).div(95);
188         } else if (_price < increaseLimit2) {
189             return _price.mul(135).div(96);
190         } else if (_price < increaseLimit3) {
191             return _price.mul(125).div(97);
192         } else if (_price < increaseLimit4) {
193             return _price.mul(117).div(97);
194         } else {
195             return _price.mul(115).div(98);
196         }
197     }
198 
199     function calculateDevCut (uint256 _price) public view returns (uint256 _devCut) {
200         if (_price < increaseLimit1) {
201             return _price.mul(10).div(100); // 10%
202         } else if (_price < increaseLimit2) {
203             return _price.mul(9).div(100); // 9%
204         } else if (_price < increaseLimit3) {
205             return _price.mul(8).div(100); // 8%
206         } else if (_price < increaseLimit4) {
207             return _price.mul(7).div(100); // 7%
208         } else {
209             return _price.mul(6).div(100); // 6%
210         }
211     }
212 
213     
214     function createConstellation(
215         string calldata _name,
216         string calldata _description,
217         string calldata _ipfsHash,
218         uint256 _price,
219         address _owner
220     )
221         external
222         whenNotPaused
223         onlyCLevel
224         returns (uint)
225     {
226         return _createConstellation(_name, _description, _ipfsHash, _price, _owner);
227     }
228     
229     function _createConstellation(
230         string memory _name,
231         string memory _description,
232         string memory _ipfsHash,
233         uint256 _price,
234         address _owner
235     )
236         internal
237         whenNotPaused
238         onlyCLevel
239         returns (uint)
240     {
241         
242         Constellation memory _constellation = Constellation({
243             name: _name,
244             description: _description,
245             ipfsHash: _ipfsHash,
246             creationTimestamp: uint64(block.timestamp)
247         });
248         uint256 newConstellationId = constellations.push(_constellation) - 1;
249 
250         require(newConstellationId == uint256(uint32(newConstellationId)));
251 
252         startingPriceOfConstellation[newConstellationId] = _price;
253         priceOfConstellation[newConstellationId] = _price;
254 
255         // emit the birth event
256         emit ConstellationCreation(_owner, newConstellationId);
257 
258         _transfer(address(0), _owner, newConstellationId);
259 
260         return newConstellationId;
261     }
262    
263 }
264 
265 
266 contract ERC721  {
267     
268     // Required methods
269     function totalSupply() public view returns (uint256 total);
270     function balanceOf(address _owner) public view returns (uint256 balance);
271     function ownerOf(uint256 _tokenId) public view returns (address owner);
272     function approve(address _to, uint256 _tokenId) external;
273     function transfer(address _to, uint256 _tokenId) external;
274     function transferFrom(address _from, address _to, uint256 _tokenId) external;
275 
276     // Events
277     event Transfer(address from, address to, uint256 tokenId);
278     event Approval(address owner, address approved, uint256 tokenId);
279 
280     // Optional
281     // function name() public view returns (string name);
282     // function symbol() public view returns (string symbol);
283     // function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);
284     // function tokenMetadata(uint256 _tokenId, string _preferredTransport) public view returns (string infoUrl);
285 
286     // ERC-165 Compatibility (https://github.com/ethereum/EIPs/issues/165)
287     function supportsInterface(bytes4 _interfaceID) external view returns (bool);
288     
289 }
290 
291 contract ERC721Metadata {
292     /// @dev Given a token Id, returns a byte array that is supposed to be converted into string.
293     function getMetadata(uint256 _tokenId, string memory) public pure returns (bytes32[4] memory buffer, uint256 count) {
294         if (_tokenId == 1) {
295             buffer[0] = "Hello World! :D";
296             count = 15;
297         } else if (_tokenId == 2) {
298             buffer[0] = "I would definitely choose a medi";
299             buffer[1] = "um length string.";
300             count = 49;
301         } else if (_tokenId == 3) {
302             buffer[0] = "Lorem ipsum dolor sit amet, mi e";
303             buffer[1] = "st accumsan dapibus augue lorem,";
304             buffer[2] = " tristique vestibulum id, libero";
305             buffer[3] = " suscipit varius sapien aliquam.";
306             count = 128;
307         }
308     }
309 }
310 
311 contract CryptoConstellationOwnership is CryptoConstellationBase, ERC721 {
312     
313     string public constant name = "CryptoConstellation";
314     string public constant symbol = "CCL";
315 
316     ERC721Metadata public erc721Metadata;
317 
318     bytes4 constant InterfaceSignature_ERC165 =
319         bytes4(keccak256('supportsInterface(bytes4)'));
320 
321     bytes4 constant InterfaceSignature_ERC721 =
322         bytes4(keccak256('name()')) ^
323         bytes4(keccak256('symbol()')) ^
324         bytes4(keccak256('totalSupply()')) ^
325         bytes4(keccak256('balanceOf(address)')) ^
326         bytes4(keccak256('ownerOf(uint256)')) ^
327         bytes4(keccak256('approve(address,uint256)')) ^
328         bytes4(keccak256('transfer(address,uint256)')) ^
329         bytes4(keccak256('transferFrom(address,address,uint256)')) ^
330         bytes4(keccak256('tokensOfOwner(address)')) ^
331         bytes4(keccak256('tokenMetadata(uint256,string)'));
332 
333 
334     function supportsInterface(bytes4 _interfaceID) external view returns (bool)
335     {
336         
337         return ((_interfaceID == InterfaceSignature_ERC165) || (_interfaceID == InterfaceSignature_ERC721));
338     }
339 
340     function setMetadataAddress(address _contractAddress) public onlyCEO {
341         erc721Metadata = ERC721Metadata(_contractAddress);
342     }
343 
344 
345     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
346         return constellationCurrentOwner[_tokenId] == _claimant;
347     }
348     
349     function _approvedFor(uint256 _tokenId) internal view returns (address) {
350         return approvedOfConstellation[_tokenId];
351     }
352 
353     function _approve(uint256 _tokenId, address _to) internal {
354         require(msg.sender != _to);
355         require(tokenExists(_tokenId));
356         require(ownerOf(_tokenId) == msg.sender);
357 
358         if (_to == address(0)) {
359             if (approvedOfConstellation[_tokenId] != address(0)) {
360                 delete approvedOfConstellation[_tokenId];
361                 emit Approval(msg.sender, address(0), _tokenId);
362             }
363         } else {
364             approvedOfConstellation[_tokenId] = _to;
365             emit Approval(msg.sender, _to, _tokenId);
366         }
367     }
368 
369     function ownerOf (uint256 _itemId) public view returns (address _owner) {
370         return constellationCurrentOwner[_itemId];
371     }
372 
373     function balanceOf(address _owner) public view returns (uint256 count) {
374         return ownershipTokenCount[_owner];
375     }
376 
377     function buy(uint256 _tokenId) payable external whenNotPaused
378     {
379         require(priceOf(_tokenId) > 0);
380         require(ownerOf(_tokenId) != address(0));
381         require(msg.value >= priceOf(_tokenId));
382         require(ownerOf(_tokenId) != msg.sender);
383         require(msg.sender != address(0));
384 
385         address payable oldOwner = address(uint160(ownerOf(_tokenId)));
386         address payable newOwner = msg.sender;
387         uint256 price = priceOf(_tokenId);
388         uint256 excess = msg.value.sub(price);
389 
390         _transfer(oldOwner, newOwner, _tokenId);
391         priceOfConstellation[_tokenId] = nextPriceOf(_tokenId);
392 
393         emit Bought(_tokenId, newOwner, price);
394         emit Sold(_tokenId, oldOwner, price);
395 
396         // Devevloper's cut which is left in contract and accesed by
397         // `withdrawAll` and `withdrawAmountTo` methods.
398         uint256 devCut = calculateDevCut(price);
399 
400         // Transfer payment to old owner minus the developer's cut.
401         oldOwner.transfer(price.sub(devCut));
402 
403         if (excess > 0) {
404             newOwner.transfer(excess);
405         }
406     }
407 
408 
409     function approve(address _to, uint256 _tokenId) external whenNotPaused
410     {
411         require(_owns(msg.sender, _tokenId));
412         
413         _approve(_tokenId, _to);
414     }
415 
416     function transfer(address _to, uint256 _itemId) external {
417         require(msg.sender == ownerOf(_itemId));
418         _transfer(msg.sender, _to, _itemId);
419     }
420 
421     function transferFrom(address _from, address _to, uint256 _tokenId) external whenNotPaused
422     {
423         require(_to != address(0));
424         require(_to != address(this));
425         
426         require(_approvedFor(_tokenId) == msg.sender);
427         require(_owns(_from, _tokenId));
428 
429 
430         _transfer(_from, _to, _tokenId);
431     }
432     
433     
434 
435     function totalSupply() public view returns (uint) {
436         return constellations.length - 1;
437     }
438 
439     function tokenExists(uint256 _itemId) public view returns (bool _exists) {
440     return priceOf(_itemId) > 0;
441     }
442 
443     function startingPriceOf(uint256 _itemId) public view returns (uint256 _startingPrice) {
444         return startingPriceOfConstellation[_itemId];
445     }
446 
447     function priceOf(uint256 _itemId) public view returns (uint256 _price) {
448         return priceOfConstellation[_itemId];
449     }
450 
451     function nextPriceOf(uint256 _itemId) public view returns (uint256 _nextPrice) {
452         return calculateNextPrice(priceOf(_itemId));
453     }
454 
455 
456     function tokensOfOwner(address _owner) external view returns(uint256[] memory ownerTokens) {
457         uint256 tokenCount = balanceOf(_owner);
458 
459         if (tokenCount == 0) {
460             // Return an empty array
461             return new uint256[](0);
462         } else {
463             uint256[] memory result = new uint256[](tokenCount);
464             uint256 totalConstellation = totalSupply();
465             uint256 resultIndex = 0;
466 
467             uint256 constellationId;
468 
469             for (constellationId = 1; constellationId <= totalConstellation; constellationId++) {
470                 if (constellationCurrentOwner[constellationId] == _owner) {
471                     result[resultIndex] = constellationId;
472                     resultIndex++;
473                 }
474             }
475 
476             return result;
477         }
478     }
479 
480 
481     function _memcpy(uint _dest, uint _src, uint _len) private pure {
482         // Copy word-length chunks while possible
483         for(; _len >= 32; _len -= 32) {
484             assembly {
485                 mstore(_dest, mload(_src))
486             }
487             _dest += 32;
488             _src += 32;
489         }
490 
491         // Copy remaining bytes
492         uint256 mask = 256 ** (32 - _len) - 1;
493         assembly {
494             let srcpart := and(mload(_src), not(mask))
495             let destpart := and(mload(_dest), mask)
496             mstore(_dest, or(destpart, srcpart))
497         }
498     }
499     
500     
501     function _toString(bytes32[4] memory _rawBytes, uint256 _stringLength) private pure returns (string memory) {
502         string memory outputString = new string(_stringLength);
503         uint256 outputPtr;
504         uint256 bytesPtr;
505 
506         assembly {
507             outputPtr := add(outputString, 32)
508             bytesPtr := _rawBytes
509         }
510 
511         _memcpy(outputPtr, bytesPtr, _stringLength);
512 
513         return outputString;
514     }
515 
516 
517     function tokenMetadata(uint256 _tokenId, string calldata _preferredTransport) external view returns (string memory infoUrl) {
518         bytes32[4] memory buffer;
519         uint256 count;
520         (buffer, count) = erc721Metadata.getMetadata(_tokenId, _preferredTransport);
521 
522         return _toString(buffer, count);
523     }
524 
525     function withdrawAll () onlyCLevel external {
526         address payable companyAddress = address(uint160(ceoAddress));
527         companyAddress.transfer(address(this).balance);
528     }
529 
530     function withdrawAmount (uint256 _amount) onlyCLevel external {
531         address payable companyAddress = address(uint160(ceoAddress));
532         companyAddress.transfer(_amount);
533     }
534 }
535 
536 contract CryptoConstellationCore is CryptoConstellationOwnership{
537     
538     constructor() public{
539 
540         // the creator of the contract is the initial CEO
541         ceoAddress = msg.sender;
542 
543         // the creator of the contract is also the initial CTO
544         ctoAddress = msg.sender;
545 
546     }
547     
548     
549     function getConstellation(uint256 _id)
550         external
551         view
552         returns (
553         string memory _name,
554         string memory _description,
555         string memory _ipfsHash,
556         address _owner, 
557         uint256 _startingPrice, 
558         uint256 _price, 
559         uint256 _nextPrice
560     ) {
561         Constellation memory constellation = constellations[_id];
562         
563         _name = constellation.name;
564         _description = constellation.description;
565         _ipfsHash = constellation.ipfsHash;
566         _owner = ownerOf(_id);
567         _startingPrice = startingPriceOf(_id);
568         _price = priceOf(_id);
569         _nextPrice = nextPriceOf(_id);
570         
571     }
572     
573 }