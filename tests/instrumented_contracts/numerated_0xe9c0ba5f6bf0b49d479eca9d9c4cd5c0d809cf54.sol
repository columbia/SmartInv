1 pragma solidity ^0.4.24;
2 
3 
4 
5 /**
6  * @title ERC165
7  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
8  */
9 interface ERC165 {
10 
11   function supportsInterface(bytes4 _interfaceId)
12     external
13     view
14     returns (bool);
15 }
16 
17 
18 
19 contract SupportsInterfaceWithLookup is ERC165 {
20   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
21 
22   mapping(bytes4 => bool) internal supportedInterfaces;
23 
24   constructor()
25     public
26   {
27     _registerInterface(InterfaceId_ERC165);
28   }
29 
30   function supportsInterface(bytes4 _interfaceId)
31     external
32     view
33     returns (bool)
34   {
35     return supportedInterfaces[_interfaceId];
36   }
37 
38   function _registerInterface(bytes4 _interfaceId)
39     internal
40   {
41     require(_interfaceId != 0xffffffff);
42     supportedInterfaces[_interfaceId] = true;
43   }
44 }
45 
46 
47 contract ERC721Basic is ERC165 {
48 
49   bytes4 internal constant InterfaceId_ERC721 = 0x80ac58cd;
50 
51   bytes4 internal constant InterfaceId_ERC721Exists = 0x4f558e79;
52 
53   bytes4 internal constant InterfaceId_ERC721Enumerable = 0x780e9d63;
54 
55   bytes4 internal constant InterfaceId_ERC721Metadata = 0x5b5e139f;
56 
57   event Transfer(
58     address indexed _from,
59     address indexed _to,
60     uint256 indexed _tokenId
61   );
62   event Approval(
63     address indexed _owner,
64     address indexed _approved,
65     uint256 indexed _tokenId
66   );
67   event ApprovalForAll(
68     address indexed _owner,
69     address indexed _operator,
70     bool _approved
71   );
72 
73   function balanceOf(address _owner) public view returns (uint256 _balance);
74   function ownerOf(uint256 _tokenId) public view returns (address _owner);
75   function exists(uint256 _tokenId) public view returns (bool _exists);
76 
77   function approve(address _to, uint256 _tokenId) public;
78   function getApproved(uint256 _tokenId)
79     public view returns (address _operator);
80 
81   function setApprovalForAll(address _operator, bool _approved) public;
82   function isApprovedForAll(address _owner, address _operator)
83     public view returns (bool);
84 
85   function transferFrom(address _from, address _to, uint256 _tokenId) public;
86   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
87     public;
88 
89   function safeTransferFrom(
90     address _from,
91     address _to,
92     uint256 _tokenId,
93     bytes _data
94   )
95     public;
96 }
97 
98 
99 
100 contract ERC721Enumerable is ERC721Basic {
101   function totalSupply() public view returns (uint256);
102   function tokenOfOwnerByIndex(
103     address _owner,
104     uint256 _index
105   )
106     public
107     view
108     returns (uint256 _tokenId);
109 
110   function tokenByIndex(uint256 _index) public view returns (uint256);
111 }
112 
113 
114 contract ERC721Metadata is ERC721Basic {
115   function name() external view returns (string _name);
116   function symbol() external view returns (string _symbol);
117   function tokenURI(uint256 _tokenId) public view returns (string);
118 }
119 
120 
121 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
122 }
123 
124 
125 
126 
127 contract ERC721Receiver {
128 
129   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
130 
131   function onERC721Received(
132     address _operator,
133     address _from,
134     uint256 _tokenId,
135     bytes _data
136   )
137     public
138     returns(bytes4);
139 }
140 
141 
142 
143 library SafeMath {
144 
145   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
146 
147     if (a == 0) {
148       return 0;
149     }
150 
151     c = a * b;
152     assert(c / a == b);
153     return c;
154   }
155 
156   function div(uint256 a, uint256 b) internal pure returns (uint256) {
157 
158     return a / b;
159   }
160 
161   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
162     assert(b <= a);
163     return a - b;
164   }
165 
166   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
167     c = a + b;
168     assert(c >= a);
169     return c;
170   }
171 }
172 
173 
174 library AddressUtils {
175 
176 
177   function isContract(address addr) internal view returns (bool) {
178     uint256 size;
179     assembly { size := extcodesize(addr) }
180     return size > 0;
181   }
182 
183 }
184 
185 
186 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
187 
188   using SafeMath for uint256;
189   using AddressUtils for address;
190 
191   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
192 
193   mapping (uint256 => address) internal tokenOwner;
194   mapping (uint256 => address) internal tokenApprovals;
195   mapping (address => uint256) internal ownedTokensCount;
196   mapping (address => mapping (address => bool)) internal operatorApprovals;
197 
198   constructor()
199     public
200   {
201     _registerInterface(InterfaceId_ERC721);
202     _registerInterface(InterfaceId_ERC721Exists);
203   }
204 
205   function balanceOf(address _owner) public view returns (uint256) {
206     require(_owner != address(0));
207     return ownedTokensCount[_owner];
208   }
209 
210   function ownerOf(uint256 _tokenId) public view returns (address) {
211     address owner = tokenOwner[_tokenId];
212     require(owner != address(0));
213     return owner;
214   }
215 
216   function exists(uint256 _tokenId) public view returns (bool) {
217     address owner = tokenOwner[_tokenId];
218     return owner != address(0);
219   }
220 
221   function approve(address _to, uint256 _tokenId) public {
222     address owner = ownerOf(_tokenId);
223     require(_to != owner);
224     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
225 
226     tokenApprovals[_tokenId] = _to;
227     emit Approval(owner, _to, _tokenId);
228   }
229 
230   function getApproved(uint256 _tokenId) public view returns (address) {
231     return tokenApprovals[_tokenId];
232   }
233 
234   function setApprovalForAll(address _to, bool _approved) public {
235     require(_to != msg.sender);
236     operatorApprovals[msg.sender][_to] = _approved;
237     emit ApprovalForAll(msg.sender, _to, _approved);
238   }
239 
240   function isApprovedForAll(
241     address _owner,
242     address _operator
243   )
244     public
245     view
246     returns (bool)
247   {
248     return operatorApprovals[_owner][_operator];
249   }
250 
251   function transferFrom(
252     address _from,
253     address _to,
254     uint256 _tokenId
255   )
256     public
257   {
258     require(isApprovedOrOwner(msg.sender, _tokenId));
259     require(_from != address(0));
260     require(_to != address(0));
261 
262     clearApproval(_from, _tokenId);
263     removeTokenFrom(_from, _tokenId);
264     addTokenTo(_to, _tokenId);
265 
266     emit Transfer(_from, _to, _tokenId);
267   }
268 
269   function safeTransferFrom(
270     address _from,
271     address _to,
272     uint256 _tokenId
273   )
274     public
275   {
276     // solium-disable-next-line arg-overflow
277     safeTransferFrom(_from, _to, _tokenId, "");
278   }
279 
280   function safeTransferFrom(
281     address _from,
282     address _to,
283     uint256 _tokenId,
284     bytes _data
285   )
286     public
287   {
288     transferFrom(_from, _to, _tokenId);
289     // solium-disable-next-line arg-overflow
290     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
291   }
292 
293   function isApprovedOrOwner(
294     address _spender,
295     uint256 _tokenId
296   )
297     internal
298     view
299     returns (bool)
300   {
301     address owner = ownerOf(_tokenId);
302     return (
303       _spender == owner ||
304       getApproved(_tokenId) == _spender ||
305       isApprovedForAll(owner, _spender)
306     );
307   }
308 
309 
310   function _mint(address _to, uint256 _tokenId) internal {
311     require(_to != address(0));
312     addTokenTo(_to, _tokenId);
313     emit Transfer(address(0), _to, _tokenId);
314   }
315 
316   function _burn(address _owner, uint256 _tokenId) internal {
317     clearApproval(_owner, _tokenId);
318     removeTokenFrom(_owner, _tokenId);
319     emit Transfer(_owner, address(0), _tokenId);
320   }
321 
322   function clearApproval(address _owner, uint256 _tokenId) internal {
323     require(ownerOf(_tokenId) == _owner);
324     if (tokenApprovals[_tokenId] != address(0)) {
325       tokenApprovals[_tokenId] = address(0);
326     }
327   }
328 
329   function addTokenTo(address _to, uint256 _tokenId) internal {
330     require(tokenOwner[_tokenId] == address(0));
331     tokenOwner[_tokenId] = _to;
332     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
333   }
334 
335   function removeTokenFrom(address _from, uint256 _tokenId) internal {
336     require(ownerOf(_tokenId) == _from);
337     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
338     tokenOwner[_tokenId] = address(0);
339   }
340 
341   function checkAndCallSafeTransfer(
342     address _from,
343     address _to,
344     uint256 _tokenId,
345     bytes _data
346   )
347     internal
348     returns (bool)
349   {
350     if (!_to.isContract()) {
351       return true;
352     }
353     bytes4 retval = ERC721Receiver(_to).onERC721Received(
354       msg.sender, _from, _tokenId, _data);
355     return (retval == ERC721_RECEIVED);
356   }
357 }
358 
359 
360 
361 
362 
363 
364 
365 contract ERC721Token is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
366 
367   // Token name
368   string internal name_;
369 
370   // Token symbol
371   string internal symbol_;
372 
373   // Mapping from owner to list of owned token IDs
374   mapping(address => uint256[]) internal ownedTokens;
375 
376   // Mapping from token ID to index of the owner tokens list
377   mapping(uint256 => uint256) internal ownedTokensIndex;
378 
379   // Array with all token ids, used for enumeration
380   uint256[] internal allTokens;
381 
382   // Mapping from token id to position in the allTokens array
383   mapping(uint256 => uint256) internal allTokensIndex;
384 
385   // Optional mapping for token URIs
386   mapping(uint256 => string) internal tokenURIs;
387 
388   constructor(string _name, string _symbol) public {
389     name_ = _name;
390     symbol_ = _symbol;
391 
392     // register the supported interfaces to conform to ERC721 via ERC165
393     _registerInterface(InterfaceId_ERC721Enumerable);
394     _registerInterface(InterfaceId_ERC721Metadata);
395   }
396 
397   function name() external view returns (string) {
398     return name_;
399   }
400 
401   function symbol() external view returns (string) {
402     return symbol_;
403   }
404 
405   function tokenURI(uint256 _tokenId) public view returns (string) {
406     require(exists(_tokenId));
407     return tokenURIs[_tokenId];
408   }
409 
410   function tokenOfOwnerByIndex(
411     address _owner,
412     uint256 _index
413   )
414     public
415     view
416     returns (uint256)
417   {
418     require(_index < balanceOf(_owner));
419     return ownedTokens[_owner][_index];
420   }
421 
422   function totalSupply() public view returns (uint256) {
423     return allTokens.length;
424   }
425 
426   function tokenByIndex(uint256 _index) public view returns (uint256) {
427     require(_index < totalSupply());
428     return allTokens[_index];
429   }
430 
431 
432   function _setTokenURI(uint256 _tokenId, string _uri) internal {
433     require(exists(_tokenId));
434     tokenURIs[_tokenId] = _uri;
435   }
436 
437 
438   function addTokenTo(address _to, uint256 _tokenId) internal {
439     super.addTokenTo(_to, _tokenId);
440     uint256 length = ownedTokens[_to].length;
441     ownedTokens[_to].push(_tokenId);
442     ownedTokensIndex[_tokenId] = length;
443   }
444 
445 
446   function removeTokenFrom(address _from, uint256 _tokenId) internal {
447     super.removeTokenFrom(_from, _tokenId);
448 
449     uint256 tokenIndex = ownedTokensIndex[_tokenId];
450     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
451     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
452 
453     ownedTokens[_from][tokenIndex] = lastToken;
454     ownedTokens[_from].length--; // This also deletes the contents at the last position of the array
455 
456     ownedTokensIndex[_tokenId] = 0;
457     ownedTokensIndex[lastToken] = tokenIndex;
458   }
459 
460 
461   function _mint(address _to, uint256 _tokenId) internal {
462     super._mint(_to, _tokenId);
463 
464     allTokensIndex[_tokenId] = allTokens.length;
465     allTokens.push(_tokenId);
466   }
467 
468 
469   function _burn(address _owner, uint256 _tokenId) internal {
470     super._burn(_owner, _tokenId);
471 
472     if (bytes(tokenURIs[_tokenId]).length != 0) {
473       delete tokenURIs[_tokenId];
474     }
475 
476     uint256 tokenIndex = allTokensIndex[_tokenId];
477     uint256 lastTokenIndex = allTokens.length.sub(1);
478     uint256 lastToken = allTokens[lastTokenIndex];
479 
480     allTokens[tokenIndex] = lastToken;
481     allTokens[lastTokenIndex] = 0;
482 
483     allTokens.length--;
484     allTokensIndex[_tokenId] = 0;
485     allTokensIndex[lastToken] = tokenIndex;
486   }
487 
488 }
489 
490 
491 contract lettertoken205 is ERC721Token {
492 
493   constructor() public ERC721Token("lettertoken205","lettertoken205") { }
494 
495   struct Token{
496     uint8 data1;
497     uint8 data2;
498     uint64 data3;
499     uint64 data4;
500     uint64 startBlock;
501   }
502 
503   Token[] private tokens;
504 
505   function create(uint8 data1, uint8 data2,uint64 data3, uint64 data4) public returns (uint256 _tokenId) {
506 
507     string memory tokenUri = createTokenUri(data1,data2,data3,data4);
508 
509     Token memory _newToken = Token({
510         data1: data1,
511         data2: data2,
512         data3: data3,
513         data4: data4,
514         startBlock: uint64(block.number)
515     });
516     _tokenId = tokens.push(_newToken) - 1;
517     _mint(msg.sender,_tokenId);
518     _setTokenURI(_tokenId, tokenUri);
519     tokenUri=strConcat(tokenUri,"-");
520     string memory tokenIdb=uint2str(_tokenId);
521     tokenUri=strConcat(tokenUri, tokenIdb);
522     emit Create(_tokenId,msg.sender,data1,data2,data3,data4,_newToken.startBlock,tokenUri);
523     return _tokenId;
524   }
525 
526   event Create(
527     uint _id,
528     address indexed _owner,
529     uint8 _data1,
530     uint8 _data2,
531     uint64 _data3,
532     uint64 _data4,
533     uint64 _startBlock,
534     string _uri
535   );
536 
537   function get(uint256 _id) public view returns (address owner,uint8 data1,uint8 data2,uint64 data3,uint64 data4,uint64 startBlock) {
538     return (
539       tokenOwner[_id],
540       tokens[_id].data1,
541       tokens[_id].data2,
542       tokens[_id].data3,
543       tokens[_id].data4,
544       tokens[_id].startBlock
545     );
546   }
547 
548   function tokensOfOwner(address _owner) public view returns(uint256[]) {
549     return ownedTokens[_owner];
550   }
551 
552   function createTokenUri(uint8 data1,uint8 data2,uint64 data3,uint64 data4) internal pure returns (string){
553     string memory uri = "https://www.millionetherwords.com/exchange/displaytoken/?s=";
554     uri = appendUint8ToString(uri,data1);
555     uri = strConcat(uri,"-");
556     uri = appendUint8ToString(uri,data2);
557     uri = strConcat(uri,"-");
558     string memory data3b=uint2str(data3);
559     uri = strConcat(uri,data3b);
560     uri = strConcat(uri,"-");
561     string memory data4b=uint2str(data4);
562     uri = strConcat(uri,data4b);
563    
564     uri = strConcat(uri,".png");
565     return uri;
566   }
567 
568 function uint2str(uint i) internal pure returns (string){
569     if (i == 0) return "0";
570     uint j = i;
571     uint length;
572     while (j != 0){
573         length++;
574         j /= 10;
575     }
576     bytes memory bstr = new bytes(length);
577     uint k = length - 1;
578     while (i != 0){
579         bstr[k--] = byte(48 + i % 10);
580         i /= 10;
581     }
582     return string(bstr);
583 }
584 
585   function appendUint8ToString(string inStr, uint8 v) internal pure returns (string str) {
586         uint maxlength = 100;
587         bytes memory reversed = new bytes(maxlength);
588         uint i = 0;
589         while (v != 0) {
590             uint remainder = v % 10;
591             v = v / 10;
592             reversed[i++] = byte(48 + remainder);
593         }
594         bytes memory inStrb = bytes(inStr);
595         bytes memory s = new bytes(inStrb.length + i);
596         uint j;
597         for (j = 0; j < inStrb.length; j++) {
598             s[j] = inStrb[j];
599         }
600         for (j = 0; j < i; j++) {
601             s[j + inStrb.length] = reversed[i - 1 - j];
602         }
603         str = string(s);
604     }
605 
606     function strConcat(string _a, string _b) internal pure returns (string) {
607         bytes memory _ba = bytes(_a);
608         bytes memory _bb = bytes(_b);
609         string memory ab = new string(_ba.length + _bb.length);
610         bytes memory bab = bytes(ab);
611         uint k = 0;
612         for (uint i = 0; i < _ba.length; i++) bab[k++] = _ba[i];
613         for (i = 0; i < _bb.length; i++) bab[k++] = _bb[i];
614         return string(bab);
615     }
616 
617 }