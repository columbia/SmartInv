1 // SPDX-License-Identifier: WTFPL
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Interface of the ERC165 standard, as defined in the
7  * https://eips.ethereum.org/EIPS/eip-165[EIP].
8  *
9  * Implementers can declare support of contract interfaces, which can then be
10  * queried by others ({ERC165Checker}).
11  *
12  * For an implementation, see {ERC165}.
13  */
14 interface IERC165 {
15     /**
16      * @dev Returns true if this contract implements the interface defined by
17      * `interfaceId`. See the corresponding
18      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
19      * to learn more about how these ids are created.
20      *
21      * This function call must use less than 30 000 gas.
22      */
23     function supportsInterface(bytes4 interfaceId) external view returns (bool);
24 }
25 
26 
27 
28 interface IAdapter {
29     struct Call {
30         address target;
31         bytes callData;
32     }
33 
34     function outputTokens(address inputToken) external view returns (address[] memory outputs);
35 
36     function encodeMigration(address _genericRouter, address _strategy, address _lp, uint256 _amount)
37         external view returns (Call[] memory calls);
38 
39     function encodeWithdraw(address _lp, uint256 _amount) external view returns (Call[] memory calls);
40 
41     function buy(address _lp, address _exchange, uint256 _minAmountOut, uint256 _deadline) external payable;
42 
43     function getAmountOut(address _lp, address _exchange, uint256 _amountIn) external returns (uint256);
44 
45     function isWhitelisted(address _token) external view returns (bool);
46 }
47 
48 
49 
50 interface ILiquidityMigration {
51     function adapters(address _adapter) external view returns (bool);
52     function hasStaked(address _account, address _lp) external view returns (bool);
53 }
54 
55 
56 
57 
58 
59 
60 
61 
62 
63 
64 
65 
66 
67 
68 
69 
70 /**
71  * _Available since v3.1._
72  */
73 interface IERC1155Receiver is IERC165 {
74     /**
75         @dev Handles the receipt of a single ERC1155 token type. This function is
76         called at the end of a `safeTransferFrom` after the balance has been updated.
77         To accept the transfer, this must return
78         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
79         (i.e. 0xf23a6e61, or its own function selector).
80         @param operator The address which initiated the transfer (i.e. msg.sender)
81         @param from The address which previously owned the token
82         @param id The ID of the token being transferred
83         @param value The amount of tokens being transferred
84         @param data Additional data with no specified format
85         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
86     */
87     function onERC1155Received(
88         address operator,
89         address from,
90         uint256 id,
91         uint256 value,
92         bytes calldata data
93     ) external returns (bytes4);
94 
95     /**
96         @dev Handles the receipt of a multiple ERC1155 token types. This function
97         is called at the end of a `safeBatchTransferFrom` after the balances have
98         been updated. To accept the transfer(s), this must return
99         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
100         (i.e. 0xbc197c81, or its own function selector).
101         @param operator The address which initiated the batch transfer (i.e. msg.sender)
102         @param from The address which previously owned the token
103         @param ids An array containing ids of each token being transferred (order and length must match values array)
104         @param values An array containing amounts of each token being transferred (order and length must match ids array)
105         @param data Additional data with no specified format
106         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
107     */
108     function onERC1155BatchReceived(
109         address operator,
110         address from,
111         uint256[] calldata ids,
112         uint256[] calldata values,
113         bytes calldata data
114     ) external returns (bytes4);
115 }
116 
117 
118 
119 
120 
121 
122 
123 /**
124  * @dev Implementation of the {IERC165} interface.
125  *
126  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
127  * for the additional interface id that will be supported. For example:
128  *
129  * ```solidity
130  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
131  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
132  * }
133  * ```
134  *
135  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
136  */
137 abstract contract ERC165 is IERC165 {
138     /**
139      * @dev See {IERC165-supportsInterface}.
140      */
141     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
142         return interfaceId == type(IERC165).interfaceId;
143     }
144 }
145 
146 
147 /**
148  * @dev _Available since v3.1._
149  */
150 abstract contract ERC1155Receiver is ERC165, IERC1155Receiver {
151     /**
152      * @dev See {IERC165-supportsInterface}.
153      */
154     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
155         return interfaceId == type(IERC1155Receiver).interfaceId || super.supportsInterface(interfaceId);
156     }
157 }
158 
159 
160 /**
161  * @dev _Available since v3.1._
162  */
163 contract ERC1155Holder is ERC1155Receiver {
164     function onERC1155Received(
165         address,
166         address,
167         uint256,
168         uint256,
169         bytes memory
170     ) public virtual override returns (bytes4) {
171         return this.onERC1155Received.selector;
172     }
173 
174     function onERC1155BatchReceived(
175         address,
176         address,
177         uint256[] memory,
178         uint256[] memory,
179         bytes memory
180     ) public virtual override returns (bytes4) {
181         return this.onERC1155BatchReceived.selector;
182     }
183 }
184 
185 
186 
187 
188 
189 
190 
191 
192 
193 /*
194  * @dev Provides information about the current execution context, including the
195  * sender of the transaction and its data. While these are generally available
196  * via msg.sender and msg.data, they should not be accessed in such a direct
197  * manner, since when dealing with meta-transactions the account sending and
198  * paying for execution may not be the actual sender (as far as an application
199  * is concerned).
200  *
201  * This contract is only required for intermediate, library-like contracts.
202  */
203 abstract contract Context {
204     function _msgSender() internal view virtual returns (address) {
205         return msg.sender;
206     }
207 
208     function _msgData() internal view virtual returns (bytes calldata) {
209         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
210         return msg.data;
211     }
212 }
213 
214 
215 /**
216  * @dev Contract module which provides a basic access control mechanism, where
217  * there is an account (an owner) that can be granted exclusive access to
218  * specific functions.
219  *
220  * By default, the owner account will be the one that deploys the contract. This
221  * can later be changed with {transferOwnership}.
222  *
223  * This module is used through inheritance. It will make available the modifier
224  * `onlyOwner`, which can be applied to your functions to restrict their use to
225  * the owner.
226  */
227 abstract contract Ownable is Context {
228     address private _owner;
229 
230     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
231 
232     /**
233      * @dev Initializes the contract setting the deployer as the initial owner.
234      */
235     constructor() {
236         address msgSender = _msgSender();
237         _owner = msgSender;
238         emit OwnershipTransferred(address(0), msgSender);
239     }
240 
241     /**
242      * @dev Returns the address of the current owner.
243      */
244     function owner() public view virtual returns (address) {
245         return _owner;
246     }
247 
248     /**
249      * @dev Throws if called by any account other than the owner.
250      */
251     modifier onlyOwner() {
252         require(owner() == _msgSender(), "Ownable: caller is not the owner");
253         _;
254     }
255 
256     /**
257      * @dev Leaves the contract without owner. It will not be possible to call
258      * `onlyOwner` functions anymore. Can only be called by the current owner.
259      *
260      * NOTE: Renouncing ownership will leave the contract without an owner,
261      * thereby removing any functionality that is only available to the owner.
262      */
263     function renounceOwnership() public virtual onlyOwner {
264         emit OwnershipTransferred(_owner, address(0));
265         _owner = address(0);
266     }
267 
268     /**
269      * @dev Transfers ownership of the contract to a new account (`newOwner`).
270      * Can only be called by the current owner.
271      */
272     function transferOwnership(address newOwner) public virtual onlyOwner {
273         require(newOwner != address(0), "Ownable: new owner is the zero address");
274         emit OwnershipTransferred(_owner, newOwner);
275         _owner = newOwner;
276     }
277 }
278 
279 
280 
281 
282 
283 
284 
285 
286 
287 
288 
289 
290 /**
291  * @dev Required interface of an ERC1155 compliant contract, as defined in the
292  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
293  *
294  * _Available since v3.1._
295  */
296 interface IERC1155 is IERC165 {
297     /**
298      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
299      */
300     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
301 
302     /**
303      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
304      * transfers.
305      */
306     event TransferBatch(
307         address indexed operator,
308         address indexed from,
309         address indexed to,
310         uint256[] ids,
311         uint256[] values
312     );
313 
314     /**
315      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
316      * `approved`.
317      */
318     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
319 
320     /**
321      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
322      *
323      * If an {URI} event was emitted for `id`, the standard
324      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
325      * returned by {IERC1155MetadataURI-uri}.
326      */
327     event URI(string value, uint256 indexed id);
328 
329     /**
330      * @dev Returns the amount of tokens of token type `id` owned by `account`.
331      *
332      * Requirements:
333      *
334      * - `account` cannot be the zero address.
335      */
336     function balanceOf(address account, uint256 id) external view returns (uint256);
337 
338     /**
339      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
340      *
341      * Requirements:
342      *
343      * - `accounts` and `ids` must have the same length.
344      */
345     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
346         external
347         view
348         returns (uint256[] memory);
349 
350     /**
351      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
352      *
353      * Emits an {ApprovalForAll} event.
354      *
355      * Requirements:
356      *
357      * - `operator` cannot be the caller.
358      */
359     function setApprovalForAll(address operator, bool approved) external;
360 
361     /**
362      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
363      *
364      * See {setApprovalForAll}.
365      */
366     function isApprovedForAll(address account, address operator) external view returns (bool);
367 
368     /**
369      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
370      *
371      * Emits a {TransferSingle} event.
372      *
373      * Requirements:
374      *
375      * - `to` cannot be the zero address.
376      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
377      * - `from` must have a balance of tokens of type `id` of at least `amount`.
378      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
379      * acceptance magic value.
380      */
381     function safeTransferFrom(
382         address from,
383         address to,
384         uint256 id,
385         uint256 amount,
386         bytes calldata data
387     ) external;
388 
389     /**
390      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
391      *
392      * Emits a {TransferBatch} event.
393      *
394      * Requirements:
395      *
396      * - `ids` and `amounts` must have the same length.
397      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
398      * acceptance magic value.
399      */
400     function safeBatchTransferFrom(
401         address from,
402         address to,
403         uint256[] calldata ids,
404         uint256[] calldata amounts,
405         bytes calldata data
406     ) external;
407 }
408 
409 
410 interface IRoot1155 is IERC1155 {
411     function getMaxTokenID() external view returns(uint256);
412     function burn(address account, uint256 id, uint256 value) external;
413 }
414 
415 
416 
417 contract Claimable is Ownable, ERC1155Holder {
418     enum State {
419         Pending,
420         Active,
421         Closed
422     }
423     State private _state;
424 
425     uint256 public max;
426     address public migration;
427     address public collection;
428 
429     mapping (address => uint256) public index;
430     mapping (address => mapping (uint256 => bool)) public claimed;
431 
432     event Claimed(address indexed account, uint256 protocol);
433     event StateChange(uint8 changed);
434     event Migration(address migration);
435     event Collection(address collection);
436 
437     /**
438     * @dev Require particular state
439     */
440     modifier onlyState(State state_) {
441         require(state() == state_, "Claimable#onlyState: ONLY_STATE_ALLOWED");
442         _;
443     }
444 
445     /* assumption is enum ID will be the same as collection ID,
446      * and no further collections will be added whilst active
447     */
448     constructor(address _migration, address _collection, uint256 _max, address[] memory _index){
449         require(_max == _index.length, "Claimable#claim: incorrect max");
450         collection = _collection;
451         migration = _migration;
452         max = _max;
453         for (uint256 i = 0; i < _index.length; i++) {
454             if (i > 0) {
455                 require(_index[i] != _index[0] && index[_index[i]] == 0,  "Claimable#constructor: duplicate adapter");
456             }
457             index[_index[i]] = i;
458         }
459     }
460 
461     /**
462      * @notice claim NFT for staking LP
463      * @param _lp address of lp
464      * @param _adapter address of adapter
465      */
466     function claim(address _lp, address _adapter)
467         public
468         onlyState(State.Active)
469     {
470         require(_lp != address(0), "Claimable#claim: empty address");
471         require(_adapter != address(0), "Claimable#claim: empty address");
472 
473         require(ILiquidityMigration(migration).adapters(_adapter), "Claimable#claim: not adapter");
474         require(IAdapter(_adapter).isWhitelisted(_lp), "Claimable#claim: not associated");
475         require(ILiquidityMigration(migration).hasStaked(msg.sender, _lp), "Claimable#claim: not staked");
476 
477         uint256 _index = index[_adapter];
478         require(!claimed[msg.sender][_index], "Claimable#claim: already claimed");
479 
480         require(IERC1155(collection).balanceOf(address(this), _index) > 0, "Claimable#claim: no NFTs left");
481 
482         claimed[msg.sender][_index] = true;
483         IERC1155(collection).safeTransferFrom(address(this), msg.sender, _index, 1, "");
484         emit Claimed(msg.sender, _index);
485     }
486 
487     /**
488      * @notice you wanna be a masta good old boi?
489      */
490     function master()
491         public
492         onlyState(State.Active)
493     {
494         require(!claimed[msg.sender][max], "Claimable#master: claimed");
495         for (uint256 i = 0; i < max; i++) {
496             require(claimed[msg.sender][i], "Claimable#master: not all");
497             require(IERC1155(collection).balanceOf(msg.sender, i) > 0, "Claimable#master: not holding");
498         }
499         claimed[msg.sender][max] = true;
500         IERC1155(collection).safeTransferFrom(address(this), msg.sender, max, 1, "");
501         emit Claimed(msg.sender, max);
502     }
503 
504     /**
505      * @notice claim all through range
506      * @param _lp[] array of lp addresses
507      * @param _adapter[] array of adapter addresses
508      */
509 
510     function claimAll(address[] memory _lp, address[] memory _adapter)
511         public
512     {
513         require(_lp.length <= max, "Claimable#claimAll: incorrect length");
514         require(_lp.length == _adapter.length, "Claimable#claimAll: incorrect len");
515         for (uint256 i = 0; i < _lp.length; i++) {
516             claim(_lp[i], _adapter[i]);
517         }
518     }
519 
520     /**
521      * @notice we wipe it, and burn all - should have got in already
522      */
523     function wipe(uint256 _start, uint256 _end)
524         public
525         onlyOwner
526     {
527         require(_start < _end, "Claimable#Wipe: range out");
528         require(_end <= max, "Claimable#Wipe: out of bounds");
529         for (uint256 start = _start; start <= _end; start++) {
530             IRoot1155(collection).
531             burn(
532                 address(this),
533                 start,
534                 IERC1155(collection).balanceOf(address(this), start)
535             );
536         }
537     }
538 
539     /**
540      * @notice emergency from deployer change state
541      * @param state_ to change to
542      */
543     function stateChange(State state_)
544         public
545         onlyOwner
546     {
547         _stateChange(state_);
548     }
549 
550     /**
551      * @notice emergency from deployer change migration
552      * @param _migration to change to
553      */
554     function updateMigration(address _migration)
555         public
556         onlyOwner
557     {
558         require(_migration != migration, "Claimable#UpdateMigration: exists");
559         migration = _migration;
560         emit Migration(migration);
561     }
562 
563     /**
564      * @notice emergency from deployer change migration
565      * @param _collection to change to
566      */
567     function updateCollection(address _collection)
568         public
569         onlyOwner
570     {
571         require(_collection != collection, "Claimable#UpdateCollection: exists");
572         collection = _collection;
573         emit Collection(collection);
574     }
575 
576     /**
577      * @return current state.
578      */
579     function state() public view virtual returns (State) {
580         return _state;
581     }
582 
583     function _stateChange(State state_)
584         private
585     {
586         require(_state != state_, "Claimable#changeState: current");
587         _state = state_;
588         emit StateChange(uint8(_state));
589     }
590 }