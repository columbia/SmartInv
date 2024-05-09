1 // File: openzeppelin-solidity\contracts\ownership\Ownable.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11     address private _owner;
12 
13     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);   
14 
15     /**
16      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17      * account.
18      */
19     constructor () internal {
20         _owner = msg.sender;
21         emit OwnershipTransferred(address(0), _owner);
22     }
23 
24     /**
25      * @return the address of the owner.
26      */
27     function owner() public view returns (address) {
28         return _owner;
29     }
30 
31     /**
32      * @dev Throws if called by any account other than the owner.
33      */
34     modifier onlyOwner() {
35         require(isOwner());
36         _;
37     }
38 
39     /**
40      * @return true if `msg.sender` is the owner of the contract.
41      */
42     function isOwner() public view returns (bool) {
43         return msg.sender == _owner;
44     }
45 
46     /**
47      * @dev Allows the current owner to relinquish control of the contract.
48      * @notice Renouncing to ownership will leave the contract without an owner.
49      * It will not be possible to call the functions with the `onlyOwner`
50      * modifier anymore.
51      */
52     function renounceOwnership() public onlyOwner {
53         emit OwnershipTransferred(_owner, address(0));
54         _owner = address(0);
55     }
56 
57     /**
58      * @dev Allows the current owner to transfer control of the contract to a newOwner.
59      * @param newOwner The address to transfer ownership to.
60      */
61     function transferOwnership(address newOwner) public onlyOwner {
62         _transferOwnership(newOwner);
63     }
64 
65     /**
66      * @dev Transfers control of the contract to a newOwner.
67      * @param newOwner The address to transfer ownership to.
68      */
69     function _transferOwnership(address newOwner) internal {
70         require(newOwner != address(0));
71         emit OwnershipTransferred(_owner, newOwner);
72         _owner = newOwner;
73     }
74 }
75 
76 // File: contracts\multi-token-standard\interfaces\IERC165.sol
77 
78 pragma solidity ^0.5.12;
79 
80 
81 /**
82  * @title ERC165
83  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
84  */
85 interface IERC165 {
86 
87     /**
88      * @notice Query if a contract implements an interface
89      * @dev Interface identification is specified in ERC-165. This function
90      * uses less than 30,000 gas
91      * @param _interfaceId The interface identifier, as specified in ERC-165
92      */
93     function supportsInterface(bytes4 _interfaceId)
94     external
95     view
96     returns (bool);
97 }
98 
99 // File: contracts\multi-token-standard\utils\SafeMath.sol
100 
101 pragma solidity ^0.5.12;
102 
103 
104 /**
105  * @title SafeMath
106  * @dev Unsigned math operations with safety checks that revert on error
107  */
108 library SafeMath {
109 
110   /**
111    * @dev Multiplies two unsigned integers, reverts on overflow.
112    */
113   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
114     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
115     // benefit is lost if 'b' is also tested.
116     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
117     if (a == 0) {
118       return 0;
119     }
120 
121     uint256 c = a * b;
122     require(c / a == b, "SafeMath#mul: OVERFLOW");
123 
124     return c;
125   }
126 
127   /**
128    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
129    */
130   function div(uint256 a, uint256 b) internal pure returns (uint256) {
131     // Solidity only automatically asserts when dividing by 0
132     require(b > 0, "SafeMath#div: DIVISION_BY_ZERO");
133     uint256 c = a / b;
134     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
135 
136     return c;
137   }
138 
139   /**
140    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
141    */
142   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
143     require(b <= a, "SafeMath#sub: UNDERFLOW");
144     uint256 c = a - b;
145 
146     return c;
147   }
148 
149   /**
150    * @dev Adds two unsigned integers, reverts on overflow.
151    */
152   function add(uint256 a, uint256 b) internal pure returns (uint256) {
153     uint256 c = a + b;
154     require(c >= a, "SafeMath#add: OVERFLOW");
155 
156     return c;
157   }
158 
159   /**
160    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
161    * reverts when dividing by zero.
162    */
163   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
164     require(b != 0, "SafeMath#mod: DIVISION_BY_ZERO");
165     return a % b;
166   }
167 
168 }
169 
170 // File: contracts\multi-token-standard\interfaces\IERC1155TokenReceiver.sol
171 
172 pragma solidity ^0.5.12;
173 
174 /**
175  * @dev ERC-1155 interface for accepting safe transfers.
176  */
177 interface IERC1155TokenReceiver {
178 
179   /**
180    * @notice Handle the receipt of a single ERC1155 token type
181    * @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeTransferFrom` after the balance has been updated
182    * This function MAY throw to revert and reject the transfer
183    * Return of other amount than the magic value MUST result in the transaction being reverted
184    * Note: The token contract address is always the message sender
185    * @param _operator  The address which called the `safeTransferFrom` function
186    * @param _from      The address which previously owned the token
187    * @param _id        The id of the token being transferred
188    * @param _amount    The amount of tokens being transferred
189    * @param _data      Additional data with no specified format
190    * @return           `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
191    */
192   function onERC1155Received(address _operator, address _from, uint256 _id, uint256 _amount, bytes calldata _data) external returns(bytes4);
193 
194   /**
195    * @notice Handle the receipt of multiple ERC1155 token types
196    * @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeBatchTransferFrom` after the balances have been updated
197    * This function MAY throw to revert and reject the transfer
198    * Return of other amount than the magic value WILL result in the transaction being reverted
199    * Note: The token contract address is always the message sender
200    * @param _operator  The address which called the `safeBatchTransferFrom` function
201    * @param _from      The address which previously owned the token
202    * @param _ids       An array containing ids of each token being transferred
203    * @param _amounts   An array containing amounts of each token being transferred
204    * @param _data      Additional data with no specified format
205    * @return           `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
206    */
207   function onERC1155BatchReceived(address _operator, address _from, uint256[] calldata _ids, uint256[] calldata _amounts, bytes calldata _data) external returns(bytes4);
208 
209   /**
210    * @notice Indicates whether a contract implements the `ERC1155TokenReceiver` functions and so can accept ERC1155 token types.
211    * @param  interfaceID The ERC-165 interface ID that is queried for support.s
212    * @dev This function MUST return true if it implements the ERC1155TokenReceiver interface and ERC-165 interface.
213    *      This function MUST NOT consume more than 5,000 gas.
214    * @return Wheter ERC-165 or ERC1155TokenReceiver interfaces are supported.
215    */
216   function supportsInterface(bytes4 interfaceID) external view returns (bool);
217 
218 }
219 
220 // File: contracts\multi-token-standard\interfaces\IERC1155.sol
221 
222 pragma solidity ^0.5.12;
223 
224 
225 interface IERC1155 {
226   // Events
227 
228   /**
229    * @dev Either TransferSingle or TransferBatch MUST emit when tokens are transferred, including zero amount transfers as well as minting or burning
230    *   Operator MUST be msg.sender
231    *   When minting/creating tokens, the `_from` field MUST be set to `0x0`
232    *   When burning/destroying tokens, the `_to` field MUST be set to `0x0`
233    *   The total amount transferred from address 0x0 minus the total amount transferred to 0x0 may be used by clients and exchanges to be added to the "circulating supply" for a given token ID
234    *   To broadcast the existence of a token ID with no initial balance, the contract SHOULD emit the TransferSingle event from `0x0` to `0x0`, with the token 
235 creator as `_operator`, and a `_amount` of 0
236    */
237   event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _amount);
238 
239   /**
240    * @dev Either TransferSingle or TransferBatch MUST emit when tokens are transferred, including zero amount transfers as well as minting or burning
241    *   Operator MUST be msg.sender
242    *   When minting/creating tokens, the `_from` field MUST be set to `0x0`
243    *   When burning/destroying tokens, the `_to` field MUST be set to `0x0`
244    *   The total amount transferred from address 0x0 minus the total amount transferred to 0x0 may be used by clients and exchanges to be added to the "circulating supply" for a given token ID
245    *   To broadcast the existence of multiple token IDs with no initial balance, this SHOULD emit the TransferBatch event from `0x0` to `0x0`, with the token creator as `_operator`, and a `_amount` of 0
246    */
247   event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _amounts);
248 
249   /**
250    * @dev MUST emit when an approval is updated
251    */
252   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
253 
254   /**
255    * @dev MUST emit when the URI is updated for a token ID
256    *   URIs are defined in RFC 3986
257    *   The URI MUST point a JSON file that conforms to the "ERC-1155 Metadata JSON Schema"
258    */
259   event URI(string _amount, uint256 indexed _id);
260 
261   /**
262    * @notice Transfers amount of an _id from the _from address to the _to address specified
263    * @dev MUST emit TransferSingle event on success
264    * Caller must be approved to manage the _from account's tokens (see isApprovedForAll)
265    * MUST throw if `_to` is the zero address
266    * MUST throw if balance of sender for token `_id` is lower than the `_amount` sent
267    * MUST throw on any other error
268    * When transfer is complete, this function MUST check if `_to` is a smart contract (code size > 0). If so, it MUST call `onERC1155Received` on `_to` and revert if the return amount is not `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
269    * @param _from    Source address
270    * @param _to      Target address
271    * @param _id      ID of the token type
272    * @param _amount  Transfered amount
273    * @param _data    Additional data with no specified format, sent in call to `_to`
274    */
275   function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount, bytes calldata _data) external;
276 
277   /**
278    * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
279    * @dev MUST emit TransferBatch event on success
280    * Caller must be approved to manage the _from account's tokens (see isApprovedForAll)
281    * MUST throw if `_to` is the zero address
282    * MUST throw if length of `_ids` is not the same as length of `_amounts`
283    * MUST throw if any of the balance of sender for token `_ids` is lower than the respective `_amounts` sent
284    * MUST throw on any other error
285    * When transfer is complete, this function MUST check if `_to` is a smart contract (code size > 0). If so, it MUST call `onERC1155BatchReceived` on `_to` and revert if the return amount is not `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
286    * Transfers and events MUST occur in the array order they were submitted (_ids[0] before _ids[1], etc)
287    * @param _from     Source addresses
288    * @param _to       Target addresses
289    * @param _ids      IDs of each token type
290    * @param _amounts  Transfer amounts per token type
291    * @param _data     Additional data with no specified format, sent in call to `_to`
292   */
293   function safeBatchTransferFrom(address _from, address _to, uint256[] calldata _ids, uint256[] calldata _amounts, bytes calldata _data) external;
294 
295   /**
296    * @notice Get the balance of an account's Tokens
297    * @param _owner  The address of the token holder
298    * @param _id     ID of the Token
299    * @return        The _owner's balance of the Token type requested
300    */
301   function balanceOf(address _owner, uint256 _id) external view returns (uint256);
302 
303   /**
304    * @notice Get the balance of multiple account/token pairs
305    * @param _owners The addresses of the token holders
306    * @param _ids    ID of the Tokens
307    * @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)
308    */
309   function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids) external view returns (uint256[] memory);
310 
311   /**
312    * @notice Enable or disable approval for a third party ("operator") to manage all of caller's tokens
313    * @dev MUST emit the ApprovalForAll event on success
314    * @param _operator  Address to add to the set of authorized operators
315    * @param _approved  True if the operator is approved, false to revoke approval
316    */
317   function setApprovalForAll(address _operator, bool _approved) external;
318 
319   /**
320    * @notice Queries the approval status of an operator for a given owner
321    * @param _owner     The owner of the Tokens
322    * @param _operator  Address of authorized operator
323    * @return           True if the operator is approved, false if not
324    */
325   function isApprovedForAll(address _owner, address _operator) external view returns (bool isOperator);
326 
327 }
328 
329 // File: contracts\multi-token-standard\utils\Address.sol
330 
331 /**
332  * Copyright 2018 ZeroEx Intl.
333  * Licensed under the Apache License, Version 2.0 (the "License");
334  * you may not use this file except in compliance with the License.
335  * You may obtain a copy of the License at
336  *   http://www.apache.org/licenses/LICENSE-2.0
337  * Unless required by applicable law or agreed to in writing, software
338  * distributed under the License is distributed on an "AS IS" BASIS,
339  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
340  * See the License for the specific language governing permissions and
341  * limitations under the License.
342  */
343 
344 pragma solidity ^0.5.12;
345 
346 
347 /**
348  * Utility library of inline functions on addresses
349  */
350 library Address {
351 
352   /**
353    * Returns whether the target address is a contract
354    * @dev This function will return false if invoked during the constructor of a contract,
355    * as the code is not actually created until after the constructor finishes.
356    * @param account address of the account to check
357    * @return whether the target address is a contract
358    */
359   function isContract(address account) internal view returns (bool) {
360     bytes32 codehash;
361     bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
362 
363     // XXX Currently there is no better way to check if there is a contract in an address
364     // than to check the size of the code at that address.
365     // See https://ethereum.stackexchange.com/a/14016/36603
366     // for more details about how this works.
367     // TODO Check this again before the Serenity release, because all addresses will be
368     // contracts then.
369     assembly { codehash := extcodehash(account) }
370     return (codehash != 0x0 && codehash != accountHash);
371   }
372 
373 }
374 
375 // File: contracts\multi-token-standard\tokens\ERC1155\ERC1155.sol
376 
377 pragma solidity ^0.5.12;
378 
379 
380 
381 
382 
383 
384 
385 /**
386  * @dev Implementation of Multi-Token Standard contract
387  */
388 contract ERC1155 is IERC165 {
389   using SafeMath for uint256;
390   using Address for address;
391 
392 
393   /***********************************|
394   |        Variables and Events       |
395   |__________________________________*/
396 
397   // onReceive function signatures
398   bytes4 constant internal ERC1155_RECEIVED_VALUE = 0xf23a6e61;
399   bytes4 constant internal ERC1155_BATCH_RECEIVED_VALUE = 0xbc197c81;
400 
401   // Objects balances
402   mapping (address => mapping(uint256 => uint256)) internal balances;
403 
404   // Operator Functions
405   mapping (address => mapping(address => bool)) internal operators;
406 
407   // Events
408   event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _amount);
409   event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _amounts);
410   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
411   event URI(string _uri, uint256 indexed _id);
412 
413 
414   /***********************************|
415   |     Public Transfer Functions     |
416   |__________________________________*/
417 
418   /**
419    * @notice Transfers amount amount of an _id from the _from address to the _to address specified
420    * @param _from    Source address
421    * @param _to      Target address
422    * @param _id      ID of the token type
423    * @param _amount  Transfered amount
424    * @param _data    Additional data with no specified format, sent in call to `_to`
425    */
426   function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount, bytes memory _data)
427     public
428   {
429     require((msg.sender == _from) || isApprovedForAll(_from, msg.sender), "ERC1155#safeTransferFrom: INVALID_OPERATOR");
430     require(_to != address(0),"ERC1155#safeTransferFrom: INVALID_RECIPIENT");
431     // require(_amount >= balances[_from][_id]) is not necessary since checked with safemath operations
432 
433     _safeTransferFrom(_from, _to, _id, _amount);
434     _callonERC1155Received(_from, _to, _id, _amount, _data);
435   }
436 
437   /**
438    * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
439    * @param _from     Source addresses
440    * @param _to       Target addresses
441    * @param _ids      IDs of each token type
442    * @param _amounts  Transfer amounts per token type
443    * @param _data     Additional data with no specified format, sent in call to `_to`
444    */
445   function safeBatchTransferFrom(address _from, address _to, uint256[] memory _ids, uint256[] memory _amounts, bytes memory _data)
446     public
447   {
448     // Requirements
449     require((msg.sender == _from) || isApprovedForAll(_from, msg.sender), "ERC1155#safeBatchTransferFrom: INVALID_OPERATOR");
450     require(_to != address(0), "ERC1155#safeBatchTransferFrom: INVALID_RECIPIENT");
451 
452     _safeBatchTransferFrom(_from, _to, _ids, _amounts);
453     _callonERC1155BatchReceived(_from, _to, _ids, _amounts, _data);
454   }
455 
456 
457   /***********************************|
458   |    Internal Transfer Functions    |
459   |__________________________________*/
460 
461   /**
462    * @notice Transfers amount amount of an _id from the _from address to the _to address specified
463    * @param _from    Source address
464    * @param _to      Target address
465    * @param _id      ID of the token type
466    * @param _amount  Transfered amount
467    */
468   function _safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount)
469     internal
470   {
471     // Update balances
472     balances[_from][_id] = balances[_from][_id].sub(_amount); // Subtract amount
473     balances[_to][_id] = balances[_to][_id].add(_amount);     // Add amount
474 
475     // Emit event
476     emit TransferSingle(msg.sender, _from, _to, _id, _amount);
477   }
478 
479   /**
480    * @notice Verifies if receiver is contract and if so, calls (_to).onERC1155Received(...)
481    */
482   function _callonERC1155Received(address _from, address _to, uint256 _id, uint256 _amount, bytes memory _data)
483     internal
484   {
485     // Check if recipient is contract
486     if (_to.isContract() && _to != address(this)) {
487       bytes4 retval = IERC1155TokenReceiver(_to).onERC1155Received(msg.sender, _from, _id, _amount, _data);
488       require(retval == ERC1155_RECEIVED_VALUE, "ERC1155#_callonERC1155Received: INVALID_ON_RECEIVE_MESSAGE");
489     }
490   }
491 
492   /**
493    * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
494    * @param _from     Source addresses
495    * @param _to       Target addresses
496    * @param _ids      IDs of each token type
497    * @param _amounts  Transfer amounts per token type
498    */
499   function _safeBatchTransferFrom(address _from, address _to, uint256[] memory _ids, uint256[] memory _amounts)
500     internal
501   {
502     require(_ids.length == _amounts.length, "ERC1155#_safeBatchTransferFrom: INVALID_ARRAYS_LENGTH");
503 
504     // Number of transfer to execute
505     uint256 nTransfer = _ids.length;
506 
507     // Executing all transfers
508     for (uint256 i = 0; i < nTransfer; i++) {
509       // Update storage balance of previous bin
510       balances[_from][_ids[i]] = balances[_from][_ids[i]].sub(_amounts[i]);
511       balances[_to][_ids[i]] = balances[_to][_ids[i]].add(_amounts[i]);
512     }
513 
514     // Emit event
515     emit TransferBatch(msg.sender, _from, _to, _ids, _amounts);
516   }
517 
518   /**
519    * @notice Verifies if receiver is contract and if so, calls (_to).onERC1155BatchReceived(...)
520    */
521   function _callonERC1155BatchReceived(address _from, address _to, uint256[] memory _ids, uint256[] memory _amounts, bytes memory _data)
522     internal
523   {
524     // Pass data if recipient is contract
525     if (_to.isContract() && _to != address(this)) {
526       bytes4 retval = IERC1155TokenReceiver(_to).onERC1155BatchReceived(msg.sender, _from, _ids, _amounts, _data);
527       require(retval == ERC1155_BATCH_RECEIVED_VALUE, "ERC1155#_callonERC1155BatchReceived: INVALID_ON_RECEIVE_MESSAGE");
528     }
529   }
530 
531 
532   /***********************************|
533   |         Operator Functions        |
534   |__________________________________*/
535 
536   /**
537    * @notice Enable or disable approval for a third party ("operator") to manage all of caller's tokens
538    * @param _operator  Address to add to the set of authorized operators
539    * @param _approved  True if the operator is approved, false to revoke approval
540    */
541   function setApprovalForAll(address _operator, bool _approved)
542     external
543   {
544     // Update operator status
545     operators[msg.sender][_operator] = _approved;
546     emit ApprovalForAll(msg.sender, _operator, _approved);
547   }
548 
549   /**
550    * @notice Queries the approval status of an operator for a given owner
551    * @param _owner     The owner of the Tokens
552    * @param _operator  Address of authorized operator
553    * @return True if the operator is approved, false if not
554    */
555   function isApprovedForAll(address _owner, address _operator)
556     public view returns (bool isOperator)
557   {
558     return operators[_owner][_operator];
559   }
560 
561 
562   /***********************************|
563   |         Balance Functions         |
564   |__________________________________*/
565 
566   /**
567    * @notice Get the balance of an account's Tokens
568    * @param _owner  The address of the token holder
569    * @param _id     ID of the Token
570    * @return The _owner's balance of the Token type requested
571    */
572   function balanceOf(address _owner, uint256 _id)
573     public view returns (uint256)
574   {
575     return balances[_owner][_id];
576   }
577 
578   /**
579    * @notice Get the balance of multiple account/token pairs
580    * @param _owners The addresses of the token holders
581    * @param _ids    ID of the Tokens
582    * @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)
583    */
584   function balanceOfBatch(address[] memory _owners, uint256[] memory _ids)
585     public view returns (uint256[] memory)
586   {
587     require(_owners.length == _ids.length, "ERC1155#balanceOfBatch: INVALID_ARRAY_LENGTH");
588 
589     // Variables
590     uint256[] memory batchBalances = new uint256[](_owners.length);
591 
592     // Iterate over each owner and token ID
593     for (uint256 i = 0; i < _owners.length; i++) {
594       batchBalances[i] = balances[_owners[i]][_ids[i]];
595     }
596 
597     return batchBalances;
598   }
599 
600 
601   /***********************************|
602   |          ERC165 Functions         |
603   |__________________________________*/
604 
605   /**
606    * INTERFACE_SIGNATURE_ERC165 = bytes4(keccak256("supportsInterface(bytes4)"));
607    */
608   bytes4 constant private INTERFACE_SIGNATURE_ERC165 = 0x01ffc9a7;
609 
610   /**
611    * INTERFACE_SIGNATURE_ERC1155 =
612    * bytes4(keccak256("safeTransferFrom(address,address,uint256,uint256,bytes)")) ^
613    * bytes4(keccak256("safeBatchTransferFrom(address,address,uint256[],uint256[],bytes)")) ^
614    * bytes4(keccak256("balanceOf(address,uint256)")) ^
615    * bytes4(keccak256("balanceOfBatch(address[],uint256[])")) ^
616    * bytes4(keccak256("setApprovalForAll(address,bool)")) ^
617    * bytes4(keccak256("isApprovedForAll(address,address)"));
618    */
619   bytes4 constant private INTERFACE_SIGNATURE_ERC1155 = 0xd9b67a26;
620 
621   /**
622    * @notice Query if a contract implements an interface
623    * @param _interfaceID  The interface identifier, as specified in ERC-165
624    * @return `true` if the contract implements `_interfaceID` and
625    */
626   function supportsInterface(bytes4 _interfaceID) external view returns (bool) {
627     if (_interfaceID == INTERFACE_SIGNATURE_ERC165 ||
628         _interfaceID == INTERFACE_SIGNATURE_ERC1155) {
629       return true;
630     }
631     return false;
632   }
633 
634 }
635 
636 // File: contracts\multi-token-standard\tokens\ERC1155\ERC1155Metadata.sol
637 
638 pragma solidity ^0.5.11;
639 
640 
641 
642 /**
643  * @notice Contract that handles metadata related methods.
644  * @dev Methods assume a deterministic generation of URI based on token IDs.
645  *      Methods also assume that URI uses hex representation of token IDs.
646  */
647 contract ERC1155Metadata {
648 
649   // URI's default URI prefix
650   string internal baseMetadataURI;
651   event URI(string _uri, uint256 indexed _id);
652 
653 
654   /***********************************|
655   |     Metadata Public Function s    |
656   |__________________________________*/
657 
658   /**
659    * @notice A distinct Uniform Resource Identifier (URI) for a given token.
660    * @dev URIs are defined in RFC 3986.
661    *      URIs are assumed to be deterministically generated based on token ID
662    *      Token IDs are assumed to be represented in their hex format in URIs
663    * @return URI string
664    */
665   function uri(uint256 _id) public view returns (string memory) {
666     return string(abi.encodePacked(baseMetadataURI, _uint2str(_id), ".json"));
667   }
668 
669 
670   /***********************************|
671   |    Metadata Internal Functions    |
672   |__________________________________*/
673 
674   /**
675    * @notice Will emit default URI log event for corresponding token _id
676    * @param _tokenIDs Array of IDs of tokens to log default URI
677    */
678   function _logURIs(uint256[] memory _tokenIDs) internal {
679     string memory baseURL = baseMetadataURI;
680     string memory tokenURI;
681 
682     for (uint256 i = 0; i < _tokenIDs.length; i++) {
683       tokenURI = string(abi.encodePacked(baseURL, _uint2str(_tokenIDs[i]), ".json"));
684       emit URI(tokenURI, _tokenIDs[i]);
685     }
686   }
687 
688   /**
689    * @notice Will emit a specific URI log event for corresponding token
690    * @param _tokenIDs IDs of the token corresponding to the _uris logged
691    * @param _URIs    The URIs of the specified _tokenIDs
692    */
693   function _logURIs(uint256[] memory _tokenIDs, string[] memory _URIs) internal {
694     require(_tokenIDs.length == _URIs.length, "ERC1155Metadata#_logURIs: INVALID_ARRAYS_LENGTH");
695     for (uint256 i = 0; i < _tokenIDs.length; i++) {
696       emit URI(_URIs[i], _tokenIDs[i]);
697     }
698   }
699 
700   /**
701    * @notice Will update the base URL of token's URI
702    * @param _newBaseMetadataURI New base URL of token's URI
703    */
704   function _setBaseMetadataURI(string memory _newBaseMetadataURI) internal {
705     baseMetadataURI = _newBaseMetadataURI;
706   }
707 
708 
709   /***********************************|
710   |    Utility Internal Functions     |
711   |__________________________________*/
712 
713   /**
714    * @notice Convert uint256 to string
715    * @param _i Unsigned integer to convert to string
716    */
717   function _uint2str(uint256 _i) internal pure returns (string memory _uintAsString) {
718     if (_i == 0) {
719       return "0";
720     }
721 
722     uint256 j = _i;
723     uint256 ii = _i;
724     uint256 len;
725 
726     // Get number of bytes
727     while (j != 0) {
728       len++;
729       j /= 10;
730     }
731 
732     bytes memory bstr = new bytes(len);
733     uint256 k = len - 1;
734 
735     // Get each individual ASCII
736     while (ii != 0) {
737       bstr[k--] = byte(uint8(48 + ii % 10));
738       ii /= 10;
739     }
740 
741     // Convert to string
742     return string(bstr);
743   }
744 
745 }
746 
747 // File: contracts\multi-token-standard\tokens\ERC1155\ERC1155MintBurn.sol
748 
749 pragma solidity ^0.5.12;
750 
751 
752 
753 /**
754  * @dev Multi-Fungible Tokens with minting and burning methods. These methods assume
755  *      a parent contract to be executed as they are `internal` functions
756  */
757 contract ERC1155MintBurn is ERC1155 {
758 
759 
760   /****************************************|
761   |            Minting Functions           |
762   |_______________________________________*/
763 
764   /**
765    * @notice Mint _amount of tokens of a given id
766    * @param _to      The address to mint tokens to
767    * @param _id      Token id to mint
768    * @param _amount  The amount to be minted
769    * @param _data    Data to pass if receiver is contract
770    */
771   function _mint(address _to, uint256 _id, uint256 _amount, bytes memory _data)
772     internal
773   {
774     // Add _amount
775     balances[_to][_id] = balances[_to][_id].add(_amount);
776 
777     // Emit event
778     emit TransferSingle(msg.sender, address(0x0), _to, _id, _amount);
779 
780     // Calling onReceive method if recipient is contract
781     _callonERC1155Received(address(0x0), _to, _id, _amount, _data);
782   }
783 
784   /**
785    * @notice Mint tokens for each ids in _ids
786    * @param _to       The address to mint tokens to
787    * @param _ids      Array of ids to mint
788    * @param _amounts  Array of amount of tokens to mint per id
789    * @param _data    Data to pass if receiver is contract
790    */
791   function _batchMint(address _to, uint256[] memory _ids, uint256[] memory _amounts, bytes memory _data)
792     internal
793   {
794     require(_ids.length == _amounts.length, "ERC1155MintBurn#batchMint: INVALID_ARRAYS_LENGTH");
795 
796     // Number of mints to execute
797     uint256 nMint = _ids.length;
798 
799      // Executing all minting
800     for (uint256 i = 0; i < nMint; i++) {
801       // Update storage balance
802       balances[_to][_ids[i]] = balances[_to][_ids[i]].add(_amounts[i]);
803     }
804 
805     // Emit batch mint event
806     emit TransferBatch(msg.sender, address(0x0), _to, _ids, _amounts);
807 
808     // Calling onReceive method if recipient is contract
809     _callonERC1155BatchReceived(address(0x0), _to, _ids, _amounts, _data);
810   }
811 
812 
813   /****************************************|
814   |            Burning Functions           |
815   |_______________________________________*/
816 
817   /**
818    * @notice Burn _amount of tokens of a given token id
819    * @param _from    The address to burn tokens from
820    * @param _id      Token id to burn
821    * @param _amount  The amount to be burned
822    */
823   function _burn(address _from, uint256 _id, uint256 _amount)
824     internal
825   {
826     //Substract _amount
827     balances[_from][_id] = balances[_from][_id].sub(_amount);
828 
829     // Emit event
830     emit TransferSingle(msg.sender, _from, address(0x0), _id, _amount);
831   }
832 
833   /**
834    * @notice Burn tokens of given token id for each (_ids[i], _amounts[i]) pair
835    * @param _from     The address to burn tokens from
836    * @param _ids      Array of token ids to burn
837    * @param _amounts  Array of the amount to be burned
838    */
839   function _batchBurn(address _from, uint256[] memory _ids, uint256[] memory _amounts)
840     internal
841   {
842     require(_ids.length == _amounts.length, "ERC1155MintBurn#batchBurn: INVALID_ARRAYS_LENGTH");
843 
844     // Number of mints to execute
845     uint256 nBurn = _ids.length;
846 
847      // Executing all minting
848     for (uint256 i = 0; i < nBurn; i++) {
849       // Update storage balance
850       balances[_from][_ids[i]] = balances[_from][_ids[i]].sub(_amounts[i]);
851     }
852 
853     // Emit batch mint event
854     emit TransferBatch(msg.sender, _from, address(0x0), _ids, _amounts);
855   }
856 
857 }
858 
859 // File: contracts\Strings.sol
860 
861 pragma solidity ^0.5.11;
862 
863 library Strings {
864   // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
865   function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory) {
866       bytes memory _ba = bytes(_a);
867       bytes memory _bb = bytes(_b);
868       bytes memory _bc = bytes(_c);
869       bytes memory _bd = bytes(_d);
870       bytes memory _be = bytes(_e);
871       string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
872       bytes memory babcde = bytes(abcde);
873       uint k = 0;
874       for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
875       for (uint i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
876       for (uint i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
877       for (uint i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
878       for (uint i = 0; i < _be.length; i++) babcde[k++] = _be[i];
879       return string(babcde);
880     }
881 
882     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory) {
883         return strConcat(_a, _b, _c, _d, "");
884     }
885 
886     function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory) {
887         return strConcat(_a, _b, _c, "", "");
888     }
889 
890     function strConcat(string memory _a, string memory _b) internal pure returns (string memory) {
891         return strConcat(_a, _b, "", "", "");
892     }
893 
894     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
895         if (_i == 0) {
896             return "0";
897         }
898         uint j = _i;
899         uint len;
900         while (j != 0) {
901             len++;
902             j /= 10;
903         }
904         bytes memory bstr = new bytes(len);
905         uint k = len - 1;
906         while (_i != 0) {
907             bstr[k--] = byte(uint8(48 + _i % 10));
908             _i /= 10;
909         }
910         return string(bstr);
911     }
912 }
913 
914 // File: contracts\ERC1155Tradable.sol
915 
916 pragma solidity ^0.5.12;
917 
918 
919 
920 
921 
922 
923 contract OwnableDelegateProxy { }
924 
925 contract ProxyRegistry {
926   mapping(address => OwnableDelegateProxy) public proxies;
927 }
928 
929 interface ERC721 {
930     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
931     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
932     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
933     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;
934     function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
935     function approve(address _approved, uint256 _tokenId) external payable;
936     function setApprovalForAll(address _operator, bool _approved) external;
937     function getApproved(uint256 _tokenId) external view returns (address);
938     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
939 }
940 
941 /**
942  * @title ERC1155Tradable
943  * ERC1155Tradable - ERC1155 contract that whitelists an operator address, has create and mint functionality, and supports useful standards from OpenZeppelin, 
944   like _exists(), name(), symbol(), and totalSupply()
945  */
946 contract ERC1155Tradable is ERC1155, ERC1155MintBurn, ERC1155Metadata, Ownable {
947   using Strings for string;
948 
949   event ArtCreated(uint token, uint amount, string name, address artist);
950 
951   uint256 printFee = 4000000000000000;
952   address admin;
953   address treasurer;
954   bool lock = false;
955   address oldContract = 0x677D8FE828Fd7143FF3CeE5883b7fC81e7c2de60;
956   address proxyRegistryAddress;
957   uint256 private _currentTokenID = 0;
958   mapping (uint256 => address) public creators;
959   mapping (uint256 => uint256) public tokenSupply;
960   // Contract name
961   string public name;
962   // Contract symbol
963   string public symbol;
964 
965   /**
966    * @dev Require msg.sender to be the creator of the token id
967    */
968   modifier creatorOnly(uint256 _id) {
969     require(creators[_id] == msg.sender, "ERC1155Tradable#creatorOnly: ONLY_CREATOR_ALLOWED");
970     _;
971   }
972 
973   /**
974    * @dev Require msg.sender to own more than 0 of the token id
975    */
976   modifier ownersOnly(uint256 _id, uint256 _amount) {
977     require(balances[msg.sender][_id] >= _amount, "ERC1155Tradable#ownersOnly: ONLY_OWNERS_ALLOWED");
978     _;
979   }
980 
981   /**
982    * @dev Require msg.sender to be admin
983    */
984   modifier onlyAdmin() {
985     require(msg.sender == admin, "ERC1155Tradable#ownersOnly: ONLY_ADMIN_ALLOWED");
986     _;
987   }
988 
989   constructor(
990     string memory _name,
991     string memory _symbol,
992     address _proxyRegistryAddress
993   ) public {
994     name = _name;
995     symbol = _symbol;
996     admin = 0x486082148bc8Dc9DEe8c9E53649ea148291FF292;
997     treasurer = 0xEbBFE1A7ffd8C0065eF1a87F018BaB8cf9aF1207;
998     proxyRegistryAddress = _proxyRegistryAddress;
999   }
1000 
1001   function uri(
1002     uint256 _id
1003   ) public view returns (string memory) {
1004     require(_exists(_id), "ERC721Tradable#uri: NONEXISTENT_TOKEN");
1005     return Strings.strConcat(
1006       baseMetadataURI,
1007       Strings.uint2str(_id)
1008     );
1009   }
1010 
1011   /**
1012     * @dev Returns the total quantity for a token ID
1013     * @param _id uint256 ID of the token to query
1014     * @return amount of token in existence
1015     */
1016   function totalSupply(
1017     uint256 _id
1018   ) public view returns (uint256) {
1019     return tokenSupply[_id];
1020   }
1021 
1022   /**
1023    * @dev Will update the base URL of token's URI
1024    * @param _newBaseMetadataURI New base URL of token's URI
1025    */
1026   function setBaseMetadataURI(
1027     string memory _newBaseMetadataURI
1028   ) public onlyAdmin {
1029     _setBaseMetadataURI(_newBaseMetadataURI);
1030   }
1031 
1032   /**
1033     * @dev Change the creator address for given tokens
1034     * @param _to   Address of the new creator
1035     * @param _ids  Array of Token IDs to change creator
1036     */
1037   function setCreator(
1038     address _to,
1039     uint256[] memory _ids
1040   ) public {
1041     require(_to != address(0), "ERC1155Tradable#setCreator: INVALID_ADDRESS.");
1042     for (uint256 i = 0; i < _ids.length; i++) {
1043       uint256 id = _ids[i];
1044       _setCreator(_to, id);
1045     }
1046   }
1047 
1048   /**
1049    * Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-free listings.
1050    */
1051   function isApprovedForAll(
1052     address _owner,
1053     address _operator
1054   ) public view returns (bool isOperator) {
1055     // Whitelist OpenSea proxy contract for easy trading.
1056     ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1057     if (address(proxyRegistry.proxies(_owner)) == _operator) {
1058       return true;
1059     }
1060 
1061     if (address(this) == _operator) {
1062       return true;
1063     }
1064 
1065     return ERC1155.isApprovedForAll(_owner, _operator);
1066   }
1067 
1068   /**
1069     * @dev Change the creator address for given token
1070     * @param _to   Address of the new creator
1071     * @param _id  Token IDs to change creator of
1072     */
1073   function _setCreator(address _to, uint256 _id) internal creatorOnly(_id)
1074   {
1075       creators[_id] = _to;
1076   }
1077 
1078   /**
1079     * @dev Returns whether the specified token exists by checking to see if it has a creator
1080     * @param _id uint256 ID of the token to query the existence of
1081     * @return bool whether the token exists
1082     */
1083   function _exists(
1084     uint256 _id
1085   ) internal view returns (bool) {
1086     return creators[_id] != address(0);
1087   }
1088 
1089   /**
1090     * @dev calculates the next token ID based on value of _currentTokenID
1091     * @return uint256 for the next token ID
1092     */
1093   function _getNextTokenID() private view returns (uint256) {
1094     return _currentTokenID.add(1);
1095   }
1096 
1097   /**
1098     * @dev increments the value of _currentTokenID
1099     */
1100   function _incrementTokenTypeId() private  {
1101     _currentTokenID++;
1102   }
1103 
1104   /**
1105     * @dev Creates a new token type and assigns _initialSupply to an address
1106     * NOTE: remove onlyOwner if you want third parties to create new tokens on your contract (which may change your IDs)
1107     * @param _initialSupply amount to supply the first owner
1108     * @param _name of artwork
1109     * @param _uri Optional URI for this token type
1110     * @param _data Data to pass if receiver is contract
1111     * @return The newly created token ID
1112     */
1113   function create(
1114     uint256 _initialSupply,
1115     string calldata _name,
1116     string calldata _uri,
1117     bytes calldata _data
1118   ) external payable returns (uint256) {
1119     require(_initialSupply > 0, "Cannot print 0 pieces!");
1120     require(msg.value >= printFee * _initialSupply, "Insufficient Balance");
1121 
1122     treasurer.call.value(msg.value)("");
1123     uint256 _id = _getNextTokenID();
1124     _incrementTokenTypeId();
1125     creators[_id] = msg.sender;
1126 
1127     if (bytes(_uri).length > 0) {
1128       emit URI(_uri, _id);
1129     }
1130 
1131     _mint(msg.sender, _id, _initialSupply, _data);
1132 
1133     tokenSupply[_id] = _initialSupply;
1134     emit ArtCreated(_id, _initialSupply, _name, msg.sender);
1135     return _id;
1136   }
1137 
1138   function toggleImports() public onlyAdmin{
1139     lock = !lock;
1140   }
1141 
1142   function importToken(uint256 _tokenIndex, string calldata _uri, bytes calldata _data) external{
1143     require(lock == false, "Imports Locked");
1144     ERC721(oldContract).transferFrom(msg.sender, address(0), _tokenIndex);
1145     uint256 _id = _getNextTokenID();
1146     _incrementTokenTypeId();
1147     creators[_id] = msg.sender;
1148 
1149     if (bytes(_uri).length > 0) {
1150       emit URI(_uri, _id);
1151     }
1152     _mint(msg.sender, _id, 1, _data);
1153     tokenSupply[_id] = 1;
1154     emit ArtCreated(_id, 1, "Imported Art", msg.sender);
1155   }
1156 
1157 }
1158 
1159 // File: contracts\BAE.sol
1160 
1161 // SPDX-License-Identifier: MIT
1162 
1163 pragma solidity ^0.5.12;
1164 
1165 contract BAE is ERC1155Tradable {
1166     event AuctionStart(address creator, uint256 token, uint256 startingBid, uint256 auctionIndex, uint256 expiry);
1167     event AuctionEnd(uint256 token, uint256 finalBid, address owner, address newOwner, uint256 auctionIndex);
1168     event AuctionReset(uint256 auctionIndex, uint256 newExpiry, uint256 newPrice);
1169     event Bid(address bidder, uint256 token, uint256 auctionIndex, uint256 amount);
1170 
1171     uint256 public auctionCount;
1172 
1173     uint256 public auctionFee = 5; //Out of 1000 for 100%
1174 
1175     struct auctionData{
1176       address owner;
1177       address lastBidder;
1178       uint256 bid;
1179       uint256 expiry;
1180       uint256 token;
1181     }
1182 
1183     mapping(uint256 => auctionData) public auctionList;
1184 
1185     constructor(address _proxyRegistryAddress)
1186     ERC1155Tradable(
1187       "Blockchain Art Exchange",
1188       "BAE",
1189       _proxyRegistryAddress
1190     ) public {
1191       _setBaseMetadataURI("https://api.mybae.io/tokens/");
1192     }
1193 
1194     function changePrintFee(uint256 _newPrice) public onlyAdmin{
1195       printFee = _newPrice;
1196     }
1197 
1198     function setAuctionFee(uint256 _newFee) public onlyAdmin{
1199       require(_newFee < 1000, "Fee Too High!");
1200       auctionFee = _newFee;
1201     }
1202 
1203     function createAuction(uint256 _price, uint256 _expiry, uint256 _token, uint256 _amount) public ownersOnly(_token, _amount){
1204       require(block.timestamp < _expiry, "Auction Date Passed");
1205       require(block.timestamp + (86400 * 14) > _expiry, "Auction Date Too Far");
1206       require(_price > 0, "Auction Price Cannot Be 0");
1207       for(uint x = 0; x < _amount; x++){
1208         safeTransferFrom(msg.sender, address(this), _token, 1, "");
1209         auctionList[auctionCount] = auctionData(msg.sender, address(0), _price, _expiry, _token);
1210         emit AuctionStart(msg.sender, _token, _price, auctionCount, _expiry);
1211         auctionCount++;
1212       }
1213     }
1214 
1215     function bid(uint256 _index) public payable {
1216       require(auctionList[_index].expiry > block.timestamp);
1217       require(auctionList[_index].bid + 10000000000000000 <= msg.value);
1218       require(msg.sender != auctionList[_index].owner);
1219       require(msg.sender != auctionList[_index].lastBidder);
1220       if(auctionList[_index].lastBidder != address(0)){
1221         auctionList[_index].lastBidder.call.value(auctionList[_index].bid)("");
1222       }
1223       auctionList[_index].bid = msg.value;
1224       auctionList[_index].lastBidder = msg.sender;
1225       emit Bid(msg.sender, auctionList[_index].token, _index, msg.value);
1226     }
1227 
1228     function buy(uint256 _index) public payable {
1229       require(auctionList[_index].expiry < block.timestamp);
1230       require(auctionList[_index].bid <= msg.value);
1231       require(address(0) == auctionList[_index].lastBidder);
1232       require(auctionList[_index].bid > 0);
1233       this.safeTransferFrom(address(this), msg.sender, auctionList[_index].token, 1, "");
1234       uint256 fee = auctionList[_index].bid * auctionFee / 1000;
1235       treasurer.call.value(fee)("");
1236       auctionList[_index].owner.call.value(auctionList[_index].bid.sub(fee))("");
1237       emit AuctionEnd(auctionList[_index].token, auctionList[_index].bid, auctionList[_index].owner, msg.sender, _index);
1238 
1239       auctionList[_index].lastBidder = msg.sender;
1240       auctionList[_index].bid = 0;
1241     }
1242 
1243     function resetAuction(uint256 _index, uint256 _expiry, uint256 _price) public{
1244       require(msg.sender == auctionList[_index].owner, "You Dont Own This Auction!");
1245       require(address(0) == auctionList[_index].lastBidder, "Someone Won This Auction!");
1246       require(auctionList[_index].expiry < block.timestamp, "Auction Is Still Running");
1247       require(_expiry > block.timestamp, "Auction Date Passed");
1248       auctionList[_index].expiry = _expiry;
1249       auctionList[_index].bid = _price;
1250       emit AuctionReset(_index, _expiry, _price);
1251     }
1252 
1253     function concludeAuction(uint256 _index) public{
1254       require(auctionList[_index].expiry < block.timestamp, "Auction Not Expired");
1255       require(auctionList[_index].bid != 0, "Auction Concluded");
1256       if(auctionList[_index].lastBidder != address(0)){
1257         this.safeTransferFrom(address(this), auctionList[_index].lastBidder, auctionList[_index].token, 1, "");
1258         uint256 fee = auctionList[_index].bid * auctionFee / 1000;
1259         treasurer.call.value(fee)("");
1260         auctionList[_index].owner.call.value(auctionList[_index].bid.sub(fee))("");
1261         emit AuctionEnd(auctionList[_index].token, auctionList[_index].bid, auctionList[_index].owner, auctionList[_index].lastBidder, _index);
1262       }
1263       else{
1264         this.safeTransferFrom(address(this), auctionList[_index].owner, auctionList[_index].token, 1, "");
1265         emit AuctionEnd(auctionList[_index].token, 0, auctionList[_index].owner, auctionList[_index].owner, _index);
1266       }
1267       auctionList[_index].lastBidder = address(0);
1268       auctionList[_index].bid = 0;
1269     }
1270 
1271 
1272 }