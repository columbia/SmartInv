1 pragma solidity ^0.5.0;
2 
3 contract BuilderShop {
4    address[] builderInstances;
5    uint contractId = 0;
6 
7    //nifty registry is hard coded
8    address niftyRegistryContract = 0x6e53130dDfF21E3BC963Ee902005223b9A202106;
9 
10    modifier onlyValidSender() {
11        NiftyRegistry nftg_registry = NiftyRegistry(niftyRegistryContract);
12        bool is_valid = nftg_registry.isValidNiftySender(msg.sender);
13        require(is_valid==true);
14        _;
15    }
16 
17    mapping (address => bool) public BuilderShops;
18 
19    function isValidBuilderShop(address builder_shop) public view returns (bool isValid) {
20        //public function, allowing anyone to check if a contract address is a valid nifty gateway contract
21        return(BuilderShops[builder_shop]);
22    }
23 
24    event BuilderInstanceCreated(address new_contract_address, uint contractId);
25 
26    function createNewBuilderInstance(
27        string memory _name,
28        string memory _symbol,
29        uint num_nifties,
30        uint[] memory nifty_quantities,
31        string memory token_base_uri,
32        string memory creator_name)
33    public onlyValidSender returns (NiftyBuilderInstance tokenAddress) {
34 
35        contractId = contractId + 1;
36 
37        NiftyBuilderInstance new_contract = new NiftyBuilderInstance(
38            _name,
39            _symbol,
40            contractId,
41            num_nifties,
42            nifty_quantities,
43            token_base_uri,
44            creator_name
45        );
46 
47        address externalId = address(new_contract);
48 
49        BuilderShops[externalId] = true;
50 
51        emit BuilderInstanceCreated(externalId, contractId);
52 
53        return (new_contract);
54     }
55 }
56 
57 /*
58 * @dev Provides information about the current execution context, including the
59 * sender of the transaction and its data. While these are generally available
60 * via msg.sender and msg.data, they should not be accessed in such a direct
61 * manner, since when dealing with GSN meta-transactions the account sending and
62 * paying for execution may not be the actual sender (as far as an application
63 * is concerned).
64 *
65 * This contract is only required for intermediate, library-like contracts.
66 */
67 contract Context {
68    // Empty internal constructor, to prevent people from mistakenly deploying
69    // an instance of this contract, which should be used via inheritance.
70    constructor () internal { }
71    // solhint-disable-previous-line no-empty-blocks
72 
73    function _msgSender() internal view returns (address payable) {
74        return msg.sender;
75    }
76 
77    function _msgData() internal view returns (bytes memory) {
78        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
79        return msg.data;
80    }
81 }
82 
83 /**
84 * @dev Interface of the ERC165 standard, as defined in the
85 * https://eips.ethereum.org/EIPS/eip-165[EIP].
86 *
87 * Implementers can declare support of contract interfaces, which can then be
88 * queried by others ({ERC165Checker}).
89 *
90 * For an implementation, see {ERC165}.
91 */
92 interface IERC165 {
93    /**
94     * @dev Returns true if this contract implements the interface defined by
95     * `interfaceId`. See the corresponding
96     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
97     * to learn more about how these ids are created.
98     *
99     * This function call must use less than 30 000 gas.
100     */
101    function supportsInterface(bytes4 interfaceId) external view returns (bool);
102 }
103 
104 /**
105 * @dev Implementation of the {IERC165} interface.
106 *
107 * Contracts may inherit from this and call {_registerInterface} to declare
108 * their support of an interface.
109 */
110 contract ERC165 is IERC165 {
111    /*
112     * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
113     */
114    bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
115 
116    /**
117     * @dev Mapping of interface ids to whether or not it's supported.
118     */
119    mapping(bytes4 => bool) private _supportedInterfaces;
120 
121    constructor () internal {
122        // Derived contracts need only register support for their own interfaces,
123        // we register support for ERC165 itself here
124        _registerInterface(_INTERFACE_ID_ERC165);
125    }
126 
127    /**
128     * @dev See {IERC165-supportsInterface}.
129     *
130     * Time complexity O(1), guaranteed to always use less than 30 000 gas.
131     */
132    function supportsInterface(bytes4 interfaceId) external view returns (bool) {
133        return _supportedInterfaces[interfaceId];
134    }
135 
136    /**
137     * @dev Registers the contract as an implementer of the interface defined by
138     * `interfaceId`. Support of the actual ERC165 interface is automatic and
139     * registering its interface id is not required.
140     *
141     * See {IERC165-supportsInterface}.
142     *
143     * Requirements:
144     *
145     * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
146     */
147    function _registerInterface(bytes4 interfaceId) internal {
148        require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
149        _supportedInterfaces[interfaceId] = true;
150    }
151 }
152 
153 /**
154 * @dev Required interface of an ERC721 compliant contract.
155 */
156 contract IERC721 is IERC165 {
157    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
158    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
159    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
160 
161    /**
162     * @dev Returns the number of NFTs in `owner`'s account.
163     */
164    function balanceOf(address owner) public view returns (uint256 balance);
165 
166    /**
167     * @dev Returns the owner of the NFT specified by `tokenId`.
168     */
169    function ownerOf(uint256 tokenId) public view returns (address owner);
170 
171    /**
172     * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
173     * another (`to`).
174     *
175     *
176     *
177     * Requirements:
178     * - `from`, `to` cannot be zero.
179     * - `tokenId` must be owned by `from`.
180     * - If the caller is not `from`, it must be have been allowed to move this
181     * NFT by either {approve} or {setApprovalForAll}.
182     */
183    function safeTransferFrom(address from, address to, uint256 tokenId) public;
184    /**
185     * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
186     * another (`to`).
187     *
188     * Requirements:
189     * - If the caller is not `from`, it must be approved to move this NFT by
190     * either {approve} or {setApprovalForAll}.
191     */
192    function transferFrom(address from, address to, uint256 tokenId) public;
193    function approve(address to, uint256 tokenId) public;
194    function getApproved(uint256 tokenId) public view returns (address operator);
195 
196    function setApprovalForAll(address operator, bool _approved) public;
197    function isApprovedForAll(address owner, address operator) public view returns (bool);
198 
199 
200    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
201 }
202 
203 /**
204 * @title ERC721 token receiver interface
205 * @dev Interface for any contract that wants to support safeTransfers
206 * from ERC721 asset contracts.
207 */
208 contract IERC721Receiver {
209    /**
210     * @notice Handle the receipt of an NFT
211     * @dev The ERC721 smart contract calls this function on the recipient
212     * after a {IERC721-safeTransferFrom}. This function MUST return the function selector,
213     * otherwise the caller will revert the transaction. The selector to be
214     * returned can be obtained as `this.onERC721Received.selector`. This
215     * function MAY throw to revert and reject the transfer.
216     * Note: the ERC721 contract address is always the message sender.
217     * @param operator The address which called `safeTransferFrom` function
218     * @param from The address which previously owned the token
219     * @param tokenId The NFT identifier which is being transferred
220     * @param data Additional data with no specified format
221     * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
222     */
223    function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
224    public returns (bytes4);
225 }
226 
227 /**
228 * @title ERC721 Non-Fungible Token Standard basic implementation
229 * @dev see https://eips.ethereum.org/EIPS/eip-721
230 */
231 contract ERC721 is Context, ERC165, IERC721 {
232    using SafeMath for uint256;
233    using Address for address;
234    using Counters for Counters.Counter;
235 
236    // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
237    // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
238    bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
239 
240    // Mapping from token ID to owner
241    mapping (uint256 => address) private _tokenOwner;
242 
243    // Mapping from token ID to approved address
244    mapping (uint256 => address) private _tokenApprovals;
245 
246    // Mapping from owner to number of owned token
247    mapping (address => Counters.Counter) private _ownedTokensCount;
248 
249    // Mapping from owner to operator approvals
250    mapping (address => mapping (address => bool)) private _operatorApprovals;
251 
252    /*
253     *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
254     *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
255     *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
256     *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
257     *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
258     *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
259     *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
260     *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
261     *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
262     *
263     *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
264     *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
265     */
266    bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
267 
268    constructor () public {
269        // register the supported interfaces to conform to ERC721 via ERC165
270        _registerInterface(_INTERFACE_ID_ERC721);
271    }
272 
273    /**
274     * @dev Gets the balance of the specified address.
275     * @param owner address to query the balance of
276     * @return uint256 representing the amount owned by the passed address
277     */
278    function balanceOf(address owner) public view returns (uint256) {
279        require(owner != address(0), "ERC721: balance query for the zero address");
280 
281        return _ownedTokensCount[owner].current();
282    }
283 
284    /**
285     * @dev Gets the owner of the specified token ID.
286     * @param tokenId uint256 ID of the token to query the owner of
287     * @return address currently marked as the owner of the given token ID
288     */
289    function ownerOf(uint256 tokenId) public view returns (address) {
290        address owner = _tokenOwner[tokenId];
291        require(owner != address(0), "ERC721: owner query for nonexistent token");
292 
293        return owner;
294    }
295 
296    /**
297     * @dev Approves another address to transfer the given token ID
298     * The zero address indicates there is no approved address.
299     * There can only be one approved address per token at a given time.
300     * Can only be called by the token owner or an approved operator.
301     * @param to address to be approved for the given token ID
302     * @param tokenId uint256 ID of the token to be approved
303     */
304    function approve(address to, uint256 tokenId) public {
305        address owner = ownerOf(tokenId);
306        require(to != owner, "ERC721: approval to current owner");
307 
308        require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
309            "ERC721: approve caller is not owner nor approved for all"
310        );
311 
312        _tokenApprovals[tokenId] = to;
313        emit Approval(owner, to, tokenId);
314    }
315 
316    /**
317     * @dev Gets the approved address for a token ID, or zero if no address set
318     * Reverts if the token ID does not exist.
319     * @param tokenId uint256 ID of the token to query the approval of
320     * @return address currently approved for the given token ID
321     */
322    function getApproved(uint256 tokenId) public view returns (address) {
323        require(_exists(tokenId), "ERC721: approved query for nonexistent token");
324 
325        return _tokenApprovals[tokenId];
326    }
327 
328    /**
329     * @dev Sets or unsets the approval of a given operator
330     * An operator is allowed to transfer all tokens of the sender on their behalf.
331     * @param to operator address to set the approval
332     * @param approved representing the status of the approval to be set
333     */
334    function setApprovalForAll(address to, bool approved) public {
335        require(to != _msgSender(), "ERC721: approve to caller");
336 
337        _operatorApprovals[_msgSender()][to] = approved;
338        emit ApprovalForAll(_msgSender(), to, approved);
339    }
340 
341    /**
342     * @dev Tells whether an operator is approved by a given owner.
343     * @param owner owner address which you want to query the approval of
344     * @param operator operator address which you want to query the approval of
345     * @return bool whether the given operator is approved by the given owner
346     */
347    function isApprovedForAll(address owner, address operator) public view returns (bool) {
348        return _operatorApprovals[owner][operator];
349    }
350 
351    /**
352     * @dev Transfers the ownership of a given token ID to another address.
353     * Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
354     * Requires the msg.sender to be the owner, approved, or operator.
355     * @param from current owner of the token
356     * @param to address to receive the ownership of the given token ID
357     * @param tokenId uint256 ID of the token to be transferred
358     */
359    function transferFrom(address from, address to, uint256 tokenId) public {
360        //solhint-disable-next-line max-line-length
361        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
362 
363        _transferFrom(from, to, tokenId);
364    }
365 
366    /**
367     * @dev Safely transfers the ownership of a given token ID to another address
368     * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
369     * which is called upon a safe transfer, and return the magic value
370     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
371     * the transfer is reverted.
372     * Requires the msg.sender to be the owner, approved, or operator
373     * @param from current owner of the token
374     * @param to address to receive the ownership of the given token ID
375     * @param tokenId uint256 ID of the token to be transferred
376     */
377    function safeTransferFrom(address from, address to, uint256 tokenId) public {
378        safeTransferFrom(from, to, tokenId, "");
379    }
380 
381    /**
382     * @dev Safely transfers the ownership of a given token ID to another address
383     * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
384     * which is called upon a safe transfer, and return the magic value
385     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
386     * the transfer is reverted.
387     * Requires the _msgSender() to be the owner, approved, or operator
388     * @param from current owner of the token
389     * @param to address to receive the ownership of the given token ID
390     * @param tokenId uint256 ID of the token to be transferred
391     * @param _data bytes data to send along with a safe transfer check
392     */
393    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
394        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
395        _safeTransferFrom(from, to, tokenId, _data);
396    }
397 
398    /**
399     * @dev Safely transfers the ownership of a given token ID to another address
400     * If the target address is a contract, it must implement `onERC721Received`,
401     * which is called upon a safe transfer, and return the magic value
402     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
403     * the transfer is reverted.
404     * Requires the msg.sender to be the owner, approved, or operator
405     * @param from current owner of the token
406     * @param to address to receive the ownership of the given token ID
407     * @param tokenId uint256 ID of the token to be transferred
408     * @param _data bytes data to send along with a safe transfer check
409     */
410    function _safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) internal {
411        _transferFrom(from, to, tokenId);
412        require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
413    }
414 
415    /**
416     * @dev Returns whether the specified token exists.
417     * @param tokenId uint256 ID of the token to query the existence of
418     * @return bool whether the token exists
419     */
420    function _exists(uint256 tokenId) internal view returns (bool) {
421        address owner = _tokenOwner[tokenId];
422        return owner != address(0);
423    }
424 
425    /**
426     * @dev Returns whether the given spender can transfer a given token ID.
427     * @param spender address of the spender to query
428     * @param tokenId uint256 ID of the token to be transferred
429     * @return bool whether the msg.sender is approved for the given token ID,
430     * is an operator of the owner, or is the owner of the token
431     */
432    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
433        require(_exists(tokenId), "ERC721: operator query for nonexistent token");
434        address owner = ownerOf(tokenId);
435        return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
436    }
437 
438    /**
439     * @dev Internal function to safely mint a new token.
440     * Reverts if the given token ID already exists.
441     * If the target address is a contract, it must implement `onERC721Received`,
442     * which is called upon a safe transfer, and return the magic value
443     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
444     * the transfer is reverted.
445     * @param to The address that will own the minted token
446     * @param tokenId uint256 ID of the token to be minted
447     */
448    function _safeMint(address to, uint256 tokenId) internal {
449        _safeMint(to, tokenId, "");
450    }
451 
452    /**
453     * @dev Internal function to safely mint a new token.
454     * Reverts if the given token ID already exists.
455     * If the target address is a contract, it must implement `onERC721Received`,
456     * which is called upon a safe transfer, and return the magic value
457     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
458     * the transfer is reverted.
459     * @param to The address that will own the minted token
460     * @param tokenId uint256 ID of the token to be minted
461     * @param _data bytes data to send along with a safe transfer check
462     */
463    function _safeMint(address to, uint256 tokenId, bytes memory _data) internal {
464        _mint(to, tokenId);
465        require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
466    }
467 
468    /**
469     * @dev Internal function to mint a new token.
470     * Reverts if the given token ID already exists.
471     * @param to The address that will own the minted token
472     * @param tokenId uint256 ID of the token to be minted
473     */
474    function _mint(address to, uint256 tokenId) internal {
475        require(to != address(0), "ERC721: mint to the zero address");
476        require(!_exists(tokenId), "ERC721: token already minted");
477 
478        _tokenOwner[tokenId] = to;
479        _ownedTokensCount[to].increment();
480 
481        emit Transfer(address(0), to, tokenId);
482    }
483 
484    /**
485     * @dev Internal function to burn a specific token.
486     * Reverts if the token does not exist.
487     * Deprecated, use {_burn} instead.
488     * @param owner owner of the token to burn
489     * @param tokenId uint256 ID of the token being burned
490     */
491    function _burn(address owner, uint256 tokenId) internal {
492        require(ownerOf(tokenId) == owner, "ERC721: burn of token that is not own");
493 
494        _clearApproval(tokenId);
495 
496        _ownedTokensCount[owner].decrement();
497        _tokenOwner[tokenId] = address(0);
498 
499        emit Transfer(owner, address(0), tokenId);
500    }
501 
502    /**
503     * @dev Internal function to burn a specific token.
504     * Reverts if the token does not exist.
505     * @param tokenId uint256 ID of the token being burned
506     */
507    function _burn(uint256 tokenId) internal {
508        _burn(ownerOf(tokenId), tokenId);
509    }
510 
511    /**
512     * @dev Internal function to transfer ownership of a given token ID to another address.
513     * As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
514     * @param from current owner of the token
515     * @param to address to receive the ownership of the given token ID
516     * @param tokenId uint256 ID of the token to be transferred
517     */
518    function _transferFrom(address from, address to, uint256 tokenId) internal {
519        require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
520        require(to != address(0), "ERC721: transfer to the zero address");
521 
522        _clearApproval(tokenId);
523 
524        _ownedTokensCount[from].decrement();
525        _ownedTokensCount[to].increment();
526 
527        _tokenOwner[tokenId] = to;
528 
529        emit Transfer(from, to, tokenId);
530    }
531 
532    /**
533     * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
534     * The call is not executed if the target address is not a contract.
535     *
536     * This function is deprecated.
537     * @param from address representing the previous owner of the given token ID
538     * @param to target address that will receive the tokens
539     * @param tokenId uint256 ID of the token to be transferred
540     * @param _data bytes optional data to send along with the call
541     * @return bool whether the call correctly returned the expected magic value
542     */
543    function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
544        internal returns (bool)
545    {
546        if (!to.isContract()) {
547            return true;
548        }
549 
550        bytes4 retval = IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data);
551        return (retval == _ERC721_RECEIVED);
552    }
553 
554    /**
555     * @dev Private function to clear current approval of a given token ID.
556     * @param tokenId uint256 ID of the token to be transferred
557     */
558    function _clearApproval(uint256 tokenId) private {
559        if (_tokenApprovals[tokenId] != address(0)) {
560            _tokenApprovals[tokenId] = address(0);
561        }
562    }
563 }
564 
565 /**
566 * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
567 * @dev See https://eips.ethereum.org/EIPS/eip-721
568 */
569 contract IERC721Enumerable is IERC721 {
570    function totalSupply() public view returns (uint256);
571    function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
572 
573    function tokenByIndex(uint256 index) public view returns (uint256);
574 }
575 
576 /**
577 * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
578 * @dev See https://eips.ethereum.org/EIPS/eip-721
579 */
580 contract ERC721Enumerable is Context, ERC165, ERC721, IERC721Enumerable {
581    // Mapping from owner to list of owned token IDs
582    mapping(address => uint256[]) private _ownedTokens;
583 
584    // Mapping from token ID to index of the owner tokens list
585    mapping(uint256 => uint256) private _ownedTokensIndex;
586 
587    // Array with all token ids, used for enumeration
588    uint256[] private _allTokens;
589 
590    // Mapping from token id to position in the allTokens array
591    mapping(uint256 => uint256) private _allTokensIndex;
592 
593    /*
594     *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
595     *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
596     *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
597     *
598     *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
599     */
600    bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
601 
602    /**
603     * @dev Constructor function.
604     */
605    constructor () public {
606        // register the supported interface to conform to ERC721Enumerable via ERC165
607        _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
608    }
609 
610    /**
611     * @dev Gets the token ID at a given index of the tokens list of the requested owner.
612     * @param owner address owning the tokens list to be accessed
613     * @param index uint256 representing the index to be accessed of the requested tokens list
614     * @return uint256 token ID at the given index of the tokens list owned by the requested address
615     */
616    function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
617        require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
618        return _ownedTokens[owner][index];
619    }
620 
621    /**
622     * @dev Gets the total amount of tokens stored by the contract.
623     * @return uint256 representing the total amount of tokens
624     */
625    function totalSupply() public view returns (uint256) {
626        return _allTokens.length;
627    }
628 
629    /**
630     * @dev Gets the token ID at a given index of all the tokens in this contract
631     * Reverts if the index is greater or equal to the total number of tokens.
632     * @param index uint256 representing the index to be accessed of the tokens list
633     * @return uint256 token ID at the given index of the tokens list
634     */
635    function tokenByIndex(uint256 index) public view returns (uint256) {
636        require(index < totalSupply(), "ERC721Enumerable: global index out of bounds");
637        return _allTokens[index];
638    }
639 
640    /**
641     * @dev Internal function to transfer ownership of a given token ID to another address.
642     * As opposed to transferFrom, this imposes no restrictions on msg.sender.
643     * @param from current owner of the token
644     * @param to address to receive the ownership of the given token ID
645     * @param tokenId uint256 ID of the token to be transferred
646     */
647    function _transferFrom(address from, address to, uint256 tokenId) internal {
648        super._transferFrom(from, to, tokenId);
649 
650        _removeTokenFromOwnerEnumeration(from, tokenId);
651 
652        _addTokenToOwnerEnumeration(to, tokenId);
653    }
654 
655    /**
656     * @dev Internal function to mint a new token.
657     * Reverts if the given token ID already exists.
658     * @param to address the beneficiary that will own the minted token
659     * @param tokenId uint256 ID of the token to be minted
660     */
661    function _mint(address to, uint256 tokenId) internal {
662        super._mint(to, tokenId);
663 
664        _addTokenToOwnerEnumeration(to, tokenId);
665 
666        _addTokenToAllTokensEnumeration(tokenId);
667    }
668 
669    /**
670     * @dev Internal function to burn a specific token.
671     * Reverts if the token does not exist.
672     * Deprecated, use {ERC721-_burn} instead.
673     * @param owner owner of the token to burn
674     * @param tokenId uint256 ID of the token being burned
675     */
676    function _burn(address owner, uint256 tokenId) internal {
677        super._burn(owner, tokenId);
678 
679        _removeTokenFromOwnerEnumeration(owner, tokenId);
680        // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
681        _ownedTokensIndex[tokenId] = 0;
682 
683        _removeTokenFromAllTokensEnumeration(tokenId);
684    }
685 
686    /**
687     * @dev Gets the list of token IDs of the requested owner.
688     * @param owner address owning the tokens
689     * @return uint256[] List of token IDs owned by the requested address
690     */
691    function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
692        return _ownedTokens[owner];
693    }
694 
695    /**
696     * @dev Private function to add a token to this extension's ownership-tracking data structures.
697     * @param to address representing the new owner of the given token ID
698     * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
699     */
700    function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
701        _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
702        _ownedTokens[to].push(tokenId);
703    }
704 
705    /**
706     * @dev Private function to add a token to this extension's token tracking data structures.
707     * @param tokenId uint256 ID of the token to be added to the tokens list
708     */
709    function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
710        _allTokensIndex[tokenId] = _allTokens.length;
711        _allTokens.push(tokenId);
712    }
713 
714    /**
715     * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
716     * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
717     * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
718     * This has O(1) time complexity, but alters the order of the _ownedTokens array.
719     * @param from address representing the previous owner of the given token ID
720     * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
721     */
722    function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
723        // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
724        // then delete the last slot (swap and pop).
725 
726        uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
727        uint256 tokenIndex = _ownedTokensIndex[tokenId];
728 
729        // When the token to delete is the last token, the swap operation is unnecessary
730        if (tokenIndex != lastTokenIndex) {
731            uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
732 
733            _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
734            _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
735        }
736 
737        // This also deletes the contents at the last position of the array
738        _ownedTokens[from].length--;
739 
740        // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occupied by
741        // lastTokenId, or just over the end of the array if the token was the last one).
742    }
743 
744    /**
745     * @dev Private function to remove a token from this extension's token tracking data structures.
746     * This has O(1) time complexity, but alters the order of the _allTokens array.
747     * @param tokenId uint256 ID of the token to be removed from the tokens list
748     */
749    function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
750        // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
751        // then delete the last slot (swap and pop).
752 
753        uint256 lastTokenIndex = _allTokens.length.sub(1);
754        uint256 tokenIndex = _allTokensIndex[tokenId];
755 
756        // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
757        // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
758        // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
759        uint256 lastTokenId = _allTokens[lastTokenIndex];
760 
761        _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
762        _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
763 
764        // This also deletes the contents at the last position of the array
765        _allTokens.length--;
766        _allTokensIndex[tokenId] = 0;
767    }
768 }
769 
770 /**
771 * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
772 * @dev See https://eips.ethereum.org/EIPS/eip-721
773 */
774 contract IERC721Metadata is IERC721 {
775    function name() external view returns (string memory);
776    function symbol() external view returns (string memory);
777    function tokenURI(uint256 tokenId) external view returns (string memory);
778 }
779 
780 contract ERC721Metadata is Context, ERC165, ERC721, IERC721Metadata {
781    // Token name
782    string private _name;
783 
784    // Token symbol
785    string private _symbol;
786 
787    // Optional mapping for token URIs
788    mapping(uint256 => string) private _tokenURIs;
789   
790    
791    //Optional mapping for IPFS link to canonical image file
792    mapping(uint256 => string) private _tokenIPFSHashes;
793 
794    /*
795     *     bytes4(keccak256('name()')) == 0x06fdde03
796     *     bytes4(keccak256('symbol()')) == 0x95d89b41
797     *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
798     *
799     *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
800     */
801    bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
802 
803    /**
804     * @dev Constructor function
805     */
806    constructor (string memory name, string memory symbol) public {
807        _name = name;
808        _symbol = symbol;
809 
810        // register the supported interfaces to conform to ERC721 via ERC165
811        _registerInterface(_INTERFACE_ID_ERC721_METADATA);
812    }
813 
814    /**
815     * @dev Gets the token name.
816     * @return string representing the token name
817     */
818    function name() external view returns (string memory) {
819        return _name;
820    }
821 
822    /**
823     * @dev Gets the token symbol.
824     * @return string representing the token symbol
825     */
826    function symbol() external view returns (string memory) {
827        return _symbol;
828    }
829 
830    /**
831     * @dev Returns an URI for a given token ID.
832     * Throws if the token ID does not exist. May return an empty string.
833     * @param tokenId uint256 ID of the token to query
834     */
835    function tokenURI(uint256 tokenId) external view returns (string memory) {
836        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
837        return _tokenURIs[tokenId];
838    }
839    
840    
841      /**
842     * @dev Returns an URI for a given token ID.
843     * Throws if the token ID does not exist. May return an empty string.
844     * @param tokenId uint256 ID of the token to query
845     */
846    function tokenIPFSHash(uint256 tokenId) external view returns (string memory) {
847        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
848        return _tokenIPFSHashes[tokenId];
849    }
850 
851    /**
852     * @dev Internal function to set the token URI for a given token.
853     * Reverts if the token ID does not exist.
854     * @param tokenId uint256 ID of the token to set its URI
855     * @param uri string URI to assign
856     */
857    function _setTokenURI(uint256 tokenId, string memory uri) internal {
858        require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
859        _tokenURIs[tokenId] = uri;
860    }
861    
862       /**
863     * @dev Internal function to set the token IPFS hash for a given token.
864     * Reverts if the token ID does not exist.
865     * @param tokenId uint256 ID of the token to set its URI
866     * @param ipfs_hash string IPFS link to assign
867     */
868    function _setTokenIPFSHash(uint256 tokenId, string memory ipfs_hash) internal {
869        require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
870        _tokenIPFSHashes[tokenId] = ipfs_hash;
871    }
872    
873    
874 
875    /**
876     * @dev Internal function to burn a specific token.
877     * Reverts if the token does not exist.
878     * Deprecated, use _burn(uint256) instead.
879     * @param owner owner of the token to burn
880     * @param tokenId uint256 ID of the token being burned by the msg.sender
881     */
882    function _burn(address owner, uint256 tokenId) internal {
883        super._burn(owner, tokenId);
884 
885        // Clear metadata (if any)
886        if (bytes(_tokenURIs[tokenId]).length != 0) {
887            delete _tokenURIs[tokenId];
888        }
889    }
890 }
891 
892 
893 /**
894 * @title Full ERC721 Token
895 * @dev This implementation includes all the required and some optional functionality of the ERC721 standard
896 * Moreover, it includes approve all functionality using operator terminology.
897 *
898 * See https://eips.ethereum.org/EIPS/eip-721
899 */
900 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
901    constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
902        // solhint-disable-previous-line no-empty-blocks
903    }
904 }
905 
906 
907 contract NiftyBuilderInstance is ERC721Full {
908 
909    //MODIFIERS
910 
911    modifier onlyValidSender() {
912        NiftyRegistry nftg_registry = NiftyRegistry(niftyRegistryContract);
913        bool is_valid = nftg_registry.isValidNiftySender(msg.sender);
914        require(is_valid==true);
915        _;
916    }
917 
918    //CONSTANTS
919 
920    // how many nifties this contract is selling
921    // used for metadat retrieval
922    uint public numNiftiesCurrentlyInContract;
923 
924    //id of this contract for metadata server
925    uint public contractId;
926 
927    //baseURI for metadata server
928    string public baseURI;
929 
930 //   //name of creator
931 //   string public creatorName;
932 
933    string public nameOfCreator;
934 
935    //nifty registry contract
936    address public niftyRegistryContract = 0x6e53130dDfF21E3BC963Ee902005223b9A202106;
937 
938    //master builder - ONLY DOES STATIC CALLS
939    address public masterBuilderContract = 0x6EFB06cF568253a53C7511BD3c31AB28BecB0192;
940 
941    using Counters for Counters.Counter;
942 
943    //MAPPINGS
944 
945    //mappings for token Ids
946    mapping (uint => Counters.Counter) public _numNiftyMinted;
947    mapping (uint => uint) public _numNiftyPermitted;
948    mapping (uint => uint) public _niftyPrice;
949    mapping (uint => string) public _niftyIPFSHashes;
950    mapping (uint => bool) public _IPFSHashHasBeenSet;
951 
952    //EVENTS
953 
954    //purchase + creation events
955    event NiftyPurchased(address _buyer, uint256 _amount, uint _tokenId);
956    event NiftyCreated(address new_owner, uint _niftyType, uint _tokenId);
957 
958    //CONSTRUCTOR FUNCTION
959 
960    constructor(
961        string memory _name,
962        string memory _symbol,
963        uint contract_id,
964        uint num_nifties,
965        uint[] memory nifty_quantities,
966        string memory base_uri,
967        string memory name_of_creator) ERC721Full(_name, _symbol) public {
968 
969        //set local variables based on inputs
970        contractId = contract_id;
971        numNiftiesCurrentlyInContract = num_nifties;
972        baseURI = base_uri;
973        nameOfCreator = name_of_creator;
974 
975        //offset starts at 1 - there is no niftyType of 0
976        for (uint i=0; i<(num_nifties); i++) {
977            _numNiftyPermitted[i+1] = nifty_quantities[i];
978        }
979    }
980    
981    function setNiftyIPFSHash(uint niftyType, 
982                             string memory ipfs_hash) onlyValidSender public {
983         //can only be set once
984         if (_IPFSHashHasBeenSet[niftyType] == true) {
985             revert("Can only be set once");
986         } else {
987             _niftyIPFSHashes[niftyType] = ipfs_hash;
988             _IPFSHashHasBeenSet[niftyType]  = true;
989         }
990     }
991 
992    function isNiftySoldOut(uint niftyType) public view returns (bool) {
993        if (niftyType > numNiftiesCurrentlyInContract) {
994            return true;
995        }
996        if (_numNiftyMinted[niftyType].current() > _numNiftyPermitted[niftyType]) {
997            return (true);
998        } else {
999            return (false);
1000        }
1001    }
1002 
1003    function giftNifty(address collector_address, 
1004                       uint niftyType) onlyValidSender public {
1005        //master for static calls
1006        BuilderMaster bm = BuilderMaster(masterBuilderContract);
1007        _numNiftyMinted[niftyType].increment();
1008        //check if this nifty is sold out
1009        if (isNiftySoldOut(niftyType)==true) {
1010            revert("Nifty sold out!");
1011        }
1012        //mint a nifty
1013        uint specificTokenId = _numNiftyMinted[niftyType].current();
1014        uint tokenId = bm.encodeTokenId(contractId, niftyType, specificTokenId);
1015        string memory tokenIdStr = bm.uint2str(tokenId);
1016        string memory tokenURI = bm.strConcat(baseURI, tokenIdStr);
1017        string memory ipfsHash = _niftyIPFSHashes[niftyType];
1018        //mint token
1019        _mint(collector_address, tokenId);
1020        _setTokenURI(tokenId, tokenURI);
1021        _setTokenIPFSHash(tokenId, ipfsHash);
1022        //do events
1023        emit NiftyCreated(collector_address, niftyType, tokenId);
1024    }
1025 
1026 }
1027 
1028 contract NiftyRegistry {
1029    function isValidNiftySender(address sending_key) public view returns (bool);
1030    function isOwner(address owner_key) public view returns (bool);
1031 }
1032 
1033 contract BuilderMaster {
1034    function getContractId(uint tokenId) public view returns (uint);
1035    function getNiftyTypeId(uint tokenId) public view returns (uint);
1036    function getSpecificNiftyNum(uint tokenId) public view returns (uint);
1037    function encodeTokenId(uint contractId, uint niftyType, uint specificNiftyNum) public view returns (uint);
1038    function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) public view returns (string memory);
1039    function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) public view returns (string memory);
1040    function strConcat(string memory _a, string memory _b, string memory _c) public view returns (string memory);
1041    function strConcat(string memory _a, string memory _b) public view returns (string memory);
1042    function uint2str(uint _i) public view returns (string memory _uintAsString);
1043 }
1044 
1045 /**
1046 * Contracts and libraries below are from OpenZeppelin, except nifty builder instance
1047 **/
1048 
1049 
1050 /**
1051 * @dev Wrappers over Solidity's arithmetic operations with added overflow
1052 * checks.
1053 *
1054 * Arithmetic operations in Solidity wrap on overflow. This can easily result
1055 * in bugs, because programmers usually assume that an overflow raises an
1056 * error, which is the standard behavior in high level programming languages.
1057 * `SafeMath` restores this intuition by reverting the transaction when an
1058 * operation overflows.
1059 *
1060 * Using this library instead of the unchecked operations eliminates an entire
1061 * class of bugs, so it's recommended to use it always.
1062 */
1063 library SafeMath {
1064    /**
1065     * @dev Returns the addition of two unsigned integers, reverting on
1066     * overflow.
1067     *
1068     * Counterpart to Solidity's `+` operator.
1069     *
1070     * Requirements:
1071     * - Addition cannot overflow.
1072     */
1073    function add(uint256 a, uint256 b) internal pure returns (uint256) {
1074        uint256 c = a + b;
1075        require(c >= a, "SafeMath: addition overflow");
1076 
1077        return c;
1078    }
1079 
1080    /**
1081     * @dev Returns the subtraction of two unsigned integers, reverting on
1082     * overflow (when the result is negative).
1083     *
1084     * Counterpart to Solidity's `-` operator.
1085     *
1086     * Requirements:
1087     * - Subtraction cannot overflow.
1088     */
1089    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1090        return sub(a, b, "SafeMath: subtraction overflow");
1091    }
1092 
1093    /**
1094     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1095     * overflow (when the result is negative).
1096     *
1097     * Counterpart to Solidity's `-` operator.
1098     *
1099     * Requirements:
1100     * - Subtraction cannot overflow.
1101     *
1102     * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
1103     * @dev Get it via `npm install @openzeppelin/contracts@next`.
1104     */
1105    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1106        require(b <= a, errorMessage);
1107        uint256 c = a - b;
1108 
1109        return c;
1110    }
1111 
1112    /**
1113     * @dev Returns the multiplication of two unsigned integers, reverting on
1114     * overflow.
1115     *
1116     * Counterpart to Solidity's `*` operator.
1117     *
1118     * Requirements:
1119     * - Multiplication cannot overflow.
1120     */
1121    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1122        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1123        // benefit is lost if 'b' is also tested.
1124        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1125        if (a == 0) {
1126            return 0;
1127        }
1128 
1129        uint256 c = a * b;
1130        require(c / a == b, "SafeMath: multiplication overflow");
1131 
1132        return c;
1133    }
1134 
1135    /**
1136     * @dev Returns the integer division of two unsigned integers. Reverts on
1137     * division by zero. The result is rounded towards zero.
1138     *
1139     * Counterpart to Solidity's `/` operator. Note: this function uses a
1140     * `revert` opcode (which leaves remaining gas untouched) while Solidity
1141     * uses an invalid opcode to revert (consuming all remaining gas).
1142     *
1143     * Requirements:
1144     * - The divisor cannot be zero.
1145     */
1146    function div(uint256 a, uint256 b) internal pure returns (uint256) {
1147        return div(a, b, "SafeMath: division by zero");
1148    }
1149 
1150    /**
1151     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
1152     * division by zero. The result is rounded towards zero.
1153     *
1154     * Counterpart to Solidity's `/` operator. Note: this function uses a
1155     * `revert` opcode (which leaves remaining gas untouched) while Solidity
1156     * uses an invalid opcode to revert (consuming all remaining gas).
1157     *
1158     * Requirements:
1159     * - The divisor cannot be zero.
1160     * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
1161     * @dev Get it via `npm install @openzeppelin/contracts@next`.
1162     */
1163    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1164        // Solidity only automatically asserts when dividing by 0
1165        require(b > 0, errorMessage);
1166        uint256 c = a / b;
1167        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1168 
1169        return c;
1170    }
1171 
1172    /**
1173     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1174     * Reverts when dividing by zero.
1175     *
1176     * Counterpart to Solidity's `%` operator. This function uses a `revert`
1177     * opcode (which leaves remaining gas untouched) while Solidity uses an
1178     * invalid opcode to revert (consuming all remaining gas).
1179     *
1180     * Requirements:
1181     * - The divisor cannot be zero.
1182     */
1183    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1184        return mod(a, b, "SafeMath: modulo by zero");
1185    }
1186 
1187    /**
1188     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1189     * Reverts with custom message when dividing by zero.
1190     *
1191     * Counterpart to Solidity's `%` operator. This function uses a `revert`
1192     * opcode (which leaves remaining gas untouched) while Solidity uses an
1193     * invalid opcode to revert (consuming all remaining gas).
1194     *
1195     * Requirements:
1196     * - The divisor cannot be zero.
1197     *
1198     * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
1199     * @dev Get it via `npm install @openzeppelin/contracts@next`.
1200     */
1201    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1202        require(b != 0, errorMessage);
1203        return a % b;
1204    }
1205 }
1206 
1207 /**
1208 * @dev Collection of functions related to the address type
1209 */
1210 library Address {
1211    /**
1212     * @dev Returns true if `account` is a contract.
1213     *
1214     * This test is non-exhaustive, and there may be false-negatives: during the
1215     * execution of a contract's constructor, its address will be reported as
1216     * not containing a contract.
1217     *
1218     * IMPORTANT: It is unsafe to assume that an address for which this
1219     * function returns false is an externally-owned account (EOA) and not a
1220     * contract.
1221     */
1222    function isContract(address account) internal view returns (bool) {
1223        // This method relies in extcodesize, which returns 0 for contracts in
1224        // construction, since the code is only stored at the end of the
1225        // constructor execution.
1226 
1227        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
1228        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
1229        // for accounts without code, i.e. `keccak256('')`
1230        bytes32 codehash;
1231        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
1232        // solhint-disable-next-line no-inline-assembly
1233        assembly { codehash := extcodehash(account) }
1234        return (codehash != 0x0 && codehash != accountHash);
1235    }
1236 
1237    /**
1238     * @dev Converts an `address` into `address payable`. Note that this is
1239     * simply a type cast: the actual underlying value is not changed.
1240     *
1241     * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
1242     * @dev Get it via `npm install @openzeppelin/contracts@next`.
1243     */
1244    function toPayable(address account) internal pure returns (address payable) {
1245        return address(uint160(account));
1246    }
1247 
1248    /**
1249     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1250     * `recipient`, forwarding all available gas and reverting on errors.
1251     *
1252     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1253     * of certain opcodes, possibly making contracts go over the 2300 gas limit
1254     * imposed by `transfer`, making them unable to receive funds via
1255     * `transfer`. {sendValue} removes this limitation.
1256     *
1257     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1258     *
1259     * IMPORTANT: because control is transferred to `recipient`, care must be
1260     * taken to not create reentrancy vulnerabilities. Consider using
1261     * {ReentrancyGuard} or the
1262     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1263     */
1264    function sendValue(address payable recipient, uint256 amount) internal {
1265        require(address(this).balance >= amount, "Address: insufficient balance");
1266 
1267        // solhint-disable-next-line avoid-call-value
1268        (bool success, ) = recipient.call.value(amount)("");
1269        require(success, "Address: unable to send value, recipient may have reverted");
1270    }
1271 }
1272 
1273 /**
1274 * @title Counters
1275 * @author Matt Condon (@shrugs)
1276 * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
1277 * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1278 *
1279 * Include with `using Counters for Counters.Counter;`
1280 * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
1281 * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
1282 * directly accessed.
1283 */
1284 library Counters {
1285    using SafeMath for uint256;
1286 
1287    struct Counter {
1288        // This variable should never be directly accessed by users of the library: interactions must be restricted to
1289        // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1290        // this feature: see https://github.com/ethereum/solidity/issues/4637
1291        uint256 _value; // default: 0
1292    }
1293 
1294    function current(Counter storage counter) internal view returns (uint256) {
1295        return counter._value;
1296    }
1297 
1298    function increment(Counter storage counter) internal {
1299        // The {SafeMath} overflow check can be skipped here, see the comment at the top
1300        counter._value += 1;
1301    }
1302 
1303    function decrement(Counter storage counter) internal {
1304        counter._value = counter._value.sub(1);
1305    }
1306 }