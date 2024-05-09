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
297 // Part: OpenZeppelin/openzeppelin-contracts@2.5.1/IERC20
298 
299 /**
300  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
301  * the optional functions; to access them see {ERC20Detailed}.
302  */
303 interface IERC20 {
304     /**
305      * @dev Returns the amount of tokens in existence.
306      */
307     function totalSupply() external view returns (uint256);
308 
309     /**
310      * @dev Returns the amount of tokens owned by `account`.
311      */
312     function balanceOf(address account) external view returns (uint256);
313 
314     /**
315      * @dev Moves `amount` tokens from the caller's account to `recipient`.
316      *
317      * Returns a boolean value indicating whether the operation succeeded.
318      *
319      * Emits a {Transfer} event.
320      */
321     function transfer(address recipient, uint256 amount) external returns (bool);
322 
323     /**
324      * @dev Returns the remaining number of tokens that `spender` will be
325      * allowed to spend on behalf of `owner` through {transferFrom}. This is
326      * zero by default.
327      *
328      * This value changes when {approve} or {transferFrom} are called.
329      */
330     function allowance(address owner, address spender) external view returns (uint256);
331 
332     /**
333      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
334      *
335      * Returns a boolean value indicating whether the operation succeeded.
336      *
337      * IMPORTANT: Beware that changing an allowance with this method brings the risk
338      * that someone may use both the old and the new allowance by unfortunate
339      * transaction ordering. One possible solution to mitigate this race
340      * condition is to first reduce the spender's allowance to 0 and set the
341      * desired value afterwards:
342      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
343      *
344      * Emits an {Approval} event.
345      */
346     function approve(address spender, uint256 amount) external returns (bool);
347 
348     /**
349      * @dev Moves `amount` tokens from `sender` to `recipient` using the
350      * allowance mechanism. `amount` is then deducted from the caller's
351      * allowance.
352      *
353      * Returns a boolean value indicating whether the operation succeeded.
354      *
355      * Emits a {Transfer} event.
356      */
357     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
358 
359     /**
360      * @dev Emitted when `value` tokens are moved from one account (`from`) to
361      * another (`to`).
362      *
363      * Note that `value` may be zero.
364      */
365     event Transfer(address indexed from, address indexed to, uint256 value);
366 
367     /**
368      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
369      * a call to {approve}. `value` is the new allowance.
370      */
371     event Approval(address indexed owner, address indexed spender, uint256 value);
372 }
373 
374 // Part: OpenZeppelin/openzeppelin-contracts@2.5.1/SafeMath
375 
376 /**
377  * @dev Wrappers over Solidity's arithmetic operations with added overflow
378  * checks.
379  *
380  * Arithmetic operations in Solidity wrap on overflow. This can easily result
381  * in bugs, because programmers usually assume that an overflow raises an
382  * error, which is the standard behavior in high level programming languages.
383  * `SafeMath` restores this intuition by reverting the transaction when an
384  * operation overflows.
385  *
386  * Using this library instead of the unchecked operations eliminates an entire
387  * class of bugs, so it's recommended to use it always.
388  */
389 library SafeMath {
390     /**
391      * @dev Returns the addition of two unsigned integers, reverting on
392      * overflow.
393      *
394      * Counterpart to Solidity's `+` operator.
395      *
396      * Requirements:
397      * - Addition cannot overflow.
398      */
399     function add(uint256 a, uint256 b) internal pure returns (uint256) {
400         uint256 c = a + b;
401         require(c >= a, "SafeMath: addition overflow");
402 
403         return c;
404     }
405 
406     /**
407      * @dev Returns the subtraction of two unsigned integers, reverting on
408      * overflow (when the result is negative).
409      *
410      * Counterpart to Solidity's `-` operator.
411      *
412      * Requirements:
413      * - Subtraction cannot overflow.
414      */
415     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
416         return sub(a, b, "SafeMath: subtraction overflow");
417     }
418 
419     /**
420      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
421      * overflow (when the result is negative).
422      *
423      * Counterpart to Solidity's `-` operator.
424      *
425      * Requirements:
426      * - Subtraction cannot overflow.
427      *
428      * _Available since v2.4.0._
429      */
430     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
431         require(b <= a, errorMessage);
432         uint256 c = a - b;
433 
434         return c;
435     }
436 
437     /**
438      * @dev Returns the multiplication of two unsigned integers, reverting on
439      * overflow.
440      *
441      * Counterpart to Solidity's `*` operator.
442      *
443      * Requirements:
444      * - Multiplication cannot overflow.
445      */
446     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
447         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
448         // benefit is lost if 'b' is also tested.
449         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
450         if (a == 0) {
451             return 0;
452         }
453 
454         uint256 c = a * b;
455         require(c / a == b, "SafeMath: multiplication overflow");
456 
457         return c;
458     }
459 
460     /**
461      * @dev Returns the integer division of two unsigned integers. Reverts on
462      * division by zero. The result is rounded towards zero.
463      *
464      * Counterpart to Solidity's `/` operator. Note: this function uses a
465      * `revert` opcode (which leaves remaining gas untouched) while Solidity
466      * uses an invalid opcode to revert (consuming all remaining gas).
467      *
468      * Requirements:
469      * - The divisor cannot be zero.
470      */
471     function div(uint256 a, uint256 b) internal pure returns (uint256) {
472         return div(a, b, "SafeMath: division by zero");
473     }
474 
475     /**
476      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
477      * division by zero. The result is rounded towards zero.
478      *
479      * Counterpart to Solidity's `/` operator. Note: this function uses a
480      * `revert` opcode (which leaves remaining gas untouched) while Solidity
481      * uses an invalid opcode to revert (consuming all remaining gas).
482      *
483      * Requirements:
484      * - The divisor cannot be zero.
485      *
486      * _Available since v2.4.0._
487      */
488     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
489         // Solidity only automatically asserts when dividing by 0
490         require(b > 0, errorMessage);
491         uint256 c = a / b;
492         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
493 
494         return c;
495     }
496 
497     /**
498      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
499      * Reverts when dividing by zero.
500      *
501      * Counterpart to Solidity's `%` operator. This function uses a `revert`
502      * opcode (which leaves remaining gas untouched) while Solidity uses an
503      * invalid opcode to revert (consuming all remaining gas).
504      *
505      * Requirements:
506      * - The divisor cannot be zero.
507      */
508     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
509         return mod(a, b, "SafeMath: modulo by zero");
510     }
511 
512     /**
513      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
514      * Reverts with custom message when dividing by zero.
515      *
516      * Counterpart to Solidity's `%` operator. This function uses a `revert`
517      * opcode (which leaves remaining gas untouched) while Solidity uses an
518      * invalid opcode to revert (consuming all remaining gas).
519      *
520      * Requirements:
521      * - The divisor cannot be zero.
522      *
523      * _Available since v2.4.0._
524      */
525     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
526         require(b != 0, errorMessage);
527         return a % b;
528     }
529 }
530 
531 // Part: OwnableDelegateProxy
532 
533 contract OwnableDelegateProxy {}
534 
535 // Part: Roles
536 
537 /**
538  * @title Roles
539  * @dev Library for managing addresses assigned to a Role.
540  */
541 library Roles {
542     struct Role {
543         mapping(address => bool) bearer;
544     }
545 
546     /**
547      * @dev Give an account access to this role.
548      */
549     function add(Role storage role, address account) internal {
550         require(!has(role, account), "Roles: account already has role");
551         role.bearer[account] = true;
552     }
553 
554     /**
555      * @dev Remove an account's access to this role.
556      */
557     function remove(Role storage role, address account) internal {
558         require(has(role, account), "Roles: account does not have role");
559         role.bearer[account] = false;
560     }
561 
562     /**
563      * @dev Check if an account has this role.
564      * @return bool
565      */
566     function has(Role storage role, address account)
567         internal
568         view
569         returns (bool)
570     {
571         require(account != address(0), "Roles: account is the zero address");
572         return role.bearer[account];
573     }
574 }
575 
576 // Part: Strings
577 
578 library Strings {
579     // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
580     function strConcat(
581         string memory _a,
582         string memory _b,
583         string memory _c,
584         string memory _d,
585         string memory _e
586     ) internal pure returns (string memory) {
587         bytes memory _ba = bytes(_a);
588         bytes memory _bb = bytes(_b);
589         bytes memory _bc = bytes(_c);
590         bytes memory _bd = bytes(_d);
591         bytes memory _be = bytes(_e);
592         string memory abcde =
593             new string(
594                 _ba.length + _bb.length + _bc.length + _bd.length + _be.length
595             );
596         bytes memory babcde = bytes(abcde);
597         uint256 k = 0;
598         for (uint256 i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
599         for (uint256 i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
600         for (uint256 i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
601         for (uint256 i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
602         for (uint256 i = 0; i < _be.length; i++) babcde[k++] = _be[i];
603         return string(babcde);
604     }
605 
606     function strConcat(
607         string memory _a,
608         string memory _b,
609         string memory _c,
610         string memory _d
611     ) internal pure returns (string memory) {
612         return strConcat(_a, _b, _c, _d, "");
613     }
614 
615     function strConcat(
616         string memory _a,
617         string memory _b,
618         string memory _c
619     ) internal pure returns (string memory) {
620         return strConcat(_a, _b, _c, "", "");
621     }
622 
623     function strConcat(string memory _a, string memory _b)
624         internal
625         pure
626         returns (string memory)
627     {
628         return strConcat(_a, _b, "", "", "");
629     }
630 
631     function uint2str(uint256 _i)
632         internal
633         pure
634         returns (string memory _uintAsString)
635     {
636         if (_i == 0) {
637             return "0";
638         }
639         uint256 j = _i;
640         uint256 len;
641         while (j != 0) {
642             len++;
643             j /= 10;
644         }
645         bytes memory bstr = new bytes(len);
646         uint256 k = len - 1;
647         while (_i != 0) {
648             bstr[k--] = bytes1(uint8(48 + (_i % 10)));
649             _i /= 10;
650         }
651         return string(bstr);
652     }
653 }
654 
655 // Part: ERC1155
656 
657 /**
658  * @dev Implementation of Multi-Token Standard contract
659  */
660 contract ERC1155 is IERC165 {
661     using SafeMath for uint256;
662     using Address for address;
663 
664     /***********************************|
665   |        Variables and Events       |
666   |__________________________________*/
667 
668     // onReceive function signatures
669     bytes4 internal constant ERC1155_RECEIVED_VALUE = 0xf23a6e61;
670     bytes4 internal constant ERC1155_BATCH_RECEIVED_VALUE = 0xbc197c81;
671 
672     // Objects balances
673     mapping(address => mapping(uint256 => uint256)) internal balances;
674 
675     // Operator Functions
676     mapping(address => mapping(address => bool)) internal operators;
677 
678     // Events
679     event TransferSingle(
680         address indexed _operator,
681         address indexed _from,
682         address indexed _to,
683         uint256 _id,
684         uint256 _amount
685     );
686     event TransferBatch(
687         address indexed _operator,
688         address indexed _from,
689         address indexed _to,
690         uint256[] _ids,
691         uint256[] _amounts
692     );
693     event ApprovalForAll(
694         address indexed _owner,
695         address indexed _operator,
696         bool _approved
697     );
698     event URI(string _uri, uint256 indexed _id);
699 
700     /***********************************|
701   |     Public Transfer Functions     |
702   |__________________________________*/
703 
704     /**
705      * @notice Transfers amount amount of an _id from the _from address to the _to address specified
706      * @param _from    Source address
707      * @param _to      Target address
708      * @param _id      ID of the token type
709      * @param _amount  Transfered amount
710      * @param _data    Additional data with no specified format, sent in call to `_to`
711      */
712     function safeTransferFrom(
713         address _from,
714         address _to,
715         uint256 _id,
716         uint256 _amount,
717         bytes memory _data
718     ) public {
719         require(
720             (msg.sender == _from) || isApprovedForAll(_from, msg.sender),
721             "ERC1155#safeTransferFrom: INVALID_OPERATOR"
722         );
723         require(
724             _to != address(0),
725             "ERC1155#safeTransferFrom: INVALID_RECIPIENT"
726         );
727         // require(_amount >= balances[_from][_id]) is not necessary since checked with safemath operations
728 
729         _safeTransferFrom(_from, _to, _id, _amount);
730         _callonERC1155Received(_from, _to, _id, _amount, _data);
731     }
732 
733     /**
734      * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
735      * @param _from     Source addresses
736      * @param _to       Target addresses
737      * @param _ids      IDs of each token type
738      * @param _amounts  Transfer amounts per token type
739      * @param _data     Additional data with no specified format, sent in call to `_to`
740      */
741     function safeBatchTransferFrom(
742         address _from,
743         address _to,
744         uint256[] memory _ids,
745         uint256[] memory _amounts,
746         bytes memory _data
747     ) public {
748         // Requirements
749         require(
750             (msg.sender == _from) || isApprovedForAll(_from, msg.sender),
751             "ERC1155#safeBatchTransferFrom: INVALID_OPERATOR"
752         );
753         require(
754             _to != address(0),
755             "ERC1155#safeBatchTransferFrom: INVALID_RECIPIENT"
756         );
757 
758         _safeBatchTransferFrom(_from, _to, _ids, _amounts);
759         _callonERC1155BatchReceived(_from, _to, _ids, _amounts, _data);
760     }
761 
762     /***********************************|
763   |    Internal Transfer Functions    |
764   |__________________________________*/
765 
766     /**
767      * @notice Transfers amount amount of an _id from the _from address to the _to address specified
768      * @param _from    Source address
769      * @param _to      Target address
770      * @param _id      ID of the token type
771      * @param _amount  Transfered amount
772      */
773     function _safeTransferFrom(
774         address _from,
775         address _to,
776         uint256 _id,
777         uint256 _amount
778     ) internal {
779         // Update balances
780         balances[_from][_id] = balances[_from][_id].sub(_amount); // Subtract amount
781         balances[_to][_id] = balances[_to][_id].add(_amount); // Add amount
782 
783         // Emit event
784         emit TransferSingle(msg.sender, _from, _to, _id, _amount);
785     }
786 
787     /**
788      * @notice Verifies if receiver is contract and if so, calls (_to).onERC1155Received(...)
789      */
790     function _callonERC1155Received(
791         address _from,
792         address _to,
793         uint256 _id,
794         uint256 _amount,
795         bytes memory _data
796     ) internal {
797         // Check if recipient is contract
798         if (_to.isContract()) {
799             bytes4 retval =
800                 IERC1155TokenReceiver(_to).onERC1155Received(
801                     msg.sender,
802                     _from,
803                     _id,
804                     _amount,
805                     _data
806                 );
807             require(
808                 retval == ERC1155_RECEIVED_VALUE,
809                 "ERC1155#_callonERC1155Received: INVALID_ON_RECEIVE_MESSAGE"
810             );
811         }
812     }
813 
814     /**
815      * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
816      * @param _from     Source addresses
817      * @param _to       Target addresses
818      * @param _ids      IDs of each token type
819      * @param _amounts  Transfer amounts per token type
820      */
821     function _safeBatchTransferFrom(
822         address _from,
823         address _to,
824         uint256[] memory _ids,
825         uint256[] memory _amounts
826     ) internal {
827         require(
828             _ids.length == _amounts.length,
829             "ERC1155#_safeBatchTransferFrom: INVALID_ARRAYS_LENGTH"
830         );
831 
832         // Number of transfer to execute
833         uint256 nTransfer = _ids.length;
834 
835         // Executing all transfers
836         for (uint256 i = 0; i < nTransfer; i++) {
837             // Update storage balance of previous bin
838             balances[_from][_ids[i]] = balances[_from][_ids[i]].sub(
839                 _amounts[i]
840             );
841             balances[_to][_ids[i]] = balances[_to][_ids[i]].add(_amounts[i]);
842         }
843 
844         // Emit event
845         emit TransferBatch(msg.sender, _from, _to, _ids, _amounts);
846     }
847 
848     /**
849      * @notice Verifies if receiver is contract and if so, calls (_to).onERC1155BatchReceived(...)
850      */
851     function _callonERC1155BatchReceived(
852         address _from,
853         address _to,
854         uint256[] memory _ids,
855         uint256[] memory _amounts,
856         bytes memory _data
857     ) internal {
858         // Pass data if recipient is contract
859         if (_to.isContract()) {
860             bytes4 retval =
861                 IERC1155TokenReceiver(_to).onERC1155BatchReceived(
862                     msg.sender,
863                     _from,
864                     _ids,
865                     _amounts,
866                     _data
867                 );
868             require(
869                 retval == ERC1155_BATCH_RECEIVED_VALUE,
870                 "ERC1155#_callonERC1155BatchReceived: INVALID_ON_RECEIVE_MESSAGE"
871             );
872         }
873     }
874 
875     /***********************************|
876   |         Operator Functions        |
877   |__________________________________*/
878 
879     /**
880      * @notice Enable or disable approval for a third party ("operator") to manage all of caller's tokens
881      * @param _operator  Address to add to the set of authorized operators
882      * @param _approved  True if the operator is approved, false to revoke approval
883      */
884     function setApprovalForAll(address _operator, bool _approved) external {
885         // Update operator status
886         operators[msg.sender][_operator] = _approved;
887         emit ApprovalForAll(msg.sender, _operator, _approved);
888     }
889 
890     /**
891      * @notice Queries the approval status of an operator for a given owner
892      * @param _owner     The owner of the Tokens
893      * @param _operator  Address of authorized operator
894      * @return True if the operator is approved, false if not
895      */
896     function isApprovedForAll(address _owner, address _operator)
897         public
898         view
899         returns (bool isOperator)
900     {
901         return operators[_owner][_operator];
902     }
903 
904     /***********************************|
905   |         Balance Functions         |
906   |__________________________________*/
907 
908     /**
909      * @notice Get the balance of an account's Tokens
910      * @param _owner  The address of the token holder
911      * @param _id     ID of the Token
912      * @return The _owner's balance of the Token type requested
913      */
914     function balanceOf(address _owner, uint256 _id)
915         public
916         view
917         returns (uint256)
918     {
919         return balances[_owner][_id];
920     }
921 
922     /**
923      * @notice Get the balance of multiple account/token pairs
924      * @param _owners The addresses of the token holders
925      * @param _ids    ID of the Tokens
926      * @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)
927      */
928     function balanceOfBatch(address[] memory _owners, uint256[] memory _ids)
929         public
930         view
931         returns (uint256[] memory)
932     {
933         require(
934             _owners.length == _ids.length,
935             "ERC1155#balanceOfBatch: INVALID_ARRAY_LENGTH"
936         );
937 
938         // Variables
939         uint256[] memory batchBalances = new uint256[](_owners.length);
940 
941         // Iterate over each owner and token ID
942         for (uint256 i = 0; i < _owners.length; i++) {
943             batchBalances[i] = balances[_owners[i]][_ids[i]];
944         }
945 
946         return batchBalances;
947     }
948 
949     /***********************************|
950   |          ERC165 Functions         |
951   |__________________________________*/
952 
953     /**
954      * INTERFACE_SIGNATURE_ERC165 = bytes4(keccak256("supportsInterface(bytes4)"));
955      */
956     bytes4 private constant INTERFACE_SIGNATURE_ERC165 = 0x01ffc9a7;
957 
958     /**
959      * INTERFACE_SIGNATURE_ERC1155 =
960      * bytes4(keccak256("safeTransferFrom(address,address,uint256,uint256,bytes)")) ^
961      * bytes4(keccak256("safeBatchTransferFrom(address,address,uint256[],uint256[],bytes)")) ^
962      * bytes4(keccak256("balanceOf(address,uint256)")) ^
963      * bytes4(keccak256("balanceOfBatch(address[],uint256[])")) ^
964      * bytes4(keccak256("setApprovalForAll(address,bool)")) ^
965      * bytes4(keccak256("isApprovedForAll(address,address)"));
966      */
967     bytes4 private constant INTERFACE_SIGNATURE_ERC1155 = 0xd9b67a26;
968 
969     /**
970      * @notice Query if a contract implements an interface
971      * @param _interfaceID  The interface identifier, as specified in ERC-165
972      * @return `true` if the contract implements `_interfaceID` and
973      */
974     function supportsInterface(bytes4 _interfaceID)
975         external
976         view
977         returns (bool)
978     {
979         if (
980             _interfaceID == INTERFACE_SIGNATURE_ERC165 ||
981             _interfaceID == INTERFACE_SIGNATURE_ERC1155
982         ) {
983             return true;
984         }
985         return false;
986     }
987 }
988 
989 // Part: MinterRole
990 
991 contract MinterRole is Context {
992     using Roles for Roles.Role;
993 
994     event MinterAdded(address indexed account);
995     event MinterRemoved(address indexed account);
996 
997     Roles.Role private _minters;
998 
999     constructor() internal {
1000         _addMinter(_msgSender());
1001     }
1002 
1003     modifier onlyMinter() {
1004         require(
1005             isMinter(_msgSender()),
1006             "MinterRole: caller does not have the Minter role"
1007         );
1008         _;
1009     }
1010 
1011     function isMinter(address account) public view returns (bool) {
1012         return _minters.has(account);
1013     }
1014 
1015     function addMinter(address account) public onlyMinter {
1016         _addMinter(account);
1017     }
1018 
1019     function renounceMinter() public {
1020         _removeMinter(_msgSender());
1021     }
1022 
1023     function _addMinter(address account) internal {
1024         _minters.add(account);
1025         emit MinterAdded(account);
1026     }
1027 
1028     function _removeMinter(address account) internal {
1029         _minters.remove(account);
1030         emit MinterRemoved(account);
1031     }
1032 }
1033 
1034 // Part: OpenZeppelin/openzeppelin-contracts@2.5.1/Ownable
1035 
1036 /**
1037  * @dev Contract module which provides a basic access control mechanism, where
1038  * there is an account (an owner) that can be granted exclusive access to
1039  * specific functions.
1040  *
1041  * This module is used through inheritance. It will make available the modifier
1042  * `onlyOwner`, which can be applied to your functions to restrict their use to
1043  * the owner.
1044  */
1045 contract Ownable is Context {
1046     address private _owner;
1047 
1048     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1049 
1050     /**
1051      * @dev Initializes the contract setting the deployer as the initial owner.
1052      */
1053     constructor () internal {
1054         address msgSender = _msgSender();
1055         _owner = msgSender;
1056         emit OwnershipTransferred(address(0), msgSender);
1057     }
1058 
1059     /**
1060      * @dev Returns the address of the current owner.
1061      */
1062     function owner() public view returns (address) {
1063         return _owner;
1064     }
1065 
1066     /**
1067      * @dev Throws if called by any account other than the owner.
1068      */
1069     modifier onlyOwner() {
1070         require(isOwner(), "Ownable: caller is not the owner");
1071         _;
1072     }
1073 
1074     /**
1075      * @dev Returns true if the caller is the current owner.
1076      */
1077     function isOwner() public view returns (bool) {
1078         return _msgSender() == _owner;
1079     }
1080 
1081     /**
1082      * @dev Leaves the contract without owner. It will not be possible to call
1083      * `onlyOwner` functions anymore. Can only be called by the current owner.
1084      *
1085      * NOTE: Renouncing ownership will leave the contract without an owner,
1086      * thereby removing any functionality that is only available to the owner.
1087      */
1088     function renounceOwnership() public onlyOwner {
1089         emit OwnershipTransferred(_owner, address(0));
1090         _owner = address(0);
1091     }
1092 
1093     /**
1094      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1095      * Can only be called by the current owner.
1096      */
1097     function transferOwnership(address newOwner) public onlyOwner {
1098         _transferOwnership(newOwner);
1099     }
1100 
1101     /**
1102      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1103      */
1104     function _transferOwnership(address newOwner) internal {
1105         require(newOwner != address(0), "Ownable: new owner is the zero address");
1106         emit OwnershipTransferred(_owner, newOwner);
1107         _owner = newOwner;
1108     }
1109 }
1110 
1111 // Part: ProxyRegistry
1112 
1113 contract ProxyRegistry {
1114     mapping(address => OwnableDelegateProxy) public proxies;
1115 }
1116 
1117 // Part: StakeTokenWrapper
1118 
1119 contract StakeTokenWrapper {
1120     using SafeMath for uint256;
1121     IERC20 public xsdt;
1122 
1123     constructor(IERC20 _xsdt) public {
1124         xsdt = IERC20(_xsdt);
1125     }
1126 
1127     uint256 private _totalSupply;
1128     mapping(address => uint256) private _balances;
1129 
1130     function totalSupply() public view returns (uint256) {
1131         return _totalSupply;
1132     }
1133 
1134     function balanceOf(address account) public view returns (uint256) {
1135         return _balances[account];
1136     }
1137 
1138     function stake(uint256 amount) public {
1139         _totalSupply = _totalSupply.add(amount);
1140         _balances[msg.sender] = _balances[msg.sender].add(amount);
1141         xsdt.transferFrom(msg.sender, address(this), amount);
1142     }
1143 
1144     function withdraw(uint256 amount) public {
1145         _totalSupply = _totalSupply.sub(amount);
1146         _balances[msg.sender] = _balances[msg.sender].sub(amount);
1147         xsdt.transfer(msg.sender, amount);
1148     }
1149 }
1150 
1151 // Part: WhitelistAdminRole
1152 
1153 /**
1154  * @title WhitelistAdminRole
1155  * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
1156  */
1157 contract WhitelistAdminRole is Context {
1158     using Roles for Roles.Role;
1159 
1160     event WhitelistAdminAdded(address indexed account);
1161     event WhitelistAdminRemoved(address indexed account);
1162 
1163     Roles.Role private _whitelistAdmins;
1164 
1165     constructor() internal {
1166         _addWhitelistAdmin(_msgSender());
1167     }
1168 
1169     modifier onlyWhitelistAdmin() {
1170         require(
1171             isWhitelistAdmin(_msgSender()),
1172             "WhitelistAdminRole: caller does not have the WhitelistAdmin role"
1173         );
1174         _;
1175     }
1176 
1177     function isWhitelistAdmin(address account) public view returns (bool) {
1178         return _whitelistAdmins.has(account);
1179     }
1180 
1181     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
1182         _addWhitelistAdmin(account);
1183     }
1184 
1185     function renounceWhitelistAdmin() public {
1186         _removeWhitelistAdmin(_msgSender());
1187     }
1188 
1189     function _addWhitelistAdmin(address account) internal {
1190         _whitelistAdmins.add(account);
1191         emit WhitelistAdminAdded(account);
1192     }
1193 
1194     function _removeWhitelistAdmin(address account) internal {
1195         _whitelistAdmins.remove(account);
1196         emit WhitelistAdminRemoved(account);
1197     }
1198 }
1199 
1200 // Part: ERC1155MintBurn
1201 
1202 /**
1203  * @dev Multi-Fungible Tokens with minting and burning methods. These methods assume
1204  *      a parent contract to be executed as they are `internal` functions
1205  */
1206 contract ERC1155MintBurn is ERC1155 {
1207     /****************************************|
1208   |            Minting Functions           |
1209   |_______________________________________*/
1210 
1211     /**
1212      * @notice Mint _amount of tokens of a given id
1213      * @param _to      The address to mint tokens to
1214      * @param _id      Token id to mint
1215      * @param _amount  The amount to be minted
1216      * @param _data    Data to pass if receiver is contract
1217      */
1218     function _mint(
1219         address _to,
1220         uint256 _id,
1221         uint256 _amount,
1222         bytes memory _data
1223     ) internal {
1224         // Add _amount
1225         balances[_to][_id] = balances[_to][_id].add(_amount);
1226 
1227         // Emit event
1228         emit TransferSingle(msg.sender, address(0x0), _to, _id, _amount);
1229 
1230         // Calling onReceive method if recipient is contract
1231         _callonERC1155Received(address(0x0), _to, _id, _amount, _data);
1232     }
1233 
1234     /**
1235      * @notice Mint tokens for each ids in _ids
1236      * @param _to       The address to mint tokens to
1237      * @param _ids      Array of ids to mint
1238      * @param _amounts  Array of amount of tokens to mint per id
1239      * @param _data    Data to pass if receiver is contract
1240      */
1241     function _batchMint(
1242         address _to,
1243         uint256[] memory _ids,
1244         uint256[] memory _amounts,
1245         bytes memory _data
1246     ) internal {
1247         require(
1248             _ids.length == _amounts.length,
1249             "ERC1155MintBurn#batchMint: INVALID_ARRAYS_LENGTH"
1250         );
1251 
1252         // Number of mints to execute
1253         uint256 nMint = _ids.length;
1254 
1255         // Executing all minting
1256         for (uint256 i = 0; i < nMint; i++) {
1257             // Update storage balance
1258             balances[_to][_ids[i]] = balances[_to][_ids[i]].add(_amounts[i]);
1259         }
1260 
1261         // Emit batch mint event
1262         emit TransferBatch(msg.sender, address(0x0), _to, _ids, _amounts);
1263 
1264         // Calling onReceive method if recipient is contract
1265         _callonERC1155BatchReceived(address(0x0), _to, _ids, _amounts, _data);
1266     }
1267 
1268     /****************************************|
1269   |            Burning Functions           |
1270   |_______________________________________*/
1271 
1272     /**
1273      * @notice Burn _amount of tokens of a given token id
1274      * @param _from    The address to burn tokens from
1275      * @param _id      Token id to burn
1276      * @param _amount  The amount to be burned
1277      */
1278     function _burn(
1279         address _from,
1280         uint256 _id,
1281         uint256 _amount
1282     ) internal {
1283         //Substract _amount
1284         balances[_from][_id] = balances[_from][_id].sub(_amount);
1285 
1286         // Emit event
1287         emit TransferSingle(msg.sender, _from, address(0x0), _id, _amount);
1288     }
1289 
1290     /**
1291      * @notice Burn tokens of given token id for each (_ids[i], _amounts[i]) pair
1292      * @param _from     The address to burn tokens from
1293      * @param _ids      Array of token ids to burn
1294      * @param _amounts  Array of the amount to be burned
1295      */
1296     function _batchBurn(
1297         address _from,
1298         uint256[] memory _ids,
1299         uint256[] memory _amounts
1300     ) internal {
1301         require(
1302             _ids.length == _amounts.length,
1303             "ERC1155MintBurn#batchBurn: INVALID_ARRAYS_LENGTH"
1304         );
1305 
1306         // Number of mints to execute
1307         uint256 nBurn = _ids.length;
1308 
1309         // Executing all minting
1310         for (uint256 i = 0; i < nBurn; i++) {
1311             // Update storage balance
1312             balances[_from][_ids[i]] = balances[_from][_ids[i]].sub(
1313                 _amounts[i]
1314             );
1315         }
1316 
1317         // Emit batch mint event
1318         emit TransferBatch(msg.sender, _from, address(0x0), _ids, _amounts);
1319     }
1320 }
1321 
1322 // Part: ERC1155Tradable
1323 
1324 /**
1325  * @title ERC1155Tradable
1326  * ERC1155Tradable - ERC1155 contract that whitelists an operator address, 
1327  * has create and mint functionality, and supports useful standards from OpenZeppelin,
1328   like _exists(), name(), symbol(), and totalSupply()
1329  */
1330 contract ERC1155Tradable is
1331     ERC1155,
1332     ERC1155MintBurn,
1333     ERC1155Metadata,
1334     Ownable,
1335     MinterRole,
1336     WhitelistAdminRole
1337 {
1338     using Strings for string;
1339 
1340     address proxyRegistryAddress;
1341     uint256 private _currentTokenID = 0;
1342     mapping(uint256 => address) public creators;
1343     mapping(uint256 => uint256) public tokenSupply;
1344     mapping(uint256 => uint256) public tokenMaxSupply;
1345     // Contract name
1346     string public name;
1347     // Contract symbol
1348     string public symbol;
1349 
1350     constructor(
1351         string memory _name,
1352         string memory _symbol,
1353         address _proxyRegistryAddress
1354     ) public {
1355         name = _name;
1356         symbol = _symbol;
1357         proxyRegistryAddress = _proxyRegistryAddress;
1358     }
1359 
1360     function removeWhitelistAdmin(address account) public onlyOwner {
1361         _removeWhitelistAdmin(account);
1362     }
1363 
1364     function removeMinter(address account) public onlyOwner {
1365         _removeMinter(account);
1366     }
1367 
1368     function uri(uint256 _id) public view returns (string memory) {
1369         require(_exists(_id), "ERC721Tradable#uri: NONEXISTENT_TOKEN");
1370         return Strings.strConcat(baseMetadataURI, Strings.uint2str(_id));
1371     }
1372 
1373     /**
1374      * @dev Returns the total quantity for a token ID
1375      * @param _id uint256 ID of the token to query
1376      * @return amount of token in existence
1377      */
1378     function totalSupply(uint256 _id) public view returns (uint256) {
1379         return tokenSupply[_id];
1380     }
1381 
1382     /**
1383      * @dev Returns the max quantity for a token ID
1384      * @param _id uint256 ID of the token to query
1385      * @return amount of token in existence
1386      */
1387     function maxSupply(uint256 _id) public view returns (uint256) {
1388         return tokenMaxSupply[_id];
1389     }
1390 
1391     /**
1392      * @dev Will update the base URL of token's URI
1393      * @param _newBaseMetadataURI New base URL of token's URI
1394      */
1395     function setBaseMetadataURI(string memory _newBaseMetadataURI)
1396         public
1397         onlyWhitelistAdmin
1398     {
1399         _setBaseMetadataURI(_newBaseMetadataURI);
1400     }
1401 
1402     /**
1403      * @dev Creates a new token type and assigns _initialSupply to an address
1404      * @param _maxSupply max supply allowed
1405      * @param _initialSupply Optional amount to supply the first owner
1406      * @param _uri Optional URI for this token type
1407      * @param _data Optional data to pass if receiver is contract
1408      * @return The newly created token ID
1409      */
1410     function create(
1411         uint256 _maxSupply,
1412         uint256 _initialSupply,
1413         string calldata _uri,
1414         bytes calldata _data
1415     ) external onlyWhitelistAdmin returns (uint256 tokenId) {
1416         require(
1417             _initialSupply <= _maxSupply,
1418             "Initial supply cannot be more than max supply"
1419         );
1420         uint256 _id = _getNextTokenID();
1421         _incrementTokenTypeId();
1422         creators[_id] = msg.sender;
1423 
1424         if (bytes(_uri).length > 0) {
1425             emit URI(_uri, _id);
1426         }
1427 
1428         if (_initialSupply != 0) _mint(msg.sender, _id, _initialSupply, _data);
1429         tokenSupply[_id] = _initialSupply;
1430         tokenMaxSupply[_id] = _maxSupply;
1431         return _id;
1432     }
1433 
1434     /**
1435      * @dev Mints some amount of tokens to an address
1436      * @param _to          Address of the future owner of the token
1437      * @param _id          Token ID to mint
1438      * @param _quantity    Amount of tokens to mint
1439      * @param _data        Data to pass if receiver is contract
1440      */
1441     function mint(
1442         address _to,
1443         uint256 _id,
1444         uint256 _quantity,
1445         bytes memory _data
1446     ) public onlyMinter {
1447         uint256 tokenId = _id;
1448         require(
1449             tokenSupply[tokenId] < tokenMaxSupply[tokenId],
1450             "Max supply reached"
1451         );
1452         _mint(_to, _id, _quantity, _data);
1453         tokenSupply[_id] = tokenSupply[_id].add(_quantity);
1454     }
1455 
1456     /**
1457      * Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-free listings.
1458      */
1459     function isApprovedForAll(address _owner, address _operator)
1460         public
1461         view
1462         returns (bool isOperator)
1463     {
1464         // Whitelist OpenSea proxy contract for easy trading.
1465         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1466         if (address(proxyRegistry.proxies(_owner)) == _operator) {
1467             return true;
1468         }
1469 
1470         return ERC1155.isApprovedForAll(_owner, _operator);
1471     }
1472 
1473     /**
1474      * @dev Returns whether the specified token exists by checking to see if it has a creator
1475      * @param _id uint256 ID of the token to query the existence of
1476      * @return bool whether the token exists
1477      */
1478     function _exists(uint256 _id) internal view returns (bool) {
1479         return creators[_id] != address(0);
1480     }
1481 
1482     /**
1483      * @dev calculates the next token ID based on value of _currentTokenID
1484      * @return uint256 for the next token ID
1485      */
1486     function _getNextTokenID() private view returns (uint256) {
1487         return _currentTokenID.add(1);
1488     }
1489 
1490     /**
1491      * @dev increments the value of _currentTokenID
1492      */
1493     function _incrementTokenTypeId() private {
1494         _currentTokenID++;
1495     }
1496 }
1497 
1498 // File: StakedaoNFTPalace.sol
1499 
1500 contract StakeDaoNFTPalace is StakeTokenWrapper, Ownable {
1501     ERC1155Tradable public nft;
1502 
1503     mapping(address => uint256) public lastUpdateTime;
1504     mapping(address => uint256) public points;
1505     mapping(uint256 => uint256) public cards;
1506 
1507     event CardAdded(uint256 card, uint256 points);
1508     event Staked(address indexed user, uint256 amount);
1509     event Withdrawn(address indexed user, uint256 amount);
1510     event Redeemed(address indexed user, uint256 id);
1511     event NFTSet(ERC1155Tradable indexed newNFT);
1512 
1513     modifier updateReward(address account) {
1514         if (account != address(0)) {
1515             points[account] = earned(account);
1516             lastUpdateTime[account] = block.timestamp;
1517         }
1518         _;
1519     }
1520 
1521     constructor(ERC1155Tradable _nftAddress, IERC20 _xsdt)
1522         public
1523         StakeTokenWrapper(_xsdt)
1524     {
1525         nft = _nftAddress;
1526     }
1527 
1528     function setNFT(ERC1155Tradable _nftAddress) public onlyOwner {
1529         nft = _nftAddress;
1530         emit NFTSet(_nftAddress);
1531     }
1532 
1533     function addCard(uint256 cardId, uint256 amount) public onlyOwner {
1534         cards[cardId] = amount;
1535         emit CardAdded(cardId, amount);
1536     }
1537 
1538     function earned(address account) public view returns (uint256) {
1539         uint256 timeDifference = block.timestamp.sub(lastUpdateTime[account]);
1540         uint256 balance = balanceOf(account);
1541         uint256 decimals = 1e18;
1542         uint256 x = balance / decimals;
1543         uint256 ratePerMin = decimals.mul(x).div(x.add(12000)).div(240);
1544         return points[account].add(ratePerMin.mul(timeDifference));
1545     }
1546 
1547     // stake visibility is public as overriding StakeTokenWrapper's stake() function
1548     function stake(uint256 amount) public updateReward(msg.sender) {
1549         require(amount > 0, "Invalid amount");
1550 
1551         super.stake(amount);
1552         emit Staked(msg.sender, amount);
1553     }
1554 
1555     function withdraw(uint256 amount) public updateReward(msg.sender) {
1556         require(amount > 0, "Cannot withdraw 0");
1557 
1558         super.withdraw(amount);
1559         emit Withdrawn(msg.sender, amount);
1560     }
1561 
1562     function exit() external {
1563         withdraw(balanceOf(msg.sender));
1564     }
1565 
1566     function redeem(uint256 card) public updateReward(msg.sender) {
1567         require(cards[card] != 0, "Card not found");
1568         require(
1569             points[msg.sender] >= cards[card],
1570             "Not enough points to redeem for card"
1571         );
1572         require(
1573             nft.totalSupply(card) < nft.maxSupply(card),
1574             "Max cards minted"
1575         );
1576 
1577         points[msg.sender] = points[msg.sender].sub(cards[card]);
1578         nft.mint(msg.sender, card, 1, "");
1579         emit Redeemed(msg.sender, card);
1580     }
1581 }
