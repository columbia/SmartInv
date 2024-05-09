1 /*
2        M                                                 M
3      M   M                                             M   M
4     M  M  M                                           M  M  M
5    M  M  M  M                                       M  M  M  M
6   M  M  M  M  M                                    M  M  M  M  M
7  M  M M  M  M  M                                 M  M  M  M  M  M
8  M  M   M  M  M  M                              M  M     M  M  M  M
9  M  M     M  M  M  M                           M  M      M  M   M  M
10  M  M       M  M  M  M                        M  M       M  M   M  M     ​​
11  M  M         M  M  M  M                     M  M        M  M   M  M
12  M  M           M  M  M  M                  M  M         M  M   M  M
13  M  M             M  M  M  M               M  M          M  M   M  M   M  M  M  M  M  M  M
14  M  M               M  M  M  M            M  M        M  M  M   M  M   M  M  M  M  M  M  M
15  M  M                 M  M  M  M         M  M      M  M  M  M   M  M                  M  M
16  M  M                   M  M  M  M      M  M    M  M  M  M  M   M  M                     M
17  M  M                     M  M  M  M   M  M  M  M  M  M  M  M   M  M
18  M  M                       M  M  M  M  M   M  M  M  M   M  M   M  M
19  M  M                         M  M  M  M   M  M  M  M    M  M   M  M
20  M  M                           M  M  M   M  M  M  M     M  M   M  M
21  M  M                             M  M   M  M  M  M      M  M   M  M
22 M  M  M  M  M  M                         M   M  M  M  M   M  M  M  M  M  M  M
23                                         M  M  M  M
24                                         M  M  M  M
25                                         M  M  M  M
26                                          M  M  M  M                        M  M  M  M  M  M
27                                           M  M  M  M                          M  M  M  M
28                                            M  M  M  M                         M  M  M  M
29                                              M  M  M  M                       M  M  M  M
30                                                M  M  M  M                     M  M  M  M
31                                                  M  M  M  M                   M  M  M  M
32                                                     M  M  M  M                M  M  M  M
33                                                        M  M  M  M             M  M  M  M
34                                                            M  M  M  M   M  M  M  M  M  M
35                                                                M  M  M  M  M  M  M  M  M
36                                                                                                                                                 
37 */
38 // based off of the beautiful work done by Erick Calderon with the smart contracts for Artblocks.
39 pragma solidity ^0.5.0;
40 /**
41 * @dev Interface of the ERC165 standard, as defined in the
42 * [EIP](https://eips.ethereum.org/EIPS/eip-165).
43 *
44 * Implementers can declare support of contract interfaces, which can then be
45 * queried by others (`ERC165Checker`).
46 *
47 * For an implementation, see `ERC165`.
48 */
49 interface IERC165 {
50 /**
51  * @dev Returns true if this contract implements the interface defined by
52  * `interfaceId`. See the corresponding
53  * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
54  * to learn more about how these ids are created.
55  *
56  * This function call must use less than 30 000 gas.
57  */
58 function supportsInterface(bytes4 interfaceId) external view returns (bool);
59 }
60 // File contracts/libs/ERC165.sol
61 // File: openzeppelin-solidity/contracts/introspection/ERC165.sol
62 pragma solidity ^0.5.0;
63 /**
64 * @dev Implementation of the `IERC165` interface.
65 *
66 * Contracts may inherit from this and call `_registerInterface` to declare
67 * their support of an interface.
68 */
69 contract ERC165 is IERC165 {
70 /*
71  * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
72  */
73 bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
74 /**
75  * @dev Mapping of interface ids to whether or not it's supported.
76  */
77 mapping(bytes4 => bool) private _supportedInterfaces;
78 constructor () internal {
79     // Derived contracts need only register support for their own interfaces,
80     // we register support for ERC165 itself here
81     _registerInterface(_INTERFACE_ID_ERC165);
82 }
83 /**
84  * @dev See `IERC165.supportsInterface`.
85  *
86  * Time complexity O(1), guaranteed to always use less than 30 000 gas.
87  */
88 function supportsInterface(bytes4 interfaceId) external view returns (bool) {
89     return _supportedInterfaces[interfaceId];
90 }
91 /**
92  * @dev Registers the contract as an implementer of the interface defined by
93  * `interfaceId`. Support of the actual ERC165 interface is automatic and
94  * registering its interface id is not required.
95  *
96  * See `IERC165.supportsInterface`.
97  *
98  * Requirements:
99  *
100  * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
101  */
102 function _registerInterface(bytes4 interfaceId) internal {
103     require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
104     _supportedInterfaces[interfaceId] = true;
105 }
106 }
107 // File contracts/libs/IERC721.sol
108 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721.sol
109 pragma solidity ^0.5.0;
110 /**
111 * @dev Required interface of an ERC721 compliant contract.
112 */
113 contract IERC721 is IERC165 {
114 event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
115 event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
116 event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
117 /**
118  * @dev Returns the number of NFTs in `owner`'s account.
119  */
120 function balanceOf(address owner) public view returns (uint256 balance);
121 /**
122  * @dev Returns the owner of the NFT specified by `tokenId`.
123  */
124 function ownerOf(uint256 tokenId) public view returns (address owner);
125 /**
126  * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
127  * another (`to`).
128  *
129  *
130  *
131  * Requirements:
132  * - `from`, `to` cannot be zero.
133  * - `tokenId` must be owned by `from`.
134  * - If the caller is not `from`, it must be have been allowed to move this
135  * NFT by either `approve` or `setApproveForAll`.
136  */
137 function safeTransferFrom(address from, address to, uint256 tokenId) public;
138 /**
139  * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
140  * another (`to`).
141  *
142  * Requirements:
143  * - If the caller is not `from`, it must be approved to move this NFT by
144  * either `approve` or `setApproveForAll`.
145  */
146 function transferFrom(address from, address to, uint256 tokenId) public;
147 function approve(address to, uint256 tokenId) public;
148 function getApproved(uint256 tokenId) public view returns (address operator);
149 function setApprovalForAll(address operator, bool _approved) public;
150 function isApprovedForAll(address owner, address operator) public view returns (bool);
151 function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
152 }
153 // File contracts/libs/SafeMath.sol
154 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
155 pragma solidity ^0.5.0;
156 /**
157 * @dev Wrappers over Solidity's arithmetic operations with added overflow
158 * checks.
159 *
160 * Arithmetic operations in Solidity wrap on overflow. This can easily result
161 * in bugs, because programmers usually assume that an overflow raises an
162 * error, which is the standard behavior in high level programming languages.
163 * `SafeMath` restores this intuition by reverting the transaction when an
164 * operation overflows.
165 *
166 * Using this library instead of the unchecked operations eliminates an entire
167 * class of bugs, so it's recommended to use it always.
168 */
169 library SafeMath {
170 /**
171  * @dev Returns the addition of two unsigned integers, reverting on
172  * overflow.
173  *
174  * Counterpart to Solidity's `+` operator.
175  *
176  * Requirements:
177  * - Addition cannot overflow.
178  */
179 function add(uint256 a, uint256 b) internal pure returns (uint256) {
180     uint256 c = a + b;
181     require(c >= a, "SafeMath: addition overflow");
182     return c;
183 }
184 /**
185  * @dev Returns the subtraction of two unsigned integers, reverting on
186  * overflow (when the result is negative).
187  *
188  * Counterpart to Solidity's `-` operator.
189  *
190  * Requirements:
191  * - Subtraction cannot overflow.
192  */
193 function sub(uint256 a, uint256 b) internal pure returns (uint256) {
194     require(b <= a, "SafeMath: subtraction overflow");
195     uint256 c = a - b;
196     return c;
197 }
198 /**
199  * @dev Returns the multiplication of two unsigned integers, reverting on
200  * overflow.
201  *
202  * Counterpart to Solidity's `*` operator.
203  *
204  * Requirements:
205  * - Multiplication cannot overflow.
206  */
207 function mul(uint256 a, uint256 b) internal pure returns (uint256) {
208     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
209     // benefit is lost if 'b' is also tested.
210     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
211     if (a == 0) {
212         return 0;
213     }
214     uint256 c = a * b;
215     require(c / a == b, "SafeMath: multiplication overflow");
216     return c;
217 }
218 /**
219  * @dev Returns the integer division of two unsigned integers. Reverts on
220  * division by zero. The result is rounded towards zero.
221  *
222  * Counterpart to Solidity's `/` operator. Note: this function uses a
223  * `revert` opcode (which leaves remaining gas untouched) while Solidity
224  * uses an invalid opcode to revert (consuming all remaining gas).
225  *
226  * Requirements:
227  * - The divisor cannot be zero.
228  */
229 function div(uint256 a, uint256 b) internal pure returns (uint256) {
230     // Solidity only automatically asserts when dividing by 0
231     require(b > 0, "SafeMath: division by zero");
232     uint256 c = a / b;
233     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
234     return c;
235 }
236 }
237 // File contracts/libs/Address.sol
238 // File: openzeppelin-solidity/contracts/utils/Address.sol
239 pragma solidity ^0.5.0;
240 /**
241 * @dev Collection of functions related to the address type,
242 */
243 library Address {
244 /**
245  * @dev Returns true if `account` is a contract.
246  *
247  * This test is non-exhaustive, and there may be false-negatives: during the
248  * execution of a contract's constructor, its address will be reported as
249  * not containing a contract.
250  *
251  * > It is unsafe to assume that an address for which this function returns
252  * false is an externally-owned account (EOA) and not a contract.
253  */
254 function isContract(address account) internal view returns (bool) {
255     // This method relies in extcodesize, which returns 0 for contracts in
256     // construction, since the code is only stored at the end of the
257     // constructor execution.
258     uint256 size;
259     // solhint-disable-next-line no-inline-assembly
260     assembly { size := extcodesize(account) }
261     return size > 0;
262 }
263 }
264 // File contracts/libs/Counters.sol
265 // File: openzeppelin-solidity/contracts/drafts/Counters.sol
266 pragma solidity ^0.5.0;
267 /**
268 * @title Counters
269 * @author Matt Condon (@shrugs)
270 * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
271 * of elements in a mapping, issuing ERC721 ids, or counting request ids.
272 *
273 * Include with `using Counters for Counters.Counter;`
274 * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the SafeMath
275 * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
276 * directly accessed.
277 */
278 library Counters {
279 using SafeMath for uint256;
280 struct Counter {
281     // This variable should never be directly accessed by users of the library: interactions must be restricted to
282     // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
283     // this feature: see https://github.com/ethereum/solidity/issues/4637
284     uint256 _value; // default: 0
285 }
286 function current(Counter storage counter) internal view returns (uint256) {
287     return counter._value;
288 }
289 function increment(Counter storage counter) internal {
290     counter._value += 1;
291 }
292 function decrement(Counter storage counter) internal {
293     counter._value = counter._value.sub(1);
294 }
295 }
296 // File contracts/libs/IERC721Receiver.sol
297 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Receiver.sol
298 pragma solidity ^0.5.0;
299 /**
300 * @title ERC721 token receiver interface
301 * @dev Interface for any contract that wants to support safeTransfers
302 * from ERC721 asset contracts.
303 */
304 contract IERC721Receiver {
305 function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
306 public returns (bytes4);
307 }
308 // File contracts/libs/ERC721.sol
309 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721.sol
310 pragma solidity ^0.5.0;
311 /**
312 * @title ERC721 Non-Fungible Token Standard basic implementation
313 * @dev see https://eips.ethereum.org/EIPS/eip-721
314 */
315 contract ERC721 is ERC165, IERC721 {
316 using SafeMath for uint256;
317 using Address for address;
318 using Counters for Counters.Counter;
319 // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
320 // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
321 bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
322 // Mapping from token ID to owner
323 mapping (uint256 => address) private _tokenOwner;
324 // Mapping from token ID to approved address
325 mapping (uint256 => address) private _tokenApprovals;
326 // Mapping from owner to number of owned token
327 mapping (address => Counters.Counter) private _ownedTokensCount;
328 // Mapping from owner to operator approvals
329 mapping (address => mapping (address => bool)) private _operatorApprovals;
330  bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
331 constructor () public {
332     // register the supported interfaces to conform to ERC721 via ERC165
333     _registerInterface(_INTERFACE_ID_ERC721);
334 }
335 function balanceOf(address owner) public view returns (uint256) {
336     require(owner != address(0), "ERC721: balance query for the zero address");
337     return _ownedTokensCount[owner].current();
338 }
339 function ownerOf(uint256 tokenId) public view returns (address) {
340     address owner = _tokenOwner[tokenId];
341     require(owner != address(0), "ERC721: owner query for nonexistent token");
342     return owner;
343 }
344 function approve(address to, uint256 tokenId) public {
345     address owner = ownerOf(tokenId);
346     require(to != owner, "ERC721: approval to current owner");
347     require(msg.sender == owner || isApprovedForAll(owner, msg.sender),
348         "ERC721: approve caller is not owner nor approved for all"
349     );
350     _tokenApprovals[tokenId] = to;
351     emit Approval(owner, to, tokenId);
352 }
353 function getApproved(uint256 tokenId) public view returns (address) {
354     require(_exists(tokenId), "ERC721: approved query for nonexistent token");
355     return _tokenApprovals[tokenId];
356 }
357 function setApprovalForAll(address to, bool approved) public {
358     require(to != msg.sender, "ERC721: approve to caller");
359     _operatorApprovals[msg.sender][to] = approved;
360     emit ApprovalForAll(msg.sender, to, approved);
361 }
362 function isApprovedForAll(address owner, address operator) public view returns (bool) {
363     return _operatorApprovals[owner][operator];
364 }
365 function transferFrom(address from, address to, uint256 tokenId) public {
366     //solhint-disable-next-line max-line-length
367     require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
368     _transferFrom(from, to, tokenId);
369 }
370 function safeTransferFrom(address from, address to, uint256 tokenId) public {
371     safeTransferFrom(from, to, tokenId, "");
372 }
373 function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
374     transferFrom(from, to, tokenId);
375     require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
376 }
377 function _exists(uint256 tokenId) internal view returns (bool) {
378     address owner = _tokenOwner[tokenId];
379     return owner != address(0);
380 }
381 function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
382     require(_exists(tokenId), "ERC721: operator query for nonexistent token");
383     address owner = ownerOf(tokenId);
384     return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
385 }
386 function _mint(address to, uint256 tokenId) internal {
387     require(to != address(0), "ERC721: mint to the zero address");
388     require(!_exists(tokenId), "ERC721: token already minted");
389     _tokenOwner[tokenId] = to;
390     _ownedTokensCount[to].increment();
391     emit Transfer(address(0), to, tokenId);
392 }
393 function _burn(address owner, uint256 tokenId) internal {
394     require(ownerOf(tokenId) == owner, "ERC721: burn of token that is not own");
395     _clearApproval(tokenId);
396     _ownedTokensCount[owner].decrement();
397     _tokenOwner[tokenId] = address(0);
398     emit Transfer(owner, address(0), tokenId);
399 }
400 function _burn(uint256 tokenId) internal {
401     _burn(ownerOf(tokenId), tokenId);
402 }
403 function _transferFrom(address from, address to, uint256 tokenId) internal {
404     require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
405     require(to != address(0), "ERC721: transfer to the zero address");
406     _clearApproval(tokenId);
407     _ownedTokensCount[from].decrement();
408     _ownedTokensCount[to].increment();
409     _tokenOwner[tokenId] = to;
410     emit Transfer(from, to, tokenId);
411 }
412 function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
413 internal returns (bool)
414 {
415     if (!to.isContract()) {
416         return true;
417     }
418     bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
419     return (retval == _ERC721_RECEIVED);
420 }
421 function _clearApproval(uint256 tokenId) private {
422     if (_tokenApprovals[tokenId] != address(0)) {
423         _tokenApprovals[tokenId] = address(0);
424     }
425 }
426 }
427 // File contracts/libs/IERC721Enumerable.sol
428 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Enumerable.sol
429 pragma solidity ^0.5.0;
430 /**
431 * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
432 * @dev See https://eips.ethereum.org/EIPS/eip-721
433 */
434 contract IERC721Enumerable is IERC721 {
435 function totalSupply() public view returns (uint256);
436 function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
437 function tokenByIndex(uint256 index) public view returns (uint256);
438 }
439 // File contracts/libs/ERC721Enumerable.sol
440 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Enumerable.sol
441 pragma solidity ^0.5.0;
442 /**
443 * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
444 * @dev See https://eips.ethereum.org/EIPS/eip-721
445 */
446 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
447 // Mapping from owner to list of owned token IDs
448 mapping(address => uint256[]) private _ownedTokens;
449 // Mapping from token ID to index of the owner tokens list
450 mapping(uint256 => uint256) private _ownedTokensIndex;
451 // Array with all token ids, used for enumeration
452 uint256[] private _allTokens;
453 // Mapping from token id to position in the allTokens array
454 mapping(uint256 => uint256) private _allTokensIndex;
455 /*
456  *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
457  *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
458  *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
459  *
460  *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
461  */
462 bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
463 /**
464  * @dev Constructor function.
465  */
466 constructor () public {
467     // register the supported interface to conform to ERC721Enumerable via ERC165
468     _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
469 }
470 /**
471  * @dev Gets the token ID at a given index of the tokens list of the requested owner.
472  * @param owner address owning the tokens list to be accessed
473  * @param index uint256 representing the index to be accessed of the requested tokens list
474  * @return uint256 token ID at the given index of the tokens list owned by the requested address
475  */
476 function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
477     require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
478     return _ownedTokens[owner][index];
479 }
480 /**
481  * @dev Gets the total amount of tokens stored by the contract.
482  * @return uint256 representing the total amount of tokens
483  */
484 function totalSupply() public view returns (uint256) {
485     return _allTokens.length;
486 }
487 /**
488  * @dev Gets the token ID at a given index of all the tokens in this contract
489  * Reverts if the index is greater or equal to the total number of tokens.
490  * @param index uint256 representing the index to be accessed of the tokens list
491  * @return uint256 token ID at the given index of the tokens list
492  */
493 function tokenByIndex(uint256 index) public view returns (uint256) {
494     require(index < totalSupply(), "ERC721Enumerable: global index out of bounds");
495     return _allTokens[index];
496 }
497 /**
498  * @dev Internal function to transfer ownership of a given token ID to another address.
499  * As opposed to transferFrom, this imposes no restrictions on msg.sender.
500  * @param from current owner of the token
501  * @param to address to receive the ownership of the given token ID
502  * @param tokenId uint256 ID of the token to be transferred
503  */
504 function _transferFrom(address from, address to, uint256 tokenId) internal {
505     super._transferFrom(from, to, tokenId);
506     _removeTokenFromOwnerEnumeration(from, tokenId);
507     _addTokenToOwnerEnumeration(to, tokenId);
508 }
509 /**
510  * @dev Internal function to mint a new token.
511  * Reverts if the given token ID already exists.
512  * @param to address the beneficiary that will own the minted token
513  * @param tokenId uint256 ID of the token to be minted
514  */
515 function _mint(address to, uint256 tokenId) internal {
516     super._mint(to, tokenId);
517     _addTokenToOwnerEnumeration(to, tokenId);
518     _addTokenToAllTokensEnumeration(tokenId);
519 }
520 /**
521  * @dev Internal function to burn a specific token.
522  * Reverts if the token does not exist.
523  * Deprecated, use _burn(uint256) instead.
524  * @param owner owner of the token to burn
525  * @param tokenId uint256 ID of the token being burned
526  */
527 function _burn(address owner, uint256 tokenId) internal {
528     super._burn(owner, tokenId);
529     _removeTokenFromOwnerEnumeration(owner, tokenId);
530     // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
531     _ownedTokensIndex[tokenId] = 0;
532     _removeTokenFromAllTokensEnumeration(tokenId);
533 }
534 /**
535  * @dev Gets the list of token IDs of the requested owner.
536  * @param owner address owning the tokens
537  * @return uint256[] List of token IDs owned by the requested address
538  */
539 function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
540     return _ownedTokens[owner];
541 }
542 /**
543  * @dev Private function to add a token to this extension's ownership-tracking data structures.
544  * @param to address representing the new owner of the given token ID
545  * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
546  */
547 function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
548     _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
549     _ownedTokens[to].push(tokenId);
550 }
551 /**
552  * @dev Private function to add a token to this extension's token tracking data structures.
553  * @param tokenId uint256 ID of the token to be added to the tokens list
554  */
555 function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
556     _allTokensIndex[tokenId] = _allTokens.length;
557     _allTokens.push(tokenId);
558 }
559 /**
560  * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
561  * while the token is not assigned a new owner, the _ownedTokensIndex mapping is _not_ updated: this allows for
562  * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
563  * This has O(1) time complexity, but alters the order of the _ownedTokens array.
564  * @param from address representing the previous owner of the given token ID
565  * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
566  */
567 function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
568     // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
569     // then delete the last slot (swap and pop).
570     uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
571     uint256 tokenIndex = _ownedTokensIndex[tokenId];
572     // When the token to delete is the last token, the swap operation is unnecessary
573     if (tokenIndex != lastTokenIndex) {
574         uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
575         _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
576         _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
577     }
578     // This also deletes the contents at the last position of the array
579     _ownedTokens[from].length--;
580     // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occupied by
581     // lastTokenId, or just over the end of the array if the token was the last one).
582 }
583 /**
584  * @dev Private function to remove a token from this extension's token tracking data structures.
585  * This has O(1) time complexity, but alters the order of the _allTokens array.
586  * @param tokenId uint256 ID of the token to be removed from the tokens list
587  */
588 function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
589     // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
590     // then delete the last slot (swap and pop).
591     uint256 lastTokenIndex = _allTokens.length.sub(1);
592     uint256 tokenIndex = _allTokensIndex[tokenId];
593     // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
594     // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
595     // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
596     uint256 lastTokenId = _allTokens[lastTokenIndex];
597     _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
598     _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
599     // This also deletes the contents at the last position of the array
600     _allTokens.length--;
601     _allTokensIndex[tokenId] = 0;
602 }
603 }
604 // File contracts/libs/CustomERC721Metadata.sol
605 // File: contracts/CustomERC721Metadata.sol
606 pragma solidity ^0.5.0;
607 /**
608 * ERC721 base contract without the concept of tokenUri as this is managed by the parent
609 */
610 contract CustomERC721Metadata is ERC165, ERC721, ERC721Enumerable {
611 // Token name
612 string private _name;
613 // Token symbol
614 string private _symbol;
615 bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
616 /**
617  * @dev Constructor function
618  */
619 constructor (string memory name, string memory symbol) public {
620     _name = name;
621     _symbol = symbol;
622     // register the supported interfaces to conform to ERC721 via ERC165
623     _registerInterface(_INTERFACE_ID_ERC721_METADATA);
624 }
625 /**
626  * @dev Gets the token name
627  * @return string representing the token name
628  */
629 function name() external view returns (string memory) {
630     return _name;
631 }
632 /**
633  * @dev Gets the token symbol
634  * @return string representing the token symbol
635  */
636 function symbol() external view returns (string memory) {
637     return _symbol;
638 }
639 }
640 // File contracts/libs/Strings.sol
641 // File: contracts/Strings.sol
642 pragma solidity ^0.5.0;
643 //https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
644 library Strings {
645 function strConcat(string memory _a, string memory _b) internal pure returns (string memory _concatenatedString) {
646     return strConcat(_a, _b, "", "", "");
647 }
648 function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory _concatenatedString) {
649     return strConcat(_a, _b, _c, "", "");
650 }
651 function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory _concatenatedString) {
652     return strConcat(_a, _b, _c, _d, "");
653 }
654 function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory _concatenatedString) {
655     bytes memory _ba = bytes(_a);
656     bytes memory _bb = bytes(_b);
657     bytes memory _bc = bytes(_c);
658     bytes memory _bd = bytes(_d);
659     bytes memory _be = bytes(_e);
660     string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
661     bytes memory babcde = bytes(abcde);
662     uint k = 0;
663     uint i = 0;
664     for (i = 0; i < _ba.length; i++) {
665         babcde[k++] = _ba[i];
666     }
667     for (i = 0; i < _bb.length; i++) {
668         babcde[k++] = _bb[i];
669     }
670     for (i = 0; i < _bc.length; i++) {
671         babcde[k++] = _bc[i];
672     }
673     for (i = 0; i < _bd.length; i++) {
674         babcde[k++] = _bd[i];
675     }
676     for (i = 0; i < _be.length; i++) {
677         babcde[k++] = _be[i];
678     }
679     return string(babcde);
680 }
681 function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
682     if (_i == 0) {
683         return "0";
684     }
685     uint j = _i;
686     uint len;
687     while (j != 0) {
688         len++;
689         j /= 10;
690     }
691     bytes memory bstr = new bytes(len);
692     uint k = len - 1;
693     while (_i != 0) {
694         bstr[k--] = byte(uint8(48 + _i % 10));
695         _i /= 10;
696     }
697     return string(bstr);
698 }
699 }
700 
701 pragma solidity ^0.5.0;
702 interface mirageContracts {
703 function balanceOf(address owner, uint256 _id) external view returns (uint256);
704 }
705 contract mirageCurated is CustomERC721Metadata {
706 using SafeMath for uint256;
707 event Mint(
708     address indexed _to,
709     uint256 indexed _tokenId,
710     uint256 indexed _projectId
711 );
712 struct Project {
713     string name;
714     string artist;
715     string description;
716     string website;
717     string license;
718     string projectBaseURI;
719     uint256 artworks;
720     uint256 maxArtworks;
721     uint256 maxEarly;
722     bool publicActive;
723     bool locked;
724     bool paused;
725     bool earlyActive;
726 }
727 uint256 constant TEN_THOUSAND = 10_000;
728 mapping(uint256 => Project) projects;
729 //All financial functions are stripped from struct for visibility
730 mapping(uint256 => address) public projectIdToArtistAddress;
731 mapping(uint256 => string) public projectIdToCurrencySymbol;
732 mapping(uint256 => address) public projectIdToCurrencyAddress;
733 mapping(uint256 => uint256) public projectIdToPricePerTokenInWei;
734 mapping(uint256 => address) public projectIdToAdditionalPayee;
735 mapping(uint256 => uint256) public projectIdToAdditionalPayeePercentage;
736 address public mirageAddress;
737 mirageContracts public membershipContract;
738 uint256 public miragePercentage = 10;
739 mapping(uint256 => uint256) public tokenIdToProjectId;
740 mapping(uint256 => uint256[]) internal projectIdToTokenIds;
741 mapping(uint256 => bytes32) public tokenIdToHash;
742 mapping(bytes32 => uint256) public hashToTokenId;
743 address public admin;
744 mapping(address => bool) public isWhitelisted;
745 mapping(address => bool) public isMintWhitelisted;
746 uint256 public nextProjectId = 1;
747 modifier onlyValidTokenId(uint256 _tokenId) {
748     require(_exists(_tokenId), "Token ID does not exist");
749     _;
750 }
751 modifier onlyUnlocked(uint256 _projectId) {
752     require(!projects[_projectId].locked, "Only if unlocked");
753     _;
754 }
755 modifier onlyArtist(uint256 _projectId) {
756     require(msg.sender == projectIdToArtistAddress[_projectId], "Only artist");
757     _;
758 }
759 modifier onlyAdmin() {
760     require(msg.sender == admin, "Only admin");
761     _;
762 }
763 modifier onlyWhitelisted() {
764     require(isWhitelisted[msg.sender], "Only whitelisted");
765     _;
766 }
767 modifier onlyArtistOrWhitelisted(uint256 _projectId) {
768     require(isWhitelisted[msg.sender] || msg.sender == projectIdToArtistAddress[_projectId], "Only artist or whitelisted");
769     _;
770 }
771 constructor(string memory _tokenName, string memory _tokenSymbol, address membershipAddress) CustomERC721Metadata(_tokenName, _tokenSymbol) public {
772     admin = msg.sender;
773     isWhitelisted[msg.sender] = true;
774     mirageAddress = msg.sender;
775     membershipContract = mirageContracts(membershipAddress);
776 }
777 function mint(address _to, uint256 _projectId, address _by) external returns (uint256 _tokenId) {
778     require(isMintWhitelisted[msg.sender], "Must mint from whitelisted minter contract.");
779     require(projects[_projectId].artworks.add(51) <= projects[_projectId].maxArtworks, "Must not exceed max artworks");
780     require(projects[_projectId].publicActive || _by == projectIdToArtistAddress[_projectId], "Project must exist and be active");
781     require(!projects[_projectId].paused || _by == projectIdToArtistAddress[_projectId], "Purchases are paused.");
782     uint256 tokenId = _mintToken(_to, _projectId);
783     return tokenId;
784 }
785  function earlyMint(address _to, uint256 _projectId, address _by) external returns (uint256 _tokenId) {
786     require(isMintWhitelisted[msg.sender], "Must mint from whitelisted minter contract.");
787     require(projects[_projectId].earlyActive || _by == projectIdToArtistAddress[_projectId], "Project not in early mint phase");
788     require(!projects[_projectId].paused || _by == projectIdToArtistAddress[_projectId], "Purchases are paused.");
789     require(projects[_projectId].artworks < projects[_projectId].maxEarly, "Must not exceed early mint allowance");
790     uint256 tokenId = _mintToken(_to, _projectId);
791     return tokenId;
792 }
793 function _mintToken(address _to, uint256 _projectId) internal returns (uint256 _tokenId) {
794     uint256 tokenIdToBe = (_projectId * TEN_THOUSAND) + projects[_projectId].artworks + 50; //adding 50 in order to skip pieces claimable by sentient members
795     projects[_projectId].artworks = projects[_projectId].artworks.add(1);
796     _mint(_to, tokenIdToBe);
797     tokenIdToProjectId[tokenIdToBe] = _projectId;
798     projectIdToTokenIds[_projectId].push(tokenIdToBe);
799     emit Mint(_to, tokenIdToBe, _projectId);
800     return tokenIdToBe;
801 }
802  function claimSentient(uint256 _projectId, uint256 membershipId) public {
803     require(projects[_projectId].publicActive || projects[_projectId].earlyActive, "Project must exist, and be active or in early mint state");
804     require(membershipId < 50, "Must be a Sentient Membership ID (0-49)");
805     require(membershipContract.balanceOf(msg.sender, membershipId) == 1, "Wallet does not have this membership ID");
806     sentientMint(msg.sender, _projectId, membershipId);
807 }
808 function sentientMint(address _to, uint256 _projectId, uint256 _membershipId) internal returns (uint256 _tokenId) {
809     uint256 tokenIdToBe = (_projectId * TEN_THOUSAND) + _membershipId;
810     _mint(_to, tokenIdToBe);
811     tokenIdToProjectId[tokenIdToBe] = _projectId;
812     projectIdToTokenIds[_projectId].push(tokenIdToBe);
813     emit Mint(_to, tokenIdToBe, _projectId);
814     return tokenIdToBe;
815 }
816  function updateMembershipContract(address newAddress) public onlyAdmin {
817     membershipContract = mirageContracts(newAddress);
818 }
819  function updateMirageAddress(address _mirageAddress) public onlyAdmin {
820     mirageAddress = _mirageAddress;
821 }
822 function updateMiragePercentage(uint256 _miragePercentage) public onlyAdmin {
823     require(_miragePercentage <= 25, "Max of 25%");
824     miragePercentage = _miragePercentage;
825 }
826 function addWhitelisted(address _address) public onlyAdmin {
827     isWhitelisted[_address] = true;
828 }
829 function removeWhitelisted(address _address) public onlyAdmin {
830     isWhitelisted[_address] = false;
831 }
832 function addMintWhitelisted(address _address) public onlyAdmin {
833     isMintWhitelisted[_address] = true;
834 }
835 function removeMintWhitelisted(address _address) public onlyAdmin {
836     isMintWhitelisted[_address] = false;
837 }
838 function toggleProjectIsLocked(uint256 _projectId) public onlyWhitelisted onlyUnlocked(_projectId) {
839     projects[_projectId].locked = true;
840 }
841 function toggleProjectPublicMint(uint256 _projectId) public onlyWhitelisted {
842     projects[_projectId].publicActive = !projects[_projectId].publicActive;
843     projects[_projectId].earlyActive = false;
844 }
845  function toggleEarlyMint(uint256 _projectId) public onlyWhitelisted {
846     projects[_projectId].earlyActive = !projects[_projectId].earlyActive;
847 }
848 function updateProjectArtistAddress(uint256 _projectId, address _artistAddress) public onlyArtistOrWhitelisted(_projectId) {
849     projectIdToArtistAddress[_projectId] = _artistAddress;
850 }
851 function toggleProjectIsPaused(uint256 _projectId) public onlyWhitelisted {
852     projects[_projectId].paused = !projects[_projectId].paused;
853 }
854 function addProject(string memory _projectName, string memory tokenURI, string memory description, string memory artistName, string memory projectWebsite, string memory projectLicense, address _artistAddress, uint256 _pricePerTokenInWei, uint256 _maxArtworks, uint256 _maxEarly) public onlyWhitelisted {
855     uint256 projectId = nextProjectId;
856     projectIdToArtistAddress[projectId] = _artistAddress;
857     projects[projectId].name = _projectName;
858     projects[projectId].artist = artistName;
859     projects[projectId].description = description;
860     projects[projectId].website = projectWebsite;
861     projects[projectId].license = projectLicense;
862     projectIdToCurrencySymbol[projectId] = "ETH";
863     projectIdToPricePerTokenInWei[projectId] = _pricePerTokenInWei;
864     projects[projectId].paused=false;
865     projects[projectId].earlyActive = false;
866     projects[projectId].publicActive = false;
867     projects[projectId].maxArtworks = _maxArtworks;
868     projects[projectId].maxEarly = _maxEarly;
869     projects[projectId].projectBaseURI = tokenURI;
870     nextProjectId = nextProjectId.add(1);
871 }
872 function updateProjectCurrencyInfo(uint256 _projectId, string memory _currencySymbol, address _currencyAddress) onlyAdmin() public {
873     projectIdToCurrencySymbol[_projectId] = _currencySymbol;
874     projectIdToCurrencyAddress[_projectId] = _currencyAddress;
875 }
876 function updateProjectPricePerTokenInWei(uint256 _projectId, uint256 _pricePerTokenInWei) onlyWhitelisted public {
877     projectIdToPricePerTokenInWei[_projectId] = _pricePerTokenInWei;
878 }
879 function updateProjectName(uint256 _projectId, string memory _projectName) onlyUnlocked(_projectId) onlyAdmin() public {
880     projects[_projectId].name = _projectName;
881 }
882 function updateProjectArtistName(uint256 _projectId, string memory _projectArtistName) onlyUnlocked(_projectId) onlyArtistOrWhitelisted(_projectId) public {
883     projects[_projectId].artist = _projectArtistName;
884 }
885 function updateProjectAdditionalPayeeInfo(uint256 _projectId, address _additionalPayee, uint256 _additionalPayeePercentage) onlyArtist(_projectId) public {
886     require(_additionalPayeePercentage <= 100, "Max of 100%");
887     projectIdToAdditionalPayee[_projectId] = _additionalPayee;
888     projectIdToAdditionalPayeePercentage[_projectId] = _additionalPayeePercentage;
889 }
890 function updateProjectDescription(uint256 _projectId, string memory _projectDescription) onlyArtist(_projectId) public {
891     projects[_projectId].description = _projectDescription;
892 }
893 function updateProjectWebsite(uint256 _projectId, string memory _projectWebsite) onlyArtist(_projectId) public {
894     projects[_projectId].website = _projectWebsite;
895 }
896 function updateProjectLicense(uint256 _projectId, string memory _projectLicense) onlyUnlocked(_projectId) onlyArtistOrWhitelisted(_projectId) public {
897     projects[_projectId].license = _projectLicense;
898 }
899 function updateProjectMaxArtworks(uint256 _projectId, uint256 _maxArtworks) onlyUnlocked(_projectId) onlyWhitelisted public {
900     require(_maxArtworks > projects[_projectId].artworks.add(50), "You must set max artworks greater than current artworks");
901     require(_maxArtworks <= 5000, "Cannot exceed 5000");
902     projects[_projectId].maxArtworks = _maxArtworks;
903 }
904  function updateProjectMaxEarly(uint256 _projectId, uint256 _maxEarly) onlyUnlocked(_projectId) onlyWhitelisted public {
905     require(_maxEarly < projects[_projectId].maxArtworks, "Early mint amount must be less than total number of artworks");
906     require(_maxEarly <= 2500, "Cannot exceed 2500");
907     projects[_projectId].maxEarly = _maxEarly;
908 }
909 function updateProjectBaseURI(uint256 _projectId, string memory _newBaseURI) onlyWhitelisted public {
910     projects[_projectId].projectBaseURI = _newBaseURI;
911 }
912 function projectDetails(uint256 _projectId) view public returns (string memory projectName, string memory artist, string memory description, string memory website, string memory license) {
913     projectName = projects[_projectId].name;
914     artist = projects[_projectId].artist;
915     description = projects[_projectId].description;
916     website = projects[_projectId].website;
917     license = projects[_projectId].license;
918 }
919 function projectTokenInfo(uint256 _projectId) view public returns (address artistAddress, uint256 pricePerTokenInWei, uint256 artworks, uint256 maxArtworks, uint256 maxEarly, address additionalPayee, uint256 additionalPayeePercentage, bool publicActive, bool earlyActive, string memory currency) {
920     artistAddress = projectIdToArtistAddress[_projectId];
921     pricePerTokenInWei = projectIdToPricePerTokenInWei[_projectId];
922     artworks = projects[_projectId].artworks.add(50); //add 50 to account for claimable pieces for sentient members
923     maxArtworks = projects[_projectId].maxArtworks;
924     maxEarly = projects[_projectId].maxEarly;
925     publicActive = projects[_projectId].publicActive;
926     earlyActive = projects[_projectId].earlyActive;
927     additionalPayee = projectIdToAdditionalPayee[_projectId];
928     additionalPayeePercentage = projectIdToAdditionalPayeePercentage[_projectId];
929     currency = projectIdToCurrencySymbol[_projectId];
930 }
931 function projectURIInfo(uint256 _projectId) view public returns (string memory projectBaseURI) {
932     projectBaseURI = projects[_projectId].projectBaseURI;
933 }
934 function projectShowAllTokens(uint _projectId) public view returns (uint256[] memory){
935     return projectIdToTokenIds[_projectId];
936 }
937 function tokensOfOwner(address owner) external view returns (uint256[] memory) {
938     return _tokensOfOwner(owner);
939 }
940 function getRoyaltyData(uint256 _tokenId) public view returns (address artistAddress, address additionalPayee, uint256 additionalPayeePercentage) {
941     artistAddress = projectIdToArtistAddress[tokenIdToProjectId[_tokenId]];
942     additionalPayee = projectIdToAdditionalPayee[tokenIdToProjectId[_tokenId]];
943     additionalPayeePercentage = projectIdToAdditionalPayeePercentage[tokenIdToProjectId[_tokenId]];
944 }
945 function tokenURI(uint256 _tokenId) external view onlyValidTokenId(_tokenId) returns (string memory) {
946     return Strings.strConcat(projects[tokenIdToProjectId[_tokenId]].projectBaseURI, Strings.uint2str(_tokenId));
947 }
948 }