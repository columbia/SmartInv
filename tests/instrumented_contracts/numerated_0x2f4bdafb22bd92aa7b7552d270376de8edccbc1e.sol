1 // File: openzeppelin-solidity/contracts/introspection/IERC165.sol
2 
3 pragma solidity ^0.5.2;
4 
5 /**
6  * @title IERC165
7  * @dev https://eips.ethereum.org/EIPS/eip-165
8  */
9 interface IERC165 {
10     /**
11      * @notice Query if a contract implements an interface
12      * @param interfaceId The interface identifier, as specified in ERC-165
13      * @dev Interface identification is specified in ERC-165. This function
14      * uses less than 30,000 gas.
15      */
16     function supportsInterface(bytes4 interfaceId) external view returns (bool);
17 }
18 
19 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721.sol
20 
21 pragma solidity ^0.5.2;
22 
23 
24 /**
25  * @title ERC721 Non-Fungible Token Standard basic interface
26  * @dev see https://eips.ethereum.org/EIPS/eip-721
27  */
28 contract IERC721 is IERC165 {
29     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
30     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
31     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
32 
33     function balanceOf(address owner) public view returns (uint256 balance);
34     function ownerOf(uint256 tokenId) public view returns (address owner);
35 
36     function approve(address to, uint256 tokenId) public;
37     function getApproved(uint256 tokenId) public view returns (address operator);
38 
39     function setApprovalForAll(address operator, bool _approved) public;
40     function isApprovedForAll(address owner, address operator) public view returns (bool);
41 
42     function transferFrom(address from, address to, uint256 tokenId) public;
43     function safeTransferFrom(address from, address to, uint256 tokenId) public;
44 
45     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
46 }
47 
48 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Receiver.sol
49 
50 pragma solidity ^0.5.2;
51 
52 /**
53  * @title ERC721 token receiver interface
54  * @dev Interface for any contract that wants to support safeTransfers
55  * from ERC721 asset contracts.
56  */
57 contract IERC721Receiver {
58     /**
59      * @notice Handle the receipt of an NFT
60      * @dev The ERC721 smart contract calls this function on the recipient
61      * after a `safeTransfer`. This function MUST return the function selector,
62      * otherwise the caller will revert the transaction. The selector to be
63      * returned can be obtained as `this.onERC721Received.selector`. This
64      * function MAY throw to revert and reject the transfer.
65      * Note: the ERC721 contract address is always the message sender.
66      * @param operator The address which called `safeTransferFrom` function
67      * @param from The address which previously owned the token
68      * @param tokenId The NFT identifier which is being transferred
69      * @param data Additional data with no specified format
70      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
71      */
72     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
73     public returns (bytes4);
74 }
75 
76 // File: openzeppelin-solidity/contracts/introspection/ERC165.sol
77 
78 pragma solidity ^0.5.2;
79 
80 
81 /**
82  * @title ERC165
83  * @author Matt Condon (@shrugs)
84  * @dev Implements ERC165 using a lookup table.
85  */
86 contract ERC165 is IERC165 {
87     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
88     /*
89      * 0x01ffc9a7 ===
90      *     bytes4(keccak256('supportsInterface(bytes4)'))
91      */
92 
93     /**
94      * @dev a mapping of interface id to whether or not it's supported
95      */
96     mapping(bytes4 => bool) private _supportedInterfaces;
97 
98     /**
99      * @dev A contract implementing SupportsInterfaceWithLookup
100      * implement ERC165 itself
101      */
102     constructor () internal {
103         _registerInterface(_INTERFACE_ID_ERC165);
104     }
105 
106     /**
107      * @dev implement supportsInterface(bytes4) using a lookup table
108      */
109     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
110         return _supportedInterfaces[interfaceId];
111     }
112 
113     /**
114      * @dev internal method for registering an interface
115      */
116     function _registerInterface(bytes4 interfaceId) internal {
117         require(interfaceId != 0xffffffff);
118         _supportedInterfaces[interfaceId] = true;
119     }
120 }
121 
122 // File: openzeppelin-solidity/contracts/utils/Address.sol
123 
124 pragma solidity ^0.5.2;
125 
126 /**
127  * Utility library of inline functions on addresses
128  */
129 library Address {
130     /**
131      * Returns whether the target address is a contract
132      * @dev This function will return false if invoked during the constructor of a contract,
133      * as the code is not actually created until after the constructor finishes.
134      * @param account address of the account to check
135      * @return whether the target address is a contract
136      */
137     function isContract(address account) internal view returns (bool) {
138         uint256 size;
139         // XXX Currently there is no better way to check if there is a contract in an address
140         // than to check the size of the code at that address.
141         // See https://ethereum.stackexchange.com/a/14016/36603
142         // for more details about how this works.
143         // TODO Check this again before the Serenity release, because all addresses will be
144         // contracts then.
145         // solhint-disable-next-line no-inline-assembly
146         assembly { size := extcodesize(account) }
147         return size > 0;
148     }
149 }
150 
151 // File: contracts/WizardPresaleNFT.sol
152 
153 pragma solidity >=0.5.6 <0.6.0;
154 
155 
156 
157 
158 
159 
160 /**
161  * @title WizardPresaleNFT
162  * @notice The basic ERC-721 functionality for storing the presale Wizard NFTs.
163  *     Derived from: https://github.com/OpenZeppelin/openzeppelin-solidity/tree/v2.2.0
164  */
165 contract WizardPresaleNFT is ERC165, IERC721 {
166 
167     using Address for address;
168 
169     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
170     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
171     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
172 
173     /// @notice Emitted when a wizard token is created.
174     event WizardSummoned(uint256 indexed tokenId, uint8 element, uint256 power);
175 
176     /// @notice Emitted when a wizard change element. Should only happen once and for wizards
177     ///         that previously had the element undefined.
178     event WizardAlignmentAssigned(uint256 indexed tokenId, uint8 element);
179 
180     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
181     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
182     bytes4 internal constant _ERC721_RECEIVED = 0x150b7a02;
183 
184     /// @dev The presale Wizard structure.
185     ///  Fits in one word
186     struct Wizard {
187         // NOTE: Changing the order or meaning of any of these fields requires an update
188         //   to the _createWizard() function which assumes a specific order for these fields.
189         uint8 affinity;
190         uint88 power;
191         address owner;
192     }
193 
194     // Mapping from Wizard ID to Wizard struct
195     mapping (uint256 => Wizard) public _wizardsById;
196 
197     // Mapping from token ID to approved address
198     mapping (uint256 => address) private _tokenApprovals;
199 
200     // Mapping from owner to number of owned token
201     mapping (address => uint256) internal _ownedTokensCount;
202 
203     // Mapping from owner to operator approvals
204     mapping (address => mapping (address => bool)) private _operatorApprovals;
205 
206     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
207     /*
208      * 0x80ac58cd ===
209      *     bytes4(keccak256('balanceOf(address)')) ^
210      *     bytes4(keccak256('ownerOf(uint256)')) ^
211      *     bytes4(keccak256('approve(address,uint256)')) ^
212      *     bytes4(keccak256('getApproved(uint256)')) ^
213      *     bytes4(keccak256('setApprovalForAll(address,bool)')) ^
214      *     bytes4(keccak256('isApprovedForAll(address,address)')) ^
215      *     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
216      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
217      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
218      */
219 
220     constructor () public {
221         // register the supported interfaces to conform to ERC721 via ERC165
222         _registerInterface(_INTERFACE_ID_ERC721);
223     }
224 
225     /**
226      * @dev Gets the balance of the specified address
227      * @param owner address to query the balance of
228      * @return uint256 representing the amount owned by the passed address
229      */
230     function balanceOf(address owner) public view returns (uint256) {
231         require(owner != address(0), "ERC721: balance query for the zero address");
232         return _ownedTokensCount[owner];
233     }
234 
235     /**
236      * @dev Gets the owner of the specified token ID
237      * @param tokenId uint256 ID of the token to query the owner of
238      * @return address currently marked as the owner of the given token ID
239      */
240     function ownerOf(uint256 tokenId) public view returns (address) {
241         address owner = _wizardsById[tokenId].owner;
242         require(owner != address(0), "ERC721: owner query for nonexistent token");
243         return owner;
244     }
245 
246     /**
247      * @dev Approves another address to transfer the given token ID
248      * The zero address indicates there is no approved address.
249      * There can only be one approved address per token at a given time.
250      * Can only be called by the token owner or an approved operator.
251      * @param to address to be approved for the given token ID
252      * @param tokenId uint256 ID of the token to be approved
253      */
254     function approve(address to, uint256 tokenId) public {
255         address owner = ownerOf(tokenId);
256         require(to != owner, "ERC721: approval to current owner");
257         require(
258             msg.sender == owner || isApprovedForAll(owner, msg.sender),
259             "ERC721: approve caller is not owner nor approved for all"
260         );
261 
262         _tokenApprovals[tokenId] = to;
263         emit Approval(owner, to, tokenId);
264     }
265 
266     /**
267      * @dev Gets the approved address for a token ID, or zero if no address set
268      * Reverts if the token ID does not exist.
269      * @param tokenId uint256 ID of the token to query the approval of
270      * @return address currently approved for the given token ID
271      */
272     function getApproved(uint256 tokenId) public view returns (address) {
273         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
274         return _tokenApprovals[tokenId];
275     }
276 
277     /**
278      * @dev Sets or unsets the approval of a given operator
279      * An operator is allowed to transfer all tokens of the sender on their behalf
280      * @param to operator address to set the approval
281      * @param approved representing the status of the approval to be set
282      */
283     function setApprovalForAll(address to, bool approved) public {
284         require(to != msg.sender, "ERC721: approve to caller");
285         _operatorApprovals[msg.sender][to] = approved;
286         emit ApprovalForAll(msg.sender, to, approved);
287     }
288 
289     /**
290      * @dev Tells whether an operator is approved by a given owner
291      * @param owner owner address which you want to query the approval of
292      * @param operator operator address which you want to query the approval of
293      * @return bool whether the given operator is approved by the given owner
294      */
295     function isApprovedForAll(address owner, address operator) public view returns (bool) {
296         return _operatorApprovals[owner][operator];
297     }
298 
299     /**
300      * @dev Transfers the ownership of a given token ID to another address
301      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
302      * Requires the msg.sender to be the owner, approved, or operator
303      * @param from current owner of the token
304      * @param to address to receive the ownership of the given token ID
305      * @param tokenId uint256 ID of the token to be transferred
306      */
307     function transferFrom(address from, address to, uint256 tokenId) public {
308         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
309 
310         _transferFrom(from, to, tokenId);
311     }
312 
313     /**
314      * @dev Safely transfers the ownership of a given token ID to another address
315      * If the target address is a contract, it must implement `onERC721Received`,
316      * which is called upon a safe transfer, and return the magic value
317      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
318      * the transfer is reverted.
319      * Requires the msg.sender to be the owner, approved, or operator
320      * @param from current owner of the token
321      * @param to address to receive the ownership of the given token ID
322      * @param tokenId uint256 ID of the token to be transferred
323      */
324     function safeTransferFrom(address from, address to, uint256 tokenId) public {
325         safeTransferFrom(from, to, tokenId, "");
326     }
327 
328     /**
329      * @dev Safely transfers the ownership of a given token ID to another address
330      * If the target address is a contract, it must implement `onERC721Received`,
331      * which is called upon a safe transfer, and return the magic value
332      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
333      * the transfer is reverted.
334      * Requires the msg.sender to be the owner, approved, or operator
335      * @param from current owner of the token
336      * @param to address to receive the ownership of the given token ID
337      * @param tokenId uint256 ID of the token to be transferred
338      * @param _data bytes data to send along with a safe transfer check
339      */
340     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
341         transferFrom(from, to, tokenId);
342         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
343     }
344 
345     /**
346      * @dev Returns whether the specified token exists
347      * @param tokenId uint256 ID of the token to query the existence of
348      * @return bool whether the token exists
349      */
350     function _exists(uint256 tokenId) internal view returns (bool) {
351         address owner = _wizardsById[tokenId].owner;
352         return owner != address(0);
353     }
354 
355     /**
356      * @dev Returns whether the given spender can transfer a given token ID
357      * @param spender address of the spender to query
358      * @param tokenId uint256 ID of the token to be transferred
359      * @return bool whether the msg.sender is approved for the given token ID,
360      * is an operator of the owner, or is the owner of the token
361      */
362     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
363         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
364         address owner = ownerOf(tokenId);
365         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
366     }
367 
368     /**
369      * @dev Internal function to burn a specific token
370      * Reverts if the token does not exist
371      * Deprecated, use _burn(uint256) instead.
372      * @param owner owner of the token to burn
373      * @param tokenId uint256 ID of the token being burned
374      */
375     function _burn(address owner, uint256 tokenId) internal {
376         require(ownerOf(tokenId) == owner, "ERC721: burn of token that is not own");
377 
378         _clearApproval(tokenId);
379 
380         _ownedTokensCount[owner]--;
381         // delete the entire object to recover the most gas
382         delete _wizardsById[tokenId];
383 
384         // required for ERC721 compatibility
385         emit Transfer(owner, address(0), tokenId);
386     }
387 
388     /**
389      * @dev Internal function to burn a specific token
390      * Reverts if the token does not exist
391      * @param tokenId uint256 ID of the token being burned
392      */
393     function _burn(uint256 tokenId) internal {
394         _burn(ownerOf(tokenId), tokenId);
395     }
396 
397     /**
398      * @dev Internal function to transfer ownership of a given token ID to another address.
399      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
400      * @param from current owner of the token
401      * @param to address to receive the ownership of the given token ID
402      * @param tokenId uint256 ID of the token to be transferred
403      */
404     function _transferFrom(address from, address to, uint256 tokenId) internal {
405         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
406         require(to != address(0), "ERC721: transfer to the zero address");
407 
408         _clearApproval(tokenId);
409 
410         _ownedTokensCount[from]--;
411         _ownedTokensCount[to]++;
412 
413         _wizardsById[tokenId].owner = to;
414 
415         emit Transfer(from, to, tokenId);
416     }
417 
418     /**
419      * @dev Internal function to invoke `onERC721Received` on a target address
420      * The call is not executed if the target address is not a contract
421      * @param from address representing the previous owner of the given token ID
422      * @param to target address that will receive the tokens
423      * @param tokenId uint256 ID of the token to be transferred
424      * @param _data bytes optional data to send along with the call
425      * @return bool whether the call correctly returned the expected magic value
426      */
427     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
428         internal returns (bool)
429     {
430         if (!to.isContract()) {
431             return true;
432         }
433 
434         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
435         return (retval == _ERC721_RECEIVED);
436     }
437 
438     /**
439      * @dev Private function to clear current approval of a given token ID
440      * @param tokenId uint256 ID of the token to be transferred
441      */
442     function _clearApproval(uint256 tokenId) private {
443         if (_tokenApprovals[tokenId] != address(0)) {
444             _tokenApprovals[tokenId] = address(0);
445         }
446     }
447 }
448 
449 // File: contracts/WizardPresaleInterface.sol
450 
451 pragma solidity >=0.5.6 <0.6.0;
452 
453 
454 /// @title WizardPresaleInterface
455 /// @notice This interface represents the single method that the final tournament and master Wizard contracts
456 ///         will use to import the presale wizards when those contracts have been finalized a released on
457 ///         mainnet. Once all presale Wizards have been absorbed, this temporary pre-sale contract can be
458 ///         destroyed.
459 contract WizardPresaleInterface {
460 
461     // See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md on how
462     // to calculate this
463     bytes4 public constant _INTERFACE_ID_WIZARDPRESALE = 0x4df71efb;
464 
465     /// @notice This function is used to bring a presale Wizard into the final contracts. It can
466     ///         ONLY be called by the official gatekeeper contract (as set by the Owner of the presale
467     ///         contract). It does a number of things:
468     ///            1. Check that the presale Wizard exists, and has not already been absorbed
469     ///            2. Transfer the Eth used to create the presale Wizard to the caller
470     ///            3. Mark the Wizard as having been absorbed, reclaiming the storage used by the presale info
471     ///            4. Return the Wizard information (its owner, minting price, and elemental alignment)
472     /// @param id the id of the presale Wizard to be absorbed
473     function absorbWizard(uint256 id) external returns (address owner, uint256 power, uint8 affinity);
474 
475     /// @notice A convenience function that allows multiple Wizards to be moved to the final contracts
476     ///         simultaneously, works the same as the previous function, but in a batch.
477     /// @param ids An array of ids indicating which presale Wizards are to be absorbed
478     function absorbWizardMulti(uint256[] calldata ids) external
479         returns (address[] memory owners, uint256[] memory powers, uint8[] memory affinities);
480 
481     function powerToCost(uint256 power) public pure returns (uint256 cost);
482     function costToPower(uint256 cost) public pure returns (uint256 power);
483 }
484 
485 // File: contracts/AddressPayable.sol
486 
487 pragma solidity >=0.5.6 <0.6.0;
488 
489 /**
490  * Utility library of inline functions on address payables
491  * Modified from original by OpenZeppelin
492  */
493 contract AddressPayable {
494     /**
495      * Returns whether the target address is a contract
496      * @dev This function will return false if invoked during the constructor of a contract,
497      * as the code is not actually created until after the constructor finishes.
498      * @param account address of the account to check
499      * @return whether the target address is a contract
500      */
501     function isContract(address payable account) internal view returns (bool) {
502         uint256 size;
503         // XXX Currently there is no better way to check if there is a contract in an address
504         // than to check the size of the code at that address.
505         // See https://ethereum.stackexchange.com/a/14016/36603
506         // for more details about how this works.
507         // TODO Check this again before the Serenity release, because all addresses will be
508         // contracts then.
509         // solhint-disable-next-line no-inline-assembly
510         assembly { size := extcodesize(account) } // solium-disable-line security/no-inline-assembly
511         return size > 0;
512     }
513 }
514 
515 // File: contracts/WizardConstants.sol
516 
517 pragma solidity >=0.5.6 <0.6.0;
518 
519 /// @title The master organization behind wizardry activity, where Wiz come from.
520 contract WizardConstants {
521     uint8 internal constant ELEMENT_NOTSET = 0;
522     // need to decide what neutral is because of price difference
523     uint8 internal constant ELEMENT_NEUTRAL = 1;
524     // no sense in defining these here as they are probably not fixed,
525     // all we need to know is that these are not neutral
526     uint8 internal constant ELEMENT_FIRE = 2;
527     uint8 internal constant ELEMENT_WIND = 3;
528     uint8 internal constant ELEMENT_WATER = 4;
529     uint8 internal constant MAX_ELEMENT = ELEMENT_WATER;
530 }
531 
532 // File: contracts/WizardPresale.sol
533 
534 pragma solidity >=0.5.6 <0.6.0;
535 
536 
537 
538 
539 
540 /// @title WizardPresale - Making Cheeze Wizards available for sale!
541 /// @notice Allows for the creation and sale of Cheeze Wizards before the final tournament
542 ///         contract has been reviewed and released on mainnet. There are three main types
543 ///         of Wizards that are managed by this contract:
544 ///          - Neutral Wizards: Available in unlimited quantities and all have the same
545 ///             innate power. Don't have a natural affinity for any particular elemental
546 ///             spell... or the corresponding weakness!
547 ///          - Elemental Wizards: Available in unlimited quantities, but with a steadily increasing
548 ///             power; the power of an Elemental Wizard is always _slightly_ higher than the power
549 ///             of the previously created Elemental Wizard. Each Elemental Wizard has an Elemental
550 ///             Affinity that gives it a power multiplier when using the associated spell, but also
551 ///             gives it a weakness for the opposing element.
552 ///          - Exclusive Wizards: Only available in VERY limited quantities, with a hard cap set at
553 ///             contract creation time. Exclusive Wizards can ONLY be created by the Guild Master
554 ///             address (the address that created this contract), and are assigned the first N
555 ///             Wizard IDs, starting with 1 (where N is the hard cap on Exclusive Wizards). The first
556 ///             non-exclusive Wizard is assigned the ID N+1. Exclusive Wizards have no starting
557 ///             affinity, and their owners much choose an affinity before they can be entered into a
558 ///             Battle. The affinity CAN NOT CHANGE once it has been selected. The power of Exclusive
559 ///             Wizards is not set by the Guild Master and is not required to follow any pattern (although
560 ///             it can't be lower than the power of Neutral Wizards).
561 contract WizardPresale is AddressPayable, WizardPresaleNFT, WizardPresaleInterface, WizardConstants {
562 
563     /// @dev The ratio between the cost of a Wizard (in wei) and the power of the wizard.
564     ///      power = cost / POWER_SCALE
565     ///      cost = power * POWER_SCALE
566     uint256 private constant POWER_SCALE = 1000;
567 
568     /// @dev The unit conversion for tenths of basis points
569     uint256 private constant TENTH_BASIS_POINTS = 100000;
570 
571     /// @dev The address used to create this smart contract, has permission to conjure Exclusive Wizards,
572     ///      set the gatekeeper address, and destroy this contract once the sale is finished and all Presale
573     ///      Wizards have been absorbed into the main contracts.
574     address payable public guildmaster;
575 
576     /// @dev The start block and duration (in blocks) of the sale.
577     ///      ACT NOW! For a limited time only!
578     uint256 public saleStartBlock;
579     uint256 public saleDuration;
580 
581     /// @dev The cost of Neutral Wizards (in wei).
582     uint256 public neutralWizardCost;
583 
584     /// @dev The cost of the _next_ Elemental Wizard (in wei); increases with each Elemental Wizard sold
585     uint256 public elementalWizardCost;
586 
587     /// @dev The increment ratio in price between sequential Elemental Wizards, multiplied by 100k for
588     ///      greater granularity (0 == 0% increase, 100000 == 100% increase, 100 = 0.1% increase, etc.)
589     ///      NOTE: This is NOT percentage points, or basis points. It's tenths of a basis point.
590     uint256 public elementalWizardIncrement;
591 
592     /// @dev The hard cap on how many Exclusive Wizards can be created
593     uint256 public maxExclusives;
594 
595     /// @dev The ID number of the next Wizard to be created (Neutral or Elemental)
596     uint256 public nextWizardId;
597 
598     /// @dev The address of the Gatekeeper for the tournament, initially set to address(0).
599     ///      To be set by the Guild Master when the final Tournament Contract is deployed on mainnet
600     address payable public gatekeeper;
601 
602     /// @notice Emitted whenever the start of the sale changes.
603     event StartBlockChanged(uint256 oldStartBlock, uint256 newStartBlock);
604 
605     /// @param startingCost The minimum cost of a Wizard, used as the price for all Neutral Wizards, and the
606     ///        cost of the first Elemental Wizard. Also used as a minimum value for Exclusive Wizards.
607     /// @param costIncremement The rate (in tenths of a basis point) at which the price of Elemental Wizards increases
608     /// @param exclusiveCount The hard cap on Exclusive Wizards, also dictates the ID of the first non-Exclusive
609     /// @param startBlock The starting block of the presale.
610     /// @param duration The duration of the presale.  Not changeable!
611     constructor(uint128 startingCost,
612             uint16 costIncremement,
613             uint256 exclusiveCount,
614             uint128 startBlock,
615             uint128 duration) public
616     {
617         require(startBlock > block.number, "start must be greater than current block");
618 
619         guildmaster = msg.sender;
620         saleStartBlock = startBlock;
621         saleDuration = duration;
622         neutralWizardCost = startingCost;
623         elementalWizardCost = startingCost;
624         elementalWizardIncrement = costIncremement;
625         maxExclusives = exclusiveCount;
626         nextWizardId = exclusiveCount + 1;
627 
628         _registerInterface(_INTERFACE_ID_WIZARDPRESALE);
629     }
630 
631     /// @dev Throws if called by any account other than the gatekeeper.
632     modifier onlyGatekeeper() {
633         require(msg.sender == gatekeeper, "Must be gatekeeper");
634         _;
635     }
636 
637     /// @dev Throws if called by any account other than the guildmaster.
638     modifier onlyGuildmaster() {
639         require(msg.sender == guildmaster, "Must be guildmaster");
640         _;
641     }
642 
643     /// @dev Checks to see that the current block number is within the range
644     ///      [saleStartBlock, saleStartBlock + saleDuraction) indicating that the sale
645     ///      is currently active
646     modifier onlyDuringSale() {
647         // The addtion of start and duration can't overflow since they can only be set from
648         // 128-bit arguments.
649         require(block.number >= saleStartBlock, "Sale not open yet");
650         require(block.number < saleStartBlock + saleDuration, "Sale closed");
651         _;
652     }
653 
654     /// @dev Sets the address of the Gatekeeper contract once the final Tournament contract is live.
655     ///      Can only be set once.
656     /// @param gc The gatekeeper address to set
657     function setGatekeeper(address payable gc) external onlyGuildmaster {
658         require(gatekeeper == address(0) && gc != address(0), "Can only set once and must not be zero");
659         gatekeeper = gc;
660     }
661 
662     /// @dev Updates the start block of the sale. The sale can only be postponed; it can't be made earlier.
663     /// @param newStart the new start block.
664     function postponeSale(uint128 newStart) external onlyGuildmaster {
665         require(block.number < saleStartBlock, "Sale start time only adjustable before previous start time");
666         require(newStart > saleStartBlock, "New start time must be later than previous start time");
667 
668         emit StartBlockChanged(saleStartBlock, newStart);
669 
670         saleStartBlock = newStart;
671     }
672 
673     /// @dev Returns true iff the sale is currently active
674     function isDuringSale() external view returns (bool) {
675         return (block.number >= saleStartBlock && block.number < saleStartBlock + saleDuration);
676     }
677 
678     /// @dev Convenience method for getting a presale wizard's data
679     /// @param id The wizard id
680     function getWizard(uint256 id) public view returns (address owner, uint88 power, uint8 affinity) {
681         Wizard memory wizard = _wizardsById[id];
682         (owner, power, affinity) = (wizard.owner, wizard.power, wizard.affinity);
683         require(wizard.owner != address(0), "Wizard does not exist");
684     }
685 
686     /// @param cost The price of the wizard in wei
687     /// @return The power of the wizard (left as uint256)
688     function costToPower(uint256 cost) public pure returns (uint256 power) {
689         return cost / POWER_SCALE;
690     }
691 
692     /// @param power The power of the wizard
693     /// @return The cost of the wizard in wei
694     function powerToCost(uint256 power) public pure returns (uint256 cost) {
695         return power * POWER_SCALE;
696     }
697 
698     /// @notice This function is used to bring a presale Wizard into the final contracts. It can
699     ///         ONLY be called by the official gatekeeper contract (as set by the Owner of the presale
700     ///         contract). It does a number of things:
701     ///            1. Check that the presale Wizard exists, and has not already been absorbed
702     ///            2. Transfer the Eth used to create the presale Wizard to the caller
703     ///            3. Mark the Wizard as having been absorbed, reclaiming the storage used by the presale info
704     ///            4. Return the Wizard information (its owner, minting price, and elemental alignment)
705     /// @param id the id of the presale Wizard to be absorbed
706     function absorbWizard(uint256 id) external onlyGatekeeper returns (address owner, uint256 power, uint8 affinity) {
707         (owner, power, affinity) = getWizard(id);
708 
709         // Free up the storage used by this wizard
710         _burn(owner, id);
711 
712         // send the price paid to the gatekeeper to be used in the tournament prize pool
713         msg.sender.transfer(powerToCost(power));
714     }
715 
716     /// @notice A convenience function that allows multiple Wizards to be moved to the final contracts
717     ///         simultaneously, works the same as the previous function, but in a batch.
718     /// @param ids An array of ids indicating which presale Wizards are to be absorbed
719     function absorbWizardMulti(uint256[] calldata ids) external onlyGatekeeper
720             returns (address[] memory owners, uint256[] memory powers, uint8[] memory affinities)
721     {
722         // allocate arrays
723         owners = new address[](ids.length);
724         powers = new uint256[](ids.length);
725         affinities = new uint8[](ids.length);
726 
727         // The total eth to send (sent in a batch to save gas)
728         uint256 totalTransfer;
729 
730         // Put the data for each Wizard into the returned arrays
731         for (uint256 i = 0; i < ids.length; i++) {
732             (owners[i], powers[i], affinities[i]) = getWizard(ids[i]);
733 
734             // Free up the storage used by this wizard
735             _burn(owners[i], ids[i]);
736 
737             // add the amount to transfer
738             totalTransfer += powerToCost(powers[i]);
739         }
740 
741         // Send all the eth together
742         msg.sender.transfer(totalTransfer);
743     }
744 
745     /// @dev Internal function to create a new Wizard; reverts if the Wizard ID is taken.
746     ///      NOTE: This function heavily depends on the internal format of the Wizard struct
747     ///      and should always be reassessed if anything about that structure changes.
748     /// @param tokenId ID of the new Wizard
749     /// @param owner The address that will own the newly conjured Wizard
750     /// @param power The power level associated with the new Wizard
751     /// @param affinity The elemental affinity of the new Wizard
752     function _createWizard(uint256 tokenId, address owner, uint256 power, uint8 affinity) internal {
753         require(!_exists(tokenId), "Can't reuse Wizard ID");
754         require(owner != address(0), "Owner address must exist");
755         require(power > 0, "Wizard power must be non-zero");
756         require(power < (1<<88), "Wizard power must fit in 88 bits of storage.");
757         require(affinity <= MAX_ELEMENT, "Invalid elemental affinity");
758 
759         // Create the Wizard!
760         _wizardsById[tokenId] = Wizard(affinity, uint88(power), owner);
761         _ownedTokensCount[owner]++;
762 
763         // Tell the world!
764         emit Transfer(address(0), owner, tokenId);
765         emit WizardSummoned(tokenId, affinity, power);
766     }
767 
768     /// @dev A private utility function that refunds any overpayment to the sender; smart
769     ///      enough to only send the excess if the amount we are returning is more than the
770     ///      cost of sending it!
771     /// @dev Warning! This does not check for underflows (msg.value < actualPrice) - so
772     ///      be sure to call this with correct values!
773     /// @param actualPrice the actual price owed
774     function _transferRefund(uint256 actualPrice) private {
775         uint256 refund = msg.value - actualPrice;
776 
777         // Make sure the amount we're trying to refund is less than the actual cost of sending it!
778         // See https://github.com/ethereum/wiki/wiki/Subtleties for magic values costs.  We can
779         // safley ignore the 25000 additional gas cost for new accounts, as msg.sender is
780         // guarunteed to exist at this point!
781         if (refund > (tx.gasprice * (9000+700))) {
782             msg.sender.transfer(refund);
783         }
784     }
785 
786     /// @notice Conjures an Exclusive Wizard with a specific element and ID. This can only be done by
787     ///         the Guildmaster, who still has to pay for the power imbued in that Wizard! The power level
788     ///         is inferred by the amount of Eth sent. MUST ONLY BE USED FOR EXTERNAL OWNER ADDRESSES.
789     /// @param id The ID of the new Wizard; must be in the Exclusive range, and can't already be allocated
790     /// @param owner The address which will own the new Wizard
791     /// @param affinity The elemental affinity of the new Wizard, can be ELEMENT_NOTSET for Exclusives!
792     function conjureExclusiveWizard(uint256 id, address owner, uint8 affinity) public payable onlyGuildmaster {
793         require(id > 0 && id <= maxExclusives, "Invalid exclusive ID");
794         _createWizard(id, owner, costToPower(msg.value), affinity);
795     }
796 
797     /// @notice Same as conjureExclusiveWizard(), but reverts if the owner address is a smart
798     ///         contract that is not ERC-721 aware.
799     /// @param id The ID of the new Wizard; must be in the Exclusive range, and can't already be allocated
800     /// @param owner The address which will own the new Wizard
801     /// @param affinity The elemental affinity of the new Wizard, can be ELEMENT_NOTSET for Exclusives!
802     function safeConjureExclusiveWizard(uint256 id, address owner, uint8 affinity) external payable onlyGuildmaster {
803         conjureExclusiveWizard(id, owner, affinity);
804         require(_checkOnERC721Received(address(0), owner, id, ""), "must support erc721");
805     }
806 
807     /// @notice Allows for the batch creation of Exclusive Wizards. Same rules apply as above, but the
808     ///         powers are specified instead of being inferred. The message still needs to have enough
809     ///         value to pay for all the newly conjured Wizards!  MUST ONLY BE USED FOR EXTERNAL OWNER ADDRESSES.
810     /// @param ids An array of IDs of the new Wizards
811     /// @param owners An array of owners
812     /// @param powers An array of power levels
813     /// @param affinities An array of elemental affinities
814     function conjureExclusiveWizardMulti(
815         uint256[] calldata ids,
816         address[] calldata owners,
817         uint256[] calldata powers,
818         uint8[] calldata affinities) external payable onlyGuildmaster
819     {
820         // Ensure the arrays are all of the same length
821         require(
822             ids.length == owners.length &&
823             owners.length == powers.length &&
824             owners.length == affinities.length,
825             "Must have equal array lengths"
826         );
827 
828         uint256 totalPower = 0;
829 
830         for (uint256 i = 0; i < ids.length; i++) {
831             require(ids[i] > 0 && ids[i] <= maxExclusives, "Invalid exclusive ID");
832             require(affinities[i] <= MAX_ELEMENT, "Must choose a valid elemental affinity");
833 
834             _createWizard(ids[i], owners[i], powers[i], affinities[i]);
835 
836             totalPower += powers[i];
837         }
838 
839         // Ensure that the message includes enough eth to cover the total power of all Wizards
840         // If this check fails, all the Wizards that we just created will be deleted, and we'll just
841         // have wasted a bunch of gas. Don't be dumb, Guildmaster!
842         // If the guildMaster has managed to overflow totalPower, well done!
843         require(powerToCost(totalPower) <= msg.value, "Must pay for power in all Wizards");
844 
845         // We don't return "change" if the caller overpays, because the caller is the Guildmaster and
846         // shouldn't be dumb like that. How many times do I have to say it? Don't be dumb, Guildmaster!
847     }
848 
849     /// @notice Sets the affinity for a Wizard that doesn't already have its elemental affinity chosen.
850     ///         Only usable for Exclusive Wizards (all non-Exclusives must have their affinity chosen when
851     ///         conjured.) Even Exclusives can't change their affinity once it's been chosen.
852     /// @param wizardId The id of the wizard
853     /// @param newAffinity The new affinity of the wizard
854     function setAffinity(uint256 wizardId, uint8 newAffinity) external {
855         require(newAffinity > ELEMENT_NOTSET && newAffinity <= MAX_ELEMENT, "Must choose a valid affinity");
856         (address owner, , uint8 affinity) = getWizard(wizardId);
857         require(msg.sender == owner, "Affinity can only be set by the owner");
858         require(affinity == ELEMENT_NOTSET, "Affinity can only be chosen once");
859 
860         _wizardsById[wizardId].affinity = newAffinity;
861 
862         // Tell the world this wizards now has an affinity!
863         emit WizardAlignmentAssigned(wizardId, newAffinity);
864     }
865 
866     /// @dev An internal convenience function used by conjureWizard and conjureWizardMulti that takes care
867     ///      of the work that is shared between them.
868     ///      The use of tempElementalWizardCost and updatedElementalWizardCost deserves some explanation here.
869     ///      Using elementalWizardCost directly would be very expensive in the case where this function is
870     ///      called repeatedly by conjureWizardMulti. Buying an elemental wizard would update the elementalWizardCost
871     ///      each time through this function _which would cost 5000 gas each time_. Of course, we don't actually
872     ///      need to store the new value each time, only once at the very end. So we go through this very annoying
873     ///      process of passing the elementalWizardCost in as an argument (tempElementalWizardCost) and returning
874     ///      the updated value as a return value (updatedElementalWizardCost). It's enough to make one want
875     ///      tear one's hair out. But! What's done is done, and hopefully SOMEONE will realize how much trouble
876     ///      we went to to save them _just that little bit_ of gas cost when they decided to buy a schwack of
877     ///      Wizards.
878     function _conjureWizard(
879         uint256 wizardId,
880         address owner,
881         uint8 affinity,
882         uint256 tempElementalWizardCost) private
883         returns (uint256 wizardCost, uint256 updatedElementalWizardCost)
884     {
885         // Check for a valid elemental affinity
886         require(affinity > ELEMENT_NOTSET && affinity <= MAX_ELEMENT, "Non-exclusive Wizards need a real affinity");
887 
888         updatedElementalWizardCost = tempElementalWizardCost;
889 
890         // Determine the price
891         if (affinity == ELEMENT_NEUTRAL) {
892             wizardCost = neutralWizardCost;
893         } else {
894             wizardCost = updatedElementalWizardCost;
895 
896             // Update the elemental Wizard cost
897             // NOTE: This math can't overflow because the total Ether supply in wei is well less than
898             //       2^128. Multiplying a price in wei by some number <100k can't possibly overflow 256 bits.
899             updatedElementalWizardCost += (updatedElementalWizardCost * elementalWizardIncrement) / TENTH_BASIS_POINTS;
900         }
901 
902         // Bring the new Wizard into existence!
903         _createWizard(wizardId, owner, costToPower(wizardCost), affinity);
904     }
905 
906     /// @notice This is it folks, the main event! The way for the world to get new Wizards! Does
907     ///         pretty much what it says on the box: Let's you conjure a new Wizard with a specified
908     ///         elemental affinity. The call must include enough eth to cover the cost of the new
909     ///         Wizard, and any excess is refunded. The power of the Wizard is derived from
910     ///         the sale price. YOU CAN NOT PAY EXTRA TO GET MORE POWER. (But you always have the option
911     ///         to conjure some more Wizards!) Returns the ID of the newly conjured Wizard.
912     /// @param affinity The elemental affinity you want for your wizard.
913     function conjureWizard(uint8 affinity) external payable onlyDuringSale returns (uint256 wizardId) {
914 
915         wizardId = nextWizardId;
916         nextWizardId++;
917 
918         uint256 wizardCost;
919 
920         (wizardCost, elementalWizardCost) = _conjureWizard(wizardId, msg.sender, affinity, elementalWizardCost);
921 
922         require(msg.value >= wizardCost, "Not enough eth to pay");
923 
924          // Refund any overpayment
925         _transferRefund(wizardCost);
926 
927         // Ensure the Wizard is being assigned to an ERC-721 aware address (either an external address,
928         // or a smart contract that implements onERC721Reived())
929         require(_checkOnERC721Received(address(0), msg.sender, wizardId, ""), "must support erc721");
930     }
931 
932     /// @notice A convenience function that allows you to get a whole bunch of Wizards at once! You know how
933     ///         there's "a pride of lions", "a murder of crows", and "a parliament of owls"? Well, with this
934     ///         here function you can conjure yourself "a stench of Cheeze Wizards"!
935     /// @dev This function is careful to bundle all of the external calls (the refund and onERC721Received)
936     ///         at the end of the function to limit the risk of reentrancy attacks.
937     /// @param affinities the elements of the wizards
938     function conjureWizardMulti(uint8[] calldata affinities) external payable onlyDuringSale
939             returns (uint256[] memory wizardIds)
940     {
941         // allocate result array
942         wizardIds = new uint256[](affinities.length);
943 
944         uint256 totalCost = 0;
945 
946         // We take these two storage variables, and turn them into local variables for the course
947         // of this loop to save about 10k gas per wizard. It's kind of ugly, but that's a lot of
948         // gas! Won't somebody please think of the children!!
949         uint256 tempWizardId = nextWizardId;
950         uint256 tempElementalWizardCost = elementalWizardCost;
951 
952         for (uint256 i = 0; i < affinities.length; i++) {
953             wizardIds[i] = tempWizardId;
954             tempWizardId++;
955 
956             uint256 wizardCost;
957 
958             (wizardCost, tempElementalWizardCost) = _conjureWizard(
959                 wizardIds[i],
960                 msg.sender,
961                 affinities[i],
962                 tempElementalWizardCost);
963 
964             totalCost += wizardCost;
965         }
966 
967         elementalWizardCost = tempElementalWizardCost;
968         nextWizardId = tempWizardId;
969 
970         // check to see if there's enough eth
971         require(msg.value >= totalCost, "Not enough eth to pay");
972 
973         // Ensure the Wizard is being assigned to an ERC-721 aware address (either an external address,
974         // or a smart contract that implements onERC721Received()). We unwind the logic of _checkOnERC721Received
975         // because called address.isContract() every time through this loop can get reasonably expensive. We do
976         // need to call this function for each token created, however, because it's allowed for an ERC-721 receiving
977         // contract to reject the transfer based on the properties of the token.
978         if (isContract(msg.sender)) {
979             for (uint256 i = 0; i < wizardIds.length; i++) {
980                 bytes4 retval = IERC721Receiver(msg.sender).onERC721Received(msg.sender, address(0), wizardIds[i], "");
981                 require(retval == _ERC721_RECEIVED, "Contract owner didn't accept ERC-721 transfer");
982             }
983         }
984 
985         // Refund any excess funds
986         _transferRefund(totalCost);
987     }
988 
989     /// @dev Transfers the current balance to the owner and terminates the contract.
990     function destroy() external onlyGuildmaster {
991         selfdestruct(guildmaster);
992     }
993 }