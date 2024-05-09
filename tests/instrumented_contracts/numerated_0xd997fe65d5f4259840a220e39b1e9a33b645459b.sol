1 pragma solidity ^0.5.11;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10     address private _owner;
11 
12     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14     /**
15      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16      * account.
17      */
18     constructor () internal {
19         _owner = msg.sender;
20         emit OwnershipTransferred(address(0), _owner);
21     }
22 
23     /**
24      * @return the address of the owner.
25      */
26     function owner() public view returns (address) {
27         return _owner;
28     }
29 
30     /**
31      * @dev Throws if called by any account other than the owner.
32      */
33     modifier onlyOwner() {
34         require(isOwner());
35         _;
36     }
37 
38     /**
39      * @return true if `msg.sender` is the owner of the contract.
40      */
41     function isOwner() public view returns (bool) {
42         return msg.sender == _owner;
43     }
44 
45     /**
46      * @dev Allows the current owner to relinquish control of the contract.
47      * @notice Renouncing to ownership will leave the contract without an owner.
48      * It will not be possible to call the functions with the `onlyOwner`
49      * modifier anymore.
50      */
51     function renounceOwnership() public onlyOwner {
52         emit OwnershipTransferred(_owner, address(0));
53         _owner = address(0);
54     }
55 
56     /**
57      * @dev Allows the current owner to transfer control of the contract to a newOwner.
58      * @param newOwner The address to transfer ownership to.
59      */
60     function transferOwnership(address newOwner) public onlyOwner {
61         _transferOwnership(newOwner);
62     }
63 
64     /**
65      * @dev Transfers control of the contract to a newOwner.
66      * @param newOwner The address to transfer ownership to.
67      */
68     function _transferOwnership(address newOwner) internal {
69         require(newOwner != address(0));
70         emit OwnershipTransferred(_owner, newOwner);
71         _owner = newOwner;
72     }
73 }
74 
75 /**
76  * @title ERC165
77  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
78  */
79 interface IERC165 {
80 
81     /**
82      * @notice Query if a contract implements an interface
83      * @dev Interface identification is specified in ERC-165. This function
84      * uses less than 30,000 gas
85      * @param _interfaceId The interface identifier, as specified in ERC-165
86      */
87     function supportsInterface(bytes4 _interfaceId)
88     external
89     view
90     returns (bool);
91 }
92 
93 /**
94  * @title SafeMath
95  * @dev Unsigned math operations with safety checks that revert on error
96  */
97 library SafeMath {
98 
99   /**
100    * @dev Multiplies two unsigned integers, reverts on overflow.
101    */
102   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
103     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
104     // benefit is lost if 'b' is also tested.
105     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
106     if (a == 0) {
107       return 0;
108     }
109 
110     uint256 c = a * b;
111     require(c / a == b, "SafeMath#mul: OVERFLOW");
112 
113     return c;
114   }
115 
116   /**
117    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
118    */
119   function div(uint256 a, uint256 b) internal pure returns (uint256) {
120     // Solidity only automatically asserts when dividing by 0
121     require(b > 0, "SafeMath#div: DIVISION_BY_ZERO");
122     uint256 c = a / b;
123     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
124 
125     return c;
126   }
127 
128   /**
129    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
130    */
131   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
132     require(b <= a, "SafeMath#sub: UNDERFLOW");
133     uint256 c = a - b;
134 
135     return c;
136   }
137 
138   /**
139    * @dev Adds two unsigned integers, reverts on overflow.
140    */
141   function add(uint256 a, uint256 b) internal pure returns (uint256) {
142     uint256 c = a + b;
143     require(c >= a, "SafeMath#add: OVERFLOW");
144 
145     return c; 
146   }
147 
148   /**
149    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
150    * reverts when dividing by zero.
151    */
152   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
153     require(b != 0, "SafeMath#mod: DIVISION_BY_ZERO");
154     return a % b;
155   }
156 
157 }
158 
159 /**
160  * @dev ERC-1155 interface for accepting safe transfers.
161  */
162 interface IERC1155TokenReceiver {
163 
164   /**
165    * @notice Handle the receipt of a single ERC1155 token type
166    * @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeTransferFrom` after the balance has been updated
167    * This function MAY throw to revert and reject the transfer
168    * Return of other amount than the magic value MUST result in the transaction being reverted
169    * Note: The token contract address is always the message sender
170    * @param _operator  The address which called the `safeTransferFrom` function
171    * @param _from      The address which previously owned the token
172    * @param _id        The id of the token being transferred
173    * @param _amount    The amount of tokens being transferred
174    * @param _data      Additional data with no specified format
175    * @return           `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
176    */
177   function onERC1155Received(address _operator, address _from, uint256 _id, uint256 _amount, bytes calldata _data) external returns(bytes4);
178 
179   /**
180    * @notice Handle the receipt of multiple ERC1155 token types
181    * @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeBatchTransferFrom` after the balances have been updated
182    * This function MAY throw to revert and reject the transfer
183    * Return of other amount than the magic value WILL result in the transaction being reverted
184    * Note: The token contract address is always the message sender
185    * @param _operator  The address which called the `safeBatchTransferFrom` function
186    * @param _from      The address which previously owned the token
187    * @param _ids       An array containing ids of each token being transferred
188    * @param _amounts   An array containing amounts of each token being transferred
189    * @param _data      Additional data with no specified format
190    * @return           `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
191    */
192   function onERC1155BatchReceived(address _operator, address _from, uint256[] calldata _ids, uint256[] calldata _amounts, bytes calldata _data) external returns(bytes4);
193 
194   /**
195    * @notice Indicates whether a contract implements the `ERC1155TokenReceiver` functions and so can accept ERC1155 token types.
196    * @param  interfaceID The ERC-165 interface ID that is queried for support.s
197    * @dev This function MUST return true if it implements the ERC1155TokenReceiver interface and ERC-165 interface.
198    *      This function MUST NOT consume more than 5,000 gas.
199    * @return Wheter ERC-165 or ERC1155TokenReceiver interfaces are supported.
200    */
201   function supportsInterface(bytes4 interfaceID) external view returns (bool);
202 
203 }
204 
205 interface IERC1155 {
206   // Events
207 
208   /**
209    * @dev Either TransferSingle or TransferBatch MUST emit when tokens are transferred, including zero amount transfers as well as minting or burning
210    *   Operator MUST be msg.sender
211    *   When minting/creating tokens, the `_from` field MUST be set to `0x0`
212    *   When burning/destroying tokens, the `_to` field MUST be set to `0x0`
213    *   The total amount transferred from address 0x0 minus the total amount transferred to 0x0 may be used by clients and exchanges to be added to the "circulating supply" for a given token ID
214    *   To broadcast the existence of a token ID with no initial balance, the contract SHOULD emit the TransferSingle event from `0x0` to `0x0`, with the token creator as `_operator`, and a `_amount` of 0
215    */
216   event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _amount);
217 
218   /**
219    * @dev Either TransferSingle or TransferBatch MUST emit when tokens are transferred, including zero amount transfers as well as minting or burning
220    *   Operator MUST be msg.sender
221    *   When minting/creating tokens, the `_from` field MUST be set to `0x0`
222    *   When burning/destroying tokens, the `_to` field MUST be set to `0x0`
223    *   The total amount transferred from address 0x0 minus the total amount transferred to 0x0 may be used by clients and exchanges to be added to the "circulating supply" for a given token ID
224    *   To broadcast the existence of multiple token IDs with no initial balance, this SHOULD emit the TransferBatch event from `0x0` to `0x0`, with the token creator as `_operator`, and a `_amount` of 0
225    */
226   event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _amounts);
227 
228   /**
229    * @dev MUST emit when an approval is updated
230    */
231   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
232 
233   /**
234    * @dev MUST emit when the URI is updated for a token ID
235    *   URIs are defined in RFC 3986
236    *   The URI MUST point a JSON file that conforms to the "ERC-1155 Metadata JSON Schema"
237    */
238   event URI(string _amount, uint256 indexed _id);
239 
240   /**
241    * @notice Transfers amount of an _id from the _from address to the _to address specified
242    * @dev MUST emit TransferSingle event on success
243    * Caller must be approved to manage the _from account's tokens (see isApprovedForAll)
244    * MUST throw if `_to` is the zero address
245    * MUST throw if balance of sender for token `_id` is lower than the `_amount` sent
246    * MUST throw on any other error
247    * When transfer is complete, this function MUST check if `_to` is a smart contract (code size > 0). If so, it MUST call `onERC1155Received` on `_to` and revert if the return amount is not `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
248    * @param _from    Source address
249    * @param _to      Target address
250    * @param _id      ID of the token type
251    * @param _amount  Transfered amount
252    * @param _data    Additional data with no specified format, sent in call to `_to`
253    */
254   function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount, bytes calldata _data) external;
255 
256   /**
257    * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
258    * @dev MUST emit TransferBatch event on success
259    * Caller must be approved to manage the _from account's tokens (see isApprovedForAll)
260    * MUST throw if `_to` is the zero address
261    * MUST throw if length of `_ids` is not the same as length of `_amounts`
262    * MUST throw if any of the balance of sender for token `_ids` is lower than the respective `_amounts` sent
263    * MUST throw on any other error
264    * When transfer is complete, this function MUST check if `_to` is a smart contract (code size > 0). If so, it MUST call `onERC1155BatchReceived` on `_to` and revert if the return amount is not `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
265    * Transfers and events MUST occur in the array order they were submitted (_ids[0] before _ids[1], etc)
266    * @param _from     Source addresses
267    * @param _to       Target addresses
268    * @param _ids      IDs of each token type
269    * @param _amounts  Transfer amounts per token type
270    * @param _data     Additional data with no specified format, sent in call to `_to`
271   */
272   function safeBatchTransferFrom(address _from, address _to, uint256[] calldata _ids, uint256[] calldata _amounts, bytes calldata _data) external;
273   
274   /**
275    * @notice Get the balance of an account's Tokens
276    * @param _owner  The address of the token holder
277    * @param _id     ID of the Token
278    * @return        The _owner's balance of the Token type requested
279    */
280   function balanceOf(address _owner, uint256 _id) external view returns (uint256);
281 
282   /**
283    * @notice Get the balance of multiple account/token pairs
284    * @param _owners The addresses of the token holders
285    * @param _ids    ID of the Tokens
286    * @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)
287    */
288   function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids) external view returns (uint256[] memory);
289 
290   /**
291    * @notice Enable or disable approval for a third party ("operator") to manage all of caller's tokens
292    * @dev MUST emit the ApprovalForAll event on success
293    * @param _operator  Address to add to the set of authorized operators
294    * @param _approved  True if the operator is approved, false to revoke approval
295    */
296   function setApprovalForAll(address _operator, bool _approved) external;
297 
298   /**
299    * @notice Queries the approval status of an operator for a given owner
300    * @param _owner     The owner of the Tokens
301    * @param _operator  Address of authorized operator
302    * @return           True if the operator is approved, false if not
303    */
304   function isApprovedForAll(address _owner, address _operator) external view returns (bool isOperator);
305 
306 }
307 
308 /**
309  * Copyright 2018 ZeroEx Intl.
310  * Licensed under the Apache License, Version 2.0 (the "License");
311  * you may not use this file except in compliance with the License.
312  * You may obtain a copy of the License at
313  *   http://www.apache.org/licenses/LICENSE-2.0
314  * Unless required by applicable law or agreed to in writing, software
315  * distributed under the License is distributed on an "AS IS" BASIS,
316  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
317  * See the License for the specific language governing permissions and
318  * limitations under the License.
319  */
320 /**
321  * Utility library of inline functions on addresses
322  */
323 library Address {
324 
325   /**
326    * Returns whether the target address is a contract
327    * @dev This function will return false if invoked during the constructor of a contract,
328    * as the code is not actually created until after the constructor finishes.
329    * @param account address of the account to check
330    * @return whether the target address is a contract
331    */
332   function isContract(address account) internal view returns (bool) {
333     bytes32 codehash;
334     bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
335 
336     // XXX Currently there is no better way to check if there is a contract in an address
337     // than to check the size of the code at that address.
338     // See https://ethereum.stackexchange.com/a/14016/36603
339     // for more details about how this works.
340     // TODO Check this again before the Serenity release, because all addresses will be
341     // contracts then.
342     assembly { codehash := extcodehash(account) }
343     return (codehash != 0x0 && codehash != accountHash);
344   }
345 
346 }
347 
348 /**
349  * @dev Implementation of Multi-Token Standard contract
350  */
351 contract ERC1155 is IERC165 {
352   using SafeMath for uint256;
353   using Address for address;
354 
355 
356   /***********************************|
357   |        Variables and Events       |
358   |__________________________________*/
359 
360   // onReceive function signatures
361   bytes4 constant internal ERC1155_RECEIVED_VALUE = 0xf23a6e61;
362   bytes4 constant internal ERC1155_BATCH_RECEIVED_VALUE = 0xbc197c81;
363 
364   // Objects balances
365   mapping (address => mapping(uint256 => uint256)) internal balances;
366 
367   // Operator Functions
368   mapping (address => mapping(address => bool)) internal operators;
369 
370   // Events
371   event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _amount);
372   event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _amounts);
373   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
374   event URI(string _uri, uint256 indexed _id);
375 
376 
377   /***********************************|
378   |     Public Transfer Functions     |
379   |__________________________________*/
380 
381   /**
382    * @notice Transfers amount amount of an _id from the _from address to the _to address specified
383    * @param _from    Source address
384    * @param _to      Target address
385    * @param _id      ID of the token type
386    * @param _amount  Transfered amount
387    * @param _data    Additional data with no specified format, sent in call to `_to`
388    */
389   function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount, bytes memory _data)
390     public
391   {
392     require((msg.sender == _from) || isApprovedForAll(_from, msg.sender), "ERC1155#safeTransferFrom: INVALID_OPERATOR");
393     require(_to != address(0),"ERC1155#safeTransferFrom: INVALID_RECIPIENT");
394     // require(_amount >= balances[_from][_id]) is not necessary since checked with safemath operations
395 
396     _safeTransferFrom(_from, _to, _id, _amount);
397     _callonERC1155Received(_from, _to, _id, _amount, _data);
398   }
399 
400   /**
401    * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
402    * @param _from     Source addresses
403    * @param _to       Target addresses
404    * @param _ids      IDs of each token type
405    * @param _amounts  Transfer amounts per token type
406    * @param _data     Additional data with no specified format, sent in call to `_to`
407    */
408   function safeBatchTransferFrom(address _from, address _to, uint256[] memory _ids, uint256[] memory _amounts, bytes memory _data)
409     public
410   {
411     // Requirements
412     require((msg.sender == _from) || isApprovedForAll(_from, msg.sender), "ERC1155#safeBatchTransferFrom: INVALID_OPERATOR");
413     require(_to != address(0), "ERC1155#safeBatchTransferFrom: INVALID_RECIPIENT");
414 
415     _safeBatchTransferFrom(_from, _to, _ids, _amounts);
416     _callonERC1155BatchReceived(_from, _to, _ids, _amounts, _data);
417   }
418 
419 
420   /***********************************|
421   |    Internal Transfer Functions    |
422   |__________________________________*/
423 
424   /**
425    * @notice Transfers amount amount of an _id from the _from address to the _to address specified
426    * @param _from    Source address
427    * @param _to      Target address
428    * @param _id      ID of the token type
429    * @param _amount  Transfered amount
430    */
431   function _safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount)
432     internal
433   {
434     // Update balances
435     balances[_from][_id] = balances[_from][_id].sub(_amount); // Subtract amount
436     balances[_to][_id] = balances[_to][_id].add(_amount);     // Add amount
437 
438     // Emit event
439     emit TransferSingle(msg.sender, _from, _to, _id, _amount);
440   }
441 
442   /**
443    * @notice Verifies if receiver is contract and if so, calls (_to).onERC1155Received(...)
444    */
445   function _callonERC1155Received(address _from, address _to, uint256 _id, uint256 _amount, bytes memory _data)
446     internal
447   {
448     // Check if recipient is contract
449     if (_to.isContract()) {
450       bytes4 retval = IERC1155TokenReceiver(_to).onERC1155Received(msg.sender, _from, _id, _amount, _data);
451       require(retval == ERC1155_RECEIVED_VALUE, "ERC1155#_callonERC1155Received: INVALID_ON_RECEIVE_MESSAGE");
452     }
453   }
454 
455   /**
456    * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
457    * @param _from     Source addresses
458    * @param _to       Target addresses
459    * @param _ids      IDs of each token type
460    * @param _amounts  Transfer amounts per token type
461    */
462   function _safeBatchTransferFrom(address _from, address _to, uint256[] memory _ids, uint256[] memory _amounts)
463     internal
464   {
465     require(_ids.length == _amounts.length, "ERC1155#_safeBatchTransferFrom: INVALID_ARRAYS_LENGTH");
466 
467     // Number of transfer to execute
468     uint256 nTransfer = _ids.length;
469 
470     // Executing all transfers
471     for (uint256 i = 0; i < nTransfer; i++) {
472       // Update storage balance of previous bin
473       balances[_from][_ids[i]] = balances[_from][_ids[i]].sub(_amounts[i]);
474       balances[_to][_ids[i]] = balances[_to][_ids[i]].add(_amounts[i]);
475     }
476 
477     // Emit event
478     emit TransferBatch(msg.sender, _from, _to, _ids, _amounts);
479   }
480 
481   /**
482    * @notice Verifies if receiver is contract and if so, calls (_to).onERC1155BatchReceived(...)
483    */
484   function _callonERC1155BatchReceived(address _from, address _to, uint256[] memory _ids, uint256[] memory _amounts, bytes memory _data)
485     internal
486   {
487     // Pass data if recipient is contract
488     if (_to.isContract()) {
489       bytes4 retval = IERC1155TokenReceiver(_to).onERC1155BatchReceived(msg.sender, _from, _ids, _amounts, _data);
490       require(retval == ERC1155_BATCH_RECEIVED_VALUE, "ERC1155#_callonERC1155BatchReceived: INVALID_ON_RECEIVE_MESSAGE");
491     }
492   }
493 
494 
495   /***********************************|
496   |         Operator Functions        |
497   |__________________________________*/
498 
499   /**
500    * @notice Enable or disable approval for a third party ("operator") to manage all of caller's tokens
501    * @param _operator  Address to add to the set of authorized operators
502    * @param _approved  True if the operator is approved, false to revoke approval
503    */
504   function setApprovalForAll(address _operator, bool _approved)
505     external
506   {
507     // Update operator status
508     operators[msg.sender][_operator] = _approved;
509     emit ApprovalForAll(msg.sender, _operator, _approved);
510   }
511 
512   /**
513    * @notice Queries the approval status of an operator for a given owner
514    * @param _owner     The owner of the Tokens
515    * @param _operator  Address of authorized operator
516    * @return True if the operator is approved, false if not
517    */
518   function isApprovedForAll(address _owner, address _operator)
519     public view returns (bool isOperator)
520   {
521     return operators[_owner][_operator];
522   }
523 
524 
525   /***********************************|
526   |         Balance Functions         |
527   |__________________________________*/
528 
529   /**
530    * @notice Get the balance of an account's Tokens
531    * @param _owner  The address of the token holder
532    * @param _id     ID of the Token
533    * @return The _owner's balance of the Token type requested
534    */
535   function balanceOf(address _owner, uint256 _id)
536     public view returns (uint256)
537   {
538     return balances[_owner][_id];
539   }
540 
541   /**
542    * @notice Get the balance of multiple account/token pairs
543    * @param _owners The addresses of the token holders
544    * @param _ids    ID of the Tokens
545    * @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)
546    */
547   function balanceOfBatch(address[] memory _owners, uint256[] memory _ids)
548     public view returns (uint256[] memory)
549   {
550     require(_owners.length == _ids.length, "ERC1155#balanceOfBatch: INVALID_ARRAY_LENGTH");
551 
552     // Variables
553     uint256[] memory batchBalances = new uint256[](_owners.length);
554 
555     // Iterate over each owner and token ID
556     for (uint256 i = 0; i < _owners.length; i++) {
557       batchBalances[i] = balances[_owners[i]][_ids[i]];
558     }
559 
560     return batchBalances;
561   }
562 
563 
564   /***********************************|
565   |          ERC165 Functions         |
566   |__________________________________*/
567 
568   /**
569    * INTERFACE_SIGNATURE_ERC165 = bytes4(keccak256("supportsInterface(bytes4)"));
570    */
571   bytes4 constant private INTERFACE_SIGNATURE_ERC165 = 0x01ffc9a7;
572 
573   /**
574    * INTERFACE_SIGNATURE_ERC1155 =
575    * bytes4(keccak256("safeTransferFrom(address,address,uint256,uint256,bytes)")) ^
576    * bytes4(keccak256("safeBatchTransferFrom(address,address,uint256[],uint256[],bytes)")) ^
577    * bytes4(keccak256("balanceOf(address,uint256)")) ^
578    * bytes4(keccak256("balanceOfBatch(address[],uint256[])")) ^
579    * bytes4(keccak256("setApprovalForAll(address,bool)")) ^
580    * bytes4(keccak256("isApprovedForAll(address,address)"));
581    */
582   bytes4 constant private INTERFACE_SIGNATURE_ERC1155 = 0xd9b67a26;
583 
584   /**
585    * @notice Query if a contract implements an interface
586    * @param _interfaceID  The interface identifier, as specified in ERC-165
587    * @return `true` if the contract implements `_interfaceID` and
588    */
589   function supportsInterface(bytes4 _interfaceID) external view returns (bool) {
590     if (_interfaceID == INTERFACE_SIGNATURE_ERC165 ||
591         _interfaceID == INTERFACE_SIGNATURE_ERC1155) {
592       return true;
593     }
594     return false;
595   }
596 
597 }
598 
599 /**
600  * @notice Contract that handles metadata related methods.
601  * @dev Methods assume a deterministic generation of URI based on token IDs.
602  *      Methods also assume that URI uses hex representation of token IDs.
603  */
604 contract ERC1155Metadata {
605 
606   // URI's default URI prefix
607   string internal baseMetadataURI;
608   event URI(string _uri, uint256 indexed _id);
609 
610 
611   /***********************************|
612   |     Metadata Public Function s    |
613   |__________________________________*/
614 
615   /**
616    * @notice A distinct Uniform Resource Identifier (URI) for a given token.
617    * @dev URIs are defined in RFC 3986.
618    *      URIs are assumed to be deterministically generated based on token ID
619    *      Token IDs are assumed to be represented in their hex format in URIs
620    * @return URI string
621    */
622   function uri(uint256 _id) public view returns (string memory) {
623     return string(abi.encodePacked(baseMetadataURI, _uint2str(_id), ".json"));
624   }
625 
626 
627   /***********************************|
628   |    Metadata Internal Functions    |
629   |__________________________________*/
630 
631   /**
632    * @notice Will emit default URI log event for corresponding token _id
633    * @param _tokenIDs Array of IDs of tokens to log default URI
634    */
635   function _logURIs(uint256[] memory _tokenIDs) internal {
636     string memory baseURL = baseMetadataURI;
637     string memory tokenURI;
638 
639     for (uint256 i = 0; i < _tokenIDs.length; i++) {
640       tokenURI = string(abi.encodePacked(baseURL, _uint2str(_tokenIDs[i]), ".json"));
641       emit URI(tokenURI, _tokenIDs[i]);
642     }
643   }
644 
645   /**
646    * @notice Will emit a specific URI log event for corresponding token
647    * @param _tokenIDs IDs of the token corresponding to the _uris logged
648    * @param _URIs    The URIs of the specified _tokenIDs
649    */
650   function _logURIs(uint256[] memory _tokenIDs, string[] memory _URIs) internal {
651     require(_tokenIDs.length == _URIs.length, "ERC1155Metadata#_logURIs: INVALID_ARRAYS_LENGTH");
652     for (uint256 i = 0; i < _tokenIDs.length; i++) {
653       emit URI(_URIs[i], _tokenIDs[i]);
654     }
655   }
656 
657   /**
658    * @notice Will update the base URL of token's URI
659    * @param _newBaseMetadataURI New base URL of token's URI
660    */
661   function _setBaseMetadataURI(string memory _newBaseMetadataURI) internal {
662     baseMetadataURI = _newBaseMetadataURI;
663   }
664 
665 
666   /***********************************|
667   |    Utility Internal Functions     |
668   |__________________________________*/
669 
670   /**
671    * @notice Convert uint256 to string
672    * @param _i Unsigned integer to convert to string
673    */
674   function _uint2str(uint256 _i) internal pure returns (string memory _uintAsString) {
675     if (_i == 0) {
676       return "0";
677     }
678 
679     uint256 j = _i;
680     uint256 ii = _i;
681     uint256 len;
682 
683     // Get number of bytes
684     while (j != 0) {
685       len++;
686       j /= 10;
687     }
688 
689     bytes memory bstr = new bytes(len);
690     uint256 k = len - 1;
691 
692     // Get each individual ASCII
693     while (ii != 0) {
694       bstr[k--] = byte(uint8(48 + ii % 10));
695       ii /= 10;
696     }
697 
698     // Convert to string
699     return string(bstr);
700   }
701 
702 }
703 
704 /**
705  * @dev Multi-Fungible Tokens with minting and burning methods. These methods assume
706  *      a parent contract to be executed as they are `internal` functions
707  */
708 contract ERC1155MintBurn is ERC1155 {
709 
710 
711   /****************************************|
712   |            Minting Functions           |
713   |_______________________________________*/
714 
715   /**
716    * @notice Mint _amount of tokens of a given id
717    * @param _to      The address to mint tokens to
718    * @param _id      Token id to mint
719    * @param _amount  The amount to be minted
720    * @param _data    Data to pass if receiver is contract
721    */
722   function _mint(address _to, uint256 _id, uint256 _amount, bytes memory _data)
723     internal
724   {
725     // Add _amount
726     balances[_to][_id] = balances[_to][_id].add(_amount);
727 
728     // Emit event
729     emit TransferSingle(msg.sender, address(0x0), _to, _id, _amount);
730 
731     // Calling onReceive method if recipient is contract
732     _callonERC1155Received(address(0x0), _to, _id, _amount, _data);
733   }
734 
735   /**
736    * @notice Mint tokens for each ids in _ids
737    * @param _to       The address to mint tokens to
738    * @param _ids      Array of ids to mint
739    * @param _amounts  Array of amount of tokens to mint per id
740    * @param _data    Data to pass if receiver is contract
741    */
742   function _batchMint(address _to, uint256[] memory _ids, uint256[] memory _amounts, bytes memory _data)
743     internal
744   {
745     require(_ids.length == _amounts.length, "ERC1155MintBurn#batchMint: INVALID_ARRAYS_LENGTH");
746 
747     // Number of mints to execute
748     uint256 nMint = _ids.length;
749 
750      // Executing all minting
751     for (uint256 i = 0; i < nMint; i++) {
752       // Update storage balance
753       balances[_to][_ids[i]] = balances[_to][_ids[i]].add(_amounts[i]);
754     }
755 
756     // Emit batch mint event
757     emit TransferBatch(msg.sender, address(0x0), _to, _ids, _amounts);
758 
759     // Calling onReceive method if recipient is contract
760     _callonERC1155BatchReceived(address(0x0), _to, _ids, _amounts, _data);
761   }
762 
763 
764   /****************************************|
765   |            Burning Functions           |
766   |_______________________________________*/
767 
768   /**
769    * @notice Burn _amount of tokens of a given token id
770    * @param _from    The address to burn tokens from
771    * @param _id      Token id to burn
772    * @param _amount  The amount to be burned
773    */
774   function _burn(address _from, uint256 _id, uint256 _amount)
775     internal
776   {
777     //Substract _amount
778     balances[_from][_id] = balances[_from][_id].sub(_amount);
779 
780     // Emit event
781     emit TransferSingle(msg.sender, _from, address(0x0), _id, _amount);
782   }
783 
784   /**
785    * @notice Burn tokens of given token id for each (_ids[i], _amounts[i]) pair
786    * @param _from     The address to burn tokens from
787    * @param _ids      Array of token ids to burn
788    * @param _amounts  Array of the amount to be burned
789    */
790   function _batchBurn(address _from, uint256[] memory _ids, uint256[] memory _amounts)
791     internal
792   {
793     require(_ids.length == _amounts.length, "ERC1155MintBurn#batchBurn: INVALID_ARRAYS_LENGTH");
794 
795     // Number of mints to execute
796     uint256 nBurn = _ids.length;
797 
798      // Executing all minting
799     for (uint256 i = 0; i < nBurn; i++) {
800       // Update storage balance
801       balances[_from][_ids[i]] = balances[_from][_ids[i]].sub(_amounts[i]);
802     }
803 
804     // Emit batch mint event
805     emit TransferBatch(msg.sender, _from, address(0x0), _ids, _amounts);
806   }
807 
808 }
809 
810 library Strings {
811   // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
812   function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory) {
813       bytes memory _ba = bytes(_a);
814       bytes memory _bb = bytes(_b);
815       bytes memory _bc = bytes(_c);
816       bytes memory _bd = bytes(_d);
817       bytes memory _be = bytes(_e);
818       string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
819       bytes memory babcde = bytes(abcde);
820       uint k = 0;
821       for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
822       for (uint i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
823       for (uint i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
824       for (uint i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
825       for (uint i = 0; i < _be.length; i++) babcde[k++] = _be[i];
826       return string(babcde);
827     }
828 
829     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory) {
830         return strConcat(_a, _b, _c, _d, "");
831     }
832 
833     function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory) {
834         return strConcat(_a, _b, _c, "", "");
835     }
836 
837     function strConcat(string memory _a, string memory _b) internal pure returns (string memory) {
838         return strConcat(_a, _b, "", "", "");
839     }
840 
841     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
842         if (_i == 0) {
843             return "0";
844         }
845         uint j = _i;
846         uint len;
847         while (j != 0) {
848             len++;
849             j /= 10;
850         }
851         bytes memory bstr = new bytes(len);
852         uint k = len - 1;
853         while (_i != 0) {
854             bstr[k--] = byte(uint8(48 + _i % 10));
855             _i /= 10;
856         }
857         return string(bstr);
858     }
859 }
860 
861 /**
862  * @title ERC1155Tradable
863  * ERC1155Tradable - ERC1155 contract that whitelists an operator address, has create and mint functionality, and supports useful standards from OpenZeppelin,
864   like _exists(), name(), symbol(), and totalSupply()
865  */
866 contract ERC1155Tradable is ERC1155, ERC1155MintBurn, ERC1155Metadata, Ownable {
867   using Strings for string;
868 
869   address proxyRegistryAddress;
870   mapping (uint256 => uint256) public tokenSupply;
871   // Contract name
872   string public name;
873 
874   /**
875    * @dev Require msg.sender to own more than 0 of the token id
876    */
877   modifier ownersOnly(uint256 _id) {
878     require(balances[msg.sender][_id] > 0, "ERC1155Tradable#ownersOnly: ONLY_OWNERS_ALLOWED");
879     _;
880   }
881 
882   constructor(
883     string memory _name,
884     address _proxyRegistryAddress
885   ) public {
886     name = _name;
887     proxyRegistryAddress = _proxyRegistryAddress;
888   }
889 
890   function uri(
891     uint256 _id
892   ) public view returns (string memory) {
893     require(_exists(_id), "ERC721Tradable#uri: NONEXISTENT_TOKEN");
894     return Strings.strConcat(Strings.strConcat(
895       baseMetadataURI,
896       Strings.uint2str(_id)
897     ), '.json');
898   }
899 
900   /**
901     * @dev Returns the total quantity for a token ID
902     * @param _id uint256 ID of the token to query
903     * @return amount of token in existence
904     */
905   function totalSupply(
906     uint256 _id
907   ) public view returns (uint256) {
908     return tokenSupply[_id];
909   }
910 
911   /**
912    * @dev Will update the base URL of token's URI
913    * @param _newBaseMetadataURI New base URL of token's URI
914    */
915   function setBaseMetadataURI(
916     string memory _newBaseMetadataURI
917   ) public onlyOwner {
918     _setBaseMetadataURI(_newBaseMetadataURI);
919   }
920 
921   /**
922     * @dev Mints some amount of tokens to an address
923     * @param _to          Address of the future owner of the token
924     * @param _id          Token ID to mint
925     * @param _quantity    Amount of tokens to mint
926     * @param _data        Data to pass if receiver is contract
927     */
928   function mint(
929     address _to,
930     uint256 _id,
931     uint256 _quantity,
932     bytes memory _data
933   ) public onlyOwner {
934     _mint(_to, _id, _quantity, _data);
935     tokenSupply[_id] = tokenSupply[_id].add(_quantity);
936   }
937 
938   /**
939     * @dev Mint tokens for each id in _ids
940     * @param _to          The address to mint tokens to
941     * @param _ids         Array of ids to mint
942     * @param _quantities  Array of amounts of tokens to mint per id
943     * @param _data        Data to pass if receiver is contract
944     */
945   function batchMint(
946     address _to,
947     uint256[] memory _ids,
948     uint256[] memory _quantities,
949     bytes memory _data
950   ) public onlyOwner {
951     for (uint256 i = 0; i < _ids.length; i++) {
952       uint256 _id = _ids[i];
953       uint256 quantity = _quantities[i];
954       tokenSupply[_id] = tokenSupply[_id].add(quantity);
955     }
956     _batchMint(_to, _ids, _quantities, _data);
957   }
958 
959   /**
960    * Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-free listings.
961    */
962   function isApprovedForAll(
963     address _owner,
964     address _operator
965   ) public view returns (bool isOperator) {
966     if (proxyRegistryAddress == _operator) {
967       return true;
968     }
969     return ERC1155.isApprovedForAll(_owner, _operator);
970   }
971 
972   /**
973     * @dev Returns whether the specified token exists by checking to see if it has a creator
974     * @param _id uint256 ID of the token to query the existence of
975     * @return bool whether the token exists
976     */
977   function _exists(
978     uint256 _id
979   ) internal view returns (bool) {
980     return tokenSupply[_id] != 0;
981   }
982 }
983 
984 /**
985  * @title DappCraftRecipes
986  * DappCraftRecipes - a contract for my semi-fungible tokens.
987  */
988 contract DappCraftRecipes is ERC1155Tradable {
989 
990     constructor(address _proxyRegistryAddress,
991         uint256[] memory _ids,
992         uint256[] memory _quantities) ERC1155Tradable(
993         "Dapp-Craft Vouchers",
994         _proxyRegistryAddress
995     ) public {
996         _setBaseMetadataURI("https://dcl-dapp-craft.storage.googleapis.com/collection1/metadata/");
997 
998         batchMint(msg.sender,
999             _ids,
1000             _quantities,
1001             new bytes(0));
1002     }
1003 }