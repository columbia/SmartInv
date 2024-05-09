1 /**
2  *Submitted for verification at Etherscan.io on 2020-10-17
3 */
4 
5 pragma solidity 0.6.12;
6 
7 
8 // SPDX-License-Identifier: MIT
9 /*
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with GSN meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address payable) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 /**
31  * @dev Interface of the ERC20 standard as defined in the EIP.
32  */
33 interface INBUNIERC20 {
34     /**
35      * @dev Returns the amount of tokens in existence.
36      */
37     function totalSupply() external view returns (uint256);
38 
39     /**
40      * @dev Returns the amount of tokens owned by `account`.
41      */
42     function balanceOf(address account) external view returns (uint256);
43 
44     /**
45      * @dev Moves `amount` tokens from the caller's account to `recipient`.
46      *
47      * Returns a boolean value indicating whether the operation succeeded.
48      *
49      * Emits a {Transfer} event.
50      */
51     function transfer(address recipient, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Returns the remaining number of tokens that `spender` will be
55      * allowed to spend on behalf of `owner` through {transferFrom}. This is
56      * zero by default.
57      *
58      * This value changes when {approve} or {transferFrom} are called.
59      */
60     function allowance(address owner, address spender) external view returns (uint256);
61 
62     /**
63      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * IMPORTANT: Beware that changing an allowance with this method brings the risk
68      * that someone may use both the old and the new allowance by unfortunate
69      * transaction ordering. One possible solution to mitigate this race
70      * condition is to first reduce the spender's allowance to 0 and set the
71      * desired value afterwards:
72      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
73      *
74      * Emits an {Approval} event.
75      */
76     function approve(address spender, uint256 amount) external returns (bool);
77 
78     /**
79      * @dev Moves `amount` tokens from `sender` to `recipient` using the
80      * allowance mechanism. `amount` is then deducted from the caller's
81      * allowance.
82      *
83      * Returns a boolean value indicating whether the operation succeeded.
84      *
85      * Emits a {Transfer} event.
86      */
87     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
88 
89     /**
90      * @dev Emitted when `value` tokens are moved from one account (`from`) to
91      * another (`to`).
92      *
93      * Note that `value` may be zero.
94      */
95     event Transfer(address indexed from, address indexed to, uint256 value);
96 
97     /**
98      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
99      * a call to {approve}. `value` is the new allowance.
100      */
101     event Approval(address indexed owner, address indexed spender, uint256 value);
102 
103 
104     event Log(string log);
105 
106 }
107 
108 /**
109  * @dev Wrappers over Solidity's arithmetic operations with added overflow
110  * checks.
111  *
112  * Arithmetic operations in Solidity wrap on overflow. This can easily result
113  * in bugs, because programmers usually assume that an overflow raises an
114  * error, which is the standard behavior in high level programming languages.
115  * `SafeMath` restores this intuition by reverting the transaction when an
116  * operation overflows.
117  *
118  * Using this library instead of the unchecked operations eliminates an entire
119  * class of bugs, so it's recommended to use it always.
120  */
121 library SafeMath {
122     /**
123      * @dev Returns the addition of two unsigned integers, reverting on
124      * overflow.
125      *
126      * Counterpart to Solidity's `+` operator.
127      *
128      * Requirements:
129      *
130      * - Addition cannot overflow.
131      */
132     function add(uint256 a, uint256 b) internal pure returns (uint256) {
133         uint256 c = a + b;
134         require(c >= a, "SafeMath: addition overflow");
135 
136         return c;
137     }
138 
139     /**
140      * @dev Returns the subtraction of two unsigned integers, reverting on
141      * overflow (when the result is negative).
142      *
143      * Counterpart to Solidity's `-` operator.
144      *
145      * Requirements:
146      *
147      * - Subtraction cannot overflow.
148      */
149     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
150         return sub(a, b, "SafeMath: subtraction overflow");
151     }
152 
153     /**
154      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
155      * overflow (when the result is negative).
156      *
157      * Counterpart to Solidity's `-` operator.
158      *
159      * Requirements:
160      *
161      * - Subtraction cannot overflow.
162      */
163     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
164         require(b <= a, errorMessage);
165         uint256 c = a - b;
166 
167         return c;
168     }
169 
170     /**
171      * @dev Returns the multiplication of two unsigned integers, reverting on
172      * overflow.
173      *
174      * Counterpart to Solidity's `*` operator.
175      *
176      * Requirements:
177      *
178      * - Multiplication cannot overflow.
179      */
180     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
181         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
182         // benefit is lost if 'b' is also tested.
183         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
184         if (a == 0) {
185             return 0;
186         }
187 
188         uint256 c = a * b;
189         require(c / a == b, "SafeMath: multiplication overflow");
190 
191         return c;
192     }
193 
194     /**
195      * @dev Returns the integer division of two unsigned integers. Reverts on
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
206     function div(uint256 a, uint256 b) internal pure returns (uint256) {
207         return div(a, b, "SafeMath: division by zero");
208     }
209 
210     /**
211      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
212      * division by zero. The result is rounded towards zero.
213      *
214      * Counterpart to Solidity's `/` operator. Note: this function uses a
215      * `revert` opcode (which leaves remaining gas untouched) while Solidity
216      * uses an invalid opcode to revert (consuming all remaining gas).
217      *
218      * Requirements:
219      *
220      * - The divisor cannot be zero.
221      */
222     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
223         require(b > 0, errorMessage);
224         uint256 c = a / b;
225         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
226 
227         return c;
228     }
229 
230     /**
231      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
232      * Reverts when dividing by zero.
233      *
234      * Counterpart to Solidity's `%` operator. This function uses a `revert`
235      * opcode (which leaves remaining gas untouched) while Solidity uses an
236      * invalid opcode to revert (consuming all remaining gas).
237      *
238      * Requirements:
239      *
240      * - The divisor cannot be zero.
241      */
242     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
243         return mod(a, b, "SafeMath: modulo by zero");
244     }
245 
246     /**
247      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
248      * Reverts with custom message when dividing by zero.
249      *
250      * Counterpart to Solidity's `%` operator. This function uses a `revert`
251      * opcode (which leaves remaining gas untouched) while Solidity uses an
252      * invalid opcode to revert (consuming all remaining gas).
253      *
254      * Requirements:
255      *
256      * - The divisor cannot be zero.
257      */
258     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
259         require(b != 0, errorMessage);
260         return a % b;
261     }
262 }
263 
264 /**
265  * @dev Collection of functions related to the address type
266  */
267 library Address {
268     /**
269      * @dev Returns true if `account` is a contract.
270      *
271      * [IMPORTANT]
272      * ====
273      * It is unsafe to assume that an address for which this function returns
274      * false is an externally-owned account (EOA) and not a contract.
275      *
276      * Among others, `isContract` will return false for the following
277      * types of addresses:
278      *
279      *  - an externally-owned account
280      *  - a contract in construction
281      *  - an address where a contract will be created
282      *  - an address where a contract lived, but was destroyed
283      * ====
284      */
285     function isContract(address account) internal view returns (bool) {
286         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
287         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
288         // for accounts without code, i.e. `keccak256('')`
289         bytes32 codehash;
290         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
291         // solhint-disable-next-line no-inline-assembly
292         assembly { codehash := extcodehash(account) }
293         return (codehash != accountHash && codehash != 0x0);
294     }
295 
296     /**
297      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
298      * `recipient`, forwarding all available gas and reverting on errors.
299      *
300      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
301      * of certain opcodes, possibly making contracts go over the 2300 gas limit
302      * imposed by `transfer`, making them unable to receive funds via
303      * `transfer`. {sendValue} removes this limitation.
304      *
305      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
306      *
307      * IMPORTANT: because control is transferred to `recipient`, care must be
308      * taken to not create reentrancy vulnerabilities. Consider using
309      * {ReentrancyGuard} or the
310      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
311      */
312     function sendValue(address payable recipient, uint256 amount) internal {
313         require(address(this).balance >= amount, "Address: insufficient balance");
314 
315         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
316         (bool success, ) = recipient.call{ value: amount }("");
317         require(success, "Address: unable to send value, recipient may have reverted");
318     }
319 
320     /**
321      * @dev Performs a Solidity function call using a low level `call`. A
322      * plain`call` is an unsafe replacement for a function call: use this
323      * function instead.
324      *
325      * If `target` reverts with a revert reason, it is bubbled up by this
326      * function (like regular Solidity function calls).
327      *
328      * Returns the raw returned data. To convert to the expected return value,
329      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
330      *
331      * Requirements:
332      *
333      * - `target` must be a contract.
334      * - calling `target` with `data` must not revert.
335      *
336      * _Available since v3.1._
337      */
338     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
339       return functionCall(target, data, "Address: low-level call failed");
340     }
341 
342     /**
343      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
344      * `errorMessage` as a fallback revert reason when `target` reverts.
345      *
346      * _Available since v3.1._
347      */
348     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
349         return _functionCallWithValue(target, data, 0, errorMessage);
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
354      * but also transferring `value` wei to `target`.
355      *
356      * Requirements:
357      *
358      * - the calling contract must have an ETH balance of at least `value`.
359      * - the called Solidity function must be `payable`.
360      *
361      * _Available since v3.1._
362      */
363     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
364         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
365     }
366 
367     /**
368      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
369      * with `errorMessage` as a fallback revert reason when `target` reverts.
370      *
371      * _Available since v3.1._
372      */
373     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
374         require(address(this).balance >= value, "Address: insufficient balance for call");
375         return _functionCallWithValue(target, data, value, errorMessage);
376     }
377 
378     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
379         require(isContract(target), "Address: call to non-contract");
380 
381         // solhint-disable-next-line avoid-low-level-calls
382         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
383         if (success) {
384             return returndata;
385         } else {
386             // Look for revert reason and bubble it up if present
387             if (returndata.length > 0) {
388                 // The easiest way to bubble the revert reason is using memory via assembly
389 
390                 // solhint-disable-next-line no-inline-assembly
391                 assembly {
392                     let returndata_size := mload(returndata)
393                     revert(add(32, returndata), returndata_size)
394                 }
395             } else {
396                 revert(errorMessage);
397             }
398         }
399     }
400 }
401 
402 interface IFeeApprover {
403 
404     function check(
405         address sender,
406         address recipient,
407         uint256 amount
408     ) external returns (bool);
409 
410     function setFeeMultiplier(uint _feeMultiplier) external;
411     function feePercentX100() external view returns (uint);
412 
413     function setTokenUniswapPair(address _tokenUniswapPair) external;
414 
415     function setupcoreTokenAddress(address _upcoreTokenAddress) external;
416     function sync() external;
417     function calculateAmountsAfterFee(
418         address sender,
419         address recipient,
420         uint256 amount
421     ) external  returns (uint256 transferToAmount, uint256 transferToFeeBearerAmount);
422 
423     function setPaused() external;
424 
425 
426 }
427 
428 interface IupcoreVault {
429     function addPendingRewards(uint _amount) external;
430 }
431 
432 library console {
433 	address constant CONSOLE_ADDRESS = address(0x000000000000000000636F6e736F6c652e6c6f67);
434 
435 	function _sendLogPayload(bytes memory payload) private view {
436 		uint256 payloadLength = payload.length;
437 		address consoleAddress = CONSOLE_ADDRESS;
438 		assembly {
439 			let payloadStart := add(payload, 32)
440 			let r := staticcall(gas(), consoleAddress, payloadStart, payloadLength, 0, 0)
441 		}
442 	}
443 
444 	function log() internal view {
445 		_sendLogPayload(abi.encodeWithSignature("log()"));
446 	}
447 
448 	function logInt(int p0) internal view {
449 		_sendLogPayload(abi.encodeWithSignature("log(int)", p0));
450 	}
451 
452 	function logUint(uint p0) internal view {
453 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
454 	}
455 
456 	function logString(string memory p0) internal view {
457 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
458 	}
459 
460 	function logBool(bool p0) internal view {
461 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
462 	}
463 
464 	function logAddress(address p0) internal view {
465 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
466 	}
467 
468 	function logBytes(bytes memory p0) internal view {
469 		_sendLogPayload(abi.encodeWithSignature("log(bytes)", p0));
470 	}
471 
472 	function logByte(byte p0) internal view {
473 		_sendLogPayload(abi.encodeWithSignature("log(byte)", p0));
474 	}
475 
476 	function logBytes1(bytes1 p0) internal view {
477 		_sendLogPayload(abi.encodeWithSignature("log(bytes1)", p0));
478 	}
479 
480 	function logBytes2(bytes2 p0) internal view {
481 		_sendLogPayload(abi.encodeWithSignature("log(bytes2)", p0));
482 	}
483 
484 	function logBytes3(bytes3 p0) internal view {
485 		_sendLogPayload(abi.encodeWithSignature("log(bytes3)", p0));
486 	}
487 
488 	function logBytes4(bytes4 p0) internal view {
489 		_sendLogPayload(abi.encodeWithSignature("log(bytes4)", p0));
490 	}
491 
492 	function logBytes5(bytes5 p0) internal view {
493 		_sendLogPayload(abi.encodeWithSignature("log(bytes5)", p0));
494 	}
495 
496 	function logBytes6(bytes6 p0) internal view {
497 		_sendLogPayload(abi.encodeWithSignature("log(bytes6)", p0));
498 	}
499 
500 	function logBytes7(bytes7 p0) internal view {
501 		_sendLogPayload(abi.encodeWithSignature("log(bytes7)", p0));
502 	}
503 
504 	function logBytes8(bytes8 p0) internal view {
505 		_sendLogPayload(abi.encodeWithSignature("log(bytes8)", p0));
506 	}
507 
508 	function logBytes9(bytes9 p0) internal view {
509 		_sendLogPayload(abi.encodeWithSignature("log(bytes9)", p0));
510 	}
511 
512 	function logBytes10(bytes10 p0) internal view {
513 		_sendLogPayload(abi.encodeWithSignature("log(bytes10)", p0));
514 	}
515 
516 	function logBytes11(bytes11 p0) internal view {
517 		_sendLogPayload(abi.encodeWithSignature("log(bytes11)", p0));
518 	}
519 
520 	function logBytes12(bytes12 p0) internal view {
521 		_sendLogPayload(abi.encodeWithSignature("log(bytes12)", p0));
522 	}
523 
524 	function logBytes13(bytes13 p0) internal view {
525 		_sendLogPayload(abi.encodeWithSignature("log(bytes13)", p0));
526 	}
527 
528 	function logBytes14(bytes14 p0) internal view {
529 		_sendLogPayload(abi.encodeWithSignature("log(bytes14)", p0));
530 	}
531 
532 	function logBytes15(bytes15 p0) internal view {
533 		_sendLogPayload(abi.encodeWithSignature("log(bytes15)", p0));
534 	}
535 
536 	function logBytes16(bytes16 p0) internal view {
537 		_sendLogPayload(abi.encodeWithSignature("log(bytes16)", p0));
538 	}
539 
540 	function logBytes17(bytes17 p0) internal view {
541 		_sendLogPayload(abi.encodeWithSignature("log(bytes17)", p0));
542 	}
543 
544 	function logBytes18(bytes18 p0) internal view {
545 		_sendLogPayload(abi.encodeWithSignature("log(bytes18)", p0));
546 	}
547 
548 	function logBytes19(bytes19 p0) internal view {
549 		_sendLogPayload(abi.encodeWithSignature("log(bytes19)", p0));
550 	}
551 
552 	function logBytes20(bytes20 p0) internal view {
553 		_sendLogPayload(abi.encodeWithSignature("log(bytes20)", p0));
554 	}
555 
556 	function logBytes21(bytes21 p0) internal view {
557 		_sendLogPayload(abi.encodeWithSignature("log(bytes21)", p0));
558 	}
559 
560 	function logBytes22(bytes22 p0) internal view {
561 		_sendLogPayload(abi.encodeWithSignature("log(bytes22)", p0));
562 	}
563 
564 	function logBytes23(bytes23 p0) internal view {
565 		_sendLogPayload(abi.encodeWithSignature("log(bytes23)", p0));
566 	}
567 
568 	function logBytes24(bytes24 p0) internal view {
569 		_sendLogPayload(abi.encodeWithSignature("log(bytes24)", p0));
570 	}
571 
572 	function logBytes25(bytes25 p0) internal view {
573 		_sendLogPayload(abi.encodeWithSignature("log(bytes25)", p0));
574 	}
575 
576 	function logBytes26(bytes26 p0) internal view {
577 		_sendLogPayload(abi.encodeWithSignature("log(bytes26)", p0));
578 	}
579 
580 	function logBytes27(bytes27 p0) internal view {
581 		_sendLogPayload(abi.encodeWithSignature("log(bytes27)", p0));
582 	}
583 
584 	function logBytes28(bytes28 p0) internal view {
585 		_sendLogPayload(abi.encodeWithSignature("log(bytes28)", p0));
586 	}
587 
588 	function logBytes29(bytes29 p0) internal view {
589 		_sendLogPayload(abi.encodeWithSignature("log(bytes29)", p0));
590 	}
591 
592 	function logBytes30(bytes30 p0) internal view {
593 		_sendLogPayload(abi.encodeWithSignature("log(bytes30)", p0));
594 	}
595 
596 	function logBytes31(bytes31 p0) internal view {
597 		_sendLogPayload(abi.encodeWithSignature("log(bytes31)", p0));
598 	}
599 
600 	function logBytes32(bytes32 p0) internal view {
601 		_sendLogPayload(abi.encodeWithSignature("log(bytes32)", p0));
602 	}
603 
604 	function log(uint p0) internal view {
605 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
606 	}
607 
608 	function log(string memory p0) internal view {
609 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
610 	}
611 
612 	function log(bool p0) internal view {
613 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
614 	}
615 
616 	function log(address p0) internal view {
617 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
618 	}
619 
620 	function log(uint p0, uint p1) internal view {
621 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint)", p0, p1));
622 	}
623 
624 	function log(uint p0, string memory p1) internal view {
625 		_sendLogPayload(abi.encodeWithSignature("log(uint,string)", p0, p1));
626 	}
627 
628 	function log(uint p0, bool p1) internal view {
629 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool)", p0, p1));
630 	}
631 
632 	function log(uint p0, address p1) internal view {
633 		_sendLogPayload(abi.encodeWithSignature("log(uint,address)", p0, p1));
634 	}
635 
636 	function log(string memory p0, uint p1) internal view {
637 		_sendLogPayload(abi.encodeWithSignature("log(string,uint)", p0, p1));
638 	}
639 
640 	function log(string memory p0, string memory p1) internal view {
641 		_sendLogPayload(abi.encodeWithSignature("log(string,string)", p0, p1));
642 	}
643 
644 	function log(string memory p0, bool p1) internal view {
645 		_sendLogPayload(abi.encodeWithSignature("log(string,bool)", p0, p1));
646 	}
647 
648 	function log(string memory p0, address p1) internal view {
649 		_sendLogPayload(abi.encodeWithSignature("log(string,address)", p0, p1));
650 	}
651 
652 	function log(bool p0, uint p1) internal view {
653 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint)", p0, p1));
654 	}
655 
656 	function log(bool p0, string memory p1) internal view {
657 		_sendLogPayload(abi.encodeWithSignature("log(bool,string)", p0, p1));
658 	}
659 
660 	function log(bool p0, bool p1) internal view {
661 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool)", p0, p1));
662 	}
663 
664 	function log(bool p0, address p1) internal view {
665 		_sendLogPayload(abi.encodeWithSignature("log(bool,address)", p0, p1));
666 	}
667 
668 	function log(address p0, uint p1) internal view {
669 		_sendLogPayload(abi.encodeWithSignature("log(address,uint)", p0, p1));
670 	}
671 
672 	function log(address p0, string memory p1) internal view {
673 		_sendLogPayload(abi.encodeWithSignature("log(address,string)", p0, p1));
674 	}
675 
676 	function log(address p0, bool p1) internal view {
677 		_sendLogPayload(abi.encodeWithSignature("log(address,bool)", p0, p1));
678 	}
679 
680 	function log(address p0, address p1) internal view {
681 		_sendLogPayload(abi.encodeWithSignature("log(address,address)", p0, p1));
682 	}
683 
684 	function log(uint p0, uint p1, uint p2) internal view {
685 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint)", p0, p1, p2));
686 	}
687 
688 	function log(uint p0, uint p1, string memory p2) internal view {
689 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string)", p0, p1, p2));
690 	}
691 
692 	function log(uint p0, uint p1, bool p2) internal view {
693 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool)", p0, p1, p2));
694 	}
695 
696 	function log(uint p0, uint p1, address p2) internal view {
697 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address)", p0, p1, p2));
698 	}
699 
700 	function log(uint p0, string memory p1, uint p2) internal view {
701 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint)", p0, p1, p2));
702 	}
703 
704 	function log(uint p0, string memory p1, string memory p2) internal view {
705 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string)", p0, p1, p2));
706 	}
707 
708 	function log(uint p0, string memory p1, bool p2) internal view {
709 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool)", p0, p1, p2));
710 	}
711 
712 	function log(uint p0, string memory p1, address p2) internal view {
713 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address)", p0, p1, p2));
714 	}
715 
716 	function log(uint p0, bool p1, uint p2) internal view {
717 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint)", p0, p1, p2));
718 	}
719 
720 	function log(uint p0, bool p1, string memory p2) internal view {
721 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string)", p0, p1, p2));
722 	}
723 
724 	function log(uint p0, bool p1, bool p2) internal view {
725 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool)", p0, p1, p2));
726 	}
727 
728 	function log(uint p0, bool p1, address p2) internal view {
729 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address)", p0, p1, p2));
730 	}
731 
732 	function log(uint p0, address p1, uint p2) internal view {
733 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint)", p0, p1, p2));
734 	}
735 
736 	function log(uint p0, address p1, string memory p2) internal view {
737 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string)", p0, p1, p2));
738 	}
739 
740 	function log(uint p0, address p1, bool p2) internal view {
741 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool)", p0, p1, p2));
742 	}
743 
744 	function log(uint p0, address p1, address p2) internal view {
745 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address)", p0, p1, p2));
746 	}
747 
748 	function log(string memory p0, uint p1, uint p2) internal view {
749 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint)", p0, p1, p2));
750 	}
751 
752 	function log(string memory p0, uint p1, string memory p2) internal view {
753 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string)", p0, p1, p2));
754 	}
755 
756 	function log(string memory p0, uint p1, bool p2) internal view {
757 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool)", p0, p1, p2));
758 	}
759 
760 	function log(string memory p0, uint p1, address p2) internal view {
761 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address)", p0, p1, p2));
762 	}
763 
764 	function log(string memory p0, string memory p1, uint p2) internal view {
765 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint)", p0, p1, p2));
766 	}
767 
768 	function log(string memory p0, string memory p1, string memory p2) internal view {
769 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string)", p0, p1, p2));
770 	}
771 
772 	function log(string memory p0, string memory p1, bool p2) internal view {
773 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool)", p0, p1, p2));
774 	}
775 
776 	function log(string memory p0, string memory p1, address p2) internal view {
777 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address)", p0, p1, p2));
778 	}
779 
780 	function log(string memory p0, bool p1, uint p2) internal view {
781 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint)", p0, p1, p2));
782 	}
783 
784 	function log(string memory p0, bool p1, string memory p2) internal view {
785 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string)", p0, p1, p2));
786 	}
787 
788 	function log(string memory p0, bool p1, bool p2) internal view {
789 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool)", p0, p1, p2));
790 	}
791 
792 	function log(string memory p0, bool p1, address p2) internal view {
793 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address)", p0, p1, p2));
794 	}
795 
796 	function log(string memory p0, address p1, uint p2) internal view {
797 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint)", p0, p1, p2));
798 	}
799 
800 	function log(string memory p0, address p1, string memory p2) internal view {
801 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string)", p0, p1, p2));
802 	}
803 
804 	function log(string memory p0, address p1, bool p2) internal view {
805 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool)", p0, p1, p2));
806 	}
807 
808 	function log(string memory p0, address p1, address p2) internal view {
809 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address)", p0, p1, p2));
810 	}
811 
812 	function log(bool p0, uint p1, uint p2) internal view {
813 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint)", p0, p1, p2));
814 	}
815 
816 	function log(bool p0, uint p1, string memory p2) internal view {
817 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string)", p0, p1, p2));
818 	}
819 
820 	function log(bool p0, uint p1, bool p2) internal view {
821 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool)", p0, p1, p2));
822 	}
823 
824 	function log(bool p0, uint p1, address p2) internal view {
825 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address)", p0, p1, p2));
826 	}
827 
828 	function log(bool p0, string memory p1, uint p2) internal view {
829 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint)", p0, p1, p2));
830 	}
831 
832 	function log(bool p0, string memory p1, string memory p2) internal view {
833 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string)", p0, p1, p2));
834 	}
835 
836 	function log(bool p0, string memory p1, bool p2) internal view {
837 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool)", p0, p1, p2));
838 	}
839 
840 	function log(bool p0, string memory p1, address p2) internal view {
841 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address)", p0, p1, p2));
842 	}
843 
844 	function log(bool p0, bool p1, uint p2) internal view {
845 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint)", p0, p1, p2));
846 	}
847 
848 	function log(bool p0, bool p1, string memory p2) internal view {
849 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string)", p0, p1, p2));
850 	}
851 
852 	function log(bool p0, bool p1, bool p2) internal view {
853 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool)", p0, p1, p2));
854 	}
855 
856 	function log(bool p0, bool p1, address p2) internal view {
857 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address)", p0, p1, p2));
858 	}
859 
860 	function log(bool p0, address p1, uint p2) internal view {
861 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint)", p0, p1, p2));
862 	}
863 
864 	function log(bool p0, address p1, string memory p2) internal view {
865 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string)", p0, p1, p2));
866 	}
867 
868 	function log(bool p0, address p1, bool p2) internal view {
869 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool)", p0, p1, p2));
870 	}
871 
872 	function log(bool p0, address p1, address p2) internal view {
873 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address)", p0, p1, p2));
874 	}
875 
876 	function log(address p0, uint p1, uint p2) internal view {
877 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint)", p0, p1, p2));
878 	}
879 
880 	function log(address p0, uint p1, string memory p2) internal view {
881 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string)", p0, p1, p2));
882 	}
883 
884 	function log(address p0, uint p1, bool p2) internal view {
885 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool)", p0, p1, p2));
886 	}
887 
888 	function log(address p0, uint p1, address p2) internal view {
889 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address)", p0, p1, p2));
890 	}
891 
892 	function log(address p0, string memory p1, uint p2) internal view {
893 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint)", p0, p1, p2));
894 	}
895 
896 	function log(address p0, string memory p1, string memory p2) internal view {
897 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string)", p0, p1, p2));
898 	}
899 
900 	function log(address p0, string memory p1, bool p2) internal view {
901 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool)", p0, p1, p2));
902 	}
903 
904 	function log(address p0, string memory p1, address p2) internal view {
905 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address)", p0, p1, p2));
906 	}
907 
908 	function log(address p0, bool p1, uint p2) internal view {
909 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint)", p0, p1, p2));
910 	}
911 
912 	function log(address p0, bool p1, string memory p2) internal view {
913 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string)", p0, p1, p2));
914 	}
915 
916 	function log(address p0, bool p1, bool p2) internal view {
917 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool)", p0, p1, p2));
918 	}
919 
920 	function log(address p0, bool p1, address p2) internal view {
921 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address)", p0, p1, p2));
922 	}
923 
924 	function log(address p0, address p1, uint p2) internal view {
925 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint)", p0, p1, p2));
926 	}
927 
928 	function log(address p0, address p1, string memory p2) internal view {
929 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string)", p0, p1, p2));
930 	}
931 
932 	function log(address p0, address p1, bool p2) internal view {
933 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool)", p0, p1, p2));
934 	}
935 
936 	function log(address p0, address p1, address p2) internal view {
937 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address)", p0, p1, p2));
938 	}
939 
940 	function log(uint p0, uint p1, uint p2, uint p3) internal view {
941 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,uint)", p0, p1, p2, p3));
942 	}
943 
944 	function log(uint p0, uint p1, uint p2, string memory p3) internal view {
945 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,string)", p0, p1, p2, p3));
946 	}
947 
948 	function log(uint p0, uint p1, uint p2, bool p3) internal view {
949 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,bool)", p0, p1, p2, p3));
950 	}
951 
952 	function log(uint p0, uint p1, uint p2, address p3) internal view {
953 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,address)", p0, p1, p2, p3));
954 	}
955 
956 	function log(uint p0, uint p1, string memory p2, uint p3) internal view {
957 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,uint)", p0, p1, p2, p3));
958 	}
959 
960 	function log(uint p0, uint p1, string memory p2, string memory p3) internal view {
961 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,string)", p0, p1, p2, p3));
962 	}
963 
964 	function log(uint p0, uint p1, string memory p2, bool p3) internal view {
965 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,bool)", p0, p1, p2, p3));
966 	}
967 
968 	function log(uint p0, uint p1, string memory p2, address p3) internal view {
969 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,address)", p0, p1, p2, p3));
970 	}
971 
972 	function log(uint p0, uint p1, bool p2, uint p3) internal view {
973 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,uint)", p0, p1, p2, p3));
974 	}
975 
976 	function log(uint p0, uint p1, bool p2, string memory p3) internal view {
977 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,string)", p0, p1, p2, p3));
978 	}
979 
980 	function log(uint p0, uint p1, bool p2, bool p3) internal view {
981 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,bool)", p0, p1, p2, p3));
982 	}
983 
984 	function log(uint p0, uint p1, bool p2, address p3) internal view {
985 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,address)", p0, p1, p2, p3));
986 	}
987 
988 	function log(uint p0, uint p1, address p2, uint p3) internal view {
989 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,uint)", p0, p1, p2, p3));
990 	}
991 
992 	function log(uint p0, uint p1, address p2, string memory p3) internal view {
993 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,string)", p0, p1, p2, p3));
994 	}
995 
996 	function log(uint p0, uint p1, address p2, bool p3) internal view {
997 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,bool)", p0, p1, p2, p3));
998 	}
999 
1000 	function log(uint p0, uint p1, address p2, address p3) internal view {
1001 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,address)", p0, p1, p2, p3));
1002 	}
1003 
1004 	function log(uint p0, string memory p1, uint p2, uint p3) internal view {
1005 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,uint)", p0, p1, p2, p3));
1006 	}
1007 
1008 	function log(uint p0, string memory p1, uint p2, string memory p3) internal view {
1009 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,string)", p0, p1, p2, p3));
1010 	}
1011 
1012 	function log(uint p0, string memory p1, uint p2, bool p3) internal view {
1013 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,bool)", p0, p1, p2, p3));
1014 	}
1015 
1016 	function log(uint p0, string memory p1, uint p2, address p3) internal view {
1017 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,address)", p0, p1, p2, p3));
1018 	}
1019 
1020 	function log(uint p0, string memory p1, string memory p2, uint p3) internal view {
1021 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,uint)", p0, p1, p2, p3));
1022 	}
1023 
1024 	function log(uint p0, string memory p1, string memory p2, string memory p3) internal view {
1025 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,string)", p0, p1, p2, p3));
1026 	}
1027 
1028 	function log(uint p0, string memory p1, string memory p2, bool p3) internal view {
1029 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,bool)", p0, p1, p2, p3));
1030 	}
1031 
1032 	function log(uint p0, string memory p1, string memory p2, address p3) internal view {
1033 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,address)", p0, p1, p2, p3));
1034 	}
1035 
1036 	function log(uint p0, string memory p1, bool p2, uint p3) internal view {
1037 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,uint)", p0, p1, p2, p3));
1038 	}
1039 
1040 	function log(uint p0, string memory p1, bool p2, string memory p3) internal view {
1041 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,string)", p0, p1, p2, p3));
1042 	}
1043 
1044 	function log(uint p0, string memory p1, bool p2, bool p3) internal view {
1045 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,bool)", p0, p1, p2, p3));
1046 	}
1047 
1048 	function log(uint p0, string memory p1, bool p2, address p3) internal view {
1049 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,address)", p0, p1, p2, p3));
1050 	}
1051 
1052 	function log(uint p0, string memory p1, address p2, uint p3) internal view {
1053 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,uint)", p0, p1, p2, p3));
1054 	}
1055 
1056 	function log(uint p0, string memory p1, address p2, string memory p3) internal view {
1057 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,string)", p0, p1, p2, p3));
1058 	}
1059 
1060 	function log(uint p0, string memory p1, address p2, bool p3) internal view {
1061 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,bool)", p0, p1, p2, p3));
1062 	}
1063 
1064 	function log(uint p0, string memory p1, address p2, address p3) internal view {
1065 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,address)", p0, p1, p2, p3));
1066 	}
1067 
1068 	function log(uint p0, bool p1, uint p2, uint p3) internal view {
1069 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,uint)", p0, p1, p2, p3));
1070 	}
1071 
1072 	function log(uint p0, bool p1, uint p2, string memory p3) internal view {
1073 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,string)", p0, p1, p2, p3));
1074 	}
1075 
1076 	function log(uint p0, bool p1, uint p2, bool p3) internal view {
1077 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,bool)", p0, p1, p2, p3));
1078 	}
1079 
1080 	function log(uint p0, bool p1, uint p2, address p3) internal view {
1081 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,address)", p0, p1, p2, p3));
1082 	}
1083 
1084 	function log(uint p0, bool p1, string memory p2, uint p3) internal view {
1085 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,uint)", p0, p1, p2, p3));
1086 	}
1087 
1088 	function log(uint p0, bool p1, string memory p2, string memory p3) internal view {
1089 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,string)", p0, p1, p2, p3));
1090 	}
1091 
1092 	function log(uint p0, bool p1, string memory p2, bool p3) internal view {
1093 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,bool)", p0, p1, p2, p3));
1094 	}
1095 
1096 	function log(uint p0, bool p1, string memory p2, address p3) internal view {
1097 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,address)", p0, p1, p2, p3));
1098 	}
1099 
1100 	function log(uint p0, bool p1, bool p2, uint p3) internal view {
1101 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,uint)", p0, p1, p2, p3));
1102 	}
1103 
1104 	function log(uint p0, bool p1, bool p2, string memory p3) internal view {
1105 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,string)", p0, p1, p2, p3));
1106 	}
1107 
1108 	function log(uint p0, bool p1, bool p2, bool p3) internal view {
1109 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,bool)", p0, p1, p2, p3));
1110 	}
1111 
1112 	function log(uint p0, bool p1, bool p2, address p3) internal view {
1113 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,address)", p0, p1, p2, p3));
1114 	}
1115 
1116 	function log(uint p0, bool p1, address p2, uint p3) internal view {
1117 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,uint)", p0, p1, p2, p3));
1118 	}
1119 
1120 	function log(uint p0, bool p1, address p2, string memory p3) internal view {
1121 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,string)", p0, p1, p2, p3));
1122 	}
1123 
1124 	function log(uint p0, bool p1, address p2, bool p3) internal view {
1125 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,bool)", p0, p1, p2, p3));
1126 	}
1127 
1128 	function log(uint p0, bool p1, address p2, address p3) internal view {
1129 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,address)", p0, p1, p2, p3));
1130 	}
1131 
1132 	function log(uint p0, address p1, uint p2, uint p3) internal view {
1133 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,uint)", p0, p1, p2, p3));
1134 	}
1135 
1136 	function log(uint p0, address p1, uint p2, string memory p3) internal view {
1137 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,string)", p0, p1, p2, p3));
1138 	}
1139 
1140 	function log(uint p0, address p1, uint p2, bool p3) internal view {
1141 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,bool)", p0, p1, p2, p3));
1142 	}
1143 
1144 	function log(uint p0, address p1, uint p2, address p3) internal view {
1145 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,address)", p0, p1, p2, p3));
1146 	}
1147 
1148 	function log(uint p0, address p1, string memory p2, uint p3) internal view {
1149 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,uint)", p0, p1, p2, p3));
1150 	}
1151 
1152 	function log(uint p0, address p1, string memory p2, string memory p3) internal view {
1153 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,string)", p0, p1, p2, p3));
1154 	}
1155 
1156 	function log(uint p0, address p1, string memory p2, bool p3) internal view {
1157 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,bool)", p0, p1, p2, p3));
1158 	}
1159 
1160 	function log(uint p0, address p1, string memory p2, address p3) internal view {
1161 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,address)", p0, p1, p2, p3));
1162 	}
1163 
1164 	function log(uint p0, address p1, bool p2, uint p3) internal view {
1165 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,uint)", p0, p1, p2, p3));
1166 	}
1167 
1168 	function log(uint p0, address p1, bool p2, string memory p3) internal view {
1169 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,string)", p0, p1, p2, p3));
1170 	}
1171 
1172 	function log(uint p0, address p1, bool p2, bool p3) internal view {
1173 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,bool)", p0, p1, p2, p3));
1174 	}
1175 
1176 	function log(uint p0, address p1, bool p2, address p3) internal view {
1177 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,address)", p0, p1, p2, p3));
1178 	}
1179 
1180 	function log(uint p0, address p1, address p2, uint p3) internal view {
1181 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,uint)", p0, p1, p2, p3));
1182 	}
1183 
1184 	function log(uint p0, address p1, address p2, string memory p3) internal view {
1185 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,string)", p0, p1, p2, p3));
1186 	}
1187 
1188 	function log(uint p0, address p1, address p2, bool p3) internal view {
1189 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,bool)", p0, p1, p2, p3));
1190 	}
1191 
1192 	function log(uint p0, address p1, address p2, address p3) internal view {
1193 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,address)", p0, p1, p2, p3));
1194 	}
1195 
1196 	function log(string memory p0, uint p1, uint p2, uint p3) internal view {
1197 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,uint)", p0, p1, p2, p3));
1198 	}
1199 
1200 	function log(string memory p0, uint p1, uint p2, string memory p3) internal view {
1201 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,string)", p0, p1, p2, p3));
1202 	}
1203 
1204 	function log(string memory p0, uint p1, uint p2, bool p3) internal view {
1205 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,bool)", p0, p1, p2, p3));
1206 	}
1207 
1208 	function log(string memory p0, uint p1, uint p2, address p3) internal view {
1209 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,address)", p0, p1, p2, p3));
1210 	}
1211 
1212 	function log(string memory p0, uint p1, string memory p2, uint p3) internal view {
1213 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,uint)", p0, p1, p2, p3));
1214 	}
1215 
1216 	function log(string memory p0, uint p1, string memory p2, string memory p3) internal view {
1217 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,string)", p0, p1, p2, p3));
1218 	}
1219 
1220 	function log(string memory p0, uint p1, string memory p2, bool p3) internal view {
1221 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,bool)", p0, p1, p2, p3));
1222 	}
1223 
1224 	function log(string memory p0, uint p1, string memory p2, address p3) internal view {
1225 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,address)", p0, p1, p2, p3));
1226 	}
1227 
1228 	function log(string memory p0, uint p1, bool p2, uint p3) internal view {
1229 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,uint)", p0, p1, p2, p3));
1230 	}
1231 
1232 	function log(string memory p0, uint p1, bool p2, string memory p3) internal view {
1233 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,string)", p0, p1, p2, p3));
1234 	}
1235 
1236 	function log(string memory p0, uint p1, bool p2, bool p3) internal view {
1237 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,bool)", p0, p1, p2, p3));
1238 	}
1239 
1240 	function log(string memory p0, uint p1, bool p2, address p3) internal view {
1241 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,address)", p0, p1, p2, p3));
1242 	}
1243 
1244 	function log(string memory p0, uint p1, address p2, uint p3) internal view {
1245 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,uint)", p0, p1, p2, p3));
1246 	}
1247 
1248 	function log(string memory p0, uint p1, address p2, string memory p3) internal view {
1249 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,string)", p0, p1, p2, p3));
1250 	}
1251 
1252 	function log(string memory p0, uint p1, address p2, bool p3) internal view {
1253 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,bool)", p0, p1, p2, p3));
1254 	}
1255 
1256 	function log(string memory p0, uint p1, address p2, address p3) internal view {
1257 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,address)", p0, p1, p2, p3));
1258 	}
1259 
1260 	function log(string memory p0, string memory p1, uint p2, uint p3) internal view {
1261 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,uint)", p0, p1, p2, p3));
1262 	}
1263 
1264 	function log(string memory p0, string memory p1, uint p2, string memory p3) internal view {
1265 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,string)", p0, p1, p2, p3));
1266 	}
1267 
1268 	function log(string memory p0, string memory p1, uint p2, bool p3) internal view {
1269 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,bool)", p0, p1, p2, p3));
1270 	}
1271 
1272 	function log(string memory p0, string memory p1, uint p2, address p3) internal view {
1273 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,address)", p0, p1, p2, p3));
1274 	}
1275 
1276 	function log(string memory p0, string memory p1, string memory p2, uint p3) internal view {
1277 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,uint)", p0, p1, p2, p3));
1278 	}
1279 
1280 	function log(string memory p0, string memory p1, string memory p2, string memory p3) internal view {
1281 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,string)", p0, p1, p2, p3));
1282 	}
1283 
1284 	function log(string memory p0, string memory p1, string memory p2, bool p3) internal view {
1285 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,bool)", p0, p1, p2, p3));
1286 	}
1287 
1288 	function log(string memory p0, string memory p1, string memory p2, address p3) internal view {
1289 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,address)", p0, p1, p2, p3));
1290 	}
1291 
1292 	function log(string memory p0, string memory p1, bool p2, uint p3) internal view {
1293 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,uint)", p0, p1, p2, p3));
1294 	}
1295 
1296 	function log(string memory p0, string memory p1, bool p2, string memory p3) internal view {
1297 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,string)", p0, p1, p2, p3));
1298 	}
1299 
1300 	function log(string memory p0, string memory p1, bool p2, bool p3) internal view {
1301 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,bool)", p0, p1, p2, p3));
1302 	}
1303 
1304 	function log(string memory p0, string memory p1, bool p2, address p3) internal view {
1305 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,address)", p0, p1, p2, p3));
1306 	}
1307 
1308 	function log(string memory p0, string memory p1, address p2, uint p3) internal view {
1309 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,uint)", p0, p1, p2, p3));
1310 	}
1311 
1312 	function log(string memory p0, string memory p1, address p2, string memory p3) internal view {
1313 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,string)", p0, p1, p2, p3));
1314 	}
1315 
1316 	function log(string memory p0, string memory p1, address p2, bool p3) internal view {
1317 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,bool)", p0, p1, p2, p3));
1318 	}
1319 
1320 	function log(string memory p0, string memory p1, address p2, address p3) internal view {
1321 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,address)", p0, p1, p2, p3));
1322 	}
1323 
1324 	function log(string memory p0, bool p1, uint p2, uint p3) internal view {
1325 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,uint)", p0, p1, p2, p3));
1326 	}
1327 
1328 	function log(string memory p0, bool p1, uint p2, string memory p3) internal view {
1329 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,string)", p0, p1, p2, p3));
1330 	}
1331 
1332 	function log(string memory p0, bool p1, uint p2, bool p3) internal view {
1333 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,bool)", p0, p1, p2, p3));
1334 	}
1335 
1336 	function log(string memory p0, bool p1, uint p2, address p3) internal view {
1337 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,address)", p0, p1, p2, p3));
1338 	}
1339 
1340 	function log(string memory p0, bool p1, string memory p2, uint p3) internal view {
1341 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,uint)", p0, p1, p2, p3));
1342 	}
1343 
1344 	function log(string memory p0, bool p1, string memory p2, string memory p3) internal view {
1345 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,string)", p0, p1, p2, p3));
1346 	}
1347 
1348 	function log(string memory p0, bool p1, string memory p2, bool p3) internal view {
1349 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,bool)", p0, p1, p2, p3));
1350 	}
1351 
1352 	function log(string memory p0, bool p1, string memory p2, address p3) internal view {
1353 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,address)", p0, p1, p2, p3));
1354 	}
1355 
1356 	function log(string memory p0, bool p1, bool p2, uint p3) internal view {
1357 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,uint)", p0, p1, p2, p3));
1358 	}
1359 
1360 	function log(string memory p0, bool p1, bool p2, string memory p3) internal view {
1361 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,string)", p0, p1, p2, p3));
1362 	}
1363 
1364 	function log(string memory p0, bool p1, bool p2, bool p3) internal view {
1365 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,bool)", p0, p1, p2, p3));
1366 	}
1367 
1368 	function log(string memory p0, bool p1, bool p2, address p3) internal view {
1369 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,address)", p0, p1, p2, p3));
1370 	}
1371 
1372 	function log(string memory p0, bool p1, address p2, uint p3) internal view {
1373 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,uint)", p0, p1, p2, p3));
1374 	}
1375 
1376 	function log(string memory p0, bool p1, address p2, string memory p3) internal view {
1377 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,string)", p0, p1, p2, p3));
1378 	}
1379 
1380 	function log(string memory p0, bool p1, address p2, bool p3) internal view {
1381 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,bool)", p0, p1, p2, p3));
1382 	}
1383 
1384 	function log(string memory p0, bool p1, address p2, address p3) internal view {
1385 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,address)", p0, p1, p2, p3));
1386 	}
1387 
1388 	function log(string memory p0, address p1, uint p2, uint p3) internal view {
1389 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,uint)", p0, p1, p2, p3));
1390 	}
1391 
1392 	function log(string memory p0, address p1, uint p2, string memory p3) internal view {
1393 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,string)", p0, p1, p2, p3));
1394 	}
1395 
1396 	function log(string memory p0, address p1, uint p2, bool p3) internal view {
1397 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,bool)", p0, p1, p2, p3));
1398 	}
1399 
1400 	function log(string memory p0, address p1, uint p2, address p3) internal view {
1401 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,address)", p0, p1, p2, p3));
1402 	}
1403 
1404 	function log(string memory p0, address p1, string memory p2, uint p3) internal view {
1405 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,uint)", p0, p1, p2, p3));
1406 	}
1407 
1408 	function log(string memory p0, address p1, string memory p2, string memory p3) internal view {
1409 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,string)", p0, p1, p2, p3));
1410 	}
1411 
1412 	function log(string memory p0, address p1, string memory p2, bool p3) internal view {
1413 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,bool)", p0, p1, p2, p3));
1414 	}
1415 
1416 	function log(string memory p0, address p1, string memory p2, address p3) internal view {
1417 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,address)", p0, p1, p2, p3));
1418 	}
1419 
1420 	function log(string memory p0, address p1, bool p2, uint p3) internal view {
1421 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,uint)", p0, p1, p2, p3));
1422 	}
1423 
1424 	function log(string memory p0, address p1, bool p2, string memory p3) internal view {
1425 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,string)", p0, p1, p2, p3));
1426 	}
1427 
1428 	function log(string memory p0, address p1, bool p2, bool p3) internal view {
1429 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,bool)", p0, p1, p2, p3));
1430 	}
1431 
1432 	function log(string memory p0, address p1, bool p2, address p3) internal view {
1433 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,address)", p0, p1, p2, p3));
1434 	}
1435 
1436 	function log(string memory p0, address p1, address p2, uint p3) internal view {
1437 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,uint)", p0, p1, p2, p3));
1438 	}
1439 
1440 	function log(string memory p0, address p1, address p2, string memory p3) internal view {
1441 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,string)", p0, p1, p2, p3));
1442 	}
1443 
1444 	function log(string memory p0, address p1, address p2, bool p3) internal view {
1445 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,bool)", p0, p1, p2, p3));
1446 	}
1447 
1448 	function log(string memory p0, address p1, address p2, address p3) internal view {
1449 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,address)", p0, p1, p2, p3));
1450 	}
1451 
1452 	function log(bool p0, uint p1, uint p2, uint p3) internal view {
1453 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,uint)", p0, p1, p2, p3));
1454 	}
1455 
1456 	function log(bool p0, uint p1, uint p2, string memory p3) internal view {
1457 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,string)", p0, p1, p2, p3));
1458 	}
1459 
1460 	function log(bool p0, uint p1, uint p2, bool p3) internal view {
1461 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,bool)", p0, p1, p2, p3));
1462 	}
1463 
1464 	function log(bool p0, uint p1, uint p2, address p3) internal view {
1465 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,address)", p0, p1, p2, p3));
1466 	}
1467 
1468 	function log(bool p0, uint p1, string memory p2, uint p3) internal view {
1469 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,uint)", p0, p1, p2, p3));
1470 	}
1471 
1472 	function log(bool p0, uint p1, string memory p2, string memory p3) internal view {
1473 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,string)", p0, p1, p2, p3));
1474 	}
1475 
1476 	function log(bool p0, uint p1, string memory p2, bool p3) internal view {
1477 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,bool)", p0, p1, p2, p3));
1478 	}
1479 
1480 	function log(bool p0, uint p1, string memory p2, address p3) internal view {
1481 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,address)", p0, p1, p2, p3));
1482 	}
1483 
1484 	function log(bool p0, uint p1, bool p2, uint p3) internal view {
1485 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,uint)", p0, p1, p2, p3));
1486 	}
1487 
1488 	function log(bool p0, uint p1, bool p2, string memory p3) internal view {
1489 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,string)", p0, p1, p2, p3));
1490 	}
1491 
1492 	function log(bool p0, uint p1, bool p2, bool p3) internal view {
1493 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,bool)", p0, p1, p2, p3));
1494 	}
1495 
1496 	function log(bool p0, uint p1, bool p2, address p3) internal view {
1497 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,address)", p0, p1, p2, p3));
1498 	}
1499 
1500 	function log(bool p0, uint p1, address p2, uint p3) internal view {
1501 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,uint)", p0, p1, p2, p3));
1502 	}
1503 
1504 	function log(bool p0, uint p1, address p2, string memory p3) internal view {
1505 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,string)", p0, p1, p2, p3));
1506 	}
1507 
1508 	function log(bool p0, uint p1, address p2, bool p3) internal view {
1509 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,bool)", p0, p1, p2, p3));
1510 	}
1511 
1512 	function log(bool p0, uint p1, address p2, address p3) internal view {
1513 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,address)", p0, p1, p2, p3));
1514 	}
1515 
1516 	function log(bool p0, string memory p1, uint p2, uint p3) internal view {
1517 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,uint)", p0, p1, p2, p3));
1518 	}
1519 
1520 	function log(bool p0, string memory p1, uint p2, string memory p3) internal view {
1521 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,string)", p0, p1, p2, p3));
1522 	}
1523 
1524 	function log(bool p0, string memory p1, uint p2, bool p3) internal view {
1525 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,bool)", p0, p1, p2, p3));
1526 	}
1527 
1528 	function log(bool p0, string memory p1, uint p2, address p3) internal view {
1529 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,address)", p0, p1, p2, p3));
1530 	}
1531 
1532 	function log(bool p0, string memory p1, string memory p2, uint p3) internal view {
1533 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,uint)", p0, p1, p2, p3));
1534 	}
1535 
1536 	function log(bool p0, string memory p1, string memory p2, string memory p3) internal view {
1537 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,string)", p0, p1, p2, p3));
1538 	}
1539 
1540 	function log(bool p0, string memory p1, string memory p2, bool p3) internal view {
1541 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,bool)", p0, p1, p2, p3));
1542 	}
1543 
1544 	function log(bool p0, string memory p1, string memory p2, address p3) internal view {
1545 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,address)", p0, p1, p2, p3));
1546 	}
1547 
1548 	function log(bool p0, string memory p1, bool p2, uint p3) internal view {
1549 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,uint)", p0, p1, p2, p3));
1550 	}
1551 
1552 	function log(bool p0, string memory p1, bool p2, string memory p3) internal view {
1553 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,string)", p0, p1, p2, p3));
1554 	}
1555 
1556 	function log(bool p0, string memory p1, bool p2, bool p3) internal view {
1557 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,bool)", p0, p1, p2, p3));
1558 	}
1559 
1560 	function log(bool p0, string memory p1, bool p2, address p3) internal view {
1561 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,address)", p0, p1, p2, p3));
1562 	}
1563 
1564 	function log(bool p0, string memory p1, address p2, uint p3) internal view {
1565 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,uint)", p0, p1, p2, p3));
1566 	}
1567 
1568 	function log(bool p0, string memory p1, address p2, string memory p3) internal view {
1569 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,string)", p0, p1, p2, p3));
1570 	}
1571 
1572 	function log(bool p0, string memory p1, address p2, bool p3) internal view {
1573 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,bool)", p0, p1, p2, p3));
1574 	}
1575 
1576 	function log(bool p0, string memory p1, address p2, address p3) internal view {
1577 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,address)", p0, p1, p2, p3));
1578 	}
1579 
1580 	function log(bool p0, bool p1, uint p2, uint p3) internal view {
1581 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,uint)", p0, p1, p2, p3));
1582 	}
1583 
1584 	function log(bool p0, bool p1, uint p2, string memory p3) internal view {
1585 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,string)", p0, p1, p2, p3));
1586 	}
1587 
1588 	function log(bool p0, bool p1, uint p2, bool p3) internal view {
1589 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,bool)", p0, p1, p2, p3));
1590 	}
1591 
1592 	function log(bool p0, bool p1, uint p2, address p3) internal view {
1593 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,address)", p0, p1, p2, p3));
1594 	}
1595 
1596 	function log(bool p0, bool p1, string memory p2, uint p3) internal view {
1597 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,uint)", p0, p1, p2, p3));
1598 	}
1599 
1600 	function log(bool p0, bool p1, string memory p2, string memory p3) internal view {
1601 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,string)", p0, p1, p2, p3));
1602 	}
1603 
1604 	function log(bool p0, bool p1, string memory p2, bool p3) internal view {
1605 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,bool)", p0, p1, p2, p3));
1606 	}
1607 
1608 	function log(bool p0, bool p1, string memory p2, address p3) internal view {
1609 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,address)", p0, p1, p2, p3));
1610 	}
1611 
1612 	function log(bool p0, bool p1, bool p2, uint p3) internal view {
1613 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,uint)", p0, p1, p2, p3));
1614 	}
1615 
1616 	function log(bool p0, bool p1, bool p2, string memory p3) internal view {
1617 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,string)", p0, p1, p2, p3));
1618 	}
1619 
1620 	function log(bool p0, bool p1, bool p2, bool p3) internal view {
1621 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,bool)", p0, p1, p2, p3));
1622 	}
1623 
1624 	function log(bool p0, bool p1, bool p2, address p3) internal view {
1625 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,address)", p0, p1, p2, p3));
1626 	}
1627 
1628 	function log(bool p0, bool p1, address p2, uint p3) internal view {
1629 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,uint)", p0, p1, p2, p3));
1630 	}
1631 
1632 	function log(bool p0, bool p1, address p2, string memory p3) internal view {
1633 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,string)", p0, p1, p2, p3));
1634 	}
1635 
1636 	function log(bool p0, bool p1, address p2, bool p3) internal view {
1637 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,bool)", p0, p1, p2, p3));
1638 	}
1639 
1640 	function log(bool p0, bool p1, address p2, address p3) internal view {
1641 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,address)", p0, p1, p2, p3));
1642 	}
1643 
1644 	function log(bool p0, address p1, uint p2, uint p3) internal view {
1645 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,uint)", p0, p1, p2, p3));
1646 	}
1647 
1648 	function log(bool p0, address p1, uint p2, string memory p3) internal view {
1649 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,string)", p0, p1, p2, p3));
1650 	}
1651 
1652 	function log(bool p0, address p1, uint p2, bool p3) internal view {
1653 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,bool)", p0, p1, p2, p3));
1654 	}
1655 
1656 	function log(bool p0, address p1, uint p2, address p3) internal view {
1657 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,address)", p0, p1, p2, p3));
1658 	}
1659 
1660 	function log(bool p0, address p1, string memory p2, uint p3) internal view {
1661 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,uint)", p0, p1, p2, p3));
1662 	}
1663 
1664 	function log(bool p0, address p1, string memory p2, string memory p3) internal view {
1665 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,string)", p0, p1, p2, p3));
1666 	}
1667 
1668 	function log(bool p0, address p1, string memory p2, bool p3) internal view {
1669 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,bool)", p0, p1, p2, p3));
1670 	}
1671 
1672 	function log(bool p0, address p1, string memory p2, address p3) internal view {
1673 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,address)", p0, p1, p2, p3));
1674 	}
1675 
1676 	function log(bool p0, address p1, bool p2, uint p3) internal view {
1677 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,uint)", p0, p1, p2, p3));
1678 	}
1679 
1680 	function log(bool p0, address p1, bool p2, string memory p3) internal view {
1681 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,string)", p0, p1, p2, p3));
1682 	}
1683 
1684 	function log(bool p0, address p1, bool p2, bool p3) internal view {
1685 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,bool)", p0, p1, p2, p3));
1686 	}
1687 
1688 	function log(bool p0, address p1, bool p2, address p3) internal view {
1689 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,address)", p0, p1, p2, p3));
1690 	}
1691 
1692 	function log(bool p0, address p1, address p2, uint p3) internal view {
1693 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,uint)", p0, p1, p2, p3));
1694 	}
1695 
1696 	function log(bool p0, address p1, address p2, string memory p3) internal view {
1697 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,string)", p0, p1, p2, p3));
1698 	}
1699 
1700 	function log(bool p0, address p1, address p2, bool p3) internal view {
1701 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,bool)", p0, p1, p2, p3));
1702 	}
1703 
1704 	function log(bool p0, address p1, address p2, address p3) internal view {
1705 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,address)", p0, p1, p2, p3));
1706 	}
1707 
1708 	function log(address p0, uint p1, uint p2, uint p3) internal view {
1709 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,uint)", p0, p1, p2, p3));
1710 	}
1711 
1712 	function log(address p0, uint p1, uint p2, string memory p3) internal view {
1713 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,string)", p0, p1, p2, p3));
1714 	}
1715 
1716 	function log(address p0, uint p1, uint p2, bool p3) internal view {
1717 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,bool)", p0, p1, p2, p3));
1718 	}
1719 
1720 	function log(address p0, uint p1, uint p2, address p3) internal view {
1721 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,address)", p0, p1, p2, p3));
1722 	}
1723 
1724 	function log(address p0, uint p1, string memory p2, uint p3) internal view {
1725 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,uint)", p0, p1, p2, p3));
1726 	}
1727 
1728 	function log(address p0, uint p1, string memory p2, string memory p3) internal view {
1729 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,string)", p0, p1, p2, p3));
1730 	}
1731 
1732 	function log(address p0, uint p1, string memory p2, bool p3) internal view {
1733 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,bool)", p0, p1, p2, p3));
1734 	}
1735 
1736 	function log(address p0, uint p1, string memory p2, address p3) internal view {
1737 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,address)", p0, p1, p2, p3));
1738 	}
1739 
1740 	function log(address p0, uint p1, bool p2, uint p3) internal view {
1741 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,uint)", p0, p1, p2, p3));
1742 	}
1743 
1744 	function log(address p0, uint p1, bool p2, string memory p3) internal view {
1745 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,string)", p0, p1, p2, p3));
1746 	}
1747 
1748 	function log(address p0, uint p1, bool p2, bool p3) internal view {
1749 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,bool)", p0, p1, p2, p3));
1750 	}
1751 
1752 	function log(address p0, uint p1, bool p2, address p3) internal view {
1753 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,address)", p0, p1, p2, p3));
1754 	}
1755 
1756 	function log(address p0, uint p1, address p2, uint p3) internal view {
1757 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,uint)", p0, p1, p2, p3));
1758 	}
1759 
1760 	function log(address p0, uint p1, address p2, string memory p3) internal view {
1761 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,string)", p0, p1, p2, p3));
1762 	}
1763 
1764 	function log(address p0, uint p1, address p2, bool p3) internal view {
1765 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,bool)", p0, p1, p2, p3));
1766 	}
1767 
1768 	function log(address p0, uint p1, address p2, address p3) internal view {
1769 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,address)", p0, p1, p2, p3));
1770 	}
1771 
1772 	function log(address p0, string memory p1, uint p2, uint p3) internal view {
1773 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,uint)", p0, p1, p2, p3));
1774 	}
1775 
1776 	function log(address p0, string memory p1, uint p2, string memory p3) internal view {
1777 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,string)", p0, p1, p2, p3));
1778 	}
1779 
1780 	function log(address p0, string memory p1, uint p2, bool p3) internal view {
1781 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,bool)", p0, p1, p2, p3));
1782 	}
1783 
1784 	function log(address p0, string memory p1, uint p2, address p3) internal view {
1785 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,address)", p0, p1, p2, p3));
1786 	}
1787 
1788 	function log(address p0, string memory p1, string memory p2, uint p3) internal view {
1789 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,uint)", p0, p1, p2, p3));
1790 	}
1791 
1792 	function log(address p0, string memory p1, string memory p2, string memory p3) internal view {
1793 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,string)", p0, p1, p2, p3));
1794 	}
1795 
1796 	function log(address p0, string memory p1, string memory p2, bool p3) internal view {
1797 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,bool)", p0, p1, p2, p3));
1798 	}
1799 
1800 	function log(address p0, string memory p1, string memory p2, address p3) internal view {
1801 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,address)", p0, p1, p2, p3));
1802 	}
1803 
1804 	function log(address p0, string memory p1, bool p2, uint p3) internal view {
1805 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,uint)", p0, p1, p2, p3));
1806 	}
1807 
1808 	function log(address p0, string memory p1, bool p2, string memory p3) internal view {
1809 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,string)", p0, p1, p2, p3));
1810 	}
1811 
1812 	function log(address p0, string memory p1, bool p2, bool p3) internal view {
1813 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,bool)", p0, p1, p2, p3));
1814 	}
1815 
1816 	function log(address p0, string memory p1, bool p2, address p3) internal view {
1817 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,address)", p0, p1, p2, p3));
1818 	}
1819 
1820 	function log(address p0, string memory p1, address p2, uint p3) internal view {
1821 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,uint)", p0, p1, p2, p3));
1822 	}
1823 
1824 	function log(address p0, string memory p1, address p2, string memory p3) internal view {
1825 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,string)", p0, p1, p2, p3));
1826 	}
1827 
1828 	function log(address p0, string memory p1, address p2, bool p3) internal view {
1829 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,bool)", p0, p1, p2, p3));
1830 	}
1831 
1832 	function log(address p0, string memory p1, address p2, address p3) internal view {
1833 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,address)", p0, p1, p2, p3));
1834 	}
1835 
1836 	function log(address p0, bool p1, uint p2, uint p3) internal view {
1837 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,uint)", p0, p1, p2, p3));
1838 	}
1839 
1840 	function log(address p0, bool p1, uint p2, string memory p3) internal view {
1841 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,string)", p0, p1, p2, p3));
1842 	}
1843 
1844 	function log(address p0, bool p1, uint p2, bool p3) internal view {
1845 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,bool)", p0, p1, p2, p3));
1846 	}
1847 
1848 	function log(address p0, bool p1, uint p2, address p3) internal view {
1849 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,address)", p0, p1, p2, p3));
1850 	}
1851 
1852 	function log(address p0, bool p1, string memory p2, uint p3) internal view {
1853 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,uint)", p0, p1, p2, p3));
1854 	}
1855 
1856 	function log(address p0, bool p1, string memory p2, string memory p3) internal view {
1857 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,string)", p0, p1, p2, p3));
1858 	}
1859 
1860 	function log(address p0, bool p1, string memory p2, bool p3) internal view {
1861 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,bool)", p0, p1, p2, p3));
1862 	}
1863 
1864 	function log(address p0, bool p1, string memory p2, address p3) internal view {
1865 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,address)", p0, p1, p2, p3));
1866 	}
1867 
1868 	function log(address p0, bool p1, bool p2, uint p3) internal view {
1869 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,uint)", p0, p1, p2, p3));
1870 	}
1871 
1872 	function log(address p0, bool p1, bool p2, string memory p3) internal view {
1873 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,string)", p0, p1, p2, p3));
1874 	}
1875 
1876 	function log(address p0, bool p1, bool p2, bool p3) internal view {
1877 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,bool)", p0, p1, p2, p3));
1878 	}
1879 
1880 	function log(address p0, bool p1, bool p2, address p3) internal view {
1881 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,address)", p0, p1, p2, p3));
1882 	}
1883 
1884 	function log(address p0, bool p1, address p2, uint p3) internal view {
1885 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,uint)", p0, p1, p2, p3));
1886 	}
1887 
1888 	function log(address p0, bool p1, address p2, string memory p3) internal view {
1889 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,string)", p0, p1, p2, p3));
1890 	}
1891 
1892 	function log(address p0, bool p1, address p2, bool p3) internal view {
1893 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,bool)", p0, p1, p2, p3));
1894 	}
1895 
1896 	function log(address p0, bool p1, address p2, address p3) internal view {
1897 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,address)", p0, p1, p2, p3));
1898 	}
1899 
1900 	function log(address p0, address p1, uint p2, uint p3) internal view {
1901 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,uint)", p0, p1, p2, p3));
1902 	}
1903 
1904 	function log(address p0, address p1, uint p2, string memory p3) internal view {
1905 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,string)", p0, p1, p2, p3));
1906 	}
1907 
1908 	function log(address p0, address p1, uint p2, bool p3) internal view {
1909 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,bool)", p0, p1, p2, p3));
1910 	}
1911 
1912 	function log(address p0, address p1, uint p2, address p3) internal view {
1913 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,address)", p0, p1, p2, p3));
1914 	}
1915 
1916 	function log(address p0, address p1, string memory p2, uint p3) internal view {
1917 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,uint)", p0, p1, p2, p3));
1918 	}
1919 
1920 	function log(address p0, address p1, string memory p2, string memory p3) internal view {
1921 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,string)", p0, p1, p2, p3));
1922 	}
1923 
1924 	function log(address p0, address p1, string memory p2, bool p3) internal view {
1925 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,bool)", p0, p1, p2, p3));
1926 	}
1927 
1928 	function log(address p0, address p1, string memory p2, address p3) internal view {
1929 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,address)", p0, p1, p2, p3));
1930 	}
1931 
1932 	function log(address p0, address p1, bool p2, uint p3) internal view {
1933 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,uint)", p0, p1, p2, p3));
1934 	}
1935 
1936 	function log(address p0, address p1, bool p2, string memory p3) internal view {
1937 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,string)", p0, p1, p2, p3));
1938 	}
1939 
1940 	function log(address p0, address p1, bool p2, bool p3) internal view {
1941 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,bool)", p0, p1, p2, p3));
1942 	}
1943 
1944 	function log(address p0, address p1, bool p2, address p3) internal view {
1945 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,address)", p0, p1, p2, p3));
1946 	}
1947 
1948 	function log(address p0, address p1, address p2, uint p3) internal view {
1949 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,uint)", p0, p1, p2, p3));
1950 	}
1951 
1952 	function log(address p0, address p1, address p2, string memory p3) internal view {
1953 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,string)", p0, p1, p2, p3));
1954 	}
1955 
1956 	function log(address p0, address p1, address p2, bool p3) internal view {
1957 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,bool)", p0, p1, p2, p3));
1958 	}
1959 
1960 	function log(address p0, address p1, address p2, address p3) internal view {
1961 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,address)", p0, p1, p2, p3));
1962 	}
1963 
1964 }
1965 
1966 /**
1967  * @dev Interface of the ERC20 standard as defined in the EIP.
1968  */
1969 interface IERC20 {
1970     /**
1971      * @dev Returns the amount of tokens in existence.
1972      */
1973     function totalSupply() external view returns (uint256);
1974 
1975     /**
1976      * @dev Returns the amount of tokens owned by `account`.
1977      */
1978     function balanceOf(address account) external view returns (uint256);
1979 
1980     /**
1981      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1982      *
1983      * Returns a boolean value indicating whether the operation succeeded.
1984      *
1985      * Emits a {Transfer} event.
1986      */
1987     function transfer(address recipient, uint256 amount) external returns (bool);
1988 
1989     /**
1990      * @dev Returns the remaining number of tokens that `spender` will be
1991      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1992      * zero by default.
1993      *
1994      * This value changes when {approve} or {transferFrom} are called.
1995      */
1996     function allowance(address owner, address spender) external view returns (uint256);
1997 
1998     /**
1999      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
2000      *
2001      * Returns a boolean value indicating whether the operation succeeded.
2002      *
2003      * IMPORTANT: Beware that changing an allowance with this method brings the risk
2004      * that someone may use both the old and the new allowance by unfortunate
2005      * transaction ordering. One possible solution to mitigate this race
2006      * condition is to first reduce the spender's allowance to 0 and set the
2007      * desired value afterwards:
2008      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
2009      *
2010      * Emits an {Approval} event.
2011      */
2012     function approve(address spender, uint256 amount) external returns (bool);
2013 
2014     /**
2015      * @dev Moves `amount` tokens from `sender` to `recipient` using the
2016      * allowance mechanism. `amount` is then deducted from the caller's
2017      * allowance.
2018      *
2019      * Returns a boolean value indicating whether the operation succeeded.
2020      *
2021      * Emits a {Transfer} event.
2022      */
2023     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
2024 
2025     /**
2026      * @dev Emitted when `value` tokens are moved from one account (`from`) to
2027      * another (`to`).
2028      *
2029      * Note that `value` may be zero.
2030      */
2031     event Transfer(address indexed from, address indexed to, uint256 value);
2032 
2033     /**
2034      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
2035      * a call to {approve}. `value` is the new allowance.
2036      */
2037     event Approval(address indexed owner, address indexed spender, uint256 value);
2038 }
2039 
2040 interface IUniswapV2Factory {
2041     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
2042 
2043     function feeTo() external view returns (address);
2044     function feeToSetter() external view returns (address);
2045     function migrator() external view returns (address);
2046 
2047     function getPair(address tokenA, address tokenB) external view returns (address pair);
2048     function allPairs(uint) external view returns (address pair);
2049     function allPairsLength() external view returns (uint);
2050 
2051     function createPair(address tokenA, address tokenB) external returns (address pair);
2052 
2053     function setFeeTo(address) external;
2054     function setFeeToSetter(address) external;
2055     function setMigrator(address) external;
2056 }
2057 
2058 interface IUniswapV2Router01 {
2059     function factory() external pure returns (address);
2060     function WETH() external pure returns (address);
2061 
2062     function addLiquidity(
2063         address tokenA,
2064         address tokenB,
2065         uint amountADesired,
2066         uint amountBDesired,
2067         uint amountAMin,
2068         uint amountBMin,
2069         address to,
2070         uint deadline
2071     ) external returns (uint amountA, uint amountB, uint liquidity);
2072     function addLiquidityETH(
2073         address token,
2074         uint amountTokenDesired,
2075         uint amountTokenMin,
2076         uint amountETHMin,
2077         address to,
2078         uint deadline
2079     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
2080     function removeLiquidity(
2081         address tokenA,
2082         address tokenB,
2083         uint liquidity,
2084         uint amountAMin,
2085         uint amountBMin,
2086         address to,
2087         uint deadline
2088     ) external returns (uint amountA, uint amountB);
2089     function removeLiquidityETH(
2090         address token,
2091         uint liquidity,
2092         uint amountTokenMin,
2093         uint amountETHMin,
2094         address to,
2095         uint deadline
2096     ) external returns (uint amountToken, uint amountETH);
2097     function removeLiquidityWithPermit(
2098         address tokenA,
2099         address tokenB,
2100         uint liquidity,
2101         uint amountAMin,
2102         uint amountBMin,
2103         address to,
2104         uint deadline,
2105         bool approveMax, uint8 v, bytes32 r, bytes32 s
2106     ) external returns (uint amountA, uint amountB);
2107     function removeLiquidityETHWithPermit(
2108         address token,
2109         uint liquidity,
2110         uint amountTokenMin,
2111         uint amountETHMin,
2112         address to,
2113         uint deadline,
2114         bool approveMax, uint8 v, bytes32 r, bytes32 s
2115     ) external returns (uint amountToken, uint amountETH);
2116     function swapExactTokensForTokens(
2117         uint amountIn,
2118         uint amountOutMin,
2119         address[] calldata path,
2120         address to,
2121         uint deadline
2122     ) external returns (uint[] memory amounts);
2123     function swapTokensForExactTokens(
2124         uint amountOut,
2125         uint amountInMax,
2126         address[] calldata path,
2127         address to,
2128         uint deadline
2129     ) external returns (uint[] memory amounts);
2130     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
2131         external
2132         payable
2133         returns (uint[] memory amounts);
2134     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
2135         external
2136         returns (uint[] memory amounts);
2137     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
2138         external
2139         returns (uint[] memory amounts);
2140     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
2141         external
2142         payable
2143         returns (uint[] memory amounts);
2144 
2145     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
2146     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
2147     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
2148     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
2149     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
2150 }
2151 
2152 interface IUniswapV2Router02 is IUniswapV2Router01 {
2153     function removeLiquidityETHSupportingFeeOnTransferTokens(
2154         address token,
2155         uint liquidity,
2156         uint amountTokenMin,
2157         uint amountETHMin,
2158         address to,
2159         uint deadline
2160     ) external returns (uint amountETH);
2161     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
2162         address token,
2163         uint liquidity,
2164         uint amountTokenMin,
2165         uint amountETHMin,
2166         address to,
2167         uint deadline,
2168         bool approveMax, uint8 v, bytes32 r, bytes32 s
2169     ) external returns (uint amountETH);
2170 
2171     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
2172         uint amountIn,
2173         uint amountOutMin,
2174         address[] calldata path,
2175         address to,
2176         uint deadline
2177     ) external;
2178     function swapExactETHForTokensSupportingFeeOnTransferTokens(
2179         uint amountOutMin,
2180         address[] calldata path,
2181         address to,
2182         uint deadline
2183     ) external payable;
2184     function swapExactTokensForETHSupportingFeeOnTransferTokens(
2185         uint amountIn,
2186         uint amountOutMin,
2187         address[] calldata path,
2188         address to,
2189         uint deadline
2190     ) external;
2191 }
2192 
2193 interface IUniswapV2Pair {
2194     event Approval(address indexed owner, address indexed spender, uint value);
2195     event Transfer(address indexed from, address indexed to, uint value);
2196 
2197     function name() external pure returns (string memory);
2198     function symbol() external pure returns (string memory);
2199     function decimals() external pure returns (uint8);
2200     function totalSupply() external view returns (uint);
2201     function balanceOf(address owner) external view returns (uint);
2202     function allowance(address owner, address spender) external view returns (uint);
2203 
2204     function approve(address spender, uint value) external returns (bool);
2205     function transfer(address to, uint value) external returns (bool);
2206     function transferFrom(address from, address to, uint value) external returns (bool);
2207 
2208     function DOMAIN_SEPARATOR() external view returns (bytes32);
2209     function PERMIT_TYPEHASH() external pure returns (bytes32);
2210     function nonces(address owner) external view returns (uint);
2211 
2212     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
2213 
2214     event Mint(address indexed sender, uint amount0, uint amount1);
2215     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
2216     event Swap(
2217         address indexed sender,
2218         uint amount0In,
2219         uint amount1In,
2220         uint amount0Out,
2221         uint amount1Out,
2222         address indexed to
2223     );
2224     event Sync(uint112 reserve0, uint112 reserve1);
2225 
2226     function MINIMUM_LIQUIDITY() external pure returns (uint);
2227     function factory() external view returns (address);
2228     function token0() external view returns (address);
2229     function token1() external view returns (address);
2230     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
2231     function price0CumulativeLast() external view returns (uint);
2232     function price1CumulativeLast() external view returns (uint);
2233     function kLast() external view returns (uint);
2234 
2235     function mint(address to) external returns (uint liquidity);
2236     function burn(address to) external returns (uint amount0, uint amount1);
2237     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
2238     function skim(address to) external;
2239     function sync() external;
2240 
2241     function initialize(address, address) external;
2242 }
2243 
2244 interface IWETH {
2245     function deposit() external payable;
2246     function transfer(address to, uint value) external returns (bool);
2247     function withdraw(uint) external;
2248 }
2249 
2250 /**
2251  * @dev Contract module which provides a basic access control mechanism, where
2252  * there is an account (an owner) that can be granted exclusive access to
2253  * specific functions.
2254  *
2255  * By default, the owner account will be the one that deploys the contract. This
2256  * can later be changed with {transferOwnership}.
2257  *
2258  * This module is used through inheritance. It will make available the modifier
2259  * `onlyOwner`, which can be applied to your functions to restrict their use to
2260  * the owner.
2261  */
2262 contract Ownable is Context {
2263     address private _owner;
2264 
2265     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2266 
2267     /**
2268      * @dev Initializes the contract setting the deployer as the initial owner.
2269      */
2270     constructor () internal {
2271         address msgSender = _msgSender();
2272         _owner = msgSender;
2273         emit OwnershipTransferred(address(0), msgSender);
2274     }
2275 
2276     /**
2277      * @dev Returns the address of the current owner.
2278      */
2279     function owner() public view returns (address) {
2280         return _owner;
2281     }
2282 
2283     /**
2284      * @dev Throws if called by any account other than the owner.
2285      */
2286     modifier onlyOwner() {
2287         require(_owner == _msgSender(), "Ownable: caller is not the owner");
2288         _;
2289     }
2290 
2291     /**
2292      * @dev Leaves the contract without owner. It will not be possible to call
2293      * `onlyOwner` functions anymore. Can only be called by the current owner.
2294      *
2295      * NOTE: Renouncing ownership will leave the contract without an owner,
2296      * thereby removing any functionality that is only available to the owner.
2297      */
2298     function renounceOwnership() public virtual onlyOwner {
2299         emit OwnershipTransferred(_owner, address(0));
2300         _owner = address(0);
2301     }
2302 
2303     /**
2304      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2305      * Can only be called by the current owner.
2306      */
2307     function transferOwnership(address newOwner) public virtual onlyOwner {
2308         require(newOwner != address(0), "Ownable: new owner is the zero address");
2309         emit OwnershipTransferred(_owner, newOwner);
2310         _owner = newOwner;
2311     }
2312 }
2313 
2314 /**
2315  * @dev Implementation of the {IERC20} interface.
2316  *
2317  * This implementation is agnostic to the way tokens are created. This means
2318  * that a supply mechanism has to be added in a derived contract using {_mint}.
2319  * For a generic mechanism see {ERC20PresetMinterPauser}.
2320  *
2321  * TIP: For a detailed writeup see our guide
2322  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
2323  * to implement supply mechanisms].
2324  *
2325  * We have followed general OpenZeppelin guidelines: functions revert instead
2326  * of returning `false` on failure. This behavior is nonetheless conventional
2327  * and does not conflict with the expectations of ERC20 applications.
2328  *
2329  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
2330  * This allows applications to reconstruct the allowance for all accounts just
2331  * by listening to said events. Other implementations of the EIP may not emit
2332  * these events, as it isn't required by the specification.
2333  *
2334  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
2335  * functions have been added to mitigate the well-known issues around setting
2336  * allowances. See {IERC20-approve}.
2337  */
2338 contract NBUNIERC20 is Context, INBUNIERC20, Ownable {
2339     using SafeMath for uint256;
2340     using Address for address;
2341 
2342     mapping(address => uint256) private _balances;
2343 
2344     mapping(address => mapping(address => uint256)) private _allowances;
2345 
2346     event LiquidityAddition(address indexed dst, uint value);
2347     event LPTokenClaimed(address dst, uint value);
2348 
2349     uint256 private _totalSupply;
2350 
2351     string private _name;
2352     string private _symbol;
2353     uint8 private _decimals;
2354     uint256 public constant initialSupply = 10000e18; // 10k
2355     uint256 public contractStartTimestamp;
2356 
2357 
2358     /**
2359      * @dev Returns the name of the token.
2360      */
2361     function name() public view returns (string memory) {
2362         return _name;
2363     }
2364 
2365     function initialSetup() internal {
2366         _name = "UPCORE";
2367         _symbol = "upCORE";
2368         _decimals = 18;
2369         _mint(address(this), initialSupply);
2370         contractStartTimestamp = block.timestamp;
2371         createUniswapPairMainnet(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);
2372     }
2373 
2374     /**
2375      * @dev Returns the symbol of the token, usually a shorter version of the
2376      * name.
2377      */
2378     function symbol() public view returns (string memory) {
2379         return _symbol;
2380     }
2381 
2382     /**
2383      * @dev Returns the number of decimals used to get its user representation.
2384      * For example, if `decimals` equals `2`, a balance of `505` tokens should
2385      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
2386      *
2387      * Tokens usually opt for a value of 18, imitating the relationship between
2388      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
2389      * called.
2390      *
2391      * NOTE: This information is only used for _display_ purposes: it in
2392      * no way affects any of the arithmetic of the contract, including
2393      * {IERC20-balanceOf} and {IERC20-transfer}.
2394      */
2395     function decimals() public view returns (uint8) {
2396         return _decimals;
2397     }
2398 
2399     /**
2400      * @dev See {IERC20-totalSupply}.
2401      */
2402     function totalSupply() public override view returns (uint256) {
2403         return _totalSupply;
2404     }
2405 
2406     /**
2407      * @dev See {IERC20-balanceOf}.
2408      */
2409     // function balanceOf(address account) public override returns (uint256) {
2410     //     return _balances[account];
2411     // }
2412     function balanceOf(address _owner) public override view returns (uint256) {
2413         return _balances[_owner];
2414     }
2415 
2416 
2417     IUniswapV2Router02 public uniswapRouterV2;
2418     IUniswapV2Factory public uniswapFactory;
2419 
2420 
2421     address public tokenUniswapPair;
2422 
2423     function createUniswapPairMainnet(address router, address factory) onlyOwner public returns (address) {
2424         uniswapRouterV2 = IUniswapV2Router02(router != address(0) ? router : 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // For testing
2425         uniswapFactory = IUniswapV2Factory(factory != address(0) ? factory : 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f); // For testing
2426         require(tokenUniswapPair == address(0), "Token: pool already created");
2427         tokenUniswapPair = uniswapFactory.createPair(
2428             address(uniswapRouterV2.WETH()),
2429             address(this)
2430         );
2431         return tokenUniswapPair;
2432     }
2433 
2434 
2435     //// Liquidity generation logic
2436     /// Steps - All tokens tat will ever exist go to this contract
2437     /// This contract accepts ETH as payable
2438     /// ETH is mapped to people
2439     /// When liquidity generationevent is over veryone can call
2440     /// the mint LP function
2441     // which will put all the ETH and tokens inside the uniswap contract
2442     /// without any involvement
2443     /// This LP will go into this contract
2444     /// And will be able to proportionally be withdrawn baed on ETH put in
2445     /// A emergency drain function allows the contract owner to drain all ETH and tokens from this contract
2446     /// After the liquidity generation event happened. In case something goes wrong, to send ETH back
2447 
2448 
2449     string public liquidityGenerationParticipationAgreement = "I agree that the developers and affiliated parties of the upcore team are not responsible for your funds";
2450 
2451     function getSecondsLeftInLiquidityGenerationEvent() public view returns (uint256) {
2452         require(liquidityGenerationOngoing(), "Event over");
2453         console.log("3 days since start is", contractStartTimestamp.add(3 days), "Time now is", block.timestamp);
2454         return contractStartTimestamp.add(3 days).sub(block.timestamp);
2455     }
2456 
2457     function liquidityGenerationOngoing() public view returns (bool) {
2458         console.log("3 days since start is", contractStartTimestamp.add(3 days), "Time now is", block.timestamp);
2459         console.log("liquidity generation ongoing", contractStartTimestamp.add(3 days) < block.timestamp);
2460         return contractStartTimestamp.add(3 days) > block.timestamp;
2461     }
2462 
2463     // Emergency drain in case of a bug
2464     // Adds all funds to owner to refund people
2465     // Designed to be as simple as possible
2466     function emergencyDrain24hAfterLiquidityGenerationEventIsDone() public onlyOwner {
2467         require(contractStartTimestamp.add(4 days) < block.timestamp, "Liquidity generation grace period still ongoing"); // About 24h after liquidity generation happens
2468         (bool success, ) = msg.sender.call.value(address(this).balance)("");
2469         require(success, "Transfer failed.");
2470         _balances[msg.sender] = _balances[address(this)];
2471         _balances[address(this)] = 0;
2472     }
2473 
2474     uint256 public totalLPTokensMinted;
2475     uint256 public totalETHContributed;
2476     uint256 public LPperETHUnit;
2477 
2478 
2479     bool public LPGenerationCompleted;
2480     // Sends all avaibile balances and mints LP tokens
2481     // Possible ways this could break addressed
2482     // 1) Multiple calls and resetting amounts - addressed with boolean
2483     // 2) Failed WETH wrapping/unwrapping addressed with checks
2484     // 3) Failure to create LP tokens, addressed with checks
2485     // 4) Unacceptable division errors . Addressed with multiplications by 1e18
2486     // 5) Pair not set - impossible since its set in constructor
2487     function addLiquidityToUniswapupcorexWETHPair() public {
2488         require(liquidityGenerationOngoing() == false, "Liquidity generation onging");
2489         require(LPGenerationCompleted == false, "Liquidity generation already finished");
2490         totalETHContributed = address(this).balance;
2491         IUniswapV2Pair pair = IUniswapV2Pair(tokenUniswapPair);
2492         console.log("Balance of this", totalETHContributed / 1e18);
2493         //Wrap eth
2494         address WETH = uniswapRouterV2.WETH();
2495         IWETH(WETH).deposit{value : totalETHContributed}();
2496         require(address(this).balance == 0 , "Transfer Failed");
2497         IWETH(WETH).transfer(address(pair),totalETHContributed);
2498         emit Transfer(address(this), address(pair), _balances[address(this)]);
2499         _balances[address(pair)] = _balances[address(this)];
2500         _balances[address(this)] = 0;
2501         pair.mint(address(this));
2502         totalLPTokensMinted = pair.balanceOf(address(this));
2503         console.log("Total tokens minted",totalLPTokensMinted);
2504         require(totalLPTokensMinted != 0 , "LP creation failed");
2505         LPperETHUnit = totalLPTokensMinted.mul(1e18).div(totalETHContributed); // 1e18x for  change
2506         console.log("Total per LP token", LPperETHUnit);
2507         require(LPperETHUnit != 0 , "LP creation failed");
2508         LPGenerationCompleted = true;
2509 
2510     }
2511 
2512 
2513     mapping (address => uint)  public ethContributed;
2514     // Possible ways this could break addressed
2515     // 1) No ageement to terms - added require
2516     // 2) Adding liquidity after generaion is over - added require
2517     // 3) Overflow from uint - impossible there isnt that much ETH aviable
2518     // 4) Depositing 0 - not an issue it will just add 0 to tally
2519     function addLiquidity(bool agreesToTermsOutlinedInLiquidityGenerationParticipationAgreement) public payable {
2520         require(liquidityGenerationOngoing(), "Liquidity Generation Event over");
2521         require(agreesToTermsOutlinedInLiquidityGenerationParticipationAgreement, "No agreement provided");
2522         ethContributed[msg.sender] += msg.value; // Overflow protection from safemath is not neded here
2523         totalETHContributed = totalETHContributed.add(msg.value); // for front end display during LGE. This resets with definietly correct balance while calling pair.
2524         emit LiquidityAddition(msg.sender, msg.value);
2525     }
2526 
2527     // Possible ways this could break addressed
2528     // 1) Accessing before event is over and resetting eth contributed -- added require
2529     // 2) No uniswap pair - impossible at this moment because of the LPGenerationCompleted bool
2530     // 3) LP per unit is 0 - impossible checked at generation function
2531     function claimLPTokens() public {
2532         require(LPGenerationCompleted, "Event not over yet");
2533         require(ethContributed[msg.sender] > 0 , "Nothing to claim, move along");
2534         IUniswapV2Pair pair = IUniswapV2Pair(tokenUniswapPair);
2535         uint256 amountLPToTransfer = ethContributed[msg.sender].mul(LPperETHUnit).div(1e18);
2536         pair.transfer(msg.sender, amountLPToTransfer); // stored as 1e18x value for change
2537         ethContributed[msg.sender] = 0;
2538         emit LPTokenClaimed(msg.sender, amountLPToTransfer);
2539     }
2540 
2541 
2542     /**
2543      * @dev See {IERC20-transfer}.
2544      *
2545      * Requirements:
2546      *
2547      * - `recipient` cannot be the zero address.
2548      * - the caller must have a balance of at least `amount`.
2549      */
2550     function transfer(address recipient, uint256 amount) public virtual override returns (bool)
2551     {
2552         _transfer(_msgSender(), recipient, amount);
2553         return true;
2554     }
2555 
2556     /**
2557      * @dev See {IERC20-allowance}.
2558      */
2559     function allowance(address owner, address spender)
2560         public
2561         virtual
2562         override
2563         view
2564         returns (uint256)
2565     {
2566         return _allowances[owner][spender];
2567     }
2568 
2569     /**
2570      * @dev See {IERC20-approve}.
2571      *
2572      * Requirements:
2573      *
2574      * - `spender` cannot be the zero address.
2575      */
2576     function approve(address spender, uint256 amount)
2577         public
2578         virtual
2579         override
2580         returns (bool)
2581     {
2582         _approve(_msgSender(), spender, amount);
2583         return true;
2584     }
2585 
2586     /**
2587      * @dev See {IERC20-transferFrom}.
2588      *
2589      * Emits an {Approval} event indicating the updated allowance. This is not
2590      * required by the EIP. See the note at the beginning of {ERC20};
2591      *
2592      * Requirements:
2593      * - `sender` and `recipient` cannot be the zero address.
2594      * - `sender` must have a balance of at least `amount`.
2595      * - the caller must have allowance for ``sender``'s tokens of at least
2596      * `amount`.
2597      */
2598     function transferFrom(
2599         address sender,
2600         address recipient,
2601         uint256 amount
2602     ) public virtual override returns (bool) {
2603         _transfer(sender, recipient, amount);
2604         _approve(
2605             sender,
2606             _msgSender(),
2607             _allowances[sender][_msgSender()].sub(
2608                 amount,
2609                 "ERC20: transfer amount exceeds allowance"
2610             )
2611         );
2612         return true;
2613     }
2614 
2615     /**
2616      * @dev Atomically increases the allowance granted to `spender` by the caller.
2617      *
2618      * This is an alternative to {approve} that can be used as a mitigation for
2619      * problems described in {IERC20-approve}.
2620      *
2621      * Emits an {Approval} event indicating the updated allowance.
2622      *
2623      * Requirements:
2624      *
2625      * - `spender` cannot be the zero address.
2626      */
2627     function increaseAllowance(address spender, uint256 addedValue)
2628         public
2629         virtual
2630         returns (bool)
2631     {
2632         _approve(
2633             _msgSender(),
2634             spender,
2635             _allowances[_msgSender()][spender].add(addedValue)
2636         );
2637         return true;
2638     }
2639 
2640     /**
2641      * @dev Atomically decreases the allowance granted to `spender` by the caller.
2642      *
2643      * This is an alternative to {approve} that can be used as a mitigation for
2644      * problems described in {IERC20-approve}.
2645      *
2646      * Emits an {Approval} event indicating the updated allowance.
2647      *
2648      * Requirements:
2649      *
2650      * - `spender` cannot be the zero address.
2651      * - `spender` must have allowance for the caller of at least
2652      * `subtractedValue`.
2653      */
2654     function decreaseAllowance(address spender, uint256 subtractedValue)
2655         public
2656         virtual
2657         returns (bool)
2658     {
2659         _approve(
2660             _msgSender(),
2661             spender,
2662             _allowances[_msgSender()][spender].sub(
2663                 subtractedValue,
2664                 "ERC20: decreased allowance below zero"
2665             )
2666         );
2667         return true;
2668     }
2669 
2670     function setShouldTransferChecker(address _transferCheckerAddress)
2671         public
2672         onlyOwner
2673     {
2674         transferCheckerAddress = _transferCheckerAddress;
2675     }
2676 
2677     address public transferCheckerAddress;
2678 
2679     function setFeeDistributor(address _feeDistributor)
2680         public
2681         onlyOwner
2682     {
2683         feeDistributor = _feeDistributor;
2684     }
2685 
2686     address public feeDistributor;
2687 
2688 
2689 
2690 
2691     /**
2692      * @dev Moves tokens `amount` from `sender` to `recipient`.
2693      *
2694      * This is internal function is equivalent to {transfer}, and can be used to
2695      * e.g. implement automatic token fees, slashing mechanisms, etc.
2696      *
2697      * Emits a {Transfer} event.
2698      *
2699      * Requirements:
2700      *
2701      * - `sender` cannot be the zero address.
2702      * - `recipient` cannot be the zero address.
2703      * - `sender` must have a balance of at least `amount`.
2704      */
2705     function _transfer(
2706         address sender,
2707         address recipient,
2708         uint256 amount
2709     ) internal virtual {
2710         require(sender != address(0), "ERC20: transfer from the zero address");
2711         require(recipient != address(0), "ERC20: transfer to the zero address");
2712 
2713 
2714 
2715         _beforeTokenTransfer(sender, recipient, amount);
2716 
2717         _balances[sender] = _balances[sender].sub(
2718             amount,
2719             "ERC20: transfer amount exceeds balance"
2720         );
2721 
2722         (uint256 transferToAmount, uint256 transferToFeeDistributorAmount) = IFeeApprover(transferCheckerAddress).calculateAmountsAfterFee(sender, recipient, amount);
2723 
2724 
2725         // Addressing a broken checker contract
2726         require(transferToAmount.add(transferToFeeDistributorAmount) == amount, "Math broke, does gravity still work?");
2727 
2728         _balances[recipient] = _balances[recipient].add(transferToAmount);
2729         emit Transfer(sender, recipient, transferToAmount);
2730 
2731         if(transferToFeeDistributorAmount > 0 && feeDistributor != address(0)){
2732             _balances[feeDistributor] = _balances[feeDistributor].add(transferToFeeDistributorAmount);
2733             emit Transfer(sender, feeDistributor, transferToFeeDistributorAmount);
2734             if(feeDistributor != address(0)){
2735                 IupcoreVault(feeDistributor).addPendingRewards(transferToFeeDistributorAmount);
2736             }
2737         }
2738     }
2739 
2740     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
2741      * the total supply.
2742      *
2743      * Emits a {Transfer} event with `from` set to the zero address.
2744      *
2745      * Requirements
2746      *
2747      * - `to` cannot be the zero address.
2748      */
2749 
2750     function _mint(address account, uint256 amount) internal virtual {
2751         require(account != address(0), "ERC20: mint to the zero address");
2752 
2753         _beforeTokenTransfer(address(0), account, amount);
2754 
2755         _totalSupply = _totalSupply.add(amount);
2756         _balances[account] = _balances[account].add(amount);
2757         emit Transfer(address(0), account, amount);
2758     }
2759 
2760     /**
2761      * @dev Destroys `amount` tokens from `account`, reducing the
2762      * total supply.
2763      *
2764      * Emits a {Transfer} event with `to` set to the zero address.
2765      *
2766      * Requirements
2767      *
2768      * - `account` cannot be the zero address.
2769      * - `account` must have at least `amount` tokens.
2770      */
2771     function _burn(address account, uint256 amount) internal virtual {
2772         require(account != address(0), "ERC20: burn from the zero address");
2773 
2774         _beforeTokenTransfer(account, address(0), amount);
2775 
2776         _balances[account] = _balances[account].sub(
2777             amount,
2778             "ERC20: burn amount exceeds balance"
2779         );
2780         _totalSupply = _totalSupply.sub(amount);
2781         emit Transfer(account, address(0), amount);
2782     }
2783 
2784     /**
2785      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
2786      *
2787      * This is internal function is equivalent to `approve`, and can be used to
2788      * e.g. set automatic allowances for certain subsystems, etc.
2789      *
2790      * Emits an {Approval} event.
2791      *
2792      * Requirements:
2793      *
2794      * - `owner` cannot be the zero address.
2795      * - `spender` cannot be the zero address.
2796      */
2797     function _approve(
2798         address owner,
2799         address spender,
2800         uint256 amount
2801     ) internal virtual {
2802         require(owner != address(0), "ERC20: approve from the zero address");
2803         require(spender != address(0), "ERC20: approve to the zero address");
2804 
2805         _allowances[owner][spender] = amount;
2806         emit Approval(owner, spender, amount);
2807     }
2808 
2809     /**
2810      * @dev Sets {decimals} to a value other than the default one of 18.
2811      *
2812      * WARNING: This function should only be called from the constructor. Most
2813      * applications that interact with token contracts will not expect
2814      * {decimals} to ever change, and may work incorrectly if it does.
2815      */
2816     function _setupDecimals(uint8 decimals_) internal {
2817         _decimals = decimals_;
2818     }
2819 
2820     /**
2821      * @dev Hook that is called before any transfer of tokens. This includes
2822      * minting and burning.
2823      *
2824      * Calling conditions:
2825      *
2826      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
2827      * will be to transferred to `to`.
2828      * - when `from` is zero, `amount` tokens will be minted for `to`.
2829      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
2830      * - `from` and `to` are never both zero.
2831      *
2832      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2833      */
2834     function _beforeTokenTransfer(
2835         address from,
2836         address to,
2837         uint256 amount
2838     ) internal virtual {}
2839 }
2840 
2841 // upcoreToken with Governance.
2842 contract upcore is NBUNIERC20 {
2843 
2844 
2845         /**
2846      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
2847      * a default value of 18.
2848      *
2849      * To select a different value for {decimals}, use {_setupDecimals}.
2850      *
2851      * All three of these values are immutable: they can only be set once during
2852      * construction.
2853      */
2854     constructor() public {
2855 
2856         initialSetup();
2857         // _name = name;
2858         // _symbol = symbol;
2859         // _decimals = 18;
2860         // _totalSupply = initialSupply;
2861         // _balances[address(this)] = initialSupply;
2862         // contractStartTimestamp = block.timestamp;
2863         // // UNISWAP
2864         // IUniswapV2Router02(router != address(0) ? router : 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f); // For testing
2865         // IUniswapV2Factory(factory != address(0) ? factory : 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f); // For testing
2866     }
2867 
2868     // Copied and modified from YAM code:
2869     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
2870     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
2871     // Which is copied and modified from COMPOUND:
2872     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
2873 
2874     mapping (address => address) internal _delegates;
2875 
2876     /// @notice A checkpoint for marking number of votes from a given block
2877     struct Checkpoint {
2878         uint32 fromBlock;
2879         uint256 votes;
2880     }
2881 
2882 
2883     /// @notice A record of votes checkpoints for each account, by index
2884     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
2885 
2886     /// @notice The number of checkpoints for each account
2887     mapping (address => uint32) public numCheckpoints;
2888 
2889     /// @notice The EIP-712 typehash for the contract's domain
2890     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
2891 
2892     /// @notice The EIP-712 typehash for the delegation struct used by the contract
2893     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
2894 
2895     /// @notice A record of states for signing / validating signatures
2896     mapping (address => uint) public nonces;
2897 
2898       /// @notice An event thats emitted when an account changes its delegate
2899     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
2900 
2901     /// @notice An event thats emitted when a delegate account's vote balance changes
2902     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
2903 
2904     /**
2905      * @notice Delegate votes from `msg.sender` to `delegatee`
2906      * @param delegator The address to get delegatee for
2907      */
2908     function delegates(address delegator)
2909         external
2910         view
2911         returns (address)
2912     {
2913         return _delegates[delegator];
2914     }
2915 
2916    /**
2917     * @notice Delegate votes from `msg.sender` to `delegatee`
2918     * @param delegatee The address to delegate votes to
2919     */
2920     function delegate(address delegatee) external {
2921         return _delegate(msg.sender, delegatee);
2922     }
2923 
2924     /**
2925      * @notice Delegates votes from signatory to `delegatee`
2926      * @param delegatee The address to delegate votes to
2927      * @param nonce The contract state required to match the signature
2928      * @param expiry The time at which to expire the signature
2929      * @param v The recovery byte of the signature
2930      * @param r Half of the ECDSA signature pair
2931      * @param s Half of the ECDSA signature pair
2932      */
2933     function delegateBySig(
2934         address delegatee,
2935         uint nonce,
2936         uint expiry,
2937         uint8 v,
2938         bytes32 r,
2939         bytes32 s
2940     )
2941         external
2942     {
2943         bytes32 domainSeparator = keccak256(
2944             abi.encode(
2945                 DOMAIN_TYPEHASH,
2946                 keccak256(bytes(name())),
2947                 getChainId(),
2948                 address(this)
2949             )
2950         );
2951 
2952         bytes32 structHash = keccak256(
2953             abi.encode(
2954                 DELEGATION_TYPEHASH,
2955                 delegatee,
2956                 nonce,
2957                 expiry
2958             )
2959         );
2960 
2961         bytes32 digest = keccak256(
2962             abi.encodePacked(
2963                 "\x19\x01",
2964                 domainSeparator,
2965                 structHash
2966             )
2967         );
2968 
2969         address signatory = ecrecover(digest, v, r, s);
2970         require(signatory != address(0), "upcore::delegateBySig: invalid signature");
2971         require(nonce == nonces[signatory]++, "upcore::delegateBySig: invalid nonce");
2972         require(now <= expiry, "upcore::delegateBySig: signature expired");
2973         return _delegate(signatory, delegatee);
2974     }
2975 
2976     /**
2977      * @notice Gets the current votes balance for `account`
2978      * @param account The address to get votes balance
2979      * @return The number of current votes for `account`
2980      */
2981     function getCurrentVotes(address account)
2982         external
2983         view
2984         returns (uint256)
2985     {
2986         uint32 nCheckpoints = numCheckpoints[account];
2987         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
2988     }
2989 
2990     /**
2991      * @notice Determine the prior number of votes for an account as of a block number
2992      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
2993      * @param account The address of the account to check
2994      * @param blockNumber The block number to get the vote balance at
2995      * @return The number of votes the account had as of the given block
2996      */
2997     function getPriorVotes(address account, uint blockNumber)
2998         external
2999         view
3000         returns (uint256)
3001     {
3002         require(blockNumber < block.number, "upcore::getPriorVotes: not yet determined");
3003 
3004         uint32 nCheckpoints = numCheckpoints[account];
3005         if (nCheckpoints == 0) {
3006             return 0;
3007         }
3008 
3009         // First check most recent balance
3010         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
3011             return checkpoints[account][nCheckpoints - 1].votes;
3012         }
3013 
3014         // Next check implicit zero balance
3015         if (checkpoints[account][0].fromBlock > blockNumber) {
3016             return 0;
3017         }
3018 
3019         uint32 lower = 0;
3020         uint32 upper = nCheckpoints - 1;
3021         while (upper > lower) {
3022             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
3023             Checkpoint memory cp = checkpoints[account][center];
3024             if (cp.fromBlock == blockNumber) {
3025                 return cp.votes;
3026             } else if (cp.fromBlock < blockNumber) {
3027                 lower = center;
3028             } else {
3029                 upper = center - 1;
3030             }
3031         }
3032         return checkpoints[account][lower].votes;
3033     }
3034 
3035     function _delegate(address delegator, address delegatee)
3036         internal
3037     {
3038         address currentDelegate = _delegates[delegator];
3039         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying upcore tokens (not scaled);
3040         _delegates[delegator] = delegatee;
3041 
3042         emit DelegateChanged(delegator, currentDelegate, delegatee);
3043 
3044         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
3045     }
3046 
3047     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
3048         if (srcRep != dstRep && amount > 0) {
3049             if (srcRep != address(0)) {
3050                 // decrease old representative
3051                 uint32 srcRepNum = numCheckpoints[srcRep];
3052                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
3053                 uint256 srcRepNew = srcRepOld.sub(amount);
3054                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
3055             }
3056 
3057             if (dstRep != address(0)) {
3058                 // increase new representative
3059                 uint32 dstRepNum = numCheckpoints[dstRep];
3060                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
3061                 uint256 dstRepNew = dstRepOld.add(amount);
3062                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
3063             }
3064         }
3065     }
3066 
3067     function _writeCheckpoint(
3068         address delegatee,
3069         uint32 nCheckpoints,
3070         uint256 oldVotes,
3071         uint256 newVotes
3072     )
3073         internal
3074     {
3075         uint32 blockNumber = safe32(block.number, "upcore::_writeCheckpoint: block number exceeds 32 bits");
3076 
3077         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
3078             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
3079         } else {
3080             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
3081             numCheckpoints[delegatee] = nCheckpoints + 1;
3082         }
3083 
3084         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
3085     }
3086 
3087     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
3088         require(n < 2**32, errorMessage);
3089         return uint32(n);
3090     }
3091 
3092     function getChainId() internal pure returns (uint) {
3093         uint256 chainId;
3094         assembly { chainId := chainid() }
3095         return chainId;
3096     }
3097 }