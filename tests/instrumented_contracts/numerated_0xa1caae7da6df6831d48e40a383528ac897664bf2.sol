1 // ███████╗███████╗███╗░░░███╗███╗░░░███╗███████╗  ██╗░░░██╗███████╗██████╗░░██████╗███████╗
2 // ██╔════╝██╔════╝████╗░████║████╗░████║██╔════╝  ██║░░░██║██╔════╝██╔══██╗██╔════╝██╔════╝
3 // █████╗░░█████╗░░██╔████╔██║██╔████╔██║█████╗░░  ╚██╗░██╔╝█████╗░░██████╔╝╚█████╗░█████╗░░
4 // ██╔══╝░░██╔══╝░░██║╚██╔╝██║██║╚██╔╝██║██╔══╝░░  ░╚████╔╝░██╔══╝░░██╔══██╗░╚═══██╗██╔══╝░░
5 // ██║░░░░░███████╗██║░╚═╝░██║██║░╚═╝░██║███████╗  ░░╚██╔╝░░███████╗██║░░██║██████╔╝███████╗
6 // ╚═╝░░░░░╚══════╝╚═╝░░░░░╚═╝╚═╝░░░░░╚═╝╚══════╝  ░░░╚═╝░░░╚══════╝╚═╝░░╚═╝╚═════╝░╚══════╝
7 
8 //FemmeVerse is the a generative NFT collection featuring 10,000 hand-painted female portraits from NonFungible Lady (me❤️)
9 //To reward my genesis collectors, Whitelist minting is open to Les Non Fongible Femmes holders for 2 free mints per Genesis Femme and 20 raffle winners with two free mints per person.
10 //Public minting will be after Whitelist minting and at 0.05eth per VFemme, max 5 VFemmes per transaction. 
11 //I'm an artist by passion, went to art school (BFA) but has to take on a job at an office front-desk to make a living, NFT offers me hope and chance to pursue my career as a full-time artist. 
12 //I learnt Javascript and Solidity every day after my day job and this is only my fifth week of coding, I apologize for the rudimentary web minting front-end and I will keep learning.
13 //Please go to my twitter @NonFungibleLady to see some test portraits from FemmeVerse, I'm shy in person but confident in my art. 
14 //Thank you for being here, I hope FemmeVerse will be a fun journey ahead for the global NFT art community. 
15 
16 
17 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Counters.sol
18 
19 
20 
21 pragma solidity ^0.8.0;
22 
23 /**
24  * @title Counters
25  * @author Matt Condon (@shrugs)
26  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
27  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
28  *
29  * Include with `using Counters for Counters.Counter;`
30  */
31 library Counters {
32     struct Counter {
33         // This variable should never be directly accessed by users of the library: interactions must be restricted to
34         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
35         // this feature: see https://github.com/ethereum/solidity/issues/4637
36         uint256 _value; // default: 0
37     }
38 
39     function current(Counter storage counter) internal view returns (uint256) {
40         return counter._value;
41     }
42 
43     function increment(Counter storage counter) internal {
44         unchecked {
45             counter._value += 1;
46         }
47     }
48 
49     function decrement(Counter storage counter) internal {
50         uint256 value = counter._value;
51         require(value > 0, "Counter: decrement overflow");
52         unchecked {
53             counter._value = value - 1;
54         }
55     }
56 
57     function reset(Counter storage counter) internal {
58         counter._value = 0;
59     }
60 }
61 
62 // File: contracts/WithLimitedSupply.sol
63 
64 
65 pragma solidity ^0.8.0;
66 
67 
68 /// @author 1001.digital 
69 /// @title A token tracker that limits the token supply and increments token IDs on each new mint.
70 abstract contract WithLimitedSupply {
71     using Counters for Counters.Counter;
72 
73     // Keeps track of how many we have minted
74     Counters.Counter private _tokenCount;
75 
76     /// @dev The maximum count of tokens this token tracker will hold.
77     uint256 private _maxSupply;
78 
79     /// Instanciate the contract
80     /// @param totalSupply_ how many tokens this collection should hold
81     constructor (uint256 totalSupply_) {
82         _maxSupply = totalSupply_;
83     }
84 
85     /// @dev Get the max Supply
86     /// @return the maximum token count
87     function maxSupply() public view returns (uint256) {
88         return _maxSupply;
89     }
90 
91     /// @dev Get the current token count
92     /// @return the created token count
93     function tokenCount() public view returns (uint256) {
94         return _tokenCount.current();
95     }
96 
97     /// @dev Check whether tokens are still available
98     /// @return the available token count
99     function availableTokenCount() public view returns (uint256) {
100         return maxSupply() - tokenCount();
101     }
102 
103     /// @dev Increment the token count and fetch the latest count
104     /// @return the next token id
105     function nextToken() internal virtual ensureAvailability returns (uint256) {
106         uint256 token = _tokenCount.current();
107 
108         _tokenCount.increment();
109 
110         return token;
111     }
112 
113     /// @dev Check whether another token is still available
114     modifier ensureAvailability() {
115         require(availableTokenCount() > 0, "No more tokens available");
116         _;
117     }
118 
119     /// @param amount Check whether number of tokens are still available
120     /// @dev Check whether tokens are still available
121     modifier ensureAvailabilityFor(uint256 amount) {
122         require(availableTokenCount() >= amount, "Requested number of tokens not available");
123         _;
124     }
125 }
126 // File: contracts/RandomlyAssigned.sol
127 
128 
129 pragma solidity ^0.8.0;
130 
131 
132 /// @author 1001.digital
133 /// @title Randomly assign tokenIDs from a given set of tokens.
134 abstract contract RandomlyAssigned is WithLimitedSupply {
135     // Used for random index assignment
136     mapping(uint256 => uint256) private tokenMatrix;
137 
138     // The initial token ID
139     uint256 private startFrom;
140 
141     /// Instanciate the contract
142     /// @param _maxSupply how many tokens this collection should hold
143     /// @param _startFrom the tokenID with which to start counting
144     constructor (uint256 _maxSupply, uint256 _startFrom)
145         WithLimitedSupply(_maxSupply)
146     {
147         startFrom = _startFrom;
148     }
149 
150     /// Get the next token ID
151     /// @dev Randomly gets a new token ID and keeps track of the ones that are still available.
152     /// @return the next token ID
153     function nextToken() internal override ensureAvailability returns (uint256) {
154         uint256 maxIndex = maxSupply() - tokenCount();
155         uint256 random = uint256(keccak256(
156             abi.encodePacked(
157                 msg.sender,
158                 block.coinbase,
159                 block.difficulty,
160                 block.gaslimit,
161                 block.timestamp
162             )
163         )) % maxIndex;
164 
165         uint256 value = 0;
166         if (tokenMatrix[random] == 0) {
167             // If this matrix position is empty, set the value to the generated random number.
168             value = random;
169         } else {
170             // Otherwise, use the previously stored number from the matrix.
171             value = tokenMatrix[random];
172         }
173 
174         // If the last available tokenID is still unused...
175         if (tokenMatrix[maxIndex - 1] == 0) {
176             // ...store that ID in the current matrix position.
177             tokenMatrix[random] = maxIndex - 1;
178         } else {
179             // ...otherwise copy over the stored number to the current matrix position.
180             tokenMatrix[random] = tokenMatrix[maxIndex - 1];
181         }
182 
183         // Increment counts
184         super.nextToken();
185 
186         return value + startFrom;
187     }
188 }
189 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
190 
191 
192 
193 pragma solidity ^0.8.0;
194 
195 // CAUTION
196 // This version of SafeMath should only be used with Solidity 0.8 or later,
197 // because it relies on the compiler's built in overflow checks.
198 
199 /**
200  * @dev Wrappers over Solidity's arithmetic operations.
201  *
202  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
203  * now has built in overflow checking.
204  */
205 library SafeMath {
206     /**
207      * @dev Returns the addition of two unsigned integers, with an overflow flag.
208      *
209      * _Available since v3.4._
210      */
211     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
212         unchecked {
213             uint256 c = a + b;
214             if (c < a) return (false, 0);
215             return (true, c);
216         }
217     }
218 
219     /**
220      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
221      *
222      * _Available since v3.4._
223      */
224     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
225         unchecked {
226             if (b > a) return (false, 0);
227             return (true, a - b);
228         }
229     }
230 
231     /**
232      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
233      *
234      * _Available since v3.4._
235      */
236     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
237         unchecked {
238             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
239             // benefit is lost if 'b' is also tested.
240             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
241             if (a == 0) return (true, 0);
242             uint256 c = a * b;
243             if (c / a != b) return (false, 0);
244             return (true, c);
245         }
246     }
247 
248     /**
249      * @dev Returns the division of two unsigned integers, with a division by zero flag.
250      *
251      * _Available since v3.4._
252      */
253     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
254         unchecked {
255             if (b == 0) return (false, 0);
256             return (true, a / b);
257         }
258     }
259 
260     /**
261      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
262      *
263      * _Available since v3.4._
264      */
265     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
266         unchecked {
267             if (b == 0) return (false, 0);
268             return (true, a % b);
269         }
270     }
271 
272     /**
273      * @dev Returns the addition of two unsigned integers, reverting on
274      * overflow.
275      *
276      * Counterpart to Solidity's `+` operator.
277      *
278      * Requirements:
279      *
280      * - Addition cannot overflow.
281      */
282     function add(uint256 a, uint256 b) internal pure returns (uint256) {
283         return a + b;
284     }
285 
286     /**
287      * @dev Returns the subtraction of two unsigned integers, reverting on
288      * overflow (when the result is negative).
289      *
290      * Counterpart to Solidity's `-` operator.
291      *
292      * Requirements:
293      *
294      * - Subtraction cannot overflow.
295      */
296     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
297         return a - b;
298     }
299 
300     /**
301      * @dev Returns the multiplication of two unsigned integers, reverting on
302      * overflow.
303      *
304      * Counterpart to Solidity's `*` operator.
305      *
306      * Requirements:
307      *
308      * - Multiplication cannot overflow.
309      */
310     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
311         return a * b;
312     }
313 
314     /**
315      * @dev Returns the integer division of two unsigned integers, reverting on
316      * division by zero. The result is rounded towards zero.
317      *
318      * Counterpart to Solidity's `/` operator.
319      *
320      * Requirements:
321      *
322      * - The divisor cannot be zero.
323      */
324     function div(uint256 a, uint256 b) internal pure returns (uint256) {
325         return a / b;
326     }
327 
328     /**
329      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
330      * reverting when dividing by zero.
331      *
332      * Counterpart to Solidity's `%` operator. This function uses a `revert`
333      * opcode (which leaves remaining gas untouched) while Solidity uses an
334      * invalid opcode to revert (consuming all remaining gas).
335      *
336      * Requirements:
337      *
338      * - The divisor cannot be zero.
339      */
340     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
341         return a % b;
342     }
343 
344     /**
345      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
346      * overflow (when the result is negative).
347      *
348      * CAUTION: This function is deprecated because it requires allocating memory for the error
349      * message unnecessarily. For custom revert reasons use {trySub}.
350      *
351      * Counterpart to Solidity's `-` operator.
352      *
353      * Requirements:
354      *
355      * - Subtraction cannot overflow.
356      */
357     function sub(
358         uint256 a,
359         uint256 b,
360         string memory errorMessage
361     ) internal pure returns (uint256) {
362         unchecked {
363             require(b <= a, errorMessage);
364             return a - b;
365         }
366     }
367 
368     /**
369      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
370      * division by zero. The result is rounded towards zero.
371      *
372      * Counterpart to Solidity's `/` operator. Note: this function uses a
373      * `revert` opcode (which leaves remaining gas untouched) while Solidity
374      * uses an invalid opcode to revert (consuming all remaining gas).
375      *
376      * Requirements:
377      *
378      * - The divisor cannot be zero.
379      */
380     function div(
381         uint256 a,
382         uint256 b,
383         string memory errorMessage
384     ) internal pure returns (uint256) {
385         unchecked {
386             require(b > 0, errorMessage);
387             return a / b;
388         }
389     }
390 
391     /**
392      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
393      * reverting with custom message when dividing by zero.
394      *
395      * CAUTION: This function is deprecated because it requires allocating memory for the error
396      * message unnecessarily. For custom revert reasons use {tryMod}.
397      *
398      * Counterpart to Solidity's `%` operator. This function uses a `revert`
399      * opcode (which leaves remaining gas untouched) while Solidity uses an
400      * invalid opcode to revert (consuming all remaining gas).
401      *
402      * Requirements:
403      *
404      * - The divisor cannot be zero.
405      */
406     function mod(
407         uint256 a,
408         uint256 b,
409         string memory errorMessage
410     ) internal pure returns (uint256) {
411         unchecked {
412             require(b > 0, errorMessage);
413             return a % b;
414         }
415     }
416 }
417 
418 // File: @openzeppelin/contracts/utils/Strings.sol
419 
420 
421 
422 pragma solidity ^0.8.0;
423 
424 /**
425  * @dev String operations.
426  */
427 library Strings {
428     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
429 
430     /**
431      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
432      */
433     function toString(uint256 value) internal pure returns (string memory) {
434         // Inspired by OraclizeAPI's implementation - MIT licence
435         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
436 
437         if (value == 0) {
438             return "0";
439         }
440         uint256 temp = value;
441         uint256 digits;
442         while (temp != 0) {
443             digits++;
444             temp /= 10;
445         }
446         bytes memory buffer = new bytes(digits);
447         while (value != 0) {
448             digits -= 1;
449             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
450             value /= 10;
451         }
452         return string(buffer);
453     }
454 
455     /**
456      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
457      */
458     function toHexString(uint256 value) internal pure returns (string memory) {
459         if (value == 0) {
460             return "0x00";
461         }
462         uint256 temp = value;
463         uint256 length = 0;
464         while (temp != 0) {
465             length++;
466             temp >>= 8;
467         }
468         return toHexString(value, length);
469     }
470 
471     /**
472      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
473      */
474     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
475         bytes memory buffer = new bytes(2 * length + 2);
476         buffer[0] = "0";
477         buffer[1] = "x";
478         for (uint256 i = 2 * length + 1; i > 1; --i) {
479             buffer[i] = _HEX_SYMBOLS[value & 0xf];
480             value >>= 4;
481         }
482         require(value == 0, "Strings: hex length insufficient");
483         return string(buffer);
484     }
485 }
486 
487 // File: @openzeppelin/contracts/utils/Context.sol
488 
489 
490 
491 pragma solidity ^0.8.0;
492 
493 /**
494  * @dev Provides information about the current execution context, including the
495  * sender of the transaction and its data. While these are generally available
496  * via msg.sender and msg.data, they should not be accessed in such a direct
497  * manner, since when dealing with meta-transactions the account sending and
498  * paying for execution may not be the actual sender (as far as an application
499  * is concerned).
500  *
501  * This contract is only required for intermediate, library-like contracts.
502  */
503 abstract contract Context {
504     function _msgSender() internal view virtual returns (address) {
505         return msg.sender;
506     }
507 
508     function _msgData() internal view virtual returns (bytes calldata) {
509         return msg.data;
510     }
511 }
512 
513 // File: @openzeppelin/contracts/access/Ownable.sol
514 
515 
516 
517 pragma solidity ^0.8.0;
518 
519 
520 /**
521  * @dev Contract module which provides a basic access control mechanism, where
522  * there is an account (an owner) that can be granted exclusive access to
523  * specific functions.
524  *
525  * By default, the owner account will be the one that deploys the contract. This
526  * can later be changed with {transferOwnership}.
527  *
528  * This module is used through inheritance. It will make available the modifier
529  * `onlyOwner`, which can be applied to your functions to restrict their use to
530  * the owner.
531  */
532 abstract contract Ownable is Context {
533     address private _owner;
534 
535     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
536 
537     /**
538      * @dev Initializes the contract setting the deployer as the initial owner.
539      */
540     constructor() {
541         _setOwner(_msgSender());
542     }
543 
544     /**
545      * @dev Returns the address of the current owner.
546      */
547     function owner() public view virtual returns (address) {
548         return _owner;
549     }
550 
551     /**
552      * @dev Throws if called by any account other than the owner.
553      */
554     modifier onlyOwner() {
555         require(owner() == _msgSender(), "Ownable: caller is not the owner");
556         _;
557     }
558 
559     /**
560      * @dev Leaves the contract without owner. It will not be possible to call
561      * `onlyOwner` functions anymore. Can only be called by the current owner.
562      *
563      * NOTE: Renouncing ownership will leave the contract without an owner,
564      * thereby removing any functionality that is only available to the owner.
565      */
566     function renounceOwnership() public virtual onlyOwner {
567         _setOwner(address(0));
568     }
569 
570     /**
571      * @dev Transfers ownership of the contract to a new account (`newOwner`).
572      * Can only be called by the current owner.
573      */
574     function transferOwnership(address newOwner) public virtual onlyOwner {
575         require(newOwner != address(0), "Ownable: new owner is the zero address");
576         _setOwner(newOwner);
577     }
578 
579     function _setOwner(address newOwner) private {
580         address oldOwner = _owner;
581         _owner = newOwner;
582         emit OwnershipTransferred(oldOwner, newOwner);
583     }
584 }
585 
586 // File: @openzeppelin/contracts/utils/Address.sol
587 
588 
589 
590 pragma solidity ^0.8.0;
591 
592 /**
593  * @dev Collection of functions related to the address type
594  */
595 library Address {
596     /**
597      * @dev Returns true if `account` is a contract.
598      *
599      * [IMPORTANT]
600      * ====
601      * It is unsafe to assume that an address for which this function returns
602      * false is an externally-owned account (EOA) and not a contract.
603      *
604      * Among others, `isContract` will return false for the following
605      * types of addresses:
606      *
607      *  - an externally-owned account
608      *  - a contract in construction
609      *  - an address where a contract will be created
610      *  - an address where a contract lived, but was destroyed
611      * ====
612      */
613     function isContract(address account) internal view returns (bool) {
614         // This method relies on extcodesize, which returns 0 for contracts in
615         // construction, since the code is only stored at the end of the
616         // constructor execution.
617 
618         uint256 size;
619         assembly {
620             size := extcodesize(account)
621         }
622         return size > 0;
623     }
624 
625     /**
626      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
627      * `recipient`, forwarding all available gas and reverting on errors.
628      *
629      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
630      * of certain opcodes, possibly making contracts go over the 2300 gas limit
631      * imposed by `transfer`, making them unable to receive funds via
632      * `transfer`. {sendValue} removes this limitation.
633      *
634      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
635      *
636      * IMPORTANT: because control is transferred to `recipient`, care must be
637      * taken to not create reentrancy vulnerabilities. Consider using
638      * {ReentrancyGuard} or the
639      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
640      */
641     function sendValue(address payable recipient, uint256 amount) internal {
642         require(address(this).balance >= amount, "Address: insufficient balance");
643 
644         (bool success, ) = recipient.call{value: amount}("");
645         require(success, "Address: unable to send value, recipient may have reverted");
646     }
647 
648     /**
649      * @dev Performs a Solidity function call using a low level `call`. A
650      * plain `call` is an unsafe replacement for a function call: use this
651      * function instead.
652      *
653      * If `target` reverts with a revert reason, it is bubbled up by this
654      * function (like regular Solidity function calls).
655      *
656      * Returns the raw returned data. To convert to the expected return value,
657      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
658      *
659      * Requirements:
660      *
661      * - `target` must be a contract.
662      * - calling `target` with `data` must not revert.
663      *
664      * _Available since v3.1._
665      */
666     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
667         return functionCall(target, data, "Address: low-level call failed");
668     }
669 
670     /**
671      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
672      * `errorMessage` as a fallback revert reason when `target` reverts.
673      *
674      * _Available since v3.1._
675      */
676     function functionCall(
677         address target,
678         bytes memory data,
679         string memory errorMessage
680     ) internal returns (bytes memory) {
681         return functionCallWithValue(target, data, 0, errorMessage);
682     }
683 
684     /**
685      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
686      * but also transferring `value` wei to `target`.
687      *
688      * Requirements:
689      *
690      * - the calling contract must have an ETH balance of at least `value`.
691      * - the called Solidity function must be `payable`.
692      *
693      * _Available since v3.1._
694      */
695     function functionCallWithValue(
696         address target,
697         bytes memory data,
698         uint256 value
699     ) internal returns (bytes memory) {
700         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
701     }
702 
703     /**
704      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
705      * with `errorMessage` as a fallback revert reason when `target` reverts.
706      *
707      * _Available since v3.1._
708      */
709     function functionCallWithValue(
710         address target,
711         bytes memory data,
712         uint256 value,
713         string memory errorMessage
714     ) internal returns (bytes memory) {
715         require(address(this).balance >= value, "Address: insufficient balance for call");
716         require(isContract(target), "Address: call to non-contract");
717 
718         (bool success, bytes memory returndata) = target.call{value: value}(data);
719         return verifyCallResult(success, returndata, errorMessage);
720     }
721 
722     /**
723      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
724      * but performing a static call.
725      *
726      * _Available since v3.3._
727      */
728     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
729         return functionStaticCall(target, data, "Address: low-level static call failed");
730     }
731 
732     /**
733      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
734      * but performing a static call.
735      *
736      * _Available since v3.3._
737      */
738     function functionStaticCall(
739         address target,
740         bytes memory data,
741         string memory errorMessage
742     ) internal view returns (bytes memory) {
743         require(isContract(target), "Address: static call to non-contract");
744 
745         (bool success, bytes memory returndata) = target.staticcall(data);
746         return verifyCallResult(success, returndata, errorMessage);
747     }
748 
749     /**
750      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
751      * but performing a delegate call.
752      *
753      * _Available since v3.4._
754      */
755     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
756         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
757     }
758 
759     /**
760      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
761      * but performing a delegate call.
762      *
763      * _Available since v3.4._
764      */
765     function functionDelegateCall(
766         address target,
767         bytes memory data,
768         string memory errorMessage
769     ) internal returns (bytes memory) {
770         require(isContract(target), "Address: delegate call to non-contract");
771 
772         (bool success, bytes memory returndata) = target.delegatecall(data);
773         return verifyCallResult(success, returndata, errorMessage);
774     }
775 
776     /**
777      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
778      * revert reason using the provided one.
779      *
780      * _Available since v4.3._
781      */
782     function verifyCallResult(
783         bool success,
784         bytes memory returndata,
785         string memory errorMessage
786     ) internal pure returns (bytes memory) {
787         if (success) {
788             return returndata;
789         } else {
790             // Look for revert reason and bubble it up if present
791             if (returndata.length > 0) {
792                 // The easiest way to bubble the revert reason is using memory via assembly
793 
794                 assembly {
795                     let returndata_size := mload(returndata)
796                     revert(add(32, returndata), returndata_size)
797                 }
798             } else {
799                 revert(errorMessage);
800             }
801         }
802     }
803 }
804 
805 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
806 
807 
808 
809 pragma solidity ^0.8.0;
810 
811 /**
812  * @title ERC721 token receiver interface
813  * @dev Interface for any contract that wants to support safeTransfers
814  * from ERC721 asset contracts.
815  */
816 interface IERC721Receiver {
817     /**
818      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
819      * by `operator` from `from`, this function is called.
820      *
821      * It must return its Solidity selector to confirm the token transfer.
822      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
823      *
824      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
825      */
826     function onERC721Received(
827         address operator,
828         address from,
829         uint256 tokenId,
830         bytes calldata data
831     ) external returns (bytes4);
832 }
833 
834 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
835 
836 
837 
838 pragma solidity ^0.8.0;
839 
840 /**
841  * @dev Interface of the ERC165 standard, as defined in the
842  * https://eips.ethereum.org/EIPS/eip-165[EIP].
843  *
844  * Implementers can declare support of contract interfaces, which can then be
845  * queried by others ({ERC165Checker}).
846  *
847  * For an implementation, see {ERC165}.
848  */
849 interface IERC165 {
850     /**
851      * @dev Returns true if this contract implements the interface defined by
852      * `interfaceId`. See the corresponding
853      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
854      * to learn more about how these ids are created.
855      *
856      * This function call must use less than 30 000 gas.
857      */
858     function supportsInterface(bytes4 interfaceId) external view returns (bool);
859 }
860 
861 // File: @openzeppelin/contracts/interfaces/IERC165.sol
862 
863 
864 
865 pragma solidity ^0.8.0;
866 
867 
868 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
869 
870 
871 
872 pragma solidity ^0.8.0;
873 
874 
875 /**
876  * @dev Interface for the NFT Royalty Standard
877  */
878 interface IERC2981 is IERC165 {
879     /**
880      * @dev Called with the sale price to determine how much royalty is owed and to whom.
881      * @param tokenId - the NFT asset queried for royalty information
882      * @param salePrice - the sale price of the NFT asset specified by `tokenId`
883      * @return receiver - address of who should be sent the royalty payment
884      * @return royaltyAmount - the royalty payment amount for `salePrice`
885      */
886     function royaltyInfo(uint256 tokenId, uint256 salePrice)
887         external
888         view
889         returns (address receiver, uint256 royaltyAmount);
890 }
891 
892 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
893 
894 
895 
896 pragma solidity ^0.8.0;
897 
898 
899 /**
900  * @dev Implementation of the {IERC165} interface.
901  *
902  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
903  * for the additional interface id that will be supported. For example:
904  *
905  * ```solidity
906  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
907  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
908  * }
909  * ```
910  *
911  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
912  */
913 abstract contract ERC165 is IERC165 {
914     /**
915      * @dev See {IERC165-supportsInterface}.
916      */
917     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
918         return interfaceId == type(IERC165).interfaceId;
919     }
920 }
921 
922 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
923 
924 
925 
926 pragma solidity ^0.8.0;
927 
928 
929 /**
930  * @dev Required interface of an ERC721 compliant contract.
931  */
932 interface IERC721 is IERC165 {
933     /**
934      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
935      */
936     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
937 
938     /**
939      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
940      */
941     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
942 
943     /**
944      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
945      */
946     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
947 
948     /**
949      * @dev Returns the number of tokens in ``owner``'s account.
950      */
951     function balanceOf(address owner) external view returns (uint256 balance);
952 
953     /**
954      * @dev Returns the owner of the `tokenId` token.
955      *
956      * Requirements:
957      *
958      * - `tokenId` must exist.
959      */
960     function ownerOf(uint256 tokenId) external view returns (address owner);
961 
962     /**
963      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
964      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
965      *
966      * Requirements:
967      *
968      * - `from` cannot be the zero address.
969      * - `to` cannot be the zero address.
970      * - `tokenId` token must exist and be owned by `from`.
971      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
972      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
973      *
974      * Emits a {Transfer} event.
975      */
976     function safeTransferFrom(
977         address from,
978         address to,
979         uint256 tokenId
980     ) external;
981 
982     /**
983      * @dev Transfers `tokenId` token from `from` to `to`.
984      *
985      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
986      *
987      * Requirements:
988      *
989      * - `from` cannot be the zero address.
990      * - `to` cannot be the zero address.
991      * - `tokenId` token must be owned by `from`.
992      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
993      *
994      * Emits a {Transfer} event.
995      */
996     function transferFrom(
997         address from,
998         address to,
999         uint256 tokenId
1000     ) external;
1001 
1002     /**
1003      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1004      * The approval is cleared when the token is transferred.
1005      *
1006      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1007      *
1008      * Requirements:
1009      *
1010      * - The caller must own the token or be an approved operator.
1011      * - `tokenId` must exist.
1012      *
1013      * Emits an {Approval} event.
1014      */
1015     function approve(address to, uint256 tokenId) external;
1016 
1017     /**
1018      * @dev Returns the account approved for `tokenId` token.
1019      *
1020      * Requirements:
1021      *
1022      * - `tokenId` must exist.
1023      */
1024     function getApproved(uint256 tokenId) external view returns (address operator);
1025 
1026     /**
1027      * @dev Approve or remove `operator` as an operator for the caller.
1028      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1029      *
1030      * Requirements:
1031      *
1032      * - The `operator` cannot be the caller.
1033      *
1034      * Emits an {ApprovalForAll} event.
1035      */
1036     function setApprovalForAll(address operator, bool _approved) external;
1037 
1038     /**
1039      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1040      *
1041      * See {setApprovalForAll}
1042      */
1043     function isApprovedForAll(address owner, address operator) external view returns (bool);
1044 
1045     /**
1046      * @dev Safely transfers `tokenId` token from `from` to `to`.
1047      *
1048      * Requirements:
1049      *
1050      * - `from` cannot be the zero address.
1051      * - `to` cannot be the zero address.
1052      * - `tokenId` token must exist and be owned by `from`.
1053      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1054      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1055      *
1056      * Emits a {Transfer} event.
1057      */
1058     function safeTransferFrom(
1059         address from,
1060         address to,
1061         uint256 tokenId,
1062         bytes calldata data
1063     ) external;
1064 }
1065 
1066 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1067 
1068 
1069 
1070 pragma solidity ^0.8.0;
1071 
1072 
1073 /**
1074  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1075  * @dev See https://eips.ethereum.org/EIPS/eip-721
1076  */
1077 interface IERC721Enumerable is IERC721 {
1078     /**
1079      * @dev Returns the total amount of tokens stored by the contract.
1080      */
1081     function totalSupply() external view returns (uint256);
1082 
1083     /**
1084      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1085      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1086      */
1087     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1088 
1089     /**
1090      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1091      * Use along with {totalSupply} to enumerate all tokens.
1092      */
1093     function tokenByIndex(uint256 index) external view returns (uint256);
1094 }
1095 
1096 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1097 
1098 
1099 
1100 pragma solidity ^0.8.0;
1101 
1102 
1103 /**
1104  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1105  * @dev See https://eips.ethereum.org/EIPS/eip-721
1106  */
1107 interface IERC721Metadata is IERC721 {
1108     /**
1109      * @dev Returns the token collection name.
1110      */
1111     function name() external view returns (string memory);
1112 
1113     /**
1114      * @dev Returns the token collection symbol.
1115      */
1116     function symbol() external view returns (string memory);
1117 
1118     /**
1119      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1120      */
1121     function tokenURI(uint256 tokenId) external view returns (string memory);
1122 }
1123 
1124 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1125 
1126 
1127 
1128 pragma solidity ^0.8.0;
1129 
1130 
1131 
1132 
1133 
1134 
1135 
1136 
1137 /**
1138  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1139  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1140  * {ERC721Enumerable}.
1141  */
1142 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1143     using Address for address;
1144     using Strings for uint256;
1145 
1146     // Token name
1147     string private _name;
1148 
1149     // Token symbol
1150     string private _symbol;
1151 
1152     // Mapping from token ID to owner address
1153     mapping(uint256 => address) private _owners;
1154 
1155     // Mapping owner address to token count
1156     mapping(address => uint256) private _balances;
1157 
1158     // Mapping from token ID to approved address
1159     mapping(uint256 => address) private _tokenApprovals;
1160 
1161     // Mapping from owner to operator approvals
1162     mapping(address => mapping(address => bool)) private _operatorApprovals;
1163 
1164     /**
1165      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1166      */
1167     constructor(string memory name_, string memory symbol_) {
1168         _name = name_;
1169         _symbol = symbol_;
1170     }
1171 
1172     /**
1173      * @dev See {IERC165-supportsInterface}.
1174      */
1175     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1176         return
1177             interfaceId == type(IERC721).interfaceId ||
1178             interfaceId == type(IERC721Metadata).interfaceId ||
1179             super.supportsInterface(interfaceId);
1180     }
1181 
1182     /**
1183      * @dev See {IERC721-balanceOf}.
1184      */
1185     function balanceOf(address owner) public view virtual override returns (uint256) {
1186         require(owner != address(0), "ERC721: balance query for the zero address");
1187         return _balances[owner];
1188     }
1189 
1190     /**
1191      * @dev See {IERC721-ownerOf}.
1192      */
1193     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1194         address owner = _owners[tokenId];
1195         require(owner != address(0), "ERC721: owner query for nonexistent token");
1196         return owner;
1197     }
1198 
1199     /**
1200      * @dev See {IERC721Metadata-name}.
1201      */
1202     function name() public view virtual override returns (string memory) {
1203         return _name;
1204     }
1205 
1206     /**
1207      * @dev See {IERC721Metadata-symbol}.
1208      */
1209     function symbol() public view virtual override returns (string memory) {
1210         return _symbol;
1211     }
1212 
1213     /**
1214      * @dev See {IERC721Metadata-tokenURI}.
1215      */
1216     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1217         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1218 
1219         string memory baseURI = _baseURI();
1220         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1221     }
1222 
1223     /**
1224      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1225      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1226      * by default, can be overriden in child contracts.
1227      */
1228     function _baseURI() internal view virtual returns (string memory) {
1229         return "";
1230     }
1231 
1232     /**
1233      * @dev See {IERC721-approve}.
1234      */
1235     function approve(address to, uint256 tokenId) public virtual override {
1236         address owner = ERC721.ownerOf(tokenId);
1237         require(to != owner, "ERC721: approval to current owner");
1238 
1239         require(
1240             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1241             "ERC721: approve caller is not owner nor approved for all"
1242         );
1243 
1244         _approve(to, tokenId);
1245     }
1246 
1247     /**
1248      * @dev See {IERC721-getApproved}.
1249      */
1250     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1251         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1252 
1253         return _tokenApprovals[tokenId];
1254     }
1255 
1256     /**
1257      * @dev See {IERC721-setApprovalForAll}.
1258      */
1259     function setApprovalForAll(address operator, bool approved) public virtual override {
1260         require(operator != _msgSender(), "ERC721: approve to caller");
1261 
1262         _operatorApprovals[_msgSender()][operator] = approved;
1263         emit ApprovalForAll(_msgSender(), operator, approved);
1264     }
1265 
1266     /**
1267      * @dev See {IERC721-isApprovedForAll}.
1268      */
1269     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1270         return _operatorApprovals[owner][operator];
1271     }
1272 
1273     /**
1274      * @dev See {IERC721-transferFrom}.
1275      */
1276     function transferFrom(
1277         address from,
1278         address to,
1279         uint256 tokenId
1280     ) public virtual override {
1281         //solhint-disable-next-line max-line-length
1282         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1283 
1284         _transfer(from, to, tokenId);
1285     }
1286 
1287     /**
1288      * @dev See {IERC721-safeTransferFrom}.
1289      */
1290     function safeTransferFrom(
1291         address from,
1292         address to,
1293         uint256 tokenId
1294     ) public virtual override {
1295         safeTransferFrom(from, to, tokenId, "");
1296     }
1297 
1298     /**
1299      * @dev See {IERC721-safeTransferFrom}.
1300      */
1301     function safeTransferFrom(
1302         address from,
1303         address to,
1304         uint256 tokenId,
1305         bytes memory _data
1306     ) public virtual override {
1307         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1308         _safeTransfer(from, to, tokenId, _data);
1309     }
1310 
1311     /**
1312      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1313      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1314      *
1315      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1316      *
1317      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1318      * implement alternative mechanisms to perform token transfer, such as signature-based.
1319      *
1320      * Requirements:
1321      *
1322      * - `from` cannot be the zero address.
1323      * - `to` cannot be the zero address.
1324      * - `tokenId` token must exist and be owned by `from`.
1325      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1326      *
1327      * Emits a {Transfer} event.
1328      */
1329     function _safeTransfer(
1330         address from,
1331         address to,
1332         uint256 tokenId,
1333         bytes memory _data
1334     ) internal virtual {
1335         _transfer(from, to, tokenId);
1336         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1337     }
1338 
1339     /**
1340      * @dev Returns whether `tokenId` exists.
1341      *
1342      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1343      *
1344      * Tokens start existing when they are minted (`_mint`),
1345      * and stop existing when they are burned (`_burn`).
1346      */
1347     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1348         return _owners[tokenId] != address(0);
1349     }
1350 
1351     /**
1352      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1353      *
1354      * Requirements:
1355      *
1356      * - `tokenId` must exist.
1357      */
1358     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1359         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1360         address owner = ERC721.ownerOf(tokenId);
1361         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1362     }
1363 
1364     /**
1365      * @dev Safely mints `tokenId` and transfers it to `to`.
1366      *
1367      * Requirements:
1368      *
1369      * - `tokenId` must not exist.
1370      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1371      *
1372      * Emits a {Transfer} event.
1373      */
1374     function _safeMint(address to, uint256 tokenId) internal virtual {
1375         _safeMint(to, tokenId, "");
1376     }
1377 
1378     /**
1379      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1380      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1381      */
1382     function _safeMint(
1383         address to,
1384         uint256 tokenId,
1385         bytes memory _data
1386     ) internal virtual {
1387         _mint(to, tokenId);
1388         require(
1389             _checkOnERC721Received(address(0), to, tokenId, _data),
1390             "ERC721: transfer to non ERC721Receiver implementer"
1391         );
1392     }
1393 
1394     /**
1395      * @dev Mints `tokenId` and transfers it to `to`.
1396      *
1397      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1398      *
1399      * Requirements:
1400      *
1401      * - `tokenId` must not exist.
1402      * - `to` cannot be the zero address.
1403      *
1404      * Emits a {Transfer} event.
1405      */
1406     function _mint(address to, uint256 tokenId) internal virtual {
1407         require(to != address(0), "ERC721: mint to the zero address");
1408         require(!_exists(tokenId), "ERC721: token already minted");
1409 
1410         _beforeTokenTransfer(address(0), to, tokenId);
1411 
1412         _balances[to] += 1;
1413         _owners[tokenId] = to;
1414 
1415         emit Transfer(address(0), to, tokenId);
1416     }
1417 
1418     /**
1419      * @dev Destroys `tokenId`.
1420      * The approval is cleared when the token is burned.
1421      *
1422      * Requirements:
1423      *
1424      * - `tokenId` must exist.
1425      *
1426      * Emits a {Transfer} event.
1427      */
1428     function _burn(uint256 tokenId) internal virtual {
1429         address owner = ERC721.ownerOf(tokenId);
1430 
1431         _beforeTokenTransfer(owner, address(0), tokenId);
1432 
1433         // Clear approvals
1434         _approve(address(0), tokenId);
1435 
1436         _balances[owner] -= 1;
1437         delete _owners[tokenId];
1438 
1439         emit Transfer(owner, address(0), tokenId);
1440     }
1441 
1442     /**
1443      * @dev Transfers `tokenId` from `from` to `to`.
1444      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1445      *
1446      * Requirements:
1447      *
1448      * - `to` cannot be the zero address.
1449      * - `tokenId` token must be owned by `from`.
1450      *
1451      * Emits a {Transfer} event.
1452      */
1453     function _transfer(
1454         address from,
1455         address to,
1456         uint256 tokenId
1457     ) internal virtual {
1458         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1459         require(to != address(0), "ERC721: transfer to the zero address");
1460 
1461         _beforeTokenTransfer(from, to, tokenId);
1462 
1463         // Clear approvals from the previous owner
1464         _approve(address(0), tokenId);
1465 
1466         _balances[from] -= 1;
1467         _balances[to] += 1;
1468         _owners[tokenId] = to;
1469 
1470         emit Transfer(from, to, tokenId);
1471     }
1472 
1473     /**
1474      * @dev Approve `to` to operate on `tokenId`
1475      *
1476      * Emits a {Approval} event.
1477      */
1478     function _approve(address to, uint256 tokenId) internal virtual {
1479         _tokenApprovals[tokenId] = to;
1480         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1481     }
1482 
1483     /**
1484      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1485      * The call is not executed if the target address is not a contract.
1486      *
1487      * @param from address representing the previous owner of the given token ID
1488      * @param to target address that will receive the tokens
1489      * @param tokenId uint256 ID of the token to be transferred
1490      * @param _data bytes optional data to send along with the call
1491      * @return bool whether the call correctly returned the expected magic value
1492      */
1493     function _checkOnERC721Received(
1494         address from,
1495         address to,
1496         uint256 tokenId,
1497         bytes memory _data
1498     ) private returns (bool) {
1499         if (to.isContract()) {
1500             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1501                 return retval == IERC721Receiver.onERC721Received.selector;
1502             } catch (bytes memory reason) {
1503                 if (reason.length == 0) {
1504                     revert("ERC721: transfer to non ERC721Receiver implementer");
1505                 } else {
1506                     assembly {
1507                         revert(add(32, reason), mload(reason))
1508                     }
1509                 }
1510             }
1511         } else {
1512             return true;
1513         }
1514     }
1515 
1516     /**
1517      * @dev Hook that is called before any token transfer. This includes minting
1518      * and burning.
1519      *
1520      * Calling conditions:
1521      *
1522      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1523      * transferred to `to`.
1524      * - When `from` is zero, `tokenId` will be minted for `to`.
1525      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1526      * - `from` and `to` are never both zero.
1527      *
1528      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1529      */
1530     function _beforeTokenTransfer(
1531         address from,
1532         address to,
1533         uint256 tokenId
1534     ) internal virtual {}
1535 }
1536 
1537 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1538 
1539 
1540 
1541 pragma solidity ^0.8.0;
1542 
1543 
1544 
1545 /**
1546  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1547  * enumerability of all the token ids in the contract as well as all token ids owned by each
1548  * account.
1549  */
1550 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1551     // Mapping from owner to list of owned token IDs
1552     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1553 
1554     // Mapping from token ID to index of the owner tokens list
1555     mapping(uint256 => uint256) private _ownedTokensIndex;
1556 
1557     // Array with all token ids, used for enumeration
1558     uint256[] private _allTokens;
1559 
1560     // Mapping from token id to position in the allTokens array
1561     mapping(uint256 => uint256) private _allTokensIndex;
1562 
1563     /**
1564      * @dev See {IERC165-supportsInterface}.
1565      */
1566     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1567         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1568     }
1569 
1570     /**
1571      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1572      */
1573     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1574         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1575         return _ownedTokens[owner][index];
1576     }
1577 
1578     /**
1579      * @dev See {IERC721Enumerable-totalSupply}.
1580      */
1581     function totalSupply() public view virtual override returns (uint256) {
1582         return _allTokens.length;
1583     }
1584 
1585     /**
1586      * @dev See {IERC721Enumerable-tokenByIndex}.
1587      */
1588     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1589         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1590         return _allTokens[index];
1591     }
1592 
1593     /**
1594      * @dev Hook that is called before any token transfer. This includes minting
1595      * and burning.
1596      *
1597      * Calling conditions:
1598      *
1599      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1600      * transferred to `to`.
1601      * - When `from` is zero, `tokenId` will be minted for `to`.
1602      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1603      * - `from` cannot be the zero address.
1604      * - `to` cannot be the zero address.
1605      *
1606      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1607      */
1608     function _beforeTokenTransfer(
1609         address from,
1610         address to,
1611         uint256 tokenId
1612     ) internal virtual override {
1613         super._beforeTokenTransfer(from, to, tokenId);
1614 
1615         if (from == address(0)) {
1616             _addTokenToAllTokensEnumeration(tokenId);
1617         } else if (from != to) {
1618             _removeTokenFromOwnerEnumeration(from, tokenId);
1619         }
1620         if (to == address(0)) {
1621             _removeTokenFromAllTokensEnumeration(tokenId);
1622         } else if (to != from) {
1623             _addTokenToOwnerEnumeration(to, tokenId);
1624         }
1625     }
1626 
1627     /**
1628      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1629      * @param to address representing the new owner of the given token ID
1630      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1631      */
1632     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1633         uint256 length = ERC721.balanceOf(to);
1634         _ownedTokens[to][length] = tokenId;
1635         _ownedTokensIndex[tokenId] = length;
1636     }
1637 
1638     /**
1639      * @dev Private function to add a token to this extension's token tracking data structures.
1640      * @param tokenId uint256 ID of the token to be added to the tokens list
1641      */
1642     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1643         _allTokensIndex[tokenId] = _allTokens.length;
1644         _allTokens.push(tokenId);
1645     }
1646 
1647     /**
1648      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1649      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1650      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1651      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1652      * @param from address representing the previous owner of the given token ID
1653      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1654      */
1655     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1656         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1657         // then delete the last slot (swap and pop).
1658 
1659         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1660         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1661 
1662         // When the token to delete is the last token, the swap operation is unnecessary
1663         if (tokenIndex != lastTokenIndex) {
1664             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1665 
1666             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1667             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1668         }
1669 
1670         // This also deletes the contents at the last position of the array
1671         delete _ownedTokensIndex[tokenId];
1672         delete _ownedTokens[from][lastTokenIndex];
1673     }
1674 
1675     /**
1676      * @dev Private function to remove a token from this extension's token tracking data structures.
1677      * This has O(1) time complexity, but alters the order of the _allTokens array.
1678      * @param tokenId uint256 ID of the token to be removed from the tokens list
1679      */
1680     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1681         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1682         // then delete the last slot (swap and pop).
1683 
1684         uint256 lastTokenIndex = _allTokens.length - 1;
1685         uint256 tokenIndex = _allTokensIndex[tokenId];
1686 
1687         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1688         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1689         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1690         uint256 lastTokenId = _allTokens[lastTokenIndex];
1691 
1692         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1693         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1694 
1695         // This also deletes the contents at the last position of the array
1696         delete _allTokensIndex[tokenId];
1697         _allTokens.pop();
1698     }
1699 }
1700 
1701 // File: contracts/FemmeVerse.sol
1702 
1703 // ███████╗███████╗███╗░░░███╗███╗░░░███╗███████╗  ██╗░░░██╗███████╗██████╗░░██████╗███████╗
1704 // ██╔════╝██╔════╝████╗░████║████╗░████║██╔════╝  ██║░░░██║██╔════╝██╔══██╗██╔════╝██╔════╝
1705 // █████╗░░█████╗░░██╔████╔██║██╔████╔██║█████╗░░  ╚██╗░██╔╝█████╗░░██████╔╝╚█████╗░█████╗░░
1706 // ██╔══╝░░██╔══╝░░██║╚██╔╝██║██║╚██╔╝██║██╔══╝░░  ░╚████╔╝░██╔══╝░░██╔══██╗░╚═══██╗██╔══╝░░
1707 // ██║░░░░░███████╗██║░╚═╝░██║██║░╚═╝░██║███████╗  ░░╚██╔╝░░███████╗██║░░██║██████╔╝███████╗
1708 // ╚═╝░░░░░╚══════╝╚═╝░░░░░╚═╝╚═╝░░░░░╚═╝╚══════╝  ░░░╚═╝░░░╚══════╝╚═╝░░╚═╝╚═════╝░╚══════╝
1709 
1710 pragma solidity ^0.8.0;
1711 //SPDX-License-Identifier: MIT
1712 
1713 //FemmeVerse is the a generative NFT collection featuring 10,000 hand-painted female portraits from NonFungible Lady (me❤️)
1714 //To reward my genesis collectors, Whitelist minting is open to Les Non Fongible Femmes holders for 2 free mints per Genesis Femme and 20 raffle winners with two free mints per person.
1715 //Public minting will be after Whitelist minting and at 0.05eth per VFemme, max 5 VFemmes per transaction. 
1716 //I'm an artist by passion, went to art school (BFA) but has to take on a job at an office front-desk to make a living, NFT offers me hope and chance to pursue my career as a full-time artist. 
1717 //I learnt Javascript and Solidity every day after my day job and this is only my fifth week of coding, I apologize for the rudimentary web minting front-end and I will keep learning.
1718 //Please go to my twitter @NonFungibleLady to see some test portraits from FemmeVerse, I'm shy in person but confident in my art. 
1719 //Thank you for being here, I hope FemmeVerse will be a fun journey ahead for the global NFT art community. 
1720 
1721 contract FemmeVerse is ERC721Enumerable, Ownable, IERC2981, RandomlyAssigned {
1722   using SafeMath for uint256;
1723   using Strings for uint256;
1724 
1725   string public baseExtension = ".json";
1726   uint256 public cost = 0.05 ether;
1727   uint256 public maxVFemme = 10000;
1728   uint256 public maxPresaleVFemmeMintAmount = 2;
1729   uint256 public maxVFemmeMintAmount = 5;
1730   int256  public VFemme_RESERVE = 1000;
1731 
1732     bool public preSaleIsActive = false;
1733     bool public saleIsActive = false;
1734     bool public paused = false;
1735     mapping(address => bool) public whitelist;
1736     mapping(address => uint256) public presalePurchases;
1737     
1738     //
1739     uint16 internal royalty = 600; // base 10000, 6%
1740     uint16 public constant BASE = 10000;
1741     //
1742     
1743     string public baseURI = "https://ipfs.io/ipfs/QmT3km4L5shRBjQhaHPufuWoGeu5STenFiiU1xvgzt1Quw/";
1744 
1745       constructor() ERC721("FemmeVerse", "VFemme")
1746           RandomlyAssigned(10000, 1) {}
1747 
1748   // internal
1749   function _baseURI() internal view virtual override returns (string memory) {
1750     return baseURI;
1751   }
1752 
1753     function mintPreSaleVFemmes(uint256 _PresaleVFemmeMintAmount) public payable {
1754     require(!paused);
1755     require(whitelist[msg.sender], 'Whitelist required for pre sale');
1756     require(preSaleIsActive, 'Pre sale must be active to mint VFemmes');
1757     require(presalePurchases[msg.sender].add(_PresaleVFemmeMintAmount) <=
1758                 maxPresaleVFemmeMintAmount,
1759             'Can only mint maxPresale_VFemme_Mint tokens during the presale');
1760     require(msg.value >= 0 * _PresaleVFemmeMintAmount);
1761             presalePurchases[msg.sender] = presalePurchases[msg.sender].add(
1762             _PresaleVFemmeMintAmount
1763         );
1764     require(_PresaleVFemmeMintAmount > 0);
1765     require(totalSupply() + _PresaleVFemmeMintAmount <= maxVFemme);
1766 
1767     for (uint256 i = 1; i <= _PresaleVFemmeMintAmount; i++) {
1768         uint256 mintIndex = nextToken();
1769      if (totalSupply() < maxVFemme) {
1770                 _safeMint(_msgSender(), mintIndex);
1771     }
1772    }
1773   }
1774   
1775     function mintPublicSaleVFemmes(uint256 _VFemmeMintAmount) public payable {
1776     require(!paused);
1777     require(_VFemmeMintAmount > 0);
1778     require(_VFemmeMintAmount <= maxVFemmeMintAmount);
1779     require(totalSupply() + _VFemmeMintAmount <= maxVFemme);
1780     require(msg.value >= cost * _VFemmeMintAmount);
1781 
1782     for (uint256 i = 1; i <= _VFemmeMintAmount; i++) {
1783         uint256 mintIndex = nextToken();
1784      if (totalSupply() < maxVFemme) {
1785                 _safeMint(_msgSender(), mintIndex);
1786     }
1787    }
1788   }
1789   
1790   function walletOfOwner(address _owner)
1791     public
1792     view
1793     returns (uint256[] memory)
1794   {
1795     uint256 ownerTokenCount = balanceOf(_owner);
1796     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1797     for (uint256 i; i < ownerTokenCount; i++) {
1798       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1799     }
1800     return tokenIds;
1801   }
1802 
1803     function tokenURI(uint256 tokenId)
1804     public
1805     view
1806     virtual
1807     override
1808     returns (string memory)
1809   {
1810     require(
1811       _exists(tokenId),
1812       "ERC721Metadata: URI query for nonexistent token"
1813     );
1814 
1815     string memory currentBaseURI = _baseURI();
1816     return bytes(currentBaseURI).length > 0
1817         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1818         : "";
1819   }
1820 
1821   //only owner
1822   
1823     function whitelistAddresses(address[] memory addresses) external onlyOwner {
1824         for (uint256 i = 0; i < addresses.length; i++) {
1825             whitelist[addresses[i]] = true;
1826         }
1827     }
1828 
1829     function removeWhitelistAddresses(address[] memory addresses)
1830         external
1831         onlyOwner
1832     {
1833         for (uint256 i = 0; i < addresses.length; i++) {
1834             whitelist[addresses[i]] = false;
1835         }
1836     }
1837   
1838     function flipPreSaleState() external onlyOwner {
1839         preSaleIsActive = !preSaleIsActive;
1840     }
1841 
1842     function flipSaleState() external onlyOwner {
1843         saleIsActive = !saleIsActive;
1844     }
1845     
1846     /// @notice Calculate the royalty payment
1847     /// @param _salePrice the sale price of the token
1848     function royaltyInfo(uint256, uint256 _salePrice)
1849         external
1850         view
1851         override
1852         returns (address receiver, uint256 royaltyAmount)
1853     {
1854         return (address(this), (_salePrice * royalty) / BASE);
1855     }
1856 
1857     /// @dev set the royalty
1858     /// @param _royalty the royalty in base 10000, 500 = 5%
1859     function setRoyalty(uint16 _royalty) public virtual onlyOwner {
1860         require(_royalty >= 0 && _royalty <= 1000, 'Royalty must be between 0% and 10%.');
1861 
1862         royalty = _royalty;
1863     }
1864 
1865     function withdraw() public payable onlyOwner {
1866     require(payable(msg.sender).send(address(this).balance));
1867   }
1868 }