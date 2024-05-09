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
733    //Base URI
734    string private _baseURI;
735 
736    // Optional mapping for token URIs
737    mapping(uint256 => string) private _tokenURIs;
738   
739    
740    //Optional mapping for IPFS link to canonical image file
741    mapping(uint256 => string) private _tokenIPFSHashes;
742    
743    mapping(uint256 => string) private _niftyTypeName;
744    
745     //Optional mapping for IPFS link to canonical image file by  Nifty type 
746    mapping(uint256 => string) private _niftyTypeIPFSHashes;
747    
748    //Token name 
749    mapping(uint256 => string) private _tokenName;
750 
751    /*
752     *     bytes4(keccak256('name()')) == 0x06fdde03
753     *     bytes4(keccak256('symbol()')) == 0x95d89b41
754     *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
755     *
756     *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
757     */
758    bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
759 
760    /**
761     * @dev Constructor function
762     */
763    constructor (string memory name, string memory symbol) public {
764        _name = name;
765        _symbol = symbol;
766 
767        // register the supported interfaces to conform to ERC721 via ERC165
768        _registerInterface(_INTERFACE_ID_ERC721_METADATA);
769    }
770 
771    /**
772     * @dev Gets the token name.
773     * @return string representing the token name
774     */
775    function name() external view returns (string memory) {
776        return _name;
777    }
778 
779    /**
780     * @dev Gets the token symbol.
781     * @return string representing the token symbol
782     */
783    function symbol() external view returns (string memory) {
784        return _symbol;
785    }
786    
787    //master builder - ONLY DOES STATIC CALLS
788    address public masterBuilderContract = 0x6EFB06cF568253a53C7511BD3c31AB28BecB0192;
789 
790    /**
791     * @dev Returns an URI for a given token ID.
792     * Throws if the token ID does not exist. May return an empty string.
793     * @param tokenId uint256 ID of the token to query
794     */
795    
796    function tokenURI(uint256 tokenId) external view returns (string memory) {
797         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
798         BuilderMaster bm = BuilderMaster(masterBuilderContract);
799        string memory tokenIdStr = bm.uint2str(tokenId);
800        string memory tokenURIStr = bm.strConcat(_baseURI, tokenIdStr);
801        return tokenURIStr;
802    }
803    
804      /**
805     * @dev Returns an IPFS Hash for a given token ID.
806     * Throws if the token ID does not exist. May return an empty string.
807     * @param tokenId uint256 ID of the token to query
808     */
809    function tokenIPFSHash(uint256 tokenId) external view returns (string memory) {
810        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
811         //master for static calls
812        BuilderMaster bm = BuilderMaster(masterBuilderContract);
813        uint nifty_type = bm.getNiftyTypeId(tokenId);
814        return _niftyTypeIPFSHashes[nifty_type];
815    }
816    
817         /**
818     * @dev Returns an URI for a given token ID.
819     * Throws if the token ID does not exist. May return an empty string.
820     * @param tokenId uint256 ID of the token to query
821     */
822    function tokenName(uint256 tokenId) external view returns (string memory) {
823        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
824         //master for static calls
825        BuilderMaster bm = BuilderMaster(masterBuilderContract);
826        uint nifty_type = bm.getNiftyTypeId(tokenId);
827        return _niftyTypeName[nifty_type];
828    }
829 
830    /**
831     * @dev Internal function to set the token URI for a given token.
832     * Reverts if the token ID does not exist.
833     * @param tokenId uint256 ID of the token to set its URI
834     * @param uri string URI to assign
835     */
836    function _setTokenURI(uint256 tokenId, string memory uri) internal {
837        require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
838        _tokenURIs[tokenId] = uri;
839    }
840    
841       /**
842     * @dev Internal function to set the token IPFS hash for a given token.
843     * Reverts if the token ID does not exist.
844     * @param tokenId uint256 ID of the token to set its URI
845     * @param ipfs_hash string IPFS link to assign
846     */
847    function _setTokenIPFSHash(uint256 tokenId, string memory ipfs_hash) internal {
848        require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
849        _tokenIPFSHashes[tokenId] = ipfs_hash;
850    }
851    
852             /**
853     * @dev Internal function to set the token IPFS hash for a given token.
854     * Reverts if the token ID does not exist.
855     * @param niftyType uint256 ID of the token to set its URI
856     * @param ipfs_hash string IPFS link to assign
857     */
858    function _setTokenIPFSHashNiftyType(uint256 niftyType, string memory ipfs_hash) internal {
859     //   require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
860        _niftyTypeIPFSHashes[niftyType] = ipfs_hash;
861    }
862    
863          /**
864     * @dev Internal function to set the token IPFS hash for a given token.
865     * Reverts if the token ID does not exist.
866     * @param nifty_type uint256 of nifty type name to be set
867     * @param nifty_type_name name of nifty type
868     */
869    function _setNiftyTypeName(uint256 nifty_type, string memory nifty_type_name) internal {
870        _niftyTypeName[nifty_type] = nifty_type_name;
871    }
872    
873    function _setBaseURIParent(string memory newBaseURI) internal {
874        _baseURI = newBaseURI;
875    }
876    
877    
878 
879    /**
880     * @dev Internal function to burn a specific token.
881     * Reverts if the token does not exist.
882     * Deprecated, use _burn(uint256) instead.
883     * @param owner owner of the token to burn
884     * @param tokenId uint256 ID of the token being burned by the msg.sender
885     */
886    function _burn(address owner, uint256 tokenId) internal {
887        super._burn(owner, tokenId);
888 
889        // Clear metadata (if any)
890        if (bytes(_tokenURIs[tokenId]).length != 0) {
891            delete _tokenURIs[tokenId];
892        }
893    }
894 }
895 
896 
897 /**
898 * @title Full ERC721 Token
899 * @dev This implementation includes all the required and some optional functionality of the ERC721 standard
900 * Moreover, it includes approve all functionality using operator terminology.
901 *
902 * See https://eips.ethereum.org/EIPS/eip-721
903 */
904 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
905    constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
906        // solhint-disable-previous-line no-empty-blocks
907    }
908 }
909 
910 
911 contract BeepleSpringCollection is ERC721Full {
912 
913    //MODIFIERS
914    
915    modifier onlyOwner() {
916        require(msg.sender == contractOwner);
917        _;
918    }
919 
920    //CONSTANTS
921 
922    // how many nifties this contract is selling
923    // used for metadat retrieval
924    uint public numNiftiesCurrentlyInContract;
925 
926    //id of this contract for metadata server
927    uint public contractId;
928 
929    //baseURI for metadata server
930    string public baseURI;
931    
932    // name of creator
933    string public nameOfCreator;
934    
935    address public contractOwner;
936 
937    //master builder - ONLY DOES STATIC CALLS
938    address public masterBuilderContract = 0x6EFB06cF568253a53C7511BD3c31AB28BecB0192;
939 
940    using Counters for Counters.Counter;
941 
942    //MAPPINGS
943 
944    //mappings for token Ids
945    mapping (uint => Counters.Counter) public _numNiftyMinted;
946    mapping (uint => uint) public _numNiftyPermitted;
947    mapping (uint => uint) public _niftyPrice;
948    mapping (uint => bool) public _IPFSHashHasBeenSet;
949 
950    //EVENTS
951 
952    //purchase + creation events
953    event NiftyPurchased(address _buyer, uint256 _amount, uint _tokenId);
954    event NiftyCreated(address new_owner, uint _niftyType, uint _tokenId);
955 
956    //CONSTRUCTOR FUNCTION
957 
958    constructor() ERC721Full("Beeple Spring Collection", "BEEPLESPRINGCOLLECTION") public {
959            
960        //set contract owner to deployer wallet
961        contractOwner = msg.sender;
962 
963        //set local variables based on inputs
964        contractId = 1;
965        numNiftiesCurrentlyInContract = 12;
966        nameOfCreator = "Beeple";
967        
968        //Spring collection consists of:
969         // edition of #100, as $1 drawing - 4
970         // edition of #100, in the "leaderboard" style - 1
971         // edition of #1, auction - 5
972         // edition of #3, silent auction - 2
973         // In total, we have 12 Nifty Types.
974         // 5 (100/100) + 5 (1/1) + 2 (3/3) = 12
975        _numNiftyPermitted[1] = 100;
976        _numNiftyPermitted[2] = 100;
977        _numNiftyPermitted[3] = 100;
978        _numNiftyPermitted[4] = 100;
979        _numNiftyPermitted[5] = 100;
980        _numNiftyPermitted[6] = 1;
981        _numNiftyPermitted[7] = 1;
982        _numNiftyPermitted[8] = 1;
983        _numNiftyPermitted[9] = 1;
984        _numNiftyPermitted[10] = 1;
985        _numNiftyPermitted[11] = 3;
986        _numNiftyPermitted[12] = 3;
987    }
988    
989    function setnewOwner (address newOwner) onlyOwner public {
990        //allow owner to change nifty name
991        contractOwner = newOwner;
992    }
993    
994    function setNiftyName (uint niftyType, string memory niftyName) onlyOwner public {
995        //allow owner to change nifty name
996         _setNiftyTypeName(niftyType, niftyName);
997    }
998    
999    function setBaseURI(string memory newBaseURI) onlyOwner public {
1000        //allow owner to change base URI
1001         _setBaseURIParent(newBaseURI);
1002    }
1003    
1004    function setNiftyIPFSHash(uint nifty_type, string memory ipfs_hash) onlyOwner public {
1005        //check if IPFS hash has been set
1006        if (_IPFSHashHasBeenSet[nifty_type] == true) { 
1007            revert ("IPFS hash already set for ths NFT");
1008        } else {
1009            _setTokenIPFSHashNiftyType(nifty_type, ipfs_hash);
1010            _IPFSHashHasBeenSet[nifty_type] = true;
1011        }
1012    }
1013 
1014    function isNiftySoldOut(uint niftyType) public view returns (bool) {
1015        if (niftyType > numNiftiesCurrentlyInContract) {
1016            return true;
1017        }
1018        if (_numNiftyMinted[niftyType].current() > _numNiftyPermitted[niftyType]) {
1019            return (true);
1020        } else {
1021            return (false);
1022        }
1023    }
1024 
1025    function giftNifty(address collector_address, 
1026                       uint niftyType) onlyOwner public {
1027        //master for static calls
1028        BuilderMaster bm = BuilderMaster(masterBuilderContract);
1029        _numNiftyMinted[niftyType].increment();
1030        //check if this nifty is sold out
1031        if (isNiftySoldOut(niftyType)==true) {
1032            revert("Nifty sold out!");
1033        }
1034        //mint a nifty
1035        uint specificTokenId = _numNiftyMinted[niftyType].current();
1036        uint tokenId = bm.encodeTokenId(contractId, niftyType, specificTokenId);
1037        //mint token
1038        _mint(collector_address, tokenId);
1039        //do events
1040        emit NiftyCreated(collector_address, niftyType, tokenId);
1041    }
1042    
1043     function massMintNFTs(address collector_address, uint numToMint, uint niftyType) onlyOwner public {
1044         //loop through array and create nifties
1045         for (uint i=0; i < numToMint; i++) {
1046             giftNifty(collector_address,niftyType);
1047         }
1048        
1049    }
1050    
1051 
1052 }
1053 
1054 contract NiftyRegistry {
1055    function isValidNiftySender(address sending_key) public view returns (bool);
1056    function isOwner(address owner_key) public view returns (bool);
1057 }
1058 
1059 contract BuilderMaster {
1060    function getContractId(uint tokenId) public view returns (uint);
1061    function getNiftyTypeId(uint tokenId) public view returns (uint);
1062    function getSpecificNiftyNum(uint tokenId) public view returns (uint);
1063    function encodeTokenId(uint contractId, uint niftyType, uint specificNiftyNum) public view returns (uint);
1064    function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) public view returns (string memory);
1065    function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) public view returns (string memory);
1066    function strConcat(string memory _a, string memory _b, string memory _c) public view returns (string memory);
1067    function strConcat(string memory _a, string memory _b) public view returns (string memory);
1068    function uint2str(uint _i) public view returns (string memory _uintAsString);
1069 }
1070 
1071 /**
1072 * Contracts and libraries below are from OpenZeppelin, except nifty builder instance
1073 **/
1074 
1075 
1076 /**
1077 * @dev Wrappers over Solidity's arithmetic operations with added overflow
1078 * checks.
1079 *
1080 * Arithmetic operations in Solidity wrap on overflow. This can easily result
1081 * in bugs, because programmers usually assume that an overflow raises an
1082 * error, which is the standard behavior in high level programming languages.
1083 * `SafeMath` restores this intuition by reverting the transaction when an
1084 * operation overflows.
1085 *
1086 * Using this library instead of the unchecked operations eliminates an entire
1087 * class of bugs, so it's recommended to use it always.
1088 */
1089 library SafeMath {
1090    /**
1091     * @dev Returns the addition of two unsigned integers, reverting on
1092     * overflow.
1093     *
1094     * Counterpart to Solidity's `+` operator.
1095     *
1096     * Requirements:
1097     * - Addition cannot overflow.
1098     */
1099    function add(uint256 a, uint256 b) internal pure returns (uint256) {
1100        uint256 c = a + b;
1101        require(c >= a, "SafeMath: addition overflow");
1102 
1103        return c;
1104    }
1105 
1106    /**
1107     * @dev Returns the subtraction of two unsigned integers, reverting on
1108     * overflow (when the result is negative).
1109     *
1110     * Counterpart to Solidity's `-` operator.
1111     *
1112     * Requirements:
1113     * - Subtraction cannot overflow.
1114     */
1115    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1116        return sub(a, b, "SafeMath: subtraction overflow");
1117    }
1118 
1119    /**
1120     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1121     * overflow (when the result is negative).
1122     *
1123     * Counterpart to Solidity's `-` operator.
1124     *
1125     * Requirements:
1126     * - Subtraction cannot overflow.
1127     *
1128     * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
1129     * @dev Get it via `npm install @openzeppelin/contracts@next`.
1130     */
1131    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1132        require(b <= a, errorMessage);
1133        uint256 c = a - b;
1134 
1135        return c;
1136    }
1137 
1138    /**
1139     * @dev Returns the multiplication of two unsigned integers, reverting on
1140     * overflow.
1141     *
1142     * Counterpart to Solidity's `*` operator.
1143     *
1144     * Requirements:
1145     * - Multiplication cannot overflow.
1146     */
1147    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1148        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1149        // benefit is lost if 'b' is also tested.
1150        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1151        if (a == 0) {
1152            return 0;
1153        }
1154 
1155        uint256 c = a * b;
1156        require(c / a == b, "SafeMath: multiplication overflow");
1157 
1158        return c;
1159    }
1160 
1161    /**
1162     * @dev Returns the integer division of two unsigned integers. Reverts on
1163     * division by zero. The result is rounded towards zero.
1164     *
1165     * Counterpart to Solidity's `/` operator. Note: this function uses a
1166     * `revert` opcode (which leaves remaining gas untouched) while Solidity
1167     * uses an invalid opcode to revert (consuming all remaining gas).
1168     *
1169     * Requirements:
1170     * - The divisor cannot be zero.
1171     */
1172    function div(uint256 a, uint256 b) internal pure returns (uint256) {
1173        return div(a, b, "SafeMath: division by zero");
1174    }
1175 
1176    /**
1177     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
1178     * division by zero. The result is rounded towards zero.
1179     *
1180     * Counterpart to Solidity's `/` operator. Note: this function uses a
1181     * `revert` opcode (which leaves remaining gas untouched) while Solidity
1182     * uses an invalid opcode to revert (consuming all remaining gas).
1183     *
1184     * Requirements:
1185     * - The divisor cannot be zero.
1186     * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
1187     * @dev Get it via `npm install @openzeppelin/contracts@next`.
1188     */
1189    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1190        // Solidity only automatically asserts when dividing by 0
1191        require(b > 0, errorMessage);
1192        uint256 c = a / b;
1193        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1194 
1195        return c;
1196    }
1197 
1198    /**
1199     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1200     * Reverts when dividing by zero.
1201     *
1202     * Counterpart to Solidity's `%` operator. This function uses a `revert`
1203     * opcode (which leaves remaining gas untouched) while Solidity uses an
1204     * invalid opcode to revert (consuming all remaining gas).
1205     *
1206     * Requirements:
1207     * - The divisor cannot be zero.
1208     */
1209    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1210        return mod(a, b, "SafeMath: modulo by zero");
1211    }
1212 
1213    /**
1214     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1215     * Reverts with custom message when dividing by zero.
1216     *
1217     * Counterpart to Solidity's `%` operator. This function uses a `revert`
1218     * opcode (which leaves remaining gas untouched) while Solidity uses an
1219     * invalid opcode to revert (consuming all remaining gas).
1220     *
1221     * Requirements:
1222     * - The divisor cannot be zero.
1223     *
1224     * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
1225     * @dev Get it via `npm install @openzeppelin/contracts@next`.
1226     */
1227    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1228        require(b != 0, errorMessage);
1229        return a % b;
1230    }
1231 }
1232 
1233 /**
1234 * @dev Collection of functions related to the address type
1235 */
1236 library Address {
1237    /**
1238     * @dev Returns true if `account` is a contract.
1239     *
1240     * This test is non-exhaustive, and there may be false-negatives: during the
1241     * execution of a contract's constructor, its address will be reported as
1242     * not containing a contract.
1243     *
1244     * IMPORTANT: It is unsafe to assume that an address for which this
1245     * function returns false is an externally-owned account (EOA) and not a
1246     * contract.
1247     */
1248    function isContract(address account) internal view returns (bool) {
1249        // This method relies in extcodesize, which returns 0 for contracts in
1250        // construction, since the code is only stored at the end of the
1251        // constructor execution.
1252 
1253        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
1254        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
1255        // for accounts without code, i.e. `keccak256('')`
1256        bytes32 codehash;
1257        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
1258        // solhint-disable-next-line no-inline-assembly
1259        assembly { codehash := extcodehash(account) }
1260        return (codehash != 0x0 && codehash != accountHash);
1261    }
1262 
1263    /**
1264     * @dev Converts an `address` into `address payable`. Note that this is
1265     * simply a type cast: the actual underlying value is not changed.
1266     *
1267     * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
1268     * @dev Get it via `npm install @openzeppelin/contracts@next`.
1269     */
1270    function toPayable(address account) internal pure returns (address payable) {
1271        return address(uint160(account));
1272    }
1273 
1274    /**
1275     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1276     * `recipient`, forwarding all available gas and reverting on errors.
1277     *
1278     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1279     * of certain opcodes, possibly making contracts go over the 2300 gas limit
1280     * imposed by `transfer`, making them unable to receive funds via
1281     * `transfer`. {sendValue} removes this limitation.
1282     *
1283     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1284     *
1285     * IMPORTANT: because control is transferred to `recipient`, care must be
1286     * taken to not create reentrancy vulnerabilities. Consider using
1287     * {ReentrancyGuard} or the
1288     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1289     */
1290    function sendValue(address payable recipient, uint256 amount) internal {
1291        require(address(this).balance >= amount, "Address: insufficient balance");
1292 
1293        // solhint-disable-next-line avoid-call-value
1294        (bool success, ) = recipient.call.value(amount)("");
1295        require(success, "Address: unable to send value, recipient may have reverted");
1296    }
1297 }
1298 
1299 /**
1300 * @title Counters
1301 * @author Matt Condon (@shrugs)
1302 * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
1303 * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1304 *
1305 * Include with `using Counters for Counters.Counter;`
1306 * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
1307 * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
1308 * directly accessed.
1309 */
1310 library Counters {
1311    using SafeMath for uint256;
1312 
1313    struct Counter {
1314        // This variable should never be directly accessed by users of the library: interactions must be restricted to
1315        // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1316        // this feature: see https://github.com/ethereum/solidity/issues/4637
1317        uint256 _value; // default: 0
1318    }
1319 
1320    function current(Counter storage counter) internal view returns (uint256) {
1321        return counter._value;
1322    }
1323 
1324    function increment(Counter storage counter) internal {
1325        // The {SafeMath} overflow check can be skipped here, see the comment at the top
1326        counter._value += 1;
1327    }
1328 
1329    function decrement(Counter storage counter) internal {
1330        counter._value = counter._value.sub(1);
1331    }
1332 }