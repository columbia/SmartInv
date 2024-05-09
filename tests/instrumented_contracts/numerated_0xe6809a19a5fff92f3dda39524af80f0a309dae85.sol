1 // SPDX-Identifier: MIT
2 pragma solidity >= 0.5.17;
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
30 // File: openzeppelin-solidity\contracts\ownership\Ownable.sol
31 
32 
33 /**
34  * @dev Contract module which provides a basic access control mechanism, where
35  * there is an account (an owner) that can be granted exclusive access to
36  * specific functions.
37  *
38  * This module is used through inheritance. It will make available the modifier
39  * `onlyOwner`, which can be applied to your functions to restrict their use to
40  * the owner.
41  */
42 contract Ownable is Context {
43     address private _owner;
44 
45     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
46 
47     /**
48      * @dev Initializes the contract setting the deployer as the initial owner.
49      */
50     constructor () internal {
51         address msgSender = _msgSender();
52         _owner = msgSender;
53         emit OwnershipTransferred(address(0), msgSender);
54     }
55 
56     /**
57      * @dev Returns the address of the current owner.
58      */
59     function owner() public view returns (address) {
60         return _owner;
61     }
62 
63     /**
64      * @dev Throws if called by any account other than the owner.
65      */
66     modifier onlyOwner() {
67         require(isOwner(), "Ownable: caller is not the owner");
68         _;
69     }
70 
71     /**
72      * @dev Returns true if the caller is the current owner.
73      */
74     function isOwner() public view returns (bool) {
75         return _msgSender() == _owner;
76     }
77 
78     /**
79      * @dev Leaves the contract without owner. It will not be possible to call
80      * `onlyOwner` functions anymore. Can only be called by the current owner.
81      *
82      * NOTE: Renouncing ownership will leave the contract without an owner,
83      * thereby removing any functionality that is only available to the owner.
84      */
85     function renounceOwnership() public onlyOwner {
86         emit OwnershipTransferred(_owner, address(0));
87         _owner = address(0);
88     }
89 
90     /**
91      * @dev Transfers ownership of the contract to a new account (`newOwner`).
92      * Can only be called by the current owner.
93      */
94     function transferOwnership(address newOwner) public onlyOwner {
95         _transferOwnership(newOwner);
96     }
97 
98     /**
99      * @dev Transfers ownership of the contract to a new account (`newOwner`).
100      */
101     function _transferOwnership(address newOwner) internal {
102         require(newOwner != address(0), "Ownable: new owner is the zero address");
103         emit OwnershipTransferred(_owner, newOwner);
104         _owner = newOwner;
105     }
106 }
107 
108 // File: node_modules\multi-token-standard\contracts\interfaces\IERC165.sol
109 
110 
111 
112 
113 /**
114  * @title ERC165
115  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
116  */
117 interface IERC165 {
118 
119     /**
120      * @notice Query if a contract implements an interface
121      * @dev Interface identification is specified in ERC-165. This function
122      * uses less than 30,000 gas
123      * @param _interfaceId The interface identifier, as specified in ERC-165
124      */
125     function supportsInterface(bytes4 _interfaceId)
126     external
127     view
128     returns (bool);
129 }
130 
131 // File: node_modules\multi-token-standard\contracts\utils\SafeMath.sol
132 
133 
134 
135 /**
136  * @title SafeMath
137  * @dev Unsigned math operations with safety checks that revert on error
138  */
139 library SafeMath {
140 
141   /**
142    * @dev Multiplies two unsigned integers, reverts on overflow.
143    */
144   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
145     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
146     // benefit is lost if 'b' is also tested.
147     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
148     if (a == 0) {
149       return 0;
150     }
151 
152     uint256 c = a * b;
153     require(c / a == b, "SafeMath#mul: OVERFLOW");
154 
155     return c;
156   }
157 
158   /**
159    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
160    */
161   function div(uint256 a, uint256 b) internal pure returns (uint256) {
162     // Solidity only automatically asserts when dividing by 0
163     require(b > 0, "SafeMath#div: DIVISION_BY_ZERO");
164     uint256 c = a / b;
165     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
166 
167     return c;
168   }
169 
170   /**
171    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
172    */
173   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
174     require(b <= a, "SafeMath#sub: UNDERFLOW");
175     uint256 c = a - b;
176 
177     return c;
178   }
179 
180   /**
181    * @dev Adds two unsigned integers, reverts on overflow.
182    */
183   function add(uint256 a, uint256 b) internal pure returns (uint256) {
184     uint256 c = a + b;
185     require(c >= a, "SafeMath#add: OVERFLOW");
186 
187     return c; 
188   }
189 
190   /**
191    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
192    * reverts when dividing by zero.
193    */
194   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
195     require(b != 0, "SafeMath#mod: DIVISION_BY_ZERO");
196     return a % b;
197   }
198 
199 }
200 
201 // File: node_modules\multi-token-standard\contracts\interfaces\IERC1155TokenReceiver.sol
202 
203 
204 /**
205  * @dev ERC-1155 interface for accepting safe transfers.
206  */
207 interface IERC1155TokenReceiver {
208 
209   /**
210    * @notice Handle the receipt of a single ERC1155 token type
211    * @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeTransferFrom` after the balance has been updated
212    * This function MAY throw to revert and reject the transfer
213    * Return of other amount than the magic value MUST result in the transaction being reverted
214    * Note: The token contract address is always the message sender
215    * @param _operator  The address which called the `safeTransferFrom` function
216    * @param _from      The address which previously owned the token
217    * @param _id        The id of the token being transferred
218    * @param _amount    The amount of tokens being transferred
219    * @param _data      Additional data with no specified format
220    * @return           `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
221    */
222   function onERC1155Received(address _operator, address _from, uint256 _id, uint256 _amount, bytes calldata _data) external returns(bytes4);
223 
224   /**
225    * @notice Handle the receipt of multiple ERC1155 token types
226    * @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeBatchTransferFrom` after the balances have been updated
227    * This function MAY throw to revert and reject the transfer
228    * Return of other amount than the magic value WILL result in the transaction being reverted
229    * Note: The token contract address is always the message sender
230    * @param _operator  The address which called the `safeBatchTransferFrom` function
231    * @param _from      The address which previously owned the token
232    * @param _ids       An array containing ids of each token being transferred
233    * @param _amounts   An array containing amounts of each token being transferred
234    * @param _data      Additional data with no specified format
235    * @return           `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
236    */
237   function onERC1155BatchReceived(address _operator, address _from, uint256[] calldata _ids, uint256[] calldata _amounts, bytes calldata _data) external returns(bytes4);
238 
239   /**
240    * @notice Indicates whether a contract implements the `ERC1155TokenReceiver` functions and so can accept ERC1155 token types.
241    * @param  interfaceID The ERC-165 interface ID that is queried for support.s
242    * @dev This function MUST return true if it implements the ERC1155TokenReceiver interface and ERC-165 interface.
243    *      This function MUST NOT consume more than 5,000 gas.
244    * @return Wheter ERC-165 or ERC1155TokenReceiver interfaces are supported.
245    */
246   function supportsInterface(bytes4 interfaceID) external view returns (bool);
247 
248 }
249 
250 // File: node_modules\multi-token-standard\contracts\interfaces\IERC1155.sol
251 
252 
253 
254 interface IERC1155 {
255   // Events
256 
257   /**
258    * @dev Either TransferSingle or TransferBatch MUST emit when tokens are transferred, including zero amount transfers as well as minting or burning
259    *   Operator MUST be msg.sender
260    *   When minting/creating tokens, the `_from` field MUST be set to `0x0`
261    *   When burning/destroying tokens, the `_to` field MUST be set to `0x0`
262    *   The total amount transferred from address 0x0 minus the total amount transferred to 0x0 may be used by clients and exchanges to be added to the "circulating supply" for a given token ID
263    *   To broadcast the existence of a token ID with no initial balance, the contract SHOULD emit the TransferSingle event from `0x0` to `0x0`, with the token creator as `_operator`, and a `_amount` of 0
264    */
265   event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _amount);
266 
267   /**
268    * @dev Either TransferSingle or TransferBatch MUST emit when tokens are transferred, including zero amount transfers as well as minting or burning
269    *   Operator MUST be msg.sender
270    *   When minting/creating tokens, the `_from` field MUST be set to `0x0`
271    *   When burning/destroying tokens, the `_to` field MUST be set to `0x0`
272    *   The total amount transferred from address 0x0 minus the total amount transferred to 0x0 may be used by clients and exchanges to be added to the "circulating supply" for a given token ID
273    *   To broadcast the existence of multiple token IDs with no initial balance, this SHOULD emit the TransferBatch event from `0x0` to `0x0`, with the token creator as `_operator`, and a `_amount` of 0
274    */
275   event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _amounts);
276 
277   /**
278    * @dev MUST emit when an approval is updated
279    */
280   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
281 
282   /**
283    * @dev MUST emit when the URI is updated for a token ID
284    *   URIs are defined in RFC 3986
285    *   The URI MUST point a JSON file that conforms to the "ERC-1155 Metadata JSON Schema"
286    */
287   event URI(string _amount, uint256 indexed _id);
288 
289   /**
290    * @notice Transfers amount of an _id from the _from address to the _to address specified
291    * @dev MUST emit TransferSingle event on success
292    * Caller must be approved to manage the _from account's tokens (see isApprovedForAll)
293    * MUST throw if `_to` is the zero address
294    * MUST throw if balance of sender for token `_id` is lower than the `_amount` sent
295    * MUST throw on any other error
296    * When transfer is complete, this function MUST check if `_to` is a smart contract (code size > 0). If so, it MUST call `onERC1155Received` on `_to` and revert if the return amount is not `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
297    * @param _from    Source address
298    * @param _to      Target address
299    * @param _id      ID of the token type
300    * @param _amount  Transfered amount
301    * @param _data    Additional data with no specified format, sent in call to `_to`
302    */
303   function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount, bytes calldata _data) external;
304 
305   /**
306    * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
307    * @dev MUST emit TransferBatch event on success
308    * Caller must be approved to manage the _from account's tokens (see isApprovedForAll)
309    * MUST throw if `_to` is the zero address
310    * MUST throw if length of `_ids` is not the same as length of `_amounts`
311    * MUST throw if any of the balance of sender for token `_ids` is lower than the respective `_amounts` sent
312    * MUST throw on any other error
313    * When transfer is complete, this function MUST check if `_to` is a smart contract (code size > 0). If so, it MUST call `onERC1155BatchReceived` on `_to` and revert if the return amount is not `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
314    * Transfers and events MUST occur in the array order they were submitted (_ids[0] before _ids[1], etc)
315    * @param _from     Source addresses
316    * @param _to       Target addresses
317    * @param _ids      IDs of each token type
318    * @param _amounts  Transfer amounts per token type
319    * @param _data     Additional data with no specified format, sent in call to `_to`
320   */
321   function safeBatchTransferFrom(address _from, address _to, uint256[] calldata _ids, uint256[] calldata _amounts, bytes calldata _data) external;
322   
323   /**
324    * @notice Get the balance of an account's Tokens
325    * @param _owner  The address of the token holder
326    * @param _id     ID of the Token
327    * @return        The _owner's balance of the Token type requested
328    */
329   function balanceOf(address _owner, uint256 _id) external view returns (uint256);
330 
331   /**
332    * @notice Get the balance of multiple account/token pairs
333    * @param _owners The addresses of the token holders
334    * @param _ids    ID of the Tokens
335    * @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)
336    */
337   function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids) external view returns (uint256[] memory);
338 
339   /**
340    * @notice Enable or disable approval for a third party ("operator") to manage all of caller's tokens
341    * @dev MUST emit the ApprovalForAll event on success
342    * @param _operator  Address to add to the set of authorized operators
343    * @param _approved  True if the operator is approved, false to revoke approval
344    */
345   function setApprovalForAll(address _operator, bool _approved) external;
346 
347   /**
348    * @notice Queries the approval status of an operator for a given owner
349    * @param _owner     The owner of the Tokens
350    * @param _operator  Address of authorized operator
351    * @return           True if the operator is approved, false if not
352    */
353   function isApprovedForAll(address _owner, address _operator) external view returns (bool isOperator);
354 
355 }
356 
357 // File: node_modules\multi-token-standard\contracts\utils\Address.sol
358 
359 /**
360  * Copyright 2018 ZeroEx Intl.
361  * Licensed under the Apache License, Version 2.0 (the "License");
362  * you may not use this file except in compliance with the License.
363  * You may obtain a copy of the License at
364  *   http://www.apache.org/licenses/LICENSE-2.0
365  * Unless required by applicable law or agreed to in writing, software
366  * distributed under the License is distributed on an "AS IS" BASIS,
367  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
368  * See the License for the specific language governing permissions and
369  * limitations under the License.
370  */
371 
372 
373 
374 /**
375  * Utility library of inline functions on addresses
376  */
377 library Address {
378 
379   /**
380    * Returns whether the target address is a contract
381    * @dev This function will return false if invoked during the constructor of a contract,
382    * as the code is not actually created until after the constructor finishes.
383    * @param account address of the account to check
384    * @return whether the target address is a contract
385    */
386   function isContract(address account) internal view returns (bool) {
387     bytes32 codehash;
388     bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
389 
390     // XXX Currently there is no better way to check if there is a contract in an address
391     // than to check the size of the code at that address.
392     // See https://ethereum.stackexchange.com/a/14016/36603
393     // for more details about how this works.
394     // TODO Check this again before the Serenity release, because all addresses will be
395     // contracts then.
396     assembly { codehash := extcodehash(account) }
397     return (codehash != 0x0 && codehash != accountHash);
398   }
399 
400 }
401 
402 
403 
404 
405 /**
406  * @notice Contract that handles metadata related methods.
407  * @dev Methods assume a deterministic generation of URI based on token IDs.
408  *      Methods also assume that URI uses hex representation of token IDs.
409  */
410 contract ERC1155Metadata {
411 
412   // URI's default URI prefix
413   string internal baseMetadataURI;
414   event URI(string _uri, uint256 indexed _id);
415 
416 
417   /***********************************|
418   |     Metadata Public Function s    |
419   |__________________________________*/
420 
421   /**
422    * @notice A distinct Uniform Resource Identifier (URI) for a given token.
423    * @dev URIs are defined in RFC 3986.
424    *      URIs are assumed to be deterministically generated based on token ID
425    *      Token IDs are assumed to be represented in their hex format in URIs
426    * @return URI string
427    */
428   function uri(uint256 _id) public view returns (string memory) {
429     return string(abi.encodePacked(baseMetadataURI, _uint2str(_id), ".json"));
430   }
431 
432 
433   /***********************************|
434   |    Metadata Internal Functions    |
435   |__________________________________*/
436 
437   /**
438    * @notice Will emit default URI log event for corresponding token _id
439    * @param _tokenIDs Array of IDs of tokens to log default URI
440    */
441   function _logURIs(uint256[] memory _tokenIDs) internal {
442     string memory baseURL = baseMetadataURI;
443     string memory tokenURI;
444 
445     for (uint256 i = 0; i < _tokenIDs.length; i++) {
446       tokenURI = string(abi.encodePacked(baseURL, _uint2str(_tokenIDs[i]), ".json"));
447       emit URI(tokenURI, _tokenIDs[i]);
448     }
449   }
450 
451   /**
452    * @notice Will emit a specific URI log event for corresponding token
453    * @param _tokenIDs IDs of the token corresponding to the _uris logged
454    * @param _URIs    The URIs of the specified _tokenIDs
455    */
456   function _logURIs(uint256[] memory _tokenIDs, string[] memory _URIs) internal {
457     require(_tokenIDs.length == _URIs.length, "ERC1155Metadata#_logURIs: INVALID_ARRAYS_LENGTH");
458     for (uint256 i = 0; i < _tokenIDs.length; i++) {
459       emit URI(_URIs[i], _tokenIDs[i]);
460     }
461   }
462 
463   /**
464    * @notice Will update the base URL of token's URI
465    * @param _newBaseMetadataURI New base URL of token's URI
466    */
467   function _setBaseMetadataURI(string memory _newBaseMetadataURI) internal {
468     baseMetadataURI = _newBaseMetadataURI;
469   }
470 
471 
472   /***********************************|
473   |    Utility Internal Functions     |
474   |__________________________________*/
475 
476   /**
477    * @notice Convert uint256 to string
478    * @param _i Unsigned integer to convert to string
479    */
480   function _uint2str(uint256 _i) internal pure returns (string memory _uintAsString) {
481     if (_i == 0) {
482       return "0";
483     }
484 
485     uint256 j = _i;
486     uint256 ii = _i;
487     uint256 len;
488 
489     // Get number of bytes
490     while (j != 0) {
491       len++;
492       j /= 10;
493     }
494 
495     bytes memory bstr = new bytes(len);
496     uint256 k = len - 1;
497 
498     // Get each individual ASCII
499     while (ii != 0) {
500       bstr[k--] = byte(uint8(48 + ii % 10));
501       ii /= 10;
502     }
503 
504     // Convert to string
505     return string(bstr);
506   }
507 
508 }
509 
510 // File: node_modules\multi-token-standard\contracts\tokens\ERC1155\ERC1155.sol
511 
512 
513 
514 
515 
516 
517 
518 
519 /**
520  * @dev Implementation of Multi-Token Standard contract
521  */
522 contract ERC1155 is IERC165 {
523   using SafeMath for uint256;
524   using Address for address;
525 
526 
527   /***********************************|
528   |        Variables and Events       |
529   |__________________________________*/
530 
531   // onReceive function signatures
532   bytes4 constant internal ERC1155_RECEIVED_VALUE = 0xf23a6e61;
533   bytes4 constant internal ERC1155_BATCH_RECEIVED_VALUE = 0xbc197c81;
534 
535   // Objects balances
536   mapping (address => mapping(uint256 => uint256)) internal balances;
537 
538   // Operator Functions
539   mapping (address => mapping(address => bool)) internal operators;
540 
541   // Events
542   event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _amount);
543   event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _amounts);
544   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
545   event URI(string _uri, uint256 indexed _id);
546 
547 
548   /***********************************|
549   |     Public Transfer Functions     |
550   |__________________________________*/
551 
552   /**
553    * @notice Transfers amount amount of an _id from the _from address to the _to address specified
554    * @param _from    Source address
555    * @param _to      Target address
556    * @param _id      ID of the token type
557    * @param _amount  Transfered amount
558    * @param _data    Additional data with no specified format, sent in call to `_to`
559    */
560   function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount, bytes memory _data)
561     public
562   {
563     require((msg.sender == _from) || isApprovedForAll(_from, msg.sender), "ERC1155#safeTransferFrom: INVALID_OPERATOR");
564     require(_to != address(0),"ERC1155#safeTransferFrom: INVALID_RECIPIENT");
565     // require(_amount >= balances[_from][_id]) is not necessary since checked with safemath operations
566 
567     _safeTransferFrom(_from, _to, _id, _amount);
568     _callonERC1155Received(_from, _to, _id, _amount, _data);
569   }
570 
571   /**
572    * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
573    * @param _from     Source addresses
574    * @param _to       Target addresses
575    * @param _ids      IDs of each token type
576    * @param _amounts  Transfer amounts per token type
577    * @param _data     Additional data with no specified format, sent in call to `_to`
578    */
579   function safeBatchTransferFrom(address _from, address _to, uint256[] memory _ids, uint256[] memory _amounts, bytes memory _data)
580     public
581   {
582     // Requirements
583     require((msg.sender == _from) || isApprovedForAll(_from, msg.sender), "ERC1155#safeBatchTransferFrom: INVALID_OPERATOR");
584     require(_to != address(0), "ERC1155#safeBatchTransferFrom: INVALID_RECIPIENT");
585 
586     _safeBatchTransferFrom(_from, _to, _ids, _amounts);
587     _callonERC1155BatchReceived(_from, _to, _ids, _amounts, _data);
588   }
589 
590 
591   /***********************************|
592   |    Internal Transfer Functions    |
593   |__________________________________*/
594 
595   /**
596    * @notice Transfers amount amount of an _id from the _from address to the _to address specified
597    * @param _from    Source address
598    * @param _to      Target address
599    * @param _id      ID of the token type
600    * @param _amount  Transfered amount
601    */
602   function _safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount)
603     internal
604   {
605     // Update balances
606     balances[_from][_id] = balances[_from][_id].sub(_amount); // Subtract amount
607     balances[_to][_id] = balances[_to][_id].add(_amount);     // Add amount
608 
609     // Emit event
610     emit TransferSingle(msg.sender, _from, _to, _id, _amount);
611   }
612 
613   /**
614    * @notice Verifies if receiver is contract and if so, calls (_to).onERC1155Received(...)
615    */
616   function _callonERC1155Received(address _from, address _to, uint256 _id, uint256 _amount, bytes memory _data)
617     internal
618   {
619     // Check if recipient is contract
620     if (_to.isContract()) {
621       bytes4 retval = IERC1155TokenReceiver(_to).onERC1155Received(msg.sender, _from, _id, _amount, _data);
622       require(retval == ERC1155_RECEIVED_VALUE, "ERC1155#_callonERC1155Received: INVALID_ON_RECEIVE_MESSAGE");
623     }
624   }
625 
626   /**
627    * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
628    * @param _from     Source addresses
629    * @param _to       Target addresses
630    * @param _ids      IDs of each token type
631    * @param _amounts  Transfer amounts per token type
632    */
633   function _safeBatchTransferFrom(address _from, address _to, uint256[] memory _ids, uint256[] memory _amounts)
634     internal
635   {
636     require(_ids.length == _amounts.length, "ERC1155#_safeBatchTransferFrom: INVALID_ARRAYS_LENGTH");
637 
638     // Number of transfer to execute
639     uint256 nTransfer = _ids.length;
640 
641     // Executing all transfers
642     for (uint256 i = 0; i < nTransfer; i++) {
643       // Update storage balance of previous bin
644       balances[_from][_ids[i]] = balances[_from][_ids[i]].sub(_amounts[i]);
645       balances[_to][_ids[i]] = balances[_to][_ids[i]].add(_amounts[i]);
646     }
647 
648     // Emit event
649     emit TransferBatch(msg.sender, _from, _to, _ids, _amounts);
650   }
651 
652   /**
653    * @notice Verifies if receiver is contract and if so, calls (_to).onERC1155BatchReceived(...)
654    */
655   function _callonERC1155BatchReceived(address _from, address _to, uint256[] memory _ids, uint256[] memory _amounts, bytes memory _data)
656     internal
657   {
658     // Pass data if recipient is contract
659     if (_to.isContract()) {
660       bytes4 retval = IERC1155TokenReceiver(_to).onERC1155BatchReceived(msg.sender, _from, _ids, _amounts, _data);
661       require(retval == ERC1155_BATCH_RECEIVED_VALUE, "ERC1155#_callonERC1155BatchReceived: INVALID_ON_RECEIVE_MESSAGE");
662     }
663   }
664 
665 
666   /***********************************|
667   |         Operator Functions        |
668   |__________________________________*/
669 
670   /**
671    * @notice Enable or disable approval for a third party ("operator") to manage all of caller's tokens
672    * @param _operator  Address to add to the set of authorized operators
673    * @param _approved  True if the operator is approved, false to revoke approval
674    */
675   function setApprovalForAll(address _operator, bool _approved)
676     external
677   {
678     // Update operator status
679     operators[msg.sender][_operator] = _approved;
680     emit ApprovalForAll(msg.sender, _operator, _approved);
681   }
682 
683   /**
684    * @notice Queries the approval status of an operator for a given owner
685    * @param _owner     The owner of the Tokens
686    * @param _operator  Address of authorized operator
687    * @return True if the operator is approved, false if not
688    */
689   function isApprovedForAll(address _owner, address _operator)
690     public view returns (bool isOperator)
691   {
692     return operators[_owner][_operator];
693   }
694 
695 
696   /***********************************|
697   |         Balance Functions         |
698   |__________________________________*/
699 
700   /**
701    * @notice Get the balance of an account's Tokens
702    * @param _owner  The address of the token holder
703    * @param _id     ID of the Token
704    * @return The _owner's balance of the Token type requested
705    */
706   function balanceOf(address _owner, uint256 _id)
707     public view returns (uint256)
708   {
709     return balances[_owner][_id];
710   }
711 
712   /**
713    * @notice Get the balance of multiple account/token pairs
714    * @param _owners The addresses of the token holders
715    * @param _ids    ID of the Tokens
716    * @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)
717    */
718   function balanceOfBatch(address[] memory _owners, uint256[] memory _ids)
719     public view returns (uint256[] memory)
720   {
721     require(_owners.length == _ids.length, "ERC1155#balanceOfBatch: INVALID_ARRAY_LENGTH");
722 
723     // Variables
724     uint256[] memory batchBalances = new uint256[](_owners.length);
725 
726     // Iterate over each owner and token ID
727     for (uint256 i = 0; i < _owners.length; i++) {
728       batchBalances[i] = balances[_owners[i]][_ids[i]];
729     }
730 
731     return batchBalances;
732   }
733 
734 
735   /***********************************|
736   |          ERC165 Functions         |
737   |__________________________________*/
738 
739   /**
740    * INTERFACE_SIGNATURE_ERC165 = bytes4(keccak256("supportsInterface(bytes4)"));
741    */
742   bytes4 constant private INTERFACE_SIGNATURE_ERC165 = 0x01ffc9a7;
743 
744   /**
745    * INTERFACE_SIGNATURE_ERC1155 =
746    * bytes4(keccak256("safeTransferFrom(address,address,uint256,uint256,bytes)")) ^
747    * bytes4(keccak256("safeBatchTransferFrom(address,address,uint256[],uint256[],bytes)")) ^
748    * bytes4(keccak256("balanceOf(address,uint256)")) ^
749    * bytes4(keccak256("balanceOfBatch(address[],uint256[])")) ^
750    * bytes4(keccak256("setApprovalForAll(address,bool)")) ^
751    * bytes4(keccak256("isApprovedForAll(address,address)"));
752    */
753   bytes4 constant private INTERFACE_SIGNATURE_ERC1155 = 0xd9b67a26;
754 
755   /**
756    * @notice Query if a contract implements an interface
757    * @param _interfaceID  The interface identifier, as specified in ERC-165
758    * @return `true` if the contract implements `_interfaceID` and
759    */
760   function supportsInterface(bytes4 _interfaceID) external view returns (bool) {
761     if (_interfaceID == INTERFACE_SIGNATURE_ERC165 ||
762         _interfaceID == INTERFACE_SIGNATURE_ERC1155) {
763       return true;
764     }
765     return false;
766   }
767 
768 }
769 
770 // File: multi-token-standard\contracts\tokens\ERC1155\ERC1155MintBurn.sol
771 
772 
773 
774 
775 /**
776  * @dev Multi-Fungible Tokens with minting and burning methods. These methods assume
777  *      a parent contract to be executed as they are `internal` functions
778  */
779 contract ERC1155MintBurn is ERC1155 {
780 
781 
782   /****************************************|
783   |            Minting Functions           |
784   |_______________________________________*/
785 
786   /**
787    * @notice Mint _amount of tokens of a given id
788    * @param _to      The address to mint tokens to
789    * @param _id      Token id to mint
790    * @param _amount  The amount to be minted
791    * @param _data    Data to pass if receiver is contract
792    */
793   function _mint(address _to, uint256 _id, uint256 _amount, bytes memory _data)
794     internal
795   {
796     // Add _amount
797     balances[_to][_id] = balances[_to][_id].add(_amount);
798 
799     // Emit event
800     emit TransferSingle(msg.sender, address(0x0), _to, _id, _amount);
801 
802     // Calling onReceive method if recipient is contract
803     _callonERC1155Received(address(0x0), _to, _id, _amount, _data);
804   }
805 
806   /**
807    * @notice Mint tokens for each ids in _ids
808    * @param _to       The address to mint tokens to
809    * @param _ids      Array of ids to mint
810    * @param _amounts  Array of amount of tokens to mint per id
811    * @param _data    Data to pass if receiver is contract
812    */
813   function _batchMint(address _to, uint256[] memory _ids, uint256[] memory _amounts, bytes memory _data)
814     internal
815   {
816     require(_ids.length == _amounts.length, "ERC1155MintBurn#batchMint: INVALID_ARRAYS_LENGTH");
817 
818     // Number of mints to execute
819     uint256 nMint = _ids.length;
820 
821      // Executing all minting
822     for (uint256 i = 0; i < nMint; i++) {
823       // Update storage balance
824       balances[_to][_ids[i]] = balances[_to][_ids[i]].add(_amounts[i]);
825     }
826 
827     // Emit batch mint event
828     emit TransferBatch(msg.sender, address(0x0), _to, _ids, _amounts);
829 
830     // Calling onReceive method if recipient is contract
831     _callonERC1155BatchReceived(address(0x0), _to, _ids, _amounts, _data);
832   }
833 
834 
835   /****************************************|
836   |            Burning Functions           |
837   |_______________________________________*/
838 
839   /**
840    * @notice Burn _amount of tokens of a given token id
841    * @param _from    The address to burn tokens from
842    * @param _id      Token id to burn
843    * @param _amount  The amount to be burned
844    */
845   function _burn(address _from, uint256 _id, uint256 _amount)
846     internal
847   {
848     //Substract _amount
849     balances[_from][_id] = balances[_from][_id].sub(_amount);
850 
851     // Emit event
852     emit TransferSingle(msg.sender, _from, address(0x0), _id, _amount);
853   }
854 
855   /**
856    * @notice Burn tokens of given token id for each (_ids[i], _amounts[i]) pair
857    * @param _from     The address to burn tokens from
858    * @param _ids      Array of token ids to burn
859    * @param _amounts  Array of the amount to be burned
860    */
861   function _batchBurn(address _from, uint256[] memory _ids, uint256[] memory _amounts)
862     internal
863   {
864     require(_ids.length == _amounts.length, "ERC1155MintBurn#batchBurn: INVALID_ARRAYS_LENGTH");
865 
866     // Number of mints to execute
867     uint256 nBurn = _ids.length;
868 
869      // Executing all minting
870     for (uint256 i = 0; i < nBurn; i++) {
871       // Update storage balance
872       balances[_from][_ids[i]] = balances[_from][_ids[i]].sub(_amounts[i]);
873     }
874 
875     // Emit batch mint event
876     emit TransferBatch(msg.sender, _from, address(0x0), _ids, _amounts);
877   }
878 
879 }
880 
881 // File: contracts\Strings.sol
882 
883 
884 library Strings {
885   // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
886   function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory) {
887       bytes memory _ba = bytes(_a);
888       bytes memory _bb = bytes(_b);
889       bytes memory _bc = bytes(_c);
890       bytes memory _bd = bytes(_d);
891       bytes memory _be = bytes(_e);
892       string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
893       bytes memory babcde = bytes(abcde);
894       uint k = 0;
895       for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
896       for (uint i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
897       for (uint i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
898       for (uint i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
899       for (uint i = 0; i < _be.length; i++) babcde[k++] = _be[i];
900       return string(babcde);
901     }
902 
903     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory) {
904         return strConcat(_a, _b, _c, _d, "");
905     }
906 
907     function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory) {
908         return strConcat(_a, _b, _c, "", "");
909     }
910 
911     function strConcat(string memory _a, string memory _b) internal pure returns (string memory) {
912         return strConcat(_a, _b, "", "", "");
913     }
914 
915     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
916         if (_i == 0) {
917             return "0";
918         }
919         uint j = _i;
920         uint len;
921         while (j != 0) {
922             len++;
923             j /= 10;
924         }
925         bytes memory bstr = new bytes(len);
926         uint k = len - 1;
927         while (_i != 0) {
928             bstr[k--] = byte(uint8(48 + _i % 10));
929             _i /= 10;
930         }
931         return string(bstr);
932     }
933 
934     /**
935      * Index Of
936      *
937      * Locates and returns the position of a character within a string
938      * 
939      * @param _base When being used for a data type this is the extended object
940      *              otherwise this is the string acting as the haystack to be
941      *              searched
942      * @param _value The needle to search for, at present this is currently
943      *               limited to one character
944      * @return int The position of the needle starting from 0 and returning -1
945      *             in the case of no matches found
946      */
947     function indexOf(string memory _base, string memory _value)
948         internal
949         pure
950         returns (int) {
951         return _indexOf(_base, _value, 0);
952     }
953 
954     /**
955      * Index Of
956      *
957      * Locates and returns the position of a character within a string starting
958      * from a defined offset
959      * 
960      * @param _base When being used for a data type this is the extended object
961      *              otherwise this is the string acting as the haystack to be
962      *              searched
963      * @param _value The needle to search for, at present this is currently
964      *               limited to one character
965      * @param _offset The starting point to start searching from which can start
966      *                from 0, but must not exceed the length of the string
967      * @return int The position of the needle starting from 0 and returning -1
968      *             in the case of no matches found
969      */
970     function _indexOf(string memory _base, string memory _value, uint _offset)
971         internal
972         pure
973         returns (int) {
974         bytes memory _baseBytes = bytes(_base);
975         bytes memory _valueBytes = bytes(_value);
976 
977         assert(_valueBytes.length == 1);
978 
979         for (uint i = _offset; i < _baseBytes.length; i++) {
980             if (_baseBytes[i] == _valueBytes[0]) {
981                 return int(i);
982             }
983         }
984 
985         return -1;
986     }
987 }
988 
989 // File: contracts\ERC1155Tradable.sol
990 
991 
992 
993 
994 
995 
996 
997 contract OwnableDelegateProxy { }
998 
999 contract ProxyRegistry {
1000   mapping(address => OwnableDelegateProxy) public proxies;
1001 }
1002 
1003 /**
1004  * @title ERC1155Tradable
1005  * ERC1155Tradable - ERC1155 contract that whitelists an operator address, has create and mint functionality, and supports useful standards from OpenZeppelin,
1006   like _exists(), name(), symbol(), and totalSupply()
1007  */
1008 contract ERC1155Tradable is ERC1155, ERC1155MintBurn, ERC1155Metadata, Ownable {
1009 
1010     //address proxyRegistryAddress;
1011 	  uint256 private totalTokenAssets = 10000;
1012     uint256 private totalReserve = 336;
1013     uint256 public _currentTokenID = 0;
1014     uint256 public _customizedTokenId = 9000;
1015     // uint256 private _maxTokenPerUser = 1000;
1016     uint256 private _maxTokenPerMint = 2;
1017     uint256 public sold = 0;
1018     uint256 private reserved = 0;
1019     // uint256 private presalesMaxToken = 3;
1020     uint256 private preSalesPrice1 = 0.07 ether;
1021     uint256 private preSalesPrice2 = 0.088 ether;
1022     uint256 private publicSalesPrice = 0.088 ether;
1023     uint256 private preSalesMaxSupply3 = 9000;
1024     address private signerAddress = 0x22A19Fd9F3a29Fe8260F88C46dB04941Fa0615C9;
1025     uint16 public salesStage = 3; //1-presales1 , 2-presales2 , 3-public
1026     address payable public companyWallet = 0xE369C3f00d8dc97Be4B58a7ede901E48c4767bD2; //test
1027 
1028     mapping(uint256 => uint256) private _presalesPrice;
1029     mapping(address => uint256) public presales1minted; // To check how many tokens an address has minted during presales
1030     mapping(address => uint256) public presales2minted; // To check how many tokens an address has minted during presales
1031     mapping(address => uint256) public minted; // To check how many tokens an address has minted
1032     mapping (uint256 => address) public creators;
1033     mapping (uint256 => uint256) public tokenSupply;
1034     mapping(uint256 => string) public rawdata;
1035 
1036     event TokenMinted(uint indexed _tokenid, address indexed _userAddress, string indexed _rawData);
1037     // Contract name
1038     string public name;
1039     // Contract symbol
1040     string public symbol;
1041     
1042     /**
1043     * @dev Require msg.sender to be the creator of the token id
1044     */
1045     modifier creatorOnly(uint256 _id) {
1046         require(creators[_id] == msg.sender, "ERC1155Tradable#creatorOnly: ONLY_CREATOR_ALLOWED");
1047         _;
1048     }
1049 
1050     /**
1051     * @dev Require msg.sender to own more than 0 of the token id
1052     */
1053     modifier ownersOnly(uint256 _id) {
1054         require(balances[msg.sender][_id] > 0, "ERC1155Tradable#ownersOnly: ONLY_OWNERS_ALLOWED");
1055         _;
1056     }
1057 
1058     constructor(
1059         string memory _name,
1060         string memory _symbol
1061         //address _proxyRegistryAddress
1062     ) public {
1063         name = _name;
1064         symbol = _symbol;
1065         //proxyRegistryAddress = _proxyRegistryAddress;
1066     }
1067 
1068     using Strings for string;
1069 
1070     // // Function to receive Ether. msg.data must be empty
1071     // receive() external payable {}
1072 
1073     // // Fallback function is called when msg.data is not empty
1074     // fallback() external payable {}
1075 
1076     function uri(
1077         uint256 _id
1078     ) public view returns (string memory) {
1079         require(_exists(_id), "ERC721Tradable#uri: NONEXISTENT_TOKEN");
1080         return Strings.strConcat(
1081         baseMetadataURI,
1082         Strings.uint2str(_id)
1083         );
1084     }
1085 
1086     /**
1087         * @dev Returns the total quantity for a token ID
1088         * @param _id uint256 ID of the token to query
1089         * @return amount of token in existence
1090         */
1091     function totalSupply(
1092         uint256 _id
1093     ) public view returns (uint256) {
1094         return tokenSupply[_id];
1095     }
1096 
1097 
1098 
1099     /**
1100     * @dev Will update the base URL of token's URI
1101     * @param _newBaseMetadataURI New base URL of token's URI
1102     */
1103     function setBaseMetadataURI(
1104         string memory _newBaseMetadataURI
1105     ) public onlyOwner {
1106         _setBaseMetadataURI(_newBaseMetadataURI);
1107     }
1108 
1109     /**
1110         * @dev Creates a new token type and assigns _initialSupply to an address
1111         * NOTE: remove onlyOwner if you want third parties to create new tokens on your contract (which may change your IDs)
1112         * @param _initialOwner address of the first owner of the token
1113         * @param _initialSupply amount to supply the first owner
1114         * @param _uri Optional URI for this token type
1115         * @param _data Data to pass if receiver is contract
1116         * @return The newly created token ID
1117         */
1118     function reserve( //When start this mint 336 first
1119         address _initialOwner,
1120         uint256 _initialSupply,
1121         string calldata _uri,
1122         bytes calldata _data
1123     ) external onlyOwner returns (uint256) {
1124         require(reserved + _initialSupply <= totalReserve, "Reserve Empty");
1125 
1126         sold += _initialSupply;
1127         
1128         for (uint256 i = 0; i < _initialSupply; i++) {
1129         reserved++;
1130         uint256 _id = reserved;
1131 
1132         if (bytes(_uri).length > 0) {
1133             emit URI(_uri, _id);
1134         }
1135 
1136 
1137         creators[_id] = msg.sender;
1138         _mint(_initialOwner, _id, 1, _data);
1139         tokenSupply[_id] = 1;
1140         }
1141         return 0;
1142     }
1143     
1144     function toBytes(address a) public pure returns (bytes memory b){
1145         assembly {
1146             let m := mload(0x40)
1147             a := and(a, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
1148             mstore(add(m, 20), xor(0x140000000000000000000000000000000000000000, a))
1149             mstore(0x40, add(m, 52))
1150             b := m
1151         }
1152     }
1153 
1154     function addressToString(address _addr) internal pure returns(string memory) {
1155         bytes32 value = bytes32(uint256(_addr));
1156         bytes memory alphabet = "0123456789abcdef";
1157 
1158         bytes memory str = new bytes(42);
1159         str[0] = "0";
1160         str[1] = "x";
1161         for (uint i = 0; i < 20; i++) {
1162             str[2+i*2] = alphabet[uint(uint8(value[i + 12] >> 4))];
1163             str[3+i*2] = alphabet[uint(uint8(value[i + 12] & 0x0f))];
1164         }
1165         return string(str);
1166     }
1167 
1168     function toAsciiString(address x) internal pure returns (string memory) {
1169         bytes memory s = new bytes(40);
1170         for (uint i = 0; i < 20; i++) {
1171             bytes1 b = bytes1(uint8(uint(uint160(x)) / (2**(8*(19 - i)))));
1172             bytes1 hi = bytes1(uint8(b) / 16);
1173             bytes1 lo = bytes1(uint8(b) - 16 * uint8(hi));
1174             s[2*i] = char(hi);
1175             s[2*i+1] = char(lo);            
1176         }
1177         return string(s);
1178     }
1179 
1180 
1181     function char(
1182         bytes1 b
1183         ) internal pure returns (bytes1 c) {
1184         if (uint8(b) < 10) return bytes1(uint8(b) + 0x30);
1185         else return bytes1(uint8(b) + 0x57);
1186     }
1187 
1188     function bytes32ToString(bytes32 _bytes32) public pure returns (string memory) {
1189         uint8 i = 0;
1190         bytes memory bytesArray = new bytes(64);
1191         for (i = 0; i < bytesArray.length; i++) {
1192 
1193             uint8 _f = uint8(_bytes32[i/2] & 0x0f);
1194             uint8 _l = uint8(_bytes32[i/2] >> 4);
1195 
1196             bytesArray[i] = toByte(_f);
1197             i = i + 1;
1198             bytesArray[i] = toByte(_l);
1199         }
1200         return string(bytesArray);
1201     }
1202 
1203     function stringToBytes32(string memory source) public pure returns (bytes32 result) {
1204         bytes memory tempEmptyStringTest = bytes(source);
1205         if (tempEmptyStringTest.length == 0) {
1206             return 0x0;
1207         }
1208 
1209         assembly {
1210             result := mload(add(source, 32))
1211         }
1212     }
1213 
1214     function splitSignature(bytes memory sig)
1215         public
1216         pure
1217         returns (uint8, bytes32, bytes32)
1218     {
1219         require(sig.length == 65);
1220 
1221         bytes32 r;
1222         bytes32 s;
1223         uint8 v;
1224 
1225         assembly {
1226             // first 32 bytes, after the length prefix
1227             r := mload(add(sig, 32))
1228             // second 32 bytes
1229             s := mload(add(sig, 64))
1230             // final byte (first byte of the next 32 bytes)
1231             v := byte(0, mload(add(sig, 96)))
1232         }
1233         
1234         return (v, r, s);
1235     }
1236 
1237     function recoverSigner(bytes32 message, bytes memory sig)
1238         public
1239         pure
1240         returns (address)
1241         {
1242         uint8 v;
1243         bytes32 r;
1244         bytes32 s;
1245 
1246         (v, r, s) = splitSignature(sig);
1247         return ecrecover(message, v, r, s);
1248     }
1249     
1250     function isValidData(string memory _word, bytes memory sig) public view returns(bool){
1251         bytes32 message = keccak256(abi.encodePacked(_word));
1252         return (recoverSigner(message, sig) == signerAddress);
1253     }
1254 
1255 
1256     function toByte(uint8 _uint8) public pure returns (byte) {
1257         if(_uint8 < 10) {
1258             return byte(_uint8 + 48);
1259         } else {
1260             return byte(_uint8 + 87);
1261         }
1262     }
1263 
1264     function withdraw() public onlyOwner {
1265       require(companyWallet != address(0), "Please Set Company Wallet Address");
1266       uint256 balance = address(this).balance;
1267       companyWallet.transfer(balance);
1268     }
1269 
1270         
1271     function presales(
1272         address _initialOwner,
1273         uint256 _initialSupply,
1274         bytes calldata _sig,
1275         bytes calldata _data
1276     ) external payable returns (uint256) {
1277         require(salesStage == 1 || salesStage == 2, "Presales is closed");
1278         if(salesStage == 1){
1279             require(sold + _initialSupply <= preSalesMaxSupply3, "Max Token reached for Sales Stage 1");
1280             require(_initialSupply * preSalesPrice1 == msg.value, "Invalid Fund");
1281 
1282         }else if(salesStage == 2){
1283             require(sold + _initialSupply <= preSalesMaxSupply3, "Max Token reached for Sales Stage 2");
1284             require(_initialSupply * preSalesPrice2 == msg.value, "Invalid Fund");
1285         }
1286         require(isValidData(addressToString(msg.sender), _sig), addressToString(msg.sender));
1287         
1288         sold += _initialSupply;
1289 
1290         if(salesStage == 1){
1291         presales1minted[_initialOwner] += _initialSupply;
1292         }else if(salesStage == 2){
1293         presales2minted[_initialOwner] += _initialSupply;
1294         }
1295         minted[_initialOwner] += _initialSupply;
1296 
1297         for (uint256 i = 0; i < _initialSupply; i++) {
1298         uint256 _id = _getNextTokenID() + totalReserve;
1299         _incrementTokenTypeId();
1300         creators[_id] = msg.sender;
1301         _mint(_initialOwner, _id, 1, _data);
1302         tokenSupply[_id] = 1;
1303         emit TokenMinted(_id, _initialOwner, "");
1304         }
1305 
1306         return 0;
1307     }
1308 
1309 
1310     function publicsales(
1311         address _initialOwner,
1312         uint256 _initialSupply,
1313         string calldata _uri,
1314         bytes calldata _data
1315     ) external payable returns (uint256) {
1316         require(salesStage == 3 , "Public Sales Is Closed");
1317         require(sold + _initialSupply <= preSalesMaxSupply3, "Max Token reached for Sales Stage 3");
1318         require(_initialSupply * publicSalesPrice == msg.value , "Invalid Fund");
1319 
1320         sold += _initialSupply;
1321         minted[_initialOwner] += _initialSupply;
1322 
1323         for (uint256 i = 0; i < _initialSupply; i++) {
1324         uint256 _id = _getNextTokenID() + totalReserve;
1325         _incrementTokenTypeId();
1326 
1327         if (bytes(_uri).length > 0) {
1328         emit URI(_uri, _id);
1329         }
1330 
1331         creators[_id] = msg.sender;
1332         _mint(_initialOwner, _id, 1, _data);
1333         tokenSupply[_id] = 1;
1334         emit TokenMinted(_id, _initialOwner, "");
1335         }
1336         return 0;
1337     }
1338 
1339     function CustomizedSales(
1340         address _initialOwner,
1341         uint256 _initialSupply,
1342         string calldata _rawdata,
1343         bytes calldata _sig,
1344         bytes calldata _data,
1345         uint price
1346     ) external payable returns (uint256) {
1347         string memory data = Strings.strConcat(_rawdata, _uint2str(price));
1348         require(isValidData(data, _sig), "Invalid Signature");
1349         uint temp_id = _getNextCustomizedTokenID();
1350         require(temp_id + _initialSupply -1 <= totalTokenAssets, "Max Token Minted");
1351         require(msg.value == price, "Invalid fund");
1352 
1353         for (uint256 i = 0; i < _initialSupply; i++) {
1354             uint256 _id = _getNextCustomizedTokenID();
1355             _incrementCustomizedTokenTypeId();
1356             creators[_id] = msg.sender;
1357             _mint(_initialOwner, _id, 1, _data);
1358             tokenSupply[_id] = 1;
1359             rawdata[_id] = _rawdata;
1360             emit TokenMinted(_id, _initialOwner, _rawdata);
1361         }
1362         return 0;
1363     }
1364 
1365     function setSalesStage(
1366         uint16 stage
1367     ) public onlyOwner {
1368         salesStage = stage;
1369     }
1370 
1371     function setCompanyWallet(
1372         address payable newWallet
1373     ) public onlyOwner {
1374         companyWallet = newWallet;
1375     }
1376 
1377     
1378     function ownerMint( 
1379         address _initialOwner,
1380         uint256 _initialSupply,
1381         string calldata _uri,
1382         bytes calldata _data
1383     ) external onlyOwner returns (uint256) {
1384         require(sold + _initialSupply <= preSalesMaxSupply3, "Max Token Minted");
1385 
1386         sold += _initialSupply;
1387         
1388         for (uint256 i = 0; i < _initialSupply; i++) {
1389             uint256 _id = _getNextTokenID() + totalReserve;
1390             _incrementTokenTypeId();
1391             //uint256 _id = reserved;
1392 
1393         if (bytes(_uri).length > 0) {
1394             emit URI(_uri, _id);
1395         }
1396 
1397 
1398         creators[_id] = msg.sender;
1399         _mint(_initialOwner, _id, 1, _data);
1400         tokenSupply[_id] = 1;
1401         }
1402         return 0;
1403     }
1404     
1405     function walletbalance(
1406     ) public view returns (uint256) {
1407             return address(this).balance;
1408         }
1409     
1410 
1411     /**
1412         * @dev Mint tokens for each id in _ids
1413         * @param _to          The address to mint tokens to
1414         * @param _ids         Array of ids to mint
1415         * @param _quantities  Array of amounts of tokens to mint per id
1416         * @param _data        Data to pass if receiver is contract
1417         */
1418     function batchMint(
1419         address _to,
1420         uint256[] memory _ids,
1421         uint256[] memory _quantities,
1422         bytes memory _data
1423     ) public {
1424         for (uint256 i = 0; i < _ids.length; i++) {
1425         uint256 _id = _ids[i];
1426         require(creators[_id] == msg.sender, "ERC1155Tradable#batchMint: ONLY_CREATOR_ALLOWED");
1427         uint256 quantity = _quantities[i];
1428         tokenSupply[_id] = tokenSupply[_id].add(quantity);
1429         }
1430         _batchMint(_to, _ids, _quantities, _data);
1431     }
1432 
1433     function setPrice(uint _sale1, uint _sale2, uint _salepublic) external onlyOwner{
1434       preSalesPrice1 = _sale1;
1435       preSalesPrice2 = _sale2;
1436       publicSalesPrice = _salepublic;
1437     }
1438 
1439     /**
1440         * @dev Change the creator address for given tokens
1441         * @param _to   Address of the new creator
1442         * @param _ids  Array of Token IDs to change creator
1443         */
1444     function setCreator(
1445         address _to,
1446         uint256[] memory _ids
1447     ) public {
1448         require(_to != address(0), "ERC1155Tradable#setCreator: INVALID_ADDRESS.");
1449         for (uint256 i = 0; i < _ids.length; i++) {
1450         uint256 id = _ids[i];
1451         _setCreator(_to, id);
1452         }
1453     }
1454 
1455   /**
1456     * @dev Change the creator address for given token
1457     * @param _to   Address of the new creator
1458     * @param _id  Token IDs to change creator of
1459     */
1460     function _setCreator(address _to, uint256 _id) internal creatorOnly(_id)
1461     {
1462         creators[_id] = _to;
1463     }
1464 
1465     /**
1466         * @dev Returns whether the specified token exists by checking to see if it has a creator
1467         * @param _id uint256 ID of the token to query the existence of
1468         * @return bool whether the token exists
1469         */
1470     function _exists(
1471         uint256 _id
1472     ) internal view returns (bool) {
1473         return creators[_id] != address(0);
1474     }
1475 
1476     /**
1477         * @dev calculates the next token ID based on value of _currentTokenID
1478         * @return uint256 for the next token ID
1479         */
1480     function _getNextTokenID() private view returns (uint256) {
1481         return _currentTokenID.add(1);
1482     }
1483 
1484     /**
1485         * @dev calculates the next token ID based on value of _customizedTokenId
1486         * @return uint256 for the next token ID
1487         */
1488     function _getNextCustomizedTokenID() private view returns (uint256) {
1489         return _customizedTokenId.add(1);
1490     }
1491 
1492     /**
1493         * @dev increments the value of _currentTokenID
1494         */
1495     function _incrementTokenTypeId() private  {
1496         _currentTokenID++;
1497     }
1498 
1499     /**
1500         * @dev increments the value of _customizedTokenId
1501         */
1502     function _incrementCustomizedTokenTypeId() private  {
1503         _customizedTokenId++;
1504     }
1505 }
1506 
1507 
1508 // File: contracts\MyCollectible.sol
1509 
1510 
1511 
1512 /**
1513  * @title MyCollectible
1514  * MyCollectible - a contract for my semi-fungible tokens.
1515  */
1516 contract HypedHuskyMetaCityNFT is ERC1155Tradable {
1517   constructor(string memory _name)//address _proxyRegistryAddress)
1518   ERC1155Tradable(
1519     _name,
1520     "HHMC"
1521   ) public {
1522     _setBaseMetadataURI("https://api.HypedHuskyMetaCityNFT.io/nft/");
1523   }
1524 
1525 }