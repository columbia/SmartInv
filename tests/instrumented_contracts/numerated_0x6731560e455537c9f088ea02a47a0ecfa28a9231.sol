1 pragma solidity ^0.4.21;
2 
3 /******************************************************************************\
4 *..................................SU.SQUARES..................................*
5 *.......................Blockchain.rentable.advertising........................*
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
16 *  - PublishInterfaces: An implementation of ERC165                            *
17 *  - SuNFT: An implementation of ERC721                                        *
18 *  - SuOperation: The actual square data and the personalize function          *
19 *  - SuPromo, SuVending: How we sell or grant squares                          *
20 *..............................................................................*
21 *............................Su.&.William.Entriken.............................*
22 *...................................(c) 2018...................................*
23 \******************************************************************************/
24 
25 /* AccessControl.sol **********************************************************/
26 
27 /// @title Reusable three-role access control inspired by CryptoKitties
28 /// @author William Entriken (https://phor.net)
29 /// @dev Keep the CEO wallet stored offline, I warned you
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
40     function AccessControl() internal {
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
101 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
102 interface ERC165 {
103     function supportsInterface(bytes4 interfaceID) external view returns (bool);
104 }
105 
106 /* ERC721.sol *****************************************************************/
107 
108 /// @title ERC-721 Non-Fungible Token Standard
109 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
110 contract ERC721 is ERC165 {
111     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
112     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
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
127 	function onERC721Received(address _from, uint256 _tokenId, bytes data) external returns(bytes4);
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
144 /* PublishInterfaces.sol ******************************************************/
145 
146 /// @title A reusable contract to comply with ERC-165
147 /// @author William Entriken (https://phor.net)
148 contract PublishInterfaces is ERC165 {
149     /// @dev Every interface that we support
150     mapping(bytes4 => bool) internal supportedInterfaces;
151 
152     function PublishInterfaces() internal {
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
176 contract SuNFT is ERC165, ERC721, ERC721Metadata, ERC721Enumerable, PublishInterfaces {
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
225     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
226 
227     /// @dev This emits when the approved address for an NFT is changed or
228     ///  reaffirmed. The zero address indicates there is no approved address.
229     ///  When a Transfer event emits, this also indicates that the approved
230     ///  address for that NFT (if any) is reset to none.
231     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
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
272     ///  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`.
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
284     ///  except this function just sets data to ""
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
319     /// @notice Set or reaffirm the approved address for an NFT
320     /// @dev The zero address indicates there is no approved address.
321     /// @dev Throws unless `msg.sender` is the current NFT owner, or an authorized
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
340     /// @notice Enable or disable approval for a third party ("operator") to manage
341     ///  all your asset.
342     /// @dev Emits the ApprovalForAll event
343     /// @param _operator Address to add to the set of authorized operators.
344     /// @param _approved True if the operators is approved, false to revoke approval
345     function setApprovalForAll(address _operator, bool _approved) external {
346         operatorApprovals[msg.sender][_operator] = _approved;
347         emit ApprovalForAll(msg.sender, _operator, _approved);
348     }
349 
350     /// @notice Get the approved address for a single NFT
351     /// @dev Throws if `_tokenId` is not a valid NFT
352     /// @param _tokenId The NFT to find the approved address for
353     /// @return The approved address for this NFT, or the zero address if there is none
354     function getApproved(uint256 _tokenId)
355         external
356         view
357         mustBeValidToken(_tokenId)
358         returns (address)
359     {
360         return tokenApprovals[_tokenId];
361     }
362 
363     /// @notice Query if an address is an authorized operator for another address
364     /// @param _owner The address that owns the NFTs
365     /// @param _operator The address that acts on behalf of the owner
366     /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
367     function isApprovedForAll(address _owner, address _operator) external view returns (bool) {
368         return operatorApprovals[_owner][_operator];
369     }
370 
371     // COMPLIANCE WITH ERC721Metadata //////////////////////////////////////////
372 
373     /// @notice A descriptive name for a collection of NFTs in this contract
374     function name() external pure returns (string) {
375         return "Su Squares";
376     }
377 
378     /// @notice An abbreviated name for NFTs in this contract
379     function symbol() external pure returns (string) {
380         return "SU";
381     }
382 
383     /// @notice A distinct Uniform Resource Identifier (URI) for a given asset.
384     /// @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
385     ///  3986. The URI may point to a JSON file that conforms to the "ERC721
386     ///  Metadata JSON Schema".
387     function tokenURI(uint256 _tokenId)
388         external
389         view
390         mustBeValidToken(_tokenId)
391         returns (string _tokenURI)
392     {
393         _tokenURI = "https://tenthousandsu.com/erc721/00000.json";
394         bytes memory _tokenURIBytes = bytes(_tokenURI);
395         _tokenURIBytes[33] = byte(48+(_tokenId / 10000) % 10);
396         _tokenURIBytes[34] = byte(48+(_tokenId / 1000) % 10);
397         _tokenURIBytes[35] = byte(48+(_tokenId / 100) % 10);
398         _tokenURIBytes[36] = byte(48+(_tokenId / 10) % 10);
399         _tokenURIBytes[37] = byte(48+(_tokenId / 1) % 10);
400 
401     }
402 
403     // COMPLIANCE WITH ERC721Enumerable ////////////////////////////////////////
404 
405     /// @notice Count NFTs tracked by this contract
406     /// @return A count of valid NFTs tracked by this contract, where each one of
407     ///  them has an assigned and queryable owner not equal to the zero address
408     function totalSupply() external view returns (uint256) {
409         return TOTAL_SUPPLY;
410     }
411 
412     /// @notice Enumerate valid NFTs
413     /// @dev Throws if `_index` >= `totalSupply()`.
414     /// @param _index A counter less than `totalSupply()`
415     /// @return The token identifier for the `_index`th NFT,
416     ///  (sort order not specified)
417     function tokenByIndex(uint256 _index) external view returns (uint256) {
418         require(_index < TOTAL_SUPPLY);
419         return _index + 1;
420     }
421 
422     /// @notice Enumerate NFTs assigned to an owner
423     /// @dev Throws if `_index` >= `balanceOf(_owner)` or if
424     ///  `_owner` is the zero address, representing invalid NFTs.
425     /// @param _owner An address where we are interested in NFTs owned by them
426     /// @param _index A counter less than `balanceOf(_owner)`
427     /// @return The token identifier for the `_index`th NFT assigned to `_owner`,
428     ///   (sort order not specified)
429     function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 _tokenId) {
430         require(_owner != address(0));
431         require(_index < _tokensOfOwnerWithSubstitutions[_owner].length);
432         _tokenId = _tokensOfOwnerWithSubstitutions[_owner][_index];
433         // Handle substitutions
434         if (_owner == address(this)) {
435             if (_tokenId == 0) {
436                 _tokenId = _index + 1;
437             }
438         }
439     }
440 
441     // INTERNAL INTERFACE //////////////////////////////////////////////////////
442 
443     /// @dev Actually do a transfer, does NO precondition checking
444     function _transfer(uint256 _tokenId, address _to) internal {
445         // Here are the preconditions we are not checking:
446         // assert(canTransfer(_tokenId))
447         // assert(mustBeValidToken(_tokenId))
448         require(_to != address(0));
449 
450         // Find the FROM address
451         address fromWithSubstitution = _tokenOwnerWithSubstitutions[_tokenId];
452         address from = fromWithSubstitution;
453         if (fromWithSubstitution == address(0)) {
454             from = address(this);
455         }
456 
457         // Take away from the FROM address
458         // The Entriken algorithm for deleting from an indexed, unsorted array
459         uint256 indexToDeleteWithSubstitution = _ownedTokensIndexWithSubstitutions[_tokenId];
460         uint256 indexToDelete;
461         if (indexToDeleteWithSubstitution == 0) {
462             indexToDelete = _tokenId - 1;
463         } else {
464             indexToDelete = indexToDeleteWithSubstitution - 1;
465         }
466         if (indexToDelete != _tokensOfOwnerWithSubstitutions[from].length - 1) {
467             uint256 lastNftWithSubstitution = _tokensOfOwnerWithSubstitutions[from][_tokensOfOwnerWithSubstitutions[from].length - 1];
468             uint256 lastNft = lastNftWithSubstitution;
469             if (lastNftWithSubstitution == 0) {
470                 // assert(from ==  address(0) || from == address(this));
471                 lastNft = _tokensOfOwnerWithSubstitutions[from].length;
472             }
473             _tokensOfOwnerWithSubstitutions[from][indexToDelete] = lastNft;
474             _ownedTokensIndexWithSubstitutions[lastNft] = indexToDelete + 1;
475         }
476         delete _tokensOfOwnerWithSubstitutions[from][_tokensOfOwnerWithSubstitutions[from].length - 1]; // get gas back
477         _tokensOfOwnerWithSubstitutions[from].length--;
478         // Right now _ownedTokensIndexWithSubstitutions[_tokenId] is invalid, set it below based on the new owner
479 
480         // Give to the TO address
481         _tokensOfOwnerWithSubstitutions[_to].push(_tokenId);
482         _ownedTokensIndexWithSubstitutions[_tokenId] = (_tokensOfOwnerWithSubstitutions[_to].length - 1) + 1;
483 
484         // External processing
485         _tokenOwnerWithSubstitutions[_tokenId] = _to;
486         tokenApprovals[_tokenId] = address(0);
487         emit Transfer(from, _to, _tokenId);
488     }
489 
490     // PRIVATE STORAGE AND FUNCTIONS ///////////////////////////////////////////
491 
492     uint256 private constant TOTAL_SUPPLY = 10000; // SOLIDITY ISSUE #3356 make this immutable
493 
494     bytes4 private constant ERC721_RECEIVED = bytes4(keccak256("onERC721Received(address,uint256,bytes)"));
495 
496     /// @dev The owner of each NFT
497     ///  If value == address(0), NFT is owned by address(this)
498     ///  If value != address(0), NFT is owned by value
499     ///  assert(This contract never assigns awnerhip to address(0) or destroys NFTs)
500     ///  See commented out code in constructor, saves hella gas
501     mapping (uint256 => address) private _tokenOwnerWithSubstitutions;
502 
503     /// @dev The list of NFTs owned by each address
504     ///  Nomenclature: this[key][index] = value
505     ///  If key != address(this) or value != 0, then value represents an NFT
506     ///  If key == address(this) and value == 0, then index + 1 is the NFT
507     ///  assert(0 is not a valid NFT)
508     ///  See commented out code in constructor, saves hella gas
509     mapping (address => uint256[]) private _tokensOfOwnerWithSubstitutions;
510 
511     /// @dev (Location + 1) of each NFT in its owner's list
512     ///  Nomenclature: this[key] = value
513     ///  If value != 0, _tokensOfOwnerWithSubstitutions[owner][value - 1] = nftId
514     ///  If value == 0, _tokensOfOwnerWithSubstitutions[owner][key - 1] = nftId
515     ///  assert(2**256-1 is not a valid NFT)
516     ///  See commented out code in constructor, saves hella gas
517     mapping (uint256 => uint256) private _ownedTokensIndexWithSubstitutions;
518 
519     // Due to implementation choices (no mint, no burn, contiguous NFT ids), it
520     // is not necessary to keep an array of NFT ids nor where each NFT id is
521     // located in that array.
522     // address[] private nftIds;
523     // mapping (uint256 => uint256) private nftIndexOfId;
524 
525     function SuNFT() internal {
526         // Publish interfaces with ERC-165
527         supportedInterfaces[0x80ac58cd] = true; // ERC721
528         supportedInterfaces[0x5b5e139f] = true; // ERC721Metadata
529         supportedInterfaces[0x780e9d63] = true; // ERC721Enumerable
530         supportedInterfaces[0x8153916a] = true; // ERC721 + 165 (not needed)
531 
532         // The effect of substitution makes storing address(this), address(this)
533         // ..., address(this) for a total of TOTAL_SUPPLY times unnecessary at
534         // deployment time
535         // for (uint256 i = 1; i <= TOTAL_SUPPLY; i++) {
536         //     _tokenOwnerWithSubstitutions[i] = address(this);
537         // }
538 
539         // The effect of substitution makes storing 1, 2, ..., TOTAL_SUPPLY
540         // unnecessary at deployment time
541         _tokensOfOwnerWithSubstitutions[address(this)].length = TOTAL_SUPPLY;
542         // for (uint256 i = 0; i < TOTAL_SUPPLY; i++) {
543         //     _tokensOfOwnerWithSubstitutions[address(this)][i] = i + 1;
544         // }
545         // for (uint256 i = 1; i <= TOTAL_SUPPLY; i++) {
546         //     _ownedTokensIndexWithSubstitutions[i] = i - 1;
547         // }
548     }
549 
550     /// @dev Actually perform the safeTransferFrom
551     function _safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data)
552         private
553         mustBeValidToken(_tokenId)
554         canTransfer(_tokenId)
555     {
556         address owner = _tokenOwnerWithSubstitutions[_tokenId];
557         // Handle substitutions
558         if (owner == address(0)) {
559             owner = address(this);
560         }
561         require(owner == _from);
562         require(_to != address(0));
563         _transfer(_tokenId, _to);
564 
565         // Do the callback after everything is done to avoid reentrancy attack
566         uint256 codeSize;
567         assembly { codeSize := extcodesize(_to) }
568         if (codeSize == 0) {
569             return;
570         }
571         bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(_from, _tokenId, data);
572         require(retval == ERC721_RECEIVED);
573     }
574 }
575 
576 /* SuOperation.sol ************************************************************/
577 
578 /// @title The features that square owners can use
579 /// @author William Entriken (https://phor.net)
580 /// @dev See SuMain contract documentation for detail on how contracts interact.
581 contract SuOperation is SuNFT {
582     /// @dev The personalization of a square has changed
583     event Personalized(uint256 _nftId);
584 
585     /// @dev The main SuSquare struct. The owner may set these properties, subject
586     ///  subject to certain rules. The actual 10x10 image is rendered on our
587     ///  website using this data.
588     struct SuSquare {
589         /// @dev This increments on each update
590         uint256 version;
591 
592         /// @dev A 10x10 pixel image, stored 8-bit RGB values from left-to-right
593         ///  and top-to-bottom order (normal English reading order). So it is
594         ///  exactly 300 bytes. Or it is an empty array.
595         ///  So the first byte is the red channel for the top-left pixel, then
596         ///  the blue, then the green, and then next is the red channel for the
597         ///  pixel to the right of the first pixel.
598         bytes rgbData;
599 
600         /// @dev The title of this square, at most 64 bytes,
601         string title;
602 
603         /// @dev The URL of this square, at most 100 bytes, or empty string
604         string href;
605     }
606 
607     /// @notice All the Su Squares that ever exist or will exist. Each Su Square
608     ///  represents a square on our webpage in a 100x100 grid. The squares are
609     ///  arranged in left-to-right, top-to-bottom order. In other words, normal
610     ///  English reading order. So suSquares[1] is the top-left location and
611     ///  suSquares[100] is the top-right location. And suSquares[101] is
612     ///  directly below suSquares[1].
613     /// @dev There is no suSquares[0] -- that is an unused array index.
614     SuSquare[10001] public suSquares;
615 
616     /// @notice Update the contents of your square, the first 3 personalizations
617     ///  for a square are free then cost 10 finney (0.01 ether) each
618     /// @param _squareId The top-left is 1, to its right is 2, ..., top-right is
619     ///  100 and then 101 is below 1... the last one at bottom-right is 10000
620     /// @param _squareId A 10x10 image for your square, in 8-bit RGB words
621     ///  ordered like the squares are ordered. See Imagemagick's command
622     ///  convert -size 10x10 -depth 8 in.rgb out.png
623     /// @param _title A description of your square (max 64 bytes UTF-8)
624     /// @param _href A hyperlink for your square (max 96 bytes)
625     function personalizeSquare(
626         uint256 _squareId,
627         bytes _rgbData,
628         string _title,
629         string _href
630     )
631         external
632         onlyOwnerOf(_squareId)
633         payable
634     {
635         require(bytes(_title).length <= 64);
636         require(bytes(_href).length <= 96);
637         require(_rgbData.length == 300);
638         suSquares[_squareId].version++;
639         suSquares[_squareId].rgbData = _rgbData;
640         suSquares[_squareId].title = _title;
641         suSquares[_squareId].href = _href;
642         if (suSquares[_squareId].version > 3) {
643             require(msg.value == 10 finney);
644         }
645         emit Personalized(_squareId);
646     }
647 }
648 
649 /* SuPromo.sol ****************************************************************/
650 
651 /// @title A limited pre-sale and promotional giveaway.
652 /// @author William Entriken (https://phor.net)
653 /// @dev See SuMain contract documentation for detail on how contracts interact.
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
678 /// @dev See SuMain contract documentation for detail on how contracts interact.
679 contract SuVending is SuNFT {
680     uint256 constant SALE_PRICE = 500 finney; // 0.5 ether
681 
682     /// @notice The price is always 0.5 ether, and you can buy any available square
683     ///  Be sure you are calling this from a regular account (not a smart contract)
684     ///  or if you are calling from a smart contract, make sure it can use
685     ///  ERC-721 non-fungible tokens
686     function purchase(uint256 _nftId)
687         external
688         payable
689         mustBeValidToken(_nftId)
690         mustBeOwnedByThisContract(_nftId)
691     {
692         require(msg.value == SALE_PRICE);
693         _transfer(_nftId, msg.sender);
694     }
695 }
696 
697 /* SuMain.sol *****************************************************************/
698 
699 /// @title The features that deed owners can use
700 /// @author William Entriken (https://phor.net)
701 /// @dev See SuMain contract documentation for detail on how contracts interact.
702 contract SuMain is AccessControl, SuNFT, SuOperation, SuVending, SuPromo {
703     function SuMain() public {
704     }
705 }