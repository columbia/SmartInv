1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity ^0.8.13;
3 
4 // ████████████████████████████████████████████████████████████████████████████████
5 // ████████████████████████████████████████████████████████████████████████████████
6 // ████████████████████████████████████████████████████████████████████████████████
7 // ████████████████████████████████████████████████████████████████████████████████
8 // ████████████████████████████████████████████████████████████████████████████████
9 // ████████████████████████████████████████████████████████████████████████████████
10 // ████████████████████████████████▓▀██████████████████████████████████████████████
11 // ██████████████████████████████████  ╙███████████████████████████████████████████
12 // ███████████████████████████████████    ╙████████████████████████████████████████
13 // ████████████████████████████████████      ╙▀████████████████████████████████████
14 // ████████████████████████████████████▌        ╙▀█████████████████████████████████
15 // ████████████████████████████████████▌           ╙███████████████████████████████
16 // ████████████████████████████████████▌            ███████████████████████████████
17 // ████████████████████████████████████▌         ▄█████████████████████████████████
18 // ████████████████████████████████████       ▄████████████████████████████████████
19 // ███████████████████████████████████▀   ,▄███████████████████████████████████████
20 // ██████████████████████████████████▀ ,▄██████████████████████████████████████████
21 // █████████████████████████████████▄▓█████████████████████████████████████████████
22 // ████████████████████████████████████████████████████████████████████████████████
23 // ████████████████████████████████████████████████████████████████████████████████
24 // ████████████████████████████████████████████████████████████████████████████████
25 // ████████████████████████████████████████████████████████████████████████████████
26 // ████████████████████████████████████████████████████████████████████████████████
27 // ████████████████████████████████████████████████████████████████████████████████
28 
29 /// @notice Modern, minimalist, and gas efficient ERC-721 implementation.
30 /// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/tokens/ERC721.sol)
31 abstract contract ERC721 {
32     /*//////////////////////////////////////////////////////////////
33                                  EVENTS
34     //////////////////////////////////////////////////////////////*/
35 
36     event Transfer(address indexed from, address indexed to, uint256 indexed id);
37 
38     event Approval(address indexed owner, address indexed spender, uint256 indexed id);
39 
40     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
41 
42     /*//////////////////////////////////////////////////////////////
43                          METADATA STORAGE/LOGIC
44     //////////////////////////////////////////////////////////////*/
45 
46     string public name;
47 
48     string public symbol;
49 
50     function tokenURI(uint256 id) public view virtual returns (string memory);
51 
52     /*//////////////////////////////////////////////////////////////
53                       ERC721 BALANCE/OWNER STORAGE
54     //////////////////////////////////////////////////////////////*/
55 
56     mapping(uint256 => address) internal _ownerOf;
57 
58     mapping(address => uint256) internal _balanceOf;
59 
60     function ownerOf(uint256 id) public view virtual returns (address owner) {
61         require((owner = _ownerOf[id]) != address(0), "NOT_MINTED");
62     }
63 
64     function balanceOf(address owner) public view virtual returns (uint256) {
65         require(owner != address(0), "ZERO_ADDRESS");
66 
67         return _balanceOf[owner];
68     }
69 
70     /*//////////////////////////////////////////////////////////////
71                          ERC721 APPROVAL STORAGE
72     //////////////////////////////////////////////////////////////*/
73 
74     mapping(uint256 => address) public getApproved;
75 
76     mapping(address => mapping(address => bool)) public isApprovedForAll;
77 
78     /*//////////////////////////////////////////////////////////////
79                                CONSTRUCTOR
80     //////////////////////////////////////////////////////////////*/
81 
82     constructor(string memory _name, string memory _symbol) {
83         name = _name;
84         symbol = _symbol;
85     }
86 
87     /*//////////////////////////////////////////////////////////////
88                               ERC721 LOGIC
89     //////////////////////////////////////////////////////////////*/
90 
91     function approve(address spender, uint256 id) public virtual {
92         address owner = _ownerOf[id];
93 
94         require(msg.sender == owner || isApprovedForAll[owner][msg.sender], "NOT_AUTHORIZED");
95 
96         getApproved[id] = spender;
97 
98         emit Approval(owner, spender, id);
99     }
100 
101     function setApprovalForAll(address operator, bool approved) public virtual {
102         isApprovedForAll[msg.sender][operator] = approved;
103 
104         emit ApprovalForAll(msg.sender, operator, approved);
105     }
106 
107     function transferFrom(
108         address from,
109         address to,
110         uint256 id
111     ) public virtual {
112         require(from == _ownerOf[id], "WRONG_FROM");
113 
114         require(to != address(0), "INVALID_RECIPIENT");
115 
116         require(
117             msg.sender == from || isApprovedForAll[from][msg.sender] || msg.sender == getApproved[id],
118             "NOT_AUTHORIZED"
119         );
120 
121         // Underflow of the sender's balance is impossible because we check for
122         // ownership above and the recipient's balance can't realistically overflow.
123         unchecked {
124             _balanceOf[from]--;
125 
126             _balanceOf[to]++;
127         }
128 
129         _ownerOf[id] = to;
130 
131         delete getApproved[id];
132 
133         emit Transfer(from, to, id);
134     }
135 
136     function safeTransferFrom(
137         address from,
138         address to,
139         uint256 id
140     ) public virtual {
141         transferFrom(from, to, id);
142 
143         require(
144             to.code.length == 0 ||
145                 ERC721TokenReceiver(to).onERC721Received(msg.sender, from, id, "") ==
146                 ERC721TokenReceiver.onERC721Received.selector,
147             "UNSAFE_RECIPIENT"
148         );
149     }
150 
151     function safeTransferFrom(
152         address from,
153         address to,
154         uint256 id,
155         bytes calldata data
156     ) public virtual {
157         transferFrom(from, to, id);
158 
159         require(
160             to.code.length == 0 ||
161                 ERC721TokenReceiver(to).onERC721Received(msg.sender, from, id, data) ==
162                 ERC721TokenReceiver.onERC721Received.selector,
163             "UNSAFE_RECIPIENT"
164         );
165     }
166 
167     /*//////////////////////////////////////////////////////////////
168                               ERC165 LOGIC
169     //////////////////////////////////////////////////////////////*/
170 
171     function supportsInterface(bytes4 interfaceId) public view virtual returns (bool) {
172         return
173             interfaceId == 0x01ffc9a7 || // ERC165 Interface ID for ERC165
174             interfaceId == 0x80ac58cd || // ERC165 Interface ID for ERC721
175             interfaceId == 0x5b5e139f; // ERC165 Interface ID for ERC721Metadata
176     }
177 
178     /*//////////////////////////////////////////////////////////////
179                         INTERNAL MINT/BURN LOGIC
180     //////////////////////////////////////////////////////////////*/
181 
182     function _mint(address to, uint256 id) internal virtual {
183         require(to != address(0), "INVALID_RECIPIENT");
184 
185         require(_ownerOf[id] == address(0), "ALREADY_MINTED");
186 
187         // Counter overflow is incredibly unrealistic.
188         unchecked {
189             _balanceOf[to]++;
190         }
191 
192         _ownerOf[id] = to;
193 
194         emit Transfer(address(0), to, id);
195     }
196 
197     function _burn(uint256 id) internal virtual {
198         address owner = _ownerOf[id];
199 
200         require(owner != address(0), "NOT_MINTED");
201 
202         // Ownership check above ensures no underflow.
203         unchecked {
204             _balanceOf[owner]--;
205         }
206 
207         delete _ownerOf[id];
208 
209         delete getApproved[id];
210 
211         emit Transfer(owner, address(0), id);
212     }
213 
214     /*//////////////////////////////////////////////////////////////
215                         INTERNAL SAFE MINT LOGIC
216     //////////////////////////////////////////////////////////////*/
217 
218     function _safeMint(address to, uint256 id) internal virtual {
219         _mint(to, id);
220 
221         require(
222             to.code.length == 0 ||
223                 ERC721TokenReceiver(to).onERC721Received(msg.sender, address(0), id, "") ==
224                 ERC721TokenReceiver.onERC721Received.selector,
225             "UNSAFE_RECIPIENT"
226         );
227     }
228 
229     function _safeMint(
230         address to,
231         uint256 id,
232         bytes memory data
233     ) internal virtual {
234         _mint(to, id);
235 
236         require(
237             to.code.length == 0 ||
238                 ERC721TokenReceiver(to).onERC721Received(msg.sender, address(0), id, data) ==
239                 ERC721TokenReceiver.onERC721Received.selector,
240             "UNSAFE_RECIPIENT"
241         );
242     }
243 }
244 
245 /// @notice A generic interface for a contract which properly accepts ERC721 tokens.
246 /// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/tokens/ERC721.sol)
247 abstract contract ERC721TokenReceiver {
248     function onERC721Received(
249         address,
250         address,
251         uint256,
252         bytes calldata
253     ) external virtual returns (bytes4) {
254         return ERC721TokenReceiver.onERC721Received.selector;
255     }
256 }
257 
258 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
259 
260 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
261 
262 /**
263  * @dev Provides information about the current execution context, including the
264  * sender of the transaction and its data. While these are generally available
265  * via msg.sender and msg.data, they should not be accessed in such a direct
266  * manner, since when dealing with meta-transactions the account sending and
267  * paying for execution may not be the actual sender (as far as an application
268  * is concerned).
269  *
270  * This contract is only required for intermediate, library-like contracts.
271  */
272 abstract contract Context {
273     function _msgSender() internal view virtual returns (address) {
274         return msg.sender;
275     }
276 
277     function _msgData() internal view virtual returns (bytes calldata) {
278         return msg.data;
279     }
280 }
281 
282 /**
283  * @dev Contract module which provides a basic access control mechanism, where
284  * there is an account (an owner) that can be granted exclusive access to
285  * specific functions.
286  *
287  * By default, the owner account will be the one that deploys the contract. This
288  * can later be changed with {transferOwnership}.
289  *
290  * This module is used through inheritance. It will make available the modifier
291  * `onlyOwner`, which can be applied to your functions to restrict their use to
292  * the owner.
293  */
294 abstract contract Ownable is Context {
295     address private _owner;
296 
297     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
298 
299     /**
300      * @dev Initializes the contract setting the deployer as the initial owner.
301      */
302     constructor() {
303         _transferOwnership(_msgSender());
304     }
305 
306     /**
307      * @dev Throws if called by any account other than the owner.
308      */
309     modifier onlyOwner() {
310         _checkOwner();
311         _;
312     }
313 
314     /**
315      * @dev Returns the address of the current owner.
316      */
317     function owner() public view virtual returns (address) {
318         return _owner;
319     }
320 
321     /**
322      * @dev Throws if the sender is not the owner.
323      */
324     function _checkOwner() internal view virtual {
325         require(owner() == _msgSender(), "Ownable: caller is not the owner");
326     }
327 
328     /**
329      * @dev Leaves the contract without owner. It will not be possible to call
330      * `onlyOwner` functions anymore. Can only be called by the current owner.
331      *
332      * NOTE: Renouncing ownership will leave the contract without an owner,
333      * thereby removing any functionality that is only available to the owner.
334      */
335     function renounceOwnership() public virtual onlyOwner {
336         _transferOwnership(address(0));
337     }
338 
339     /**
340      * @dev Transfers ownership of the contract to a new account (`newOwner`).
341      * Can only be called by the current owner.
342      */
343     function transferOwnership(address newOwner) public virtual onlyOwner {
344         require(newOwner != address(0), "Ownable: new owner is the zero address");
345         _transferOwnership(newOwner);
346     }
347 
348     /**
349      * @dev Transfers ownership of the contract to a new account (`newOwner`).
350      * Internal function without access restriction.
351      */
352     function _transferOwnership(address newOwner) internal virtual {
353         address oldOwner = _owner;
354         _owner = newOwner;
355         emit OwnershipTransferred(oldOwner, newOwner);
356     }
357 }
358 
359 contract Pass is ERC721, Ownable {
360     //////////////////////////////////////////////////////////////////////
361     // ERRORS
362     //////////////////////////////////////////////////////////////////////
363     error DoesNotExist(); // Custom error for when a token does not exist
364     error Unauthorized(); // Custom error for unauthorized access
365     error AlreadyTaken(); // Custom error for when a token is already taken
366     error AddressAlreadyClaimed(); // Custom error for when an address has already claimed a token
367     error AlreadyClaimed(); // Custom error for when a token has already been claimed
368     error InvalidLength(); // Custom error for when a username is an invalid length
369     error InvalidFirstOrLastCharacter(); // Custom error for when a username starts or ends with an underscore
370     error InvalidCharacter(); // Custom error for when a username contains an invalid character
371 
372     event DefaultUsernameSet(address indexed user, uint256 indexed tokenId); // Event emitted when a user sets their default username
373     event PassMinted(address indexed user, uint256 indexed passId, string username, PassType passType, address invitedBy); // Event emitted when a user claims a token
374 
375     //////////////////////////////////////////////////////////////////////
376     // TYPES
377     //////////////////////////////////////////////////////////////////////
378     enum PassType {
379         // Custom enum to represent the type of token
380         GENESIS, // The first token
381         CURATED, // A token invited by a curated user
382         OPEN // A token claimed during open claim period
383     }
384 
385     //////////////////////////////////////////////////////////////////////
386     // CONSTANTS
387     //////////////////////////////////////////////////////////////////////
388     address public immutable genesis; // Address of the user who created the contract
389     string internal constant TABLE_ENCODE = // Lookup table for base64 encoding
390         "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"; 
391     bytes internal constant TABLE_DECODE = // Lookup table for base64 decoding
392         hex"0000000000000000000000000000000000000000000000000000000000000000"
393         hex"00000000000000000000003e0000003f3435363738393a3b3c3d000000000000"
394         hex"00000102030405060708090a0b0c0d0e0f101112131415161718190000000000"
395         hex"001a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132330000000000";
396 
397     //////////////////////////////////////////////////////////////////////
398     // VARIABLES
399     //////////////////////////////////////////////////////////////////////
400     mapping(uint256 => string) public usernames; // Mapping of token IDs to usernames
401     mapping(address => address) public invitedBy; // Mapping of addresses to the address of the user who invited them to claim a token
402     mapping(address => uint256) public defaultUsername; // Mapping of addresses to the ID of the token associated with their default username
403     mapping(address => bool) public claimed; // Mapping of addresses to a boolean indicating whether or not they have claimed a token
404     mapping(uint => PassType) public passType; // Mapping of token IDs to their respective PassType
405     bool public open; // Boolean indicating whether or not the contract is currently allowing open claims
406 
407     //////////////////////////////////////////////////////////////////////
408     // CONSTRUCTOR
409     //////////////////////////////////////////////////////////////////////
410     /**
411     * @dev Constructor function for the Pass contract.
412     * @param name Name of the ERC721 token.
413     * @param symbol Symbol of the ERC721 token.
414     * @param _genesis Address of the genesis user who can mint GENESIS passes.
415     */
416     constructor(
417         string memory name,
418         string memory symbol,
419         address _genesis
420     ) ERC721(name, symbol) { // Call the constructor of the parent contract ERC721
421         genesis = _genesis; // Set the address of the user who created the contract
422         invitedBy[genesis] = genesis; // Set the genesis user as the inviter of the genesis token
423         transferOwnership(msg.sender); // Transfer ownership of the contract to the user who deployed it
424     }
425 
426     //////////////////////////////////////////////////////////////////////
427     // ADMIN FUNCTIONS
428     //////////////////////////////////////////////////////////////////////
429     /**
430     * @dev Function to change the open claim status.
431     * @param _open Boolean indicating whether or not the open claim feature is enabled.
432     */
433     function changeOpenClaimStatus(bool _open) public onlyOwner { // Function to change the status of open claims
434         open = _open; // Set the open status of claims to the given value
435     }
436 
437     //////////////////////////////////////////////////////////////////////
438     // USERNAME FUNCTIONS
439     //////////////////////////////////////////////////////////////////////
440     /**
441     * @dev Function to set the default username for a user.
442     * @param id ID of the token to set the default username for.
443     */
444     function setDefaultUsername(uint256 id) public { // Function to set the default username associated with a given token ID
445         if (_ownerOf[id] != msg.sender) revert Unauthorized(); // Check if the caller of the function is the owner of the token
446         defaultUsername[msg.sender] = id; // Set the default username of the caller to the given ID
447 
448         emit DefaultUsernameSet(msg.sender, id);
449     }
450 
451     /**
452     * @dev Function to validate a username.
453     * @param username Username to validate.
454     */
455     function validateUsername(string memory username) public pure {
456         // make it so first or last character cant be underscore
457         uint256 usernameLength = bytes(username).length;
458 
459         if (usernameLength < 3 || usernameLength > 15) revert InvalidLength();
460         bytes1 firstByte = bytes(username)[0];
461         bytes1 lastByte = bytes(username)[usernameLength - 1];
462         if (firstByte == "_" || lastByte == "_")
463             revert InvalidFirstOrLastCharacter();
464 
465         for (uint256 i = 0; i < usernameLength; ) {
466             bytes1 char = bytes(username)[i];
467             if (
468                 !(char >= 0x30 && char <= 0x39) && // 9-0
469                 !(char >= 0x61 && char <= 0x7A) && // a-z
470                 !(char == 0x5F) // _ underscore
471             ) {
472                 revert InvalidCharacter();
473             }
474             unchecked {
475                 ++i;
476             }
477         }
478     }
479 
480     //////////////////////////////////////////////////////////////////////
481     // CLAIM FUNCTIONS
482     //////////////////////////////////////////////////////////////////////
483     /**
484     * @dev Function to check the eligibility of a user to claim a token.
485     * @param id ID of the token to check.
486     * @param _callingOpenClaim Boolean indicating whether or not the open claim feature is enabled.
487     */
488     function checkEligibility(uint id, bool _callingOpenClaim) internal view { // Function to check eligibility to claim a token
489         if (_callingOpenClaim)
490             if (!open) revert Unauthorized(); // Check that open claims are currently allowed
491         if (claimed[msg.sender]) revert AddressAlreadyClaimed(); // Check that the caller has not already claimed a token
492         if (_ownerOf[id] != address(0)) revert AlreadyTaken(); // Check that the token has not already been claimed
493     }
494 
495     /**
496     * @dev Function for users to claim a token using the open claim feature.
497     * @param _username Username to claim the token with.
498     */
499     function openClaim(string memory _username) public { // Function to claim a token during the open claim period
500         uint256 id = uint(keccak256(abi.encodePacked(_username))); // Generate a unique ID for the token based on the username
501         checkEligibility(id, true); // Check the eligibility to claim the token
502         validateUsername(_username); // Validate the given username
503 
504         mint(id, _username, address(this)); // Mint the token with the given ID, username, and no inviter
505     }
506 
507     /**
508     * @dev Verify a signature and return the address of who signed this message.
509     * @param _address The address being signed.
510     * @param _signature The signature as a byte array.
511     * @return An address indicating who signed the message.
512     */
513     function verifySignature(address _address, bytes memory _signature) public pure returns (address) {
514         // Make sure the signature has the correct length
515         require(_signature.length == 65, "Invalid signature length");
516         // Get the hash of the message being signed
517         bytes32 messageHash = getMessageHash(_address);
518 
519         bytes32 r;
520         bytes32 s;
521         uint8 v;
522         assembly {
523             // first 32 bytes, after the length prefix
524             r := mload(add(_signature, 32))
525             // second 32 bytes
526             s := mload(add(_signature, 64))
527             // final byte (first byte of the next 32 bytes)
528             v := byte(0, mload(add(_signature, 96)))
529         }
530 
531         // Recover the address that signed the message and check if it matches the calling address
532         return recoverSigner(messageHash, v, r, s);
533     }
534 
535     /**
536     * @dev Get the hash of an address.
537     * @param _address The address to hash.
538     * @return The hash of the address.
539     */
540     function getMessageHash(address _address) public pure returns (bytes32) {
541         // Hash the address using keccak256
542         return keccak256(abi.encodePacked(_address));
543     }
544 
545     /**
546     * @dev Recover the address that signed a message.
547     * @param _messageHash The hash of the signed message.
548     * @param _v The recovery identifier (0 or 1).
549     * @param _r The x-coordinate of the point on the elliptic curve that represents the signature.
550     * @param _s The signature value.
551     * @return The address of the signer.
552     */
553     function recoverSigner(bytes32 _messageHash, uint8 _v, bytes32 _r, bytes32 _s) public pure returns (address) {
554         // Add prefix to message hash as per EIP-191 standard
555         bytes32 prefixedHash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _messageHash));
556         // Recover the address that signed the message using ecrecover
557         return ecrecover(prefixedHash, _v, _r, _s);
558     }
559 
560     /**
561     * @dev Function for invited users to claim a token.
562     * @param _username Username to claim the token with.
563     * @param _signature Value of the signature.
564     */
565     function claimInvitation(
566         string memory _username,
567         bytes memory _signature
568     ) public { // Function to claim a token using an invitation
569         address signer = verifySignature(msg.sender, _signature);
570         if (invitedBy[signer] == address(0)) revert Unauthorized(); // Check that the signer is a valid inviter
571         uint256 id = uint(keccak256(abi.encodePacked(_username))); // Generate a unique ID for the token based on the username
572         checkEligibility(id, false); // Check the eligibility to claim the token
573         validateUsername(_username); // Validate the given username
574         mint(id, _username, signer); // Mint the token with the given ID, username, and inviter
575     }
576 
577     /**
578     * @dev Function to mint a token.
579     * @param id ID of the token to mint.
580     * @param _username Username to mint the token with.
581     * @param _invitedBy Address of the user who invited the token owner.
582     */
583     function mint(
584         uint id,
585         string memory _username,
586         address _invitedBy
587     ) private { // Function to mint a new token
588         _mint(msg.sender, id); // Mint the token to the caller of the function
589         usernames[id] = _username; // Set the username associated with the token ID
590         defaultUsername[msg.sender] = id; // Set the default username of the caller to the given ID
591         claimed[msg.sender] = true; // Set the claimed status of the caller to true
592         invitedBy[msg.sender] = _invitedBy; // Set the inviter of the caller to the given address
593         if (_invitedBy == genesis) { // If the inviter is the genesis address, set the pass type to GENESIS
594             passType[id] = PassType.GENESIS;
595         } else if (_invitedBy != address(this) || _invitedBy != address(0)) { // If the inviter is not the genesis address and not zero, set the pass type to CURATED
596             passType[id] = PassType.CURATED;
597         } else { // Otherwise, set the pass type to OPEN
598             passType[id] = PassType.OPEN;
599         }
600 
601         emit PassMinted(msg.sender, id, _username, passType[id], _invitedBy); // Emit the PassClaimed event
602     }
603 
604     //////////////////////////////////////////////////////////////////////
605     // METADATA FUNCTIONS
606     //////////////////////////////////////////////////////////////////////
607     /**
608     * @dev Function to get the URI of a token.
609     * @param id ID of the token to get the URI of.
610     * @return The URI of the token.
611     */
612     function tokenURI(uint256 id) public view override returns (string memory) { // Function to get the metadata URI for a token
613         address owner = _ownerOf[id]; // Get the owner of the token
614         if (owner == address(0)) revert DoesNotExist(); // Check that the token exists
615         if (passType[id] == PassType.GENESIS) { // If the pass type is GENESIS, set the background color to #FF4E00 and the font color to #000000
616             return nftMetadata(usernames[id], "GENESIS", "#FF4F00", "#000000");
617         }
618         if (passType[id] == PassType.CURATED) { // If the pass type is CURATED, set the background color to #000000 and the font color to #FFFFFF
619             return nftMetadata(usernames[id], "CURATED", "#000000", "#FFFFFF");
620         }
621         return nftMetadata(usernames[id], "OPEN", "#FFFFFF", "#000000"); // Otherwise, set the background color to #FFFFFF and the font color to #000000
622     }
623 
624     /**
625     * @dev Function to generate the metadata for a token.
626     * @param username Username of the token.
627     * @param _passType Type of the token.
628     * @param backgroundColor Background color of the token.
629     * @param fontColor Font color of the token.
630     * @return The metadata for the token.
631     */
632     function nftMetadata(
633         string memory username,
634         string memory _passType,
635         string memory backgroundColor,
636         string memory fontColor
637     ) internal pure returns (string memory) { // Function to generate the metadata for a token
638         return
639             string(
640                 abi.encodePacked(
641                     "data:application/json;base64,",
642                     base64Encode(
643                         bytes(
644                             abi.encodePacked(
645                                 '{"name":"',
646                                 username, // Set the name of the token to the given username
647                                 '.glass", "description":"',
648                                 "Glass passes are special assets that signify usernames, ownership, and the power to give others access to join the protocol.",
649                                 '", "image": "',
650                                 svg(username, backgroundColor, fontColor), // Set the image of the token to the SVG generated by the svg() function
651                                 '", "attributes": [',
652                                 '{"trait_type": "Pass Type", "value": "',
653                                 _passType, // Set the pass type attribute to the given pass type
654                                 '"}',
655                                 "]}"
656                             )
657                         )
658                     )
659                 )
660             );
661     }
662 
663     /**
664     * @dev Function to generate the SVG for a token.
665     * @param username Username of the token.
666     * @param backgroundColor Background color of the token.
667     * @param fontColor Font color of the token.
668     * @return The SVG for the token.
669     */
670     function svg(
671         string memory username,
672         string memory backgroundColor,
673         string memory fontColor
674     ) internal pure returns (string memory) { // Function to generate an SVG for a token
675         return
676             string(
677                 abi.encodePacked(
678                     "data:image/svg+xml;base64,",
679                     base64Encode(
680                         bytes(
681                             abi.encodePacked(
682                                 '<svg width="512" height="512" viewBox="0 0 512 512" fill="none" xmlns="http://www.w3.org/2000/svg">',
683                                 '<rect width="512" height="512" fill="',
684                                 backgroundColor, // Set the background color of the SVG to the given color
685                                 '"/>'
686                                 '<path d="M250.3 410C250.3 418.982 246.746 427.113 241 433L268.498 412.982C270.501 411.524 270.501 408.477 268.498 407.018L241 387C246.746 392.887 250.3 401.018 250.3 410Z" fill="',
687                                 fontColor, // Set the font color of the SVG to the given color
688                                 '"/>'
689                                 '<text font-family="sans-serif" font-weight="bold" y="50%" x="50%" dominant-baseline="middle" text-anchor="middle" font-size="40" fill="',
690                                 fontColor, // Set the font color of the text to the given color
691                                 '">',
692                                 username, // Set the text of the SVG to the given username
693                                 "</text>",
694                                 "</svg>"
695                             )
696                         )
697                     )
698                 )
699             );
700     }
701 
702     //////////////////////////////////////////////////////////////////////
703     // UTILITY FUNCTIONS
704     //////////////////////////////////////////////////////////////////////
705     /**
706     * @dev Function to encode bytes as base64.
707     * @param data The bytes to encode.
708     * @return The base64 encoded string.
709     */
710     function base64Encode(
711         bytes memory data
712     ) internal pure returns (string memory) {
713         if (data.length == 0) return "";
714 
715         // load the table into memory
716         string memory table = TABLE_ENCODE;
717 
718         // multiply by 4/3 rounded up
719         uint256 encodedLen = 4 * ((data.length + 2) / 3);
720 
721         // add some extra buffer at the end required for the writing
722         string memory result = new string(encodedLen + 32);
723 
724         assembly {
725             // set the actual output length
726             mstore(result, encodedLen)
727 
728             // prepare the lookup table
729             let tablePtr := add(table, 1)
730 
731             // input ptr
732             let dataPtr := data
733             let endPtr := add(dataPtr, mload(data))
734 
735             // result ptr, jump over length
736             let resultPtr := add(result, 32)
737 
738             // run over the input, 3 bytes at a time
739             for {
740 
741             } lt(dataPtr, endPtr) {
742 
743             } {
744                 // read 3 bytes
745                 dataPtr := add(dataPtr, 3)
746                 let input := mload(dataPtr)
747 
748                 // write 4 characters
749                 mstore8(
750                     resultPtr,
751                     mload(add(tablePtr, and(shr(18, input), 0x3F)))
752                 )
753                 resultPtr := add(resultPtr, 1)
754                 mstore8(
755                     resultPtr,
756                     mload(add(tablePtr, and(shr(12, input), 0x3F)))
757                 )
758                 resultPtr := add(resultPtr, 1)
759                 mstore8(
760                     resultPtr,
761                     mload(add(tablePtr, and(shr(6, input), 0x3F)))
762                 )
763                 resultPtr := add(resultPtr, 1)
764                 mstore8(resultPtr, mload(add(tablePtr, and(input, 0x3F))))
765                 resultPtr := add(resultPtr, 1)
766             }
767 
768             // padding with '='
769             switch mod(mload(data), 3)
770             case 1 {
771                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
772             }
773             case 2 {
774                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
775             }
776         }
777 
778         return result;
779     }
780 }
