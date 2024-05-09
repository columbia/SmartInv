1 pragma solidity ^0.4.24;
2 
3 /******************************************************************************\
4 *..................................SU SQUARES..................................*
5 *.......................Blockchain rentable advertising........................*
6 *..............................................................................*
7 * First, I just want to say we are so excited and humbled to get this far and  *
8 * that you're even reading this. So thank you!                                 *
9 *                                                                              *
10 * This file is organized into multiple contracts that separate functionality   *
11 * into logical parts. The deployed contract, SuMain, is at the bottom and      *
12 * includes the rest of the file using inheritance.                             *
13 *                                                                              *
14 *  - ERC165, ERC721: These interfaces follow the official EIPs                 *
15 *  - AccessControl: A reusable CEO/CFO/COO access model                        *
16 *  - SupportsInterface: An implementation of ERC165                            *
17 *  - SuNFT: An implementation of ERC721                                        *
18 *  - SuOperation: The actual square data and the personalize function          *
19 *  - SuPromo, SuVending: How we grant or sell squares                          *
20 *..............................................................................*
21 *............................Su & William Entriken.............................*
22 *...................................(c) 2018...................................*
23 \******************************************************************************/
24 
25 /* AccessControl.sol **********************************************************/
26 
27 /// @title Reusable three-role access control inspired by CryptoKitties
28 /// @author William Entriken (https://phor.net)
29 /// @dev Keep the CEO wallet stored offline, I warned you.
30 contract AccessControl {
31     /// @notice The account that can only reassign executive accounts
32     address public executiveOfficerAddress;
33 
34     /// @notice The account that can collect funds from this contract
35     address public financialOfficerAddress;
36 
37     /// @notice The account with administrative control of this contract
38     address public operatingOfficerAddress;
39 
40     constructor() internal {
41         executiveOfficerAddress = msg.sender;
42     }
43 
44     /// @dev Only allowed by executive officer
45     modifier onlyExecutiveOfficer() {
46         require(msg.sender == executiveOfficerAddress);
47         _;
48     }
49 
50     /// @dev Only allowed by financial officer
51     modifier onlyFinancialOfficer() {
52         require(msg.sender == financialOfficerAddress);
53         _;
54     }
55 
56     /// @dev Only allowed by operating officer
57     modifier onlyOperatingOfficer() {
58         require(msg.sender == operatingOfficerAddress);
59         _;
60     }
61 
62     /// @notice Reassign the executive officer role
63     /// @param _executiveOfficerAddress new officer address
64     function setExecutiveOfficer(address _executiveOfficerAddress)
65         external
66         onlyExecutiveOfficer
67     {
68         require(_executiveOfficerAddress != address(0));
69         executiveOfficerAddress = _executiveOfficerAddress;
70     }
71 
72     /// @notice Reassign the financial officer role
73     /// @param _financialOfficerAddress new officer address
74     function setFinancialOfficer(address _financialOfficerAddress)
75         external
76         onlyExecutiveOfficer
77     {
78         require(_financialOfficerAddress != address(0));
79         financialOfficerAddress = _financialOfficerAddress;
80     }
81 
82     /// @notice Reassign the operating officer role
83     /// @param _operatingOfficerAddress new officer address
84     function setOperatingOfficer(address _operatingOfficerAddress)
85         external
86         onlyExecutiveOfficer
87     {
88         require(_operatingOfficerAddress != address(0));
89         operatingOfficerAddress = _operatingOfficerAddress;
90     }
91 
92     /// @notice Collect funds from this contract
93     function withdrawBalance() external onlyFinancialOfficer {
94         financialOfficerAddress.transfer(address(this).balance);
95     }
96 }
97 
98 /* ERC165.sol *****************************************************************/
99 
100 /// @title ERC-165 Standard Interface Detection
101 /// @dev Reference https://eips.ethereum.org/EIPS/eip-165
102 interface ERC165 {
103     function supportsInterface(bytes4 interfaceID) external view returns (bool);
104 }
105 
106 /* ERC721.sol *****************************************************************/
107 
108 /// @title ERC-721 Non-Fungible Token Standard
109 /// @dev Reference https://eips.ethereum.org/EIPS/eip-721
110 interface ERC721 /* is ERC165 */ {
111     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
112     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
113     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
114     function balanceOf(address _owner) external view returns (uint256);
115     function ownerOf(uint256 _tokenId) external view returns (address);
116     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) external payable;
117     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;
118     function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
119     function approve(address _approved, uint256 _tokenId) external payable;
120     function setApprovalForAll(address _operator, bool _approved) external;
121     function getApproved(uint256 _tokenId) external view returns (address);
122     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
123 }
124 
125 /// @title ERC-721 Non-Fungible Token Standard
126 interface ERC721TokenReceiver {
127     function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes _data) external returns(bytes4);
128 }
129 
130 /// @title ERC-721 Non-Fungible Token Standard, optional metadata extension
131 interface ERC721Metadata /* is ERC721 */ {
132     function name() external pure returns (string _name);
133     function symbol() external pure returns (string _symbol);
134     function tokenURI(uint256 _tokenId) external view returns (string);
135 }
136 
137 /// @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
138 interface ERC721Enumerable /* is ERC721 */ {
139     function totalSupply() external view returns (uint256);
140     function tokenByIndex(uint256 _index) external view returns (uint256);
141     function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256);
142 }
143 
144 /* SupportsInterface.sol ******************************************************/
145 
146 /// @title A reusable contract to comply with ERC-165
147 /// @author William Entriken (https://phor.net)
148 contract SupportsInterface is ERC165 {
149     /// @dev Every interface that we support, do not set 0xffffffff to true
150     mapping(bytes4 => bool) internal supportedInterfaces;
151 
152     constructor() internal {
153         supportedInterfaces[0x01ffc9a7] = true; // ERC165
154     }
155 
156     /// @notice Query if a contract implements an interface
157     /// @param interfaceID The interface identifier, as specified in ERC-165
158     /// @dev Interface identification is specified in ERC-165. This function
159     ///  uses less than 30,000 gas.
160     /// @return `true` if the contract implements `interfaceID` and
161     ///  `interfaceID` is not 0xffffffff, `false` otherwise
162     function supportsInterface(bytes4 interfaceID) external view returns (bool) {
163         return supportedInterfaces[interfaceID] && (interfaceID != 0xffffffff);
164     }
165 }
166 
167 /* SuNFT.sol ******************************************************************/
168 
169 /// @title Compliance with ERC-721 for Su Squares
170 /// @dev This implementation assumes:
171 ///  - A fixed supply of NFTs, cannot mint or burn
172 ///  - ids are numbered sequentially starting at 1.
173 ///  - NFTs are initially assigned to this contract
174 ///  - This contract does not externally call its own functions
175 /// @author William Entriken (https://phor.net)
176 contract SuNFT is ERC165, ERC721, ERC721Metadata, ERC721Enumerable, SupportsInterface {
177     /// @dev The authorized address for each NFT
178     mapping (uint256 => address) internal tokenApprovals;
179 
180     /// @dev The authorized operators for each address
181     mapping (address => mapping (address => bool)) internal operatorApprovals;
182 
183     /// @dev Guarantees msg.sender is the owner of _tokenId
184     /// @param _tokenId The token to validate belongs to msg.sender
185     modifier onlyOwnerOf(uint256 _tokenId) {
186         address owner = _tokenOwnerWithSubstitutions[_tokenId];
187         // assert(msg.sender != address(this))
188         require(msg.sender == owner);
189         _;
190     }
191 
192     modifier mustBeOwnedByThisContract(uint256 _tokenId) {
193         require(_tokenId >= 1 && _tokenId <= TOTAL_SUPPLY);
194         address owner = _tokenOwnerWithSubstitutions[_tokenId];
195         require(owner == address(0) || owner == address(this));
196         _;
197     }
198 
199     modifier canOperate(uint256 _tokenId) {
200         // assert(msg.sender != address(this))
201         address owner = _tokenOwnerWithSubstitutions[_tokenId];
202         require(msg.sender == owner || operatorApprovals[owner][msg.sender]);
203         _;
204     }
205 
206     modifier canTransfer(uint256 _tokenId) {
207         // assert(msg.sender != address(this))
208         address owner = _tokenOwnerWithSubstitutions[_tokenId];
209         require(msg.sender == owner ||
210           msg.sender == tokenApprovals[_tokenId] ||
211           operatorApprovals[msg.sender][msg.sender]);
212         _;
213     }
214 
215     modifier mustBeValidToken(uint256 _tokenId) {
216         require(_tokenId >= 1 && _tokenId <= TOTAL_SUPPLY);
217         _;
218     }
219 
220     /// @dev This emits when ownership of any NFT changes by any mechanism.
221     ///  This event emits when NFTs are created (`from` == 0) and destroyed
222     ///  (`to` == 0). Exception: during contract creation, any number of NFTs
223     ///  may be created and assigned without emitting Transfer. At the time of
224     ///  any transfer, the approved address for that NFT (if any) is reset to none.
225     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
226 
227     /// @dev This emits when the approved address for an NFT is changed or
228     ///  reaffirmed. The zero address indicates there is no approved address.
229     ///  When a Transfer event emits, this also indicates that the approved
230     ///  address for that NFT (if any) is reset to none.
231     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
232 
233     /// @dev This emits when an operator is enabled or disabled for an owner.
234     ///  The operator can manage all NFTs of the owner.
235     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
236 
237     /// @notice Count all NFTs assigned to an owner
238     /// @dev NFTs assigned to the zero address are considered invalid, and this
239     ///  function throws for queries about the zero address.
240     /// @param _owner An address for whom to query the balance
241     /// @return The number of NFTs owned by `_owner`, possibly zero
242     function balanceOf(address _owner) external view returns (uint256) {
243         require(_owner != address(0));
244         return _tokensOfOwnerWithSubstitutions[_owner].length;
245     }
246 
247     /// @notice Find the owner of an NFT
248     /// @dev NFTs assigned to zero address are considered invalid, and queries
249     ///  about them do throw.
250     /// @param _tokenId The identifier for an NFT
251     /// @return The address of the owner of the NFT
252     function ownerOf(uint256 _tokenId)
253         external
254         view
255         mustBeValidToken(_tokenId)
256         returns (address _owner)
257     {
258         _owner = _tokenOwnerWithSubstitutions[_tokenId];
259         // Handle substitutions
260         if (_owner == address(0)) {
261             _owner = address(this);
262         }
263     }
264 
265     /// @notice Transfers the ownership of an NFT from one address to another address
266     /// @dev Throws unless `msg.sender` is the current owner, an authorized
267     ///  operator, or the approved address for this NFT. Throws if `_from` is
268     ///  not the current owner. Throws if `_to` is the zero address. Throws if
269     ///  `_tokenId` is not a valid NFT. When transfer is complete, this function
270     ///  checks if `_to` is a smart contract (code size > 0). If so, it calls
271     ///  `onERC721Received` on `_to` and throws if the return value is not
272     ///  `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
273     /// @param _from The current owner of the NFT
274     /// @param _to The new owner
275     /// @param _tokenId The NFT to transfer
276     /// @param data Additional data with no specified format, sent in call to `_to`
277     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) external payable
278     {
279         _safeTransferFrom(_from, _to, _tokenId, data);
280     }
281 
282     /// @notice Transfers the ownership of an NFT from one address to another address
283     /// @dev This works identically to the other function with an extra data parameter,
284     ///  except this function just sets data to "".
285     /// @param _from The current owner of the NFT
286     /// @param _to The new owner
287     /// @param _tokenId The NFT to transfer
288     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable
289     {
290         _safeTransferFrom(_from, _to, _tokenId, "");
291     }
292 
293     /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
294     ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
295     ///  THEY MAY BE PERMANENTLY LOST
296     /// @dev Throws unless `msg.sender` is the current owner, an authorized
297     ///  operator, or the approved address for this NFT. Throws if `_from` is
298     ///  not the current owner. Throws if `_to` is the zero address. Throws if
299     ///  `_tokenId` is not a valid NFT.
300     /// @param _from The current owner of the NFT
301     /// @param _to The new owner
302     /// @param _tokenId The NFT to transfer
303     function transferFrom(address _from, address _to, uint256 _tokenId)
304         external
305         payable
306         mustBeValidToken(_tokenId)
307         canTransfer(_tokenId)
308     {
309         address owner = _tokenOwnerWithSubstitutions[_tokenId];
310         // Handle substitutions
311         if (owner == address(0)) {
312             owner = address(this);
313         }
314         require(owner == _from);
315         require(_to != address(0));
316         _transfer(_tokenId, _to);
317     }
318 
319     /// @notice Change or reaffirm the approved address for an NFT
320     /// @dev The zero address indicates there is no approved address.
321     ///  Throws unless `msg.sender` is the current NFT owner, or an authorized
322     ///  operator of the current owner.
323     /// @param _approved The new approved NFT controller
324     /// @param _tokenId The NFT to approve
325     function approve(address _approved, uint256 _tokenId)
326         external
327         payable
328         // assert(mustBeValidToken(_tokenId))
329         canOperate(_tokenId)
330     {
331         address _owner = _tokenOwnerWithSubstitutions[_tokenId];
332         // Handle substitutions
333         if (_owner == address(0)) {
334             _owner = address(this);
335         }
336         tokenApprovals[_tokenId] = _approved;
337         emit Approval(_owner, _approved, _tokenId);
338     }
339 
340     /// @notice Enable or disable approval for a third party ("operator") to
341     ///  manage all of `msg.sender`'s assets
342     /// @dev Emits the ApprovalForAll event. The contract MUST allow
343     ///  multiple operators per owner.
344     /// @param _operator Address to add to the set of authorized operators
345     /// @param _approved True if operator is approved, false to revoke approval
346     function setApprovalForAll(address _operator, bool _approved) external {
347         operatorApprovals[msg.sender][_operator] = _approved;
348         emit ApprovalForAll(msg.sender, _operator, _approved);
349     }
350 
351     /// @notice Get the approved address for a single NFT
352     /// @dev Throws if `_tokenId` is not a valid NFT.
353     /// @param _tokenId The NFT to find the approved address for
354     /// @return The approved address for this NFT, or the zero address if there is none
355     function getApproved(uint256 _tokenId)
356         external
357         view
358         mustBeValidToken(_tokenId)
359         returns (address)
360     {
361         return tokenApprovals[_tokenId];
362     }
363 
364     /// @notice Query if an address is an authorized operator for another address
365     /// @param _owner The address that owns the NFTs
366     /// @param _operator The address that acts on behalf of the owner
367     /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
368     function isApprovedForAll(address _owner, address _operator) external view returns (bool) {
369         return operatorApprovals[_owner][_operator];
370     }
371 
372     // COMPLIANCE WITH ERC721Metadata //////////////////////////////////////////
373 
374     /// @notice A descriptive name for a collection of NFTs in this contract
375     function name() external pure returns (string) {
376         return "Su Squares";
377     }
378 
379     /// @notice An abbreviated name for NFTs in this contract
380     function symbol() external pure returns (string) {
381         return "SU";
382     }
383 
384     /// @notice A distinct Uniform Resource Identifier (URI) for a given asset.
385     /// @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
386     ///  3986. The URI may point to a JSON file that conforms to the "ERC721
387     ///  Metadata JSON Schema".
388     function tokenURI(uint256 _tokenId)
389         external
390         view
391         mustBeValidToken(_tokenId)
392         returns (string _tokenURI)
393     {
394         _tokenURI = "https://tenthousandsu.com/erc721/00000.json";
395         bytes memory _tokenURIBytes = bytes(_tokenURI);
396         _tokenURIBytes[33] = byte(48+(_tokenId / 10000) % 10);
397         _tokenURIBytes[34] = byte(48+(_tokenId / 1000) % 10);
398         _tokenURIBytes[35] = byte(48+(_tokenId / 100) % 10);
399         _tokenURIBytes[36] = byte(48+(_tokenId / 10) % 10);
400         _tokenURIBytes[37] = byte(48+(_tokenId / 1) % 10);
401 
402     }
403 
404     // COMPLIANCE WITH ERC721Enumerable ////////////////////////////////////////
405 
406     /// @notice Count NFTs tracked by this contract
407     /// @return A count of valid NFTs tracked by this contract, where each one
408     ///  has an assigned and queryable owner not equal to the zero address
409     function totalSupply() external view returns (uint256) {
410         return TOTAL_SUPPLY;
411     }
412 
413     /// @notice Enumerate valid NFTs
414     /// @dev Throws if `_index` >= `totalSupply()`.
415     /// @param _index A counter less than `totalSupply()`
416     /// @return The token identifier for the `_index`th NFT,
417     ///  (sort order not specified)
418     function tokenByIndex(uint256 _index) external view returns (uint256) {
419         require(_index < TOTAL_SUPPLY);
420         return _index + 1;
421     }
422 
423     /// @notice Enumerate NFTs assigned to an owner
424     /// @dev Throws if `_index` >= `balanceOf(_owner)` or if
425     ///  `_owner` is the zero address, representing invalid NFTs.
426     /// @param _owner An address where we are interested in NFTs owned by them
427     /// @param _index A counter less than `balanceOf(_owner)`
428     /// @return The token identifier for the `_index`th NFT assigned to `_owner`,
429     ///   (sort order not specified)
430     function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 _tokenId) {
431         require(_owner != address(0));
432         require(_index < _tokensOfOwnerWithSubstitutions[_owner].length);
433         _tokenId = _tokensOfOwnerWithSubstitutions[_owner][_index];
434         // Handle substitutions
435         if (_owner == address(this)) {
436             if (_tokenId == 0) {
437                 _tokenId = _index + 1;
438             }
439         }
440     }
441 
442     // INTERNAL INTERFACE //////////////////////////////////////////////////////
443 
444     /// @dev Actually do a transfer, does NO precondition checking
445     function _transfer(uint256 _tokenId, address _to) internal {
446         // Here are the preconditions we are not checking:
447         // assert(canTransfer(_tokenId))
448         // assert(mustBeValidToken(_tokenId))
449         require(_to != address(0));
450 
451         // Find the FROM address
452         address fromWithSubstitution = _tokenOwnerWithSubstitutions[_tokenId];
453         address from = fromWithSubstitution;
454         if (fromWithSubstitution == address(0)) {
455             from = address(this);
456         }
457 
458         // Take away from the FROM address
459         // The Entriken algorithm for deleting from an indexed, unsorted array
460         uint256 indexToDeleteWithSubstitution = _ownedTokensIndexWithSubstitutions[_tokenId];
461         uint256 indexToDelete;
462         if (indexToDeleteWithSubstitution == 0) {
463             indexToDelete = _tokenId - 1;
464         } else {
465             indexToDelete = indexToDeleteWithSubstitution - 1;
466         }
467         if (indexToDelete != _tokensOfOwnerWithSubstitutions[from].length - 1) {
468             uint256 lastNftWithSubstitution = _tokensOfOwnerWithSubstitutions[from][_tokensOfOwnerWithSubstitutions[from].length - 1];
469             uint256 lastNft = lastNftWithSubstitution;
470             if (lastNftWithSubstitution == 0) {
471                 // assert(from ==  address(0) || from == address(this));
472                 lastNft = _tokensOfOwnerWithSubstitutions[from].length;
473             }
474             _tokensOfOwnerWithSubstitutions[from][indexToDelete] = lastNft;
475             _ownedTokensIndexWithSubstitutions[lastNft] = indexToDelete + 1;
476         }
477         delete _tokensOfOwnerWithSubstitutions[from][_tokensOfOwnerWithSubstitutions[from].length - 1]; // get gas back
478         _tokensOfOwnerWithSubstitutions[from].length--;
479         // Right now _ownedTokensIndexWithSubstitutions[_tokenId] is invalid, set it below based on the new owner
480 
481         // Give to the TO address
482         _tokensOfOwnerWithSubstitutions[_to].push(_tokenId);
483         _ownedTokensIndexWithSubstitutions[_tokenId] = (_tokensOfOwnerWithSubstitutions[_to].length - 1) + 1;
484 
485         // External processing
486         _tokenOwnerWithSubstitutions[_tokenId] = _to;
487         tokenApprovals[_tokenId] = address(0);
488         emit Transfer(from, _to, _tokenId);
489     }
490 
491     // PRIVATE STORAGE AND FUNCTIONS ///////////////////////////////////////////
492 
493     // See Solidity issue #3356, it would be clearer to initialize in SuMain
494     uint256 private constant TOTAL_SUPPLY = 10000;
495 
496     bytes4 private constant ERC721_RECEIVED = bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));
497 
498     /// @dev The owner of each NFT
499     ///  If value == address(0), NFT is owned by address(this)
500     ///  If value != address(0), NFT is owned by value
501     ///  assert(This contract never assigns awnerhip to address(0) or destroys NFTs)
502     ///  See commented out code in constructor, saves hella gas
503     mapping (uint256 => address) private _tokenOwnerWithSubstitutions;
504 
505     /// @dev The list of NFTs owned by each address
506     ///  Nomenclature: this[key][index] = value
507     ///  If key != address(this) or value != 0, then value represents an NFT
508     ///  If key == address(this) and value == 0, then index + 1 is the NFT
509     ///  assert(0 is not a valid NFT)
510     ///  See commented out code in constructor, saves hella gas
511     mapping (address => uint256[]) private _tokensOfOwnerWithSubstitutions;
512 
513     /// @dev (Location + 1) of each NFT in its owner's list
514     ///  Nomenclature: this[key] = value
515     ///  If value != 0, _tokensOfOwnerWithSubstitutions[owner][value - 1] = nftId
516     ///  If value == 0, _tokensOfOwnerWithSubstitutions[owner][key - 1] = nftId
517     ///  assert(2**256-1 is not a valid NFT)
518     ///  See commented out code in constructor, saves hella gas
519     mapping (uint256 => uint256) private _ownedTokensIndexWithSubstitutions;
520 
521     // Due to implementation choices (no mint, no burn, contiguous NFT ids), it
522     // is not necessary to keep an array of NFT ids nor where each NFT id is
523     // located in that array.
524     // address[] private nftIds;
525     // mapping (uint256 => uint256) private nftIndexOfId;
526 
527     constructor() internal {
528         // Publish interfaces with ERC-165
529         supportedInterfaces[0x80ac58cd] = true; // ERC721
530         supportedInterfaces[0x5b5e139f] = true; // ERC721Metadata
531         supportedInterfaces[0x780e9d63] = true; // ERC721Enumerable
532         supportedInterfaces[0x8153916a] = true; // ERC721 + 165 (not needed)
533 
534         // The effect of substitution makes storing address(this), address(this)
535         // ..., address(this) for a total of TOTAL_SUPPLY times unnecessary at
536         // deployment time
537         // for (uint256 i = 1; i <= TOTAL_SUPPLY; i++) {
538         //     _tokenOwnerWithSubstitutions[i] = address(this);
539         // }
540 
541         // The effect of substitution makes storing 1, 2, ..., TOTAL_SUPPLY
542         // unnecessary at deployment time
543         _tokensOfOwnerWithSubstitutions[address(this)].length = TOTAL_SUPPLY;
544         // for (uint256 i = 0; i < TOTAL_SUPPLY; i++) {
545         //     _tokensOfOwnerWithSubstitutions[address(this)][i] = i + 1;
546         // }
547         // for (uint256 i = 1; i <= TOTAL_SUPPLY; i++) {
548         //     _ownedTokensIndexWithSubstitutions[i] = i - 1;
549         // }
550     }
551 
552     /// @dev Actually perform the safeTransferFrom
553     function _safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data)
554         private
555         mustBeValidToken(_tokenId)
556         canTransfer(_tokenId)
557     {
558         address owner = _tokenOwnerWithSubstitutions[_tokenId];
559         // Handle substitutions
560         if (owner == address(0)) {
561             owner = address(this);
562         }
563         require(owner == _from);
564         require(_to != address(0));
565         _transfer(_tokenId, _to);
566 
567         // Do the callback after everything is done to avoid reentrancy attack
568         uint256 codeSize;
569         assembly { codeSize := extcodesize(_to) }
570         if (codeSize == 0) {
571             return;
572         }
573         bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId, data);
574         require(retval == ERC721_RECEIVED);
575     }
576 }
577 
578 /* SuOperation.sol ************************************************************/
579 
580 /// @title The features that square owners can use
581 /// @author William Entriken (https://phor.net)
582 contract SuOperation is SuNFT {
583     /// @dev The personalization of a square has changed
584     event Personalized(uint256 _nftId);
585 
586     /// @dev The main SuSquare struct. The owner may set these properties,
587     ///  subject to certain rules. The actual 10x10 image is rendered on our
588     ///  website using this data.
589     struct SuSquare {
590         /// @dev This increments on each update
591         uint256 version;
592 
593         /// @dev A 10x10 pixel image, stored 8-bit RGB values from left-to-right
594         ///  and top-to-bottom order (normal English reading order). So it is
595         ///  exactly 300 bytes. Or it is an empty array.
596         ///  So the first byte is the red channel for the top-left pixel, then
597         ///  the blue, then the green, and then next is the red channel for the
598         ///  pixel to the right of the first pixel.
599         bytes rgbData;
600 
601         /// @dev The title of this square, at most 64 bytes,
602         string title;
603 
604         /// @dev The URL of this square, at most 100 bytes, or empty string
605         string href;
606     }
607 
608     /// @notice All the Su Squares that ever exist or will exist. Each Su Square
609     ///  represents a square on our webpage in a 100x100 grid. The squares are
610     ///  arranged in left-to-right, top-to-bottom order. In other words, normal
611     ///  English reading order. So suSquares[1] is the top-left location and
612     ///  suSquares[100] is the top-right location. And suSquares[101] is
613     ///  directly below suSquares[1].
614     /// @dev There is no suSquares[0] -- that is an unused array index.
615     SuSquare[10001] public suSquares;
616 
617     /// @notice Update the contents of your square, the first 3 personalizations
618     ///  for a square are free then cost 100 finney (0.01 ether) each
619     /// @param _squareId The top-left is 1, to its right is 2, ..., top-right is
620     ///  100 and then 101 is below 1... the last one at bottom-right is 10000
621     /// @param _squareId A 10x10 image for your square, in 8-bit RGB words
622     ///  ordered like the squares are ordered. See Imagemagick's command
623     ///  convert -size 10x10 -depth 8 in.rgb out.png
624     /// @param _title A description of your square (max 64 bytes UTF-8)
625     /// @param _href A hyperlink for your square (max 96 bytes)
626     function personalizeSquare(
627         uint256 _squareId,
628         bytes _rgbData,
629         string _title,
630         string _href
631     )
632         external
633         onlyOwnerOf(_squareId)
634         payable
635     {
636         require(bytes(_title).length <= 64);
637         require(bytes(_href).length <= 96);
638         require(_rgbData.length == 300);
639         suSquares[_squareId].version++;
640         suSquares[_squareId].rgbData = _rgbData;
641         suSquares[_squareId].title = _title;
642         suSquares[_squareId].href = _href;
643         if (suSquares[_squareId].version > 3) {
644             require(msg.value == 10 finney);
645         }
646         emit Personalized(_squareId);
647     }
648 }
649 
650 /* SuPromo.sol ****************************************************************/
651 
652 /// @title A limited pre-sale and promotional giveaway
653 /// @author William Entriken (https://phor.net)
654 contract SuPromo is AccessControl, SuNFT {
655     uint256 constant PROMO_CREATION_LIMIT = 5000;
656 
657     /// @notice How many promo squares were granted
658     uint256 public promoCreatedCount;
659 
660     /// @notice BEWARE, this does not use a safe transfer mechanism!
661     ///  You must manually check the receiver can accept NFTs
662     function grantToken(uint256 _tokenId, address _newOwner)
663         external
664         onlyOperatingOfficer
665         mustBeValidToken(_tokenId)
666         mustBeOwnedByThisContract(_tokenId)
667     {
668         require(promoCreatedCount < PROMO_CREATION_LIMIT);
669         promoCreatedCount++;
670         _transfer(_tokenId, _newOwner);
671     }
672 }
673 
674 /* SuVending.sol **************************************************************/
675 
676 /// @title A token vending machine
677 /// @author William Entriken (https://phor.net)
678 contract SuVending is SuNFT {
679     uint256 constant SALE_PRICE = 500 finney; // 0.5 ether
680 
681     /// @notice The price is always 0.5 ether, and you can buy any available square
682     ///  Be sure you are calling this from a regular account (not a smart contract)
683     ///  or if you are calling from a smart contract, make sure it can use
684     ///  ERC-721 non-fungible tokens
685     function purchase(uint256 _nftId)
686         external
687         payable
688         mustBeValidToken(_nftId)
689         mustBeOwnedByThisContract(_nftId)
690     {
691         require(msg.value == SALE_PRICE);
692         _transfer(_nftId, msg.sender);
693     }
694 }
695 
696 /* SuMain.sol *****************************************************************/
697 
698 /// @title The features that deed owners can use
699 /// @author William Entriken (https://phor.net)
700 contract SuMain is AccessControl, SuNFT, SuOperation, SuVending, SuPromo {
701     constructor() public {
702     }
703 }