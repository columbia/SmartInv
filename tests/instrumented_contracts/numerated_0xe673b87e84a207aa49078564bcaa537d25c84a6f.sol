1 pragma solidity ^0.5.17;
2 
3 interface paintglyphsV1Contract {
4     function ownerOf(uint256 tokenId) external view returns (address owner);
5     function transferFrom(address _from, address _to, uint256 _tokenId) external;
6 }
7 
8 interface ERC721TokenReceiver
9 {
10     function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes calldata _data) external returns(bytes4);
11 }
12 
13 contract Repaintedglyphs {
14 
15     event Generated(uint indexed index, address indexed a, string value);
16 
17     /// @dev This emits when ownership of any NFT changes by any mechanism.
18     ///  This event emits when NFTs are created (`from` == 0) and destroyed
19     ///  (`to` == 0). Exception: during contract creation, any number of NFTs
20     ///  may be created and assigned without emitting Transfer. At the time of
21     ///  any transfer, the approved address for that NFT (if any) is reset to none.
22     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
23 
24     /// @dev This emits when the approved address for an NFT is changed or
25     ///  reaffirmed. The zero address indicates there is no approved address.
26     ///  When a Transfer event emits, this also indicates that the approved
27     ///  address for that NFT (if any) is reset to none.
28     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
29 
30     /// @dev This emits when an operator is enabled or disabled for an owner.
31     ///  The operator can manage all NFTs of the owner.
32     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
33 
34     event ColorChanged(uint id, uint symbolToUpdate, uint newColor);
35     
36     bytes4 internal constant MAGIC_ON_ERC721_RECEIVED = 0x150b7a02;
37 
38     uint public constant TOKEN_LIMIT = 512;
39     uint public constant ARTIST_PRINTS = 0;
40 
41     uint public constant PRICE = 200 finney;
42 
43     address payable public constant BENEFICIARY = 0x8C9eEEcaeb226f1B8C1385abE0960754e08EC285;
44 
45     mapping (uint => address) private idToCreator;
46     mapping (uint => uint8) private idToSymbolScheme;
47     mapping (uint => uint256) private idToBackgroundColor;
48     mapping (uint => uint256[8]) private idToColorScheme;
49     mapping (uint => string) private processingCode;
50 
51     // ERC 165
52     mapping(bytes4 => bool) internal supportedInterfaces;
53 
54     /**
55      * @dev A mapping from NFT ID to the address that owns it.
56      */
57     mapping (uint256 => address) internal idToOwner;
58 
59     /**
60      * @dev A mapping from NFT ID to the seed used to make it.
61      */
62     mapping (uint256 => uint256) internal idToSeed;
63     mapping (uint256 => uint256) internal seedToId;
64 
65     /**
66      * @dev Mapping from NFT ID to approved address.
67      */
68     mapping (uint256 => address) internal idToApproval;
69 
70     /**
71      * @dev Mapping from owner address to mapping of operator addresses.
72      */
73     mapping (address => mapping (address => bool)) internal ownerToOperators;
74 
75     /**
76      * @dev Mapping from owner to list of owned NFT IDs.
77      */
78     mapping(address => uint256[]) internal ownerToIds;
79 
80     /**
81      * @dev Mapping from NFT ID to its index in the owner tokens list.
82      */
83     mapping(uint256 => uint256) internal idToOwnerIndex;
84 
85     /**
86      * @dev Total number of tokens.
87      */
88     uint internal numTokens = 102; //start index at 102 (# of paintglyphs v1)
89 
90     /**
91      * @dev Guarantees that the msg.sender is an owner or operator of the given NFT.
92      * @param _tokenId ID of the NFT to validate.
93      */
94     modifier canOperate(uint256 _tokenId) {
95         address tokenOwner = idToOwner[_tokenId];
96         require(tokenOwner == msg.sender || ownerToOperators[tokenOwner][msg.sender]);
97         _;
98     }
99 
100     /**
101      * @dev Guarantees that the msg.sender is allowed to transfer NFT.
102      * @param _tokenId ID of the NFT to transfer.
103      */
104     modifier canTransfer(uint256 _tokenId) {
105         address tokenOwner = idToOwner[_tokenId];
106         require(
107             tokenOwner == msg.sender
108             || idToApproval[_tokenId] == msg.sender
109             || ownerToOperators[tokenOwner][msg.sender]
110         );
111         _;
112     }
113 
114     /**
115      * @dev Guarantees that _tokenId is a valid Token.
116      * @param _tokenId ID of the NFT to validate.
117      */
118     modifier validNFToken(uint256 _tokenId) {
119         require(idToOwner[_tokenId] != address(0));
120         _;
121     }
122     
123         
124     modifier isOwner() {
125         require(msg.sender == owner, "Must be deployer of contract");
126         _;
127     }
128 
129     /**
130      * @dev Contract constructor.
131      */
132     constructor() public {
133         supportedInterfaces[0x01ffc9a7] = true; // ERC165
134         supportedInterfaces[0x80ac58cd] = true; // ERC721
135         supportedInterfaces[0x780e9d63] = true; // ERC721 Enumerable
136         supportedInterfaces[0x5b5e139f] = true; // ERC721 Metadata
137         paintglyphsV1 = paintglyphsV1Contract(paintglyphsAddress);
138         owner = msg.sender;
139         setURI("https://paintglyphsV2.azurewebsites.net/api/HttpTrigger?id=");
140     }
141 
142     ///////////////////
143     //// GENERATOR ////
144     ///////////////////
145 
146     int constant ONE = int(0x100000000);
147     uint constant USIZE = 32;
148     int constant SIZE = int(USIZE);
149     int constant HALF_SIZE = SIZE / int(2);
150     address public owner;
151     string URI;
152 
153     int constant SCALE = int(0x1b81a81ab1a81a823);
154     int constant HALF_SCALE = SCALE / int(2);
155 
156     bytes prefix = "data:text/plain;charset=utf-8,";
157 
158     string internal nftName = "Paintglyphs V2";
159     string internal nftSymbol = "p☵2";
160     address public paintglyphsAddress = 0x2E8b45D550E4bb8c7986EE98879C1740519E0A1A;
161     string public allSymbols = "0 - ░; 1 - ▒; 2 - ■; 3 - ┼; 4 - ▓; 5 - ▄; 6 - ▀; 7 - ≡";
162     
163     paintglyphsV1Contract paintglyphsV1;
164 
165     function abs(int n) internal pure returns (int) {
166         if (n >= 0) return n;
167         return -n;
168     }
169     
170     function getStartColor(uint a) internal pure returns (uint256) {
171         uint256 xxxxff = a % 96;
172         uint256 xxffxx = xxxxff*256;
173         uint256 ffxxxx = xxffxx*256;
174         uint256 randomColor = xxxxff + xxffxx + ffxxxx;
175         return randomColor;
176     }
177 
178     function getBackgroundColor(uint a) internal pure returns (uint256) {
179         uint256 xxxxff = (a % 128) + 128;
180         uint256 xxffxx = xxxxff*256;
181         uint256 ffxxxx = xxffxx*256;
182         uint256 randomColor = xxxxff + xxffxx + ffxxxx;
183         return randomColor;
184     }
185     
186     function getScheme(uint a) internal pure returns (uint8) {
187         uint index = a % 100;
188         uint8 scheme;
189         if (index < 22) {
190             scheme = 1;
191         } else if (index < 41) {
192             scheme = 2;
193         } else if (index < 58) {
194             scheme = 3;
195         } else if (index < 72) {
196             scheme = 4;
197         } else if (index < 84) {
198             scheme = 5;
199         } else if (index < 93) {
200             scheme = 6;
201         }else {
202             scheme = 7;
203         }
204         return scheme;
205     }
206 
207     /* * ** *** ***** ******** ************* ******** ***** *** ** * */
208 
209     // The following code generates art.
210 
211     function draw(uint id) public view returns (string memory) {
212         uint a = uint((keccak256(abi.encodePacked(idToSeed[id]))));
213         bytes memory output = new bytes(USIZE * (USIZE + 3) + 30);
214         uint c;
215         for (c = 0; c < 30; c++) {
216             output[c] = prefix[c];
217         }
218         int x = 0;
219         int y = 0;
220         uint v = 0;
221         uint value = 0;
222         uint mod = (a % 11) + 10;
223         bytes10 symbols;
224         if (idToSymbolScheme[id] == 0) {
225             revert();
226         } else if (idToSymbolScheme[id] == 1) {
227             symbols = 0x3030302E2E2E2E2E2E2E; // ░
228         } else if (idToSymbolScheme[id] == 2) { 
229             symbols = 0x303130312E2E2E2E2E2E; // ░▒
230         } else if (idToSymbolScheme[id] == 3) {
231             symbols = 0x323332332E2E2E2E2E2E; // ■┼
232         } else if (idToSymbolScheme[id] == 4) {
233             symbols = 0x303134302E2E2E2E2E2E; // ░▒▓
234         } else if (idToSymbolScheme[id] == 5) {
235             symbols = 0x3035362E2E2E2E2E2E2E; // ░▄▀
236         } else if (idToSymbolScheme[id] == 6) {
237             symbols = 0x313731332E2E2E2E2E2E; // ▒┼≡
238         } else {
239             symbols = 0x30313233342E2E2E2E2E; // ░▒■┼▓
240         }
241         for (int i = int(0); i < SIZE; i++) {
242             y = (2 * (i - HALF_SIZE) + 1);
243             if (a % 3 == 1) {
244                 y = -y;
245             } else if (a % 3 == 2) {
246                 y = abs(y);
247             }
248             y = y * int(a);
249             for (int j = int(0); j < SIZE; j++) {
250                 x = (2 * (j - HALF_SIZE) + 1);
251                 if (a % 2 == 1) {
252                     x = abs(x);
253                 }
254                 x = x * int(a);
255                 v = uint(x * y / ONE) % mod;
256                 if (v < 10) {
257                     value = uint(uint8(symbols[v]));
258                 } else {
259                     value = 0x2E;
260                 }
261                 output[c] = byte(bytes32(value << 248));
262                 c++;
263             }
264             output[c] = byte(0x25);
265             c++;
266             output[c] = byte(0x30);
267             c++;
268             output[c] = byte(0x41);
269             c++;
270         }
271         string memory result = string(output);
272         return result;
273     }
274 
275     /* * ** *** ***** ******** ************* ******** ***** *** ** * */
276     
277     function creator(uint _id) external view returns (address) {
278         return idToCreator[_id];
279     }
280 
281     function symbolScheme(uint _id) external view returns (uint8) {
282         return idToSymbolScheme[_id];
283     }
284 
285     function backgroundScheme(uint _id) external view returns (uint256) {
286         return idToBackgroundColor[_id];
287     }
288 
289     function colorScheme(uint _id) external view returns (uint256 color0, uint256 color1, uint color2, uint color3, uint color4, uint color5, uint color6, uint color7) {
290         color0 = idToColorScheme[_id][0];
291         color1 = idToColorScheme[_id][1];
292         color2 = idToColorScheme[_id][2];
293         color3 = idToColorScheme[_id][3];
294         color4 = idToColorScheme[_id][4];
295         color5 = idToColorScheme[_id][5];
296         color6 = idToColorScheme[_id][6];
297         color7 = idToColorScheme[_id][7];
298     }
299     
300     function updateProcessingCode(string memory newProcessingCode, uint256 version) public {
301         processingCode[version] = newProcessingCode;
302     }
303     
304     function showProcessingCode(uint version) external view returns (string memory) {
305         return processingCode[version];
306     }
307 
308     //////////////////////////
309     //// ERC 721 and 165  ////
310     //////////////////////////
311 
312     /**
313      * @dev Returns whether the target address is a contract.
314      * @param _addr Address to check.
315      */
316     function isContract(address _addr) internal view returns (bool addressCheck) {
317         uint256 size;
318         assembly { size := extcodesize(_addr) } // solhint-disable-line
319         addressCheck = size > 0;
320     }
321 
322     /**
323      * @dev Function to check which interfaces are suported by this contract.
324      * @param _interfaceID Id of the interface.
325      * @return True if _interfaceID is supported, false otherwise.
326      */
327     function supportsInterface(bytes4 _interfaceID) external view returns (bool) {
328         return supportedInterfaces[_interfaceID];
329     }
330 
331     /**
332      * @dev Transfers the ownership of an NFT from one address to another address. This function can
333      * be changed to payable.
334      * @notice Throws unless `msg.sender` is the current owner, an authorized operator, or the
335      * approved address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is
336      * the zero address. Throws if `_tokenId` is not a valid NFT. When transfer is complete, this
337      * function checks if `_to` is a smart contract (code size > 0). If so, it calls
338      * `onERC721Received` on `_to` and throws if the return value is not
339      * `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`.
340      * @param _from The current owner of the NFT.
341      * @param _to The new owner.
342      * @param _tokenId The NFT to transfer.
343      * @param _data Additional data with no specified format, sent in call to `_to`.
344      */
345     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes calldata _data) external {
346         _safeTransferFrom(_from, _to, _tokenId, _data);
347     }
348 
349     /**
350      * @dev Transfers the ownership of an NFT from one address to another address. This function can
351      * be changed to payable.
352      * @notice This works identically to the other function with an extra data parameter, except this
353      * function just sets data to ""
354      * @param _from The current owner of the NFT.
355      * @param _to The new owner.
356      * @param _tokenId The NFT to transfer.
357      */
358     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external {
359         _safeTransferFrom(_from, _to, _tokenId, "");
360     }
361 
362     /**
363      * @dev Throws unless `msg.sender` is the current owner, an authorized operator, or the approved
364      * address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is the zero
365      * address. Throws if `_tokenId` is not a valid NFT. This function can be changed to payable.
366      * @notice The caller is responsible to confirm that `_to` is capable of receiving NFTs or else
367      * they maybe be permanently lost.
368      * @param _from The current owner of the NFT.
369      * @param _to The new owner.
370      * @param _tokenId The NFT to transfer.
371      */
372     function transferFrom(address _from, address _to, uint256 _tokenId) external canTransfer(_tokenId) validNFToken(_tokenId) {
373         address tokenOwner = idToOwner[_tokenId];
374         require(tokenOwner == _from);
375         require(_to != address(0));
376         _transfer(_to, _tokenId);
377     }
378 
379     /**
380      * @dev Set or reaffirm the approved address for an NFT. This function can be changed to payable.
381      * @notice The zero address indicates there is no approved address. Throws unless `msg.sender` is
382      * the current NFT owner, or an authorized operator of the current owner.
383      * @param _approved Address to be approved for the given NFT ID.
384      * @param _tokenId ID of the token to be approved.
385      */
386     function approve(address _approved, uint256 _tokenId) external canOperate(_tokenId) validNFToken(_tokenId) {
387         address tokenOwner = idToOwner[_tokenId];
388         require(_approved != tokenOwner);
389         idToApproval[_tokenId] = _approved;
390         emit Approval(tokenOwner, _approved, _tokenId);
391     }
392 
393     /**
394      * @dev Enables or disables approval for a third party ("operator") to manage all of
395      * `msg.sender`'s assets. It also emits the ApprovalForAll event.
396      * @notice This works even if sender doesn't own any tokens at the time.
397      * @param _operator Address to add to the set of authorized operators.
398      * @param _approved True if the operators is approved, false to revoke approval.
399      */
400     function setApprovalForAll(address _operator, bool _approved) external {
401         ownerToOperators[msg.sender][_operator] = _approved;
402         emit ApprovalForAll(msg.sender, _operator, _approved);
403     }
404 
405     /**
406      * @dev Returns the number of NFTs owned by `_owner`. NFTs assigned to the zero address are
407      * considered invalid, and this function throws for queries about the zero address.
408      * @param _owner Address for whom to query the balance.
409      * @return Balance of _owner.
410      */
411     function balanceOf(address _owner) external view returns (uint256) {
412         require(_owner != address(0));
413         return _getOwnerNFTCount(_owner);
414     }
415 
416     /**
417      * @dev Returns the address of the owner of the NFT. NFTs assigned to zero address are considered
418      * invalid, and queries about them do throw.
419      */
420     function ownerOf(uint256 _tokenId) public view returns (address _owner) {
421         _owner = idToOwner[_tokenId];
422         require(_owner != address(0));
423     }
424 
425     /**
426      * @dev Get the approved address for a single NFT.
427      * @notice Throws if `_tokenId` is not a valid NFT.
428      * @param _tokenId ID of the NFT to query the approval of.
429      * @return Address that _tokenId is approved for.
430      */
431     function getApproved(uint256 _tokenId) external view validNFToken(_tokenId) returns (address) {
432         return idToApproval[_tokenId];
433     }
434 
435     /**
436      * @dev Checks if `_operator` is an approved operator for `_owner`.
437      * @param _owner The address that owns the NFTs.
438      * @param _operator The address that acts on behalf of the owner.
439      * @return True if approved for all, false otherwise.
440      */
441     function isApprovedForAll(address _owner, address _operator) external view returns (bool) {
442         return ownerToOperators[_owner][_operator];
443     }
444 
445     /**
446      * @dev Actually preforms the transfer.
447      * @notice Does NO checks.
448      * @param _to Address of a new owner.
449      * @param _tokenId The NFT that is being transferred.
450      */
451     function _transfer(address _to, uint256 _tokenId) internal {
452         address from = idToOwner[_tokenId];
453         _clearApproval(_tokenId);
454 
455         _removeNFToken(from, _tokenId);
456         _addNFToken(_to, _tokenId);
457 
458         emit Transfer(from, _to, _tokenId);
459 }
460 
461 
462     function createPiece(uint seed) external payable {
463         return _mint(msg.sender, seed);
464     }
465 
466 
467     /**
468      * @dev Mints a new NFT.
469      * @notice This is an internal function which should be called from user-implemented external
470      * mint function. Its purpose is to show and properly initialize data structures when using this
471      * implementation.
472      * @param _to The address that will own the minted NFT.
473      */
474     function _mint(address _to, uint seed) internal {
475         require(_to != address(0));
476         require(numTokens < TOKEN_LIMIT);
477         uint amount = 0;
478         if (numTokens >= ARTIST_PRINTS) {
479             amount = PRICE;
480             require(msg.value >= amount);
481         }
482         require(seedToId[seed] == 0);
483         uint id = numTokens + 1;
484 
485         idToCreator[id] = _to;
486         idToSeed[id] = seed;
487         seedToId[seed] = id;
488         uint a = uint((keccak256(abi.encodePacked(seed,id))));
489         idToBackgroundColor[id] = getBackgroundColor(a);
490         idToSymbolScheme[id] = getScheme(a);
491         uint randomColor;
492         
493         for (uint i = 0; i<8; i = i+1) {
494             randomColor = getStartColor(uint(keccak256(abi.encodePacked(a,id,i))));
495             idToColorScheme[id][i] = randomColor;
496         }
497 
498         numTokens = numTokens + 1;
499         _addNFToken(_to, id);
500 
501         if (msg.value > amount) {
502             msg.sender.transfer(msg.value - amount);
503         }
504         if (amount > 0) {
505             BENEFICIARY.transfer(address(this).balance);
506         }
507 
508         emit Transfer(address(0), _to, id);
509         
510         feelingLuckyColor(id);
511     }
512 
513     function createWithV1(uint seed, uint v1GlyphID) external {
514         require(v1GlyphID < 103);
515         require(address(uint160(paintglyphsV1.ownerOf(v1GlyphID))) == msg.sender);
516         
517         paintglyphsV1.transferFrom(msg.sender,address(this),v1GlyphID);
518         
519         return _mintWithV1(msg.sender, seed, v1GlyphID);
520     }
521     
522     function _mintWithV1(address _to, uint seed, uint v1GlyphID) internal {
523         require(_to != address(0));
524         require(numTokens <= TOKEN_LIMIT);
525         
526         require(seedToId[seed] == 0);
527 
528         uint id = v1GlyphID;
529         
530         idToCreator[id] = _to;
531         idToSeed[id] = seed;
532         seedToId[seed] = id;
533         uint a = uint((keccak256(abi.encodePacked(seed,id))));
534         idToBackgroundColor[id] = getBackgroundColor(a);
535         idToSymbolScheme[id] = getScheme(a);
536         uint randomColor;
537         
538         for (uint i = 0; i<8; i = i+1) {
539             randomColor = getStartColor(uint(keccak256(abi.encodePacked(a,id,i))));
540             idToColorScheme[id][i] = randomColor;
541         }
542 
543         _addNFToken(_to, id);
544 
545         emit Transfer(address(0), _to, id);
546         
547         feelingLuckyColor(id);
548     }
549     
550     function updateColor(uint id, uint symbolToUpdate, uint newColor) public {
551         require(msg.sender == ownerOf(id));
552         require(newColor < 16777216);
553         require(checkValidSymbol(id,symbolToUpdate) == true);
554         
555         idToColorScheme[id][symbolToUpdate] = newColor;
556         emit ColorChanged(id, symbolToUpdate, newColor);
557     }
558     
559     function feelingLuckyColor(uint id) public {
560         require(msg.sender == ownerOf(id));
561         
562         uint256 symbolToUpdate;
563         uint256 seed = uint(keccak256(abi.encodePacked(id,block.number)));
564         
565         if (idToSymbolScheme[id] == 1) { //if scheme 1, then update symbol 0
566             symbolToUpdate == 0;
567             }
568         else if (idToSymbolScheme[id] == 2) { //if scheme 2, then update symbol 0 or 1
569             symbolToUpdate = seed % 2;
570         }
571         else if (idToSymbolScheme[id] == 3) { //if scheme 3, then update symbol 2 or 3
572             symbolToUpdate = (seed % 2) + 2;
573         }
574         else if (idToSymbolScheme[id] == 4) { //if scheme 4, then update symbol 0, 1, or 4
575             symbolToUpdate = (seed % 3);
576             if (symbolToUpdate == 2) {
577                 symbolToUpdate = 4;
578             }
579         }
580         else if (idToSymbolScheme[id] == 5) { //if scheme 5, then update symbol 0, 5, or 6
581             symbolToUpdate = (seed % 3);
582             if (symbolToUpdate == 1) {
583                 symbolToUpdate = 5;
584             }
585             else if (symbolToUpdate == 2) {
586                 symbolToUpdate = 6;
587             }
588         }
589         else if (idToSymbolScheme[id] == 6) { //if scheme 6, then update symbol 1, 3, or 7
590             symbolToUpdate = (seed % 3);
591             if (symbolToUpdate == 0) {
592                 symbolToUpdate = 3;
593             }
594             else if (symbolToUpdate == 2) {
595                 symbolToUpdate = 7;
596             }
597         }
598         else {
599             symbolToUpdate = seed % 5; // if scheme 7, then update symbol 0, 1, 2, 3, or 4
600         }        
601         
602         uint256 newColor = seed % 16777216;
603         
604         idToColorScheme[id][symbolToUpdate] = newColor;
605         emit ColorChanged(id, symbolToUpdate, newColor);
606     }
607     
608     function checkValidSymbol(uint id, uint symbolToCheck) public view returns (bool isValid){
609         if (idToSymbolScheme[id] == 1) {
610             if (symbolToCheck == 0) {
611                 isValid = true;
612             }
613         }
614         else if (idToSymbolScheme[id] == 2) {
615             if (symbolToCheck == 0 || symbolToCheck == 1) {
616                 isValid = true;
617             }
618         }
619         else if (idToSymbolScheme[id] == 3) {
620             if (symbolToCheck == 2 || symbolToCheck == 3) {
621                 isValid = true;
622             }
623         }
624         else if (idToSymbolScheme[id] == 4) {
625             if (symbolToCheck == 0 || symbolToCheck == 1 || symbolToCheck == 4) {
626                 isValid = true;
627             }
628         }
629         else if (idToSymbolScheme[id] == 5) {
630             if (symbolToCheck == 0 || symbolToCheck == 5 || symbolToCheck == 6) {
631                 isValid = true;
632             }
633         }
634         else if (idToSymbolScheme[id] == 6) {
635             if (symbolToCheck == 1 || symbolToCheck == 3 || symbolToCheck == 7) {
636                 isValid = true;
637             }
638         } 
639         else {
640             if (symbolToCheck == 0 || symbolToCheck == 1 || symbolToCheck == 2 || symbolToCheck == 3 || symbolToCheck == 4) {
641                 isValid = true;
642             }
643         } 
644     }
645 
646     /**
647      * @dev Assigns a new NFT to an address.
648      * @notice Use and override this function with caution. Wrong usage can have serious consequences.
649      * @param _to Address to which we want to add the NFT.
650      * @param _tokenId Which NFT we want to add.
651      */
652     function _addNFToken(address _to, uint256 _tokenId) internal {
653         require(idToOwner[_tokenId] == address(0));
654         idToOwner[_tokenId] = _to;
655 
656         uint256 length = ownerToIds[_to].push(_tokenId);
657         idToOwnerIndex[_tokenId] = length - 1;
658     }
659 
660     /**
661      * @dev Removes a NFT from an address.
662      * @notice Use and override this function with caution. Wrong usage can have serious consequences.
663      * @param _from Address from wich we want to remove the NFT.
664      * @param _tokenId Which NFT we want to remove.
665      */
666     function _removeNFToken(address _from, uint256 _tokenId) internal {
667         require(idToOwner[_tokenId] == _from);
668         delete idToOwner[_tokenId];
669 
670         uint256 tokenToRemoveIndex = idToOwnerIndex[_tokenId];
671         uint256 lastTokenIndex = ownerToIds[_from].length - 1;
672 
673         if (lastTokenIndex != tokenToRemoveIndex) {
674             uint256 lastToken = ownerToIds[_from][lastTokenIndex];
675             ownerToIds[_from][tokenToRemoveIndex] = lastToken;
676             idToOwnerIndex[lastToken] = tokenToRemoveIndex;
677         }
678 
679         ownerToIds[_from].length--;
680     }
681 
682     /**
683      * @dev Helper function that gets NFT count of owner. This is needed for overriding in enumerable
684      * extension to remove double storage (gas optimization) of owner nft count.
685      * @param _owner Address for whom to query the count.
686      * @return Number of _owner NFTs.
687      */
688     function _getOwnerNFTCount(address _owner) internal view returns (uint256) {
689         return ownerToIds[_owner].length;
690     }
691 
692     /**
693      * @dev Actually perform the safeTransferFrom.
694      * @param _from The current owner of the NFT.
695      * @param _to The new owner.
696      * @param _tokenId The NFT to transfer.
697      * @param _data Additional data with no specified format, sent in call to `_to`.
698      */
699     function _safeTransferFrom(address _from,  address _to,  uint256 _tokenId,  bytes memory _data) private canTransfer(_tokenId) validNFToken(_tokenId) {
700         address tokenOwner = idToOwner[_tokenId];
701         require(tokenOwner == _from);
702         require(_to != address(0));
703 
704         _transfer(_to, _tokenId);
705 
706         if (isContract(_to)) {
707             bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
708             require(retval == MAGIC_ON_ERC721_RECEIVED);
709         }
710     }
711 
712     /**
713      * @dev Clears the current approval of a given NFT ID.
714      * @param _tokenId ID of the NFT to be transferred.
715      */
716     function _clearApproval(uint256 _tokenId) private {
717         if (idToApproval[_tokenId] != address(0)) {
718             delete idToApproval[_tokenId];
719         }
720     }
721 
722     //// Enumerable
723 
724     function totalSupply() public view returns (uint256) {
725         return numTokens;
726     }
727 
728     function tokenByIndex(uint256 index) public view returns (uint256) {
729         require(index < numTokens);
730         return index;
731     }
732 
733     /**
734      * @dev returns the n-th NFT ID from a list of owner's tokens.
735      * @param _owner Token owner's address.
736      * @param _index Index number representing n-th token in owner's list of tokens.
737      * @return Token id.
738      */
739     function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256) {
740         require(_index < ownerToIds[_owner].length);
741         return ownerToIds[_owner][_index];
742     }
743 
744     //// Metadata
745 
746     /**
747       * @dev Returns a descriptive name for a collection of NFTokens.
748       */
749     function name() external view returns (string memory _name) {
750         _name = nftName;
751     }
752 
753     /**
754      * @dev Returns an abbreviated name for NFTokens.
755      */
756     function symbol() external view returns (string memory _symbol) {
757         _symbol = nftSymbol;
758     }
759 
760     /**
761      * @dev A distinct URI (RFC 3986) for a given NFT.
762      */
763     function tokenURI(uint256 id) external view returns (string memory) {
764         return string(abi.encodePacked(URI, integerToString(uint256(id))));
765     }
766     
767     function setURI(string memory newURI) public isOwner {
768         URI = newURI;
769     }
770 
771     function integerToString(uint _i) internal pure returns (string memory) {
772       if (_i == 0) {
773          return "0";
774       }
775       uint j = _i;
776       uint len;
777       
778       while (j != 0) {
779          len++;
780          j /= 10;
781       }
782       bytes memory bstr = new bytes(len);
783       uint k = len - 1;
784       
785       while (_i != 0) {
786          bstr[k--] = byte(uint8(48 + _i % 10));
787          _i /= 10;
788       }
789       return string(bstr);
790    }
791 
792 }