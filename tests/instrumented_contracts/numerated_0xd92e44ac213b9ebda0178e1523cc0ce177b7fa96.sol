1 pragma solidity ^0.5.0;
2 
3 /*
4 * @dev Provides information about the current execution context, including the
5 * sender of the transaction and its data. While these are generally available
6 * via msg.sender and msg.data, they should not be accessed in such a direct
7 * manner, since when dealing with GSN meta-transactions the account sending and
8 * paying for execution may not be the actual sender (as far as an application
9 * is concerned).
10 *
11 * This contract is only required for intermediate, library-like contracts.
12 */
13 contract Context {
14    // Empty internal constructor, to prevent people from mistakenly deploying
15    // an instance of this contract, which should be used via inheritance.
16    constructor () internal { }
17    // solhint-disable-previous-line no-empty-blocks
18 
19    function _msgSender() internal view returns (address payable) {
20        return msg.sender;
21    }
22 
23    function _msgData() internal view returns (bytes memory) {
24        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25        return msg.data;
26    }
27 }
28 
29 /**
30 * @dev Interface of the ERC165 standard, as defined in the
31 * https://eips.ethereum.org/EIPS/eip-165[EIP].
32 *
33 * Implementers can declare support of contract interfaces, which can then be
34 * queried by others ({ERC165Checker}).
35 *
36 * For an implementation, see {ERC165}.
37 */
38 interface IERC165 {
39    /**
40     * @dev Returns true if this contract implements the interface defined by
41     * `interfaceId`. See the corresponding
42     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
43     * to learn more about how these ids are created.
44     *
45     * This function call must use less than 30 000 gas.
46     */
47    function supportsInterface(bytes4 interfaceId) external view returns (bool);
48 }
49 
50 /**
51 * @dev Implementation of the {IERC165} interface.
52 *
53 * Contracts may inherit from this and call {_registerInterface} to declare
54 * their support of an interface.
55 */
56 contract ERC165 is IERC165 {
57    /*
58     * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
59     */
60    bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
61 
62    /**
63     * @dev Mapping of interface ids to whether or not it's supported.
64     */
65    mapping(bytes4 => bool) private _supportedInterfaces;
66 
67    constructor () internal {
68        // Derived contracts need only register support for their own interfaces,
69        // we register support for ERC165 itself here
70        _registerInterface(_INTERFACE_ID_ERC165);
71    }
72 
73    /**
74     * @dev See {IERC165-supportsInterface}.
75     *
76     * Time complexity O(1), guaranteed to always use less than 30 000 gas.
77     */
78    function supportsInterface(bytes4 interfaceId) external view returns (bool) {
79        return _supportedInterfaces[interfaceId];
80    }
81 
82    /**
83     * @dev Registers the contract as an implementer of the interface defined by
84     * `interfaceId`. Support of the actual ERC165 interface is automatic and
85     * registering its interface id is not required.
86     *
87     * See {IERC165-supportsInterface}.
88     *
89     * Requirements:
90     *
91     * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
92     */
93    function _registerInterface(bytes4 interfaceId) internal {
94        require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
95        _supportedInterfaces[interfaceId] = true;
96    }
97 }
98 
99 /**
100 * @dev Required interface of an ERC721 compliant contract.
101 */
102 contract IERC721 is IERC165 {
103    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
104    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
105    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
106 
107    /**
108     * @dev Returns the number of NFTs in `owner`'s account.
109     */
110    function balanceOf(address owner) public view returns (uint256 balance);
111 
112    /**
113     * @dev Returns the owner of the NFT specified by `tokenId`.
114     */
115    function ownerOf(uint256 tokenId) public view returns (address owner);
116 
117    /**
118     * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
119     * another (`to`).
120     *
121     *
122     *
123     * Requirements:
124     * - `from`, `to` cannot be zero.
125     * - `tokenId` must be owned by `from`.
126     * - If the caller is not `from`, it must be have been allowed to move this
127     * NFT by either {approve} or {setApprovalForAll}.
128     */
129    function safeTransferFrom(address from, address to, uint256 tokenId) public;
130    /**
131     * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
132     * another (`to`).
133     *
134     * Requirements:
135     * - If the caller is not `from`, it must be approved to move this NFT by
136     * either {approve} or {setApprovalForAll}.
137     */
138    function transferFrom(address from, address to, uint256 tokenId) public;
139    function approve(address to, uint256 tokenId) public;
140    function getApproved(uint256 tokenId) public view returns (address operator);
141 
142    function setApprovalForAll(address operator, bool _approved) public;
143    function isApprovedForAll(address owner, address operator) public view returns (bool);
144 
145 
146    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
147 }
148 
149 /**
150 * @title ERC721 token receiver interface
151 * @dev Interface for any contract that wants to support safeTransfers
152 * from ERC721 asset contracts.
153 */
154 contract IERC721Receiver {
155    /**
156     * @notice Handle the receipt of an NFT
157     * @dev The ERC721 smart contract calls this function on the recipient
158     * after a {IERC721-safeTransferFrom}. This function MUST return the function selector,
159     * otherwise the caller will revert the transaction. The selector to be
160     * returned can be obtained as `this.onERC721Received.selector`. This
161     * function MAY throw to revert and reject the transfer.
162     * Note: the ERC721 contract address is always the message sender.
163     * @param operator The address which called `safeTransferFrom` function
164     * @param from The address which previously owned the token
165     * @param tokenId The NFT identifier which is being transferred
166     * @param data Additional data with no specified format
167     * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
168     */
169    function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
170    public returns (bytes4);
171 }
172 
173 /**
174 * @title ERC721 Non-Fungible Token Standard basic implementation
175 * @dev see https://eips.ethereum.org/EIPS/eip-721
176 */
177 contract ERC721 is Context, ERC165, IERC721 {
178    using SafeMath for uint256;
179    using Address for address;
180    using Counters for Counters.Counter;
181 
182    // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
183    // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
184    bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
185 
186    // Mapping from token ID to owner
187    mapping (uint256 => address) private _tokenOwner;
188 
189    // Mapping from token ID to approved address
190    mapping (uint256 => address) private _tokenApprovals;
191 
192    // Mapping from owner to number of owned token
193    mapping (address => Counters.Counter) private _ownedTokensCount;
194 
195    // Mapping from owner to operator approvals
196    mapping (address => mapping (address => bool)) private _operatorApprovals;
197 
198    /*
199     *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
200     *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
201     *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
202     *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
203     *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
204     *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
205     *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
206     *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
207     *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
208     *
209     *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
210     *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
211     */
212    bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
213 
214    constructor () public {
215        // register the supported interfaces to conform to ERC721 via ERC165
216        _registerInterface(_INTERFACE_ID_ERC721);
217    }
218 
219    /**
220     * @dev Gets the balance of the specified address.
221     * @param owner address to query the balance of
222     * @return uint256 representing the amount owned by the passed address
223     */
224    function balanceOf(address owner) public view returns (uint256) {
225        require(owner != address(0), "ERC721: balance query for the zero address");
226 
227        return _ownedTokensCount[owner].current();
228    }
229 
230    /**
231     * @dev Gets the owner of the specified token ID.
232     * @param tokenId uint256 ID of the token to query the owner of
233     * @return address currently marked as the owner of the given token ID
234     */
235    function ownerOf(uint256 tokenId) public view returns (address) {
236        address owner = _tokenOwner[tokenId];
237        require(owner != address(0), "ERC721: owner query for nonexistent token");
238 
239        return owner;
240    }
241 
242    /**
243     * @dev Approves another address to transfer the given token ID
244     * The zero address indicates there is no approved address.
245     * There can only be one approved address per token at a given time.
246     * Can only be called by the token owner or an approved operator.
247     * @param to address to be approved for the given token ID
248     * @param tokenId uint256 ID of the token to be approved
249     */
250    function approve(address to, uint256 tokenId) public {
251        address owner = ownerOf(tokenId);
252        require(to != owner, "ERC721: approval to current owner");
253 
254        require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
255            "ERC721: approve caller is not owner nor approved for all"
256        );
257 
258        _tokenApprovals[tokenId] = to;
259        emit Approval(owner, to, tokenId);
260    }
261 
262    /**
263     * @dev Gets the approved address for a token ID, or zero if no address set
264     * Reverts if the token ID does not exist.
265     * @param tokenId uint256 ID of the token to query the approval of
266     * @return address currently approved for the given token ID
267     */
268    function getApproved(uint256 tokenId) public view returns (address) {
269        require(_exists(tokenId), "ERC721: approved query for nonexistent token");
270 
271        return _tokenApprovals[tokenId];
272    }
273 
274    /**
275     * @dev Sets or unsets the approval of a given operator
276     * An operator is allowed to transfer all tokens of the sender on their behalf.
277     * @param to operator address to set the approval
278     * @param approved representing the status of the approval to be set
279     */
280    function setApprovalForAll(address to, bool approved) public {
281        require(to != _msgSender(), "ERC721: approve to caller");
282 
283        _operatorApprovals[_msgSender()][to] = approved;
284        emit ApprovalForAll(_msgSender(), to, approved);
285    }
286 
287    /**
288     * @dev Tells whether an operator is approved by a given owner.
289     * @param owner owner address which you want to query the approval of
290     * @param operator operator address which you want to query the approval of
291     * @return bool whether the given operator is approved by the given owner
292     */
293    function isApprovedForAll(address owner, address operator) public view returns (bool) {
294        return _operatorApprovals[owner][operator];
295    }
296 
297    /**
298     * @dev Transfers the ownership of a given token ID to another address.
299     * Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
300     * Requires the msg.sender to be the owner, approved, or operator.
301     * @param from current owner of the token
302     * @param to address to receive the ownership of the given token ID
303     * @param tokenId uint256 ID of the token to be transferred
304     */
305    function transferFrom(address from, address to, uint256 tokenId) public {
306        //solhint-disable-next-line max-line-length
307        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
308 
309        _transferFrom(from, to, tokenId);
310    }
311 
312    /**
313     * @dev Safely transfers the ownership of a given token ID to another address
314     * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
315     * which is called upon a safe transfer, and return the magic value
316     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
317     * the transfer is reverted.
318     * Requires the msg.sender to be the owner, approved, or operator
319     * @param from current owner of the token
320     * @param to address to receive the ownership of the given token ID
321     * @param tokenId uint256 ID of the token to be transferred
322     */
323    function safeTransferFrom(address from, address to, uint256 tokenId) public {
324        safeTransferFrom(from, to, tokenId, "");
325    }
326 
327    /**
328     * @dev Safely transfers the ownership of a given token ID to another address
329     * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
330     * which is called upon a safe transfer, and return the magic value
331     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
332     * the transfer is reverted.
333     * Requires the _msgSender() to be the owner, approved, or operator
334     * @param from current owner of the token
335     * @param to address to receive the ownership of the given token ID
336     * @param tokenId uint256 ID of the token to be transferred
337     * @param _data bytes data to send along with a safe transfer check
338     */
339    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
340        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
341        _safeTransferFrom(from, to, tokenId, _data);
342    }
343 
344    /**
345     * @dev Safely transfers the ownership of a given token ID to another address
346     * If the target address is a contract, it must implement `onERC721Received`,
347     * which is called upon a safe transfer, and return the magic value
348     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
349     * the transfer is reverted.
350     * Requires the msg.sender to be the owner, approved, or operator
351     * @param from current owner of the token
352     * @param to address to receive the ownership of the given token ID
353     * @param tokenId uint256 ID of the token to be transferred
354     * @param _data bytes data to send along with a safe transfer check
355     */
356    function _safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) internal {
357        _transferFrom(from, to, tokenId);
358        require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
359    }
360 
361    /**
362     * @dev Returns whether the specified token exists.
363     * @param tokenId uint256 ID of the token to query the existence of
364     * @return bool whether the token exists
365     */
366    function _exists(uint256 tokenId) internal view returns (bool) {
367        address owner = _tokenOwner[tokenId];
368        return owner != address(0);
369    }
370 
371    /**
372     * @dev Returns whether the given spender can transfer a given token ID.
373     * @param spender address of the spender to query
374     * @param tokenId uint256 ID of the token to be transferred
375     * @return bool whether the msg.sender is approved for the given token ID,
376     * is an operator of the owner, or is the owner of the token
377     */
378    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
379        require(_exists(tokenId), "ERC721: operator query for nonexistent token");
380        address owner = ownerOf(tokenId);
381        return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
382    }
383 
384    /**
385     * @dev Internal function to safely mint a new token.
386     * Reverts if the given token ID already exists.
387     * If the target address is a contract, it must implement `onERC721Received`,
388     * which is called upon a safe transfer, and return the magic value
389     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
390     * the transfer is reverted.
391     * @param to The address that will own the minted token
392     * @param tokenId uint256 ID of the token to be minted
393     */
394    function _safeMint(address to, uint256 tokenId) internal {
395        _safeMint(to, tokenId, "");
396    }
397 
398    /**
399     * @dev Internal function to safely mint a new token.
400     * Reverts if the given token ID already exists.
401     * If the target address is a contract, it must implement `onERC721Received`,
402     * which is called upon a safe transfer, and return the magic value
403     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
404     * the transfer is reverted.
405     * @param to The address that will own the minted token
406     * @param tokenId uint256 ID of the token to be minted
407     * @param _data bytes data to send along with a safe transfer check
408     */
409    function _safeMint(address to, uint256 tokenId, bytes memory _data) internal {
410        _mint(to, tokenId);
411        require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
412    }
413 
414    /**
415     * @dev Internal function to mint a new token.
416     * Reverts if the given token ID already exists.
417     * @param to The address that will own the minted token
418     * @param tokenId uint256 ID of the token to be minted
419     */
420    function _mint(address to, uint256 tokenId) internal {
421        require(to != address(0), "ERC721: mint to the zero address");
422        require(!_exists(tokenId), "ERC721: token already minted");
423 
424        _tokenOwner[tokenId] = to;
425        _ownedTokensCount[to].increment();
426 
427        emit Transfer(address(0), to, tokenId);
428    }
429 
430    /**
431     * @dev Internal function to burn a specific token.
432     * Reverts if the token does not exist.
433     * Deprecated, use {_burn} instead.
434     * @param owner owner of the token to burn
435     * @param tokenId uint256 ID of the token being burned
436     */
437    function _burn(address owner, uint256 tokenId) internal {
438        require(ownerOf(tokenId) == owner, "ERC721: burn of token that is not own");
439 
440        _clearApproval(tokenId);
441 
442        _ownedTokensCount[owner].decrement();
443        _tokenOwner[tokenId] = address(0);
444 
445        emit Transfer(owner, address(0), tokenId);
446    }
447 
448    /**
449     * @dev Internal function to burn a specific token.
450     * Reverts if the token does not exist.
451     * @param tokenId uint256 ID of the token being burned
452     */
453    function _burn(uint256 tokenId) internal {
454        _burn(ownerOf(tokenId), tokenId);
455    }
456 
457    /**
458     * @dev Internal function to transfer ownership of a given token ID to another address.
459     * As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
460     * @param from current owner of the token
461     * @param to address to receive the ownership of the given token ID
462     * @param tokenId uint256 ID of the token to be transferred
463     */
464    function _transferFrom(address from, address to, uint256 tokenId) internal {
465        require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
466        require(to != address(0), "ERC721: transfer to the zero address");
467 
468        _clearApproval(tokenId);
469 
470        _ownedTokensCount[from].decrement();
471        _ownedTokensCount[to].increment();
472 
473        _tokenOwner[tokenId] = to;
474 
475        emit Transfer(from, to, tokenId);
476    }
477 
478    /**
479     * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
480     * The call is not executed if the target address is not a contract.
481     *
482     * This function is deprecated.
483     * @param from address representing the previous owner of the given token ID
484     * @param to target address that will receive the tokens
485     * @param tokenId uint256 ID of the token to be transferred
486     * @param _data bytes optional data to send along with the call
487     * @return bool whether the call correctly returned the expected magic value
488     */
489    function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
490        internal returns (bool)
491    {
492        if (!to.isContract()) {
493            return true;
494        }
495 
496        bytes4 retval = IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data);
497        return (retval == _ERC721_RECEIVED);
498    }
499 
500    /**
501     * @dev Private function to clear current approval of a given token ID.
502     * @param tokenId uint256 ID of the token to be transferred
503     */
504    function _clearApproval(uint256 tokenId) private {
505        if (_tokenApprovals[tokenId] != address(0)) {
506            _tokenApprovals[tokenId] = address(0);
507        }
508    }
509 }
510 
511 /**
512 * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
513 * @dev See https://eips.ethereum.org/EIPS/eip-721
514 */
515 contract IERC721Enumerable is IERC721 {
516    function totalSupply() public view returns (uint256);
517    function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
518 
519    function tokenByIndex(uint256 index) public view returns (uint256);
520 }
521 
522 /**
523 * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
524 * @dev See https://eips.ethereum.org/EIPS/eip-721
525 */
526 contract ERC721Enumerable is Context, ERC165, ERC721, IERC721Enumerable {
527    // Mapping from owner to list of owned token IDs
528    mapping(address => uint256[]) private _ownedTokens;
529 
530    // Mapping from token ID to index of the owner tokens list
531    mapping(uint256 => uint256) private _ownedTokensIndex;
532 
533    // Array with all token ids, used for enumeration
534    uint256[] private _allTokens;
535 
536    // Mapping from token id to position in the allTokens array
537    mapping(uint256 => uint256) private _allTokensIndex;
538 
539    /*
540     *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
541     *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
542     *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
543     *
544     *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
545     */
546    bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
547 
548    /**
549     * @dev Constructor function.
550     */
551    constructor () public {
552        // register the supported interface to conform to ERC721Enumerable via ERC165
553        _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
554    }
555 
556    /**
557     * @dev Gets the token ID at a given index of the tokens list of the requested owner.
558     * @param owner address owning the tokens list to be accessed
559     * @param index uint256 representing the index to be accessed of the requested tokens list
560     * @return uint256 token ID at the given index of the tokens list owned by the requested address
561     */
562    function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
563        require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
564        return _ownedTokens[owner][index];
565    }
566 
567    /**
568     * @dev Gets the total amount of tokens stored by the contract.
569     * @return uint256 representing the total amount of tokens
570     */
571    function totalSupply() public view returns (uint256) {
572        return _allTokens.length;
573    }
574 
575    /**
576     * @dev Gets the token ID at a given index of all the tokens in this contract
577     * Reverts if the index is greater or equal to the total number of tokens.
578     * @param index uint256 representing the index to be accessed of the tokens list
579     * @return uint256 token ID at the given index of the tokens list
580     */
581    function tokenByIndex(uint256 index) public view returns (uint256) {
582        require(index < totalSupply(), "ERC721Enumerable: global index out of bounds");
583        return _allTokens[index];
584    }
585 
586    /**
587     * @dev Internal function to transfer ownership of a given token ID to another address.
588     * As opposed to transferFrom, this imposes no restrictions on msg.sender.
589     * @param from current owner of the token
590     * @param to address to receive the ownership of the given token ID
591     * @param tokenId uint256 ID of the token to be transferred
592     */
593    function _transferFrom(address from, address to, uint256 tokenId) internal {
594        super._transferFrom(from, to, tokenId);
595 
596        _removeTokenFromOwnerEnumeration(from, tokenId);
597 
598        _addTokenToOwnerEnumeration(to, tokenId);
599    }
600 
601    /**
602     * @dev Internal function to mint a new token.
603     * Reverts if the given token ID already exists.
604     * @param to address the beneficiary that will own the minted token
605     * @param tokenId uint256 ID of the token to be minted
606     */
607    function _mint(address to, uint256 tokenId) internal {
608        super._mint(to, tokenId);
609 
610        _addTokenToOwnerEnumeration(to, tokenId);
611 
612        _addTokenToAllTokensEnumeration(tokenId);
613    }
614 
615    /**
616     * @dev Internal function to burn a specific token.
617     * Reverts if the token does not exist.
618     * Deprecated, use {ERC721-_burn} instead.
619     * @param owner owner of the token to burn
620     * @param tokenId uint256 ID of the token being burned
621     */
622    function _burn(address owner, uint256 tokenId) internal {
623        super._burn(owner, tokenId);
624 
625        _removeTokenFromOwnerEnumeration(owner, tokenId);
626        // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
627        _ownedTokensIndex[tokenId] = 0;
628 
629        _removeTokenFromAllTokensEnumeration(tokenId);
630    }
631 
632    /**
633     * @dev Gets the list of token IDs of the requested owner.
634     * @param owner address owning the tokens
635     * @return uint256[] List of token IDs owned by the requested address
636     */
637    function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
638        return _ownedTokens[owner];
639    }
640 
641    /**
642     * @dev Private function to add a token to this extension's ownership-tracking data structures.
643     * @param to address representing the new owner of the given token ID
644     * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
645     */
646    function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
647        _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
648        _ownedTokens[to].push(tokenId);
649    }
650 
651    /**
652     * @dev Private function to add a token to this extension's token tracking data structures.
653     * @param tokenId uint256 ID of the token to be added to the tokens list
654     */
655    function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
656        _allTokensIndex[tokenId] = _allTokens.length;
657        _allTokens.push(tokenId);
658    }
659 
660    /**
661     * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
662     * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
663     * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
664     * This has O(1) time complexity, but alters the order of the _ownedTokens array.
665     * @param from address representing the previous owner of the given token ID
666     * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
667     */
668    function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
669        // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
670        // then delete the last slot (swap and pop).
671 
672        uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
673        uint256 tokenIndex = _ownedTokensIndex[tokenId];
674 
675        // When the token to delete is the last token, the swap operation is unnecessary
676        if (tokenIndex != lastTokenIndex) {
677            uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
678 
679            _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
680            _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
681        }
682 
683        // This also deletes the contents at the last position of the array
684        _ownedTokens[from].length--;
685 
686        // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occupied by
687        // lastTokenId, or just over the end of the array if the token was the last one).
688    }
689 
690    /**
691     * @dev Private function to remove a token from this extension's token tracking data structures.
692     * This has O(1) time complexity, but alters the order of the _allTokens array.
693     * @param tokenId uint256 ID of the token to be removed from the tokens list
694     */
695    function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
696        // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
697        // then delete the last slot (swap and pop).
698 
699        uint256 lastTokenIndex = _allTokens.length.sub(1);
700        uint256 tokenIndex = _allTokensIndex[tokenId];
701 
702        // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
703        // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
704        // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
705        uint256 lastTokenId = _allTokens[lastTokenIndex];
706 
707        _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
708        _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
709 
710        // This also deletes the contents at the last position of the array
711        _allTokens.length--;
712        _allTokensIndex[tokenId] = 0;
713    }
714 }
715 
716 /**
717 * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
718 * @dev See https://eips.ethereum.org/EIPS/eip-721
719 */
720 contract IERC721Metadata is IERC721 {
721    function name() external view returns (string memory);
722    function symbol() external view returns (string memory);
723    function tokenURI(uint256 tokenId) external view returns (string memory);
724 }
725 
726 contract ERC721Metadata is Context, ERC165, ERC721, IERC721Metadata {
727    // Token name
728    string private _name;
729 
730    // Token symbol
731    string private _symbol;
732 
733    // Optional mapping for token URIs
734    mapping(uint256 => string) private _tokenURIs;
735   
736    
737    //Optional mapping for IPFS link to canonical image file
738    mapping(uint256 => string) private _tokenIPFSHashes;
739    
740    mapping(uint256 => string) private _niftyTypeName;
741    
742     //Optional mapping for IPFS link to canonical image file by  Nifty type 
743    mapping(uint256 => string) private _niftyTypeIPFSHashes;
744    
745    //Token name 
746    mapping(uint256 => string) private _tokenName;
747 
748    /*
749     *     bytes4(keccak256('name()')) == 0x06fdde03
750     *     bytes4(keccak256('symbol()')) == 0x95d89b41
751     *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
752     *
753     *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
754     */
755    bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
756 
757    /**
758     * @dev Constructor function
759     */
760    constructor (string memory name, string memory symbol) public {
761        _name = name;
762        _symbol = symbol;
763 
764        // register the supported interfaces to conform to ERC721 via ERC165
765        _registerInterface(_INTERFACE_ID_ERC721_METADATA);
766    }
767 
768    /**
769     * @dev Gets the token name.
770     * @return string representing the token name
771     */
772    function name() external view returns (string memory) {
773        return _name;
774    }
775 
776    /**
777     * @dev Gets the token symbol.
778     * @return string representing the token symbol
779     */
780    function symbol() external view returns (string memory) {
781        return _symbol;
782    }
783    
784       //master builder - ONLY DOES STATIC CALLS
785    address public masterBuilderContract = 0x6EFB06cF568253a53C7511BD3c31AB28BecB0192;
786 
787    /**
788     * @dev Returns an URI for a given token ID.
789     * Throws if the token ID does not exist. May return an empty string.
790     * @param tokenId uint256 ID of the token to query
791     */
792    function tokenURI(uint256 tokenId) external view returns (string memory) {
793        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
794        return _tokenURIs[tokenId];
795    }
796    
797    
798      /**
799     * @dev Returns an IPFS Hash for a given token ID.
800     * Throws if the token ID does not exist. May return an empty string.
801     * @param tokenId uint256 ID of the token to query
802     */
803    function tokenIPFSHash(uint256 tokenId) external view returns (string memory) {
804        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
805         //master for static calls
806        BuilderMaster bm = BuilderMaster(masterBuilderContract);
807        uint nifty_type = bm.getNiftyTypeId(tokenId);
808        return _niftyTypeIPFSHashes[nifty_type];
809    }
810    
811         /**
812     * @dev Returns an URI for a given token ID.
813     * Throws if the token ID does not exist. May return an empty string.
814     * @param tokenId uint256 ID of the token to query
815     */
816    function tokenName(uint256 tokenId) external view returns (string memory) {
817        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
818         //master for static calls
819        BuilderMaster bm = BuilderMaster(masterBuilderContract);
820        uint nifty_type = bm.getNiftyTypeId(tokenId);
821        return _niftyTypeName[nifty_type];
822    }
823 
824    /**
825     * @dev Internal function to set the token URI for a given token.
826     * Reverts if the token ID does not exist.
827     * @param tokenId uint256 ID of the token to set its URI
828     * @param uri string URI to assign
829     */
830    function _setTokenURI(uint256 tokenId, string memory uri) internal {
831        require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
832        _tokenURIs[tokenId] = uri;
833    }
834    
835       /**
836     * @dev Internal function to set the token IPFS hash for a given token.
837     * Reverts if the token ID does not exist.
838     * @param tokenId uint256 ID of the token to set its URI
839     * @param ipfs_hash string IPFS link to assign
840     */
841    function _setTokenIPFSHash(uint256 tokenId, string memory ipfs_hash) internal {
842        require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
843        _tokenIPFSHashes[tokenId] = ipfs_hash;
844    }
845    
846             /**
847     * @dev Internal function to set the token IPFS hash for a given token.
848     * Reverts if the token ID does not exist.
849     * @param niftyType uint256 ID of the token to set its URI
850     * @param ipfs_hash string IPFS link to assign
851     */
852    function _setTokenIPFSHashNiftyType(uint256 niftyType, string memory ipfs_hash) internal {
853     //   require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
854        _niftyTypeIPFSHashes[niftyType] = ipfs_hash;
855    }
856    
857          /**
858     * @dev Internal function to set the token IPFS hash for a given token.
859     * Reverts if the token ID does not exist.
860     * @param nifty_type uint256 of nifty type name to be set
861     * @param nifty_type_name name of nifty type
862     */
863    function _setNiftyTypeName(uint256 nifty_type, string memory nifty_type_name) internal {
864        _niftyTypeName[nifty_type] = nifty_type_name;
865    }
866    
867    
868 
869    /**
870     * @dev Internal function to burn a specific token.
871     * Reverts if the token does not exist.
872     * Deprecated, use _burn(uint256) instead.
873     * @param owner owner of the token to burn
874     * @param tokenId uint256 ID of the token being burned by the msg.sender
875     */
876    function _burn(address owner, uint256 tokenId) internal {
877        super._burn(owner, tokenId);
878 
879        // Clear metadata (if any)
880        if (bytes(_tokenURIs[tokenId]).length != 0) {
881            delete _tokenURIs[tokenId];
882        }
883    }
884 }
885 
886 
887 /**
888 * @title Full ERC721 Token
889 * @dev This implementation includes all the required and some optional functionality of the ERC721 standard
890 * Moreover, it includes approve all functionality using operator terminology.
891 *
892 * See https://eips.ethereum.org/EIPS/eip-721
893 */
894 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
895    constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
896        // solhint-disable-previous-line no-empty-blocks
897    }
898 }
899 
900 
901 contract BeepleCollectionTwoOpenEdition is ERC721Full {
902 
903    //MODIFIERS
904    
905    modifier onlyOwner() {
906        require(msg.sender == contractOwner);
907        _;
908    }
909 
910    //CONSTANTS
911 
912    // how many nifties this contract is selling
913    // used for metadat retrieval
914    uint public numNiftiesCurrentlyInContract;
915 
916    //id of this contract for metadata server
917    uint public contractId;
918 
919    //baseURI for metadata server
920    string public baseURI;
921    
922    // name of creator
923    string public nameOfCreator;
924    
925    address public contractOwner;
926 
927    //master builder - ONLY DOES STATIC CALLS
928    address public masterBuilderContract = 0x6EFB06cF568253a53C7511BD3c31AB28BecB0192;
929 
930    using Counters for Counters.Counter;
931 
932    //MAPPINGS
933 
934    //mappings for token Ids
935    mapping (uint => Counters.Counter) public _numNiftyMinted;
936    mapping (uint => uint) public _numNiftyPermitted;
937    mapping (uint => uint) public _niftyPrice;
938    mapping (uint => string) public _niftyIPFSHashes;
939 //   mapping (uint => bool) public _IPFSHashHasBeenSet;
940 
941    //EVENTS
942 
943    //purchase + creation events
944    event NiftyPurchased(address _buyer, uint256 _amount, uint _tokenId);
945    event NiftyCreated(address new_owner, uint _niftyType, uint _tokenId);
946 
947    //CONSTRUCTOR FUNCTION
948 
949    constructor(
950        string memory base_uri) ERC721Full("Beeple Round 2 Open Edition", "BEEPLE2") public {
951            
952        //set contract owner to deployer wallet
953        contractOwner = msg.sender;
954 
955        //set local variables based on inputs
956        contractId = 1;
957        numNiftiesCurrentlyInContract = 3;
958        baseURI = base_uri;
959        nameOfCreator = "Beeple";
960        
961        //3 open editions
962        _numNiftyPermitted[1] = 9999;
963        _numNiftyPermitted[2] = 9999;
964        _numNiftyPermitted[3] = 9999;
965        
966        //set names
967        _setNiftyTypeName(1, "BULL RUN");
968        _setNiftyTypeName(2, "INFECTED");
969        _setNiftyTypeName(3, "INTO THE ETHER");
970 
971    }
972    
973    function setNiftyName (uint niftyType, string memory niftyName) onlyOwner public {
974        //allow owner to change nifty name
975         _setNiftyTypeName(niftyType, niftyName);
976    }
977    
978    function setBaseURI(string memory newBaseURI) onlyOwner public {
979        //allow owner to change base URI
980         baseURI = newBaseURI;
981    }
982 
983    function isNiftySoldOut(uint niftyType) public view returns (bool) {
984        if (niftyType > numNiftiesCurrentlyInContract) {
985            return true;
986        }
987        if (_numNiftyMinted[niftyType].current() > _numNiftyPermitted[niftyType]) {
988            return (true);
989        } else {
990            return (false);
991        }
992    }
993 
994    function giftNifty(address collector_address, 
995                       uint niftyType) onlyOwner public {
996        //master for static calls
997        BuilderMaster bm = BuilderMaster(masterBuilderContract);
998        _numNiftyMinted[niftyType].increment();
999        //check if this nifty is sold out
1000        if (isNiftySoldOut(niftyType)==true) {
1001            revert("Nifty sold out!");
1002        }
1003        //mint a nifty
1004        uint specificTokenId = _numNiftyMinted[niftyType].current();
1005        uint tokenId = bm.encodeTokenId(contractId, niftyType, specificTokenId);
1006        string memory tokenIdStr = bm.uint2str(tokenId);
1007        string memory tokenURI = bm.strConcat(baseURI, tokenIdStr);
1008        //mint token
1009        _mint(collector_address, tokenId);
1010        _setTokenURI(tokenId, tokenURI);
1011        //do events
1012        emit NiftyCreated(collector_address, niftyType, tokenId);
1013    }
1014    
1015     function massMintNFTs(address collector_address, uint numToMint, uint niftyType) onlyOwner public {
1016         //loop through array and create nifties
1017         for (uint i=0; i < numToMint; i++) {
1018             giftNifty(collector_address,niftyType);
1019         }
1020        
1021    }
1022    
1023    function closeOpenEdition() onlyOwner public {
1024        _numNiftyPermitted[1] = _numNiftyMinted[1].current();
1025        _numNiftyPermitted[2] = _numNiftyMinted[2].current();
1026        _numNiftyPermitted[3] = _numNiftyMinted[3].current();
1027    }
1028 
1029 }
1030 
1031 contract NiftyRegistry {
1032    function isValidNiftySender(address sending_key) public view returns (bool);
1033    function isOwner(address owner_key) public view returns (bool);
1034 }
1035 
1036 contract BuilderMaster {
1037    function getContractId(uint tokenId) public view returns (uint);
1038    function getNiftyTypeId(uint tokenId) public view returns (uint);
1039    function getSpecificNiftyNum(uint tokenId) public view returns (uint);
1040    function encodeTokenId(uint contractId, uint niftyType, uint specificNiftyNum) public view returns (uint);
1041    function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) public view returns (string memory);
1042    function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) public view returns (string memory);
1043    function strConcat(string memory _a, string memory _b, string memory _c) public view returns (string memory);
1044    function strConcat(string memory _a, string memory _b) public view returns (string memory);
1045    function uint2str(uint _i) public view returns (string memory _uintAsString);
1046 }
1047 
1048 /**
1049 * Contracts and libraries below are from OpenZeppelin, except nifty builder instance
1050 **/
1051 
1052 
1053 /**
1054 * @dev Wrappers over Solidity's arithmetic operations with added overflow
1055 * checks.
1056 *
1057 * Arithmetic operations in Solidity wrap on overflow. This can easily result
1058 * in bugs, because programmers usually assume that an overflow raises an
1059 * error, which is the standard behavior in high level programming languages.
1060 * `SafeMath` restores this intuition by reverting the transaction when an
1061 * operation overflows.
1062 *
1063 * Using this library instead of the unchecked operations eliminates an entire
1064 * class of bugs, so it's recommended to use it always.
1065 */
1066 library SafeMath {
1067    /**
1068     * @dev Returns the addition of two unsigned integers, reverting on
1069     * overflow.
1070     *
1071     * Counterpart to Solidity's `+` operator.
1072     *
1073     * Requirements:
1074     * - Addition cannot overflow.
1075     */
1076    function add(uint256 a, uint256 b) internal pure returns (uint256) {
1077        uint256 c = a + b;
1078        require(c >= a, "SafeMath: addition overflow");
1079 
1080        return c;
1081    }
1082 
1083    /**
1084     * @dev Returns the subtraction of two unsigned integers, reverting on
1085     * overflow (when the result is negative).
1086     *
1087     * Counterpart to Solidity's `-` operator.
1088     *
1089     * Requirements:
1090     * - Subtraction cannot overflow.
1091     */
1092    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1093        return sub(a, b, "SafeMath: subtraction overflow");
1094    }
1095 
1096    /**
1097     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1098     * overflow (when the result is negative).
1099     *
1100     * Counterpart to Solidity's `-` operator.
1101     *
1102     * Requirements:
1103     * - Subtraction cannot overflow.
1104     *
1105     * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
1106     * @dev Get it via `npm install @openzeppelin/contracts@next`.
1107     */
1108    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1109        require(b <= a, errorMessage);
1110        uint256 c = a - b;
1111 
1112        return c;
1113    }
1114 
1115    /**
1116     * @dev Returns the multiplication of two unsigned integers, reverting on
1117     * overflow.
1118     *
1119     * Counterpart to Solidity's `*` operator.
1120     *
1121     * Requirements:
1122     * - Multiplication cannot overflow.
1123     */
1124    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1125        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1126        // benefit is lost if 'b' is also tested.
1127        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1128        if (a == 0) {
1129            return 0;
1130        }
1131 
1132        uint256 c = a * b;
1133        require(c / a == b, "SafeMath: multiplication overflow");
1134 
1135        return c;
1136    }
1137 
1138    /**
1139     * @dev Returns the integer division of two unsigned integers. Reverts on
1140     * division by zero. The result is rounded towards zero.
1141     *
1142     * Counterpart to Solidity's `/` operator. Note: this function uses a
1143     * `revert` opcode (which leaves remaining gas untouched) while Solidity
1144     * uses an invalid opcode to revert (consuming all remaining gas).
1145     *
1146     * Requirements:
1147     * - The divisor cannot be zero.
1148     */
1149    function div(uint256 a, uint256 b) internal pure returns (uint256) {
1150        return div(a, b, "SafeMath: division by zero");
1151    }
1152 
1153    /**
1154     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
1155     * division by zero. The result is rounded towards zero.
1156     *
1157     * Counterpart to Solidity's `/` operator. Note: this function uses a
1158     * `revert` opcode (which leaves remaining gas untouched) while Solidity
1159     * uses an invalid opcode to revert (consuming all remaining gas).
1160     *
1161     * Requirements:
1162     * - The divisor cannot be zero.
1163     * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
1164     * @dev Get it via `npm install @openzeppelin/contracts@next`.
1165     */
1166    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1167        // Solidity only automatically asserts when dividing by 0
1168        require(b > 0, errorMessage);
1169        uint256 c = a / b;
1170        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1171 
1172        return c;
1173    }
1174 
1175    /**
1176     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1177     * Reverts when dividing by zero.
1178     *
1179     * Counterpart to Solidity's `%` operator. This function uses a `revert`
1180     * opcode (which leaves remaining gas untouched) while Solidity uses an
1181     * invalid opcode to revert (consuming all remaining gas).
1182     *
1183     * Requirements:
1184     * - The divisor cannot be zero.
1185     */
1186    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1187        return mod(a, b, "SafeMath: modulo by zero");
1188    }
1189 
1190    /**
1191     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1192     * Reverts with custom message when dividing by zero.
1193     *
1194     * Counterpart to Solidity's `%` operator. This function uses a `revert`
1195     * opcode (which leaves remaining gas untouched) while Solidity uses an
1196     * invalid opcode to revert (consuming all remaining gas).
1197     *
1198     * Requirements:
1199     * - The divisor cannot be zero.
1200     *
1201     * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
1202     * @dev Get it via `npm install @openzeppelin/contracts@next`.
1203     */
1204    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1205        require(b != 0, errorMessage);
1206        return a % b;
1207    }
1208 }
1209 
1210 /**
1211 * @dev Collection of functions related to the address type
1212 */
1213 library Address {
1214    /**
1215     * @dev Returns true if `account` is a contract.
1216     *
1217     * This test is non-exhaustive, and there may be false-negatives: during the
1218     * execution of a contract's constructor, its address will be reported as
1219     * not containing a contract.
1220     *
1221     * IMPORTANT: It is unsafe to assume that an address for which this
1222     * function returns false is an externally-owned account (EOA) and not a
1223     * contract.
1224     */
1225    function isContract(address account) internal view returns (bool) {
1226        // This method relies in extcodesize, which returns 0 for contracts in
1227        // construction, since the code is only stored at the end of the
1228        // constructor execution.
1229 
1230        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
1231        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
1232        // for accounts without code, i.e. `keccak256('')`
1233        bytes32 codehash;
1234        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
1235        // solhint-disable-next-line no-inline-assembly
1236        assembly { codehash := extcodehash(account) }
1237        return (codehash != 0x0 && codehash != accountHash);
1238    }
1239 
1240    /**
1241     * @dev Converts an `address` into `address payable`. Note that this is
1242     * simply a type cast: the actual underlying value is not changed.
1243     *
1244     * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
1245     * @dev Get it via `npm install @openzeppelin/contracts@next`.
1246     */
1247    function toPayable(address account) internal pure returns (address payable) {
1248        return address(uint160(account));
1249    }
1250 
1251    /**
1252     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1253     * `recipient`, forwarding all available gas and reverting on errors.
1254     *
1255     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1256     * of certain opcodes, possibly making contracts go over the 2300 gas limit
1257     * imposed by `transfer`, making them unable to receive funds via
1258     * `transfer`. {sendValue} removes this limitation.
1259     *
1260     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1261     *
1262     * IMPORTANT: because control is transferred to `recipient`, care must be
1263     * taken to not create reentrancy vulnerabilities. Consider using
1264     * {ReentrancyGuard} or the
1265     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1266     */
1267    function sendValue(address payable recipient, uint256 amount) internal {
1268        require(address(this).balance >= amount, "Address: insufficient balance");
1269 
1270        // solhint-disable-next-line avoid-call-value
1271        (bool success, ) = recipient.call.value(amount)("");
1272        require(success, "Address: unable to send value, recipient may have reverted");
1273    }
1274 }
1275 
1276 /**
1277 * @title Counters
1278 * @author Matt Condon (@shrugs)
1279 * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
1280 * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1281 *
1282 * Include with `using Counters for Counters.Counter;`
1283 * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
1284 * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
1285 * directly accessed.
1286 */
1287 library Counters {
1288    using SafeMath for uint256;
1289 
1290    struct Counter {
1291        // This variable should never be directly accessed by users of the library: interactions must be restricted to
1292        // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1293        // this feature: see https://github.com/ethereum/solidity/issues/4637
1294        uint256 _value; // default: 0
1295    }
1296 
1297    function current(Counter storage counter) internal view returns (uint256) {
1298        return counter._value;
1299    }
1300 
1301    function increment(Counter storage counter) internal {
1302        // The {SafeMath} overflow check can be skipped here, see the comment at the top
1303        counter._value += 1;
1304    }
1305 
1306    function decrement(Counter storage counter) internal {
1307        counter._value = counter._value.sub(1);
1308    }
1309 }