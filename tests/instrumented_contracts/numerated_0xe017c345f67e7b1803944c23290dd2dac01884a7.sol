1 //                                                  zr
2 //                                               Yt$$$.
3 //                                            .,e$$$$$F'
4 //                          4e r               $$$$$$$.
5 //                          d$$br            _z$$$$$$$F`
6 //                           ?$$b._          ^?$$$$$$$
7 //                            4$$$"     -eec.  ""JP" ..eee$%..
8 //                            -**N #c   -^***.eE  ^z$P$$$$$$$$$r-
9 //                   .ze$$$$$eu?$eu '$$$$b $=^*$$ .$$$$$$$$$$"
10 //                --."?$$$$$$$$$c"$$c .""" e$K  =""*?$$$P""""
11 //    ueee. `:`  $E !!h ?$$$$$$$$b R$N'~!! *$$F J"""C.  `
12 //   J  `"$$eu`!h !!!`4!!<?$$$$$$$P ?".eee-z.ee" ~$$e.br
13 //   'j$$Ne`?$$c`4!~`-e-:!:`$$$$$$$ $$**"z $^R$P  3 "$$$bJ
14 //    4$$$F".`?$$c`!! \).!!!`?$$$$F.$$$# $u$% ee*"^ :4`"$"?$q
15 //     ""`,!!!:`$$N.4!!~~.~~4 ?$$F'$$F.@.* -L.e@$$$$ec.      "
16 //     "Rr`!!!!h ?$$c`h: `# !! $F,r4$L***  e$$$$$$$$$$$$hc
17 //       #e'4!!!!L`$$b'!.:!h`~~ .$F'"    d$$$$$$$$$$$$$$$$$h,
18 //        ^$.`!!!!h $$b`!. -    $P /'   .$$$$$$$$$$$$$$$$$$$$$c
19 //          "$c`!!!h`$$.4~      $$$r'   <$$$$$$$$$$$$$$$$$$$P"""
20 //            ^te.`~ $$b        `Fue-   `$$$$$$$$$$$$$$P".:  !! "<
21 //               ^"=4$P"     .,,,. -^.   ?$$$$$$$$$$"?:. !! :!!~ ,,ec..
22 //                     ..z$$$$$$$$$h,    `$$$$$$P"..`!f :!f ~)Lze$$$P""""?i
23 //                   ud$$$$$$$$$$$$$$h    `?$$F <!!'<!>:~)ue$$P*"..:!!!!! J
24 //                 .K$$$$$$$$$$$$$$$$$,     P.>e'!f !~ ed$$P".:!!!!!!!!`.d"
25 //                z$$$$$$$$$$$$$$$$$$$$      4!!~\e$$$P`:!!!!!!!!!!'.eP'
26 //               -*". . "??$$$$$$$$$$$$       ~ `z$$$F".`!!!!!!!!!!',dP"
27 //             ." ):!!h i`!- ("?$$$$$$f        ,$$P":! ). `'!!!!`,d$F'
28 //        .ueeeu.J`-^.!h <-  ~`.. ??$$'       ,$$ :!!`e$$$$e `,e$F'
29 //     e$$$$$$$$$$$$$eeiC ")?:-<:%':^?        ?$f !!! ?$$$$",F"
30 //    P"....```""?$$$$$$$$$euL^.!..` .         "Tu._.,``""
31 //    $ !!!!!!!!!!::.""??$$$$$$eJ~^=.            ````
32 //    ?$.`!!!!!!!!!!!!!!:."??$$$$$c'.
33 //     "?b.`!!!!!!!!!!!!!!!!>."?$$$$c
34 //       ^?$c`'!!!!!!!!!!!',eeb, "$$$k
35 //          "?$e.`'!!!!!!! $$$$$ ;.?$$
36 //             "?$ee,``''!."?$P`i!! 3P
37 //                 ""??$bec,,.,ceeeP"
38 //                        `""""""
39 
40 
41 //Santametti (SANTA) is a fine art NFT collection from artist Pumpametti. This is a holiday free mint for all Metti ETH NFT holders. 
42 //Total 1000 SANTA available. 
43 //VIP reserved free mint for Pumpametti holders, 300 SANTA available. 
44 //First-come-frist-serve free mint Pettametti/Standametti/MettiLandscape holders, 700 SANTA available. 
45 //Only 1 SANTA per transaction.
46 //For Pumpa holders please select "PumpaFirstChoiceVIPMint".
47 //For Petta holders please select "PettaVernissageMint".
48 //For Standa holders please select "StandaPrivateMint".
49 //For MettiLandscape please select 'LandscapePrivateMint".
50 //No public mint, you have to own a Metti to mint a SANTA.
51 //Only mint from contract.
52 //https://www.pumpametti.com/santametti
53 //https://twitter.com/pumpametti
54 
55 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
56 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
57 
58 pragma solidity ^0.8.0;
59 
60 // CAUTION
61 // This version of SafeMath should only be used with Solidity 0.8 or later,
62 // because it relies on the compiler's built in overflow checks.
63 
64 /**
65  * @dev Wrappers over Solidity's arithmetic operations.
66  *
67  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
68  * now has built in overflow checking.
69  */
70 library SafeMath {
71     /**
72      * @dev Returns the addition of two unsigned integers, with an overflow flag.
73      *
74      * _Available since v3.4._
75      */
76     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
77         unchecked {
78             uint256 c = a + b;
79             if (c < a) return (false, 0);
80             return (true, c);
81         }
82     }
83 
84     /**
85      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
86      *
87      * _Available since v3.4._
88      */
89     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
90         unchecked {
91             if (b > a) return (false, 0);
92             return (true, a - b);
93         }
94     }
95 
96     /**
97      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
98      *
99      * _Available since v3.4._
100      */
101     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
102         unchecked {
103             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
104             // benefit is lost if 'b' is also tested.
105             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
106             if (a == 0) return (true, 0);
107             uint256 c = a * b;
108             if (c / a != b) return (false, 0);
109             return (true, c);
110         }
111     }
112 
113     /**
114      * @dev Returns the division of two unsigned integers, with a division by zero flag.
115      *
116      * _Available since v3.4._
117      */
118     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
119         unchecked {
120             if (b == 0) return (false, 0);
121             return (true, a / b);
122         }
123     }
124 
125     /**
126      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
127      *
128      * _Available since v3.4._
129      */
130     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
131         unchecked {
132             if (b == 0) return (false, 0);
133             return (true, a % b);
134         }
135     }
136 
137     /**
138      * @dev Returns the addition of two unsigned integers, reverting on
139      * overflow.
140      *
141      * Counterpart to Solidity's `+` operator.
142      *
143      * Requirements:
144      *
145      * - Addition cannot overflow.
146      */
147     function add(uint256 a, uint256 b) internal pure returns (uint256) {
148         return a + b;
149     }
150 
151     /**
152      * @dev Returns the subtraction of two unsigned integers, reverting on
153      * overflow (when the result is negative).
154      *
155      * Counterpart to Solidity's `-` operator.
156      *
157      * Requirements:
158      *
159      * - Subtraction cannot overflow.
160      */
161     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
162         return a - b;
163     }
164 
165     /**
166      * @dev Returns the multiplication of two unsigned integers, reverting on
167      * overflow.
168      *
169      * Counterpart to Solidity's `*` operator.
170      *
171      * Requirements:
172      *
173      * - Multiplication cannot overflow.
174      */
175     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
176         return a * b;
177     }
178 
179     /**
180      * @dev Returns the integer division of two unsigned integers, reverting on
181      * division by zero. The result is rounded towards zero.
182      *
183      * Counterpart to Solidity's `/` operator.
184      *
185      * Requirements:
186      *
187      * - The divisor cannot be zero.
188      */
189     function div(uint256 a, uint256 b) internal pure returns (uint256) {
190         return a / b;
191     }
192 
193     /**
194      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
195      * reverting when dividing by zero.
196      *
197      * Counterpart to Solidity's `%` operator. This function uses a `revert`
198      * opcode (which leaves remaining gas untouched) while Solidity uses an
199      * invalid opcode to revert (consuming all remaining gas).
200      *
201      * Requirements:
202      *
203      * - The divisor cannot be zero.
204      */
205     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
206         return a % b;
207     }
208 
209     /**
210      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
211      * overflow (when the result is negative).
212      *
213      * CAUTION: This function is deprecated because it requires allocating memory for the error
214      * message unnecessarily. For custom revert reasons use {trySub}.
215      *
216      * Counterpart to Solidity's `-` operator.
217      *
218      * Requirements:
219      *
220      * - Subtraction cannot overflow.
221      */
222     function sub(
223         uint256 a,
224         uint256 b,
225         string memory errorMessage
226     ) internal pure returns (uint256) {
227         unchecked {
228             require(b <= a, errorMessage);
229             return a - b;
230         }
231     }
232 
233     /**
234      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
235      * division by zero. The result is rounded towards zero.
236      *
237      * Counterpart to Solidity's `/` operator. Note: this function uses a
238      * `revert` opcode (which leaves remaining gas untouched) while Solidity
239      * uses an invalid opcode to revert (consuming all remaining gas).
240      *
241      * Requirements:
242      *
243      * - The divisor cannot be zero.
244      */
245     function div(
246         uint256 a,
247         uint256 b,
248         string memory errorMessage
249     ) internal pure returns (uint256) {
250         unchecked {
251             require(b > 0, errorMessage);
252             return a / b;
253         }
254     }
255 
256     /**
257      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
258      * reverting with custom message when dividing by zero.
259      *
260      * CAUTION: This function is deprecated because it requires allocating memory for the error
261      * message unnecessarily. For custom revert reasons use {tryMod}.
262      *
263      * Counterpart to Solidity's `%` operator. This function uses a `revert`
264      * opcode (which leaves remaining gas untouched) while Solidity uses an
265      * invalid opcode to revert (consuming all remaining gas).
266      *
267      * Requirements:
268      *
269      * - The divisor cannot be zero.
270      */
271     function mod(
272         uint256 a,
273         uint256 b,
274         string memory errorMessage
275     ) internal pure returns (uint256) {
276         unchecked {
277             require(b > 0, errorMessage);
278             return a % b;
279         }
280     }
281 }
282 
283 // File: @openzeppelin/contracts/utils/Strings.sol
284 
285 
286 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
287 
288 pragma solidity ^0.8.0;
289 
290 /**
291  * @dev String operations.
292  */
293 library Strings {
294     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
295 
296     /**
297      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
298      */
299     function toString(uint256 value) internal pure returns (string memory) {
300         // Inspired by OraclizeAPI's implementation - MIT licence
301         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
302 
303         if (value == 0) {
304             return "0";
305         }
306         uint256 temp = value;
307         uint256 digits;
308         while (temp != 0) {
309             digits++;
310             temp /= 10;
311         }
312         bytes memory buffer = new bytes(digits);
313         while (value != 0) {
314             digits -= 1;
315             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
316             value /= 10;
317         }
318         return string(buffer);
319     }
320 
321     /**
322      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
323      */
324     function toHexString(uint256 value) internal pure returns (string memory) {
325         if (value == 0) {
326             return "0x00";
327         }
328         uint256 temp = value;
329         uint256 length = 0;
330         while (temp != 0) {
331             length++;
332             temp >>= 8;
333         }
334         return toHexString(value, length);
335     }
336 
337     /**
338      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
339      */
340     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
341         bytes memory buffer = new bytes(2 * length + 2);
342         buffer[0] = "0";
343         buffer[1] = "x";
344         for (uint256 i = 2 * length + 1; i > 1; --i) {
345             buffer[i] = _HEX_SYMBOLS[value & 0xf];
346             value >>= 4;
347         }
348         require(value == 0, "Strings: hex length insufficient");
349         return string(buffer);
350     }
351 }
352 
353 // File: @openzeppelin/contracts/utils/Context.sol
354 
355 
356 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
357 
358 pragma solidity ^0.8.0;
359 
360 /**
361  * @dev Provides information about the current execution context, including the
362  * sender of the transaction and its data. While these are generally available
363  * via msg.sender and msg.data, they should not be accessed in such a direct
364  * manner, since when dealing with meta-transactions the account sending and
365  * paying for execution may not be the actual sender (as far as an application
366  * is concerned).
367  *
368  * This contract is only required for intermediate, library-like contracts.
369  */
370 abstract contract Context {
371     function _msgSender() internal view virtual returns (address) {
372         return msg.sender;
373     }
374 
375     function _msgData() internal view virtual returns (bytes calldata) {
376         return msg.data;
377     }
378 }
379 
380 // File: @openzeppelin/contracts/access/Ownable.sol
381 
382 
383 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
384 
385 pragma solidity ^0.8.0;
386 
387 
388 /**
389  * @dev Contract module which provides a basic access control mechanism, where
390  * there is an account (an owner) that can be granted exclusive access to
391  * specific functions.
392  *
393  * By default, the owner account will be the one that deploys the contract. This
394  * can later be changed with {transferOwnership}.
395  *
396  * This module is used through inheritance. It will make available the modifier
397  * `onlyOwner`, which can be applied to your functions to restrict their use to
398  * the owner.
399  */
400 abstract contract Ownable is Context {
401     address private _owner;
402 
403     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
404 
405     /**
406      * @dev Initializes the contract setting the deployer as the initial owner.
407      */
408     constructor() {
409         _transferOwnership(_msgSender());
410     }
411 
412     /**
413      * @dev Returns the address of the current owner.
414      */
415     function owner() public view virtual returns (address) {
416         return _owner;
417     }
418 
419     /**
420      * @dev Throws if called by any account other than the owner.
421      */
422     modifier onlyOwner() {
423         require(owner() == _msgSender(), "Ownable: caller is not the owner");
424         _;
425     }
426 
427     /**
428      * @dev Leaves the contract without owner. It will not be possible to call
429      * `onlyOwner` functions anymore. Can only be called by the current owner.
430      *
431      * NOTE: Renouncing ownership will leave the contract without an owner,
432      * thereby removing any functionality that is only available to the owner.
433      */
434     function renounceOwnership() public virtual onlyOwner {
435         _transferOwnership(address(0));
436     }
437 
438     /**
439      * @dev Transfers ownership of the contract to a new account (`newOwner`).
440      * Can only be called by the current owner.
441      */
442     function transferOwnership(address newOwner) public virtual onlyOwner {
443         require(newOwner != address(0), "Ownable: new owner is the zero address");
444         _transferOwnership(newOwner);
445     }
446 
447     /**
448      * @dev Transfers ownership of the contract to a new account (`newOwner`).
449      * Internal function without access restriction.
450      */
451     function _transferOwnership(address newOwner) internal virtual {
452         address oldOwner = _owner;
453         _owner = newOwner;
454         emit OwnershipTransferred(oldOwner, newOwner);
455     }
456 }
457 
458 // File: @openzeppelin/contracts/utils/Address.sol
459 
460 
461 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
462 
463 pragma solidity ^0.8.0;
464 
465 /**
466  * @dev Collection of functions related to the address type
467  */
468 library Address {
469     /**
470      * @dev Returns true if `account` is a contract.
471      *
472      * [IMPORTANT]
473      * ====
474      * It is unsafe to assume that an address for which this function returns
475      * false is an externally-owned account (EOA) and not a contract.
476      *
477      * Among others, `isContract` will return false for the following
478      * types of addresses:
479      *
480      *  - an externally-owned account
481      *  - a contract in construction
482      *  - an address where a contract will be created
483      *  - an address where a contract lived, but was destroyed
484      * ====
485      */
486     function isContract(address account) internal view returns (bool) {
487         // This method relies on extcodesize, which returns 0 for contracts in
488         // construction, since the code is only stored at the end of the
489         // constructor execution.
490 
491         uint256 size;
492         assembly {
493             size := extcodesize(account)
494         }
495         return size > 0;
496     }
497 
498     /**
499      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
500      * `recipient`, forwarding all available gas and reverting on errors.
501      *
502      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
503      * of certain opcodes, possibly making contracts go over the 2300 gas limit
504      * imposed by `transfer`, making them unable to receive funds via
505      * `transfer`. {sendValue} removes this limitation.
506      *
507      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
508      *
509      * IMPORTANT: because control is transferred to `recipient`, care must be
510      * taken to not create reentrancy vulnerabilities. Consider using
511      * {ReentrancyGuard} or the
512      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
513      */
514     function sendValue(address payable recipient, uint256 amount) internal {
515         require(address(this).balance >= amount, "Address: insufficient balance");
516 
517         (bool success, ) = recipient.call{value: amount}("");
518         require(success, "Address: unable to send value, recipient may have reverted");
519     }
520 
521     /**
522      * @dev Performs a Solidity function call using a low level `call`. A
523      * plain `call` is an unsafe replacement for a function call: use this
524      * function instead.
525      *
526      * If `target` reverts with a revert reason, it is bubbled up by this
527      * function (like regular Solidity function calls).
528      *
529      * Returns the raw returned data. To convert to the expected return value,
530      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
531      *
532      * Requirements:
533      *
534      * - `target` must be a contract.
535      * - calling `target` with `data` must not revert.
536      *
537      * _Available since v3.1._
538      */
539     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
540         return functionCall(target, data, "Address: low-level call failed");
541     }
542 
543     /**
544      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
545      * `errorMessage` as a fallback revert reason when `target` reverts.
546      *
547      * _Available since v3.1._
548      */
549     function functionCall(
550         address target,
551         bytes memory data,
552         string memory errorMessage
553     ) internal returns (bytes memory) {
554         return functionCallWithValue(target, data, 0, errorMessage);
555     }
556 
557     /**
558      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
559      * but also transferring `value` wei to `target`.
560      *
561      * Requirements:
562      *
563      * - the calling contract must have an ETH balance of at least `value`.
564      * - the called Solidity function must be `payable`.
565      *
566      * _Available since v3.1._
567      */
568     function functionCallWithValue(
569         address target,
570         bytes memory data,
571         uint256 value
572     ) internal returns (bytes memory) {
573         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
574     }
575 
576     /**
577      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
578      * with `errorMessage` as a fallback revert reason when `target` reverts.
579      *
580      * _Available since v3.1._
581      */
582     function functionCallWithValue(
583         address target,
584         bytes memory data,
585         uint256 value,
586         string memory errorMessage
587     ) internal returns (bytes memory) {
588         require(address(this).balance >= value, "Address: insufficient balance for call");
589         require(isContract(target), "Address: call to non-contract");
590 
591         (bool success, bytes memory returndata) = target.call{value: value}(data);
592         return verifyCallResult(success, returndata, errorMessage);
593     }
594 
595     /**
596      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
597      * but performing a static call.
598      *
599      * _Available since v3.3._
600      */
601     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
602         return functionStaticCall(target, data, "Address: low-level static call failed");
603     }
604 
605     /**
606      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
607      * but performing a static call.
608      *
609      * _Available since v3.3._
610      */
611     function functionStaticCall(
612         address target,
613         bytes memory data,
614         string memory errorMessage
615     ) internal view returns (bytes memory) {
616         require(isContract(target), "Address: static call to non-contract");
617 
618         (bool success, bytes memory returndata) = target.staticcall(data);
619         return verifyCallResult(success, returndata, errorMessage);
620     }
621 
622     /**
623      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
624      * but performing a delegate call.
625      *
626      * _Available since v3.4._
627      */
628     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
629         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
630     }
631 
632     /**
633      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
634      * but performing a delegate call.
635      *
636      * _Available since v3.4._
637      */
638     function functionDelegateCall(
639         address target,
640         bytes memory data,
641         string memory errorMessage
642     ) internal returns (bytes memory) {
643         require(isContract(target), "Address: delegate call to non-contract");
644 
645         (bool success, bytes memory returndata) = target.delegatecall(data);
646         return verifyCallResult(success, returndata, errorMessage);
647     }
648 
649     /**
650      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
651      * revert reason using the provided one.
652      *
653      * _Available since v4.3._
654      */
655     function verifyCallResult(
656         bool success,
657         bytes memory returndata,
658         string memory errorMessage
659     ) internal pure returns (bytes memory) {
660         if (success) {
661             return returndata;
662         } else {
663             // Look for revert reason and bubble it up if present
664             if (returndata.length > 0) {
665                 // The easiest way to bubble the revert reason is using memory via assembly
666 
667                 assembly {
668                     let returndata_size := mload(returndata)
669                     revert(add(32, returndata), returndata_size)
670                 }
671             } else {
672                 revert(errorMessage);
673             }
674         }
675     }
676 }
677 
678 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
679 
680 
681 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
682 
683 pragma solidity ^0.8.0;
684 
685 /**
686  * @title ERC721 token receiver interface
687  * @dev Interface for any contract that wants to support safeTransfers
688  * from ERC721 asset contracts.
689  */
690 interface IERC721Receiver {
691     /**
692      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
693      * by `operator` from `from`, this function is called.
694      *
695      * It must return its Solidity selector to confirm the token transfer.
696      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
697      *
698      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
699      */
700     function onERC721Received(
701         address operator,
702         address from,
703         uint256 tokenId,
704         bytes calldata data
705     ) external returns (bytes4);
706 }
707 
708 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
709 
710 
711 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
712 
713 pragma solidity ^0.8.0;
714 
715 /**
716  * @dev Interface of the ERC165 standard, as defined in the
717  * https://eips.ethereum.org/EIPS/eip-165[EIP].
718  *
719  * Implementers can declare support of contract interfaces, which can then be
720  * queried by others ({ERC165Checker}).
721  *
722  * For an implementation, see {ERC165}.
723  */
724 interface IERC165 {
725     /**
726      * @dev Returns true if this contract implements the interface defined by
727      * `interfaceId`. See the corresponding
728      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
729      * to learn more about how these ids are created.
730      *
731      * This function call must use less than 30 000 gas.
732      */
733     function supportsInterface(bytes4 interfaceId) external view returns (bool);
734 }
735 
736 // File: @openzeppelin/contracts/interfaces/IERC165.sol
737 
738 
739 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC165.sol)
740 
741 pragma solidity ^0.8.0;
742 
743 
744 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
745 
746 
747 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC2981.sol)
748 
749 pragma solidity ^0.8.0;
750 
751 
752 /**
753  * @dev Interface for the NFT Royalty Standard
754  */
755 interface IERC2981 is IERC165 {
756     /**
757      * @dev Called with the sale price to determine how much royalty is owed and to whom.
758      * @param tokenId - the NFT asset queried for royalty information
759      * @param salePrice - the sale price of the NFT asset specified by `tokenId`
760      * @return receiver - address of who should be sent the royalty payment
761      * @return royaltyAmount - the royalty payment amount for `salePrice`
762      */
763     function royaltyInfo(uint256 tokenId, uint256 salePrice)
764         external
765         view
766         returns (address receiver, uint256 royaltyAmount);
767 }
768 
769 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
770 
771 
772 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
773 
774 pragma solidity ^0.8.0;
775 
776 
777 /**
778  * @dev Implementation of the {IERC165} interface.
779  *
780  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
781  * for the additional interface id that will be supported. For example:
782  *
783  * ```solidity
784  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
785  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
786  * }
787  * ```
788  *
789  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
790  */
791 abstract contract ERC165 is IERC165 {
792     /**
793      * @dev See {IERC165-supportsInterface}.
794      */
795     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
796         return interfaceId == type(IERC165).interfaceId;
797     }
798 }
799 
800 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
801 
802 
803 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
804 
805 pragma solidity ^0.8.0;
806 
807 
808 /**
809  * @dev Required interface of an ERC721 compliant contract.
810  */
811 interface IERC721 is IERC165 {
812     /**
813      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
814      */
815     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
816 
817     /**
818      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
819      */
820     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
821 
822     /**
823      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
824      */
825     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
826 
827     /**
828      * @dev Returns the number of tokens in ``owner``'s account.
829      */
830     function balanceOf(address owner) external view returns (uint256 balance);
831 
832     /**
833      * @dev Returns the owner of the `tokenId` token.
834      *
835      * Requirements:
836      *
837      * - `tokenId` must exist.
838      */
839     function ownerOf(uint256 tokenId) external view returns (address owner);
840 
841     /**
842      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
843      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
844      *
845      * Requirements:
846      *
847      * - `from` cannot be the zero address.
848      * - `to` cannot be the zero address.
849      * - `tokenId` token must exist and be owned by `from`.
850      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
851      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
852      *
853      * Emits a {Transfer} event.
854      */
855     function safeTransferFrom(
856         address from,
857         address to,
858         uint256 tokenId
859     ) external;
860 
861     /**
862      * @dev Transfers `tokenId` token from `from` to `to`.
863      *
864      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
865      *
866      * Requirements:
867      *
868      * - `from` cannot be the zero address.
869      * - `to` cannot be the zero address.
870      * - `tokenId` token must be owned by `from`.
871      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
872      *
873      * Emits a {Transfer} event.
874      */
875     function transferFrom(
876         address from,
877         address to,
878         uint256 tokenId
879     ) external;
880 
881     /**
882      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
883      * The approval is cleared when the token is transferred.
884      *
885      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
886      *
887      * Requirements:
888      *
889      * - The caller must own the token or be an approved operator.
890      * - `tokenId` must exist.
891      *
892      * Emits an {Approval} event.
893      */
894     function approve(address to, uint256 tokenId) external;
895 
896     /**
897      * @dev Returns the account approved for `tokenId` token.
898      *
899      * Requirements:
900      *
901      * - `tokenId` must exist.
902      */
903     function getApproved(uint256 tokenId) external view returns (address operator);
904 
905     /**
906      * @dev Approve or remove `operator` as an operator for the caller.
907      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
908      *
909      * Requirements:
910      *
911      * - The `operator` cannot be the caller.
912      *
913      * Emits an {ApprovalForAll} event.
914      */
915     function setApprovalForAll(address operator, bool _approved) external;
916 
917     /**
918      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
919      *
920      * See {setApprovalForAll}
921      */
922     function isApprovedForAll(address owner, address operator) external view returns (bool);
923 
924     /**
925      * @dev Safely transfers `tokenId` token from `from` to `to`.
926      *
927      * Requirements:
928      *
929      * - `from` cannot be the zero address.
930      * - `to` cannot be the zero address.
931      * - `tokenId` token must exist and be owned by `from`.
932      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
933      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
934      *
935      * Emits a {Transfer} event.
936      */
937     function safeTransferFrom(
938         address from,
939         address to,
940         uint256 tokenId,
941         bytes calldata data
942     ) external;
943 }
944 
945 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
946 
947 
948 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
949 
950 pragma solidity ^0.8.0;
951 
952 
953 /**
954  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
955  * @dev See https://eips.ethereum.org/EIPS/eip-721
956  */
957 interface IERC721Enumerable is IERC721 {
958     /**
959      * @dev Returns the total amount of tokens stored by the contract.
960      */
961     function totalSupply() external view returns (uint256);
962 
963     /**
964      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
965      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
966      */
967     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
968 
969     /**
970      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
971      * Use along with {totalSupply} to enumerate all tokens.
972      */
973     function tokenByIndex(uint256 index) external view returns (uint256);
974 }
975 
976 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
977 
978 
979 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
980 
981 pragma solidity ^0.8.0;
982 
983 
984 /**
985  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
986  * @dev See https://eips.ethereum.org/EIPS/eip-721
987  */
988 interface IERC721Metadata is IERC721 {
989     /**
990      * @dev Returns the token collection name.
991      */
992     function name() external view returns (string memory);
993 
994     /**
995      * @dev Returns the token collection symbol.
996      */
997     function symbol() external view returns (string memory);
998 
999     /**
1000      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1001      */
1002     function tokenURI(uint256 tokenId) external view returns (string memory);
1003 }
1004 
1005 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1006 
1007 
1008 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
1009 
1010 pragma solidity ^0.8.0;
1011 
1012 
1013 
1014 
1015 
1016 
1017 
1018 
1019 /**
1020  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1021  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1022  * {ERC721Enumerable}.
1023  */
1024 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1025     using Address for address;
1026     using Strings for uint256;
1027 
1028     // Token name
1029     string private _name;
1030 
1031     // Token symbol
1032     string private _symbol;
1033 
1034     // Mapping from token ID to owner address
1035     mapping(uint256 => address) private _owners;
1036 
1037     // Mapping owner address to token count
1038     mapping(address => uint256) private _balances;
1039 
1040     // Mapping from token ID to approved address
1041     mapping(uint256 => address) private _tokenApprovals;
1042 
1043     // Mapping from owner to operator approvals
1044     mapping(address => mapping(address => bool)) private _operatorApprovals;
1045 
1046     /**
1047      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1048      */
1049     constructor(string memory name_, string memory symbol_) {
1050         _name = name_;
1051         _symbol = symbol_;
1052     }
1053 
1054     /**
1055      * @dev See {IERC165-supportsInterface}.
1056      */
1057     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1058         return
1059             interfaceId == type(IERC721).interfaceId ||
1060             interfaceId == type(IERC721Metadata).interfaceId ||
1061             super.supportsInterface(interfaceId);
1062     }
1063 
1064     /**
1065      * @dev See {IERC721-balanceOf}.
1066      */
1067     function balanceOf(address owner) public view virtual override returns (uint256) {
1068         require(owner != address(0), "ERC721: balance query for the zero address");
1069         return _balances[owner];
1070     }
1071 
1072     /**
1073      * @dev See {IERC721-ownerOf}.
1074      */
1075     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1076         address owner = _owners[tokenId];
1077         require(owner != address(0), "ERC721: owner query for nonexistent token");
1078         return owner;
1079     }
1080 
1081     /**
1082      * @dev See {IERC721Metadata-name}.
1083      */
1084     function name() public view virtual override returns (string memory) {
1085         return _name;
1086     }
1087 
1088     /**
1089      * @dev See {IERC721Metadata-symbol}.
1090      */
1091     function symbol() public view virtual override returns (string memory) {
1092         return _symbol;
1093     }
1094 
1095     /**
1096      * @dev See {IERC721Metadata-tokenURI}.
1097      */
1098     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1099         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1100 
1101         string memory baseURI = _baseURI();
1102         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1103     }
1104 
1105     /**
1106      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1107      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1108      * by default, can be overriden in child contracts.
1109      */
1110     function _baseURI() internal view virtual returns (string memory) {
1111         return "";
1112     }
1113 
1114     /**
1115      * @dev See {IERC721-approve}.
1116      */
1117     function approve(address to, uint256 tokenId) public virtual override {
1118         address owner = ERC721.ownerOf(tokenId);
1119         require(to != owner, "ERC721: approval to current owner");
1120 
1121         require(
1122             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1123             "ERC721: approve caller is not owner nor approved for all"
1124         );
1125 
1126         _approve(to, tokenId);
1127     }
1128 
1129     /**
1130      * @dev See {IERC721-getApproved}.
1131      */
1132     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1133         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1134 
1135         return _tokenApprovals[tokenId];
1136     }
1137 
1138     /**
1139      * @dev See {IERC721-setApprovalForAll}.
1140      */
1141     function setApprovalForAll(address operator, bool approved) public virtual override {
1142         _setApprovalForAll(_msgSender(), operator, approved);
1143     }
1144 
1145     /**
1146      * @dev See {IERC721-isApprovedForAll}.
1147      */
1148     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1149         return _operatorApprovals[owner][operator];
1150     }
1151 
1152     /**
1153      * @dev See {IERC721-transferFrom}.
1154      */
1155     function transferFrom(
1156         address from,
1157         address to,
1158         uint256 tokenId
1159     ) public virtual override {
1160         //solhint-disable-next-line max-line-length
1161         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1162 
1163         _transfer(from, to, tokenId);
1164     }
1165 
1166     /**
1167      * @dev See {IERC721-safeTransferFrom}.
1168      */
1169     function safeTransferFrom(
1170         address from,
1171         address to,
1172         uint256 tokenId
1173     ) public virtual override {
1174         safeTransferFrom(from, to, tokenId, "");
1175     }
1176 
1177     /**
1178      * @dev See {IERC721-safeTransferFrom}.
1179      */
1180     function safeTransferFrom(
1181         address from,
1182         address to,
1183         uint256 tokenId,
1184         bytes memory _data
1185     ) public virtual override {
1186         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1187         _safeTransfer(from, to, tokenId, _data);
1188     }
1189 
1190     /**
1191      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1192      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1193      *
1194      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1195      *
1196      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1197      * implement alternative mechanisms to perform token transfer, such as signature-based.
1198      *
1199      * Requirements:
1200      *
1201      * - `from` cannot be the zero address.
1202      * - `to` cannot be the zero address.
1203      * - `tokenId` token must exist and be owned by `from`.
1204      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1205      *
1206      * Emits a {Transfer} event.
1207      */
1208     function _safeTransfer(
1209         address from,
1210         address to,
1211         uint256 tokenId,
1212         bytes memory _data
1213     ) internal virtual {
1214         _transfer(from, to, tokenId);
1215         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1216     }
1217 
1218     /**
1219      * @dev Returns whether `tokenId` exists.
1220      *
1221      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1222      *
1223      * Tokens start existing when they are minted (`_mint`),
1224      * and stop existing when they are burned (`_burn`).
1225      */
1226     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1227         return _owners[tokenId] != address(0);
1228     }
1229 
1230     /**
1231      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1232      *
1233      * Requirements:
1234      *
1235      * - `tokenId` must exist.
1236      */
1237     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1238         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1239         address owner = ERC721.ownerOf(tokenId);
1240         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1241     }
1242 
1243     /**
1244      * @dev Safely mints `tokenId` and transfers it to `to`.
1245      *
1246      * Requirements:
1247      *
1248      * - `tokenId` must not exist.
1249      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1250      *
1251      * Emits a {Transfer} event.
1252      */
1253     function _safeMint(address to, uint256 tokenId) internal virtual {
1254         _safeMint(to, tokenId, "");
1255     }
1256 
1257     /**
1258      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1259      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1260      */
1261     function _safeMint(
1262         address to,
1263         uint256 tokenId,
1264         bytes memory _data
1265     ) internal virtual {
1266         _mint(to, tokenId);
1267         require(
1268             _checkOnERC721Received(address(0), to, tokenId, _data),
1269             "ERC721: transfer to non ERC721Receiver implementer"
1270         );
1271     }
1272 
1273     /**
1274      * @dev Mints `tokenId` and transfers it to `to`.
1275      *
1276      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1277      *
1278      * Requirements:
1279      *
1280      * - `tokenId` must not exist.
1281      * - `to` cannot be the zero address.
1282      *
1283      * Emits a {Transfer} event.
1284      */
1285     function _mint(address to, uint256 tokenId) internal virtual {
1286         require(to != address(0), "ERC721: mint to the zero address");
1287         require(!_exists(tokenId), "ERC721: token already minted");
1288 
1289         _beforeTokenTransfer(address(0), to, tokenId);
1290 
1291         _balances[to] += 1;
1292         _owners[tokenId] = to;
1293 
1294         emit Transfer(address(0), to, tokenId);
1295     }
1296 
1297     /**
1298      * @dev Destroys `tokenId`.
1299      * The approval is cleared when the token is burned.
1300      *
1301      * Requirements:
1302      *
1303      * - `tokenId` must exist.
1304      *
1305      * Emits a {Transfer} event.
1306      */
1307     function _burn(uint256 tokenId) internal virtual {
1308         address owner = ERC721.ownerOf(tokenId);
1309 
1310         _beforeTokenTransfer(owner, address(0), tokenId);
1311 
1312         // Clear approvals
1313         _approve(address(0), tokenId);
1314 
1315         _balances[owner] -= 1;
1316         delete _owners[tokenId];
1317 
1318         emit Transfer(owner, address(0), tokenId);
1319     }
1320 
1321     /**
1322      * @dev Transfers `tokenId` from `from` to `to`.
1323      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1324      *
1325      * Requirements:
1326      *
1327      * - `to` cannot be the zero address.
1328      * - `tokenId` token must be owned by `from`.
1329      *
1330      * Emits a {Transfer} event.
1331      */
1332     function _transfer(
1333         address from,
1334         address to,
1335         uint256 tokenId
1336     ) internal virtual {
1337         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1338         require(to != address(0), "ERC721: transfer to the zero address");
1339 
1340         _beforeTokenTransfer(from, to, tokenId);
1341 
1342         // Clear approvals from the previous owner
1343         _approve(address(0), tokenId);
1344 
1345         _balances[from] -= 1;
1346         _balances[to] += 1;
1347         _owners[tokenId] = to;
1348 
1349         emit Transfer(from, to, tokenId);
1350     }
1351 
1352     /**
1353      * @dev Approve `to` to operate on `tokenId`
1354      *
1355      * Emits a {Approval} event.
1356      */
1357     function _approve(address to, uint256 tokenId) internal virtual {
1358         _tokenApprovals[tokenId] = to;
1359         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1360     }
1361 
1362     /**
1363      * @dev Approve `operator` to operate on all of `owner` tokens
1364      *
1365      * Emits a {ApprovalForAll} event.
1366      */
1367     function _setApprovalForAll(
1368         address owner,
1369         address operator,
1370         bool approved
1371     ) internal virtual {
1372         require(owner != operator, "ERC721: approve to caller");
1373         _operatorApprovals[owner][operator] = approved;
1374         emit ApprovalForAll(owner, operator, approved);
1375     }
1376 
1377     /**
1378      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1379      * The call is not executed if the target address is not a contract.
1380      *
1381      * @param from address representing the previous owner of the given token ID
1382      * @param to target address that will receive the tokens
1383      * @param tokenId uint256 ID of the token to be transferred
1384      * @param _data bytes optional data to send along with the call
1385      * @return bool whether the call correctly returned the expected magic value
1386      */
1387     function _checkOnERC721Received(
1388         address from,
1389         address to,
1390         uint256 tokenId,
1391         bytes memory _data
1392     ) private returns (bool) {
1393         if (to.isContract()) {
1394             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1395                 return retval == IERC721Receiver.onERC721Received.selector;
1396             } catch (bytes memory reason) {
1397                 if (reason.length == 0) {
1398                     revert("ERC721: transfer to non ERC721Receiver implementer");
1399                 } else {
1400                     assembly {
1401                         revert(add(32, reason), mload(reason))
1402                     }
1403                 }
1404             }
1405         } else {
1406             return true;
1407         }
1408     }
1409 
1410     /**
1411      * @dev Hook that is called before any token transfer. This includes minting
1412      * and burning.
1413      *
1414      * Calling conditions:
1415      *
1416      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1417      * transferred to `to`.
1418      * - When `from` is zero, `tokenId` will be minted for `to`.
1419      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1420      * - `from` and `to` are never both zero.
1421      *
1422      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1423      */
1424     function _beforeTokenTransfer(
1425         address from,
1426         address to,
1427         uint256 tokenId
1428     ) internal virtual {}
1429 }
1430 
1431 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1432 
1433 
1434 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1435 
1436 pragma solidity ^0.8.0;
1437 
1438 
1439 
1440 /**
1441  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1442  * enumerability of all the token ids in the contract as well as all token ids owned by each
1443  * account.
1444  */
1445 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1446     // Mapping from owner to list of owned token IDs
1447     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1448 
1449     // Mapping from token ID to index of the owner tokens list
1450     mapping(uint256 => uint256) private _ownedTokensIndex;
1451 
1452     // Array with all token ids, used for enumeration
1453     uint256[] private _allTokens;
1454 
1455     // Mapping from token id to position in the allTokens array
1456     mapping(uint256 => uint256) private _allTokensIndex;
1457 
1458     /**
1459      * @dev See {IERC165-supportsInterface}.
1460      */
1461     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1462         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1463     }
1464 
1465     /**
1466      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1467      */
1468     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1469         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1470         return _ownedTokens[owner][index];
1471     }
1472 
1473     /**
1474      * @dev See {IERC721Enumerable-totalSupply}.
1475      */
1476     function totalSupply() public view virtual override returns (uint256) {
1477         return _allTokens.length;
1478     }
1479 
1480     /**
1481      * @dev See {IERC721Enumerable-tokenByIndex}.
1482      */
1483     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1484         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1485         return _allTokens[index];
1486     }
1487 
1488     /**
1489      * @dev Hook that is called before any token transfer. This includes minting
1490      * and burning.
1491      *
1492      * Calling conditions:
1493      *
1494      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1495      * transferred to `to`.
1496      * - When `from` is zero, `tokenId` will be minted for `to`.
1497      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1498      * - `from` cannot be the zero address.
1499      * - `to` cannot be the zero address.
1500      *
1501      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1502      */
1503     function _beforeTokenTransfer(
1504         address from,
1505         address to,
1506         uint256 tokenId
1507     ) internal virtual override {
1508         super._beforeTokenTransfer(from, to, tokenId);
1509 
1510         if (from == address(0)) {
1511             _addTokenToAllTokensEnumeration(tokenId);
1512         } else if (from != to) {
1513             _removeTokenFromOwnerEnumeration(from, tokenId);
1514         }
1515         if (to == address(0)) {
1516             _removeTokenFromAllTokensEnumeration(tokenId);
1517         } else if (to != from) {
1518             _addTokenToOwnerEnumeration(to, tokenId);
1519         }
1520     }
1521 
1522     /**
1523      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1524      * @param to address representing the new owner of the given token ID
1525      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1526      */
1527     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1528         uint256 length = ERC721.balanceOf(to);
1529         _ownedTokens[to][length] = tokenId;
1530         _ownedTokensIndex[tokenId] = length;
1531     }
1532 
1533     /**
1534      * @dev Private function to add a token to this extension's token tracking data structures.
1535      * @param tokenId uint256 ID of the token to be added to the tokens list
1536      */
1537     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1538         _allTokensIndex[tokenId] = _allTokens.length;
1539         _allTokens.push(tokenId);
1540     }
1541 
1542     /**
1543      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1544      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1545      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1546      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1547      * @param from address representing the previous owner of the given token ID
1548      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1549      */
1550     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1551         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1552         // then delete the last slot (swap and pop).
1553 
1554         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1555         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1556 
1557         // When the token to delete is the last token, the swap operation is unnecessary
1558         if (tokenIndex != lastTokenIndex) {
1559             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1560 
1561             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1562             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1563         }
1564 
1565         // This also deletes the contents at the last position of the array
1566         delete _ownedTokensIndex[tokenId];
1567         delete _ownedTokens[from][lastTokenIndex];
1568     }
1569 
1570     /**
1571      * @dev Private function to remove a token from this extension's token tracking data structures.
1572      * This has O(1) time complexity, but alters the order of the _allTokens array.
1573      * @param tokenId uint256 ID of the token to be removed from the tokens list
1574      */
1575     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1576         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1577         // then delete the last slot (swap and pop).
1578 
1579         uint256 lastTokenIndex = _allTokens.length - 1;
1580         uint256 tokenIndex = _allTokensIndex[tokenId];
1581 
1582         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1583         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1584         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1585         uint256 lastTokenId = _allTokens[lastTokenIndex];
1586 
1587         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1588         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1589 
1590         // This also deletes the contents at the last position of the array
1591         delete _allTokensIndex[tokenId];
1592         _allTokens.pop();
1593     }
1594 }
1595 
1596 // File: contracts/Santametti.sol
1597 
1598 //                                                  zr
1599 //                                               Yt$$$.
1600 //                                            .,e$$$$$F'
1601 //                          4e r               $$$$$$$.
1602 //                          d$$br            _z$$$$$$$F`
1603 //                           ?$$b._          ^?$$$$$$$
1604 //                            4$$$"     -eec.  ""JP" ..eee$%..
1605 //                            -**N #c   -^***.eE  ^z$P$$$$$$$$$r-
1606 //                   .ze$$$$$eu?$eu '$$$$b $=^*$$ .$$$$$$$$$$"
1607 //                --."?$$$$$$$$$c"$$c .""" e$K  =""*?$$$P""""
1608 //    ueee. `:`  $E !!h ?$$$$$$$$b R$N'~!! *$$F J"""C.  `
1609 //   J  `"$$eu`!h !!!`4!!<?$$$$$$$P ?".eee-z.ee" ~$$e.br
1610 //   'j$$Ne`?$$c`4!~`-e-:!:`$$$$$$$ $$**"z $^R$P  3 "$$$bJ
1611 //    4$$$F".`?$$c`!! \).!!!`?$$$$F.$$$# $u$% ee*"^ :4`"$"?$q
1612 //     ""`,!!!:`$$N.4!!~~.~~4 ?$$F'$$F.@.* -L.e@$$$$ec.      "
1613 //     "Rr`!!!!h ?$$c`h: `# !! $F,r4$L***  e$$$$$$$$$$$$hc
1614 //       #e'4!!!!L`$$b'!.:!h`~~ .$F'"    d$$$$$$$$$$$$$$$$$h,
1615 //        ^$.`!!!!h $$b`!. -    $P /'   .$$$$$$$$$$$$$$$$$$$$$c
1616 //          "$c`!!!h`$$.4~      $$$r'   <$$$$$$$$$$$$$$$$$$$P"""
1617 //            ^te.`~ $$b        `Fue-   `$$$$$$$$$$$$$$P".:  !! "<
1618 //               ^"=4$P"     .,,,. -^.   ?$$$$$$$$$$"?:. !! :!!~ ,,ec..
1619 //                     ..z$$$$$$$$$h,    `$$$$$$P"..`!f :!f ~)Lze$$$P""""?i
1620 //                   ud$$$$$$$$$$$$$$h    `?$$F <!!'<!>:~)ue$$P*"..:!!!!! J
1621 //                 .K$$$$$$$$$$$$$$$$$,     P.>e'!f !~ ed$$P".:!!!!!!!!`.d"
1622 //                z$$$$$$$$$$$$$$$$$$$$      4!!~\e$$$P`:!!!!!!!!!!'.eP'
1623 //               -*". . "??$$$$$$$$$$$$       ~ `z$$$F".`!!!!!!!!!!',dP"
1624 //             ." ):!!h i`!- ("?$$$$$$f        ,$$P":! ). `'!!!!`,d$F'
1625 //        .ueeeu.J`-^.!h <-  ~`.. ??$$'       ,$$ :!!`e$$$$e `,e$F'
1626 //     e$$$$$$$$$$$$$eeiC ")?:-<:%':^?        ?$f !!! ?$$$$",F"
1627 //    P"....```""?$$$$$$$$$euL^.!..` .         "Tu._.,``""
1628 //    $ !!!!!!!!!!::.""??$$$$$$eJ~^=.            ````
1629 //    ?$.`!!!!!!!!!!!!!!:."??$$$$$c'.
1630 //     "?b.`!!!!!!!!!!!!!!!!>."?$$$$c
1631 //       ^?$c`'!!!!!!!!!!!',eeb, "$$$k
1632 //          "?$e.`'!!!!!!! $$$$$ ;.?$$
1633 //             "?$ee,``''!."?$P`i!! 3P
1634 //                 ""??$bec,,.,ceeeP"
1635 //                        `""""""
1636 
1637 
1638 //Santametti (SANTA) is a fine art NFT collection from artist Pumpametti. This is a holiday free mint for all Metti ETH NFT holders. 
1639 //Total 1000 SANTA available. 
1640 //VIP reserved free mint for Pumpametti holders, 300 SANTA available. 
1641 //First-come-frist-serve free mint Pettametti/Standametti/MettiLandscape holders, 700 SANTA available. 
1642 //Only 1 SANTA per transaction.
1643 //For Pumpa holders please select "PumpaFirstChoiceVIPMint".
1644 //For Petta holders please select "PettaVernissageMint".
1645 //For Standa holders please select "StandaPrivateMint".
1646 //For MettiLandscape please select 'LandscapePrivateMint".
1647 //No public mint, you have to own a Metti to mint a SANTA.
1648 //Only mint from contract.
1649 //https://www.pumpametti.com/santametti
1650 //https://twitter.com/pumpametti
1651 
1652 
1653 //SPDX-License-Identifier: MIT
1654 
1655 pragma solidity ^0.8.0;
1656 
1657 interface PumpaInterface {
1658     function ownerOf(uint256 tokenId) external view returns (address owner);
1659     function balanceOf(address owner) external view returns (uint256 balance);
1660     function tokenOfOwnerByIndex(address owner, uint256 index)
1661         external
1662         view
1663         returns (uint256 tokenId);
1664 }
1665 
1666 interface PettaInterface {
1667     function ownerOf(uint256 tokenId) external view returns (address owner);
1668     function balanceOf(address owner) external view returns (uint256 balance);
1669     function tokenOfOwnerByIndex(address owner, uint256 index)
1670         external
1671         view
1672         returns (uint256 tokenId);
1673 }
1674 
1675 interface StandaInterface {
1676     function ownerOf(uint256 tokenId) external view returns (address owner);
1677     function balanceOf(address owner) external view returns (uint256 balance);
1678     function tokenOfOwnerByIndex(address owner, uint256 index)
1679         external
1680         view
1681         returns (uint256 tokenId);
1682 }
1683 
1684 interface LandscapeInterface {
1685     function ownerOf(uint256 tokenId) external view returns (address owner);
1686     function balanceOf(address owner) external view returns (uint256 balance);
1687     function tokenOfOwnerByIndex(address owner, uint256 index)
1688         external
1689         view
1690         returns (uint256 tokenId);
1691 }
1692 
1693 
1694 
1695 
1696 
1697 
1698 contract Santametti is ERC721Enumerable, Ownable, IERC2981 {
1699   using Strings for uint256;
1700   using SafeMath for uint256;
1701  
1702   string public baseURI;
1703   string public baseExtension = ".json";
1704   string public notRevealedUri;
1705   uint256 public cost = 0.0001 ether;
1706   uint256 public maxPumpaSupply = 300;
1707   uint256 public maxPettaStandaLandscapeSupply = 700;
1708   uint256 public maxMintAmount = 1;
1709   bool public paused = false;
1710   bool public revealed = false;
1711   
1712   uint16 internal royalty = 700; // base 10000, 7%
1713   uint16 public constant BASE = 10000;
1714 
1715   address public PumpaAddress = 0x09646c5c1e42ede848A57d6542382C32f2877164;
1716   PumpaInterface PumpaContract = PumpaInterface(PumpaAddress);
1717   uint public PumpaOwnersSupplyMinted = 0;
1718   uint public PettaStandaLandscapeSupplyMinted = 0;
1719 
1720   address public PettaAddress = 0x52474FBF6b678a280d0C69F2314d6d95548b3DAF;
1721   PettaInterface PettaContract = PettaInterface(PettaAddress);
1722 
1723   address public StandaAddress = 0xFC6Bc5D50912354e89bAd4daBf053Bca2d7Cd817;
1724   StandaInterface StandaContract = StandaInterface(StandaAddress);
1725 
1726   address public LandscapeAddress = 0x6067E1963Fe613609eE61E93588E4736Cbfc7800;
1727   LandscapeInterface LandscapeContract = LandscapeInterface(LandscapeAddress);
1728 
1729   constructor( 
1730     string memory _initBaseURI,
1731     string memory _initNotRevealedUri
1732   ) ERC721("Santametti", "SANTA") {
1733     setBaseURI(_initBaseURI);
1734     setNotRevealedURI(_initNotRevealedUri);
1735   }
1736 
1737   // internal
1738   function _baseURI() internal view virtual override returns (string memory) {
1739     return baseURI;
1740   }
1741 
1742   function PumpaFirstChoiceVIPMint(uint PumpaId) public payable {
1743     require(PumpaId > 0 && PumpaId <= 300, "Token ID invalid");
1744     require(PumpaContract.ownerOf(PumpaId) == msg.sender, "Not the owner of this Pumpa");
1745 
1746     _safeMint(msg.sender, PumpaId);
1747   }
1748 
1749   function PettaVernissageMint(uint PettaId, uint _mintAmount) public payable {
1750     require(PettaContract.ownerOf(PettaId) == msg.sender, "Not the owner of this Petta");
1751     require(msg.value >= 0.0001 ether * _mintAmount);
1752     require(!paused);
1753     require(_mintAmount > 0);
1754     require(_mintAmount <= maxMintAmount);
1755     require(PettaStandaLandscapeSupplyMinted + _mintAmount <= maxPettaStandaLandscapeSupply, "No more PettaStandaLandscape supply left");
1756 
1757     for (uint256 i = 1; i <= _mintAmount; i++) {
1758       _safeMint(msg.sender, maxPumpaSupply + PettaStandaLandscapeSupplyMinted + i);
1759     }
1760     PettaStandaLandscapeSupplyMinted = PettaStandaLandscapeSupplyMinted + _mintAmount;
1761 }
1762 
1763   function StandaPrivateMint(uint StandaId, uint _mintAmount) public payable {
1764     require(StandaContract.ownerOf(StandaId) == msg.sender, "Not the owner of this Standa");
1765     require(msg.value >= 0.0001 ether * _mintAmount);
1766     require(!paused);
1767     require(_mintAmount > 0);
1768     require(_mintAmount <= maxMintAmount);
1769     require(PettaStandaLandscapeSupplyMinted + _mintAmount <= maxPettaStandaLandscapeSupply, "No more PettaStandaLandscape supply left");
1770 
1771     for (uint256 i = 1; i <= _mintAmount; i++) {
1772       _safeMint(msg.sender, maxPumpaSupply + PettaStandaLandscapeSupplyMinted + i);
1773     }
1774     PettaStandaLandscapeSupplyMinted = PettaStandaLandscapeSupplyMinted + _mintAmount;
1775   }
1776 
1777     function LandscapePrivateMint(uint LandscapeId, uint _mintAmount) public payable {
1778     require(LandscapeContract.ownerOf(LandscapeId) == msg.sender, "Not the owner of this Landscape");
1779     require(msg.value >= 0.0001 ether * _mintAmount);
1780     require(!paused);
1781     require(_mintAmount > 0);
1782     require(_mintAmount <= maxMintAmount);
1783     require(PettaStandaLandscapeSupplyMinted + _mintAmount <= maxPettaStandaLandscapeSupply, "No more PettaStandaLandscape supply left");
1784 
1785     for (uint256 i = 1; i <= _mintAmount; i++) {
1786       _safeMint(msg.sender, maxPumpaSupply + PettaStandaLandscapeSupplyMinted + i);
1787     }
1788     PettaStandaLandscapeSupplyMinted = PettaStandaLandscapeSupplyMinted + _mintAmount;
1789   }
1790 
1791   function tokenURI(uint256 tokenId)
1792     public
1793     view
1794     virtual
1795     override
1796     returns (string memory)
1797   {
1798     require(
1799       _exists(tokenId),
1800       "ERC721Metadata: URI query for nonexistent token"
1801     );
1802     
1803     if(revealed == false) {
1804         return notRevealedUri;
1805     }
1806 
1807     string memory currentBaseURI = _baseURI();
1808     return bytes(currentBaseURI).length > 0
1809         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1810         : "";
1811   }
1812   
1813   //onlyOwner
1814   
1815   function reveal() public onlyOwner {
1816       revealed = true;
1817   }
1818   
1819   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1820     baseURI = _newBaseURI;
1821   }
1822 
1823   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1824     baseExtension = _newBaseExtension;
1825   }
1826   
1827   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1828     notRevealedUri = _notRevealedURI;
1829   }
1830 
1831   function pause(bool _state) public onlyOwner {
1832     paused = _state;
1833   }
1834   
1835   function royaltyInfo(uint256, uint256 _salePrice)
1836         external
1837         view
1838         override
1839         returns (address receiver, uint256 royaltyAmount)
1840     {
1841         return (address(this), (_salePrice * royalty) / BASE);
1842     }
1843 
1844   function setRoyalty(uint16 _royalty) public virtual onlyOwner {
1845         require(_royalty >= 0 && _royalty <= 1000, 'Royalty must be between 0% and 10%.');
1846 
1847         royalty = _royalty;
1848     }
1849 
1850   function withdraw() public payable onlyOwner {
1851     require(payable(msg.sender).send(address(this).balance));
1852   }
1853   
1854 }