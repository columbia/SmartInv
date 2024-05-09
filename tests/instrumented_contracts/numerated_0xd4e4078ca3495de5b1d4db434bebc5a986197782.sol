1 pragma solidity ^0.4.24;
2 
3 /**
4  *
5  *      ***    **     ** ********  *******   ******   **     **    ** ********  **     **  ******
6  *     ** **   **     **    **    **     ** **    **  **      **  **  **     ** **     ** **    **
7  *    **   **  **     **    **    **     ** **        **       ****   **     ** **     ** **
8  *   **     ** **     **    **    **     ** **   **** **        **    ********  *********  ******
9  *   ********* **     **    **    **     ** **    **  **        **    **        **     **       **
10  *   **     ** **     **    **    **     ** **    **  **        **    **        **     ** **    **
11  *   **     **  *******     **     *******   ******   ********  **    **        **     **  ******
12  *
13  *
14  *                                                                by Matt Hall and John Watkinson
15  *
16  *
17  * The output of the 'tokenURI' function is a set of instructions to make a drawing.
18  * Each symbol in the output corresponds to a cell, and there are 64x64 cells arranged in a square grid.
19  * The drawing can be any size, and the pen's stroke width should be between 1/5th to 1/10th the size of a cell.
20  * The drawing instructions for the nine different symbols are as follows:
21  *
22  *   .  Draw nothing in the cell.
23  *   O  Draw a circle bounded by the cell.
24  *   +  Draw centered lines vertically and horizontally the length of the cell.
25  *   X  Draw diagonal lines connecting opposite corners of the cell.
26  *   |  Draw a centered vertical line the length of the cell.
27  *   -  Draw a centered horizontal line the length of the cell.
28  *   \  Draw a line connecting the top left corner of the cell to the bottom right corner.
29  *   /  Draw a line connecting the bottom left corner of teh cell to the top right corner.
30  *   #  Fill in the cell completely.
31  *
32  */
33 interface ERC721TokenReceiver
34 {
35 
36     function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes _data) external returns(bytes4);
37 
38 }
39 
40 contract Autoglyphs {
41 
42     event Generated(uint indexed index, address indexed a, string value);
43 
44     /// @dev This emits when ownership of any NFT changes by any mechanism.
45     ///  This event emits when NFTs are created (`from` == 0) and destroyed
46     ///  (`to` == 0). Exception: during contract creation, any number of NFTs
47     ///  may be created and assigned without emitting Transfer. At the time of
48     ///  any transfer, the approved address for that NFT (if any) is reset to none.
49     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
50 
51     /// @dev This emits when the approved address for an NFT is changed or
52     ///  reaffirmed. The zero address indicates there is no approved address.
53     ///  When a Transfer event emits, this also indicates that the approved
54     ///  address for that NFT (if any) is reset to none.
55     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
56 
57     /// @dev This emits when an operator is enabled or disabled for an owner.
58     ///  The operator can manage all NFTs of the owner.
59     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
60 
61     bytes4 internal constant MAGIC_ON_ERC721_RECEIVED = 0x150b7a02;
62 
63     uint public constant TOKEN_LIMIT = 512; // 8 for testing, 256 or 512 for prod;
64     uint public constant ARTIST_PRINTS = 128; // 2 for testing, 64 for prod;
65 
66     uint public constant PRICE = 200 finney;
67 
68     // The beneficiary is 350.org
69     address public constant BENEFICIARY = 0x50990F09d4f0cb864b8e046e7edC749dE410916b;
70 
71     mapping (uint => address) private idToCreator;
72     mapping (uint => uint8) private idToSymbolScheme;
73 
74     // ERC 165
75     mapping(bytes4 => bool) internal supportedInterfaces;
76 
77     /**
78      * @dev A mapping from NFT ID to the address that owns it.
79      */
80     mapping (uint256 => address) internal idToOwner;
81 
82     /**
83      * @dev A mapping from NFT ID to the seed used to make it.
84      */
85     mapping (uint256 => uint256) internal idToSeed;
86     mapping (uint256 => uint256) internal seedToId;
87 
88     /**
89      * @dev Mapping from NFT ID to approved address.
90      */
91     mapping (uint256 => address) internal idToApproval;
92 
93     /**
94      * @dev Mapping from owner address to mapping of operator addresses.
95      */
96     mapping (address => mapping (address => bool)) internal ownerToOperators;
97 
98     /**
99      * @dev Mapping from owner to list of owned NFT IDs.
100      */
101     mapping(address => uint256[]) internal ownerToIds;
102 
103     /**
104      * @dev Mapping from NFT ID to its index in the owner tokens list.
105      */
106     mapping(uint256 => uint256) internal idToOwnerIndex;
107 
108     /**
109      * @dev Total number of tokens.
110      */
111     uint internal numTokens = 0;
112 
113     /**
114      * @dev Guarantees that the msg.sender is an owner or operator of the given NFT.
115      * @param _tokenId ID of the NFT to validate.
116      */
117     modifier canOperate(uint256 _tokenId) {
118         address tokenOwner = idToOwner[_tokenId];
119         require(tokenOwner == msg.sender || ownerToOperators[tokenOwner][msg.sender]);
120         _;
121     }
122 
123     /**
124      * @dev Guarantees that the msg.sender is allowed to transfer NFT.
125      * @param _tokenId ID of the NFT to transfer.
126      */
127     modifier canTransfer(uint256 _tokenId) {
128         address tokenOwner = idToOwner[_tokenId];
129         require(
130             tokenOwner == msg.sender
131             || idToApproval[_tokenId] == msg.sender
132             || ownerToOperators[tokenOwner][msg.sender]
133         );
134         _;
135     }
136 
137     /**
138      * @dev Guarantees that _tokenId is a valid Token.
139      * @param _tokenId ID of the NFT to validate.
140      */
141     modifier validNFToken(uint256 _tokenId) {
142         require(idToOwner[_tokenId] != address(0));
143         _;
144     }
145 
146     /**
147      * @dev Contract constructor.
148      */
149     constructor() public {
150         supportedInterfaces[0x01ffc9a7] = true; // ERC165
151         supportedInterfaces[0x80ac58cd] = true; // ERC721
152         supportedInterfaces[0x780e9d63] = true; // ERC721 Enumerable
153         supportedInterfaces[0x5b5e139f] = true; // ERC721 Metadata
154     }
155 
156     ///////////////////
157     //// GENERATOR ////
158     ///////////////////
159 
160     int constant ONE = int(0x100000000);
161     uint constant USIZE = 64;
162     int constant SIZE = int(USIZE);
163     int constant HALF_SIZE = SIZE / int(2);
164 
165     int constant SCALE = int(0x1b81a81ab1a81a823);
166     int constant HALF_SCALE = SCALE / int(2);
167 
168     bytes prefix = "data:text/plain;charset=utf-8,";
169 
170     string internal nftName = "Autoglyphs";
171     string internal nftSymbol = "☵";
172 
173     // 0x2E = .
174     // 0x4F = O
175     // 0x2B = +
176     // 0x58 = X
177     // 0x7C = |
178     // 0x2D = -
179     // 0x5C = \
180     // 0x2F = /
181     // 0x23 = #
182 
183     function abs(int n) internal pure returns (int) {
184         if (n >= 0) return n;
185         return -n;
186     }
187 
188     function getScheme(uint a) internal pure returns (uint8) {
189         uint index = a % 83;
190         uint8 scheme;
191         if (index < 20) {
192             scheme = 1;
193         } else if (index < 35) {
194             scheme = 2;
195         } else if (index < 48) {
196             scheme = 3;
197         } else if (index < 59) {
198             scheme = 4;
199         } else if (index < 68) {
200             scheme = 5;
201         } else if (index < 73) {
202             scheme = 6;
203         } else if (index < 77) {
204             scheme = 7;
205         } else if (index < 80) {
206             scheme = 8;
207         } else if (index < 82) {
208             scheme = 9;
209         } else {
210             scheme = 10;
211         }
212         return scheme;
213     }
214 
215     /* * ** *** ***** ******** ************* ******** ***** *** ** * */
216 
217     // The following code generates art.
218 
219     function draw(uint id) public view returns (string) {
220         uint a = uint(uint160(keccak256(abi.encodePacked(idToSeed[id]))));
221         bytes memory output = new bytes(USIZE * (USIZE + 3) + 30);
222         uint c;
223         for (c = 0; c < 30; c++) {
224             output[c] = prefix[c];
225         }
226         int x = 0;
227         int y = 0;
228         uint v = 0;
229         uint value = 0;
230         uint mod = (a % 11) + 5;
231         bytes5 symbols;
232         if (idToSymbolScheme[id] == 0) {
233             revert();
234         } else if (idToSymbolScheme[id] == 1) {
235             symbols = 0x2E582F5C2E; // X/\
236         } else if (idToSymbolScheme[id] == 2) {
237             symbols = 0x2E2B2D7C2E; // +-|
238         } else if (idToSymbolScheme[id] == 3) {
239             symbols = 0x2E2F5C2E2E; // /\
240         } else if (idToSymbolScheme[id] == 4) {
241             symbols = 0x2E5C7C2D2F; // \|-/
242         } else if (idToSymbolScheme[id] == 5) {
243             symbols = 0x2E4F7C2D2E; // O|-
244         } else if (idToSymbolScheme[id] == 6) {
245             symbols = 0x2E5C5C2E2E; // \
246         } else if (idToSymbolScheme[id] == 7) {
247             symbols = 0x2E237C2D2B; // #|-+
248         } else if (idToSymbolScheme[id] == 8) {
249             symbols = 0x2E4F4F2E2E; // OO
250         } else if (idToSymbolScheme[id] == 9) {
251             symbols = 0x2E232E2E2E; // #
252         } else {
253             symbols = 0x2E234F2E2E; // #O
254         }
255         for (int i = int(0); i < SIZE; i++) {
256             y = (2 * (i - HALF_SIZE) + 1);
257             if (a % 3 == 1) {
258                 y = -y;
259             } else if (a % 3 == 2) {
260                 y = abs(y);
261             }
262             y = y * int(a);
263             for (int j = int(0); j < SIZE; j++) {
264                 x = (2 * (j - HALF_SIZE) + 1);
265                 if (a % 2 == 1) {
266                     x = abs(x);
267                 }
268                 x = x * int(a);
269                 v = uint(x * y / ONE) % mod;
270                 if (v < 5) {
271                     value = uint(symbols[v]);
272                 } else {
273                     value = 0x2E;
274                 }
275                 output[c] = byte(bytes32(value << 248));
276                 c++;
277             }
278             output[c] = byte(0x25);
279             c++;
280             output[c] = byte(0x30);
281             c++;
282             output[c] = byte(0x41);
283             c++;
284         }
285         string memory result = string(output);
286         return result;
287     }
288 
289     /* * ** *** ***** ******** ************* ******** ***** *** ** * */
290 
291     function creator(uint _id) external view returns (address) {
292         return idToCreator[_id];
293     }
294 
295     function symbolScheme(uint _id) external view returns (uint8) {
296         return idToSymbolScheme[_id];
297     }
298 
299     function createGlyph(uint seed) external payable returns (string) {
300         return _mint(msg.sender, seed);
301     }
302 
303     //////////////////////////
304     //// ERC 721 and 165  ////
305     //////////////////////////
306 
307     /**
308      * @dev Returns whether the target address is a contract.
309      * @param _addr Address to check.
310      * @return True if _addr is a contract, false if not.
311      */
312     function isContract(address _addr) internal view returns (bool addressCheck) {
313         uint256 size;
314         assembly { size := extcodesize(_addr) } // solhint-disable-line
315         addressCheck = size > 0;
316     }
317 
318     /**
319      * @dev Function to check which interfaces are suported by this contract.
320      * @param _interfaceID Id of the interface.
321      * @return True if _interfaceID is supported, false otherwise.
322      */
323     function supportsInterface(bytes4 _interfaceID) external view returns (bool) {
324         return supportedInterfaces[_interfaceID];
325     }
326 
327     /**
328      * @dev Transfers the ownership of an NFT from one address to another address. This function can
329      * be changed to payable.
330      * @notice Throws unless `msg.sender` is the current owner, an authorized operator, or the
331      * approved address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is
332      * the zero address. Throws if `_tokenId` is not a valid NFT. When transfer is complete, this
333      * function checks if `_to` is a smart contract (code size > 0). If so, it calls
334      * `onERC721Received` on `_to` and throws if the return value is not
335      * `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`.
336      * @param _from The current owner of the NFT.
337      * @param _to The new owner.
338      * @param _tokenId The NFT to transfer.
339      * @param _data Additional data with no specified format, sent in call to `_to`.
340      */
341     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) external {
342         _safeTransferFrom(_from, _to, _tokenId, _data);
343     }
344 
345     /**
346      * @dev Transfers the ownership of an NFT from one address to another address. This function can
347      * be changed to payable.
348      * @notice This works identically to the other function with an extra data parameter, except this
349      * function just sets data to ""
350      * @param _from The current owner of the NFT.
351      * @param _to The new owner.
352      * @param _tokenId The NFT to transfer.
353      */
354     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external {
355         _safeTransferFrom(_from, _to, _tokenId, "");
356     }
357 
358     /**
359      * @dev Throws unless `msg.sender` is the current owner, an authorized operator, or the approved
360      * address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is the zero
361      * address. Throws if `_tokenId` is not a valid NFT. This function can be changed to payable.
362      * @notice The caller is responsible to confirm that `_to` is capable of receiving NFTs or else
363      * they maybe be permanently lost.
364      * @param _from The current owner of the NFT.
365      * @param _to The new owner.
366      * @param _tokenId The NFT to transfer.
367      */
368     function transferFrom(address _from, address _to, uint256 _tokenId) external canTransfer(_tokenId) validNFToken(_tokenId) {
369         address tokenOwner = idToOwner[_tokenId];
370         require(tokenOwner == _from);
371         require(_to != address(0));
372         _transfer(_to, _tokenId);
373     }
374 
375     /**
376      * @dev Set or reaffirm the approved address for an NFT. This function can be changed to payable.
377      * @notice The zero address indicates there is no approved address. Throws unless `msg.sender` is
378      * the current NFT owner, or an authorized operator of the current owner.
379      * @param _approved Address to be approved for the given NFT ID.
380      * @param _tokenId ID of the token to be approved.
381      */
382     function approve(address _approved, uint256 _tokenId) external canOperate(_tokenId) validNFToken(_tokenId) {
383         address tokenOwner = idToOwner[_tokenId];
384         require(_approved != tokenOwner);
385         idToApproval[_tokenId] = _approved;
386         emit Approval(tokenOwner, _approved, _tokenId);
387     }
388 
389     /**
390      * @dev Enables or disables approval for a third party ("operator") to manage all of
391      * `msg.sender`'s assets. It also emits the ApprovalForAll event.
392      * @notice This works even if sender doesn't own any tokens at the time.
393      * @param _operator Address to add to the set of authorized operators.
394      * @param _approved True if the operators is approved, false to revoke approval.
395      */
396     function setApprovalForAll(address _operator, bool _approved) external {
397         ownerToOperators[msg.sender][_operator] = _approved;
398         emit ApprovalForAll(msg.sender, _operator, _approved);
399     }
400 
401     /**
402      * @dev Returns the number of NFTs owned by `_owner`. NFTs assigned to the zero address are
403      * considered invalid, and this function throws for queries about the zero address.
404      * @param _owner Address for whom to query the balance.
405      * @return Balance of _owner.
406      */
407     function balanceOf(address _owner) external view returns (uint256) {
408         require(_owner != address(0));
409         return _getOwnerNFTCount(_owner);
410     }
411 
412     /**
413      * @dev Returns the address of the owner of the NFT. NFTs assigned to zero address are considered
414      * invalid, and queries about them do throw.
415      * @param _tokenId The identifier for an NFT.
416      * @return Address of _tokenId owner.
417      */
418     function ownerOf(uint256 _tokenId) external view returns (address _owner) {
419         _owner = idToOwner[_tokenId];
420         require(_owner != address(0));
421     }
422 
423     /**
424      * @dev Get the approved address for a single NFT.
425      * @notice Throws if `_tokenId` is not a valid NFT.
426      * @param _tokenId ID of the NFT to query the approval of.
427      * @return Address that _tokenId is approved for.
428      */
429     function getApproved(uint256 _tokenId) external view validNFToken(_tokenId) returns (address) {
430         return idToApproval[_tokenId];
431     }
432 
433     /**
434      * @dev Checks if `_operator` is an approved operator for `_owner`.
435      * @param _owner The address that owns the NFTs.
436      * @param _operator The address that acts on behalf of the owner.
437      * @return True if approved for all, false otherwise.
438      */
439     function isApprovedForAll(address _owner, address _operator) external view returns (bool) {
440         return ownerToOperators[_owner][_operator];
441     }
442 
443     /**
444      * @dev Actually preforms the transfer.
445      * @notice Does NO checks.
446      * @param _to Address of a new owner.
447      * @param _tokenId The NFT that is being transferred.
448      */
449     function _transfer(address _to, uint256 _tokenId) internal {
450         address from = idToOwner[_tokenId];
451         _clearApproval(_tokenId);
452 
453         _removeNFToken(from, _tokenId);
454         _addNFToken(_to, _tokenId);
455 
456         emit Transfer(from, _to, _tokenId);
457 }
458 
459     /**
460      * @dev Mints a new NFT.
461      * @notice This is an internal function which should be called from user-implemented external
462      * mint function. Its purpose is to show and properly initialize data structures when using this
463      * implementation.
464      * @param _to The address that will own the minted NFT.
465      */
466     function _mint(address _to, uint seed) internal returns (string) {
467         require(_to != address(0));
468         require(numTokens < TOKEN_LIMIT);
469         uint amount = 0;
470         if (numTokens >= ARTIST_PRINTS) {
471             amount = PRICE;
472             require(msg.value >= amount);
473         }
474         require(seedToId[seed] == 0);
475         uint id = numTokens + 1;
476 
477         idToCreator[id] = _to;
478         idToSeed[id] = seed;
479         seedToId[seed] = id;
480         uint a = uint(uint160(keccak256(abi.encodePacked(seed))));
481         idToSymbolScheme[id] = getScheme(a);
482         string memory uri = draw(id);
483         emit Generated(id, _to, uri);
484 
485         numTokens = numTokens + 1;
486         _addNFToken(_to, id);
487 
488         if (msg.value > amount) {
489             msg.sender.transfer(msg.value - amount);
490         }
491         if (amount > 0) {
492             BENEFICIARY.transfer(amount);
493         }
494 
495         emit Transfer(address(0), _to, id);
496         return uri;
497     }
498 
499     /**
500      * @dev Assigns a new NFT to an address.
501      * @notice Use and override this function with caution. Wrong usage can have serious consequences.
502      * @param _to Address to which we want to add the NFT.
503      * @param _tokenId Which NFT we want to add.
504      */
505     function _addNFToken(address _to, uint256 _tokenId) internal {
506         require(idToOwner[_tokenId] == address(0));
507         idToOwner[_tokenId] = _to;
508 
509         uint256 length = ownerToIds[_to].push(_tokenId);
510         idToOwnerIndex[_tokenId] = length - 1;
511     }
512 
513     /**
514      * @dev Removes a NFT from an address.
515      * @notice Use and override this function with caution. Wrong usage can have serious consequences.
516      * @param _from Address from wich we want to remove the NFT.
517      * @param _tokenId Which NFT we want to remove.
518      */
519     function _removeNFToken(address _from, uint256 _tokenId) internal {
520         require(idToOwner[_tokenId] == _from);
521         delete idToOwner[_tokenId];
522 
523         uint256 tokenToRemoveIndex = idToOwnerIndex[_tokenId];
524         uint256 lastTokenIndex = ownerToIds[_from].length - 1;
525 
526         if (lastTokenIndex != tokenToRemoveIndex) {
527             uint256 lastToken = ownerToIds[_from][lastTokenIndex];
528             ownerToIds[_from][tokenToRemoveIndex] = lastToken;
529             idToOwnerIndex[lastToken] = tokenToRemoveIndex;
530         }
531 
532         ownerToIds[_from].length--;
533     }
534 
535     /**
536      * @dev Helper function that gets NFT count of owner. This is needed for overriding in enumerable
537      * extension to remove double storage (gas optimization) of owner nft count.
538      * @param _owner Address for whom to query the count.
539      * @return Number of _owner NFTs.
540      */
541     function _getOwnerNFTCount(address _owner) internal view returns (uint256) {
542         return ownerToIds[_owner].length;
543     }
544 
545     /**
546      * @dev Actually perform the safeTransferFrom.
547      * @param _from The current owner of the NFT.
548      * @param _to The new owner.
549      * @param _tokenId The NFT to transfer.
550      * @param _data Additional data with no specified format, sent in call to `_to`.
551      */
552     function _safeTransferFrom(address _from,  address _to,  uint256 _tokenId,  bytes memory _data) private canTransfer(_tokenId) validNFToken(_tokenId) {
553         address tokenOwner = idToOwner[_tokenId];
554         require(tokenOwner == _from);
555         require(_to != address(0));
556 
557         _transfer(_to, _tokenId);
558 
559         if (isContract(_to)) {
560             bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
561             require(retval == MAGIC_ON_ERC721_RECEIVED);
562         }
563     }
564 
565     /**
566      * @dev Clears the current approval of a given NFT ID.
567      * @param _tokenId ID of the NFT to be transferred.
568      */
569     function _clearApproval(uint256 _tokenId) private {
570         if (idToApproval[_tokenId] != address(0)) {
571             delete idToApproval[_tokenId];
572         }
573     }
574 
575     //// Enumerable
576 
577     function totalSupply() public view returns (uint256) {
578         return numTokens;
579     }
580 
581     function tokenByIndex(uint256 index) public view returns (uint256) {
582         require(index < numTokens);
583         return index;
584     }
585 
586     /**
587      * @dev returns the n-th NFT ID from a list of owner's tokens.
588      * @param _owner Token owner's address.
589      * @param _index Index number representing n-th token in owner's list of tokens.
590      * @return Token id.
591      */
592     function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256) {
593         require(_index < ownerToIds[_owner].length);
594         return ownerToIds[_owner][_index];
595     }
596 
597     //// Metadata
598 
599     /**
600       * @dev Returns a descriptive name for a collection of NFTokens.
601       * @return Representing name.
602       */
603     function name() external view returns (string memory _name) {
604         _name = nftName;
605     }
606 
607     /**
608      * @dev Returns an abbreviated name for NFTokens.
609      * @return Representing symbol.
610      */
611     function symbol() external view returns (string memory _symbol) {
612         _symbol = nftSymbol;
613     }
614 
615     /**
616      * @dev A distinct URI (RFC 3986) for a given NFT.
617      * @param _tokenId Id for which we want uri.
618      * @return URI of _tokenId.
619      */
620     function tokenURI(uint256 _tokenId) external view validNFToken(_tokenId) returns (string memory) {
621         return draw(_tokenId);
622     }
623 
624 }