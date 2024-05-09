1 pragma solidity ^0.6.6;
2 
3 
4 // SPDX-License-Identifier: MIT
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
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address payable) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes memory) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 // SPDX-License-Identifier: MIT
27 /**
28  * @dev Contract module which provides a basic access control mechanism, where
29  * there is an account (an owner) that can be granted exclusive access to
30  * specific functions.
31  *
32  * By default, the owner account will be the one that deploys the contract. This
33  * can later be changed with {transferOwnership}.
34  *
35  * This module is used through inheritance. It will make available the modifier
36  * `onlyOwner`, which can be applied to your functions to restrict their use to
37  * the owner.
38  */
39 abstract contract Ownable is Context {
40     address private _owner;
41 
42     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44     /**
45      * @dev Initializes the contract setting the deployer as the initial owner.
46      */
47     constructor () internal {
48         address msgSender = _msgSender();
49         _owner = msgSender;
50         emit OwnershipTransferred(address(0), msgSender);
51     }
52 
53     /**
54      * @dev Returns the address of the current owner.
55      */
56     function owner() public view returns (address) {
57         return _owner;
58     }
59 
60     /**
61      * @dev Throws if called by any account other than the owner.
62      */
63     modifier onlyOwner() {
64         require(_owner == _msgSender(), "Ownable: caller is not the owner");
65         _;
66     }
67 
68     /**
69      * @dev Leaves the contract without owner. It will not be possible to call
70      * `onlyOwner` functions anymore. Can only be called by the current owner.
71      *
72      * NOTE: Renouncing ownership will leave the contract without an owner,
73      * thereby removing any functionality that is only available to the owner.
74      */
75     function renounceOwnership() public virtual onlyOwner {
76         emit OwnershipTransferred(_owner, address(0));
77         _owner = address(0);
78     }
79 
80     /**
81      * @dev Transfers ownership of the contract to a new account (`newOwner`).
82      * Can only be called by the current owner.
83      */
84     function transferOwnership(address newOwner) public virtual onlyOwner {
85         require(newOwner != address(0), "Ownable: new owner is the zero address");
86         emit OwnershipTransferred(_owner, newOwner);
87         _owner = newOwner;
88     }
89 }
90 
91 // SPDX-License-Identifier: MIT
92 /**
93  * @dev Wrappers over Solidity's arithmetic operations with added overflow
94  * checks.
95  *
96  * Arithmetic operations in Solidity wrap on overflow. This can easily result
97  * in bugs, because programmers usually assume that an overflow raises an
98  * error, which is the standard behavior in high level programming languages.
99  * `SafeMath` restores this intuition by reverting the transaction when an
100  * operation overflows.
101  *
102  * Using this library instead of the unchecked operations eliminates an entire
103  * class of bugs, so it's recommended to use it always.
104  */
105 library SafeMath {
106     /**
107      * @dev Returns the addition of two unsigned integers, reverting on
108      * overflow.
109      *
110      * Counterpart to Solidity's `+` operator.
111      *
112      * Requirements:
113      *
114      * - Addition cannot overflow.
115      */
116     function add(uint256 a, uint256 b) internal pure returns (uint256) {
117         uint256 c = a + b;
118         require(c >= a, "SafeMath: addition overflow");
119 
120         return c;
121     }
122 
123     /**
124      * @dev Returns the subtraction of two unsigned integers, reverting on
125      * overflow (when the result is negative).
126      *
127      * Counterpart to Solidity's `-` operator.
128      *
129      * Requirements:
130      *
131      * - Subtraction cannot overflow.
132      */
133     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
134         return sub(a, b, "SafeMath: subtraction overflow");
135     }
136 
137     /**
138      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
139      * overflow (when the result is negative).
140      *
141      * Counterpart to Solidity's `-` operator.
142      *
143      * Requirements:
144      *
145      * - Subtraction cannot overflow.
146      */
147     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
148         require(b <= a, errorMessage);
149         uint256 c = a - b;
150 
151         return c;
152     }
153 
154     /**
155      * @dev Returns the multiplication of two unsigned integers, reverting on
156      * overflow.
157      *
158      * Counterpart to Solidity's `*` operator.
159      *
160      * Requirements:
161      *
162      * - Multiplication cannot overflow.
163      */
164     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
165         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
166         // benefit is lost if 'b' is also tested.
167         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
168         if (a == 0) {
169             return 0;
170         }
171 
172         uint256 c = a * b;
173         require(c / a == b, "SafeMath: multiplication overflow");
174 
175         return c;
176     }
177 
178     /**
179      * @dev Returns the integer division of two unsigned integers. Reverts on
180      * division by zero. The result is rounded towards zero.
181      *
182      * Counterpart to Solidity's `/` operator. Note: this function uses a
183      * `revert` opcode (which leaves remaining gas untouched) while Solidity
184      * uses an invalid opcode to revert (consuming all remaining gas).
185      *
186      * Requirements:
187      *
188      * - The divisor cannot be zero.
189      */
190     function div(uint256 a, uint256 b) internal pure returns (uint256) {
191         return div(a, b, "SafeMath: division by zero");
192     }
193 
194     /**
195      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
196      * division by zero. The result is rounded towards zero.
197      *
198      * Counterpart to Solidity's `/` operator. Note: this function uses a
199      * `revert` opcode (which leaves remaining gas untouched) while Solidity
200      * uses an invalid opcode to revert (consuming all remaining gas).
201      *
202      * Requirements:
203      *
204      * - The divisor cannot be zero.
205      */
206     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
207         require(b > 0, errorMessage);
208         uint256 c = a / b;
209         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
210 
211         return c;
212     }
213 
214     /**
215      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
216      * Reverts when dividing by zero.
217      *
218      * Counterpart to Solidity's `%` operator. This function uses a `revert`
219      * opcode (which leaves remaining gas untouched) while Solidity uses an
220      * invalid opcode to revert (consuming all remaining gas).
221      *
222      * Requirements:
223      *
224      * - The divisor cannot be zero.
225      */
226     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
227         return mod(a, b, "SafeMath: modulo by zero");
228     }
229 
230     /**
231      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
232      * Reverts with custom message when dividing by zero.
233      *
234      * Counterpart to Solidity's `%` operator. This function uses a `revert`
235      * opcode (which leaves remaining gas untouched) while Solidity uses an
236      * invalid opcode to revert (consuming all remaining gas).
237      *
238      * Requirements:
239      *
240      * - The divisor cannot be zero.
241      */
242     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
243         require(b != 0, errorMessage);
244         return a % b;
245     }
246 }
247 
248 // SPDX-License-Identifier: MIT
249 /**
250  * @dev Collection of functions related to the address type
251  */
252 library Address {
253     /**
254      * @dev Returns true if `account` is a contract.
255      *
256      * [IMPORTANT]
257      * ====
258      * It is unsafe to assume that an address for which this function returns
259      * false is an externally-owned account (EOA) and not a contract.
260      *
261      * Among others, `isContract` will return false for the following
262      * types of addresses:
263      *
264      *  - an externally-owned account
265      *  - a contract in construction
266      *  - an address where a contract will be created
267      *  - an address where a contract lived, but was destroyed
268      * ====
269      */
270     function isContract(address account) internal view returns (bool) {
271         // This method relies on extcodesize, which returns 0 for contracts in
272         // construction, since the code is only stored at the end of the
273         // constructor execution.
274 
275         uint256 size;
276         // solhint-disable-next-line no-inline-assembly
277         assembly { size := extcodesize(account) }
278         return size > 0;
279     }
280 
281     /**
282      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
283      * `recipient`, forwarding all available gas and reverting on errors.
284      *
285      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
286      * of certain opcodes, possibly making contracts go over the 2300 gas limit
287      * imposed by `transfer`, making them unable to receive funds via
288      * `transfer`. {sendValue} removes this limitation.
289      *
290      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
291      *
292      * IMPORTANT: because control is transferred to `recipient`, care must be
293      * taken to not create reentrancy vulnerabilities. Consider using
294      * {ReentrancyGuard} or the
295      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
296      */
297     function sendValue(address payable recipient, uint256 amount) internal {
298         require(address(this).balance >= amount, "Address: insufficient balance");
299 
300         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
301         (bool success, ) = recipient.call{ value: amount }("");
302         require(success, "Address: unable to send value, recipient may have reverted");
303     }
304 
305     /**
306      * @dev Performs a Solidity function call using a low level `call`. A
307      * plain`call` is an unsafe replacement for a function call: use this
308      * function instead.
309      *
310      * If `target` reverts with a revert reason, it is bubbled up by this
311      * function (like regular Solidity function calls).
312      *
313      * Returns the raw returned data. To convert to the expected return value,
314      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
315      *
316      * Requirements:
317      *
318      * - `target` must be a contract.
319      * - calling `target` with `data` must not revert.
320      *
321      * _Available since v3.1._
322      */
323     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
324       return functionCall(target, data, "Address: low-level call failed");
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
329      * `errorMessage` as a fallback revert reason when `target` reverts.
330      *
331      * _Available since v3.1._
332      */
333     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
334         return functionCallWithValue(target, data, 0, errorMessage);
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
339      * but also transferring `value` wei to `target`.
340      *
341      * Requirements:
342      *
343      * - the calling contract must have an ETH balance of at least `value`.
344      * - the called Solidity function must be `payable`.
345      *
346      * _Available since v3.1._
347      */
348     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
349         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
354      * with `errorMessage` as a fallback revert reason when `target` reverts.
355      *
356      * _Available since v3.1._
357      */
358     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
359         require(address(this).balance >= value, "Address: insufficient balance for call");
360         require(isContract(target), "Address: call to non-contract");
361 
362         // solhint-disable-next-line avoid-low-level-calls
363         (bool success, bytes memory returndata) = target.call{ value: value }(data);
364         return _verifyCallResult(success, returndata, errorMessage);
365     }
366 
367     /**
368      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
369      * but performing a static call.
370      *
371      * _Available since v3.3._
372      */
373     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
374         return functionStaticCall(target, data, "Address: low-level static call failed");
375     }
376 
377     /**
378      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
379      * but performing a static call.
380      *
381      * _Available since v3.3._
382      */
383     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
384         require(isContract(target), "Address: static call to non-contract");
385 
386         // solhint-disable-next-line avoid-low-level-calls
387         (bool success, bytes memory returndata) = target.staticcall(data);
388         return _verifyCallResult(success, returndata, errorMessage);
389     }
390 
391     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
392         if (success) {
393             return returndata;
394         } else {
395             // Look for revert reason and bubble it up if present
396             if (returndata.length > 0) {
397                 // The easiest way to bubble the revert reason is using memory via assembly
398 
399                 // solhint-disable-next-line no-inline-assembly
400                 assembly {
401                     let returndata_size := mload(returndata)
402                     revert(add(32, returndata), returndata_size)
403                 }
404             } else {
405                 revert(errorMessage);
406             }
407         }
408     }
409 }
410 
411 // SPDX-License-Identifier: MIT
412 /**
413  * @dev ERC-1155 interface for accepting safe transfers.
414  */
415 interface IERC1155TokenReceiver {
416   /**
417    * @notice Handle the receipt of a single ERC1155 token type
418    * @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeTransferFrom` after the balance has been updated
419    * This function MAY throw to revert and reject the transfer
420    * Return of other amount than the magic value MUST result in the transaction being reverted
421    * Note: The token contract address is always the message sender
422    * @param _operator  The address which called the `safeTransferFrom` function
423    * @param _from      The address which previously owned the token
424    * @param _id        The id of the token being transferred
425    * @param _amount    The amount of tokens being transferred
426    * @param _data      Additional data with no specified format
427    * @return           `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
428    */
429   function onERC1155Received(
430     address _operator,
431     address _from,
432     uint256 _id,
433     uint256 _amount,
434     bytes calldata _data
435   ) external returns (bytes4);
436 
437   /**
438    * @notice Handle the receipt of multiple ERC1155 token types
439    * @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeBatchTransferFrom` after the balances have been updated
440    * This function MAY throw to revert and reject the transfer
441    * Return of other amount than the magic value WILL result in the transaction being reverted
442    * Note: The token contract address is always the message sender
443    * @param _operator  The address which called the `safeBatchTransferFrom` function
444    * @param _from      The address which previously owned the token
445    * @param _ids       An array containing ids of each token being transferred
446    * @param _amounts   An array containing amounts of each token being transferred
447    * @param _data      Additional data with no specified format
448    * @return           `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
449    */
450   function onERC1155BatchReceived(
451     address _operator,
452     address _from,
453     uint256[] calldata _ids,
454     uint256[] calldata _amounts,
455     bytes calldata _data
456   ) external returns (bytes4);
457 
458   /**
459    * @notice Indicates whether a contract implements the `ERC1155TokenReceiver` functions and so can accept ERC1155 token types.
460    * @param  interfaceID The ERC-165 interface ID that is queried for support.s
461    * @dev This function MUST return true if it implements the ERC1155TokenReceiver interface and ERC-165 interface.
462    *      This function MUST NOT consume more than 5,000 gas.
463    * @return Wheter ERC-165 or ERC1155TokenReceiver interfaces are supported.
464    */
465   function supportsInterface(bytes4 interfaceID) external view returns (bool);
466 }
467 
468 // SPDX-License-Identifier: MIT
469 /**
470  * @title ERC165
471  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
472  */
473 interface IERC165 {
474   /**
475    * @notice Query if a contract implements an interface
476    * @dev Interface identification is specified in ERC-165. This function
477    * uses less than 30,000 gas
478    * @param _interfaceId The interface identifier, as specified in ERC-165
479    */
480   function supportsInterface(bytes4 _interfaceId) external view returns (bool);
481 }
482 
483 // SPDX-License-Identifier: MIT
484 /**
485  * @dev Implementation of Multi-Token Standard contract
486  */
487 contract ERC1155 is IERC165 {
488   using SafeMath for uint256;
489   using Address for address;
490 
491   /***********************************|
492   |        Variables and Events       |
493   |__________________________________*/
494 
495   // onReceive function signatures
496   bytes4 internal constant ERC1155_RECEIVED_VALUE = 0xf23a6e61;
497   bytes4 internal constant ERC1155_BATCH_RECEIVED_VALUE = 0xbc197c81;
498 
499   // Objects balances
500   mapping(address => mapping(uint256 => uint256)) internal balances;
501 
502   // Operator Functions
503   mapping(address => mapping(address => bool)) internal operators;
504 
505   // Events
506   event TransferSingle(
507     address indexed _operator,
508     address indexed _from,
509     address indexed _to,
510     uint256 _id,
511     uint256 _amount
512   );
513   event TransferBatch(
514     address indexed _operator,
515     address indexed _from,
516     address indexed _to,
517     uint256[] _ids,
518     uint256[] _amounts
519   );
520   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
521   event URI(string _uri, uint256 indexed _id);
522 
523   /***********************************|
524   |     Public Transfer Functions     |
525   |__________________________________*/
526 
527   /**
528    * @notice Transfers amount amount of an _id from the _from address to the _to address specified
529    * @param _from    Source address
530    * @param _to      Target address
531    * @param _id      ID of the token type
532    * @param _amount  Transfered amount
533    * @param _data    Additional data with no specified format, sent in call to `_to`
534    */
535   function safeTransferFrom(
536     address _from,
537     address _to,
538     uint256 _id,
539     uint256 _amount,
540     bytes memory _data
541   ) public {
542     require((msg.sender == _from) || isApprovedForAll(_from, msg.sender), "ERC1155#safeTransferFrom: INVALID_OPERATOR");
543     require(_to != address(0), "ERC1155#safeTransferFrom: INVALID_RECIPIENT");
544     // require(_amount >= balances[_from][_id]) is not necessary since checked with safemath operations
545 
546     _safeTransferFrom(_from, _to, _id, _amount);
547     _callonERC1155Received(_from, _to, _id, _amount, _data);
548   }
549 
550   /**
551    * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
552    * @param _from     Source addresses
553    * @param _to       Target addresses
554    * @param _ids      IDs of each token type
555    * @param _amounts  Transfer amounts per token type
556    * @param _data     Additional data with no specified format, sent in call to `_to`
557    */
558   function safeBatchTransferFrom(
559     address _from,
560     address _to,
561     uint256[] memory _ids,
562     uint256[] memory _amounts,
563     bytes memory _data
564   ) public {
565     // Requirements
566     require(
567       (msg.sender == _from) || isApprovedForAll(_from, msg.sender),
568       "ERC1155#safeBatchTransferFrom: INVALID_OPERATOR"
569     );
570     require(_to != address(0), "ERC1155#safeBatchTransferFrom: INVALID_RECIPIENT");
571 
572     _safeBatchTransferFrom(_from, _to, _ids, _amounts);
573     _callonERC1155BatchReceived(_from, _to, _ids, _amounts, _data);
574   }
575 
576   /***********************************|
577   |    Internal Transfer Functions    |
578   |__________________________________*/
579 
580   /**
581    * @notice Transfers amount amount of an _id from the _from address to the _to address specified
582    * @param _from    Source address
583    * @param _to      Target address
584    * @param _id      ID of the token type
585    * @param _amount  Transfered amount
586    */
587   function _safeTransferFrom(
588     address _from,
589     address _to,
590     uint256 _id,
591     uint256 _amount
592   ) internal {
593     // Update balances
594     balances[_from][_id] = balances[_from][_id].sub(_amount); // Subtract amount
595     balances[_to][_id] = balances[_to][_id].add(_amount); // Add amount
596 
597     // Emit event
598     emit TransferSingle(msg.sender, _from, _to, _id, _amount);
599   }
600 
601   /**
602    * @notice Verifies if receiver is contract and if so, calls (_to).onERC1155Received(...)
603    */
604   function _callonERC1155Received(
605     address _from,
606     address _to,
607     uint256 _id,
608     uint256 _amount,
609     bytes memory _data
610   ) internal {
611     // Check if recipient is contract
612     if (_to.isContract()) {
613       bytes4 retval = IERC1155TokenReceiver(_to).onERC1155Received(msg.sender, _from, _id, _amount, _data);
614       require(retval == ERC1155_RECEIVED_VALUE, "ERC1155#_callonERC1155Received: INVALID_ON_RECEIVE_MESSAGE");
615     }
616   }
617 
618   /**
619    * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
620    * @param _from     Source addresses
621    * @param _to       Target addresses
622    * @param _ids      IDs of each token type
623    * @param _amounts  Transfer amounts per token type
624    */
625   function _safeBatchTransferFrom(
626     address _from,
627     address _to,
628     uint256[] memory _ids,
629     uint256[] memory _amounts
630   ) internal {
631     require(_ids.length == _amounts.length, "ERC1155#_safeBatchTransferFrom: INVALID_ARRAYS_LENGTH");
632 
633     // Number of transfer to execute
634     uint256 nTransfer = _ids.length;
635 
636     // Executing all transfers
637     for (uint256 i = 0; i < nTransfer; i++) {
638       // Update storage balance of previous bin
639       balances[_from][_ids[i]] = balances[_from][_ids[i]].sub(_amounts[i]);
640       balances[_to][_ids[i]] = balances[_to][_ids[i]].add(_amounts[i]);
641     }
642 
643     // Emit event
644     emit TransferBatch(msg.sender, _from, _to, _ids, _amounts);
645   }
646 
647   /**
648    * @notice Verifies if receiver is contract and if so, calls (_to).onERC1155BatchReceived(...)
649    */
650   function _callonERC1155BatchReceived(
651     address _from,
652     address _to,
653     uint256[] memory _ids,
654     uint256[] memory _amounts,
655     bytes memory _data
656   ) internal {
657     // Pass data if recipient is contract
658     if (_to.isContract()) {
659       bytes4 retval = IERC1155TokenReceiver(_to).onERC1155BatchReceived(msg.sender, _from, _ids, _amounts, _data);
660       require(
661         retval == ERC1155_BATCH_RECEIVED_VALUE,
662         "ERC1155#_callonERC1155BatchReceived: INVALID_ON_RECEIVE_MESSAGE"
663       );
664     }
665   }
666 
667   /***********************************|
668   |         Operator Functions        |
669   |__________________________________*/
670 
671   /**
672    * @notice Enable or disable approval for a third party ("operator") to manage all of caller's tokens
673    * @param _operator  Address to add to the set of authorized operators
674    * @param _approved  True if the operator is approved, false to revoke approval
675    */
676   function setApprovalForAll(address _operator, bool _approved) external {
677     // Update operator status
678     operators[msg.sender][_operator] = _approved;
679     emit ApprovalForAll(msg.sender, _operator, _approved);
680   }
681 
682   /**
683    * @notice Queries the approval status of an operator for a given owner
684    * @param _owner     The owner of the Tokens
685    * @param _operator  Address of authorized operator
686    * @return isOperator True if the operator is approved, false if not
687    */
688   function isApprovedForAll(address _owner, address _operator) public view virtual returns (bool isOperator) {
689     return operators[_owner][_operator];
690   }
691 
692   /***********************************|
693   |         Balance Functions         |
694   |__________________________________*/
695 
696   /**
697    * @notice Get the balance of an account's Tokens
698    * @param _owner  The address of the token holder
699    * @param _id     ID of the Token
700    * @return The _owner's balance of the Token type requested
701    */
702   function balanceOf(address _owner, uint256 _id) public view returns (uint256) {
703     return balances[_owner][_id];
704   }
705 
706   /**
707    * @notice Get the balance of multiple account/token pairs
708    * @param _owners The addresses of the token holders
709    * @param _ids    ID of the Tokens
710    * @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)
711    */
712   function balanceOfBatch(address[] memory _owners, uint256[] memory _ids) public view returns (uint256[] memory) {
713     require(_owners.length == _ids.length, "ERC1155#balanceOfBatch: INVALID_ARRAY_LENGTH");
714 
715     // Variables
716     uint256[] memory batchBalances = new uint256[](_owners.length);
717 
718     // Iterate over each owner and token ID
719     for (uint256 i = 0; i < _owners.length; i++) {
720       batchBalances[i] = balances[_owners[i]][_ids[i]];
721     }
722 
723     return batchBalances;
724   }
725 
726   /***********************************|
727   |          ERC165 Functions         |
728   |__________________________________*/
729 
730   /**
731    * INTERFACE_SIGNATURE_ERC165 = bytes4(keccak256("supportsInterface(bytes4)"));
732    */
733   bytes4 private constant INTERFACE_SIGNATURE_ERC165 = 0x01ffc9a7;
734 
735   /**
736    * INTERFACE_SIGNATURE_ERC1155 =
737    * bytes4(keccak256("safeTransferFrom(address,address,uint256,uint256,bytes)")) ^
738    * bytes4(keccak256("safeBatchTransferFrom(address,address,uint256[],uint256[],bytes)")) ^
739    * bytes4(keccak256("balanceOf(address,uint256)")) ^
740    * bytes4(keccak256("balanceOfBatch(address[],uint256[])")) ^
741    * bytes4(keccak256("setApprovalForAll(address,bool)")) ^
742    * bytes4(keccak256("isApprovedForAll(address,address)"));
743    */
744   bytes4 private constant INTERFACE_SIGNATURE_ERC1155 = 0xd9b67a26;
745 
746   /**
747    * @notice Query if a contract implements an interface
748    * @param _interfaceID  The interface identifier, as specified in ERC-165
749    * @return `true` if the contract implements `_interfaceID` and
750    */
751   function supportsInterface(bytes4 _interfaceID) external view override(IERC165) returns (bool) {
752     if (_interfaceID == INTERFACE_SIGNATURE_ERC165 || _interfaceID == INTERFACE_SIGNATURE_ERC1155) {
753       return true;
754     }
755     return false;
756   }
757 }
758 
759 // SPDX-License-Identifier: MIT
760 /**
761  * @notice Contract that handles metadata related methods.
762  * @dev Methods assume a deterministic generation of URI based on token IDs.
763  *      Methods also assume that URI uses hex representation of token IDs.
764  */
765 contract ERC1155Metadata {
766   // URI's default URI prefix
767   string internal baseMetadataURI;
768   event URI(string _uri, uint256 indexed _id);
769 
770   /***********************************|
771   |     Metadata Public Function s    |
772   |__________________________________*/
773 
774   /**
775    * @notice A distinct Uniform Resource Identifier (URI) for a given token.
776    * @dev URIs are defined in RFC 3986.
777    *      URIs are assumed to be deterministically generated based on token ID
778    *      Token IDs are assumed to be represented in their hex format in URIs
779    * @return URI string
780    */
781   function uri(uint256 _id) public view virtual returns (string memory) {
782     return string(abi.encodePacked(baseMetadataURI, _uint2str(_id), ".json"));
783   }
784 
785   /***********************************|
786   |    Metadata Internal Functions    |
787   |__________________________________*/
788 
789   /**
790    * @notice Will emit default URI log event for corresponding token _id
791    * @param _tokenIDs Array of IDs of tokens to log default URI
792    */
793   function _logURIs(uint256[] memory _tokenIDs) internal {
794     string memory baseURL = baseMetadataURI;
795     string memory tokenURI;
796 
797     for (uint256 i = 0; i < _tokenIDs.length; i++) {
798       tokenURI = string(abi.encodePacked(baseURL, _uint2str(_tokenIDs[i]), ".json"));
799       emit URI(tokenURI, _tokenIDs[i]);
800     }
801   }
802 
803   /**
804    * @notice Will emit a specific URI log event for corresponding token
805    * @param _tokenIDs IDs of the token corresponding to the _uris logged
806    * @param _URIs    The URIs of the specified _tokenIDs
807    */
808   function _logURIs(uint256[] memory _tokenIDs, string[] memory _URIs) internal {
809     require(_tokenIDs.length == _URIs.length, "ERC1155Metadata#_logURIs: INVALID_ARRAYS_LENGTH");
810     for (uint256 i = 0; i < _tokenIDs.length; i++) {
811       emit URI(_URIs[i], _tokenIDs[i]);
812     }
813   }
814 
815   /**
816    * @notice Will update the base URL of token's URI
817    * @param _newBaseMetadataURI New base URL of token's URI
818    */
819   function _setBaseMetadataURI(string memory _newBaseMetadataURI) internal {
820     baseMetadataURI = _newBaseMetadataURI;
821   }
822 
823   /***********************************|
824   |    Utility Internal Functions     |
825   |__________________________________*/
826 
827   /**
828    * @notice Convert uint256 to string
829    * @param _i Unsigned integer to convert to string
830    */
831   function _uint2str(uint256 _i) internal pure returns (string memory _uintAsString) {
832     if (_i == 0) {
833       return "0";
834     }
835 
836     uint256 j = _i;
837     uint256 ii = _i;
838     uint256 len;
839 
840     // Get number of bytes
841     while (j != 0) {
842       len++;
843       j /= 10;
844     }
845 
846     bytes memory bstr = new bytes(len);
847     uint256 k = len - 1;
848 
849     // Get each individual ASCII
850     while (ii != 0) {
851       bstr[k--] = bytes1(uint8(48 + (ii % 10)));
852       ii /= 10;
853     }
854 
855     // Convert to string
856     return string(bstr);
857   }
858 }
859 
860 // SPDX-License-Identifier: MIT
861 /**
862  * @dev Multi-Fungible Tokens with minting and burning methods. These methods assume
863  *      a parent contract to be executed as they are `internal` functions
864  */
865 contract ERC1155MintBurn is ERC1155 {
866   /****************************************|
867   |            Minting Functions           |
868   |_______________________________________*/
869 
870   /**
871    * @notice Mint _amount of tokens of a given id
872    * @param _to      The address to mint tokens to
873    * @param _id      Token id to mint
874    * @param _amount  The amount to be minted
875    * @param _data    Data to pass if receiver is contract
876    */
877   function _mint(
878     address _to,
879     uint256 _id,
880     uint256 _amount,
881     bytes memory _data
882   ) internal {
883     // Add _amount
884     balances[_to][_id] = balances[_to][_id].add(_amount);
885 
886     // Emit event
887     emit TransferSingle(msg.sender, address(0x0), _to, _id, _amount);
888 
889     // Calling onReceive method if recipient is contract
890     _callonERC1155Received(address(0x0), _to, _id, _amount, _data);
891   }
892 
893   /**
894    * @notice Mint tokens for each ids in _ids
895    * @param _to       The address to mint tokens to
896    * @param _ids      Array of ids to mint
897    * @param _amounts  Array of amount of tokens to mint per id
898    * @param _data    Data to pass if receiver is contract
899    */
900   function _batchMint(
901     address _to,
902     uint256[] memory _ids,
903     uint256[] memory _amounts,
904     bytes memory _data
905   ) internal {
906     require(_ids.length == _amounts.length, "ERC1155MintBurn#batchMint: INVALID_ARRAYS_LENGTH");
907 
908     // Number of mints to execute
909     uint256 nMint = _ids.length;
910 
911     // Executing all minting
912     for (uint256 i = 0; i < nMint; i++) {
913       // Update storage balance
914       balances[_to][_ids[i]] = balances[_to][_ids[i]].add(_amounts[i]);
915     }
916 
917     // Emit batch mint event
918     emit TransferBatch(msg.sender, address(0x0), _to, _ids, _amounts);
919 
920     // Calling onReceive method if recipient is contract
921     _callonERC1155BatchReceived(address(0x0), _to, _ids, _amounts, _data);
922   }
923 
924   /****************************************|
925   |            Burning Functions           |
926   |_______________________________________*/
927 
928   /**
929    * @notice Burn _amount of tokens of a given token id
930    * @param _from    The address to burn tokens from
931    * @param _id      Token id to burn
932    * @param _amount  The amount to be burned
933    */
934   function _burn(
935     address _from,
936     uint256 _id,
937     uint256 _amount
938   ) internal {
939     //Substract _amount
940     balances[_from][_id] = balances[_from][_id].sub(_amount);
941 
942     // Emit event
943     emit TransferSingle(msg.sender, _from, address(0x0), _id, _amount);
944   }
945 
946   /**
947    * @notice Burn tokens of given token id for each (_ids[i], _amounts[i]) pair
948    * @param _from     The address to burn tokens from
949    * @param _ids      Array of token ids to burn
950    * @param _amounts  Array of the amount to be burned
951    */
952   function _batchBurn(
953     address _from,
954     uint256[] memory _ids,
955     uint256[] memory _amounts
956   ) internal {
957     require(_ids.length == _amounts.length, "ERC1155MintBurn#batchBurn: INVALID_ARRAYS_LENGTH");
958 
959     // Number of mints to execute
960     uint256 nBurn = _ids.length;
961 
962     // Executing all minting
963     for (uint256 i = 0; i < nBurn; i++) {
964       // Update storage balance
965       balances[_from][_ids[i]] = balances[_from][_ids[i]].sub(_amounts[i]);
966     }
967 
968     // Emit batch mint event
969     emit TransferBatch(msg.sender, _from, address(0x0), _ids, _amounts);
970   }
971 }
972 
973 // SPDX-License-Identifier: MIT
974 /**
975  * @title Roles
976  * @dev Library for managing addresses assigned to a Role.
977  */
978 library Roles {
979   struct Role {
980     mapping(address => bool) bearer;
981   }
982 
983   /**
984    * @dev Give an account access to this role.
985    */
986   function add(Role storage role, address account) internal {
987     require(!has(role, account), "Roles: account already has role");
988     role.bearer[account] = true;
989   }
990 
991   /**
992    * @dev Remove an account's access to this role.
993    */
994   function remove(Role storage role, address account) internal {
995     require(has(role, account), "Roles: account does not have role");
996     role.bearer[account] = false;
997   }
998 
999   /**
1000    * @dev Check if an account has this role.
1001    * @return bool
1002    */
1003   function has(Role storage role, address account) internal view returns (bool) {
1004     require(account != address(0), "Roles: account is the zero address");
1005     return role.bearer[account];
1006   }
1007 }
1008 
1009 // SPDX-License-Identifier: MIT
1010 contract MinterRole is Context {
1011   using Roles for Roles.Role;
1012 
1013   event MinterAdded(address indexed account);
1014   event MinterRemoved(address indexed account);
1015 
1016   Roles.Role private _minters;
1017 
1018   constructor() internal {
1019     _addMinter(_msgSender());
1020   }
1021 
1022   modifier onlyMinter() {
1023     require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
1024     _;
1025   }
1026 
1027   function isMinter(address account) public view returns (bool) {
1028     return _minters.has(account);
1029   }
1030 
1031   function addMinter(address account) public onlyMinter {
1032     _addMinter(account);
1033   }
1034 
1035   function renounceMinter() public {
1036     _removeMinter(_msgSender());
1037   }
1038 
1039   function _addMinter(address account) internal {
1040     _minters.add(account);
1041     emit MinterAdded(account);
1042   }
1043 
1044   function _removeMinter(address account) internal {
1045     _minters.remove(account);
1046     emit MinterRemoved(account);
1047   }
1048 }
1049 
1050 // SPDX-License-Identifier: MIT
1051 abstract contract Proxy {
1052   event ReceivedEther(address indexed sender, uint256 amount);
1053 
1054   /**
1055    * @dev Tells the address of the implementation where every call will be delegated.
1056    * @return address of the implementation to which it will be delegated
1057    */
1058   function implementation() public view virtual returns (address);
1059 
1060   /**
1061    * @dev Tells the type of proxy (EIP 897)
1062    * @return Type of proxy, 2 for upgradeable proxy
1063    */
1064   function proxyType() public pure virtual returns (uint256);
1065 
1066   /**
1067    * @dev Fallback function allowing to perform a delegatecall to the given implementation.
1068    * This function will return whatever the implementation call returns
1069    */
1070   fallback() external payable {
1071     address _impl = implementation();
1072     require(_impl != address(0));
1073 
1074     assembly {
1075       let ptr := mload(0x40)
1076       calldatacopy(ptr, 0, calldatasize())
1077       let result := delegatecall(gas(), _impl, ptr, calldatasize(), 0, 0)
1078       let size := returndatasize()
1079       returndatacopy(ptr, 0, size)
1080 
1081       switch result
1082         case 0 {
1083           revert(ptr, size)
1084         }
1085         default {
1086           return(ptr, size)
1087         }
1088     }
1089   }
1090 
1091   /**
1092    * @dev Receive Ether and generate a log event
1093    */
1094   receive() external payable {
1095     emit ReceivedEther(msg.sender, msg.value);
1096   }
1097 }
1098 
1099 // SPDX-License-Identifier: MIT
1100 contract OwnedUpgradeabilityStorage is Proxy {
1101   // Current implementation
1102   address internal _implementation;
1103 
1104   // Owner of the contract
1105   address private _upgradeabilityOwner;
1106 
1107   /**
1108    * @dev Tells the address of the owner
1109    * @return the address of the owner
1110    */
1111   function upgradeabilityOwner() public view returns (address) {
1112     return _upgradeabilityOwner;
1113   }
1114 
1115   /**
1116    * @dev Sets the address of the owner
1117    */
1118   function setUpgradeabilityOwner(address newUpgradeabilityOwner) internal {
1119     _upgradeabilityOwner = newUpgradeabilityOwner;
1120   }
1121 
1122   /**
1123    * @dev Tells the address of the current implementation
1124    * @return address of the current implementation
1125    */
1126   function implementation() public view override returns (address) {
1127     return _implementation;
1128   }
1129 
1130   /**
1131    * @dev Tells the proxy type (EIP 897)
1132    * @return Proxy type, 2 for forwarding proxy
1133    */
1134   function proxyType() public pure override returns (uint256) {
1135     return 2;
1136   }
1137 }
1138 
1139 // SPDX-License-Identifier: MIT
1140 contract OwnedUpgradeabilityProxy is OwnedUpgradeabilityStorage {
1141   /**
1142    * @dev Event to show ownership has been transferred
1143    * @param previousOwner representing the address of the previous owner
1144    * @param newOwner representing the address of the new owner
1145    */
1146   event ProxyOwnershipTransferred(address previousOwner, address newOwner);
1147 
1148   /**
1149    * @dev This event will be emitted every time the implementation gets upgraded
1150    * @param implementation representing the address of the upgraded implementation
1151    */
1152   event Upgraded(address indexed implementation);
1153 
1154   /**
1155    * @dev Upgrades the implementation address
1156    * @param implementation representing the address of the new implementation to be set
1157    */
1158   function _upgradeTo(address implementation) internal {
1159     require(_implementation != implementation);
1160     _implementation = implementation;
1161     emit Upgraded(implementation);
1162   }
1163 
1164   /**
1165    * @dev Throws if called by any account other than the owner.
1166    */
1167   modifier onlyProxyOwner() {
1168     require(msg.sender == proxyOwner());
1169     _;
1170   }
1171 
1172   /**
1173    * @dev Tells the address of the proxy owner
1174    * @return the address of the proxy owner
1175    */
1176   function proxyOwner() public view returns (address) {
1177     return upgradeabilityOwner();
1178   }
1179 
1180   /**
1181    * @dev Allows the current owner to transfer control of the contract to a newOwner.
1182    * @param newOwner The address to transfer ownership to.
1183    */
1184   function transferProxyOwnership(address newOwner) public onlyProxyOwner {
1185     require(newOwner != address(0));
1186     emit ProxyOwnershipTransferred(proxyOwner(), newOwner);
1187     setUpgradeabilityOwner(newOwner);
1188   }
1189 
1190   /**
1191    * @dev Allows the upgradeability owner to upgrade the current implementation of the proxy.
1192    * @param implementation representing the address of the new implementation to be set.
1193    */
1194   function upgradeTo(address implementation) public onlyProxyOwner {
1195     _upgradeTo(implementation);
1196   }
1197 
1198   /**
1199    * @dev Allows the upgradeability owner to upgrade the current implementation of the proxy
1200    * and delegatecall the new implementation for initialization.
1201    * @param implementation representing the address of the new implementation to be set.
1202    * @param data represents the msg.data to bet sent in the low level call. This parameter may include the function
1203    * signature of the implementation to be called with the needed payload
1204    */
1205   function upgradeToAndCall(address implementation, bytes memory data) public payable onlyProxyOwner {
1206     upgradeTo(implementation);
1207     (bool result, ) = address(this).delegatecall(data);
1208     require(result);
1209   }
1210 }
1211 
1212 // SPDX-License-Identifier: MIT
1213 contract OwnableDelegateProxy is OwnedUpgradeabilityProxy {
1214   constructor(
1215     address owner,
1216     address initialImplementation,
1217     bytes memory callData
1218   ) public {
1219     setUpgradeabilityOwner(owner);
1220     _upgradeTo(initialImplementation);
1221     (bool result, ) = initialImplementation.delegatecall(callData);
1222     require(result);
1223   }
1224 }
1225 
1226 // SPDX-License-Identifier: MIT
1227 contract ProxyRegistry is Ownable {
1228   /* DelegateProxy implementation contract. Must be initialized. */
1229   address public delegateProxyImplementation;
1230 
1231   /* Authenticated proxies by user. */
1232   mapping(address => OwnableDelegateProxy) public proxies;
1233 
1234   /* Contracts pending access. */
1235   mapping(address => uint256) public pending;
1236 
1237   /* Contracts allowed to call those proxies. */
1238   mapping(address => bool) public contracts;
1239 
1240   /* Delay period for adding an authenticated contract.
1241        This mitigates a particular class of potential attack on the Wyvern DAO (which owns this registry) - if at any point the value of assets held by proxy contracts exceeded the value of half the WYV supply (votes in the DAO),
1242        a malicious but rational attacker could buy half the Wyvern and grant themselves access to all the proxy contracts. A delay period renders this attack nonthreatening - given two weeks, if that happened, users would have
1243        plenty of time to notice and transfer their assets.
1244     */
1245   uint256 public DELAY_PERIOD = 2 weeks;
1246 
1247   /**
1248    * Start the process to enable access for specified contract. Subject to delay period.
1249    *
1250    * @dev ProxyRegistry owner only
1251    * @param addr Address to which to grant permissions
1252    */
1253   function startGrantAuthentication(address addr) public onlyOwner {
1254     require(!contracts[addr] && pending[addr] == 0);
1255     pending[addr] = now;
1256   }
1257 
1258   /**
1259    * End the process to nable access for specified contract after delay period has passed.
1260    *
1261    * @dev ProxyRegistry owner only
1262    * @param addr Address to which to grant permissions
1263    */
1264   function endGrantAuthentication(address addr) public onlyOwner {
1265     require(!contracts[addr] && pending[addr] != 0 && ((pending[addr] + DELAY_PERIOD) < now));
1266     pending[addr] = 0;
1267     contracts[addr] = true;
1268   }
1269 
1270   /**
1271    * Revoke access for specified contract. Can be done instantly.
1272    *
1273    * @dev ProxyRegistry owner only
1274    * @param addr Address of which to revoke permissions
1275    */
1276   function revokeAuthentication(address addr) public onlyOwner {
1277     contracts[addr] = false;
1278   }
1279 
1280   /**
1281    * Register a proxy contract with this registry
1282    *
1283    * @dev Must be called by the user which the proxy is for, creates a new AuthenticatedProxy
1284    * @return proxy New AuthenticatedProxy contract
1285    */
1286   function registerProxy() public returns (OwnableDelegateProxy proxy) {
1287     require(address(proxies[msg.sender]) == address(0));
1288     proxy = new OwnableDelegateProxy(
1289       msg.sender,
1290       delegateProxyImplementation,
1291       abi.encodeWithSignature("initialize(address,address)", msg.sender, address(this))
1292     );
1293     proxies[msg.sender] = proxy;
1294   }
1295 }
1296 
1297 // SPDX-License-Identifier: MIT
1298 library Strings {
1299   // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
1300   function strConcat(
1301     string memory _a,
1302     string memory _b,
1303     string memory _c,
1304     string memory _d,
1305     string memory _e
1306   ) internal pure returns (string memory) {
1307     bytes memory _ba = bytes(_a);
1308     bytes memory _bb = bytes(_b);
1309     bytes memory _bc = bytes(_c);
1310     bytes memory _bd = bytes(_d);
1311     bytes memory _be = bytes(_e);
1312     string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
1313     bytes memory babcde = bytes(abcde);
1314     uint256 k = 0;
1315     for (uint256 i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
1316     for (uint256 i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
1317     for (uint256 i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
1318     for (uint256 i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
1319     for (uint256 i = 0; i < _be.length; i++) babcde[k++] = _be[i];
1320     return string(babcde);
1321   }
1322 
1323   function strConcat(
1324     string memory _a,
1325     string memory _b,
1326     string memory _c,
1327     string memory _d
1328   ) internal pure returns (string memory) {
1329     return strConcat(_a, _b, _c, _d, "");
1330   }
1331 
1332   function strConcat(
1333     string memory _a,
1334     string memory _b,
1335     string memory _c
1336   ) internal pure returns (string memory) {
1337     return strConcat(_a, _b, _c, "", "");
1338   }
1339 
1340   function strConcat(string memory _a, string memory _b) internal pure returns (string memory) {
1341     return strConcat(_a, _b, "", "", "");
1342   }
1343 
1344   function uint2str(uint256 _i) internal pure returns (string memory _uintAsString) {
1345     if (_i == 0) {
1346       return "0";
1347     }
1348     uint256 j = _i;
1349     uint256 len;
1350     while (j != 0) {
1351       len++;
1352       j /= 10;
1353     }
1354     bytes memory bstr = new bytes(len);
1355     uint256 k = len - 1;
1356     while (_i != 0) {
1357       bstr[k--] = bytes1(uint8(48 + (_i % 10)));
1358       _i /= 10;
1359     }
1360     return string(bstr);
1361   }
1362 }
1363 
1364 // SPDX-License-Identifier: MIT
1365 /**
1366  * @title WhitelistAdminRole
1367  * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
1368  */
1369 contract WhitelistAdminRole is Context {
1370   using Roles for Roles.Role;
1371 
1372   event WhitelistAdminAdded(address indexed account);
1373   event WhitelistAdminRemoved(address indexed account);
1374 
1375   Roles.Role private _whitelistAdmins;
1376 
1377   constructor() internal {
1378     _addWhitelistAdmin(_msgSender());
1379   }
1380 
1381   modifier onlyWhitelistAdmin() {
1382     require(isWhitelistAdmin(_msgSender()), "WhitelistAdminRole: caller does not have the WhitelistAdmin role");
1383     _;
1384   }
1385 
1386   function isWhitelistAdmin(address account) public view returns (bool) {
1387     return _whitelistAdmins.has(account);
1388   }
1389 
1390   function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
1391     _addWhitelistAdmin(account);
1392   }
1393 
1394   function renounceWhitelistAdmin() public {
1395     _removeWhitelistAdmin(_msgSender());
1396   }
1397 
1398   function _addWhitelistAdmin(address account) internal {
1399     _whitelistAdmins.add(account);
1400     emit WhitelistAdminAdded(account);
1401   }
1402 
1403   function _removeWhitelistAdmin(address account) internal {
1404     _whitelistAdmins.remove(account);
1405     emit WhitelistAdminRemoved(account);
1406   }
1407 }
1408 
1409 // SPDX-License-Identifier: MIT
1410 /**
1411  * @title ERC1155Tradable
1412  * ERC1155Tradable - ERC1155 contract that whitelists an operator address, 
1413  * has create and mint functionality, and supports useful standards from OpenZeppelin,
1414   like _exists(), name(), symbol(), and totalSupply()
1415  */
1416 contract ERC1155Tradable is ERC1155, ERC1155MintBurn, ERC1155Metadata, Ownable, MinterRole, WhitelistAdminRole {
1417   using Strings for string;
1418 
1419   address proxyRegistryAddress;
1420   uint256 private _currentTokenID = 0;
1421   mapping(uint256 => address) public creators;
1422   mapping(uint256 => uint256) public tokenSupply;
1423   mapping(uint256 => uint256) public tokenMaxSupply;
1424   // Contract name
1425   string public name;
1426   // Contract symbol
1427   string public symbol;
1428 
1429   constructor(
1430     string memory _name,
1431     string memory _symbol,
1432     address _proxyRegistryAddress
1433   ) public {
1434     name = _name;
1435     symbol = _symbol;
1436     proxyRegistryAddress = _proxyRegistryAddress;
1437   }
1438 
1439   function removeWhitelistAdmin(address account) public onlyOwner {
1440     _removeWhitelistAdmin(account);
1441   }
1442 
1443   function removeMinter(address account) public onlyOwner {
1444     _removeMinter(account);
1445   }
1446 
1447   function uri(uint256 _id) public view override returns (string memory) {
1448     require(_exists(_id), "ERC721Tradable#uri: NONEXISTENT_TOKEN");
1449     return Strings.strConcat(baseMetadataURI, Strings.uint2str(_id));
1450   }
1451 
1452   /**
1453    * @dev Returns the total quantity for a token ID
1454    * @param _id uint256 ID of the token to query
1455    * @return amount of token in existence
1456    */
1457   function totalSupply(uint256 _id) public view returns (uint256) {
1458     return tokenSupply[_id];
1459   }
1460 
1461   /**
1462    * @dev Returns the max quantity for a token ID
1463    * @param _id uint256 ID of the token to query
1464    * @return amount of token in existence
1465    */
1466   function maxSupply(uint256 _id) public view returns (uint256) {
1467     return tokenMaxSupply[_id];
1468   }
1469 
1470   /**
1471    * @dev Will update the base URL of token's URI
1472    * @param _newBaseMetadataURI New base URL of token's URI
1473    */
1474   function setBaseMetadataURI(string memory _newBaseMetadataURI) public onlyWhitelistAdmin {
1475     _setBaseMetadataURI(_newBaseMetadataURI);
1476   }
1477 
1478   /**
1479    * @dev Creates a new token type and assigns _initialSupply to an address
1480    * @param _maxSupply max supply allowed
1481    * @param _initialSupply Optional amount to supply the first owner
1482    * @param _uri Optional URI for this token type
1483    * @param _data Optional data to pass if receiver is contract
1484    * @return tokenId The newly created token ID
1485    */
1486   function create(
1487     uint256 _maxSupply,
1488     uint256 _initialSupply,
1489     string calldata _uri,
1490     bytes calldata _data
1491   ) external onlyWhitelistAdmin returns (uint256 tokenId) {
1492     require(_initialSupply <= _maxSupply, "Initial supply cannot be more than max supply");
1493     uint256 _id = _getNextTokenID();
1494     _incrementTokenTypeId();
1495     creators[_id] = msg.sender;
1496 
1497     if (bytes(_uri).length > 0) {
1498       emit URI(_uri, _id);
1499     }
1500 
1501     if (_initialSupply != 0) _mint(msg.sender, _id, _initialSupply, _data);
1502     tokenSupply[_id] = _initialSupply;
1503     tokenMaxSupply[_id] = _maxSupply;
1504     return _id;
1505   }
1506 
1507   /**
1508    * @dev Mints some amount of tokens to an address
1509    * @param _to          Address of the future owner of the token
1510    * @param _id          Token ID to mint
1511    * @param _quantity    Amount of tokens to mint
1512    * @param _data        Data to pass if receiver is contract
1513    */
1514   function mint(
1515     address _to,
1516     uint256 _id,
1517     uint256 _quantity,
1518     bytes memory _data
1519   ) public onlyMinter {
1520     uint256 tokenId = _id;
1521     require(tokenSupply[tokenId].add(_quantity) <= tokenMaxSupply[tokenId], "Max supply reached");
1522     _mint(_to, _id, _quantity, _data);
1523     tokenSupply[_id] = tokenSupply[_id].add(_quantity);
1524   }
1525 
1526   /**
1527    * Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-free listings.
1528    */
1529   function isApprovedForAll(address _owner, address _operator) public view override returns (bool isOperator) {
1530     // Whitelist OpenSea proxy contract for easy trading.
1531     ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1532     if (address(proxyRegistry.proxies(_owner)) == _operator) {
1533       return true;
1534     }
1535 
1536     return ERC1155.isApprovedForAll(_owner, _operator);
1537   }
1538 
1539   /**
1540    * @dev Returns whether the specified token exists by checking to see if it has a creator
1541    * @param _id uint256 ID of the token to query the existence of
1542    * @return bool whether the token exists
1543    */
1544   function _exists(uint256 _id) internal view returns (bool) {
1545     return creators[_id] != address(0);
1546   }
1547 
1548   /**
1549    * @dev calculates the next token ID based on value of _currentTokenID
1550    * @return uint256 for the next token ID
1551    */
1552   function _getNextTokenID() private view returns (uint256) {
1553     return _currentTokenID.add(1);
1554   }
1555 
1556   /**
1557    * @dev increments the value of _currentTokenID
1558    */
1559   function _incrementTokenTypeId() private {
1560     _currentTokenID++;
1561   }
1562 
1563   /**
1564    * @dev Updates token max supply
1565    * @param id_ uint256 ID of the token to update
1566    * @param maxSupply_ uint256 max supply allowed
1567    */
1568   function updateTokenMaxSupply(uint256 id_, uint256 maxSupply_) external onlyWhitelistAdmin {
1569     require(_exists(id_), "ERC1155Tradable#updateTokenMaxSupply: NONEXISTENT_TOKEN");
1570     require(tokenSupply[id_] <= maxSupply_, "already minted > new maxSupply");
1571     tokenMaxSupply[id_] = maxSupply_;
1572   }
1573 }
1574 
1575 // SPDX-License-Identifier: MIT
1576 /**
1577  * @title EddaNft
1578  * EddaNft - Collect limited edition NFTs from Edda
1579  */
1580 contract EddaNft is ERC1155Tradable {
1581   string public contractURI;
1582 
1583   constructor(
1584     string memory _name, //// "Meme Ltd."
1585     string memory _symbol, //// "MEMES"
1586     address _proxyRegistryAddress,
1587     string memory _baseMetadataURI, //// "https://api.dontbuymeme.com/memes/"
1588     string memory _contractURI //// "https://api.dontbuymeme.com/contract/memes-erc1155"
1589   ) public ERC1155Tradable(_name, _symbol, _proxyRegistryAddress) {
1590     contractURI = _contractURI;
1591     _setBaseMetadataURI(_baseMetadataURI);
1592   }
1593 
1594   //// function contractURI() public pure returns (string memory) {
1595   ////   return "https://api.dontbuymeme.com/contract/memes-erc1155";
1596   //// }
1597 }