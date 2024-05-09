1 pragma solidity >=0.5.0 <0.6.0;
2 
3 /*Proven Compiler v0.5.12+commit.7709ece9*/
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 
16 
17 /*
18 
19 /$$$$$$$                     /$$ /$$           /$$$$$$$                            /$$$$$$$
20 | $$__  $$                   | $/| $$          | $$__  $$                          | $$__  $$
21 | $$  \ $$  /$$$$$$  /$$$$$$$|_//$$$$$$        | $$  \ $$ /$$   /$$ /$$   /$$      | $$  \ $$  /$$$$$$   /$$$$$$   /$$$$$$
22 | $$  | $$ /$$__  $$| $$__  $$ |_  $$_/        | $$$$$$$ | $$  | $$| $$  | $$      | $$$$$$$/ /$$__  $$ /$$__  $$ /$$__  $$
23 | $$  | $$| $$  \ $$| $$  \ $$   | $$          | $$__  $$| $$  | $$| $$  | $$      | $$__  $$| $$  \ $$| $$  \ $$| $$$$$$$$
24 | $$  | $$| $$  | $$| $$  | $$   | $$ /$$      | $$  \ $$| $$  | $$| $$  | $$      | $$  \ $$| $$  | $$| $$  | $$| $$_____/
25 | $$$$$$$/|  $$$$$$/| $$  | $$   |  $$$$/      | $$$$$$$/|  $$$$$$/|  $$$$$$$      | $$  | $$|  $$$$$$/| $$$$$$$/|  $$$$$$$
26 |_______/  \______/ |__/  |__/    \___/        |_______/  \______/  \____  $$      |__/  |__/ \______/ | $$____/  \_______/
27                                                                   /$$  | $$                          | $$
28                                                                  |  $$$$$$/                          | $$
29                                                                   \______/                           |__/
30 
31 *Friendly Message from Anon "Devs"*
32 Digital Assets can be extremely volatile - Good Times come with the Bad Times
33 When times are tough we are here to help cope - Don't Buy Rope
34 
35 https://suicidepreventionlifeline.org/
36 1-800-273-8255
37 
38 https://en.wikipedia.org/wiki/List_of_suicide_crisis_lines
39 
40 */
41 
42 
43 contract Context {
44     // Empty internal constructor, to prevent people from mistakenly deploying
45     // an instance of this contract, which should be used via inheritance.
46     constructor () internal { }
47     // solhint-disable-previous-line no-empty-blocks
48 
49     function _msgSender() internal view returns (address payable) {
50         return msg.sender;
51     }
52 
53     function _msgData() internal view returns (bytes memory) {
54         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
55         return msg.data;
56     }
57 }
58 
59 /**
60  * @dev Contract module which provides a basic access control mechanism, where
61  * there is an account (an owner) that can be granted exclusive access to
62  * specific functions.
63  *
64  * This module is used through inheritance. It will make available the modifier
65  * `onlyOwner`, which can be applied to your functions to restrict their use to
66  * the owner.
67  */
68 contract Ownable is Context {
69     address private _owner;
70 
71     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
72 
73     /**
74      * @dev Initializes the contract setting the deployer as the initial owner.
75      */
76     constructor () internal {
77         address msgSender = _msgSender();
78         _owner = msgSender;
79         emit OwnershipTransferred(address(0), msgSender);
80     }
81 
82     /**
83      * @dev Returns the address of the current owner.
84      */
85     function owner() public view returns (address) {
86         return _owner;
87     }
88 
89     /**
90      * @dev Throws if called by any account other than the owner.
91      */
92     modifier onlyOwner() {
93         require(isOwner(), "Ownable: caller is not the owner");
94         _;
95     }
96 
97     /**
98      * @dev Returns true if the caller is the current owner.
99      */
100     function isOwner() public view returns (bool) {
101         return _msgSender() == _owner;
102     }
103 
104     /**
105      * @dev Leaves the contract without owner. It will not be possible to call
106      * `onlyOwner` functions anymore. Can only be called by the current owner.
107      *
108      * NOTE: Renouncing ownership will leave the contract without an owner,
109      * thereby removing any functionality that is only available to the owner.
110      */
111     function renounceOwnership() public onlyOwner {
112         emit OwnershipTransferred(_owner, address(0));
113         _owner = address(0);
114     }
115 
116     /**
117      * @dev Transfers ownership of the contract to a new account (`newOwner`).
118      * Can only be called by the current owner.
119      */
120     function transferOwnership(address newOwner) public onlyOwner {
121         _transferOwnership(newOwner);
122     }
123 
124     /**
125      * @dev Transfers ownership of the contract to a new account (`newOwner`).
126      */
127     function _transferOwnership(address newOwner) internal {
128         require(newOwner != address(0), "Ownable: new owner is the zero address");
129         emit OwnershipTransferred(_owner, newOwner);
130         _owner = newOwner;
131     }
132 }
133 
134 /**
135  * @title Roles
136  * @dev Library for managing addresses assigned to a Role.
137  */
138 library Roles {
139     struct Role {
140         mapping (address => bool) bearer;
141     }
142 
143     /**
144      * @dev Give an account access to this role.
145      */
146     function add(Role storage role, address account) internal {
147         require(!has(role, account), "Roles: account already has role");
148         role.bearer[account] = true;
149     }
150 
151     /**
152      * @dev Remove an account's access to this role.
153      */
154     function remove(Role storage role, address account) internal {
155         require(has(role, account), "Roles: account does not have role");
156         role.bearer[account] = false;
157     }
158 
159     /**
160      * @dev Check if an account has this role.
161      * @return bool
162      */
163     function has(Role storage role, address account) internal view returns (bool) {
164         require(account != address(0), "Roles: account is the zero address");
165         return role.bearer[account];
166     }
167 }
168 
169 contract MinterRole is Context {
170     using Roles for Roles.Role;
171 
172     event MinterAdded(address indexed account);
173     event MinterRemoved(address indexed account);
174 
175     Roles.Role private _minters;
176 
177     constructor () internal {
178         _addMinter(_msgSender());
179     }
180 
181     modifier onlyMinter() {
182         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
183         _;
184     }
185 
186     function isMinter(address account) public view returns (bool) {
187         return _minters.has(account);
188     }
189 
190     function addMinter(address account) public onlyMinter {
191         _addMinter(account);
192     }
193 
194     function renounceMinter() public {
195         _removeMinter(_msgSender());
196     }
197 
198     function _addMinter(address account) internal {
199         _minters.add(account);
200         emit MinterAdded(account);
201     }
202 
203     function _removeMinter(address account) internal {
204         _minters.remove(account);
205         emit MinterRemoved(account);
206     }
207 }
208 
209 /**
210  * @title WhitelistAdminRole
211  * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
212  */
213 contract WhitelistAdminRole is Context {
214     using Roles for Roles.Role;
215 
216     event WhitelistAdminAdded(address indexed account);
217     event WhitelistAdminRemoved(address indexed account);
218 
219     Roles.Role private _whitelistAdmins;
220 
221     constructor () internal {
222         _addWhitelistAdmin(_msgSender());
223     }
224 
225     modifier onlyWhitelistAdmin() {
226         require(isWhitelistAdmin(_msgSender()), "WhitelistAdminRole: caller does not have the WhitelistAdmin role");
227         _;
228     }
229 
230     function isWhitelistAdmin(address account) public view returns (bool) {
231         return _whitelistAdmins.has(account);
232     }
233 
234     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
235         _addWhitelistAdmin(account);
236     }
237 
238     function renounceWhitelistAdmin() public {
239         _removeWhitelistAdmin(_msgSender());
240     }
241 
242     function _addWhitelistAdmin(address account) internal {
243         _whitelistAdmins.add(account);
244         emit WhitelistAdminAdded(account);
245     }
246 
247     function _removeWhitelistAdmin(address account) internal {
248         _whitelistAdmins.remove(account);
249         emit WhitelistAdminRemoved(account);
250     }
251 }
252 
253 /**
254  * @title ERC165
255  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
256  */
257 interface IERC165 {
258 
259     /**
260      * @notice Query if a contract implements an interface
261      * @dev Interface identification is specified in ERC-165. This function
262      * uses less than 30,000 gas
263      * @param _interfaceId The interface identifier, as specified in ERC-165
264      */
265     function supportsInterface(bytes4 _interfaceId)
266     external
267     view
268     returns (bool);
269 }
270 
271 /**
272  * @title SafeMath
273  * @dev Unsigned math operations with safety checks that revert on error
274  */
275 library SafeMath {
276 
277     /**
278      * @dev Multiplies two unsigned integers, reverts on overflow.
279      */
280     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
281         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
282         // benefit is lost if 'b' is also tested.
283         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
284         if (a == 0) {
285             return 0;
286         }
287 
288         uint256 c = a * b;
289         require(c / a == b, "SafeMath#mul: OVERFLOW");
290 
291         return c;
292     }
293 
294     /**
295      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
296      */
297     function div(uint256 a, uint256 b) internal pure returns (uint256) {
298         // Solidity only automatically asserts when dividing by 0
299         require(b > 0, "SafeMath#div: DIVISION_BY_ZERO");
300         uint256 c = a / b;
301         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
302 
303         return c;
304     }
305 
306     /**
307      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
308      */
309     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
310         require(b <= a, "SafeMath#sub: UNDERFLOW");
311         uint256 c = a - b;
312 
313         return c;
314     }
315 
316     /**
317      * @dev Adds two unsigned integers, reverts on overflow.
318      */
319     function add(uint256 a, uint256 b) internal pure returns (uint256) {
320         uint256 c = a + b;
321         require(c >= a, "SafeMath#add: OVERFLOW");
322 
323         return c;
324     }
325 
326     /**
327      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
328      * reverts when dividing by zero.
329      */
330     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
331         require(b != 0, "SafeMath#mod: DIVISION_BY_ZERO");
332         return a % b;
333     }
334 
335 }
336 
337 /**
338  * @dev ERC-1155 interface for accepting safe transfers.
339  */
340 interface IERC1155TokenReceiver {
341 
342     /**
343      * @notice Handle the receipt of a single ERC1155 token type
344      * @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeTransferFrom` after the balance has been updated
345      * This function MAY throw to revert and reject the transfer
346      * Return of other amount than the magic value MUST result in the transaction being reverted
347      * Note: The token contract address is always the message sender
348      * @param _operator  The address which called the `safeTransferFrom` function
349      * @param _from      The address which previously owned the token
350      * @param _id        The id of the token being transferred
351      * @param _amount    The amount of tokens being transferred
352      * @param _data      Additional data with no specified format
353      * @return           `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
354      */
355     function onERC1155Received(address _operator, address _from, uint256 _id, uint256 _amount, bytes calldata _data) external returns(bytes4);
356 
357     /**
358      * @notice Handle the receipt of multiple ERC1155 token types
359      * @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeBatchTransferFrom` after the balances have been updated
360      * This function MAY throw to revert and reject the transfer
361      * Return of other amount than the magic value WILL result in the transaction being reverted
362      * Note: The token contract address is always the message sender
363      * @param _operator  The address which called the `safeBatchTransferFrom` function
364      * @param _from      The address which previously owned the token
365      * @param _ids       An array containing ids of each token being transferred
366      * @param _amounts   An array containing amounts of each token being transferred
367      * @param _data      Additional data with no specified format
368      * @return           `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
369      */
370     function onERC1155BatchReceived(address _operator, address _from, uint256[] calldata _ids, uint256[] calldata _amounts, bytes calldata _data) external returns(bytes4);
371 
372     /**
373      * @notice Indicates whether a contract implements the `ERC1155TokenReceiver` functions and so can accept ERC1155 token types.
374      * @param  interfaceID The ERC-165 interface ID that is queried for support.s
375      * @dev This function MUST return true if it implements the ERC1155TokenReceiver interface and ERC-165 interface.
376      *      This function MUST NOT consume more than 5,000 gas.
377      * @return Wheter ERC-165 or ERC1155TokenReceiver interfaces are supported.
378      */
379     function supportsInterface(bytes4 interfaceID) external view returns (bool);
380 
381 }
382 
383 interface IERC1155 {
384     // Events
385 
386     /**
387      * @dev Either TransferSingle or TransferBatch MUST emit when tokens are transferred, including zero amount transfers as well as minting or burning
388      *   Operator MUST be msg.sender
389      *   When minting/creating tokens, the `_from` field MUST be set to `0x0`
390      *   When burning/destroying tokens, the `_to` field MUST be set to `0x0`
391      *   The total amount transferred from address 0x0 minus the total amount transferred to 0x0 may be used by clients and exchanges to be added to the "circulating supply" for a given token ID
392      *   To broadcast the existence of a token ID with no initial balance, the contract SHOULD emit the TransferSingle event from `0x0` to `0x0`, with the token creator as `_operator`, and a `_amount` of 0
393      */
394     event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _amount);
395 
396     /**
397      * @dev Either TransferSingle or TransferBatch MUST emit when tokens are transferred, including zero amount transfers as well as minting or burning
398      *   Operator MUST be msg.sender
399      *   When minting/creating tokens, the `_from` field MUST be set to `0x0`
400      *   When burning/destroying tokens, the `_to` field MUST be set to `0x0`
401      *   The total amount transferred from address 0x0 minus the total amount transferred to 0x0 may be used by clients and exchanges to be added to the "circulating supply" for a given token ID
402      *   To broadcast the existence of multiple token IDs with no initial balance, this SHOULD emit the TransferBatch event from `0x0` to `0x0`, with the token creator as `_operator`, and a `_amount` of 0
403      */
404     event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _amounts);
405 
406     /**
407      * @dev MUST emit when an approval is updated
408      */
409     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
410 
411     /**
412      * @dev MUST emit when the URI is updated for a token ID
413      *   URIs are defined in RFC 3986
414      *   The URI MUST point a JSON file that conforms to the "ERC-1155 Metadata JSON Schema"
415      */
416     event URI(string _amount, uint256 indexed _id);
417 
418     /**
419      * @notice Transfers amount of an _id from the _from address to the _to address specified
420      * @dev MUST emit TransferSingle event on success
421      * Caller must be approved to manage the _from account's tokens (see isApprovedForAll)
422      * MUST throw if `_to` is the zero address
423      * MUST throw if balance of sender for token `_id` is lower than the `_amount` sent
424      * MUST throw on any other error
425      * When transfer is complete, this function MUST check if `_to` is a smart contract (code size > 0). If so, it MUST call `onERC1155Received` on `_to` and revert if the return amount is not `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
426      * @param _from    Source address
427      * @param _to      Target address
428      * @param _id      ID of the token type
429      * @param _amount  Transfered amount
430      * @param _data    Additional data with no specified format, sent in call to `_to`
431      */
432     function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount, bytes calldata _data) external;
433 
434     /**
435      * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
436      * @dev MUST emit TransferBatch event on success
437      * Caller must be approved to manage the _from account's tokens (see isApprovedForAll)
438      * MUST throw if `_to` is the zero address
439      * MUST throw if length of `_ids` is not the same as length of `_amounts`
440      * MUST throw if any of the balance of sender for token `_ids` is lower than the respective `_amounts` sent
441      * MUST throw on any other error
442      * When transfer is complete, this function MUST check if `_to` is a smart contract (code size > 0). If so, it MUST call `onERC1155BatchReceived` on `_to` and revert if the return amount is not `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
443      * Transfers and events MUST occur in the array order they were submitted (_ids[0] before _ids[1], etc)
444      * @param _from     Source addresses
445      * @param _to       Target addresses
446      * @param _ids      IDs of each token type
447      * @param _amounts  Transfer amounts per token type
448      * @param _data     Additional data with no specified format, sent in call to `_to`
449     */
450     function safeBatchTransferFrom(address _from, address _to, uint256[] calldata _ids, uint256[] calldata _amounts, bytes calldata _data) external;
451 
452     /**
453      * @notice Get the balance of an account's Tokens
454      * @param _owner  The address of the token holder
455      * @param _id     ID of the Token
456      * @return        The _owner's balance of the Token type requested
457      */
458     function balanceOf(address _owner, uint256 _id) external view returns (uint256);
459 
460     /**
461      * @notice Get the balance of multiple account/token pairs
462      * @param _owners The addresses of the token holders
463      * @param _ids    ID of the Tokens
464      * @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)
465      */
466     function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids) external view returns (uint256[] memory);
467 
468     /**
469      * @notice Enable or disable approval for a third party ("operator") to manage all of caller's tokens
470      * @dev MUST emit the ApprovalForAll event on success
471      * @param _operator  Address to add to the set of authorized operators
472      * @param _approved  True if the operator is approved, false to revoke approval
473      */
474     function setApprovalForAll(address _operator, bool _approved) external;
475 
476     /**
477      * @notice Queries the approval status of an operator for a given owner
478      * @param _owner     The owner of the Tokens
479      * @param _operator  Address of authorized operator
480      * @return           True if the operator is approved, false if not
481      */
482     function isApprovedForAll(address _owner, address _operator) external view returns (bool isOperator);
483 
484 }
485 
486 /**
487  * Copyright 2018 ZeroEx Intl.
488  * Licensed under the Apache License, Version 2.0 (the "License");
489  * you may not use this file except in compliance with the License.
490  * You may obtain a copy of the License at
491  *   http://www.apache.org/licenses/LICENSE-2.0
492  * Unless required by applicable law or agreed to in writing, software
493  * distributed under the License is distributed on an "AS IS" BASIS,
494  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
495  * See the License for the specific language governing permissions and
496  * limitations under the License.
497  */
498 /**
499  * Utility library of inline functions on addresses
500  */
501 library Address {
502 
503     /**
504      * Returns whether the target address is a contract
505      * @dev This function will return false if invoked during the constructor of a contract,
506      * as the code is not actually created until after the constructor finishes.
507      * @param account address of the account to check
508      * @return whether the target address is a contract
509      */
510     function isContract(address account) internal view returns (bool) {
511         bytes32 codehash;
512         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
513 
514         // XXX Currently there is no better way to check if there is a contract in an address
515         // than to check the size of the code at that address.
516         // See https://ethereum.stackexchange.com/a/14016/36603
517         // for more details about how this works.
518         // TODO Check this again before the Serenity release, because all addresses will be
519         // contracts then.
520         assembly { codehash := extcodehash(account) }
521         return (codehash != 0x0 && codehash != accountHash);
522     }
523 
524 }
525 
526 /**
527  * @dev Implementation of Multi-Token Standard contract
528  */
529 contract ERC1155 is IERC165 {
530     using SafeMath for uint256;
531     using Address for address;
532 
533 
534     /***********************************|
535     |        Variables and Events       |
536     |__________________________________*/
537 
538     // onReceive function signatures
539     bytes4 constant internal ERC1155_RECEIVED_VALUE = 0xf23a6e61;
540     bytes4 constant internal ERC1155_BATCH_RECEIVED_VALUE = 0xbc197c81;
541 
542     // Objects balances
543     mapping (address => mapping(uint256 => uint256)) internal balances;
544 
545     // Operator Functions
546     mapping (address => mapping(address => bool)) internal operators;
547 
548     // Events
549     event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _amount);
550     event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _amounts);
551     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
552     event URI(string _uri, uint256 indexed _id);
553 
554 
555     /***********************************|
556     |     Public Transfer Functions     |
557     |__________________________________*/
558 
559     /**
560      * @notice Transfers amount amount of an _id from the _from address to the _to address specified
561      * @param _from    Source address
562      * @param _to      Target address
563      * @param _id      ID of the token type
564      * @param _amount  Transfered amount
565      * @param _data    Additional data with no specified format, sent in call to `_to`
566      */
567     function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount, bytes memory _data)
568     public
569     {
570         require((msg.sender == _from) || isApprovedForAll(_from, msg.sender), "ERC1155#safeTransferFrom: INVALID_OPERATOR");
571         require(_to != address(0),"ERC1155#safeTransferFrom: INVALID_RECIPIENT");
572         // require(_amount >= balances[_from][_id]) is not necessary since checked with safemath operations
573 
574         _safeTransferFrom(_from, _to, _id, _amount);
575         _callonERC1155Received(_from, _to, _id, _amount, _data);
576     }
577 
578     /**
579      * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
580      * @param _from     Source addresses
581      * @param _to       Target addresses
582      * @param _ids      IDs of each token type
583      * @param _amounts  Transfer amounts per token type
584      * @param _data     Additional data with no specified format, sent in call to `_to`
585      */
586     function safeBatchTransferFrom(address _from, address _to, uint256[] memory _ids, uint256[] memory _amounts, bytes memory _data)
587     public
588     {
589         // Requirements
590         require((msg.sender == _from) || isApprovedForAll(_from, msg.sender), "ERC1155#safeBatchTransferFrom: INVALID_OPERATOR");
591         require(_to != address(0), "ERC1155#safeBatchTransferFrom: INVALID_RECIPIENT");
592 
593         _safeBatchTransferFrom(_from, _to, _ids, _amounts);
594         _callonERC1155BatchReceived(_from, _to, _ids, _amounts, _data);
595     }
596 
597 
598     /***********************************|
599     |    Internal Transfer Functions    |
600     |__________________________________*/
601 
602     /**
603      * @notice Transfers amount amount of an _id from the _from address to the _to address specified
604      * @param _from    Source address
605      * @param _to      Target address
606      * @param _id      ID of the token type
607      * @param _amount  Transfered amount
608      */
609     function _safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount)
610     internal
611     {
612         // Update balances
613         balances[_from][_id] = balances[_from][_id].sub(_amount); // Subtract amount
614         balances[_to][_id] = balances[_to][_id].add(_amount);     // Add amount
615 
616         // Emit event
617         emit TransferSingle(msg.sender, _from, _to, _id, _amount);
618     }
619 
620     /**
621      * @notice Verifies if receiver is contract and if so, calls (_to).onERC1155Received(...)
622      */
623     function _callonERC1155Received(address _from, address _to, uint256 _id, uint256 _amount, bytes memory _data)
624     internal
625     {
626         // Check if recipient is contract
627         if (_to.isContract()) {
628             bytes4 retval = IERC1155TokenReceiver(_to).onERC1155Received(msg.sender, _from, _id, _amount, _data);
629             require(retval == ERC1155_RECEIVED_VALUE, "ERC1155#_callonERC1155Received: INVALID_ON_RECEIVE_MESSAGE");
630         }
631     }
632 
633     /**
634      * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
635      * @param _from     Source addresses
636      * @param _to       Target addresses
637      * @param _ids      IDs of each token type
638      * @param _amounts  Transfer amounts per token type
639      */
640     function _safeBatchTransferFrom(address _from, address _to, uint256[] memory _ids, uint256[] memory _amounts)
641     internal
642     {
643         require(_ids.length == _amounts.length, "ERC1155#_safeBatchTransferFrom: INVALID_ARRAYS_LENGTH");
644 
645         // Number of transfer to execute
646         uint256 nTransfer = _ids.length;
647 
648         // Executing all transfers
649         for (uint256 i = 0; i < nTransfer; i++) {
650             // Update storage balance of previous bin
651             balances[_from][_ids[i]] = balances[_from][_ids[i]].sub(_amounts[i]);
652             balances[_to][_ids[i]] = balances[_to][_ids[i]].add(_amounts[i]);
653         }
654 
655         // Emit event
656         emit TransferBatch(msg.sender, _from, _to, _ids, _amounts);
657     }
658 
659     /**
660      * @notice Verifies if receiver is contract and if so, calls (_to).onERC1155BatchReceived(...)
661      */
662     function _callonERC1155BatchReceived(address _from, address _to, uint256[] memory _ids, uint256[] memory _amounts, bytes memory _data)
663     internal
664     {
665         // Pass data if recipient is contract
666         if (_to.isContract()) {
667             bytes4 retval = IERC1155TokenReceiver(_to).onERC1155BatchReceived(msg.sender, _from, _ids, _amounts, _data);
668             require(retval == ERC1155_BATCH_RECEIVED_VALUE, "ERC1155#_callonERC1155BatchReceived: INVALID_ON_RECEIVE_MESSAGE");
669         }
670     }
671 
672 
673     /***********************************|
674     |         Operator Functions        |
675     |__________________________________*/
676 
677     /**
678      * @notice Enable or disable approval for a third party ("operator") to manage all of caller's tokens
679      * @param _operator  Address to add to the set of authorized operators
680      * @param _approved  True if the operator is approved, false to revoke approval
681      */
682     function setApprovalForAll(address _operator, bool _approved)
683     external
684     {
685         // Update operator status
686         operators[msg.sender][_operator] = _approved;
687         emit ApprovalForAll(msg.sender, _operator, _approved);
688     }
689 
690     /**
691      * @notice Queries the approval status of an operator for a given owner
692      * @param _owner     The owner of the Tokens
693      * @param _operator  Address of authorized operator
694      * @return True if the operator is approved, false if not
695      */
696     function isApprovedForAll(address _owner, address _operator)
697     public view returns (bool isOperator)
698     {
699         return operators[_owner][_operator];
700     }
701 
702 
703     /***********************************|
704     |         Balance Functions         |
705     |__________________________________*/
706 
707     /**
708      * @notice Get the balance of an account's Tokens
709      * @param _owner  The address of the token holder
710      * @param _id     ID of the Token
711      * @return The _owner's balance of the Token type requested
712      */
713     function balanceOf(address _owner, uint256 _id)
714     public view returns (uint256)
715     {
716         return balances[_owner][_id];
717     }
718 
719     /**
720      * @notice Get the balance of multiple account/token pairs
721      * @param _owners The addresses of the token holders
722      * @param _ids    ID of the Tokens
723      * @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)
724      */
725     function balanceOfBatch(address[] memory _owners, uint256[] memory _ids)
726     public view returns (uint256[] memory)
727     {
728         require(_owners.length == _ids.length, "ERC1155#balanceOfBatch: INVALID_ARRAY_LENGTH");
729 
730         // Variables
731         uint256[] memory batchBalances = new uint256[](_owners.length);
732 
733         // Iterate over each owner and token ID
734         for (uint256 i = 0; i < _owners.length; i++) {
735             batchBalances[i] = balances[_owners[i]][_ids[i]];
736         }
737 
738         return batchBalances;
739     }
740 
741 
742     /***********************************|
743     |          ERC165 Functions         |
744     |__________________________________*/
745 
746     /**
747      * INTERFACE_SIGNATURE_ERC165 = bytes4(keccak256("supportsInterface(bytes4)"));
748      */
749     bytes4 constant private INTERFACE_SIGNATURE_ERC165 = 0x01ffc9a7;
750 
751     /**
752      * INTERFACE_SIGNATURE_ERC1155 =
753      * bytes4(keccak256("safeTransferFrom(address,address,uint256,uint256,bytes)")) ^
754      * bytes4(keccak256("safeBatchTransferFrom(address,address,uint256[],uint256[],bytes)")) ^
755      * bytes4(keccak256("balanceOf(address,uint256)")) ^
756      * bytes4(keccak256("balanceOfBatch(address[],uint256[])")) ^
757      * bytes4(keccak256("setApprovalForAll(address,bool)")) ^
758      * bytes4(keccak256("isApprovedForAll(address,address)"));
759      */
760     bytes4 constant private INTERFACE_SIGNATURE_ERC1155 = 0xd9b67a26;
761 
762     /**
763      * @notice Query if a contract implements an interface
764      * @param _interfaceID  The interface identifier, as specified in ERC-165
765      * @return `true` if the contract implements `_interfaceID` and
766      */
767     function supportsInterface(bytes4 _interfaceID) external view returns (bool) {
768         if (_interfaceID == INTERFACE_SIGNATURE_ERC165 ||
769             _interfaceID == INTERFACE_SIGNATURE_ERC1155) {
770             return true;
771         }
772         return false;
773     }
774 
775 }
776 
777 /**
778  * @notice Contract that handles metadata related methods.
779  * @dev Methods assume a deterministic generation of URI based on token IDs.
780  *      Methods also assume that URI uses hex representation of token IDs.
781  */
782 contract ERC1155Metadata {
783 
784     // URI's default URI prefix
785     string internal baseMetadataURI;
786     event URI(string _uri, uint256 indexed _id);
787 
788 
789     /***********************************|
790     |     Metadata Public Function s    |
791     |__________________________________*/
792 
793     /**
794      * @notice A distinct Uniform Resource Identifier (URI) for a given token.
795      * @dev URIs are defined in RFC 3986.
796      *      URIs are assumed to be deterministically generated based on token ID
797      *      Token IDs are assumed to be represented in their hex format in URIs
798      * @return URI string
799      */
800     function uri(uint256 _id) public view returns (string memory) {
801         return string(abi.encodePacked(baseMetadataURI, _uint2str(_id), ".json"));
802     }
803 
804 
805     /***********************************|
806     |    Metadata Internal Functions    |
807     |__________________________________*/
808 
809     /**
810      * @notice Will emit default URI log event for corresponding token _id
811      * @param _tokenIDs Array of IDs of tokens to log default URI
812      */
813     function _logURIs(uint256[] memory _tokenIDs) internal {
814         string memory baseURL = baseMetadataURI;
815         string memory tokenURI;
816 
817         for (uint256 i = 0; i < _tokenIDs.length; i++) {
818             tokenURI = string(abi.encodePacked(baseURL, _uint2str(_tokenIDs[i]), ".json"));
819             emit URI(tokenURI, _tokenIDs[i]);
820         }
821     }
822 
823     /**
824      * @notice Will emit a specific URI log event for corresponding token
825      * @param _tokenIDs IDs of the token corresponding to the _uris logged
826      * @param _URIs    The URIs of the specified _tokenIDs
827      */
828     function _logURIs(uint256[] memory _tokenIDs, string[] memory _URIs) internal {
829         require(_tokenIDs.length == _URIs.length, "ERC1155Metadata#_logURIs: INVALID_ARRAYS_LENGTH");
830         for (uint256 i = 0; i < _tokenIDs.length; i++) {
831             emit URI(_URIs[i], _tokenIDs[i]);
832         }
833     }
834 
835     /**
836      * @notice Will update the base URL of token's URI
837      * @param _newBaseMetadataURI New base URL of token's URI
838      */
839     function _setBaseMetadataURI(string memory _newBaseMetadataURI) internal {
840         baseMetadataURI = _newBaseMetadataURI;
841     }
842 
843 
844     /***********************************|
845     |    Utility Internal Functions     |
846     |__________________________________*/
847 
848     /**
849      * @notice Convert uint256 to string
850      * @param _i Unsigned integer to convert to string
851      */
852     function _uint2str(uint256 _i) internal pure returns (string memory _uintAsString) {
853         if (_i == 0) {
854             return "0";
855         }
856 
857         uint256 j = _i;
858         uint256 ii = _i;
859         uint256 len;
860 
861         // Get number of bytes
862         while (j != 0) {
863             len++;
864             j /= 10;
865         }
866 
867         bytes memory bstr = new bytes(len);
868         uint256 k = len - 1;
869 
870         // Get each individual ASCII
871         while (ii != 0) {
872             bstr[k--] = byte(uint8(48 + ii % 10));
873             ii /= 10;
874         }
875 
876         // Convert to string
877         return string(bstr);
878     }
879 
880 }
881 
882 /**
883  * @dev Multi-Fungible Tokens with minting and burning methods. These methods assume
884  *      a parent contract to be executed as they are `internal` functions
885  */
886 contract ERC1155MintBurn is ERC1155 {
887 
888 
889     /****************************************|
890     |            Minting Functions           |
891     |_______________________________________*/
892 
893     /**
894      * @notice Mint _amount of tokens of a given id
895      * @param _to      The address to mint tokens to
896      * @param _id      Token id to mint
897      * @param _amount  The amount to be minted
898      * @param _data    Data to pass if receiver is contract
899      */
900     function _mint(address _to, uint256 _id, uint256 _amount, bytes memory _data)
901     internal
902     {
903         // Add _amount
904         balances[_to][_id] = balances[_to][_id].add(_amount);
905 
906         // Emit event
907         emit TransferSingle(msg.sender, address(0x0), _to, _id, _amount);
908 
909         // Calling onReceive method if recipient is contract
910         _callonERC1155Received(address(0x0), _to, _id, _amount, _data);
911     }
912 
913     /**
914      * @notice Mint tokens for each ids in _ids
915      * @param _to       The address to mint tokens to
916      * @param _ids      Array of ids to mint
917      * @param _amounts  Array of amount of tokens to mint per id
918      * @param _data    Data to pass if receiver is contract
919      */
920     function _batchMint(address _to, uint256[] memory _ids, uint256[] memory _amounts, bytes memory _data)
921     internal
922     {
923         require(_ids.length == _amounts.length, "ERC1155MintBurn#batchMint: INVALID_ARRAYS_LENGTH");
924 
925         // Number of mints to execute
926         uint256 nMint = _ids.length;
927 
928         // Executing all minting
929         for (uint256 i = 0; i < nMint; i++) {
930             // Update storage balance
931             balances[_to][_ids[i]] = balances[_to][_ids[i]].add(_amounts[i]);
932         }
933 
934         // Emit batch mint event
935         emit TransferBatch(msg.sender, address(0x0), _to, _ids, _amounts);
936 
937         // Calling onReceive method if recipient is contract
938         _callonERC1155BatchReceived(address(0x0), _to, _ids, _amounts, _data);
939     }
940 
941 
942     /****************************************|
943     |            Burning Functions           |
944     |_______________________________________*/
945 
946     /**
947      * @notice Burn _amount of tokens of a given token id
948      * @param _from    The address to burn tokens from
949      * @param _id      Token id to burn
950      * @param _amount  The amount to be burned
951      */
952     function _burn(address _from, uint256 _id, uint256 _amount)
953     internal
954     {
955         //Substract _amount
956         balances[_from][_id] = balances[_from][_id].sub(_amount);
957 
958         // Emit event
959         emit TransferSingle(msg.sender, _from, address(0x0), _id, _amount);
960     }
961 
962     /**
963      * @notice Burn tokens of given token id for each (_ids[i], _amounts[i]) pair
964      * @param _from     The address to burn tokens from
965      * @param _ids      Array of token ids to burn
966      * @param _amounts  Array of the amount to be burned
967      */
968     function _batchBurn(address _from, uint256[] memory _ids, uint256[] memory _amounts)
969     internal
970     {
971         require(_ids.length == _amounts.length, "ERC1155MintBurn#batchBurn: INVALID_ARRAYS_LENGTH");
972 
973         // Number of mints to execute
974         uint256 nBurn = _ids.length;
975 
976         // Executing all minting
977         for (uint256 i = 0; i < nBurn; i++) {
978             // Update storage balance
979             balances[_from][_ids[i]] = balances[_from][_ids[i]].sub(_amounts[i]);
980         }
981 
982         // Emit batch mint event
983         emit TransferBatch(msg.sender, _from, address(0x0), _ids, _amounts);
984     }
985 
986 }
987 
988 library Strings {
989     // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
990     function strConcat(
991         string memory _a,
992         string memory _b,
993         string memory _c,
994         string memory _d,
995         string memory _e
996     ) internal pure returns (string memory) {
997         bytes memory _ba = bytes(_a);
998         bytes memory _bb = bytes(_b);
999         bytes memory _bc = bytes(_c);
1000         bytes memory _bd = bytes(_d);
1001         bytes memory _be = bytes(_e);
1002         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
1003         bytes memory babcde = bytes(abcde);
1004         uint256 k = 0;
1005         for (uint256 i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
1006         for (uint256 i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
1007         for (uint256 i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
1008         for (uint256 i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
1009         for (uint256 i = 0; i < _be.length; i++) babcde[k++] = _be[i];
1010         return string(babcde);
1011     }
1012 
1013     function strConcat(
1014         string memory _a,
1015         string memory _b,
1016         string memory _c,
1017         string memory _d
1018     ) internal pure returns (string memory) {
1019         return strConcat(_a, _b, _c, _d, "");
1020     }
1021 
1022     function strConcat(
1023         string memory _a,
1024         string memory _b,
1025         string memory _c
1026     ) internal pure returns (string memory) {
1027         return strConcat(_a, _b, _c, "", "");
1028     }
1029 
1030     function strConcat(string memory _a, string memory _b) internal pure returns (string memory) {
1031         return strConcat(_a, _b, "", "", "");
1032     }
1033 
1034     function uint2str(uint256 _i) internal pure returns (string memory _uintAsString) {
1035         if (_i == 0) {
1036             return "0";
1037         }
1038         uint256 j = _i;
1039         uint256 len;
1040         while (j != 0) {
1041             len++;
1042             j /= 10;
1043         }
1044         bytes memory bstr = new bytes(len);
1045         uint256 k = len - 1;
1046         while (_i != 0) {
1047             bstr[k--] = bytes1(uint8(48 + (_i % 10)));
1048             _i /= 10;
1049         }
1050         return string(bstr);
1051     }
1052 }
1053 
1054 contract OwnableDelegateProxy {}
1055 
1056 contract ProxyRegistry {
1057     mapping(address => OwnableDelegateProxy) public proxies;
1058 }
1059 
1060 /**
1061  * @title ERC1155Tradable
1062  * ERC1155Tradable - ERC1155 contract that whitelists an operator address,
1063  * has create and mint functionality, and supports useful standards from OpenZeppelin,
1064   like _exists(), name(), symbol(), and totalSupply()
1065  */
1066 contract ERC1155Tradable is ERC1155, ERC1155MintBurn, ERC1155Metadata, Ownable, MinterRole, WhitelistAdminRole {
1067     using Strings for string;
1068 
1069     address proxyRegistryAddress;
1070     uint256 private _currentTokenID = 0;
1071     mapping(uint256 => address) public creators;
1072     mapping(uint256 => uint256) public tokenSupply;
1073     mapping(uint256 => uint256) public tokenMaxSupply;
1074     // Contract name
1075     string public name;
1076     // Contract symbol
1077     string public symbol;
1078 
1079     constructor(
1080         string memory _name,
1081         string memory _symbol,
1082         address _proxyRegistryAddress
1083     ) public {
1084         name = _name;
1085         symbol = _symbol;
1086         proxyRegistryAddress = _proxyRegistryAddress;
1087     }
1088 
1089     function removeWhitelistAdmin(address account) public onlyOwner {
1090         _removeWhitelistAdmin(account);
1091     }
1092 
1093     function removeMinter(address account) public onlyOwner {
1094         _removeMinter(account);
1095     }
1096 
1097     function uri(uint256 _id) public view returns (string memory) {
1098         require(_exists(_id), "ERC721Tradable#uri: NONEXISTENT_TOKEN");
1099         return Strings.strConcat(baseMetadataURI, Strings.uint2str(_id));
1100     }
1101 
1102     /**
1103      * @dev Returns the total quantity for a token ID
1104      * @param _id uint256 ID of the token to query
1105      * @return amount of token in existence
1106      */
1107     function totalSupply(uint256 _id) public view returns (uint256) {
1108         return tokenSupply[_id];
1109     }
1110 
1111     /**
1112      * @dev Returns the max quantity for a token ID
1113      * @param _id uint256 ID of the token to query
1114      * @return amount of token in existence
1115      */
1116     function maxSupply(uint256 _id) public view returns (uint256) {
1117         return tokenMaxSupply[_id];
1118     }
1119 
1120     /**
1121      * @dev Will update the base URL of token's URI
1122      * @param _newBaseMetadataURI New base URL of token's URI
1123      */
1124     function setBaseMetadataURI(string memory _newBaseMetadataURI) public onlyWhitelistAdmin {
1125         _setBaseMetadataURI(_newBaseMetadataURI);
1126     }
1127 
1128     /**
1129      * @dev Creates a new token type and assigns _initialSupply to an address
1130      * @param _maxSupply max supply allowed
1131      * @param _initialSupply Optional amount to supply the first owner
1132      * @param _uri Optional URI for this token type
1133      * @param _data Optional data to pass if receiver is contract
1134      * @return The newly created token ID
1135      */
1136     function create(
1137         uint256 _maxSupply,
1138         uint256 _initialSupply,
1139         string calldata _uri,
1140         bytes calldata _data
1141     ) external onlyWhitelistAdmin returns (uint256 tokenId) {
1142         require(_initialSupply <= _maxSupply, "Initial supply cannot be more than max supply");
1143         uint256 _id = _getNextTokenID();
1144         _incrementTokenTypeId();
1145         creators[_id] = msg.sender;
1146 
1147         if (bytes(_uri).length > 0) {
1148             emit URI(_uri, _id);
1149         }
1150 
1151         if (_initialSupply != 0) _mint(msg.sender, _id, _initialSupply, _data);
1152         tokenSupply[_id] = _initialSupply;
1153         tokenMaxSupply[_id] = _maxSupply;
1154         return _id;
1155     }
1156 
1157     /**
1158      * @dev Mints some amount of tokens to an address
1159      * @param _to          Address of the future owner of the token
1160      * @param _id          Token ID to mint
1161      * @param _quantity    Amount of tokens to mint
1162      * @param _data        Data to pass if receiver is contract
1163      */
1164     function mint(
1165         address _to,
1166         uint256 _id,
1167         uint256 _quantity,
1168         bytes memory _data
1169     ) public onlyMinter {
1170         uint256 tokenId = _id;
1171         uint256 newSupply = tokenSupply[tokenId].add(_quantity);
1172         require(newSupply <= tokenMaxSupply[tokenId], "Max supply reached");
1173         _mint(_to, _id, _quantity, _data);
1174         tokenSupply[_id] = tokenSupply[_id].add(_quantity);
1175     }
1176 
1177     /**
1178      * Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-free listings - The Beano of NFTs
1179      */
1180     function isApprovedForAll(address _owner, address _operator) public view returns (bool isOperator) {
1181         // Whitelist OpenSea proxy contract for easy trading.
1182         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1183         if (address(proxyRegistry.proxies(_owner)) == _operator) {
1184             return true;
1185         }
1186 
1187         return ERC1155.isApprovedForAll(_owner, _operator);
1188     }
1189 
1190     /**
1191      * @dev Returns whether the specified token exists by checking to see if it has a creator
1192      * @param _id uint256 ID of the token to query the existence of
1193      * @return bool whether the token exists
1194      */
1195     function _exists(uint256 _id) internal view returns (bool) {
1196         return creators[_id] != address(0);
1197     }
1198 
1199     /**
1200      * @dev calculates the next token ID based on value of _currentTokenID
1201      * @return uint256 for the next token ID
1202      */
1203     function _getNextTokenID() private view returns (uint256) {
1204         return _currentTokenID.add(1);
1205     }
1206 
1207     /**
1208      * @dev increments the value of _currentTokenID
1209      */
1210     function _incrementTokenTypeId() private {
1211         _currentTokenID++;
1212     }
1213 }
1214 
1215 /**
1216  * @title Rope Makers United
1217  * RMU - Seriously as Professional Rope Makers, Don't Buy Rope
1218  */
1219 contract RMU is ERC1155Tradable {
1220     string private _contractURI;
1221 
1222     constructor(address _proxyRegistryAddress) public ERC1155Tradable("Rope Makers United", "RMU", _proxyRegistryAddress) {
1223         _setBaseMetadataURI("https://rope.lol/api/RMU/");
1224         _contractURI = "https://rope.lol/api/hopes-erc1155";
1225     }
1226 
1227     function setBaseMetadataURI(string memory newURI) public onlyWhitelistAdmin {
1228         _setBaseMetadataURI(newURI);
1229     }
1230 
1231     function setContractURI(string memory newURI) public onlyWhitelistAdmin {
1232         _contractURI = newURI;
1233     }
1234 
1235     function contractURI() public view returns (string memory) {
1236         return _contractURI;
1237     }
1238 
1239     /**
1240 	 * @dev Ends minting of token
1241 	 * @param _id          Token ID for which minting will end
1242 	 */
1243     function endMinting(uint256 _id) external onlyWhitelistAdmin {
1244         tokenMaxSupply[_id] = tokenSupply[_id];
1245     }
1246 
1247     function burn(address _account, uint256 _id, uint256 _amount) public onlyMinter {
1248         require(balanceOf(_account, _id) >= _amount, "Cannot burn more than addres has");
1249         _burn(_account, _id, _amount);
1250     }
1251 
1252     /**
1253     * Mint NFT and send those to the list of given addresses
1254     */
1255     function airdrop(uint256 _id, address[] memory _addresses) public onlyMinter {
1256         require(tokenMaxSupply[_id] - tokenSupply[_id] >= _addresses.length, "Cant mint above max supply");
1257         for (uint256 i = 0; i < _addresses.length; i++) {
1258             mint(_addresses[i], _id, 1, "");
1259         }
1260     }
1261 }
1262 
1263 /*
1264 Constructor Argument To Add During Deployment
1265 OpenSea Registry Address
1266 000000000000000000000000a5409ec958c83c3f309868babaca7c86dcb077c1
1267 
1268 0xa5409ec958c83c3f309868babaca7c86dcb077c1
1269 */