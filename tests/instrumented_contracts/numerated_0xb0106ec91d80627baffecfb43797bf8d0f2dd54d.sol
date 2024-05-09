1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC165
5  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
6  */
7 interface ERC165 {
8 
9   function supportsInterface(bytes4 _interfaceId)
10     external
11     view
12     returns (bool);
13 }
14 
15 
16 
17 contract SupportsInterfaceWithLookup is ERC165 {
18   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
19 
20   mapping(bytes4 => bool) internal supportedInterfaces;
21 
22   constructor()
23     public
24   {
25     _registerInterface(InterfaceId_ERC165);
26   }
27 
28   function supportsInterface(bytes4 _interfaceId)
29     external
30     view
31     returns (bool)
32   {
33     return supportedInterfaces[_interfaceId];
34   }
35 
36   function _registerInterface(bytes4 _interfaceId)
37     internal
38   {
39     require(_interfaceId != 0xffffffff);
40     supportedInterfaces[_interfaceId] = true;
41   }
42 }
43 
44 
45 contract ERC721Basic is ERC165 {
46 
47   bytes4 internal constant InterfaceId_ERC721 = 0x80ac58cd;
48 
49   bytes4 internal constant InterfaceId_ERC721Exists = 0x4f558e79;
50 
51   bytes4 internal constant InterfaceId_ERC721Enumerable = 0x780e9d63;
52 
53   bytes4 internal constant InterfaceId_ERC721Metadata = 0x5b5e139f;
54 
55   event Transfer(
56     address indexed _from,
57     address indexed _to,
58     uint256 indexed _tokenId
59   );
60   event Approval(
61     address indexed _owner,
62     address indexed _approved,
63     uint256 indexed _tokenId
64   );
65   event ApprovalForAll(
66     address indexed _owner,
67     address indexed _operator,
68     bool _approved
69   );
70 
71   function balanceOf(address _owner) public view returns (uint256 _balance);
72   function ownerOf(uint256 _tokenId) public view returns (address _owner);
73   function exists(uint256 _tokenId) public view returns (bool _exists);
74 
75   function approve(address _to, uint256 _tokenId) public;
76   function getApproved(uint256 _tokenId)
77     public view returns (address _operator);
78 
79   function setApprovalForAll(address _operator, bool _approved) public;
80   function isApprovedForAll(address _owner, address _operator)
81     public view returns (bool);
82 
83   function transferFrom(address _from, address _to, uint256 _tokenId) public;
84   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
85     public;
86 
87   function safeTransferFrom(
88     address _from,
89     address _to,
90     uint256 _tokenId,
91     bytes _data
92   )
93     public;
94 }
95 
96 
97 
98 contract ERC721Enumerable is ERC721Basic {
99   function totalSupply() public view returns (uint256);
100   function tokenOfOwnerByIndex(
101     address _owner,
102     uint256 _index
103   )
104     public
105     view
106     returns (uint256 _tokenId);
107 
108   function tokenByIndex(uint256 _index) public view returns (uint256);
109 }
110 
111 
112 contract ERC721Metadata is ERC721Basic {
113   function name() external view returns (string _name);
114   function symbol() external view returns (string _symbol);
115   function tokenURI(uint256 _tokenId) public view returns (string);
116 }
117 
118 
119 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
120 }
121 
122 
123 
124 
125 contract ERC721Receiver {
126 
127   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
128 
129   function onERC721Received(
130     address _operator,
131     address _from,
132     uint256 _tokenId,
133     bytes _data
134   )
135     public
136     returns(bytes4);
137 }
138 
139 
140 
141 library SafeMath {
142 
143   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
144 
145     if (a == 0) {
146       return 0;
147     }
148 
149     c = a * b;
150     assert(c / a == b);
151     return c;
152   }
153 
154   function div(uint256 a, uint256 b) internal pure returns (uint256) {
155 
156     return a / b;
157   }
158 
159   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
160     assert(b <= a);
161     return a - b;
162   }
163 
164   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
165     c = a + b;
166     assert(c >= a);
167     return c;
168   }
169 }
170 
171 
172 library AddressUtils {
173 
174 
175   function isContract(address addr) internal view returns (bool) {
176     uint256 size;
177     assembly { size := extcodesize(addr) }
178     return size > 0;
179   }
180 
181 }
182 
183 
184 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
185 
186   using SafeMath for uint256;
187   using AddressUtils for address;
188 
189   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
190 
191   mapping (uint256 => address) internal tokenOwner;
192   mapping (uint256 => address) internal tokenApprovals;
193   mapping (address => uint256) internal ownedTokensCount;
194   mapping (address => mapping (address => bool)) internal operatorApprovals;
195 
196   constructor()
197     public
198   {
199     _registerInterface(InterfaceId_ERC721);
200     _registerInterface(InterfaceId_ERC721Exists);
201   }
202 
203   function balanceOf(address _owner) public view returns (uint256) {
204     require(_owner != address(0));
205     return ownedTokensCount[_owner];
206   }
207 
208   function ownerOf(uint256 _tokenId) public view returns (address) {
209     address owner = tokenOwner[_tokenId];
210     require(owner != address(0));
211     return owner;
212   }
213 
214   function exists(uint256 _tokenId) public view returns (bool) {
215     address owner = tokenOwner[_tokenId];
216     return owner != address(0);
217   }
218 
219   function approve(address _to, uint256 _tokenId) public {
220     address owner = ownerOf(_tokenId);
221     require(_to != owner);
222     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
223 
224     tokenApprovals[_tokenId] = _to;
225     emit Approval(owner, _to, _tokenId);
226   }
227 
228   function getApproved(uint256 _tokenId) public view returns (address) {
229     return tokenApprovals[_tokenId];
230   }
231 
232   function setApprovalForAll(address _to, bool _approved) public {
233     require(_to != msg.sender);
234     operatorApprovals[msg.sender][_to] = _approved;
235     emit ApprovalForAll(msg.sender, _to, _approved);
236   }
237 
238   function isApprovedForAll(
239     address _owner,
240     address _operator
241   )
242     public
243     view
244     returns (bool)
245   {
246     return operatorApprovals[_owner][_operator];
247   }
248 
249   function transferFrom(
250     address _from,
251     address _to,
252     uint256 _tokenId
253   )
254     public
255   {
256     require(isApprovedOrOwner(msg.sender, _tokenId));
257     require(_from != address(0));
258     require(_to != address(0));
259 
260     clearApproval(_from, _tokenId);
261     removeTokenFrom(_from, _tokenId);
262     addTokenTo(_to, _tokenId);
263 
264     emit Transfer(_from, _to, _tokenId);
265   }
266 
267   function safeTransferFrom(
268     address _from,
269     address _to,
270     uint256 _tokenId
271   )
272     public
273   {
274     // solium-disable-next-line arg-overflow
275     safeTransferFrom(_from, _to, _tokenId, "");
276   }
277 
278   function safeTransferFrom(
279     address _from,
280     address _to,
281     uint256 _tokenId,
282     bytes _data
283   )
284     public
285   {
286     transferFrom(_from, _to, _tokenId);
287     // solium-disable-next-line arg-overflow
288     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
289   }
290 
291   function isApprovedOrOwner(
292     address _spender,
293     uint256 _tokenId
294   )
295     internal
296     view
297     returns (bool)
298   {
299     address owner = ownerOf(_tokenId);
300     return (
301       _spender == owner ||
302       getApproved(_tokenId) == _spender ||
303       isApprovedForAll(owner, _spender)
304     );
305   }
306 
307 
308   function _mint(address _to, uint256 _tokenId) internal {
309     require(_to != address(0));
310     addTokenTo(_to, _tokenId);
311     emit Transfer(address(0), _to, _tokenId);
312   }
313 
314   function _burn(address _owner, uint256 _tokenId) internal {
315     clearApproval(_owner, _tokenId);
316     removeTokenFrom(_owner, _tokenId);
317     emit Transfer(_owner, address(0), _tokenId);
318   }
319 
320   function clearApproval(address _owner, uint256 _tokenId) internal {
321     require(ownerOf(_tokenId) == _owner);
322     if (tokenApprovals[_tokenId] != address(0)) {
323       tokenApprovals[_tokenId] = address(0);
324     }
325   }
326 
327   function addTokenTo(address _to, uint256 _tokenId) internal {
328     require(tokenOwner[_tokenId] == address(0));
329     tokenOwner[_tokenId] = _to;
330     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
331   }
332 
333   function removeTokenFrom(address _from, uint256 _tokenId) internal {
334     require(ownerOf(_tokenId) == _from);
335     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
336     tokenOwner[_tokenId] = address(0);
337   }
338 
339   function checkAndCallSafeTransfer(
340     address _from,
341     address _to,
342     uint256 _tokenId,
343     bytes _data
344   )
345     internal
346     returns (bool)
347   {
348     if (!_to.isContract()) {
349       return true;
350     }
351     bytes4 retval = ERC721Receiver(_to).onERC721Received(
352       msg.sender, _from, _tokenId, _data);
353     return (retval == ERC721_RECEIVED);
354   }
355 }
356 
357 
358 
359 
360 
361 
362 
363 contract ERC721Token is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
364 
365   // Token name
366   string internal name_;
367 
368   // Token symbol
369   string internal symbol_;
370 
371   // Mapping from owner to list of owned token IDs
372   mapping(address => uint256[]) internal ownedTokens;
373 
374   // Mapping from token ID to index of the owner tokens list
375   mapping(uint256 => uint256) internal ownedTokensIndex;
376 
377   // Array with all token ids, used for enumeration
378   uint256[] internal allTokens;
379 
380   // Mapping from token id to position in the allTokens array
381   mapping(uint256 => uint256) internal allTokensIndex;
382 
383   // Optional mapping for token URIs
384   mapping(uint256 => string) internal tokenURIs;
385 
386   constructor(string _name, string _symbol) public {
387     name_ = _name;
388     symbol_ = _symbol;
389 
390     // register the supported interfaces to conform to ERC721 via ERC165
391     _registerInterface(InterfaceId_ERC721Enumerable);
392     _registerInterface(InterfaceId_ERC721Metadata);
393   }
394 
395   function name() external view returns (string) {
396     return name_;
397   }
398 
399   function symbol() external view returns (string) {
400     return symbol_;
401   }
402 
403   function tokenURI(uint256 _tokenId) public view returns (string) {
404     require(exists(_tokenId));
405     return tokenURIs[_tokenId];
406   }
407 
408   function tokenOfOwnerByIndex(
409     address _owner,
410     uint256 _index
411   )
412     public
413     view
414     returns (uint256)
415   {
416     require(_index < balanceOf(_owner));
417     return ownedTokens[_owner][_index];
418   }
419 
420   function totalSupply() public view returns (uint256) {
421     return allTokens.length;
422   }
423 
424   function tokenByIndex(uint256 _index) public view returns (uint256) {
425     require(_index < totalSupply());
426     return allTokens[_index];
427   }
428 
429 
430   function _setTokenURI(uint256 _tokenId, string _uri) internal {
431     require(exists(_tokenId));
432     tokenURIs[_tokenId] = _uri;
433   }
434 
435 
436   function addTokenTo(address _to, uint256 _tokenId) internal {
437     super.addTokenTo(_to, _tokenId);
438     uint256 length = ownedTokens[_to].length;
439     ownedTokens[_to].push(_tokenId);
440     ownedTokensIndex[_tokenId] = length;
441   }
442 
443 
444   function removeTokenFrom(address _from, uint256 _tokenId) internal {
445     super.removeTokenFrom(_from, _tokenId);
446 
447     uint256 tokenIndex = ownedTokensIndex[_tokenId];
448     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
449     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
450 
451     ownedTokens[_from][tokenIndex] = lastToken;
452     ownedTokens[_from].length--; // This also deletes the contents at the last position of the array
453 
454     ownedTokensIndex[_tokenId] = 0;
455     ownedTokensIndex[lastToken] = tokenIndex;
456   }
457 
458 
459   function _mint(address _to, uint256 _tokenId) internal {
460     super._mint(_to, _tokenId);
461 
462     allTokensIndex[_tokenId] = allTokens.length;
463     allTokens.push(_tokenId);
464   }
465 
466 
467   function _burn(address _owner, uint256 _tokenId) internal {
468     super._burn(_owner, _tokenId);
469 
470     if (bytes(tokenURIs[_tokenId]).length != 0) {
471       delete tokenURIs[_tokenId];
472     }
473 
474     uint256 tokenIndex = allTokensIndex[_tokenId];
475     uint256 lastTokenIndex = allTokens.length.sub(1);
476     uint256 lastToken = allTokens[lastTokenIndex];
477 
478     allTokens[tokenIndex] = lastToken;
479     allTokens[lastTokenIndex] = 0;
480 
481     allTokens.length--;
482     allTokensIndex[_tokenId] = 0;
483     allTokensIndex[lastToken] = tokenIndex;
484   }
485 
486 }
487 
488 
489 contract LetterToken307 is ERC721Token {
490 
491   constructor() public ERC721Token("LetterToken307","LetterToken307") { }
492 
493   struct Token{
494     string UplinePaid;
495     string GameID;
496     string FortuneCookie;
497     string Letter;
498     uint256 Amt;
499   }
500 
501   Token[] private tokens;
502 
503   
504   function create(address paid1, address paid2, address paid3, address paid4, address paid5, address paid6, address paid7, string GameID, string FortuneCookie, string Letter) public payable returns (uint256 _tokenId) {
505 
506 
507     uint256  Amt=msg.value/7;
508     paid1.transfer(Amt);
509     paid2.transfer(Amt);
510     paid3.transfer(Amt);
511     paid4.transfer(Amt);
512     paid5.transfer(Amt);
513     paid6.transfer(Amt);
514     paid7.transfer(Amt);
515 
516     //Generate A String Proving The Upline Was Paid
517     string memory UplinePaid=StoreProofOfUplinePaid(paid1,paid2,paid3,paid4,paid5,paid6,paid7,Amt);
518 
519 
520     //Add The Token	
521     Token memory _newToken = Token({
522 	    UplinePaid: UplinePaid,
523 	    GameID: GameID,
524         FortuneCookie: FortuneCookie,
525         Letter: Letter,
526 	    Amt: Amt
527     });
528     _tokenId = tokens.push(_newToken) - 1;
529     
530     string memory tokenUri = createTokenUri(GameID);
531     _mint(msg.sender,_tokenId);
532     _setTokenURI(_tokenId, tokenUri);
533 
534     
535     //Emit The Token
536     emit Create(_tokenId,msg.sender,UplinePaid,Amt,GameID,FortuneCookie,Letter,tokenUri);
537     return _tokenId;
538   }
539 
540   event Create(
541     uint _id,
542     address indexed _owner,string UplinePaid,uint256 amt, string GameID, 
543     string FortuneCookie,
544     string Letter,
545     string tokenUri
546   );
547 
548   function get(uint256 _id) public view returns (address owner, string UplinePaid,string Letter,string GameID,string FortuneCookie) {
549     return (
550     
551       tokenOwner[_id],
552       tokens[_id].UplinePaid,
553       tokens[_id].Letter,
554       tokens[_id].GameID,
555       tokens[_id].FortuneCookie
556     );
557   }
558 
559   function tokensOfOwner(address _owner) public view returns(uint256[]) {
560     return ownedTokens[_owner];
561   }
562 
563 
564  function toAsciiString(address x) internal pure returns (string) {
565     bytes memory s = new bytes(40);
566     for (uint i = 0; i < 20; i++) {
567         byte b = byte(uint8(uint(x) / (2**(8*(19 - i)))));
568         byte hi = byte(uint8(b) / 16);
569         byte lo = byte(uint8(b) - 16 * uint8(hi));
570         s[2*i] = char(hi);
571         s[2*i+1] = char(lo);            
572     }
573     return string(s);
574 }
575 
576  function char(byte b) internal pure returns (byte c) {
577     if (b < 10) return byte(uint8(b) + 0x30);
578     else return byte(uint8(b) + 0x57);
579 }
580 
581   function createTokenUri(string GameID) internal pure returns (string){
582     string memory uri = "https://www.millionetherwords.com/Win/At?game=";
583     
584     uri = strConcat(uri,GameID);
585     
586     return uri;
587   }
588   
589   
590   function StoreProofOfUplinePaid(address paid1, address paid2, address paid3, address paid4, address paid5, address paid6, address paid7,uint256 amt) internal pure returns (string){
591     string memory UplinePaid = "";
592     
593     UplinePaid = strConcat(UplinePaid,toAsciiString(paid1));
594     UplinePaid = strConcat(UplinePaid,"-");
595 
596     UplinePaid = strConcat(UplinePaid,toAsciiString(paid2));
597     UplinePaid = strConcat(UplinePaid,"-");
598     
599     UplinePaid = strConcat(UplinePaid,toAsciiString(paid3));
600     UplinePaid = strConcat(UplinePaid,"-");
601     
602     UplinePaid = strConcat(UplinePaid,toAsciiString(paid4));
603     UplinePaid = strConcat(UplinePaid,"-");
604     
605     UplinePaid = strConcat(UplinePaid,toAsciiString(paid5));
606     UplinePaid = strConcat(UplinePaid,"-");
607     
608     UplinePaid = strConcat(UplinePaid,toAsciiString(paid6));
609     UplinePaid = strConcat(UplinePaid,"-");
610     
611     UplinePaid = strConcat(UplinePaid,toAsciiString(paid7));
612     UplinePaid = strConcat(UplinePaid,"-");
613     
614     UplinePaid = strConcat(UplinePaid,uint2str(amt));
615     return UplinePaid;
616   }
617 
618 function uint2str(uint i) internal pure returns (string){
619 
620     bytes32 data = bytes32(i);
621     bytes memory bytesString = new bytes(32);
622     for (uint j=0; j<32; j++) {
623         byte char1 = byte(bytes32(uint(data) * 2 ** (8 * j)));
624         if (char1 != 0) {
625             bytesString[j] = char1;
626         }
627     }
628     return string(bytesString);
629 
630     
631 }
632 
633 
634 
635     function strConcat(string _a, string _b) internal pure returns (string) {
636         bytes memory _ba = bytes(_a);
637         bytes memory _bb = bytes(_b);
638         string memory ab = new string(_ba.length + _bb.length);
639         bytes memory bab = bytes(ab);
640         uint k = 0;
641         for (uint i = 0; i < _ba.length; i++) bab[k++] = _ba[i];
642         for (uint i2 = 0; i2 < _bb.length; i2++) bab[k++] = _bb[i2];
643         return string(bab);
644     }
645 
646 }