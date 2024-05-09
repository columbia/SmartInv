1 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Contract module which provides a basic access control mechanism, where
7  * there is an account (an owner) that can be granted exclusive access to
8  * specific functions.
9  *
10  * This module is used through inheritance. It will make available the modifier
11  * `onlyOwner`, which can be aplied to your functions to restrict their use to
12  * the owner.
13  */
14 contract Ownable {
15     address private _owner;
16 
17     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
18 
19     /**
20      * @dev Initializes the contract setting the deployer as the initial owner.
21      */
22     constructor () internal {
23         _owner = msg.sender;
24         emit OwnershipTransferred(address(0), _owner);
25     }
26 
27     /**
28      * @dev Returns the address of the current owner.
29      */
30     function owner() public view returns (address) {
31         return _owner;
32     }
33 
34     /**
35      * @dev Throws if called by any account other than the owner.
36      */
37     modifier onlyOwner() {
38         require(isOwner(), "Ownable: caller is not the owner");
39         _;
40     }
41 
42     /**
43      * @dev Returns true if the caller is the current owner.
44      */
45     function isOwner() public view returns (bool) {
46         return msg.sender == _owner;
47     }
48 
49     /**
50      * @dev Leaves the contract without owner. It will not be possible to call
51      * `onlyOwner` functions anymore. Can only be called by the current owner.
52      *
53      * > Note: Renouncing ownership will leave the contract without an owner,
54      * thereby removing any functionality that is only available to the owner.
55      */
56     function renounceOwnership() public onlyOwner {
57         emit OwnershipTransferred(_owner, address(0));
58         _owner = address(0);
59     }
60 
61     /**
62      * @dev Transfers ownership of the contract to a new account (`newOwner`).
63      * Can only be called by the current owner.
64      */
65     function transferOwnership(address newOwner) public onlyOwner {
66         _transferOwnership(newOwner);
67     }
68 
69     /**
70      * @dev Transfers ownership of the contract to a new account (`newOwner`).
71      */
72     function _transferOwnership(address newOwner) internal {
73         require(newOwner != address(0), "Ownable: new owner is the zero address");
74         emit OwnershipTransferred(_owner, newOwner);
75         _owner = newOwner;
76     }
77 }
78 
79 // File: multi-token-standard/contracts/interfaces/IERC165.sol
80 
81 pragma solidity ^0.5.12;
82 
83 
84 /**
85  * @title ERC165
86  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
87  */
88 interface IERC165 {
89 
90     /**
91      * @notice Query if a contract implements an interface
92      * @dev Interface identification is specified in ERC-165. This function
93      * uses less than 30,000 gas
94      * @param _interfaceId The interface identifier, as specified in ERC-165
95      */
96     function supportsInterface(bytes4 _interfaceId)
97     external
98     view
99     returns (bool);
100 }
101 
102 // File: multi-token-standard/contracts/utils/SafeMath.sol
103 
104 pragma solidity ^0.5.12;
105 
106 
107 /**
108  * @title SafeMath
109  * @dev Unsigned math operations with safety checks that revert on error
110  */
111 library SafeMath {
112 
113   /**
114    * @dev Multiplies two unsigned integers, reverts on overflow.
115    */
116   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
117     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
118     // benefit is lost if 'b' is also tested.
119     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
120     if (a == 0) {
121       return 0;
122     }
123 
124     uint256 c = a * b;
125     require(c / a == b, "SafeMath#mul: OVERFLOW");
126 
127     return c;
128   }
129 
130   /**
131    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
132    */
133   function div(uint256 a, uint256 b) internal pure returns (uint256) {
134     // Solidity only automatically asserts when dividing by 0
135     require(b > 0, "SafeMath#div: DIVISION_BY_ZERO");
136     uint256 c = a / b;
137     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
138 
139     return c;
140   }
141 
142   /**
143    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
144    */
145   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
146     require(b <= a, "SafeMath#sub: UNDERFLOW");
147     uint256 c = a - b;
148 
149     return c;
150   }
151 
152   /**
153    * @dev Adds two unsigned integers, reverts on overflow.
154    */
155   function add(uint256 a, uint256 b) internal pure returns (uint256) {
156     uint256 c = a + b;
157     require(c >= a, "SafeMath#add: OVERFLOW");
158 
159     return c; 
160   }
161 
162   /**
163    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
164    * reverts when dividing by zero.
165    */
166   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
167     require(b != 0, "SafeMath#mod: DIVISION_BY_ZERO");
168     return a % b;
169   }
170 
171 }
172 
173 // File: multi-token-standard/contracts/interfaces/IERC1155TokenReceiver.sol
174 
175 pragma solidity ^0.5.12;
176 
177 /**
178  * @dev ERC-1155 interface for accepting safe transfers.
179  */
180 interface IERC1155TokenReceiver {
181 
182   /**
183    * @notice Handle the receipt of a single ERC1155 token type
184    * @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeTransferFrom` after the balance has been updated
185    * This function MAY throw to revert and reject the transfer
186    * Return of other amount than the magic value MUST result in the transaction being reverted
187    * Note: The token contract address is always the message sender
188    * @param _operator  The address which called the `safeTransferFrom` function
189    * @param _from      The address which previously owned the token
190    * @param _id        The id of the token being transferred
191    * @param _amount    The amount of tokens being transferred
192    * @param _data      Additional data with no specified format
193    * @return           `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
194    */
195   function onERC1155Received(address _operator, address _from, uint256 _id, uint256 _amount, bytes calldata _data) external returns(bytes4);
196 
197   /**
198    * @notice Handle the receipt of multiple ERC1155 token types
199    * @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeBatchTransferFrom` after the balances have been updated
200    * This function MAY throw to revert and reject the transfer
201    * Return of other amount than the magic value WILL result in the transaction being reverted
202    * Note: The token contract address is always the message sender
203    * @param _operator  The address which called the `safeBatchTransferFrom` function
204    * @param _from      The address which previously owned the token
205    * @param _ids       An array containing ids of each token being transferred
206    * @param _amounts   An array containing amounts of each token being transferred
207    * @param _data      Additional data with no specified format
208    * @return           `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
209    */
210   function onERC1155BatchReceived(address _operator, address _from, uint256[] calldata _ids, uint256[] calldata _amounts, bytes calldata _data) external returns(bytes4);
211 
212   /**
213    * @notice Indicates whether a contract implements the `ERC1155TokenReceiver` functions and so can accept ERC1155 token types.
214    * @param  interfaceID The ERC-165 interface ID that is queried for support.s
215    * @dev This function MUST return true if it implements the ERC1155TokenReceiver interface and ERC-165 interface.
216    *      This function MUST NOT consume more than 5,000 gas.
217    * @return Wheter ERC-165 or ERC1155TokenReceiver interfaces are supported.
218    */
219   function supportsInterface(bytes4 interfaceID) external view returns (bool);
220 
221 }
222 
223 // File: multi-token-standard/contracts/interfaces/IERC1155.sol
224 
225 pragma solidity ^0.5.12;
226 
227 
228 interface IERC1155 {
229   // Events
230 
231   /**
232    * @dev Either TransferSingle or TransferBatch MUST emit when tokens are transferred, including zero amount transfers as well as minting or burning
233    *   Operator MUST be msg.sender
234    *   When minting/creating tokens, the `_from` field MUST be set to `0x0`
235    *   When burning/destroying tokens, the `_to` field MUST be set to `0x0`
236    *   The total amount transferred from address 0x0 minus the total amount transferred to 0x0 may be used by clients and exchanges to be added to the "circulating supply" for a given token ID
237    *   To broadcast the existence of a token ID with no initial balance, the contract SHOULD emit the TransferSingle event from `0x0` to `0x0`, with the token creator as `_operator`, and a `_amount` of 0
238    */
239   event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _amount);
240 
241   /**
242    * @dev Either TransferSingle or TransferBatch MUST emit when tokens are transferred, including zero amount transfers as well as minting or burning
243    *   Operator MUST be msg.sender
244    *   When minting/creating tokens, the `_from` field MUST be set to `0x0`
245    *   When burning/destroying tokens, the `_to` field MUST be set to `0x0`
246    *   The total amount transferred from address 0x0 minus the total amount transferred to 0x0 may be used by clients and exchanges to be added to the "circulating supply" for a given token ID
247    *   To broadcast the existence of multiple token IDs with no initial balance, this SHOULD emit the TransferBatch event from `0x0` to `0x0`, with the token creator as `_operator`, and a `_amount` of 0
248    */
249   event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _amounts);
250 
251   /**
252    * @dev MUST emit when an approval is updated
253    */
254   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
255 
256   /**
257    * @dev MUST emit when the URI is updated for a token ID
258    *   URIs are defined in RFC 3986
259    *   The URI MUST point a JSON file that conforms to the "ERC-1155 Metadata JSON Schema"
260    */
261   event URI(string _amount, uint256 indexed _id);
262 
263   /**
264    * @notice Transfers amount of an _id from the _from address to the _to address specified
265    * @dev MUST emit TransferSingle event on success
266    * Caller must be approved to manage the _from account's tokens (see isApprovedForAll)
267    * MUST throw if `_to` is the zero address
268    * MUST throw if balance of sender for token `_id` is lower than the `_amount` sent
269    * MUST throw on any other error
270    * When transfer is complete, this function MUST check if `_to` is a smart contract (code size > 0). If so, it MUST call `onERC1155Received` on `_to` and revert if the return amount is not `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
271    * @param _from    Source address
272    * @param _to      Target address
273    * @param _id      ID of the token type
274    * @param _amount  Transfered amount
275    * @param _data    Additional data with no specified format, sent in call to `_to`
276    */
277   function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount, bytes calldata _data) external;
278 
279   /**
280    * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
281    * @dev MUST emit TransferBatch event on success
282    * Caller must be approved to manage the _from account's tokens (see isApprovedForAll)
283    * MUST throw if `_to` is the zero address
284    * MUST throw if length of `_ids` is not the same as length of `_amounts`
285    * MUST throw if any of the balance of sender for token `_ids` is lower than the respective `_amounts` sent
286    * MUST throw on any other error
287    * When transfer is complete, this function MUST check if `_to` is a smart contract (code size > 0). If so, it MUST call `onERC1155BatchReceived` on `_to` and revert if the return amount is not `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
288    * Transfers and events MUST occur in the array order they were submitted (_ids[0] before _ids[1], etc)
289    * @param _from     Source addresses
290    * @param _to       Target addresses
291    * @param _ids      IDs of each token type
292    * @param _amounts  Transfer amounts per token type
293    * @param _data     Additional data with no specified format, sent in call to `_to`
294   */
295   function safeBatchTransferFrom(address _from, address _to, uint256[] calldata _ids, uint256[] calldata _amounts, bytes calldata _data) external;
296   
297   /**
298    * @notice Get the balance of an account's Tokens
299    * @param _owner  The address of the token holder
300    * @param _id     ID of the Token
301    * @return        The _owner's balance of the Token type requested
302    */
303   function balanceOf(address _owner, uint256 _id) external view returns (uint256);
304 
305   /**
306    * @notice Get the balance of multiple account/token pairs
307    * @param _owners The addresses of the token holders
308    * @param _ids    ID of the Tokens
309    * @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)
310    */
311   function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids) external view returns (uint256[] memory);
312 
313   /**
314    * @notice Enable or disable approval for a third party ("operator") to manage all of caller's tokens
315    * @dev MUST emit the ApprovalForAll event on success
316    * @param _operator  Address to add to the set of authorized operators
317    * @param _approved  True if the operator is approved, false to revoke approval
318    */
319   function setApprovalForAll(address _operator, bool _approved) external;
320 
321   /**
322    * @notice Queries the approval status of an operator for a given owner
323    * @param _owner     The owner of the Tokens
324    * @param _operator  Address of authorized operator
325    * @return           True if the operator is approved, false if not
326    */
327   function isApprovedForAll(address _owner, address _operator) external view returns (bool isOperator);
328 
329 }
330 
331 // File: multi-token-standard/contracts/utils/Address.sol
332 
333 /**
334  * Copyright 2018 ZeroEx Intl.
335  * Licensed under the Apache License, Version 2.0 (the "License");
336  * you may not use this file except in compliance with the License.
337  * You may obtain a copy of the License at
338  *   http://www.apache.org/licenses/LICENSE-2.0
339  * Unless required by applicable law or agreed to in writing, software
340  * distributed under the License is distributed on an "AS IS" BASIS,
341  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
342  * See the License for the specific language governing permissions and
343  * limitations under the License.
344  */
345 
346 pragma solidity ^0.5.12;
347 
348 
349 /**
350  * Utility library of inline functions on addresses
351  */
352 library Address {
353 
354   /**
355    * Returns whether the target address is a contract
356    * @dev This function will return false if invoked during the constructor of a contract,
357    * as the code is not actually created until after the constructor finishes.
358    * @param account address of the account to check
359    * @return whether the target address is a contract
360    */
361   function isContract(address account) internal view returns (bool) {
362     bytes32 codehash;
363     bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
364 
365     // XXX Currently there is no better way to check if there is a contract in an address
366     // than to check the size of the code at that address.
367     // See https://ethereum.stackexchange.com/a/14016/36603
368     // for more details about how this works.
369     // TODO Check this again before the Serenity release, because all addresses will be
370     // contracts then.
371     assembly { codehash := extcodehash(account) }
372     return (codehash != 0x0 && codehash != accountHash);
373   }
374 
375 }
376 
377 // File: multi-token-standard/contracts/tokens/ERC1155/ERC1155.sol
378 
379 pragma solidity ^0.5.12;
380 
381 
382 
383 
384 
385 
386 
387 /**
388  * @dev Implementation of Multi-Token Standard contract
389  */
390 contract ERC1155 is IERC165 {
391   using SafeMath for uint256;
392   using Address for address;
393 
394 
395   /***********************************|
396   |        Variables and Events       |
397   |__________________________________*/
398 
399   // onReceive function signatures
400   bytes4 constant internal ERC1155_RECEIVED_VALUE = 0xf23a6e61;
401   bytes4 constant internal ERC1155_BATCH_RECEIVED_VALUE = 0xbc197c81;
402 
403   // Objects balances
404   mapping (address => mapping(uint256 => uint256)) internal balances;
405 
406   // Operator Functions
407   mapping (address => mapping(address => bool)) internal operators;
408 
409   // Events
410   event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _amount);
411   event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _amounts);
412   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
413   event URI(string _uri, uint256 indexed _id);
414 
415 
416   /***********************************|
417   |     Public Transfer Functions     |
418   |__________________________________*/
419 
420   /**
421    * @notice Transfers amount amount of an _id from the _from address to the _to address specified
422    * @param _from    Source address
423    * @param _to      Target address
424    * @param _id      ID of the token type
425    * @param _amount  Transfered amount
426    * @param _data    Additional data with no specified format, sent in call to `_to`
427    */
428   function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount, bytes memory _data)
429     public
430   {
431     require((msg.sender == _from) || isApprovedForAll(_from, msg.sender), "ERC1155#safeTransferFrom: INVALID_OPERATOR");
432     require(_to != address(0),"ERC1155#safeTransferFrom: INVALID_RECIPIENT");
433     // require(_amount >= balances[_from][_id]) is not necessary since checked with safemath operations
434 
435     _safeTransferFrom(_from, _to, _id, _amount);
436     _callonERC1155Received(_from, _to, _id, _amount, _data);
437   }
438 
439   /**
440    * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
441    * @param _from     Source addresses
442    * @param _to       Target addresses
443    * @param _ids      IDs of each token type
444    * @param _amounts  Transfer amounts per token type
445    * @param _data     Additional data with no specified format, sent in call to `_to`
446    */
447   function safeBatchTransferFrom(address _from, address _to, uint256[] memory _ids, uint256[] memory _amounts, bytes memory _data)
448     public
449   {
450     // Requirements
451     require((msg.sender == _from) || isApprovedForAll(_from, msg.sender), "ERC1155#safeBatchTransferFrom: INVALID_OPERATOR");
452     require(_to != address(0), "ERC1155#safeBatchTransferFrom: INVALID_RECIPIENT");
453 
454     _safeBatchTransferFrom(_from, _to, _ids, _amounts);
455     _callonERC1155BatchReceived(_from, _to, _ids, _amounts, _data);
456   }
457 
458 
459   /***********************************|
460   |    Internal Transfer Functions    |
461   |__________________________________*/
462 
463   /**
464    * @notice Transfers amount amount of an _id from the _from address to the _to address specified
465    * @param _from    Source address
466    * @param _to      Target address
467    * @param _id      ID of the token type
468    * @param _amount  Transfered amount
469    */
470   function _safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount)
471     internal
472   {
473     // Update balances
474     balances[_from][_id] = balances[_from][_id].sub(_amount); // Subtract amount
475     balances[_to][_id] = balances[_to][_id].add(_amount);     // Add amount
476 
477     // Emit event
478     emit TransferSingle(msg.sender, _from, _to, _id, _amount);
479   }
480 
481   /**
482    * @notice Verifies if receiver is contract and if so, calls (_to).onERC1155Received(...)
483    */
484   function _callonERC1155Received(address _from, address _to, uint256 _id, uint256 _amount, bytes memory _data)
485     internal
486   {
487     // Check if recipient is contract
488     if (_to.isContract()) {
489       bytes4 retval = IERC1155TokenReceiver(_to).onERC1155Received(msg.sender, _from, _id, _amount, _data);
490       require(retval == ERC1155_RECEIVED_VALUE, "ERC1155#_callonERC1155Received: INVALID_ON_RECEIVE_MESSAGE");
491     }
492   }
493 
494   /**
495    * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
496    * @param _from     Source addresses
497    * @param _to       Target addresses
498    * @param _ids      IDs of each token type
499    * @param _amounts  Transfer amounts per token type
500    */
501   function _safeBatchTransferFrom(address _from, address _to, uint256[] memory _ids, uint256[] memory _amounts)
502     internal
503   {
504     require(_ids.length == _amounts.length, "ERC1155#_safeBatchTransferFrom: INVALID_ARRAYS_LENGTH");
505 
506     // Number of transfer to execute
507     uint256 nTransfer = _ids.length;
508 
509     // Executing all transfers
510     for (uint256 i = 0; i < nTransfer; i++) {
511       // Update storage balance of previous bin
512       balances[_from][_ids[i]] = balances[_from][_ids[i]].sub(_amounts[i]);
513       balances[_to][_ids[i]] = balances[_to][_ids[i]].add(_amounts[i]);
514     }
515 
516     // Emit event
517     emit TransferBatch(msg.sender, _from, _to, _ids, _amounts);
518   }
519 
520   /**
521    * @notice Verifies if receiver is contract and if so, calls (_to).onERC1155BatchReceived(...)
522    */
523   function _callonERC1155BatchReceived(address _from, address _to, uint256[] memory _ids, uint256[] memory _amounts, bytes memory _data)
524     internal
525   {
526     // Pass data if recipient is contract
527     if (_to.isContract()) {
528       bytes4 retval = IERC1155TokenReceiver(_to).onERC1155BatchReceived(msg.sender, _from, _ids, _amounts, _data);
529       require(retval == ERC1155_BATCH_RECEIVED_VALUE, "ERC1155#_callonERC1155BatchReceived: INVALID_ON_RECEIVE_MESSAGE");
530     }
531   }
532 
533 
534   /***********************************|
535   |         Operator Functions        |
536   |__________________________________*/
537 
538   /**
539    * @notice Enable or disable approval for a third party ("operator") to manage all of caller's tokens
540    * @param _operator  Address to add to the set of authorized operators
541    * @param _approved  True if the operator is approved, false to revoke approval
542    */
543   function setApprovalForAll(address _operator, bool _approved)
544     external
545   {
546     // Update operator status
547     operators[msg.sender][_operator] = _approved;
548     emit ApprovalForAll(msg.sender, _operator, _approved);
549   }
550 
551   /**
552    * @notice Queries the approval status of an operator for a given owner
553    * @param _owner     The owner of the Tokens
554    * @param _operator  Address of authorized operator
555    * @return True if the operator is approved, false if not
556    */
557   function isApprovedForAll(address _owner, address _operator)
558     public view returns (bool isOperator)
559   {
560     return operators[_owner][_operator];
561   }
562 
563 
564   /***********************************|
565   |         Balance Functions         |
566   |__________________________________*/
567 
568   /**
569    * @notice Get the balance of an account's Tokens
570    * @param _owner  The address of the token holder
571    * @param _id     ID of the Token
572    * @return The _owner's balance of the Token type requested
573    */
574   function balanceOf(address _owner, uint256 _id)
575     public view returns (uint256)
576   {
577     return balances[_owner][_id];
578   }
579 
580   /**
581    * @notice Get the balance of multiple account/token pairs
582    * @param _owners The addresses of the token holders
583    * @param _ids    ID of the Tokens
584    * @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)
585    */
586   function balanceOfBatch(address[] memory _owners, uint256[] memory _ids)
587     public view returns (uint256[] memory)
588   {
589     require(_owners.length == _ids.length, "ERC1155#balanceOfBatch: INVALID_ARRAY_LENGTH");
590 
591     // Variables
592     uint256[] memory batchBalances = new uint256[](_owners.length);
593 
594     // Iterate over each owner and token ID
595     for (uint256 i = 0; i < _owners.length; i++) {
596       batchBalances[i] = balances[_owners[i]][_ids[i]];
597     }
598 
599     return batchBalances;
600   }
601 
602 
603   /***********************************|
604   |          ERC165 Functions         |
605   |__________________________________*/
606 
607   /**
608    * INTERFACE_SIGNATURE_ERC165 = bytes4(keccak256("supportsInterface(bytes4)"));
609    */
610   bytes4 constant private INTERFACE_SIGNATURE_ERC165 = 0x01ffc9a7;
611 
612   /**
613    * INTERFACE_SIGNATURE_ERC1155 =
614    * bytes4(keccak256("safeTransferFrom(address,address,uint256,uint256,bytes)")) ^
615    * bytes4(keccak256("safeBatchTransferFrom(address,address,uint256[],uint256[],bytes)")) ^
616    * bytes4(keccak256("balanceOf(address,uint256)")) ^
617    * bytes4(keccak256("balanceOfBatch(address[],uint256[])")) ^
618    * bytes4(keccak256("setApprovalForAll(address,bool)")) ^
619    * bytes4(keccak256("isApprovedForAll(address,address)"));
620    */
621   bytes4 constant private INTERFACE_SIGNATURE_ERC1155 = 0xd9b67a26;
622 
623   /**
624    * @notice Query if a contract implements an interface
625    * @param _interfaceID  The interface identifier, as specified in ERC-165
626    * @return `true` if the contract implements `_interfaceID` and
627    */
628   function supportsInterface(bytes4 _interfaceID) external view returns (bool) {
629     if (_interfaceID == INTERFACE_SIGNATURE_ERC165 ||
630         _interfaceID == INTERFACE_SIGNATURE_ERC1155) {
631       return true;
632     }
633     return false;
634   }
635 
636 }
637 
638 // File: multi-token-standard/contracts/tokens/ERC1155/ERC1155Metadata.sol
639 
640 pragma solidity ^0.5.11;
641 
642 
643 
644 /**
645  * @notice Contract that handles metadata related methods.
646  * @dev Methods assume a deterministic generation of URI based on token IDs.
647  *      Methods also assume that URI uses hex representation of token IDs.
648  */
649 contract ERC1155Metadata {
650 
651   // URI's default URI prefix
652   string internal baseMetadataURI;
653   event URI(string _uri, uint256 indexed _id);
654 
655 
656   /***********************************|
657   |     Metadata Public Function s    |
658   |__________________________________*/
659 
660   /**
661    * @notice A distinct Uniform Resource Identifier (URI) for a given token.
662    * @dev URIs are defined in RFC 3986.
663    *      URIs are assumed to be deterministically generated based on token ID
664    *      Token IDs are assumed to be represented in their hex format in URIs
665    * @return URI string
666    */
667   function uri(uint256 _id) public view returns (string memory) {
668     return string(abi.encodePacked(baseMetadataURI, _uint2str(_id), ".json"));
669   }
670 
671 
672   /***********************************|
673   |    Metadata Internal Functions    |
674   |__________________________________*/
675 
676   /**
677    * @notice Will emit default URI log event for corresponding token _id
678    * @param _tokenIDs Array of IDs of tokens to log default URI
679    */
680   function _logURIs(uint256[] memory _tokenIDs) internal {
681     string memory baseURL = baseMetadataURI;
682     string memory tokenURI;
683 
684     for (uint256 i = 0; i < _tokenIDs.length; i++) {
685       tokenURI = string(abi.encodePacked(baseURL, _uint2str(_tokenIDs[i]), ".json"));
686       emit URI(tokenURI, _tokenIDs[i]);
687     }
688   }
689 
690   /**
691    * @notice Will emit a specific URI log event for corresponding token
692    * @param _tokenIDs IDs of the token corresponding to the _uris logged
693    * @param _URIs    The URIs of the specified _tokenIDs
694    */
695   function _logURIs(uint256[] memory _tokenIDs, string[] memory _URIs) internal {
696     require(_tokenIDs.length == _URIs.length, "ERC1155Metadata#_logURIs: INVALID_ARRAYS_LENGTH");
697     for (uint256 i = 0; i < _tokenIDs.length; i++) {
698       emit URI(_URIs[i], _tokenIDs[i]);
699     }
700   }
701 
702   /**
703    * @notice Will update the base URL of token's URI
704    * @param _newBaseMetadataURI New base URL of token's URI
705    */
706   function _setBaseMetadataURI(string memory _newBaseMetadataURI) internal {
707     baseMetadataURI = _newBaseMetadataURI;
708   }
709 
710 
711   /***********************************|
712   |    Utility Internal Functions     |
713   |__________________________________*/
714 
715   /**
716    * @notice Convert uint256 to string
717    * @param _i Unsigned integer to convert to string
718    */
719   function _uint2str(uint256 _i) internal pure returns (string memory _uintAsString) {
720     if (_i == 0) {
721       return "0";
722     }
723 
724     uint256 j = _i;
725     uint256 ii = _i;
726     uint256 len;
727 
728     // Get number of bytes
729     while (j != 0) {
730       len++;
731       j /= 10;
732     }
733 
734     bytes memory bstr = new bytes(len);
735     uint256 k = len - 1;
736 
737     // Get each individual ASCII
738     while (ii != 0) {
739       bstr[k--] = byte(uint8(48 + ii % 10));
740       ii /= 10;
741     }
742 
743     // Convert to string
744     return string(bstr);
745   }
746 
747 }
748 
749 // File: multi-token-standard/contracts/tokens/ERC1155/ERC1155MintBurn.sol
750 
751 pragma solidity ^0.5.12;
752 
753 
754 
755 /**
756  * @dev Multi-Fungible Tokens with minting and burning methods. These methods assume
757  *      a parent contract to be executed as they are `internal` functions
758  */
759 contract ERC1155MintBurn is ERC1155 {
760 
761 
762   /****************************************|
763   |            Minting Functions           |
764   |_______________________________________*/
765 
766   /**
767    * @notice Mint _amount of tokens of a given id
768    * @param _to      The address to mint tokens to
769    * @param _id      Token id to mint
770    * @param _amount  The amount to be minted
771    * @param _data    Data to pass if receiver is contract
772    */
773   function _mint(address _to, uint256 _id, uint256 _amount, bytes memory _data)
774     internal
775   {
776     // Add _amount
777     balances[_to][_id] = balances[_to][_id].add(_amount);
778 
779     // Emit event
780     emit TransferSingle(msg.sender, address(0x0), _to, _id, _amount);
781 
782     // Calling onReceive method if recipient is contract
783     _callonERC1155Received(address(0x0), _to, _id, _amount, _data);
784   }
785 
786   /**
787    * @notice Mint tokens for each ids in _ids
788    * @param _to       The address to mint tokens to
789    * @param _ids      Array of ids to mint
790    * @param _amounts  Array of amount of tokens to mint per id
791    * @param _data    Data to pass if receiver is contract
792    */
793   function _batchMint(address _to, uint256[] memory _ids, uint256[] memory _amounts, bytes memory _data)
794     internal
795   {
796     require(_ids.length == _amounts.length, "ERC1155MintBurn#batchMint: INVALID_ARRAYS_LENGTH");
797 
798     // Number of mints to execute
799     uint256 nMint = _ids.length;
800 
801      // Executing all minting
802     for (uint256 i = 0; i < nMint; i++) {
803       // Update storage balance
804       balances[_to][_ids[i]] = balances[_to][_ids[i]].add(_amounts[i]);
805     }
806 
807     // Emit batch mint event
808     emit TransferBatch(msg.sender, address(0x0), _to, _ids, _amounts);
809 
810     // Calling onReceive method if recipient is contract
811     _callonERC1155BatchReceived(address(0x0), _to, _ids, _amounts, _data);
812   }
813 
814 
815   /****************************************|
816   |            Burning Functions           |
817   |_______________________________________*/
818 
819   /**
820    * @notice Burn _amount of tokens of a given token id
821    * @param _from    The address to burn tokens from
822    * @param _id      Token id to burn
823    * @param _amount  The amount to be burned
824    */
825   function _burn(address _from, uint256 _id, uint256 _amount)
826     internal
827   {
828     //Substract _amount
829     balances[_from][_id] = balances[_from][_id].sub(_amount);
830 
831     // Emit event
832     emit TransferSingle(msg.sender, _from, address(0x0), _id, _amount);
833   }
834 
835   /**
836    * @notice Burn tokens of given token id for each (_ids[i], _amounts[i]) pair
837    * @param _from     The address to burn tokens from
838    * @param _ids      Array of token ids to burn
839    * @param _amounts  Array of the amount to be burned
840    */
841   function _batchBurn(address _from, uint256[] memory _ids, uint256[] memory _amounts)
842     internal
843   {
844     require(_ids.length == _amounts.length, "ERC1155MintBurn#batchBurn: INVALID_ARRAYS_LENGTH");
845 
846     // Number of mints to execute
847     uint256 nBurn = _ids.length;
848 
849      // Executing all minting
850     for (uint256 i = 0; i < nBurn; i++) {
851       // Update storage balance
852       balances[_from][_ids[i]] = balances[_from][_ids[i]].sub(_amounts[i]);
853     }
854 
855     // Emit batch mint event
856     emit TransferBatch(msg.sender, _from, address(0x0), _ids, _amounts);
857   }
858 
859 }
860 
861 // File: contracts/Strings.sol
862 
863 pragma solidity ^0.5.11;
864 
865 library Strings {
866   // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
867   function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory) {
868       bytes memory _ba = bytes(_a);
869       bytes memory _bb = bytes(_b);
870       bytes memory _bc = bytes(_c);
871       bytes memory _bd = bytes(_d);
872       bytes memory _be = bytes(_e);
873       string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
874       bytes memory babcde = bytes(abcde);
875       uint k = 0;
876       for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
877       for (uint i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
878       for (uint i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
879       for (uint i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
880       for (uint i = 0; i < _be.length; i++) babcde[k++] = _be[i];
881       return string(babcde);
882     }
883 
884     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory) {
885         return strConcat(_a, _b, _c, _d, "");
886     }
887 
888     function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory) {
889         return strConcat(_a, _b, _c, "", "");
890     }
891 
892     function strConcat(string memory _a, string memory _b) internal pure returns (string memory) {
893         return strConcat(_a, _b, "", "", "");
894     }
895 
896     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
897         if (_i == 0) {
898             return "0";
899         }
900         uint j = _i;
901         uint len;
902         while (j != 0) {
903             len++;
904             j /= 10;
905         }
906         bytes memory bstr = new bytes(len);
907         uint k = len - 1;
908         while (_i != 0) {
909             bstr[k--] = byte(uint8(48 + _i % 10));
910             _i /= 10;
911         }
912         return string(bstr);
913     }
914 }
915 
916 // File: contracts/ERC1155Tradable.sol
917 
918 pragma solidity ^0.5.11;
919 
920 
921 
922 
923 
924 
925 contract OwnableDelegateProxy { }
926 
927 contract ProxyRegistry {
928   mapping(address => OwnableDelegateProxy) public proxies;
929 }
930 
931 /**
932  * @title ERC1155Tradable
933  * ERC1155Tradable - ERC1155 contract that whitelists an operator address, has create and mint functionality, and supports useful standards from OpenZeppelin,
934   like _exists(), name(), symbol(), and totalSupply()
935  */
936 contract ERC1155Tradable is ERC1155, ERC1155MintBurn, ERC1155Metadata, Ownable {
937   using Strings for string;
938 
939   address proxyRegistryAddress;
940   uint256 private _currentTokenID = 0;
941   mapping (uint256 => address) public creators;
942   mapping (uint256 => uint256) public tokenSupply;
943   // Contract name
944   string public name;
945   // Contract symbol
946   string public symbol;
947 
948   /**
949    * @dev Require msg.sender to be the creator of the token id
950    */
951   modifier creatorOnly(uint256 _id) {
952     require(creators[_id] == msg.sender, "ERC1155Tradable#creatorOnly: ONLY_CREATOR_ALLOWED");
953     _;
954   }
955 
956   /**
957    * @dev Require msg.sender to own more than 0 of the token id
958    */
959   modifier ownersOnly(uint256 _id) {
960     require(balances[msg.sender][_id] > 0, "ERC1155Tradable#ownersOnly: ONLY_OWNERS_ALLOWED");
961     _;
962   }
963 
964   constructor(
965     string memory _name,
966     string memory _symbol,
967     address _proxyRegistryAddress
968   ) public {
969     name = _name;
970     symbol = _symbol;
971     proxyRegistryAddress = _proxyRegistryAddress;
972   }
973 
974   function uri(
975     uint256 _id
976   ) public view returns (string memory) {
977     require(_exists(_id), "ERC721Tradable#uri: NONEXISTENT_TOKEN");
978     return Strings.strConcat(
979       baseMetadataURI,
980       Strings.uint2str(_id)
981     );
982   }
983 
984   /**
985     * @dev Returns the total quantity for a token ID
986     * @param _id uint256 ID of the token to query
987     * @return amount of token in existence
988     */
989   function totalSupply(
990     uint256 _id
991   ) public view returns (uint256) {
992     return tokenSupply[_id];
993   }
994 
995   /**
996    * @dev Will update the base URL of token's URI
997    * @param _newBaseMetadataURI New base URL of token's URI
998    */
999   function setBaseMetadataURI(
1000     string memory _newBaseMetadataURI
1001   ) public onlyOwner {
1002     _setBaseMetadataURI(_newBaseMetadataURI);
1003   }
1004 
1005   /**
1006     * @dev Creates a new token type and assigns _initialSupply to an address
1007     * NOTE: remove onlyOwner if you want third parties to create new tokens on your contract (which may change your IDs)
1008     * @param _initialOwner address of the first owner of the token
1009     * @param _initialSupply amount to supply the first owner
1010     * @param _uri Optional URI for this token type
1011     * @param _data Data to pass if receiver is contract
1012     * @return The newly created token ID
1013     */
1014   function create(
1015     address _initialOwner,
1016     uint256 _initialSupply,
1017     string calldata _uri,
1018     bytes calldata _data
1019   ) external onlyOwner returns (uint256) {
1020 
1021     uint256 _id = _getNextTokenID();
1022     _incrementTokenTypeId();
1023     creators[_id] = msg.sender;
1024 
1025     if (bytes(_uri).length > 0) {
1026       emit URI(_uri, _id);
1027     }
1028 
1029     _mint(_initialOwner, _id, _initialSupply, _data);
1030     tokenSupply[_id] = _initialSupply;
1031     return _id;
1032   }
1033 
1034   /**
1035     * @dev Mints some amount of tokens to an address
1036     * @param _to          Address of the future owner of the token
1037     * @param _id          Token ID to mint
1038     * @param _quantity    Amount of tokens to mint
1039     * @param _data        Data to pass if receiver is contract
1040     */
1041   function mint(
1042     address _to,
1043     uint256 _id,
1044     uint256 _quantity,
1045     bytes memory _data
1046   ) public creatorOnly(_id) {
1047     _mint(_to, _id, _quantity, _data);
1048     tokenSupply[_id] += _quantity;
1049   }
1050 
1051   /**
1052     * @dev Mint tokens for each id in _ids
1053     * @param _to          The address to mint tokens to
1054     * @param _ids         Array of ids to mint
1055     * @param _quantities  Array of amounts of tokens to mint per id
1056     * @param _data        Data to pass if receiver is contract
1057     */
1058   function batchMint(
1059     address _to,
1060     uint256[] memory _ids,
1061     uint256[] memory _quantities,
1062     bytes memory _data
1063   ) public {
1064     for (uint256 i = 0; i < _ids.length; i++) {
1065       uint256 _id = _ids[i];
1066       require(creators[_id] == msg.sender, "ERC1155Tradable#batchMint: ONLY_CREATOR_ALLOWED");
1067       uint256 quantity = _quantities[i];
1068       tokenSupply[_id] += quantity;
1069     }
1070     _batchMint(_to, _ids, _quantities, _data);
1071   }
1072 
1073   /**
1074    * Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-free listings.
1075    */
1076   function isApprovedForAll(
1077     address _owner,
1078     address _operator
1079   ) public view returns (bool isOperator) {
1080     // Whitelist OpenSea proxy contract for easy trading.
1081     ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1082     if (address(proxyRegistry.proxies(_owner)) == _operator) {
1083       return true;
1084     }
1085 
1086     return ERC1155.isApprovedForAll(_owner, _operator);
1087   }
1088 
1089   /**
1090     * @dev Returns whether the specified token exists by checking to see if it has a creator
1091     * @param _id uint256 ID of the token to query the existence of
1092     * @return bool whether the token exists
1093     */
1094   function _exists(
1095     uint256 _id
1096   ) internal view returns (bool) {
1097     return creators[_id] != address(0);
1098   }
1099 
1100   /**
1101     * @dev calculates the next token ID based on value of _currentTokenID
1102     * @return uint256 for the next token ID
1103     */
1104   function _getNextTokenID() private view returns (uint256) {
1105     return _currentTokenID.add(1);
1106   }
1107 
1108   /**
1109     * @dev increments the value of _currentTokenID
1110     */
1111   function _incrementTokenTypeId() private  {
1112     _currentTokenID++;
1113   }
1114 }
1115 
1116 // File: contracts/Wearables.sol
1117 
1118 pragma solidity ^0.5.11;
1119 
1120 
1121 /**
1122  * @title MyCollectible
1123  * MyCollectible - a contract for my semi-fungible tokens.
1124  */
1125 contract Wearables is ERC1155Tradable {
1126   constructor(address _proxyRegistryAddress) ERC1155Tradable(
1127     "Cryptovoxel Wearables",
1128     "WEAR",
1129     _proxyRegistryAddress
1130   ) public {
1131     _setBaseMetadataURI("https://www.cryptovoxels.com/w/");
1132   }
1133 }