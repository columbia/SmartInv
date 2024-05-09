1 pragma solidity >=0.5.0 <0.6.0;
2 
3 /*
4  * @dev Provides information about the current execution context, including the
5  * sender of the transaction and its data. While these are generally available
6  * via msg.sender and msg.data, they should not be accessed in such a direct
7  * manner, since when dealing with GSN meta-transactions the account sending and
8  * paying for execution may not be the actual sender (as far as an application
9  * is concerned).
10  *
11  * This contract is only required for intermediate, library-like contracts.
12  */
13 
14 
15 /*
16 
17                                        ##
18                                     @%...%@
19                                    @@..*,*@@
20                                     @@,,,%@
21                @@@@@@@@@              @@.@%             @@@@@@@@&
22           @@@@@/......./@@@           @@.@%         /@@@/......./@@@@@
23        &@@@...............@@@         @@.@%        @@@...............@@@
24       @@@......&@@@........@@@@@@@@@@@@@@@@@@@@@@@@@@......@@@@........@@@
25      &@@......@@@  @@....................................@@@@  @/.......@@
26       @@......@@@@@@......................................@@@@@@........@@
27       @@@..........................(,.......@,........................*@@@
28       @@@%.........................#@@@@@@@@@.........................#@@@@
29     @@@,.....*********...................................*********........@@@
30   @@@**.......*******,....................................********..........@@@
31  @@@,*......................................................................,@@@
32  @@*,*......................................................................,*@@
33  @@,,,......................................................................,,@@
34  @@#,*.....................................................................,,(@@
35   @@(**...................................................................,*,@@
36    @@@**.................................................................**|@@
37      @@@,,..............................................................,,@@@
38        @@@@*..........................................................**@@@
39           @@@@*.....................................................,@@@@
40              *@@@@@..............................................@@@@@
41                    @@@@@@@@,...................................@@@
42                            &@@@..................................@@@
43                          %@@@@...................................*@@@
44                        @@@.......................................**@@
45                       #@@@......................................,,,@@
46                          @@@@@*.................................,*#@@
47                           (@@@,................................*,*@@
48                       (@@@@,..................................***@@
49                     (@@,....................................,,,@@@
50                     (@@....................................*|@@@
51                       @@@@@@,.........................*@@@@@@/
52                            *@@@@@@@@@@@@@@@@@@@@@@@@@@@/
53 
54 */
55 
56 
57 contract Context {
58     // Empty internal constructor, to prevent people from mistakenly deploying
59     // an instance of this contract, which should be used via inheritance.
60     constructor () internal { }
61     // solhint-disable-previous-line no-empty-blocks
62 
63     function _msgSender() internal view returns (address payable) {
64         return msg.sender;
65     }
66 
67     function _msgData() internal view returns (bytes memory) {
68         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
69         return msg.data;
70     }
71 }
72 
73 /**
74  * @dev Contract module which provides a basic access control mechanism, where
75  * there is an account (an owner) that can be granted exclusive access to
76  * specific functions.
77  *
78  * This module is used through inheritance. It will make available the modifier
79  * `onlyOwner`, which can be applied to your functions to restrict their use to
80  * the owner.
81  */
82 contract Ownable is Context {
83     address private _owner;
84 
85     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
86 
87     /**
88      * @dev Initializes the contract setting the deployer as the initial owner.
89      */
90     constructor () internal {
91         address msgSender = _msgSender();
92         _owner = msgSender;
93         emit OwnershipTransferred(address(0), msgSender);
94     }
95 
96     /**
97      * @dev Returns the address of the current owner.
98      */
99     function owner() public view returns (address) {
100         return _owner;
101     }
102 
103     /**
104      * @dev Throws if called by any account other than the owner.
105      */
106     modifier onlyOwner() {
107         require(isOwner(), "Ownable: caller is not the owner");
108         _;
109     }
110 
111     /**
112      * @dev Returns true if the caller is the current owner.
113      */
114     function isOwner() public view returns (bool) {
115         return _msgSender() == _owner;
116     }
117 
118     /**
119      * @dev Leaves the contract without owner. It will not be possible to call
120      * `onlyOwner` functions anymore. Can only be called by the current owner.
121      *
122      * NOTE: Renouncing ownership will leave the contract without an owner,
123      * thereby removing any functionality that is only available to the owner.
124      */
125     function renounceOwnership() public onlyOwner {
126         emit OwnershipTransferred(_owner, address(0));
127         _owner = address(0);
128     }
129 
130     /**
131      * @dev Transfers ownership of the contract to a new account (`newOwner`).
132      * Can only be called by the current owner.
133      */
134     function transferOwnership(address newOwner) public onlyOwner {
135         _transferOwnership(newOwner);
136     }
137 
138     /**
139      * @dev Transfers ownership of the contract to a new account (`newOwner`).
140      */
141     function _transferOwnership(address newOwner) internal {
142         require(newOwner != address(0), "ownable: new studio owner is the zero address");
143         emit OwnershipTransferred(_owner, newOwner);
144         _owner = newOwner;
145     }
146 }
147 
148 /**
149  * @title Roles
150  * @dev Library for managing addresses assigned to a Role.
151  */
152 library Roles {
153     struct Role {
154         mapping (address => bool) bearer;
155     }
156 
157     /**
158      * @dev Give an account access to this role.
159      */
160     function add(Role storage role, address account) internal {
161         require(!has(role, account), "roles: account already has requested role");
162         role.bearer[account] = true;
163     }
164 
165     /**
166      * @dev Remove an account's access to this role.
167      */
168     function remove(Role storage role, address account) internal {
169         require(has(role, account), "roles: account does not have needed role");
170         role.bearer[account] = false;
171     }
172 
173     /**
174      * @dev Check if an account has this role.
175      * @return bool
176      */
177     function has(Role storage role, address account) internal view returns (bool) {
178         require(account != address(0), "roles: account is the zero address");
179         return role.bearer[account];
180     }
181 }
182 
183 contract MinterRole is Context {
184     using Roles for Roles.Role;
185 
186     event MinterAdded(address indexed account);
187     event MinterRemoved(address indexed account);
188 
189     Roles.Role private _minters;
190 
191     constructor () internal {
192         _addMinter(_msgSender());
193     }
194 
195     modifier onlyMinter() {
196         require(isMinter(_msgSender()), "minterRole: caller does not have the beeg nft minter role");
197         _;
198     }
199 
200     function isMinter(address account) public view returns (bool) {
201         return _minters.has(account);
202     }
203 
204     function addMinter(address account) public onlyMinter {
205         _addMinter(account);
206     }
207 
208     function renounceMinter() public {
209         _removeMinter(_msgSender());
210     }
211 
212     function _addMinter(address account) internal {
213         _minters.add(account);
214         emit MinterAdded(account);
215     }
216 
217     function _removeMinter(address account) internal {
218         _minters.remove(account);
219         emit MinterRemoved(account);
220     }
221 }
222 
223 /**
224  * @title WhitelistAdminRole
225  * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
226  */
227 contract WhitelistAdminRole is Context {
228     using Roles for Roles.Role;
229 
230     event WhitelistAdminAdded(address indexed account);
231     event WhitelistAdminRemoved(address indexed account);
232 
233     Roles.Role private _whitelistAdmins;
234 
235     constructor () internal {
236         _addWhitelistAdmin(_msgSender());
237     }
238 
239     modifier onlyWhitelistAdmin() {
240         require(isWhitelistAdmin(_msgSender()), "whitelistadminrole: caller does not have the beeg whitelistadmin ting");
241         _;
242     }
243 
244     function isWhitelistAdmin(address account) public view returns (bool) {
245         return _whitelistAdmins.has(account);
246     }
247 
248     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
249         _addWhitelistAdmin(account);
250     }
251 
252     function renounceWhitelistAdmin() public {
253         _removeWhitelistAdmin(_msgSender());
254     }
255 
256     function _addWhitelistAdmin(address account) internal {
257         _whitelistAdmins.add(account);
258         emit WhitelistAdminAdded(account);
259     }
260 
261     function _removeWhitelistAdmin(address account) internal {
262         _whitelistAdmins.remove(account);
263         emit WhitelistAdminRemoved(account);
264     }
265 }
266 
267 /**
268  * @title ERC165
269  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
270  */
271 interface IERC165 {
272 
273     /**
274      * @notice Query if a contract implements an interface
275      * @dev Interface identification is specified in ERC-165. This function
276      * uses less than 30,000 gas
277      * @param _interfaceId The interface identifier, as specified in ERC-165
278      */
279     function supportsInterface(bytes4 _interfaceId)
280     external
281     view
282     returns (bool);
283 }
284 
285 /**
286  * @title SafeMath
287  * @dev Unsigned math operations with safety checks that revert on error
288  */
289 library SafeMath {
290 
291     /**
292      * @dev Multiplies two unsigned integers, reverts on overflow.
293      */
294     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
295         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
296         // benefit is lost if 'b' is also tested.
297         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
298         if (a == 0) {
299             return 0;
300         }
301 
302         uint256 c = a * b;
303         require(c / a == b, "safemath#mul: OVERFLOW");
304 
305         return c;
306     }
307 
308     /**
309      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
310      */
311     function div(uint256 a, uint256 b) internal pure returns (uint256) {
312         // Solidity only automatically asserts when dividing by 0
313         require(b > 0, "safemath#div: DIVISION_BY_ZERO");
314         uint256 c = a / b;
315         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
316 
317         return c;
318     }
319 
320     /**
321      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
322      */
323     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
324         require(b <= a, "safemath#sub: UNDERFLOW");
325         uint256 c = a - b;
326 
327         return c;
328     }
329 
330     /**
331      * @dev Adds two unsigned integers, reverts on overflow.
332      */
333     function add(uint256 a, uint256 b) internal pure returns (uint256) {
334         uint256 c = a + b;
335         require(c >= a, "safemath#add: OVERFLOW");
336 
337         return c;
338     }
339 
340     /**
341      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
342      * reverts when dividing by zero.
343      */
344     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
345         require(b != 0, "safemath#mod: DIVISION_BY_ZERO");
346         return a % b;
347     }
348 
349 }
350 
351 /**
352  * @dev ERC-1155 interface for accepting safe transfers.
353  */
354 interface IERC1155TokenReceiver {
355 
356     /**
357      * @notice Handle the receipt of a single ERC1155 token type
358      * @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeTransferFrom` after the balance has been updated
359      * This function MAY throw to revert and reject the transfer
360      * Return of other amount than the magic value MUST result in the transaction being reverted
361      * Note: The token contract address is always the message sender
362      * @param _operator  The address which called the `safeTransferFrom` function
363      * @param _from      The address which previously owned the token
364      * @param _id        The id of the token being transferred
365      * @param _amount    The amount of tokens being transferred
366      * @param _data      Additional data with no specified format
367      * @return           `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
368      */
369     function onERC1155Received(address _operator, address _from, uint256 _id, uint256 _amount, bytes calldata _data) external returns(bytes4);
370 
371     /**
372      * @notice Handle the receipt of multiple ERC1155 token types
373      * @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeBatchTransferFrom` after the balances have been updated
374      * This function MAY throw to revert and reject the transfer
375      * Return of other amount than the magic value WILL result in the transaction being reverted
376      * Note: The token contract address is always the message sender
377      * @param _operator  The address which called the `safeBatchTransferFrom` function
378      * @param _from      The address which previously owned the token
379      * @param _ids       An array containing ids of each token being transferred
380      * @param _amounts   An array containing amounts of each token being transferred
381      * @param _data      Additional data with no specified format
382      * @return           `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
383      */
384     function onERC1155BatchReceived(address _operator, address _from, uint256[] calldata _ids, uint256[] calldata _amounts, bytes calldata _data) external returns(bytes4);
385 
386     /**
387      * @notice Indicates whether a contract implements the `ERC1155TokenReceiver` functions and so can accept ERC1155 token types.
388      * @param  interfaceID The ERC-165 interface ID that is queried for support.s
389      * @dev This function MUST return true if it implements the ERC1155TokenReceiver interface and ERC-165 interface.
390      *      This function MUST NOT consume more than 5,000 gas.
391      * @return Wheter ERC-165 or ERC1155TokenReceiver interfaces are supported.
392      */
393     function supportsInterface(bytes4 interfaceID) external view returns (bool);
394 
395 }
396 
397 interface IERC1155 {
398     // Events
399 
400     /**
401      * @dev Either TransferSingle or TransferBatch MUST emit when tokens are transferred, including zero amount transfers as well as minting or burning
402      *   Operator MUST be msg.sender
403      *   When minting/creating tokens, the `_from` field MUST be set to `0x0`
404      *   When burning/destroying tokens, the `_to` field MUST be set to `0x0`
405      *   The total amount transferred from address 0x0 minus the total amount transferred to 0x0 may be used by clients and exchanges to be added to the "circulating supply" for a given token ID
406      *   To broadcast the existence of a token ID with no initial balance, the contract SHOULD emit the TransferSingle event from `0x0` to `0x0`, with the token creator as `_operator`, and a `_amount` of 0
407      */
408     event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _amount);
409 
410     /**
411      * @dev Either TransferSingle or TransferBatch MUST emit when tokens are transferred, including zero amount transfers as well as minting or burning
412      *   Operator MUST be msg.sender
413      *   When minting/creating tokens, the `_from` field MUST be set to `0x0`
414      *   When burning/destroying tokens, the `_to` field MUST be set to `0x0`
415      *   The total amount transferred from address 0x0 minus the total amount transferred to 0x0 may be used by clients and exchanges to be added to the "circulating supply" for a given token ID
416      *   To broadcast the existence of multiple token IDs with no initial balance, this SHOULD emit the TransferBatch event from `0x0` to `0x0`, with the token creator as `_operator`, and a `_amount` of 0
417      */
418     event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _amounts);
419 
420     /**
421      * @dev MUST emit when an approval is updated
422      */
423     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
424 
425     /**
426      * @dev MUST emit when the URI is updated for a token ID
427      *   URIs are defined in RFC 3986
428      *   The URI MUST point a JSON file that conforms to the "ERC-1155 Metadata JSON Schema"
429      */
430     event URI(string _amount, uint256 indexed _id);
431 
432     /**
433      * @notice Transfers amount of an _id from the _from address to the _to address specified
434      * @dev MUST emit TransferSingle event on success
435      * Caller must be approved to manage the _from account's tokens (see isApprovedForAll)
436      * MUST throw if `_to` is the zero address
437      * MUST throw if balance of sender for token `_id` is lower than the `_amount` sent
438      * MUST throw on any other error
439      * When transfer is complete, this function MUST check if `_to` is a smart contract (code size > 0). If so, it MUST call `onERC1155Received` on `_to` and revert if the return amount is not `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
440      * @param _from    Source address
441      * @param _to      Target address
442      * @param _id      ID of the token type
443      * @param _amount  Transfered amount
444      * @param _data    Additional data with no specified format, sent in call to `_to`
445      */
446     function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount, bytes calldata _data) external;
447 
448     /**
449      * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
450      * @dev MUST emit TransferBatch event on success
451      * Caller must be approved to manage the _from account's tokens (see isApprovedForAll)
452      * MUST throw if `_to` is the zero address
453      * MUST throw if length of `_ids` is not the same as length of `_amounts`
454      * MUST throw if any of the balance of sender for token `_ids` is lower than the respective `_amounts` sent
455      * MUST throw on any other error
456      * When transfer is complete, this function MUST check if `_to` is a smart contract (code size > 0). If so, it MUST call `onERC1155BatchReceived` on `_to` and revert if the return amount is not `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
457      * Transfers and events MUST occur in the array order they were submitted (_ids[0] before _ids[1], etc)
458      * @param _from     Source addresses
459      * @param _to       Target addresses
460      * @param _ids      IDs of each token type
461      * @param _amounts  Transfer amounts per token type
462      * @param _data     Additional data with no specified format, sent in call to `_to`
463     */
464     function safeBatchTransferFrom(address _from, address _to, uint256[] calldata _ids, uint256[] calldata _amounts, bytes calldata _data) external;
465 
466     /**
467      * @notice Get the balance of an account's Tokens
468      * @param _owner  The address of the token holder
469      * @param _id     ID of the Token
470      * @return        The _owner's balance of the Token type requested
471      */
472     function balanceOf(address _owner, uint256 _id) external view returns (uint256);
473 
474     /**
475      * @notice Get the balance of multiple account/token pairs
476      * @param _owners The addresses of the token holders
477      * @param _ids    ID of the Tokens
478      * @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)
479      */
480     function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids) external view returns (uint256[] memory);
481 
482     /**
483      * @notice Enable or disable approval for a third party ("operator") to manage all of caller's tokens
484      * @dev MUST emit the ApprovalForAll event on success
485      * @param _operator  Address to add to the set of authorized operators
486      * @param _approved  True if the operator is approved, false to revoke approval
487      */
488     function setApprovalForAll(address _operator, bool _approved) external;
489 
490     /**
491      * @notice Queries the approval status of an operator for a given owner
492      * @param _owner     The owner of the Tokens
493      * @param _operator  Address of authorized operator
494      * @return           True if the operator is approved, false if not
495      */
496     function isApprovedForAll(address _owner, address _operator) external view returns (bool isOperator);
497 
498 }
499 
500 /**
501  * Copyright 2018 ZeroEx Intl.
502  * Licensed under the Apache License, Version 2.0 (the "License");
503  * you may not use this file except in compliance with the License.
504  * You may obtain a copy of the License at
505  *   http://www.apache.org/licenses/LICENSE-2.0
506  * Unless required by applicable law or agreed to in writing, software
507  * distributed under the License is distributed on an "AS IS" BASIS,
508  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
509  * See the License for the specific language governing permissions and
510  * limitations under the License.
511  */
512 /**
513  * Utility library of inline functions on addresses
514  */
515 library Address {
516 
517     /**
518      * Returns whether the target address is a contract
519      * @dev This function will return false if invoked during the constructor of a contract,
520      * as the code is not actually created until after the constructor finishes.
521      * @param account address of the account to check
522      * @return whether the target address is a contract
523      */
524     function isContract(address account) internal view returns (bool) {
525         bytes32 codehash;
526         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
527 
528         // XXX Currently there is no better way to check if there is a contract in an address
529         // than to check the size of the code at that address.
530         // See https://ethereum.stackexchange.com/a/14016/36603
531         // for more details about how this works.
532         // TODO Check this again before the Serenity release, because all addresses will be
533         // contracts then.
534         assembly { codehash := extcodehash(account) }
535         return (codehash != 0x0 && codehash != accountHash);
536     }
537 
538 }
539 
540 /**
541  * @dev Implementation of Multi-Token Standard contract
542  */
543 contract ERC1155 is IERC165 {
544     using SafeMath for uint256;
545     using Address for address;
546 
547 
548     /***********************************|
549     |        Variables and Events       |
550     |__________________________________*/
551 
552     // onReceive function signatures
553     bytes4 constant internal ERC1155_RECEIVED_VALUE = 0xf23a6e61;
554     bytes4 constant internal ERC1155_BATCH_RECEIVED_VALUE = 0xbc197c81;
555 
556     // Objects balances
557     mapping (address => mapping(uint256 => uint256)) internal balances;
558 
559     // Operator Functions
560     mapping (address => mapping(address => bool)) internal operators;
561 
562     // Events
563     event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _amount);
564     event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _amounts);
565     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
566     event URI(string _uri, uint256 indexed _id);
567 
568 
569     /***********************************|
570     |     Public Transfer Functions     |
571     |__________________________________*/
572 
573     /**
574      * @notice Transfers amount amount of an _id from the _from address to the _to address specified
575      * @param _from    Source address
576      * @param _to      Target address
577      * @param _id      ID of the token type
578      * @param _amount  Transfered amount
579      * @param _data    Additional data with no specified format, sent in call to `_to`
580      */
581     function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount, bytes memory _data)
582     public
583     {
584         require((msg.sender == _from) || isApprovedForAll(_from, msg.sender), "erc1155#safetransferfrom: INVALID_OPERATOR");
585         require(_to != address(0),"erc1155#safetransferfrom: INVALID_RECIPIENT");
586         // require(_amount >= balances[_from][_id]) is not necessary since checked with safemath operations
587 
588         _safeTransferFrom(_from, _to, _id, _amount);
589         _callonERC1155Received(_from, _to, _id, _amount, _data);
590     }
591 
592     /**
593      * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
594      * @param _from     Source addresses
595      * @param _to       Target addresses
596      * @param _ids      IDs of each token type
597      * @param _amounts  Transfer amounts per token type
598      * @param _data     Additional data with no specified format, sent in call to `_to`
599      */
600     function safeBatchTransferFrom(address _from, address _to, uint256[] memory _ids, uint256[] memory _amounts, bytes memory _data)
601     public
602     {
603         // Requirements
604         require((msg.sender == _from) || isApprovedForAll(_from, msg.sender), "erc1155#safebatchtransferfrom: INVALID_OPERATOR");
605         require(_to != address(0), "erc1155#safebatchtransferfrom: INVALID_RECIPIENT");
606 
607         _safeBatchTransferFrom(_from, _to, _ids, _amounts);
608         _callonERC1155BatchReceived(_from, _to, _ids, _amounts, _data);
609     }
610 
611 
612     /***********************************|
613     |    Internal Transfer Functions    |
614     |__________________________________*/
615 
616     /**
617      * @notice Transfers amount amount of an _id from the _from address to the _to address specified
618      * @param _from    Source address
619      * @param _to      Target address
620      * @param _id      ID of the token type
621      * @param _amount  Transfered amount
622      */
623     function _safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount)
624     internal
625     {
626         // Update balances
627         balances[_from][_id] = balances[_from][_id].sub(_amount); // Subtract amount
628         balances[_to][_id] = balances[_to][_id].add(_amount);     // Add amount
629 
630         // Emit event
631         emit TransferSingle(msg.sender, _from, _to, _id, _amount);
632     }
633 
634     /**
635      * @notice Verifies if receiver is contract and if so, calls (_to).onERC1155Received(...)
636      */
637     function _callonERC1155Received(address _from, address _to, uint256 _id, uint256 _amount, bytes memory _data)
638     internal
639     {
640         // Check if recipient is contract
641         if (_to.isContract()) {
642             bytes4 retval = IERC1155TokenReceiver(_to).onERC1155Received(msg.sender, _from, _id, _amount, _data);
643             require(retval == ERC1155_RECEIVED_VALUE, "erc1155#_callonerc1155received: INVALID_ON_RECEIVE_MESSAGE");
644         }
645     }
646 
647     /**
648      * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
649      * @param _from     Source addresses
650      * @param _to       Target addresses
651      * @param _ids      IDs of each token type
652      * @param _amounts  Transfer amounts per token type
653      */
654     function _safeBatchTransferFrom(address _from, address _to, uint256[] memory _ids, uint256[] memory _amounts)
655     internal
656     {
657         require(_ids.length == _amounts.length, "erc1155#_safebatchtransferfrom: INVALID_ARRAYS_LENGTH");
658 
659         // Number of transfer to execute
660         uint256 nTransfer = _ids.length;
661 
662         // Executing all transfers
663         for (uint256 i = 0; i < nTransfer; i++) {
664             // Update storage balance of previous bin
665             balances[_from][_ids[i]] = balances[_from][_ids[i]].sub(_amounts[i]);
666             balances[_to][_ids[i]] = balances[_to][_ids[i]].add(_amounts[i]);
667         }
668 
669         // Emit event
670         emit TransferBatch(msg.sender, _from, _to, _ids, _amounts);
671     }
672 
673     /**
674      * @notice Verifies if receiver is contract and if so, calls (_to).onERC1155BatchReceived(...)
675      */
676     function _callonERC1155BatchReceived(address _from, address _to, uint256[] memory _ids, uint256[] memory _amounts, bytes memory _data)
677     internal
678     {
679         // Pass data if recipient is contract
680         if (_to.isContract()) {
681             bytes4 retval = IERC1155TokenReceiver(_to).onERC1155BatchReceived(msg.sender, _from, _ids, _amounts, _data);
682             require(retval == ERC1155_BATCH_RECEIVED_VALUE, "erc1155#_callonerc1155batchreceived: INVALID_ON_RECEIVE_MESSAGE");
683         }
684     }
685 
686 
687     /***********************************|
688     |         Operator Functions        |
689     |__________________________________*/
690 
691     /**
692      * @notice Enable or disable approval for a third party ("operator") to manage all of caller's tokens
693      * @param _operator  Address to add to the set of authorized operators
694      * @param _approved  True if the operator is approved, false to revoke approval
695      */
696     function setApprovalForAll(address _operator, bool _approved)
697     external
698     {
699         // Update operator status
700         operators[msg.sender][_operator] = _approved;
701         emit ApprovalForAll(msg.sender, _operator, _approved);
702     }
703 
704     /**
705      * @notice Queries the approval status of an operator for a given owner
706      * @param _owner     The owner of the Tokens
707      * @param _operator  Address of authorized operator
708      * @return True if the operator is approved, false if not
709      */
710     function isApprovedForAll(address _owner, address _operator)
711     public view returns (bool isOperator)
712     {
713         return operators[_owner][_operator];
714     }
715 
716 
717     /***********************************|
718     |         Balance Functions         |
719     |__________________________________*/
720 
721     /**
722      * @notice Get the balance of an account's Tokens
723      * @param _owner  The address of the token holder
724      * @param _id     ID of the Token
725      * @return The _owner's balance of the Token type requested
726      */
727     function balanceOf(address _owner, uint256 _id)
728     public view returns (uint256)
729     {
730         return balances[_owner][_id];
731     }
732 
733     /**
734      * @notice Get the balance of multiple account/token pairs
735      * @param _owners The addresses of the token holders
736      * @param _ids    ID of the Tokens
737      * @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)
738      */
739     function balanceOfBatch(address[] memory _owners, uint256[] memory _ids)
740     public view returns (uint256[] memory)
741     {
742         require(_owners.length == _ids.length, "erc1155#balanceofbatch: INVALID_ARRAY_LENGTH");
743 
744         // Variables
745         uint256[] memory batchBalances = new uint256[](_owners.length);
746 
747         // Iterate over each owner and token ID
748         for (uint256 i = 0; i < _owners.length; i++) {
749             batchBalances[i] = balances[_owners[i]][_ids[i]];
750         }
751 
752         return batchBalances;
753     }
754 
755 
756     /***********************************|
757     |          ERC165 Functions         |
758     |__________________________________*/
759 
760     /**
761      * INTERFACE_SIGNATURE_ERC165 = bytes4(keccak256("supportsInterface(bytes4)"));
762      */
763     bytes4 constant private INTERFACE_SIGNATURE_ERC165 = 0x01ffc9a7;
764 
765     /**
766      * INTERFACE_SIGNATURE_ERC1155 =
767      * bytes4(keccak256("safeTransferFrom(address,address,uint256,uint256,bytes)")) ^
768      * bytes4(keccak256("safeBatchTransferFrom(address,address,uint256[],uint256[],bytes)")) ^
769      * bytes4(keccak256("balanceOf(address,uint256)")) ^
770      * bytes4(keccak256("balanceOfBatch(address[],uint256[])")) ^
771      * bytes4(keccak256("setApprovalForAll(address,bool)")) ^
772      * bytes4(keccak256("isApprovedForAll(address,address)"));
773      */
774     bytes4 constant private INTERFACE_SIGNATURE_ERC1155 = 0xd9b67a26;
775 
776     /**
777      * @notice Query if a contract implements an interface
778      * @param _interfaceID  The interface identifier, as specified in ERC-165
779      * @return `true` if the contract implements `_interfaceID` and
780      */
781     function supportsInterface(bytes4 _interfaceID) external view returns (bool) {
782         if (_interfaceID == INTERFACE_SIGNATURE_ERC165 ||
783             _interfaceID == INTERFACE_SIGNATURE_ERC1155) {
784             return true;
785         }
786         return false;
787     }
788 
789 }
790 
791 /**
792  * @notice Contract that handles metadata related methods.
793  * @dev Methods assume a deterministic generation of URI based on token IDs.
794  *      Methods also assume that URI uses hex representation of token IDs.
795  */
796 contract ERC1155Metadata {
797 
798     // URI's default URI prefix
799     string internal baseMetadataURI;
800     event URI(string _uri, uint256 indexed _id);
801 
802 
803     /***********************************|
804     |     Metadata Public Function s    |
805     |__________________________________*/
806 
807     /**
808      * @notice A distinct Uniform Resource Identifier (URI) for a given token.
809      * @dev URIs are defined in RFC 3986.
810      *      URIs are assumed to be deterministically generated based on token ID
811      *      Token IDs are assumed to be represented in their hex format in URIs
812      * @return URI string
813      */
814     function uri(uint256 _id) public view returns (string memory) {
815         return string(abi.encodePacked(baseMetadataURI, _uint2str(_id), ".json"));
816     }
817 
818 
819     /***********************************|
820     |    Metadata Internal Functions    |
821     |__________________________________*/
822 
823     /**
824      * @notice Will emit default URI log event for corresponding token _id
825      * @param _tokenIDs Array of IDs of tokens to log default URI
826      */
827     function _logURIs(uint256[] memory _tokenIDs) internal {
828         string memory baseURL = baseMetadataURI;
829         string memory tokenURI;
830 
831         for (uint256 i = 0; i < _tokenIDs.length; i++) {
832             tokenURI = string(abi.encodePacked(baseURL, _uint2str(_tokenIDs[i]), ".json"));
833             emit URI(tokenURI, _tokenIDs[i]);
834         }
835     }
836 
837     /**
838      * @notice Will emit a specific URI log event for corresponding token
839      * @param _tokenIDs IDs of the token corresponding to the _uris logged
840      * @param _URIs    The URIs of the specified _tokenIDs
841      */
842     function _logURIs(uint256[] memory _tokenIDs, string[] memory _URIs) internal {
843         require(_tokenIDs.length == _URIs.length, "erc1155metadata#_loguris: INVALID_ARRAYS_LENGTH");
844         for (uint256 i = 0; i < _tokenIDs.length; i++) {
845             emit URI(_URIs[i], _tokenIDs[i]);
846         }
847     }
848 
849     /**
850      * @notice Will update the base URL of token's URI
851      * @param _newBaseMetadataURI New base URL of token's URI
852      */
853     function _setBaseMetadataURI(string memory _newBaseMetadataURI) internal {
854         baseMetadataURI = _newBaseMetadataURI;
855     }
856 
857 
858     /***********************************|
859     |    Utility Internal Functions     |
860     |__________________________________*/
861 
862     /**
863      * @notice Convert uint256 to string
864      * @param _i Unsigned integer to convert to string
865      */
866     function _uint2str(uint256 _i) internal pure returns (string memory _uintAsString) {
867         if (_i == 0) {
868             return "0";
869         }
870 
871         uint256 j = _i;
872         uint256 ii = _i;
873         uint256 len;
874 
875         // Get number of bytes
876         while (j != 0) {
877             len++;
878             j /= 10;
879         }
880 
881         bytes memory bstr = new bytes(len);
882         uint256 k = len - 1;
883 
884         // Get each individual ASCII
885         while (ii != 0) {
886             bstr[k--] = byte(uint8(48 + ii % 10));
887             ii /= 10;
888         }
889 
890         // Convert to string
891         return string(bstr);
892     }
893 
894 }
895 
896 /**
897  * @dev Multi-Fungible Tokens with minting and burning methods. These methods assume
898  *      a parent contract to be executed as they are `internal` functions
899  */
900 contract ERC1155MintBurn is ERC1155 {
901 
902 
903     /****************************************|
904     |            Minting Functions           |
905     |_______________________________________*/
906 
907     /**
908      * @notice Mint _amount of tokens of a given id
909      * @param _to      The address to mint tokens to
910      * @param _id      Token id to mint
911      * @param _amount  The amount to be minted
912      * @param _data    Data to pass if receiver is contract
913      */
914     function _mint(address _to, uint256 _id, uint256 _amount, bytes memory _data)
915     internal
916     {
917         // Add _amount
918         balances[_to][_id] = balances[_to][_id].add(_amount);
919 
920         // Emit event
921         emit TransferSingle(msg.sender, address(0x0), _to, _id, _amount);
922 
923         // Calling onReceive method if recipient is contract
924         _callonERC1155Received(address(0x0), _to, _id, _amount, _data);
925     }
926 
927     /**
928      * @notice Mint tokens for each ids in _ids
929      * @param _to       The address to mint tokens to
930      * @param _ids      Array of ids to mint
931      * @param _amounts  Array of amount of tokens to mint per id
932      * @param _data    Data to pass if receiver is contract
933      */
934     function _batchMint(address _to, uint256[] memory _ids, uint256[] memory _amounts, bytes memory _data)
935     internal
936     {
937         require(_ids.length == _amounts.length, "erc1155mintburn#batchmint: INVALID_ARRAYS_LENGTH");
938 
939         // Number of mints to execute
940         uint256 nMint = _ids.length;
941 
942         // Executing all minting
943         for (uint256 i = 0; i < nMint; i++) {
944             // Update storage balance
945             balances[_to][_ids[i]] = balances[_to][_ids[i]].add(_amounts[i]);
946         }
947 
948         // Emit batch mint event
949         emit TransferBatch(msg.sender, address(0x0), _to, _ids, _amounts);
950 
951         // Calling onReceive method if recipient is contract
952         _callonERC1155BatchReceived(address(0x0), _to, _ids, _amounts, _data);
953     }
954 
955 
956     /****************************************|
957     |            Burning Functions           |
958     |_______________________________________*/
959 
960     /**
961      * @notice Burn _amount of tokens of a given token id
962      * @param _from    The address to burn tokens from
963      * @param _id      Token id to burn
964      * @param _amount  The amount to be burned
965      */
966     function _burn(address _from, uint256 _id, uint256 _amount)
967     internal
968     {
969         //Substract _amount
970         balances[_from][_id] = balances[_from][_id].sub(_amount);
971 
972         // Emit event
973         emit TransferSingle(msg.sender, _from, address(0x0), _id, _amount);
974     }
975 
976     /**
977      * @notice Burn tokens of given token id for each (_ids[i], _amounts[i]) pair
978      * @param _from     The address to burn tokens from
979      * @param _ids      Array of token ids to burn
980      * @param _amounts  Array of the amount to be burned
981      */
982     function _batchBurn(address _from, uint256[] memory _ids, uint256[] memory _amounts)
983     internal
984     {
985         require(_ids.length == _amounts.length, "erc1155mintburn#batchburn: INVALID_ARRAYS_LENGTH");
986 
987         // Number of mints to execute
988         uint256 nBurn = _ids.length;
989 
990         // Executing all minting
991         for (uint256 i = 0; i < nBurn; i++) {
992             // Update storage balance
993             balances[_from][_ids[i]] = balances[_from][_ids[i]].sub(_amounts[i]);
994         }
995 
996         // Emit batch mint event
997         emit TransferBatch(msg.sender, _from, address(0x0), _ids, _amounts);
998     }
999 
1000 }
1001 
1002 library Strings {
1003     // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
1004     function strConcat(
1005         string memory _a,
1006         string memory _b,
1007         string memory _c,
1008         string memory _d,
1009         string memory _e
1010     ) internal pure returns (string memory) {
1011         bytes memory _ba = bytes(_a);
1012         bytes memory _bb = bytes(_b);
1013         bytes memory _bc = bytes(_c);
1014         bytes memory _bd = bytes(_d);
1015         bytes memory _be = bytes(_e);
1016         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
1017         bytes memory babcde = bytes(abcde);
1018         uint256 k = 0;
1019         for (uint256 i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
1020         for (uint256 i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
1021         for (uint256 i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
1022         for (uint256 i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
1023         for (uint256 i = 0; i < _be.length; i++) babcde[k++] = _be[i];
1024         return string(babcde);
1025     }
1026 
1027     function strConcat(
1028         string memory _a,
1029         string memory _b,
1030         string memory _c,
1031         string memory _d
1032     ) internal pure returns (string memory) {
1033         return strConcat(_a, _b, _c, _d, "");
1034     }
1035 
1036     function strConcat(
1037         string memory _a,
1038         string memory _b,
1039         string memory _c
1040     ) internal pure returns (string memory) {
1041         return strConcat(_a, _b, _c, "", "");
1042     }
1043 
1044     function strConcat(string memory _a, string memory _b) internal pure returns (string memory) {
1045         return strConcat(_a, _b, "", "", "");
1046     }
1047 
1048     function uint2str(uint256 _i) internal pure returns (string memory _uintAsString) {
1049         if (_i == 0) {
1050             return "0";
1051         }
1052         uint256 j = _i;
1053         uint256 len;
1054         while (j != 0) {
1055             len++;
1056             j /= 10;
1057         }
1058         bytes memory bstr = new bytes(len);
1059         uint256 k = len - 1;
1060         while (_i != 0) {
1061             bstr[k--] = bytes1(uint8(48 + (_i % 10)));
1062             _i /= 10;
1063         }
1064         return string(bstr);
1065     }
1066 }
1067 
1068 contract OwnableDelegateProxy {}
1069 
1070 contract ProxyRegistry {
1071     mapping(address => OwnableDelegateProxy) public proxies;
1072 }
1073 
1074 /**
1075  * @title ERC1155Tradable
1076  * ERC1155Tradable - ERC1155 contract that whitelists an operator address,
1077  * has create and mint functionality, and supports useful standards from OpenZeppelin,
1078   like _exists(), name(), symbol(), and totalSupply()
1079  */
1080 contract ERC1155Tradable is ERC1155, ERC1155MintBurn, ERC1155Metadata, Ownable, MinterRole, WhitelistAdminRole {
1081     using Strings for string;
1082 
1083     address proxyRegistryAddress;
1084     uint256 private _currentTokenID = 0;
1085     mapping(uint256 => address) public creators;
1086     mapping(uint256 => uint256) public tokenSupply;
1087     mapping(uint256 => uint256) public tokenMaxSupply;
1088     // Contract name
1089     string public name;
1090     // Contract symbol
1091     string public symbol;
1092 
1093     constructor(
1094         string memory _name,
1095         string memory _symbol,
1096         address _proxyRegistryAddress
1097     ) public {
1098         name = _name;
1099         symbol = _symbol;
1100         proxyRegistryAddress = _proxyRegistryAddress;
1101     }
1102 
1103     function removeWhitelistAdmin(address account) public onlyOwner {
1104         _removeWhitelistAdmin(account);
1105     }
1106 
1107     function removeMinter(address account) public onlyOwner {
1108         _removeMinter(account);
1109     }
1110 
1111     function uri(uint256 _id) public view returns (string memory) {
1112         require(_exists(_id), "erc721tradable#uri: NONEXISTENT_TOKEN");
1113         return Strings.strConcat(baseMetadataURI, Strings.uint2str(_id));
1114     }
1115 
1116     /**
1117      * @dev Returns the total quantity for a token ID
1118      * @param _id uint256 ID of the token to query
1119      * @return amount of token in existence
1120      */
1121     function totalSupply(uint256 _id) public view returns (uint256) {
1122         return tokenSupply[_id];
1123     }
1124 
1125     /**
1126      * @dev Returns the max quantity for a token ID
1127      * @param _id uint256 ID of the token to query
1128      * @return amount of token in existence
1129      */
1130     function maxSupply(uint256 _id) public view returns (uint256) {
1131         return tokenMaxSupply[_id];
1132     }
1133 
1134     /**
1135      * @dev Will update the base URL of token's URI
1136      * @param _newBaseMetadataURI New base URL of token's URI
1137      */
1138     function setBaseMetadataURI(string memory _newBaseMetadataURI) public onlyWhitelistAdmin {
1139         _setBaseMetadataURI(_newBaseMetadataURI);
1140     }
1141 
1142     /**
1143      * @dev Creates a new token type and assigns _initialSupply to an address
1144      * @param _maxSupply max supply allowed
1145      * @param _initialSupply Optional amount to supply the first owner
1146      * @param _uri Optional URI for this token type
1147      * @param _data Optional data to pass if receiver is contract
1148      * @return The newly created token ID
1149      */
1150     function create(
1151         uint256 _maxSupply,
1152         uint256 _initialSupply,
1153         string calldata _uri,
1154         bytes calldata _data
1155     ) external onlyWhitelistAdmin returns (uint256 tokenId) {
1156         require(_initialSupply <= _maxSupply, "initial supply cannot be more than max supply");
1157         uint256 _id = _getNextTokenID();
1158         _incrementTokenTypeId();
1159         creators[_id] = msg.sender;
1160 
1161         if (bytes(_uri).length > 0) {
1162             emit URI(_uri, _id);
1163         }
1164 
1165         if (_initialSupply != 0) _mint(msg.sender, _id, _initialSupply, _data);
1166         tokenSupply[_id] = _initialSupply;
1167         tokenMaxSupply[_id] = _maxSupply;
1168         return _id;
1169     }
1170 
1171     /**
1172      * @dev Mints some amount of tokens to an address
1173      * @param _to          Address of the future owner of the token
1174      * @param _id          Token ID to mint
1175      * @param _quantity    Amount of tokens to mint
1176      * @param _data        Data to pass if receiver is contract
1177      */
1178     function mint(
1179         address _to,
1180         uint256 _id,
1181         uint256 _quantity,
1182         bytes memory _data
1183     ) public onlyMinter {
1184         uint256 tokenId = _id;
1185         uint256 newSupply = tokenSupply[tokenId].add(_quantity);
1186         require(newSupply <= tokenMaxSupply[tokenId], "max supply of nftings reached");
1187         _mint(_to, _id, _quantity, _data);
1188         tokenSupply[_id] = tokenSupply[_id].add(_quantity);
1189     }
1190 
1191     /**
1192      * Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-free listings - The Beano of NFTs
1193      */
1194     function isApprovedForAll(address _owner, address _operator) public view returns (bool isOperator) {
1195         // Whitelist OpenSea proxy contract for easy trading.
1196         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1197         if (address(proxyRegistry.proxies(_owner)) == _operator) {
1198             return true;
1199         }
1200 
1201         return ERC1155.isApprovedForAll(_owner, _operator);
1202     }
1203 
1204     /**
1205      * @dev Returns whether the specified token exists by checking to see if it has a creator
1206      * @param _id uint256 ID of the token to query the existence of
1207      * @return bool whether the token exists
1208      */
1209     function _exists(uint256 _id) internal view returns (bool) {
1210         return creators[_id] != address(0);
1211     }
1212 
1213     /**
1214      * @dev calculates the next token ID based on value of _currentTokenID
1215      * @return uint256 for the next token ID
1216      */
1217     function _getNextTokenID() private view returns (uint256) {
1218         return _currentTokenID.add(1);
1219     }
1220 
1221     /**
1222      * @dev increments the value of _currentTokenID
1223      */
1224     function _incrementTokenTypeId() private {
1225         _currentTokenID++;
1226     }
1227 }
1228 
1229 /**
1230  * @title smol studio
1231  */
1232 contract SmolStudio is ERC1155Tradable {
1233     string private _contractURI;
1234 
1235     constructor(address _proxyRegistryAddress) public ERC1155Tradable("smol studio", "SmolStudio", _proxyRegistryAddress) {
1236         _setBaseMetadataURI("https://api.smol.finance/studio/");
1237         _contractURI = "https://api.smol.finance/studio/tings-erc1155";
1238     }
1239 
1240     function setBaseMetadataURI(string memory newURI) public onlyWhitelistAdmin {
1241         _setBaseMetadataURI(newURI);
1242     }
1243 
1244     function setContractURI(string memory newURI) public onlyWhitelistAdmin {
1245         _contractURI = newURI;
1246     }
1247 
1248     function contractURI() public view returns (string memory) {
1249         return _contractURI;
1250     }
1251 
1252     /**
1253          * @dev Ends minting of token
1254          * @param _id          Token ID for which minting will end
1255          */
1256     function endMinting(uint256 _id) external onlyWhitelistAdmin {
1257         tokenMaxSupply[_id] = tokenSupply[_id];
1258     }
1259 
1260     function burn(address _account, uint256 _id, uint256 _amount) public onlyMinter {
1261         require(balanceOf(_account, _id) >= _amount, "cannot burn more than address has");
1262         _burn(_account, _id, _amount);
1263     }
1264 
1265     /**
1266     * Mint NFT and send those to the list of given addresses
1267     */
1268     function airdrop(uint256 _id, address[] memory _addresses) public onlyMinter {
1269         require(tokenMaxSupply[_id] - tokenSupply[_id] >= _addresses.length, "cannot mint above max supply");
1270         for (uint256 i = 0; i < _addresses.length; i++) {
1271             mint(_addresses[i], _id, 1, "");
1272         }
1273     }
1274 }
1275 
1276 /*
1277 Constructor Argument To Add During Deployment
1278 OpenSea Registry Address
1279 000000000000000000000000a5409ec958c83c3f309868babaca7c86dcb077c1
1280 
1281 0xa5409ec958c83c3f309868babaca7c86dcb077c1
1282 */