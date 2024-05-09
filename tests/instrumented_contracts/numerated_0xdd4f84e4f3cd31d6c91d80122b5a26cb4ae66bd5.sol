1 // SPDX-License-Identifier: UNLICENSED
2 
3 pragma solidity 0.5.17;
4 
5 
6 
7 // Part: ERC1155Metadata
8 
9 /**
10  * @notice Contract that handles metadata related methods.
11  * @dev Methods assume a deterministic generation of URI based on token IDs.
12  *      Methods also assume that URI uses hex representation of token IDs.
13  */
14 contract ERC1155Metadata {
15     // URI's default URI prefix
16     string internal baseMetadataURI;
17     event URI(string _uri, uint256 indexed _id);
18 
19     /***********************************|
20   |     Metadata Public Function s    |
21   |__________________________________*/
22 
23     /**
24      * @notice A distinct Uniform Resource Identifier (URI) for a given token.
25      * @dev URIs are defined in RFC 3986.
26      *      URIs are assumed to be deterministically generated based on token ID
27      *      Token IDs are assumed to be represented in their hex format in URIs
28      * @return URI string
29      */
30     function uri(uint256 _id) public view returns (string memory) {
31         return
32             string(abi.encodePacked(baseMetadataURI, _uint2str(_id), ".json"));
33     }
34 
35     /***********************************|
36   |    Metadata Internal Functions    |
37   |__________________________________*/
38 
39     /**
40      * @notice Will emit default URI log event for corresponding token _id
41      * @param _tokenIDs Array of IDs of tokens to log default URI
42      */
43     function _logURIs(uint256[] memory _tokenIDs) internal {
44         string memory baseURL = baseMetadataURI;
45         string memory tokenURI;
46 
47         for (uint256 i = 0; i < _tokenIDs.length; i++) {
48             tokenURI = string(
49                 abi.encodePacked(baseURL, _uint2str(_tokenIDs[i]), ".json")
50             );
51             emit URI(tokenURI, _tokenIDs[i]);
52         }
53     }
54 
55     /**
56      * @notice Will emit a specific URI log event for corresponding token
57      * @param _tokenIDs IDs of the token corresponding to the _uris logged
58      * @param _URIs    The URIs of the specified _tokenIDs
59      */
60     function _logURIs(uint256[] memory _tokenIDs, string[] memory _URIs)
61         internal
62     {
63         require(
64             _tokenIDs.length == _URIs.length,
65             "ERC1155Metadata#_logURIs: INVALID_ARRAYS_LENGTH"
66         );
67         for (uint256 i = 0; i < _tokenIDs.length; i++) {
68             emit URI(_URIs[i], _tokenIDs[i]);
69         }
70     }
71 
72     /**
73      * @notice Will update the base URL of token's URI
74      * @param _newBaseMetadataURI New base URL of token's URI
75      */
76     function _setBaseMetadataURI(string memory _newBaseMetadataURI) internal {
77         baseMetadataURI = _newBaseMetadataURI;
78     }
79 
80     /***********************************|
81   |    Utility Internal Functions     |
82   |__________________________________*/
83 
84     /**
85      * @notice Convert uint256 to string
86      * @param _i Unsigned integer to convert to string
87      */
88     function _uint2str(uint256 _i)
89         internal
90         pure
91         returns (string memory _uintAsString)
92     {
93         if (_i == 0) {
94             return "0";
95         }
96 
97         uint256 j = _i;
98         uint256 ii = _i;
99         uint256 len;
100 
101         // Get number of bytes
102         while (j != 0) {
103             len++;
104             j /= 10;
105         }
106 
107         bytes memory bstr = new bytes(len);
108         uint256 k = len - 1;
109 
110         // Get each individual ASCII
111         while (ii != 0) {
112             bstr[k--] = bytes1(uint8(48 + (ii % 10)));
113             ii /= 10;
114         }
115 
116         // Convert to string
117         return string(bstr);
118     }
119 }
120 
121 // Part: IERC1155TokenReceiver
122 
123 /**
124  * @dev ERC-1155 interface for accepting safe transfers.
125  */
126 interface IERC1155TokenReceiver {
127     /**
128      * @notice Handle the receipt of a single ERC1155 token type
129      * @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeTransferFrom` after the balance has been updated
130      * This function MAY throw to revert and reject the transfer
131      * Return of other amount than the magic value MUST result in the transaction being reverted
132      * Note: The token contract address is always the message sender
133      * @param _operator  The address which called the `safeTransferFrom` function
134      * @param _from      The address which previously owned the token
135      * @param _id        The id of the token being transferred
136      * @param _amount    The amount of tokens being transferred
137      * @param _data      Additional data with no specified format
138      * @return           `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
139      */
140     function onERC1155Received(
141         address _operator,
142         address _from,
143         uint256 _id,
144         uint256 _amount,
145         bytes calldata _data
146     ) external returns (bytes4);
147 
148     /**
149      * @notice Handle the receipt of multiple ERC1155 token types
150      * @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeBatchTransferFrom` after the balances have been updated
151      * This function MAY throw to revert and reject the transfer
152      * Return of other amount than the magic value WILL result in the transaction being reverted
153      * Note: The token contract address is always the message sender
154      * @param _operator  The address which called the `safeBatchTransferFrom` function
155      * @param _from      The address which previously owned the token
156      * @param _ids       An array containing ids of each token being transferred
157      * @param _amounts   An array containing amounts of each token being transferred
158      * @param _data      Additional data with no specified format
159      * @return           `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
160      */
161     function onERC1155BatchReceived(
162         address _operator,
163         address _from,
164         uint256[] calldata _ids,
165         uint256[] calldata _amounts,
166         bytes calldata _data
167     ) external returns (bytes4);
168 
169     /**
170      * @notice Indicates whether a contract implements the `ERC1155TokenReceiver` functions and so can accept ERC1155 token types.
171      * @param  interfaceID The ERC-165 interface ID that is queried for support.s
172      * @dev This function MUST return true if it implements the ERC1155TokenReceiver interface and ERC-165 interface.
173      *      This function MUST NOT consume more than 5,000 gas.
174      * @return Wheter ERC-165 or ERC1155TokenReceiver interfaces are supported.
175      */
176     function supportsInterface(bytes4 interfaceID) external view returns (bool);
177 }
178 
179 // Part: IERC165
180 
181 /**
182  * @title ERC165
183  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
184  */
185 interface IERC165 {
186     /**
187      * @notice Query if a contract implements an interface
188      * @dev Interface identification is specified in ERC-165. This function
189      * uses less than 30,000 gas
190      * @param _interfaceId The interface identifier, as specified in ERC-165
191      */
192     function supportsInterface(bytes4 _interfaceId)
193         external
194         view
195         returns (bool);
196 }
197 
198 // Part: OpenZeppelin/openzeppelin-contracts@2.5.1/Address
199 
200 /**
201  * @dev Collection of functions related to the address type
202  */
203 library Address {
204     /**
205      * @dev Returns true if `account` is a contract.
206      *
207      * [IMPORTANT]
208      * ====
209      * It is unsafe to assume that an address for which this function returns
210      * false is an externally-owned account (EOA) and not a contract.
211      *
212      * Among others, `isContract` will return false for the following 
213      * types of addresses:
214      *
215      *  - an externally-owned account
216      *  - a contract in construction
217      *  - an address where a contract will be created
218      *  - an address where a contract lived, but was destroyed
219      * ====
220      */
221     function isContract(address account) internal view returns (bool) {
222         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
223         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
224         // for accounts without code, i.e. `keccak256('')`
225         bytes32 codehash;
226         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
227         // solhint-disable-next-line no-inline-assembly
228         assembly { codehash := extcodehash(account) }
229         return (codehash != accountHash && codehash != 0x0);
230     }
231 
232     /**
233      * @dev Converts an `address` into `address payable`. Note that this is
234      * simply a type cast: the actual underlying value is not changed.
235      *
236      * _Available since v2.4.0._
237      */
238     function toPayable(address account) internal pure returns (address payable) {
239         return address(uint160(account));
240     }
241 
242     /**
243      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
244      * `recipient`, forwarding all available gas and reverting on errors.
245      *
246      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
247      * of certain opcodes, possibly making contracts go over the 2300 gas limit
248      * imposed by `transfer`, making them unable to receive funds via
249      * `transfer`. {sendValue} removes this limitation.
250      *
251      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
252      *
253      * IMPORTANT: because control is transferred to `recipient`, care must be
254      * taken to not create reentrancy vulnerabilities. Consider using
255      * {ReentrancyGuard} or the
256      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
257      *
258      * _Available since v2.4.0._
259      */
260     function sendValue(address payable recipient, uint256 amount) internal {
261         require(address(this).balance >= amount, "Address: insufficient balance");
262 
263         // solhint-disable-next-line avoid-call-value
264         (bool success, ) = recipient.call.value(amount)("");
265         require(success, "Address: unable to send value, recipient may have reverted");
266     }
267 }
268 
269 // Part: OpenZeppelin/openzeppelin-contracts@2.5.1/Context
270 
271 /*
272  * @dev Provides information about the current execution context, including the
273  * sender of the transaction and its data. While these are generally available
274  * via msg.sender and msg.data, they should not be accessed in such a direct
275  * manner, since when dealing with GSN meta-transactions the account sending and
276  * paying for execution may not be the actual sender (as far as an application
277  * is concerned).
278  *
279  * This contract is only required for intermediate, library-like contracts.
280  */
281 contract Context {
282     // Empty internal constructor, to prevent people from mistakenly deploying
283     // an instance of this contract, which should be used via inheritance.
284     constructor () internal { }
285     // solhint-disable-previous-line no-empty-blocks
286 
287     function _msgSender() internal view returns (address payable) {
288         return msg.sender;
289     }
290 
291     function _msgData() internal view returns (bytes memory) {
292         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
293         return msg.data;
294     }
295 }
296 
297 // Part: OpenZeppelin/openzeppelin-contracts@2.5.1/SafeMath
298 
299 /**
300  * @dev Wrappers over Solidity's arithmetic operations with added overflow
301  * checks.
302  *
303  * Arithmetic operations in Solidity wrap on overflow. This can easily result
304  * in bugs, because programmers usually assume that an overflow raises an
305  * error, which is the standard behavior in high level programming languages.
306  * `SafeMath` restores this intuition by reverting the transaction when an
307  * operation overflows.
308  *
309  * Using this library instead of the unchecked operations eliminates an entire
310  * class of bugs, so it's recommended to use it always.
311  */
312 library SafeMath {
313     /**
314      * @dev Returns the addition of two unsigned integers, reverting on
315      * overflow.
316      *
317      * Counterpart to Solidity's `+` operator.
318      *
319      * Requirements:
320      * - Addition cannot overflow.
321      */
322     function add(uint256 a, uint256 b) internal pure returns (uint256) {
323         uint256 c = a + b;
324         require(c >= a, "SafeMath: addition overflow");
325 
326         return c;
327     }
328 
329     /**
330      * @dev Returns the subtraction of two unsigned integers, reverting on
331      * overflow (when the result is negative).
332      *
333      * Counterpart to Solidity's `-` operator.
334      *
335      * Requirements:
336      * - Subtraction cannot overflow.
337      */
338     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
339         return sub(a, b, "SafeMath: subtraction overflow");
340     }
341 
342     /**
343      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
344      * overflow (when the result is negative).
345      *
346      * Counterpart to Solidity's `-` operator.
347      *
348      * Requirements:
349      * - Subtraction cannot overflow.
350      *
351      * _Available since v2.4.0._
352      */
353     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
354         require(b <= a, errorMessage);
355         uint256 c = a - b;
356 
357         return c;
358     }
359 
360     /**
361      * @dev Returns the multiplication of two unsigned integers, reverting on
362      * overflow.
363      *
364      * Counterpart to Solidity's `*` operator.
365      *
366      * Requirements:
367      * - Multiplication cannot overflow.
368      */
369     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
370         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
371         // benefit is lost if 'b' is also tested.
372         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
373         if (a == 0) {
374             return 0;
375         }
376 
377         uint256 c = a * b;
378         require(c / a == b, "SafeMath: multiplication overflow");
379 
380         return c;
381     }
382 
383     /**
384      * @dev Returns the integer division of two unsigned integers. Reverts on
385      * division by zero. The result is rounded towards zero.
386      *
387      * Counterpart to Solidity's `/` operator. Note: this function uses a
388      * `revert` opcode (which leaves remaining gas untouched) while Solidity
389      * uses an invalid opcode to revert (consuming all remaining gas).
390      *
391      * Requirements:
392      * - The divisor cannot be zero.
393      */
394     function div(uint256 a, uint256 b) internal pure returns (uint256) {
395         return div(a, b, "SafeMath: division by zero");
396     }
397 
398     /**
399      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
400      * division by zero. The result is rounded towards zero.
401      *
402      * Counterpart to Solidity's `/` operator. Note: this function uses a
403      * `revert` opcode (which leaves remaining gas untouched) while Solidity
404      * uses an invalid opcode to revert (consuming all remaining gas).
405      *
406      * Requirements:
407      * - The divisor cannot be zero.
408      *
409      * _Available since v2.4.0._
410      */
411     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
412         // Solidity only automatically asserts when dividing by 0
413         require(b > 0, errorMessage);
414         uint256 c = a / b;
415         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
416 
417         return c;
418     }
419 
420     /**
421      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
422      * Reverts when dividing by zero.
423      *
424      * Counterpart to Solidity's `%` operator. This function uses a `revert`
425      * opcode (which leaves remaining gas untouched) while Solidity uses an
426      * invalid opcode to revert (consuming all remaining gas).
427      *
428      * Requirements:
429      * - The divisor cannot be zero.
430      */
431     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
432         return mod(a, b, "SafeMath: modulo by zero");
433     }
434 
435     /**
436      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
437      * Reverts with custom message when dividing by zero.
438      *
439      * Counterpart to Solidity's `%` operator. This function uses a `revert`
440      * opcode (which leaves remaining gas untouched) while Solidity uses an
441      * invalid opcode to revert (consuming all remaining gas).
442      *
443      * Requirements:
444      * - The divisor cannot be zero.
445      *
446      * _Available since v2.4.0._
447      */
448     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
449         require(b != 0, errorMessage);
450         return a % b;
451     }
452 }
453 
454 // Part: OwnableDelegateProxy
455 
456 contract OwnableDelegateProxy {}
457 
458 // Part: Roles
459 
460 /**
461  * @title Roles
462  * @dev Library for managing addresses assigned to a Role.
463  */
464 library Roles {
465     struct Role {
466         mapping(address => bool) bearer;
467     }
468 
469     /**
470      * @dev Give an account access to this role.
471      */
472     function add(Role storage role, address account) internal {
473         require(!has(role, account), "Roles: account already has role");
474         role.bearer[account] = true;
475     }
476 
477     /**
478      * @dev Remove an account's access to this role.
479      */
480     function remove(Role storage role, address account) internal {
481         require(has(role, account), "Roles: account does not have role");
482         role.bearer[account] = false;
483     }
484 
485     /**
486      * @dev Check if an account has this role.
487      * @return bool
488      */
489     function has(Role storage role, address account)
490         internal
491         view
492         returns (bool)
493     {
494         require(account != address(0), "Roles: account is the zero address");
495         return role.bearer[account];
496     }
497 }
498 
499 // Part: Strings
500 
501 library Strings {
502     // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
503     function strConcat(
504         string memory _a,
505         string memory _b,
506         string memory _c,
507         string memory _d,
508         string memory _e
509     ) internal pure returns (string memory) {
510         bytes memory _ba = bytes(_a);
511         bytes memory _bb = bytes(_b);
512         bytes memory _bc = bytes(_c);
513         bytes memory _bd = bytes(_d);
514         bytes memory _be = bytes(_e);
515         string memory abcde =
516             new string(
517                 _ba.length + _bb.length + _bc.length + _bd.length + _be.length
518             );
519         bytes memory babcde = bytes(abcde);
520         uint256 k = 0;
521         for (uint256 i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
522         for (uint256 i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
523         for (uint256 i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
524         for (uint256 i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
525         for (uint256 i = 0; i < _be.length; i++) babcde[k++] = _be[i];
526         return string(babcde);
527     }
528 
529     function strConcat(
530         string memory _a,
531         string memory _b,
532         string memory _c,
533         string memory _d
534     ) internal pure returns (string memory) {
535         return strConcat(_a, _b, _c, _d, "");
536     }
537 
538     function strConcat(
539         string memory _a,
540         string memory _b,
541         string memory _c
542     ) internal pure returns (string memory) {
543         return strConcat(_a, _b, _c, "", "");
544     }
545 
546     function strConcat(string memory _a, string memory _b)
547         internal
548         pure
549         returns (string memory)
550     {
551         return strConcat(_a, _b, "", "", "");
552     }
553 
554     function uint2str(uint256 _i)
555         internal
556         pure
557         returns (string memory _uintAsString)
558     {
559         if (_i == 0) {
560             return "0";
561         }
562         uint256 j = _i;
563         uint256 len;
564         while (j != 0) {
565             len++;
566             j /= 10;
567         }
568         bytes memory bstr = new bytes(len);
569         uint256 k = len - 1;
570         while (_i != 0) {
571             bstr[k--] = bytes1(uint8(48 + (_i % 10)));
572             _i /= 10;
573         }
574         return string(bstr);
575     }
576 }
577 
578 // Part: ERC1155
579 
580 /**
581  * @dev Implementation of Multi-Token Standard contract
582  */
583 contract ERC1155 is IERC165 {
584     using SafeMath for uint256;
585     using Address for address;
586 
587     /***********************************|
588   |        Variables and Events       |
589   |__________________________________*/
590 
591     // onReceive function signatures
592     bytes4 internal constant ERC1155_RECEIVED_VALUE = 0xf23a6e61;
593     bytes4 internal constant ERC1155_BATCH_RECEIVED_VALUE = 0xbc197c81;
594 
595     // Objects balances
596     mapping(address => mapping(uint256 => uint256)) internal balances;
597 
598     // Operator Functions
599     mapping(address => mapping(address => bool)) internal operators;
600 
601     // Events
602     event TransferSingle(
603         address indexed _operator,
604         address indexed _from,
605         address indexed _to,
606         uint256 _id,
607         uint256 _amount
608     );
609     event TransferBatch(
610         address indexed _operator,
611         address indexed _from,
612         address indexed _to,
613         uint256[] _ids,
614         uint256[] _amounts
615     );
616     event ApprovalForAll(
617         address indexed _owner,
618         address indexed _operator,
619         bool _approved
620     );
621     event URI(string _uri, uint256 indexed _id);
622 
623     /***********************************|
624   |     Public Transfer Functions     |
625   |__________________________________*/
626 
627     /**
628      * @notice Transfers amount amount of an _id from the _from address to the _to address specified
629      * @param _from    Source address
630      * @param _to      Target address
631      * @param _id      ID of the token type
632      * @param _amount  Transfered amount
633      * @param _data    Additional data with no specified format, sent in call to `_to`
634      */
635     function safeTransferFrom(
636         address _from,
637         address _to,
638         uint256 _id,
639         uint256 _amount,
640         bytes memory _data
641     ) public {
642         require(
643             (msg.sender == _from) || isApprovedForAll(_from, msg.sender),
644             "ERC1155#safeTransferFrom: INVALID_OPERATOR"
645         );
646         require(
647             _to != address(0),
648             "ERC1155#safeTransferFrom: INVALID_RECIPIENT"
649         );
650         // require(_amount >= balances[_from][_id]) is not necessary since checked with safemath operations
651 
652         _safeTransferFrom(_from, _to, _id, _amount);
653         _callonERC1155Received(_from, _to, _id, _amount, _data);
654     }
655 
656     /**
657      * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
658      * @param _from     Source addresses
659      * @param _to       Target addresses
660      * @param _ids      IDs of each token type
661      * @param _amounts  Transfer amounts per token type
662      * @param _data     Additional data with no specified format, sent in call to `_to`
663      */
664     function safeBatchTransferFrom(
665         address _from,
666         address _to,
667         uint256[] memory _ids,
668         uint256[] memory _amounts,
669         bytes memory _data
670     ) public {
671         // Requirements
672         require(
673             (msg.sender == _from) || isApprovedForAll(_from, msg.sender),
674             "ERC1155#safeBatchTransferFrom: INVALID_OPERATOR"
675         );
676         require(
677             _to != address(0),
678             "ERC1155#safeBatchTransferFrom: INVALID_RECIPIENT"
679         );
680 
681         _safeBatchTransferFrom(_from, _to, _ids, _amounts);
682         _callonERC1155BatchReceived(_from, _to, _ids, _amounts, _data);
683     }
684 
685     /***********************************|
686   |    Internal Transfer Functions    |
687   |__________________________________*/
688 
689     /**
690      * @notice Transfers amount amount of an _id from the _from address to the _to address specified
691      * @param _from    Source address
692      * @param _to      Target address
693      * @param _id      ID of the token type
694      * @param _amount  Transfered amount
695      */
696     function _safeTransferFrom(
697         address _from,
698         address _to,
699         uint256 _id,
700         uint256 _amount
701     ) internal {
702         // Update balances
703         balances[_from][_id] = balances[_from][_id].sub(_amount); // Subtract amount
704         balances[_to][_id] = balances[_to][_id].add(_amount); // Add amount
705 
706         // Emit event
707         emit TransferSingle(msg.sender, _from, _to, _id, _amount);
708     }
709 
710     /**
711      * @notice Verifies if receiver is contract and if so, calls (_to).onERC1155Received(...)
712      */
713     function _callonERC1155Received(
714         address _from,
715         address _to,
716         uint256 _id,
717         uint256 _amount,
718         bytes memory _data
719     ) internal {
720         // Check if recipient is contract
721         if (_to.isContract()) {
722             bytes4 retval =
723                 IERC1155TokenReceiver(_to).onERC1155Received(
724                     msg.sender,
725                     _from,
726                     _id,
727                     _amount,
728                     _data
729                 );
730             require(
731                 retval == ERC1155_RECEIVED_VALUE,
732                 "ERC1155#_callonERC1155Received: INVALID_ON_RECEIVE_MESSAGE"
733             );
734         }
735     }
736 
737     /**
738      * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
739      * @param _from     Source addresses
740      * @param _to       Target addresses
741      * @param _ids      IDs of each token type
742      * @param _amounts  Transfer amounts per token type
743      */
744     function _safeBatchTransferFrom(
745         address _from,
746         address _to,
747         uint256[] memory _ids,
748         uint256[] memory _amounts
749     ) internal {
750         require(
751             _ids.length == _amounts.length,
752             "ERC1155#_safeBatchTransferFrom: INVALID_ARRAYS_LENGTH"
753         );
754 
755         // Number of transfer to execute
756         uint256 nTransfer = _ids.length;
757 
758         // Executing all transfers
759         for (uint256 i = 0; i < nTransfer; i++) {
760             // Update storage balance of previous bin
761             balances[_from][_ids[i]] = balances[_from][_ids[i]].sub(
762                 _amounts[i]
763             );
764             balances[_to][_ids[i]] = balances[_to][_ids[i]].add(_amounts[i]);
765         }
766 
767         // Emit event
768         emit TransferBatch(msg.sender, _from, _to, _ids, _amounts);
769     }
770 
771     /**
772      * @notice Verifies if receiver is contract and if so, calls (_to).onERC1155BatchReceived(...)
773      */
774     function _callonERC1155BatchReceived(
775         address _from,
776         address _to,
777         uint256[] memory _ids,
778         uint256[] memory _amounts,
779         bytes memory _data
780     ) internal {
781         // Pass data if recipient is contract
782         if (_to.isContract()) {
783             bytes4 retval =
784                 IERC1155TokenReceiver(_to).onERC1155BatchReceived(
785                     msg.sender,
786                     _from,
787                     _ids,
788                     _amounts,
789                     _data
790                 );
791             require(
792                 retval == ERC1155_BATCH_RECEIVED_VALUE,
793                 "ERC1155#_callonERC1155BatchReceived: INVALID_ON_RECEIVE_MESSAGE"
794             );
795         }
796     }
797 
798     /***********************************|
799   |         Operator Functions        |
800   |__________________________________*/
801 
802     /**
803      * @notice Enable or disable approval for a third party ("operator") to manage all of caller's tokens
804      * @param _operator  Address to add to the set of authorized operators
805      * @param _approved  True if the operator is approved, false to revoke approval
806      */
807     function setApprovalForAll(address _operator, bool _approved) external {
808         // Update operator status
809         operators[msg.sender][_operator] = _approved;
810         emit ApprovalForAll(msg.sender, _operator, _approved);
811     }
812 
813     /**
814      * @notice Queries the approval status of an operator for a given owner
815      * @param _owner     The owner of the Tokens
816      * @param _operator  Address of authorized operator
817      * @return True if the operator is approved, false if not
818      */
819     function isApprovedForAll(address _owner, address _operator)
820         public
821         view
822         returns (bool isOperator)
823     {
824         return operators[_owner][_operator];
825     }
826 
827     /***********************************|
828   |         Balance Functions         |
829   |__________________________________*/
830 
831     /**
832      * @notice Get the balance of an account's Tokens
833      * @param _owner  The address of the token holder
834      * @param _id     ID of the Token
835      * @return The _owner's balance of the Token type requested
836      */
837     function balanceOf(address _owner, uint256 _id)
838         public
839         view
840         returns (uint256)
841     {
842         return balances[_owner][_id];
843     }
844 
845     /**
846      * @notice Get the balance of multiple account/token pairs
847      * @param _owners The addresses of the token holders
848      * @param _ids    ID of the Tokens
849      * @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)
850      */
851     function balanceOfBatch(address[] memory _owners, uint256[] memory _ids)
852         public
853         view
854         returns (uint256[] memory)
855     {
856         require(
857             _owners.length == _ids.length,
858             "ERC1155#balanceOfBatch: INVALID_ARRAY_LENGTH"
859         );
860 
861         // Variables
862         uint256[] memory batchBalances = new uint256[](_owners.length);
863 
864         // Iterate over each owner and token ID
865         for (uint256 i = 0; i < _owners.length; i++) {
866             batchBalances[i] = balances[_owners[i]][_ids[i]];
867         }
868 
869         return batchBalances;
870     }
871 
872     /***********************************|
873   |          ERC165 Functions         |
874   |__________________________________*/
875 
876     /**
877      * INTERFACE_SIGNATURE_ERC165 = bytes4(keccak256("supportsInterface(bytes4)"));
878      */
879     bytes4 private constant INTERFACE_SIGNATURE_ERC165 = 0x01ffc9a7;
880 
881     /**
882      * INTERFACE_SIGNATURE_ERC1155 =
883      * bytes4(keccak256("safeTransferFrom(address,address,uint256,uint256,bytes)")) ^
884      * bytes4(keccak256("safeBatchTransferFrom(address,address,uint256[],uint256[],bytes)")) ^
885      * bytes4(keccak256("balanceOf(address,uint256)")) ^
886      * bytes4(keccak256("balanceOfBatch(address[],uint256[])")) ^
887      * bytes4(keccak256("setApprovalForAll(address,bool)")) ^
888      * bytes4(keccak256("isApprovedForAll(address,address)"));
889      */
890     bytes4 private constant INTERFACE_SIGNATURE_ERC1155 = 0xd9b67a26;
891 
892     /**
893      * @notice Query if a contract implements an interface
894      * @param _interfaceID  The interface identifier, as specified in ERC-165
895      * @return `true` if the contract implements `_interfaceID` and
896      */
897     function supportsInterface(bytes4 _interfaceID)
898         external
899         view
900         returns (bool)
901     {
902         if (
903             _interfaceID == INTERFACE_SIGNATURE_ERC165 ||
904             _interfaceID == INTERFACE_SIGNATURE_ERC1155
905         ) {
906             return true;
907         }
908         return false;
909     }
910 }
911 
912 // Part: MinterRole
913 
914 contract MinterRole is Context {
915     using Roles for Roles.Role;
916 
917     event MinterAdded(address indexed account);
918     event MinterRemoved(address indexed account);
919 
920     Roles.Role private _minters;
921 
922     constructor() internal {
923         _addMinter(_msgSender());
924     }
925 
926     modifier onlyMinter() {
927         require(
928             isMinter(_msgSender()),
929             "MinterRole: caller does not have the Minter role"
930         );
931         _;
932     }
933 
934     function isMinter(address account) public view returns (bool) {
935         return _minters.has(account);
936     }
937 
938     function addMinter(address account) public onlyMinter {
939         _addMinter(account);
940     }
941 
942     function renounceMinter() public {
943         _removeMinter(_msgSender());
944     }
945 
946     function _addMinter(address account) internal {
947         _minters.add(account);
948         emit MinterAdded(account);
949     }
950 
951     function _removeMinter(address account) internal {
952         _minters.remove(account);
953         emit MinterRemoved(account);
954     }
955 }
956 
957 // Part: OpenZeppelin/openzeppelin-contracts@2.5.1/Ownable
958 
959 /**
960  * @dev Contract module which provides a basic access control mechanism, where
961  * there is an account (an owner) that can be granted exclusive access to
962  * specific functions.
963  *
964  * This module is used through inheritance. It will make available the modifier
965  * `onlyOwner`, which can be applied to your functions to restrict their use to
966  * the owner.
967  */
968 contract Ownable is Context {
969     address private _owner;
970 
971     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
972 
973     /**
974      * @dev Initializes the contract setting the deployer as the initial owner.
975      */
976     constructor () internal {
977         address msgSender = _msgSender();
978         _owner = msgSender;
979         emit OwnershipTransferred(address(0), msgSender);
980     }
981 
982     /**
983      * @dev Returns the address of the current owner.
984      */
985     function owner() public view returns (address) {
986         return _owner;
987     }
988 
989     /**
990      * @dev Throws if called by any account other than the owner.
991      */
992     modifier onlyOwner() {
993         require(isOwner(), "Ownable: caller is not the owner");
994         _;
995     }
996 
997     /**
998      * @dev Returns true if the caller is the current owner.
999      */
1000     function isOwner() public view returns (bool) {
1001         return _msgSender() == _owner;
1002     }
1003 
1004     /**
1005      * @dev Leaves the contract without owner. It will not be possible to call
1006      * `onlyOwner` functions anymore. Can only be called by the current owner.
1007      *
1008      * NOTE: Renouncing ownership will leave the contract without an owner,
1009      * thereby removing any functionality that is only available to the owner.
1010      */
1011     function renounceOwnership() public onlyOwner {
1012         emit OwnershipTransferred(_owner, address(0));
1013         _owner = address(0);
1014     }
1015 
1016     /**
1017      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1018      * Can only be called by the current owner.
1019      */
1020     function transferOwnership(address newOwner) public onlyOwner {
1021         _transferOwnership(newOwner);
1022     }
1023 
1024     /**
1025      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1026      */
1027     function _transferOwnership(address newOwner) internal {
1028         require(newOwner != address(0), "Ownable: new owner is the zero address");
1029         emit OwnershipTransferred(_owner, newOwner);
1030         _owner = newOwner;
1031     }
1032 }
1033 
1034 // Part: ProxyRegistry
1035 
1036 contract ProxyRegistry {
1037     mapping(address => OwnableDelegateProxy) public proxies;
1038 }
1039 
1040 // Part: WhitelistAdminRole
1041 
1042 /**
1043  * @title WhitelistAdminRole
1044  * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
1045  */
1046 contract WhitelistAdminRole is Context {
1047     using Roles for Roles.Role;
1048 
1049     event WhitelistAdminAdded(address indexed account);
1050     event WhitelistAdminRemoved(address indexed account);
1051 
1052     Roles.Role private _whitelistAdmins;
1053 
1054     constructor() internal {
1055         _addWhitelistAdmin(_msgSender());
1056     }
1057 
1058     modifier onlyWhitelistAdmin() {
1059         require(
1060             isWhitelistAdmin(_msgSender()),
1061             "WhitelistAdminRole: caller does not have the WhitelistAdmin role"
1062         );
1063         _;
1064     }
1065 
1066     function isWhitelistAdmin(address account) public view returns (bool) {
1067         return _whitelistAdmins.has(account);
1068     }
1069 
1070     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
1071         _addWhitelistAdmin(account);
1072     }
1073 
1074     function renounceWhitelistAdmin() public {
1075         _removeWhitelistAdmin(_msgSender());
1076     }
1077 
1078     function _addWhitelistAdmin(address account) internal {
1079         _whitelistAdmins.add(account);
1080         emit WhitelistAdminAdded(account);
1081     }
1082 
1083     function _removeWhitelistAdmin(address account) internal {
1084         _whitelistAdmins.remove(account);
1085         emit WhitelistAdminRemoved(account);
1086     }
1087 }
1088 
1089 // Part: ERC1155MintBurn
1090 
1091 /**
1092  * @dev Multi-Fungible Tokens with minting and burning methods. These methods assume
1093  *      a parent contract to be executed as they are `internal` functions
1094  */
1095 contract ERC1155MintBurn is ERC1155 {
1096     /****************************************|
1097   |            Minting Functions           |
1098   |_______________________________________*/
1099 
1100     /**
1101      * @notice Mint _amount of tokens of a given id
1102      * @param _to      The address to mint tokens to
1103      * @param _id      Token id to mint
1104      * @param _amount  The amount to be minted
1105      * @param _data    Data to pass if receiver is contract
1106      */
1107     function _mint(
1108         address _to,
1109         uint256 _id,
1110         uint256 _amount,
1111         bytes memory _data
1112     ) internal {
1113         // Add _amount
1114         balances[_to][_id] = balances[_to][_id].add(_amount);
1115 
1116         // Emit event
1117         emit TransferSingle(msg.sender, address(0x0), _to, _id, _amount);
1118 
1119         // Calling onReceive method if recipient is contract
1120         _callonERC1155Received(address(0x0), _to, _id, _amount, _data);
1121     }
1122 
1123     /**
1124      * @notice Mint tokens for each ids in _ids
1125      * @param _to       The address to mint tokens to
1126      * @param _ids      Array of ids to mint
1127      * @param _amounts  Array of amount of tokens to mint per id
1128      * @param _data    Data to pass if receiver is contract
1129      */
1130     function _batchMint(
1131         address _to,
1132         uint256[] memory _ids,
1133         uint256[] memory _amounts,
1134         bytes memory _data
1135     ) internal {
1136         require(
1137             _ids.length == _amounts.length,
1138             "ERC1155MintBurn#batchMint: INVALID_ARRAYS_LENGTH"
1139         );
1140 
1141         // Number of mints to execute
1142         uint256 nMint = _ids.length;
1143 
1144         // Executing all minting
1145         for (uint256 i = 0; i < nMint; i++) {
1146             // Update storage balance
1147             balances[_to][_ids[i]] = balances[_to][_ids[i]].add(_amounts[i]);
1148         }
1149 
1150         // Emit batch mint event
1151         emit TransferBatch(msg.sender, address(0x0), _to, _ids, _amounts);
1152 
1153         // Calling onReceive method if recipient is contract
1154         _callonERC1155BatchReceived(address(0x0), _to, _ids, _amounts, _data);
1155     }
1156 
1157     /****************************************|
1158   |            Burning Functions           |
1159   |_______________________________________*/
1160 
1161     /**
1162      * @notice Burn _amount of tokens of a given token id
1163      * @param _from    The address to burn tokens from
1164      * @param _id      Token id to burn
1165      * @param _amount  The amount to be burned
1166      */
1167     function _burn(
1168         address _from,
1169         uint256 _id,
1170         uint256 _amount
1171     ) internal {
1172         //Substract _amount
1173         balances[_from][_id] = balances[_from][_id].sub(_amount);
1174 
1175         // Emit event
1176         emit TransferSingle(msg.sender, _from, address(0x0), _id, _amount);
1177     }
1178 
1179     /**
1180      * @notice Burn tokens of given token id for each (_ids[i], _amounts[i]) pair
1181      * @param _from     The address to burn tokens from
1182      * @param _ids      Array of token ids to burn
1183      * @param _amounts  Array of the amount to be burned
1184      */
1185     function _batchBurn(
1186         address _from,
1187         uint256[] memory _ids,
1188         uint256[] memory _amounts
1189     ) internal {
1190         require(
1191             _ids.length == _amounts.length,
1192             "ERC1155MintBurn#batchBurn: INVALID_ARRAYS_LENGTH"
1193         );
1194 
1195         // Number of mints to execute
1196         uint256 nBurn = _ids.length;
1197 
1198         // Executing all minting
1199         for (uint256 i = 0; i < nBurn; i++) {
1200             // Update storage balance
1201             balances[_from][_ids[i]] = balances[_from][_ids[i]].sub(
1202                 _amounts[i]
1203             );
1204         }
1205 
1206         // Emit batch mint event
1207         emit TransferBatch(msg.sender, _from, address(0x0), _ids, _amounts);
1208     }
1209 }
1210 
1211 // Part: ERC1155Tradable
1212 
1213 /**
1214  * @title ERC1155Tradable
1215  * ERC1155Tradable - ERC1155 contract that whitelists an operator address, 
1216  * has create and mint functionality, and supports useful standards from OpenZeppelin,
1217   like _exists(), name(), symbol(), and totalSupply()
1218  */
1219 contract ERC1155Tradable is
1220     ERC1155,
1221     ERC1155MintBurn,
1222     ERC1155Metadata,
1223     Ownable,
1224     MinterRole,
1225     WhitelistAdminRole
1226 {
1227     using Strings for string;
1228 
1229     address proxyRegistryAddress;
1230     uint256 private _currentTokenID = 0;
1231     mapping(uint256 => address) public creators;
1232     mapping(uint256 => uint256) public tokenSupply;
1233     mapping(uint256 => uint256) public tokenMaxSupply;
1234     // Contract name
1235     string public name;
1236     // Contract symbol
1237     string public symbol;
1238 
1239     constructor(
1240         string memory _name,
1241         string memory _symbol,
1242         address _proxyRegistryAddress
1243     ) public {
1244         name = _name;
1245         symbol = _symbol;
1246         proxyRegistryAddress = _proxyRegistryAddress;
1247     }
1248 
1249     function removeWhitelistAdmin(address account) public onlyOwner {
1250         _removeWhitelistAdmin(account);
1251     }
1252 
1253     function removeMinter(address account) public onlyOwner {
1254         _removeMinter(account);
1255     }
1256 
1257     function uri(uint256 _id) public view returns (string memory) {
1258         require(_exists(_id), "ERC721Tradable#uri: NONEXISTENT_TOKEN");
1259         return Strings.strConcat(baseMetadataURI, Strings.uint2str(_id));
1260     }
1261 
1262     /**
1263      * @dev Returns the total quantity for a token ID
1264      * @param _id uint256 ID of the token to query
1265      * @return amount of token in existence
1266      */
1267     function totalSupply(uint256 _id) public view returns (uint256) {
1268         return tokenSupply[_id];
1269     }
1270 
1271     /**
1272      * @dev Returns the max quantity for a token ID
1273      * @param _id uint256 ID of the token to query
1274      * @return amount of token in existence
1275      */
1276     function maxSupply(uint256 _id) public view returns (uint256) {
1277         return tokenMaxSupply[_id];
1278     }
1279 
1280     /**
1281      * @dev Will update the base URL of token's URI
1282      * @param _newBaseMetadataURI New base URL of token's URI
1283      */
1284     function setBaseMetadataURI(string memory _newBaseMetadataURI)
1285         public
1286         onlyWhitelistAdmin
1287     {
1288         _setBaseMetadataURI(_newBaseMetadataURI);
1289     }
1290 
1291     /**
1292      * @dev Creates a new token type and assigns _initialSupply to an address
1293      * @param _maxSupply max supply allowed
1294      * @param _initialSupply Optional amount to supply the first owner
1295      * @param _uri Optional URI for this token type
1296      * @param _data Optional data to pass if receiver is contract
1297      * @return The newly created token ID
1298      */
1299     function create(
1300         uint256 _maxSupply,
1301         uint256 _initialSupply,
1302         string calldata _uri,
1303         bytes calldata _data
1304     ) external onlyWhitelistAdmin returns (uint256 tokenId) {
1305         require(
1306             _initialSupply <= _maxSupply,
1307             "Initial supply cannot be more than max supply"
1308         );
1309         uint256 _id = _getNextTokenID();
1310         _incrementTokenTypeId();
1311         creators[_id] = msg.sender;
1312 
1313         if (bytes(_uri).length > 0) {
1314             emit URI(_uri, _id);
1315         }
1316 
1317         if (_initialSupply != 0) _mint(msg.sender, _id, _initialSupply, _data);
1318         tokenSupply[_id] = _initialSupply;
1319         tokenMaxSupply[_id] = _maxSupply;
1320         return _id;
1321     }
1322 
1323     /**
1324      * @dev Mints some amount of tokens to an address
1325      * @param _to          Address of the future owner of the token
1326      * @param _id          Token ID to mint
1327      * @param _quantity    Amount of tokens to mint
1328      * @param _data        Data to pass if receiver is contract
1329      */
1330     function mint(
1331         address _to,
1332         uint256 _id,
1333         uint256 _quantity,
1334         bytes memory _data
1335     ) public onlyMinter {
1336         uint256 tokenId = _id;
1337         require(
1338             tokenSupply[tokenId] < tokenMaxSupply[tokenId],
1339             "Max supply reached"
1340         );
1341         _mint(_to, _id, _quantity, _data);
1342         tokenSupply[_id] = tokenSupply[_id].add(_quantity);
1343     }
1344 
1345     /**
1346      * Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-free listings.
1347      */
1348     function isApprovedForAll(address _owner, address _operator)
1349         public
1350         view
1351         returns (bool isOperator)
1352     {
1353         // Whitelist OpenSea proxy contract for easy trading.
1354         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1355         if (address(proxyRegistry.proxies(_owner)) == _operator) {
1356             return true;
1357         }
1358 
1359         return ERC1155.isApprovedForAll(_owner, _operator);
1360     }
1361 
1362     /**
1363      * @dev Returns whether the specified token exists by checking to see if it has a creator
1364      * @param _id uint256 ID of the token to query the existence of
1365      * @return bool whether the token exists
1366      */
1367     function _exists(uint256 _id) internal view returns (bool) {
1368         return creators[_id] != address(0);
1369     }
1370 
1371     /**
1372      * @dev calculates the next token ID based on value of _currentTokenID
1373      * @return uint256 for the next token ID
1374      */
1375     function _getNextTokenID() private view returns (uint256) {
1376         return _currentTokenID.add(1);
1377     }
1378 
1379     /**
1380      * @dev increments the value of _currentTokenID
1381      */
1382     function _incrementTokenTypeId() private {
1383         _currentTokenID++;
1384     }
1385 }
1386 
1387 // File: StakeDaoNFT.sol
1388 
1389 /**
1390  * @title Stake Dao NFT Contract
1391  */
1392 contract StakeDaoNFT is ERC1155Tradable {
1393     constructor(address _proxyRegistryAddress)
1394         public
1395         ERC1155Tradable("Stake DAO NFT", "sdNFT", _proxyRegistryAddress)
1396     {
1397         _setBaseMetadataURI(
1398             "https://gateway.pinata.cloud/ipfs/QmZwsoGKw42DxNwnQXKtWiuULSzFrUPCNHUx6yhNgrUMj6/metadata/"
1399         );
1400     }
1401 
1402     function contractURI() public view returns (string memory) {
1403         return
1404             "https://gateway.pinata.cloud/ipfs/Qmc1i37KPdg7Cp8rzjgp3QoCECaEbfoSymCpKG8hF85ENv";
1405     }
1406 }
