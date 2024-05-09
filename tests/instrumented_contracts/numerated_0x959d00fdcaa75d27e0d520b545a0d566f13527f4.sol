1 // SPDX-License-Identifier: GPL-3.0
2 
3 /*
4 ************************************************************
5 *********************** IX Panthers ************************
6 ************************************************************
7 ***    ,\/~~~\_                            _/~~~~\       ***
8 ***    |  ---, `\_    ___,-------~~\__  /~' ,,''  |      ***
9 ***    | `~`, ',,\`-~~--_____    ---  - /, ,--/ '/'      ***
10 ***     `\_|\ _\`    ______,---~~~\  ,_   '\_/' /'       ***
11 ***       \,_|   , '~,/'~   /~\ ,_  `\_\ \_  \_\'        ***
12 ***       ,/   /' ,/' _,-'~~  `\  ~~\_ ,_  `\  `\        ***
13 ***     /@@ _/  /' ./',-                 \       `@,     ***
14 ***     @@ '   |  ___/  /'  /  \  \ '\__ _`~|, `, @@     ***
15 ***   /@@ /  | | ',___  |  |    `  | ,,---,  |  | `@@,   ***      
16 ***   @@@ \  | | \ \O_`\ |        / / O_/' | \  \  @@@   ***
17 ***   @@@ |  | `| '   ~ / ,          ~     /  |    @@@   ***
18 ***   `@@ |   \ `\     ` |         | |  _/'  /'  | @@'   ***
19 ***    @@ |    ~\ /--'~  |       , |  \__   |    | |@@   ***
20 ***    @@, \     | ,,|   |       ,,|   | `\     /',@@    ***
21 ***    `@@, ~\   \ '     |       / /    `' '   / ,@@     ***
22 ***     @@@,    \    ~~\ `\/~---'~/' _ /'~~~~~~~~--,_    ***
23 ***      `@@@_,---::::::=  `-,| ,~  _=:::::''''''    `   ***
24 ***      ,/~~_---'_,-___     _-__  ' -~~~\_```---        ***
25 ***        ~`   ~~_/'// _,--~\_/ '~--, |\_               ***
26 ***             /' /'| `@@@@@,,,,,@@@@  | \              ***
27 ***                  `     `@@@@@@'                      ***
28 ************************************************************
29 ************************************************************
30 ************************************************************
31 */
32 
33 pragma solidity ^0.8.9;
34 
35 library SafeMath {
36     /**
37      * @dev Returns the addition of two unsigned integers, reverting on
38      * overflow.
39      *
40      * Counterpart to Solidity's `+` operator.
41      *
42      * Requirements:
43      *
44      * - Addition cannot overflow.
45      */
46     function add(uint256 a, uint256 b) internal pure returns (uint256) {
47         uint256 c = a + b;
48         require(c >= a, "SafeMath: addition overflow");
49         return c;
50     }
51 
52     /**
53      * @dev Returns the subtraction of two unsigned integers, reverting on
54      * overflow (when the result is negative).
55      *
56      * Counterpart to Solidity's `-` operator.
57      *
58      * Requirements:
59      *
60      * - Subtraction cannot overflow.
61      */
62     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
63         require(b <= a, "SafeMath: subtraction overflow");
64         return a - b;
65     }
66 
67     /**
68      * @dev Returns the multiplication of two unsigned integers, reverting on
69      * overflow.
70      *
71      * Counterpart to Solidity's `*` operator.
72      *
73      * Requirements:
74      *
75      * - Multiplication cannot overflow.
76      */
77     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
78         if (a == 0) return 0;
79         uint256 c = a * b;
80         require(c / a == b, "SafeMath: multiplication overflow");
81         return c;
82     }
83 
84     /**
85      * @dev Returns the integer division of two unsigned integers, reverting on
86      * division by zero. The result is rounded towards zero.
87      *
88      * Counterpart to Solidity's `/` operator. Note: this function uses a
89      * `revert` opcode (which leaves remaining gas untouched) while Solidity
90      * uses an invalid opcode to revert (consuming all remaining gas).
91      *
92      * Requirements:
93      *
94      * - The divisor cannot be zero.
95      */
96     function div(uint256 a, uint256 b) internal pure returns (uint256) {
97         require(b > 0, "SafeMath: division by zero");
98         return a / b;
99     }
100 
101     /**
102      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
103      * reverting when dividing by zero.
104      *
105      * Counterpart to Solidity's `%` operator. This function uses a `revert`
106      * opcode (which leaves remaining gas untouched) while Solidity uses an
107      * invalid opcode to revert (consuming all remaining gas).
108      *
109      * Requirements:
110      *
111      * - The divisor cannot be zero.
112      */
113     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
114         require(b > 0, "SafeMath: modulo by zero");
115         return a % b;
116     }
117 
118     /**
119      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
120      * overflow (when the result is negative).
121      *
122      * CAUTION: This function is deprecated because it requires allocating memory for the error
123      * message unnecessarily. For custom revert reasons use {trySub}.
124      *
125      * Counterpart to Solidity's `-` operator.
126      *
127      * Requirements:
128      *
129      * - Subtraction cannot overflow.
130      */
131     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
132         require(b <= a, errorMessage);
133         return a - b;
134     }
135 
136     /**
137      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
138      * division by zero. The result is rounded towards zero.
139      *
140      * CAUTION: This function is deprecated because it requires allocating memory for the error
141      * message unnecessarily. For custom revert reasons use {tryDiv}.
142      *
143      * Counterpart to Solidity's `/` operator. Note: this function uses a
144      * `revert` opcode (which leaves remaining gas untouched) while Solidity
145      * uses an invalid opcode to revert (consuming all remaining gas).
146      *
147      * Requirements:
148      *
149      * - The divisor cannot be zero.
150      */
151     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
152         require(b > 0, errorMessage);
153         return a / b;
154     }
155 
156     /**
157      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
158      * reverting with custom message when dividing by zero.
159      *
160      * CAUTION: This function is deprecated because it requires allocating memory for the error
161      * message unnecessarily. For custom revert reasons use {tryMod}.
162      *
163      * Counterpart to Solidity's `%` operator. This function uses a `revert`
164      * opcode (which leaves remaining gas untouched) while Solidity uses an
165      * invalid opcode to revert (consuming all remaining gas).
166      *
167      * Requirements:
168      *
169      * - The divisor cannot be zero.
170      */
171     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
172         require(b > 0, errorMessage);
173         return a % b;
174     }
175 }
176 
177 
178 /**
179  * @title Counters
180  * @author Matt Condon (@shrugs)
181  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
182  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
183  *
184  * Include with `using Counters for Counters.Counter;`
185  */
186 library Counters {
187     struct Counter {
188         // This variable should never be directly accessed by users of the library: interactions must be restricted to
189         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
190         // this feature: see https://github.com/ethereum/solidity/issues/4637
191         uint256 _value; // default: 0
192     }
193 
194     function current(Counter storage counter) internal view returns (uint256) {
195         return counter._value;
196     }
197 
198     function increment(Counter storage counter) internal {
199         unchecked {
200             counter._value += 1;
201         }
202     }
203 
204     function decrement(Counter storage counter) internal {
205         uint256 value = counter._value;
206         require(value > 0, "Counter: decrement overflow");
207         unchecked {
208             counter._value = value - 1;
209         }
210     }
211 
212     function reset(Counter storage counter) internal {
213         counter._value = 0;
214     }
215 }
216 
217 /// @author 1001.digital
218 /// @title A token tracker that limits the token supply and increments token IDs on each new mint.
219 abstract contract WithLimitedSupply {
220     using Counters for Counters.Counter;
221 
222     // Keeps track of how many we have minted
223     Counters.Counter private _tokenCount;
224 
225     /// @dev The maximum count of tokens this token tracker will hold.
226     uint256 private _totalSupply;
227 
228     /// Instanciate the contract
229     /// @param totalSupply_ how many tokens this collection should hold
230     constructor (uint256 totalSupply_) {
231         _totalSupply = totalSupply_;
232     }
233 
234     /// @dev Get the max Supply
235     /// @return the maximum token count
236     function totalSupply() public view returns (uint256) {
237         return _totalSupply;
238     }
239 
240     /// @dev Get the current token count
241     /// @return the created token count
242     function tokenCount() public view returns (uint256) {
243         return _tokenCount.current();
244     }
245 
246     /// @dev Check whether tokens are still available
247     /// @return the available token count
248     function availableTokenCount() public view returns (uint256) {
249         return totalSupply() - tokenCount();
250     }
251 
252     /// @dev Increment the token count and fetch the latest count
253     /// @return the next token id
254     function nextToken() internal virtual ensureAvailability returns (uint256) {
255         uint256 token = _tokenCount.current();
256 
257         _tokenCount.increment();
258 
259         return token;
260     }
261 
262     /// @dev Check whether another token is still available
263     modifier ensureAvailability() {
264         require(availableTokenCount() > 0, "No more tokens available");
265         _;
266     }
267 
268     /// @param amount Check whether number of tokens are still available
269     /// @dev Check whether tokens are still available
270     modifier ensureAvailabilityFor(uint256 amount) {
271         require(availableTokenCount() >= amount, "Requested number of tokens not available");
272         _;
273     }
274 }
275 
276 /// @author 1001.digital
277 /// @title Randomly assign tokenIDs from a given set of tokens.
278 abstract contract RandomlyAssigned is WithLimitedSupply {
279     // Used for random index assignment
280     mapping(uint256 => uint256) private tokenMatrix;
281 
282     // The initial token ID
283     uint256 private startFrom;
284 
285     /// Instanciate the contract
286     /// @param _totalSupply how many tokens this collection should hold
287     /// @param _startFrom the tokenID with which to start counting
288     constructor (uint256 _totalSupply, uint256 _startFrom)
289         WithLimitedSupply(_totalSupply)
290     {
291         startFrom = _startFrom;
292     }
293 
294     /// Get the next token ID
295     /// @dev Randomly gets a new token ID and keeps track of the ones that are still available.
296     /// @return the next token ID
297     function nextToken() internal override ensureAvailability returns (uint256) {
298         uint256 maxIndex = totalSupply() - tokenCount();
299         uint256 random = uint256(keccak256(
300             abi.encodePacked(
301                 msg.sender,
302                 block.coinbase,
303                 block.difficulty,
304                 block.gaslimit,
305                 block.timestamp
306             )
307         )) % maxIndex;
308 
309         uint256 value = 0;
310         if (tokenMatrix[random] == 0) {
311             // If this matrix position is empty, set the value to the generated random number.
312             value = random;
313         } else {
314             // Otherwise, use the previously stored number from the matrix.
315             value = tokenMatrix[random];
316         }
317 
318         // If the last available tokenID is still unused...
319         if (tokenMatrix[maxIndex - 1] == 0) {
320             // ...store that ID in the current matrix position.
321             tokenMatrix[random] = maxIndex - 1;
322         } else {
323             // ...otherwise copy over the stored number to the current matrix position.
324             tokenMatrix[random] = tokenMatrix[maxIndex - 1];
325         }
326 
327         // Increment counts
328         super.nextToken();
329 
330         return value + startFrom;
331     }
332 }
333 
334 /**
335  * @dev String operations.
336  */
337 library Strings {
338     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
339 
340     /**
341      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
342      */
343     function toString(uint256 value) internal pure returns (string memory) {
344         // Inspired by OraclizeAPI's implementation - MIT licence
345         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
346 
347         if (value == 0) {
348             return "0";
349         }
350         uint256 temp = value;
351         uint256 digits;
352         while (temp != 0) {
353             digits++;
354             temp /= 10;
355         }
356         bytes memory buffer = new bytes(digits);
357         while (value != 0) {
358             digits -= 1;
359             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
360             value /= 10;
361         }
362         return string(buffer);
363     }
364 
365     /**
366      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
367      */
368     function toHexString(uint256 value) internal pure returns (string memory) {
369         if (value == 0) {
370             return "0x00";
371         }
372         uint256 temp = value;
373         uint256 length = 0;
374         while (temp != 0) {
375             length++;
376             temp >>= 8;
377         }
378         return toHexString(value, length);
379     }
380 
381     /**
382      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
383      */
384     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
385         bytes memory buffer = new bytes(2 * length + 2);
386         buffer[0] = "0";
387         buffer[1] = "x";
388         for (uint256 i = 2 * length + 1; i > 1; --i) {
389             buffer[i] = _HEX_SYMBOLS[value & 0xf];
390             value >>= 4;
391         }
392         require(value == 0, "Strings: hex length insufficient");
393         return string(buffer);
394     }
395 }
396 
397 /**
398  * @dev Provides information about the current execution context, including the
399  * sender of the transaction and its data. While these are generally available
400  * via msg.sender and msg.data, they should not be accessed in such a direct
401  * manner, since when dealing with meta-transactions the account sending and
402  * paying for execution may not be the actual sender (as far as an application
403  * is concerned).
404  *
405  * This contract is only required for intermediate, library-like contracts.
406  */
407 abstract contract Context {
408     function _msgSender() internal view virtual returns (address) {
409         return msg.sender;
410     }
411 
412     function _msgData() internal view virtual returns (bytes calldata) {
413         return msg.data;
414     }
415 }
416 
417 
418 /**
419  * @dev Contract module which provides a basic access control mechanism, where
420  * there is an account (an owner) that can be granted exclusive access to
421  * specific functions.
422  *
423  * By default, the owner account will be the one that deploys the contract. This
424  * can later be changed with {transferOwnership}.
425  *
426  * This module is used through inheritance. It will make available the modifier
427  * `onlyOwner`, which can be applied to your functions to restrict their use to
428  * the owner.
429  */
430 abstract contract Ownable is Context {
431     address private _owner;
432 
433     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
434 
435     /**
436      * @dev Initializes the contract setting the deployer as the initial owner.
437      */
438     constructor() {
439         _transferOwnership(_msgSender());
440     }
441 
442     /**
443      * @dev Returns the address of the current owner.
444      */
445     function owner() public view virtual returns (address) {
446         return _owner;
447     }
448 
449     /**
450      * @dev Throws if called by any account other than the owner.
451      */
452     modifier onlyOwner() {
453         require(owner() == _msgSender(), "Ownable: caller is not the owner");
454         _;
455     }
456 
457     /**
458      * @dev Leaves the contract without owner. It will not be possible to call
459      * `onlyOwner` functions anymore. Can only be called by the current owner.
460      *
461      * NOTE: Renouncing ownership will leave the contract without an owner,
462      * thereby removing any functionality that is only available to the owner.
463      */
464     function renounceOwnership() public virtual onlyOwner {
465         _transferOwnership(address(0));
466     }
467 
468     /**
469      * @dev Transfers ownership of the contract to a new account (`newOwner`).
470      * Can only be called by the current owner.
471      */
472     function transferOwnership(address newOwner) public virtual onlyOwner {
473         require(newOwner != address(0), "Ownable: new owner is the zero address");
474         _transferOwnership(newOwner);
475     }
476 
477     /**
478      * @dev Transfers ownership of the contract to a new account (`newOwner`).
479      * Internal function without access restriction.
480      */
481     function _transferOwnership(address newOwner) internal virtual {
482         address oldOwner = _owner;
483         _owner = newOwner;
484         emit OwnershipTransferred(oldOwner, newOwner);
485     }
486 }
487 
488 /**
489  * @dev Collection of functions related to the address type
490  */
491 library Address {
492     /**
493      * @dev Returns true if `account` is a contract.
494      *
495      * [IMPORTANT]
496      * ====
497      * It is unsafe to assume that an address for which this function returns
498      * false is an externally-owned account (EOA) and not a contract.
499      *
500      * Among others, `isContract` will return false for the following
501      * types of addresses:
502      *
503      *  - an externally-owned account
504      *  - a contract in construction
505      *  - an address where a contract will be created
506      *  - an address where a contract lived, but was destroyed
507      * ====
508      */
509     function isContract(address account) internal view returns (bool) {
510         // This method relies on extcodesize, which returns 0 for contracts in
511         // construction, since the code is only stored at the end of the
512         // constructor execution.
513 
514         uint256 size;
515         assembly {
516             size := extcodesize(account)
517         }
518         return size > 0;
519     }
520 
521     /**
522      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
523      * `recipient`, forwarding all available gas and reverting on errors.
524      *
525      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
526      * of certain opcodes, possibly making contracts go over the 2300 gas limit
527      * imposed by `transfer`, making them unable to receive funds via
528      * `transfer`. {sendValue} removes this limitation.
529      *
530      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
531      *
532      * IMPORTANT: because control is transferred to `recipient`, care must be
533      * taken to not create reentrancy vulnerabilities. Consider using
534      * {ReentrancyGuard} or the
535      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
536      */
537     function sendValue(address payable recipient, uint256 amount) internal {
538         require(address(this).balance >= amount, "Address: insufficient balance");
539 
540         (bool success, ) = recipient.call{value: amount}("");
541         require(success, "Address: unable to send value, recipient may have reverted");
542     }
543 
544     /**
545      * @dev Performs a Solidity function call using a low level `call`. A
546      * plain `call` is an unsafe replacement for a function call: use this
547      * function instead.
548      *
549      * If `target` reverts with a revert reason, it is bubbled up by this
550      * function (like regular Solidity function calls).
551      *
552      * Returns the raw returned data. To convert to the expected return value,
553      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
554      *
555      * Requirements:
556      *
557      * - `target` must be a contract.
558      * - calling `target` with `data` must not revert.
559      *
560      * _Available since v3.1._
561      */
562     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
563         return functionCall(target, data, "Address: low-level call failed");
564     }
565 
566     /**
567      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
568      * `errorMessage` as a fallback revert reason when `target` reverts.
569      *
570      * _Available since v3.1._
571      */
572     function functionCall(
573         address target,
574         bytes memory data,
575         string memory errorMessage
576     ) internal returns (bytes memory) {
577         return functionCallWithValue(target, data, 0, errorMessage);
578     }
579 
580     /**
581      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
582      * but also transferring `value` wei to `target`.
583      *
584      * Requirements:
585      *
586      * - the calling contract must have an ETH balance of at least `value`.
587      * - the called Solidity function must be `payable`.
588      *
589      * _Available since v3.1._
590      */
591     function functionCallWithValue(
592         address target,
593         bytes memory data,
594         uint256 value
595     ) internal returns (bytes memory) {
596         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
597     }
598 
599     /**
600      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
601      * with `errorMessage` as a fallback revert reason when `target` reverts.
602      *
603      * _Available since v3.1._
604      */
605     function functionCallWithValue(
606         address target,
607         bytes memory data,
608         uint256 value,
609         string memory errorMessage
610     ) internal returns (bytes memory) {
611         require(address(this).balance >= value, "Address: insufficient balance for call");
612         require(isContract(target), "Address: call to non-contract");
613 
614         (bool success, bytes memory returndata) = target.call{value: value}(data);
615         return verifyCallResult(success, returndata, errorMessage);
616     }
617 
618     /**
619      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
620      * but performing a static call.
621      *
622      * _Available since v3.3._
623      */
624     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
625         return functionStaticCall(target, data, "Address: low-level static call failed");
626     }
627 
628     /**
629      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
630      * but performing a static call.
631      *
632      * _Available since v3.3._
633      */
634     function functionStaticCall(
635         address target,
636         bytes memory data,
637         string memory errorMessage
638     ) internal view returns (bytes memory) {
639         require(isContract(target), "Address: static call to non-contract");
640 
641         (bool success, bytes memory returndata) = target.staticcall(data);
642         return verifyCallResult(success, returndata, errorMessage);
643     }
644 
645     /**
646      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
647      * but performing a delegate call.
648      *
649      * _Available since v3.4._
650      */
651     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
652         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
653     }
654 
655     /**
656      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
657      * but performing a delegate call.
658      *
659      * _Available since v3.4._
660      */
661     function functionDelegateCall(
662         address target,
663         bytes memory data,
664         string memory errorMessage
665     ) internal returns (bytes memory) {
666         require(isContract(target), "Address: delegate call to non-contract");
667 
668         (bool success, bytes memory returndata) = target.delegatecall(data);
669         return verifyCallResult(success, returndata, errorMessage);
670     }
671 
672     /**
673      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
674      * revert reason using the provided one.
675      *
676      * _Available since v4.3._
677      */
678     function verifyCallResult(
679         bool success,
680         bytes memory returndata,
681         string memory errorMessage
682     ) internal pure returns (bytes memory) {
683         if (success) {
684             return returndata;
685         } else {
686             // Look for revert reason and bubble it up if present
687             if (returndata.length > 0) {
688                 // The easiest way to bubble the revert reason is using memory via assembly
689 
690                 assembly {
691                     let returndata_size := mload(returndata)
692                     revert(add(32, returndata), returndata_size)
693                 }
694             } else {
695                 revert(errorMessage);
696             }
697         }
698     }
699 }
700 
701 /**
702  * @title ERC721 token receiver interface
703  * @dev Interface for any contract that wants to support safeTransfers
704  * from ERC721 asset contracts.
705  */
706 interface IERC721Receiver {
707     /**
708      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
709      * by `operator` from `from`, this function is called.
710      *
711      * It must return its Solidity selector to confirm the token transfer.
712      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
713      *
714      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
715      */
716     function onERC721Received(
717         address operator,
718         address from,
719         uint256 tokenId,
720         bytes calldata data
721     ) external returns (bytes4);
722 }
723 
724 /**
725  * @dev Interface of the ERC165 standard, as defined in the
726  * https://eips.ethereum.org/EIPS/eip-165[EIP].
727  *
728  * Implementers can declare support of contract interfaces, which can then be
729  * queried by others ({ERC165Checker}).
730  *
731  * For an implementation, see {ERC165}.
732  */
733 interface IERC165 {
734     /**
735      * @dev Returns true if this contract implements the interface defined by
736      * `interfaceId`. See the corresponding
737      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
738      * to learn more about how these ids are created.
739      *
740      * This function call must use less than 30 000 gas.
741      */
742     function supportsInterface(bytes4 interfaceId) external view returns (bool);
743 }
744 
745 
746 /**
747  * @dev Implementation of the {IERC165} interface.
748  *
749  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
750  * for the additional interface id that will be supported. For example:
751  *
752  * ```solidity
753  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
754  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
755  * }
756  * ```
757  *
758  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
759  */
760 abstract contract ERC165 is IERC165 {
761     /**
762      * @dev See {IERC165-supportsInterface}.
763      */
764     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
765         return interfaceId == type(IERC165).interfaceId;
766     }
767 }
768 
769 
770 /**
771  * @dev Required interface of an ERC721 compliant contract.
772  */
773 interface IERC721 is IERC165 {
774     /**
775      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
776      */
777     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
778 
779     /**
780      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
781      */
782     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
783 
784     /**
785      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
786      */
787     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
788 
789     /**
790      * @dev Returns the number of tokens in ``owner``'s account.
791      */
792     function balanceOf(address owner) external view returns (uint256 balance);
793 
794     /**
795      * @dev Returns the owner of the `tokenId` token.
796      *
797      * Requirements:
798      *
799      * - `tokenId` must exist.
800      */
801     function ownerOf(uint256 tokenId) external view returns (address owner);
802 
803     /**
804      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
805      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
806      *
807      * Requirements:
808      *
809      * - `from` cannot be the zero address.
810      * - `to` cannot be the zero address.
811      * - `tokenId` token must exist and be owned by `from`.
812      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
813      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
814      *
815      * Emits a {Transfer} event.
816      */
817     function safeTransferFrom(
818         address from,
819         address to,
820         uint256 tokenId
821     ) external;
822 
823     /**
824      * @dev Transfers `tokenId` token from `from` to `to`.
825      *
826      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
827      *
828      * Requirements:
829      *
830      * - `from` cannot be the zero address.
831      * - `to` cannot be the zero address.
832      * - `tokenId` token must be owned by `from`.
833      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
834      *
835      * Emits a {Transfer} event.
836      */
837     function transferFrom(
838         address from,
839         address to,
840         uint256 tokenId
841     ) external;
842 
843     /**
844      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
845      * The approval is cleared when the token is transferred.
846      *
847      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
848      *
849      * Requirements:
850      *
851      * - The caller must own the token or be an approved operator.
852      * - `tokenId` must exist.
853      *
854      * Emits an {Approval} event.
855      */
856     function approve(address to, uint256 tokenId) external;
857 
858     /**
859      * @dev Returns the account approved for `tokenId` token.
860      *
861      * Requirements:
862      *
863      * - `tokenId` must exist.
864      */
865     function getApproved(uint256 tokenId) external view returns (address operator);
866 
867     /**
868      * @dev Approve or remove `operator` as an operator for the caller.
869      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
870      *
871      * Requirements:
872      *
873      * - The `operator` cannot be the caller.
874      *
875      * Emits an {ApprovalForAll} event.
876      */
877     function setApprovalForAll(address operator, bool _approved) external;
878 
879     /**
880      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
881      *
882      * See {setApprovalForAll}
883      */
884     function isApprovedForAll(address owner, address operator) external view returns (bool);
885 
886     /**
887      * @dev Safely transfers `tokenId` token from `from` to `to`.
888      *
889      * Requirements:
890      *
891      * - `from` cannot be the zero address.
892      * - `to` cannot be the zero address.
893      * - `tokenId` token must exist and be owned by `from`.
894      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
895      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
896      *
897      * Emits a {Transfer} event.
898      */
899     function safeTransferFrom(
900         address from,
901         address to,
902         uint256 tokenId,
903         bytes calldata data
904     ) external;
905 }
906 
907 /**
908  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
909  * @dev See https://eips.ethereum.org/EIPS/eip-721
910  */
911 interface IERC721Metadata is IERC721 {
912     /**
913      * @dev Returns the token collection name.
914      */
915     function name() external view returns (string memory);
916 
917     /**
918      * @dev Returns the token collection symbol.
919      */
920     function symbol() external view returns (string memory);
921 
922     /**
923      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
924      */
925     function tokenURI(uint256 tokenId) external view returns (string memory);
926 }
927 
928 /**
929  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
930  * the Metadata extension, but not including the Enumerable extension, which is available separately as
931  * {ERC721Enumerable}.
932  */
933 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
934     using Address for address;
935     using Strings for uint256;
936 
937     // Token name
938     string private _name;
939 
940     // Token symbol
941     string private _symbol;
942 
943     // Mapping from token ID to owner address
944     mapping(uint256 => address) private _owners;
945 
946     // Mapping owner address to token count
947     mapping(address => uint256) private _balances;
948 
949     // Mapping from token ID to approved address
950     mapping(uint256 => address) private _tokenApprovals;
951 
952     // Mapping from owner to operator approvals
953     mapping(address => mapping(address => bool)) private _operatorApprovals;
954 
955     /**
956      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
957      */
958     constructor(string memory name_, string memory symbol_) {
959         _name = name_;
960         _symbol = symbol_;
961     }
962 
963     /**
964      * @dev See {IERC165-supportsInterface}.
965      */
966     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
967         return
968             interfaceId == type(IERC721).interfaceId ||
969             interfaceId == type(IERC721Metadata).interfaceId ||
970             super.supportsInterface(interfaceId);
971     }
972 
973     /**
974      * @dev See {IERC721-balanceOf}.
975      */
976     function balanceOf(address owner) public view virtual override returns (uint256) {
977         require(owner != address(0), "ERC721: balance query for the zero address");
978         return _balances[owner];
979     }
980 
981     /**
982      * @dev See {IERC721-ownerOf}.
983      */
984     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
985         address owner = _owners[tokenId];
986         require(owner != address(0), "ERC721: owner query for nonexistent token");
987         return owner;
988     }
989 
990     /**
991      * @dev See {IERC721Metadata-name}.
992      */
993     function name() public view virtual override returns (string memory) {
994         return _name;
995     }
996 
997     /**
998      * @dev See {IERC721Metadata-symbol}.
999      */
1000     function symbol() public view virtual override returns (string memory) {
1001         return _symbol;
1002     }
1003 
1004     /**
1005      * @dev See {IERC721Metadata-tokenURI}.
1006      */
1007     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1008         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1009 
1010         string memory baseURI = _baseURI();
1011         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1012     }
1013 
1014     /**
1015      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1016      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1017      * by default, can be overriden in child contracts.
1018      */
1019     function _baseURI() internal view virtual returns (string memory) {
1020         return "";
1021     }
1022 
1023     /**
1024      * @dev See {IERC721-approve}.
1025      */
1026     function approve(address to, uint256 tokenId) public virtual override {
1027         address owner = ERC721.ownerOf(tokenId);
1028         require(to != owner, "ERC721: approval to current owner");
1029 
1030         require(
1031             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1032             "ERC721: approve caller is not owner nor approved for all"
1033         );
1034 
1035         _approve(to, tokenId);
1036     }
1037 
1038     /**
1039      * @dev See {IERC721-getApproved}.
1040      */
1041     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1042         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1043 
1044         return _tokenApprovals[tokenId];
1045     }
1046 
1047     /**
1048      * @dev See {IERC721-setApprovalForAll}.
1049      */
1050     function setApprovalForAll(address operator, bool approved) public virtual override {
1051         _setApprovalForAll(_msgSender(), operator, approved);
1052     }
1053 
1054     /**
1055      * @dev See {IERC721-isApprovedForAll}.
1056      */
1057     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1058         return _operatorApprovals[owner][operator];
1059     }
1060 
1061     /**
1062      * @dev See {IERC721-transferFrom}.
1063      */
1064     function transferFrom(
1065         address from,
1066         address to,
1067         uint256 tokenId
1068     ) public virtual override {
1069         //solhint-disable-next-line max-line-length
1070         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1071 
1072         _transfer(from, to, tokenId);
1073     }
1074 
1075     /**
1076      * @dev See {IERC721-safeTransferFrom}.
1077      */
1078     function safeTransferFrom(
1079         address from,
1080         address to,
1081         uint256 tokenId
1082     ) public virtual override {
1083         safeTransferFrom(from, to, tokenId, "");
1084     }
1085 
1086     /**
1087      * @dev See {IERC721-safeTransferFrom}.
1088      */
1089     function safeTransferFrom(
1090         address from,
1091         address to,
1092         uint256 tokenId,
1093         bytes memory _data
1094     ) public virtual override {
1095         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1096         _safeTransfer(from, to, tokenId, _data);
1097     }
1098 
1099     /**
1100      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1101      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1102      *
1103      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1104      *
1105      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1106      * implement alternative mechanisms to perform token transfer, such as signature-based.
1107      *
1108      * Requirements:
1109      *
1110      * - `from` cannot be the zero address.
1111      * - `to` cannot be the zero address.
1112      * - `tokenId` token must exist and be owned by `from`.
1113      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1114      *
1115      * Emits a {Transfer} event.
1116      */
1117     function _safeTransfer(
1118         address from,
1119         address to,
1120         uint256 tokenId,
1121         bytes memory _data
1122     ) internal virtual {
1123         _transfer(from, to, tokenId);
1124         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1125     }
1126 
1127     /**
1128      * @dev Returns whether `tokenId` exists.
1129      *
1130      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1131      *
1132      * Tokens start existing when they are minted (`_mint`),
1133      * and stop existing when they are burned (`_burn`).
1134      */
1135     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1136         return _owners[tokenId] != address(0);
1137     }
1138 
1139     /**
1140      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1141      *
1142      * Requirements:
1143      *
1144      * - `tokenId` must exist.
1145      */
1146     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1147         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1148         address owner = ERC721.ownerOf(tokenId);
1149         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1150     }
1151 
1152     /**
1153      * @dev Safely mints `tokenId` and transfers it to `to`.
1154      *
1155      * Requirements:
1156      *
1157      * - `tokenId` must not exist.
1158      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1159      *
1160      * Emits a {Transfer} event.
1161      */
1162     function _safeMint(address to, uint256 tokenId) internal virtual {
1163         _safeMint(to, tokenId, "");
1164     }
1165 
1166     /**
1167      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1168      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1169      */
1170     function _safeMint(
1171         address to,
1172         uint256 tokenId,
1173         bytes memory _data
1174     ) internal virtual {
1175         _mint(to, tokenId);
1176         require(
1177             _checkOnERC721Received(address(0), to, tokenId, _data),
1178             "ERC721: transfer to non ERC721Receiver implementer"
1179         );
1180     }
1181 
1182     /**
1183      * @dev Mints `tokenId` and transfers it to `to`.
1184      *
1185      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1186      *
1187      * Requirements:
1188      *
1189      * - `tokenId` must not exist.
1190      * - `to` cannot be the zero address.
1191      *
1192      * Emits a {Transfer} event.
1193      */
1194     function _mint(address to, uint256 tokenId) internal virtual {
1195         require(to != address(0), "ERC721: mint to the zero address");
1196         require(!_exists(tokenId), "ERC721: token already minted");
1197 
1198         _beforeTokenTransfer(address(0), to, tokenId);
1199 
1200         _balances[to] += 1;
1201         _owners[tokenId] = to;
1202 
1203         emit Transfer(address(0), to, tokenId);
1204     }
1205 
1206     /**
1207      * @dev Destroys `tokenId`.
1208      * The approval is cleared when the token is burned.
1209      *
1210      * Requirements:
1211      *
1212      * - `tokenId` must exist.
1213      *
1214      * Emits a {Transfer} event.
1215      */
1216     function _burn(uint256 tokenId) internal virtual {
1217         address owner = ERC721.ownerOf(tokenId);
1218 
1219         _beforeTokenTransfer(owner, address(0), tokenId);
1220 
1221         // Clear approvals
1222         _approve(address(0), tokenId);
1223 
1224         _balances[owner] -= 1;
1225         delete _owners[tokenId];
1226 
1227         emit Transfer(owner, address(0), tokenId);
1228     }
1229 
1230     /**
1231      * @dev Transfers `tokenId` from `from` to `to`.
1232      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1233      *
1234      * Requirements:
1235      *
1236      * - `to` cannot be the zero address.
1237      * - `tokenId` token must be owned by `from`.
1238      *
1239      * Emits a {Transfer} event.
1240      */
1241     function _transfer(
1242         address from,
1243         address to,
1244         uint256 tokenId
1245     ) internal virtual {
1246         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1247         require(to != address(0), "ERC721: transfer to the zero address");
1248 
1249         _beforeTokenTransfer(from, to, tokenId);
1250 
1251         // Clear approvals from the previous owner
1252         _approve(address(0), tokenId);
1253 
1254         _balances[from] -= 1;
1255         _balances[to] += 1;
1256         _owners[tokenId] = to;
1257 
1258         emit Transfer(from, to, tokenId);
1259     }
1260 
1261     /**
1262      * @dev Approve `to` to operate on `tokenId`
1263      *
1264      * Emits a {Approval} event.
1265      */
1266     function _approve(address to, uint256 tokenId) internal virtual {
1267         _tokenApprovals[tokenId] = to;
1268         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1269     }
1270 
1271     /**
1272      * @dev Approve `operator` to operate on all of `owner` tokens
1273      *
1274      * Emits a {ApprovalForAll} event.
1275      */
1276     function _setApprovalForAll(
1277         address owner,
1278         address operator,
1279         bool approved
1280     ) internal virtual {
1281         require(owner != operator, "ERC721: approve to caller");
1282         _operatorApprovals[owner][operator] = approved;
1283         emit ApprovalForAll(owner, operator, approved);
1284     }
1285 
1286     /**
1287      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1288      * The call is not executed if the target address is not a contract.
1289      *
1290      * @param from address representing the previous owner of the given token ID
1291      * @param to target address that will receive the tokens
1292      * @param tokenId uint256 ID of the token to be transferred
1293      * @param _data bytes optional data to send along with the call
1294      * @return bool whether the call correctly returned the expected magic value
1295      */
1296     function _checkOnERC721Received(
1297         address from,
1298         address to,
1299         uint256 tokenId,
1300         bytes memory _data
1301     ) private returns (bool) {
1302         if (to.isContract()) {
1303             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1304                 return retval == IERC721Receiver.onERC721Received.selector;
1305             } catch (bytes memory reason) {
1306                 if (reason.length == 0) {
1307                     revert("ERC721: transfer to non ERC721Receiver implementer");
1308                 } else {
1309                     assembly {
1310                         revert(add(32, reason), mload(reason))
1311                     }
1312                 }
1313             }
1314         } else {
1315             return true;
1316         }
1317     }
1318 
1319     /**
1320      * @dev Hook that is called before any token transfer. This includes minting
1321      * and burning.
1322      *
1323      * Calling conditions:
1324      *
1325      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1326      * transferred to `to`.
1327      * - When `from` is zero, `tokenId` will be minted for `to`.
1328      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1329      * - `from` and `to` are never both zero.
1330      *
1331      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1332      */
1333     function _beforeTokenTransfer(
1334         address from,
1335         address to,
1336         uint256 tokenId
1337     ) internal virtual {}
1338 }
1339 
1340 contract IXPanthers is ERC721, Ownable, RandomlyAssigned {
1341   using Strings for uint256;
1342   using SafeMath for uint256;
1343   
1344   string public _name = "IXPanthers";
1345   string public _symbol = "IXP";
1346   string public baseExtension = ".json";
1347   string public baseURI;
1348   string public notRevealedUri;
1349   
1350   uint256 public cost = 0.075 ether;
1351   uint256 public maxMintPerTransction = 5;
1352   uint256 public nftLimitPerAddressTier1 = 5;
1353   uint256 public nftLimitPerAddressTier2 = 2;
1354   uint256 public currentSupply = 0;
1355   uint256 public currentTicketId = 0;
1356   uint256 public maxNftSupply = 7000;
1357   uint256 public nftsForTeam = 47;
1358   
1359   bool public paused = true;
1360   bool public onlyWhitelisted = true;
1361   bool public revealed = false;
1362   
1363   mapping(address => bool) tier1WhitelistedUsers;
1364   mapping(address => bool) tier2WhitelistedUsers;
1365   mapping(address => uint256) public usersTickets;
1366   mapping(address => uint256) public totalClaimed;
1367   
1368   constructor(
1369     string memory _initBaseURI,
1370     string memory _initNotRevealedUri
1371   ) ERC721(_name, _symbol) RandomlyAssigned(maxNftSupply, 1) {
1372      mintTeamTickets();
1373      setBaseURI(_initBaseURI);
1374      setNotRevealedURI(_initNotRevealedUri);
1375   }
1376 
1377   function _baseURI() internal view virtual override returns (string memory) {
1378     return baseURI;
1379   }
1380 
1381   function tokenURI(uint256 tokenId)
1382     public
1383     view
1384     virtual
1385     override
1386     returns (string memory)
1387   {
1388     require(
1389       _exists(tokenId),
1390       "ERC721Metadata: URI query for nonexistent token"
1391     );
1392     
1393     if(revealed == false) {
1394        return notRevealedUri;
1395     }
1396 
1397     string memory currentBaseURI = _baseURI();
1398     return bytes(currentBaseURI).length > 0
1399         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1400         : "";
1401   }
1402 
1403   function setCost(uint256 _newCost) public onlyOwner() {
1404     cost = _newCost;
1405   }
1406   
1407   function setMaxMintPerTransction(uint256 _amount) public onlyOwner {
1408     maxMintPerTransction = _amount;
1409   }
1410 
1411   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1412     baseURI = _newBaseURI;
1413   }
1414   
1415   function addToTierOneWhitelist(address[] calldata addressToAdd) external onlyOwner {
1416     for (uint i=0; i<addressToAdd.length; i++) {
1417         tier1WhitelistedUsers[addressToAdd[i]] = true;
1418     }
1419   }
1420 
1421   function addToTierTwoWhitelist(address[] calldata addressToAdd) external onlyOwner {
1422     for (uint i=0; i<addressToAdd.length; i++) {
1423         tier2WhitelistedUsers[addressToAdd[i]] = true;
1424     }
1425   }
1426   
1427   function isTier1Whitelisted(address _user) public view returns (bool) {
1428     return tier1WhitelistedUsers[_user];
1429   }
1430 
1431   function isTier2Whitelisted(address _user) public view returns (bool) {
1432     return tier2WhitelistedUsers[_user];
1433   }
1434   
1435   function reserveTickets(uint256 numberOfTickets) external payable {
1436     require(currentTicketId.add(numberOfTickets) <= maxNftSupply, "EXCEEDS MAX SUPPLY");
1437     require(tx.origin == msg.sender, "CANNOT MINT THROUGH A CUSTOM CONTRACT");
1438 
1439     if (msg.sender != owner()) {
1440       if(onlyWhitelisted == true) {
1441         require(isTier1Whitelisted(msg.sender) || isTier2Whitelisted(msg.sender), "YOU ARE NOT WHITELISTED");
1442  
1443       }
1444 
1445       uint256 maxPerWallet = nftLimitPerAddressTier1;
1446       if (isTier2Whitelisted(msg.sender)) {
1447           maxPerWallet = nftLimitPerAddressTier2;
1448       }   
1449     
1450       uint256 _usersTickets = usersTickets[_msgSender()];
1451       require(numberOfTickets.add(_usersTickets) <= maxPerWallet, "EXCEEDS MAX ALLOWED PER USER");
1452       require(numberOfTickets > 0, string(abi.encodePacked("MINTING AMOUNT SHOULD BE BETWEEN 1 AND ", maxMintPerTransction)));
1453       require(!paused, "MINTING IS PAUSED");
1454       require(cost.mul(numberOfTickets) <= msg.value, "ETHER VALUE IS NOT CORRECT");
1455     }
1456     
1457     usersTickets[_msgSender()] = numberOfTickets.add(usersTickets[_msgSender()]);
1458     currentTicketId = currentTicketId.add(numberOfTickets);
1459   }
1460   
1461   function claimNFTs() external {
1462     uint256 numbersOfTickets = getUserClaimableTicketCount(_msgSender());
1463     
1464     for(uint256 i = 0; i < numbersOfTickets; i++) {
1465         uint256 id = nextToken();
1466         _safeMint(_msgSender(), id);
1467         currentSupply++;
1468     }
1469 
1470     totalClaimed[_msgSender()] = numbersOfTickets.add(totalClaimed[_msgSender()]);
1471   }
1472     
1473   function setOnlyWhitelisted(bool _state) external onlyOwner {
1474     onlyWhitelisted = _state;
1475   }
1476   
1477   function reveal() external onlyOwner() {
1478       revealed = true;
1479   }
1480   
1481   function mintTeamTickets() internal {
1482     usersTickets[_msgSender()] = nftsForTeam;
1483     currentTicketId = currentTicketId.add(nftsForTeam);
1484       
1485     for(uint256 i = 0; i < nftsForTeam; i++) {
1486         uint256 id = nextToken();
1487         _safeMint(_msgSender(), id);
1488         currentSupply++;
1489     }
1490 
1491     totalClaimed[_msgSender()] = nftsForTeam;
1492   }
1493   
1494   function getUserClaimableTicketCount(address user) public view returns (uint256) {
1495     return usersTickets[user].sub(totalClaimed[user]);
1496   }
1497   
1498   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1499     notRevealedUri = _notRevealedURI;
1500   }
1501   
1502   function setNftPerAddressTier1Limit(uint256 _limit) external onlyOwner() {
1503    nftLimitPerAddressTier1 = _limit;
1504   }
1505 
1506   function setNftPerAddressTier2Limit(uint256 _limit) external onlyOwner() {
1507    nftLimitPerAddressTier2 = _limit;
1508   }
1509 
1510   function setBaseExtension(string memory _newBaseExtension) external onlyOwner {
1511     baseExtension = _newBaseExtension;
1512   }
1513 
1514   function pause(bool _state) external onlyOwner {
1515     paused = _state;
1516   }
1517 
1518   function withdraw() external onlyOwner {
1519     require(payable(msg.sender).send(address(this).balance));
1520   }
1521 }