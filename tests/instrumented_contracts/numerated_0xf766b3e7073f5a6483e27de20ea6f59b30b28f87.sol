1 pragma solidity ^0.4.24;
2 
3 
4 
5 library ECRecovery {
6 
7   
8   function recover(bytes32 hash, bytes sig)
9     internal
10     pure
11     returns (address)
12   {
13     bytes32 r;
14     bytes32 s;
15     uint8 v;
16 
17    
18     if (sig.length != 65) {
19       return (address(0));
20     }
21 
22    
23    
24    
25    
26     assembly {
27       r := mload(add(sig, 32))
28       s := mload(add(sig, 64))
29       v := byte(0, mload(add(sig, 96)))
30     }
31 
32    
33     if (v < 27) {
34       v += 27;
35     }
36 
37    
38     if (v != 27 && v != 28) {
39       return (address(0));
40     } else {
41      
42       return ecrecover(toEthSignedMessageHash(hash), v, r, s);
43     }
44   }
45 
46   
47   function toEthSignedMessageHash(bytes32 hash)
48     internal
49     pure
50     returns (bytes32)
51   {
52    
53    
54     return keccak256(
55       abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
56     );
57   }
58 }
59 
60 
61 contract Ownable {
62   address public owner;
63 
64 
65   event OwnershipRenounced(address indexed previousOwner);
66   event OwnershipTransferred(
67     address indexed previousOwner,
68     address indexed newOwner
69   );
70 
71 
72   
73   constructor() public {
74     owner = msg.sender;
75   }
76 
77   
78   modifier onlyOwner() {
79     require(msg.sender == owner);
80     _;
81   }
82 
83   
84   function renounceOwnership() public onlyOwner {
85     emit OwnershipRenounced(owner);
86     owner = address(0);
87   }
88 
89   
90   function transferOwnership(address _newOwner) public onlyOwner {
91     _transferOwnership(_newOwner);
92   }
93 
94   
95   function _transferOwnership(address _newOwner) internal {
96     require(_newOwner != address(0));
97     emit OwnershipTransferred(owner, _newOwner);
98     owner = _newOwner;
99   }
100 }
101 
102 
103 interface ERC165 {
104 
105   
106   function supportsInterface(bytes4 _interfaceId)
107     external
108     view
109     returns (bool);
110 }
111 
112 
113 contract SupportsInterfaceWithLookup is ERC165 {
114   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
115   
116 
117   
118   mapping(bytes4 => bool) internal supportedInterfaces;
119 
120   
121   constructor()
122     public
123   {
124     _registerInterface(InterfaceId_ERC165);
125   }
126 
127   
128   function supportsInterface(bytes4 _interfaceId)
129     external
130     view
131     returns (bool)
132   {
133     return supportedInterfaces[_interfaceId];
134   }
135 
136   
137   function _registerInterface(bytes4 _interfaceId)
138     internal
139   {
140     require(_interfaceId != 0xffffffff);
141     supportedInterfaces[_interfaceId] = true;
142   }
143 }
144 
145 
146 contract ERC721Basic is ERC165 {
147   event Transfer(
148     address indexed _from,
149     address indexed _to,
150     uint256 indexed _tokenId
151   );
152   event Approval(
153     address indexed _owner,
154     address indexed _approved,
155     uint256 indexed _tokenId
156   );
157   event ApprovalForAll(
158     address indexed _owner,
159     address indexed _operator,
160     bool _approved
161   );
162 
163   function balanceOf(address _owner) public view returns (uint256 _balance);
164   function ownerOf(uint256 _tokenId) public view returns (address _owner);
165   function exists(uint256 _tokenId) public view returns (bool _exists);
166 
167   function approve(address _to, uint256 _tokenId) public;
168   function getApproved(uint256 _tokenId)
169     public view returns (address _operator);
170 
171   function setApprovalForAll(address _operator, bool _approved) public;
172   function isApprovedForAll(address _owner, address _operator)
173     public view returns (bool);
174 
175   function transferFrom(address _from, address _to, uint256 _tokenId) public;
176   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
177     public;
178 
179   function safeTransferFrom(
180     address _from,
181     address _to,
182     uint256 _tokenId,
183     bytes _data
184   )
185     public;
186 }
187 
188 
189 contract ERC721Enumerable is ERC721Basic {
190   function totalSupply() public view returns (uint256);
191   function tokenOfOwnerByIndex(
192     address _owner,
193     uint256 _index
194   )
195     public
196     view
197     returns (uint256 _tokenId);
198 
199   function tokenByIndex(uint256 _index) public view returns (uint256);
200 }
201 
202 
203 
204 contract ERC721Metadata is ERC721Basic {
205   function name() external view returns (string _name);
206   function symbol() external view returns (string _symbol);
207   function tokenURI(uint256 _tokenId) public view returns (string);
208 }
209 
210 
211 
212 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
213 }
214 
215 
216 library AddressUtils {
217 
218   
219   function isContract(address addr) internal view returns (bool) {
220     uint256 size;
221    
222    
223    
224    
225    
226    
227    
228     assembly { size := extcodesize(addr) }
229     return size > 0;
230   }
231 
232 }
233 
234 
235 library SafeMath {
236 
237   
238   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
239    
240    
241    
242     if (a == 0) {
243       return 0;
244     }
245 
246     c = a * b;
247     assert(c / a == b);
248     return c;
249   }
250 
251   
252   function div(uint256 a, uint256 b) internal pure returns (uint256) {
253    
254    
255    
256     return a / b;
257   }
258 
259   
260   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
261     assert(b <= a);
262     return a - b;
263   }
264 
265   
266   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
267     c = a + b;
268     assert(c >= a);
269     return c;
270   }
271 }
272 
273 
274 contract ERC721Receiver {
275   
276   bytes4 internal constant ERC721_RECEIVED = 0xf0b9e5ba;
277 
278   
279   function onERC721Received(
280     address _from,
281     uint256 _tokenId,
282     bytes _data
283   )
284     public
285     returns(bytes4);
286 }
287 
288 
289 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
290 
291   bytes4 private constant InterfaceId_ERC721 = 0x80ac58cd;
292   
293 
294   bytes4 private constant InterfaceId_ERC721Exists = 0x4f558e79;
295   
296 
297   using SafeMath for uint256;
298   using AddressUtils for address;
299 
300  
301  
302   bytes4 private constant ERC721_RECEIVED = 0xf0b9e5ba;
303 
304  
305   mapping (uint256 => address) internal tokenOwner;
306 
307  
308   mapping (uint256 => address) internal tokenApprovals;
309 
310  
311   mapping (address => uint256) internal ownedTokensCount;
312 
313  
314   mapping (address => mapping (address => bool)) internal operatorApprovals;
315 
316   
317   modifier onlyOwnerOf(uint256 _tokenId) {
318     require(ownerOf(_tokenId) == msg.sender);
319     _;
320   }
321 
322   
323   modifier canTransfer(uint256 _tokenId) {
324     require(isApprovedOrOwner(msg.sender, _tokenId));
325     _;
326   }
327 
328   constructor()
329     public
330   {
331    
332     _registerInterface(InterfaceId_ERC721);
333     _registerInterface(InterfaceId_ERC721Exists);
334   }
335 
336   
337   function balanceOf(address _owner) public view returns (uint256) {
338     require(_owner != address(0));
339     return ownedTokensCount[_owner];
340   }
341 
342   
343   function ownerOf(uint256 _tokenId) public view returns (address) {
344     address owner = tokenOwner[_tokenId];
345     require(owner != address(0));
346     return owner;
347   }
348 
349   
350   function exists(uint256 _tokenId) public view returns (bool) {
351     address owner = tokenOwner[_tokenId];
352     return owner != address(0);
353   }
354 
355   
356   function approve(address _to, uint256 _tokenId) public {
357     address owner = ownerOf(_tokenId);
358     require(_to != owner);
359     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
360 
361     tokenApprovals[_tokenId] = _to;
362     emit Approval(owner, _to, _tokenId);
363   }
364 
365   
366   function getApproved(uint256 _tokenId) public view returns (address) {
367     return tokenApprovals[_tokenId];
368   }
369 
370   
371   function setApprovalForAll(address _to, bool _approved) public {
372     require(_to != msg.sender);
373     operatorApprovals[msg.sender][_to] = _approved;
374     emit ApprovalForAll(msg.sender, _to, _approved);
375   }
376 
377   
378   function isApprovedForAll(
379     address _owner,
380     address _operator
381   )
382     public
383     view
384     returns (bool)
385   {
386     return operatorApprovals[_owner][_operator];
387   }
388 
389   
390   function transferFrom(
391     address _from,
392     address _to,
393     uint256 _tokenId
394   )
395     public
396     canTransfer(_tokenId)
397   {
398     require(_from != address(0));
399     require(_to != address(0));
400 
401     clearApproval(_from, _tokenId);
402     removeTokenFrom(_from, _tokenId);
403     addTokenTo(_to, _tokenId);
404 
405     emit Transfer(_from, _to, _tokenId);
406   }
407 
408   
409   function safeTransferFrom(
410     address _from,
411     address _to,
412     uint256 _tokenId
413   )
414     public
415     canTransfer(_tokenId)
416   {
417    
418     safeTransferFrom(_from, _to, _tokenId, "");
419   }
420 
421   
422   function safeTransferFrom(
423     address _from,
424     address _to,
425     uint256 _tokenId,
426     bytes _data
427   )
428     public
429     canTransfer(_tokenId)
430   {
431     transferFrom(_from, _to, _tokenId);
432    
433     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
434   }
435 
436   
437   function isApprovedOrOwner(
438     address _spender,
439     uint256 _tokenId
440   )
441     internal
442     view
443     returns (bool)
444   {
445     address owner = ownerOf(_tokenId);
446    
447    
448    
449     return (
450       _spender == owner ||
451       getApproved(_tokenId) == _spender ||
452       isApprovedForAll(owner, _spender)
453     );
454   }
455 
456   
457   function _mint(address _to, uint256 _tokenId) internal {
458     require(_to != address(0));
459     addTokenTo(_to, _tokenId);
460     emit Transfer(address(0), _to, _tokenId);
461   }
462 
463   
464   function _burn(address _owner, uint256 _tokenId) internal {
465     clearApproval(_owner, _tokenId);
466     removeTokenFrom(_owner, _tokenId);
467     emit Transfer(_owner, address(0), _tokenId);
468   }
469 
470   
471   function clearApproval(address _owner, uint256 _tokenId) internal {
472     require(ownerOf(_tokenId) == _owner);
473     if (tokenApprovals[_tokenId] != address(0)) {
474       tokenApprovals[_tokenId] = address(0);
475       emit Approval(_owner, address(0), _tokenId);
476     }
477   }
478 
479   
480   function addTokenTo(address _to, uint256 _tokenId) internal {
481     require(tokenOwner[_tokenId] == address(0));
482     tokenOwner[_tokenId] = _to;
483     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
484   }
485 
486   
487   function removeTokenFrom(address _from, uint256 _tokenId) internal {
488     require(ownerOf(_tokenId) == _from);
489     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
490     tokenOwner[_tokenId] = address(0);
491   }
492 
493   
494   function checkAndCallSafeTransfer(
495     address _from,
496     address _to,
497     uint256 _tokenId,
498     bytes _data
499   )
500     internal
501     returns (bool)
502   {
503     if (!_to.isContract()) {
504       return true;
505     }
506     bytes4 retval = ERC721Receiver(_to).onERC721Received(
507       _from, _tokenId, _data);
508     return (retval == ERC721_RECEIVED);
509   }
510 }
511 
512 
513 contract ERC721Token is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
514 
515   bytes4 private constant InterfaceId_ERC721Enumerable = 0x780e9d63;
516   
517 
518   bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
519   
520 
521  
522   string internal name_;
523 
524  
525   string internal symbol_;
526 
527  
528   mapping(address => uint256[]) internal ownedTokens;
529 
530  
531   mapping(uint256 => uint256) internal ownedTokensIndex;
532 
533  
534   uint256[] internal allTokens;
535 
536  
537   mapping(uint256 => uint256) internal allTokensIndex;
538 
539  
540   mapping(uint256 => string) internal tokenURIs;
541 
542   
543   constructor(string _name, string _symbol) public {
544     name_ = _name;
545     symbol_ = _symbol;
546 
547    
548     _registerInterface(InterfaceId_ERC721Enumerable);
549     _registerInterface(InterfaceId_ERC721Metadata);
550   }
551 
552   
553   function name() external view returns (string) {
554     return name_;
555   }
556 
557   
558   function symbol() external view returns (string) {
559     return symbol_;
560   }
561 
562   
563   function tokenURI(uint256 _tokenId) public view returns (string) {
564     require(exists(_tokenId));
565     return tokenURIs[_tokenId];
566   }
567 
568   
569   function tokenOfOwnerByIndex(
570     address _owner,
571     uint256 _index
572   )
573     public
574     view
575     returns (uint256)
576   {
577     require(_index < balanceOf(_owner));
578     return ownedTokens[_owner][_index];
579   }
580 
581   
582   function totalSupply() public view returns (uint256) {
583     return allTokens.length;
584   }
585 
586   
587   function tokenByIndex(uint256 _index) public view returns (uint256) {
588     require(_index < totalSupply());
589     return allTokens[_index];
590   }
591 
592   
593   function _setTokenURI(uint256 _tokenId, string _uri) internal {
594     require(exists(_tokenId));
595     tokenURIs[_tokenId] = _uri;
596   }
597 
598   
599   function addTokenTo(address _to, uint256 _tokenId) internal {
600     super.addTokenTo(_to, _tokenId);
601     uint256 length = ownedTokens[_to].length;
602     ownedTokens[_to].push(_tokenId);
603     ownedTokensIndex[_tokenId] = length;
604   }
605 
606   
607   function removeTokenFrom(address _from, uint256 _tokenId) internal {
608     super.removeTokenFrom(_from, _tokenId);
609 
610     uint256 tokenIndex = ownedTokensIndex[_tokenId];
611     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
612     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
613 
614     ownedTokens[_from][tokenIndex] = lastToken;
615     ownedTokens[_from][lastTokenIndex] = 0;
616    
617    
618    
619 
620     ownedTokens[_from].length--;
621     ownedTokensIndex[_tokenId] = 0;
622     ownedTokensIndex[lastToken] = tokenIndex;
623   }
624 
625   
626   function _mint(address _to, uint256 _tokenId) internal {
627     super._mint(_to, _tokenId);
628 
629     allTokensIndex[_tokenId] = allTokens.length;
630     allTokens.push(_tokenId);
631   }
632 
633   
634   function _burn(address _owner, uint256 _tokenId) internal {
635     super._burn(_owner, _tokenId);
636 
637    
638     if (bytes(tokenURIs[_tokenId]).length != 0) {
639       delete tokenURIs[_tokenId];
640     }
641 
642    
643     uint256 tokenIndex = allTokensIndex[_tokenId];
644     uint256 lastTokenIndex = allTokens.length.sub(1);
645     uint256 lastToken = allTokens[lastTokenIndex];
646 
647     allTokens[tokenIndex] = lastToken;
648     allTokens[lastTokenIndex] = 0;
649 
650     allTokens.length--;
651     allTokensIndex[_tokenId] = 0;
652     allTokensIndex[lastToken] = tokenIndex;
653   }
654 
655 }
656 
657 
658 
659 
660 contract ImpItem is ERC721Token, Ownable {
661     using ECRecovery for bytes32;
662 
663     event TokenInformationUpdated(string _name, string _symbol);
664 
665     constructor(string _name, string _symbol) ERC721Token(_name, _symbol) public {
666 
667     }
668 
669     
670     function setTokenInformation(string _newName, string _newSymbol) external onlyOwner {
671         name_ = _newName;
672         symbol_ = _newSymbol;
673 
674        
675         emit TokenInformationUpdated(name_, symbol_);
676     }
677 
678     
679     function symbol() external view returns (string) {
680         return symbol_;
681     }
682 
683     
684     function burn(uint _tokenId) external {
685         _burn(msg.sender, _tokenId);
686     }
687 
688     
689     function mint(uint _tokenId, string _uri, bytes _signedData) external {
690         bytes32 validatingHash = keccak256(
691             abi.encodePacked(msg.sender, _tokenId, _uri)
692         );
693 
694        
695         address addressRecovered = validatingHash.recover(_signedData);
696 
697         require(addressRecovered == owner);
698 
699        
700        
701         _mint(msg.sender, _tokenId);
702 
703         _setTokenURI(_tokenId, _uri);
704     }
705 
706 }