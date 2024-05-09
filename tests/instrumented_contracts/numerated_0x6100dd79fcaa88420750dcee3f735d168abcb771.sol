1 // File: node_modules\@openzeppelin\contracts\utils\introspection\IERC165.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Interface of the ERC165 standard, as defined in the
9  * https://eips.ethereum.org/EIPS/eip-165[EIP].
10  *
11  * Implementers can declare support of contract interfaces, which can then be
12  * queried by others ({ERC165Checker}).
13  *
14  * For an implementation, see {ERC165}.
15  */
16 interface IERC165 {
17     /**
18      * @dev Returns true if this contract implements the interface defined by
19      * `interfaceId`. See the corresponding
20      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
21      * to learn more about how these ids are created.
22      *
23      * This function call must use less than 30 000 gas.
24      */
25     function supportsInterface(bytes4 interfaceId) external view returns (bool);
26 }
27 
28 // File: @openzeppelin\contracts\token\ERC1155\IERC1155.sol
29 
30 // SPDX_License_Identifier: MIT
31 
32 pragma solidity ^0.8.0;
33 
34 
35 /**
36  * @dev Required interface of an ERC1155 compliant contract, as defined in the
37  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
38  *
39  * _Available since v3.1._
40  */
41 interface IERC1155 is IERC165 {
42     /**
43      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
44      */
45     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
46 
47     /**
48      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
49      * transfers.
50      */
51     event TransferBatch(
52         address indexed operator,
53         address indexed from,
54         address indexed to,
55         uint256[] ids,
56         uint256[] values
57     );
58 
59     /**
60      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
61      * `approved`.
62      */
63     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
64 
65     /**
66      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
67      *
68      * If an {URI} event was emitted for `id`, the standard
69      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
70      * returned by {IERC1155MetadataURI-uri}.
71      */
72     event URI(string value, uint256 indexed id);
73 
74     /**
75      * @dev Returns the amount of tokens of token type `id` owned by `account`.
76      *
77      * Requirements:
78      *
79      * - `account` cannot be the zero address.
80      */
81     function balanceOf(address account, uint256 id) external view returns (uint256);
82 
83     /**
84      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
85      *
86      * Requirements:
87      *
88      * - `accounts` and `ids` must have the same length.
89      */
90     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
91         external
92         view
93         returns (uint256[] memory);
94 
95     /**
96      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
97      *
98      * Emits an {ApprovalForAll} event.
99      *
100      * Requirements:
101      *
102      * - `operator` cannot be the caller.
103      */
104     function setApprovalForAll(address operator, bool approved) external;
105 
106     /**
107      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
108      *
109      * See {setApprovalForAll}.
110      */
111     function isApprovedForAll(address account, address operator) external view returns (bool);
112 
113     /**
114      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
115      *
116      * Emits a {TransferSingle} event.
117      *
118      * Requirements:
119      *
120      * - `to` cannot be the zero address.
121      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
122      * - `from` must have a balance of tokens of type `id` of at least `amount`.
123      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
124      * acceptance magic value.
125      */
126     function safeTransferFrom(
127         address from,
128         address to,
129         uint256 id,
130         uint256 amount,
131         bytes calldata data
132     ) external;
133 
134     /**
135      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
136      *
137      * Emits a {TransferBatch} event.
138      *
139      * Requirements:
140      *
141      * - `ids` and `amounts` must have the same length.
142      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
143      * acceptance magic value.
144      */
145     function safeBatchTransferFrom(
146         address from,
147         address to,
148         uint256[] calldata ids,
149         uint256[] calldata amounts,
150         bytes calldata data
151     ) external;
152 }
153 
154 // File: contracts\model\IERC1155Views.sol
155 
156 // SPDX_License_Identifier: MIT
157 
158 pragma solidity >=0.7.0;
159 
160 /**
161  * @title IERC1155Views - An optional utility interface to improve the ERC-1155 Standard.
162  * @dev This interface introduces some additional capabilities for ERC-1155 Tokens.
163  */
164 interface IERC1155Views {
165 
166     /**
167      * @dev Returns the total supply of the given token id
168      * @param itemId the id of the token whose availability you want to know 
169      */
170     function totalSupply(uint256 itemId) external view returns (uint256);
171 
172     /**
173      * @dev Returns the name of the given token id
174      * @param itemId the id of the token whose name you want to know 
175      */
176     function name(uint256 itemId) external view returns (string memory);
177 
178     /**
179      * @dev Returns the symbol of the given token id
180      * @param itemId the id of the token whose symbol you want to know 
181      */
182     function symbol(uint256 itemId) external view returns (string memory);
183 
184     /**
185      * @dev Returns the decimals of the given token id
186      * @param itemId the id of the token whose decimals you want to know 
187      */
188     function decimals(uint256 itemId) external view returns (uint256);
189 
190     /**
191      * @dev Returns the uri of the given token id
192      * @param itemId the id of the token whose uri you want to know 
193      */
194     function uri(uint256 itemId) external view returns (string memory);
195 }
196 
197 // File: contracts\model\Item.sol
198 
199 //SPDX_License_Identifier: MIT
200 
201 pragma solidity >=0.7.0;
202 pragma abicoder v2;
203 
204 
205 
206 struct Header {
207     address host;
208     string name;
209     string symbol;
210     string uri;
211 }
212 
213 struct CreateItem {
214     Header header;
215     bytes32 collectionId;
216     uint256 id;
217     address[] accounts;
218     uint256[] amounts;
219 }
220 
221 interface Item is IERC1155, IERC1155Views {
222 
223     event CollectionItem(bytes32 indexed fromCollectionId, bytes32 indexed toCollectionId, uint256 indexed itemId);
224 
225     function name() external view returns(string memory);
226     function symbol() external view returns(string memory);
227     function decimals() external view returns(uint256);
228 
229     function burn(address account, uint256 itemId, uint256 amount) external;
230     function burnBatch(address account, uint256[] calldata itemIds, uint256[] calldata amounts) external;
231 
232     function burn(address account, uint256 itemId, uint256 amount, bytes calldata data) external;
233     function burnBatch(address account, uint256[] calldata itemIds, uint256[] calldata amounts, bytes calldata data) external;
234 
235     function mintItems(CreateItem[] calldata items) external returns(uint256[] memory itemIds);
236     function setItemsCollection(uint256[] calldata itemIds, bytes32[] calldata collectionIds) external returns(bytes32[] memory oldCollectionIds);
237     function setItemsMetadata(uint256[] calldata itemIds, Header[] calldata newValues) external returns(Header[] memory oldValues);
238 
239     function interoperableOf(uint256 itemId) external view returns(address);
240 }
241 
242 // File: contracts\model\IItemMainInterface.sol
243 
244 //SPDX_License_Identifier: MIT
245 pragma solidity >=0.7.0;
246 
247 
248 struct ItemData {
249     bytes32 collectionId;
250     Header header;
251     bytes32 domainSeparator;
252     uint256 totalSupply;
253     mapping(address => uint256) balanceOf;
254     mapping(address => mapping(address => uint256)) allowance;
255     mapping(address => uint256) nonces;
256 }
257 
258 interface IItemMainInterface is Item {
259 
260     event Collection(address indexed from, address indexed to, bytes32 indexed collectionId);
261 
262     function interoperableInterfaceModel() external view returns(address);
263 
264     function uri() external view returns(string memory);
265     function plainUri() external view returns(string memory);
266     function dynamicUriResolver() external view returns(address);
267     function hostInitializer() external view returns(address);
268 
269     function collection(bytes32 collectionId) external view returns(address host, string memory name, string memory symbol, string memory uri);
270     function collectionUri(bytes32 collectionId) external view returns(string memory);
271     function createCollection(Header calldata _collection, CreateItem[] calldata items) external returns(bytes32 collectionId, uint256[] memory itemIds);
272     function setCollectionsMetadata(bytes32[] calldata collectionIds, Header[] calldata values) external returns(Header[] memory oldValues);
273 
274     function setApprovalForAllByCollectionHost(bytes32 collectionId, address account, address operator, bool approved) external;
275 
276     function item(uint256 itemId) external view returns(bytes32 collectionId, Header memory header, bytes32 domainSeparator, uint256 totalSupply);
277 
278     function mintTransferOrBurn(bool isMulti, bytes calldata data) external;
279 
280     function allowance(address account, address spender, uint256 itemId) external view returns(uint256);
281     function approve(address account, address spender, uint256 amount, uint256 itemId) external;
282     function TYPEHASH_PERMIT() external view returns (bytes32);
283     function EIP712_PERMIT_DOMAINSEPARATOR_NAME_AND_VERSION() external view returns(string memory domainSeparatorName, string memory domainSeparatorVersion);
284     function permit(uint256 itemId, address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;
285     function nonces(address owner, uint256 itemId) external view returns(uint256);
286 }
287 
288 // File: @openzeppelin\contracts\token\ERC20\IERC20.sol
289 
290 // SPDX_License_Identifier: MIT
291 
292 pragma solidity ^0.8.0;
293 
294 /**
295  * @dev Interface of the ERC20 standard as defined in the EIP.
296  */
297 interface IERC20 {
298     /**
299      * @dev Returns the amount of tokens in existence.
300      */
301     function totalSupply() external view returns (uint256);
302 
303     /**
304      * @dev Returns the amount of tokens owned by `account`.
305      */
306     function balanceOf(address account) external view returns (uint256);
307 
308     /**
309      * @dev Moves `amount` tokens from the caller's account to `recipient`.
310      *
311      * Returns a boolean value indicating whether the operation succeeded.
312      *
313      * Emits a {Transfer} event.
314      */
315     function transfer(address recipient, uint256 amount) external returns (bool);
316 
317     /**
318      * @dev Returns the remaining number of tokens that `spender` will be
319      * allowed to spend on behalf of `owner` through {transferFrom}. This is
320      * zero by default.
321      *
322      * This value changes when {approve} or {transferFrom} are called.
323      */
324     function allowance(address owner, address spender) external view returns (uint256);
325 
326     /**
327      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
328      *
329      * Returns a boolean value indicating whether the operation succeeded.
330      *
331      * IMPORTANT: Beware that changing an allowance with this method brings the risk
332      * that someone may use both the old and the new allowance by unfortunate
333      * transaction ordering. One possible solution to mitigate this race
334      * condition is to first reduce the spender's allowance to 0 and set the
335      * desired value afterwards:
336      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
337      *
338      * Emits an {Approval} event.
339      */
340     function approve(address spender, uint256 amount) external returns (bool);
341 
342     /**
343      * @dev Moves `amount` tokens from `sender` to `recipient` using the
344      * allowance mechanism. `amount` is then deducted from the caller's
345      * allowance.
346      *
347      * Returns a boolean value indicating whether the operation succeeded.
348      *
349      * Emits a {Transfer} event.
350      */
351     function transferFrom(
352         address sender,
353         address recipient,
354         uint256 amount
355     ) external returns (bool);
356 
357     /**
358      * @dev Emitted when `value` tokens are moved from one account (`from`) to
359      * another (`to`).
360      *
361      * Note that `value` may be zero.
362      */
363     event Transfer(address indexed from, address indexed to, uint256 value);
364 
365     /**
366      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
367      * a call to {approve}. `value` is the new allowance.
368      */
369     event Approval(address indexed owner, address indexed spender, uint256 value);
370 }
371 
372 // File: @openzeppelin\contracts\token\ERC20\extensions\IERC20Metadata.sol
373 
374 // SPDX_License_Identifier: MIT
375 
376 pragma solidity ^0.8.0;
377 
378 
379 /**
380  * @dev Interface for the optional metadata functions from the ERC20 standard.
381  *
382  * _Available since v4.1._
383  */
384 interface IERC20Metadata is IERC20 {
385     /**
386      * @dev Returns the name of the token.
387      */
388     function name() external view returns (string memory);
389 
390     /**
391      * @dev Returns the symbol of the token.
392      */
393     function symbol() external view returns (string memory);
394 
395     /**
396      * @dev Returns the decimals places of the token.
397      */
398     function decimals() external view returns (uint8);
399 }
400 
401 // File: @openzeppelin\contracts\token\ERC20\extensions\draft-IERC20Permit.sol
402 
403 // SPDX_License_Identifier: MIT
404 
405 pragma solidity ^0.8.0;
406 
407 /**
408  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
409  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
410  *
411  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
412  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
413  * need to send a transaction, and thus is not required to hold Ether at all.
414  */
415 interface IERC20Permit {
416     /**
417      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
418      * given ``owner``'s signed approval.
419      *
420      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
421      * ordering also apply here.
422      *
423      * Emits an {Approval} event.
424      *
425      * Requirements:
426      *
427      * - `spender` cannot be the zero address.
428      * - `deadline` must be a timestamp in the future.
429      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
430      * over the EIP712-formatted function arguments.
431      * - the signature must use ``owner``'s current nonce (see {nonces}).
432      *
433      * For more information on the signature format, see the
434      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
435      * section].
436      */
437     function permit(
438         address owner,
439         address spender,
440         uint256 value,
441         uint256 deadline,
442         uint8 v,
443         bytes32 r,
444         bytes32 s
445     ) external;
446 
447     /**
448      * @dev Returns the current nonce for `owner`. This value must be
449      * included whenever a signature is generated for {permit}.
450      *
451      * Every successful call to {permit} increases ``owner``'s nonce by one. This
452      * prevents a signature from being used multiple times.
453      */
454     function nonces(address owner) external view returns (uint256);
455 
456     /**
457      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
458      */
459     // solhint-disable-next-line func-name-mixedcase
460     function DOMAIN_SEPARATOR() external view returns (bytes32);
461 }
462 
463 // File: contracts\model\IItemInteroperableInterface.sol
464 
465 //SPDX_License_Identifier: MIT
466 
467 pragma solidity >=0.7.0;
468 
469 
470 
471 
472 interface IItemInteroperableInterface is IERC20, IERC20Metadata, IERC20Permit {
473 
474     function init() external;
475     function mainInterface() external view returns(address);
476     function itemId() external view returns(uint256);
477     function emitEvent(bool forApprove, bool isMulti, bytes calldata data) external;
478     function burn(uint256 amount) external;
479     function burnFrom(address account, uint256 amount) external;
480     function EIP712_PERMIT_DOMAINSEPARATOR_NAME_AND_VERSION() external view returns(string memory name, string memory version);
481 }
482 
483 // File: contracts\impl\ItemInteroperableInterface.sol
484 
485 //SPDX_License_Identifier: MIT
486 
487 pragma solidity >=0.7.0;
488 
489 
490 
491 contract ItemInteroperableInterface is IItemInteroperableInterface {
492 
493     address public override mainInterface;
494 
495     function init() override external {
496         require(mainInterface == address(0));
497         mainInterface = msg.sender;
498     }
499 
500     function DOMAIN_SEPARATOR() external override view returns (bytes32 domainSeparatorValue) {
501         (,,domainSeparatorValue,) = IItemMainInterface(mainInterface).item(itemId());
502     }
503 
504     function EIP712_PERMIT_DOMAINSEPARATOR_NAME_AND_VERSION() external override view returns(string memory, string memory) {
505         return IItemMainInterface(mainInterface).EIP712_PERMIT_DOMAINSEPARATOR_NAME_AND_VERSION();
506     }
507 
508     function itemId() override public view returns(uint256) {
509         return uint160(address(this));
510     }
511 
512     function emitEvent(bool forApprove, bool isMulti, bytes calldata data) override external {
513         require(msg.sender == mainInterface, "Unauthorized");
514         if(isMulti) {
515             (address[] memory froms, address[] memory tos, uint256[] memory amounts) = abi.decode(data, (address[], address[], uint256[]));
516             for(uint256 i = 0; i < froms.length; i++) {
517                 if(forApprove) {
518                     emit Approval(froms[i], tos[i], amounts[i]);
519                 } else {
520                     emit Transfer(froms[i], tos[i], amounts[i]);
521                 }
522             }
523             return;
524         }
525         (address from, address to, uint256 amount) = abi.decode(data, (address, address, uint256));
526         if(forApprove) {
527             emit Approval(from, to, amount);
528         } else {
529             emit Transfer(from, to, amount);
530        }
531     }
532 
533     function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) override external {
534         IItemMainInterface(mainInterface).permit(itemId(), owner, spender, value, deadline, v, r, s);
535         emit Approval(owner, spender, value);
536     }
537 
538     function burn(uint256 amount) override external {
539         IItemMainInterface(mainInterface).mintTransferOrBurn(false, abi.encode(msg.sender, msg.sender, address(0), itemId(), amount));
540         emit Transfer(msg.sender, address(0), amount);
541     }
542 
543     function burnFrom(address account, uint256 amount) external override {
544         require(account != address(0), "burn zero address");
545         IItemMainInterface(mainInterface).mintTransferOrBurn(false, abi.encode(msg.sender, account, address(0), itemId(), amount));
546         emit Transfer(msg.sender, address(0), amount);
547     }
548 
549     function name() override external view returns (string memory) {
550         (, Header memory header,,) = IItemMainInterface(mainInterface).item(itemId());
551         return header.name;
552     }
553 
554     function symbol() override external view returns (string memory) {
555         (, Header memory header,,) = IItemMainInterface(mainInterface).item(itemId());
556         return header.symbol;
557     }
558 
559     function decimals() override external pure returns (uint8) {
560         return 18;
561     }
562 
563     function nonces(address owner) external override view returns(uint256) {
564         return IItemMainInterface(mainInterface).nonces(owner, itemId());
565     }
566 
567     function totalSupply() override external view returns (uint256 totalSupplyValue) {
568         (,,, totalSupplyValue) = IItemMainInterface(mainInterface).item(itemId());
569     }
570 
571     function balanceOf(address account) override external view returns (uint256) {
572         return IItemMainInterface(mainInterface).balanceOf(account, itemId());
573     }
574 
575     function allowance(address owner, address spender) override external view returns (uint256) {
576         return IItemMainInterface(mainInterface).allowance(owner, spender, itemId());
577     }
578 
579     function approve(address spender, uint256 amount) override external returns(bool) {
580         IItemMainInterface(mainInterface).approve(msg.sender, spender, amount, itemId());
581         emit Approval(msg.sender, spender, amount);
582         return true;
583     }
584 
585     function transfer(address recipient, uint256 amount) override external returns(bool) {
586         return _transferFrom(msg.sender, recipient, amount);
587     }
588 
589     function transferFrom(address sender, address recipient, uint256 amount) override external returns(bool) {
590         return _transferFrom(sender, recipient, amount);
591     }
592 
593     function _transferFrom(address sender, address recipient, uint256 amount) private returns(bool) {
594         require(sender != address(0), "transfer from the zero address");
595         require(recipient != address(0), "transfer to the zero address");
596         IItemMainInterface(mainInterface).mintTransferOrBurn(false, abi.encode(msg.sender, sender, recipient, itemId(), amount));
597         emit Transfer(sender, recipient, amount);
598         return true;
599     }
600 }