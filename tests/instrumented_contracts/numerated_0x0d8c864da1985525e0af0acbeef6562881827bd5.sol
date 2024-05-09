1 pragma solidity >=0.5.6 <0.6.0;
2 
3 /// @title Shared constants used throughout the Cheeze Wizards contracts
4 contract WizardConstants {
5     // Wizards normally have their affinity set when they are first created,
6     // but for example Exclusive Wizards can be created with no set affinity.
7     // In this case the affinity can be set by the owner.
8     uint8 internal constant ELEMENT_NOTSET = 0; //000
9     // A neutral Wizard has no particular strength or weakness with specific
10     // elements.
11     uint8 internal constant ELEMENT_NEUTRAL = 1; //001
12     // The fire, water and wind elements are used both to reflect an affinity
13     // of Elemental Wizards for a specific element, and as the moves a
14     // Wizard can make during a duel.
15     // Note that if these values change then `moveMask` and `moveDelta` in
16     // ThreeAffinityDuelResolver would need to be updated accordingly.
17     uint8 internal constant ELEMENT_FIRE = 2; //010
18     uint8 internal constant ELEMENT_WATER = 3; //011
19     uint8 internal constant ELEMENT_WIND = 4; //100
20     uint8 internal constant MAX_ELEMENT = ELEMENT_WIND;
21 }
22 
23 
24 
25 /// @title ERC165Query example
26 /// @notice see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
27 contract ERC165Query {
28     bytes4 constant _INTERFACE_ID_INVALID = 0xffffffff;
29     bytes4 constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
30 
31     function doesContractImplementInterface(
32         address _contract,
33         bytes4 _interfaceId
34     )
35         internal
36         view
37         returns (bool)
38     {
39         uint256 success;
40         uint256 result;
41 
42         (success, result) = noThrowCall(_contract, _INTERFACE_ID_ERC165);
43         if ((success == 0) || (result == 0)) {
44             return false;
45         }
46 
47         (success, result) = noThrowCall(_contract, _INTERFACE_ID_INVALID);
48         if ((success == 0) || (result != 0)) {
49             return false;
50         }
51 
52         (success, result) = noThrowCall(_contract, _interfaceId);
53         if ((success == 1) && (result == 1)) {
54             return true;
55         }
56         return false;
57     }
58 
59     function noThrowCall(
60         address _contract,
61         bytes4 _interfaceId
62     )
63         internal
64         view
65         returns (
66             uint256 success,
67             uint256 result
68         )
69     {
70         bytes memory encodedParams = abi.encodeWithSelector(_INTERFACE_ID_ERC165, _interfaceId);
71 
72         // solhint-disable-next-line no-inline-assembly
73         assembly { // solium-disable-line security/no-inline-assembly
74             let encodedParams_data := add(0x20, encodedParams)
75             let encodedParams_size := mload(encodedParams)
76 
77             let output := mload(0x40)    // Find empty storage location using "free memory pointer"
78             mstore(output, 0x0)
79 
80             success := staticcall(
81                 30000,                   // 30k gas
82                 _contract,               // To addr
83                 encodedParams_data,
84                 encodedParams_size,
85                 output,
86                 0x20                     // Outputs are 32 bytes long
87             )
88 
89             result := mload(output)      // Load the result
90         }
91     }
92 }
93 
94 
95 
96 
97 
98 
99 
100 
101 /**
102  * @title IERC165
103  * @dev https://eips.ethereum.org/EIPS/eip-165
104  */
105 interface IERC165 {
106     /**
107      * @notice Query if a contract implements an interface
108      * @param interfaceId The interface identifier, as specified in ERC-165
109      * @dev Interface identification is specified in ERC-165. This function
110      * uses less than 30,000 gas.
111      */
112     function supportsInterface(bytes4 interfaceId) external view returns (bool);
113 }
114 
115 
116 /**
117  * @title ERC721 Non-Fungible Token Standard basic interface
118  * @dev see https://eips.ethereum.org/EIPS/eip-721
119  */
120 contract IERC721 is IERC165 {
121     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
122     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
123     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
124 
125     function balanceOf(address owner) public view returns (uint256 balance);
126     function ownerOf(uint256 tokenId) public view returns (address owner);
127 
128     function approve(address to, uint256 tokenId) public;
129     function getApproved(uint256 tokenId) public view returns (address operator);
130 
131     function setApprovalForAll(address operator, bool _approved) public;
132     function isApprovedForAll(address owner, address operator) public view returns (bool);
133 
134     function transferFrom(address from, address to, uint256 tokenId) public;
135     function safeTransferFrom(address from, address to, uint256 tokenId) public;
136 
137     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
138 }
139 
140 
141 
142 /**
143  * @title ERC721 token receiver interface
144  * @dev Interface for any contract that wants to support safeTransfers
145  * from ERC721 asset contracts.
146  */
147 contract IERC721Receiver {
148     /**
149      * @notice Handle the receipt of an NFT
150      * @dev The ERC721 smart contract calls this function on the recipient
151      * after a `safeTransfer`. This function MUST return the function selector,
152      * otherwise the caller will revert the transaction. The selector to be
153      * returned can be obtained as `this.onERC721Received.selector`. This
154      * function MAY throw to revert and reject the transfer.
155      * Note: the ERC721 contract address is always the message sender.
156      * @param operator The address which called `safeTransferFrom` function
157      * @param from The address which previously owned the token
158      * @param tokenId The NFT identifier which is being transferred
159      * @param data Additional data with no specified format
160      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
161      */
162     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
163     public returns (bytes4);
164 }
165 
166 
167 
168 
169 /// @title ERC165Interface
170 /// @dev https://eips.ethereum.org/EIPS/eip-165
171 interface ERC165Interface {
172     /// @notice Query if a contract implements an interface
173     /// @param interfaceId The interface identifier, as specified in ERC-165
174     /// @dev Interface identification is specified in ERC-165. This function
175     ///      uses less than 30,000 gas.
176     function supportsInterface(bytes4 interfaceId) external view returns (bool);
177 }
178 
179 
180 
181 /// Utility library of inline functions on address payables.
182 /// Modified from original by OpenZeppelin.
183 contract Address {
184     /// @notice Returns whether the target address is a contract.
185     /// @dev This function will return false if invoked during the constructor of a contract,
186     /// as the code is not actually created until after the constructor finishes.
187     /// @param account address of the account to check
188     /// @return whether the target address is a contract
189     function isContract(address account) internal view returns (bool) {
190         uint256 size;
191         // XXX Currently there is no better way to check if there is a contract in an address
192         // than to check the size of the code at that address.
193         // See https://ethereum.stackexchange.com/a/14016/36603
194         // for more details about how this works.
195         // TODO Check this again before the Serenity release, because all addresses will be
196         // contracts then.
197         // solhint-disable-next-line no-inline-assembly
198         assembly { size := extcodesize(account) } // solium-disable-line security/no-inline-assembly
199         return size > 0;
200     }
201 }
202 
203 
204 
205 
206 /// @title Wizard Non-Fungible Token
207 /// @notice The basic ERC-721 functionality for storing Cheeze Wizard NFTs.
208 ///     Derived from: https://github.com/OpenZeppelin/openzeppelin-solidity/tree/v2.2.0
209 contract WizardNFT is ERC165Interface, IERC721, WizardConstants, Address {
210 
211     /// @notice Emitted when a wizard token is created.
212     event WizardConjured(uint256 wizardId, uint8 affinity, uint256 innatePower);
213 
214     /// @notice Emitted when a Wizard's affinity is set. This only applies for
215     ///         Exclusive Wizards who can have the ELEMENT_NOT_SET affinity,
216     ///         and should only happen once for each Wizard.
217     event WizardAffinityAssigned(uint256 wizardId, uint8 affinity);
218 
219     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
220     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
221     bytes4 internal constant _ERC721_RECEIVED = 0x150b7a02;
222 
223     /// @dev The base Wizard structure.
224     /// Designed to fit in two words.
225     struct Wizard {
226         // NOTE: Changing the order or meaning of any of these fields requires an update
227         //   to the _createWizard() function which assumes a specific order for these fields.
228         uint8 affinity;
229         uint88 innatePower;
230         address owner;
231         bytes32 metadata;
232     }
233 
234     // Mapping from Wizard ID to Wizard struct
235     mapping (uint256 => Wizard) public wizardsById;
236 
237     // Mapping from Wizard ID to address approved to control them
238     mapping (uint256 => address) private wizardApprovals;
239 
240     // Mapping from owner address to number of owned Wizards
241     mapping (address => uint256) internal ownedWizardsCount;
242 
243     // Mapping from owner to Wizard controllers
244     mapping (address => mapping (address => bool)) private _operatorApprovals;
245 
246     /// @dev 0x80ac58cd ===
247     ///    bytes4(keccak256('balanceOf(address)')) ^
248     ///    bytes4(keccak256('ownerOf(uint256)')) ^
249     ///    bytes4(keccak256('approve(address,uint256)')) ^
250     ///    bytes4(keccak256('getApproved(uint256)')) ^
251     ///    bytes4(keccak256('setApprovalForAll(address,bool)')) ^
252     ///    bytes4(keccak256('isApprovedForAll(address,address)')) ^
253     ///    bytes4(keccak256('transferFrom(address,address,uint256)')) ^
254     ///    bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
255     ///    bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
256     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
257 
258     /// @notice Query if a contract implements an interface
259     /// @param interfaceId The interface identifier, as specified in ERC-165
260     /// @dev Interface identification is specified in ERC-165. This function
261     ///      uses less than 30,000 gas.
262     function supportsInterface(bytes4 interfaceId) public view returns (bool) {
263         return
264             interfaceId == this.supportsInterface.selector || // ERC165
265             interfaceId == _INTERFACE_ID_ERC721; // ERC721
266     }
267 
268     /// @notice Gets the number of Wizards owned by the specified address.
269     /// @param owner Address to query the balance of.
270     /// @return uint256 representing the amount of Wizards owned by the address.
271     function balanceOf(address owner) public view returns (uint256) {
272         require(owner != address(0), "ERC721: balance query for the zero address");
273         return ownedWizardsCount[owner];
274     }
275 
276     /// @notice Gets the owner of the specified Wizard
277     /// @param wizardId ID of the Wizard to query the owner of
278     /// @return address currently marked as the owner of the given Wizard
279     function ownerOf(uint256 wizardId) public view returns (address) {
280         address owner = wizardsById[wizardId].owner;
281         require(owner != address(0), "ERC721: owner query for nonexistent token");
282         return owner;
283     }
284 
285     /// @notice Approves another address to transfer the given Wizard
286     /// The zero address indicates there is no approved address.
287     /// There can only be one approved address per Wizard at a given time.
288     /// Can only be called by the Wizard owner or an approved operator.
289     /// @param to address to be approved for the given Wizard
290     /// @param wizardId ID of the Wizard to be approved
291     function approve(address to, uint256 wizardId) public {
292         address owner = ownerOf(wizardId);
293         require(to != owner, "ERC721: approval to current owner");
294         require(
295             msg.sender == owner || isApprovedForAll(owner, msg.sender),
296             "ERC721: approve caller is not owner nor approved for all"
297         );
298 
299         wizardApprovals[wizardId] = to;
300         emit Approval(owner, to, wizardId);
301     }
302 
303     /// @notice Gets the approved address for a Wizard, or zero if no address set
304     /// Reverts if the Wizard does not exist.
305     /// @param wizardId ID of the Wizard to query the approval of
306     /// @return address currently approved for the given Wizard
307     function getApproved(uint256 wizardId) public view returns (address) {
308         require(_exists(wizardId), "ERC721: approved query for nonexistent token");
309         return wizardApprovals[wizardId];
310     }
311 
312     /// @notice Sets or unsets the approval of a given operator.
313     /// An operator is allowed to transfer all Wizards of the sender on their behalf.
314     /// @param to operator address to set the approval
315     /// @param approved representing the status of the approval to be set
316     function setApprovalForAll(address to, bool approved) public {
317         require(to != msg.sender, "ERC721: approve to caller");
318         _operatorApprovals[msg.sender][to] = approved;
319         emit ApprovalForAll(msg.sender, to, approved);
320     }
321 
322     /// @notice Tells whether an operator is approved by a given owner.
323     /// @param owner owner address which you want to query the approval of
324     /// @param operator operator address which you want to query the approval of
325     /// @return bool whether the given operator is approved by the given owner
326     function isApprovedForAll(address owner, address operator) public view returns (bool) {
327         return _operatorApprovals[owner][operator];
328     }
329 
330     /// @notice Transfers the ownership of a given Wizard to another address.
331     /// Usage of this method is discouraged, use `safeTransferFrom` whenever possible.
332     /// Requires the msg.sender to be the owner, approved, or operator.
333     /// @param from current owner of the Wizard.
334     /// @param to address to receive the ownership of the given Wizard.
335     /// @param wizardId ID of the Wizard to be transferred.
336     function transferFrom(address from, address to, uint256 wizardId) public {
337         require(_isApprovedOrOwner(msg.sender, wizardId), "ERC721: transfer caller is not owner nor approved");
338 
339         _transferFrom(from, to, wizardId);
340     }
341 
342     /// @notice Safely transfers the ownership of a given Wizard to another address
343     /// If the target address is a contract, it must implement `onERC721Received`,
344     /// which is called upon a safe transfer, and return the magic value
345     /// `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
346     /// the transfer is reverted.
347     /// Requires the msg.sender to be the owner, approved, or operator.
348     /// @param from current owner of the Wizard.
349     /// @param to address to receive the ownership of the given Wizard.
350     /// @param wizardId ID of the Wizard to be transferred.
351     function safeTransferFrom(address from, address to, uint256 wizardId) public {
352         safeTransferFrom(from, to, wizardId, "");
353     }
354 
355     /// @notice Safely transfers the ownership of a given Wizard to another address
356     /// If the target address is a contract, it must implement `onERC721Received`,
357     /// which is called upon a safe transfer, and return the magic value
358     /// `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
359     /// the transfer is reverted.
360     /// Requires the msg.sender to be the owner, approved, or operator
361     /// @param from current owner of the Wizard.
362     /// @param to address to receive the ownership of the given Wizard.
363     /// @param wizardId ID of the Wizard to be transferred.
364     /// @param _data bytes data to send along with a safe transfer check
365     function safeTransferFrom(address from, address to, uint256 wizardId, bytes memory _data) public {
366         transferFrom(from, to, wizardId);
367         require(_checkOnERC721Received(from, to, wizardId, _data), "ERC721: transfer to non ERC721Receiver implementer");
368     }
369 
370     /// @notice Returns whether the specified Wizard exists.
371     /// @param wizardId ID of the Wizard to query the existence of..
372     /// @return bool whether the Wizard exists.
373     function _exists(uint256 wizardId) internal view returns (bool) {
374         address owner = wizardsById[wizardId].owner;
375         return owner != address(0);
376     }
377 
378     /// @notice Returns whether the given spender can transfer a given Wizard.
379     /// @param spender address of the spender to query
380     /// @param wizardId ID of the Wizard to be transferred
381     /// @return bool whether the msg.sender is approved for the given Wizard,
382     /// is an operator of the owner, or is the owner of the Wizard.
383     function _isApprovedOrOwner(address spender, uint256 wizardId) internal view returns (bool) {
384         require(_exists(wizardId), "ERC721: operator query for nonexistent token");
385         address owner = ownerOf(wizardId);
386         return (spender == owner || getApproved(wizardId) == spender || isApprovedForAll(owner, spender));
387     }
388 
389     /** @dev Internal function to create a new Wizard; reverts if the Wizard ID is taken.
390      *       NOTE: This function heavily depends on the internal format of the Wizard struct
391      *       and should always be reassessed if anything about that structure changes.
392      *  @param wizardId ID of the new Wizard.
393      *  @param owner The address that will own the newly conjured Wizard.
394      *  @param innatePower The power level associated with the new Wizard.
395      *  @param affinity The elemental affinity of the new Wizard.
396      */
397     function _createWizard(uint256 wizardId, address owner, uint88 innatePower, uint8 affinity) internal {
398         require(owner != address(0), "ERC721: mint to the zero address");
399         require(!_exists(wizardId), "ERC721: token already minted");
400         require(wizardId > 0, "No 0 token allowed");
401         require(innatePower > 0, "Wizard power must be non-zero");
402 
403         // Create the Wizard!
404         wizardsById[wizardId] = Wizard({
405             affinity: affinity,
406             innatePower: innatePower,
407             owner: owner,
408             metadata: 0
409         });
410 
411         ownedWizardsCount[owner]++;
412 
413         // Tell the world!
414         emit Transfer(address(0), owner, wizardId);
415         emit WizardConjured(wizardId, affinity, innatePower);
416     }
417 
418     /// @notice Internal function to burn a specific Wizard.
419     /// Reverts if the Wizard does not exist.
420     /// Deprecated, use _burn(uint256) instead.
421     /// @param owner owner of the Wizard to burn.
422     /// @param wizardId ID of the Wizard being burned
423     function _burn(address owner, uint256 wizardId) internal {
424         require(ownerOf(wizardId) == owner, "ERC721: burn of token that is not own");
425 
426         _clearApproval(wizardId);
427 
428         ownedWizardsCount[owner]--;
429         // delete the entire object to recover the most gas
430         delete wizardsById[wizardId];
431 
432         // required for ERC721 compatibility
433         emit Transfer(owner, address(0), wizardId);
434     }
435 
436     /// @notice Internal function to burn a specific Wizard.
437     /// Reverts if the Wizard does not exist.
438     /// @param wizardId ID of the Wizard being burned
439     function _burn(uint256 wizardId) internal {
440         _burn(ownerOf(wizardId), wizardId);
441     }
442 
443     /// @notice Internal function to transfer ownership of a given Wizard to another address.
444     /// As opposed to transferFrom, this imposes no restrictions on msg.sender.
445     /// @param from current owner of the Wizard.
446     /// @param to address to receive the ownership of the given Wizard
447     /// @param wizardId ID of the Wizard to be transferred
448     function _transferFrom(address from, address to, uint256 wizardId) internal {
449         require(ownerOf(wizardId) == from, "ERC721: transfer of token that is not own");
450         require(to != address(0), "ERC721: transfer to the zero address");
451 
452         _clearApproval(wizardId);
453 
454         ownedWizardsCount[from]--;
455         ownedWizardsCount[to]++;
456 
457         wizardsById[wizardId].owner = to;
458 
459         emit Transfer(from, to, wizardId);
460     }
461 
462     /// @notice Internal function to invoke `onERC721Received` on a target address.
463     /// The call is not executed if the target address is not a contract
464     /// @param from address representing the previous owner of the given Wizard
465     /// @param to target address that will receive the Wizards.
466     /// @param wizardId ID of the Wizard to be transferred
467     /// @param _data bytes optional data to send along with the call
468     /// @return bool whether the call correctly returned the expected magic value
469     function _checkOnERC721Received(address from, address to, uint256 wizardId, bytes memory _data)
470         internal returns (bool)
471     {
472         if (!isContract(to)) {
473             return true;
474         }
475 
476         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, wizardId, _data);
477         return (retval == _ERC721_RECEIVED);
478     }
479 
480     /// @notice Private function to clear current approval of a given Wizard.
481     /// @param wizardId ID of the Wizard to be transferred
482     function _clearApproval(uint256 wizardId) private {
483         if (wizardApprovals[wizardId] != address(0)) {
484             wizardApprovals[wizardId] = address(0);
485         }
486     }
487 }
488 
489 
490 
491 
492 
493 contract WizardGuildInterfaceId {
494     bytes4 internal constant _INTERFACE_ID_WIZARDGUILD = 0x41d4d437;
495 }
496 
497 /// @title The public interface of the Wizard Guild
498 /// @notice The methods listed in this interface (including the inherited ERC-721 interface),
499 ///         make up the public interface of the Wizard Guild contract. Any contracts that wish
500 ///         to make use of Cheeze Wizard NFTs (such as Cheeze Wizards Tournaments!) should use
501 ///         these methods to ensure they are working correctly with the base NFTs.
502 contract WizardGuildInterface is IERC721, WizardGuildInterfaceId {
503 
504     /// @notice Returns the information associated with the given Wizard
505     ///         owner - The address that owns this Wizard
506     ///         innatePower - The innate power level of this Wizard, set when minted and entirely
507     ///               immutable
508     ///         affinity - The Elemental Affinity of this Wizard. For most Wizards, this is set
509     ///               when they are minted, but some exclusive Wizards are minted with an affinity
510     ///               of 0 (ELEMENT_NOTSET). A Wizard with an NOTSET affinity should NOT be able
511     ///               to participate in Tournaments. Once the affinity of a Wizard is set to a non-zero
512     ///               value, it can never be changed again.
513     ///         metadata - A 256-bit hash of the Wizard's metadata, which is stored off chain. This
514     ///               contract doesn't specify format of this hash, nor the off-chain storage mechanism
515     ///               but, let's be honest, it's probably an IPFS SHA-256 hash.
516     ///
517     ///         NOTE: Series zero Wizards have one of four Affinities:  Neutral (1), Fire (2), Water (3)
518     ///               or Air (4, sometimes called "Wind" in the code). Future Wizard Series may have
519     ///               additional Affinities, and clients of this API should be prepared for that
520     ///               eventuality.
521     function getWizard(uint256 id) external view returns (address owner, uint88 innatePower, uint8 affinity, bytes32 metadata);
522 
523     /// @notice Sets the affinity for a Wizard that doesn't already have its elemental affinity chosen.
524     ///         Only usable for Exclusive Wizards (all non-Exclusives must have their affinity chosen when
525     ///         conjured.) Even Exclusives can't change their affinity once it's been chosen.
526     ///
527     ///         NOTE: This function can only be called by the series minter, and (therefore) only while the
528     ///         series is open. A Wizard that has no affinity when a series is closed will NEVER have an Affinity.
529     ///         BTW- This implies that a minter is responsible for either never minting ELEMENT_NOTSET
530     ///         Wizards, or having some public mechanism for a Wizard owner to set the Affinity after minting.
531     /// @param wizardId The id of the wizard
532     /// @param newAffinity The new affinity of the wizard
533     function setAffinity(uint256 wizardId, uint8 newAffinity) external;
534 
535     /// @notice A function to be called that conjures a whole bunch of Wizards at once! You know how
536     ///         there's "a pride of lions", "a murder of crows", and "a parliament of owls"? Well, with this
537     ///         here function you can conjure yourself "a stench of Cheeze Wizards"!
538     ///
539     ///         Unsurprisingly, this method can only be called by the registered minter for a Series.
540     /// @param powers the power level of each wizard
541     /// @param affinities the Elements of the wizards to create
542     /// @param owner the address that will own the newly created Wizards
543     function mintWizards(
544         uint88[] calldata powers,
545         uint8[] calldata affinities,
546         address owner
547         ) external returns (uint256[] memory wizardIds);
548 
549     /// @notice A function to be called that conjures a series of Wizards in the reserved ID range.
550     /// @param wizardIds the ID values to use for each Wizard, must be in the reserved range of the current Series
551     /// @param affinities the Elements of the wizards to create
552     /// @param powers the power level of each wizard
553     /// @param owner the address that will own the newly created Wizards
554     function mintReservedWizards(
555         uint256[] calldata wizardIds,
556         uint88[] calldata powers,
557         uint8[] calldata affinities,
558         address owner
559         ) external;
560 
561     /// @notice Sets the metadata values for a list of Wizards. The metadata for a Wizard can only be set once,
562     ///         can only be set by the COO or Minter, and can only be set while the Series is still open. Once
563     ///         a Series is closed, the metadata is locked forever!
564     /// @param wizardIds the ID values of the Wizards to apply metadata changes to.
565     /// @param metadata the raw metadata values for each Wizard. This contract does not define how metadata
566     ///         should be interpreted, but it is likely to be a 256-bit hash of a complete metadata package
567     ///         accessible via IPFS or similar.
568     function setMetadata(uint256[] calldata wizardIds, bytes32[] calldata metadata) external;
569 
570     /// @notice Returns true if the given "spender" address is allowed to manipulate the given token
571     ///         (either because it is the owner of that token, has been given approval to manage that token)
572     function isApprovedOrOwner(address spender, uint256 tokenId) external view returns (bool);
573 
574     /// @notice Verifies that a given signature represents authority to control the given Wizard ID,
575     ///         reverting otherwise. It handles three cases:
576     ///             - The simplest case: The signature was signed with the private key associated with
577     ///               an external address that is the owner of this Wizard.
578     ///             - The signature was generated with the private key associated with an external address
579     ///               that is "approved" for working with this Wizard ID. (See the Wizard Guild and/or
580     ///               the ERC-721 spec for more information on "approval".)
581     ///             - The owner or approval address (as in cases one or two) is a smart contract
582     ///               that conforms to ERC-1654, and accepts the given signature as being valid
583     ///               using its own internal logic.
584     ///
585     ///        NOTE: This function DOES NOT accept a signature created by an address that was given "operator
586     ///               status" (as granted by ERC-721's setApprovalForAll() functionality). Doing so is
587     ///               considered an extreme edge case that can be worked around where necessary.
588     /// @param wizardId The Wizard ID whose control is in question
589     /// @param hash The message hash we are authenticating against
590     /// @param sig the signature data; can be longer than 65 bytes for ERC-1654
591     function verifySignature(uint256 wizardId, bytes32 hash, bytes calldata sig) external view;
592 
593     /// @notice Convenience function that verifies signatures for two wizards using equivalent logic to
594     ///         verifySignature(). Included to save on cross-contract calls in the common case where we
595     ///         are verifying the signatures of two Wizards who wish to enter into a Duel.
596     /// @param wizardId1 The first Wizard ID whose control is in question
597     /// @param wizardId2 The second Wizard ID whose control is in question
598     /// @param hash1 The message hash we are authenticating against for the first Wizard
599     /// @param hash2 The message hash we are authenticating against for the first Wizard
600     /// @param sig1 the signature data corresponding to the first Wizard; can be longer than 65 bytes for ERC-1654
601     /// @param sig2 the signature data corresponding to the second Wizard; can be longer than 65 bytes for ERC-1654
602     function verifySignatures(
603         uint256 wizardId1,
604         uint256 wizardId2,
605         bytes32 hash1,
606         bytes32 hash2,
607         bytes calldata sig1,
608         bytes calldata sig2) external view;
609 }
610 
611 
612 
613 /// @title Contract that manages addresses and access modifiers for certain operations.
614 /// @author Dapper Labs Inc. (https://www.dapperlabs.com)
615 contract AccessControl {
616 
617     /// @dev The address of the master administrator account that has the power to
618     ///      update itself and all of the other administrator addresses.
619     ///      The CEO account is not expected to be used regularly, and is intended to
620     ///      be stored offline (i.e. a hardware device kept in a safe).
621     address public ceoAddress;
622 
623     /// @dev The address of the "day-to-day" operator of various privileged
624     ///      functions inside the smart contract. Although the CEO has the power
625     ///      to replace the COO, the CEO address doesn't actually have the power
626     ///      to do "COO-only" operations. This is to discourage the regular use
627     ///      of the CEO account.
628     address public cooAddress;
629 
630     /// @dev The address that is allowed to move money around. Kept separate from
631     ///      the COO because the COO address typically lives on an internet-connected
632     ///      computer.
633     address payable public cfoAddress;
634 
635     // Events to indicate when access control role addresses are updated.
636     event CEOTransferred(address previousCeo, address newCeo);
637     event COOTransferred(address previousCoo, address newCoo);
638     event CFOTransferred(address previousCfo, address newCfo);
639 
640     /// @dev The AccessControl constructor sets the `ceoAddress` to the sender account. Also
641     ///      initializes the COO and CFO to the passed values (CFO is optional and can be address(0)).
642     /// @param newCooAddress The initial COO address to set
643     /// @param newCfoAddress The initial CFO to set (optional)
644     constructor(address newCooAddress, address payable newCfoAddress) public {
645         _setCeo(msg.sender);
646         setCoo(newCooAddress);
647 
648         if (newCfoAddress != address(0)) {
649             setCfo(newCfoAddress);
650         }
651     }
652 
653     /// @notice Access modifier for CEO-only functionality
654     modifier onlyCEO() {
655         require(msg.sender == ceoAddress, "Only CEO");
656         _;
657     }
658 
659     /// @notice Access modifier for COO-only functionality
660     modifier onlyCOO() {
661         require(msg.sender == cooAddress, "Only COO");
662         _;
663     }
664 
665     /// @notice Access modifier for CFO-only functionality
666     modifier onlyCFO() {
667         require(msg.sender == cfoAddress, "Only CFO");
668         _;
669     }
670 
671     function checkControlAddress(address newController) internal view {
672         require(newController != address(0) && newController != ceoAddress, "Invalid CEO address");
673     }
674 
675     /// @notice Assigns a new address to act as the CEO. Only available to the current CEO.
676     /// @param newCeo The address of the new CEO
677     function setCeo(address newCeo) external onlyCEO {
678         checkControlAddress(newCeo);
679         _setCeo(newCeo);
680     }
681 
682     /// @dev An internal utility function that updates the CEO variable and emits the
683     ///      transfer event. Used from both the public setCeo function and the constructor.
684     function _setCeo(address newCeo) private {
685         emit CEOTransferred(ceoAddress, newCeo);
686         ceoAddress = newCeo;
687     }
688 
689     /// @notice Assigns a new address to act as the COO. Only available to the current CEO.
690     /// @param newCoo The address of the new COO
691     function setCoo(address newCoo) public onlyCEO {
692         checkControlAddress(newCoo);
693         emit COOTransferred(cooAddress, newCoo);
694         cooAddress = newCoo;
695     }
696 
697     /// @notice Assigns a new address to act as the CFO. Only available to the current CEO.
698     /// @param newCfo The address of the new CFO
699     function setCfo(address payable newCfo) public onlyCEO {
700         checkControlAddress(newCfo);
701         emit CFOTransferred(cfoAddress, newCfo);
702         cfoAddress = newCfo;
703     }
704 }
705 
706 
707 
708 
709 /// @title Signature utility library
710 library SigTools {
711 
712     /// @notice Splits a signature into r & s values, and v (the verification value).
713     /// @dev Note: This does not verify the version, but does require signature length = 65
714     /// @param signature the packed signature to be split
715     function _splitSignature(bytes memory signature) internal pure returns (bytes32 r, bytes32 s, uint8 v) {
716         // Check signature length
717         require(signature.length == 65, "Invalid signature length");
718 
719         // We need to unpack the signature, which is given as an array of 65 bytes (like eth.sign)
720         // solium-disable-next-line security/no-inline-assembly
721         assembly {
722             r := mload(add(signature, 32))
723             s := mload(add(signature, 64))
724             v := and(mload(add(signature, 65)), 255)
725         }
726 
727         if (v < 27) {
728             v += 27; // Ethereum versions are 27 or 28 as opposed to 0 or 1 which is submitted by some signing libs
729         }
730 
731         // check for valid version
732         // removed for now, done in another function
733         //require((v == 27 || v == 28), "Invalid signature version");
734 
735         return (r, s, v);
736     }
737 }
738 
739 
740 
741 contract ERC1654 {
742 
743     /// @dev bytes4(keccak256("isValidSignature(bytes32,bytes)")
744     bytes4 public constant ERC1654_VALIDSIGNATURE = 0x1626ba7e;
745 
746     /// @dev Should return whether the signature provided is valid for the provided data
747     /// @param hash 32-byte hash of the data that is signed
748     /// @param _signature Signature byte array associated with _data
749     ///  MUST return the bytes4 magic value 0x1626ba7e when function passes.
750     ///  MUST NOT modify state (using STATICCALL for solc < 0.5, view modifier for solc > 0.5)
751     ///  MUST allow external calls
752     function isValidSignature(
753         bytes32 hash,
754         bytes calldata _signature)
755         external
756         view
757         returns (bytes4);
758 }
759 
760 
761 
762 /// @title The master organization behind all Cheeze Wizardry. The source of all them Wiz.
763 contract WizardGuild is AccessControl, WizardNFT, WizardGuildInterface, ERC165Query {
764 
765     /// @notice Emitted when a new Series is opened or closed.
766     event SeriesOpen(uint64 seriesIndex, uint256 reservedIds);
767     event SeriesClose(uint64 seriesIndex);
768 
769     /// @notice Emitted when metadata is associated with a Wizard
770     event MetadataSet(uint256 indexed wizardId, bytes32 metadata);
771 
772     /// @notice The index of the current Series (zero-based). When no Series is open, this value
773     ///         indicates the index of the _upcoming_ Series. (i.e. it is incremented when the
774     ///         Series is closed. This makes it easier to bootstrap the first Series.)
775     uint64 internal seriesIndex;
776 
777     /// @notice The address which is allowed to mint new Wizards in the current Series. When this
778     ///         is set to address(0), there is no open Series.
779     address internal seriesMinter;
780 
781     /// @notice The index number of the next Wizard to be created (Neutral or Elemental).
782     ///         NOTE: There is a subtle distinction between a Wizard "ID" and a Wizard "index".
783     ///               We use the term "ID" to refer to a value that includes the Series number in the
784     ///               top 64 bits, while the term "index" refers to the Wizard number _within_ its
785     ///               Series. This is especially confusing when talking about Wizards in the first
786     ///               Series (Series 0), because the two values are identical in that case!
787     ///
788     ///               |---------------|--------------------------|
789     ///               |           Wizard ID (256 bits)           |
790     ///               |---------------|--------------------------|
791     ///               |  Series Index |      Wizard Index        |
792     ///               |   (64 bits)   |       (192 bits)         |
793     ///               |---------------|--------------------------|
794     uint256 internal nextWizardIndex;
795 
796     function getNextWizardIndex() external view returns (uint256) {
797         return nextWizardIndex;
798     }
799 
800     // NOTE: uint256(-1) maps to a value with all bits set, both the << and >> operators will fill
801     // in with zeros when acting on an unsigned value. So, "uint256(-1) << 192" resolves to "a bunch
802     /// of ones, followed by 192 zeros"
803     uint256 internal constant SERIES_OFFSET = 192;
804     uint256 internal constant SERIES_MASK = uint256(-1) << SERIES_OFFSET;
805     uint256 internal constant INDEX_MASK = uint256(-1) >> 64;
806 
807     // The ERC1654 function selector value
808     bytes4 internal constant ERC1654_VALIDSIGNATURE = 0x1626ba7e;
809 
810     /// @notice The Guild constructor.
811     /// @param _cooAddress The COO has the ability to create new Series and to update
812     ///         the metadata on the currently open Series (if any). It has no other special
813     ///         abilities, and (in particular), ALL Wizards in a closed series can never be
814     ///         modified or deleted. If the CEO and COO values are ever set to invalid addresses
815     ///        (such as address(1)), then no new Series can ever be created, either.
816     constructor(address _cooAddress) public AccessControl(_cooAddress, address(0)) {
817     }
818 
819     /// @notice Require that a Tournament Series is currently open. For example closing
820     ///         a Series does not make sense if none is open.
821     /// @dev While in other contracts we use separate checking functions to avoid having the same
822     ///      string inlined in multiple places, given this modifier is scarcely used it doesn't seem
823     ///      worth the per-call gas cost here.
824     modifier duringSeries() {
825         require(seriesMinter != address(0), "No series is currently open");
826         _;
827     }
828 
829     /// @notice Require that the caller is the minter of the current series. This implicitely
830     ///         requires that a Series is open, or the minter address would be invalid (can never
831     ///         be matched).
832     /// @dev While in other contracts we use separate checking functions to avoid having the same
833     ///      string inlined in multiple places, given this modifier is scarcely used it doesn't seem
834     ///      worth the per-call gas cost here.
835     modifier onlyMinter() {
836         require(msg.sender == seriesMinter, "Only callable by minter");
837         _;
838     }
839 
840     /// @notice Open a new Series of Cheeze Wizards! Can only be called by the COO when no Series is open.
841     /// @param minter The address which is allowed to mint Wizards in this series. This contract does not
842     ///         assume that the minter is a smart contract, but it will presumably be in the vast majority
843     ///         of the cases. A minter has absolute control over the creation of new Wizards in an open
844     ///         Series, but CAN NOT manipulate a Series after it has been closed, and CAN NOT manipulate
845     ///         any Wizards that don't belong to its own Series. (Even if the same minting address is used
846     ///         for multiple Series, the Minter only has power over the currently open Series.)
847     /// @param reservedIds The number of IDs (from 1 to reservedIds, inclusive) that are reserved for minting
848     ///         reserved Wizards. (We use the term "reserved" here, instead of Exclusive, because there
849     ///         are times -- such as during the importation of the Presale -- when we need to reserve a
850     ///         block of IDs for Wizards that aren't what a user would think of as "exclusive". In Series
851     ///         0, the reserved IDs will include all Exclusive Wizards and Presale Wizards. In other Series
852     ///         it might also be the case that the set of "reserved IDs" doesn't exactly match the set of
853     ///         "exclusive" IDs.)
854     function openSeries(address minter, uint256 reservedIds) external onlyCOO returns (uint64 seriesId) {
855         require(seriesMinter == address(0), "A series is already open");
856         require(minter != address(0), "Minter address cannot be 0");
857 
858         if (seriesIndex == 0) {
859             // The last wizard sold in the unpasteurized Tournament at the time the Presale contract
860             // was destroyed is 6133.
861             //
862             // The unpasteurized Tournament contract is the Tournament contract that doesn't have the
863             // "Same Wizard" check in the resolveTimedOutDuel function.
864 
865             // The wizards, which were minted in the unpasteurized Tournament before the Presale contract
866             // was destroyed, will be minted again in the new Tournament contract with their ID reserved.
867             //
868             // So the reason the reservedIds is hardcoded here is to ensure:
869             // 1) The next Wizard minted will have its ID continued from this above wizard ID.
870             // 2) The Presale wizards and some wizards minted in the unpasteurized Tournament contract,
871             //    can be minted in this contract with their ID reserved.
872             require(reservedIds == 6133, "Invalid reservedIds for 1st series");
873         } else {
874             require(reservedIds < 1 << 192, "Invalid reservedIds");
875         }
876 
877         // NOTE: The seriesIndex is updated when the Series is _closed_, not when it's opened.
878         //  (The first Series is Series #0.) So in this function, we just leave the seriesIndex alone.
879 
880         seriesMinter = minter;
881         nextWizardIndex = reservedIds + 1;
882 
883         emit SeriesOpen(seriesIndex, reservedIds);
884 
885         return seriesIndex;
886     }
887 
888     /// @notice Closes the current Wizard Series. Once a Series has been closed, it is forever sealed and
889     ///         no more Wizards in that Series can ever be minted! Can only be called by the COO when a Series
890     ///         is open.
891     ///
892     ///    NOTE: A series can be closed by the COO or the Minter. (It's assumed that some minters will
893     ///          know when they are done, and others will need to be shut off manually by the COO.)
894     function closeSeries() external duringSeries {
895         require(
896             msg.sender == seriesMinter || msg.sender == cooAddress,
897             "Only Minter or COO can close a Series");
898 
899         seriesMinter = address(0);
900         emit SeriesClose(seriesIndex);
901 
902         // Set up the next series.
903         seriesIndex += 1;
904         nextWizardIndex = 0;
905     }
906 
907     /// @notice ERC-165 Query Function.
908     function supportsInterface(bytes4 interfaceId) public view returns (bool) {
909         return interfaceId == _INTERFACE_ID_WIZARDGUILD || super.supportsInterface(interfaceId);
910     }
911 
912     /// @notice Returns the information associated with the given Wizard
913     ///         owner - The address that owns this Wizard
914     ///         innatePower - The innate power level of this Wizard, set when minted and entirely
915     ///               immutable
916     ///         affinity - The Elemental Affinity of this Wizard. For most Wizards, this is set
917     ///               when they are minted, but some exclusive Wizards are minted with an affinity
918     ///               of 0 (ELEMENT_NOTSET). A Wizard with an NOTSET affinity should NOT be able
919     ///               to participate in Tournaments. Once the affinity of a Wizard is set to a non-zero
920     ///               value, it can never be changed again.
921     ///         metadata - A 256-bit hash of the Wizard's metadata, which is stored off chain. This
922     ///               contract doesn't specify format of this hash, nor the off-chain storage mechanism
923     ///               but, let's be honest, it's probably an IPFS SHA-256 hash.
924     ///
925     ///         NOTE: Series zero Wizards have one of four Affinities:  Neutral (1), Fire (2), Water (3)
926     ///               or Air (4, sometimes called "Wind" in the code). Future Wizard Series may have
927     ///               additional Affinities, and clients of this API should be prepared for that
928     ///               eventuality.
929     function getWizard(uint256 id) public view returns (address owner, uint88 innatePower, uint8 affinity, bytes32 metadata) {
930         Wizard memory wizard = wizardsById[id];
931         require(wizard.owner != address(0), "Wizard does not exist");
932         (owner, innatePower, affinity, metadata) = (wizard.owner, wizard.innatePower, wizard.affinity, wizard.metadata);
933     }
934 
935     /// @notice A function to be called that conjures a whole bunch of Wizards at once! You know how
936     ///         there's "a pride of lions", "a murder of crows", and "a parliament of owls"? Well, with this
937     ///         here function you can conjure yourself "a stench of Cheeze Wizards"!
938     ///
939     ///         Unsurprisingly, this method can only be called by the registered minter for a Series.
940     /// @dev This function DOES NOT CALL onERC721Received() as required by the ERC-721 standard. It is
941     ///         REQUIRED that the Minter calls onERC721Received() after calling this function. The following
942     ///         code snippet should suffice:
943     ///                 // Ensure the Wizard is being assigned to an ERC-721 aware address (either an external address,
944     ///                 // or a smart contract that implements onERC721Received()). We must call onERC721Received for
945     ///                 // each token created because it's allowed for an ERC-721 receiving contract to reject the
946     ///                 // transfer based on the properties of the token.
947     ///                 if (isContract(owner)) {
948     ///                     for (uint256 i = 0; i < wizardIds.length; i++) {
949     ///                         bytes4 retval = IERC721Receiver(owner).onERC721Received(owner, address(0), wizardIds[i], "");
950     ///                         require(retval == _ERC721_RECEIVED, "Contract owner didn't accept ERC721 transfer");
951     ///                     }
952     ///                 }
953     ///        Although it would be convenient for mintWizards to call onERC721Received, it opens us up to potential
954     ///        reentrancy attacks if the Minter needs to do more state updates after mintWizards() returns.
955     /// @param powers the power level of each wizard
956     /// @param affinities the Elements of the wizards to create
957     /// @param owner the address that will own the newly created Wizards
958     function mintWizards(
959         uint88[] calldata powers,
960         uint8[] calldata affinities,
961         address owner
962     ) external onlyMinter returns (uint256[] memory wizardIds)
963     {
964         require(affinities.length == powers.length, "Inconsistent parameter lengths");
965 
966         // allocate result array
967         wizardIds = new uint256[](affinities.length);
968 
969         // We take this storage variables, and turn it into a local variable for the course
970         // of this loop to save about 5k gas per wizard.
971         uint256 tempWizardId = (uint256(seriesIndex) << SERIES_OFFSET) + nextWizardIndex;
972 
973         for (uint256 i = 0; i < affinities.length; i++) {
974             wizardIds[i] = tempWizardId;
975             tempWizardId++;
976 
977             _createWizard(wizardIds[i], owner, powers[i], affinities[i]);
978         }
979 
980         nextWizardIndex = tempWizardId & INDEX_MASK;
981     }
982 
983     /// @notice A function to be called that mints a Series of Wizards in the reserved ID range, can only
984     ///         be called by the Minter for this Series.
985     /// @dev This function DOES NOT CALL onERC721Received() as required by the ERC-721 standard. It is
986     ///         REQUIRED that the Minter calls onERC721Received() after calling this function. See the note
987     ///         above on mintWizards() for more info.
988     /// @param wizardIds the ID values to use for each Wizard, must be in the reserved range of the current Series.
989     /// @param powers the power level of each Wizard.
990     /// @param affinities the Elements of the Wizards to create.
991     /// @param owner the address that will own the newly created Wizards.
992     function mintReservedWizards(
993         uint256[] calldata wizardIds,
994         uint88[] calldata powers,
995         uint8[] calldata affinities,
996         address owner
997     )
998     external onlyMinter
999     {
1000         require(
1001             wizardIds.length == affinities.length &&
1002             wizardIds.length == powers.length, "Inconsistent parameter lengths");
1003 
1004         for (uint256 i = 0; i < wizardIds.length; i++) {
1005             uint256 currentId = wizardIds[i];
1006 
1007             require((currentId & SERIES_MASK) == (uint256(seriesIndex) << SERIES_OFFSET), "Wizards not in current series");
1008             require((currentId & INDEX_MASK) > 0, "Wizards id cannot be zero");
1009 
1010             // Ideally, we would compare the requested Wizard index against the reserved range directly. However,
1011             // it's a bit wasteful to spend storage on a reserved range variable when we can combine some known
1012             // true facts instead:
1013             //         - nextWizardIndex is initialized to reservedRange + 1 when the Series was opened
1014             //         - nextWizardIndex is only incremented when a new Wizard is created
1015             //         - therefore, the only empty Wizard IDs less than nextWizardIndex are in the reserved range.
1016             //         - _conjureWizard() will abort if we try to reuse an ID.
1017             // Combining all of the above, we know that, if the requested index is less than the next index, it
1018             // either points to a reserved slot or an occupied slot. Trying to reuse an occupied slot will fail,
1019             // so just checking against nextWizardIndex is sufficient to ensure we're pointing at a reserved slot.
1020             require((currentId & INDEX_MASK) < nextWizardIndex, "Wizards not in reserved range");
1021 
1022             _createWizard(currentId, owner, powers[i], affinities[i]);
1023         }
1024     }
1025 
1026     /// @notice Sets the metadata values for a list of Wizards. The metadata for a Wizard can only be set once,
1027     ///         can only be set by the COO or Minter, and can only be set while the Series is still open. Once
1028     ///         a Series is closed, the metadata is locked forever!
1029     /// @param wizardIds the ID values of the Wizards to apply metadata changes to.
1030     /// @param metadata the raw metadata values for each Wizard. This contract does not define how metadata
1031     ///         should be interpreted, but it is likely to be a 256-bit hash of a complete metadata package
1032     ///         accessible via IPFS or similar.
1033     function setMetadata(uint256[] calldata wizardIds, bytes32[] calldata metadata) external duringSeries {
1034         require(msg.sender == seriesMinter || msg.sender == cooAddress, "Only Minter or COO can set metadata");
1035         require(wizardIds.length == metadata.length, "Inconsistent parameter lengths");
1036 
1037         for (uint256 i = 0; i < wizardIds.length; i++) {
1038             uint256 currentId = wizardIds[i];
1039             bytes32 currentMetadata = metadata[i];
1040 
1041             require((currentId & SERIES_MASK) == (uint256(seriesIndex) << SERIES_OFFSET), "Wizards not in current series");
1042 
1043             require(wizardsById[currentId].metadata == bytes32(0), "Metadata already set");
1044 
1045             require(currentMetadata != bytes32(0), "Invalid metadata");
1046 
1047             wizardsById[currentId].metadata = currentMetadata;
1048 
1049             emit MetadataSet(currentId, currentMetadata);
1050         }
1051     }
1052 
1053     /// @notice Sets the affinity for a Wizard that doesn't already have its elemental affinity chosen.
1054     ///         Only usable for Exclusive Wizards (all non-Exclusives must have their affinity chosen when
1055     ///         conjured.) Even Exclusives can't change their affinity once it's been chosen.
1056     ///
1057     ///         NOTE: This function can only be called by the Series minter, and (therefore) only while the
1058     ///         Series is open. A Wizard that has no affinity when a Series is closed will NEVER have an Affinity.
1059     /// @param wizardId The ID of the Wizard to update affinity of.
1060     /// @param newAffinity The new affinity of the Wizard.
1061     function setAffinity(uint256 wizardId, uint8 newAffinity) external onlyMinter {
1062         require((wizardId & SERIES_MASK) == (uint256(seriesIndex) << SERIES_OFFSET), "Wizard not in current series");
1063 
1064         Wizard storage wizard = wizardsById[wizardId];
1065 
1066         require(wizard.affinity == ELEMENT_NOTSET, "Affinity can only be chosen once");
1067 
1068         // set the affinity
1069         wizard.affinity = newAffinity;
1070 
1071         // Tell the world this wizards now has an affinity!
1072         emit WizardAffinityAssigned(wizardId, newAffinity);
1073     }
1074 
1075     /// @notice Returns true if the given "spender" address is allowed to manipulate the given token
1076     ///         (either because it is the owner of that token, has been given approval to manage that token)
1077     function isApprovedOrOwner(address spender, uint256 tokenId) external view returns (bool) {
1078         return _isApprovedOrOwner(spender, tokenId);
1079     }
1080 
1081     /// @notice Verifies that a given signature represents authority to control the given Wizard ID,
1082     ///         reverting otherwise. It handles three cases:
1083     ///             - The simplest case: The signature was signed with the private key associated with
1084     ///               an external address that is the owner of this Wizard.
1085     ///             - The signature was generated with the private key associated with an external address
1086     ///               that is "approved" for working with this Wizard ID. (See the Wizard Guild and/or
1087     ///               the ERC-721 spec for more information on "approval".)
1088     ///             - The owner or approval address (as in cases one or two) is a smart contract
1089     ///               that conforms to ERC-1654, and accepts the given signature as being valid
1090     ///               using its own internal logic.
1091     ///
1092     ///        NOTE: This function DOES NOT accept a signature created by an address that was given "operator
1093     ///               status" (as granted by ERC-721's setApprovalForAll() functionality). Doing so is
1094     ///               considered an extreme edge case that can be worked around where necessary.
1095     /// @param wizardId The Wizard ID whose control is in question
1096     /// @param hash The message hash we are authenticating against
1097     /// @param sig the signature data; can be longer than 65 bytes for ERC-1654
1098     function verifySignature(uint256 wizardId, bytes32 hash, bytes memory sig) public view {
1099         // First see if the signature belongs to the owner (the most common case)
1100         address owner = ownerOf(wizardId);
1101 
1102         if (_validSignatureForAddress(owner, hash, sig)) {
1103             return;
1104         }
1105 
1106         // Next check if the signature belongs to the approved address
1107         address approved = getApproved(wizardId);
1108 
1109         if (_validSignatureForAddress(approved, hash, sig)) {
1110             return;
1111         }
1112 
1113         revert("Invalid signature");
1114     }
1115 
1116     /// @notice Convenience function that verifies signatures for two wizards using equivalent logic to
1117     ///         verifySignature(). Included to save on cross-contract calls in the common case where we
1118     ///         are verifying the signatures of two Wizards who wish to enter into a Duel.
1119     /// @param wizardId1 The first Wizard ID whose control is in question
1120     /// @param wizardId2 The second Wizard ID whose control is in question
1121     /// @param hash1 The message hash we are authenticating against for the first Wizard
1122     /// @param hash2 The message hash we are authenticating against for the first Wizard
1123     /// @param sig1 the signature data corresponding to the first Wizard; can be longer than 65 bytes for ERC-1654
1124     /// @param sig2 the signature data corresponding to the second Wizard; can be longer than 65 bytes for ERC-1654
1125     function verifySignatures(
1126         uint256 wizardId1,
1127         uint256 wizardId2,
1128         bytes32 hash1,
1129         bytes32 hash2,
1130         bytes calldata sig1,
1131         bytes calldata sig2) external view
1132     {
1133         verifySignature(wizardId1, hash1, sig1);
1134         verifySignature(wizardId2, hash2, sig2);
1135     }
1136 
1137     /// @notice An internal function that checks if a given signature is a valid signature for a
1138     ///         specific address on a particular hash value. Checks for ERC-1654 compatibility
1139     ///         first (where the possibleSigner is a smart contract that implements its own
1140     ///         signature validation), and falls back to ecrecover() otherwise.
1141     function _validSignatureForAddress(address possibleSigner, bytes32 hash, bytes memory signature)
1142         internal view returns(bool)
1143     {
1144         if (possibleSigner == address(0)) {
1145             // The most basic Bozo check: The zero address can never be a valid signer!
1146             return false;
1147         } else if (Address.isContract(possibleSigner)) {
1148             // If the address is a contract, it either implements ERC-1654 (and will validate the signature
1149             // itself), or we have no way of confirming that this signature matches this address. In other words,
1150             // if this address is a contract, there's no point in "falling back" to ecrecover().
1151             if (doesContractImplementInterface(possibleSigner, ERC1654_VALIDSIGNATURE)) {
1152                 // cast to ERC1654
1153                 ERC1654 tso = ERC1654(possibleSigner);
1154                 bytes4 result = tso.isValidSignature(keccak256(abi.encodePacked(hash)), signature);
1155                 if (result == ERC1654_VALIDSIGNATURE) {
1156                     return true;
1157                 }
1158             }
1159 
1160             return false;
1161         } else {
1162             // Not a contract, check for a match against an external address
1163             // assume EIP 191 signature here
1164             (bytes32 r, bytes32 s, uint8 v) = SigTools._splitSignature(signature);
1165             address signer = ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)), v, r, s);
1166 
1167             // Note: Signer could be address(0) here, but we already checked that possibleSigner isn't zero
1168             return (signer == possibleSigner);
1169         }
1170     }
1171 
1172 }