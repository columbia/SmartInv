1 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev These functions deal with verification of Merkle Trees proofs.
10  *
11  * The proofs can be generated using the JavaScript library
12  * https://github.com/miguelmota/merkletreejs[merkletreejs].
13  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
14  *
15  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
16  */
17 library MerkleProof {
18     /**
19      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
20      * defined by `root`. For this, a `proof` must be provided, containing
21      * sibling hashes on the branch from the leaf to the root of the tree. Each
22      * pair of leaves and each pair of pre-images are assumed to be sorted.
23      */
24     function verify(
25         bytes32[] memory proof,
26         bytes32 root,
27         bytes32 leaf
28     ) internal pure returns (bool) {
29         return processProof(proof, leaf) == root;
30     }
31 
32     /**
33      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
34      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
35      * hash matches the root of the tree. When processing the proof, the pairs
36      * of leafs & pre-images are assumed to be sorted.
37      *
38      * _Available since v4.4._
39      */
40     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
41         bytes32 computedHash = leaf;
42         for (uint256 i = 0; i < proof.length; i++) {
43             bytes32 proofElement = proof[i];
44             if (computedHash <= proofElement) {
45                 // Hash(current computed hash + current element of the proof)
46                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
47             } else {
48                 // Hash(current element of the proof + current computed hash)
49                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
50             }
51         }
52         return computedHash;
53     }
54 }
55 
56 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
57 
58 
59 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
60 
61 pragma solidity ^0.8.0;
62 
63 // CAUTION
64 // This version of SafeMath should only be used with Solidity 0.8 or later,
65 // because it relies on the compiler's built in overflow checks.
66 
67 /**
68  * @dev Wrappers over Solidity's arithmetic operations.
69  *
70  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
71  * now has built in overflow checking.
72  */
73 library SafeMath {
74     /**
75      * @dev Returns the addition of two unsigned integers, with an overflow flag.
76      *
77      * _Available since v3.4._
78      */
79     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
80         unchecked {
81             uint256 c = a + b;
82             if (c < a) return (false, 0);
83             return (true, c);
84         }
85     }
86 
87     /**
88      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
89      *
90      * _Available since v3.4._
91      */
92     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
93         unchecked {
94             if (b > a) return (false, 0);
95             return (true, a - b);
96         }
97     }
98 
99     /**
100      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
101      *
102      * _Available since v3.4._
103      */
104     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
105         unchecked {
106             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
107             // benefit is lost if 'b' is also tested.
108             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
109             if (a == 0) return (true, 0);
110             uint256 c = a * b;
111             if (c / a != b) return (false, 0);
112             return (true, c);
113         }
114     }
115 
116     /**
117      * @dev Returns the division of two unsigned integers, with a division by zero flag.
118      *
119      * _Available since v3.4._
120      */
121     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
122         unchecked {
123             if (b == 0) return (false, 0);
124             return (true, a / b);
125         }
126     }
127 
128     /**
129      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
130      *
131      * _Available since v3.4._
132      */
133     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
134         unchecked {
135             if (b == 0) return (false, 0);
136             return (true, a % b);
137         }
138     }
139 
140     /**
141      * @dev Returns the addition of two unsigned integers, reverting on
142      * overflow.
143      *
144      * Counterpart to Solidity's `+` operator.
145      *
146      * Requirements:
147      *
148      * - Addition cannot overflow.
149      */
150     function add(uint256 a, uint256 b) internal pure returns (uint256) {
151         return a + b;
152     }
153 
154     /**
155      * @dev Returns the subtraction of two unsigned integers, reverting on
156      * overflow (when the result is negative).
157      *
158      * Counterpart to Solidity's `-` operator.
159      *
160      * Requirements:
161      *
162      * - Subtraction cannot overflow.
163      */
164     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
165         return a - b;
166     }
167 
168     /**
169      * @dev Returns the multiplication of two unsigned integers, reverting on
170      * overflow.
171      *
172      * Counterpart to Solidity's `*` operator.
173      *
174      * Requirements:
175      *
176      * - Multiplication cannot overflow.
177      */
178     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
179         return a * b;
180     }
181 
182     /**
183      * @dev Returns the integer division of two unsigned integers, reverting on
184      * division by zero. The result is rounded towards zero.
185      *
186      * Counterpart to Solidity's `/` operator.
187      *
188      * Requirements:
189      *
190      * - The divisor cannot be zero.
191      */
192     function div(uint256 a, uint256 b) internal pure returns (uint256) {
193         return a / b;
194     }
195 
196     /**
197      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
198      * reverting when dividing by zero.
199      *
200      * Counterpart to Solidity's `%` operator. This function uses a `revert`
201      * opcode (which leaves remaining gas untouched) while Solidity uses an
202      * invalid opcode to revert (consuming all remaining gas).
203      *
204      * Requirements:
205      *
206      * - The divisor cannot be zero.
207      */
208     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
209         return a % b;
210     }
211 
212     /**
213      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
214      * overflow (when the result is negative).
215      *
216      * CAUTION: This function is deprecated because it requires allocating memory for the error
217      * message unnecessarily. For custom revert reasons use {trySub}.
218      *
219      * Counterpart to Solidity's `-` operator.
220      *
221      * Requirements:
222      *
223      * - Subtraction cannot overflow.
224      */
225     function sub(
226         uint256 a,
227         uint256 b,
228         string memory errorMessage
229     ) internal pure returns (uint256) {
230         unchecked {
231             require(b <= a, errorMessage);
232             return a - b;
233         }
234     }
235 
236     /**
237      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
238      * division by zero. The result is rounded towards zero.
239      *
240      * Counterpart to Solidity's `/` operator. Note: this function uses a
241      * `revert` opcode (which leaves remaining gas untouched) while Solidity
242      * uses an invalid opcode to revert (consuming all remaining gas).
243      *
244      * Requirements:
245      *
246      * - The divisor cannot be zero.
247      */
248     function div(
249         uint256 a,
250         uint256 b,
251         string memory errorMessage
252     ) internal pure returns (uint256) {
253         unchecked {
254             require(b > 0, errorMessage);
255             return a / b;
256         }
257     }
258 
259     /**
260      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
261      * reverting with custom message when dividing by zero.
262      *
263      * CAUTION: This function is deprecated because it requires allocating memory for the error
264      * message unnecessarily. For custom revert reasons use {tryMod}.
265      *
266      * Counterpart to Solidity's `%` operator. This function uses a `revert`
267      * opcode (which leaves remaining gas untouched) while Solidity uses an
268      * invalid opcode to revert (consuming all remaining gas).
269      *
270      * Requirements:
271      *
272      * - The divisor cannot be zero.
273      */
274     function mod(
275         uint256 a,
276         uint256 b,
277         string memory errorMessage
278     ) internal pure returns (uint256) {
279         unchecked {
280             require(b > 0, errorMessage);
281             return a % b;
282         }
283     }
284 }
285 
286 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
287 
288 
289 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
290 
291 pragma solidity ^0.8.0;
292 
293 /**
294  * @dev Interface of the ERC20 standard as defined in the EIP.
295  */
296 interface IERC20 {
297     /**
298      * @dev Returns the amount of tokens in existence.
299      */
300     function totalSupply() external view returns (uint256);
301 
302     /**
303      * @dev Returns the amount of tokens owned by `account`.
304      */
305     function balanceOf(address account) external view returns (uint256);
306 
307     /**
308      * @dev Moves `amount` tokens from the caller's account to `recipient`.
309      *
310      * Returns a boolean value indicating whether the operation succeeded.
311      *
312      * Emits a {Transfer} event.
313      */
314     function transfer(address recipient, uint256 amount) external returns (bool);
315 
316     /**
317      * @dev Returns the remaining number of tokens that `spender` will be
318      * allowed to spend on behalf of `owner` through {transferFrom}. This is
319      * zero by default.
320      *
321      * This value changes when {approve} or {transferFrom} are called.
322      */
323     function allowance(address owner, address spender) external view returns (uint256);
324 
325     /**
326      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
327      *
328      * Returns a boolean value indicating whether the operation succeeded.
329      *
330      * IMPORTANT: Beware that changing an allowance with this method brings the risk
331      * that someone may use both the old and the new allowance by unfortunate
332      * transaction ordering. One possible solution to mitigate this race
333      * condition is to first reduce the spender's allowance to 0 and set the
334      * desired value afterwards:
335      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
336      *
337      * Emits an {Approval} event.
338      */
339     function approve(address spender, uint256 amount) external returns (bool);
340 
341     /**
342      * @dev Moves `amount` tokens from `sender` to `recipient` using the
343      * allowance mechanism. `amount` is then deducted from the caller's
344      * allowance.
345      *
346      * Returns a boolean value indicating whether the operation succeeded.
347      *
348      * Emits a {Transfer} event.
349      */
350     function transferFrom(
351         address sender,
352         address recipient,
353         uint256 amount
354     ) external returns (bool);
355 
356     /**
357      * @dev Emitted when `value` tokens are moved from one account (`from`) to
358      * another (`to`).
359      *
360      * Note that `value` may be zero.
361      */
362     event Transfer(address indexed from, address indexed to, uint256 value);
363 
364     /**
365      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
366      * a call to {approve}. `value` is the new allowance.
367      */
368     event Approval(address indexed owner, address indexed spender, uint256 value);
369 }
370 
371 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
372 
373 
374 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
375 
376 pragma solidity ^0.8.0;
377 
378 
379 /**
380  * @dev Interface for the optional metadata functions from the ERC20 standard.
381  *
382  * _Available since v4.1._
383  */
384 interface IERC20Metadata is IERC20 {
385     /**
386      * @dev Returns the name of the token.
387      */
388     function name() external view returns (string memory);
389 
390     /**
391      * @dev Returns the symbol of the token.
392      */
393     function symbol() external view returns (string memory);
394 
395     /**
396      * @dev Returns the decimals places of the token.
397      */
398     function decimals() external view returns (uint8);
399 }
400 
401 // File: @openzeppelin/contracts/utils/Address.sol
402 
403 
404 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
405 
406 pragma solidity ^0.8.0;
407 
408 /**
409  * @dev Collection of functions related to the address type
410  */
411 library Address {
412     /**
413      * @dev Returns true if `account` is a contract.
414      *
415      * [IMPORTANT]
416      * ====
417      * It is unsafe to assume that an address for which this function returns
418      * false is an externally-owned account (EOA) and not a contract.
419      *
420      * Among others, `isContract` will return false for the following
421      * types of addresses:
422      *
423      *  - an externally-owned account
424      *  - a contract in construction
425      *  - an address where a contract will be created
426      *  - an address where a contract lived, but was destroyed
427      * ====
428      */
429     function isContract(address account) internal view returns (bool) {
430         // This method relies on extcodesize, which returns 0 for contracts in
431         // construction, since the code is only stored at the end of the
432         // constructor execution.
433 
434         uint256 size;
435         assembly {
436             size := extcodesize(account)
437         }
438         return size > 0;
439     }
440 
441     /**
442      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
443      * `recipient`, forwarding all available gas and reverting on errors.
444      *
445      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
446      * of certain opcodes, possibly making contracts go over the 2300 gas limit
447      * imposed by `transfer`, making them unable to receive funds via
448      * `transfer`. {sendValue} removes this limitation.
449      *
450      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
451      *
452      * IMPORTANT: because control is transferred to `recipient`, care must be
453      * taken to not create reentrancy vulnerabilities. Consider using
454      * {ReentrancyGuard} or the
455      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
456      */
457     function sendValue(address payable recipient, uint256 amount) internal {
458         require(address(this).balance >= amount, "Address: insufficient balance");
459 
460         (bool success, ) = recipient.call{value: amount}("");
461         require(success, "Address: unable to send value, recipient may have reverted");
462     }
463 
464     /**
465      * @dev Performs a Solidity function call using a low level `call`. A
466      * plain `call` is an unsafe replacement for a function call: use this
467      * function instead.
468      *
469      * If `target` reverts with a revert reason, it is bubbled up by this
470      * function (like regular Solidity function calls).
471      *
472      * Returns the raw returned data. To convert to the expected return value,
473      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
474      *
475      * Requirements:
476      *
477      * - `target` must be a contract.
478      * - calling `target` with `data` must not revert.
479      *
480      * _Available since v3.1._
481      */
482     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
483         return functionCall(target, data, "Address: low-level call failed");
484     }
485 
486     /**
487      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
488      * `errorMessage` as a fallback revert reason when `target` reverts.
489      *
490      * _Available since v3.1._
491      */
492     function functionCall(
493         address target,
494         bytes memory data,
495         string memory errorMessage
496     ) internal returns (bytes memory) {
497         return functionCallWithValue(target, data, 0, errorMessage);
498     }
499 
500     /**
501      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
502      * but also transferring `value` wei to `target`.
503      *
504      * Requirements:
505      *
506      * - the calling contract must have an ETH balance of at least `value`.
507      * - the called Solidity function must be `payable`.
508      *
509      * _Available since v3.1._
510      */
511     function functionCallWithValue(
512         address target,
513         bytes memory data,
514         uint256 value
515     ) internal returns (bytes memory) {
516         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
517     }
518 
519     /**
520      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
521      * with `errorMessage` as a fallback revert reason when `target` reverts.
522      *
523      * _Available since v3.1._
524      */
525     function functionCallWithValue(
526         address target,
527         bytes memory data,
528         uint256 value,
529         string memory errorMessage
530     ) internal returns (bytes memory) {
531         require(address(this).balance >= value, "Address: insufficient balance for call");
532         require(isContract(target), "Address: call to non-contract");
533 
534         (bool success, bytes memory returndata) = target.call{value: value}(data);
535         return verifyCallResult(success, returndata, errorMessage);
536     }
537 
538     /**
539      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
540      * but performing a static call.
541      *
542      * _Available since v3.3._
543      */
544     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
545         return functionStaticCall(target, data, "Address: low-level static call failed");
546     }
547 
548     /**
549      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
550      * but performing a static call.
551      *
552      * _Available since v3.3._
553      */
554     function functionStaticCall(
555         address target,
556         bytes memory data,
557         string memory errorMessage
558     ) internal view returns (bytes memory) {
559         require(isContract(target), "Address: static call to non-contract");
560 
561         (bool success, bytes memory returndata) = target.staticcall(data);
562         return verifyCallResult(success, returndata, errorMessage);
563     }
564 
565     /**
566      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
567      * but performing a delegate call.
568      *
569      * _Available since v3.4._
570      */
571     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
572         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
573     }
574 
575     /**
576      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
577      * but performing a delegate call.
578      *
579      * _Available since v3.4._
580      */
581     function functionDelegateCall(
582         address target,
583         bytes memory data,
584         string memory errorMessage
585     ) internal returns (bytes memory) {
586         require(isContract(target), "Address: delegate call to non-contract");
587 
588         (bool success, bytes memory returndata) = target.delegatecall(data);
589         return verifyCallResult(success, returndata, errorMessage);
590     }
591 
592     /**
593      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
594      * revert reason using the provided one.
595      *
596      * _Available since v4.3._
597      */
598     function verifyCallResult(
599         bool success,
600         bytes memory returndata,
601         string memory errorMessage
602     ) internal pure returns (bytes memory) {
603         if (success) {
604             return returndata;
605         } else {
606             // Look for revert reason and bubble it up if present
607             if (returndata.length > 0) {
608                 // The easiest way to bubble the revert reason is using memory via assembly
609 
610                 assembly {
611                     let returndata_size := mload(returndata)
612                     revert(add(32, returndata), returndata_size)
613                 }
614             } else {
615                 revert(errorMessage);
616             }
617         }
618     }
619 }
620 
621 // File: @openzeppelin/contracts/utils/Context.sol
622 
623 
624 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
625 
626 pragma solidity ^0.8.0;
627 
628 /**
629  * @dev Provides information about the current execution context, including the
630  * sender of the transaction and its data. While these are generally available
631  * via msg.sender and msg.data, they should not be accessed in such a direct
632  * manner, since when dealing with meta-transactions the account sending and
633  * paying for execution may not be the actual sender (as far as an application
634  * is concerned).
635  *
636  * This contract is only required for intermediate, library-like contracts.
637  */
638 abstract contract Context {
639     function _msgSender() internal view virtual returns (address) {
640         return msg.sender;
641     }
642 
643     function _msgData() internal view virtual returns (bytes calldata) {
644         return msg.data;
645     }
646 }
647 
648 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
649 
650 
651 // OpenZeppelin Contracts v4.4.1 (token/ERC20/ERC20.sol)
652 
653 pragma solidity ^0.8.0;
654 
655 
656 
657 
658 /**
659  * @dev Implementation of the {IERC20} interface.
660  *
661  * This implementation is agnostic to the way tokens are created. This means
662  * that a supply mechanism has to be added in a derived contract using {_mint}.
663  * For a generic mechanism see {ERC20PresetMinterPauser}.
664  *
665  * TIP: For a detailed writeup see our guide
666  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
667  * to implement supply mechanisms].
668  *
669  * We have followed general OpenZeppelin Contracts guidelines: functions revert
670  * instead returning `false` on failure. This behavior is nonetheless
671  * conventional and does not conflict with the expectations of ERC20
672  * applications.
673  *
674  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
675  * This allows applications to reconstruct the allowance for all accounts just
676  * by listening to said events. Other implementations of the EIP may not emit
677  * these events, as it isn't required by the specification.
678  *
679  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
680  * functions have been added to mitigate the well-known issues around setting
681  * allowances. See {IERC20-approve}.
682  */
683 contract ERC20 is Context, IERC20, IERC20Metadata {
684     mapping(address => uint256) private _balances;
685 
686     mapping(address => mapping(address => uint256)) private _allowances;
687 
688     uint256 private _totalSupply;
689 
690     string private _name;
691     string private _symbol;
692 
693     /**
694      * @dev Sets the values for {name} and {symbol}.
695      *
696      * The default value of {decimals} is 18. To select a different value for
697      * {decimals} you should overload it.
698      *
699      * All two of these values are immutable: they can only be set once during
700      * construction.
701      */
702     constructor(string memory name_, string memory symbol_) {
703         _name = name_;
704         _symbol = symbol_;
705     }
706 
707     /**
708      * @dev Returns the name of the token.
709      */
710     function name() public view virtual override returns (string memory) {
711         return _name;
712     }
713 
714     /**
715      * @dev Returns the symbol of the token, usually a shorter version of the
716      * name.
717      */
718     function symbol() public view virtual override returns (string memory) {
719         return _symbol;
720     }
721 
722     /**
723      * @dev Returns the number of decimals used to get its user representation.
724      * For example, if `decimals` equals `2`, a balance of `505` tokens should
725      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
726      *
727      * Tokens usually opt for a value of 18, imitating the relationship between
728      * Ether and Wei. This is the value {ERC20} uses, unless this function is
729      * overridden;
730      *
731      * NOTE: This information is only used for _display_ purposes: it in
732      * no way affects any of the arithmetic of the contract, including
733      * {IERC20-balanceOf} and {IERC20-transfer}.
734      */
735     function decimals() public view virtual override returns (uint8) {
736         return 18;
737     }
738 
739     /**
740      * @dev See {IERC20-totalSupply}.
741      */
742     function totalSupply() public view virtual override returns (uint256) {
743         return _totalSupply;
744     }
745 
746     /**
747      * @dev See {IERC20-balanceOf}.
748      */
749     function balanceOf(address account) public view virtual override returns (uint256) {
750         return _balances[account];
751     }
752 
753     /**
754      * @dev See {IERC20-transfer}.
755      *
756      * Requirements:
757      *
758      * - `recipient` cannot be the zero address.
759      * - the caller must have a balance of at least `amount`.
760      */
761     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
762         _transfer(_msgSender(), recipient, amount);
763         return true;
764     }
765 
766     /**
767      * @dev See {IERC20-allowance}.
768      */
769     function allowance(address owner, address spender) public view virtual override returns (uint256) {
770         return _allowances[owner][spender];
771     }
772 
773     /**
774      * @dev See {IERC20-approve}.
775      *
776      * Requirements:
777      *
778      * - `spender` cannot be the zero address.
779      */
780     function approve(address spender, uint256 amount) public virtual override returns (bool) {
781         _approve(_msgSender(), spender, amount);
782         return true;
783     }
784 
785     /**
786      * @dev See {IERC20-transferFrom}.
787      *
788      * Emits an {Approval} event indicating the updated allowance. This is not
789      * required by the EIP. See the note at the beginning of {ERC20}.
790      *
791      * Requirements:
792      *
793      * - `sender` and `recipient` cannot be the zero address.
794      * - `sender` must have a balance of at least `amount`.
795      * - the caller must have allowance for ``sender``'s tokens of at least
796      * `amount`.
797      */
798     function transferFrom(
799         address sender,
800         address recipient,
801         uint256 amount
802     ) public virtual override returns (bool) {
803         _transfer(sender, recipient, amount);
804 
805         uint256 currentAllowance = _allowances[sender][_msgSender()];
806         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
807         unchecked {
808             _approve(sender, _msgSender(), currentAllowance - amount);
809         }
810 
811         return true;
812     }
813 
814     /**
815      * @dev Atomically increases the allowance granted to `spender` by the caller.
816      *
817      * This is an alternative to {approve} that can be used as a mitigation for
818      * problems described in {IERC20-approve}.
819      *
820      * Emits an {Approval} event indicating the updated allowance.
821      *
822      * Requirements:
823      *
824      * - `spender` cannot be the zero address.
825      */
826     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
827         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
828         return true;
829     }
830 
831     /**
832      * @dev Atomically decreases the allowance granted to `spender` by the caller.
833      *
834      * This is an alternative to {approve} that can be used as a mitigation for
835      * problems described in {IERC20-approve}.
836      *
837      * Emits an {Approval} event indicating the updated allowance.
838      *
839      * Requirements:
840      *
841      * - `spender` cannot be the zero address.
842      * - `spender` must have allowance for the caller of at least
843      * `subtractedValue`.
844      */
845     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
846         uint256 currentAllowance = _allowances[_msgSender()][spender];
847         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
848         unchecked {
849             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
850         }
851 
852         return true;
853     }
854 
855     /**
856      * @dev Moves `amount` of tokens from `sender` to `recipient`.
857      *
858      * This internal function is equivalent to {transfer}, and can be used to
859      * e.g. implement automatic token fees, slashing mechanisms, etc.
860      *
861      * Emits a {Transfer} event.
862      *
863      * Requirements:
864      *
865      * - `sender` cannot be the zero address.
866      * - `recipient` cannot be the zero address.
867      * - `sender` must have a balance of at least `amount`.
868      */
869     function _transfer(
870         address sender,
871         address recipient,
872         uint256 amount
873     ) internal virtual {
874         require(sender != address(0), "ERC20: transfer from the zero address");
875         require(recipient != address(0), "ERC20: transfer to the zero address");
876 
877         _beforeTokenTransfer(sender, recipient, amount);
878 
879         uint256 senderBalance = _balances[sender];
880         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
881         unchecked {
882             _balances[sender] = senderBalance - amount;
883         }
884         _balances[recipient] += amount;
885 
886         emit Transfer(sender, recipient, amount);
887 
888         _afterTokenTransfer(sender, recipient, amount);
889     }
890 
891     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
892      * the total supply.
893      *
894      * Emits a {Transfer} event with `from` set to the zero address.
895      *
896      * Requirements:
897      *
898      * - `account` cannot be the zero address.
899      */
900     function _mint(address account, uint256 amount) internal virtual {
901         require(account != address(0), "ERC20: mint to the zero address");
902 
903         _beforeTokenTransfer(address(0), account, amount);
904 
905         _totalSupply += amount;
906         _balances[account] += amount;
907         emit Transfer(address(0), account, amount);
908 
909         _afterTokenTransfer(address(0), account, amount);
910     }
911 
912     /**
913      * @dev Destroys `amount` tokens from `account`, reducing the
914      * total supply.
915      *
916      * Emits a {Transfer} event with `to` set to the zero address.
917      *
918      * Requirements:
919      *
920      * - `account` cannot be the zero address.
921      * - `account` must have at least `amount` tokens.
922      */
923     function _burn(address account, uint256 amount) internal virtual {
924         require(account != address(0), "ERC20: burn from the zero address");
925 
926         _beforeTokenTransfer(account, address(0), amount);
927 
928         uint256 accountBalance = _balances[account];
929         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
930         unchecked {
931             _balances[account] = accountBalance - amount;
932         }
933         _totalSupply -= amount;
934 
935         emit Transfer(account, address(0), amount);
936 
937         _afterTokenTransfer(account, address(0), amount);
938     }
939 
940     /**
941      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
942      *
943      * This internal function is equivalent to `approve`, and can be used to
944      * e.g. set automatic allowances for certain subsystems, etc.
945      *
946      * Emits an {Approval} event.
947      *
948      * Requirements:
949      *
950      * - `owner` cannot be the zero address.
951      * - `spender` cannot be the zero address.
952      */
953     function _approve(
954         address owner,
955         address spender,
956         uint256 amount
957     ) internal virtual {
958         require(owner != address(0), "ERC20: approve from the zero address");
959         require(spender != address(0), "ERC20: approve to the zero address");
960 
961         _allowances[owner][spender] = amount;
962         emit Approval(owner, spender, amount);
963     }
964 
965     /**
966      * @dev Hook that is called before any transfer of tokens. This includes
967      * minting and burning.
968      *
969      * Calling conditions:
970      *
971      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
972      * will be transferred to `to`.
973      * - when `from` is zero, `amount` tokens will be minted for `to`.
974      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
975      * - `from` and `to` are never both zero.
976      *
977      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
978      */
979     function _beforeTokenTransfer(
980         address from,
981         address to,
982         uint256 amount
983     ) internal virtual {}
984 
985     /**
986      * @dev Hook that is called after any transfer of tokens. This includes
987      * minting and burning.
988      *
989      * Calling conditions:
990      *
991      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
992      * has been transferred to `to`.
993      * - when `from` is zero, `amount` tokens have been minted for `to`.
994      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
995      * - `from` and `to` are never both zero.
996      *
997      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
998      */
999     function _afterTokenTransfer(
1000         address from,
1001         address to,
1002         uint256 amount
1003     ) internal virtual {}
1004 }
1005 
1006 // File: @openzeppelin/contracts/access/Ownable.sol
1007 
1008 
1009 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1010 
1011 pragma solidity ^0.8.0;
1012 
1013 
1014 /**
1015  * @dev Contract module which provides a basic access control mechanism, where
1016  * there is an account (an owner) that can be granted exclusive access to
1017  * specific functions.
1018  *
1019  * By default, the owner account will be the one that deploys the contract. This
1020  * can later be changed with {transferOwnership}.
1021  *
1022  * This module is used through inheritance. It will make available the modifier
1023  * `onlyOwner`, which can be applied to your functions to restrict their use to
1024  * the owner.
1025  */
1026 abstract contract Ownable is Context {
1027     address private _owner;
1028 
1029     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1030 
1031     /**
1032      * @dev Initializes the contract setting the deployer as the initial owner.
1033      */
1034     constructor() {
1035         _transferOwnership(_msgSender());
1036     }
1037 
1038     /**
1039      * @dev Returns the address of the current owner.
1040      */
1041     function owner() public view virtual returns (address) {
1042         return _owner;
1043     }
1044 
1045     /**
1046      * @dev Throws if called by any account other than the owner.
1047      */
1048     modifier onlyOwner() {
1049         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1050         _;
1051     }
1052 
1053     /**
1054      * @dev Leaves the contract without owner. It will not be possible to call
1055      * `onlyOwner` functions anymore. Can only be called by the current owner.
1056      *
1057      * NOTE: Renouncing ownership will leave the contract without an owner,
1058      * thereby removing any functionality that is only available to the owner.
1059      */
1060     function renounceOwnership() public virtual onlyOwner {
1061         _transferOwnership(address(0));
1062     }
1063 
1064     /**
1065      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1066      * Can only be called by the current owner.
1067      */
1068     function transferOwnership(address newOwner) public virtual onlyOwner {
1069         require(newOwner != address(0), "Ownable: new owner is the zero address");
1070         _transferOwnership(newOwner);
1071     }
1072 
1073     /**
1074      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1075      * Internal function without access restriction.
1076      */
1077     function _transferOwnership(address newOwner) internal virtual {
1078         address oldOwner = _owner;
1079         _owner = newOwner;
1080         emit OwnershipTransferred(oldOwner, newOwner);
1081     }
1082 }
1083 
1084 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1085 
1086 
1087 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1088 
1089 pragma solidity ^0.8.0;
1090 
1091 /**
1092  * @dev Interface of the ERC165 standard, as defined in the
1093  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1094  *
1095  * Implementers can declare support of contract interfaces, which can then be
1096  * queried by others ({ERC165Checker}).
1097  *
1098  * For an implementation, see {ERC165}.
1099  */
1100 interface IERC165 {
1101     /**
1102      * @dev Returns true if this contract implements the interface defined by
1103      * `interfaceId`. See the corresponding
1104      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1105      * to learn more about how these ids are created.
1106      *
1107      * This function call must use less than 30 000 gas.
1108      */
1109     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1110 }
1111 
1112 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1113 
1114 
1115 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
1116 
1117 pragma solidity ^0.8.0;
1118 
1119 
1120 /**
1121  * @dev Required interface of an ERC721 compliant contract.
1122  */
1123 interface IERC721 is IERC165 {
1124     /**
1125      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1126      */
1127     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1128 
1129     /**
1130      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1131      */
1132     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1133 
1134     /**
1135      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1136      */
1137     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1138 
1139     /**
1140      * @dev Returns the number of tokens in ``owner``'s account.
1141      */
1142     function balanceOf(address owner) external view returns (uint256 balance);
1143 
1144     /**
1145      * @dev Returns the owner of the `tokenId` token.
1146      *
1147      * Requirements:
1148      *
1149      * - `tokenId` must exist.
1150      */
1151     function ownerOf(uint256 tokenId) external view returns (address owner);
1152 
1153     /**
1154      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1155      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1156      *
1157      * Requirements:
1158      *
1159      * - `from` cannot be the zero address.
1160      * - `to` cannot be the zero address.
1161      * - `tokenId` token must exist and be owned by `from`.
1162      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1163      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1164      *
1165      * Emits a {Transfer} event.
1166      */
1167     function safeTransferFrom(
1168         address from,
1169         address to,
1170         uint256 tokenId
1171     ) external;
1172 
1173     /**
1174      * @dev Transfers `tokenId` token from `from` to `to`.
1175      *
1176      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1177      *
1178      * Requirements:
1179      *
1180      * - `from` cannot be the zero address.
1181      * - `to` cannot be the zero address.
1182      * - `tokenId` token must be owned by `from`.
1183      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1184      *
1185      * Emits a {Transfer} event.
1186      */
1187     function transferFrom(
1188         address from,
1189         address to,
1190         uint256 tokenId
1191     ) external;
1192 
1193     /**
1194      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1195      * The approval is cleared when the token is transferred.
1196      *
1197      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1198      *
1199      * Requirements:
1200      *
1201      * - The caller must own the token or be an approved operator.
1202      * - `tokenId` must exist.
1203      *
1204      * Emits an {Approval} event.
1205      */
1206     function approve(address to, uint256 tokenId) external;
1207 
1208     /**
1209      * @dev Returns the account approved for `tokenId` token.
1210      *
1211      * Requirements:
1212      *
1213      * - `tokenId` must exist.
1214      */
1215     function getApproved(uint256 tokenId) external view returns (address operator);
1216 
1217     /**
1218      * @dev Approve or remove `operator` as an operator for the caller.
1219      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1220      *
1221      * Requirements:
1222      *
1223      * - The `operator` cannot be the caller.
1224      *
1225      * Emits an {ApprovalForAll} event.
1226      */
1227     function setApprovalForAll(address operator, bool _approved) external;
1228 
1229     /**
1230      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1231      *
1232      * See {setApprovalForAll}
1233      */
1234     function isApprovedForAll(address owner, address operator) external view returns (bool);
1235 
1236     /**
1237      * @dev Safely transfers `tokenId` token from `from` to `to`.
1238      *
1239      * Requirements:
1240      *
1241      * - `from` cannot be the zero address.
1242      * - `to` cannot be the zero address.
1243      * - `tokenId` token must exist and be owned by `from`.
1244      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1245      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1246      *
1247      * Emits a {Transfer} event.
1248      */
1249     function safeTransferFrom(
1250         address from,
1251         address to,
1252         uint256 tokenId,
1253         bytes calldata data
1254     ) external;
1255 }
1256 
1257 // File: contracts/InulandStaking.sol
1258 
1259 //SPDX-License-Identifier: MIT
1260 pragma solidity 0.8.7;
1261 
1262 /**
1263  * @title Inuland Staking Contract
1264  * @author Inuland Dev
1265  */
1266 
1267 
1268 
1269 
1270 
1271 
1272 
1273 
1274 
1275 contract InulandStaking is ERC20("INUS", "INUS"), Ownable {
1276     using SafeMath for uint256;
1277     using Address for address;
1278    
1279 
1280     /**
1281      *    @notice Keeping track of user and its token
1282      */
1283     struct UserInfo {
1284         uint256[] stakedTokens;
1285         // TokenId => Locked Days
1286         mapping(uint256 => uint256) lockedDays;
1287         // TokenId => Block time
1288         mapping(uint256 => uint256) stakedDate;
1289         // TokenId => Mining Power
1290           mapping(uint256 => uint256) miningPower;
1291         uint256 amountStaked;
1292         mapping(uint256 => uint256) lastRewardUpdated;
1293     }
1294 
1295     struct MintingPowerProofs {
1296         bytes32[] proof;
1297     }
1298 
1299     /**
1300      *    @notice map User Addresses to their info
1301      */
1302     mapping(address => UserInfo) public stakeUserInfo;
1303 
1304     /**
1305      *    @notice staked nft => user address
1306      */
1307     mapping(uint256 => address) public tokenOwners;
1308 
1309     address InulandCollectionAddress;
1310     address private contractExtension;
1311 
1312     uint256 dailyReward = 1 ether;
1313     uint256[] boosters = [102, 104, 105, 106, 107, 108, 109];
1314     uint256 rewardInterwal = 86400;
1315 
1316     bytes32 private miningPowerRoot;
1317 
1318     modifier onlyExtensionContract() {
1319         require(msg.sender == contractExtension);
1320         _;
1321     }
1322 
1323 
1324 // Verify that a given leaf is in the tree.
1325     function _verify(
1326         bytes32 _leafNode,
1327         bytes32[] memory proof
1328     ) internal view returns (bool) {
1329         return MerkleProof.verify(proof, miningPowerRoot, _leafNode);
1330     }
1331 
1332     // Generate the leaf node (just the hash of tokenID concatenated with the account address)
1333     function _leaf(uint256[] memory miningLeaf) internal pure returns (bytes32) {
1334         return keccak256(abi.encodePacked(miningLeaf));
1335     }
1336 
1337     
1338 
1339     function setMiningPowerRoot(bytes32 _root) public onlyOwner {
1340         miningPowerRoot = _root;
1341     }
1342 
1343     //initital minting for Launch pads | Liquidity
1344     function mint(address _to, uint256 _amount) public onlyOwner {
1345         _mint(_to, _amount);
1346     }
1347 
1348     function setRewardInterval(uint256 _interval) public onlyOwner{
1349         rewardInterwal = _interval;
1350     }
1351 
1352     //extending functions for Furture upgrades
1353     function setContractExtension(address _contractExtenstion)
1354         public
1355         onlyOwner
1356     {
1357         contractExtension = _contractExtenstion;
1358     }
1359 
1360     function mintFromExtentionContract(address _to, uint256 _amount)
1361         external
1362         onlyExtensionContract
1363     {
1364         _mint(_to, _amount);
1365     }
1366 
1367     function burnFromExtentionContract(address _to, uint256 _amount)
1368         external
1369         onlyExtensionContract
1370     {
1371         _burn(_to, _amount);
1372     }
1373 
1374     constructor(address _inulandCollectionAddress) {
1375         InulandCollectionAddress = _inulandCollectionAddress;
1376     }
1377 
1378   
1379 
1380     function setBooster(uint256[] memory _booster) public onlyOwner {
1381         boosters = _booster;
1382     }
1383 
1384     function setDailyReward(uint256 _dailyReward) public onlyOwner {
1385         //wei
1386         dailyReward = _dailyReward;
1387     }
1388 
1389     function stake(uint256 _id, uint256 _lockedDays, uint256 _miningPower, bytes32[] calldata _proof) public {
1390         _stake(msg.sender, _id, _lockedDays,_miningPower, _proof);
1391     }
1392 
1393     function batchStake(uint256[] memory _ids, uint256 _lockedDays, uint256[] memory _miningPower, MintingPowerProofs[] calldata proofs) public {
1394         for (uint256 i = 0; i < _ids.length; ++i) {
1395             _stake(msg.sender, _ids[i], _lockedDays, _miningPower[i], proofs[i].proof);
1396         }
1397     }
1398 
1399     function unstake(uint256 _id) public {
1400         _unstake(msg.sender, _id);
1401     }
1402 
1403     function batchUnstake(uint256[] memory _ids) public {
1404         for (uint256 i = 0; i < _ids.length; ++i) {
1405             _unstake(msg.sender, _ids[i]);
1406         }
1407     }
1408 
1409     
1410 
1411     function claimRewards() public {
1412         uint256 rewards = getStakingRewards(msg.sender);
1413         _mint(msg.sender, rewards);
1414         //update last reward date
1415         _updateLastUpdated(msg.sender);
1416     }
1417 
1418     function _updateLastUpdated(address _user) internal {
1419         UserInfo storage user = stakeUserInfo[_user];
1420         for (uint256 i; i < user.stakedTokens.length; i++) {
1421             user.lastRewardUpdated[user.stakedTokens[i]] = block.timestamp;
1422         }
1423     }
1424 
1425     function getMiningPower(address _user, uint256 _tokenId) public  view returns (uint256){
1426          UserInfo storage user = stakeUserInfo[_user];
1427          return user.miningPower[_tokenId];
1428     }
1429 
1430     function getStakingRewards(address _user) public view returns (uint256) {
1431         uint256 time = block.timestamp;
1432         UserInfo storage user = stakeUserInfo[_user];
1433         uint256 clamableRewards;
1434         for (uint256 i; i < user.stakedTokens.length; i++) {
1435             if (user.stakedTokens[i] != 0) {
1436                 uint256 nftMiningPower = user.miningPower[user.stakedTokens[i]];
1437                 //first time
1438                 if (user.lastRewardUpdated[user.stakedTokens[i]] == 0) {
1439                     if (user.stakedDate[user.stakedTokens[i]] == 0) {
1440                         clamableRewards += 0;
1441                     } else {
1442                         uint256 normalReward = dailyReward
1443                             .mul(
1444                                 time.sub(user.stakedDate[user.stakedTokens[i]])
1445                             )
1446                             .div(rewardInterwal)
1447                             .mul(nftMiningPower);
1448                         //calculate locked day rewards
1449                         if (user.lockedDays[user.stakedTokens[i]] == 14) {
1450                             clamableRewards += (normalReward * 112) / 100;
1451                         } else if (
1452                             user.lockedDays[user.stakedTokens[i]] == 30
1453                         ) {
1454                             clamableRewards += (normalReward * 140) / 100;
1455                         } else if (
1456                             user.lockedDays[user.stakedTokens[i]] == 60
1457                         ) {
1458                             clamableRewards += (normalReward * 180) / 100;
1459                         } else if (
1460                             user.lockedDays[user.stakedTokens[i]] == 90
1461                         ) {
1462                             clamableRewards += (normalReward * 200) / 100;
1463                         } else {
1464                             clamableRewards += (normalReward * 112) / 100;
1465                         }
1466                     }
1467                 } else {
1468                     //calculate rewards from the last reward updated date
1469                     uint256 normalReward = dailyReward
1470                         .mul(
1471                             time.sub(
1472                                 user.lastRewardUpdated[user.stakedTokens[i]]
1473                             )
1474                         )
1475                         .div(rewardInterwal);
1476                     //calculate locked day rewards
1477                     if (user.lockedDays[user.stakedTokens[i]] == 14) {
1478                         clamableRewards += (normalReward * 112) / 100;
1479                     } else if (user.lockedDays[user.stakedTokens[i]] == 30) {
1480                         clamableRewards += (normalReward * 140) / 100;
1481                     } else if (user.lockedDays[user.stakedTokens[i]] == 60) {
1482                         clamableRewards += (normalReward * 180) / 100;
1483                     } else if (user.lockedDays[user.stakedTokens[i]] == 90) {
1484                         clamableRewards += (normalReward * 200) / 100;
1485                     } else {
1486                         clamableRewards += (normalReward * 112) / 100;
1487                     }
1488                 }
1489             }
1490         }
1491 
1492         //booster rewards
1493         // [102,104,105,106,107,108,109];
1494         if (user.amountStaked >= 35) {
1495             clamableRewards = clamableRewards.mul(boosters[6]).div(100);
1496         } else if (user.amountStaked >= 30) {
1497             clamableRewards = clamableRewards.mul(boosters[5]).div(100);
1498         } else if (user.amountStaked >= 25) {
1499             clamableRewards = clamableRewards.mul(boosters[4]).div(100);
1500         } else if (user.amountStaked >= 20) {
1501             clamableRewards = clamableRewards.mul(boosters[3]).div(100);
1502         } else if (user.amountStaked >= 15) {
1503             clamableRewards = clamableRewards.mul(boosters[2]).div(100);
1504         } else if (user.amountStaked >= 10) {
1505             clamableRewards = clamableRewards.mul(boosters[1]).div(100);
1506         } else if (user.amountStaked >= 5) {
1507             clamableRewards = clamableRewards.mul(boosters[0]).div(100);
1508         }
1509 
1510         return clamableRewards;
1511     }
1512     function testVerify( bytes32[] calldata proof, uint256 id, uint256 power) public view {
1513       uint256[] memory t = new uint256[](2);
1514           t[0] = id;
1515           t[1] = power;
1516              require(
1517                     _verify(_leaf(t), proof),
1518                     "Invalid proof"
1519                 );
1520     }
1521 
1522     function _stake(
1523         address _user,
1524         uint256 _id,
1525         uint256 _lockedDays,
1526         uint256 _miningPower,
1527         bytes32[] calldata proof
1528     ) internal {
1529          uint256[] memory t = new uint256[](2);
1530 
1531         UserInfo storage user = stakeUserInfo[_user];
1532         t[0] = _id;
1533         t[1] = _miningPower;
1534          require(
1535                     _verify(_leaf(t), proof),
1536                     "Invalid Mining Data proof"
1537                 );
1538 
1539         IERC721(InulandCollectionAddress).transferFrom(
1540             _user,
1541             address(this),
1542             _id
1543         );
1544         user.miningPower[_id] = _miningPower;
1545         user.amountStaked += 1;
1546         user.stakedDate[_id] = block.timestamp;
1547         user.lockedDays[_id] = _lockedDays;
1548         user.stakedTokens.push(_id);
1549         tokenOwners[_id] = _user;
1550     }
1551 
1552     function whenUnstake(address _user, uint256 _id) public  view returns (bool,uint256){
1553          UserInfo storage user = stakeUserInfo[_user];
1554             if( block.timestamp > (user.stakedDate[_id] + (user.lockedDays[_id] * rewardInterwal)) ){
1555                 return (true, block.timestamp - (user.stakedDate[_id] + (user.lockedDays[_id] * rewardInterwal)));
1556             }else{
1557                 return (true, block.timestamp - (user.stakedDate[_id] + (user.lockedDays[_id] * rewardInterwal)));
1558             }
1559     }
1560 
1561     function _unstake(address _user, uint256 _id) internal {
1562         UserInfo storage user = stakeUserInfo[_user];
1563 
1564         require(
1565             tokenOwners[_id] == _user,
1566             "Inuland._unstake: Sender doesn't owns this token"
1567         );
1568         //check locked 
1569         require( block.timestamp > (user.stakedDate[_id] + (user.lockedDays[_id] * rewardInterwal)), "You cant Unstake right now");
1570         _removeElement(user.stakedTokens, _id);
1571         user.amountStaked -= 1;
1572         delete tokenOwners[_id];
1573 
1574         if (user.stakedTokens.length == 0) {
1575             delete stakeUserInfo[_user];
1576         }
1577 
1578         IERC721(InulandCollectionAddress).transferFrom(
1579             address(this),
1580             _user,
1581             _id
1582         );
1583     }
1584 
1585     //-------------------------------Functions for website-------------------------------/
1586 
1587     function getUserInfo(address _user) public view returns (uint256[] memory) {
1588         UserInfo storage user = stakeUserInfo[_user];
1589 
1590         return (user.stakedTokens);
1591     }
1592 
1593     function getLockedDays(uint256 _id) public view returns (uint256) {
1594         UserInfo storage user = stakeUserInfo[tokenOwners[_id]];
1595         return user.lockedDays[_id];
1596     }
1597 
1598     function getStakedDate(uint256 _id) public view returns (uint256) {
1599         UserInfo storage user = stakeUserInfo[tokenOwners[_id]];
1600         return user.stakedDate[_id];
1601     }
1602 
1603      function _removeElement(uint256[] storage _array, uint256 _element) internal {
1604         for (uint256 i; i < _array.length; i++) {
1605             if (_array[i] == _element) {
1606                 _array[i] = _array[_array.length - 1];
1607                 _array.pop();
1608                 break;
1609             }
1610         }
1611     }
1612 }