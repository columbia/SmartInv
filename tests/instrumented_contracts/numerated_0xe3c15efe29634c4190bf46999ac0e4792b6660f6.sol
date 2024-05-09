1 pragma solidity ^0.4.24;
2 
3 interface ERC721 {
4   event Transfer(
5     address indexed _from,
6     address indexed _to,
7     uint256 indexed _tokenId
8   );
9 
10   event Approval(
11     address indexed _owner,
12     address indexed _approved,
13     uint256 indexed _tokenId
14   );
15 
16   event ApprovalForAll(
17     address indexed _owner,
18     address indexed _operator,
19     bool _approved
20   );
21 
22   function balanceOf(
23     address _owner
24   )
25     external
26     view
27     returns (uint256);
28 
29   function ownerOf(
30     uint256 _tokenId
31   )
32     external
33     view
34     returns (address);
35 
36   function safeTransferFrom(
37     address _from,
38     address _to,
39     uint256 _tokenId,
40     bytes _data
41   )
42     external;
43 
44   function safeTransferFrom(
45     address _from,
46     address _to,
47     uint256 _tokenId
48   )
49     external;
50 
51   function transferFrom(
52     address _from,
53     address _to,
54     uint256 _tokenId
55   )
56     external;
57 
58   function approve(
59     address _approved,
60     uint256 _tokenId
61   )
62     external;
63 
64   function setApprovalForAll(
65     address _operator,
66     bool _approved
67   )
68     external;
69 
70   function getApproved(
71     uint256 _tokenId
72   )
73     external
74     view
75     returns (address);
76 
77   function isApprovedForAll(
78     address _owner,
79     address _operator
80   )
81     external
82     view
83     returns (bool);
84 
85 }
86 
87 interface ERC721TokenReceiver {
88   function onERC721Received(
89     address _operator,
90     address _from,
91     uint256 _tokenId,
92     bytes _data
93   )
94     external
95     returns(bytes4);
96 }
97 
98 interface ERC721Enumerable {
99   function totalSupply()
100     external
101     view
102     returns (uint256);
103 
104   function tokenByIndex(
105     uint256 _index
106   )
107     external
108     view
109     returns (uint256);
110 
111   function tokenOfOwnerByIndex(
112     address _owner,
113     uint256 _index
114   )
115     external
116     view
117     returns (uint256);
118 }
119 
120 interface ERC721Metadata {
121   function name()
122     external
123     view
124     returns (string _name);
125 
126   function symbol()
127     external
128     view
129     returns (string _symbol);
130 
131   function tokenURI(uint256 _tokenId)
132     external
133     view
134     returns (string, string, string, uint256, uint256);
135 }
136 
137 library SafeMath {
138     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
139         if (a == 0) {
140             return 0;
141         }
142         c = a * b;
143         assert(c / a == b);
144         return c;
145     }
146 
147     function div(uint256 a, uint256 b) internal pure returns (uint256) {
148         return a / b;
149     }
150 
151     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
152         assert(b <= a);
153         return a - b;
154     }
155 
156     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
157         c = a + b;
158         assert(c >= a);
159         return c;
160     }
161 }
162 
163 library AddressUtils {
164     function isContract(address addr) internal view returns (bool) {
165         uint256 size;
166         assembly { size := extcodesize(addr) }
167         return size > 0;
168     }
169 
170 }
171 
172 interface ERC165 {
173   function supportsInterface(
174     bytes4 _interfaceID
175   )
176     external
177     view
178     returns (bool);
179 
180 }
181 
182 contract Ownable {
183   address public owner;
184 
185 
186   /** 
187    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
188    * account.
189    */
190   constructor () public{
191     owner = msg.sender;
192   }
193 
194 
195   /**
196    * @dev Throws if called by any account other than the owner. 
197    */
198   modifier onlyOwner() {
199     require(owner==msg.sender);
200     _;
201  }
202 
203   /**
204    * @dev Allows the current owner to transfer control of the contract to a newOwner.
205    * @param newOwner The address to transfer ownership to. 
206    */
207   function transferOwnership(address newOwner) public onlyOwner {
208       owner = newOwner;
209   }
210  
211 }
212 
213 contract SupportsInterface is
214   ERC165
215 {
216   mapping(bytes4 => bool) internal supportedInterfaces;
217 
218   constructor()
219     public
220   {
221     supportedInterfaces[0x01ffc9a7] = true; // ERC165
222   }
223 
224   function supportsInterface(
225     bytes4 _interfaceID
226   )
227     external
228     view
229     returns (bool)
230   {
231     return supportedInterfaces[_interfaceID];
232   }
233 
234 }
235 
236 contract NFToken is
237   ERC721,
238   SupportsInterface
239 {
240   using SafeMath for uint256;
241   using AddressUtils for address;
242 
243   mapping (uint256 => address) internal idToOwner;
244   mapping (uint256 => address) internal idToApprovals;
245   mapping (address => uint256) internal ownerToNFTokenCount;
246   mapping (address => mapping (address => bool)) internal ownerToOperators;
247   bytes4 constant MAGIC_ON_ERC721_RECEIVED = 0x150b7a02;
248 
249   event Transfer(
250     address indexed _from,
251     address indexed _to,
252     uint256 indexed _tokenId
253   );
254 
255   event Approval(
256     address indexed _owner,
257     address indexed _approved,
258     uint256 indexed _tokenId
259   );
260 
261   event ApprovalForAll(
262     address indexed _owner,
263     address indexed _operator,
264     bool _approved
265   );
266 
267   modifier canOperate(
268     uint256 _tokenId
269   ) {
270     address tokenOwner = idToOwner[_tokenId];
271     require(tokenOwner == msg.sender || ownerToOperators[tokenOwner][msg.sender]);
272     _;
273   }
274 
275   modifier canTransfer(
276     uint256 _tokenId
277   ) {
278     address tokenOwner = idToOwner[_tokenId];
279     require(
280       tokenOwner == msg.sender
281       || getApproved(_tokenId) == msg.sender
282       || ownerToOperators[tokenOwner][msg.sender]
283     );
284 
285     _;
286   }
287 
288   modifier validNFToken(
289     uint256 _tokenId
290   ) {
291     require(idToOwner[_tokenId] != address(0));
292     _;
293   }
294 
295   constructor()
296     public
297   {
298     supportedInterfaces[0x80ac58cd] = true; // ERC721
299   }
300 
301   function balanceOf(
302     address _owner
303   )
304     external
305     view
306     returns (uint256)
307   {
308     require(_owner != address(0));
309     return ownerToNFTokenCount[_owner];
310   }
311 
312   function ownerOf(
313     uint256 _tokenId
314   )
315     external
316     view
317     returns (address _owner)
318   {
319     _owner = idToOwner[_tokenId];
320     require(_owner != address(0));
321   }
322 
323   function safeTransferFrom(
324     address _from,
325     address _to,
326     uint256 _tokenId,
327     bytes _data
328   )
329     external
330   {
331     _safeTransferFrom(_from, _to, _tokenId, _data);
332   }
333 
334   function safeTransferFrom(
335     address _from,
336     address _to,
337     uint256 _tokenId
338   )
339     external
340   {
341     _safeTransferFrom(_from, _to, _tokenId, "");
342   }
343 
344   function transferFrom(
345     address _from,
346     address _to,
347     uint256 _tokenId
348   )
349     external
350     canTransfer(_tokenId)
351     validNFToken(_tokenId)
352   {
353     address tokenOwner = idToOwner[_tokenId];
354     require(tokenOwner == _from);
355     require(_to != address(0));
356 
357     _transfer(_to, _tokenId);
358   }
359 
360   function approve(
361     address _approved,
362     uint256 _tokenId
363   )
364     external
365     canOperate(_tokenId)
366     validNFToken(_tokenId)
367   {
368     address tokenOwner = idToOwner[_tokenId];
369     require(_approved != tokenOwner);
370 
371     idToApprovals[_tokenId] = _approved;
372     emit Approval(tokenOwner, _approved, _tokenId);
373   }
374 
375   function setApprovalForAll(
376     address _operator,
377     bool _approved
378   )
379     external
380   {
381     require(_operator != address(0));
382     ownerToOperators[msg.sender][_operator] = _approved;
383     emit ApprovalForAll(msg.sender, _operator, _approved);
384   }
385 
386   function getApproved(
387     uint256 _tokenId
388   )
389     public
390     view
391     validNFToken(_tokenId)
392     returns (address)
393   {
394     return idToApprovals[_tokenId];
395   }
396 
397   function isApprovedForAll(
398     address _owner,
399     address _operator
400   )
401     external
402     view
403     returns (bool)
404   {
405     require(_owner != address(0));
406     require(_operator != address(0));
407     return ownerToOperators[_owner][_operator];
408   }
409 
410   function _safeTransferFrom(
411     address _from,
412     address _to,
413     uint256 _tokenId,
414     bytes _data
415   )
416     internal
417     canTransfer(_tokenId)
418     validNFToken(_tokenId)
419   {
420     address tokenOwner = idToOwner[_tokenId];
421     require(tokenOwner == _from);
422     require(_to != address(0));
423 
424     _transfer(_to, _tokenId);
425 
426     if (_to.isContract()) {
427       bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
428       require(retval == MAGIC_ON_ERC721_RECEIVED);
429     }
430   }
431 
432   function _transfer(
433     address _to,
434     uint256 _tokenId
435   )
436     private
437   {
438     address from = idToOwner[_tokenId];
439     clearApproval(_tokenId);
440 
441     _removeNFToken(from, _tokenId);
442     _addNFToken(_to, _tokenId);
443 
444     emit Transfer(from, _to, _tokenId);
445   }
446 
447   function _mint(
448     address _to,
449     uint256 _tokenId
450   )
451     internal
452   {
453     require(_to != address(0));
454     require(_tokenId != 0);
455     require(idToOwner[_tokenId] == address(0));
456 
457     _addNFToken(_to, _tokenId);
458 
459     emit Transfer(address(0), _to, _tokenId);
460   }
461 
462   function _burn(
463     address _owner,
464     uint256 _tokenId
465   )
466     validNFToken(_tokenId)
467     internal
468   {
469     clearApproval(_tokenId);
470     _removeNFToken(_owner, _tokenId);
471     emit Transfer(_owner, address(0), _tokenId);
472   }
473 
474   function clearApproval(
475     uint256 _tokenId
476   )
477     private
478   {
479     if(idToApprovals[_tokenId] != 0)
480     {
481       delete idToApprovals[_tokenId];
482     }
483   }
484 
485   function _removeNFToken(
486     address _from,
487     uint256 _tokenId
488   )
489    internal
490   {
491     require(idToOwner[_tokenId] == _from);
492     assert(ownerToNFTokenCount[_from] > 0);
493     ownerToNFTokenCount[_from] = ownerToNFTokenCount[_from] - 1;
494     delete idToOwner[_tokenId];
495   }
496 
497   function _addNFToken(
498     address _to,
499     uint256 _tokenId
500   )
501     internal
502   {
503     require(idToOwner[_tokenId] == address(0));
504 
505     idToOwner[_tokenId] = _to;
506     ownerToNFTokenCount[_to] = ownerToNFTokenCount[_to].add(1);
507   }
508 }
509 
510 contract NFTokenEnumerable is
511   NFToken,
512   ERC721Enumerable
513 {
514   uint256[] internal tokens;
515   mapping(uint256 => uint256) internal idToIndex;
516   mapping(address => uint256[]) internal ownerToIds;
517   mapping(uint256 => uint256) internal idToOwnerIndex;
518   constructor()
519     public
520   {
521     supportedInterfaces[0x780e9d63] = true; // ERC721Enumerable
522   }
523 
524   function _mint(
525     address _to,
526     uint256 _tokenId
527   )
528     internal
529   {
530     super._mint(_to, _tokenId);
531     uint256 length = tokens.push(_tokenId);
532     idToIndex[_tokenId] = length - 1;
533   }
534 
535   function _burn(
536     address _owner,
537     uint256 _tokenId
538   )
539     internal
540   {
541     super._burn(_owner, _tokenId);
542     assert(tokens.length > 0);
543 
544     uint256 tokenIndex = idToIndex[_tokenId];
545     // Sanity check. This could be removed in the future.
546     assert(tokens[tokenIndex] == _tokenId);
547     uint256 lastTokenIndex = tokens.length - 1;
548     uint256 lastToken = tokens[lastTokenIndex];
549 
550     tokens[tokenIndex] = lastToken;
551 
552     tokens.length--;
553     idToIndex[lastToken] = tokenIndex;
554     idToIndex[_tokenId] = 0;
555   }
556 
557   function removeNFToken(
558     address _from,
559     uint256 _tokenId
560   )
561    internal
562   {
563     super._removeNFToken(_from, _tokenId);
564     assert(ownerToIds[_from].length > 0);
565 
566     uint256 tokenToRemoveIndex = idToOwnerIndex[_tokenId];
567     uint256 lastTokenIndex = ownerToIds[_from].length - 1;
568     uint256 lastToken = ownerToIds[_from][lastTokenIndex];
569 
570     ownerToIds[_from][tokenToRemoveIndex] = lastToken;
571 
572     ownerToIds[_from].length--;
573     idToOwnerIndex[lastToken] = tokenToRemoveIndex;
574     idToOwnerIndex[_tokenId] = 0;
575   }
576 
577   function addNFToken(
578     address _to,
579     uint256 _tokenId
580   )
581     internal
582   {
583     super._addNFToken(_to, _tokenId);
584 
585     uint256 length = ownerToIds[_to].push(_tokenId);
586     idToOwnerIndex[_tokenId] = length - 1;
587   }
588 
589   function totalSupply()
590     external
591     view
592     returns (uint256)
593   {
594     return tokens.length;
595   }
596 
597   function tokenByIndex(
598     uint256 _index
599   )
600     external
601     view
602     returns (uint256)
603   {
604     require(_index < tokens.length);
605     assert(idToIndex[tokens[_index]] == _index);
606     return tokens[_index];
607   }
608 
609   function tokenOfOwnerByIndex(
610     address _owner,
611     uint256 _index
612   )
613     external
614     view
615     returns (uint256)
616   {
617     require(_index < ownerToIds[_owner].length);
618     return ownerToIds[_owner][_index];
619   }
620 }
621 
622 contract NFTokenMetadata is
623   NFToken,
624   ERC721Metadata
625 {
626   struct Character {
627     string uri;
628     string chtype;
629     string name;
630     uint256 honey;
631     uint256 spec;
632   }
633 
634   string internal nftName = "BLUEPZ";
635   string internal nftSymbol = "BLPZ";
636   mapping (uint256 => Character) internal idToUri;
637 
638   constructor()
639     public
640   {
641     supportedInterfaces[0x5b5e139f] = true; // ERC721Metadata
642   }
643 
644   function _setTokenUri(
645     uint256 _tokenId,
646     string _uri,
647     string _chtype,
648     string _name,
649     uint256 _honey,
650     uint256 _spec)
651     validNFToken(_tokenId)
652     internal
653   {
654     idToUri[_tokenId] = Character(_uri, _chtype, _name, _honey, _spec);
655   }
656 
657   function name()
658     external
659     view
660     returns (string _name)
661   {
662     _name = nftName;
663   }
664 
665   function symbol()
666     external
667     view
668     returns (string _symbol)
669   {
670     _symbol = nftSymbol;
671   }
672 
673   function tokenURI(uint256 _tokenId) validNFToken(_tokenId) external view returns (string, string, string, uint256, uint256)
674   {
675     Character memory character = idToUri[_tokenId];
676     return (character.uri, character.chtype, character.name, character.honey, character.spec);
677   }
678 }
679 
680 contract BLUEPZ is NFTokenMetadata, NFTokenEnumerable, Ownable {
681   function mint(address _to, uint256 _tokenId) external onlyOwner
682   {
683     super._mint(_to, _tokenId);
684   }
685 
686   function burn(address _owner, uint256 _tokenId) external onlyOwner
687   {
688     super._burn(_owner, _tokenId);
689   }
690 
691   function removeNFBTNY(address _from, uint256 _tokenId) external onlyOwner
692   {
693     super.removeNFToken(_from, _tokenId);
694   }
695 
696   function addNFBTNY(address _to, uint256 _tokenId) external onlyOwner
697   {
698     super.addNFToken(_to, _tokenId);
699   }
700 
701   function setTokenUri(uint256 _tokenId, string _uri, string _chtype, string _name, uint256 _honey, uint256 _spec) external onlyOwner
702   {
703     super._setTokenUri(_tokenId, _uri, _chtype, _name, _honey, _spec);
704   }
705 }