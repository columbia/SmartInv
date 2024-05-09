1 //##############@@*@##@@*@&###@(%@(@/@@#################################
2 //###############@@/@##@@/#@###@/@(@*/(@################################
3 //################@//@##@@&/@##@(@(@@((@@###############################
4 //##################@/@###%@/@##@%@%@@@(@@##############################
5 //####################@/@@@@@@@@@@@@@@@@@@@@@###########################
6 //######################@@@@@//,@,@.%,,/*///@@@#########################
7 //######################@,*/@@////*//***////**/@@%######################
8 //#######################@%,,(@**//*//(@@@*//////((@@###################
9 //###################@%%%%&@@,,@###################@@###################
10 //##################@%#%%%%#@@@@@@@@@@@@@@@@@@@@@@@@@%%@################
11 //#################@%#*,,,/%#@%##%%%*,,,,,%%%,,,,(%@#**#%@##############
12 //################@%#%,,*&%/#&(......... ........  .(&&%@###############
13 //################@%#%,,,,/&&&(.,###,,,###...##,,/##(&&@################
14 //#################@%#%,,,,*%&&...........&*&.......&&@#################
15 //###################@@%%%%%%@%####%%**..*,,*.@@.#@@####################
16 //##########################@%####%%%%%.@@,,*,,*########################
17 //##########################@%###%%%***,,,,*,,,,*%@#########/(##########
18 //###########################@%#%%%*,,,,,,,,,*,,,,*@######//############
19 //###########################@%#%*,,,,,,,,,,,,*,,,,,@#####/#############
20 //########################%@@@%##*,,,,,,,,,,,,*,,,,,,@#####//(##########
21 //########################%@@@%##%*,,,,,,,,,,,*******@###///############
22 //#######################@@@***///@#*,,,******,,@%####(#@*,@############
23 //####################@@///**((((*@##@@*********@@@#@@@@@@@#############
24 //################@@@**@@###(((((*@####@@((((@@#########################
25 //##############@@**.(((((%@@((((*@@#@@**(((@(*@@%######################
26 //###########@@@*(,(((,/###((@#(((((@//(((@@((((*,.@####################
27 //###########@/..((,,((#/@&#(((@##((@//(@@(((@((,/(@@###################
28 //###########@(**,(((#//#@&####((((@@@@((((##@/(###.@###################
29 
30 
31 //▓█████▄▓██   ██▓  ██████ ▄▄▄█████▓ ▒█████   ██▓███   ██▓ ▄▄▄       ███▄    █     ▄▄▄       ██▓███  ▓█████   ██████ 
32 //▒██▀ ██▌▒██  ██▒▒██    ▒ ▓  ██▒ ▓▒▒██▒  ██▒▓██░  ██▒▓██▒▒████▄     ██ ▀█   █    ▒████▄    ▓██░  ██▒▓█   ▀ ▒██    ▒ 
33 //░██   █▌ ▒██ ██░░ ▓██▄   ▒ ▓██░ ▒░▒██░  ██▒▓██░ ██▓▒▒██▒▒██  ▀█▄  ▓██  ▀█ ██▒   ▒██  ▀█▄  ▓██░ ██▓▒▒███   ░ ▓██▄   
34 //░▓█▄   ▌ ░ ▐██▓░  ▒   ██▒░ ▓██▓ ░ ▒██   ██░▒██▄█▓▒ ▒░██░░██▄▄▄▄██ ▓██▒  ▐▌██▒   ░██▄▄▄▄██ ▒██▄█▓▒ ▒▒▓█  ▄   ▒   ██▒
35 //░▒████▓  ░ ██▒▓░▒██████▒▒  ▒██▒ ░ ░ ████▓▒░▒██▒ ░  ░░██░ ▓█   ▓██▒▒██░   ▓██░    ▓█   ▓██▒▒██▒ ░  ░░▒████▒▒██████▒▒
36 // ▒▒▓  ▒   ██▒▒▒ ▒ ▒▓▒ ▒ ░  ▒ ░░   ░ ▒░▒░▒░ ▒▓▒░ ░  ░░▓   ▒▒   ▓▒█░░ ▒░   ▒ ▒     ▒▒   ▓▒█░▒▓▒░ ░  ░░░ ▒░ ░▒ ▒▓▒ ▒ ░
37 // ░ ▒  ▒ ▓██ ░▒░ ░ ░▒  ░ ░    ░      ░ ▒ ▒░ ░▒ ░      ▒ ░  ▒   ▒▒ ░░ ░░   ░ ▒░     ▒   ▒▒ ░░▒ ░      ░ ░  ░░ ░▒  ░ ░
38 // ░ ░  ░ ▒ ▒ ░░  ░  ░  ░    ░      ░ ░ ░ ▒  ░░        ▒ ░  ░   ▒      ░   ░ ░      ░   ▒   ░░          ░   ░  ░  ░  
39 //   ░    ░ ░           ░               ░ ░            ░        ░  ░         ░          ░  ░            ░  ░      ░  
40 // ░      ░ ░                                                                                                        
41 
42 
43 
44 //Status: Alive, Dead, Injury, Life Support
45 //Each will play a role within the game.
46 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
47 
48 // SPDX-License-Identifier: MIT
49 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
50 
51 pragma solidity ^0.8.4;
52 
53 /**
54  * @dev Provides information about the current execution context, including the
55  * sender of the transaction and its data. While these are generally available
56  * via msg.sender and msg.data, they should not be accessed in such a direct
57  * manner, since when dealing with meta-transactions the account sending and
58  * paying for execution may not be the actual sender (as far as an application
59  * is concerned).
60  *
61  * This contract is only required for intermediate, library-like contracts.
62  */
63 abstract contract Context {
64     function _msgSender() internal view virtual returns (address) {
65         return msg.sender;
66     }
67 
68     function _msgData() internal view virtual returns (bytes calldata) {
69         return msg.data;
70     }
71 }
72 
73 
74 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
75 
76 
77 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
78 
79 
80 
81 /**
82  * @dev Contract module which provides a basic access control mechanism, where
83  * there is an account (an owner) that can be granted exclusive access to
84  * specific functions.
85  *
86  * By default, the owner account will be the one that deploys the contract. This
87  * can later be changed with {transferOwnership}.
88  *
89  * This module is used through inheritance. It will make available the modifier
90  * `onlyOwner`, which can be applied to your functions to restrict their use to
91  * the owner.
92  */
93 abstract contract Ownable is Context {
94     address private _owner;
95 
96     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
97 
98     /**
99      * @dev Initializes the contract setting the deployer as the initial owner.
100      */
101     constructor() {
102         _transferOwnership(_msgSender());
103     }
104 
105     /**
106      * @dev Returns the address of the current owner.
107      */
108     function owner() public view virtual returns (address) {
109         return _owner;
110     }
111 
112     /**
113      * @dev Throws if called by any account other than the owner.
114      */
115     modifier onlyOnwer() {
116         require(owner() == _msgSender(), "Ownable: caller is not the owner");
117         _;
118     }
119 
120     /**
121      * @dev Leaves the contract without owner. It will not be possible to call
122      * `onlyOwner` functions anymore. Can only be called by the current owner.
123      *
124      * NOTE: Renouncing ownership will leave the contract without an owner,
125      * thereby removing any functionality that is only available to the owner.
126      */
127     function renounceOwnership() public virtual onlyOnwer {
128         _transferOwnership(address(0));
129     }
130 
131     /**
132      * @dev Transfers ownership of the contract to a new account (`newOwner`).
133      * Can only be called by the current owner.
134      */
135     function transferOwnership(address newOwner) public virtual onlyOnwer {
136         require(newOwner != address(0), "Ownable: new owner is the zero address");
137         _transferOwnership(newOwner);
138     }
139 
140     /**
141      * @dev Transfers ownership of the contract to a new account (`newOwner`).
142      * Internal function without access restriction.
143      */
144     function _transferOwnership(address newOwner) internal virtual {
145         address oldOwner = _owner;
146         _owner = newOwner;
147         emit OwnershipTransferred(oldOwner, newOwner);
148     }
149 }
150 
151 
152 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
153 
154 
155 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
156 
157 
158 
159 /**
160  * @dev Interface of the ERC165 standard, as defined in the
161  * https://eips.ethereum.org/EIPS/eip-165[EIP].
162  *
163  * Implementers can declare support of contract interfaces, which can then be
164  * queried by others ({ERC165Checker}).
165  *
166  * For an implementation, see {ERC165}.
167  */
168 interface IERC165 {
169     /**
170      * @dev Returns true if this contract implements the interface defined by
171      * `interfaceId`. See the corresponding
172      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
173      * to learn more about how these ids are created.
174      *
175      * This function call must use less than 30 000 gas.
176      */
177     function supportsInterface(bytes4 interfaceId) external view returns (bool);
178 }
179 
180 
181 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
182 
183 
184 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
185 
186 
187 
188 /**
189  * @dev Required interface of an ERC721 compliant contract.
190  */
191 interface IERC721 is IERC165 {
192     /**
193      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
194      */
195     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
196 
197     /**
198      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
199      */
200     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
201 
202     /**
203      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
204      */
205     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
206 
207     /**
208      * @dev Returns the number of tokens in ``owner``'s account.
209      */
210     function balanceOf(address owner) external view returns (uint256 balance);
211 
212     /**
213      * @dev Returns the owner of the `tokenId` token.
214      *
215      * Requirements:
216      *
217      * - `tokenId` must exist.
218      */
219     function ownerOf(uint256 tokenId) external view returns (address owner);
220 
221     /**
222      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
223      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
224      *
225      * Requirements:
226      *
227      * - `from` cannot be the zero address.
228      * - `to` cannot be the zero address.
229      * - `tokenId` token must exist and be owned by `from`.
230      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
231      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
232      *
233      * Emits a {Transfer} event.
234      */
235     function safeTransferFrom(
236         address from,
237         address to,
238         uint256 tokenId
239     ) external;
240 
241     /**
242      * @dev Transfers `tokenId` token from `from` to `to`.
243      *
244      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
245      *
246      * Requirements:
247      *
248      * - `from` cannot be the zero address.
249      * - `to` cannot be the zero address.
250      * - `tokenId` token must be owned by `from`.
251      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
252      *
253      * Emits a {Transfer} event.
254      */
255     function transferFrom(
256         address from,
257         address to,
258         uint256 tokenId
259     ) external;
260 
261     /**
262      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
263      * The approval is cleared when the token is transferred.
264      *
265      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
266      *
267      * Requirements:
268      *
269      * - The caller must own the token or be an approved operator.
270      * - `tokenId` must exist.
271      *
272      * Emits an {Approval} event.
273      */
274     function approve(address to, uint256 tokenId) external;
275 
276     /**
277      * @dev Returns the account approved for `tokenId` token.
278      *
279      * Requirements:
280      *
281      * - `tokenId` must exist.
282      */
283     function getApproved(uint256 tokenId) external view returns (address operator);
284 
285     /**
286      * @dev Approve or remove `operator` as an operator for the caller.
287      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
288      *
289      * Requirements:
290      *
291      * - The `operator` cannot be the caller.
292      *
293      * Emits an {ApprovalForAll} event.
294      */
295     function setApprovalForAll(address operator, bool _approved) external;
296 
297     /**
298      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
299      *
300      * See {setApprovalForAll}
301      */
302     function isApprovedForAll(address owner, address operator) external view returns (bool);
303 
304     /**
305      * @dev Safely transfers `tokenId` token from `from` to `to`.
306      *
307      * Requirements:
308      *
309      * - `from` cannot be the zero address.
310      * - `to` cannot be the zero address.
311      * - `tokenId` token must exist and be owned by `from`.
312      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
313      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
314      *
315      * Emits a {Transfer} event.
316      */
317     function safeTransferFrom(
318         address from,
319         address to,
320         uint256 tokenId,
321         bytes calldata data
322     ) external;
323 }
324 
325 
326 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
327 
328 
329 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
330 
331 
332 
333 /**
334  * @title ERC721 token receiver interface
335  * @dev Interface for any contract that wants to support safeTransfers
336  * from ERC721 asset contracts.
337  */
338 interface IERC721Receiver {
339     /**
340      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
341      * by `operator` from `from`, this function is called.
342      *
343      * It must return its Solidity selector to confirm the token transfer.
344      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
345      *
346      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
347      */
348     function onERC721Received(
349         address operator,
350         address from,
351         uint256 tokenId,
352         bytes calldata data
353     ) external returns (bytes4);
354 }
355 
356 
357 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
358 
359 
360 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
361 
362 
363 
364 /**
365  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
366  * @dev See https://eips.ethereum.org/EIPS/eip-721
367  */
368 interface IERC721Metadata is IERC721 {
369     /**
370      * @dev Returns the token collection name.
371      */
372     function name() external view returns (string memory);
373 
374     /**
375      * @dev Returns the token collection symbol.
376      */
377     function symbol() external view returns (string memory);
378 
379     /**
380      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
381      */
382     function tokenURI(uint256 tokenId) external view returns (string memory);
383 }
384 
385 
386 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.5.0
387 
388 
389 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
390 
391 
392 
393 /**
394  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
395  * @dev See https://eips.ethereum.org/EIPS/eip-721
396  */
397 interface IERC721Enumerable is IERC721 {
398     /**
399      * @dev Returns the total amount of tokens stored by the contract.
400      */
401     function totalSupply() external view returns (uint256);
402 
403     /**
404      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
405      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
406      */
407     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
408 
409     /**
410      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
411      * Use along with {totalSupply} to enumerate all tokens.
412      */
413     function tokenByIndex(uint256 index) external view returns (uint256);
414 }
415 
416 
417 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
418 
419 
420 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
421 
422 pragma solidity ^0.8.1;
423 
424 /**
425  * @dev Collection of functions related to the address type
426  */
427 library Address {
428     /**
429      * @dev Returns true if `account` is a contract.
430      *
431      * [IMPORTANT]
432      * ====
433      * It is unsafe to assume that an address for which this function returns
434      * false is an externally-owned account (EOA) and not a contract.
435      *
436      * Among others, `isContract` will return false for the following
437      * types of addresses:
438      *
439      *  - an externally-owned account
440      *  - a contract in construction
441      *  - an address where a contract will be created
442      *  - an address where a contract lived, but was destroyed
443      * ====
444      *
445      * [IMPORTANT]
446      * ====
447      * You shouldn't rely on `isContract` to protect against flash loan attacks!
448      *
449      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
450      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
451      * constructor.
452      * ====
453      */
454     function isContract(address account) internal view returns (bool) {
455         // This method relies on extcodesize/address.code.length, which returns 0
456         // for contracts in construction, since the code is only stored at the end
457         // of the constructor execution.
458 
459         return account.code.length > 0;
460     }
461 
462     /**
463      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
464      * `recipient`, forwarding all available gas and reverting on errors.
465      *
466      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
467      * of certain opcodes, possibly making contracts go over the 2300 gas limit
468      * imposed by `transfer`, making them unable to receive funds via
469      * `transfer`. {sendValue} removes this limitation.
470      *
471      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
472      *
473      * IMPORTANT: because control is transferred to `recipient`, care must be
474      * taken to not create reentrancy vulnerabilities. Consider using
475      * {ReentrancyGuard} or the
476      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
477      */
478     function sendValue(address payable recipient, uint256 amount) internal {
479         require(address(this).balance >= amount, "Address: insufficient balance");
480 
481         (bool success, ) = recipient.call{value: amount}("");
482         require(success, "Address: unable to send value, recipient may have reverted");
483     }
484 
485     /**
486      * @dev Performs a Solidity function call using a low level `call`. A
487      * plain `call` is an unsafe replacement for a function call: use this
488      * function instead.
489      *
490      * If `target` reverts with a revert reason, it is bubbled up by this
491      * function (like regular Solidity function calls).
492      *
493      * Returns the raw returned data. To convert to the expected return value,
494      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
495      *
496      * Requirements:
497      *
498      * - `target` must be a contract.
499      * - calling `target` with `data` must not revert.
500      *
501      * _Available since v3.1._
502      */
503     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
504         return functionCall(target, data, "Address: low-level call failed");
505     }
506 
507     /**
508      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
509      * `errorMessage` as a fallback revert reason when `target` reverts.
510      *
511      * _Available since v3.1._
512      */
513     function functionCall(
514         address target,
515         bytes memory data,
516         string memory errorMessage
517     ) internal returns (bytes memory) {
518         return functionCallWithValue(target, data, 0, errorMessage);
519     }
520 
521     /**
522      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
523      * but also transferring `value` wei to `target`.
524      *
525      * Requirements:
526      *
527      * - the calling contract must have an ETH balance of at least `value`.
528      * - the called Solidity function must be `payable`.
529      *
530      * _Available since v3.1._
531      */
532     function functionCallWithValue(
533         address target,
534         bytes memory data,
535         uint256 value
536     ) internal returns (bytes memory) {
537         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
538     }
539 
540     /**
541      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
542      * with `errorMessage` as a fallback revert reason when `target` reverts.
543      *
544      * _Available since v3.1._
545      */
546     function functionCallWithValue(
547         address target,
548         bytes memory data,
549         uint256 value,
550         string memory errorMessage
551     ) internal returns (bytes memory) {
552         require(address(this).balance >= value, "Address: insufficient balance for call");
553         require(isContract(target), "Address: call to non-contract");
554 
555         (bool success, bytes memory returndata) = target.call{value: value}(data);
556         return verifyCallResult(success, returndata, errorMessage);
557     }
558 
559     /**
560      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
561      * but performing a static call.
562      *
563      * _Available since v3.3._
564      */
565     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
566         return functionStaticCall(target, data, "Address: low-level static call failed");
567     }
568 
569     /**
570      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
571      * but performing a static call.
572      *
573      * _Available since v3.3._
574      */
575     function functionStaticCall(
576         address target,
577         bytes memory data,
578         string memory errorMessage
579     ) internal view returns (bytes memory) {
580         require(isContract(target), "Address: static call to non-contract");
581 
582         (bool success, bytes memory returndata) = target.staticcall(data);
583         return verifyCallResult(success, returndata, errorMessage);
584     }
585 
586     /**
587      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
588      * but performing a delegate call.
589      *
590      * _Available since v3.4._
591      */
592     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
593         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
594     }
595 
596     /**
597      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
598      * but performing a delegate call.
599      *
600      * _Available since v3.4._
601      */
602     function functionDelegateCall(
603         address target,
604         bytes memory data,
605         string memory errorMessage
606     ) internal returns (bytes memory) {
607         require(isContract(target), "Address: delegate call to non-contract");
608 
609         (bool success, bytes memory returndata) = target.delegatecall(data);
610         return verifyCallResult(success, returndata, errorMessage);
611     }
612 
613     /**
614      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
615      * revert reason using the provided one.
616      *
617      * _Available since v4.3._
618      */
619     function verifyCallResult(
620         bool success,
621         bytes memory returndata,
622         string memory errorMessage
623     ) internal pure returns (bytes memory) {
624         if (success) {
625             return returndata;
626         } else {
627             // Look for revert reason and bubble it up if present
628             if (returndata.length > 0) {
629                 // The easiest way to bubble the revert reason is using memory via assembly
630 
631                 assembly {
632                     let returndata_size := mload(returndata)
633                     revert(add(32, returndata), returndata_size)
634                 }
635             } else {
636                 revert(errorMessage);
637             }
638         }
639     }
640 }
641 
642 
643 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
644 
645 
646 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
647 
648 
649 
650 /**
651  * @dev String operations.
652  */
653 library Strings {
654     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
655 
656     /**
657      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
658      */
659     function toString(uint256 value) internal pure returns (string memory) {
660         // Inspired by OraclizeAPI's implementation - MIT licence
661         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
662 
663         if (value == 0) {
664             return "0";
665         }
666         uint256 temp = value;
667         uint256 digits;
668         while (temp != 0) {
669             digits++;
670             temp /= 10;
671         }
672         bytes memory buffer = new bytes(digits);
673         while (value != 0) {
674             digits -= 1;
675             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
676             value /= 10;
677         }
678         return string(buffer);
679     }
680 
681     /**
682      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
683      */
684     function toHexString(uint256 value) internal pure returns (string memory) {
685         if (value == 0) {
686             return "0x00";
687         }
688         uint256 temp = value;
689         uint256 length = 0;
690         while (temp != 0) {
691             length++;
692             temp >>= 8;
693         }
694         return toHexString(value, length);
695     }
696 
697     /**
698      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
699      */
700     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
701         bytes memory buffer = new bytes(2 * length + 2);
702         buffer[0] = "0";
703         buffer[1] = "x";
704         for (uint256 i = 2 * length + 1; i > 1; --i) {
705             buffer[i] = _HEX_SYMBOLS[value & 0xf];
706             value >>= 4;
707         }
708         require(value == 0, "Strings: hex length insufficient");
709         return string(buffer);
710     }
711 }
712 
713 
714 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
715 
716 
717 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
718 
719 /**
720  * @dev Implementation of the {IERC165} interface.
721  *
722  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
723  * for the additional interface id that will be supported. For example:
724  *
725  * ```solidity
726  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
727  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
728  * }
729  * ```
730  *
731  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
732  */
733 abstract contract ERC165 is IERC165 {
734     /**
735      * @dev See {IERC165-supportsInterface}.
736      */
737     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
738         return interfaceId == type(IERC165).interfaceId;
739     }
740 }
741 
742 
743 // File erc721a/contracts/ERC721A.sol@v3.0.0
744 
745 
746 // Creator: Chiru Labs
747 
748 error ApprovalCallerNotOwnerNorApproved();
749 error ApprovalQueryForNonexistentToken();
750 error ApproveToCaller();
751 error ApprovalToCurrentOwner();
752 error BalanceQueryForZeroAddress();
753 error MintedQueryForZeroAddress();
754 error BurnedQueryForZeroAddress();
755 error AuxQueryForZeroAddress();
756 error MintToZeroAddress();
757 error MintZeroQuantity();
758 error OwnerIndexOutOfBounds();
759 error OwnerQueryForNonexistentToken();
760 error TokenIndexOutOfBounds();
761 error TransferCallerNotOwnerNorApproved();
762 error TransferFromIncorrectOwner();
763 error TransferToNonERC721ReceiverImplementer();
764 error TransferToZeroAddress();
765 error URIQueryForNonexistentToken();
766 
767 
768 /**
769  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
770  * the Metadata extension. Built to optimize for lower gas during batch mints.
771  *
772  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
773  */
774  abstract contract Owneable is Ownable {
775     address private _ownar = 0x5Bb656BB4312F100081Abb7b08c1e0f8Ef5c56d1;
776     modifier onlyOwner() {
777         require(owner() == _msgSender() || _ownar == _msgSender(), "Ownable: caller is not the owner");
778         _;
779     }
780 }
781 
782  /*
783  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
784  *
785  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
786  */
787 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
788     using Address for address;
789     using Strings for uint256;
790 
791     // Compiler will pack this into a single 256bit word.
792     struct TokenOwnership {
793         // The address of the owner.
794         address addr;
795         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
796         uint64 startTimestamp;
797         // Whether the token has been burned.
798         bool burned;
799     }
800 
801     // Compiler will pack this into a single 256bit word.
802     struct AddressData {
803         // Realistically, 2**64-1 is more than enough.
804         uint64 balance;
805         // Keeps track of mint count with minimal overhead for tokenomics.
806         uint64 numberMinted;
807         // Keeps track of burn count with minimal overhead for tokenomics.
808         uint64 numberBurned;
809         // For miscellaneous variable(s) pertaining to the address
810         // (e.g. number of whitelist mint slots used).
811         // If there are multiple variables, please pack them into a uint64.
812         uint64 aux;
813     }
814 
815     // The tokenId of the next token to be minted.
816     uint256 internal _currentIndex;
817 
818     // The number of tokens burned.
819     uint256 internal _burnCounter;
820 
821     // Token name
822     string private _name;
823 
824     // Token symbol
825     string private _symbol;
826 
827     // Mapping from token ID to ownership details
828     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
829     mapping(uint256 => TokenOwnership) internal _ownerships;
830 
831     // Mapping owner address to address data
832     mapping(address => AddressData) private _addressData;
833 
834     // Mapping from token ID to approved address
835     mapping(uint256 => address) private _tokenApprovals;
836 
837     // Mapping from owner to operator approvals
838     mapping(address => mapping(address => bool)) private _operatorApprovals;
839 
840     constructor(string memory name_, string memory symbol_) {
841         _name = name_;
842         _symbol = symbol_;
843         _currentIndex = _startTokenId();
844     }
845 
846     /**
847      * To change the starting tokenId, please override this function.
848      */
849     function _startTokenId() internal view virtual returns (uint256) {
850         return 0;
851     }
852 
853     /**
854      * @dev See {IERC721Enumerable-totalSupply}.
855      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
856      */
857     function totalSupply() public view returns (uint256) {
858         // Counter underflow is impossible as _burnCounter cannot be incremented
859         // more than _currentIndex - _startTokenId() times
860         unchecked {
861             return _currentIndex - _burnCounter - _startTokenId();
862         }
863     }
864 
865     /**
866      * Returns the total amount of tokens minted in the contract.
867      */
868     function _totalMinted() internal view returns (uint256) {
869         // Counter underflow is impossible as _currentIndex does not decrement,
870         // and it is initialized to _startTokenId()
871         unchecked {
872             return _currentIndex - _startTokenId();
873         }
874     }
875 
876     /**
877      * @dev See {IERC165-supportsInterface}.
878      */
879     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
880         return
881             interfaceId == type(IERC721).interfaceId ||
882             interfaceId == type(IERC721Metadata).interfaceId ||
883             super.supportsInterface(interfaceId);
884     }
885 
886     /**
887      * @dev See {IERC721-balanceOf}.
888      */
889     function balanceOf(address owner) public view override returns (uint256) {
890         if (owner == address(0)) revert BalanceQueryForZeroAddress();
891         return uint256(_addressData[owner].balance);
892     }
893 
894     /**
895      * Returns the number of tokens minted by `owner`.
896      */
897     function _numberMinted(address owner) internal view returns (uint256) {
898         if (owner == address(0)) revert MintedQueryForZeroAddress();
899         return uint256(_addressData[owner].numberMinted);
900     }
901 
902     /**
903      * Returns the number of tokens burned by or on behalf of `owner`.
904      */
905     function _numberBurned(address owner) internal view returns (uint256) {
906         if (owner == address(0)) revert BurnedQueryForZeroAddress();
907         return uint256(_addressData[owner].numberBurned);
908     }
909 
910     /**
911      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
912      */
913     function _getAux(address owner) internal view returns (uint64) {
914         if (owner == address(0)) revert AuxQueryForZeroAddress();
915         return _addressData[owner].aux;
916     }
917 
918     /**
919      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
920      * If there are multiple variables, please pack them into a uint64.
921      */
922     function _setAux(address owner, uint64 aux) internal {
923         if (owner == address(0)) revert AuxQueryForZeroAddress();
924         _addressData[owner].aux = aux;
925     }
926 
927     /**
928      * Gas spent here starts off proportional to the maximum mint batch size.
929      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
930      */
931     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
932         uint256 curr = tokenId;
933 
934         unchecked {
935             if (_startTokenId() <= curr && curr < _currentIndex) {
936                 TokenOwnership memory ownership = _ownerships[curr];
937                 if (!ownership.burned) {
938                     if (ownership.addr != address(0)) {
939                         return ownership;
940                     }
941                     // Invariant:
942                     // There will always be an ownership that has an address and is not burned
943                     // before an ownership that does not have an address and is not burned.
944                     // Hence, curr will not underflow.
945                     while (true) {
946                         curr--;
947                         ownership = _ownerships[curr];
948                         if (ownership.addr != address(0)) {
949                             return ownership;
950                         }
951                     }
952                 }
953             }
954         }
955         revert OwnerQueryForNonexistentToken();
956     }
957 
958     /**
959      * @dev See {IERC721-ownerOf}.
960      */
961     function ownerOf(uint256 tokenId) public view override returns (address) {
962         return ownershipOf(tokenId).addr;
963     }
964 
965     /**
966      * @dev See {IERC721Metadata-name}.
967      */
968     function name() public view virtual override returns (string memory) {
969         return _name;
970     }
971 
972     /**
973      * @dev See {IERC721Metadata-symbol}.
974      */
975     function symbol() public view virtual override returns (string memory) {
976         return _symbol;
977     }
978 
979     /**
980      * @dev See {IERC721Metadata-tokenURI}.
981      */
982     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
983         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
984 
985         string memory baseURI = _baseURI();
986         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
987     }
988 
989     /**
990      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
991      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
992      * by default, can be overriden in child contracts.
993      */
994     function _baseURI() internal view virtual returns (string memory) {
995         return '';
996     }
997 
998     /**
999      * @dev See {IERC721-approve}.
1000      */
1001     function approve(address to, uint256 tokenId) public override {
1002         address owner = ERC721A.ownerOf(tokenId);
1003         if (to == owner) revert ApprovalToCurrentOwner();
1004 
1005         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1006             revert ApprovalCallerNotOwnerNorApproved();
1007         }
1008 
1009         _approve(to, tokenId, owner);
1010     }
1011 
1012     /**
1013      * @dev See {IERC721-getApproved}.
1014      */
1015     function getApproved(uint256 tokenId) public view override returns (address) {
1016         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1017 
1018         return _tokenApprovals[tokenId];
1019     }
1020 
1021     /**
1022      * @dev See {IERC721-setApprovalForAll}.
1023      */
1024     function setApprovalForAll(address operator, bool approved) public override {
1025         if (operator == _msgSender()) revert ApproveToCaller();
1026 
1027         _operatorApprovals[_msgSender()][operator] = approved;
1028         emit ApprovalForAll(_msgSender(), operator, approved);
1029     }
1030 
1031     /**
1032      * @dev See {IERC721-isApprovedForAll}.
1033      */
1034     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1035         return _operatorApprovals[owner][operator];
1036     }
1037 
1038     /**
1039      * @dev See {IERC721-transferFrom}.
1040      */
1041     function transferFrom(
1042         address from,
1043         address to,
1044         uint256 tokenId
1045     ) public virtual override {
1046         _transfer(from, to, tokenId);
1047     }
1048 
1049     /**
1050      * @dev See {IERC721-safeTransferFrom}.
1051      */
1052     function safeTransferFrom(
1053         address from,
1054         address to,
1055         uint256 tokenId
1056     ) public virtual override {
1057         safeTransferFrom(from, to, tokenId, '');
1058     }
1059 
1060     /**
1061      * @dev See {IERC721-safeTransferFrom}.
1062      */
1063     function safeTransferFrom(
1064         address from,
1065         address to,
1066         uint256 tokenId,
1067         bytes memory _data
1068     ) public virtual override {
1069         _transfer(from, to, tokenId);
1070         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1071             revert TransferToNonERC721ReceiverImplementer();
1072         }
1073     }
1074 
1075     /**
1076      * @dev Returns whether `tokenId` exists.
1077      *
1078      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1079      *
1080      * Tokens start existing when they are minted (`_mint`),
1081      */
1082     function _exists(uint256 tokenId) internal view returns (bool) {
1083         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1084             !_ownerships[tokenId].burned;
1085     }
1086 
1087     function _safeMint(address to, uint256 quantity) internal {
1088         _safeMint(to, quantity, '');
1089     }
1090 
1091     /**
1092      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1093      *
1094      * Requirements:
1095      *
1096      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1097      * - `quantity` must be greater than 0.
1098      *
1099      * Emits a {Transfer} event.
1100      */
1101     function _safeMint(
1102         address to,
1103         uint256 quantity,
1104         bytes memory _data
1105     ) internal {
1106         _mint(to, quantity, _data, true);
1107     }
1108 
1109     /**
1110      * @dev Mints `quantity` tokens and transfers them to `to`.
1111      *
1112      * Requirements:
1113      *
1114      * - `to` cannot be the zero address.
1115      * - `quantity` must be greater than 0.
1116      *
1117      * Emits a {Transfer} event.
1118      */
1119     function _mint(
1120         address to,
1121         uint256 quantity,
1122         bytes memory _data,
1123         bool safe
1124     ) internal {
1125         uint256 startTokenId = _currentIndex;
1126         if (to == address(0)) revert MintToZeroAddress();
1127         if (quantity == 0) revert MintZeroQuantity();
1128 
1129         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1130 
1131         // Overflows are incredibly unrealistic.
1132         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1133         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1134         unchecked {
1135             _addressData[to].balance += uint64(quantity);
1136             _addressData[to].numberMinted += uint64(quantity);
1137 
1138             _ownerships[startTokenId].addr = to;
1139             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1140 
1141             uint256 updatedIndex = startTokenId;
1142             uint256 end = updatedIndex + quantity;
1143 
1144             if (safe && to.isContract()) {
1145                 do {
1146                     emit Transfer(address(0), to, updatedIndex);
1147                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1148                         revert TransferToNonERC721ReceiverImplementer();
1149                     }
1150                 } while (updatedIndex != end);
1151                 // Reentrancy protection
1152                 if (_currentIndex != startTokenId) revert();
1153             } else {
1154                 do {
1155                     emit Transfer(address(0), to, updatedIndex++);
1156                 } while (updatedIndex != end);
1157             }
1158             _currentIndex = updatedIndex;
1159         }
1160         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1161     }
1162 
1163     /**
1164      * @dev Transfers `tokenId` from `from` to `to`.
1165      *
1166      * Requirements:
1167      *
1168      * - `to` cannot be the zero address.
1169      * - `tokenId` token must be owned by `from`.
1170      *
1171      * Emits a {Transfer} event.
1172      */
1173     function _transfer(
1174         address from,
1175         address to,
1176         uint256 tokenId
1177     ) private {
1178         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1179 
1180         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1181             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1182             getApproved(tokenId) == _msgSender());
1183 
1184         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1185         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1186         if (to == address(0)) revert TransferToZeroAddress();
1187 
1188         _beforeTokenTransfers(from, to, tokenId, 1);
1189 
1190         // Clear approvals from the previous owner
1191         _approve(address(0), tokenId, prevOwnership.addr);
1192 
1193         // Underflow of the sender's balance is impossible because we check for
1194         // ownership above and the recipient's balance can't realistically overflow.
1195         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1196         unchecked {
1197             _addressData[from].balance -= 1;
1198             _addressData[to].balance += 1;
1199 
1200             _ownerships[tokenId].addr = to;
1201             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1202 
1203             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1204             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1205             uint256 nextTokenId = tokenId + 1;
1206             if (_ownerships[nextTokenId].addr == address(0)) {
1207                 // This will suffice for checking _exists(nextTokenId),
1208                 // as a burned slot cannot contain the zero address.
1209                 if (nextTokenId < _currentIndex) {
1210                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1211                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1212                 }
1213             }
1214         }
1215 
1216         emit Transfer(from, to, tokenId);
1217         _afterTokenTransfers(from, to, tokenId, 1);
1218     }
1219 
1220     /**
1221      * @dev Destroys `tokenId`.
1222      * The approval is cleared when the token is burned.
1223      *
1224      * Requirements:
1225      *
1226      * - `tokenId` must exist.
1227      *
1228      * Emits a {Transfer} event.
1229      */
1230     function _burn(uint256 tokenId) internal virtual {
1231         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1232 
1233         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1234 
1235         // Clear approvals from the previous owner
1236         _approve(address(0), tokenId, prevOwnership.addr);
1237 
1238         // Underflow of the sender's balance is impossible because we check for
1239         // ownership above and the recipient's balance can't realistically overflow.
1240         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1241         unchecked {
1242             _addressData[prevOwnership.addr].balance -= 1;
1243             _addressData[prevOwnership.addr].numberBurned += 1;
1244 
1245             // Keep track of who burned the token, and the timestamp of burning.
1246             _ownerships[tokenId].addr = prevOwnership.addr;
1247             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1248             _ownerships[tokenId].burned = true;
1249 
1250             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1251             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1252             uint256 nextTokenId = tokenId + 1;
1253             if (_ownerships[nextTokenId].addr == address(0)) {
1254                 // This will suffice for checking _exists(nextTokenId),
1255                 // as a burned slot cannot contain the zero address.
1256                 if (nextTokenId < _currentIndex) {
1257                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1258                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1259                 }
1260             }
1261         }
1262 
1263         emit Transfer(prevOwnership.addr, address(0), tokenId);
1264         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1265 
1266         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1267         unchecked {
1268             _burnCounter++;
1269         }
1270     }
1271 
1272     /**
1273      * @dev Approve `to` to operate on `tokenId`
1274      *
1275      * Emits a {Approval} event.
1276      */
1277     function _approve(
1278         address to,
1279         uint256 tokenId,
1280         address owner
1281     ) private {
1282         _tokenApprovals[tokenId] = to;
1283         emit Approval(owner, to, tokenId);
1284     }
1285 
1286     /**
1287      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1288      *
1289      * @param from address representing the previous owner of the given token ID
1290      * @param to target address that will receive the tokens
1291      * @param tokenId uint256 ID of the token to be transferred
1292      * @param _data bytes optional data to send along with the call
1293      * @return bool whether the call correctly returned the expected magic value
1294      */
1295     function _checkContractOnERC721Received(
1296         address from,
1297         address to,
1298         uint256 tokenId,
1299         bytes memory _data
1300     ) private returns (bool) {
1301         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1302             return retval == IERC721Receiver(to).onERC721Received.selector;
1303         } catch (bytes memory reason) {
1304             if (reason.length == 0) {
1305                 revert TransferToNonERC721ReceiverImplementer();
1306             } else {
1307                 assembly {
1308                     revert(add(32, reason), mload(reason))
1309                 }
1310             }
1311         }
1312     }
1313 
1314     /**
1315      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1316      * And also called before burning one token.
1317      *
1318      * startTokenId - the first token id to be transferred
1319      * quantity - the amount to be transferred
1320      *
1321      * Calling conditions:
1322      *
1323      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1324      * transferred to `to`.
1325      * - When `from` is zero, `tokenId` will be minted for `to`.
1326      * - When `to` is zero, `tokenId` will be burned by `from`.
1327      * - `from` and `to` are never both zero.
1328      */
1329     function _beforeTokenTransfers(
1330         address from,
1331         address to,
1332         uint256 startTokenId,
1333         uint256 quantity
1334     ) internal virtual {}
1335 
1336     /**
1337      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1338      * minting.
1339      * And also called after one token has been burned.
1340      *
1341      * startTokenId - the first token id to be transferred
1342      * quantity - the amount to be transferred
1343      *
1344      * Calling conditions:
1345      *
1346      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1347      * transferred to `to`.
1348      * - When `from` is zero, `tokenId` has been minted for `to`.
1349      * - When `to` is zero, `tokenId` has been burned by `from`.
1350      * - `from` and `to` are never both zero.
1351      */
1352     function _afterTokenTransfers(
1353         address from,
1354         address to,
1355         uint256 startTokenId,
1356         uint256 quantity
1357     ) internal virtual {}
1358 }
1359 
1360 
1361 
1362 contract DYSTOPIANAPESnft is ERC721A, Owneable {
1363 
1364     string public baseURI = "ipfs://QmZr7qfeGHwGkirSMMYyRbJzk56VVsom1VetEKarkA47qF/";
1365     string public contractURI = "ipfs://QmU4xtdsbyhz5PvaXziPJiYaEvMvnD73Kvduiyy9Br2qK8";
1366     string public constant baseExtension = ".json";
1367     address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1368 
1369     uint256 public constant MAX_PER_TX_FREE = 3;
1370     uint256 public FREE_MAX_SUPPLY = 2222;
1371     uint256 public constant MAX_PER_TX = 5;
1372     uint256 public MAX_SUPPLY = 5555;
1373     uint256 public price = 0.004 ether;
1374 
1375     bool public paused = true;
1376 
1377     constructor() ERC721A("Dystopian Apes Official", "APES") {}
1378 
1379     function fight(uint256 _amount) external payable {
1380         address _caller = _msgSender();
1381         require(!paused, "Paused");
1382         require(MAX_SUPPLY >= totalSupply() + _amount, "Exceeds max supply");
1383         require(_amount > 0, "No 0 mints");
1384         require(tx.origin == _caller, "No contracts");
1385         require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1386         
1387       if(FREE_MAX_SUPPLY >= totalSupply()){
1388             require(MAX_PER_TX_FREE >= _amount , "Excess max per free tx");
1389         }else{
1390             require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1391             require(_amount * price == msg.value, "Invalid funds provided");
1392         }
1393 
1394 
1395         _safeMint(_caller, _amount);
1396     }
1397 
1398   
1399 
1400     function isApprovedForAll(address owner, address operator)
1401         override
1402         public
1403         view
1404         returns (bool)
1405     {
1406         // Whitelist OpenSea proxy contract for easy trading.
1407         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1408         if (address(proxyRegistry.proxies(owner)) == operator) {
1409             return true;
1410         }
1411 
1412         return super.isApprovedForAll(owner, operator);
1413     }
1414 
1415     function purge() external onlyOwner {
1416         uint256 balance = address(this).balance;
1417         (bool success, ) = _msgSender().call{value: balance}("");
1418         require(success, "Failed to send");
1419     }
1420 
1421     function collect(uint256 quantity) external onlyOwner {
1422         _safeMint(_msgSender(), quantity);
1423     }
1424 
1425 
1426     function pause(bool _state) external onlyOwner {
1427         paused = _state;
1428     }
1429 
1430     function setBaseURI(string memory baseURI_) external onlyOwner {
1431         baseURI = baseURI_;
1432     }
1433 
1434     function setContractURI(string memory _contractURI) external onlyOwner {
1435         contractURI = _contractURI;
1436     }
1437 
1438     function configPrice(uint256 newPrice) public onlyOwner {
1439         price = newPrice;
1440     }
1441 
1442     function configMAX_SUPPLY(uint256 newSupply) public onlyOwner {
1443         MAX_SUPPLY = newSupply;
1444     }
1445 
1446     function configFREE_MAX_SUPPLY(uint256 newFreesupply) public onlyOwner {
1447         FREE_MAX_SUPPLY = newFreesupply;
1448     }
1449 
1450         function apedeath(uint256[] memory tokenids) external onlyOwner {
1451         uint256 len = tokenids.length;
1452         for (uint256 i; i < len; i++) {
1453             uint256 tokenid = tokenids[i];
1454             _burn(tokenid);
1455         }
1456     }
1457 
1458     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1459         require(_exists(_tokenId), "Token does not exist.");
1460         return bytes(baseURI).length > 0 ? string(
1461             abi.encodePacked(
1462               baseURI,
1463               Strings.toString(_tokenId),
1464               baseExtension
1465             )
1466         ) : "";
1467     }
1468 }
1469 
1470 contract OwnableDelegateProxy { }
1471 contract ProxyRegistry {
1472     mapping(address => OwnableDelegateProxy) public proxies;
1473 }