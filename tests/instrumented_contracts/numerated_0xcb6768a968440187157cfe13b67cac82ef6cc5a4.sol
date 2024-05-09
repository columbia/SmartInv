1 // File: contracts/PepemonFactory.sol
2 
3 pragma solidity >=0.5.0 <0.6.0;
4 
5 
6 contract Context {
7     // Empty internal constructor, to prevent people from mistakenly deploying
8     // an instance of this contract, which should be used via inheritance.
9     constructor () internal { }
10     // solhint-disable-previous-line no-empty-blocks
11 
12     function _msgSender() internal view returns (address payable) {
13         return msg.sender;
14     }
15 
16     function _msgData() internal view returns (bytes memory) {
17         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
18         return msg.data;
19     }
20 }
21 
22 /**
23  * @dev Contract module which provides a basic access control mechanism, where
24  * there is an account (an owner) that can be granted exclusive access to
25  * specific functions.
26  *
27  * This module is used through inheritance. It will make available the modifier
28  * `onlyOwner`, which can be applied to your functions to restrict their use to
29  * the owner.
30  */
31 contract Ownable is Context {
32     address private _owner;
33 
34     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
35 
36     /**
37      * @dev Initializes the contract setting the deployer as the initial owner.
38      */
39     constructor () internal {
40         address msgSender = _msgSender();
41         _owner = msgSender;
42         emit OwnershipTransferred(address(0), msgSender);
43     }
44 
45     /**
46      * @dev Returns the address of the current owner.
47      */
48     function owner() public view returns (address) {
49         return _owner;
50     }
51 
52     /**
53      * @dev Throws if called by any account other than the owner.
54      */
55     modifier onlyOwner() {
56         require(isOwner(), "Ownable: caller is not the owner");
57         _;
58     }
59 
60     /**
61      * @dev Returns true if the caller is the current owner.
62      */
63     function isOwner() public view returns (bool) {
64         return _msgSender() == _owner;
65     }
66 
67     /**
68      * @dev Leaves the contract without owner. It will not be possible to call
69      * `onlyOwner` functions anymore. Can only be called by the current owner.
70      *
71      * NOTE: Renouncing ownership will leave the contract without an owner,
72      * thereby removing any functionality that is only available to the owner.
73      */
74     function renounceOwnership() public onlyOwner {
75         emit OwnershipTransferred(_owner, address(0));
76         _owner = address(0);
77     }
78 
79     /**
80      * @dev Transfers ownership of the contract to a new account (`newOwner`).
81      * Can only be called by the current owner.
82      */
83     function transferOwnership(address newOwner) public onlyOwner {
84         _transferOwnership(newOwner);
85     }
86 
87     /**
88      * @dev Transfers ownership of the contract to a new account (`newOwner`).
89      */
90     function _transferOwnership(address newOwner) internal {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         emit OwnershipTransferred(_owner, newOwner);
93         _owner = newOwner;
94     }
95 }
96 
97 /**
98  * @title Roles
99  * @dev Library for managing addresses assigned to a Role.
100  */
101 library Roles {
102     struct Role {
103         mapping (address => bool) bearer;
104     }
105 
106     /**
107      * @dev Give an account access to this role.
108      */
109     function add(Role storage role, address account) internal {
110         require(!has(role, account), "Roles: account already has role");
111         role.bearer[account] = true;
112     }
113 
114     /**
115      * @dev Remove an account's access to this role.
116      */
117     function remove(Role storage role, address account) internal {
118         require(has(role, account), "Roles: account does not have role");
119         role.bearer[account] = false;
120     }
121 
122     /**
123      * @dev Check if an account has this role.
124      * @return bool
125      */
126     function has(Role storage role, address account) internal view returns (bool) {
127         require(account != address(0), "Roles: account is the zero address");
128         return role.bearer[account];
129     }
130 }
131 
132 contract MinterRole is Context {
133     using Roles for Roles.Role;
134 
135     event MinterAdded(address indexed account);
136     event MinterRemoved(address indexed account);
137 
138     Roles.Role private _minters;
139 
140     constructor () internal {
141         _addMinter(_msgSender());
142     }
143 
144     modifier onlyMinter() {
145         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
146         _;
147     }
148 
149     function isMinter(address account) public view returns (bool) {
150         return _minters.has(account);
151     }
152 
153     function addMinter(address account) public onlyMinter {
154         _addMinter(account);
155     }
156 
157     function renounceMinter() public {
158         _removeMinter(_msgSender());
159     }
160 
161     function _addMinter(address account) internal {
162         _minters.add(account);
163         emit MinterAdded(account);
164     }
165 
166     function _removeMinter(address account) internal {
167         _minters.remove(account);
168         emit MinterRemoved(account);
169     }
170 }
171 
172 /**
173  * @title WhitelistAdminRole
174  * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
175  */
176 contract WhitelistAdminRole is Context {
177     using Roles for Roles.Role;
178 
179     event WhitelistAdminAdded(address indexed account);
180     event WhitelistAdminRemoved(address indexed account);
181 
182     Roles.Role private _whitelistAdmins;
183 
184     constructor () internal {
185         _addWhitelistAdmin(_msgSender());
186     }
187 
188     modifier onlyWhitelistAdmin() {
189         require(isWhitelistAdmin(_msgSender()), "WhitelistAdminRole: caller does not have the WhitelistAdmin role");
190         _;
191     }
192 
193     function isWhitelistAdmin(address account) public view returns (bool) {
194         return _whitelistAdmins.has(account);
195     }
196 
197     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
198         _addWhitelistAdmin(account);
199     }
200 
201     function renounceWhitelistAdmin() public {
202         _removeWhitelistAdmin(_msgSender());
203     }
204 
205     function _addWhitelistAdmin(address account) internal {
206         _whitelistAdmins.add(account);
207         emit WhitelistAdminAdded(account);
208     }
209 
210     function _removeWhitelistAdmin(address account) internal {
211         _whitelistAdmins.remove(account);
212         emit WhitelistAdminRemoved(account);
213     }
214 }
215 
216 /**
217  * @title ERC165
218  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
219  */
220 interface IERC165 {
221 
222     /**
223      * @notice Query if a contract implements an interface
224      * @dev Interface identification is specified in ERC-165. This function
225      * uses less than 30,000 gas
226      * @param _interfaceId The interface identifier, as specified in ERC-165
227      */
228     function supportsInterface(bytes4 _interfaceId)
229     external
230     view
231     returns (bool);
232 }
233 
234 /**
235  * @title SafeMath
236  * @dev Unsigned math operations with safety checks that revert on error
237  */
238 library SafeMath {
239 
240     /**
241      * @dev Multiplies two unsigned integers, reverts on overflow.
242      */
243     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
244         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
245         // benefit is lost if 'b' is also tested.
246         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
247         if (a == 0) {
248             return 0;
249         }
250 
251         uint256 c = a * b;
252         require(c / a == b, "SafeMath#mul: OVERFLOW");
253 
254         return c;
255     }
256 
257     /**
258      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
259      */
260     function div(uint256 a, uint256 b) internal pure returns (uint256) {
261         // Solidity only automatically asserts when dividing by 0
262         require(b > 0, "SafeMath#div: DIVISION_BY_ZERO");
263         uint256 c = a / b;
264         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
265 
266         return c;
267     }
268 
269     /**
270      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
271      */
272     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
273         require(b <= a, "SafeMath#sub: UNDERFLOW");
274         uint256 c = a - b;
275 
276         return c;
277     }
278 
279     /**
280      * @dev Adds two unsigned integers, reverts on overflow.
281      */
282     function add(uint256 a, uint256 b) internal pure returns (uint256) {
283         uint256 c = a + b;
284         require(c >= a, "SafeMath#add: OVERFLOW");
285 
286         return c;
287     }
288 
289     /**
290      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
291      * reverts when dividing by zero.
292      */
293     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
294         require(b != 0, "SafeMath#mod: DIVISION_BY_ZERO");
295         return a % b;
296     }
297 
298 }
299 
300 /**
301  * @dev ERC-1155 interface for accepting safe transfers.
302  */
303 interface IERC1155TokenReceiver {
304 
305     /**
306      * @notice Handle the receipt of a single ERC1155 token type
307      * @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeTransferFrom` after the balance has been updated
308      * This function MAY throw to revert and reject the transfer
309      * Return of other amount than the magic value MUST result in the transaction being reverted
310      * Note: The token contract address is always the message sender
311      * @param _operator  The address which called the `safeTransferFrom` function
312      * @param _from      The address which previously owned the token
313      * @param _id        The id of the token being transferred
314      * @param _amount    The amount of tokens being transferred
315      * @param _data      Additional data with no specified format
316      * @return           `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
317      */
318     function onERC1155Received(address _operator, address _from, uint256 _id, uint256 _amount, bytes calldata _data) external returns(bytes4);
319 
320     /**
321      * @notice Handle the receipt of multiple ERC1155 token types
322      * @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeBatchTransferFrom` after the balances have been updated
323      * This function MAY throw to revert and reject the transfer
324      * Return of other amount than the magic value WILL result in the transaction being reverted
325      * Note: The token contract address is always the message sender
326      * @param _operator  The address which called the `safeBatchTransferFrom` function
327      * @param _from      The address which previously owned the token
328      * @param _ids       An array containing ids of each token being transferred
329      * @param _amounts   An array containing amounts of each token being transferred
330      * @param _data      Additional data with no specified format
331      * @return           `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
332      */
333     function onERC1155BatchReceived(address _operator, address _from, uint256[] calldata _ids, uint256[] calldata _amounts, bytes calldata _data) external returns(bytes4);
334 
335     /**
336      * @notice Indicates whether a contract implements the `ERC1155TokenReceiver` functions and so can accept ERC1155 token types.
337      * @param  interfaceID The ERC-165 interface ID that is queried for support.s
338      * @dev This function MUST return true if it implements the ERC1155TokenReceiver interface and ERC-165 interface.
339      *      This function MUST NOT consume more than 5,000 gas.
340      * @return Wheter ERC-165 or ERC1155TokenReceiver interfaces are supported.
341      */
342     function supportsInterface(bytes4 interfaceID) external view returns (bool);
343 
344 }
345 
346 interface IERC1155 {
347     // Events
348 
349     /**
350      * @dev Either TransferSingle or TransferBatch MUST emit when tokens are transferred, including zero amount transfers as well as minting or burning
351      *   Operator MUST be msg.sender
352      *   When minting/creating tokens, the `_from` field MUST be set to `0x0`
353      *   When burning/destroying tokens, the `_to` field MUST be set to `0x0`
354      *   The total amount transferred from address 0x0 minus the total amount transferred to 0x0 may be used by clients and exchanges to be added to the "circulating supply" for a given token ID
355      *   To broadcast the existence of a token ID with no initial balance, the contract SHOULD emit the TransferSingle event from `0x0` to `0x0`, with the token creator as `_operator`, and a `_amount` of 0
356      */
357     event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _amount);
358 
359     /**
360      * @dev Either TransferSingle or TransferBatch MUST emit when tokens are transferred, including zero amount transfers as well as minting or burning
361      *   Operator MUST be msg.sender
362      *   When minting/creating tokens, the `_from` field MUST be set to `0x0`
363      *   When burning/destroying tokens, the `_to` field MUST be set to `0x0`
364      *   The total amount transferred from address 0x0 minus the total amount transferred to 0x0 may be used by clients and exchanges to be added to the "circulating supply" for a given token ID
365      *   To broadcast the existence of multiple token IDs with no initial balance, this SHOULD emit the TransferBatch event from `0x0` to `0x0`, with the token creator as `_operator`, and a `_amount` of 0
366      */
367     event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _amounts);
368 
369     /**
370      * @dev MUST emit when an approval is updated
371      */
372     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
373 
374     /**
375      * @dev MUST emit when the URI is updated for a token ID
376      *   URIs are defined in RFC 3986
377      *   The URI MUST point a JSON file that conforms to the "ERC-1155 Metadata JSON Schema"
378      */
379     event URI(string _amount, uint256 indexed _id);
380 
381     /**
382      * @notice Transfers amount of an _id from the _from address to the _to address specified
383      * @dev MUST emit TransferSingle event on success
384      * Caller must be approved to manage the _from account's tokens (see isApprovedForAll)
385      * MUST throw if `_to` is the zero address
386      * MUST throw if balance of sender for token `_id` is lower than the `_amount` sent
387      * MUST throw on any other error
388      * When transfer is complete, this function MUST check if `_to` is a smart contract (code size > 0). If so, it MUST call `onERC1155Received` on `_to` and revert if the return amount is not `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
389      * @param _from    Source address
390      * @param _to      Target address
391      * @param _id      ID of the token type
392      * @param _amount  Transfered amount
393      * @param _data    Additional data with no specified format, sent in call to `_to`
394      */
395     function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount, bytes calldata _data) external;
396 
397     /**
398      * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
399      * @dev MUST emit TransferBatch event on success
400      * Caller must be approved to manage the _from account's tokens (see isApprovedForAll)
401      * MUST throw if `_to` is the zero address
402      * MUST throw if length of `_ids` is not the same as length of `_amounts`
403      * MUST throw if any of the balance of sender for token `_ids` is lower than the respective `_amounts` sent
404      * MUST throw on any other error
405      * When transfer is complete, this function MUST check if `_to` is a smart contract (code size > 0). If so, it MUST call `onERC1155BatchReceived` on `_to` and revert if the return amount is not `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
406      * Transfers and events MUST occur in the array order they were submitted (_ids[0] before _ids[1], etc)
407      * @param _from     Source addresses
408      * @param _to       Target addresses
409      * @param _ids      IDs of each token type
410      * @param _amounts  Transfer amounts per token type
411      * @param _data     Additional data with no specified format, sent in call to `_to`
412     */
413     function safeBatchTransferFrom(address _from, address _to, uint256[] calldata _ids, uint256[] calldata _amounts, bytes calldata _data) external;
414 
415     /**
416      * @notice Get the balance of an account's Tokens
417      * @param _owner  The address of the token holder
418      * @param _id     ID of the Token
419      * @return        The _owner's balance of the Token type requested
420      */
421     function balanceOf(address _owner, uint256 _id) external view returns (uint256);
422 
423     /**
424      * @notice Get the balance of multiple account/token pairs
425      * @param _owners The addresses of the token holders
426      * @param _ids    ID of the Tokens
427      * @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)
428      */
429     function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids) external view returns (uint256[] memory);
430 
431     /**
432      * @notice Enable or disable approval for a third party ("operator") to manage all of caller's tokens
433      * @dev MUST emit the ApprovalForAll event on success
434      * @param _operator  Address to add to the set of authorized operators
435      * @param _approved  True if the operator is approved, false to revoke approval
436      */
437     function setApprovalForAll(address _operator, bool _approved) external;
438 
439     /**
440      * @notice Queries the approval status of an operator for a given owner
441      * @param _owner     The owner of the Tokens
442      * @param _operator  Address of authorized operator
443      * @return           True if the operator is approved, false if not
444      */
445     function isApprovedForAll(address _owner, address _operator) external view returns (bool isOperator);
446 
447 }
448 
449 /**
450  * Copyright 2018 ZeroEx Intl.
451  * Licensed under the Apache License, Version 2.0 (the "License");
452  * you may not use this file except in compliance with the License.
453  * You may obtain a copy of the License at
454  *   http://www.apache.org/licenses/LICENSE-2.0
455  * Unless required by applicable law or agreed to in writing, software
456  * distributed under the License is distributed on an "AS IS" BASIS,
457  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
458  * See the License for the specific language governing permissions and
459  * limitations under the License.
460  */
461 /**
462  * Utility library of inline functions on addresses
463  */
464 library Address {
465 
466     /**
467      * Returns whether the target address is a contract
468      * @dev This function will return false if invoked during the constructor of a contract,
469      * as the code is not actually created until after the constructor finishes.
470      * @param account address of the account to check
471      * @return whether the target address is a contract
472      */
473     function isContract(address account) internal view returns (bool) {
474         bytes32 codehash;
475         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
476 
477         // XXX Currently there is no better way to check if there is a contract in an address
478         // than to check the size of the code at that address.
479         // See https://ethereum.stackexchange.com/a/14016/36603
480         // for more details about how this works.
481         // TODO Check this again before the Serenity release, because all addresses will be
482         // contracts then.
483         assembly { codehash := extcodehash(account) }
484         return (codehash != 0x0 && codehash != accountHash);
485     }
486 
487 }
488 
489 /**
490  * @dev Implementation of Multi-Token Standard contract
491  */
492 contract ERC1155 is IERC165 {
493     using SafeMath for uint256;
494     using Address for address;
495 
496 
497     /***********************************|
498     |        Variables and Events       |
499     |__________________________________*/
500 
501     // onReceive function signatures
502     bytes4 constant internal ERC1155_RECEIVED_VALUE = 0xf23a6e61;
503     bytes4 constant internal ERC1155_BATCH_RECEIVED_VALUE = 0xbc197c81;
504 
505     // Objects balances
506     mapping (address => mapping(uint256 => uint256)) internal balances;
507 
508     // Operator Functions
509     mapping (address => mapping(address => bool)) internal operators;
510 
511     // Events
512     event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _amount);
513     event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _amounts);
514     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
515     event URI(string _uri, uint256 indexed _id);
516 
517 
518     /***********************************|
519     |     Public Transfer Functions     |
520     |__________________________________*/
521 
522     /**
523      * @notice Transfers amount amount of an _id from the _from address to the _to address specified
524      * @param _from    Source address
525      * @param _to      Target address
526      * @param _id      ID of the token type
527      * @param _amount  Transfered amount
528      * @param _data    Additional data with no specified format, sent in call to `_to`
529      */
530     function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount, bytes memory _data)
531     public
532     {
533         require((msg.sender == _from) || isApprovedForAll(_from, msg.sender), "ERC1155#safeTransferFrom: INVALID_OPERATOR");
534         require(_to != address(0),"ERC1155#safeTransferFrom: INVALID_RECIPIENT");
535         // require(_amount >= balances[_from][_id]) is not necessary since checked with safemath operations
536 
537         _safeTransferFrom(_from, _to, _id, _amount);
538         _callonERC1155Received(_from, _to, _id, _amount, _data);
539     }
540 
541     /**
542      * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
543      * @param _from     Source addresses
544      * @param _to       Target addresses
545      * @param _ids      IDs of each token type
546      * @param _amounts  Transfer amounts per token type
547      * @param _data     Additional data with no specified format, sent in call to `_to`
548      */
549     function safeBatchTransferFrom(address _from, address _to, uint256[] memory _ids, uint256[] memory _amounts, bytes memory _data)
550     public
551     {
552         // Requirements
553         require((msg.sender == _from) || isApprovedForAll(_from, msg.sender), "ERC1155#safeBatchTransferFrom: INVALID_OPERATOR");
554         require(_to != address(0), "ERC1155#safeBatchTransferFrom: INVALID_RECIPIENT");
555 
556         _safeBatchTransferFrom(_from, _to, _ids, _amounts);
557         _callonERC1155BatchReceived(_from, _to, _ids, _amounts, _data);
558     }
559 
560 
561     /***********************************|
562     |    Internal Transfer Functions    |
563     |__________________________________*/
564 
565     /**
566      * @notice Transfers amount amount of an _id from the _from address to the _to address specified
567      * @param _from    Source address
568      * @param _to      Target address
569      * @param _id      ID of the token type
570      * @param _amount  Transfered amount
571      */
572     function _safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount)
573     internal
574     {
575         // Update balances
576         balances[_from][_id] = balances[_from][_id].sub(_amount); // Subtract amount
577         balances[_to][_id] = balances[_to][_id].add(_amount);     // Add amount
578 
579         // Emit event
580         emit TransferSingle(msg.sender, _from, _to, _id, _amount);
581     }
582 
583     /**
584      * @notice Verifies if receiver is contract and if so, calls (_to).onERC1155Received(...)
585      */
586     function _callonERC1155Received(address _from, address _to, uint256 _id, uint256 _amount, bytes memory _data)
587     internal
588     {
589         // Check if recipient is contract
590         if (_to.isContract()) {
591             bytes4 retval = IERC1155TokenReceiver(_to).onERC1155Received(msg.sender, _from, _id, _amount, _data);
592             require(retval == ERC1155_RECEIVED_VALUE, "ERC1155#_callonERC1155Received: INVALID_ON_RECEIVE_MESSAGE");
593         }
594     }
595 
596     /**
597      * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
598      * @param _from     Source addresses
599      * @param _to       Target addresses
600      * @param _ids      IDs of each token type
601      * @param _amounts  Transfer amounts per token type
602      */
603     function _safeBatchTransferFrom(address _from, address _to, uint256[] memory _ids, uint256[] memory _amounts)
604     internal
605     {
606         require(_ids.length == _amounts.length, "ERC1155#_safeBatchTransferFrom: INVALID_ARRAYS_LENGTH");
607 
608         // Number of transfer to execute
609         uint256 nTransfer = _ids.length;
610 
611         // Executing all transfers
612         for (uint256 i = 0; i < nTransfer; i++) {
613             // Update storage balance of previous bin
614             balances[_from][_ids[i]] = balances[_from][_ids[i]].sub(_amounts[i]);
615             balances[_to][_ids[i]] = balances[_to][_ids[i]].add(_amounts[i]);
616         }
617 
618         // Emit event
619         emit TransferBatch(msg.sender, _from, _to, _ids, _amounts);
620     }
621 
622     /**
623      * @notice Verifies if receiver is contract and if so, calls (_to).onERC1155BatchReceived(...)
624      */
625     function _callonERC1155BatchReceived(address _from, address _to, uint256[] memory _ids, uint256[] memory _amounts, bytes memory _data)
626     internal
627     {
628         // Pass data if recipient is contract
629         if (_to.isContract()) {
630             bytes4 retval = IERC1155TokenReceiver(_to).onERC1155BatchReceived(msg.sender, _from, _ids, _amounts, _data);
631             require(retval == ERC1155_BATCH_RECEIVED_VALUE, "ERC1155#_callonERC1155BatchReceived: INVALID_ON_RECEIVE_MESSAGE");
632         }
633     }
634 
635 
636     /***********************************|
637     |         Operator Functions        |
638     |__________________________________*/
639 
640     /**
641      * @notice Enable or disable approval for a third party ("operator") to manage all of caller's tokens
642      * @param _operator  Address to add to the set of authorized operators
643      * @param _approved  True if the operator is approved, false to revoke approval
644      */
645     function setApprovalForAll(address _operator, bool _approved)
646     external
647     {
648         // Update operator status
649         operators[msg.sender][_operator] = _approved;
650         emit ApprovalForAll(msg.sender, _operator, _approved);
651     }
652 
653     /**
654      * @notice Queries the approval status of an operator for a given owner
655      * @param _owner     The owner of the Tokens
656      * @param _operator  Address of authorized operator
657      * @return True if the operator is approved, false if not
658      */
659     function isApprovedForAll(address _owner, address _operator)
660     public view returns (bool isOperator)
661     {
662         return operators[_owner][_operator];
663     }
664 
665 
666     /***********************************|
667     |         Balance Functions         |
668     |__________________________________*/
669 
670     /**
671      * @notice Get the balance of an account's Tokens
672      * @param _owner  The address of the token holder
673      * @param _id     ID of the Token
674      * @return The _owner's balance of the Token type requested
675      */
676     function balanceOf(address _owner, uint256 _id)
677     public view returns (uint256)
678     {
679         return balances[_owner][_id];
680     }
681 
682     /**
683      * @notice Get the balance of multiple account/token pairs
684      * @param _owners The addresses of the token holders
685      * @param _ids    ID of the Tokens
686      * @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)
687      */
688     function balanceOfBatch(address[] memory _owners, uint256[] memory _ids)
689     public view returns (uint256[] memory)
690     {
691         require(_owners.length == _ids.length, "ERC1155#balanceOfBatch: INVALID_ARRAY_LENGTH");
692 
693         // Variables
694         uint256[] memory batchBalances = new uint256[](_owners.length);
695 
696         // Iterate over each owner and token ID
697         for (uint256 i = 0; i < _owners.length; i++) {
698             batchBalances[i] = balances[_owners[i]][_ids[i]];
699         }
700 
701         return batchBalances;
702     }
703 
704 
705     /***********************************|
706     |          ERC165 Functions         |
707     |__________________________________*/
708 
709     /**
710      * INTERFACE_SIGNATURE_ERC165 = bytes4(keccak256("supportsInterface(bytes4)"));
711      */
712     bytes4 constant private INTERFACE_SIGNATURE_ERC165 = 0x01ffc9a7;
713 
714     /**
715      * INTERFACE_SIGNATURE_ERC1155 =
716      * bytes4(keccak256("safeTransferFrom(address,address,uint256,uint256,bytes)")) ^
717      * bytes4(keccak256("safeBatchTransferFrom(address,address,uint256[],uint256[],bytes)")) ^
718      * bytes4(keccak256("balanceOf(address,uint256)")) ^
719      * bytes4(keccak256("balanceOfBatch(address[],uint256[])")) ^
720      * bytes4(keccak256("setApprovalForAll(address,bool)")) ^
721      * bytes4(keccak256("isApprovedForAll(address,address)"));
722      */
723     bytes4 constant private INTERFACE_SIGNATURE_ERC1155 = 0xd9b67a26;
724 
725     /**
726      * @notice Query if a contract implements an interface
727      * @param _interfaceID  The interface identifier, as specified in ERC-165
728      * @return `true` if the contract implements `_interfaceID` and
729      */
730     function supportsInterface(bytes4 _interfaceID) external view returns (bool) {
731         if (_interfaceID == INTERFACE_SIGNATURE_ERC165 ||
732             _interfaceID == INTERFACE_SIGNATURE_ERC1155) {
733             return true;
734         }
735         return false;
736     }
737 
738 }
739 
740 /**
741  * @notice Contract that handles metadata related methods.
742  * @dev Methods assume a deterministic generation of URI based on token IDs.
743  *      Methods also assume that URI uses hex representation of token IDs.
744  */
745 contract ERC1155Metadata {
746 
747     // URI's default URI prefix
748     string internal baseMetadataURI;
749     event URI(string _uri, uint256 indexed _id);
750 
751 
752     /***********************************|
753     |     Metadata Public Function s    |
754     |__________________________________*/
755 
756     /**
757      * @notice A distinct Uniform Resource Identifier (URI) for a given token.
758      * @dev URIs are defined in RFC 3986.
759      *      URIs are assumed to be deterministically generated based on token ID
760      *      Token IDs are assumed to be represented in their hex format in URIs
761      * @return URI string
762      */
763     function uri(uint256 _id) public view returns (string memory) {
764         return string(abi.encodePacked(baseMetadataURI, _uint2str(_id), ".json"));
765     }
766 
767 
768     /***********************************|
769     |    Metadata Internal Functions    |
770     |__________________________________*/
771 
772     /**
773      * @notice Will emit default URI log event for corresponding token _id
774      * @param _tokenIDs Array of IDs of tokens to log default URI
775      */
776     function _logURIs(uint256[] memory _tokenIDs) internal {
777         string memory baseURL = baseMetadataURI;
778         string memory tokenURI;
779 
780         for (uint256 i = 0; i < _tokenIDs.length; i++) {
781             tokenURI = string(abi.encodePacked(baseURL, _uint2str(_tokenIDs[i]), ".json"));
782             emit URI(tokenURI, _tokenIDs[i]);
783         }
784     }
785 
786     /**
787      * @notice Will emit a specific URI log event for corresponding token
788      * @param _tokenIDs IDs of the token corresponding to the _uris logged
789      * @param _URIs    The URIs of the specified _tokenIDs
790      */
791     function _logURIs(uint256[] memory _tokenIDs, string[] memory _URIs) internal {
792         require(_tokenIDs.length == _URIs.length, "ERC1155Metadata#_logURIs: INVALID_ARRAYS_LENGTH");
793         for (uint256 i = 0; i < _tokenIDs.length; i++) {
794             emit URI(_URIs[i], _tokenIDs[i]);
795         }
796     }
797 
798     /**
799      * @notice Will update the base URL of token's URI
800      * @param _newBaseMetadataURI New base URL of token's URI
801      */
802     function _setBaseMetadataURI(string memory _newBaseMetadataURI) internal {
803         baseMetadataURI = _newBaseMetadataURI;
804     }
805 
806 
807     /***********************************|
808     |    Utility Internal Functions     |
809     |__________________________________*/
810 
811     /**
812      * @notice Convert uint256 to string
813      * @param _i Unsigned integer to convert to string
814      */
815     function _uint2str(uint256 _i) internal pure returns (string memory _uintAsString) {
816         if (_i == 0) {
817             return "0";
818         }
819 
820         uint256 j = _i;
821         uint256 ii = _i;
822         uint256 len;
823 
824         // Get number of bytes
825         while (j != 0) {
826             len++;
827             j /= 10;
828         }
829 
830         bytes memory bstr = new bytes(len);
831         uint256 k = len - 1;
832 
833         // Get each individual ASCII
834         while (ii != 0) {
835             bstr[k--] = byte(uint8(48 + ii % 10));
836             ii /= 10;
837         }
838 
839         // Convert to string
840         return string(bstr);
841     }
842 
843 }
844 
845 /**
846  * @dev Multi-Fungible Tokens with minting and burning methods. These methods assume
847  *      a parent contract to be executed as they are `internal` functions
848  */
849 contract ERC1155MintBurn is ERC1155 {
850 
851 
852     /****************************************|
853     |            Minting Functions           |
854     |_______________________________________*/
855 
856     /**
857      * @notice Mint _amount of tokens of a given id
858      * @param _to      The address to mint tokens to
859      * @param _id      Token id to mint
860      * @param _amount  The amount to be minted
861      * @param _data    Data to pass if receiver is contract
862      */
863     function _mint(address _to, uint256 _id, uint256 _amount, bytes memory _data)
864     internal
865     {
866         // Add _amount
867         balances[_to][_id] = balances[_to][_id].add(_amount);
868 
869         // Emit event
870         emit TransferSingle(msg.sender, address(0x0), _to, _id, _amount);
871 
872         // Calling onReceive method if recipient is contract
873         _callonERC1155Received(address(0x0), _to, _id, _amount, _data);
874     }
875 
876     /**
877      * @notice Mint tokens for each ids in _ids
878      * @param _to       The address to mint tokens to
879      * @param _ids      Array of ids to mint
880      * @param _amounts  Array of amount of tokens to mint per id
881      * @param _data    Data to pass if receiver is contract
882      */
883     function _batchMint(address _to, uint256[] memory _ids, uint256[] memory _amounts, bytes memory _data)
884     internal
885     {
886         require(_ids.length == _amounts.length, "ERC1155MintBurn#batchMint: INVALID_ARRAYS_LENGTH");
887 
888         // Number of mints to execute
889         uint256 nMint = _ids.length;
890 
891         // Executing all minting
892         for (uint256 i = 0; i < nMint; i++) {
893             // Update storage balance
894             balances[_to][_ids[i]] = balances[_to][_ids[i]].add(_amounts[i]);
895         }
896 
897         // Emit batch mint event
898         emit TransferBatch(msg.sender, address(0x0), _to, _ids, _amounts);
899 
900         // Calling onReceive method if recipient is contract
901         _callonERC1155BatchReceived(address(0x0), _to, _ids, _amounts, _data);
902     }
903 
904 
905     /****************************************|
906     |            Burning Functions           |
907     |_______________________________________*/
908 
909     /**
910      * @notice Burn _amount of tokens of a given token id
911      * @param _from    The address to burn tokens from
912      * @param _id      Token id to burn
913      * @param _amount  The amount to be burned
914      */
915     function _burn(address _from, uint256 _id, uint256 _amount)
916     internal
917     {
918         //Substract _amount
919         balances[_from][_id] = balances[_from][_id].sub(_amount);
920 
921         // Emit event
922         emit TransferSingle(msg.sender, _from, address(0x0), _id, _amount);
923     }
924 
925     /**
926      * @notice Burn tokens of given token id for each (_ids[i], _amounts[i]) pair
927      * @param _from     The address to burn tokens from
928      * @param _ids      Array of token ids to burn
929      * @param _amounts  Array of the amount to be burned
930      */
931     function _batchBurn(address _from, uint256[] memory _ids, uint256[] memory _amounts)
932     internal
933     {
934         require(_ids.length == _amounts.length, "ERC1155MintBurn#batchBurn: INVALID_ARRAYS_LENGTH");
935 
936         // Number of mints to execute
937         uint256 nBurn = _ids.length;
938 
939         // Executing all minting
940         for (uint256 i = 0; i < nBurn; i++) {
941             // Update storage balance
942             balances[_from][_ids[i]] = balances[_from][_ids[i]].sub(_amounts[i]);
943         }
944 
945         // Emit batch mint event
946         emit TransferBatch(msg.sender, _from, address(0x0), _ids, _amounts);
947     }
948 
949 }
950 
951 library Strings {
952     // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
953     function strConcat(
954         string memory _a,
955         string memory _b,
956         string memory _c,
957         string memory _d,
958         string memory _e
959     ) internal pure returns (string memory) {
960         bytes memory _ba = bytes(_a);
961         bytes memory _bb = bytes(_b);
962         bytes memory _bc = bytes(_c);
963         bytes memory _bd = bytes(_d);
964         bytes memory _be = bytes(_e);
965         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
966         bytes memory babcde = bytes(abcde);
967         uint256 k = 0;
968         for (uint256 i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
969         for (uint256 i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
970         for (uint256 i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
971         for (uint256 i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
972         for (uint256 i = 0; i < _be.length; i++) babcde[k++] = _be[i];
973         return string(babcde);
974     }
975 
976     function strConcat(
977         string memory _a,
978         string memory _b,
979         string memory _c,
980         string memory _d
981     ) internal pure returns (string memory) {
982         return strConcat(_a, _b, _c, _d, "");
983     }
984 
985     function strConcat(
986         string memory _a,
987         string memory _b,
988         string memory _c
989     ) internal pure returns (string memory) {
990         return strConcat(_a, _b, _c, "", "");
991     }
992 
993     function strConcat(string memory _a, string memory _b) internal pure returns (string memory) {
994         return strConcat(_a, _b, "", "", "");
995     }
996 
997     function uint2str(uint256 _i) internal pure returns (string memory _uintAsString) {
998         if (_i == 0) {
999             return "0";
1000         }
1001         uint256 j = _i;
1002         uint256 len;
1003         while (j != 0) {
1004             len++;
1005             j /= 10;
1006         }
1007         bytes memory bstr = new bytes(len);
1008         uint256 k = len - 1;
1009         while (_i != 0) {
1010             bstr[k--] = bytes1(uint8(48 + (_i % 10)));
1011             _i /= 10;
1012         }
1013         return string(bstr);
1014     }
1015 }
1016 
1017 contract OwnableDelegateProxy {}
1018 
1019 contract ProxyRegistry {
1020     mapping(address => OwnableDelegateProxy) public proxies;
1021 }
1022 
1023 /**
1024  * @title ERC1155Tradable
1025  * ERC1155Tradable - ERC1155 contract that whitelists an operator address,
1026  * has create and mint functionality, and supports useful standards from OpenZeppelin,
1027   like _exists(), name(), symbol(), and totalSupply()
1028  */
1029 contract ERC1155Tradable is ERC1155, ERC1155MintBurn, ERC1155Metadata, Ownable, MinterRole, WhitelistAdminRole {
1030     using Strings for string;
1031 
1032     address proxyRegistryAddress;
1033     uint256 private _currentTokenID = 0;
1034     mapping(uint256 => address) public creators;
1035     mapping(uint256 => uint256) public tokenSupply;
1036     mapping(uint256 => uint256) public tokenMaxSupply;
1037     // Contract name
1038     string public name;
1039     // Contract symbol
1040     string public symbol;
1041 
1042     constructor(
1043         string memory _name,
1044         string memory _symbol,
1045         address _proxyRegistryAddress
1046     ) public {
1047         name = _name;
1048         symbol = _symbol;
1049         proxyRegistryAddress = _proxyRegistryAddress;
1050     }
1051 
1052     function removeWhitelistAdmin(address account) public onlyOwner {
1053         _removeWhitelistAdmin(account);
1054     }
1055 
1056     function removeMinter(address account) public onlyOwner {
1057         _removeMinter(account);
1058     }
1059 
1060     function uri(uint256 _id) public view returns (string memory) {
1061         require(_exists(_id), "ERC721Tradable#uri: NONEXISTENT_TOKEN");
1062         return Strings.strConcat(baseMetadataURI, Strings.uint2str(_id));
1063     }
1064 
1065     /**
1066      * @dev Returns the total quantity for a token ID
1067      * @param _id uint256 ID of the token to query
1068      * @return amount of token in existence
1069      */
1070     function totalSupply(uint256 _id) public view returns (uint256) {
1071         return tokenSupply[_id];
1072     }
1073 
1074     /**
1075      * @dev Returns the max quantity for a token ID
1076      * @param _id uint256 ID of the token to query
1077      * @return amount of token in existence
1078      */
1079     function maxSupply(uint256 _id) public view returns (uint256) {
1080         return tokenMaxSupply[_id];
1081     }
1082 
1083     /**
1084      * @dev Will update the base URL of token's URI
1085      * @param _newBaseMetadataURI New base URL of token's URI
1086      */
1087     function setBaseMetadataURI(string memory _newBaseMetadataURI) public onlyWhitelistAdmin {
1088         _setBaseMetadataURI(_newBaseMetadataURI);
1089     }
1090 
1091     /**
1092      * @dev Creates a new token type and assigns _initialSupply to an address
1093      * @param _maxSupply max supply allowed
1094      * @param _initialSupply Optional amount to supply the first owner
1095      * @param _uri Optional URI for this token type
1096      * @param _data Optional data to pass if receiver is contract
1097      * @return The newly created token ID
1098      */
1099     function create(
1100         uint256 _maxSupply,
1101         uint256 _initialSupply,
1102         string calldata _uri,
1103         bytes calldata _data
1104     ) external onlyWhitelistAdmin returns (uint256 tokenId) {
1105         require(_initialSupply <= _maxSupply, "Initial supply cannot be more than max supply");
1106         uint256 _id = _getNextTokenID();
1107         _incrementTokenTypeId();
1108         creators[_id] = msg.sender;
1109 
1110         if (bytes(_uri).length > 0) {
1111             emit URI(_uri, _id);
1112         }
1113 
1114         if (_initialSupply != 0) _mint(msg.sender, _id, _initialSupply, _data);
1115         tokenSupply[_id] = _initialSupply;
1116         tokenMaxSupply[_id] = _maxSupply;
1117         return _id;
1118     }
1119 
1120     /**
1121      * @dev Mints some amount of tokens to an address
1122      * @param _to          Address of the future owner of the token
1123      * @param _id          Token ID to mint
1124      * @param _quantity    Amount of tokens to mint
1125      * @param _data        Data to pass if receiver is contract
1126      */
1127     function mint(
1128         address _to,
1129         uint256 _id,
1130         uint256 _quantity,
1131         bytes memory _data
1132     ) public onlyMinter {
1133         uint256 tokenId = _id;
1134         uint256 newSupply = tokenSupply[tokenId].add(_quantity);
1135         require(newSupply <= tokenMaxSupply[tokenId], "Max supply reached");
1136         _mint(_to, _id, _quantity, _data);
1137         tokenSupply[_id] = tokenSupply[_id].add(_quantity);
1138     }
1139 
1140     /**
1141      * Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-free listings - The Beano of NFTs
1142      */
1143     function isApprovedForAll(address _owner, address _operator) public view returns (bool isOperator) {
1144         // Whitelist OpenSea proxy contract for easy trading.
1145         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1146         if (address(proxyRegistry.proxies(_owner)) == _operator) {
1147             return true;
1148         }
1149 
1150         return ERC1155.isApprovedForAll(_owner, _operator);
1151     }
1152 
1153     /**
1154      * @dev Returns whether the specified token exists by checking to see if it has a creator
1155      * @param _id uint256 ID of the token to query the existence of
1156      * @return bool whether the token exists
1157      */
1158     function _exists(uint256 _id) internal view returns (bool) {
1159         return creators[_id] != address(0);
1160     }
1161 
1162     /**
1163      * @dev calculates the next token ID based on value of _currentTokenID
1164      * @return uint256 for the next token ID
1165      */
1166     function _getNextTokenID() private view returns (uint256) {
1167         return _currentTokenID.add(1);
1168     }
1169 
1170     /**
1171      * @dev increments the value of _currentTokenID
1172      */
1173     function _incrementTokenTypeId() private {
1174         _currentTokenID++;
1175     }
1176 }
1177 
1178 /**
1179  * @title Pepemon Factory
1180  * PEPEMON - gotta farm em all
1181  */
1182 contract PepemonFactory is ERC1155Tradable {
1183     string private _contractURI;
1184 
1185     constructor(address _proxyRegistryAddress) public ERC1155Tradable("PepemonFactory", "PEPEMON", _proxyRegistryAddress) {
1186         _setBaseMetadataURI("https://pepemon.finance/api/cards/");
1187         _contractURI = "https://pepemon.finance/api/pepemon-erc1155";
1188     }
1189 
1190     function setBaseMetadataURI(string memory newURI) public onlyWhitelistAdmin {
1191         _setBaseMetadataURI(newURI);
1192     }
1193 
1194     function setContractURI(string memory newURI) public onlyWhitelistAdmin {
1195         _contractURI = newURI;
1196     }
1197 
1198     function contractURI() public view returns (string memory) {
1199         return _contractURI;
1200     }
1201 
1202     /**
1203 	 * @dev Ends minting of token
1204 	 * @param _id          Token ID for which minting will end
1205 	 */
1206     function endMinting(uint256 _id) external onlyWhitelistAdmin {
1207         tokenMaxSupply[_id] = tokenSupply[_id];
1208     }
1209 
1210     function burn(address _account, uint256 _id, uint256 _amount) public onlyMinter {
1211         require(balanceOf(_account, _id) >= _amount, "Cannot burn more than addres has");
1212         _burn(_account, _id, _amount);
1213     }
1214 
1215     /**
1216     * Mint NFT and send those to the list of given addresses
1217     */
1218     function airdrop(uint256 _id, address[] memory _addresses) public onlyMinter {
1219         require(tokenMaxSupply[_id] - tokenSupply[_id] >= _addresses.length, "Cant mint above max supply");
1220         for (uint256 i = 0; i < _addresses.length; i++) {
1221             mint(_addresses[i], _id, 1, "");
1222         }
1223     }
1224 }
1225 
1226 /*
1227 Constructor Argument To Add During Deployment
1228 OpenSea Registry Address
1229 000000000000000000000000a5409ec958c83c3f309868babaca7c86dcb077c1
1230 
1231 0xa5409ec958c83c3f309868babaca7c86dcb077c1
1232 */