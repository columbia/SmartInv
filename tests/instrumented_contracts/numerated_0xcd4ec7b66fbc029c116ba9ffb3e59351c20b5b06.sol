1 pragma solidity ^0.5.0;
2 pragma experimental ABIEncoderV2;
3 
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, reverting on
21      * overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      * - Addition cannot overflow.
27      */
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31 
32         return c;
33     }
34 
35     /**
36      * @dev Returns the subtraction of two unsigned integers, reverting on
37      * overflow (when the result is negative).
38      *
39      * Counterpart to Solidity's `-` operator.
40      *
41      * Requirements:
42      * - Subtraction cannot overflow.
43      */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         return sub(a, b, "SafeMath: subtraction overflow");
46     }
47 
48     /**
49      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
50      * overflow (when the result is negative).
51      *
52      * Counterpart to Solidity's `-` operator.
53      *
54      * Requirements:
55      * - Subtraction cannot overflow.
56      *
57      * _Available since v2.4.0._
58      */
59     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
60         require(b <= a, errorMessage);
61         uint256 c = a - b;
62 
63         return c;
64     }
65 
66     /**
67      * @dev Returns the multiplication of two unsigned integers, reverting on
68      * overflow.
69      *
70      * Counterpart to Solidity's `*` operator.
71      *
72      * Requirements:
73      * - Multiplication cannot overflow.
74      */
75     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
76         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
77         // benefit is lost if 'b' is also tested.
78         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
79         if (a == 0) {
80             return 0;
81         }
82 
83         uint256 c = a * b;
84         require(c / a == b, "SafeMath: multiplication overflow");
85 
86         return c;
87     }
88 
89     /**
90      * @dev Returns the integer division of two unsigned integers. Reverts on
91      * division by zero. The result is rounded towards zero.
92      *
93      * Counterpart to Solidity's `/` operator. Note: this function uses a
94      * `revert` opcode (which leaves remaining gas untouched) while Solidity
95      * uses an invalid opcode to revert (consuming all remaining gas).
96      *
97      * Requirements:
98      * - The divisor cannot be zero.
99      */
100     function div(uint256 a, uint256 b) internal pure returns (uint256) {
101         return div(a, b, "SafeMath: division by zero");
102     }
103 
104     /**
105      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
106      * division by zero. The result is rounded towards zero.
107      *
108      * Counterpart to Solidity's `/` operator. Note: this function uses a
109      * `revert` opcode (which leaves remaining gas untouched) while Solidity
110      * uses an invalid opcode to revert (consuming all remaining gas).
111      *
112      * Requirements:
113      * - The divisor cannot be zero.
114      *
115      * _Available since v2.4.0._
116      */
117     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
118         // Solidity only automatically asserts when dividing by 0
119         require(b > 0, errorMessage);
120         uint256 c = a / b;
121         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
122 
123         return c;
124     }
125 
126     /**
127      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
128      * Reverts when dividing by zero.
129      *
130      * Counterpart to Solidity's `%` operator. This function uses a `revert`
131      * opcode (which leaves remaining gas untouched) while Solidity uses an
132      * invalid opcode to revert (consuming all remaining gas).
133      *
134      * Requirements:
135      * - The divisor cannot be zero.
136      */
137     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
138         return mod(a, b, "SafeMath: modulo by zero");
139     }
140 
141     /**
142      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
143      * Reverts with custom message when dividing by zero.
144      *
145      * Counterpart to Solidity's `%` operator. This function uses a `revert`
146      * opcode (which leaves remaining gas untouched) while Solidity uses an
147      * invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      * - The divisor cannot be zero.
151      *
152      * _Available since v2.4.0._
153      */
154     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
155         require(b != 0, errorMessage);
156         return a % b;
157     }
158 }
159 
160 /**
161  * @dev Interface of the ERC165 standard, as defined in the
162  * https://eips.ethereum.org/EIPS/eip-165[EIP].
163  *
164  * Implementers can declare support of contract interfaces, which can then be
165  * queried by others ({ERC165Checker}).
166  *
167  * For an implementation, see {ERC165}.
168  */
169 interface IERC165 {
170     /**
171      * @dev Returns true if this contract implements the interface defined by
172      * `interfaceId`. See the corresponding
173      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
174      * to learn more about how these ids are created.
175      *
176      * This function call must use less than 30 000 gas.
177      */
178     function supportsInterface(bytes4 interfaceId) external view returns (bool);
179 }
180 
181 /**
182  * @dev Required interface of an ERC721 compliant contract.
183  */
184 contract IERC721 is IERC165 {
185     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
186     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
187     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
188 
189     /**
190      * @dev Returns the number of NFTs in `owner`'s account.
191      */
192     function balanceOf(address owner) public view returns (uint256 balance);
193 
194     /**
195      * @dev Returns the owner of the NFT specified by `tokenId`.
196      */
197     function ownerOf(uint256 tokenId) public view returns (address owner);
198 
199     /**
200      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
201      * another (`to`).
202      *
203      *
204      *
205      * Requirements:
206      * - `from`, `to` cannot be zero.
207      * - `tokenId` must be owned by `from`.
208      * - If the caller is not `from`, it must be have been allowed to move this
209      * NFT by either {approve} or {setApprovalForAll}.
210      */
211     function safeTransferFrom(address from, address to, uint256 tokenId) public;
212     /**
213      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
214      * another (`to`).
215      *
216      * Requirements:
217      * - If the caller is not `from`, it must be approved to move this NFT by
218      * either {approve} or {setApprovalForAll}.
219      */
220     function transferFrom(address from, address to, uint256 tokenId) public;
221     function approve(address to, uint256 tokenId) public;
222     function getApproved(uint256 tokenId) public view returns (address operator);
223 
224     function setApprovalForAll(address operator, bool _approved) public;
225     function isApprovedForAll(address owner, address operator) public view returns (bool);
226 
227 
228     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
229 }
230 
231 /*
232  * @dev Provides information about the current execution context, including the
233  * sender of the transaction and its data. While these are generally available
234  * via msg.sender and msg.data, they should not be accessed in such a direct
235  * manner, since when dealing with GSN meta-transactions the account sending and
236  * paying for execution may not be the actual sender (as far as an application
237  * is concerned).
238  *
239  * This contract is only required for intermediate, library-like contracts.
240  */
241 contract Context {
242     // Empty internal constructor, to prevent people from mistakenly deploying
243     // an instance of this contract, which should be used via inheritance.
244     constructor () internal { }
245     // solhint-disable-previous-line no-empty-blocks
246 
247     function _msgSender() internal view returns (address payable) {
248         return msg.sender;
249     }
250 
251     function _msgData() internal view returns (bytes memory) {
252         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
253         return msg.data;
254     }
255 }
256 
257 /**
258  * @title Roles
259  * @dev Library for managing addresses assigned to a Role.
260  */
261 library Roles {
262     struct Role {
263         mapping (address => bool) bearer;
264     }
265 
266     /**
267      * @dev Give an account access to this role.
268      */
269     function add(Role storage role, address account) internal {
270         require(!has(role, account), "Roles: account already has role");
271         role.bearer[account] = true;
272     }
273 
274     /**
275      * @dev Remove an account's access to this role.
276      */
277     function remove(Role storage role, address account) internal {
278         require(has(role, account), "Roles: account does not have role");
279         role.bearer[account] = false;
280     }
281 
282     /**
283      * @dev Check if an account has this role.
284      * @return bool
285      */
286     function has(Role storage role, address account) internal view returns (bool) {
287         require(account != address(0), "Roles: account is the zero address");
288         return role.bearer[account];
289     }
290 }
291 
292 contract OperatorRole is Context {
293     using Roles for Roles.Role;
294 
295     event OperatorAdded(address indexed account);
296     event OperatorRemoved(address indexed account);
297 
298     Roles.Role private _operators;
299 
300     constructor () internal {
301 
302     }
303 
304     modifier onlyOperator() {
305         require(isOperator(_msgSender()), "OperatorRole: caller does not have the Operator role");
306         _;
307     }
308 
309     function isOperator(address account) public view returns (bool) {
310         return _operators.has(account);
311     }
312 
313     function _addOperator(address account) internal {
314         _operators.add(account);
315         emit OperatorAdded(account);
316     }
317 
318     function _removeOperator(address account) internal {
319         _operators.remove(account);
320         emit OperatorRemoved(account);
321     }
322 }
323 
324 /**
325  * @dev Contract module which provides a basic access control mechanism, where
326  * there is an account (an owner) that can be granted exclusive access to
327  * specific functions.
328  *
329  * This module is used through inheritance. It will make available the modifier
330  * `onlyOwner`, which can be applied to your functions to restrict their use to
331  * the owner.
332  */
333 contract Ownable is Context {
334     address private _owner;
335 
336     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
337 
338     /**
339      * @dev Initializes the contract setting the deployer as the initial owner.
340      */
341     constructor () internal {
342         address msgSender = _msgSender();
343         _owner = msgSender;
344         emit OwnershipTransferred(address(0), msgSender);
345     }
346 
347     /**
348      * @dev Returns the address of the current owner.
349      */
350     function owner() public view returns (address) {
351         return _owner;
352     }
353 
354     /**
355      * @dev Throws if called by any account other than the owner.
356      */
357     modifier onlyOwner() {
358         require(isOwner(), "Ownable: caller is not the owner");
359         _;
360     }
361 
362     /**
363      * @dev Returns true if the caller is the current owner.
364      */
365     function isOwner() public view returns (bool) {
366         return _msgSender() == _owner;
367     }
368 
369     /**
370      * @dev Leaves the contract without owner. It will not be possible to call
371      * `onlyOwner` functions anymore. Can only be called by the current owner.
372      *
373      * NOTE: Renouncing ownership will leave the contract without an owner,
374      * thereby removing any functionality that is only available to the owner.
375      */
376     function renounceOwnership() public onlyOwner {
377         emit OwnershipTransferred(_owner, address(0));
378         _owner = address(0);
379     }
380 
381     /**
382      * @dev Transfers ownership of the contract to a new account (`newOwner`).
383      * Can only be called by the current owner.
384      */
385     function transferOwnership(address newOwner) public onlyOwner {
386         _transferOwnership(newOwner);
387     }
388 
389     /**
390      * @dev Transfers ownership of the contract to a new account (`newOwner`).
391      */
392     function _transferOwnership(address newOwner) internal {
393         require(newOwner != address(0), "Ownable: new owner is the zero address");
394         emit OwnershipTransferred(_owner, newOwner);
395         _owner = newOwner;
396     }
397 }
398 
399 contract OwnableOperatorRole is Ownable, OperatorRole {
400     function addOperator(address account) external onlyOwner {
401         _addOperator(account);
402     }
403 
404     function removeOperator(address account) external onlyOwner {
405         _removeOperator(account);
406     }
407 }
408 
409 /**
410     @title ERC-1155 Multi Token Standard
411     @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-1155.md
412     Note: The ERC-165 identifier for this interface is 0xd9b67a26.
413  */
414 contract IERC1155 is IERC165 {
415     /**
416         @dev Either `TransferSingle` or `TransferBatch` MUST emit when tokens are transferred, including zero value transfers as well as minting or burning (see "Safe Transfer Rules" section of the standard).
417         The `_operator` argument MUST be msg.sender.
418         The `_from` argument MUST be the address of the holder whose balance is decreased.
419         The `_to` argument MUST be the address of the recipient whose balance is increased.
420         The `_id` argument MUST be the token type being transferred.
421         The `_value` argument MUST be the number of tokens the holder balance is decreased by and match what the recipient balance is increased by.
422         When minting/creating tokens, the `_from` argument MUST be set to `0x0` (i.e. zero address).
423         When burning/destroying tokens, the `_to` argument MUST be set to `0x0` (i.e. zero address).
424     */
425     event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _value);
426 
427     /**
428         @dev Either `TransferSingle` or `TransferBatch` MUST emit when tokens are transferred, including zero value transfers as well as minting or burning (see "Safe Transfer Rules" section of the standard).
429         The `_operator` argument MUST be msg.sender.
430         The `_from` argument MUST be the address of the holder whose balance is decreased.
431         The `_to` argument MUST be the address of the recipient whose balance is increased.
432         The `_ids` argument MUST be the list of tokens being transferred.
433         The `_values` argument MUST be the list of number of tokens (matching the list and order of tokens specified in _ids) the holder balance is decreased by and match what the recipient balance is increased by.
434         When minting/creating tokens, the `_from` argument MUST be set to `0x0` (i.e. zero address).
435         When burning/destroying tokens, the `_to` argument MUST be set to `0x0` (i.e. zero address).
436     */
437     event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _values);
438 
439     /**
440         @dev MUST emit when approval for a second party/operator address to manage all tokens for an owner address is enabled or disabled (absense of an event assumes disabled).
441     */
442     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
443 
444     /**
445         @dev MUST emit when the URI is updated for a token ID.
446         URIs are defined in RFC 3986.
447         The URI MUST point a JSON file that conforms to the "ERC-1155 Metadata URI JSON Schema".
448     */
449     event URI(string _value, uint256 indexed _id);
450 
451     /**
452         @notice Transfers `_value` amount of an `_id` from the `_from` address to the `_to` address specified (with safety call).
453         @dev Caller must be approved to manage the tokens being transferred out of the `_from` account (see "Approval" section of the standard).
454         MUST revert if `_to` is the zero address.
455         MUST revert if balance of holder for token `_id` is lower than the `_value` sent.
456         MUST revert on any other error.
457         MUST emit the `TransferSingle` event to reflect the balance change (see "Safe Transfer Rules" section of the standard).
458         After the above conditions are met, this function MUST check if `_to` is a smart contract (e.g. code size > 0). If so, it MUST call `onERC1155Received` on `_to` and act appropriately (see "Safe Transfer Rules" section of the standard).
459         @param _from    Source address
460         @param _to      Target address
461         @param _id      ID of the token type
462         @param _value   Transfer amount
463         @param _data    Additional data with no specified format, MUST be sent unaltered in call to `onERC1155Received` on `_to`
464     */
465     function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _value, bytes calldata _data) external;
466 
467     /**
468         @notice Transfers `_values` amount(s) of `_ids` from the `_from` address to the `_to` address specified (with safety call).
469         @dev Caller must be approved to manage the tokens being transferred out of the `_from` account (see "Approval" section of the standard).
470         MUST revert if `_to` is the zero address.
471         MUST revert if length of `_ids` is not the same as length of `_values`.
472         MUST revert if any of the balance(s) of the holder(s) for token(s) in `_ids` is lower than the respective amount(s) in `_values` sent to the recipient.
473         MUST revert on any other error.
474         MUST emit `TransferSingle` or `TransferBatch` event(s) such that all the balance changes are reflected (see "Safe Transfer Rules" section of the standard).
475         Balance changes and events MUST follow the ordering of the arrays (_ids[0]/_values[0] before _ids[1]/_values[1], etc).
476         After the above conditions for the transfer(s) in the batch are met, this function MUST check if `_to` is a smart contract (e.g. code size > 0). If so, it MUST call the relevant `ERC1155TokenReceiver` hook(s) on `_to` and act appropriately (see "Safe Transfer Rules" section of the standard).
477         @param _from    Source address
478         @param _to      Target address
479         @param _ids     IDs of each token type (order and length must match _values array)
480         @param _values  Transfer amounts per token type (order and length must match _ids array)
481         @param _data    Additional data with no specified format, MUST be sent unaltered in call to the `ERC1155TokenReceiver` hook(s) on `_to`
482     */
483     function safeBatchTransferFrom(address _from, address _to, uint256[] calldata _ids, uint256[] calldata _values, bytes calldata _data) external;
484 
485     /**
486         @notice Get the balance of an account's Tokens.
487         @param _owner  The address of the token holder
488         @param _id     ID of the Token
489         @return        The _owner's balance of the Token type requested
490      */
491     function balanceOf(address _owner, uint256 _id) external view returns (uint256);
492 
493     /**
494         @notice Get the balance of multiple account/token pairs
495         @param _owners The addresses of the token holders
496         @param _ids    ID of the Tokens
497         @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)
498      */
499     function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids) external view returns (uint256[] memory);
500 
501     /**
502         @notice Enable or disable approval for a third party ("operator") to manage all of the caller's tokens.
503         @dev MUST emit the ApprovalForAll event on success.
504         @param _operator  Address to add to the set of authorized operators
505         @param _approved  True if the operator is approved, false to revoke approval
506     */
507     function setApprovalForAll(address _operator, bool _approved) external;
508 
509     /**
510         @notice Queries the approval status of an operator for a given owner.
511         @param _owner     The owner of the Tokens
512         @param _operator  Address of authorized operator
513         @return           True if the operator is approved, false if not
514     */
515     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
516 }
517 
518 contract TransferProxy is OwnableOperatorRole {
519 
520     function erc721safeTransferFrom(IERC721 token, address from, address to, uint256 tokenId) external onlyOperator {
521         token.safeTransferFrom(from, to, tokenId);
522     }
523 
524     function erc1155safeTransferFrom(IERC1155 token, address from, address to, uint256 id, uint256 value, bytes calldata data) external onlyOperator {
525         token.safeTransferFrom(from, to, id, value, data);
526     }
527 }
528 
529 contract TransferProxyForDeprecated is OwnableOperatorRole {
530 
531     function erc721TransferFrom(IERC721 token, address from, address to, uint256 tokenId) external onlyOperator {
532         token.transferFrom(from, to, tokenId);
533     }
534 }
535 
536 /**
537  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
538  * the optional functions; to access them see {ERC20Detailed}.
539  */
540 interface IERC20 {
541     /**
542      * @dev Returns the amount of tokens in existence.
543      */
544     function totalSupply() external view returns (uint256);
545 
546     /**
547      * @dev Returns the amount of tokens owned by `account`.
548      */
549     function balanceOf(address account) external view returns (uint256);
550 
551     /**
552      * @dev Moves `amount` tokens from the caller's account to `recipient`.
553      *
554      * Returns a boolean value indicating whether the operation succeeded.
555      *
556      * Emits a {Transfer} event.
557      */
558     function transfer(address recipient, uint256 amount) external returns (bool);
559 
560     /**
561      * @dev Returns the remaining number of tokens that `spender` will be
562      * allowed to spend on behalf of `owner` through {transferFrom}. This is
563      * zero by default.
564      *
565      * This value changes when {approve} or {transferFrom} are called.
566      */
567     function allowance(address owner, address spender) external view returns (uint256);
568 
569     /**
570      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
571      *
572      * Returns a boolean value indicating whether the operation succeeded.
573      *
574      * IMPORTANT: Beware that changing an allowance with this method brings the risk
575      * that someone may use both the old and the new allowance by unfortunate
576      * transaction ordering. One possible solution to mitigate this race
577      * condition is to first reduce the spender's allowance to 0 and set the
578      * desired value afterwards:
579      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
580      *
581      * Emits an {Approval} event.
582      */
583     function approve(address spender, uint256 amount) external returns (bool);
584 
585     /**
586      * @dev Moves `amount` tokens from `sender` to `recipient` using the
587      * allowance mechanism. `amount` is then deducted from the caller's
588      * allowance.
589      *
590      * Returns a boolean value indicating whether the operation succeeded.
591      *
592      * Emits a {Transfer} event.
593      */
594     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
595 
596     /**
597      * @dev Emitted when `value` tokens are moved from one account (`from`) to
598      * another (`to`).
599      *
600      * Note that `value` may be zero.
601      */
602     event Transfer(address indexed from, address indexed to, uint256 value);
603 
604     /**
605      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
606      * a call to {approve}. `value` is the new allowance.
607      */
608     event Approval(address indexed owner, address indexed spender, uint256 value);
609 }
610 
611 contract ERC20TransferProxy is OwnableOperatorRole {
612 
613     function erc20safeTransferFrom(IERC20 token, address from, address to, uint256 value) external onlyOperator {
614         require(token.transferFrom(from, to, value), "failure while transferring");
615     }
616 }
617 
618 library UintLibrary {
619     using SafeMath for uint;
620 
621     function toString(uint256 i) internal pure returns (string memory) {
622         if (i == 0) {
623             return "0";
624         }
625         uint j = i;
626         uint len;
627         while (j != 0) {
628             len++;
629             j /= 10;
630         }
631         bytes memory bstr = new bytes(len);
632         uint k = len - 1;
633         while (i != 0) {
634             bstr[k--] = byte(uint8(48 + i % 10));
635             i /= 10;
636         }
637         return string(bstr);
638     }
639 
640     function bp(uint value, uint bpValue) internal pure returns (uint) {
641         return value.mul(bpValue).div(10000);
642     }
643 }
644 
645 library StringLibrary {
646     using UintLibrary for uint256;
647 
648     function append(string memory a, string memory b) internal pure returns (string memory) {
649         bytes memory ba = bytes(a);
650         bytes memory bb = bytes(b);
651         bytes memory bab = new bytes(ba.length + bb.length);
652         uint k = 0;
653         for (uint i = 0; i < ba.length; i++) bab[k++] = ba[i];
654         for (uint i = 0; i < bb.length; i++) bab[k++] = bb[i];
655         return string(bab);
656     }
657 
658     function append(string memory a, string memory b, string memory c) internal pure returns (string memory) {
659         bytes memory ba = bytes(a);
660         bytes memory bb = bytes(b);
661         bytes memory bc = bytes(c);
662         bytes memory bbb = new bytes(ba.length + bb.length + bc.length);
663         uint k = 0;
664         for (uint i = 0; i < ba.length; i++) bbb[k++] = ba[i];
665         for (uint i = 0; i < bb.length; i++) bbb[k++] = bb[i];
666         for (uint i = 0; i < bc.length; i++) bbb[k++] = bc[i];
667         return string(bbb);
668     }
669 
670     function recover(string memory message, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
671         bytes memory msgBytes = bytes(message);
672         bytes memory fullMessage = concat(
673             bytes("\x19Ethereum Signed Message:\n"),
674             bytes(msgBytes.length.toString()),
675             msgBytes,
676             new bytes(0), new bytes(0), new bytes(0), new bytes(0)
677         );
678         return ecrecover(keccak256(fullMessage), v, r, s);
679     }
680 
681     function concat(bytes memory ba, bytes memory bb, bytes memory bc, bytes memory bd, bytes memory be, bytes memory bf, bytes memory bg) internal pure returns (bytes memory) {
682         bytes memory resultBytes = new bytes(ba.length + bb.length + bc.length + bd.length + be.length + bf.length + bg.length);
683         uint k = 0;
684         for (uint i = 0; i < ba.length; i++) resultBytes[k++] = ba[i];
685         for (uint i = 0; i < bb.length; i++) resultBytes[k++] = bb[i];
686         for (uint i = 0; i < bc.length; i++) resultBytes[k++] = bc[i];
687         for (uint i = 0; i < bd.length; i++) resultBytes[k++] = bd[i];
688         for (uint i = 0; i < be.length; i++) resultBytes[k++] = be[i];
689         for (uint i = 0; i < bf.length; i++) resultBytes[k++] = bf[i];
690         for (uint i = 0; i < bg.length; i++) resultBytes[k++] = bg[i];
691         return resultBytes;
692     }
693 }
694 
695 library BytesLibrary {
696     function toString(bytes32 value) internal pure returns (string memory) {
697         bytes memory alphabet = "0123456789abcdef";
698         bytes memory str = new bytes(64);
699         for (uint256 i = 0; i < 32; i++) {
700             str[i*2] = alphabet[uint8(value[i] >> 4)];
701             str[1+i*2] = alphabet[uint8(value[i] & 0x0f)];
702         }
703         return string(str);
704     }
705 }
706 
707 contract ExchangeDomainV1 {
708 
709     enum AssetType {ETH, ERC20, ERC1155, ERC721, ERC721Deprecated}
710 
711     struct Asset {
712         address token;
713         uint tokenId;
714         AssetType assetType;
715     }
716 
717     struct OrderKey {
718         /* who signed the order */
719         address owner;
720         /* random number */
721         uint salt;
722 
723         /* what has owner */
724         Asset sellAsset;
725 
726         /* what wants owner */
727         Asset buyAsset;
728     }
729 
730     struct Order {
731         OrderKey key;
732 
733         /* how much has owner (in wei, or UINT256_MAX if ERC-721) */
734         uint selling;
735         /* how much wants owner (in wei, or UINT256_MAX if ERC-721) */
736         uint buying;
737 
738         /* fee for selling */
739         uint sellerFee;
740     }
741 
742     /* An ECDSA signature. */
743     struct Sig {
744         /* v parameter */
745         uint8 v;
746         /* r parameter */
747         bytes32 r;
748         /* s parameter */
749         bytes32 s;
750     }
751 }
752 
753 contract ExchangeStateV1 is OwnableOperatorRole {
754 
755     // keccak256(OrderKey) => completed
756     mapping(bytes32 => uint256) public completed;
757 
758     function getCompleted(ExchangeDomainV1.OrderKey calldata key) view external returns (uint256) {
759         return completed[getCompletedKey(key)];
760     }
761 
762     function setCompleted(ExchangeDomainV1.OrderKey calldata key, uint256 newCompleted) external onlyOperator {
763         completed[getCompletedKey(key)] = newCompleted;
764     }
765 
766     function getCompletedKey(ExchangeDomainV1.OrderKey memory key) pure public returns (bytes32) {
767         return keccak256(abi.encodePacked(key.owner, key.sellAsset.token, key.sellAsset.tokenId, key.buyAsset.token, key.buyAsset.tokenId, key.salt));
768     }
769 }
770 
771 contract ExchangeOrdersHolderV1 {
772 
773     mapping(bytes32 => OrderParams) internal orders;
774 
775     struct OrderParams {
776         /* how much has owner (in wei, or UINT256_MAX if ERC-721) */
777         uint selling;
778         /* how much wants owner (in wei, or UINT256_MAX if ERC-721) */
779         uint buying;
780 
781         /* fee for selling */
782         uint sellerFee;
783     }
784 
785     function add(ExchangeDomainV1.Order calldata order) external {
786         require(msg.sender == order.key.owner, "order could be added by owner only");
787         bytes32 key = prepareKey(order);
788         orders[key] = OrderParams(order.selling, order.buying, order.sellerFee);
789     }
790 
791     function exists(ExchangeDomainV1.Order calldata order) external view returns (bool) {
792         bytes32 key = prepareKey(order);
793         OrderParams memory params = orders[key];
794         return params.buying == order.buying && params.selling == order.selling && params.sellerFee == order.sellerFee;
795     }
796 
797     function prepareKey(ExchangeDomainV1.Order memory order) internal pure returns (bytes32) {
798         return keccak256(abi.encode(
799                 order.key.sellAsset.token,
800                 order.key.sellAsset.tokenId,
801                 order.key.owner,
802                 order.key.buyAsset.token,
803                 order.key.buyAsset.tokenId,
804                 order.key.salt
805             ));
806     }
807 }
808 
809 /**
810  * @dev Implementation of the {IERC165} interface.
811  *
812  * Contracts may inherit from this and call {_registerInterface} to declare
813  * their support of an interface.
814  */
815 contract ERC165 is IERC165 {
816     /*
817      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
818      */
819     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
820 
821     /**
822      * @dev Mapping of interface ids to whether or not it's supported.
823      */
824     mapping(bytes4 => bool) private _supportedInterfaces;
825 
826     constructor () internal {
827         // Derived contracts need only register support for their own interfaces,
828         // we register support for ERC165 itself here
829         _registerInterface(_INTERFACE_ID_ERC165);
830     }
831 
832     /**
833      * @dev See {IERC165-supportsInterface}.
834      *
835      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
836      */
837     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
838         return _supportedInterfaces[interfaceId];
839     }
840 
841     /**
842      * @dev Registers the contract as an implementer of the interface defined by
843      * `interfaceId`. Support of the actual ERC165 interface is automatic and
844      * registering its interface id is not required.
845      *
846      * See {IERC165-supportsInterface}.
847      *
848      * Requirements:
849      *
850      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
851      */
852     function _registerInterface(bytes4 interfaceId) internal {
853         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
854         _supportedInterfaces[interfaceId] = true;
855     }
856 }
857 
858 contract HasSecondarySaleFees is ERC165 {
859 
860     event SecondarySaleFees(uint256 tokenId, address[] recipients, uint[] bps);
861 
862     /*
863      * bytes4(keccak256('getFeeBps(uint256)')) == 0x0ebd4c7f
864      * bytes4(keccak256('getFeeRecipients(uint256)')) == 0xb9c4d9fb
865      *
866      * => 0x0ebd4c7f ^ 0xb9c4d9fb == 0xb7799584
867      */
868     bytes4 private constant _INTERFACE_ID_FEES = 0xb7799584;
869 
870     constructor() public {
871         _registerInterface(_INTERFACE_ID_FEES);
872     }
873 
874     function getFeeRecipients(uint256 id) external view returns (address payable[] memory);
875     function getFeeBps(uint256 id) external view returns (uint[] memory);
876 }
877 
878 contract ExchangeV1 is Ownable, ExchangeDomainV1 {
879     using SafeMath for uint;
880     using UintLibrary for uint;
881     using StringLibrary for string;
882     using BytesLibrary for bytes32;
883 
884     enum FeeSide {NONE, SELL, BUY}
885 
886     event Buy(
887         address indexed sellToken, uint256 indexed sellTokenId, uint256 sellValue,
888         address owner,
889         address buyToken, uint256 buyTokenId, uint256 buyValue,
890         address buyer,
891         uint256 amount,
892         uint256 salt
893     );
894 
895     event Cancel(
896         address indexed sellToken, uint256 indexed sellTokenId,
897         address owner,
898         address buyToken, uint256 buyTokenId,
899         uint256 salt
900     );
901 
902     bytes4 private constant _INTERFACE_ID_FEES = 0xb7799584;
903     uint256 private constant UINT256_MAX = 2 ** 256 - 1;
904 
905     address payable public beneficiary;
906     address public buyerFeeSigner;
907 
908     TransferProxy public transferProxy;
909     TransferProxyForDeprecated public transferProxyForDeprecated;
910     ERC20TransferProxy public erc20TransferProxy;
911     ExchangeStateV1 public state;
912     ExchangeOrdersHolderV1 public ordersHolder;
913 
914     constructor(
915         TransferProxy _transferProxy, TransferProxyForDeprecated _transferProxyForDeprecated, ERC20TransferProxy _erc20TransferProxy, ExchangeStateV1 _state,
916         ExchangeOrdersHolderV1 _ordersHolder, address payable _beneficiary, address _buyerFeeSigner
917     ) public {
918         transferProxy = _transferProxy;
919         transferProxyForDeprecated = _transferProxyForDeprecated;
920         erc20TransferProxy = _erc20TransferProxy;
921         state = _state;
922         ordersHolder = _ordersHolder;
923         beneficiary = _beneficiary;
924         buyerFeeSigner = _buyerFeeSigner;
925     }
926 
927     function setBeneficiary(address payable newBeneficiary) external onlyOwner {
928         beneficiary = newBeneficiary;
929     }
930 
931     function setBuyerFeeSigner(address newBuyerFeeSigner) external onlyOwner {
932         buyerFeeSigner = newBuyerFeeSigner;
933     }
934 
935     function exchange(
936         Order calldata order,
937         Sig calldata sig,
938         uint buyerFee,
939         Sig calldata buyerFeeSig,
940         uint amount,
941         address buyer
942     ) payable external {
943         validateOrderSig(order, sig);
944         validateBuyerFeeSig(order, buyerFee, buyerFeeSig);
945         uint paying = order.buying.mul(amount).div(order.selling);
946         verifyOpenAndModifyOrderState(order.key, order.selling, amount);
947         require(order.key.sellAsset.assetType != AssetType.ETH, "ETH is not supported on sell side");
948         if (order.key.buyAsset.assetType == AssetType.ETH) {
949             validateEthTransfer(paying, buyerFee);
950         }
951         FeeSide feeSide = getFeeSide(order.key.sellAsset.assetType, order.key.buyAsset.assetType);
952         if (buyer == address(0x0)) {
953             buyer = msg.sender;
954         }
955         transferWithFeesPossibility(order.key.sellAsset, amount, order.key.owner, buyer, feeSide == FeeSide.SELL, buyerFee, order.sellerFee, order.key.buyAsset);
956         transferWithFeesPossibility(order.key.buyAsset, paying, msg.sender, order.key.owner, feeSide == FeeSide.BUY, order.sellerFee, buyerFee, order.key.sellAsset);
957         emitBuy(order, amount, buyer);
958     }
959 
960     function validateEthTransfer(uint value, uint buyerFee) internal view {
961         uint256 buyerFeeValue = value.bp(buyerFee);
962         require(msg.value == value + buyerFeeValue, "msg.value is incorrect");
963     }
964 
965     function cancel(OrderKey calldata key) external {
966         require(key.owner == msg.sender, "not an owner");
967         state.setCompleted(key, UINT256_MAX);
968         emit Cancel(key.sellAsset.token, key.sellAsset.tokenId, msg.sender, key.buyAsset.token, key.buyAsset.tokenId, key.salt);
969     }
970 
971     function validateOrderSig(
972         Order memory order,
973         Sig memory sig
974     ) internal view {
975         if (sig.v == 0 && sig.r == bytes32(0x0) && sig.s == bytes32(0x0)) {
976             require(ordersHolder.exists(order), "incorrect signature");
977         } else {
978             require(prepareMessage(order).recover(sig.v, sig.r, sig.s) == order.key.owner, "incorrect signature");
979         }
980     }
981 
982     function validateBuyerFeeSig(
983         Order memory order,
984         uint buyerFee,
985         Sig memory sig
986     ) internal view {
987         require(prepareBuyerFeeMessage(order, buyerFee).recover(sig.v, sig.r, sig.s) == buyerFeeSigner, "incorrect buyer fee signature");
988     }
989 
990     function prepareBuyerFeeMessage(Order memory order, uint fee) public pure returns (string memory) {
991         return keccak256(abi.encode(order, fee)).toString();
992     }
993 
994     function prepareMessage(Order memory order) public pure returns (string memory) {
995         return keccak256(abi.encode(order)).toString();
996     }
997 
998     function transferWithFeesPossibility(Asset memory firstType, uint value, address from, address to, bool hasFee, uint256 sellerFee, uint256 buyerFee, Asset memory secondType) internal {
999         if (!hasFee) {
1000             transfer(firstType, value, from, to);
1001         } else {
1002             transferWithFees(firstType, value, from, to, sellerFee, buyerFee, secondType);
1003         }
1004     }
1005 
1006     function transfer(Asset memory asset, uint value, address from, address to) internal {
1007         if (asset.assetType == AssetType.ETH) {
1008             address payable toPayable = address(uint160(to));
1009             toPayable.transfer(value);
1010         } else if (asset.assetType == AssetType.ERC20) {
1011             require(asset.tokenId == 0, "tokenId should be 0");
1012             erc20TransferProxy.erc20safeTransferFrom(IERC20(asset.token), from, to, value);
1013         } else if (asset.assetType == AssetType.ERC721) {
1014             require(value == 1, "value should be 1 for ERC-721");
1015             transferProxy.erc721safeTransferFrom(IERC721(asset.token), from, to, asset.tokenId);
1016         } else if (asset.assetType == AssetType.ERC721Deprecated) {
1017             require(value == 1, "value should be 1 for ERC-721");
1018             transferProxyForDeprecated.erc721TransferFrom(IERC721(asset.token), from, to, asset.tokenId);
1019         } else {
1020             transferProxy.erc1155safeTransferFrom(IERC1155(asset.token), from, to, asset.tokenId, value, "");
1021         }
1022     }
1023 
1024     function transferWithFees(Asset memory firstType, uint value, address from, address to, uint256 sellerFee, uint256 buyerFee, Asset memory secondType) internal {
1025         uint restValue = transferFeeToBeneficiary(firstType, from, value, sellerFee, buyerFee);
1026         if (
1027             secondType.assetType == AssetType.ERC1155 && IERC1155(secondType.token).supportsInterface(_INTERFACE_ID_FEES) ||
1028             (secondType.assetType == AssetType.ERC721 || secondType.assetType == AssetType.ERC721Deprecated) && IERC721(secondType.token).supportsInterface(_INTERFACE_ID_FEES)
1029         ) {
1030             HasSecondarySaleFees withFees = HasSecondarySaleFees(secondType.token);
1031             address payable[] memory recipients = withFees.getFeeRecipients(secondType.tokenId);
1032             uint[] memory fees = withFees.getFeeBps(secondType.tokenId);
1033             require(fees.length == recipients.length);
1034             for (uint256 i = 0; i < fees.length; i++) {
1035                 (uint newRestValue, uint current) = subFeeInBp(restValue, value, fees[i]);
1036                 restValue = newRestValue;
1037                 transfer(firstType, current, from, recipients[i]);
1038             }
1039         }
1040         address payable toPayable = address(uint160(to));
1041         transfer(firstType, restValue, from, toPayable);
1042     }
1043 
1044     function transferFeeToBeneficiary(Asset memory asset, address from, uint total, uint sellerFee, uint buyerFee) internal returns (uint) {
1045         (uint restValue, uint sellerFeeValue) = subFeeInBp(total, total, sellerFee);
1046         uint buyerFeeValue = total.bp(buyerFee);
1047         uint beneficiaryFee = buyerFeeValue.add(sellerFeeValue);
1048         if (beneficiaryFee > 0) {
1049             transfer(asset, beneficiaryFee, from, beneficiary);
1050         }
1051         return restValue;
1052     }
1053 
1054     function emitBuy(Order memory order, uint amount, address buyer) internal {
1055         emit Buy(order.key.sellAsset.token, order.key.sellAsset.tokenId, order.selling,
1056             order.key.owner,
1057             order.key.buyAsset.token, order.key.buyAsset.tokenId, order.buying,
1058             buyer,
1059             amount,
1060             order.key.salt
1061         );
1062     }
1063 
1064     function subFeeInBp(uint value, uint total, uint feeInBp) internal pure returns (uint newValue, uint realFee) {
1065         return subFee(value, total.bp(feeInBp));
1066     }
1067 
1068     function subFee(uint value, uint fee) internal pure returns (uint newValue, uint realFee) {
1069         if (value > fee) {
1070             newValue = value - fee;
1071             realFee = fee;
1072         } else {
1073             newValue = 0;
1074             realFee = value;
1075         }
1076     }
1077 
1078     function verifyOpenAndModifyOrderState(OrderKey memory key, uint selling, uint amount) internal {
1079         uint completed = state.getCompleted(key);
1080         uint newCompleted = completed.add(amount);
1081         require(newCompleted <= selling, "not enough stock of order for buying");
1082         state.setCompleted(key, newCompleted);
1083     }
1084 
1085     function getFeeSide(AssetType sellType, AssetType buyType) internal pure returns (FeeSide) {
1086         if ((sellType == AssetType.ERC721 || sellType == AssetType.ERC721Deprecated) &&
1087             (buyType == AssetType.ERC721 || buyType == AssetType.ERC721Deprecated)) {
1088             return FeeSide.NONE;
1089         }
1090         if (uint(sellType) > uint(buyType)) {
1091             return FeeSide.BUY;
1092         }
1093         return FeeSide.SELL;
1094     }
1095 }