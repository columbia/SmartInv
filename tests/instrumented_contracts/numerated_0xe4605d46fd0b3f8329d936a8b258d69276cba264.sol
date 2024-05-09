1 pragma solidity >=0.5.0;
2 
3 
4 /*
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with GSN meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 contract Context {
15     // Empty internal constructor, to prevent people from mistakenly deploying
16     // an instance of this contract, which should be used via inheritance.
17     constructor () internal { }
18     // solhint-disable-previous-line no-empty-blocks
19 
20     function _msgSender() internal view returns (address payable) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 /**
31  * @dev Contract module which provides a basic access control mechanism, where
32  * there is an account (an owner) that can be granted exclusive access to
33  * specific functions.
34  *
35  * This module is used through inheritance. It will make available the modifier
36  * `onlyOwner`, which can be applied to your functions to restrict their use to
37  * the owner.
38  */
39 contract Ownable is Context {
40     address private _owner;
41 
42     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44     /**
45      * @dev Initializes the contract setting the deployer as the initial owner.
46      */
47     constructor () internal {
48         address msgSender = _msgSender();
49         _owner = msgSender;
50         emit OwnershipTransferred(address(0), msgSender);
51     }
52 
53     /**
54      * @dev Returns the address of the current owner.
55      */
56     function owner() public view returns (address) {
57         return _owner;
58     }
59 
60     /**
61      * @dev Throws if called by any account other than the owner.
62      */
63     modifier onlyOwner() {
64         require(isOwner(), "Ownable: caller is not the owner");
65         _;
66     }
67 
68     /**
69      * @dev Returns true if the caller is the current owner.
70      */
71     function isOwner() public view returns (bool) {
72         return _msgSender() == _owner;
73     }
74 
75     /**
76      * @dev Leaves the contract without owner. It will not be possible to call
77      * `onlyOwner` functions anymore. Can only be called by the current owner.
78      *
79      * NOTE: Renouncing ownership will leave the contract without an owner,
80      * thereby removing any functionality that is only available to the owner.
81      */
82     function renounceOwnership() public onlyOwner {
83         emit OwnershipTransferred(_owner, address(0));
84         _owner = address(0);
85     }
86 
87     /**
88      * @dev Transfers ownership of the contract to a new account (`newOwner`).
89      * Can only be called by the current owner.
90      */
91     function transferOwnership(address newOwner) public onlyOwner {
92         _transferOwnership(newOwner);
93     }
94 
95     /**
96      * @dev Transfers ownership of the contract to a new account (`newOwner`).
97      */
98     function _transferOwnership(address newOwner) internal {
99         require(newOwner != address(0), "Ownable: new owner is the zero address");
100         emit OwnershipTransferred(_owner, newOwner);
101         _owner = newOwner;
102     }
103 }
104 
105 /**
106  * @title Roles
107  * @dev Library for managing addresses assigned to a Role.
108  */
109 library Roles {
110     struct Role {
111         mapping (address => bool) bearer;
112     }
113 
114     /**
115      * @dev Give an account access to this role.
116      */
117     function add(Role storage role, address account) internal {
118         require(!has(role, account), "Roles: account already has role");
119         role.bearer[account] = true;
120     }
121 
122     /**
123      * @dev Remove an account's access to this role.
124      */
125     function remove(Role storage role, address account) internal {
126         require(has(role, account), "Roles: account does not have role");
127         role.bearer[account] = false;
128     }
129 
130     /**
131      * @dev Check if an account has this role.
132      * @return bool
133      */
134     function has(Role storage role, address account) internal view returns (bool) {
135         require(account != address(0), "Roles: account is the zero address");
136         return role.bearer[account];
137     }
138 }
139 
140 contract MinterRole is Context {
141     using Roles for Roles.Role;
142 
143     event MinterAdded(address indexed account);
144     event MinterRemoved(address indexed account);
145 
146     Roles.Role private _minters;
147 
148     constructor () internal {
149         _addMinter(_msgSender());
150     }
151 
152     modifier onlyMinter() {
153         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
154         _;
155     }
156 
157     function isMinter(address account) public view returns (bool) {
158         return _minters.has(account);
159     }
160 
161     function addMinter(address account) public onlyMinter {
162         _addMinter(account);
163     }
164 
165     function renounceMinter() public {
166         _removeMinter(_msgSender());
167     }
168 
169     function _addMinter(address account) internal {
170         _minters.add(account);
171         emit MinterAdded(account);
172     }
173 
174     function _removeMinter(address account) internal {
175         _minters.remove(account);
176         emit MinterRemoved(account);
177     }
178 }
179 
180 /**
181  * @title WhitelistAdminRole
182  * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
183  */
184 contract WhitelistAdminRole is Context {
185     using Roles for Roles.Role;
186 
187     event WhitelistAdminAdded(address indexed account);
188     event WhitelistAdminRemoved(address indexed account);
189 
190     Roles.Role private _whitelistAdmins;
191 
192     constructor () internal {
193         _addWhitelistAdmin(_msgSender());
194     }
195 
196     modifier onlyWhitelistAdmin() {
197         require(isWhitelistAdmin(_msgSender()), "WhitelistAdminRole: caller does not have the WhitelistAdmin role");
198         _;
199     }
200 
201     function isWhitelistAdmin(address account) public view returns (bool) {
202         return _whitelistAdmins.has(account);
203     }
204 
205     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
206         _addWhitelistAdmin(account);
207     }
208 
209     function renounceWhitelistAdmin() public {
210         _removeWhitelistAdmin(_msgSender());
211     }
212 
213     function _addWhitelistAdmin(address account) internal {
214         _whitelistAdmins.add(account);
215         emit WhitelistAdminAdded(account);
216     }
217 
218     function _removeWhitelistAdmin(address account) internal {
219         _whitelistAdmins.remove(account);
220         emit WhitelistAdminRemoved(account);
221     }
222 }
223 
224 /**
225  * @title ERC165
226  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
227  */
228 interface IERC165 {
229 
230     /**
231      * @notice Query if a contract implements an interface
232      * @dev Interface identification is specified in ERC-165. This function
233      * uses less than 30,000 gas
234      * @param _interfaceId The interface identifier, as specified in ERC-165
235      */
236     function supportsInterface(bytes4 _interfaceId)
237     external
238     view
239     returns (bool);
240 }
241 
242 /**
243  * @title SafeMath
244  * @dev Unsigned math operations with safety checks that revert on error
245  */
246 library SafeMath {
247 
248   /**
249    * @dev Multiplies two unsigned integers, reverts on overflow.
250    */
251   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
252     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
253     // benefit is lost if 'b' is also tested.
254     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
255     if (a == 0) {
256       return 0;
257     }
258 
259     uint256 c = a * b;
260     require(c / a == b, "SafeMath#mul: OVERFLOW");
261 
262     return c;
263   }
264 
265   /**
266    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
267    */
268   function div(uint256 a, uint256 b) internal pure returns (uint256) {
269     // Solidity only automatically asserts when dividing by 0
270     require(b > 0, "SafeMath#div: DIVISION_BY_ZERO");
271     uint256 c = a / b;
272     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
273 
274     return c;
275   }
276 
277   /**
278    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
279    */
280   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
281     require(b <= a, "SafeMath#sub: UNDERFLOW");
282     uint256 c = a - b;
283 
284     return c;
285   }
286 
287   /**
288    * @dev Adds two unsigned integers, reverts on overflow.
289    */
290   function add(uint256 a, uint256 b) internal pure returns (uint256) {
291     uint256 c = a + b;
292     require(c >= a, "SafeMath#add: OVERFLOW");
293 
294     return c; 
295   }
296 
297   /**
298    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
299    * reverts when dividing by zero.
300    */
301   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
302     require(b != 0, "SafeMath#mod: DIVISION_BY_ZERO");
303     return a % b;
304   }
305 
306 }
307 
308 /**
309  * @dev ERC-1155 interface for accepting safe transfers.
310  */
311 interface IERC1155TokenReceiver {
312 
313   /**
314    * @notice Handle the receipt of a single ERC1155 token type
315    * @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeTransferFrom` after the balance has been updated
316    * This function MAY throw to revert and reject the transfer
317    * Return of other amount than the magic value MUST result in the transaction being reverted
318    * Note: The token contract address is always the message sender
319    * @param _operator  The address which called the `safeTransferFrom` function
320    * @param _from      The address which previously owned the token
321    * @param _id        The id of the token being transferred
322    * @param _amount    The amount of tokens being transferred
323    * @param _data      Additional data with no specified format
324    * @return           `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
325    */
326   function onERC1155Received(address _operator, address _from, uint256 _id, uint256 _amount, bytes calldata _data) external returns(bytes4);
327 
328   /**
329    * @notice Handle the receipt of multiple ERC1155 token types
330    * @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeBatchTransferFrom` after the balances have been updated
331    * This function MAY throw to revert and reject the transfer
332    * Return of other amount than the magic value WILL result in the transaction being reverted
333    * Note: The token contract address is always the message sender
334    * @param _operator  The address which called the `safeBatchTransferFrom` function
335    * @param _from      The address which previously owned the token
336    * @param _ids       An array containing ids of each token being transferred
337    * @param _amounts   An array containing amounts of each token being transferred
338    * @param _data      Additional data with no specified format
339    * @return           `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
340    */
341   function onERC1155BatchReceived(address _operator, address _from, uint256[] calldata _ids, uint256[] calldata _amounts, bytes calldata _data) external returns(bytes4);
342 
343   /**
344    * @notice Indicates whether a contract implements the `ERC1155TokenReceiver` functions and so can accept ERC1155 token types.
345    * @param  interfaceID The ERC-165 interface ID that is queried for support.s
346    * @dev This function MUST return true if it implements the ERC1155TokenReceiver interface and ERC-165 interface.
347    *      This function MUST NOT consume more than 5,000 gas.
348    * @return Wheter ERC-165 or ERC1155TokenReceiver interfaces are supported.
349    */
350   function supportsInterface(bytes4 interfaceID) external view returns (bool);
351 
352 }
353 
354 interface IERC1155 {
355   // Events
356 
357   /**
358    * @dev Either TransferSingle or TransferBatch MUST emit when tokens are transferred, including zero amount transfers as well as minting or burning
359    *   Operator MUST be msg.sender
360    *   When minting/creating tokens, the `_from` field MUST be set to `0x0`
361    *   When burning/destroying tokens, the `_to` field MUST be set to `0x0`
362    *   The total amount transferred from address 0x0 minus the total amount transferred to 0x0 may be used by clients and exchanges to be added to the "circulating supply" for a given token ID
363    *   To broadcast the existence of a token ID with no initial balance, the contract SHOULD emit the TransferSingle event from `0x0` to `0x0`, with the token creator as `_operator`, and a `_amount` of 0
364    */
365   event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _amount);
366 
367   /**
368    * @dev Either TransferSingle or TransferBatch MUST emit when tokens are transferred, including zero amount transfers as well as minting or burning
369    *   Operator MUST be msg.sender
370    *   When minting/creating tokens, the `_from` field MUST be set to `0x0`
371    *   When burning/destroying tokens, the `_to` field MUST be set to `0x0`
372    *   The total amount transferred from address 0x0 minus the total amount transferred to 0x0 may be used by clients and exchanges to be added to the "circulating supply" for a given token ID
373    *   To broadcast the existence of multiple token IDs with no initial balance, this SHOULD emit the TransferBatch event from `0x0` to `0x0`, with the token creator as `_operator`, and a `_amount` of 0
374    */
375   event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _amounts);
376 
377   /**
378    * @dev MUST emit when an approval is updated
379    */
380   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
381 
382   /**
383    * @dev MUST emit when the URI is updated for a token ID
384    *   URIs are defined in RFC 3986
385    *   The URI MUST point a JSON file that conforms to the "ERC-1155 Metadata JSON Schema"
386    */
387   event URI(string _amount, uint256 indexed _id);
388 
389   /**
390    * @notice Transfers amount of an _id from the _from address to the _to address specified
391    * @dev MUST emit TransferSingle event on success
392    * Caller must be approved to manage the _from account's tokens (see isApprovedForAll)
393    * MUST throw if `_to` is the zero address
394    * MUST throw if balance of sender for token `_id` is lower than the `_amount` sent
395    * MUST throw on any other error
396    * When transfer is complete, this function MUST check if `_to` is a smart contract (code size > 0). If so, it MUST call `onERC1155Received` on `_to` and revert if the return amount is not `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
397    * @param _from    Source address
398    * @param _to      Target address
399    * @param _id      ID of the token type
400    * @param _amount  Transfered amount
401    * @param _data    Additional data with no specified format, sent in call to `_to`
402    */
403   function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount, bytes calldata _data) external;
404 
405   /**
406    * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
407    * @dev MUST emit TransferBatch event on success
408    * Caller must be approved to manage the _from account's tokens (see isApprovedForAll)
409    * MUST throw if `_to` is the zero address
410    * MUST throw if length of `_ids` is not the same as length of `_amounts`
411    * MUST throw if any of the balance of sender for token `_ids` is lower than the respective `_amounts` sent
412    * MUST throw on any other error
413    * When transfer is complete, this function MUST check if `_to` is a smart contract (code size > 0). If so, it MUST call `onERC1155BatchReceived` on `_to` and revert if the return amount is not `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
414    * Transfers and events MUST occur in the array order they were submitted (_ids[0] before _ids[1], etc)
415    * @param _from     Source addresses
416    * @param _to       Target addresses
417    * @param _ids      IDs of each token type
418    * @param _amounts  Transfer amounts per token type
419    * @param _data     Additional data with no specified format, sent in call to `_to`
420   */
421   function safeBatchTransferFrom(address _from, address _to, uint256[] calldata _ids, uint256[] calldata _amounts, bytes calldata _data) external;
422   
423   /**
424    * @notice Get the balance of an account's Tokens
425    * @param _owner  The address of the token holder
426    * @param _id     ID of the Token
427    * @return        The _owner's balance of the Token type requested
428    */
429   function balanceOf(address _owner, uint256 _id) external view returns (uint256);
430 
431   /**
432    * @notice Get the balance of multiple account/token pairs
433    * @param _owners The addresses of the token holders
434    * @param _ids    ID of the Tokens
435    * @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)
436    */
437   function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids) external view returns (uint256[] memory);
438 
439   /**
440    * @notice Enable or disable approval for a third party ("operator") to manage all of caller's tokens
441    * @dev MUST emit the ApprovalForAll event on success
442    * @param _operator  Address to add to the set of authorized operators
443    * @param _approved  True if the operator is approved, false to revoke approval
444    */
445   function setApprovalForAll(address _operator, bool _approved) external;
446 
447   /**
448    * @notice Queries the approval status of an operator for a given owner
449    * @param _owner     The owner of the Tokens
450    * @param _operator  Address of authorized operator
451    * @return           True if the operator is approved, false if not
452    */
453   function isApprovedForAll(address _owner, address _operator) external view returns (bool isOperator);
454 
455 }
456 
457 /**
458  * Copyright 2018 ZeroEx Intl.
459  * Licensed under the Apache License, Version 2.0 (the "License");
460  * you may not use this file except in compliance with the License.
461  * You may obtain a copy of the License at
462  *   http://www.apache.org/licenses/LICENSE-2.0
463  * Unless required by applicable law or agreed to in writing, software
464  * distributed under the License is distributed on an "AS IS" BASIS,
465  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
466  * See the License for the specific language governing permissions and
467  * limitations under the License.
468  */
469 /**
470  * Utility library of inline functions on addresses
471  */
472 library Address {
473 
474   /**
475    * Returns whether the target address is a contract
476    * @dev This function will return false if invoked during the constructor of a contract,
477    * as the code is not actually created until after the constructor finishes.
478    * @param account address of the account to check
479    * @return whether the target address is a contract
480    */
481   function isContract(address account) internal view returns (bool) {
482     bytes32 codehash;
483     bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
484 
485     // XXX Currently there is no better way to check if there is a contract in an address
486     // than to check the size of the code at that address.
487     // See https://ethereum.stackexchange.com/a/14016/36603
488     // for more details about how this works.
489     // TODO Check this again before the Serenity release, because all addresses will be
490     // contracts then.
491     assembly { codehash := extcodehash(account) }
492     return (codehash != 0x0 && codehash != accountHash);
493   }
494 
495 }
496 
497 /**
498  * @dev Implementation of Multi-Token Standard contract
499  */
500 contract ERC1155 is IERC165 {
501   using SafeMath for uint256;
502   using Address for address;
503 
504 
505   /***********************************|
506   |        Variables and Events       |
507   |__________________________________*/
508 
509   // onReceive function signatures
510   bytes4 constant internal ERC1155_RECEIVED_VALUE = 0xf23a6e61;
511   bytes4 constant internal ERC1155_BATCH_RECEIVED_VALUE = 0xbc197c81;
512 
513   // Objects balances
514   mapping (address => mapping(uint256 => uint256)) internal balances;
515 
516   // Operator Functions
517   mapping (address => mapping(address => bool)) internal operators;
518 
519   // Events
520   event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _amount);
521   event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _amounts);
522   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
523   event URI(string _uri, uint256 indexed _id);
524 
525 
526   /***********************************|
527   |     Public Transfer Functions     |
528   |__________________________________*/
529 
530   /**
531    * @notice Transfers amount amount of an _id from the _from address to the _to address specified
532    * @param _from    Source address
533    * @param _to      Target address
534    * @param _id      ID of the token type
535    * @param _amount  Transfered amount
536    * @param _data    Additional data with no specified format, sent in call to `_to`
537    */
538   function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount, bytes memory _data)
539     public
540   {
541     require((msg.sender == _from) || isApprovedForAll(_from, msg.sender), "ERC1155#safeTransferFrom: INVALID_OPERATOR");
542     require(_to != address(0),"ERC1155#safeTransferFrom: INVALID_RECIPIENT");
543     // require(_amount >= balances[_from][_id]) is not necessary since checked with safemath operations
544 
545     _safeTransferFrom(_from, _to, _id, _amount);
546     _callonERC1155Received(_from, _to, _id, _amount, _data);
547   }
548 
549   /**
550    * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
551    * @param _from     Source addresses
552    * @param _to       Target addresses
553    * @param _ids      IDs of each token type
554    * @param _amounts  Transfer amounts per token type
555    * @param _data     Additional data with no specified format, sent in call to `_to`
556    */
557   function safeBatchTransferFrom(address _from, address _to, uint256[] memory _ids, uint256[] memory _amounts, bytes memory _data)
558     public
559   {
560     // Requirements
561     require((msg.sender == _from) || isApprovedForAll(_from, msg.sender), "ERC1155#safeBatchTransferFrom: INVALID_OPERATOR");
562     require(_to != address(0), "ERC1155#safeBatchTransferFrom: INVALID_RECIPIENT");
563 
564     _safeBatchTransferFrom(_from, _to, _ids, _amounts);
565     _callonERC1155BatchReceived(_from, _to, _ids, _amounts, _data);
566   }
567 
568 
569   /***********************************|
570   |    Internal Transfer Functions    |
571   |__________________________________*/
572 
573   /**
574    * @notice Transfers amount amount of an _id from the _from address to the _to address specified
575    * @param _from    Source address
576    * @param _to      Target address
577    * @param _id      ID of the token type
578    * @param _amount  Transfered amount
579    */
580   function _safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount)
581     internal
582   {
583     // Update balances
584     balances[_from][_id] = balances[_from][_id].sub(_amount); // Subtract amount
585     balances[_to][_id] = balances[_to][_id].add(_amount);     // Add amount
586 
587     // Emit event
588     emit TransferSingle(msg.sender, _from, _to, _id, _amount);
589   }
590 
591   /**
592    * @notice Verifies if receiver is contract and if so, calls (_to).onERC1155Received(...)
593    */
594   function _callonERC1155Received(address _from, address _to, uint256 _id, uint256 _amount, bytes memory _data)
595     internal
596   {
597     // Check if recipient is contract
598     if (_to.isContract()) {
599       bytes4 retval = IERC1155TokenReceiver(_to).onERC1155Received(msg.sender, _from, _id, _amount, _data);
600       require(retval == ERC1155_RECEIVED_VALUE, "ERC1155#_callonERC1155Received: INVALID_ON_RECEIVE_MESSAGE");
601     }
602   }
603 
604   /**
605    * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
606    * @param _from     Source addresses
607    * @param _to       Target addresses
608    * @param _ids      IDs of each token type
609    * @param _amounts  Transfer amounts per token type
610    */
611   function _safeBatchTransferFrom(address _from, address _to, uint256[] memory _ids, uint256[] memory _amounts)
612     internal
613   {
614     require(_ids.length == _amounts.length, "ERC1155#_safeBatchTransferFrom: INVALID_ARRAYS_LENGTH");
615 
616     // Number of transfer to execute
617     uint256 nTransfer = _ids.length;
618 
619     // Executing all transfers
620     for (uint256 i = 0; i < nTransfer; i++) {
621       // Update storage balance of previous bin
622       balances[_from][_ids[i]] = balances[_from][_ids[i]].sub(_amounts[i]);
623       balances[_to][_ids[i]] = balances[_to][_ids[i]].add(_amounts[i]);
624     }
625 
626     // Emit event
627     emit TransferBatch(msg.sender, _from, _to, _ids, _amounts);
628   }
629 
630   /**
631    * @notice Verifies if receiver is contract and if so, calls (_to).onERC1155BatchReceived(...)
632    */
633   function _callonERC1155BatchReceived(address _from, address _to, uint256[] memory _ids, uint256[] memory _amounts, bytes memory _data)
634     internal
635   {
636     // Pass data if recipient is contract
637     if (_to.isContract()) {
638       bytes4 retval = IERC1155TokenReceiver(_to).onERC1155BatchReceived(msg.sender, _from, _ids, _amounts, _data);
639       require(retval == ERC1155_BATCH_RECEIVED_VALUE, "ERC1155#_callonERC1155BatchReceived: INVALID_ON_RECEIVE_MESSAGE");
640     }
641   }
642 
643 
644   /***********************************|
645   |         Operator Functions        |
646   |__________________________________*/
647 
648   /**
649    * @notice Enable or disable approval for a third party ("operator") to manage all of caller's tokens
650    * @param _operator  Address to add to the set of authorized operators
651    * @param _approved  True if the operator is approved, false to revoke approval
652    */
653   function setApprovalForAll(address _operator, bool _approved)
654     external
655   {
656     // Update operator status
657     operators[msg.sender][_operator] = _approved;
658     emit ApprovalForAll(msg.sender, _operator, _approved);
659   }
660 
661   /**
662    * @notice Queries the approval status of an operator for a given owner
663    * @param _owner     The owner of the Tokens
664    * @param _operator  Address of authorized operator
665    * @return True if the operator is approved, false if not
666    */
667   function isApprovedForAll(address _owner, address _operator)
668     public view returns (bool isOperator)
669   {
670     return operators[_owner][_operator];
671   }
672 
673 
674   /***********************************|
675   |         Balance Functions         |
676   |__________________________________*/
677 
678   /**
679    * @notice Get the balance of an account's Tokens
680    * @param _owner  The address of the token holder
681    * @param _id     ID of the Token
682    * @return The _owner's balance of the Token type requested
683    */
684   function balanceOf(address _owner, uint256 _id)
685     public view returns (uint256)
686   {
687     return balances[_owner][_id];
688   }
689 
690   /**
691    * @notice Get the balance of multiple account/token pairs
692    * @param _owners The addresses of the token holders
693    * @param _ids    ID of the Tokens
694    * @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)
695    */
696   function balanceOfBatch(address[] memory _owners, uint256[] memory _ids)
697     public view returns (uint256[] memory)
698   {
699     require(_owners.length == _ids.length, "ERC1155#balanceOfBatch: INVALID_ARRAY_LENGTH");
700 
701     // Variables
702     uint256[] memory batchBalances = new uint256[](_owners.length);
703 
704     // Iterate over each owner and token ID
705     for (uint256 i = 0; i < _owners.length; i++) {
706       batchBalances[i] = balances[_owners[i]][_ids[i]];
707     }
708 
709     return batchBalances;
710   }
711 
712 
713   /***********************************|
714   |          ERC165 Functions         |
715   |__________________________________*/
716 
717   /**
718    * INTERFACE_SIGNATURE_ERC165 = bytes4(keccak256("supportsInterface(bytes4)"));
719    */
720   bytes4 constant private INTERFACE_SIGNATURE_ERC165 = 0x01ffc9a7;
721 
722   /**
723    * INTERFACE_SIGNATURE_ERC1155 =
724    * bytes4(keccak256("safeTransferFrom(address,address,uint256,uint256,bytes)")) ^
725    * bytes4(keccak256("safeBatchTransferFrom(address,address,uint256[],uint256[],bytes)")) ^
726    * bytes4(keccak256("balanceOf(address,uint256)")) ^
727    * bytes4(keccak256("balanceOfBatch(address[],uint256[])")) ^
728    * bytes4(keccak256("setApprovalForAll(address,bool)")) ^
729    * bytes4(keccak256("isApprovedForAll(address,address)"));
730    */
731   bytes4 constant private INTERFACE_SIGNATURE_ERC1155 = 0xd9b67a26;
732 
733   /**
734    * @notice Query if a contract implements an interface
735    * @param _interfaceID  The interface identifier, as specified in ERC-165
736    * @return `true` if the contract implements `_interfaceID` and
737    */
738   function supportsInterface(bytes4 _interfaceID) external view returns (bool) {
739     if (_interfaceID == INTERFACE_SIGNATURE_ERC165 ||
740         _interfaceID == INTERFACE_SIGNATURE_ERC1155) {
741       return true;
742     }
743     return false;
744   }
745 
746 }
747 
748 /**
749  * @notice Contract that handles metadata related methods.
750  * @dev Methods assume a deterministic generation of URI based on token IDs.
751  *      Methods also assume that URI uses hex representation of token IDs.
752  */
753 contract ERC1155Metadata {
754 
755   // URI's default URI prefix
756   string internal baseMetadataURI;
757   event URI(string _uri, uint256 indexed _id);
758 
759 
760   /***********************************|
761   |     Metadata Public Function s    |
762   |__________________________________*/
763 
764   /**
765    * @notice A distinct Uniform Resource Identifier (URI) for a given token.
766    * @dev URIs are defined in RFC 3986.
767    *      URIs are assumed to be deterministically generated based on token ID
768    *      Token IDs are assumed to be represented in their hex format in URIs
769    * @return URI string
770    */
771   function uri(uint256 _id) public view returns (string memory) {
772     return string(abi.encodePacked(baseMetadataURI, _uint2str(_id), ".json"));
773   }
774 
775 
776   /***********************************|
777   |    Metadata Internal Functions    |
778   |__________________________________*/
779 
780   /**
781    * @notice Will emit default URI log event for corresponding token _id
782    * @param _tokenIDs Array of IDs of tokens to log default URI
783    */
784   function _logURIs(uint256[] memory _tokenIDs) internal {
785     string memory baseURL = baseMetadataURI;
786     string memory tokenURI;
787 
788     for (uint256 i = 0; i < _tokenIDs.length; i++) {
789       tokenURI = string(abi.encodePacked(baseURL, _uint2str(_tokenIDs[i]), ".json"));
790       emit URI(tokenURI, _tokenIDs[i]);
791     }
792   }
793 
794   /**
795    * @notice Will emit a specific URI log event for corresponding token
796    * @param _tokenIDs IDs of the token corresponding to the _uris logged
797    * @param _URIs    The URIs of the specified _tokenIDs
798    */
799   function _logURIs(uint256[] memory _tokenIDs, string[] memory _URIs) internal {
800     require(_tokenIDs.length == _URIs.length, "ERC1155Metadata#_logURIs: INVALID_ARRAYS_LENGTH");
801     for (uint256 i = 0; i < _tokenIDs.length; i++) {
802       emit URI(_URIs[i], _tokenIDs[i]);
803     }
804   }
805 
806   /**
807    * @notice Will update the base URL of token's URI
808    * @param _newBaseMetadataURI New base URL of token's URI
809    */
810   function _setBaseMetadataURI(string memory _newBaseMetadataURI) internal {
811     baseMetadataURI = _newBaseMetadataURI;
812   }
813 
814 
815   /***********************************|
816   |    Utility Internal Functions     |
817   |__________________________________*/
818 
819   /**
820    * @notice Convert uint256 to string
821    * @param _i Unsigned integer to convert to string
822    */
823   function _uint2str(uint256 _i) internal pure returns (string memory _uintAsString) {
824     if (_i == 0) {
825       return "0";
826     }
827 
828     uint256 j = _i;
829     uint256 ii = _i;
830     uint256 len;
831 
832     // Get number of bytes
833     while (j != 0) {
834       len++;
835       j /= 10;
836     }
837 
838     bytes memory bstr = new bytes(len);
839     uint256 k = len - 1;
840 
841     // Get each individual ASCII
842     while (ii != 0) {
843       bstr[k--] = byte(uint8(48 + ii % 10));
844       ii /= 10;
845     }
846 
847     // Convert to string
848     return string(bstr);
849   }
850 
851 }
852 
853 /**
854  * @dev Multi-Fungible Tokens with minting and burning methods. These methods assume
855  *      a parent contract to be executed as they are `internal` functions
856  */
857 contract ERC1155MintBurn is ERC1155 {
858 
859 
860   /****************************************|
861   |            Minting Functions           |
862   |_______________________________________*/
863 
864   /**
865    * @notice Mint _amount of tokens of a given id
866    * @param _to      The address to mint tokens to
867    * @param _id      Token id to mint
868    * @param _amount  The amount to be minted
869    * @param _data    Data to pass if receiver is contract
870    */
871   function _mint(address _to, uint256 _id, uint256 _amount, bytes memory _data)
872     internal
873   {
874     // Add _amount
875     balances[_to][_id] = balances[_to][_id].add(_amount);
876 
877     // Emit event
878     emit TransferSingle(msg.sender, address(0x0), _to, _id, _amount);
879 
880     // Calling onReceive method if recipient is contract
881     _callonERC1155Received(address(0x0), _to, _id, _amount, _data);
882   }
883 
884   /**
885    * @notice Mint tokens for each ids in _ids
886    * @param _to       The address to mint tokens to
887    * @param _ids      Array of ids to mint
888    * @param _amounts  Array of amount of tokens to mint per id
889    * @param _data    Data to pass if receiver is contract
890    */
891   function _batchMint(address _to, uint256[] memory _ids, uint256[] memory _amounts, bytes memory _data)
892     internal
893   {
894     require(_ids.length == _amounts.length, "ERC1155MintBurn#batchMint: INVALID_ARRAYS_LENGTH");
895 
896     // Number of mints to execute
897     uint256 nMint = _ids.length;
898 
899      // Executing all minting
900     for (uint256 i = 0; i < nMint; i++) {
901       // Update storage balance
902       balances[_to][_ids[i]] = balances[_to][_ids[i]].add(_amounts[i]);
903     }
904 
905     // Emit batch mint event
906     emit TransferBatch(msg.sender, address(0x0), _to, _ids, _amounts);
907 
908     // Calling onReceive method if recipient is contract
909     _callonERC1155BatchReceived(address(0x0), _to, _ids, _amounts, _data);
910   }
911 
912 
913   /****************************************|
914   |            Burning Functions           |
915   |_______________________________________*/
916 
917   /**
918    * @notice Burn _amount of tokens of a given token id
919    * @param _from    The address to burn tokens from
920    * @param _id      Token id to burn
921    * @param _amount  The amount to be burned
922    */
923   function _burn(address _from, uint256 _id, uint256 _amount)
924     internal
925   {
926     //Substract _amount
927     balances[_from][_id] = balances[_from][_id].sub(_amount);
928 
929     // Emit event
930     emit TransferSingle(msg.sender, _from, address(0x0), _id, _amount);
931   }
932 
933   /**
934    * @notice Burn tokens of given token id for each (_ids[i], _amounts[i]) pair
935    * @param _from     The address to burn tokens from
936    * @param _ids      Array of token ids to burn
937    * @param _amounts  Array of the amount to be burned
938    */
939   function _batchBurn(address _from, uint256[] memory _ids, uint256[] memory _amounts)
940     internal
941   {
942     require(_ids.length == _amounts.length, "ERC1155MintBurn#batchBurn: INVALID_ARRAYS_LENGTH");
943 
944     // Number of mints to execute
945     uint256 nBurn = _ids.length;
946 
947      // Executing all minting
948     for (uint256 i = 0; i < nBurn; i++) {
949       // Update storage balance
950       balances[_from][_ids[i]] = balances[_from][_ids[i]].sub(_amounts[i]);
951     }
952 
953     // Emit batch mint event
954     emit TransferBatch(msg.sender, _from, address(0x0), _ids, _amounts);
955   }
956 
957 }
958 
959 library Strings {
960 	// via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
961 	function strConcat(
962 		string memory _a,
963 		string memory _b,
964 		string memory _c,
965 		string memory _d,
966 		string memory _e
967 	) internal pure returns (string memory) {
968 		bytes memory _ba = bytes(_a);
969 		bytes memory _bb = bytes(_b);
970 		bytes memory _bc = bytes(_c);
971 		bytes memory _bd = bytes(_d);
972 		bytes memory _be = bytes(_e);
973 		string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
974 		bytes memory babcde = bytes(abcde);
975 		uint256 k = 0;
976 		for (uint256 i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
977 		for (uint256 i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
978 		for (uint256 i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
979 		for (uint256 i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
980 		for (uint256 i = 0; i < _be.length; i++) babcde[k++] = _be[i];
981 		return string(babcde);
982 	}
983 
984 	function strConcat(
985 		string memory _a,
986 		string memory _b,
987 		string memory _c,
988 		string memory _d
989 	) internal pure returns (string memory) {
990 		return strConcat(_a, _b, _c, _d, "");
991 	}
992 
993 	function strConcat(
994 		string memory _a,
995 		string memory _b,
996 		string memory _c
997 	) internal pure returns (string memory) {
998 		return strConcat(_a, _b, _c, "", "");
999 	}
1000 
1001 	function strConcat(string memory _a, string memory _b) internal pure returns (string memory) {
1002 		return strConcat(_a, _b, "", "", "");
1003 	}
1004 
1005 	function uint2str(uint256 _i) internal pure returns (string memory _uintAsString) {
1006 		if (_i == 0) {
1007 			return "0";
1008 		}
1009 		uint256 j = _i;
1010 		uint256 len;
1011 		while (j != 0) {
1012 			len++;
1013 			j /= 10;
1014 		}
1015 		bytes memory bstr = new bytes(len);
1016 		uint256 k = len - 1;
1017 		while (_i != 0) {
1018 			bstr[k--] = bytes1(uint8(48 + (_i % 10)));
1019 			_i /= 10;
1020 		}
1021 		return string(bstr);
1022 	}
1023 }
1024 
1025 contract OwnableDelegateProxy {}
1026 
1027 contract ProxyRegistry {
1028 	mapping(address => OwnableDelegateProxy) public proxies;
1029 }
1030 
1031 /**
1032  * @title ERC1155Tradable
1033  * ERC1155Tradable - ERC1155 contract that whitelists an operator address, 
1034  * has create and mint functionality, and supports useful standards from OpenZeppelin,
1035   like _exists(), name(), symbol(), and totalSupply()
1036  */
1037 contract ERC1155Tradable is ERC1155, ERC1155MintBurn, ERC1155Metadata, Ownable, MinterRole, WhitelistAdminRole {
1038 	using Strings for string;
1039 
1040 	address proxyRegistryAddress;
1041 	uint256 private _currentTokenID = 0;
1042 	mapping(uint256 => address) public creators;
1043 	mapping(uint256 => uint256) public tokenSupply;
1044 	mapping(uint256 => uint256) public tokenMaxSupply;
1045 	// Contract name
1046 	string public name;
1047 	// Contract symbol
1048 	string public symbol;
1049 
1050 	constructor(
1051 		string memory _name,
1052 		string memory _symbol,
1053 		address _proxyRegistryAddress
1054 	) public {
1055 		name = _name;
1056 		symbol = _symbol;
1057 		proxyRegistryAddress = _proxyRegistryAddress;
1058 	}
1059 
1060 	function removeWhitelistAdmin(address account) public onlyOwner {
1061 		_removeWhitelistAdmin(account);
1062 	}
1063 
1064 	function removeMinter(address account) public onlyOwner {
1065 		_removeMinter(account);
1066 	}
1067 
1068 	function uri(uint256 _id) public view returns (string memory) {
1069 		require(_exists(_id), "ERC721Tradable#uri: NONEXISTENT_TOKEN");
1070 		return Strings.strConcat(baseMetadataURI, Strings.uint2str(_id));
1071 	}
1072 
1073 	/**
1074 	 * @dev Returns the total quantity for a token ID
1075 	 * @param _id uint256 ID of the token to query
1076 	 * @return amount of token in existence
1077 	 */
1078 	function totalSupply(uint256 _id) public view returns (uint256) {
1079 		return tokenSupply[_id];
1080 	}
1081 
1082 	/**
1083 	 * @dev Returns the max quantity for a token ID
1084 	 * @param _id uint256 ID of the token to query
1085 	 * @return amount of token in existence
1086 	 */
1087 	function maxSupply(uint256 _id) public view returns (uint256) {
1088 		return tokenMaxSupply[_id];
1089 	}
1090 
1091 	/**
1092 	 * @dev Will update the base URL of token's URI
1093 	 * @param _newBaseMetadataURI New base URL of token's URI
1094 	 */
1095 	function setBaseMetadataURI(string memory _newBaseMetadataURI) public onlyWhitelistAdmin {
1096 		_setBaseMetadataURI(_newBaseMetadataURI);
1097 	}
1098 
1099 	/**
1100 	 * @dev Creates a new token type and assigns _initialSupply to an address
1101 	 * @param _maxSupply max supply allowed
1102 	 * @param _initialSupply Optional amount to supply the first owner
1103 	 * @param _uri Optional URI for this token type
1104 	 * @param _data Optional data to pass if receiver is contract
1105 	 * @return The newly created token ID
1106 	 */
1107 	function create(
1108 		uint256 _maxSupply,
1109 		uint256 _initialSupply,
1110 		string calldata _uri,
1111 		bytes calldata _data
1112 	) external onlyWhitelistAdmin returns (uint256 tokenId) {
1113 		require(_initialSupply <= _maxSupply, "Initial supply cannot be more than max supply");
1114 		uint256 _id = _getNextTokenID();
1115 		_incrementTokenTypeId();
1116 		creators[_id] = msg.sender;
1117 
1118 		if (bytes(_uri).length > 0) {
1119 			emit URI(_uri, _id);
1120 		}
1121 
1122 		if (_initialSupply != 0) _mint(msg.sender, _id, _initialSupply, _data);
1123 		tokenSupply[_id] = _initialSupply;
1124 		tokenMaxSupply[_id] = _maxSupply;
1125 		return _id;
1126 	}
1127 
1128 	/**
1129 	 * @dev Mints some amount of tokens to an address
1130 	 * @param _to          Address of the future owner of the token
1131 	 * @param _id          Token ID to mint
1132 	 * @param _quantity    Amount of tokens to mint
1133 	 * @param _data        Data to pass if receiver is contract
1134 	 */
1135 	function mint(
1136 		address _to,
1137 		uint256 _id,
1138 		uint256 _quantity,
1139 		bytes memory _data
1140 	) public onlyMinter {
1141 		uint256 tokenId = _id;
1142 		require(tokenSupply[tokenId] < tokenMaxSupply[tokenId], "Max supply reached");
1143 		_mint(_to, _id, _quantity, _data);
1144 		tokenSupply[_id] = tokenSupply[_id].add(_quantity);
1145 	}
1146 
1147 	/**
1148 	 * Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-free listings.
1149 	 */
1150 	function isApprovedForAll(address _owner, address _operator) public view returns (bool isOperator) {
1151 		// Whitelist OpenSea proxy contract for easy trading.
1152 		ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1153 		if (address(proxyRegistry.proxies(_owner)) == _operator) {
1154 			return true;
1155 		}
1156 
1157 		return ERC1155.isApprovedForAll(_owner, _operator);
1158 	}
1159 
1160 	/**
1161 	 * @dev Returns whether the specified token exists by checking to see if it has a creator
1162 	 * @param _id uint256 ID of the token to query the existence of
1163 	 * @return bool whether the token exists
1164 	 */
1165 	function _exists(uint256 _id) internal view returns (bool) {
1166 		return creators[_id] != address(0);
1167 	}
1168 
1169 	/**
1170 	 * @dev calculates the next token ID based on value of _currentTokenID
1171 	 * @return uint256 for the next token ID
1172 	 */
1173 	function _getNextTokenID() private view returns (uint256) {
1174 		return _currentTokenID.add(1);
1175 	}
1176 
1177 	/**
1178 	 * @dev increments the value of _currentTokenID
1179 	 */
1180 	function _incrementTokenTypeId() private {
1181 		_currentTokenID++;
1182 	}
1183 }
1184 
1185 /**
1186  * @title MemeLtd
1187  * MemeLtd - Collect limited edition NFTs from Meme Ltd
1188  */
1189 contract MemeLtd is ERC1155Tradable {
1190 	constructor(address _proxyRegistryAddress) public ERC1155Tradable("Meme Ltd.", "MEMES", _proxyRegistryAddress) {
1191 		_setBaseMetadataURI("https://api.dontbuymeme.com/memes/");
1192 	}
1193 
1194 	function contractURI() public view returns (string memory) {
1195 		return "https://api.dontbuymeme.com/contract/memes-erc1155";
1196 	}
1197 }