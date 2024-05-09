1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 //  â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆ   â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆ  â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆ  â–ˆâ–ˆ      â–ˆâ–ˆ â–ˆâ–ˆâ–ˆ    â–ˆâ–ˆ â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆ         
5 // â–ˆâ–ˆ       â–ˆâ–ˆ    â–ˆâ–ˆ â–ˆâ–ˆ   â–ˆâ–ˆ â–ˆâ–ˆ      â–ˆâ–ˆ â–ˆâ–ˆâ–ˆâ–ˆ   â–ˆâ–ˆ â–ˆâ–ˆ              
6 // â–ˆâ–ˆ   â–ˆâ–ˆâ–ˆ â–ˆâ–ˆ    â–ˆâ–ˆ â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆ  â–ˆâ–ˆ      â–ˆâ–ˆ â–ˆâ–ˆ â–ˆâ–ˆ  â–ˆâ–ˆ â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆ         
7 // â–ˆâ–ˆ    â–ˆâ–ˆ â–ˆâ–ˆ    â–ˆâ–ˆ â–ˆâ–ˆ   â–ˆâ–ˆ â–ˆâ–ˆ      â–ˆâ–ˆ â–ˆâ–ˆ  â–ˆâ–ˆ â–ˆâ–ˆ      â–ˆâ–ˆ         
8 //  â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆ   â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆ  â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆ  â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆ â–ˆâ–ˆ â–ˆâ–ˆ   â–ˆâ–ˆâ–ˆâ–ˆ â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆ         
9 //                                                                
10 //                                                                
11 // â–ˆâ–ˆ     â–ˆâ–ˆ â–ˆâ–ˆ â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆ â–ˆâ–ˆ   â–ˆâ–ˆ                                  
12 // â–ˆâ–ˆ     â–ˆâ–ˆ â–ˆâ–ˆ    â–ˆâ–ˆ    â–ˆâ–ˆ   â–ˆâ–ˆ                                  
13 // â–ˆâ–ˆ  â–ˆ  â–ˆâ–ˆ â–ˆâ–ˆ    â–ˆâ–ˆ    â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆ                                  
14 // â–ˆâ–ˆ â–ˆâ–ˆâ–ˆ â–ˆâ–ˆ â–ˆâ–ˆ    â–ˆâ–ˆ    â–ˆâ–ˆ   â–ˆâ–ˆ                                  
15 //  â–ˆâ–ˆâ–ˆ â–ˆâ–ˆâ–ˆ  â–ˆâ–ˆ    â–ˆâ–ˆ    â–ˆâ–ˆ   â–ˆâ–ˆ                                  
16 //                                                                
17 //                                                                
18 //  â–ˆâ–ˆâ–ˆâ–ˆâ–ˆ  â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆ â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆ â–ˆâ–ˆ â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆ â–ˆâ–ˆ    â–ˆâ–ˆ â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆ  â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆ 
19 // â–ˆâ–ˆ   â–ˆâ–ˆ    â–ˆâ–ˆ       â–ˆâ–ˆ    â–ˆâ–ˆ    â–ˆâ–ˆ    â–ˆâ–ˆ    â–ˆâ–ˆ â–ˆâ–ˆ   â–ˆâ–ˆ â–ˆâ–ˆ      
20 // â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆ    â–ˆâ–ˆ       â–ˆâ–ˆ    â–ˆâ–ˆ    â–ˆâ–ˆ    â–ˆâ–ˆ    â–ˆâ–ˆ â–ˆâ–ˆ   â–ˆâ–ˆ â–ˆâ–ˆâ–ˆâ–ˆâ–ˆ   
21 // â–ˆâ–ˆ   â–ˆâ–ˆ    â–ˆâ–ˆ       â–ˆâ–ˆ    â–ˆâ–ˆ    â–ˆâ–ˆ    â–ˆâ–ˆ    â–ˆâ–ˆ â–ˆâ–ˆ   â–ˆâ–ˆ â–ˆâ–ˆ      
22 // â–ˆâ–ˆ   â–ˆâ–ˆ    â–ˆâ–ˆ       â–ˆâ–ˆ    â–ˆâ–ˆ    â–ˆâ–ˆ     â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆ  â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆ  â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆ 
23 //                                                                
24 //                                                                
25 //
26 //*********************************************************************//
27 //*********************************************************************//
28   
29 //-------------DEPENDENCIES--------------------------//
30 
31 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
32 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
33 
34 pragma solidity ^0.8.0;
35 
36 // CAUTION
37 // This version of SafeMath should only be used with Solidity 0.8 or later,
38 // because it relies on the compiler's built in overflow checks.
39 
40 /**
41  * @dev Wrappers over Solidity's arithmetic operations.
42  *
43  * NOTE: SafeMath is generally not needed starting with Solidity 0.8, since the compiler
44  * now has built in overflow checking.
45  */
46 library SafeMath {
47     /**
48      * @dev Returns the addition of two unsigned integers, with an overflow flag.
49      *
50      * _Available since v3.4._
51      */
52     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
53         unchecked {
54             uint256 c = a + b;
55             if (c < a) return (false, 0);
56             return (true, c);
57         }
58     }
59 
60     /**
61      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
62      *
63      * _Available since v3.4._
64      */
65     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
66         unchecked {
67             if (b > a) return (false, 0);
68             return (true, a - b);
69         }
70     }
71 
72     /**
73      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
74      *
75      * _Available since v3.4._
76      */
77     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
78         unchecked {
79             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
80             // benefit is lost if 'b' is also tested.
81             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
82             if (a == 0) return (true, 0);
83             uint256 c = a * b;
84             if (c / a != b) return (false, 0);
85             return (true, c);
86         }
87     }
88 
89     /**
90      * @dev Returns the division of two unsigned integers, with a division by zero flag.
91      *
92      * _Available since v3.4._
93      */
94     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
95         unchecked {
96             if (b == 0) return (false, 0);
97             return (true, a / b);
98         }
99     }
100 
101     /**
102      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
103      *
104      * _Available since v3.4._
105      */
106     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
107         unchecked {
108             if (b == 0) return (false, 0);
109             return (true, a % b);
110         }
111     }
112 
113     /**
114      * @dev Returns the addition of two unsigned integers, reverting on
115      * overflow.
116      *
117      * Counterpart to Solidity's + operator.
118      *
119      * Requirements:
120      *
121      * - Addition cannot overflow.
122      */
123     function add(uint256 a, uint256 b) internal pure returns (uint256) {
124         return a + b;
125     }
126 
127     /**
128      * @dev Returns the subtraction of two unsigned integers, reverting on
129      * overflow (when the result is negative).
130      *
131      * Counterpart to Solidity's - operator.
132      *
133      * Requirements:
134      *
135      * - Subtraction cannot overflow.
136      */
137     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
138         return a - b;
139     }
140 
141     /**
142      * @dev Returns the multiplication of two unsigned integers, reverting on
143      * overflow.
144      *
145      * Counterpart to Solidity's * operator.
146      *
147      * Requirements:
148      *
149      * - Multiplication cannot overflow.
150      */
151     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
152         return a * b;
153     }
154 
155     /**
156      * @dev Returns the integer division of two unsigned integers, reverting on
157      * division by zero. The result is rounded towards zero.
158      *
159      * Counterpart to Solidity's / operator.
160      *
161      * Requirements:
162      *
163      * - The divisor cannot be zero.
164      */
165     function div(uint256 a, uint256 b) internal pure returns (uint256) {
166         return a / b;
167     }
168 
169     /**
170      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
171      * reverting when dividing by zero.
172      *
173      * Counterpart to Solidity's % operator. This function uses a revert
174      * opcode (which leaves remaining gas untouched) while Solidity uses an
175      * invalid opcode to revert (consuming all remaining gas).
176      *
177      * Requirements:
178      *
179      * - The divisor cannot be zero.
180      */
181     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
182         return a % b;
183     }
184 
185     /**
186      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
187      * overflow (when the result is negative).
188      *
189      * CAUTION: This function is deprecated because it requires allocating memory for the error
190      * message unnecessarily. For custom revert reasons use {trySub}.
191      *
192      * Counterpart to Solidity's - operator.
193      *
194      * Requirements:
195      *
196      * - Subtraction cannot overflow.
197      */
198     function sub(
199         uint256 a,
200         uint256 b,
201         string memory errorMessage
202     ) internal pure returns (uint256) {
203         unchecked {
204             require(b <= a, errorMessage);
205             return a - b;
206         }
207     }
208 
209     /**
210      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
211      * division by zero. The result is rounded towards zero.
212      *
213      * Counterpart to Solidity's / operator. Note: this function uses a
214      * revert opcode (which leaves remaining gas untouched) while Solidity
215      * uses an invalid opcode to revert (consuming all remaining gas).
216      *
217      * Requirements:
218      *
219      * - The divisor cannot be zero.
220      */
221     function div(
222         uint256 a,
223         uint256 b,
224         string memory errorMessage
225     ) internal pure returns (uint256) {
226         unchecked {
227             require(b > 0, errorMessage);
228             return a / b;
229         }
230     }
231 
232     /**
233      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
234      * reverting with custom message when dividing by zero.
235      *
236      * CAUTION: This function is deprecated because it requires allocating memory for the error
237      * message unnecessarily. For custom revert reasons use {tryMod}.
238      *
239      * Counterpart to Solidity's % operator. This function uses a revert
240      * opcode (which leaves remaining gas untouched) while Solidity uses an
241      * invalid opcode to revert (consuming all remaining gas).
242      *
243      * Requirements:
244      *
245      * - The divisor cannot be zero.
246      */
247     function mod(
248         uint256 a,
249         uint256 b,
250         string memory errorMessage
251     ) internal pure returns (uint256) {
252         unchecked {
253             require(b > 0, errorMessage);
254             return a % b;
255         }
256     }
257 }
258 
259 // File: @openzeppelin/contracts/utils/Address.sol
260 
261 
262 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
263 
264 pragma solidity ^0.8.1;
265 
266 /**
267  * @dev Collection of functions related to the address type
268  */
269 library Address {
270     /**
271      * @dev Returns true if account is a contract.
272      *
273      * [IMPORTANT]
274      * ====
275      * It is unsafe to assume that an address for which this function returns
276      * false is an externally-owned account (EOA) and not a contract.
277      *
278      * Among others, isContract will return false for the following
279      * types of addresses:
280      *
281      *  - an externally-owned account
282      *  - a contract in construction
283      *  - an address where a contract will be created
284      *  - an address where a contract lived, but was destroyed
285      * ====
286      *
287      * [IMPORTANT]
288      * ====
289      * You shouldn't rely on isContract to protect against flash loan attacks!
290      *
291      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
292      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
293      * constructor.
294      * ====
295      */
296     function isContract(address account) internal view returns (bool) {
297         // This method relies on extcodesize/address.code.length, which returns 0
298         // for contracts in construction, since the code is only stored at the end
299         // of the constructor execution.
300 
301         return account.code.length > 0;
302     }
303 
304     /**
305      * @dev Replacement for Solidity's transfer: sends amount wei to
306      * recipient, forwarding all available gas and reverting on errors.
307      *
308      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
309      * of certain opcodes, possibly making contracts go over the 2300 gas limit
310      * imposed by transfer, making them unable to receive funds via
311      * transfer. {sendValue} removes this limitation.
312      *
313      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
314      *
315      * IMPORTANT: because control is transferred to recipient, care must be
316      * taken to not create reentrancy vulnerabilities. Consider using
317      * {ReentrancyGuard} or the
318      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
319      */
320     function sendValue(address payable recipient, uint256 amount) internal {
321         require(address(this).balance >= amount, "Address: insufficient balance");
322 
323         (bool success, ) = recipient.call{value: amount}("");
324         require(success, "Address: unable to send value, recipient may have reverted");
325     }
326 
327     /**
328      * @dev Performs a Solidity function call using a low level call. A
329      * plain call is an unsafe replacement for a function call: use this
330      * function instead.
331      *
332      * If target reverts with a revert reason, it is bubbled up by this
333      * function (like regular Solidity function calls).
334      *
335      * Returns the raw returned data. To convert to the expected return value,
336      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[abi.decode].
337      *
338      * Requirements:
339      *
340      * - target must be a contract.
341      * - calling target with data must not revert.
342      *
343      * _Available since v3.1._
344      */
345     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
346         return functionCall(target, data, "Address: low-level call failed");
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall], but with
351      * errorMessage as a fallback revert reason when target reverts.
352      *
353      * _Available since v3.1._
354      */
355     function functionCall(
356         address target,
357         bytes memory data,
358         string memory errorMessage
359     ) internal returns (bytes memory) {
360         return functionCallWithValue(target, data, 0, errorMessage);
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
365      * but also transferring value wei to target.
366      *
367      * Requirements:
368      *
369      * - the calling contract must have an ETH balance of at least value.
370      * - the called Solidity function must be payable.
371      *
372      * _Available since v3.1._
373      */
374     function functionCallWithValue(
375         address target,
376         bytes memory data,
377         uint256 value
378     ) internal returns (bytes memory) {
379         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
380     }
381 
382     /**
383      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[functionCallWithValue], but
384      * with errorMessage as a fallback revert reason when target reverts.
385      *
386      * _Available since v3.1._
387      */
388     function functionCallWithValue(
389         address target,
390         bytes memory data,
391         uint256 value,
392         string memory errorMessage
393     ) internal returns (bytes memory) {
394         require(address(this).balance >= value, "Address: insufficient balance for call");
395         require(isContract(target), "Address: call to non-contract");
396 
397         (bool success, bytes memory returndata) = target.call{value: value}(data);
398         return verifyCallResult(success, returndata, errorMessage);
399     }
400 
401     /**
402      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
403      * but performing a static call.
404      *
405      * _Available since v3.3._
406      */
407     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
408         return functionStaticCall(target, data, "Address: low-level static call failed");
409     }
410 
411     /**
412      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
413      * but performing a static call.
414      *
415      * _Available since v3.3._
416      */
417     function functionStaticCall(
418         address target,
419         bytes memory data,
420         string memory errorMessage
421     ) internal view returns (bytes memory) {
422         require(isContract(target), "Address: static call to non-contract");
423 
424         (bool success, bytes memory returndata) = target.staticcall(data);
425         return verifyCallResult(success, returndata, errorMessage);
426     }
427 
428     /**
429      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
430      * but performing a delegate call.
431      *
432      * _Available since v3.4._
433      */
434     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
435         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
436     }
437 
438     /**
439      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
440      * but performing a delegate call.
441      *
442      * _Available since v3.4._
443      */
444     function functionDelegateCall(
445         address target,
446         bytes memory data,
447         string memory errorMessage
448     ) internal returns (bytes memory) {
449         require(isContract(target), "Address: delegate call to non-contract");
450 
451         (bool success, bytes memory returndata) = target.delegatecall(data);
452         return verifyCallResult(success, returndata, errorMessage);
453     }
454 
455     /**
456      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
457      * revert reason using the provided one.
458      *
459      * _Available since v4.3._
460      */
461     function verifyCallResult(
462         bool success,
463         bytes memory returndata,
464         string memory errorMessage
465     ) internal pure returns (bytes memory) {
466         if (success) {
467             return returndata;
468         } else {
469             // Look for revert reason and bubble it up if present
470             if (returndata.length > 0) {
471                 // The easiest way to bubble the revert reason is using memory via assembly
472 
473                 assembly {
474                     let returndata_size := mload(returndata)
475                     revert(add(32, returndata), returndata_size)
476                 }
477             } else {
478                 revert(errorMessage);
479             }
480         }
481     }
482 }
483 
484 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
485 
486 
487 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
488 
489 pragma solidity ^0.8.0;
490 
491 /**
492  * @title ERC721 token receiver interface
493  * @dev Interface for any contract that wants to support safeTransfers
494  * from ERC721 asset contracts.
495  */
496 interface IERC721Receiver {
497     /**
498      * @dev Whenever an {IERC721} tokenId token is transferred to this contract via {IERC721-safeTransferFrom}
499      * by operator from from, this function is called.
500      *
501      * It must return its Solidity selector to confirm the token transfer.
502      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
503      *
504      * The selector can be obtained in Solidity with IERC721.onERC721Received.selector.
505      */
506     function onERC721Received(
507         address operator,
508         address from,
509         uint256 tokenId,
510         bytes calldata data
511     ) external returns (bytes4);
512 }
513 
514 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
515 
516 
517 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
518 
519 pragma solidity ^0.8.0;
520 
521 /**
522  * @dev Interface of the ERC165 standard, as defined in the
523  * https://eips.ethereum.org/EIPS/eip-165[EIP].
524  *
525  * Implementers can declare support of contract interfaces, which can then be
526  * queried by others ({ERC165Checker}).
527  *
528  * For an implementation, see {ERC165}.
529  */
530 interface IERC165 {
531     /**
532      * @dev Returns true if this contract implements the interface defined by
533      * interfaceId. See the corresponding
534      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
535      * to learn more about how these ids are created.
536      *
537      * This function call must use less than 30 000 gas.
538      */
539     function supportsInterface(bytes4 interfaceId) external view returns (bool);
540 }
541 
542 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
543 
544 
545 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
546 
547 pragma solidity ^0.8.0;
548 
549 
550 /**
551  * @dev Implementation of the {IERC165} interface.
552  *
553  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
554  * for the additional interface id that will be supported. For example:
555  *
556  * solidity
557  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
558  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
559  * }
560  * 
561  *
562  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
563  */
564 abstract contract ERC165 is IERC165 {
565     /**
566      * @dev See {IERC165-supportsInterface}.
567      */
568     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
569         return interfaceId == type(IERC165).interfaceId;
570     }
571 }
572 
573 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
574 
575 
576 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
577 
578 pragma solidity ^0.8.0;
579 
580 
581 /**
582  * @dev Required interface of an ERC721 compliant contract.
583  */
584 interface IERC721 is IERC165 {
585     /**
586      * @dev Emitted when tokenId token is transferred from from to to.
587      */
588     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
589 
590     /**
591      * @dev Emitted when owner enables approved to manage the tokenId token.
592      */
593     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
594 
595     /**
596      * @dev Emitted when owner enables or disables (approved) operator to manage all of its assets.
597      */
598     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
599 
600     /**
601      * @dev Returns the number of tokens in owner's account.
602      */
603     function balanceOf(address owner) external view returns (uint256 balance);
604 
605     /**
606      * @dev Returns the owner of the tokenId token.
607      *
608      * Requirements:
609      *
610      * - tokenId must exist.
611      */
612     function ownerOf(uint256 tokenId) external view returns (address owner);
613 
614     /**
615      * @dev Safely transfers tokenId token from from to to, checking first that contract recipients
616      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
617      *
618      * Requirements:
619      *
620      * - from cannot be the zero address.
621      * - to cannot be the zero address.
622      * - tokenId token must exist and be owned by from.
623      * - If the caller is not from, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
624      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
625      *
626      * Emits a {Transfer} event.
627      */
628     function safeTransferFrom(
629         address from,
630         address to,
631         uint256 tokenId
632     ) external;
633 
634     /**
635      * @dev Transfers tokenId token from from to to.
636      *
637      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
638      *
639      * Requirements:
640      *
641      * - from cannot be the zero address.
642      * - to cannot be the zero address.
643      * - tokenId token must be owned by from.
644      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
645      *
646      * Emits a {Transfer} event.
647      */
648     function transferFrom(
649         address from,
650         address to,
651         uint256 tokenId
652     ) external;
653 
654     /**
655      * @dev Gives permission to to to transfer tokenId token to another account.
656      * The approval is cleared when the token is transferred.
657      *
658      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
659      *
660      * Requirements:
661      *
662      * - The caller must own the token or be an approved operator.
663      * - tokenId must exist.
664      *
665      * Emits an {Approval} event.
666      */
667     function approve(address to, uint256 tokenId) external;
668 
669     /**
670      * @dev Returns the account approved for tokenId token.
671      *
672      * Requirements:
673      *
674      * - tokenId must exist.
675      */
676     function getApproved(uint256 tokenId) external view returns (address operator);
677 
678     /**
679      * @dev Approve or remove operator as an operator for the caller.
680      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
681      *
682      * Requirements:
683      *
684      * - The operator cannot be the caller.
685      *
686      * Emits an {ApprovalForAll} event.
687      */
688     function setApprovalForAll(address operator, bool _approved) external;
689 
690     /**
691      * @dev Returns if the operator is allowed to manage all of the assets of owner.
692      *
693      * See {setApprovalForAll}
694      */
695     function isApprovedForAll(address owner, address operator) external view returns (bool);
696 
697     /**
698      * @dev Safely transfers tokenId token from from to to.
699      *
700      * Requirements:
701      *
702      * - from cannot be the zero address.
703      * - to cannot be the zero address.
704      * - tokenId token must exist and be owned by from.
705      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
706      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
707      *
708      * Emits a {Transfer} event.
709      */
710     function safeTransferFrom(
711         address from,
712         address to,
713         uint256 tokenId,
714         bytes calldata data
715     ) external;
716 }
717 
718 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
719 
720 
721 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
722 
723 pragma solidity ^0.8.0;
724 
725 
726 /**
727  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
728  * @dev See https://eips.ethereum.org/EIPS/eip-721
729  */
730 interface IERC721Enumerable is IERC721 {
731     /**
732      * @dev Returns the total amount of tokens stored by the contract.
733      */
734     function totalSupply() external view returns (uint256);
735 
736     /**
737      * @dev Returns a token ID owned by owner at a given index of its token list.
738      * Use along with {balanceOf} to enumerate all of owner's tokens.
739      */
740     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
741 
742     /**
743      * @dev Returns a token ID at a given index of all the tokens stored by the contract.
744      * Use along with {totalSupply} to enumerate all tokens.
745      */
746     function tokenByIndex(uint256 index) external view returns (uint256);
747 }
748 
749 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
750 
751 
752 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
753 
754 pragma solidity ^0.8.0;
755 
756 
757 /**
758  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
759  * @dev See https://eips.ethereum.org/EIPS/eip-721
760  */
761 interface IERC721Metadata is IERC721 {
762     /**
763      * @dev Returns the token collection name.
764      */
765     function name() external view returns (string memory);
766 
767     /**
768      * @dev Returns the token collection symbol.
769      */
770     function symbol() external view returns (string memory);
771 
772     /**
773      * @dev Returns the Uniform Resource Identifier (URI) for tokenId token.
774      */
775     function tokenURI(uint256 tokenId) external view returns (string memory);
776 }
777 
778 // File: @openzeppelin/contracts/utils/Strings.sol
779 
780 
781 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
782 
783 pragma solidity ^0.8.0;
784 
785 /**
786  * @dev String operations.
787  */
788 library Strings {
789     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
790 
791     /**
792      * @dev Converts a uint256 to its ASCII string decimal representation.
793      */
794     function toString(uint256 value) internal pure returns (string memory) {
795         // Inspired by OraclizeAPI's implementation - MIT licence
796         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
797 
798         if (value == 0) {
799             return "0";
800         }
801         uint256 temp = value;
802         uint256 digits;
803         while (temp != 0) {
804             digits++;
805             temp /= 10;
806         }
807         bytes memory buffer = new bytes(digits);
808         while (value != 0) {
809             digits -= 1;
810             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
811             value /= 10;
812         }
813         return string(buffer);
814     }
815 
816     /**
817      * @dev Converts a uint256 to its ASCII string hexadecimal representation.
818      */
819     function toHexString(uint256 value) internal pure returns (string memory) {
820         if (value == 0) {
821             return "0x00";
822         }
823         uint256 temp = value;
824         uint256 length = 0;
825         while (temp != 0) {
826             length++;
827             temp >>= 8;
828         }
829         return toHexString(value, length);
830     }
831 
832     /**
833      * @dev Converts a uint256 to its ASCII string hexadecimal representation with fixed length.
834      */
835     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
836         bytes memory buffer = new bytes(2 * length + 2);
837         buffer[0] = "0";
838         buffer[1] = "x";
839         for (uint256 i = 2 * length + 1; i > 1; --i) {
840             buffer[i] = _HEX_SYMBOLS[value & 0xf];
841             value >>= 4;
842         }
843         require(value == 0, "Strings: hex length insufficient");
844         return string(buffer);
845     }
846 }
847 
848 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
849 
850 
851 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
852 
853 pragma solidity ^0.8.0;
854 
855 /**
856  * @dev Contract module that helps prevent reentrant calls to a function.
857  *
858  * Inheriting from ReentrancyGuard will make the {nonReentrant} modifier
859  * available, which can be applied to functions to make sure there are no nested
860  * (reentrant) calls to them.
861  *
862  * Note that because there is a single nonReentrant guard, functions marked as
863  * nonReentrant may not call one another. This can be worked around by making
864  * those functions private, and then adding external nonReentrant entry
865  * points to them.
866  *
867  * TIP: If you would like to learn more about reentrancy and alternative ways
868  * to protect against it, check out our blog post
869  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
870  */
871 abstract contract ReentrancyGuard {
872     // Booleans are more expensive than uint256 or any type that takes up a full
873     // word because each write operation emits an extra SLOAD to first read the
874     // slot's contents, replace the bits taken up by the boolean, and then write
875     // back. This is the compiler's defense against contract upgrades and
876     // pointer aliasing, and it cannot be disabled.
877 
878     // The values being non-zero value makes deployment a bit more expensive,
879     // but in exchange the refund on every call to nonReentrant will be lower in
880     // amount. Since refunds are capped to a percentage of the total
881     // transaction's gas, it is best to keep them low in cases like this one, to
882     // increase the likelihood of the full refund coming into effect.
883     uint256 private constant _NOT_ENTERED = 1;
884     uint256 private constant _ENTERED = 2;
885 
886     uint256 private _status;
887 
888     constructor() {
889         _status = _NOT_ENTERED;
890     }
891 
892     /**
893      * @dev Prevents a contract from calling itself, directly or indirectly.
894      * Calling a nonReentrant function from another nonReentrant
895      * function is not supported. It is possible to prevent this from happening
896      * by making the nonReentrant function external, and making it call a
897      * private function that does the actual work.
898      */
899     modifier nonReentrant() {
900         // On the first call to nonReentrant, _notEntered will be true
901         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
902 
903         // Any calls to nonReentrant after this point will fail
904         _status = _ENTERED;
905 
906         _;
907 
908         // By storing the original value once again, a refund is triggered (see
909         // https://eips.ethereum.org/EIPS/eip-2200)
910         _status = _NOT_ENTERED;
911     }
912 }
913 
914 // File: @openzeppelin/contracts/utils/Context.sol
915 
916 
917 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
918 
919 pragma solidity ^0.8.0;
920 
921 /**
922  * @dev Provides information about the current execution context, including the
923  * sender of the transaction and its data. While these are generally available
924  * via msg.sender and msg.data, they should not be accessed in such a direct
925  * manner, since when dealing with meta-transactions the account sending and
926  * paying for execution may not be the actual sender (as far as an application
927  * is concerned).
928  *
929  * This contract is only required for intermediate, library-like contracts.
930  */
931 abstract contract Context {
932     function _msgSender() internal view virtual returns (address) {
933         return msg.sender;
934     }
935 
936     function _msgData() internal view virtual returns (bytes calldata) {
937         return msg.data;
938     }
939 }
940 
941 // File: @openzeppelin/contracts/access/Ownable.sol
942 
943 
944 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
945 
946 pragma solidity ^0.8.0;
947 
948 
949 /**
950  * @dev Contract module which provides a basic access control mechanism, where
951  * there is an account (an owner) that can be granted exclusive access to
952  * specific functions.
953  *
954  * By default, the owner account will be the one that deploys the contract. This
955  * can later be changed with {transferOwnership}.
956  *
957  * This module is used through inheritance. It will make available the modifier
958  * onlyOwner, which can be applied to your functions to restrict their use to
959  * the owner.
960  */
961 abstract contract Ownable is Context {
962     address private _owner;
963 
964     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
965 
966     /**
967      * @dev Initializes the contract setting the deployer as the initial owner.
968      */
969     constructor() {
970         _transferOwnership(_msgSender());
971     }
972 
973     /**
974      * @dev Returns the address of the current owner.
975      */
976     function owner() public view virtual returns (address) {
977         return _owner;
978     }
979 
980     /**
981      * @dev Throws if called by any account other than the owner.
982      */
983     modifier onlyOwner() {
984         require(owner() == _msgSender(), "Ownable: caller is not the owner");
985         _;
986     }
987 
988     /**
989      * @dev Leaves the contract without owner. It will not be possible to call
990      * onlyOwner functions anymore. Can only be called by the current owner.
991      *
992      * NOTE: Renouncing ownership will leave the contract without an owner,
993      * thereby removing any functionality that is only available to the owner.
994      */
995     function renounceOwnership() public virtual onlyOwner {
996         _transferOwnership(address(0));
997     }
998 
999     /**
1000      * @dev Transfers ownership of the contract to a new account (newOwner).
1001      * Can only be called by the current owner.
1002      */
1003     function transferOwnership(address newOwner) public virtual onlyOwner {
1004         require(newOwner != address(0), "Ownable: new owner is the zero address");
1005         _transferOwnership(newOwner);
1006     }
1007 
1008     /**
1009      * @dev Transfers ownership of the contract to a new account (newOwner).
1010      * Internal function without access restriction.
1011      */
1012     function _transferOwnership(address newOwner) internal virtual {
1013         address oldOwner = _owner;
1014         _owner = newOwner;
1015         emit OwnershipTransferred(oldOwner, newOwner);
1016     }
1017 }
1018 //-------------END DEPENDENCIES------------------------//
1019 
1020 
1021   
1022   
1023 /**
1024  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1025  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1026  *
1027  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1028  * 
1029  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1030  *
1031  * Does not support burning tokens to address(0).
1032  */
1033 contract ERC721A is
1034   Context,
1035   ERC165,
1036   IERC721,
1037   IERC721Metadata,
1038   IERC721Enumerable
1039 {
1040   using Address for address;
1041   using Strings for uint256;
1042 
1043   struct TokenOwnership {
1044     address addr;
1045     uint64 startTimestamp;
1046   }
1047 
1048   struct AddressData {
1049     uint128 balance;
1050     uint128 numberMinted;
1051   }
1052 
1053   uint256 private currentIndex;
1054 
1055   uint256 public immutable collectionSize;
1056   uint256 public maxBatchSize;
1057 
1058   // Token name
1059   string private _name;
1060 
1061   // Token symbol
1062   string private _symbol;
1063 
1064   // Mapping from token ID to ownership details
1065   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1066   mapping(uint256 => TokenOwnership) private _ownerships;
1067 
1068   // Mapping owner address to address data
1069   mapping(address => AddressData) private _addressData;
1070 
1071   // Mapping from token ID to approved address
1072   mapping(uint256 => address) private _tokenApprovals;
1073 
1074   // Mapping from owner to operator approvals
1075   mapping(address => mapping(address => bool)) private _operatorApprovals;
1076 
1077   /**
1078    * @dev
1079    * maxBatchSize refers to how much a minter can mint at a time.
1080    * collectionSize_ refers to how many tokens are in the collection.
1081    */
1082   constructor(
1083     string memory name_,
1084     string memory symbol_,
1085     uint256 maxBatchSize_,
1086     uint256 collectionSize_
1087   ) {
1088     require(
1089       collectionSize_ > 0,
1090       "ERC721A: collection must have a nonzero supply"
1091     );
1092     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1093     _name = name_;
1094     _symbol = symbol_;
1095     maxBatchSize = maxBatchSize_;
1096     collectionSize = collectionSize_;
1097     currentIndex = _startTokenId();
1098   }
1099 
1100   /**
1101   * To change the starting tokenId, please override this function.
1102   */
1103   function _startTokenId() internal view virtual returns (uint256) {
1104     return 1;
1105   }
1106 
1107   /**
1108    * @dev See {IERC721Enumerable-totalSupply}.
1109    */
1110   function totalSupply() public view override returns (uint256) {
1111     return _totalMinted();
1112   }
1113 
1114   function currentTokenId() public view returns (uint256) {
1115     return _totalMinted();
1116   }
1117 
1118   function getNextTokenId() public view returns (uint256) {
1119       return SafeMath.add(_totalMinted(), 1);
1120   }
1121 
1122   /**
1123   * Returns the total amount of tokens minted in the contract.
1124   */
1125   function _totalMinted() internal view returns (uint256) {
1126     unchecked {
1127       return currentIndex - _startTokenId();
1128     }
1129   }
1130 
1131   /**
1132    * @dev See {IERC721Enumerable-tokenByIndex}.
1133    */
1134   function tokenByIndex(uint256 index) public view override returns (uint256) {
1135     require(index < totalSupply(), "ERC721A: global index out of bounds");
1136     return index;
1137   }
1138 
1139   /**
1140    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1141    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1142    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1143    */
1144   function tokenOfOwnerByIndex(address owner, uint256 index)
1145     public
1146     view
1147     override
1148     returns (uint256)
1149   {
1150     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1151     uint256 numMintedSoFar = totalSupply();
1152     uint256 tokenIdsIdx = 0;
1153     address currOwnershipAddr = address(0);
1154     for (uint256 i = 0; i < numMintedSoFar; i++) {
1155       TokenOwnership memory ownership = _ownerships[i];
1156       if (ownership.addr != address(0)) {
1157         currOwnershipAddr = ownership.addr;
1158       }
1159       if (currOwnershipAddr == owner) {
1160         if (tokenIdsIdx == index) {
1161           return i;
1162         }
1163         tokenIdsIdx++;
1164       }
1165     }
1166     revert("ERC721A: unable to get token of owner by index");
1167   }
1168 
1169   /**
1170    * @dev See {IERC165-supportsInterface}.
1171    */
1172   function supportsInterface(bytes4 interfaceId)
1173     public
1174     view
1175     virtual
1176     override(ERC165, IERC165)
1177     returns (bool)
1178   {
1179     return
1180       interfaceId == type(IERC721).interfaceId ||
1181       interfaceId == type(IERC721Metadata).interfaceId ||
1182       interfaceId == type(IERC721Enumerable).interfaceId ||
1183       super.supportsInterface(interfaceId);
1184   }
1185 
1186   /**
1187    * @dev See {IERC721-balanceOf}.
1188    */
1189   function balanceOf(address owner) public view override returns (uint256) {
1190     require(owner != address(0), "ERC721A: balance query for the zero address");
1191     return uint256(_addressData[owner].balance);
1192   }
1193 
1194   function _numberMinted(address owner) internal view returns (uint256) {
1195     require(
1196       owner != address(0),
1197       "ERC721A: number minted query for the zero address"
1198     );
1199     return uint256(_addressData[owner].numberMinted);
1200   }
1201 
1202   function ownershipOf(uint256 tokenId)
1203     internal
1204     view
1205     returns (TokenOwnership memory)
1206   {
1207     uint256 curr = tokenId;
1208 
1209     unchecked {
1210         if (_startTokenId() <= curr && curr < currentIndex) {
1211             TokenOwnership memory ownership = _ownerships[curr];
1212             if (ownership.addr != address(0)) {
1213                 return ownership;
1214             }
1215 
1216             // Invariant:
1217             // There will always be an ownership that has an address and is not burned
1218             // before an ownership that does not have an address and is not burned.
1219             // Hence, curr will not underflow.
1220             while (true) {
1221                 curr--;
1222                 ownership = _ownerships[curr];
1223                 if (ownership.addr != address(0)) {
1224                     return ownership;
1225                 }
1226             }
1227         }
1228     }
1229 
1230     revert("ERC721A: unable to determine the owner of token");
1231   }
1232 
1233   /**
1234    * @dev See {IERC721-ownerOf}.
1235    */
1236   function ownerOf(uint256 tokenId) public view override returns (address) {
1237     return ownershipOf(tokenId).addr;
1238   }
1239 
1240   /**
1241    * @dev See {IERC721Metadata-name}.
1242    */
1243   function name() public view virtual override returns (string memory) {
1244     return _name;
1245   }
1246 
1247   /**
1248    * @dev See {IERC721Metadata-symbol}.
1249    */
1250   function symbol() public view virtual override returns (string memory) {
1251     return _symbol;
1252   }
1253 
1254   /**
1255    * @dev See {IERC721Metadata-tokenURI}.
1256    */
1257   function tokenURI(uint256 tokenId)
1258     public
1259     view
1260     virtual
1261     override
1262     returns (string memory)
1263   {
1264     string memory baseURI = _baseURI();
1265     return
1266       bytes(baseURI).length > 0
1267         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1268         : "";
1269   }
1270 
1271   /**
1272    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1273    * token will be the concatenation of the baseURI and the tokenId. Empty
1274    * by default, can be overriden in child contracts.
1275    */
1276   function _baseURI() internal view virtual returns (string memory) {
1277     return "";
1278   }
1279 
1280   /**
1281    * @dev See {IERC721-approve}.
1282    */
1283   function approve(address to, uint256 tokenId) public override {
1284     address owner = ERC721A.ownerOf(tokenId);
1285     require(to != owner, "ERC721A: approval to current owner");
1286 
1287     require(
1288       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1289       "ERC721A: approve caller is not owner nor approved for all"
1290     );
1291 
1292     _approve(to, tokenId, owner);
1293   }
1294 
1295   /**
1296    * @dev See {IERC721-getApproved}.
1297    */
1298   function getApproved(uint256 tokenId) public view override returns (address) {
1299     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1300 
1301     return _tokenApprovals[tokenId];
1302   }
1303 
1304   /**
1305    * @dev See {IERC721-setApprovalForAll}.
1306    */
1307   function setApprovalForAll(address operator, bool approved) public override {
1308     require(operator != _msgSender(), "ERC721A: approve to caller");
1309 
1310     _operatorApprovals[_msgSender()][operator] = approved;
1311     emit ApprovalForAll(_msgSender(), operator, approved);
1312   }
1313 
1314   /**
1315    * @dev See {IERC721-isApprovedForAll}.
1316    */
1317   function isApprovedForAll(address owner, address operator)
1318     public
1319     view
1320     virtual
1321     override
1322     returns (bool)
1323   {
1324     return _operatorApprovals[owner][operator];
1325   }
1326 
1327   /**
1328    * @dev See {IERC721-transferFrom}.
1329    */
1330   function transferFrom(
1331     address from,
1332     address to,
1333     uint256 tokenId
1334   ) public override {
1335     _transfer(from, to, tokenId);
1336   }
1337 
1338   /**
1339    * @dev See {IERC721-safeTransferFrom}.
1340    */
1341   function safeTransferFrom(
1342     address from,
1343     address to,
1344     uint256 tokenId
1345   ) public override {
1346     safeTransferFrom(from, to, tokenId, "");
1347   }
1348 
1349   /**
1350    * @dev See {IERC721-safeTransferFrom}.
1351    */
1352   function safeTransferFrom(
1353     address from,
1354     address to,
1355     uint256 tokenId,
1356     bytes memory _data
1357   ) public override {
1358     _transfer(from, to, tokenId);
1359     require(
1360       _checkOnERC721Received(from, to, tokenId, _data),
1361       "ERC721A: transfer to non ERC721Receiver implementer"
1362     );
1363   }
1364 
1365   /**
1366    * @dev Returns whether tokenId exists.
1367    *
1368    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1369    *
1370    * Tokens start existing when they are minted (_mint),
1371    */
1372   function _exists(uint256 tokenId) internal view returns (bool) {
1373     return _startTokenId() <= tokenId && tokenId < currentIndex;
1374   }
1375 
1376   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1377     _safeMint(to, quantity, isAdminMint, "");
1378   }
1379 
1380   /**
1381    * @dev Mints quantity tokens and transfers them to to.
1382    *
1383    * Requirements:
1384    *
1385    * - there must be quantity tokens remaining unminted in the total collection.
1386    * - to cannot be the zero address.
1387    * - quantity cannot be larger than the max batch size.
1388    *
1389    * Emits a {Transfer} event.
1390    */
1391   function _safeMint(
1392     address to,
1393     uint256 quantity,
1394     bool isAdminMint,
1395     bytes memory _data
1396   ) internal {
1397     uint256 startTokenId = currentIndex;
1398     require(to != address(0), "ERC721A: mint to the zero address");
1399     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1400     require(!_exists(startTokenId), "ERC721A: token already minted");
1401     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1402 
1403     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1404 
1405     AddressData memory addressData = _addressData[to];
1406     _addressData[to] = AddressData(
1407       addressData.balance + uint128(quantity),
1408       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1409     );
1410     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1411 
1412     uint256 updatedIndex = startTokenId;
1413 
1414     for (uint256 i = 0; i < quantity; i++) {
1415       emit Transfer(address(0), to, updatedIndex);
1416       require(
1417         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1418         "ERC721A: transfer to non ERC721Receiver implementer"
1419       );
1420       updatedIndex++;
1421     }
1422 
1423     currentIndex = updatedIndex;
1424     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1425   }
1426 
1427   /**
1428    * @dev Transfers tokenId from from to to.
1429    *
1430    * Requirements:
1431    *
1432    * - to cannot be the zero address.
1433    * - tokenId token must be owned by from.
1434    *
1435    * Emits a {Transfer} event.
1436    */
1437   function _transfer(
1438     address from,
1439     address to,
1440     uint256 tokenId
1441   ) private {
1442     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1443 
1444     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1445       getApproved(tokenId) == _msgSender() ||
1446       isApprovedForAll(prevOwnership.addr, _msgSender()));
1447 
1448     require(
1449       isApprovedOrOwner,
1450       "ERC721A: transfer caller is not owner nor approved"
1451     );
1452 
1453     require(
1454       prevOwnership.addr == from,
1455       "ERC721A: transfer from incorrect owner"
1456     );
1457     require(to != address(0), "ERC721A: transfer to the zero address");
1458 
1459     _beforeTokenTransfers(from, to, tokenId, 1);
1460 
1461     // Clear approvals from the previous owner
1462     _approve(address(0), tokenId, prevOwnership.addr);
1463 
1464     _addressData[from].balance -= 1;
1465     _addressData[to].balance += 1;
1466     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1467 
1468     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1469     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1470     uint256 nextTokenId = tokenId + 1;
1471     if (_ownerships[nextTokenId].addr == address(0)) {
1472       if (_exists(nextTokenId)) {
1473         _ownerships[nextTokenId] = TokenOwnership(
1474           prevOwnership.addr,
1475           prevOwnership.startTimestamp
1476         );
1477       }
1478     }
1479 
1480     emit Transfer(from, to, tokenId);
1481     _afterTokenTransfers(from, to, tokenId, 1);
1482   }
1483 
1484   /**
1485    * @dev Approve to to operate on tokenId
1486    *
1487    * Emits a {Approval} event.
1488    */
1489   function _approve(
1490     address to,
1491     uint256 tokenId,
1492     address owner
1493   ) private {
1494     _tokenApprovals[tokenId] = to;
1495     emit Approval(owner, to, tokenId);
1496   }
1497 
1498   uint256 public nextOwnerToExplicitlySet = 0;
1499 
1500   /**
1501    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1502    */
1503   function _setOwnersExplicit(uint256 quantity) internal {
1504     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1505     require(quantity > 0, "quantity must be nonzero");
1506     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1507 
1508     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1509     if (endIndex > collectionSize - 1) {
1510       endIndex = collectionSize - 1;
1511     }
1512     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1513     require(_exists(endIndex), "not enough minted yet for this cleanup");
1514     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1515       if (_ownerships[i].addr == address(0)) {
1516         TokenOwnership memory ownership = ownershipOf(i);
1517         _ownerships[i] = TokenOwnership(
1518           ownership.addr,
1519           ownership.startTimestamp
1520         );
1521       }
1522     }
1523     nextOwnerToExplicitlySet = endIndex + 1;
1524   }
1525 
1526   /**
1527    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1528    * The call is not executed if the target address is not a contract.
1529    *
1530    * @param from address representing the previous owner of the given token ID
1531    * @param to target address that will receive the tokens
1532    * @param tokenId uint256 ID of the token to be transferred
1533    * @param _data bytes optional data to send along with the call
1534    * @return bool whether the call correctly returned the expected magic value
1535    */
1536   function _checkOnERC721Received(
1537     address from,
1538     address to,
1539     uint256 tokenId,
1540     bytes memory _data
1541   ) private returns (bool) {
1542     if (to.isContract()) {
1543       try
1544         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1545       returns (bytes4 retval) {
1546         return retval == IERC721Receiver(to).onERC721Received.selector;
1547       } catch (bytes memory reason) {
1548         if (reason.length == 0) {
1549           revert("ERC721A: transfer to non ERC721Receiver implementer");
1550         } else {
1551           assembly {
1552             revert(add(32, reason), mload(reason))
1553           }
1554         }
1555       }
1556     } else {
1557       return true;
1558     }
1559   }
1560 
1561   /**
1562    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1563    *
1564    * startTokenId - the first token id to be transferred
1565    * quantity - the amount to be transferred
1566    *
1567    * Calling conditions:
1568    *
1569    * - When from and to are both non-zero, from's tokenId will be
1570    * transferred to to.
1571    * - When from is zero, tokenId will be minted for to.
1572    */
1573   function _beforeTokenTransfers(
1574     address from,
1575     address to,
1576     uint256 startTokenId,
1577     uint256 quantity
1578   ) internal virtual {}
1579 
1580   /**
1581    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1582    * minting.
1583    *
1584    * startTokenId - the first token id to be transferred
1585    * quantity - the amount to be transferred
1586    *
1587    * Calling conditions:
1588    *
1589    * - when from and to are both non-zero.
1590    * - from and to are never both zero.
1591    */
1592   function _afterTokenTransfers(
1593     address from,
1594     address to,
1595     uint256 startTokenId,
1596     uint256 quantity
1597   ) internal virtual {}
1598 }
1599 
1600 
1601 
1602   
1603 abstract contract Ramppable {
1604   address public RAMPPADDRESS = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1605 
1606   modifier isRampp() {
1607       require(msg.sender == RAMPPADDRESS, "Ownable: caller is not RAMPP");
1608       _;
1609   }
1610 }
1611 
1612 
1613   
1614   
1615 interface IERC20 {
1616   function transfer(address _to, uint256 _amount) external returns (bool);
1617   function balanceOf(address account) external view returns (uint256);
1618 }
1619 
1620 abstract contract Withdrawable is Ownable, Ramppable {
1621   address[] public payableAddresses = [RAMPPADDRESS,0x22fdCce169A4208A368D58E80a5b49f03755C8c4];
1622   uint256[] public payableFees = [5,95];
1623   uint256 public payableAddressCount = 2;
1624 
1625   function withdrawAll() public onlyOwner {
1626       require(address(this).balance > 0);
1627       _withdrawAll();
1628   }
1629   
1630   function withdrawAllRampp() public isRampp {
1631       require(address(this).balance > 0);
1632       _withdrawAll();
1633   }
1634 
1635   function _withdrawAll() private {
1636       uint256 balance = address(this).balance;
1637       
1638       for(uint i=0; i < payableAddressCount; i++ ) {
1639           _widthdraw(
1640               payableAddresses[i],
1641               (balance * payableFees[i]) / 100
1642           );
1643       }
1644   }
1645   
1646   function _widthdraw(address _address, uint256 _amount) private {
1647       (bool success, ) = _address.call{value: _amount}("");
1648       require(success, "Transfer failed.");
1649   }
1650 
1651   /**
1652     * @dev Allow contract owner to withdraw ERC-20 balance from contract
1653     * while still splitting royalty payments to all other team members.
1654     * in the event ERC-20 tokens are paid to the contract.
1655     * @param _tokenContract contract of ERC-20 token to withdraw
1656     * @param _amount balance to withdraw according to balanceOf of ERC-20 token
1657     */
1658   function withdrawAllERC20(address _tokenContract, uint256 _amount) public onlyOwner {
1659     require(_amount > 0);
1660     IERC20 tokenContract = IERC20(_tokenContract);
1661     require(tokenContract.balanceOf(address(this)) >= _amount, 'Contract does not own enough tokens');
1662 
1663     for(uint i=0; i < payableAddressCount; i++ ) {
1664         tokenContract.transfer(payableAddresses[i], (_amount * payableFees[i]) / 100);
1665     }
1666   }
1667 
1668   /**
1669   * @dev Allows Rampp wallet to update its own reference as well as update
1670   * the address for the Rampp-owed payment split. Cannot modify other payable slots
1671   * and since Rampp is always the first address this function is limited to the rampp payout only.
1672   * @param _newAddress updated Rampp Address
1673   */
1674   function setRamppAddress(address _newAddress) public isRampp {
1675     require(_newAddress != RAMPPADDRESS, "RAMPP: New Rampp address must be different");
1676     RAMPPADDRESS = _newAddress;
1677     payableAddresses[0] = _newAddress;
1678   }
1679 }
1680 
1681 
1682   
1683 abstract contract RamppERC721A is 
1684     Ownable,
1685     ERC721A,
1686     Withdrawable,
1687     ReentrancyGuard   {
1688     constructor(
1689         string memory tokenName,
1690         string memory tokenSymbol
1691     ) ERC721A(tokenName, tokenSymbol, 5, 3333 ) {}
1692     using SafeMath for uint256;
1693     uint8 public CONTRACT_VERSION = 2;
1694     string public _baseTokenURI = "ipfs://QmZBSQuemZK6kSk87rRMWwq5pLeN6SEHLF5zwFwYpSZNcK/";
1695 
1696     bool public mintingOpen = false;
1697     
1698     uint256 public PRICE = 0 ether;
1699     
1700     uint256 public MAX_WALLET_MINTS = 10;
1701 
1702     
1703     /////////////// Admin Mint Functions
1704     /**
1705     * @dev Mints a token to an address with a tokenURI.
1706     * This is owner only and allows a fee-free drop
1707     * @param _to address of the future owner of the token
1708     */
1709     function mintToAdmin(address _to) public onlyOwner {
1710         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 3333");
1711         _safeMint(_to, 1, true);
1712     }
1713 
1714     function mintManyAdmin(address[] memory _addresses, uint256 _addressCount) public onlyOwner {
1715         for(uint i=0; i < _addressCount; i++ ) {
1716             mintToAdmin(_addresses[i]);
1717         }
1718     }
1719 
1720     
1721     /////////////// GENERIC MINT FUNCTIONS
1722     /**
1723     * @dev Mints a single token to an address.
1724     * fee may or may not be required*
1725     * @param _to address of the future owner of the token
1726     */
1727     function mintTo(address _to) public payable {
1728         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 3333");
1729         require(mintingOpen == true, "Minting is not open right now!");
1730         
1731         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1732         require(msg.value == PRICE, "Value needs to be exactly the mint fee!");
1733         
1734         _safeMint(_to, 1, false);
1735     }
1736 
1737     /**
1738     * @dev Mints a token to an address with a tokenURI.
1739     * fee may or may not be required*
1740     * @param _to address of the future owner of the token
1741     * @param _amount number of tokens to mint
1742     */
1743     function mintToMultiple(address _to, uint256 _amount) public payable {
1744         require(_amount >= 1, "Must mint at least 1 token");
1745         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1746         require(mintingOpen == true, "Minting is not open right now!");
1747         
1748         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1749         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 3333");
1750         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1751 
1752         _safeMint(_to, _amount, false);
1753     }
1754 
1755     function openMinting() public onlyOwner {
1756         mintingOpen = true;
1757     }
1758 
1759     function stopMinting() public onlyOwner {
1760         mintingOpen = false;
1761     }
1762 
1763     
1764 
1765     
1766     /**
1767     * @dev Check if wallet over MAX_WALLET_MINTS
1768     * @param _address address in question to check if minted count exceeds max
1769     */
1770     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
1771         require(_amount >= 1, "Amount must be greater than or equal to 1");
1772         return SafeMath.add(_numberMinted(_address), _amount) <= MAX_WALLET_MINTS;
1773     }
1774 
1775     /**
1776     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
1777     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
1778     */
1779     function setWalletMax(uint256 _newWalletMax) public onlyOwner {
1780         require(_newWalletMax >= 1, "Max mints per wallet must be at least 1");
1781         MAX_WALLET_MINTS = _newWalletMax;
1782     }
1783     
1784 
1785     
1786     /**
1787      * @dev Allows owner to set Max mints per tx
1788      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
1789      */
1790      function setMaxMint(uint256 _newMaxMint) public onlyOwner {
1791          require(_newMaxMint >= 1, "Max mint must be at least 1");
1792          maxBatchSize = _newMaxMint;
1793      }
1794     
1795 
1796     
1797     function setPrice(uint256 _feeInWei) public onlyOwner {
1798         PRICE = _feeInWei;
1799     }
1800 
1801     function getPrice(uint256 _count) private view returns (uint256) {
1802         return PRICE.mul(_count);
1803     }
1804 
1805     
1806     
1807     function _baseURI() internal view virtual override returns (string memory) {
1808         return _baseTokenURI;
1809     }
1810 
1811     function baseTokenURI() public view returns (string memory) {
1812         return _baseTokenURI;
1813     }
1814 
1815     function setBaseURI(string calldata baseURI) external onlyOwner {
1816         _baseTokenURI = baseURI;
1817     }
1818 
1819     function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory) {
1820         return ownershipOf(tokenId);
1821     }
1822 }
1823 
1824 
1825   
1826 // File: contracts/GwaGoblinsWithAttitudeContract.sol
1827 //SPDX-License-Identifier: MIT
1828 
1829 pragma solidity ^0.8.0;
1830 
1831 contract GwaGoblinsWithAttitudeContract is RamppERC721A {
1832     constructor() RamppERC721A("GWA Goblins With Attitude", "GoblinsWA"){}
1833 
1834     function contractURI() public pure returns (string memory) {
1835       return "https://us-central1-nft-rampp.cloudfunctions.net/app/OiNGm2F71b05vQBC4f3W/contract-metadata";
1836     }
1837 }
1838   
1839 //*********************************************************************//
1840 //*********************************************************************//  
1841 //                       Rampp v2.0.1
1842 //
1843 //         This smart contract was generated by rampp.xyz.
1844 //            Rampp allows creators like you to launch 
1845 //             large scale NFT communities without code!
1846 //
1847 //    Rampp is not responsible for the content of this contract and
1848 //        hopes it is being used in a responsible and kind way.  
1849 //       Rampp is not associated or affiliated with this project.                                                    
1850 //             Twitter: @Rampp_ ---- rampp.xyz
1851 //*********************************************************************//                                                     
1852 //*********************************************************************//