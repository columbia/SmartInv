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
182 contract SupportsInterface is
183   ERC165
184 {
185   mapping(bytes4 => bool) internal supportedInterfaces;
186 
187   constructor()
188     public
189   {
190     supportedInterfaces[0x01ffc9a7] = true; // ERC165
191   }
192 
193   function supportsInterface(
194     bytes4 _interfaceID
195   )
196     external
197     view
198     returns (bool)
199   {
200     return supportedInterfaces[_interfaceID];
201   }
202 
203 }
204 
205 contract NFToken is
206   ERC721,
207   SupportsInterface
208 {
209   using SafeMath for uint256;
210   using AddressUtils for address;
211 
212   mapping (uint256 => address) internal idToOwner;
213   mapping (uint256 => address) internal idToApprovals;
214   mapping (address => uint256) internal ownerToNFTokenCount;
215   mapping (address => mapping (address => bool)) internal ownerToOperators;
216   bytes4 constant MAGIC_ON_ERC721_RECEIVED = 0x150b7a02;
217 
218   event Transfer(
219     address indexed _from,
220     address indexed _to,
221     uint256 indexed _tokenId
222   );
223 
224   event Approval(
225     address indexed _owner,
226     address indexed _approved,
227     uint256 indexed _tokenId
228   );
229 
230   event ApprovalForAll(
231     address indexed _owner,
232     address indexed _operator,
233     bool _approved
234   );
235 
236   modifier canOperate(
237     uint256 _tokenId
238   ) {
239     address tokenOwner = idToOwner[_tokenId];
240     require(tokenOwner == msg.sender || ownerToOperators[tokenOwner][msg.sender]);
241     _;
242   }
243 
244   modifier canTransfer(
245     uint256 _tokenId
246   ) {
247     address tokenOwner = idToOwner[_tokenId];
248     require(
249       tokenOwner == msg.sender
250       || getApproved(_tokenId) == msg.sender
251       || ownerToOperators[tokenOwner][msg.sender]
252     );
253 
254     _;
255   }
256 
257   modifier validNFToken(
258     uint256 _tokenId
259   ) {
260     require(idToOwner[_tokenId] != address(0));
261     _;
262   }
263 
264   constructor()
265     public
266   {
267     supportedInterfaces[0x80ac58cd] = true; // ERC721
268   }
269 
270   function balanceOf(
271     address _owner
272   )
273     external
274     view
275     returns (uint256)
276   {
277     require(_owner != address(0));
278     return ownerToNFTokenCount[_owner];
279   }
280 
281   function ownerOf(
282     uint256 _tokenId
283   )
284     external
285     view
286     returns (address _owner)
287   {
288     _owner = idToOwner[_tokenId];
289     require(_owner != address(0));
290   }
291 
292   function safeTransferFrom(
293     address _from,
294     address _to,
295     uint256 _tokenId,
296     bytes _data
297   )
298     external
299   {
300     _safeTransferFrom(_from, _to, _tokenId, _data);
301   }
302 
303   function safeTransferFrom(
304     address _from,
305     address _to,
306     uint256 _tokenId
307   )
308     external
309   {
310     _safeTransferFrom(_from, _to, _tokenId, "");
311   }
312 
313   function transferFrom(
314     address _from,
315     address _to,
316     uint256 _tokenId
317   )
318     external
319     canTransfer(_tokenId)
320     validNFToken(_tokenId)
321   {
322     address tokenOwner = idToOwner[_tokenId];
323     require(tokenOwner == _from);
324     require(_to != address(0));
325 
326     _transfer(_to, _tokenId);
327   }
328 
329   function approve(
330     address _approved,
331     uint256 _tokenId
332   )
333     external
334     canOperate(_tokenId)
335     validNFToken(_tokenId)
336   {
337     address tokenOwner = idToOwner[_tokenId];
338     require(_approved != tokenOwner);
339 
340     idToApprovals[_tokenId] = _approved;
341     emit Approval(tokenOwner, _approved, _tokenId);
342   }
343 
344   function setApprovalForAll(
345     address _operator,
346     bool _approved
347   )
348     external
349   {
350     require(_operator != address(0));
351     ownerToOperators[msg.sender][_operator] = _approved;
352     emit ApprovalForAll(msg.sender, _operator, _approved);
353   }
354 
355   function getApproved(
356     uint256 _tokenId
357   )
358     public
359     view
360     validNFToken(_tokenId)
361     returns (address)
362   {
363     return idToApprovals[_tokenId];
364   }
365 
366   function isApprovedForAll(
367     address _owner,
368     address _operator
369   )
370     external
371     view
372     returns (bool)
373   {
374     require(_owner != address(0));
375     require(_operator != address(0));
376     return ownerToOperators[_owner][_operator];
377   }
378 
379   function _safeTransferFrom(
380     address _from,
381     address _to,
382     uint256 _tokenId,
383     bytes _data
384   )
385     internal
386     canTransfer(_tokenId)
387     validNFToken(_tokenId)
388   {
389     address tokenOwner = idToOwner[_tokenId];
390     require(tokenOwner == _from);
391     require(_to != address(0));
392 
393     _transfer(_to, _tokenId);
394 
395     if (_to.isContract()) {
396       bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
397       require(retval == MAGIC_ON_ERC721_RECEIVED);
398     }
399   }
400 
401   function _transfer(
402     address _to,
403     uint256 _tokenId
404   )
405     private
406   {
407     address from = idToOwner[_tokenId];
408     clearApproval(_tokenId);
409 
410     _removeNFToken(from, _tokenId);
411     _addNFToken(_to, _tokenId);
412 
413     emit Transfer(from, _to, _tokenId);
414   }
415 
416   function _mint(
417     address _to,
418     uint256 _tokenId
419   )
420     internal
421   {
422     require(_to != address(0));
423     require(_tokenId != 0);
424     require(idToOwner[_tokenId] == address(0));
425 
426     _addNFToken(_to, _tokenId);
427 
428     emit Transfer(address(0), _to, _tokenId);
429   }
430 
431   function _burn(
432     address _owner,
433     uint256 _tokenId
434   )
435     validNFToken(_tokenId)
436     internal
437   {
438     clearApproval(_tokenId);
439     _removeNFToken(_owner, _tokenId);
440     emit Transfer(_owner, address(0), _tokenId);
441   }
442 
443   function clearApproval(
444     uint256 _tokenId
445   )
446     private
447   {
448     if(idToApprovals[_tokenId] != 0)
449     {
450       delete idToApprovals[_tokenId];
451     }
452   }
453 
454   function _removeNFToken(
455     address _from,
456     uint256 _tokenId
457   )
458    internal
459   {
460     require(idToOwner[_tokenId] == _from);
461     assert(ownerToNFTokenCount[_from] > 0);
462     ownerToNFTokenCount[_from] = ownerToNFTokenCount[_from] - 1;
463     delete idToOwner[_tokenId];
464   }
465 
466   function _addNFToken(
467     address _to,
468     uint256 _tokenId
469   )
470     internal
471   {
472     require(idToOwner[_tokenId] == address(0));
473 
474     idToOwner[_tokenId] = _to;
475     ownerToNFTokenCount[_to] = ownerToNFTokenCount[_to].add(1);
476   }
477 }
478 
479 contract NFTokenEnumerable is
480   NFToken,
481   ERC721Enumerable
482 {
483   uint256[] internal tokens;
484   mapping(uint256 => uint256) internal idToIndex;
485   mapping(address => uint256[]) internal ownerToIds;
486   mapping(uint256 => uint256) internal idToOwnerIndex;
487   constructor()
488     public
489   {
490     supportedInterfaces[0x780e9d63] = true; // ERC721Enumerable
491   }
492 
493   function _mint(
494     address _to,
495     uint256 _tokenId
496   )
497     internal
498   {
499     super._mint(_to, _tokenId);
500     uint256 length = tokens.push(_tokenId);
501     idToIndex[_tokenId] = length - 1;
502   }
503 
504   function _burn(
505     address _owner,
506     uint256 _tokenId
507   )
508     internal
509   {
510     super._burn(_owner, _tokenId);
511     assert(tokens.length > 0);
512 
513     uint256 tokenIndex = idToIndex[_tokenId];
514     // Sanity check. This could be removed in the future.
515     assert(tokens[tokenIndex] == _tokenId);
516     uint256 lastTokenIndex = tokens.length - 1;
517     uint256 lastToken = tokens[lastTokenIndex];
518 
519     tokens[tokenIndex] = lastToken;
520 
521     tokens.length--;
522     idToIndex[lastToken] = tokenIndex;
523     idToIndex[_tokenId] = 0;
524   }
525 
526   function removeNFToken(
527     address _from,
528     uint256 _tokenId
529   )
530    internal
531   {
532     super._removeNFToken(_from, _tokenId);
533     assert(ownerToIds[_from].length > 0);
534 
535     uint256 tokenToRemoveIndex = idToOwnerIndex[_tokenId];
536     uint256 lastTokenIndex = ownerToIds[_from].length - 1;
537     uint256 lastToken = ownerToIds[_from][lastTokenIndex];
538 
539     ownerToIds[_from][tokenToRemoveIndex] = lastToken;
540 
541     ownerToIds[_from].length--;
542     idToOwnerIndex[lastToken] = tokenToRemoveIndex;
543     idToOwnerIndex[_tokenId] = 0;
544   }
545 
546   function addNFToken(
547     address _to,
548     uint256 _tokenId
549   )
550     internal
551   {
552     super._addNFToken(_to, _tokenId);
553 
554     uint256 length = ownerToIds[_to].push(_tokenId);
555     idToOwnerIndex[_tokenId] = length - 1;
556   }
557 
558   function totalSupply()
559     external
560     view
561     returns (uint256)
562   {
563     return tokens.length;
564   }
565 
566   function tokenByIndex(
567     uint256 _index
568   )
569     external
570     view
571     returns (uint256)
572   {
573     require(_index < tokens.length);
574     assert(idToIndex[tokens[_index]] == _index);
575     return tokens[_index];
576   }
577 
578   function tokenOfOwnerByIndex(
579     address _owner,
580     uint256 _index
581   )
582     external
583     view
584     returns (uint256)
585   {
586     require(_index < ownerToIds[_owner].length);
587     return ownerToIds[_owner][_index];
588   }
589 }
590 
591 contract NFTokenMetadata is
592   NFToken,
593   ERC721Metadata
594 {
595   struct Character {
596     string uri;
597     string chtype;
598     string name;
599     uint256 honey;
600     uint256 spec;
601   }
602 
603   string internal nftName = "BLUEPZ";
604   string internal nftSymbol = "BLPZ";
605   mapping (uint256 => Character) internal idToUri;
606 
607   constructor()
608     public
609   {
610     supportedInterfaces[0x5b5e139f] = true; // ERC721Metadata
611   }
612 
613   function _setTokenUri(
614     uint256 _tokenId,
615     string _uri,
616     string _chtype,
617     string _name,
618     uint256 _honey,
619     uint256 _spec)
620     validNFToken(_tokenId)
621     internal
622   {
623     idToUri[_tokenId] = Character(_uri, _chtype, _name, _honey, _spec);
624   }
625 
626   function name()
627     external
628     view
629     returns (string _name)
630   {
631     _name = nftName;
632   }
633 
634   function symbol()
635     external
636     view
637     returns (string _symbol)
638   {
639     _symbol = nftSymbol;
640   }
641 
642   function tokenURI(uint256 _tokenId) validNFToken(_tokenId) external view returns (string, string, string, uint256, uint256)
643   {
644     Character memory character = idToUri[_tokenId];
645     return (character.uri, character.chtype, character.name, character.honey, character.spec);
646   }
647 }
648 
649 contract BLPZ is NFTokenMetadata, NFTokenEnumerable {
650   function mint(address _to, uint256 _tokenId)external
651   {
652     super._mint(_to, _tokenId);
653   }
654 
655   function burn(address _owner, uint256 _tokenId) external
656   {
657     super._burn(_owner, _tokenId);
658   }
659 
660   function removeNFBTNY(address _from, uint256 _tokenId) external
661   {
662     super.removeNFToken(_from, _tokenId);
663   }
664 
665   function addNFBTNY(address _to, uint256 _tokenId) external
666   {
667     super.addNFToken(_to, _tokenId);
668   }
669 
670   function setTokenUri(uint256 _tokenId, string _uri, string _chtype, string _name, uint256 _honey, uint256 _spec) external
671   {
672     super._setTokenUri(_tokenId, _uri, _chtype, _name, _honey, _spec);
673   }
674 }