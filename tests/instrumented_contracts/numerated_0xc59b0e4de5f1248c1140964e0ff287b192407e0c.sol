1 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
7  * the optional functions; to access them see `ERC20Detailed`.
8  */
9 interface IERC20 {
10     /**
11      * @dev Returns the amount of tokens in existence.
12      */
13     function totalSupply() external view returns (uint256);
14 
15     /**
16      * @dev Returns the amount of tokens owned by `account`.
17      */
18     function balanceOf(address account) external view returns (uint256);
19 
20     /**
21      * @dev Moves `amount` tokens from the caller's account to `recipient`.
22      *
23      * Returns a boolean value indicating whether the operation succeeded.
24      *
25      * Emits a `Transfer` event.
26      */
27     function transfer(address recipient, uint256 amount) external returns (bool);
28 
29     /**
30      * @dev Returns the remaining number of tokens that `spender` will be
31      * allowed to spend on behalf of `owner` through `transferFrom`. This is
32      * zero by default.
33      *
34      * This value changes when `approve` or `transferFrom` are called.
35      */
36     function allowance(address owner, address spender) external view returns (uint256);
37 
38     /**
39      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * > Beware that changing an allowance with this method brings the risk
44      * that someone may use both the old and the new allowance by unfortunate
45      * transaction ordering. One possible solution to mitigate this race
46      * condition is to first reduce the spender's allowance to 0 and set the
47      * desired value afterwards:
48      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
49      *
50      * Emits an `Approval` event.
51      */
52     function approve(address spender, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Moves `amount` tokens from `sender` to `recipient` using the
56      * allowance mechanism. `amount` is then deducted from the caller's
57      * allowance.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a `Transfer` event.
62      */
63     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Emitted when `value` tokens are moved from one account (`from`) to
67      * another (`to`).
68      *
69      * Note that `value` may be zero.
70      */
71     event Transfer(address indexed from, address indexed to, uint256 value);
72 
73     /**
74      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
75      * a call to `approve`. `value` is the new allowance.
76      */
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 // File: openzeppelin-solidity/contracts/introspection/IERC165.sol
81 
82 pragma solidity ^0.5.0;
83 
84 /**
85  * @dev Interface of the ERC165 standard, as defined in the
86  * [EIP](https://eips.ethereum.org/EIPS/eip-165).
87  *
88  * Implementers can declare support of contract interfaces, which can then be
89  * queried by others (`ERC165Checker`).
90  *
91  * For an implementation, see `ERC165`.
92  */
93 interface IERC165 {
94     /**
95      * @dev Returns true if this contract implements the interface defined by
96      * `interfaceId`. See the corresponding
97      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
98      * to learn more about how these ids are created.
99      *
100      * This function call must use less than 30 000 gas.
101      */
102     function supportsInterface(bytes4 interfaceId) external view returns (bool);
103 }
104 
105 // File: contracts/ERC1155/IERC1155.sol
106 
107 pragma solidity ^0.5.0;
108 
109 
110 /**
111     @title ERC-1155 Multi Token Standard basic interface
112     @dev See https://eips.ethereum.org/EIPS/eip-1155
113  */
114 contract IERC1155 is IERC165 {
115     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
116 
117     event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values);
118 
119     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
120 
121     event URI(string value, uint256 indexed id);
122 
123     function balanceOf(address owner, uint256 id) public view returns (uint256);
124 
125     function balanceOfBatch(address[] memory owners, uint256[] memory ids) public view returns (uint256[] memory);
126 
127     function setApprovalForAll(address operator, bool approved) external;
128 
129     function isApprovedForAll(address owner, address operator) external view returns (bool);
130 
131     function safeTransferFrom(address from, address to, uint256 id, uint256 value, bytes calldata data) external;
132 
133     function safeBatchTransferFrom(address from, address to, uint256[] calldata ids, uint256[] calldata values, bytes calldata data) external;
134 }
135 
136 // File: contracts/ERC1155/IERC1155TokenReceiver.sol
137 
138 pragma solidity ^0.5.0;
139 
140 
141 /**
142     @title ERC-1155 Multi Token Receiver Interface
143     @dev See https://eips.ethereum.org/EIPS/eip-1155
144 */
145 contract IERC1155TokenReceiver is IERC165 {
146 
147     /**
148         @dev Handles the receipt of a single ERC1155 token type. This function is
149         called at the end of a `safeTransferFrom` after the balance has been updated.
150         To accept the transfer, this must return
151         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
152         (i.e. 0xf23a6e61, or its own function selector).
153         @param operator The address which initiated the transfer (i.e. msg.sender)
154         @param from The address which previously owned the token
155         @param id The ID of the token being transferred
156         @param value The amount of tokens being transferred
157         @param data Additional data with no specified format
158         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
159     */
160     function onERC1155Received(
161         address operator,
162         address from,
163         uint256 id,
164         uint256 value,
165         bytes calldata data
166     )
167         external
168         returns(bytes4);
169 
170     /**
171         @dev Handles the receipt of a multiple ERC1155 token types. This function
172         is called at the end of a `safeBatchTransferFrom` after the balances have
173         been updated. To accept the transfer(s), this must return
174         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
175         (i.e. 0xbc197c81, or its own function selector).
176         @param operator The address which initiated the batch transfer (i.e. msg.sender)
177         @param from The address which previously owned the token
178         @param ids An array containing ids of each token being transferred (order and length must match values array)
179         @param values An array containing amounts of each token being transferred (order and length must match ids array)
180         @param data Additional data with no specified format
181         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
182     */
183     function onERC1155BatchReceived(
184         address operator,
185         address from,
186         uint256[] calldata ids,
187         uint256[] calldata values,
188         bytes calldata data
189     )
190         external
191         returns(bytes4);
192 }
193 
194 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
195 
196 pragma solidity ^0.5.0;
197 
198 /**
199  * @dev Wrappers over Solidity's arithmetic operations with added overflow
200  * checks.
201  *
202  * Arithmetic operations in Solidity wrap on overflow. This can easily result
203  * in bugs, because programmers usually assume that an overflow raises an
204  * error, which is the standard behavior in high level programming languages.
205  * `SafeMath` restores this intuition by reverting the transaction when an
206  * operation overflows.
207  *
208  * Using this library instead of the unchecked operations eliminates an entire
209  * class of bugs, so it's recommended to use it always.
210  */
211 library SafeMath {
212     /**
213      * @dev Returns the addition of two unsigned integers, reverting on
214      * overflow.
215      *
216      * Counterpart to Solidity's `+` operator.
217      *
218      * Requirements:
219      * - Addition cannot overflow.
220      */
221     function add(uint256 a, uint256 b) internal pure returns (uint256) {
222         uint256 c = a + b;
223         require(c >= a, "SafeMath: addition overflow");
224 
225         return c;
226     }
227 
228     /**
229      * @dev Returns the subtraction of two unsigned integers, reverting on
230      * overflow (when the result is negative).
231      *
232      * Counterpart to Solidity's `-` operator.
233      *
234      * Requirements:
235      * - Subtraction cannot overflow.
236      */
237     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
238         require(b <= a, "SafeMath: subtraction overflow");
239         uint256 c = a - b;
240 
241         return c;
242     }
243 
244     /**
245      * @dev Returns the multiplication of two unsigned integers, reverting on
246      * overflow.
247      *
248      * Counterpart to Solidity's `*` operator.
249      *
250      * Requirements:
251      * - Multiplication cannot overflow.
252      */
253     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
254         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
255         // benefit is lost if 'b' is also tested.
256         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
257         if (a == 0) {
258             return 0;
259         }
260 
261         uint256 c = a * b;
262         require(c / a == b, "SafeMath: multiplication overflow");
263 
264         return c;
265     }
266 
267     /**
268      * @dev Returns the integer division of two unsigned integers. Reverts on
269      * division by zero. The result is rounded towards zero.
270      *
271      * Counterpart to Solidity's `/` operator. Note: this function uses a
272      * `revert` opcode (which leaves remaining gas untouched) while Solidity
273      * uses an invalid opcode to revert (consuming all remaining gas).
274      *
275      * Requirements:
276      * - The divisor cannot be zero.
277      */
278     function div(uint256 a, uint256 b) internal pure returns (uint256) {
279         // Solidity only automatically asserts when dividing by 0
280         require(b > 0, "SafeMath: division by zero");
281         uint256 c = a / b;
282         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
283 
284         return c;
285     }
286 
287     /**
288      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
289      * Reverts when dividing by zero.
290      *
291      * Counterpart to Solidity's `%` operator. This function uses a `revert`
292      * opcode (which leaves remaining gas untouched) while Solidity uses an
293      * invalid opcode to revert (consuming all remaining gas).
294      *
295      * Requirements:
296      * - The divisor cannot be zero.
297      */
298     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
299         require(b != 0, "SafeMath: modulo by zero");
300         return a % b;
301     }
302 }
303 
304 // File: openzeppelin-solidity/contracts/utils/Address.sol
305 
306 pragma solidity ^0.5.0;
307 
308 /**
309  * @dev Collection of functions related to the address type,
310  */
311 library Address {
312     /**
313      * @dev Returns true if `account` is a contract.
314      *
315      * This test is non-exhaustive, and there may be false-negatives: during the
316      * execution of a contract's constructor, its address will be reported as
317      * not containing a contract.
318      *
319      * > It is unsafe to assume that an address for which this function returns
320      * false is an externally-owned account (EOA) and not a contract.
321      */
322     function isContract(address account) internal view returns (bool) {
323         // This method relies in extcodesize, which returns 0 for contracts in
324         // construction, since the code is only stored at the end of the
325         // constructor execution.
326 
327         uint256 size;
328         // solhint-disable-next-line no-inline-assembly
329         assembly { size := extcodesize(account) }
330         return size > 0;
331     }
332 }
333 
334 // File: openzeppelin-solidity/contracts/introspection/ERC165.sol
335 
336 pragma solidity ^0.5.0;
337 
338 
339 /**
340  * @dev Implementation of the `IERC165` interface.
341  *
342  * Contracts may inherit from this and call `_registerInterface` to declare
343  * their support of an interface.
344  */
345 contract ERC165 is IERC165 {
346     /*
347      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
348      */
349     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
350 
351     /**
352      * @dev Mapping of interface ids to whether or not it's supported.
353      */
354     mapping(bytes4 => bool) private _supportedInterfaces;
355 
356     constructor () internal {
357         // Derived contracts need only register support for their own interfaces,
358         // we register support for ERC165 itself here
359         _registerInterface(_INTERFACE_ID_ERC165);
360     }
361 
362     /**
363      * @dev See `IERC165.supportsInterface`.
364      *
365      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
366      */
367     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
368         return _supportedInterfaces[interfaceId];
369     }
370 
371     /**
372      * @dev Registers the contract as an implementer of the interface defined by
373      * `interfaceId`. Support of the actual ERC165 interface is automatic and
374      * registering its interface id is not required.
375      *
376      * See `IERC165.supportsInterface`.
377      *
378      * Requirements:
379      *
380      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
381      */
382     function _registerInterface(bytes4 interfaceId) internal {
383         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
384         _supportedInterfaces[interfaceId] = true;
385     }
386 }
387 
388 // File: contracts/ERC1155/ERC1155.sol
389 
390 pragma solidity ^0.5.0;
391 
392 
393 
394 
395 
396 
397 /**
398  * @title Standard ERC1155 token
399  *
400  * @dev Implementation of the basic standard multi-token.
401  * See https://eips.ethereum.org/EIPS/eip-1155
402  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
403  */
404 contract ERC1155 is ERC165, IERC1155
405 {
406     using SafeMath for uint256;
407     using Address for address;
408 
409     // Mapping from token ID to owner balances
410     mapping (uint256 => mapping(address => uint256)) private _balances;
411 
412     // Mapping from owner to operator approvals
413     mapping (address => mapping(address => bool)) private _operatorApprovals;
414 
415     constructor()
416         public
417     {
418         _registerInterface(
419             ERC1155(0).safeTransferFrom.selector ^
420             ERC1155(0).safeBatchTransferFrom.selector ^
421             ERC1155(0).balanceOf.selector ^
422             ERC1155(0).balanceOfBatch.selector ^
423             ERC1155(0).setApprovalForAll.selector ^
424             ERC1155(0).isApprovedForAll.selector
425         );
426     }
427 
428     /**
429         @dev Get the specified address' balance for token with specified ID.
430         @param owner The address of the token holder
431         @param id ID of the token
432         @return The owner's balance of the token type requested
433      */
434     function balanceOf(address owner, uint256 id) public view returns (uint256) {
435         require(owner != address(0), "ERC1155: balance query for the zero address");
436         return _balances[id][owner];
437     }
438 
439     /**
440         @dev Get the balance of multiple account/token pairs
441         @param owners The addresses of the token holders
442         @param ids IDs of the tokens
443         @return Balances for each owner and token id pair
444      */
445     function balanceOfBatch(
446         address[] memory owners,
447         uint256[] memory ids
448     )
449         public
450         view
451         returns (uint256[] memory)
452     {
453         require(owners.length == ids.length, "ERC1155: owners and IDs must have same lengths");
454 
455         uint256[] memory batchBalances = new uint256[](owners.length);
456 
457         for (uint256 i = 0; i < owners.length; ++i) {
458             require(owners[i] != address(0), "ERC1155: some address in batch balance query is zero");
459             batchBalances[i] = _balances[ids[i]][owners[i]];
460         }
461 
462         return batchBalances;
463     }
464 
465     /**
466      * @dev Sets or unsets the approval of a given operator
467      * An operator is allowed to transfer all tokens of the sender on their behalf
468      * @param operator address to set the approval
469      * @param approved representing the status of the approval to be set
470      */
471     function setApprovalForAll(address operator, bool approved) external {
472         _operatorApprovals[msg.sender][operator] = approved;
473         emit ApprovalForAll(msg.sender, operator, approved);
474     }
475 
476     /**
477         @notice Queries the approval status of an operator for a given owner.
478         @param owner     The owner of the Tokens
479         @param operator  Address of authorized operator
480         @return           True if the operator is approved, false if not
481     */
482     function isApprovedForAll(address owner, address operator) external view returns (bool) {
483         return _operatorApprovals[owner][operator];
484     }
485 
486     /**
487         @dev Transfers `value` amount of an `id` from the `from` address to the `to` address specified.
488         Caller must be approved to manage the tokens being transferred out of the `from` account.
489         If `to` is a smart contract, will call `onERC1155Received` on `to` and act appropriately.
490         @param from Source address
491         @param to Target address
492         @param id ID of the token type
493         @param value Transfer amount
494         @param data Data forwarded to `onERC1155Received` if `to` is a contract receiver
495     */
496     function safeTransferFrom(
497         address from,
498         address to,
499         uint256 id,
500         uint256 value,
501         bytes calldata data
502     )
503         external
504     {
505         require(to != address(0), "ERC1155: target address must be non-zero");
506         require(
507             from == msg.sender || _operatorApprovals[from][msg.sender] == true,
508             "ERC1155: need operator approval for 3rd party transfers."
509         );
510 
511         _balances[id][from] = _balances[id][from].sub(value);
512         _balances[id][to] = value.add(_balances[id][to]);
513 
514         emit TransferSingle(msg.sender, from, to, id, value);
515 
516         _doSafeTransferAcceptanceCheck(msg.sender, from, to, id, value, data);
517     }
518 
519     /**
520         @dev Transfers `values` amount(s) of `ids` from the `from` address to the
521         `to` address specified. Caller must be approved to manage the tokens being
522         transferred out of the `from` account. If `to` is a smart contract, will
523         call `onERC1155BatchReceived` on `to` and act appropriately.
524         @param from Source address
525         @param to Target address
526         @param ids IDs of each token type
527         @param values Transfer amounts per token type
528         @param data Data forwarded to `onERC1155Received` if `to` is a contract receiver
529     */
530     function safeBatchTransferFrom(
531         address from,
532         address to,
533         uint256[] calldata ids,
534         uint256[] calldata values,
535         bytes calldata data
536     )
537         external
538     {
539         require(ids.length == values.length, "ERC1155: IDs and values must have same lengths");
540         require(to != address(0), "ERC1155: target address must be non-zero");
541         require(
542             from == msg.sender || _operatorApprovals[from][msg.sender] == true,
543             "ERC1155: need operator approval for 3rd party transfers."
544         );
545 
546         for (uint256 i = 0; i < ids.length; ++i) {
547             uint256 id = ids[i];
548             uint256 value = values[i];
549 
550             _balances[id][from] = _balances[id][from].sub(value);
551             _balances[id][to] = value.add(_balances[id][to]);
552         }
553 
554         emit TransferBatch(msg.sender, from, to, ids, values);
555 
556         _doSafeBatchTransferAcceptanceCheck(msg.sender, from, to, ids, values, data);
557     }
558 
559     /**
560      * @dev Internal function to mint an amount of a token with the given ID
561      * @param to The address that will own the minted token
562      * @param id ID of the token to be minted
563      * @param value Amount of the token to be minted
564      * @param data Data forwarded to `onERC1155Received` if `to` is a contract receiver
565      */
566     function _mint(address to, uint256 id, uint256 value, bytes memory data) internal {
567         require(to != address(0), "ERC1155: mint to the zero address");
568 
569         _balances[id][to] = value.add(_balances[id][to]);
570         emit TransferSingle(msg.sender, address(0), to, id, value);
571 
572         _doSafeTransferAcceptanceCheck(msg.sender, address(0), to, id, value, data);
573     }
574 
575     /**
576      * @dev Internal function to batch mint amounts of tokens with the given IDs
577      * @param to The address that will own the minted token
578      * @param ids IDs of the tokens to be minted
579      * @param values Amounts of the tokens to be minted
580      * @param data Data forwarded to `onERC1155Received` if `to` is a contract receiver
581      */
582     function _batchMint(address to, uint256[] memory ids, uint256[] memory values, bytes memory data) internal {
583         require(to != address(0), "ERC1155: batch mint to the zero address");
584         require(ids.length == values.length, "ERC1155: IDs and values must have same lengths");
585 
586         for(uint i = 0; i < ids.length; i++) {
587             _balances[ids[i]][to] = values[i].add(_balances[ids[i]][to]);
588         }
589 
590         emit TransferBatch(msg.sender, address(0), to, ids, values);
591 
592         _doSafeBatchTransferAcceptanceCheck(msg.sender, address(0), to, ids, values, data);
593     }
594 
595     /**
596      * @dev Internal function to burn an amount of a token with the given ID
597      * @param owner Account which owns the token to be burnt
598      * @param id ID of the token to be burnt
599      * @param value Amount of the token to be burnt
600      */
601     function _burn(address owner, uint256 id, uint256 value) internal {
602         _balances[id][owner] = _balances[id][owner].sub(value);
603         emit TransferSingle(msg.sender, owner, address(0), id, value);
604     }
605 
606     /**
607      * @dev Internal function to batch burn an amounts of tokens with the given IDs
608      * @param owner Account which owns the token to be burnt
609      * @param ids IDs of the tokens to be burnt
610      * @param values Amounts of the tokens to be burnt
611      */
612     function _batchBurn(address owner, uint256[] memory ids, uint256[] memory values) internal {
613         require(ids.length == values.length, "ERC1155: IDs and values must have same lengths");
614 
615         for(uint i = 0; i < ids.length; i++) {
616             _balances[ids[i]][owner] = _balances[ids[i]][owner].sub(values[i]);
617         }
618 
619         emit TransferBatch(msg.sender, owner, address(0), ids, values);
620     }
621 
622     function _doSafeTransferAcceptanceCheck(
623         address operator,
624         address from,
625         address to,
626         uint256 id,
627         uint256 value,
628         bytes memory data
629     )
630         internal
631     {
632         if(to.isContract()) {
633             require(
634                 IERC1155TokenReceiver(to).onERC1155Received(operator, from, id, value, data) ==
635                     IERC1155TokenReceiver(to).onERC1155Received.selector,
636                 "ERC1155: got unknown value from onERC1155Received"
637             );
638         }
639     }
640 
641     function _doSafeBatchTransferAcceptanceCheck(
642         address operator,
643         address from,
644         address to,
645         uint256[] memory ids,
646         uint256[] memory values,
647         bytes memory data
648     )
649         internal
650     {
651         if(to.isContract()) {
652             require(
653                 IERC1155TokenReceiver(to).onERC1155BatchReceived(operator, from, ids, values, data) == IERC1155TokenReceiver(to).onERC1155BatchReceived.selector,
654                 "ERC1155: got unknown value from onERC1155BatchReceived"
655             );
656         }
657     }
658 }
659 
660 // File: contracts/CTHelpers.sol
661 
662 pragma solidity ^0.5.1;
663 
664 
665 library CTHelpers {
666     /// @dev Constructs a condition ID from an oracle, a question ID, and the outcome slot count for the question.
667     /// @param oracle The account assigned to report the result for the prepared condition.
668     /// @param questionId An identifier for the question to be answered by the oracle.
669     /// @param outcomeSlotCount The number of outcome slots which should be used for this condition. Must not exceed 256.
670     function getConditionId(address oracle, bytes32 questionId, uint outcomeSlotCount) internal pure returns (bytes32) {
671         return keccak256(abi.encodePacked(oracle, questionId, outcomeSlotCount));
672     }
673 
674     uint constant P = 21888242871839275222246405745257275088696311157297823662689037894645226208583;
675     uint constant B = 3;
676 
677     function sqrt(uint x) private pure returns (uint y) {
678         uint p = P;
679         // solium-disable-next-line security/no-inline-assembly
680         assembly {
681             // add chain generated via https://crypto.stackexchange.com/q/27179/71252
682             // and transformed to the following program:
683 
684             // x=1; y=x+x; z=y+y; z=z+z; y=y+z; x=x+y; y=y+x; z=y+y; t=z+z; t=z+t; t=t+t;
685             // t=t+t; z=z+t; x=x+z; z=x+x; z=z+z; y=y+z; z=y+y; z=z+z; z=z+z; z=y+z; x=x+z;
686             // z=x+x; z=z+z; z=z+z; z=x+z; y=y+z; x=x+y; z=x+x; z=z+z; y=y+z; z=y+y; t=z+z;
687             // t=t+t; t=t+t; z=z+t; x=x+z; y=y+x; z=y+y; z=z+z; z=z+z; x=x+z; z=x+x; z=z+z;
688             // z=x+z; z=z+z; z=z+z; z=x+z; y=y+z; z=y+y; t=z+z; t=t+t; t=z+t; t=y+t; t=t+t;
689             // t=t+t; t=t+t; t=t+t; z=z+t; x=x+z; z=x+x; z=x+z; y=y+z; z=y+y; z=y+z; z=z+z;
690             // t=z+z; t=z+t; w=t+t; w=w+w; w=w+w; w=w+w; w=w+w; t=t+w; z=z+t; x=x+z; y=y+x;
691             // z=y+y; x=x+z; y=y+x; x=x+y; y=y+x; x=x+y; z=x+x; z=x+z; z=z+z; y=y+z; z=y+y;
692             // z=z+z; x=x+z; y=y+x; z=y+y; z=y+z; x=x+z; y=y+x; x=x+y; y=y+x; z=y+y; z=z+z;
693             // z=y+z; x=x+z; z=x+x; z=x+z; y=y+z; x=x+y; y=y+x; x=x+y; y=y+x; z=y+y; z=y+z;
694             // z=z+z; x=x+z; y=y+x; z=y+y; z=y+z; z=z+z; x=x+z; z=x+x; t=z+z; t=t+t; t=z+t;
695             // t=x+t; t=t+t; t=t+t; t=t+t; t=t+t; z=z+t; y=y+z; x=x+y; y=y+x; x=x+y; z=x+x;
696             // z=x+z; z=z+z; z=z+z; z=z+z; z=x+z; y=y+z; z=y+y; z=y+z; z=z+z; x=x+z; z=x+x;
697             // z=x+z; y=y+z; x=x+y; z=x+x; z=z+z; y=y+z; x=x+y; z=x+x; y=y+z; x=x+y; y=y+x;
698             // z=y+y; z=y+z; x=x+z; y=y+x; z=y+y; z=y+z; z=z+z; z=z+z; x=x+z; z=x+x; z=z+z;
699             // z=z+z; z=x+z; y=y+z; x=x+y; z=x+x; t=x+z; t=t+t; t=t+t; z=z+t; y=y+z; z=y+y;
700             // x=x+z; y=y+x; x=x+y; y=y+x; x=x+y; y=y+x; z=y+y; t=y+z; z=y+t; z=z+z; z=z+z;
701             // z=t+z; x=x+z; y=y+x; x=x+y; y=y+x; x=x+y; z=x+x; z=x+z; y=y+z; x=x+y; x=x+x;
702             // x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x;
703             // x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x;
704             // x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x;
705             // x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x;
706             // x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x;
707             // x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x;
708             // x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x;
709             // x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x;
710             // x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x;
711             // x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x;
712             // x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x; x=x+x;
713             // x=x+x; x=x+x; x=x+x; x=x+x; res=y+x
714             // res == (P + 1) // 4
715 
716             y := mulmod(x, x, p)
717             {
718                 let z := mulmod(y, y, p)
719                 z := mulmod(z, z, p)
720                 y := mulmod(y, z, p)
721                 x := mulmod(x, y, p)
722                 y := mulmod(y, x, p)
723                 z := mulmod(y, y, p)
724                 {
725                     let t := mulmod(z, z, p)
726                     t := mulmod(z, t, p)
727                     t := mulmod(t, t, p)
728                     t := mulmod(t, t, p)
729                     z := mulmod(z, t, p)
730                     x := mulmod(x, z, p)
731                     z := mulmod(x, x, p)
732                     z := mulmod(z, z, p)
733                     y := mulmod(y, z, p)
734                     z := mulmod(y, y, p)
735                     z := mulmod(z, z, p)
736                     z := mulmod(z, z, p)
737                     z := mulmod(y, z, p)
738                     x := mulmod(x, z, p)
739                     z := mulmod(x, x, p)
740                     z := mulmod(z, z, p)
741                     z := mulmod(z, z, p)
742                     z := mulmod(x, z, p)
743                     y := mulmod(y, z, p)
744                     x := mulmod(x, y, p)
745                     z := mulmod(x, x, p)
746                     z := mulmod(z, z, p)
747                     y := mulmod(y, z, p)
748                     z := mulmod(y, y, p)
749                     t := mulmod(z, z, p)
750                     t := mulmod(t, t, p)
751                     t := mulmod(t, t, p)
752                     z := mulmod(z, t, p)
753                     x := mulmod(x, z, p)
754                     y := mulmod(y, x, p)
755                     z := mulmod(y, y, p)
756                     z := mulmod(z, z, p)
757                     z := mulmod(z, z, p)
758                     x := mulmod(x, z, p)
759                     z := mulmod(x, x, p)
760                     z := mulmod(z, z, p)
761                     z := mulmod(x, z, p)
762                     z := mulmod(z, z, p)
763                     z := mulmod(z, z, p)
764                     z := mulmod(x, z, p)
765                     y := mulmod(y, z, p)
766                     z := mulmod(y, y, p)
767                     t := mulmod(z, z, p)
768                     t := mulmod(t, t, p)
769                     t := mulmod(z, t, p)
770                     t := mulmod(y, t, p)
771                     t := mulmod(t, t, p)
772                     t := mulmod(t, t, p)
773                     t := mulmod(t, t, p)
774                     t := mulmod(t, t, p)
775                     z := mulmod(z, t, p)
776                     x := mulmod(x, z, p)
777                     z := mulmod(x, x, p)
778                     z := mulmod(x, z, p)
779                     y := mulmod(y, z, p)
780                     z := mulmod(y, y, p)
781                     z := mulmod(y, z, p)
782                     z := mulmod(z, z, p)
783                     t := mulmod(z, z, p)
784                     t := mulmod(z, t, p)
785                     {
786                         let w := mulmod(t, t, p)
787                         w := mulmod(w, w, p)
788                         w := mulmod(w, w, p)
789                         w := mulmod(w, w, p)
790                         w := mulmod(w, w, p)
791                         t := mulmod(t, w, p)
792                     }
793                     z := mulmod(z, t, p)
794                     x := mulmod(x, z, p)
795                     y := mulmod(y, x, p)
796                     z := mulmod(y, y, p)
797                     x := mulmod(x, z, p)
798                     y := mulmod(y, x, p)
799                     x := mulmod(x, y, p)
800                     y := mulmod(y, x, p)
801                     x := mulmod(x, y, p)
802                     z := mulmod(x, x, p)
803                     z := mulmod(x, z, p)
804                     z := mulmod(z, z, p)
805                     y := mulmod(y, z, p)
806                     z := mulmod(y, y, p)
807                     z := mulmod(z, z, p)
808                     x := mulmod(x, z, p)
809                     y := mulmod(y, x, p)
810                     z := mulmod(y, y, p)
811                     z := mulmod(y, z, p)
812                     x := mulmod(x, z, p)
813                     y := mulmod(y, x, p)
814                     x := mulmod(x, y, p)
815                     y := mulmod(y, x, p)
816                     z := mulmod(y, y, p)
817                     z := mulmod(z, z, p)
818                     z := mulmod(y, z, p)
819                     x := mulmod(x, z, p)
820                     z := mulmod(x, x, p)
821                     z := mulmod(x, z, p)
822                     y := mulmod(y, z, p)
823                     x := mulmod(x, y, p)
824                     y := mulmod(y, x, p)
825                     x := mulmod(x, y, p)
826                     y := mulmod(y, x, p)
827                     z := mulmod(y, y, p)
828                     z := mulmod(y, z, p)
829                     z := mulmod(z, z, p)
830                     x := mulmod(x, z, p)
831                     y := mulmod(y, x, p)
832                     z := mulmod(y, y, p)
833                     z := mulmod(y, z, p)
834                     z := mulmod(z, z, p)
835                     x := mulmod(x, z, p)
836                     z := mulmod(x, x, p)
837                     t := mulmod(z, z, p)
838                     t := mulmod(t, t, p)
839                     t := mulmod(z, t, p)
840                     t := mulmod(x, t, p)
841                     t := mulmod(t, t, p)
842                     t := mulmod(t, t, p)
843                     t := mulmod(t, t, p)
844                     t := mulmod(t, t, p)
845                     z := mulmod(z, t, p)
846                     y := mulmod(y, z, p)
847                     x := mulmod(x, y, p)
848                     y := mulmod(y, x, p)
849                     x := mulmod(x, y, p)
850                     z := mulmod(x, x, p)
851                     z := mulmod(x, z, p)
852                     z := mulmod(z, z, p)
853                     z := mulmod(z, z, p)
854                     z := mulmod(z, z, p)
855                     z := mulmod(x, z, p)
856                     y := mulmod(y, z, p)
857                     z := mulmod(y, y, p)
858                     z := mulmod(y, z, p)
859                     z := mulmod(z, z, p)
860                     x := mulmod(x, z, p)
861                     z := mulmod(x, x, p)
862                     z := mulmod(x, z, p)
863                     y := mulmod(y, z, p)
864                     x := mulmod(x, y, p)
865                     z := mulmod(x, x, p)
866                     z := mulmod(z, z, p)
867                     y := mulmod(y, z, p)
868                     x := mulmod(x, y, p)
869                     z := mulmod(x, x, p)
870                     y := mulmod(y, z, p)
871                     x := mulmod(x, y, p)
872                     y := mulmod(y, x, p)
873                     z := mulmod(y, y, p)
874                     z := mulmod(y, z, p)
875                     x := mulmod(x, z, p)
876                     y := mulmod(y, x, p)
877                     z := mulmod(y, y, p)
878                     z := mulmod(y, z, p)
879                     z := mulmod(z, z, p)
880                     z := mulmod(z, z, p)
881                     x := mulmod(x, z, p)
882                     z := mulmod(x, x, p)
883                     z := mulmod(z, z, p)
884                     z := mulmod(z, z, p)
885                     z := mulmod(x, z, p)
886                     y := mulmod(y, z, p)
887                     x := mulmod(x, y, p)
888                     z := mulmod(x, x, p)
889                     t := mulmod(x, z, p)
890                     t := mulmod(t, t, p)
891                     t := mulmod(t, t, p)
892                     z := mulmod(z, t, p)
893                     y := mulmod(y, z, p)
894                     z := mulmod(y, y, p)
895                     x := mulmod(x, z, p)
896                     y := mulmod(y, x, p)
897                     x := mulmod(x, y, p)
898                     y := mulmod(y, x, p)
899                     x := mulmod(x, y, p)
900                     y := mulmod(y, x, p)
901                     z := mulmod(y, y, p)
902                     t := mulmod(y, z, p)
903                     z := mulmod(y, t, p)
904                     z := mulmod(z, z, p)
905                     z := mulmod(z, z, p)
906                     z := mulmod(t, z, p)
907                 }
908                 x := mulmod(x, z, p)
909                 y := mulmod(y, x, p)
910                 x := mulmod(x, y, p)
911                 y := mulmod(y, x, p)
912                 x := mulmod(x, y, p)
913                 z := mulmod(x, x, p)
914                 z := mulmod(x, z, p)
915                 y := mulmod(y, z, p)
916             }
917             x := mulmod(x, y, p)
918             x := mulmod(x, x, p)
919             x := mulmod(x, x, p)
920             x := mulmod(x, x, p)
921             x := mulmod(x, x, p)
922             x := mulmod(x, x, p)
923             x := mulmod(x, x, p)
924             x := mulmod(x, x, p)
925             x := mulmod(x, x, p)
926             x := mulmod(x, x, p)
927             x := mulmod(x, x, p)
928             x := mulmod(x, x, p)
929             x := mulmod(x, x, p)
930             x := mulmod(x, x, p)
931             x := mulmod(x, x, p)
932             x := mulmod(x, x, p)
933             x := mulmod(x, x, p)
934             x := mulmod(x, x, p)
935             x := mulmod(x, x, p)
936             x := mulmod(x, x, p)
937             x := mulmod(x, x, p)
938             x := mulmod(x, x, p)
939             x := mulmod(x, x, p)
940             x := mulmod(x, x, p)
941             x := mulmod(x, x, p)
942             x := mulmod(x, x, p)
943             x := mulmod(x, x, p)
944             x := mulmod(x, x, p)
945             x := mulmod(x, x, p)
946             x := mulmod(x, x, p)
947             x := mulmod(x, x, p)
948             x := mulmod(x, x, p)
949             x := mulmod(x, x, p)
950             x := mulmod(x, x, p)
951             x := mulmod(x, x, p)
952             x := mulmod(x, x, p)
953             x := mulmod(x, x, p)
954             x := mulmod(x, x, p)
955             x := mulmod(x, x, p)
956             x := mulmod(x, x, p)
957             x := mulmod(x, x, p)
958             x := mulmod(x, x, p)
959             x := mulmod(x, x, p)
960             x := mulmod(x, x, p)
961             x := mulmod(x, x, p)
962             x := mulmod(x, x, p)
963             x := mulmod(x, x, p)
964             x := mulmod(x, x, p)
965             x := mulmod(x, x, p)
966             x := mulmod(x, x, p)
967             x := mulmod(x, x, p)
968             x := mulmod(x, x, p)
969             x := mulmod(x, x, p)
970             x := mulmod(x, x, p)
971             x := mulmod(x, x, p)
972             x := mulmod(x, x, p)
973             x := mulmod(x, x, p)
974             x := mulmod(x, x, p)
975             x := mulmod(x, x, p)
976             x := mulmod(x, x, p)
977             x := mulmod(x, x, p)
978             x := mulmod(x, x, p)
979             x := mulmod(x, x, p)
980             x := mulmod(x, x, p)
981             x := mulmod(x, x, p)
982             x := mulmod(x, x, p)
983             x := mulmod(x, x, p)
984             x := mulmod(x, x, p)
985             x := mulmod(x, x, p)
986             x := mulmod(x, x, p)
987             x := mulmod(x, x, p)
988             x := mulmod(x, x, p)
989             x := mulmod(x, x, p)
990             x := mulmod(x, x, p)
991             x := mulmod(x, x, p)
992             x := mulmod(x, x, p)
993             x := mulmod(x, x, p)
994             x := mulmod(x, x, p)
995             x := mulmod(x, x, p)
996             x := mulmod(x, x, p)
997             x := mulmod(x, x, p)
998             x := mulmod(x, x, p)
999             x := mulmod(x, x, p)
1000             x := mulmod(x, x, p)
1001             x := mulmod(x, x, p)
1002             x := mulmod(x, x, p)
1003             x := mulmod(x, x, p)
1004             x := mulmod(x, x, p)
1005             x := mulmod(x, x, p)
1006             x := mulmod(x, x, p)
1007             x := mulmod(x, x, p)
1008             x := mulmod(x, x, p)
1009             x := mulmod(x, x, p)
1010             x := mulmod(x, x, p)
1011             x := mulmod(x, x, p)
1012             x := mulmod(x, x, p)
1013             x := mulmod(x, x, p)
1014             x := mulmod(x, x, p)
1015             x := mulmod(x, x, p)
1016             x := mulmod(x, x, p)
1017             x := mulmod(x, x, p)
1018             x := mulmod(x, x, p)
1019             x := mulmod(x, x, p)
1020             x := mulmod(x, x, p)
1021             x := mulmod(x, x, p)
1022             x := mulmod(x, x, p)
1023             x := mulmod(x, x, p)
1024             x := mulmod(x, x, p)
1025             x := mulmod(x, x, p)
1026             x := mulmod(x, x, p)
1027             x := mulmod(x, x, p)
1028             x := mulmod(x, x, p)
1029             x := mulmod(x, x, p)
1030             x := mulmod(x, x, p)
1031             x := mulmod(x, x, p)
1032             x := mulmod(x, x, p)
1033             x := mulmod(x, x, p)
1034             x := mulmod(x, x, p)
1035             x := mulmod(x, x, p)
1036             x := mulmod(x, x, p)
1037             x := mulmod(x, x, p)
1038             x := mulmod(x, x, p)
1039             x := mulmod(x, x, p)
1040             x := mulmod(x, x, p)
1041             x := mulmod(x, x, p)
1042             x := mulmod(x, x, p)
1043             x := mulmod(x, x, p)
1044             y := mulmod(y, x, p)
1045         }
1046     }
1047 
1048     /// @dev Constructs an outcome collection ID from a parent collection and an outcome collection.
1049     /// @param parentCollectionId Collection ID of the parent outcome collection, or bytes32(0) if there's no parent.
1050     /// @param conditionId Condition ID of the outcome collection to combine with the parent outcome collection.
1051     /// @param indexSet Index set of the outcome collection to combine with the parent outcome collection.
1052     function getCollectionId(bytes32 parentCollectionId, bytes32 conditionId, uint indexSet) internal view returns (bytes32) {
1053         uint x1 = uint(keccak256(abi.encodePacked(conditionId, indexSet)));
1054         bool odd = x1 >> 255 != 0;
1055         uint y1;
1056         uint yy;
1057         do {
1058             x1 = addmod(x1, 1, P);
1059             yy = addmod(mulmod(x1, mulmod(x1, x1, P), P), B, P);
1060             y1 = sqrt(yy);
1061         } while(mulmod(y1, y1, P) != yy);
1062         if(odd && y1 % 2 == 0 || !odd && y1 % 2 == 1)
1063             y1 = P - y1;
1064 
1065         uint x2 = uint(parentCollectionId);
1066         if(x2 != 0) {
1067             odd = x2 >> 254 != 0;
1068             x2 = (x2 << 2) >> 2;
1069             yy = addmod(mulmod(x2, mulmod(x2, x2, P), P), B, P);
1070             uint y2 = sqrt(yy);
1071             if(odd && y2 % 2 == 0 || !odd && y2 % 2 == 1)
1072                 y2 = P - y2;
1073             require(mulmod(y2, y2, P) == yy, "invalid parent collection ID");
1074 
1075             (bool success, bytes memory ret) = address(6).staticcall(abi.encode(x1, y1, x2, y2));
1076             require(success, "ecadd failed");
1077             (x1, y1) = abi.decode(ret, (uint, uint));
1078         }
1079 
1080         if(y1 % 2 == 1)
1081             x1 ^= 1 << 254;
1082 
1083         return bytes32(x1);
1084     }
1085 
1086     /// @dev Constructs a position ID from a collateral token and an outcome collection. These IDs are used as the ERC-1155 ID for this contract.
1087     /// @param collateralToken Collateral token which backs the position.
1088     /// @param collectionId ID of the outcome collection associated with this position.
1089     function getPositionId(IERC20 collateralToken, bytes32 collectionId) internal pure returns (uint) {
1090         return uint(keccak256(abi.encodePacked(collateralToken, collectionId)));
1091     }
1092 }
1093 
1094 // File: contracts/ConditionalTokens.sol
1095 
1096 pragma solidity ^0.5.1;
1097 
1098 
1099 
1100 
1101 contract ConditionalTokens is ERC1155 {
1102 
1103     /// @dev Emitted upon the successful preparation of a condition.
1104     /// @param conditionId The condition's ID. This ID may be derived from the other three parameters via ``keccak256(abi.encodePacked(oracle, questionId, outcomeSlotCount))``.
1105     /// @param oracle The account assigned to report the result for the prepared condition.
1106     /// @param questionId An identifier for the question to be answered by the oracle.
1107     /// @param outcomeSlotCount The number of outcome slots which should be used for this condition. Must not exceed 256.
1108     event ConditionPreparation(
1109         bytes32 indexed conditionId,
1110         address indexed oracle,
1111         bytes32 indexed questionId,
1112         uint outcomeSlotCount
1113     );
1114 
1115     event ConditionResolution(
1116         bytes32 indexed conditionId,
1117         address indexed oracle,
1118         bytes32 indexed questionId,
1119         uint outcomeSlotCount,
1120         uint[] payoutNumerators
1121     );
1122 
1123     /// @dev Emitted when a position is successfully split.
1124     event PositionSplit(
1125         address indexed stakeholder,
1126         IERC20 collateralToken,
1127         bytes32 indexed parentCollectionId,
1128         bytes32 indexed conditionId,
1129         uint[] partition,
1130         uint amount
1131     );
1132     /// @dev Emitted when positions are successfully merged.
1133     event PositionsMerge(
1134         address indexed stakeholder,
1135         IERC20 collateralToken,
1136         bytes32 indexed parentCollectionId,
1137         bytes32 indexed conditionId,
1138         uint[] partition,
1139         uint amount
1140     );
1141     event PayoutRedemption(
1142         address indexed redeemer,
1143         IERC20 indexed collateralToken,
1144         bytes32 indexed parentCollectionId,
1145         bytes32 conditionId,
1146         uint[] indexSets,
1147         uint payout
1148     );
1149 
1150 
1151     /// Mapping key is an condition ID. Value represents numerators of the payout vector associated with the condition. This array is initialized with a length equal to the outcome slot count. E.g. Condition with 3 outcomes [A, B, C] and two of those correct [0.5, 0.5, 0]. In Ethereum there are no decimal values, so here, 0.5 is represented by fractions like 1/2 == 0.5. That's why we need numerator and denominator values. Payout numerators are also used as a check of initialization. If the numerators array is empty (has length zero), the condition was not created/prepared. See getOutcomeSlotCount.
1152     mapping(bytes32 => uint[]) public payoutNumerators;
1153     /// Denominator is also used for checking if the condition has been resolved. If the denominator is non-zero, then the condition has been resolved.
1154     mapping(bytes32 => uint) public payoutDenominator;
1155 
1156     /// @dev This function prepares a condition by initializing a payout vector associated with the condition.
1157     /// @param oracle The account assigned to report the result for the prepared condition.
1158     /// @param questionId An identifier for the question to be answered by the oracle.
1159     /// @param outcomeSlotCount The number of outcome slots which should be used for this condition. Must not exceed 256.
1160     function prepareCondition(address oracle, bytes32 questionId, uint outcomeSlotCount) external {
1161         // Limit of 256 because we use a partition array that is a number of 256 bits.
1162         require(outcomeSlotCount <= 256, "too many outcome slots");
1163         require(outcomeSlotCount > 1, "there should be more than one outcome slot");
1164         bytes32 conditionId = CTHelpers.getConditionId(oracle, questionId, outcomeSlotCount);
1165         require(payoutNumerators[conditionId].length == 0, "condition already prepared");
1166         payoutNumerators[conditionId] = new uint[](outcomeSlotCount);
1167         emit ConditionPreparation(conditionId, oracle, questionId, outcomeSlotCount);
1168     }
1169 
1170     /// @dev Called by the oracle for reporting results of conditions. Will set the payout vector for the condition with the ID ``keccak256(abi.encodePacked(oracle, questionId, outcomeSlotCount))``, where oracle is the message sender, questionId is one of the parameters of this function, and outcomeSlotCount is the length of the payouts parameter, which contains the payoutNumerators for each outcome slot of the condition.
1171     /// @param questionId The question ID the oracle is answering for
1172     /// @param payouts The oracle's answer
1173     function reportPayouts(bytes32 questionId, uint[] calldata payouts) external {
1174         uint outcomeSlotCount = payouts.length;
1175         require(outcomeSlotCount > 1, "there should be more than one outcome slot");
1176         // IMPORTANT, the oracle is enforced to be the sender because it's part of the hash.
1177         bytes32 conditionId = CTHelpers.getConditionId(msg.sender, questionId, outcomeSlotCount);
1178         require(payoutNumerators[conditionId].length == outcomeSlotCount, "condition not prepared or found");
1179         require(payoutDenominator[conditionId] == 0, "payout denominator already set");
1180 
1181         uint den = 0;
1182         for (uint i = 0; i < outcomeSlotCount; i++) {
1183             uint num = payouts[i];
1184             den = den.add(num);
1185 
1186             require(payoutNumerators[conditionId][i] == 0, "payout numerator already set");
1187             payoutNumerators[conditionId][i] = num;
1188         }
1189         require(den > 0, "payout is all zeroes");
1190         payoutDenominator[conditionId] = den;
1191         emit ConditionResolution(conditionId, msg.sender, questionId, outcomeSlotCount, payoutNumerators[conditionId]);
1192     }
1193 
1194     /// @dev This function splits a position. If splitting from the collateral, this contract will attempt to transfer `amount` collateral from the message sender to itself. Otherwise, this contract will burn `amount` stake held by the message sender in the position being split worth of EIP 1155 tokens. Regardless, if successful, `amount` stake will be minted in the split target positions. If any of the transfers, mints, or burns fail, the transaction will revert. The transaction will also revert if the given partition is trivial, invalid, or refers to more slots than the condition is prepared with.
1195     /// @param collateralToken The address of the positions' backing collateral token.
1196     /// @param parentCollectionId The ID of the outcome collections common to the position being split and the split target positions. May be null, in which only the collateral is shared.
1197     /// @param conditionId The ID of the condition to split on.
1198     /// @param partition An array of disjoint index sets representing a nontrivial partition of the outcome slots of the given condition. E.g. A|B and C but not A|B and B|C (is not disjoint). Each element's a number which, together with the condition, represents the outcome collection. E.g. 0b110 is A|B, 0b010 is B, etc.
1199     /// @param amount The amount of collateral or stake to split.
1200     function splitPosition(
1201         IERC20 collateralToken,
1202         bytes32 parentCollectionId,
1203         bytes32 conditionId,
1204         uint[] calldata partition,
1205         uint amount
1206     ) external {
1207         require(partition.length > 1, "got empty or singleton partition");
1208         uint outcomeSlotCount = payoutNumerators[conditionId].length;
1209         require(outcomeSlotCount > 0, "condition not prepared yet");
1210 
1211         // For a condition with 4 outcomes fullIndexSet's 0b1111; for 5 it's 0b11111...
1212         uint fullIndexSet = (1 << outcomeSlotCount) - 1;
1213         // freeIndexSet starts as the full collection
1214         uint freeIndexSet = fullIndexSet;
1215         // This loop checks that all condition sets are disjoint (the same outcome is not part of more than 1 set)
1216         uint[] memory positionIds = new uint[](partition.length);
1217         uint[] memory amounts = new uint[](partition.length);
1218         for (uint i = 0; i < partition.length; i++) {
1219             uint indexSet = partition[i];
1220             require(indexSet > 0 && indexSet < fullIndexSet, "got invalid index set");
1221             require((indexSet & freeIndexSet) == indexSet, "partition not disjoint");
1222             freeIndexSet ^= indexSet;
1223             positionIds[i] = CTHelpers.getPositionId(collateralToken, CTHelpers.getCollectionId(parentCollectionId, conditionId, indexSet));
1224             amounts[i] = amount;
1225         }
1226 
1227         if (freeIndexSet == 0) {
1228             // Partitioning the full set of outcomes for the condition in this branch
1229             if (parentCollectionId == bytes32(0)) {
1230                 require(collateralToken.transferFrom(msg.sender, address(this), amount), "could not receive collateral tokens");
1231             } else {
1232                 _burn(
1233                     msg.sender,
1234                     CTHelpers.getPositionId(collateralToken, parentCollectionId),
1235                     amount
1236                 );
1237             }
1238         } else {
1239             // Partitioning a subset of outcomes for the condition in this branch.
1240             // For example, for a condition with three outcomes A, B, and C, this branch
1241             // allows the splitting of a position $:(A|C) to positions $:(A) and $:(C).
1242             _burn(
1243                 msg.sender,
1244                 CTHelpers.getPositionId(collateralToken,
1245                     CTHelpers.getCollectionId(parentCollectionId, conditionId, fullIndexSet ^ freeIndexSet)),
1246                 amount
1247             );
1248         }
1249 
1250         _batchMint(
1251             msg.sender,
1252             // position ID is the ERC 1155 token ID
1253             positionIds,
1254             amounts,
1255             ""
1256         );
1257         emit PositionSplit(msg.sender, collateralToken, parentCollectionId, conditionId, partition, amount);
1258     }
1259 
1260     function mergePositions(
1261         IERC20 collateralToken,
1262         bytes32 parentCollectionId,
1263         bytes32 conditionId,
1264         uint[] calldata partition,
1265         uint amount
1266     ) external {
1267         require(partition.length > 1, "got empty or singleton partition");
1268         uint outcomeSlotCount = payoutNumerators[conditionId].length;
1269         require(outcomeSlotCount > 0, "condition not prepared yet");
1270 
1271         uint fullIndexSet = (1 << outcomeSlotCount) - 1;
1272         uint freeIndexSet = fullIndexSet;
1273         uint[] memory positionIds = new uint[](partition.length);
1274         uint[] memory amounts = new uint[](partition.length);
1275         for (uint i = 0; i < partition.length; i++) {
1276             uint indexSet = partition[i];
1277             require(indexSet > 0 && indexSet < fullIndexSet, "got invalid index set");
1278             require((indexSet & freeIndexSet) == indexSet, "partition not disjoint");
1279             freeIndexSet ^= indexSet;
1280             positionIds[i] = CTHelpers.getPositionId(collateralToken, CTHelpers.getCollectionId(parentCollectionId, conditionId, indexSet));
1281             amounts[i] = amount;
1282         }
1283         _batchBurn(
1284             msg.sender,
1285             positionIds,
1286             amounts
1287         );
1288 
1289         if (freeIndexSet == 0) {
1290             if (parentCollectionId == bytes32(0)) {
1291                 require(collateralToken.transfer(msg.sender, amount), "could not send collateral tokens");
1292             } else {
1293                 _mint(
1294                     msg.sender,
1295                     CTHelpers.getPositionId(collateralToken, parentCollectionId),
1296                     amount,
1297                     ""
1298                 );
1299             }
1300         } else {
1301             _mint(
1302                 msg.sender,
1303                 CTHelpers.getPositionId(collateralToken,
1304                     CTHelpers.getCollectionId(parentCollectionId, conditionId, fullIndexSet ^ freeIndexSet)),
1305                 amount,
1306                 ""
1307             );
1308         }
1309 
1310         emit PositionsMerge(msg.sender, collateralToken, parentCollectionId, conditionId, partition, amount);
1311     }
1312 
1313     function redeemPositions(IERC20 collateralToken, bytes32 parentCollectionId, bytes32 conditionId, uint[] calldata indexSets) external {
1314         uint den = payoutDenominator[conditionId];
1315         require(den > 0, "result for condition not received yet");
1316         uint outcomeSlotCount = payoutNumerators[conditionId].length;
1317         require(outcomeSlotCount > 0, "condition not prepared yet");
1318 
1319         uint totalPayout = 0;
1320 
1321         uint fullIndexSet = (1 << outcomeSlotCount) - 1;
1322         for (uint i = 0; i < indexSets.length; i++) {
1323             uint indexSet = indexSets[i];
1324             require(indexSet > 0 && indexSet < fullIndexSet, "got invalid index set");
1325             uint positionId = CTHelpers.getPositionId(collateralToken,
1326                 CTHelpers.getCollectionId(parentCollectionId, conditionId, indexSet));
1327 
1328             uint payoutNumerator = 0;
1329             for (uint j = 0; j < outcomeSlotCount; j++) {
1330                 if (indexSet & (1 << j) != 0) {
1331                     payoutNumerator = payoutNumerator.add(payoutNumerators[conditionId][j]);
1332                 }
1333             }
1334 
1335             uint payoutStake = balanceOf(msg.sender, positionId);
1336             if (payoutStake > 0) {
1337                 totalPayout = totalPayout.add(payoutStake.mul(payoutNumerator).div(den));
1338                 _burn(msg.sender, positionId, payoutStake);
1339             }
1340         }
1341 
1342         if (totalPayout > 0) {
1343             if (parentCollectionId == bytes32(0)) {
1344                 require(collateralToken.transfer(msg.sender, totalPayout), "could not transfer payout to message sender");
1345             } else {
1346                 _mint(msg.sender, CTHelpers.getPositionId(collateralToken, parentCollectionId), totalPayout, "");
1347             }
1348         }
1349         emit PayoutRedemption(msg.sender, collateralToken, parentCollectionId, conditionId, indexSets, totalPayout);
1350     }
1351 
1352     /// @dev Gets the outcome slot count of a condition.
1353     /// @param conditionId ID of the condition.
1354     /// @return Number of outcome slots associated with a condition, or zero if condition has not been prepared yet.
1355     function getOutcomeSlotCount(bytes32 conditionId) external view returns (uint) {
1356         return payoutNumerators[conditionId].length;
1357     }
1358 
1359     /// @dev Constructs a condition ID from an oracle, a question ID, and the outcome slot count for the question.
1360     /// @param oracle The account assigned to report the result for the prepared condition.
1361     /// @param questionId An identifier for the question to be answered by the oracle.
1362     /// @param outcomeSlotCount The number of outcome slots which should be used for this condition. Must not exceed 256.
1363     function getConditionId(address oracle, bytes32 questionId, uint outcomeSlotCount) external pure returns (bytes32) {
1364         return CTHelpers.getConditionId(oracle, questionId, outcomeSlotCount);
1365     }
1366 
1367     /// @dev Constructs an outcome collection ID from a parent collection and an outcome collection.
1368     /// @param parentCollectionId Collection ID of the parent outcome collection, or bytes32(0) if there's no parent.
1369     /// @param conditionId Condition ID of the outcome collection to combine with the parent outcome collection.
1370     /// @param indexSet Index set of the outcome collection to combine with the parent outcome collection.
1371     function getCollectionId(bytes32 parentCollectionId, bytes32 conditionId, uint indexSet) external view returns (bytes32) {
1372         return CTHelpers.getCollectionId(parentCollectionId, conditionId, indexSet);
1373     }
1374 
1375     /// @dev Constructs a position ID from a collateral token and an outcome collection. These IDs are used as the ERC-1155 ID for this contract.
1376     /// @param collateralToken Collateral token which backs the position.
1377     /// @param collectionId ID of the outcome collection associated with this position.
1378     function getPositionId(IERC20 collateralToken, bytes32 collectionId) external pure returns (uint) {
1379         return CTHelpers.getPositionId(collateralToken, collectionId);
1380     }
1381 }