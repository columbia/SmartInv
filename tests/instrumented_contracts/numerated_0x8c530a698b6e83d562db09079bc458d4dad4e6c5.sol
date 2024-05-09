1 pragma solidity ^0.5.0;
2 
3 /**
4  * @dev Interface of the ERC165 standard, as defined in the
5  * https://eips.ethereum.org/EIPS/eip-165[EIP].
6  *
7  * Implementers can declare support of contract interfaces, which can then be
8  * queried by others ({ERC165Checker}).
9  *
10  * For an implementation, see {ERC165}.
11  */
12 interface IERC165 {
13     /**
14      * @dev Returns true if this contract implements the interface defined by
15      * `interfaceId`. See the corresponding
16      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
17      * to learn more about how these ids are created.
18      *
19      * This function call must use less than 30 000 gas.
20      */
21     function supportsInterface(bytes4 interfaceId) external view returns (bool);
22 }
23 
24 /**
25     @title ERC-1155 Multi Token Standard
26     @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-1155.md
27     Note: The ERC-165 identifier for this interface is 0xd9b67a26.
28  */
29 contract IERC1155 is IERC165 {
30     /**
31         @dev Either `TransferSingle` or `TransferBatch` MUST emit when tokens are transferred, including zero value transfers as well as minting or burning (see "Safe Transfer Rules" section of the standard).
32         The `_operator` argument MUST be msg.sender.
33         The `_from` argument MUST be the address of the holder whose balance is decreased.
34         The `_to` argument MUST be the address of the recipient whose balance is increased.
35         The `_id` argument MUST be the token type being transferred.
36         The `_value` argument MUST be the number of tokens the holder balance is decreased by and match what the recipient balance is increased by.
37         When minting/creating tokens, the `_from` argument MUST be set to `0x0` (i.e. zero address).
38         When burning/destroying tokens, the `_to` argument MUST be set to `0x0` (i.e. zero address).
39     */
40     event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _value);
41 
42     /**
43         @dev Either `TransferSingle` or `TransferBatch` MUST emit when tokens are transferred, including zero value transfers as well as minting or burning (see "Safe Transfer Rules" section of the standard).
44         The `_operator` argument MUST be msg.sender.
45         The `_from` argument MUST be the address of the holder whose balance is decreased.
46         The `_to` argument MUST be the address of the recipient whose balance is increased.
47         The `_ids` argument MUST be the list of tokens being transferred.
48         The `_values` argument MUST be the list of number of tokens (matching the list and order of tokens specified in _ids) the holder balance is decreased by and match what the recipient balance is increased by.
49         When minting/creating tokens, the `_from` argument MUST be set to `0x0` (i.e. zero address).
50         When burning/destroying tokens, the `_to` argument MUST be set to `0x0` (i.e. zero address).
51     */
52     event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _values);
53 
54     /**
55         @dev MUST emit when approval for a second party/operator address to manage all tokens for an owner address is enabled or disabled (absense of an event assumes disabled).
56     */
57     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
58 
59     /**
60         @dev MUST emit when the URI is updated for a token ID.
61         URIs are defined in RFC 3986.
62         The URI MUST point a JSON file that conforms to the "ERC-1155 Metadata URI JSON Schema".
63     */
64     event URI(string _value, uint256 indexed _id);
65 
66     /**
67         @notice Transfers `_value` amount of an `_id` from the `_from` address to the `_to` address specified (with safety call).
68         @dev Caller must be approved to manage the tokens being transferred out of the `_from` account (see "Approval" section of the standard).
69         MUST revert if `_to` is the zero address.
70         MUST revert if balance of holder for token `_id` is lower than the `_value` sent.
71         MUST revert on any other error.
72         MUST emit the `TransferSingle` event to reflect the balance change (see "Safe Transfer Rules" section of the standard).
73         After the above conditions are met, this function MUST check if `_to` is a smart contract (e.g. code size > 0). If so, it MUST call `onERC1155Received` on `_to` and act appropriately (see "Safe Transfer Rules" section of the standard).
74         @param _from    Source address
75         @param _to      Target address
76         @param _id      ID of the token type
77         @param _value   Transfer amount
78         @param _data    Additional data with no specified format, MUST be sent unaltered in call to `onERC1155Received` on `_to`
79     */
80     function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _value, bytes calldata _data) external;
81 
82     /**
83         @notice Transfers `_values` amount(s) of `_ids` from the `_from` address to the `_to` address specified (with safety call).
84         @dev Caller must be approved to manage the tokens being transferred out of the `_from` account (see "Approval" section of the standard).
85         MUST revert if `_to` is the zero address.
86         MUST revert if length of `_ids` is not the same as length of `_values`.
87         MUST revert if any of the balance(s) of the holder(s) for token(s) in `_ids` is lower than the respective amount(s) in `_values` sent to the recipient.
88         MUST revert on any other error.
89         MUST emit `TransferSingle` or `TransferBatch` event(s) such that all the balance changes are reflected (see "Safe Transfer Rules" section of the standard).
90         Balance changes and events MUST follow the ordering of the arrays (_ids[0]/_values[0] before _ids[1]/_values[1], etc).
91         After the above conditions for the transfer(s) in the batch are met, this function MUST check if `_to` is a smart contract (e.g. code size > 0). If so, it MUST call the relevant `ERC1155TokenReceiver` hook(s) on `_to` and act appropriately (see "Safe Transfer Rules" section of the standard).
92         @param _from    Source address
93         @param _to      Target address
94         @param _ids     IDs of each token type (order and length must match _values array)
95         @param _values  Transfer amounts per token type (order and length must match _ids array)
96         @param _data    Additional data with no specified format, MUST be sent unaltered in call to the `ERC1155TokenReceiver` hook(s) on `_to`
97     */
98     function safeBatchTransferFrom(address _from, address _to, uint256[] calldata _ids, uint256[] calldata _values, bytes calldata _data) external;
99 
100     /**
101         @notice Get the balance of an account's Tokens.
102         @param _owner  The address of the token holder
103         @param _id     ID of the Token
104         @return        The _owner's balance of the Token type requested
105      */
106     function balanceOf(address _owner, uint256 _id) external view returns (uint256);
107 
108     /**
109         @notice Get the balance of multiple account/token pairs
110         @param _owners The addresses of the token holders
111         @param _ids    ID of the Tokens
112         @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)
113      */
114     function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids) external view returns (uint256[] memory);
115 
116     /**
117         @notice Enable or disable approval for a third party ("operator") to manage all of the caller's tokens.
118         @dev MUST emit the ApprovalForAll event on success.
119         @param _operator  Address to add to the set of authorized operators
120         @param _approved  True if the operator is approved, false to revoke approval
121     */
122     function setApprovalForAll(address _operator, bool _approved) external;
123 
124     /**
125         @notice Queries the approval status of an operator for a given owner.
126         @param _owner     The owner of the Tokens
127         @param _operator  Address of authorized operator
128         @return           True if the operator is approved, false if not
129     */
130     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
131 }
132 
133 /**
134  * @dev Wrappers over Solidity's arithmetic operations with added overflow
135  * checks.
136  *
137  * Arithmetic operations in Solidity wrap on overflow. This can easily result
138  * in bugs, because programmers usually assume that an overflow raises an
139  * error, which is the standard behavior in high level programming languages.
140  * `SafeMath` restores this intuition by reverting the transaction when an
141  * operation overflows.
142  *
143  * Using this library instead of the unchecked operations eliminates an entire
144  * class of bugs, so it's recommended to use it always.
145  */
146 library SafeMath {
147     /**
148      * @dev Returns the addition of two unsigned integers, reverting on
149      * overflow.
150      *
151      * Counterpart to Solidity's `+` operator.
152      *
153      * Requirements:
154      * - Addition cannot overflow.
155      */
156     function add(uint256 a, uint256 b) internal pure returns (uint256) {
157         uint256 c = a + b;
158         require(c >= a, "SafeMath: addition overflow");
159 
160         return c;
161     }
162 
163     /**
164      * @dev Returns the subtraction of two unsigned integers, reverting on
165      * overflow (when the result is negative).
166      *
167      * Counterpart to Solidity's `-` operator.
168      *
169      * Requirements:
170      * - Subtraction cannot overflow.
171      */
172     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
173         return sub(a, b, "SafeMath: subtraction overflow");
174     }
175 
176     /**
177      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
178      * overflow (when the result is negative).
179      *
180      * Counterpart to Solidity's `-` operator.
181      *
182      * Requirements:
183      * - Subtraction cannot overflow.
184      *
185      * _Available since v2.4.0._
186      */
187     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
188         require(b <= a, errorMessage);
189         uint256 c = a - b;
190 
191         return c;
192     }
193 
194     /**
195      * @dev Returns the multiplication of two unsigned integers, reverting on
196      * overflow.
197      *
198      * Counterpart to Solidity's `*` operator.
199      *
200      * Requirements:
201      * - Multiplication cannot overflow.
202      */
203     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
204         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
205         // benefit is lost if 'b' is also tested.
206         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
207         if (a == 0) {
208             return 0;
209         }
210 
211         uint256 c = a * b;
212         require(c / a == b, "SafeMath: multiplication overflow");
213 
214         return c;
215     }
216 
217     /**
218      * @dev Returns the integer division of two unsigned integers. Reverts on
219      * division by zero. The result is rounded towards zero.
220      *
221      * Counterpart to Solidity's `/` operator. Note: this function uses a
222      * `revert` opcode (which leaves remaining gas untouched) while Solidity
223      * uses an invalid opcode to revert (consuming all remaining gas).
224      *
225      * Requirements:
226      * - The divisor cannot be zero.
227      */
228     function div(uint256 a, uint256 b) internal pure returns (uint256) {
229         return div(a, b, "SafeMath: division by zero");
230     }
231 
232     /**
233      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
234      * division by zero. The result is rounded towards zero.
235      *
236      * Counterpart to Solidity's `/` operator. Note: this function uses a
237      * `revert` opcode (which leaves remaining gas untouched) while Solidity
238      * uses an invalid opcode to revert (consuming all remaining gas).
239      *
240      * Requirements:
241      * - The divisor cannot be zero.
242      *
243      * _Available since v2.4.0._
244      */
245     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
246         // Solidity only automatically asserts when dividing by 0
247         require(b > 0, errorMessage);
248         uint256 c = a / b;
249         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
250 
251         return c;
252     }
253 
254     /**
255      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
256      * Reverts when dividing by zero.
257      *
258      * Counterpart to Solidity's `%` operator. This function uses a `revert`
259      * opcode (which leaves remaining gas untouched) while Solidity uses an
260      * invalid opcode to revert (consuming all remaining gas).
261      *
262      * Requirements:
263      * - The divisor cannot be zero.
264      */
265     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
266         return mod(a, b, "SafeMath: modulo by zero");
267     }
268 
269     /**
270      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
271      * Reverts with custom message when dividing by zero.
272      *
273      * Counterpart to Solidity's `%` operator. This function uses a `revert`
274      * opcode (which leaves remaining gas untouched) while Solidity uses an
275      * invalid opcode to revert (consuming all remaining gas).
276      *
277      * Requirements:
278      * - The divisor cannot be zero.
279      *
280      * _Available since v2.4.0._
281      */
282     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
283         require(b != 0, errorMessage);
284         return a % b;
285     }
286 }
287 
288 library UintLibrary {
289     function toString(uint256 _i) internal pure returns (string memory) {
290         if (_i == 0) {
291             return "0";
292         }
293         uint j = _i;
294         uint len;
295         while (j != 0) {
296             len++;
297             j /= 10;
298         }
299         bytes memory bstr = new bytes(len);
300         uint k = len - 1;
301         while (_i != 0) {
302             bstr[k--] = byte(uint8(48 + _i % 10));
303             _i /= 10;
304         }
305         return string(bstr);
306     }
307 }
308 
309 library StringLibrary {
310     using UintLibrary for uint256;
311 
312     function append(string memory _a, string memory _b) internal pure returns (string memory) {
313         bytes memory _ba = bytes(_a);
314         bytes memory _bb = bytes(_b);
315         bytes memory bab = new bytes(_ba.length + _bb.length);
316         uint k = 0;
317         for (uint i = 0; i < _ba.length; i++) bab[k++] = _ba[i];
318         for (uint i = 0; i < _bb.length; i++) bab[k++] = _bb[i];
319         return string(bab);
320     }
321 
322     function append(string memory _a, string memory _b, string memory _c) internal pure returns (string memory) {
323         bytes memory _ba = bytes(_a);
324         bytes memory _bb = bytes(_b);
325         bytes memory _bc = bytes(_c);
326         bytes memory bbb = new bytes(_ba.length + _bb.length + _bc.length);
327         uint k = 0;
328         for (uint i = 0; i < _ba.length; i++) bbb[k++] = _ba[i];
329         for (uint i = 0; i < _bb.length; i++) bbb[k++] = _bb[i];
330         for (uint i = 0; i < _bc.length; i++) bbb[k++] = _bc[i];
331         return string(bbb);
332     }
333 
334     function recover(string memory message, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
335         bytes memory msgBytes = bytes(message);
336         bytes memory fullMessage = concat(
337             bytes("\x19Ethereum Signed Message:\n"),
338             bytes(msgBytes.length.toString()),
339             msgBytes,
340             new bytes(0), new bytes(0), new bytes(0), new bytes(0)
341         );
342         return ecrecover(keccak256(fullMessage), v, r, s);
343     }
344 
345     function concat(bytes memory _ba, bytes memory _bb, bytes memory _bc, bytes memory _bd, bytes memory _be, bytes memory _bf, bytes memory _bg) internal pure returns (bytes memory) {
346         bytes memory resultBytes = new bytes(_ba.length + _bb.length + _bc.length + _bd.length + _be.length + _bf.length + _bg.length);
347         uint k = 0;
348         for (uint i = 0; i < _ba.length; i++) resultBytes[k++] = _ba[i];
349         for (uint i = 0; i < _bb.length; i++) resultBytes[k++] = _bb[i];
350         for (uint i = 0; i < _bc.length; i++) resultBytes[k++] = _bc[i];
351         for (uint i = 0; i < _bd.length; i++) resultBytes[k++] = _bd[i];
352         for (uint i = 0; i < _be.length; i++) resultBytes[k++] = _be[i];
353         for (uint i = 0; i < _bf.length; i++) resultBytes[k++] = _bf[i];
354         for (uint i = 0; i < _bg.length; i++) resultBytes[k++] = _bg[i];
355         return resultBytes;
356     }
357 }
358 
359 library AddressLibrary {
360     function toString(address _addr) internal pure returns (string memory) {
361         bytes32 value = bytes32(uint256(_addr));
362         bytes memory alphabet = "0123456789abcdef";
363         bytes memory str = new bytes(42);
364         str[0] = '0';
365         str[1] = 'x';
366         for (uint256 i = 0; i < 20; i++) {
367             str[2+i*2] = alphabet[uint8(value[i + 12] >> 4)];
368             str[3+i*2] = alphabet[uint8(value[i + 12] & 0x0f)];
369         }
370         return string(str);
371     }
372 }
373 
374 contract AbstractSale {
375     using UintLibrary for uint256;
376     using AddressLibrary for address;
377 
378     function prepareMessage(address token, uint256 tokenId, uint256 price, uint256 nonce) internal pure returns (string memory) {
379         return string(strConcat(
380             bytes(token.toString()),
381             bytes(". tokenId: "),
382             bytes(tokenId.toString()),
383             bytes(". price: "),
384             bytes(price.toString()),
385             bytes(". nonce: "),
386             bytes(nonce.toString())
387         ));
388     }
389 
390     function strConcat(bytes memory _ba, bytes memory _bb, bytes memory _bc, bytes memory _bd, bytes memory _be, bytes memory _bf, bytes memory _bg) internal pure returns (bytes memory) {
391         bytes memory resultBytes = new bytes(_ba.length + _bb.length + _bc.length + _bd.length + _be.length + _bf.length + _bg.length);
392         uint k = 0;
393         for (uint i = 0; i < _ba.length; i++) resultBytes[k++] = _ba[i];
394         for (uint i = 0; i < _bb.length; i++) resultBytes[k++] = _bb[i];
395         for (uint i = 0; i < _bc.length; i++) resultBytes[k++] = _bc[i];
396         for (uint i = 0; i < _bd.length; i++) resultBytes[k++] = _bd[i];
397         for (uint i = 0; i < _be.length; i++) resultBytes[k++] = _be[i];
398         for (uint i = 0; i < _bf.length; i++) resultBytes[k++] = _bf[i];
399         for (uint i = 0; i < _bg.length; i++) resultBytes[k++] = _bg[i];
400         return resultBytes;
401     }
402 }
403 
404 /**
405  * @dev Required interface of an ERC721 compliant contract.
406  */
407 contract IERC721 is IERC165 {
408     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
409     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
410     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
411 
412     /**
413      * @dev Returns the number of NFTs in `owner`'s account.
414      */
415     function balanceOf(address owner) public view returns (uint256 balance);
416 
417     /**
418      * @dev Returns the owner of the NFT specified by `tokenId`.
419      */
420     function ownerOf(uint256 tokenId) public view returns (address owner);
421 
422     /**
423      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
424      * another (`to`).
425      *
426      *
427      *
428      * Requirements:
429      * - `from`, `to` cannot be zero.
430      * - `tokenId` must be owned by `from`.
431      * - If the caller is not `from`, it must be have been allowed to move this
432      * NFT by either {approve} or {setApprovalForAll}.
433      */
434     function safeTransferFrom(address from, address to, uint256 tokenId) public;
435     /**
436      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
437      * another (`to`).
438      *
439      * Requirements:
440      * - If the caller is not `from`, it must be approved to move this NFT by
441      * either {approve} or {setApprovalForAll}.
442      */
443     function transferFrom(address from, address to, uint256 tokenId) public;
444     function approve(address to, uint256 tokenId) public;
445     function getApproved(uint256 tokenId) public view returns (address operator);
446 
447     function setApprovalForAll(address operator, bool _approved) public;
448     function isApprovedForAll(address owner, address operator) public view returns (bool);
449 
450 
451     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
452 }
453 
454 /*
455  * @dev Provides information about the current execution context, including the
456  * sender of the transaction and its data. While these are generally available
457  * via msg.sender and msg.data, they should not be accessed in such a direct
458  * manner, since when dealing with GSN meta-transactions the account sending and
459  * paying for execution may not be the actual sender (as far as an application
460  * is concerned).
461  *
462  * This contract is only required for intermediate, library-like contracts.
463  */
464 contract Context {
465     // Empty internal constructor, to prevent people from mistakenly deploying
466     // an instance of this contract, which should be used via inheritance.
467     constructor () internal { }
468     // solhint-disable-previous-line no-empty-blocks
469 
470     function _msgSender() internal view returns (address payable) {
471         return msg.sender;
472     }
473 
474     function _msgData() internal view returns (bytes memory) {
475         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
476         return msg.data;
477     }
478 }
479 
480 /**
481  * @title Roles
482  * @dev Library for managing addresses assigned to a Role.
483  */
484 library Roles {
485     struct Role {
486         mapping (address => bool) bearer;
487     }
488 
489     /**
490      * @dev Give an account access to this role.
491      */
492     function add(Role storage role, address account) internal {
493         require(!has(role, account), "Roles: account already has role");
494         role.bearer[account] = true;
495     }
496 
497     /**
498      * @dev Remove an account's access to this role.
499      */
500     function remove(Role storage role, address account) internal {
501         require(has(role, account), "Roles: account does not have role");
502         role.bearer[account] = false;
503     }
504 
505     /**
506      * @dev Check if an account has this role.
507      * @return bool
508      */
509     function has(Role storage role, address account) internal view returns (bool) {
510         require(account != address(0), "Roles: account is the zero address");
511         return role.bearer[account];
512     }
513 }
514 
515 contract OperatorRole is Context {
516     using Roles for Roles.Role;
517 
518     event OperatorAdded(address indexed account);
519     event OperatorRemoved(address indexed account);
520 
521     Roles.Role private _operators;
522 
523     constructor () internal {
524 
525     }
526 
527     modifier onlyOperator() {
528         require(isOperator(_msgSender()), "OperatorRole: caller does not have the Operator role");
529         _;
530     }
531 
532     function isOperator(address account) public view returns (bool) {
533         return _operators.has(account);
534     }
535 
536     function _addOperator(address account) internal {
537         _operators.add(account);
538         emit OperatorAdded(account);
539     }
540 
541     function _removeOperator(address account) internal {
542         _operators.remove(account);
543         emit OperatorRemoved(account);
544     }
545 }
546 
547 /**
548  * @dev Contract module which provides a basic access control mechanism, where
549  * there is an account (an owner) that can be granted exclusive access to
550  * specific functions.
551  *
552  * This module is used through inheritance. It will make available the modifier
553  * `onlyOwner`, which can be applied to your functions to restrict their use to
554  * the owner.
555  */
556 contract Ownable is Context {
557     address private _owner;
558 
559     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
560 
561     /**
562      * @dev Initializes the contract setting the deployer as the initial owner.
563      */
564     constructor () internal {
565         address msgSender = _msgSender();
566         _owner = msgSender;
567         emit OwnershipTransferred(address(0), msgSender);
568     }
569 
570     /**
571      * @dev Returns the address of the current owner.
572      */
573     function owner() public view returns (address) {
574         return _owner;
575     }
576 
577     /**
578      * @dev Throws if called by any account other than the owner.
579      */
580     modifier onlyOwner() {
581         require(isOwner(), "Ownable: caller is not the owner");
582         _;
583     }
584 
585     /**
586      * @dev Returns true if the caller is the current owner.
587      */
588     function isOwner() public view returns (bool) {
589         return _msgSender() == _owner;
590     }
591 
592     /**
593      * @dev Leaves the contract without owner. It will not be possible to call
594      * `onlyOwner` functions anymore. Can only be called by the current owner.
595      *
596      * NOTE: Renouncing ownership will leave the contract without an owner,
597      * thereby removing any functionality that is only available to the owner.
598      */
599     function renounceOwnership() public onlyOwner {
600         emit OwnershipTransferred(_owner, address(0));
601         _owner = address(0);
602     }
603 
604     /**
605      * @dev Transfers ownership of the contract to a new account (`newOwner`).
606      * Can only be called by the current owner.
607      */
608     function transferOwnership(address newOwner) public onlyOwner {
609         _transferOwnership(newOwner);
610     }
611 
612     /**
613      * @dev Transfers ownership of the contract to a new account (`newOwner`).
614      */
615     function _transferOwnership(address newOwner) internal {
616         require(newOwner != address(0), "Ownable: new owner is the zero address");
617         emit OwnershipTransferred(_owner, newOwner);
618         _owner = newOwner;
619     }
620 }
621 
622 contract OwnableOperatorRole is Ownable, OperatorRole {
623     function addOperator(address account) public onlyOwner {
624         _addOperator(account);
625     }
626 
627     function removeOperator(address account) public onlyOwner {
628         _removeOperator(account);
629     }
630 }
631 
632 contract TransferProxy is OwnableOperatorRole {
633 
634     function erc721safeTransferFrom(IERC721 token, address from, address to, uint256 tokenId) external onlyOperator {
635         token.safeTransferFrom(from, to, tokenId);
636     }
637 
638     function erc1155safeTransferFrom(IERC1155 token, address _from, address _to, uint256 _id, uint256 _value, bytes calldata _data) external onlyOperator {
639         token.safeTransferFrom(_from, _to, _id, _value, _data);
640     }
641 }
642 
643 /**
644  * @dev Implementation of the {IERC165} interface.
645  *
646  * Contracts may inherit from this and call {_registerInterface} to declare
647  * their support of an interface.
648  */
649 contract ERC165 is IERC165 {
650     /*
651      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
652      */
653     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
654 
655     /**
656      * @dev Mapping of interface ids to whether or not it's supported.
657      */
658     mapping(bytes4 => bool) private _supportedInterfaces;
659 
660     constructor () internal {
661         // Derived contracts need only register support for their own interfaces,
662         // we register support for ERC165 itself here
663         _registerInterface(_INTERFACE_ID_ERC165);
664     }
665 
666     /**
667      * @dev See {IERC165-supportsInterface}.
668      *
669      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
670      */
671     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
672         return _supportedInterfaces[interfaceId];
673     }
674 
675     /**
676      * @dev Registers the contract as an implementer of the interface defined by
677      * `interfaceId`. Support of the actual ERC165 interface is automatic and
678      * registering its interface id is not required.
679      *
680      * See {IERC165-supportsInterface}.
681      *
682      * Requirements:
683      *
684      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
685      */
686     function _registerInterface(bytes4 interfaceId) internal {
687         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
688         _supportedInterfaces[interfaceId] = true;
689     }
690 }
691 
692 contract HasSecondarySaleFees is ERC165 {
693 
694     event SecondarySaleFees(uint256 tokenId, address[] recipients, uint[] bps);
695 
696     /*
697      * bytes4(keccak256('getFeeBps(uint256)')) == 0x0ebd4c7f
698      * bytes4(keccak256('getFeeRecipients(uint256)')) == 0xb9c4d9fb
699      *
700      * => 0x0ebd4c7f ^ 0xb9c4d9fb == 0xb7799584
701      */
702     bytes4 private constant _INTERFACE_ID_FEES = 0xb7799584;
703 
704     constructor() public {
705         _registerInterface(_INTERFACE_ID_FEES);
706     }
707 
708     function getFeeRecipients(uint256 id) public view returns (address payable[] memory);
709     function getFeeBps(uint256 id) public view returns (uint[] memory);
710 }
711 
712 contract ERC1155SaleNonceHolder is OwnableOperatorRole {
713     // keccak256(token, owner, tokenId) => nonce
714     mapping(bytes32 => uint256) public nonces;
715 
716     // keccak256(token, owner, tokenId, nonce) => completed amount
717     mapping(bytes32 => uint256) public completed;
718 
719     function getNonce(address token, uint256 tokenId, address owner) view public returns (uint256) {
720         return nonces[getNonceKey(token, tokenId, owner)];
721     }
722 
723     function setNonce(address token, uint256 tokenId, address owner, uint256 nonce) public onlyOperator {
724         nonces[getNonceKey(token, tokenId, owner)] = nonce;
725     }
726 
727     function getNonceKey(address token, uint256 tokenId, address owner) pure public returns (bytes32) {
728         return keccak256(abi.encodePacked(token, tokenId, owner));
729     }
730 
731     function getCompleted(address token, uint256 tokenId, address owner, uint256 nonce) view public returns (uint256) {
732         return completed[getCompletedKey(token, tokenId, owner, nonce)];
733     }
734 
735     function setCompleted(address token, uint256 tokenId, address owner, uint256 nonce, uint256 _completed) public onlyOperator {
736         completed[getCompletedKey(token, tokenId, owner, nonce)] = _completed;
737     }
738 
739     function getCompletedKey(address token, uint256 tokenId, address owner, uint256 nonce) pure public returns (bytes32) {
740         return keccak256(abi.encodePacked(token, tokenId, owner, nonce));
741     }
742 }
743 
744 contract ERC1155Sale is AbstractSale {
745     using SafeMath for uint256;
746     using StringLibrary for string;
747 
748     event CloseOrder(address indexed token, uint256 indexed tokenId, address owner, uint256 nonce);
749     event Buy(address indexed token, uint256 indexed tokenId, address owner, uint256 price, address buyer, uint256 value);
750 
751     bytes constant EMPTY = "";
752     bytes4 private constant _INTERFACE_ID_FEES = 0xb7799584;
753 
754     TransferProxy public transferProxy;
755     ERC1155SaleNonceHolder public nonceHolder;
756 
757     constructor(TransferProxy _transferProxy, ERC1155SaleNonceHolder _nonceHolder) public {
758         transferProxy = _transferProxy;
759         nonceHolder = _nonceHolder;
760     }
761 
762     function buy(IERC1155 token, uint256 tokenId, address payable owner, uint256 selling, uint256 buying, uint8 v, bytes32 r, bytes32 s) public payable {
763         uint256 price = msg.value.div(buying);
764         uint256 nonce = verifySignature(address(token), tokenId, owner, selling, price, v, r, s);
765         verifyOpenAndModifyState(address(token), tokenId, owner, nonce, selling, buying);
766 
767         transferProxy.erc1155safeTransferFrom(token, owner, msg.sender, tokenId, buying, EMPTY);
768 
769         transferEther(token, tokenId, owner);
770         emit Buy(address(token), tokenId, owner, price, msg.sender, buying);
771     }
772 
773     function transferEther(IERC1155 token, uint256 tokenId, address payable owner) internal {
774         uint256 value = msg.value;
775         if (token.supportsInterface(_INTERFACE_ID_FEES)) {
776             HasSecondarySaleFees withFees = HasSecondarySaleFees(address(token));
777             address payable[] memory recipients = withFees.getFeeRecipients(tokenId);
778             uint[] memory fees = withFees.getFeeBps(tokenId);
779             require(fees.length == recipients.length);
780             for (uint256 i = 0; i < fees.length; i++) {
781                 uint current = msg.value.mul(fees[i]).div(10000);
782                 recipients[i].transfer(current);
783                 value = value.sub(current);
784             }
785         }
786         owner.transfer(value);
787     }
788 
789     function cancel(address token, uint256 tokenId) public payable {
790         uint nonce = nonceHolder.getNonce(token, tokenId, msg.sender);
791         nonceHolder.setNonce(token, tokenId, msg.sender, nonce + 1);
792 
793         emit CloseOrder(token, tokenId, msg.sender, nonce + 1);
794     }
795 
796     function verifySignature(address token, uint256 tokenId, address payable owner, uint256 selling, uint256 price, uint8 v, bytes32 r, bytes32 s) view internal returns (uint256 nonce) {
797         nonce = nonceHolder.getNonce(token, tokenId, owner);
798         require(prepareMessage(token, tokenId, price, selling, nonce).recover(v, r, s) == owner, "incorrect signature");
799     }
800 
801     function verifyOpenAndModifyState(address token, uint256 tokenId, address payable owner, uint256 nonce, uint256 selling, uint256 buying) internal {
802         uint comp = nonceHolder.getCompleted(token, tokenId, owner, nonce).add(buying);
803         require(comp <= selling);
804         nonceHolder.setCompleted(token, tokenId, owner, nonce, comp);
805 
806         if (comp == selling) {
807             nonceHolder.setNonce(token, tokenId, owner, nonce + 1);
808             emit CloseOrder(token, tokenId, owner, nonce + 1);
809         }
810     }
811 
812     function prepareMessage(address token, uint256 tokenId, uint256 price, uint256 value, uint256 nonce) internal pure returns (string memory) {
813         return prepareMessage(token, tokenId, price, nonce)
814         .append(". value: ", value.toString());
815     }
816 }