1 /*
2 Spindle Braiding
3 Deposit Rope Here to Generate HOPE
4 */
5 
6 pragma solidity ^0.5.0;
7 
8 
9 /**
10  * @dev Standard math utilities missing in the Solidity language.
11  */
12 library Math {
13     /**
14      * @dev Returns the largest of two numbers.
15      */
16     function max(uint256 a, uint256 b) internal pure returns (uint256) {
17         return a >= b ? a : b;
18     }
19 
20     /**
21      * @dev Returns the smallest of two numbers.
22      */
23     function min(uint256 a, uint256 b) internal pure returns (uint256) {
24         return a < b ? a : b;
25     }
26 
27     /**
28      * @dev Returns the average of two numbers. The result is rounded towards
29      * zero.
30      */
31     function average(uint256 a, uint256 b) internal pure returns (uint256) {
32         // (a + b) / 2 can overflow, so we distribute
33         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
34     }
35 }
36 
37 /*
38  * @dev Provides information about the current execution context, including the
39  * sender of the transaction and its data. While these are generally available
40  * via msg.sender and msg.data, they should not be accessed in such a direct
41  * manner, since when dealing with GSN meta-transactions the account sending and
42  * paying for execution may not be the actual sender (as far as an application
43  * is concerned).
44  *
45  * This contract is only required for intermediate, library-like contracts.
46  */
47 contract Context {
48     // Empty internal constructor, to prevent people from mistakenly deploying
49     // an instance of this contract, which should be used via inheritance.
50     constructor () internal { }
51     // solhint-disable-previous-line no-empty-blocks
52 
53     function _msgSender() internal view returns (address payable) {
54         return msg.sender;
55     }
56 
57     function _msgData() internal view returns (bytes memory) {
58         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
59         return msg.data;
60     }
61 }
62 
63 /**
64  * @dev Contract module which provides a basic access control mechanism, where
65  * there is an account (an owner) that can be granted exclusive access to
66  * specific functions.
67  *
68  * This module is used through inheritance. It will make available the modifier
69  * `onlyOwner`, which can be applied to your functions to restrict their use to
70  * the owner.
71  */
72 contract Ownable is Context {
73     address private _owner;
74 
75     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
76 
77     /**
78      * @dev Initializes the contract setting the deployer as the initial owner.
79      */
80     constructor () internal {
81         address msgSender = _msgSender();
82         _owner = msgSender;
83         emit OwnershipTransferred(address(0), msgSender);
84     }
85 
86     /**
87      * @dev Returns the address of the current owner.
88      */
89     function owner() public view returns (address) {
90         return _owner;
91     }
92 
93     /**
94      * @dev Throws if called by any account other than the owner.
95      */
96     modifier onlyOwner() {
97         require(isOwner(), "Ownable: caller is not the owner");
98         _;
99     }
100 
101     /**
102      * @dev Returns true if the caller is the current owner.
103      */
104     function isOwner() public view returns (bool) {
105         return _msgSender() == _owner;
106     }
107 
108     /**
109      * @dev Leaves the contract without owner. It will not be possible to call
110      * `onlyOwner` functions anymore. Can only be called by the current owner.
111      *
112      * NOTE: Renouncing ownership will leave the contract without an owner,
113      * thereby removing any functionality that is only available to the owner.
114      */
115     function renounceOwnership() public onlyOwner {
116         emit OwnershipTransferred(_owner, address(0));
117         _owner = address(0);
118     }
119 
120     /**
121      * @dev Transfers ownership of the contract to a new account (`newOwner`).
122      * Can only be called by the current owner.
123      */
124     function transferOwnership(address newOwner) public onlyOwner {
125         _transferOwnership(newOwner);
126     }
127 
128     /**
129      * @dev Transfers ownership of the contract to a new account (`newOwner`).
130      */
131     function _transferOwnership(address newOwner) internal {
132         require(newOwner != address(0), "Ownable: new owner is the zero address");
133         emit OwnershipTransferred(_owner, newOwner);
134         _owner = newOwner;
135     }
136 }
137 
138 /**
139  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
140  * the optional functions; to access them see {ERC20Detailed}.
141  */
142 interface IERC20 {
143     /**
144      * @dev Returns the amount of tokens in existence.
145      */
146     function totalSupply() external view returns (uint256);
147 
148     /**
149      * @dev Returns the amount of tokens owned by `account`.
150      */
151     function balanceOf(address account) external view returns (uint256);
152 
153     /**
154      * @dev Moves `amount` tokens from the caller's account to `recipient`.
155      *
156      * Returns a boolean value indicating whether the operation succeeded.
157      *
158      * Emits a {Transfer} event.
159      */
160     function transfer(address recipient, uint256 amount) external returns (bool);
161 
162     /**
163      * @dev Returns the remaining number of tokens that `spender` will be
164      * allowed to spend on behalf of `owner` through {transferFrom}. This is
165      * zero by default.
166      *
167      * This value changes when {approve} or {transferFrom} are called.
168      */
169     function allowance(address owner, address spender) external view returns (uint256);
170 
171     /**
172      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
173      *
174      * Returns a boolean value indicating whether the operation succeeded.
175      *
176      * IMPORTANT: Beware that changing an allowance with this method brings the risk
177      * that someone may use both the old and the new allowance by unfortunate
178      * transaction ordering. One possible solution to mitigate this race
179      * condition is to first reduce the spender's allowance to 0 and set the
180      * desired value afterwards:
181      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
182      *
183      * Emits an {Approval} event.
184      */
185     function approve(address spender, uint256 amount) external returns (bool);
186 
187     /**
188      * @dev Moves `amount` tokens from `sender` to `recipient` using the
189      * allowance mechanism. `amount` is then deducted from the caller's
190      * allowance.
191      *
192      * Returns a boolean value indicating whether the operation succeeded.
193      *
194      * Emits a {Transfer} event.
195      */
196     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
197 
198     /**
199      * @dev Emitted when `value` tokens are moved from one account (`from`) to
200      * another (`to`).
201      *
202      * Note that `value` may be zero.
203      */
204     event Transfer(address indexed from, address indexed to, uint256 value);
205 
206     /**
207      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
208      * a call to {approve}. `value` is the new allowance.
209      */
210     event Approval(address indexed owner, address indexed spender, uint256 value);
211 }
212 
213 /**
214  * @title Roles
215  * @dev Library for managing addresses assigned to a Role.
216  */
217 library Roles {
218     struct Role {
219         mapping (address => bool) bearer;
220     }
221 
222     /**
223      * @dev Give an account access to this role.
224      */
225     function add(Role storage role, address account) internal {
226         require(!has(role, account), "Roles: account already has role");
227         role.bearer[account] = true;
228     }
229 
230     /**
231      * @dev Remove an account's access to this role.
232      */
233     function remove(Role storage role, address account) internal {
234         require(has(role, account), "Roles: account does not have role");
235         role.bearer[account] = false;
236     }
237 
238     /**
239      * @dev Check if an account has this role.
240      * @return bool
241      */
242     function has(Role storage role, address account) internal view returns (bool) {
243         require(account != address(0), "Roles: account is the zero address");
244         return role.bearer[account];
245     }
246 }
247 
248 contract MinterRole is Context {
249     using Roles for Roles.Role;
250 
251     event MinterAdded(address indexed account);
252     event MinterRemoved(address indexed account);
253 
254     Roles.Role private _minters;
255 
256     constructor () internal {
257         _addMinter(_msgSender());
258     }
259 
260     modifier onlyMinter() {
261         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
262         _;
263     }
264 
265     function isMinter(address account) public view returns (bool) {
266         return _minters.has(account);
267     }
268 
269     function addMinter(address account) public onlyMinter {
270         _addMinter(account);
271     }
272 
273     function renounceMinter() public {
274         _removeMinter(_msgSender());
275     }
276 
277     function _addMinter(address account) internal {
278         _minters.add(account);
279         emit MinterAdded(account);
280     }
281 
282     function _removeMinter(address account) internal {
283         _minters.remove(account);
284         emit MinterRemoved(account);
285     }
286 }
287 
288 /**
289  * @title WhitelistAdminRole
290  * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
291  */
292 contract WhitelistAdminRole is Context {
293     using Roles for Roles.Role;
294 
295     event WhitelistAdminAdded(address indexed account);
296     event WhitelistAdminRemoved(address indexed account);
297 
298     Roles.Role private _whitelistAdmins;
299 
300     constructor () internal {
301         _addWhitelistAdmin(_msgSender());
302     }
303 
304     modifier onlyWhitelistAdmin() {
305         require(isWhitelistAdmin(_msgSender()), "WhitelistAdminRole: caller does not have the WhitelistAdmin role");
306         _;
307     }
308 
309     function isWhitelistAdmin(address account) public view returns (bool) {
310         return _whitelistAdmins.has(account);
311     }
312 
313     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
314         _addWhitelistAdmin(account);
315     }
316 
317     function renounceWhitelistAdmin() public {
318         _removeWhitelistAdmin(_msgSender());
319     }
320 
321     function _addWhitelistAdmin(address account) internal {
322         _whitelistAdmins.add(account);
323         emit WhitelistAdminAdded(account);
324     }
325 
326     function _removeWhitelistAdmin(address account) internal {
327         _whitelistAdmins.remove(account);
328         emit WhitelistAdminRemoved(account);
329     }
330 }
331 
332 /**
333  * @title ERC165
334  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
335  */
336 interface IERC165 {
337 
338     /**
339      * @notice Query if a contract implements an interface
340      * @dev Interface identification is specified in ERC-165. This function
341      * uses less than 30,000 gas
342      * @param _interfaceId The interface identifier, as specified in ERC-165
343      */
344     function supportsInterface(bytes4 _interfaceId)
345     external
346     view
347     returns (bool);
348 }
349 
350 /**
351  * @title SafeMath
352  * @dev Unsigned math operations with safety checks that revert on error
353  */
354 library SafeMath {
355 
356     /**
357      * @dev Multiplies two unsigned integers, reverts on overflow.
358      */
359     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
360         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
361         // benefit is lost if 'b' is also tested.
362         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
363         if (a == 0) {
364             return 0;
365         }
366 
367         uint256 c = a * b;
368         require(c / a == b, "SafeMath#mul: OVERFLOW");
369 
370         return c;
371     }
372 
373     /**
374      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
375      */
376     function div(uint256 a, uint256 b) internal pure returns (uint256) {
377         // Solidity only automatically asserts when dividing by 0
378         require(b > 0, "SafeMath#div: DIVISION_BY_ZERO");
379         uint256 c = a / b;
380         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
381 
382         return c;
383     }
384 
385     /**
386      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
387      */
388     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
389         require(b <= a, "SafeMath#sub: UNDERFLOW");
390         uint256 c = a - b;
391 
392         return c;
393     }
394 
395     /**
396      * @dev Adds two unsigned integers, reverts on overflow.
397      */
398     function add(uint256 a, uint256 b) internal pure returns (uint256) {
399         uint256 c = a + b;
400         require(c >= a, "SafeMath#add: OVERFLOW");
401 
402         return c;
403     }
404 
405     /**
406      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
407      * reverts when dividing by zero.
408      */
409     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
410         require(b != 0, "SafeMath#mod: DIVISION_BY_ZERO");
411         return a % b;
412     }
413 
414 }
415 
416 /**
417  * @dev ERC-1155 interface for accepting safe transfers.
418  */
419 interface IERC1155TokenReceiver {
420 
421     /**
422      * @notice Handle the receipt of a single ERC1155 token type
423      * @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeTransferFrom` after the balance has been updated
424      * This function MAY throw to revert and reject the transfer
425      * Return of other amount than the magic value MUST result in the transaction being reverted
426      * Note: The token contract address is always the message sender
427      * @param _operator  The address which called the `safeTransferFrom` function
428      * @param _from      The address which previously owned the token
429      * @param _id        The id of the token being transferred
430      * @param _amount    The amount of tokens being transferred
431      * @param _data      Additional data with no specified format
432      * @return           `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
433      */
434     function onERC1155Received(address _operator, address _from, uint256 _id, uint256 _amount, bytes calldata _data) external returns(bytes4);
435 
436     /**
437      * @notice Handle the receipt of multiple ERC1155 token types
438      * @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeBatchTransferFrom` after the balances have been updated
439      * This function MAY throw to revert and reject the transfer
440      * Return of other amount than the magic value WILL result in the transaction being reverted
441      * Note: The token contract address is always the message sender
442      * @param _operator  The address which called the `safeBatchTransferFrom` function
443      * @param _from      The address which previously owned the token
444      * @param _ids       An array containing ids of each token being transferred
445      * @param _amounts   An array containing amounts of each token being transferred
446      * @param _data      Additional data with no specified format
447      * @return           `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
448      */
449     function onERC1155BatchReceived(address _operator, address _from, uint256[] calldata _ids, uint256[] calldata _amounts, bytes calldata _data) external returns(bytes4);
450 
451     /**
452      * @notice Indicates whether a contract implements the `ERC1155TokenReceiver` functions and so can accept ERC1155 token types.
453      * @param  interfaceID The ERC-165 interface ID that is queried for support.s
454      * @dev This function MUST return true if it implements the ERC1155TokenReceiver interface and ERC-165 interface.
455      *      This function MUST NOT consume more than 5,000 gas.
456      * @return Wheter ERC-165 or ERC1155TokenReceiver interfaces are supported.
457      */
458     function supportsInterface(bytes4 interfaceID) external view returns (bool);
459 
460 }
461 
462 interface IERC1155 {
463     // Events
464 
465     /**
466      * @dev Either TransferSingle or TransferBatch MUST emit when tokens are transferred, including zero amount transfers as well as minting or burning
467      *   Operator MUST be msg.sender
468      *   When minting/creating tokens, the `_from` field MUST be set to `0x0`
469      *   When burning/destroying tokens, the `_to` field MUST be set to `0x0`
470      *   The total amount transferred from address 0x0 minus the total amount transferred to 0x0 may be used by clients and exchanges to be added to the "circulating supply" for a given token ID
471      *   To broadcast the existence of a token ID with no initial balance, the contract SHOULD emit the TransferSingle event from `0x0` to `0x0`, with the token creator as `_operator`, and a `_amount` of 0
472      */
473     event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _amount);
474 
475     /**
476      * @dev Either TransferSingle or TransferBatch MUST emit when tokens are transferred, including zero amount transfers as well as minting or burning
477      *   Operator MUST be msg.sender
478      *   When minting/creating tokens, the `_from` field MUST be set to `0x0`
479      *   When burning/destroying tokens, the `_to` field MUST be set to `0x0`
480      *   The total amount transferred from address 0x0 minus the total amount transferred to 0x0 may be used by clients and exchanges to be added to the "circulating supply" for a given token ID
481      *   To broadcast the existence of multiple token IDs with no initial balance, this SHOULD emit the TransferBatch event from `0x0` to `0x0`, with the token creator as `_operator`, and a `_amount` of 0
482      */
483     event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _amounts);
484 
485     /**
486      * @dev MUST emit when an approval is updated
487      */
488     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
489 
490     /**
491      * @dev MUST emit when the URI is updated for a token ID
492      *   URIs are defined in RFC 3986
493      *   The URI MUST point a JSON file that conforms to the "ERC-1155 Metadata JSON Schema"
494      */
495     event URI(string _amount, uint256 indexed _id);
496 
497     /**
498      * @notice Transfers amount of an _id from the _from address to the _to address specified
499      * @dev MUST emit TransferSingle event on success
500      * Caller must be approved to manage the _from account's tokens (see isApprovedForAll)
501      * MUST throw if `_to` is the zero address
502      * MUST throw if balance of sender for token `_id` is lower than the `_amount` sent
503      * MUST throw on any other error
504      * When transfer is complete, this function MUST check if `_to` is a smart contract (code size > 0). If so, it MUST call `onERC1155Received` on `_to` and revert if the return amount is not `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
505      * @param _from    Source address
506      * @param _to      Target address
507      * @param _id      ID of the token type
508      * @param _amount  Transfered amount
509      * @param _data    Additional data with no specified format, sent in call to `_to`
510      */
511     function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount, bytes calldata _data) external;
512 
513     /**
514      * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
515      * @dev MUST emit TransferBatch event on success
516      * Caller must be approved to manage the _from account's tokens (see isApprovedForAll)
517      * MUST throw if `_to` is the zero address
518      * MUST throw if length of `_ids` is not the same as length of `_amounts`
519      * MUST throw if any of the balance of sender for token `_ids` is lower than the respective `_amounts` sent
520      * MUST throw on any other error
521      * When transfer is complete, this function MUST check if `_to` is a smart contract (code size > 0). If so, it MUST call `onERC1155BatchReceived` on `_to` and revert if the return amount is not `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
522      * Transfers and events MUST occur in the array order they were submitted (_ids[0] before _ids[1], etc)
523      * @param _from     Source addresses
524      * @param _to       Target addresses
525      * @param _ids      IDs of each token type
526      * @param _amounts  Transfer amounts per token type
527      * @param _data     Additional data with no specified format, sent in call to `_to`
528     */
529     function safeBatchTransferFrom(address _from, address _to, uint256[] calldata _ids, uint256[] calldata _amounts, bytes calldata _data) external;
530 
531     /**
532      * @notice Get the balance of an account's Tokens
533      * @param _owner  The address of the token holder
534      * @param _id     ID of the Token
535      * @return        The _owner's balance of the Token type requested
536      */
537     function balanceOf(address _owner, uint256 _id) external view returns (uint256);
538 
539     /**
540      * @notice Get the balance of multiple account/token pairs
541      * @param _owners The addresses of the token holders
542      * @param _ids    ID of the Tokens
543      * @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)
544      */
545     function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids) external view returns (uint256[] memory);
546 
547     /**
548      * @notice Enable or disable approval for a third party ("operator") to manage all of caller's tokens
549      * @dev MUST emit the ApprovalForAll event on success
550      * @param _operator  Address to add to the set of authorized operators
551      * @param _approved  True if the operator is approved, false to revoke approval
552      */
553     function setApprovalForAll(address _operator, bool _approved) external;
554 
555     /**
556      * @notice Queries the approval status of an operator for a given owner
557      * @param _owner     The owner of the Tokens
558      * @param _operator  Address of authorized operator
559      * @return           True if the operator is approved, false if not
560      */
561     function isApprovedForAll(address _owner, address _operator) external view returns (bool isOperator);
562 
563 }
564 
565 /**
566  * Copyright 2018 ZeroEx Intl.
567  * Licensed under the Apache License, Version 2.0 (the "License");
568  * you may not use this file except in compliance with the License.
569  * You may obtain a copy of the License at
570  *   http://www.apache.org/licenses/LICENSE-2.0
571  * Unless required by applicable law or agreed to in writing, software
572  * distributed under the License is distributed on an "AS IS" BASIS,
573  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
574  * See the License for the specific language governing permissions and
575  * limitations under the License.
576  */
577 /**
578  * Utility library of inline functions on addresses
579  */
580 library Address {
581 
582     /**
583      * Returns whether the target address is a contract
584      * @dev This function will return false if invoked during the constructor of a contract,
585      * as the code is not actually created until after the constructor finishes.
586      * @param account address of the account to check
587      * @return whether the target address is a contract
588      */
589     function isContract(address account) internal view returns (bool) {
590         bytes32 codehash;
591         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
592 
593         // XXX Currently there is no better way to check if there is a contract in an address
594         // than to check the size of the code at that address.
595         // See https://ethereum.stackexchange.com/a/14016/36603
596         // for more details about how this works.
597         // TODO Check this again before the Serenity release, because all addresses will be
598         // contracts then.
599         assembly { codehash := extcodehash(account) }
600         return (codehash != 0x0 && codehash != accountHash);
601     }
602 
603 }
604 
605 /**
606  * @dev Implementation of Multi-Token Standard contract
607  */
608 contract ERC1155 is IERC165 {
609     using SafeMath for uint256;
610     using Address for address;
611 
612 
613     /***********************************|
614     |        Variables and Events       |
615     |__________________________________*/
616 
617     // onReceive function signatures
618     bytes4 constant internal ERC1155_RECEIVED_VALUE = 0xf23a6e61;
619     bytes4 constant internal ERC1155_BATCH_RECEIVED_VALUE = 0xbc197c81;
620 
621     // Objects balances
622     mapping (address => mapping(uint256 => uint256)) internal balances;
623 
624     // Operator Functions
625     mapping (address => mapping(address => bool)) internal operators;
626 
627     // Events
628     event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _amount);
629     event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _amounts);
630     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
631     event URI(string _uri, uint256 indexed _id);
632 
633 
634     /***********************************|
635     |     Public Transfer Functions     |
636     |__________________________________*/
637 
638     /**
639      * @notice Transfers amount amount of an _id from the _from address to the _to address specified
640      * @param _from    Source address
641      * @param _to      Target address
642      * @param _id      ID of the token type
643      * @param _amount  Transfered amount
644      * @param _data    Additional data with no specified format, sent in call to `_to`
645      */
646     function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount, bytes memory _data)
647     public
648     {
649         require((msg.sender == _from) || isApprovedForAll(_from, msg.sender), "ERC1155#safeTransferFrom: INVALID_OPERATOR");
650         require(_to != address(0),"ERC1155#safeTransferFrom: INVALID_RECIPIENT");
651         // require(_amount >= balances[_from][_id]) is not necessary since checked with safemath operations
652 
653         _safeTransferFrom(_from, _to, _id, _amount);
654         _callonERC1155Received(_from, _to, _id, _amount, _data);
655     }
656 
657     /**
658      * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
659      * @param _from     Source addresses
660      * @param _to       Target addresses
661      * @param _ids      IDs of each token type
662      * @param _amounts  Transfer amounts per token type
663      * @param _data     Additional data with no specified format, sent in call to `_to`
664      */
665     function safeBatchTransferFrom(address _from, address _to, uint256[] memory _ids, uint256[] memory _amounts, bytes memory _data)
666     public
667     {
668         // Requirements
669         require((msg.sender == _from) || isApprovedForAll(_from, msg.sender), "ERC1155#safeBatchTransferFrom: INVALID_OPERATOR");
670         require(_to != address(0), "ERC1155#safeBatchTransferFrom: INVALID_RECIPIENT");
671 
672         _safeBatchTransferFrom(_from, _to, _ids, _amounts);
673         _callonERC1155BatchReceived(_from, _to, _ids, _amounts, _data);
674     }
675 
676 
677     /***********************************|
678     |    Internal Transfer Functions    |
679     |__________________________________*/
680 
681     /**
682      * @notice Transfers amount amount of an _id from the _from address to the _to address specified
683      * @param _from    Source address
684      * @param _to      Target address
685      * @param _id      ID of the token type
686      * @param _amount  Transfered amount
687      */
688     function _safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount)
689     internal
690     {
691         // Update balances
692         balances[_from][_id] = balances[_from][_id].sub(_amount); // Subtract amount
693         balances[_to][_id] = balances[_to][_id].add(_amount);     // Add amount
694 
695         // Emit event
696         emit TransferSingle(msg.sender, _from, _to, _id, _amount);
697     }
698 
699     /**
700      * @notice Verifies if receiver is contract and if so, calls (_to).onERC1155Received(...)
701      */
702     function _callonERC1155Received(address _from, address _to, uint256 _id, uint256 _amount, bytes memory _data)
703     internal
704     {
705         // Check if recipient is contract
706         if (_to.isContract()) {
707             bytes4 retval = IERC1155TokenReceiver(_to).onERC1155Received(msg.sender, _from, _id, _amount, _data);
708             require(retval == ERC1155_RECEIVED_VALUE, "ERC1155#_callonERC1155Received: INVALID_ON_RECEIVE_MESSAGE");
709         }
710     }
711 
712     /**
713      * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
714      * @param _from     Source addresses
715      * @param _to       Target addresses
716      * @param _ids      IDs of each token type
717      * @param _amounts  Transfer amounts per token type
718      */
719     function _safeBatchTransferFrom(address _from, address _to, uint256[] memory _ids, uint256[] memory _amounts)
720     internal
721     {
722         require(_ids.length == _amounts.length, "ERC1155#_safeBatchTransferFrom: INVALID_ARRAYS_LENGTH");
723 
724         // Number of transfer to execute
725         uint256 nTransfer = _ids.length;
726 
727         // Executing all transfers
728         for (uint256 i = 0; i < nTransfer; i++) {
729             // Update storage balance of previous bin
730             balances[_from][_ids[i]] = balances[_from][_ids[i]].sub(_amounts[i]);
731             balances[_to][_ids[i]] = balances[_to][_ids[i]].add(_amounts[i]);
732         }
733 
734         // Emit event
735         emit TransferBatch(msg.sender, _from, _to, _ids, _amounts);
736     }
737 
738     /**
739      * @notice Verifies if receiver is contract and if so, calls (_to).onERC1155BatchReceived(...)
740      */
741     function _callonERC1155BatchReceived(address _from, address _to, uint256[] memory _ids, uint256[] memory _amounts, bytes memory _data)
742     internal
743     {
744         // Pass data if recipient is contract
745         if (_to.isContract()) {
746             bytes4 retval = IERC1155TokenReceiver(_to).onERC1155BatchReceived(msg.sender, _from, _ids, _amounts, _data);
747             require(retval == ERC1155_BATCH_RECEIVED_VALUE, "ERC1155#_callonERC1155BatchReceived: INVALID_ON_RECEIVE_MESSAGE");
748         }
749     }
750 
751 
752     /***********************************|
753     |         Operator Functions        |
754     |__________________________________*/
755 
756     /**
757      * @notice Enable or disable approval for a third party ("operator") to manage all of caller's tokens
758      * @param _operator  Address to add to the set of authorized operators
759      * @param _approved  True if the operator is approved, false to revoke approval
760      */
761     function setApprovalForAll(address _operator, bool _approved)
762     external
763     {
764         // Update operator status
765         operators[msg.sender][_operator] = _approved;
766         emit ApprovalForAll(msg.sender, _operator, _approved);
767     }
768 
769     /**
770      * @notice Queries the approval status of an operator for a given owner
771      * @param _owner     The owner of the Tokens
772      * @param _operator  Address of authorized operator
773      * @return True if the operator is approved, false if not
774      */
775     function isApprovedForAll(address _owner, address _operator)
776     public view returns (bool isOperator)
777     {
778         return operators[_owner][_operator];
779     }
780 
781 
782     /***********************************|
783     |         Balance Functions         |
784     |__________________________________*/
785 
786     /**
787      * @notice Get the balance of an account's Tokens
788      * @param _owner  The address of the token holder
789      * @param _id     ID of the Token
790      * @return The _owner's balance of the Token type requested
791      */
792     function balanceOf(address _owner, uint256 _id)
793     public view returns (uint256)
794     {
795         return balances[_owner][_id];
796     }
797 
798     /**
799      * @notice Get the balance of multiple account/token pairs
800      * @param _owners The addresses of the token holders
801      * @param _ids    ID of the Tokens
802      * @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)
803      */
804     function balanceOfBatch(address[] memory _owners, uint256[] memory _ids)
805     public view returns (uint256[] memory)
806     {
807         require(_owners.length == _ids.length, "ERC1155#balanceOfBatch: INVALID_ARRAY_LENGTH");
808 
809         // Variables
810         uint256[] memory batchBalances = new uint256[](_owners.length);
811 
812         // Iterate over each owner and token ID
813         for (uint256 i = 0; i < _owners.length; i++) {
814             batchBalances[i] = balances[_owners[i]][_ids[i]];
815         }
816 
817         return batchBalances;
818     }
819 
820 
821     /***********************************|
822     |          ERC165 Functions         |
823     |__________________________________*/
824 
825     /**
826      * INTERFACE_SIGNATURE_ERC165 = bytes4(keccak256("supportsInterface(bytes4)"));
827      */
828     bytes4 constant private INTERFACE_SIGNATURE_ERC165 = 0x01ffc9a7;
829 
830     /**
831      * INTERFACE_SIGNATURE_ERC1155 =
832      * bytes4(keccak256("safeTransferFrom(address,address,uint256,uint256,bytes)")) ^
833      * bytes4(keccak256("safeBatchTransferFrom(address,address,uint256[],uint256[],bytes)")) ^
834      * bytes4(keccak256("balanceOf(address,uint256)")) ^
835      * bytes4(keccak256("balanceOfBatch(address[],uint256[])")) ^
836      * bytes4(keccak256("setApprovalForAll(address,bool)")) ^
837      * bytes4(keccak256("isApprovedForAll(address,address)"));
838      */
839     bytes4 constant private INTERFACE_SIGNATURE_ERC1155 = 0xd9b67a26;
840 
841     /**
842      * @notice Query if a contract implements an interface
843      * @param _interfaceID  The interface identifier, as specified in ERC-165
844      * @return `true` if the contract implements `_interfaceID` and
845      */
846     function supportsInterface(bytes4 _interfaceID) external view returns (bool) {
847         if (_interfaceID == INTERFACE_SIGNATURE_ERC165 ||
848             _interfaceID == INTERFACE_SIGNATURE_ERC1155) {
849             return true;
850         }
851         return false;
852     }
853 
854 }
855 
856 /**
857  * @notice Contract that handles metadata related methods.
858  * @dev Methods assume a deterministic generation of URI based on token IDs.
859  *      Methods also assume that URI uses hex representation of token IDs.
860  */
861 contract ERC1155Metadata {
862 
863     // URI's default URI prefix
864     string internal baseMetadataURI;
865     event URI(string _uri, uint256 indexed _id);
866 
867 
868     /***********************************|
869     |     Metadata Public Function s    |
870     |__________________________________*/
871 
872     /**
873      * @notice A distinct Uniform Resource Identifier (URI) for a given token.
874      * @dev URIs are defined in RFC 3986.
875      *      URIs are assumed to be deterministically generated based on token ID
876      *      Token IDs are assumed to be represented in their hex format in URIs
877      * @return URI string
878      */
879     function uri(uint256 _id) public view returns (string memory) {
880         return string(abi.encodePacked(baseMetadataURI, _uint2str(_id), ".json"));
881     }
882 
883 
884     /***********************************|
885     |    Metadata Internal Functions    |
886     |__________________________________*/
887 
888     /**
889      * @notice Will emit default URI log event for corresponding token _id
890      * @param _tokenIDs Array of IDs of tokens to log default URI
891      */
892     function _logURIs(uint256[] memory _tokenIDs) internal {
893         string memory baseURL = baseMetadataURI;
894         string memory tokenURI;
895 
896         for (uint256 i = 0; i < _tokenIDs.length; i++) {
897             tokenURI = string(abi.encodePacked(baseURL, _uint2str(_tokenIDs[i]), ".json"));
898             emit URI(tokenURI, _tokenIDs[i]);
899         }
900     }
901 
902     /**
903      * @notice Will emit a specific URI log event for corresponding token
904      * @param _tokenIDs IDs of the token corresponding to the _uris logged
905      * @param _URIs    The URIs of the specified _tokenIDs
906      */
907     function _logURIs(uint256[] memory _tokenIDs, string[] memory _URIs) internal {
908         require(_tokenIDs.length == _URIs.length, "ERC1155Metadata#_logURIs: INVALID_ARRAYS_LENGTH");
909         for (uint256 i = 0; i < _tokenIDs.length; i++) {
910             emit URI(_URIs[i], _tokenIDs[i]);
911         }
912     }
913 
914     /**
915      * @notice Will update the base URL of token's URI
916      * @param _newBaseMetadataURI New base URL of token's URI
917      */
918     function _setBaseMetadataURI(string memory _newBaseMetadataURI) internal {
919         baseMetadataURI = _newBaseMetadataURI;
920     }
921 
922 
923     /***********************************|
924     |    Utility Internal Functions     |
925     |__________________________________*/
926 
927     /**
928      * @notice Convert uint256 to string
929      * @param _i Unsigned integer to convert to string
930      */
931     function _uint2str(uint256 _i) internal pure returns (string memory _uintAsString) {
932         if (_i == 0) {
933             return "0";
934         }
935 
936         uint256 j = _i;
937         uint256 ii = _i;
938         uint256 len;
939 
940         // Get number of bytes
941         while (j != 0) {
942             len++;
943             j /= 10;
944         }
945 
946         bytes memory bstr = new bytes(len);
947         uint256 k = len - 1;
948 
949         // Get each individual ASCII
950         while (ii != 0) {
951             bstr[k--] = byte(uint8(48 + ii % 10));
952             ii /= 10;
953         }
954 
955         // Convert to string
956         return string(bstr);
957     }
958 
959 }
960 
961 /**
962  * @dev Multi-Fungible Tokens with minting and burning methods. These methods assume
963  *      a parent contract to be executed as they are `internal` functions
964  */
965 contract ERC1155MintBurn is ERC1155 {
966 
967 
968     /****************************************|
969     |            Minting Functions           |
970     |_______________________________________*/
971 
972     /**
973      * @notice Mint _amount of tokens of a given id
974      * @param _to      The address to mint tokens to
975      * @param _id      Token id to mint
976      * @param _amount  The amount to be minted
977      * @param _data    Data to pass if receiver is contract
978      */
979     function _mint(address _to, uint256 _id, uint256 _amount, bytes memory _data)
980     internal
981     {
982         // Add _amount
983         balances[_to][_id] = balances[_to][_id].add(_amount);
984 
985         // Emit event
986         emit TransferSingle(msg.sender, address(0x0), _to, _id, _amount);
987 
988         // Calling onReceive method if recipient is contract
989         _callonERC1155Received(address(0x0), _to, _id, _amount, _data);
990     }
991 
992     /**
993      * @notice Mint tokens for each ids in _ids
994      * @param _to       The address to mint tokens to
995      * @param _ids      Array of ids to mint
996      * @param _amounts  Array of amount of tokens to mint per id
997      * @param _data    Data to pass if receiver is contract
998      */
999     function _batchMint(address _to, uint256[] memory _ids, uint256[] memory _amounts, bytes memory _data)
1000     internal
1001     {
1002         require(_ids.length == _amounts.length, "ERC1155MintBurn#batchMint: INVALID_ARRAYS_LENGTH");
1003 
1004         // Number of mints to execute
1005         uint256 nMint = _ids.length;
1006 
1007         // Executing all minting
1008         for (uint256 i = 0; i < nMint; i++) {
1009             // Update storage balance
1010             balances[_to][_ids[i]] = balances[_to][_ids[i]].add(_amounts[i]);
1011         }
1012 
1013         // Emit batch mint event
1014         emit TransferBatch(msg.sender, address(0x0), _to, _ids, _amounts);
1015 
1016         // Calling onReceive method if recipient is contract
1017         _callonERC1155BatchReceived(address(0x0), _to, _ids, _amounts, _data);
1018     }
1019 
1020 
1021     /****************************************|
1022     |            Burning Functions           |
1023     |_______________________________________*/
1024 
1025     /**
1026      * @notice Burn _amount of tokens of a given token id
1027      * @param _from    The address to burn tokens from
1028      * @param _id      Token id to burn
1029      * @param _amount  The amount to be burned
1030      */
1031     function _burn(address _from, uint256 _id, uint256 _amount)
1032     internal
1033     {
1034         //Substract _amount
1035         balances[_from][_id] = balances[_from][_id].sub(_amount);
1036 
1037         // Emit event
1038         emit TransferSingle(msg.sender, _from, address(0x0), _id, _amount);
1039     }
1040 
1041     /**
1042      * @notice Burn tokens of given token id for each (_ids[i], _amounts[i]) pair
1043      * @param _from     The address to burn tokens from
1044      * @param _ids      Array of token ids to burn
1045      * @param _amounts  Array of the amount to be burned
1046      */
1047     function _batchBurn(address _from, uint256[] memory _ids, uint256[] memory _amounts)
1048     internal
1049     {
1050         require(_ids.length == _amounts.length, "ERC1155MintBurn#batchBurn: INVALID_ARRAYS_LENGTH");
1051 
1052         // Number of mints to execute
1053         uint256 nBurn = _ids.length;
1054 
1055         // Executing all minting
1056         for (uint256 i = 0; i < nBurn; i++) {
1057             // Update storage balance
1058             balances[_from][_ids[i]] = balances[_from][_ids[i]].sub(_amounts[i]);
1059         }
1060 
1061         // Emit batch mint event
1062         emit TransferBatch(msg.sender, _from, address(0x0), _ids, _amounts);
1063     }
1064 
1065 }
1066 
1067 library Strings {
1068     // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
1069     function strConcat(
1070         string memory _a,
1071         string memory _b,
1072         string memory _c,
1073         string memory _d,
1074         string memory _e
1075     ) internal pure returns (string memory) {
1076         bytes memory _ba = bytes(_a);
1077         bytes memory _bb = bytes(_b);
1078         bytes memory _bc = bytes(_c);
1079         bytes memory _bd = bytes(_d);
1080         bytes memory _be = bytes(_e);
1081         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
1082         bytes memory babcde = bytes(abcde);
1083         uint256 k = 0;
1084         for (uint256 i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
1085         for (uint256 i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
1086         for (uint256 i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
1087         for (uint256 i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
1088         for (uint256 i = 0; i < _be.length; i++) babcde[k++] = _be[i];
1089         return string(babcde);
1090     }
1091 
1092     function strConcat(
1093         string memory _a,
1094         string memory _b,
1095         string memory _c,
1096         string memory _d
1097     ) internal pure returns (string memory) {
1098         return strConcat(_a, _b, _c, _d, "");
1099     }
1100 
1101     function strConcat(
1102         string memory _a,
1103         string memory _b,
1104         string memory _c
1105     ) internal pure returns (string memory) {
1106         return strConcat(_a, _b, _c, "", "");
1107     }
1108 
1109     function strConcat(string memory _a, string memory _b) internal pure returns (string memory) {
1110         return strConcat(_a, _b, "", "", "");
1111     }
1112 
1113     function uint2str(uint256 _i) internal pure returns (string memory _uintAsString) {
1114         if (_i == 0) {
1115             return "0";
1116         }
1117         uint256 j = _i;
1118         uint256 len;
1119         while (j != 0) {
1120             len++;
1121             j /= 10;
1122         }
1123         bytes memory bstr = new bytes(len);
1124         uint256 k = len - 1;
1125         while (_i != 0) {
1126             bstr[k--] = bytes1(uint8(48 + (_i % 10)));
1127             _i /= 10;
1128         }
1129         return string(bstr);
1130     }
1131 }
1132 
1133 contract OwnableDelegateProxy {}
1134 
1135 contract ProxyRegistry {
1136     mapping(address => OwnableDelegateProxy) public proxies;
1137 }
1138 
1139 /**
1140  * @title ERC1155Tradable
1141  * ERC1155Tradable - ERC1155 contract that whitelists an operator address,
1142  * has create and mint functionality, and supports useful standards from OpenZeppelin,
1143   like _exists(), name(), symbol(), and totalSupply()
1144  */
1145 contract ERC1155Tradable is ERC1155, ERC1155MintBurn, ERC1155Metadata, Ownable, MinterRole, WhitelistAdminRole {
1146     using Strings for string;
1147 
1148     address proxyRegistryAddress;
1149     uint256 private _currentTokenID = 0;
1150     mapping(uint256 => address) public creators;
1151     mapping(uint256 => uint256) public tokenSupply;
1152     mapping(uint256 => uint256) public tokenMaxSupply;
1153     // Contract name
1154     string public name;
1155     // Contract symbol
1156     string public symbol;
1157 
1158     constructor(
1159         string memory _name,
1160         string memory _symbol,
1161         address _proxyRegistryAddress
1162     ) public {
1163         name = _name;
1164         symbol = _symbol;
1165         proxyRegistryAddress = _proxyRegistryAddress;
1166     }
1167 
1168     function removeWhitelistAdmin(address account) public onlyOwner {
1169         _removeWhitelistAdmin(account);
1170     }
1171 
1172     function removeMinter(address account) public onlyOwner {
1173         _removeMinter(account);
1174     }
1175 
1176     function uri(uint256 _id) public view returns (string memory) {
1177         require(_exists(_id), "ERC721Tradable#uri: NONEXISTENT_TOKEN");
1178         return Strings.strConcat(baseMetadataURI, Strings.uint2str(_id));
1179     }
1180 
1181     /**
1182      * @dev Returns the total quantity for a token ID
1183      * @param _id uint256 ID of the token to query
1184      * @return amount of token in existence
1185      */
1186     function totalSupply(uint256 _id) public view returns (uint256) {
1187         return tokenSupply[_id];
1188     }
1189 
1190     /**
1191      * @dev Returns the max quantity for a token ID
1192      * @param _id uint256 ID of the token to query
1193      * @return amount of token in existence
1194      */
1195     function maxSupply(uint256 _id) public view returns (uint256) {
1196         return tokenMaxSupply[_id];
1197     }
1198 
1199     /**
1200      * @dev Will update the base URL of token's URI
1201      * @param _newBaseMetadataURI New base URL of token's URI
1202      */
1203     function setBaseMetadataURI(string memory _newBaseMetadataURI) public onlyWhitelistAdmin {
1204         _setBaseMetadataURI(_newBaseMetadataURI);
1205     }
1206 
1207     /**
1208      * @dev Creates a new token type and assigns _initialSupply to an address
1209      * @param _maxSupply max supply allowed
1210      * @param _initialSupply Optional amount to supply the first owner
1211      * @param _uri Optional URI for this token type
1212      * @param _data Optional data to pass if receiver is contract
1213      * @return The newly created token ID
1214      */
1215     function create(
1216         uint256 _maxSupply,
1217         uint256 _initialSupply,
1218         string calldata _uri,
1219         bytes calldata _data
1220     ) external onlyWhitelistAdmin returns (uint256 tokenId) {
1221         require(_initialSupply <= _maxSupply, "Initial supply cannot be more than max supply");
1222         uint256 _id = _getNextTokenID();
1223         _incrementTokenTypeId();
1224         creators[_id] = msg.sender;
1225 
1226         if (bytes(_uri).length > 0) {
1227             emit URI(_uri, _id);
1228         }
1229 
1230         if (_initialSupply != 0) _mint(msg.sender, _id, _initialSupply, _data);
1231         tokenSupply[_id] = _initialSupply;
1232         tokenMaxSupply[_id] = _maxSupply;
1233         return _id;
1234     }
1235 
1236     /**
1237      * @dev Mints some amount of tokens to an address
1238      * @param _to          Address of the future owner of the token
1239      * @param _id          Token ID to mint
1240      * @param _quantity    Amount of tokens to mint
1241      * @param _data        Data to pass if receiver is contract
1242      */
1243     function mint(
1244         address _to,
1245         uint256 _id,
1246         uint256 _quantity,
1247         bytes memory _data
1248     ) public onlyMinter {
1249         uint256 tokenId = _id;
1250         require(tokenSupply[tokenId] < tokenMaxSupply[tokenId], "Max supply reached");
1251         _mint(_to, _id, _quantity, _data);
1252         tokenSupply[_id] = tokenSupply[_id].add(_quantity);
1253     }
1254 
1255     /**
1256      * Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-free listings.
1257      */
1258     function isApprovedForAll(address _owner, address _operator) public view returns (bool isOperator) {
1259         // Whitelist OpenSea proxy contract for easy trading.
1260         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1261         if (address(proxyRegistry.proxies(_owner)) == _operator) {
1262             return true;
1263         }
1264 
1265         return ERC1155.isApprovedForAll(_owner, _operator);
1266     }
1267 
1268     /**
1269      * @dev Returns whether the specified token exists by checking to see if it has a creator
1270      * @param _id uint256 ID of the token to query the existence of
1271      * @return bool whether the token exists
1272      */
1273     function _exists(uint256 _id) internal view returns (bool) {
1274         return creators[_id] != address(0);
1275     }
1276 
1277     /**
1278      * @dev calculates the next token ID based on value of _currentTokenID
1279      * @return uint256 for the next token ID
1280      */
1281     function _getNextTokenID() private view returns (uint256) {
1282         return _currentTokenID.add(1);
1283     }
1284 
1285     /**
1286      * @dev increments the value of _currentTokenID
1287      */
1288     function _incrementTokenTypeId() private {
1289         _currentTokenID++;
1290     }
1291 }
1292 
1293 contract HopeNonTradable is Ownable, MinterRole {
1294     using SafeMath for uint256;
1295     event Transfer(address indexed from, address indexed to, uint256 value);
1296 
1297     mapping (address => uint256) private _balances;
1298 
1299     uint256 private _totalSupply;
1300     string public name = "$HOPE - Non Tradable";
1301     string public symbol = "$HOPE";
1302     uint8 public decimals = 18;
1303 
1304     /**
1305      * @dev Total number of tokens in existence.
1306      */
1307     function totalSupply() public view returns (uint256) {
1308         return _totalSupply;
1309     }
1310 
1311     /**
1312      * @dev Gets the balance of the specified address.
1313      * @param owner The address to query the balance of.
1314      * @return A uint256 representing the amount owned by the passed address.
1315      */
1316     function balanceOf(address owner) public view returns (uint256) {
1317         return _balances[owner];
1318     }
1319 
1320     function mint(address _to, uint256 _amount) public onlyMinter {
1321         _mint(_to, _amount);
1322     }
1323 
1324     function burn(address _account, uint256 value) public onlyMinter {
1325         require(_balances[_account] >= value, "Cannot burn more than address has");
1326         _burn(_account, value);
1327     }
1328 
1329     /**
1330      * @dev Internal function that mints an amount of the token and assigns it to
1331      * an account. This encapsulates the modification of balances such that the
1332      * proper events are emitted.
1333      * @param account The account that will receive the created tokens.
1334      * @param value The amount that will be created.
1335      */
1336     function _mint(address account, uint256 value) internal {
1337         require(account != address(0), "ERC20: mint to the zero address");
1338 
1339         _totalSupply = _totalSupply.add(value);
1340         _balances[account] = _balances[account].add(value);
1341         emit Transfer(address(0), account, value);
1342     }
1343 
1344     /**
1345      * @dev Internal function that burns an amount of the token of a given
1346      * account.
1347      * @param account The account whose tokens will be burnt.
1348      * @param value The amount that will be burnt.
1349      */
1350     function _burn(address account, uint256 value) internal {
1351         require(account != address(0), "ERC20: burn from the zero address");
1352 
1353         _totalSupply = _totalSupply.sub(value);
1354         _balances[account] = _balances[account].sub(value);
1355         emit Transfer(account, address(0), value);
1356     }
1357 }
1358 
1359 contract HopeVendingMachine is Ownable {
1360     ERC1155Tradable public RMU;
1361     HopeNonTradable public Hope;
1362     mapping(uint256 => uint256) public cardCosts;
1363 
1364     event CardAdded(uint256 card, uint256 points);
1365     event Redeemed(address indexed user, uint256 amount);
1366 
1367     constructor(ERC1155Tradable _RMUAddress, HopeNonTradable _hopeAddress) public {
1368         RMU = _RMUAddress;
1369         Hope = _hopeAddress;
1370     }
1371 
1372     function addCard(uint256 cardId, uint256 amount) public onlyOwner {
1373         cardCosts[cardId] = amount;
1374         emit CardAdded(cardId, amount);
1375     }
1376 
1377     function redeem(uint256 card) public {
1378         require(cardCosts[card] != 0, "Card not found");
1379         require(Hope.balanceOf(msg.sender) >= cardCosts[card], "Not enough points to redeem for card");
1380         require(RMU.totalSupply(card) < RMU.maxSupply(card), "Max cards minted");
1381 
1382         Hope.burn(msg.sender, cardCosts[card]);
1383         RMU.mint(msg.sender, card, 1, "");
1384         emit Redeemed(msg.sender, cardCosts[card]);
1385     }
1386 }