1 pragma solidity ^0.5.0;
2 
3 
4 /**
5  * @title ERC165
6  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
7  */
8 interface IERC165 {
9     /**
10      * @notice Query if a contract implements an interface
11      * @dev Interface identification is specified in ERC-165. This function
12      * uses less than 30,000 gas
13      * @param _interfaceId The interface identifier, as specified in ERC-165
14      */
15     function supportsInterface(bytes4 _interfaceId)
16         external
17         view
18         returns (bool);
19 }
20 
21 /**
22  * @dev ERC-1155 interface for accepting safe transfers.
23  */
24 interface IERC1155TokenReceiver {
25     /**
26      * @notice Handle the receipt of a single ERC1155 token type
27      * @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeTransferFrom` after the balance has been updated
28      * This function MAY throw to revert and reject the transfer
29      * Return of other amount than the magic value MUST result in the transaction being reverted
30      * Note: The token contract address is always the message sender
31      * @param _operator  The address which called the `safeTransferFrom` function
32      * @param _from      The address which previously owned the token
33      * @param _id        The id of the token being transferred
34      * @param _amount    The amount of tokens being transferred
35      * @param _data      Additional data with no specified format
36      * @return           `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
37      */
38     function onERC1155Received(
39         address _operator,
40         address _from,
41         uint256 _id,
42         uint256 _amount,
43         bytes calldata _data
44     ) external returns (bytes4);
45 
46     /**
47      * @notice Handle the receipt of multiple ERC1155 token types
48      * @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeBatchTransferFrom` after the balances have been updated
49      * This function MAY throw to revert and reject the transfer
50      * Return of other amount than the magic value WILL result in the transaction being reverted
51      * Note: The token contract address is always the message sender
52      * @param _operator  The address which called the `safeBatchTransferFrom` function
53      * @param _from      The address which previously owned the token
54      * @param _ids       An array containing ids of each token being transferred
55      * @param _amounts   An array containing amounts of each token being transferred
56      * @param _data      Additional data with no specified format
57      * @return           `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
58      */
59     function onERC1155BatchReceived(
60         address _operator,
61         address _from,
62         uint256[] calldata _ids,
63         uint256[] calldata _amounts,
64         bytes calldata _data
65     ) external returns (bytes4);
66 
67     /**
68      * @notice Indicates whether a contract implements the `ERC1155TokenReceiver` functions and so can accept ERC1155 token types.
69      * @param  interfaceID The ERC-165 interface ID that is queried for support.s
70      * @dev This function MUST return true if it implements the ERC1155TokenReceiver interface and ERC-165 interface.
71      *      This function MUST NOT consume more than 5,000 gas.
72      * @return Wheter ERC-165 or ERC1155TokenReceiver interfaces are supported.
73      */
74     function supportsInterface(bytes4 interfaceID) external view returns (bool);
75 }
76 
77 /**
78  * @title SafeMath
79  * @dev Unsigned math operations with safety checks that revert on error
80  */
81 library SafeMath {
82     /**
83      * @dev Multiplies two unsigned integers, reverts on overflow.
84      */
85     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
86         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
87         // benefit is lost if 'b' is also tested.
88         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
89         if (a == 0) {
90             return 0;
91         }
92 
93         uint256 c = a * b;
94         require(c / a == b, "SafeMath#mul: OVERFLOW");
95 
96         return c;
97     }
98 
99     /**
100      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
101      */
102     function div(uint256 a, uint256 b) internal pure returns (uint256) {
103         // Solidity only automatically asserts when dividing by 0
104         require(b > 0, "SafeMath#div: DIVISION_BY_ZERO");
105         uint256 c = a / b;
106         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
107 
108         return c;
109     }
110 
111     /**
112      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
113      */
114     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
115         require(b <= a, "SafeMath#sub: UNDERFLOW");
116         uint256 c = a - b;
117 
118         return c;
119     }
120 
121     /**
122      * @dev Adds two unsigned integers, reverts on overflow.
123      */
124     function add(uint256 a, uint256 b) internal pure returns (uint256) {
125         uint256 c = a + b;
126         require(c >= a, "SafeMath#add: OVERFLOW");
127 
128         return c;
129     }
130 
131     /**
132      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
133      * reverts when dividing by zero.
134      */
135     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
136         require(b != 0, "SafeMath#mod: DIVISION_BY_ZERO");
137         return a % b;
138     }
139 }
140 
141 /**
142  * Copyright 2018 ZeroEx Intl.
143  * Licensed under the Apache License, Version 2.0 (the "License");
144  * you may not use this file except in compliance with the License.
145  * You may obtain a copy of the License at
146  *   http://www.apache.org/licenses/LICENSE-2.0
147  * Unless required by applicable law or agreed to in writing, software
148  * distributed under the License is distributed on an "AS IS" BASIS,
149  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
150  * See the License for the specific language governing permissions and
151  * limitations under the License.
152  */
153 /**
154  * Utility library of inline functions on addresses
155  */
156 library Address {
157     /**
158      * Returns whether the target address is a contract
159      * @dev This function will return false if invoked during the constructor of a contract,
160      * as the code is not actually created until after the constructor finishes.
161      * @param account address of the account to check
162      * @return whether the target address is a contract
163      */
164     function isContract(address account) internal view returns (bool) {
165         bytes32 codehash;
166 
167 
168             bytes32 accountHash
169          = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
170 
171         // XXX Currently there is no better way to check if there is a contract in an address
172         // than to check the size of the code at that address.
173         // See https://ethereum.stackexchange.com/a/14016/36603
174         // for more details about how this works.
175         // TODO Check this again before the Serenity release, because all addresses will be
176         // contracts then.
177         assembly {
178             codehash := extcodehash(account)
179         }
180         return (codehash != 0x0 && codehash != accountHash);
181     }
182 }
183 
184 /**
185  * @dev Implementation of Multi-Token Standard contract
186  */
187 contract ERC1155 is IERC165 {
188     using SafeMath for uint256;
189     using Address for address;
190 
191     /***********************************|
192   |        Variables and Events       |
193   |__________________________________*/
194 
195     // onReceive function signatures
196     bytes4 internal constant ERC1155_RECEIVED_VALUE = 0xf23a6e61;
197     bytes4 internal constant ERC1155_BATCH_RECEIVED_VALUE = 0xbc197c81;
198 
199     // Objects balances
200     mapping(address => mapping(uint256 => uint256)) internal balances;
201 
202     // Operator Functions
203     mapping(address => mapping(address => bool)) internal operators;
204 
205     // Events
206     event TransferSingle(
207         address indexed _operator,
208         address indexed _from,
209         address indexed _to,
210         uint256 _id,
211         uint256 _amount
212     );
213     event TransferBatch(
214         address indexed _operator,
215         address indexed _from,
216         address indexed _to,
217         uint256[] _ids,
218         uint256[] _amounts
219     );
220     event ApprovalForAll(
221         address indexed _owner,
222         address indexed _operator,
223         bool _approved
224     );
225     event URI(string _uri, uint256 indexed _id);
226 
227     /***********************************|
228   |     Public Transfer Functions     |
229   |__________________________________*/
230 
231     /**
232      * @notice Transfers amount amount of an _id from the _from address to the _to address specified
233      * @param _from    Source address
234      * @param _to      Target address
235      * @param _id      ID of the token type
236      * @param _amount  Transfered amount
237      * @param _data    Additional data with no specified format, sent in call to `_to`
238      */
239     function safeTransferFrom(
240         address _from,
241         address _to,
242         uint256 _id,
243         uint256 _amount,
244         bytes memory _data
245     ) public {
246         require(
247             (msg.sender == _from) || isApprovedForAll(_from, msg.sender),
248             "ERC1155#safeTransferFrom: INVALID_OPERATOR"
249         );
250         require(
251             _to != address(0),
252             "ERC1155#safeTransferFrom: INVALID_RECIPIENT"
253         );
254         // require(_amount >= balances[_from][_id]) is not necessary since checked with safemath operations
255 
256         _safeTransferFrom(_from, _to, _id, _amount);
257         _callonERC1155Received(_from, _to, _id, _amount, _data);
258     }
259 
260     /**
261      * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
262      * @param _from     Source addresses
263      * @param _to       Target addresses
264      * @param _ids      IDs of each token type
265      * @param _amounts  Transfer amounts per token type
266      * @param _data     Additional data with no specified format, sent in call to `_to`
267      */
268     function safeBatchTransferFrom(
269         address _from,
270         address _to,
271         uint256[] memory _ids,
272         uint256[] memory _amounts,
273         bytes memory _data
274     ) public {
275         // Requirements
276         require(
277             (msg.sender == _from) || isApprovedForAll(_from, msg.sender),
278             "ERC1155#safeBatchTransferFrom: INVALID_OPERATOR"
279         );
280         require(
281             _to != address(0),
282             "ERC1155#safeBatchTransferFrom: INVALID_RECIPIENT"
283         );
284 
285         _safeBatchTransferFrom(_from, _to, _ids, _amounts);
286         _callonERC1155BatchReceived(_from, _to, _ids, _amounts, _data);
287     }
288 
289     /***********************************|
290   |    Internal Transfer Functions    |
291   |__________________________________*/
292 
293     /**
294      * @notice Transfers amount amount of an _id from the _from address to the _to address specified
295      * @param _from    Source address
296      * @param _to      Target address
297      * @param _id      ID of the token type
298      * @param _amount  Transfered amount
299      */
300     function _safeTransferFrom(
301         address _from,
302         address _to,
303         uint256 _id,
304         uint256 _amount
305     ) internal {
306         // Update balances
307         balances[_from][_id] = balances[_from][_id].sub(_amount); // Subtract amount
308         balances[_to][_id] = balances[_to][_id].add(_amount); // Add amount
309 
310         // Emit event
311         emit TransferSingle(msg.sender, _from, _to, _id, _amount);
312     }
313 
314     /**
315      * @notice Verifies if receiver is contract and if so, calls (_to).onERC1155Received(...)
316      */
317     function _callonERC1155Received(
318         address _from,
319         address _to,
320         uint256 _id,
321         uint256 _amount,
322         bytes memory _data
323     ) internal {
324         // Check if recipient is contract
325         if (_to.isContract()) {
326             bytes4 retval = IERC1155TokenReceiver(_to).onERC1155Received(
327                 msg.sender,
328                 _from,
329                 _id,
330                 _amount,
331                 _data
332             );
333             require(
334                 retval == ERC1155_RECEIVED_VALUE,
335                 "ERC1155#_callonERC1155Received: INVALID_ON_RECEIVE_MESSAGE"
336             );
337         }
338     }
339 
340     /**
341      * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
342      * @param _from     Source addresses
343      * @param _to       Target addresses
344      * @param _ids      IDs of each token type
345      * @param _amounts  Transfer amounts per token type
346      */
347     function _safeBatchTransferFrom(
348         address _from,
349         address _to,
350         uint256[] memory _ids,
351         uint256[] memory _amounts
352     ) internal {
353         require(
354             _ids.length == _amounts.length,
355             "ERC1155#_safeBatchTransferFrom: INVALID_ARRAYS_LENGTH"
356         );
357 
358         // Number of transfer to execute
359         uint256 nTransfer = _ids.length;
360 
361         // Executing all transfers
362         for (uint256 i = 0; i < nTransfer; i++) {
363             // Update storage balance of previous bin
364             balances[_from][_ids[i]] = balances[_from][_ids[i]].sub(
365                 _amounts[i]
366             );
367             balances[_to][_ids[i]] = balances[_to][_ids[i]].add(_amounts[i]);
368         }
369 
370         // Emit event
371         emit TransferBatch(msg.sender, _from, _to, _ids, _amounts);
372     }
373 
374     /**
375      * @notice Verifies if receiver is contract and if so, calls (_to).onERC1155BatchReceived(...)
376      */
377     function _callonERC1155BatchReceived(
378         address _from,
379         address _to,
380         uint256[] memory _ids,
381         uint256[] memory _amounts,
382         bytes memory _data
383     ) internal {
384         // Pass data if recipient is contract
385         if (_to.isContract()) {
386             bytes4 retval = IERC1155TokenReceiver(_to).onERC1155BatchReceived(
387                 msg.sender,
388                 _from,
389                 _ids,
390                 _amounts,
391                 _data
392             );
393             require(
394                 retval == ERC1155_BATCH_RECEIVED_VALUE,
395                 "ERC1155#_callonERC1155BatchReceived: INVALID_ON_RECEIVE_MESSAGE"
396             );
397         }
398     }
399 
400     /***********************************|
401   |         Operator Functions        |
402   |__________________________________*/
403 
404     /**
405      * @notice Enable or disable approval for a third party ("operator") to manage all of caller's tokens
406      * @param _operator  Address to add to the set of authorized operators
407      * @param _approved  True if the operator is approved, false to revoke approval
408      */
409     function setApprovalForAll(address _operator, bool _approved) external {
410         // Update operator status
411         operators[msg.sender][_operator] = _approved;
412         emit ApprovalForAll(msg.sender, _operator, _approved);
413     }
414 
415     /**
416      * @notice Queries the approval status of an operator for a given owner
417      * @param _owner     The owner of the Tokens
418      * @param _operator  Address of authorized operator
419      * @return True if the operator is approved, false if not
420      */
421     function isApprovedForAll(address _owner, address _operator)
422         public
423         view
424         returns (bool isOperator)
425     {
426         return operators[_owner][_operator];
427     }
428 
429     /***********************************|
430   |         Balance Functions         |
431   |__________________________________*/
432 
433     /**
434      * @notice Get the balance of an account's Tokens
435      * @param _owner  The address of the token holder
436      * @param _id     ID of the Token
437      * @return The _owner's balance of the Token type requested
438      */
439     function balanceOf(address _owner, uint256 _id)
440         public
441         view
442         returns (uint256)
443     {
444         return balances[_owner][_id];
445     }
446 
447     /**
448      * @notice Get the balance of multiple account/token pairs
449      * @param _owners The addresses of the token holders
450      * @param _ids    ID of the Tokens
451      * @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)
452      */
453     function balanceOfBatch(address[] memory _owners, uint256[] memory _ids)
454         public
455         view
456         returns (uint256[] memory)
457     {
458         require(
459             _owners.length == _ids.length,
460             "ERC1155#balanceOfBatch: INVALID_ARRAY_LENGTH"
461         );
462 
463         // Variables
464         uint256[] memory batchBalances = new uint256[](_owners.length);
465 
466         // Iterate over each owner and token ID
467         for (uint256 i = 0; i < _owners.length; i++) {
468             batchBalances[i] = balances[_owners[i]][_ids[i]];
469         }
470 
471         return batchBalances;
472     }
473 
474     /***********************************|
475   |          ERC165 Functions         |
476   |__________________________________*/
477 
478     /**
479      * INTERFACE_SIGNATURE_ERC165 = bytes4(keccak256("supportsInterface(bytes4)"));
480      */
481     bytes4 private constant INTERFACE_SIGNATURE_ERC165 = 0x01ffc9a7;
482 
483     /**
484      * INTERFACE_SIGNATURE_ERC1155 =
485      * bytes4(keccak256("safeTransferFrom(address,address,uint256,uint256,bytes)")) ^
486      * bytes4(keccak256("safeBatchTransferFrom(address,address,uint256[],uint256[],bytes)")) ^
487      * bytes4(keccak256("balanceOf(address,uint256)")) ^
488      * bytes4(keccak256("balanceOfBatch(address[],uint256[])")) ^
489      * bytes4(keccak256("setApprovalForAll(address,bool)")) ^
490      * bytes4(keccak256("isApprovedForAll(address,address)"));
491      */
492     bytes4 private constant INTERFACE_SIGNATURE_ERC1155 = 0xd9b67a26;
493 
494     /**
495      * @notice Query if a contract implements an interface
496      * @param _interfaceID  The interface identifier, as specified in ERC-165
497      * @return `true` if the contract implements `_interfaceID` and
498      */
499     function supportsInterface(bytes4 _interfaceID)
500         external
501         view
502         returns (bool)
503     {
504         if (
505             _interfaceID == INTERFACE_SIGNATURE_ERC165 ||
506             _interfaceID == INTERFACE_SIGNATURE_ERC1155
507         ) {
508             return true;
509         }
510         return false;
511     }
512 }
513 
514 /**
515  * @dev Multi-Fungible Tokens with minting and burning methods. These methods assume
516  *      a parent contract to be executed as they are `internal` functions
517  */
518 contract ERC1155MintBurn is ERC1155 {
519     /****************************************|
520   |            Minting Functions           |
521   |_______________________________________*/
522 
523     /**
524      * @notice Mint _amount of tokens of a given id
525      * @param _to      The address to mint tokens to
526      * @param _id      Token id to mint
527      * @param _amount  The amount to be minted
528      * @param _data    Data to pass if receiver is contract
529      */
530     function _mint(
531         address _to,
532         uint256 _id,
533         uint256 _amount,
534         bytes memory _data
535     ) internal {
536         // Add _amount
537         balances[_to][_id] = balances[_to][_id].add(_amount);
538 
539         // Emit event
540         emit TransferSingle(msg.sender, address(0x0), _to, _id, _amount);
541 
542         // Calling onReceive method if recipient is contract
543         _callonERC1155Received(address(0x0), _to, _id, _amount, _data);
544     }
545 
546     /**
547      * @notice Mint tokens for each ids in _ids
548      * @param _to       The address to mint tokens to
549      * @param _ids      Array of ids to mint
550      * @param _amounts  Array of amount of tokens to mint per id
551      * @param _data    Data to pass if receiver is contract
552      */
553     function _batchMint(
554         address _to,
555         uint256[] memory _ids,
556         uint256[] memory _amounts,
557         bytes memory _data
558     ) internal {
559         require(
560             _ids.length == _amounts.length,
561             "ERC1155MintBurn#batchMint: INVALID_ARRAYS_LENGTH"
562         );
563 
564         // Number of mints to execute
565         uint256 nMint = _ids.length;
566 
567         // Executing all minting
568         for (uint256 i = 0; i < nMint; i++) {
569             // Update storage balance
570             balances[_to][_ids[i]] = balances[_to][_ids[i]].add(_amounts[i]);
571         }
572 
573         // Emit batch mint event
574         emit TransferBatch(msg.sender, address(0x0), _to, _ids, _amounts);
575 
576         // Calling onReceive method if recipient is contract
577         _callonERC1155BatchReceived(address(0x0), _to, _ids, _amounts, _data);
578     }
579 
580     /****************************************|
581   |            Burning Functions           |
582   |_______________________________________*/
583 
584     /**
585      * @notice Burn _amount of tokens of a given token id
586      * @param _from    The address to burn tokens from
587      * @param _id      Token id to burn
588      * @param _amount  The amount to be burned
589      */
590     function _burn(
591         address _from,
592         uint256 _id,
593         uint256 _amount
594     ) internal {
595         //Substract _amount
596         balances[_from][_id] = balances[_from][_id].sub(_amount);
597 
598         // Emit event
599         emit TransferSingle(msg.sender, _from, address(0x0), _id, _amount);
600     }
601 
602     /**
603      * @notice Burn tokens of given token id for each (_ids[i], _amounts[i]) pair
604      * @param _from     The address to burn tokens from
605      * @param _ids      Array of token ids to burn
606      * @param _amounts  Array of the amount to be burned
607      */
608     function _batchBurn(
609         address _from,
610         uint256[] memory _ids,
611         uint256[] memory _amounts
612     ) internal {
613         require(
614             _ids.length == _amounts.length,
615             "ERC1155MintBurn#batchBurn: INVALID_ARRAYS_LENGTH"
616         );
617 
618         // Number of mints to execute
619         uint256 nBurn = _ids.length;
620 
621         // Executing all minting
622         for (uint256 i = 0; i < nBurn; i++) {
623             // Update storage balance
624             balances[_from][_ids[i]] = balances[_from][_ids[i]].sub(
625                 _amounts[i]
626             );
627         }
628 
629         // Emit batch mint event
630         emit TransferBatch(msg.sender, _from, address(0x0), _ids, _amounts);
631     }
632 }
633 
634 /**
635  * @notice Contract that handles metadata related methods.
636  * @dev Methods assume a deterministic generation of URI based on token IDs.
637  *      Methods also assume that URI uses hex representation of token IDs.
638  */
639 contract ERC1155Metadata {
640     // URI's default URI prefix
641     string internal baseMetadataURI;
642     event URI(string _uri, uint256 indexed _id);
643 
644     /***********************************|
645   |     Metadata Public Function s    |
646   |__________________________________*/
647 
648     /**
649      * @notice A distinct Uniform Resource Identifier (URI) for a given token.
650      * @dev URIs are defined in RFC 3986.
651      *      URIs are assumed to be deterministically generated based on token ID
652      *      Token IDs are assumed to be represented in their hex format in URIs
653      * @return URI string
654      */
655     function uri(uint256 _id) public view returns (string memory) {
656         return
657             string(abi.encodePacked(baseMetadataURI, _uint2str(_id), ".json"));
658     }
659 
660     /***********************************|
661   |    Metadata Internal Functions    |
662   |__________________________________*/
663 
664     /**
665      * @notice Will emit default URI log event for corresponding token _id
666      * @param _tokenIDs Array of IDs of tokens to log default URI
667      */
668     function _logURIs(uint256[] memory _tokenIDs) internal {
669         string memory baseURL = baseMetadataURI;
670         string memory tokenURI;
671 
672         for (uint256 i = 0; i < _tokenIDs.length; i++) {
673             tokenURI = string(
674                 abi.encodePacked(baseURL, _uint2str(_tokenIDs[i]), ".json")
675             );
676             emit URI(tokenURI, _tokenIDs[i]);
677         }
678     }
679 
680     /**
681      * @notice Will emit a specific URI log event for corresponding token
682      * @param _tokenIDs IDs of the token corresponding to the _uris logged
683      * @param _URIs    The URIs of the specified _tokenIDs
684      */
685     function _logURIs(uint256[] memory _tokenIDs, string[] memory _URIs)
686         internal
687     {
688         require(
689             _tokenIDs.length == _URIs.length,
690             "ERC1155Metadata#_logURIs: INVALID_ARRAYS_LENGTH"
691         );
692         for (uint256 i = 0; i < _tokenIDs.length; i++) {
693             emit URI(_URIs[i], _tokenIDs[i]);
694         }
695     }
696 
697     /**
698      * @notice Will update the base URL of token's URI
699      * @param _newBaseMetadataURI New base URL of token's URI
700      */
701     function _setBaseMetadataURI(string memory _newBaseMetadataURI) internal {
702         baseMetadataURI = _newBaseMetadataURI;
703     }
704 
705     /***********************************|
706   |    Utility Internal Functions     |
707   |__________________________________*/
708 
709     /**
710      * @notice Convert uint256 to string
711      * @param _i Unsigned integer to convert to string
712      */
713     function _uint2str(uint256 _i)
714         internal
715         pure
716         returns (string memory _uintAsString)
717     {
718         if (_i == 0) {
719             return "0";
720         }
721 
722         uint256 j = _i;
723         uint256 ii = _i;
724         uint256 len;
725 
726         // Get number of bytes
727         while (j != 0) {
728             len++;
729             j /= 10;
730         }
731 
732         bytes memory bstr = new bytes(len);
733         uint256 k = len - 1;
734 
735         // Get each individual ASCII
736         while (ii != 0) {
737             bstr[k--] = bytes1(uint8(48 + (ii % 10)));
738             ii /= 10;
739         }
740 
741         // Convert to string
742         return string(bstr);
743     }
744 }
745 
746 /*
747  * @dev Provides information about the current execution context, including the
748  * sender of the transaction and its data. While these are generally available
749  * via msg.sender and msg.data, they should not be accessed in such a direct
750  * manner, since when dealing with GSN meta-transactions the account sending and
751  * paying for execution may not be the actual sender (as far as an application
752  * is concerned).
753  *
754  * This contract is only required for intermediate, library-like contracts.
755  */
756 contract Context {
757     // Empty internal constructor, to prevent people from mistakenly deploying
758     // an instance of this contract, which should be used via inheritance.
759     constructor() internal {}
760 
761     // solhint-disable-previous-line no-empty-blocks
762 
763     function _msgSender() internal view returns (address payable) {
764         return msg.sender;
765     }
766 
767     function _msgData() internal view returns (bytes memory) {
768         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
769         return msg.data;
770     }
771 }
772 
773 /**
774  * @dev Contract module which provides a basic access control mechanism, where
775  * there is an account (an owner) that can be granted exclusive access to
776  * specific functions.
777  *
778  * This module is used through inheritance. It will make available the modifier
779  * `onlyOwner`, which can be applied to your functions to restrict their use to
780  * the owner.
781  */
782 contract Ownable is Context {
783     address private _owner;
784 
785     event OwnershipTransferred(
786         address indexed previousOwner,
787         address indexed newOwner
788     );
789 
790     /**
791      * @dev Initializes the contract setting the deployer as the initial owner.
792      */
793     constructor() internal {
794         address msgSender = _msgSender();
795         _owner = msgSender;
796         emit OwnershipTransferred(address(0), msgSender);
797     }
798 
799     /**
800      * @dev Returns the address of the current owner.
801      */
802     function owner() public view returns (address) {
803         return _owner;
804     }
805 
806     /**
807      * @dev Throws if called by any account other than the owner.
808      */
809     modifier onlyOwner() {
810         require(isOwner(), "Ownable: caller is not the owner");
811         _;
812     }
813 
814     /**
815      * @dev Returns true if the caller is the current owner.
816      */
817     function isOwner() public view returns (bool) {
818         return _msgSender() == _owner;
819     }
820 
821     /**
822      * @dev Leaves the contract without owner. It will not be possible to call
823      * `onlyOwner` functions anymore. Can only be called by the current owner.
824      *
825      * NOTE: Renouncing ownership will leave the contract without an owner,
826      * thereby removing any functionality that is only available to the owner.
827      */
828     function renounceOwnership() public onlyOwner {
829         emit OwnershipTransferred(_owner, address(0));
830         _owner = address(0);
831     }
832 
833     /**
834      * @dev Transfers ownership of the contract to a new account (`newOwner`).
835      * Can only be called by the current owner.
836      */
837     function transferOwnership(address newOwner) public onlyOwner {
838         _transferOwnership(newOwner);
839     }
840 
841     /**
842      * @dev Transfers ownership of the contract to a new account (`newOwner`).
843      */
844     function _transferOwnership(address newOwner) internal {
845         require(
846             newOwner != address(0),
847             "Ownable: new owner is the zero address"
848         );
849         emit OwnershipTransferred(_owner, newOwner);
850         _owner = newOwner;
851     }
852 }
853 
854 contract OwnableDelegateProxy {}
855 
856 contract ProxyRegistry {
857     mapping(address => OwnableDelegateProxy) public proxies;
858 }
859 
860 library Strings {
861     // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
862     function strConcat(
863         string memory _a,
864         string memory _b,
865         string memory _c,
866         string memory _d,
867         string memory _e
868     ) internal pure returns (string memory) {
869         bytes memory _ba = bytes(_a);
870         bytes memory _bb = bytes(_b);
871         bytes memory _bc = bytes(_c);
872         bytes memory _bd = bytes(_d);
873         bytes memory _be = bytes(_e);
874         string memory abcde = new string(
875             _ba.length + _bb.length + _bc.length + _bd.length + _be.length
876         );
877         bytes memory babcde = bytes(abcde);
878         uint256 k = 0;
879         for (uint256 i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
880         for (uint256 i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
881         for (uint256 i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
882         for (uint256 i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
883         for (uint256 i = 0; i < _be.length; i++) babcde[k++] = _be[i];
884         return string(babcde);
885     }
886 
887     function strConcat(
888         string memory _a,
889         string memory _b,
890         string memory _c,
891         string memory _d
892     ) internal pure returns (string memory) {
893         return strConcat(_a, _b, _c, _d, "");
894     }
895 
896     function strConcat(
897         string memory _a,
898         string memory _b,
899         string memory _c
900     ) internal pure returns (string memory) {
901         return strConcat(_a, _b, _c, "", "");
902     }
903 
904     function strConcat(string memory _a, string memory _b)
905         internal
906         pure
907         returns (string memory)
908     {
909         return strConcat(_a, _b, "", "", "");
910     }
911 
912     function uint2str(uint256 _i)
913         internal
914         pure
915         returns (string memory _uintAsString)
916     {
917         if (_i == 0) {
918             return "0";
919         }
920         uint256 j = _i;
921         uint256 len;
922         while (j != 0) {
923             len++;
924             j /= 10;
925         }
926         bytes memory bstr = new bytes(len);
927         uint256 k = len - 1;
928         while (_i != 0) {
929             bstr[k--] = bytes1(uint8(48 + (_i % 10)));
930             _i /= 10;
931         }
932         return string(bstr);
933     }
934 }
935 
936 /**
937  * @title Roles
938  * @dev Library for managing addresses assigned to a Role.
939  */
940 library Roles {
941     struct Role {
942         mapping(address => bool) bearer;
943     }
944 
945     /**
946      * @dev Give an account access to this role.
947      */
948     function add(Role storage role, address account) internal {
949         require(!has(role, account), "Roles: account already has role");
950         role.bearer[account] = true;
951     }
952 
953     /**
954      * @dev Remove an account's access to this role.
955      */
956     function remove(Role storage role, address account) internal {
957         require(has(role, account), "Roles: account does not have role");
958         role.bearer[account] = false;
959     }
960 
961     /**
962      * @dev Check if an account has this role.
963      * @return bool
964      */
965     function has(Role storage role, address account)
966         internal
967         view
968         returns (bool)
969     {
970         require(account != address(0), "Roles: account is the zero address");
971         return role.bearer[account];
972     }
973 }
974 
975 contract MinterRole is Context {
976     using Roles for Roles.Role;
977 
978     event MinterAdded(address indexed account);
979     event MinterRemoved(address indexed account);
980 
981     Roles.Role private _minters;
982 
983     constructor() internal {
984         _addMinter(_msgSender());
985     }
986 
987     modifier onlyMinter() {
988         require(
989             isMinter(_msgSender()),
990             "MinterRole: caller does not have the Minter role"
991         );
992         _;
993     }
994 
995     function isMinter(address account) public view returns (bool) {
996         return _minters.has(account);
997     }
998 
999     function addMinter(address account) public onlyMinter {
1000         _addMinter(account);
1001     }
1002 
1003     function renounceMinter() public {
1004         _removeMinter(_msgSender());
1005     }
1006 
1007     function _addMinter(address account) internal {
1008         _minters.add(account);
1009         emit MinterAdded(account);
1010     }
1011 
1012     function _removeMinter(address account) internal {
1013         _minters.remove(account);
1014         emit MinterRemoved(account);
1015     }
1016 }
1017 
1018 /**
1019  * @title WhitelistAdminRole
1020  * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
1021  */
1022 contract WhitelistAdminRole is Context {
1023     using Roles for Roles.Role;
1024 
1025     event WhitelistAdminAdded(address indexed account);
1026     event WhitelistAdminRemoved(address indexed account);
1027 
1028     Roles.Role private _whitelistAdmins;
1029 
1030     constructor() internal {
1031         _addWhitelistAdmin(_msgSender());
1032     }
1033 
1034     modifier onlyWhitelistAdmin() {
1035         require(
1036             isWhitelistAdmin(_msgSender()),
1037             "WhitelistAdminRole: caller does not have the WhitelistAdmin role"
1038         );
1039         _;
1040     }
1041 
1042     function isWhitelistAdmin(address account) public view returns (bool) {
1043         return _whitelistAdmins.has(account);
1044     }
1045 
1046     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
1047         _addWhitelistAdmin(account);
1048     }
1049 
1050     function renounceWhitelistAdmin() public {
1051         _removeWhitelistAdmin(_msgSender());
1052     }
1053 
1054     function _addWhitelistAdmin(address account) internal {
1055         _whitelistAdmins.add(account);
1056         emit WhitelistAdminAdded(account);
1057     }
1058 
1059     function _removeWhitelistAdmin(address account) internal {
1060         _whitelistAdmins.remove(account);
1061         emit WhitelistAdminRemoved(account);
1062     }
1063 }
1064 
1065 /**
1066  * @title ERC1155Tradable
1067  * ERC1155Tradable - ERC1155 contract that whitelists an operator address, 
1068  * has create and mint functionality, and supports useful standards from OpenZeppelin,
1069   like _exists(), name(), symbol(), and totalSupply()
1070  */
1071 contract ERC1155Tradable is
1072     ERC1155,
1073     ERC1155MintBurn,
1074     ERC1155Metadata,
1075     Ownable,
1076     MinterRole,
1077     WhitelistAdminRole
1078 {
1079     using Strings for string;
1080 
1081     address proxyRegistryAddress;
1082     uint256 private _currentTokenID = 0;
1083     mapping(uint256 => address) public creators;
1084     mapping(uint256 => uint256) public tokenSupply;
1085     mapping(uint256 => uint256) public tokenMaxSupply;
1086     // Contract name
1087     string public name;
1088     // Contract symbol
1089     string public symbol;
1090 
1091     constructor(
1092         string memory _name,
1093         string memory _symbol,
1094         address _proxyRegistryAddress
1095     ) public {
1096         name = _name;
1097         symbol = _symbol;
1098         proxyRegistryAddress = _proxyRegistryAddress;
1099     }
1100 
1101     function removeWhitelistAdmin(address account) public onlyOwner {
1102         _removeWhitelistAdmin(account);
1103     }
1104 
1105     function removeMinter(address account) public onlyOwner {
1106         _removeMinter(account);
1107     }
1108 
1109     function uri(uint256 _id) public view returns (string memory) {
1110         require(_exists(_id), "ERC721Tradable#uri: NONEXISTENT_TOKEN");
1111         return Strings.strConcat(baseMetadataURI, Strings.uint2str(_id));
1112     }
1113 
1114     /**
1115      * @dev Returns the total quantity for a token ID
1116      * @param _id uint256 ID of the token to query
1117      * @return amount of token in existence
1118      */
1119     function totalSupply(uint256 _id) public view returns (uint256) {
1120         return tokenSupply[_id];
1121     }
1122 
1123     /**
1124      * @dev Returns the max quantity for a token ID
1125      * @param _id uint256 ID of the token to query
1126      * @return amount of token in existence
1127      */
1128     function maxSupply(uint256 _id) public view returns (uint256) {
1129         return tokenMaxSupply[_id];
1130     }
1131 
1132     /**
1133      * @dev Will update the base URL of token's URI
1134      * @param _newBaseMetadataURI New base URL of token's URI
1135      */
1136     function setBaseMetadataURI(string memory _newBaseMetadataURI)
1137         public
1138         onlyWhitelistAdmin
1139     {
1140         _setBaseMetadataURI(_newBaseMetadataURI);
1141     }
1142 
1143     /**
1144      * @dev Creates a new token type and assigns _initialSupply to an address
1145      * @param _maxSupply max supply allowed
1146      * @param _initialSupply Optional amount to supply the first owner
1147      * @param _uri Optional URI for this token type
1148      * @param _data Optional data to pass if receiver is contract
1149      * @return The newly created token ID
1150      */
1151     function create(
1152         uint256 _maxSupply,
1153         uint256 _initialSupply,
1154         string calldata _uri,
1155         bytes calldata _data
1156     ) external onlyWhitelistAdmin returns (uint256 tokenId) {
1157         require(
1158             _initialSupply <= _maxSupply,
1159             "Initial supply cannot be more than max supply"
1160         );
1161         uint256 _id = _getNextTokenID();
1162         _incrementTokenTypeId();
1163         creators[_id] = msg.sender;
1164 
1165         if (bytes(_uri).length > 0) {
1166             emit URI(_uri, _id);
1167         }
1168 
1169         if (_initialSupply != 0) _mint(msg.sender, _id, _initialSupply, _data);
1170         tokenSupply[_id] = _initialSupply;
1171         tokenMaxSupply[_id] = _maxSupply;
1172         return _id;
1173     }
1174 
1175     /**
1176      * @dev Mints some amount of tokens to an address
1177      * @param _to          Address of the future owner of the token
1178      * @param _id          Token ID to mint
1179      * @param _quantity    Amount of tokens to mint
1180      * @param _data        Data to pass if receiver is contract
1181      */
1182     function mint(
1183         address _to,
1184         uint256 _id,
1185         uint256 _quantity,
1186         bytes memory _data
1187     ) public onlyMinter {
1188         uint256 tokenId = _id;
1189         require(
1190             tokenSupply[tokenId] < tokenMaxSupply[tokenId],
1191             "Max supply reached"
1192         );
1193         _mint(_to, _id, _quantity, _data);
1194         tokenSupply[_id] = tokenSupply[_id].add(_quantity);
1195     }
1196 
1197     /**
1198      * @dev Mints some amount of multiple tokens to an addresse
1199      * @param _to          Address of the future owner of the token
1200      * @param _ids          Token ID to mint
1201      * @param _amounts    Amount of tokens to mint
1202      * @param _data        Data to pass if receiver is contract
1203      */
1204     function batchMint(
1205         address _to,
1206         uint256[] memory _ids,
1207         uint256[] memory _amounts,
1208         bytes memory _data
1209     ) public onlyMinter {
1210         require(
1211             _ids.length == _amounts.length,
1212             "ERC1155MintBurn#batchMint: INVALID_ARRAYS_LENGTH"
1213         );
1214 
1215         uint256 nLength = _ids.length;
1216         for (uint256 i = 0; i < nLength; i++) {
1217             require(
1218                 tokenSupply[_ids[i]] < tokenMaxSupply[_ids[i]],
1219                 "Max supply reached"
1220             );
1221             tokenSupply[_ids[i]] = tokenSupply[_ids[i]].add(_amounts[i]);
1222         }
1223         _batchMint(_to, _ids, _amounts, _data);
1224     }
1225 
1226     /**
1227      * @dev Burns some amount of tokens from an address
1228      * @param _from          Address of the future owner of the token
1229      * @param _id          Token ID to mint
1230      * @param _quantity    Amount of tokens to mint
1231      */
1232     function burn(
1233         address _from,
1234         uint256 _id,
1235         uint256 _quantity
1236     ) public {
1237         uint256 tokenId = _id;
1238         require(
1239             balances[_from][tokenId] >= _quantity,
1240             "Exceed the amount of balance"
1241         );
1242         _burn(_from, tokenId, _quantity);
1243         tokenMaxSupply[tokenId] = tokenMaxSupply[tokenId].sub(_quantity);
1244         tokenSupply[tokenId] = tokenSupply[tokenId].sub(_quantity);
1245     }
1246 
1247     /**
1248      * @dev Burns some amount of multiple tokens from an addresse
1249      * @param _from          Address of the future owner of the token
1250      * @param _ids          Token ID to mint
1251      * @param _amounts    Amount of tokens to mint
1252      */
1253     function batchBurn(
1254         address _from,
1255         uint256[] memory _ids,
1256         uint256[] memory _amounts
1257     ) public {
1258         require(
1259             _ids.length == _amounts.length,
1260             "ERC1155MintBurn#batchBurn: INVALID_ARRAYS_LENGTH"
1261         );
1262 
1263         uint256 nLength = _ids.length;
1264         for (uint256 i = 0; i < nLength; i++) {
1265             require(
1266                 balances[_from][_ids[i]] >= _amounts[i],
1267                 "Exceed the amount of balance"
1268             );
1269             tokenSupply[_ids[i]] = tokenSupply[_ids[i]].sub(_amounts[i]);
1270             tokenMaxSupply[_ids[i]] = tokenMaxSupply[_ids[i]].sub(_amounts[i]);
1271         }
1272         _batchBurn(_from, _ids, _amounts);
1273     }
1274 
1275     /**
1276      * Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-free listings.
1277      */
1278     function isApprovedForAll(address _owner, address _operator)
1279         public
1280         view
1281         returns (bool isOperator)
1282     {
1283         // Whitelist OpenSea proxy contract for easy trading.
1284         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1285         if (address(proxyRegistry.proxies(_owner)) == _operator) {
1286             return true;
1287         }
1288         return ERC1155.isApprovedForAll(_owner, _operator);
1289     }
1290 
1291     /**
1292      * @dev Returns whether the specified token exists by checking to see if it has a creator
1293      * @param _id uint256 ID of the token to query the existence of
1294      * @return bool whether the token exists
1295      */
1296     function _exists(uint256 _id) internal view returns (bool) {
1297         return creators[_id] != address(0);
1298     }
1299 
1300     /**
1301      * @dev calculates the next token ID based on value of _currentTokenID
1302      * @return uint256 for the next token ID
1303      */
1304     function _getNextTokenID() private view returns (uint256) {
1305         return _currentTokenID.add(1);
1306     }
1307 
1308     /**
1309      * @dev increments the value of _currentTokenID
1310      */
1311     function _incrementTokenTypeId() private {
1312         _currentTokenID++;
1313     }
1314 }
1315 
1316 contract PolkaPet is ERC1155Tradable {
1317     constructor(address _proxyRegistryAddress)
1318         public
1319         ERC1155Tradable("PolkaPets Base Set", "PPBS", _proxyRegistryAddress)
1320     {
1321         _setBaseMetadataURI("https://api.ppw.digital/api/item/");
1322     }
1323 
1324     function contractURI() public pure returns (string memory) {
1325         return "https://api.ppw.digital/api/contract";
1326     }
1327 }