1 pragma solidity ^0.5.15;
2 
3 /*
4 ids:[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18]
5 quantities:[20000,10000,5000,3000,1500,1000,3000,2000,1000,500,200,100,3000,2000,1000,500,200,100]
6 */
7 
8 library Address {
9 
10   /**
11    * Returns whether the target address is a contract
12    * @dev This function will return false if invoked during the constructor of a contract,
13    * as the code is not actually created until after the constructor finishes.
14    * @param account address of the account to check
15    * @return whether the target address is a contract
16    */
17   function isContract(address account) internal view returns (bool) {
18     bytes32 codehash;
19     bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
20 
21     // XXX Currently there is no better way to check if there is a contract in an address
22     // than to check the size of the code at that address.
23     // See https://ethereum.stackexchange.com/a/14016/36603
24     // for more details about how this works.
25     // TODO Check this again before the Serenity release, because all addresses will be
26     // contracts then.
27     assembly { codehash := extcodehash(account) }
28     return (codehash != 0x0 && codehash != accountHash);
29   }
30 
31 }
32 
33 library SafeMath {
34 
35   /**
36    * @dev Multiplies two unsigned integers, reverts on overflow.
37    */
38   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
39     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
40     // benefit is lost if 'b' is also tested.
41     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
42     if (a == 0) {
43       return 0;
44     }
45 
46     uint256 c = a * b;
47     require(c / a == b, "SafeMath#mul: OVERFLOW");
48 
49     return c;
50   }
51 
52   /**
53    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
54    */
55   function div(uint256 a, uint256 b) internal pure returns (uint256) {
56     // Solidity only automatically asserts when dividing by 0
57     require(b > 0, "SafeMath#div: DIVISION_BY_ZERO");
58     uint256 c = a / b;
59     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
60 
61     return c;
62   }
63 
64   /**
65    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
66    */
67   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
68     require(b <= a, "SafeMath#sub: UNDERFLOW");
69     uint256 c = a - b;
70 
71     return c;
72   }
73 
74   /**
75    * @dev Adds two unsigned integers, reverts on overflow.
76    */
77   function add(uint256 a, uint256 b) internal pure returns (uint256) {
78     uint256 c = a + b;
79     require(c >= a, "SafeMath#add: OVERFLOW");
80 
81     return c; 
82   }
83 
84   /**
85    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
86    * reverts when dividing by zero.
87    */
88   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
89     require(b != 0, "SafeMath#mod: DIVISION_BY_ZERO");
90     return a % b;
91   }
92 
93 }
94 
95 contract ERC1155Metadata {
96 
97   // URI's default URI prefix
98   string internal baseMetadataURI;
99   event URI(string _uri, uint256 indexed _id);
100 
101 
102   /***********************************|
103   |     Metadata Public Function s    |
104   |__________________________________*/
105 
106   /**
107    * @notice A distinct Uniform Resource Identifier (URI) for a given token.
108    * @dev URIs are defined in RFC 3986.
109    *      URIs are assumed to be deterministically generated based on token ID
110    *      Token IDs are assumed to be represented in their hex format in URIs
111    * @return URI string
112    */
113   function uri(uint256 _id) public view returns (string memory) {
114     return string(abi.encodePacked(baseMetadataURI, _uint2str(_id), ".json"));
115   }
116 
117 
118   /***********************************|
119   |    Metadata Internal Functions    |
120   |__________________________________*/
121 
122   /**
123    * @notice Will emit default URI log event for corresponding token _id
124    * @param _tokenIDs Array of IDs of tokens to log default URI
125    */
126   function _logURIs(uint256[] memory _tokenIDs) internal {
127     string memory baseURL = baseMetadataURI;
128     string memory tokenURI;
129 
130     for (uint256 i = 0; i < _tokenIDs.length; i++) {
131       tokenURI = string(abi.encodePacked(baseURL, _uint2str(_tokenIDs[i]), ".json"));
132       emit URI(tokenURI, _tokenIDs[i]);
133     }
134   }
135 
136   /**
137    * @notice Will emit a specific URI log event for corresponding token
138    * @param _tokenIDs IDs of the token corresponding to the _uris logged
139    * @param _URIs    The URIs of the specified _tokenIDs
140    */
141   function _logURIs(uint256[] memory _tokenIDs, string[] memory _URIs) internal {
142     require(_tokenIDs.length == _URIs.length, "ERC1155Metadata#_logURIs: INVALID_ARRAYS_LENGTH");
143     for (uint256 i = 0; i < _tokenIDs.length; i++) {
144       emit URI(_URIs[i], _tokenIDs[i]);
145     }
146   }
147 
148   /**
149    * @notice Will update the base URL of token's URI
150    * @param _newBaseMetadataURI New base URL of token's URI
151    */
152   function _setBaseMetadataURI(string memory _newBaseMetadataURI) internal {
153     baseMetadataURI = _newBaseMetadataURI;
154   }
155 
156 
157   /***********************************|
158   |    Utility Internal Functions     |
159   |__________________________________*/
160 
161   /**
162    * @notice Convert uint256 to string
163    * @param _i Unsigned integer to convert to string
164    */
165   function _uint2str(uint256 _i) internal pure returns (string memory _uintAsString) {
166     if (_i == 0) {
167       return "0";
168     }
169 
170     uint256 j = _i;
171     uint256 ii = _i;
172     uint256 len;
173 
174     // Get number of bytes
175     while (j != 0) {
176       len++;
177       j /= 10;
178     }
179 
180     bytes memory bstr = new bytes(len);
181     uint256 k = len - 1;
182 
183     // Get each individual ASCII
184     while (ii != 0) {
185       bstr[k--] = byte(uint8(48 + ii % 10));
186       ii /= 10;
187     }
188 
189     // Convert to string
190     return string(bstr);
191   }
192 
193 }
194 
195 interface IERC165 {
196 
197     /**
198      * @notice Query if a contract implements an interface
199      * @dev Interface identification is specified in ERC-165. This function
200      * uses less than 30,000 gas
201      * @param _interfaceId The interface identifier, as specified in ERC-165
202      */
203     function supportsInterface(bytes4 _interfaceId)
204     external
205     view
206     returns (bool);
207 }
208 
209 interface IERC1155TokenReceiver {
210 
211   /**
212    * @notice Handle the receipt of a single ERC1155 token type
213    * @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeTransferFrom` after the balance has been updated
214    * This function MAY throw to revert and reject the transfer
215    * Return of other amount than the magic value MUST result in the transaction being reverted
216    * Note: The token contract address is always the message sender
217    * @param _operator  The address which called the `safeTransferFrom` function
218    * @param _from      The address which previously owned the token
219    * @param _id        The id of the token being transferred
220    * @param _amount    The amount of tokens being transferred
221    * @param _data      Additional data with no specified format
222    * @return           `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
223    */
224   function onERC1155Received(address _operator, address _from, uint256 _id, uint256 _amount, bytes calldata _data) external returns(bytes4);
225 
226   /**
227    * @notice Handle the receipt of multiple ERC1155 token types
228    * @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeBatchTransferFrom` after the balances have been updated
229    * This function MAY throw to revert and reject the transfer
230    * Return of other amount than the magic value WILL result in the transaction being reverted
231    * Note: The token contract address is always the message sender
232    * @param _operator  The address which called the `safeBatchTransferFrom` function
233    * @param _from      The address which previously owned the token
234    * @param _ids       An array containing ids of each token being transferred
235    * @param _amounts   An array containing amounts of each token being transferred
236    * @param _data      Additional data with no specified format
237    * @return           `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
238    */
239   function onERC1155BatchReceived(address _operator, address _from, uint256[] calldata _ids, uint256[] calldata _amounts, bytes calldata _data) external returns(bytes4);
240 
241   /**
242    * @notice Indicates whether a contract implements the `ERC1155TokenReceiver` functions and so can accept ERC1155 token types.
243    * @param  interfaceID The ERC-165 interface ID that is queried for support.s
244    * @dev This function MUST return true if it implements the ERC1155TokenReceiver interface and ERC-165 interface.
245    *      This function MUST NOT consume more than 5,000 gas.
246    * @return Wheter ERC-165 or ERC1155TokenReceiver interfaces are supported.
247    */
248   function supportsInterface(bytes4 interfaceID) external view returns (bool);
249 
250 }
251 
252 
253 contract ERC1155 is IERC165 {
254   using SafeMath for uint256;
255   using Address for address;
256 
257 
258   /***********************************|
259   |        Variables and Events       |
260   |__________________________________*/
261 
262   // onReceive function signatures
263   bytes4 constant internal ERC1155_RECEIVED_VALUE = 0xf23a6e61;
264   bytes4 constant internal ERC1155_BATCH_RECEIVED_VALUE = 0xbc197c81;
265 
266   // Objects balances
267   mapping (address => mapping(uint256 => uint256)) internal balances;
268 
269   // Operator Functions
270   mapping (address => mapping(address => bool)) internal operators;
271 
272   // Events
273   event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _amount);
274   event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _amounts);
275   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
276   event URI(string _uri, uint256 indexed _id);
277 
278 
279   /***********************************|
280   |     Public Transfer Functions     |
281   |__________________________________*/
282 
283   /**
284    * @notice Transfers amount amount of an _id from the _from address to the _to address specified
285    * @param _from    Source address
286    * @param _to      Target address
287    * @param _id      ID of the token type
288    * @param _amount  Transfered amount
289    * @param _data    Additional data with no specified format, sent in call to `_to`
290    */
291   function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount, bytes memory _data)
292     public
293   {
294     require((msg.sender == _from) || isApprovedForAll(_from, msg.sender), "ERC1155#safeTransferFrom: INVALID_OPERATOR");
295     require(_to != address(0),"ERC1155#safeTransferFrom: INVALID_RECIPIENT");
296     // require(_amount >= balances[_from][_id]) is not necessary since checked with safemath operations
297 
298     _safeTransferFrom(_from, _to, _id, _amount);
299     _callonERC1155Received(_from, _to, _id, _amount, _data);
300   }
301 
302   /**
303    * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
304    * @param _from     Source addresses
305    * @param _to       Target addresses
306    * @param _ids      IDs of each token type
307    * @param _amounts  Transfer amounts per token type
308    * @param _data     Additional data with no specified format, sent in call to `_to`
309    */
310   function safeBatchTransferFrom(address _from, address _to, uint256[] memory _ids, uint256[] memory _amounts, bytes memory _data)
311     public
312   {
313     // Requirements
314     require((msg.sender == _from) || isApprovedForAll(_from, msg.sender), "ERC1155#safeBatchTransferFrom: INVALID_OPERATOR");
315     require(_to != address(0), "ERC1155#safeBatchTransferFrom: INVALID_RECIPIENT");
316 
317     _safeBatchTransferFrom(_from, _to, _ids, _amounts);
318     _callonERC1155BatchReceived(_from, _to, _ids, _amounts, _data);
319   }
320 
321 
322   /***********************************|
323   |    Internal Transfer Functions    |
324   |__________________________________*/
325 
326   /**
327    * @notice Transfers amount amount of an _id from the _from address to the _to address specified
328    * @param _from    Source address
329    * @param _to      Target address
330    * @param _id      ID of the token type
331    * @param _amount  Transfered amount
332    */
333   function _safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount)
334     internal
335   {
336     // Update balances
337     balances[_from][_id] = balances[_from][_id].sub(_amount); // Subtract amount
338     balances[_to][_id] = balances[_to][_id].add(_amount);     // Add amount
339 
340     // Emit event
341     emit TransferSingle(msg.sender, _from, _to, _id, _amount);
342   }
343 
344   /**
345    * @notice Verifies if receiver is contract and if so, calls (_to).onERC1155Received(...)
346    */
347   function _callonERC1155Received(address _from, address _to, uint256 _id, uint256 _amount, bytes memory _data)
348     internal
349   {
350     // Check if recipient is contract
351     if (_to.isContract()) {
352       bytes4 retval = IERC1155TokenReceiver(_to).onERC1155Received(msg.sender, _from, _id, _amount, _data);
353       require(retval == ERC1155_RECEIVED_VALUE, "ERC1155#_callonERC1155Received: INVALID_ON_RECEIVE_MESSAGE");
354     }
355   }
356 
357   /**
358    * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
359    * @param _from     Source addresses
360    * @param _to       Target addresses
361    * @param _ids      IDs of each token type
362    * @param _amounts  Transfer amounts per token type
363    */
364   function _safeBatchTransferFrom(address _from, address _to, uint256[] memory _ids, uint256[] memory _amounts)
365     internal
366   {
367     require(_ids.length == _amounts.length, "ERC1155#_safeBatchTransferFrom: INVALID_ARRAYS_LENGTH");
368 
369     // Number of transfer to execute
370     uint256 nTransfer = _ids.length;
371 
372     // Executing all transfers
373     for (uint256 i = 0; i < nTransfer; i++) {
374       // Update storage balance of previous bin
375       balances[_from][_ids[i]] = balances[_from][_ids[i]].sub(_amounts[i]);
376       balances[_to][_ids[i]] = balances[_to][_ids[i]].add(_amounts[i]);
377     }
378 
379     // Emit event
380     emit TransferBatch(msg.sender, _from, _to, _ids, _amounts);
381   }
382 
383   /**
384    * @notice Verifies if receiver is contract and if so, calls (_to).onERC1155BatchReceived(...)
385    */
386   function _callonERC1155BatchReceived(address _from, address _to, uint256[] memory _ids, uint256[] memory _amounts, bytes memory _data)
387     internal
388   {
389     // Pass data if recipient is contract
390     if (_to.isContract()) {
391       bytes4 retval = IERC1155TokenReceiver(_to).onERC1155BatchReceived(msg.sender, _from, _ids, _amounts, _data);
392       require(retval == ERC1155_BATCH_RECEIVED_VALUE, "ERC1155#_callonERC1155BatchReceived: INVALID_ON_RECEIVE_MESSAGE");
393     }
394   }
395 
396 
397   /***********************************|
398   |         Operator Functions        |
399   |__________________________________*/
400 
401   /**
402    * @notice Enable or disable approval for a third party ("operator") to manage all of caller's tokens
403    * @param _operator  Address to add to the set of authorized operators
404    * @param _approved  True if the operator is approved, false to revoke approval
405    */
406   function setApprovalForAll(address _operator, bool _approved)
407     external
408   {
409     // Update operator status
410     operators[msg.sender][_operator] = _approved;
411     emit ApprovalForAll(msg.sender, _operator, _approved);
412   }
413 
414   /**
415    * @notice Queries the approval status of an operator for a given owner
416    * @param _owner     The owner of the Tokens
417    * @param _operator  Address of authorized operator
418    * @return True if the operator is approved, false if not
419    */
420   function isApprovedForAll(address _owner, address _operator)
421     public view returns (bool isOperator)
422   {
423     return operators[_owner][_operator];
424   }
425 
426 
427   /***********************************|
428   |         Balance Functions         |
429   |__________________________________*/
430 
431   /**
432    * @notice Get the balance of an account's Tokens
433    * @param _owner  The address of the token holder
434    * @param _id     ID of the Token
435    * @return The _owner's balance of the Token type requested
436    */
437   function balanceOf(address _owner, uint256 _id)
438     public view returns (uint256)
439   {
440     return balances[_owner][_id];
441   }
442 
443   /**
444    * @notice Get the balance of multiple account/token pairs
445    * @param _owners The addresses of the token holders
446    * @param _ids    ID of the Tokens
447    * @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)
448    */
449   function balanceOfBatch(address[] memory _owners, uint256[] memory _ids)
450     public view returns (uint256[] memory)
451   {
452     require(_owners.length == _ids.length, "ERC1155#balanceOfBatch: INVALID_ARRAY_LENGTH");
453 
454     // Variables
455     uint256[] memory batchBalances = new uint256[](_owners.length);
456 
457     // Iterate over each owner and token ID
458     for (uint256 i = 0; i < _owners.length; i++) {
459       batchBalances[i] = balances[_owners[i]][_ids[i]];
460     }
461 
462     return batchBalances;
463   }
464 
465 
466   /***********************************|
467   |          ERC165 Functions         |
468   |__________________________________*/
469 
470   /**
471    * INTERFACE_SIGNATURE_ERC165 = bytes4(keccak256("supportsInterface(bytes4)"));
472    */
473   bytes4 constant private INTERFACE_SIGNATURE_ERC165 = 0x01ffc9a7;
474 
475   /**
476    * INTERFACE_SIGNATURE_ERC1155 =
477    * bytes4(keccak256("safeTransferFrom(address,address,uint256,uint256,bytes)")) ^
478    * bytes4(keccak256("safeBatchTransferFrom(address,address,uint256[],uint256[],bytes)")) ^
479    * bytes4(keccak256("balanceOf(address,uint256)")) ^
480    * bytes4(keccak256("balanceOfBatch(address[],uint256[])")) ^
481    * bytes4(keccak256("setApprovalForAll(address,bool)")) ^
482    * bytes4(keccak256("isApprovedForAll(address,address)"));
483    */
484   bytes4 constant private INTERFACE_SIGNATURE_ERC1155 = 0xd9b67a26;
485 
486   /**
487    * @notice Query if a contract implements an interface
488    * @param _interfaceID  The interface identifier, as specified in ERC-165
489    * @return `true` if the contract implements `_interfaceID` and
490    */
491   function supportsInterface(bytes4 _interfaceID) external view returns (bool) {
492     if (_interfaceID == INTERFACE_SIGNATURE_ERC165 ||
493         _interfaceID == INTERFACE_SIGNATURE_ERC1155) {
494       return true;
495     }
496     return false;
497   }
498 
499 }
500 
501 library Strings {
502   // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
503   function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory) {
504       bytes memory _ba = bytes(_a);
505       bytes memory _bb = bytes(_b);
506       bytes memory _bc = bytes(_c);
507       bytes memory _bd = bytes(_d);
508       bytes memory _be = bytes(_e);
509       string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
510       bytes memory babcde = bytes(abcde);
511       uint k = 0;
512       for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
513       for (uint i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
514       for (uint i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
515       for (uint i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
516       for (uint i = 0; i < _be.length; i++) babcde[k++] = _be[i];
517       return string(babcde);
518     }
519 
520     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory) {
521         return strConcat(_a, _b, _c, _d, "");
522     }
523 
524     function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory) {
525         return strConcat(_a, _b, _c, "", "");
526     }
527 
528     function strConcat(string memory _a, string memory _b) internal pure returns (string memory) {
529         return strConcat(_a, _b, "", "", "");
530     }
531 
532     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
533         if (_i == 0) {
534             return "0";
535         }
536         uint j = _i;
537         uint len;
538         while (j != 0) {
539             len++;
540             j /= 10;
541         }
542         bytes memory bstr = new bytes(len);
543         uint k = len - 1;
544         while (_i != 0) {
545             bstr[k--] = byte(uint8(48 + _i % 10));
546             _i /= 10;
547         }
548         return string(bstr);
549     }
550 }
551 contract Context {
552     
553     
554     constructor () internal { }
555     
556 
557     function _msgSender() internal view returns (address payable) {
558         return msg.sender;
559     }
560 
561     function _msgData() internal view returns (bytes memory) {
562         this; 
563         return msg.data;
564     }
565 }
566 
567 contract Ownable is Context {
568     
569     address private _owner;
570 
571     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
572 
573     
574     constructor () internal {
575         address msgSender = _msgSender();
576         _owner = msgSender;
577         emit OwnershipTransferred(address(0), msgSender);
578     }
579 
580     
581     function owner() public view returns (address) {
582         return _owner;
583     }
584 
585     
586     modifier onlyOwner() {
587         require(isOwner(), "Ownable: caller is not the owner");
588         _;
589     }
590 
591     
592     function isOwner() public view returns (bool) {
593         return _msgSender() == _owner;
594     }
595 
596     
597     function renounceOwnership() public onlyOwner {
598         emit OwnershipTransferred(_owner, address(0));
599         _owner = address(0);
600     }
601 
602     
603     function transferOwnership(address newOwner) public onlyOwner {
604         _transferOwnership(newOwner);
605     }
606 
607     
608     function _transferOwnership(address newOwner) internal {
609         require(newOwner != address(0), "Ownable: new owner is the zero address");
610         emit OwnershipTransferred(_owner, newOwner);
611         _owner = newOwner;
612     }
613 }
614 
615 contract ERC1155MintBurn is ERC1155 {
616 
617 
618   /****************************************|
619   |            Minting Functions           |
620   |_______________________________________*/
621 
622   /**
623    * @notice Mint _amount of tokens of a given id
624    * @param _to      The address to mint tokens to
625    * @param _id      Token id to mint
626    * @param _amount  The amount to be minted
627    * @param _data    Data to pass if receiver is contract
628    */
629   function _mint(address _to, uint256 _id, uint256 _amount, bytes memory _data)
630     internal
631   {
632     // Add _amount
633     balances[_to][_id] = balances[_to][_id].add(_amount);
634 
635     // Emit event
636     emit TransferSingle(msg.sender, address(0x0), _to, _id, _amount);
637 
638     // Calling onReceive method if recipient is contract
639     _callonERC1155Received(address(0x0), _to, _id, _amount, _data);
640   }
641 
642   /**
643    * @notice Mint tokens for each ids in _ids
644    * @param _to       The address to mint tokens to
645    * @param _ids      Array of ids to mint
646    * @param _amounts  Array of amount of tokens to mint per id
647    * @param _data    Data to pass if receiver is contract
648    */
649   function _batchMint(address _to, uint256[] memory _ids, uint256[] memory _amounts, bytes memory _data)
650     internal
651   {
652     require(_ids.length == _amounts.length, "ERC1155MintBurn#batchMint: INVALID_ARRAYS_LENGTH");
653 
654     // Number of mints to execute
655     uint256 nMint = _ids.length;
656 
657      // Executing all minting
658     for (uint256 i = 0; i < nMint; i++) {
659       // Update storage balance
660       balances[_to][_ids[i]] = balances[_to][_ids[i]].add(_amounts[i]);
661     }
662 
663     // Emit batch mint event
664     emit TransferBatch(msg.sender, address(0x0), _to, _ids, _amounts);
665 
666     // Calling onReceive method if recipient is contract
667     _callonERC1155BatchReceived(address(0x0), _to, _ids, _amounts, _data);
668   }
669 
670 
671   /****************************************|
672   |            Burning Functions           |
673   |_______________________________________*/
674 
675   /**
676    * @notice Burn _amount of tokens of a given token id
677    * @param _from    The address to burn tokens from
678    * @param _id      Token id to burn
679    * @param _amount  The amount to be burned
680    */
681   function _burn(address _from, uint256 _id, uint256 _amount)
682     internal
683   {
684     //Substract _amount
685     balances[_from][_id] = balances[_from][_id].sub(_amount);
686 
687     // Emit event
688     emit TransferSingle(msg.sender, _from, address(0x0), _id, _amount);
689   }
690 
691   /**
692    * @notice Burn tokens of given token id for each (_ids[i], _amounts[i]) pair
693    * @param _from     The address to burn tokens from
694    * @param _ids      Array of token ids to burn
695    * @param _amounts  Array of the amount to be burned
696    */
697   function _batchBurn(address _from, uint256[] memory _ids, uint256[] memory _amounts)
698     internal
699   {
700     require(_ids.length == _amounts.length, "ERC1155MintBurn#batchBurn: INVALID_ARRAYS_LENGTH");
701 
702     // Number of mints to execute
703     uint256 nBurn = _ids.length;
704 
705      // Executing all minting
706     for (uint256 i = 0; i < nBurn; i++) {
707       // Update storage balance
708       balances[_from][_ids[i]] = balances[_from][_ids[i]].sub(_amounts[i]);
709     }
710 
711     // Emit batch mint event
712     emit TransferBatch(msg.sender, _from, address(0x0), _ids, _amounts);
713   }
714 
715 }
716 
717 
718 
719 contract OwnableDelegateProxy { }
720 
721 contract ProxyRegistry {
722   mapping(address => OwnableDelegateProxy) public proxies;
723 }
724 
725 /**
726  * @title ERC1155Tradable
727  * ERC1155Tradable - ERC1155 contract that whitelists an operator address, has create and mint functionality, and supports useful standards from OpenZeppelin,
728   like _exists(), name(), symbol(), and totalSupply()
729  */
730 contract ERC1155Tradable is ERC1155, ERC1155MintBurn, ERC1155Metadata, Ownable {
731   using Strings for string;
732 
733   address proxyRegistryAddress;
734   uint256 private _currentTokenID = 0;
735   mapping (uint256 => address) public creators;
736   mapping (uint256 => uint256) public tokenSupply;
737   // Contract name
738   string public name;
739   // Contract symbol
740   string public symbol;
741 
742   /**
743    * @dev Require msg.sender to be the creator of the token id
744    */
745   modifier creatorOnly(uint256 _id) {
746     require(creators[_id] == msg.sender, "ERC1155Tradable#creatorOnly: ONLY_CREATOR_ALLOWED");
747     _;
748   }
749 
750   /**
751    * @dev Require msg.sender to own more than 0 of the token id
752    */
753   modifier ownersOnly(uint256 _id) {
754     require(balances[msg.sender][_id] > 0, "ERC1155Tradable#ownersOnly: ONLY_OWNERS_ALLOWED");
755     _;
756   }
757 
758   constructor(
759     string memory _name,
760     string memory _symbol,
761     address _proxyRegistryAddress
762   ) public {
763     name = _name;
764     symbol = _symbol;
765     proxyRegistryAddress = _proxyRegistryAddress;
766   }
767   
768   function setProxyRegistryAddress(address _proxyRegistryAddress) public onlyOwner {
769       proxyRegistryAddress = _proxyRegistryAddress;
770   }
771 
772   function uri(
773     uint256 _id
774   ) public view returns (string memory) {
775     require(_exists(_id), "ERC721Tradable#uri: NONEXISTENT_TOKEN");
776     return Strings.strConcat(
777       baseMetadataURI,
778       Strings.uint2str(_id)
779     );
780   }
781 
782   /**
783     * @dev Returns the total quantity for a token ID
784     * @param _id uint256 ID of the token to query
785     * @return amount of token in existence
786     */
787   function totalSupply(
788     uint256 _id
789   ) public view returns (uint256) {
790     return tokenSupply[_id];
791   }
792 
793   /**
794    * @dev Will update the base URL of token's URI
795    * @param _newBaseMetadataURI New base URL of token's URI
796    */
797   function setBaseMetadataURI(
798     string memory _newBaseMetadataURI
799   ) public onlyOwner {
800     _setBaseMetadataURI(_newBaseMetadataURI);
801   }
802 
803   /**
804     * @dev Creates a new token type and assigns _initialSupply to an address
805     * NOTE: remove onlyOwner if you want third parties to create new tokens on your contract (which may change your IDs)
806     * @param _initialOwner address of the first owner of the token
807     * @param _initialSupply amount to supply the first owner
808     * @param _uri Optional URI for this token type
809     * @param _data Data to pass if receiver is contract
810     * @return The newly created token ID
811     */
812   function create(
813     address _initialOwner,
814     uint256 _initialSupply,
815     string calldata _uri,
816     bytes calldata _data
817   ) external onlyOwner returns (uint256) {
818 
819     uint256 _id = _getNextTokenID();
820     _incrementTokenTypeId();
821     creators[_id] = msg.sender;
822 
823     if (bytes(_uri).length > 0) {
824       emit URI(_uri, _id);
825     }
826 
827     _mint(_initialOwner, _id, _initialSupply, _data);
828     tokenSupply[_id] = _initialSupply;
829     return _id;
830   }
831 
832   /**
833     * @dev Mints some amount of tokens to an address
834     * @param _to          Address of the future owner of the token
835     * @param _id          Token ID to mint
836     * @param _quantity    Amount of tokens to mint
837     * @param _data        Data to pass if receiver is contract
838     */
839   function mint(
840     address _to,
841     uint256 _id,
842     uint256 _quantity,
843     bytes memory _data
844   ) public creatorOnly(_id) {
845     _mint(_to, _id, _quantity, _data);
846     tokenSupply[_id] = tokenSupply[_id].add(_quantity);
847   }
848 
849   /**
850     * @dev Mint tokens for each id in _ids
851     * @param _to          The address to mint tokens to
852     * @param _ids         Array of ids to mint
853     * @param _quantities  Array of amounts of tokens to mint per id
854     * @param _data        Data to pass if receiver is contract
855     */
856   function batchMint(
857     address _to,
858     uint256[] memory _ids,
859     uint256[] memory _quantities,
860     bytes memory _data
861   ) public {
862     for (uint256 i = 0; i < _ids.length; i++) {
863       uint256 _id = _ids[i];
864       require(creators[_id] == msg.sender, "ERC1155Tradable#batchMint: ONLY_CREATOR_ALLOWED");
865       uint256 quantity = _quantities[i];
866       tokenSupply[_id] = tokenSupply[_id].add(quantity);
867     }
868     _batchMint(_to, _ids, _quantities, _data);
869   }
870 
871   /**
872     * @dev Change the creator address for given tokens
873     * @param _to   Address of the new creator
874     * @param _ids  Array of Token IDs to change creator
875     */
876   function setCreator(
877     address _to,
878     uint256[] memory _ids
879   ) public {
880     require(_to != address(0), "ERC1155Tradable#setCreator: INVALID_ADDRESS.");
881     for (uint256 i = 0; i < _ids.length; i++) {
882       uint256 id = _ids[i];
883       _setCreator(_to, id);
884     }
885   }
886 
887   /**
888    * Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-free listings.
889    */
890   function isApprovedForAll(
891     address _owner,
892     address _operator
893   ) public view returns (bool isOperator) {
894     // Whitelist OpenSea proxy contract for easy trading.
895     ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
896     if (address(proxyRegistry.proxies(_owner)) == _operator) {
897       return true;
898     }
899 
900     return ERC1155.isApprovedForAll(_owner, _operator);
901   }
902 
903   /**
904     * @dev Change the creator address for given token
905     * @param _to   Address of the new creator
906     * @param _id  Token IDs to change creator of
907     */
908   function _setCreator(address _to, uint256 _id) internal creatorOnly(_id)
909   {
910       creators[_id] = _to;
911   }
912 
913   /**
914     * @dev Returns whether the specified token exists by checking to see if it has a creator
915     * @param _id uint256 ID of the token to query the existence of
916     * @return bool whether the token exists
917     */
918   function _exists(
919     uint256 _id
920   ) internal view returns (bool) {
921     return creators[_id] != address(0);
922   }
923 
924   /**
925     * @dev calculates the next token ID based on value of _currentTokenID
926     * @return uint256 for the next token ID
927     */
928   function _getNextTokenID() private view returns (uint256) {
929     return _currentTokenID.add(1);
930   }
931 
932   /**
933     * @dev increments the value of _currentTokenID
934     */
935   function _incrementTokenTypeId() private  {
936     _currentTokenID++;
937   }
938 }