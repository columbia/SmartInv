1 /**
2  *previously submitted for verification at Etherscan.io on 2020-11-16 and 2020-11-17
3 */
4 
5 pragma solidity 0.6.12;
6 
7 
8 // SPDX-License-Identifier: MIT
9 //
10 // TCORE v1 smart contract
11 // https://tornado.finance
12 // https://t.me/tornadofinance
13 //
14 //-._    _.--'"`'--._    _.--'"`'--._    _.--'"`'--._    _   
15 //    '-:`.'|`|"':-.  '-:`.'|`|"':-.  '-:`.'|`|"':-.  '.` : '.   
16 //  '. T'.  | |  | |'. C'.  | |  | |'. O'.  | |  | |'. R'.:   '. E'.
17 //  : '.  '.| |  | |  '.  '.| |  | |  '.  '.| |  | |  '.  '.  : '.  `.
18 //  '   '.  `.:_ | :_.' '.v `.:_ | :_.' '.1 `.:_ | :_.' '.  `.'   `.
19 //         `-..,..-'       `-..,..-'       `-..,..-'       `         `
20 //
21 
22 /*
23  * @dev Provides information about the current execution context, including the
24  * sender of the transaction and its data. While these are generally available
25  * via msg.sender and msg.data, they should not be accessed in such a direct
26  * manner, since when dealing with GSN meta-transactions the account sending and
27  * paying for execution may not be the actual sender (as far as an application
28  * is concerned).
29  *
30  * This contract is only required for intermediate, library-like contracts.
31  */
32 abstract contract Context {
33     function _msgSender() internal view virtual returns (address payable) {
34         return msg.sender;
35     }
36 
37     function _msgData() internal view virtual returns (bytes memory) {
38         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
39         return msg.data;
40     }
41 }
42 
43 /**
44  * @dev Interface of the ERC20 standard as defined in the EIP.
45  */
46 interface INBUNIERC20 {
47     /**
48      * @dev Returns the amount of tokens in existence.
49      */
50     function totalSupply() external view returns (uint256);
51 
52     /**
53      * @dev Returns the amount of tokens owned by `account`.
54      */
55     function balanceOf(address account) external view returns (uint256);
56 
57     /**
58      * @dev Moves `amount` tokens from the caller's account to `recipient`.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transfer(address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Returns the remaining number of tokens that `spender` will be
68      * allowed to spend on behalf of `owner` through {transferFrom}. This is
69      * zero by default.
70      *
71      * This value changes when {approve} or {transferFrom} are called.
72      */
73     function allowance(address owner, address spender) external view returns (uint256);
74 
75     /**
76      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
77      *
78      * Returns a boolean value indicating whether the operation succeeded.
79      *
80      * IMPORTANT: Beware that changing an allowance with this method brings the risk
81      * that someone may use both the old and the new allowance by unfortunate
82      * transaction ordering. One possible solution to mitigate this race
83      * condition is to first reduce the spender's allowance to 0 and set the
84      * desired value afterwards:
85      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
86      *
87      * Emits an {Approval} event.
88      */
89     function approve(address spender, uint256 amount) external returns (bool);
90 
91     /**
92      * @dev Moves `amount` tokens from `sender` to `recipient` using the
93      * allowance mechanism. `amount` is then deducted from the caller's
94      * allowance.
95      *
96      * Returns a boolean value indicating whether the operation succeeded.
97      *
98      * Emits a {Transfer} event.
99      */
100     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
101 
102     /**
103      * @dev Emitted when `value` tokens are moved from one account (`from`) to
104      * another (`to`).
105      *
106      * Note that `value` may be zero.
107      */
108     event Transfer(address indexed from, address indexed to, uint256 value);
109 
110     /**
111      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
112      * a call to {approve}. `value` is the new allowance.
113      */
114     event Approval(address indexed owner, address indexed spender, uint256 value);
115 
116 
117     event Log(string log);
118 
119 }
120 
121 /**
122  * @dev Wrappers over Solidity's arithmetic operations with added overflow
123  * checks.
124  *
125  * Arithmetic operations in Solidity wrap on overflow. This can easily result
126  * in bugs, because programmers usually assume that an overflow raises an
127  * error, which is the standard behavior in high level programming languages.
128  * `SafeMath` restores this intuition by reverting the transaction when an
129  * operation overflows.
130  *
131  * Using this library instead of the unchecked operations eliminates an entire
132  * class of bugs, so it's recommended to use it always.
133  */
134 library SafeMath {
135     /**
136      * @dev Returns the addition of two unsigned integers, reverting on
137      * overflow.
138      *
139      * Counterpart to Solidity's `+` operator.
140      *
141      * Requirements:
142      *
143      * - Addition cannot overflow.
144      */
145     function add(uint256 a, uint256 b) internal pure returns (uint256) {
146         uint256 c = a + b;
147         require(c >= a, "SafeMath: addition overflow");
148 
149         return c;
150     }
151 
152     /**
153      * @dev Returns the subtraction of two unsigned integers, reverting on
154      * overflow (when the result is negative).
155      *
156      * Counterpart to Solidity's `-` operator.
157      *
158      * Requirements:
159      *
160      * - Subtraction cannot overflow.
161      */
162     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
163         return sub(a, b, "SafeMath: subtraction overflow");
164     }
165 
166     /**
167      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
168      * overflow (when the result is negative).
169      *
170      * Counterpart to Solidity's `-` operator.
171      *
172      * Requirements:
173      *
174      * - Subtraction cannot overflow.
175      */
176     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
177         require(b <= a, errorMessage);
178         uint256 c = a - b;
179 
180         return c;
181     }
182 
183     /**
184      * @dev Returns the multiplication of two unsigned integers, reverting on
185      * overflow.
186      *
187      * Counterpart to Solidity's `*` operator.
188      *
189      * Requirements:
190      *
191      * - Multiplication cannot overflow.
192      */
193     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
194         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
195         // benefit is lost if 'b' is also tested.
196         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
197         if (a == 0) {
198             return 0;
199         }
200 
201         uint256 c = a * b;
202         require(c / a == b, "SafeMath: multiplication overflow");
203 
204         return c;
205     }
206 
207     /**
208      * @dev Returns the integer division of two unsigned integers. Reverts on
209      * division by zero. The result is rounded towards zero.
210      *
211      * Counterpart to Solidity's `/` operator. Note: this function uses a
212      * `revert` opcode (which leaves remaining gas untouched) while Solidity
213      * uses an invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      *
217      * - The divisor cannot be zero.
218      */
219     function div(uint256 a, uint256 b) internal pure returns (uint256) {
220         return div(a, b, "SafeMath: division by zero");
221     }
222 
223     /**
224      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
225      * division by zero. The result is rounded towards zero.
226      *
227      * Counterpart to Solidity's `/` operator. Note: this function uses a
228      * `revert` opcode (which leaves remaining gas untouched) while Solidity
229      * uses an invalid opcode to revert (consuming all remaining gas).
230      *
231      * Requirements:
232      *
233      * - The divisor cannot be zero.
234      */
235     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
236         require(b > 0, errorMessage);
237         uint256 c = a / b;
238         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
239 
240         return c;
241     }
242 
243     /**
244      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
245      * Reverts when dividing by zero.
246      *
247      * Counterpart to Solidity's `%` operator. This function uses a `revert`
248      * opcode (which leaves remaining gas untouched) while Solidity uses an
249      * invalid opcode to revert (consuming all remaining gas).
250      *
251      * Requirements:
252      *
253      * - The divisor cannot be zero.
254      */
255     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
256         return mod(a, b, "SafeMath: modulo by zero");
257     }
258 
259     /**
260      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
261      * Reverts with custom message when dividing by zero.
262      *
263      * Counterpart to Solidity's `%` operator. This function uses a `revert`
264      * opcode (which leaves remaining gas untouched) while Solidity uses an
265      * invalid opcode to revert (consuming all remaining gas).
266      *
267      * Requirements:
268      *
269      * - The divisor cannot be zero.
270      */
271     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
272         require(b != 0, errorMessage);
273         return a % b;
274     }
275 }
276 
277 /**
278  * @dev Collection of functions related to the address type
279  */
280 library Address {
281     /**
282      * @dev Returns true if `account` is a contract.
283      *
284      * [IMPORTANT]
285      * ====
286      * It is unsafe to assume that an address for which this function returns
287      * false is an externally-owned account (EOA) and not a contract.
288      *
289      * Among others, `isContract` will return false for the following
290      * types of addresses:
291      *
292      *  - an externally-owned account
293      *  - a contract in construction
294      *  - an address where a contract will be created
295      *  - an address where a contract lived, but was destroyed
296      * ====
297      */
298     function isContract(address account) internal view returns (bool) {
299         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
300         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
301         // for accounts without code, i.e. `keccak256('')`
302         bytes32 codehash;
303         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
304         // solhint-disable-next-line no-inline-assembly
305         assembly { codehash := extcodehash(account) }
306         return (codehash != accountHash && codehash != 0x0);
307     }
308 
309     /**
310      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
311      * `recipient`, forwarding all available gas and reverting on errors.
312      *
313      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
314      * of certain opcodes, possibly making contracts go over the 2300 gas limit
315      * imposed by `transfer`, making them unable to receive funds via
316      * `transfer`. {sendValue} removes this limitation.
317      *
318      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
319      *
320      * IMPORTANT: because control is transferred to `recipient`, care must be
321      * taken to not create reentrancy vulnerabilities. Consider using
322      * {ReentrancyGuard} or the
323      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
324      */
325     function sendValue(address payable recipient, uint256 amount) internal {
326         require(address(this).balance >= amount, "Address: insufficient balance");
327 
328         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
329         (bool success, ) = recipient.call{ value: amount }("");
330         require(success, "Address: unable to send value, recipient may have reverted");
331     }
332 
333     /**
334      * @dev Performs a Solidity function call using a low level `call`. A
335      * plain`call` is an unsafe replacement for a function call: use this
336      * function instead.
337      *
338      * If `target` reverts with a revert reason, it is bubbled up by this
339      * function (like regular Solidity function calls).
340      *
341      * Returns the raw returned data. To convert to the expected return value,
342      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
343      *
344      * Requirements:
345      *
346      * - `target` must be a contract.
347      * - calling `target` with `data` must not revert.
348      *
349      * _Available since v3.1._
350      */
351     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
352       return functionCall(target, data, "Address: low-level call failed");
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
357      * `errorMessage` as a fallback revert reason when `target` reverts.
358      *
359      * _Available since v3.1._
360      */
361     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
362         return _functionCallWithValue(target, data, 0, errorMessage);
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
367      * but also transferring `value` wei to `target`.
368      *
369      * Requirements:
370      *
371      * - the calling contract must have an ETH balance of at least `value`.
372      * - the called Solidity function must be `payable`.
373      *
374      * _Available since v3.1._
375      */
376     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
377         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
382      * with `errorMessage` as a fallback revert reason when `target` reverts.
383      *
384      * _Available since v3.1._
385      */
386     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
387         require(address(this).balance >= value, "Address: insufficient balance for call");
388         return _functionCallWithValue(target, data, value, errorMessage);
389     }
390 
391     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
392         require(isContract(target), "Address: call to non-contract");
393 
394         // solhint-disable-next-line avoid-low-level-calls
395         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
396         if (success) {
397             return returndata;
398         } else {
399             // Look for revert reason and bubble it up if present
400             if (returndata.length > 0) {
401                 // The easiest way to bubble the revert reason is using memory via assembly
402 
403                 // solhint-disable-next-line no-inline-assembly
404                 assembly {
405                     let returndata_size := mload(returndata)
406                     revert(add(32, returndata), returndata_size)
407                 }
408             } else {
409                 revert(errorMessage);
410             }
411         }
412     }
413 }
414 
415 interface IFeeApprover {
416 
417     function check(
418         address sender,
419         address recipient,
420         uint256 amount
421     ) external returns (bool);
422 
423     function setFeeMultiplier(uint _feeMultiplier) external;
424     function feePercentX100() external view returns (uint);
425     function setTcoreTokenAddress(address _TcoreTokenAddress) external;
426     function sync() external;
427     function calculateAmountsAfterFee(
428         address sender,
429         address recipient,
430         uint256 amount
431     ) external  returns (uint256 transferToAmount, uint256 transferToFeeBearerAmount);
432 
433     function setPaused() external;
434 
435 
436 }
437 
438 interface ITcoreVault {
439     function addPendingRewards(uint _amount) external;
440 }
441 
442 library console {
443 	address constant CONSOLE_ADDRESS = address(0x000000000000000000636F6e736F6c652e6c6f67);
444 
445 	function _sendLogPayload(bytes memory payload) private view {
446 		uint256 payloadLength = payload.length;
447 		address consoleAddress = CONSOLE_ADDRESS;
448 		assembly {
449 			let payloadStart := add(payload, 32)
450 			let r := staticcall(gas(), consoleAddress, payloadStart, payloadLength, 0, 0)
451 		}
452 	}
453 
454 	function log() internal view {
455 		_sendLogPayload(abi.encodeWithSignature("log()"));
456 	}
457 
458 	function logInt(int p0) internal view {
459 		_sendLogPayload(abi.encodeWithSignature("log(int)", p0));
460 	}
461 
462 	function logUint(uint p0) internal view {
463 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
464 	}
465 
466 	function logString(string memory p0) internal view {
467 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
468 	}
469 
470 	function logBool(bool p0) internal view {
471 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
472 	}
473 
474 	function logAddress(address p0) internal view {
475 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
476 	}
477 
478 	function logBytes(bytes memory p0) internal view {
479 		_sendLogPayload(abi.encodeWithSignature("log(bytes)", p0));
480 	}
481 
482 	function logByte(byte p0) internal view {
483 		_sendLogPayload(abi.encodeWithSignature("log(byte)", p0));
484 	}
485 
486 	function logBytes1(bytes1 p0) internal view {
487 		_sendLogPayload(abi.encodeWithSignature("log(bytes1)", p0));
488 	}
489 
490 	function logBytes2(bytes2 p0) internal view {
491 		_sendLogPayload(abi.encodeWithSignature("log(bytes2)", p0));
492 	}
493 
494 	function logBytes3(bytes3 p0) internal view {
495 		_sendLogPayload(abi.encodeWithSignature("log(bytes3)", p0));
496 	}
497 
498 	function logBytes4(bytes4 p0) internal view {
499 		_sendLogPayload(abi.encodeWithSignature("log(bytes4)", p0));
500 	}
501 
502 	function logBytes5(bytes5 p0) internal view {
503 		_sendLogPayload(abi.encodeWithSignature("log(bytes5)", p0));
504 	}
505 
506 	function logBytes6(bytes6 p0) internal view {
507 		_sendLogPayload(abi.encodeWithSignature("log(bytes6)", p0));
508 	}
509 
510 	function logBytes7(bytes7 p0) internal view {
511 		_sendLogPayload(abi.encodeWithSignature("log(bytes7)", p0));
512 	}
513 
514 	function logBytes8(bytes8 p0) internal view {
515 		_sendLogPayload(abi.encodeWithSignature("log(bytes8)", p0));
516 	}
517 
518 	function logBytes9(bytes9 p0) internal view {
519 		_sendLogPayload(abi.encodeWithSignature("log(bytes9)", p0));
520 	}
521 
522 	function logBytes10(bytes10 p0) internal view {
523 		_sendLogPayload(abi.encodeWithSignature("log(bytes10)", p0));
524 	}
525 
526 	function logBytes11(bytes11 p0) internal view {
527 		_sendLogPayload(abi.encodeWithSignature("log(bytes11)", p0));
528 	}
529 
530 	function logBytes12(bytes12 p0) internal view {
531 		_sendLogPayload(abi.encodeWithSignature("log(bytes12)", p0));
532 	}
533 
534 	function logBytes13(bytes13 p0) internal view {
535 		_sendLogPayload(abi.encodeWithSignature("log(bytes13)", p0));
536 	}
537 
538 	function logBytes14(bytes14 p0) internal view {
539 		_sendLogPayload(abi.encodeWithSignature("log(bytes14)", p0));
540 	}
541 
542 	function logBytes15(bytes15 p0) internal view {
543 		_sendLogPayload(abi.encodeWithSignature("log(bytes15)", p0));
544 	}
545 
546 	function logBytes16(bytes16 p0) internal view {
547 		_sendLogPayload(abi.encodeWithSignature("log(bytes16)", p0));
548 	}
549 
550 	function logBytes17(bytes17 p0) internal view {
551 		_sendLogPayload(abi.encodeWithSignature("log(bytes17)", p0));
552 	}
553 
554 	function logBytes18(bytes18 p0) internal view {
555 		_sendLogPayload(abi.encodeWithSignature("log(bytes18)", p0));
556 	}
557 
558 	function logBytes19(bytes19 p0) internal view {
559 		_sendLogPayload(abi.encodeWithSignature("log(bytes19)", p0));
560 	}
561 
562 	function logBytes20(bytes20 p0) internal view {
563 		_sendLogPayload(abi.encodeWithSignature("log(bytes20)", p0));
564 	}
565 
566 	function logBytes21(bytes21 p0) internal view {
567 		_sendLogPayload(abi.encodeWithSignature("log(bytes21)", p0));
568 	}
569 
570 	function logBytes22(bytes22 p0) internal view {
571 		_sendLogPayload(abi.encodeWithSignature("log(bytes22)", p0));
572 	}
573 
574 	function logBytes23(bytes23 p0) internal view {
575 		_sendLogPayload(abi.encodeWithSignature("log(bytes23)", p0));
576 	}
577 
578 	function logBytes24(bytes24 p0) internal view {
579 		_sendLogPayload(abi.encodeWithSignature("log(bytes24)", p0));
580 	}
581 
582 	function logBytes25(bytes25 p0) internal view {
583 		_sendLogPayload(abi.encodeWithSignature("log(bytes25)", p0));
584 	}
585 
586 	function logBytes26(bytes26 p0) internal view {
587 		_sendLogPayload(abi.encodeWithSignature("log(bytes26)", p0));
588 	}
589 
590 	function logBytes27(bytes27 p0) internal view {
591 		_sendLogPayload(abi.encodeWithSignature("log(bytes27)", p0));
592 	}
593 
594 	function logBytes28(bytes28 p0) internal view {
595 		_sendLogPayload(abi.encodeWithSignature("log(bytes28)", p0));
596 	}
597 
598 	function logBytes29(bytes29 p0) internal view {
599 		_sendLogPayload(abi.encodeWithSignature("log(bytes29)", p0));
600 	}
601 
602 	function logBytes30(bytes30 p0) internal view {
603 		_sendLogPayload(abi.encodeWithSignature("log(bytes30)", p0));
604 	}
605 
606 	function logBytes31(bytes31 p0) internal view {
607 		_sendLogPayload(abi.encodeWithSignature("log(bytes31)", p0));
608 	}
609 
610 	function logBytes32(bytes32 p0) internal view {
611 		_sendLogPayload(abi.encodeWithSignature("log(bytes32)", p0));
612 	}
613 
614 	function log(uint p0) internal view {
615 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
616 	}
617 
618 	function log(string memory p0) internal view {
619 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
620 	}
621 
622 	function log(bool p0) internal view {
623 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
624 	}
625 
626 	function log(address p0) internal view {
627 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
628 	}
629 
630 	function log(uint p0, uint p1) internal view {
631 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint)", p0, p1));
632 	}
633 
634 	function log(uint p0, string memory p1) internal view {
635 		_sendLogPayload(abi.encodeWithSignature("log(uint,string)", p0, p1));
636 	}
637 
638 	function log(uint p0, bool p1) internal view {
639 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool)", p0, p1));
640 	}
641 
642 	function log(uint p0, address p1) internal view {
643 		_sendLogPayload(abi.encodeWithSignature("log(uint,address)", p0, p1));
644 	}
645 
646 	function log(string memory p0, uint p1) internal view {
647 		_sendLogPayload(abi.encodeWithSignature("log(string,uint)", p0, p1));
648 	}
649 
650 	function log(string memory p0, string memory p1) internal view {
651 		_sendLogPayload(abi.encodeWithSignature("log(string,string)", p0, p1));
652 	}
653 
654 	function log(string memory p0, bool p1) internal view {
655 		_sendLogPayload(abi.encodeWithSignature("log(string,bool)", p0, p1));
656 	}
657 
658 	function log(string memory p0, address p1) internal view {
659 		_sendLogPayload(abi.encodeWithSignature("log(string,address)", p0, p1));
660 	}
661 
662 	function log(bool p0, uint p1) internal view {
663 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint)", p0, p1));
664 	}
665 
666 	function log(bool p0, string memory p1) internal view {
667 		_sendLogPayload(abi.encodeWithSignature("log(bool,string)", p0, p1));
668 	}
669 
670 	function log(bool p0, bool p1) internal view {
671 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool)", p0, p1));
672 	}
673 
674 	function log(bool p0, address p1) internal view {
675 		_sendLogPayload(abi.encodeWithSignature("log(bool,address)", p0, p1));
676 	}
677 
678 	function log(address p0, uint p1) internal view {
679 		_sendLogPayload(abi.encodeWithSignature("log(address,uint)", p0, p1));
680 	}
681 
682 	function log(address p0, string memory p1) internal view {
683 		_sendLogPayload(abi.encodeWithSignature("log(address,string)", p0, p1));
684 	}
685 
686 	function log(address p0, bool p1) internal view {
687 		_sendLogPayload(abi.encodeWithSignature("log(address,bool)", p0, p1));
688 	}
689 
690 	function log(address p0, address p1) internal view {
691 		_sendLogPayload(abi.encodeWithSignature("log(address,address)", p0, p1));
692 	}
693 
694 	function log(uint p0, uint p1, uint p2) internal view {
695 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint)", p0, p1, p2));
696 	}
697 
698 	function log(uint p0, uint p1, string memory p2) internal view {
699 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string)", p0, p1, p2));
700 	}
701 
702 	function log(uint p0, uint p1, bool p2) internal view {
703 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool)", p0, p1, p2));
704 	}
705 
706 	function log(uint p0, uint p1, address p2) internal view {
707 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address)", p0, p1, p2));
708 	}
709 
710 	function log(uint p0, string memory p1, uint p2) internal view {
711 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint)", p0, p1, p2));
712 	}
713 
714 	function log(uint p0, string memory p1, string memory p2) internal view {
715 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string)", p0, p1, p2));
716 	}
717 
718 	function log(uint p0, string memory p1, bool p2) internal view {
719 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool)", p0, p1, p2));
720 	}
721 
722 	function log(uint p0, string memory p1, address p2) internal view {
723 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address)", p0, p1, p2));
724 	}
725 
726 	function log(uint p0, bool p1, uint p2) internal view {
727 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint)", p0, p1, p2));
728 	}
729 
730 	function log(uint p0, bool p1, string memory p2) internal view {
731 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string)", p0, p1, p2));
732 	}
733 
734 	function log(uint p0, bool p1, bool p2) internal view {
735 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool)", p0, p1, p2));
736 	}
737 
738 	function log(uint p0, bool p1, address p2) internal view {
739 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address)", p0, p1, p2));
740 	}
741 
742 	function log(uint p0, address p1, uint p2) internal view {
743 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint)", p0, p1, p2));
744 	}
745 
746 	function log(uint p0, address p1, string memory p2) internal view {
747 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string)", p0, p1, p2));
748 	}
749 
750 	function log(uint p0, address p1, bool p2) internal view {
751 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool)", p0, p1, p2));
752 	}
753 
754 	function log(uint p0, address p1, address p2) internal view {
755 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address)", p0, p1, p2));
756 	}
757 
758 	function log(string memory p0, uint p1, uint p2) internal view {
759 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint)", p0, p1, p2));
760 	}
761 
762 	function log(string memory p0, uint p1, string memory p2) internal view {
763 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string)", p0, p1, p2));
764 	}
765 
766 	function log(string memory p0, uint p1, bool p2) internal view {
767 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool)", p0, p1, p2));
768 	}
769 
770 	function log(string memory p0, uint p1, address p2) internal view {
771 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address)", p0, p1, p2));
772 	}
773 
774 	function log(string memory p0, string memory p1, uint p2) internal view {
775 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint)", p0, p1, p2));
776 	}
777 
778 	function log(string memory p0, string memory p1, string memory p2) internal view {
779 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string)", p0, p1, p2));
780 	}
781 
782 	function log(string memory p0, string memory p1, bool p2) internal view {
783 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool)", p0, p1, p2));
784 	}
785 
786 	function log(string memory p0, string memory p1, address p2) internal view {
787 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address)", p0, p1, p2));
788 	}
789 
790 	function log(string memory p0, bool p1, uint p2) internal view {
791 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint)", p0, p1, p2));
792 	}
793 
794 	function log(string memory p0, bool p1, string memory p2) internal view {
795 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string)", p0, p1, p2));
796 	}
797 
798 	function log(string memory p0, bool p1, bool p2) internal view {
799 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool)", p0, p1, p2));
800 	}
801 
802 	function log(string memory p0, bool p1, address p2) internal view {
803 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address)", p0, p1, p2));
804 	}
805 
806 	function log(string memory p0, address p1, uint p2) internal view {
807 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint)", p0, p1, p2));
808 	}
809 
810 	function log(string memory p0, address p1, string memory p2) internal view {
811 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string)", p0, p1, p2));
812 	}
813 
814 	function log(string memory p0, address p1, bool p2) internal view {
815 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool)", p0, p1, p2));
816 	}
817 
818 	function log(string memory p0, address p1, address p2) internal view {
819 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address)", p0, p1, p2));
820 	}
821 
822 	function log(bool p0, uint p1, uint p2) internal view {
823 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint)", p0, p1, p2));
824 	}
825 
826 	function log(bool p0, uint p1, string memory p2) internal view {
827 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string)", p0, p1, p2));
828 	}
829 
830 	function log(bool p0, uint p1, bool p2) internal view {
831 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool)", p0, p1, p2));
832 	}
833 
834 	function log(bool p0, uint p1, address p2) internal view {
835 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address)", p0, p1, p2));
836 	}
837 
838 	function log(bool p0, string memory p1, uint p2) internal view {
839 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint)", p0, p1, p2));
840 	}
841 
842 	function log(bool p0, string memory p1, string memory p2) internal view {
843 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string)", p0, p1, p2));
844 	}
845 
846 	function log(bool p0, string memory p1, bool p2) internal view {
847 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool)", p0, p1, p2));
848 	}
849 
850 	function log(bool p0, string memory p1, address p2) internal view {
851 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address)", p0, p1, p2));
852 	}
853 
854 	function log(bool p0, bool p1, uint p2) internal view {
855 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint)", p0, p1, p2));
856 	}
857 
858 	function log(bool p0, bool p1, string memory p2) internal view {
859 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string)", p0, p1, p2));
860 	}
861 
862 	function log(bool p0, bool p1, bool p2) internal view {
863 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool)", p0, p1, p2));
864 	}
865 
866 	function log(bool p0, bool p1, address p2) internal view {
867 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address)", p0, p1, p2));
868 	}
869 
870 	function log(bool p0, address p1, uint p2) internal view {
871 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint)", p0, p1, p2));
872 	}
873 
874 	function log(bool p0, address p1, string memory p2) internal view {
875 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string)", p0, p1, p2));
876 	}
877 
878 	function log(bool p0, address p1, bool p2) internal view {
879 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool)", p0, p1, p2));
880 	}
881 
882 	function log(bool p0, address p1, address p2) internal view {
883 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address)", p0, p1, p2));
884 	}
885 
886 	function log(address p0, uint p1, uint p2) internal view {
887 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint)", p0, p1, p2));
888 	}
889 
890 	function log(address p0, uint p1, string memory p2) internal view {
891 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string)", p0, p1, p2));
892 	}
893 
894 	function log(address p0, uint p1, bool p2) internal view {
895 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool)", p0, p1, p2));
896 	}
897 
898 	function log(address p0, uint p1, address p2) internal view {
899 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address)", p0, p1, p2));
900 	}
901 
902 	function log(address p0, string memory p1, uint p2) internal view {
903 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint)", p0, p1, p2));
904 	}
905 
906 	function log(address p0, string memory p1, string memory p2) internal view {
907 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string)", p0, p1, p2));
908 	}
909 
910 	function log(address p0, string memory p1, bool p2) internal view {
911 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool)", p0, p1, p2));
912 	}
913 
914 	function log(address p0, string memory p1, address p2) internal view {
915 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address)", p0, p1, p2));
916 	}
917 
918 	function log(address p0, bool p1, uint p2) internal view {
919 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint)", p0, p1, p2));
920 	}
921 
922 	function log(address p0, bool p1, string memory p2) internal view {
923 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string)", p0, p1, p2));
924 	}
925 
926 	function log(address p0, bool p1, bool p2) internal view {
927 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool)", p0, p1, p2));
928 	}
929 
930 	function log(address p0, bool p1, address p2) internal view {
931 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address)", p0, p1, p2));
932 	}
933 
934 	function log(address p0, address p1, uint p2) internal view {
935 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint)", p0, p1, p2));
936 	}
937 
938 	function log(address p0, address p1, string memory p2) internal view {
939 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string)", p0, p1, p2));
940 	}
941 
942 	function log(address p0, address p1, bool p2) internal view {
943 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool)", p0, p1, p2));
944 	}
945 
946 	function log(address p0, address p1, address p2) internal view {
947 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address)", p0, p1, p2));
948 	}
949 
950 	function log(uint p0, uint p1, uint p2, uint p3) internal view {
951 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,uint)", p0, p1, p2, p3));
952 	}
953 
954 	function log(uint p0, uint p1, uint p2, string memory p3) internal view {
955 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,string)", p0, p1, p2, p3));
956 	}
957 
958 	function log(uint p0, uint p1, uint p2, bool p3) internal view {
959 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,bool)", p0, p1, p2, p3));
960 	}
961 
962 	function log(uint p0, uint p1, uint p2, address p3) internal view {
963 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,address)", p0, p1, p2, p3));
964 	}
965 
966 	function log(uint p0, uint p1, string memory p2, uint p3) internal view {
967 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,uint)", p0, p1, p2, p3));
968 	}
969 
970 	function log(uint p0, uint p1, string memory p2, string memory p3) internal view {
971 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,string)", p0, p1, p2, p3));
972 	}
973 
974 	function log(uint p0, uint p1, string memory p2, bool p3) internal view {
975 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,bool)", p0, p1, p2, p3));
976 	}
977 
978 	function log(uint p0, uint p1, string memory p2, address p3) internal view {
979 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,address)", p0, p1, p2, p3));
980 	}
981 
982 	function log(uint p0, uint p1, bool p2, uint p3) internal view {
983 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,uint)", p0, p1, p2, p3));
984 	}
985 
986 	function log(uint p0, uint p1, bool p2, string memory p3) internal view {
987 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,string)", p0, p1, p2, p3));
988 	}
989 
990 	function log(uint p0, uint p1, bool p2, bool p3) internal view {
991 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,bool)", p0, p1, p2, p3));
992 	}
993 
994 	function log(uint p0, uint p1, bool p2, address p3) internal view {
995 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,address)", p0, p1, p2, p3));
996 	}
997 
998 	function log(uint p0, uint p1, address p2, uint p3) internal view {
999 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,uint)", p0, p1, p2, p3));
1000 	}
1001 
1002 	function log(uint p0, uint p1, address p2, string memory p3) internal view {
1003 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,string)", p0, p1, p2, p3));
1004 	}
1005 
1006 	function log(uint p0, uint p1, address p2, bool p3) internal view {
1007 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,bool)", p0, p1, p2, p3));
1008 	}
1009 
1010 	function log(uint p0, uint p1, address p2, address p3) internal view {
1011 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,address)", p0, p1, p2, p3));
1012 	}
1013 
1014 	function log(uint p0, string memory p1, uint p2, uint p3) internal view {
1015 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,uint)", p0, p1, p2, p3));
1016 	}
1017 
1018 	function log(uint p0, string memory p1, uint p2, string memory p3) internal view {
1019 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,string)", p0, p1, p2, p3));
1020 	}
1021 
1022 	function log(uint p0, string memory p1, uint p2, bool p3) internal view {
1023 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,bool)", p0, p1, p2, p3));
1024 	}
1025 
1026 	function log(uint p0, string memory p1, uint p2, address p3) internal view {
1027 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,address)", p0, p1, p2, p3));
1028 	}
1029 
1030 	function log(uint p0, string memory p1, string memory p2, uint p3) internal view {
1031 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,uint)", p0, p1, p2, p3));
1032 	}
1033 
1034 	function log(uint p0, string memory p1, string memory p2, string memory p3) internal view {
1035 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,string)", p0, p1, p2, p3));
1036 	}
1037 
1038 	function log(uint p0, string memory p1, string memory p2, bool p3) internal view {
1039 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,bool)", p0, p1, p2, p3));
1040 	}
1041 
1042 	function log(uint p0, string memory p1, string memory p2, address p3) internal view {
1043 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,address)", p0, p1, p2, p3));
1044 	}
1045 
1046 	function log(uint p0, string memory p1, bool p2, uint p3) internal view {
1047 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,uint)", p0, p1, p2, p3));
1048 	}
1049 
1050 	function log(uint p0, string memory p1, bool p2, string memory p3) internal view {
1051 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,string)", p0, p1, p2, p3));
1052 	}
1053 
1054 	function log(uint p0, string memory p1, bool p2, bool p3) internal view {
1055 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,bool)", p0, p1, p2, p3));
1056 	}
1057 
1058 	function log(uint p0, string memory p1, bool p2, address p3) internal view {
1059 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,address)", p0, p1, p2, p3));
1060 	}
1061 
1062 	function log(uint p0, string memory p1, address p2, uint p3) internal view {
1063 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,uint)", p0, p1, p2, p3));
1064 	}
1065 
1066 	function log(uint p0, string memory p1, address p2, string memory p3) internal view {
1067 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,string)", p0, p1, p2, p3));
1068 	}
1069 
1070 	function log(uint p0, string memory p1, address p2, bool p3) internal view {
1071 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,bool)", p0, p1, p2, p3));
1072 	}
1073 
1074 	function log(uint p0, string memory p1, address p2, address p3) internal view {
1075 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,address)", p0, p1, p2, p3));
1076 	}
1077 
1078 	function log(uint p0, bool p1, uint p2, uint p3) internal view {
1079 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,uint)", p0, p1, p2, p3));
1080 	}
1081 
1082 	function log(uint p0, bool p1, uint p2, string memory p3) internal view {
1083 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,string)", p0, p1, p2, p3));
1084 	}
1085 
1086 	function log(uint p0, bool p1, uint p2, bool p3) internal view {
1087 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,bool)", p0, p1, p2, p3));
1088 	}
1089 
1090 	function log(uint p0, bool p1, uint p2, address p3) internal view {
1091 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,address)", p0, p1, p2, p3));
1092 	}
1093 
1094 	function log(uint p0, bool p1, string memory p2, uint p3) internal view {
1095 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,uint)", p0, p1, p2, p3));
1096 	}
1097 
1098 	function log(uint p0, bool p1, string memory p2, string memory p3) internal view {
1099 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,string)", p0, p1, p2, p3));
1100 	}
1101 
1102 	function log(uint p0, bool p1, string memory p2, bool p3) internal view {
1103 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,bool)", p0, p1, p2, p3));
1104 	}
1105 
1106 	function log(uint p0, bool p1, string memory p2, address p3) internal view {
1107 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,address)", p0, p1, p2, p3));
1108 	}
1109 
1110 	function log(uint p0, bool p1, bool p2, uint p3) internal view {
1111 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,uint)", p0, p1, p2, p3));
1112 	}
1113 
1114 	function log(uint p0, bool p1, bool p2, string memory p3) internal view {
1115 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,string)", p0, p1, p2, p3));
1116 	}
1117 
1118 	function log(uint p0, bool p1, bool p2, bool p3) internal view {
1119 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,bool)", p0, p1, p2, p3));
1120 	}
1121 
1122 	function log(uint p0, bool p1, bool p2, address p3) internal view {
1123 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,address)", p0, p1, p2, p3));
1124 	}
1125 
1126 	function log(uint p0, bool p1, address p2, uint p3) internal view {
1127 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,uint)", p0, p1, p2, p3));
1128 	}
1129 
1130 	function log(uint p0, bool p1, address p2, string memory p3) internal view {
1131 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,string)", p0, p1, p2, p3));
1132 	}
1133 
1134 	function log(uint p0, bool p1, address p2, bool p3) internal view {
1135 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,bool)", p0, p1, p2, p3));
1136 	}
1137 
1138 	function log(uint p0, bool p1, address p2, address p3) internal view {
1139 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,address)", p0, p1, p2, p3));
1140 	}
1141 
1142 	function log(uint p0, address p1, uint p2, uint p3) internal view {
1143 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,uint)", p0, p1, p2, p3));
1144 	}
1145 
1146 	function log(uint p0, address p1, uint p2, string memory p3) internal view {
1147 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,string)", p0, p1, p2, p3));
1148 	}
1149 
1150 	function log(uint p0, address p1, uint p2, bool p3) internal view {
1151 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,bool)", p0, p1, p2, p3));
1152 	}
1153 
1154 	function log(uint p0, address p1, uint p2, address p3) internal view {
1155 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,address)", p0, p1, p2, p3));
1156 	}
1157 
1158 	function log(uint p0, address p1, string memory p2, uint p3) internal view {
1159 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,uint)", p0, p1, p2, p3));
1160 	}
1161 
1162 	function log(uint p0, address p1, string memory p2, string memory p3) internal view {
1163 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,string)", p0, p1, p2, p3));
1164 	}
1165 
1166 	function log(uint p0, address p1, string memory p2, bool p3) internal view {
1167 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,bool)", p0, p1, p2, p3));
1168 	}
1169 
1170 	function log(uint p0, address p1, string memory p2, address p3) internal view {
1171 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,address)", p0, p1, p2, p3));
1172 	}
1173 
1174 	function log(uint p0, address p1, bool p2, uint p3) internal view {
1175 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,uint)", p0, p1, p2, p3));
1176 	}
1177 
1178 	function log(uint p0, address p1, bool p2, string memory p3) internal view {
1179 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,string)", p0, p1, p2, p3));
1180 	}
1181 
1182 	function log(uint p0, address p1, bool p2, bool p3) internal view {
1183 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,bool)", p0, p1, p2, p3));
1184 	}
1185 
1186 	function log(uint p0, address p1, bool p2, address p3) internal view {
1187 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,address)", p0, p1, p2, p3));
1188 	}
1189 
1190 	function log(uint p0, address p1, address p2, uint p3) internal view {
1191 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,uint)", p0, p1, p2, p3));
1192 	}
1193 
1194 	function log(uint p0, address p1, address p2, string memory p3) internal view {
1195 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,string)", p0, p1, p2, p3));
1196 	}
1197 
1198 	function log(uint p0, address p1, address p2, bool p3) internal view {
1199 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,bool)", p0, p1, p2, p3));
1200 	}
1201 
1202 	function log(uint p0, address p1, address p2, address p3) internal view {
1203 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,address)", p0, p1, p2, p3));
1204 	}
1205 
1206 	function log(string memory p0, uint p1, uint p2, uint p3) internal view {
1207 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,uint)", p0, p1, p2, p3));
1208 	}
1209 
1210 	function log(string memory p0, uint p1, uint p2, string memory p3) internal view {
1211 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,string)", p0, p1, p2, p3));
1212 	}
1213 
1214 	function log(string memory p0, uint p1, uint p2, bool p3) internal view {
1215 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,bool)", p0, p1, p2, p3));
1216 	}
1217 
1218 	function log(string memory p0, uint p1, uint p2, address p3) internal view {
1219 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,address)", p0, p1, p2, p3));
1220 	}
1221 
1222 	function log(string memory p0, uint p1, string memory p2, uint p3) internal view {
1223 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,uint)", p0, p1, p2, p3));
1224 	}
1225 
1226 	function log(string memory p0, uint p1, string memory p2, string memory p3) internal view {
1227 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,string)", p0, p1, p2, p3));
1228 	}
1229 
1230 	function log(string memory p0, uint p1, string memory p2, bool p3) internal view {
1231 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,bool)", p0, p1, p2, p3));
1232 	}
1233 
1234 	function log(string memory p0, uint p1, string memory p2, address p3) internal view {
1235 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,address)", p0, p1, p2, p3));
1236 	}
1237 
1238 	function log(string memory p0, uint p1, bool p2, uint p3) internal view {
1239 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,uint)", p0, p1, p2, p3));
1240 	}
1241 
1242 	function log(string memory p0, uint p1, bool p2, string memory p3) internal view {
1243 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,string)", p0, p1, p2, p3));
1244 	}
1245 
1246 	function log(string memory p0, uint p1, bool p2, bool p3) internal view {
1247 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,bool)", p0, p1, p2, p3));
1248 	}
1249 
1250 	function log(string memory p0, uint p1, bool p2, address p3) internal view {
1251 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,address)", p0, p1, p2, p3));
1252 	}
1253 
1254 	function log(string memory p0, uint p1, address p2, uint p3) internal view {
1255 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,uint)", p0, p1, p2, p3));
1256 	}
1257 
1258 	function log(string memory p0, uint p1, address p2, string memory p3) internal view {
1259 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,string)", p0, p1, p2, p3));
1260 	}
1261 
1262 	function log(string memory p0, uint p1, address p2, bool p3) internal view {
1263 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,bool)", p0, p1, p2, p3));
1264 	}
1265 
1266 	function log(string memory p0, uint p1, address p2, address p3) internal view {
1267 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,address)", p0, p1, p2, p3));
1268 	}
1269 
1270 	function log(string memory p0, string memory p1, uint p2, uint p3) internal view {
1271 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,uint)", p0, p1, p2, p3));
1272 	}
1273 
1274 	function log(string memory p0, string memory p1, uint p2, string memory p3) internal view {
1275 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,string)", p0, p1, p2, p3));
1276 	}
1277 
1278 	function log(string memory p0, string memory p1, uint p2, bool p3) internal view {
1279 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,bool)", p0, p1, p2, p3));
1280 	}
1281 
1282 	function log(string memory p0, string memory p1, uint p2, address p3) internal view {
1283 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,address)", p0, p1, p2, p3));
1284 	}
1285 
1286 	function log(string memory p0, string memory p1, string memory p2, uint p3) internal view {
1287 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,uint)", p0, p1, p2, p3));
1288 	}
1289 
1290 	function log(string memory p0, string memory p1, string memory p2, string memory p3) internal view {
1291 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,string)", p0, p1, p2, p3));
1292 	}
1293 
1294 	function log(string memory p0, string memory p1, string memory p2, bool p3) internal view {
1295 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,bool)", p0, p1, p2, p3));
1296 	}
1297 
1298 	function log(string memory p0, string memory p1, string memory p2, address p3) internal view {
1299 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,address)", p0, p1, p2, p3));
1300 	}
1301 
1302 	function log(string memory p0, string memory p1, bool p2, uint p3) internal view {
1303 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,uint)", p0, p1, p2, p3));
1304 	}
1305 
1306 	function log(string memory p0, string memory p1, bool p2, string memory p3) internal view {
1307 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,string)", p0, p1, p2, p3));
1308 	}
1309 
1310 	function log(string memory p0, string memory p1, bool p2, bool p3) internal view {
1311 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,bool)", p0, p1, p2, p3));
1312 	}
1313 
1314 	function log(string memory p0, string memory p1, bool p2, address p3) internal view {
1315 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,address)", p0, p1, p2, p3));
1316 	}
1317 
1318 	function log(string memory p0, string memory p1, address p2, uint p3) internal view {
1319 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,uint)", p0, p1, p2, p3));
1320 	}
1321 
1322 	function log(string memory p0, string memory p1, address p2, string memory p3) internal view {
1323 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,string)", p0, p1, p2, p3));
1324 	}
1325 
1326 	function log(string memory p0, string memory p1, address p2, bool p3) internal view {
1327 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,bool)", p0, p1, p2, p3));
1328 	}
1329 
1330 	function log(string memory p0, string memory p1, address p2, address p3) internal view {
1331 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,address)", p0, p1, p2, p3));
1332 	}
1333 
1334 	function log(string memory p0, bool p1, uint p2, uint p3) internal view {
1335 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,uint)", p0, p1, p2, p3));
1336 	}
1337 
1338 	function log(string memory p0, bool p1, uint p2, string memory p3) internal view {
1339 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,string)", p0, p1, p2, p3));
1340 	}
1341 
1342 	function log(string memory p0, bool p1, uint p2, bool p3) internal view {
1343 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,bool)", p0, p1, p2, p3));
1344 	}
1345 
1346 	function log(string memory p0, bool p1, uint p2, address p3) internal view {
1347 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,address)", p0, p1, p2, p3));
1348 	}
1349 
1350 	function log(string memory p0, bool p1, string memory p2, uint p3) internal view {
1351 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,uint)", p0, p1, p2, p3));
1352 	}
1353 
1354 	function log(string memory p0, bool p1, string memory p2, string memory p3) internal view {
1355 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,string)", p0, p1, p2, p3));
1356 	}
1357 
1358 	function log(string memory p0, bool p1, string memory p2, bool p3) internal view {
1359 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,bool)", p0, p1, p2, p3));
1360 	}
1361 
1362 	function log(string memory p0, bool p1, string memory p2, address p3) internal view {
1363 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,address)", p0, p1, p2, p3));
1364 	}
1365 
1366 	function log(string memory p0, bool p1, bool p2, uint p3) internal view {
1367 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,uint)", p0, p1, p2, p3));
1368 	}
1369 
1370 	function log(string memory p0, bool p1, bool p2, string memory p3) internal view {
1371 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,string)", p0, p1, p2, p3));
1372 	}
1373 
1374 	function log(string memory p0, bool p1, bool p2, bool p3) internal view {
1375 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,bool)", p0, p1, p2, p3));
1376 	}
1377 
1378 	function log(string memory p0, bool p1, bool p2, address p3) internal view {
1379 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,address)", p0, p1, p2, p3));
1380 	}
1381 
1382 	function log(string memory p0, bool p1, address p2, uint p3) internal view {
1383 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,uint)", p0, p1, p2, p3));
1384 	}
1385 
1386 	function log(string memory p0, bool p1, address p2, string memory p3) internal view {
1387 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,string)", p0, p1, p2, p3));
1388 	}
1389 
1390 	function log(string memory p0, bool p1, address p2, bool p3) internal view {
1391 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,bool)", p0, p1, p2, p3));
1392 	}
1393 
1394 	function log(string memory p0, bool p1, address p2, address p3) internal view {
1395 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,address)", p0, p1, p2, p3));
1396 	}
1397 
1398 	function log(string memory p0, address p1, uint p2, uint p3) internal view {
1399 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,uint)", p0, p1, p2, p3));
1400 	}
1401 
1402 	function log(string memory p0, address p1, uint p2, string memory p3) internal view {
1403 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,string)", p0, p1, p2, p3));
1404 	}
1405 
1406 	function log(string memory p0, address p1, uint p2, bool p3) internal view {
1407 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,bool)", p0, p1, p2, p3));
1408 	}
1409 
1410 	function log(string memory p0, address p1, uint p2, address p3) internal view {
1411 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,address)", p0, p1, p2, p3));
1412 	}
1413 
1414 	function log(string memory p0, address p1, string memory p2, uint p3) internal view {
1415 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,uint)", p0, p1, p2, p3));
1416 	}
1417 
1418 	function log(string memory p0, address p1, string memory p2, string memory p3) internal view {
1419 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,string)", p0, p1, p2, p3));
1420 	}
1421 
1422 	function log(string memory p0, address p1, string memory p2, bool p3) internal view {
1423 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,bool)", p0, p1, p2, p3));
1424 	}
1425 
1426 	function log(string memory p0, address p1, string memory p2, address p3) internal view {
1427 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,address)", p0, p1, p2, p3));
1428 	}
1429 
1430 	function log(string memory p0, address p1, bool p2, uint p3) internal view {
1431 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,uint)", p0, p1, p2, p3));
1432 	}
1433 
1434 	function log(string memory p0, address p1, bool p2, string memory p3) internal view {
1435 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,string)", p0, p1, p2, p3));
1436 	}
1437 
1438 	function log(string memory p0, address p1, bool p2, bool p3) internal view {
1439 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,bool)", p0, p1, p2, p3));
1440 	}
1441 
1442 	function log(string memory p0, address p1, bool p2, address p3) internal view {
1443 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,address)", p0, p1, p2, p3));
1444 	}
1445 
1446 	function log(string memory p0, address p1, address p2, uint p3) internal view {
1447 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,uint)", p0, p1, p2, p3));
1448 	}
1449 
1450 	function log(string memory p0, address p1, address p2, string memory p3) internal view {
1451 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,string)", p0, p1, p2, p3));
1452 	}
1453 
1454 	function log(string memory p0, address p1, address p2, bool p3) internal view {
1455 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,bool)", p0, p1, p2, p3));
1456 	}
1457 
1458 	function log(string memory p0, address p1, address p2, address p3) internal view {
1459 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,address)", p0, p1, p2, p3));
1460 	}
1461 
1462 	function log(bool p0, uint p1, uint p2, uint p3) internal view {
1463 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,uint)", p0, p1, p2, p3));
1464 	}
1465 
1466 	function log(bool p0, uint p1, uint p2, string memory p3) internal view {
1467 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,string)", p0, p1, p2, p3));
1468 	}
1469 
1470 	function log(bool p0, uint p1, uint p2, bool p3) internal view {
1471 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,bool)", p0, p1, p2, p3));
1472 	}
1473 
1474 	function log(bool p0, uint p1, uint p2, address p3) internal view {
1475 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,address)", p0, p1, p2, p3));
1476 	}
1477 
1478 	function log(bool p0, uint p1, string memory p2, uint p3) internal view {
1479 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,uint)", p0, p1, p2, p3));
1480 	}
1481 
1482 	function log(bool p0, uint p1, string memory p2, string memory p3) internal view {
1483 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,string)", p0, p1, p2, p3));
1484 	}
1485 
1486 	function log(bool p0, uint p1, string memory p2, bool p3) internal view {
1487 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,bool)", p0, p1, p2, p3));
1488 	}
1489 
1490 	function log(bool p0, uint p1, string memory p2, address p3) internal view {
1491 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,address)", p0, p1, p2, p3));
1492 	}
1493 
1494 	function log(bool p0, uint p1, bool p2, uint p3) internal view {
1495 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,uint)", p0, p1, p2, p3));
1496 	}
1497 
1498 	function log(bool p0, uint p1, bool p2, string memory p3) internal view {
1499 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,string)", p0, p1, p2, p3));
1500 	}
1501 
1502 	function log(bool p0, uint p1, bool p2, bool p3) internal view {
1503 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,bool)", p0, p1, p2, p3));
1504 	}
1505 
1506 	function log(bool p0, uint p1, bool p2, address p3) internal view {
1507 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,address)", p0, p1, p2, p3));
1508 	}
1509 
1510 	function log(bool p0, uint p1, address p2, uint p3) internal view {
1511 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,uint)", p0, p1, p2, p3));
1512 	}
1513 
1514 	function log(bool p0, uint p1, address p2, string memory p3) internal view {
1515 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,string)", p0, p1, p2, p3));
1516 	}
1517 
1518 	function log(bool p0, uint p1, address p2, bool p3) internal view {
1519 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,bool)", p0, p1, p2, p3));
1520 	}
1521 
1522 	function log(bool p0, uint p1, address p2, address p3) internal view {
1523 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,address)", p0, p1, p2, p3));
1524 	}
1525 
1526 	function log(bool p0, string memory p1, uint p2, uint p3) internal view {
1527 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,uint)", p0, p1, p2, p3));
1528 	}
1529 
1530 	function log(bool p0, string memory p1, uint p2, string memory p3) internal view {
1531 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,string)", p0, p1, p2, p3));
1532 	}
1533 
1534 	function log(bool p0, string memory p1, uint p2, bool p3) internal view {
1535 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,bool)", p0, p1, p2, p3));
1536 	}
1537 
1538 	function log(bool p0, string memory p1, uint p2, address p3) internal view {
1539 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,address)", p0, p1, p2, p3));
1540 	}
1541 
1542 	function log(bool p0, string memory p1, string memory p2, uint p3) internal view {
1543 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,uint)", p0, p1, p2, p3));
1544 	}
1545 
1546 	function log(bool p0, string memory p1, string memory p2, string memory p3) internal view {
1547 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,string)", p0, p1, p2, p3));
1548 	}
1549 
1550 	function log(bool p0, string memory p1, string memory p2, bool p3) internal view {
1551 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,bool)", p0, p1, p2, p3));
1552 	}
1553 
1554 	function log(bool p0, string memory p1, string memory p2, address p3) internal view {
1555 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,address)", p0, p1, p2, p3));
1556 	}
1557 
1558 	function log(bool p0, string memory p1, bool p2, uint p3) internal view {
1559 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,uint)", p0, p1, p2, p3));
1560 	}
1561 
1562 	function log(bool p0, string memory p1, bool p2, string memory p3) internal view {
1563 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,string)", p0, p1, p2, p3));
1564 	}
1565 
1566 	function log(bool p0, string memory p1, bool p2, bool p3) internal view {
1567 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,bool)", p0, p1, p2, p3));
1568 	}
1569 
1570 	function log(bool p0, string memory p1, bool p2, address p3) internal view {
1571 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,address)", p0, p1, p2, p3));
1572 	}
1573 
1574 	function log(bool p0, string memory p1, address p2, uint p3) internal view {
1575 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,uint)", p0, p1, p2, p3));
1576 	}
1577 
1578 	function log(bool p0, string memory p1, address p2, string memory p3) internal view {
1579 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,string)", p0, p1, p2, p3));
1580 	}
1581 
1582 	function log(bool p0, string memory p1, address p2, bool p3) internal view {
1583 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,bool)", p0, p1, p2, p3));
1584 	}
1585 
1586 	function log(bool p0, string memory p1, address p2, address p3) internal view {
1587 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,address)", p0, p1, p2, p3));
1588 	}
1589 
1590 	function log(bool p0, bool p1, uint p2, uint p3) internal view {
1591 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,uint)", p0, p1, p2, p3));
1592 	}
1593 
1594 	function log(bool p0, bool p1, uint p2, string memory p3) internal view {
1595 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,string)", p0, p1, p2, p3));
1596 	}
1597 
1598 	function log(bool p0, bool p1, uint p2, bool p3) internal view {
1599 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,bool)", p0, p1, p2, p3));
1600 	}
1601 
1602 	function log(bool p0, bool p1, uint p2, address p3) internal view {
1603 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,address)", p0, p1, p2, p3));
1604 	}
1605 
1606 	function log(bool p0, bool p1, string memory p2, uint p3) internal view {
1607 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,uint)", p0, p1, p2, p3));
1608 	}
1609 
1610 	function log(bool p0, bool p1, string memory p2, string memory p3) internal view {
1611 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,string)", p0, p1, p2, p3));
1612 	}
1613 
1614 	function log(bool p0, bool p1, string memory p2, bool p3) internal view {
1615 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,bool)", p0, p1, p2, p3));
1616 	}
1617 
1618 	function log(bool p0, bool p1, string memory p2, address p3) internal view {
1619 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,address)", p0, p1, p2, p3));
1620 	}
1621 
1622 	function log(bool p0, bool p1, bool p2, uint p3) internal view {
1623 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,uint)", p0, p1, p2, p3));
1624 	}
1625 
1626 	function log(bool p0, bool p1, bool p2, string memory p3) internal view {
1627 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,string)", p0, p1, p2, p3));
1628 	}
1629 
1630 	function log(bool p0, bool p1, bool p2, bool p3) internal view {
1631 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,bool)", p0, p1, p2, p3));
1632 	}
1633 
1634 	function log(bool p0, bool p1, bool p2, address p3) internal view {
1635 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,address)", p0, p1, p2, p3));
1636 	}
1637 
1638 	function log(bool p0, bool p1, address p2, uint p3) internal view {
1639 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,uint)", p0, p1, p2, p3));
1640 	}
1641 
1642 	function log(bool p0, bool p1, address p2, string memory p3) internal view {
1643 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,string)", p0, p1, p2, p3));
1644 	}
1645 
1646 	function log(bool p0, bool p1, address p2, bool p3) internal view {
1647 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,bool)", p0, p1, p2, p3));
1648 	}
1649 
1650 	function log(bool p0, bool p1, address p2, address p3) internal view {
1651 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,address)", p0, p1, p2, p3));
1652 	}
1653 
1654 	function log(bool p0, address p1, uint p2, uint p3) internal view {
1655 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,uint)", p0, p1, p2, p3));
1656 	}
1657 
1658 	function log(bool p0, address p1, uint p2, string memory p3) internal view {
1659 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,string)", p0, p1, p2, p3));
1660 	}
1661 
1662 	function log(bool p0, address p1, uint p2, bool p3) internal view {
1663 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,bool)", p0, p1, p2, p3));
1664 	}
1665 
1666 	function log(bool p0, address p1, uint p2, address p3) internal view {
1667 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,address)", p0, p1, p2, p3));
1668 	}
1669 
1670 	function log(bool p0, address p1, string memory p2, uint p3) internal view {
1671 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,uint)", p0, p1, p2, p3));
1672 	}
1673 
1674 	function log(bool p0, address p1, string memory p2, string memory p3) internal view {
1675 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,string)", p0, p1, p2, p3));
1676 	}
1677 
1678 	function log(bool p0, address p1, string memory p2, bool p3) internal view {
1679 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,bool)", p0, p1, p2, p3));
1680 	}
1681 
1682 	function log(bool p0, address p1, string memory p2, address p3) internal view {
1683 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,address)", p0, p1, p2, p3));
1684 	}
1685 
1686 	function log(bool p0, address p1, bool p2, uint p3) internal view {
1687 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,uint)", p0, p1, p2, p3));
1688 	}
1689 
1690 	function log(bool p0, address p1, bool p2, string memory p3) internal view {
1691 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,string)", p0, p1, p2, p3));
1692 	}
1693 
1694 	function log(bool p0, address p1, bool p2, bool p3) internal view {
1695 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,bool)", p0, p1, p2, p3));
1696 	}
1697 
1698 	function log(bool p0, address p1, bool p2, address p3) internal view {
1699 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,address)", p0, p1, p2, p3));
1700 	}
1701 
1702 	function log(bool p0, address p1, address p2, uint p3) internal view {
1703 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,uint)", p0, p1, p2, p3));
1704 	}
1705 
1706 	function log(bool p0, address p1, address p2, string memory p3) internal view {
1707 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,string)", p0, p1, p2, p3));
1708 	}
1709 
1710 	function log(bool p0, address p1, address p2, bool p3) internal view {
1711 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,bool)", p0, p1, p2, p3));
1712 	}
1713 
1714 	function log(bool p0, address p1, address p2, address p3) internal view {
1715 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,address)", p0, p1, p2, p3));
1716 	}
1717 
1718 	function log(address p0, uint p1, uint p2, uint p3) internal view {
1719 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,uint)", p0, p1, p2, p3));
1720 	}
1721 
1722 	function log(address p0, uint p1, uint p2, string memory p3) internal view {
1723 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,string)", p0, p1, p2, p3));
1724 	}
1725 
1726 	function log(address p0, uint p1, uint p2, bool p3) internal view {
1727 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,bool)", p0, p1, p2, p3));
1728 	}
1729 
1730 	function log(address p0, uint p1, uint p2, address p3) internal view {
1731 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,address)", p0, p1, p2, p3));
1732 	}
1733 
1734 	function log(address p0, uint p1, string memory p2, uint p3) internal view {
1735 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,uint)", p0, p1, p2, p3));
1736 	}
1737 
1738 	function log(address p0, uint p1, string memory p2, string memory p3) internal view {
1739 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,string)", p0, p1, p2, p3));
1740 	}
1741 
1742 	function log(address p0, uint p1, string memory p2, bool p3) internal view {
1743 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,bool)", p0, p1, p2, p3));
1744 	}
1745 
1746 	function log(address p0, uint p1, string memory p2, address p3) internal view {
1747 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,address)", p0, p1, p2, p3));
1748 	}
1749 
1750 	function log(address p0, uint p1, bool p2, uint p3) internal view {
1751 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,uint)", p0, p1, p2, p3));
1752 	}
1753 
1754 	function log(address p0, uint p1, bool p2, string memory p3) internal view {
1755 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,string)", p0, p1, p2, p3));
1756 	}
1757 
1758 	function log(address p0, uint p1, bool p2, bool p3) internal view {
1759 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,bool)", p0, p1, p2, p3));
1760 	}
1761 
1762 	function log(address p0, uint p1, bool p2, address p3) internal view {
1763 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,address)", p0, p1, p2, p3));
1764 	}
1765 
1766 	function log(address p0, uint p1, address p2, uint p3) internal view {
1767 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,uint)", p0, p1, p2, p3));
1768 	}
1769 
1770 	function log(address p0, uint p1, address p2, string memory p3) internal view {
1771 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,string)", p0, p1, p2, p3));
1772 	}
1773 
1774 	function log(address p0, uint p1, address p2, bool p3) internal view {
1775 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,bool)", p0, p1, p2, p3));
1776 	}
1777 
1778 	function log(address p0, uint p1, address p2, address p3) internal view {
1779 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,address)", p0, p1, p2, p3));
1780 	}
1781 
1782 	function log(address p0, string memory p1, uint p2, uint p3) internal view {
1783 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,uint)", p0, p1, p2, p3));
1784 	}
1785 
1786 	function log(address p0, string memory p1, uint p2, string memory p3) internal view {
1787 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,string)", p0, p1, p2, p3));
1788 	}
1789 
1790 	function log(address p0, string memory p1, uint p2, bool p3) internal view {
1791 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,bool)", p0, p1, p2, p3));
1792 	}
1793 
1794 	function log(address p0, string memory p1, uint p2, address p3) internal view {
1795 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,address)", p0, p1, p2, p3));
1796 	}
1797 
1798 	function log(address p0, string memory p1, string memory p2, uint p3) internal view {
1799 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,uint)", p0, p1, p2, p3));
1800 	}
1801 
1802 	function log(address p0, string memory p1, string memory p2, string memory p3) internal view {
1803 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,string)", p0, p1, p2, p3));
1804 	}
1805 
1806 	function log(address p0, string memory p1, string memory p2, bool p3) internal view {
1807 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,bool)", p0, p1, p2, p3));
1808 	}
1809 
1810 	function log(address p0, string memory p1, string memory p2, address p3) internal view {
1811 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,address)", p0, p1, p2, p3));
1812 	}
1813 
1814 	function log(address p0, string memory p1, bool p2, uint p3) internal view {
1815 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,uint)", p0, p1, p2, p3));
1816 	}
1817 
1818 	function log(address p0, string memory p1, bool p2, string memory p3) internal view {
1819 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,string)", p0, p1, p2, p3));
1820 	}
1821 
1822 	function log(address p0, string memory p1, bool p2, bool p3) internal view {
1823 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,bool)", p0, p1, p2, p3));
1824 	}
1825 
1826 	function log(address p0, string memory p1, bool p2, address p3) internal view {
1827 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,address)", p0, p1, p2, p3));
1828 	}
1829 
1830 	function log(address p0, string memory p1, address p2, uint p3) internal view {
1831 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,uint)", p0, p1, p2, p3));
1832 	}
1833 
1834 	function log(address p0, string memory p1, address p2, string memory p3) internal view {
1835 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,string)", p0, p1, p2, p3));
1836 	}
1837 
1838 	function log(address p0, string memory p1, address p2, bool p3) internal view {
1839 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,bool)", p0, p1, p2, p3));
1840 	}
1841 
1842 	function log(address p0, string memory p1, address p2, address p3) internal view {
1843 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,address)", p0, p1, p2, p3));
1844 	}
1845 
1846 	function log(address p0, bool p1, uint p2, uint p3) internal view {
1847 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,uint)", p0, p1, p2, p3));
1848 	}
1849 
1850 	function log(address p0, bool p1, uint p2, string memory p3) internal view {
1851 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,string)", p0, p1, p2, p3));
1852 	}
1853 
1854 	function log(address p0, bool p1, uint p2, bool p3) internal view {
1855 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,bool)", p0, p1, p2, p3));
1856 	}
1857 
1858 	function log(address p0, bool p1, uint p2, address p3) internal view {
1859 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,address)", p0, p1, p2, p3));
1860 	}
1861 
1862 	function log(address p0, bool p1, string memory p2, uint p3) internal view {
1863 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,uint)", p0, p1, p2, p3));
1864 	}
1865 
1866 	function log(address p0, bool p1, string memory p2, string memory p3) internal view {
1867 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,string)", p0, p1, p2, p3));
1868 	}
1869 
1870 	function log(address p0, bool p1, string memory p2, bool p3) internal view {
1871 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,bool)", p0, p1, p2, p3));
1872 	}
1873 
1874 	function log(address p0, bool p1, string memory p2, address p3) internal view {
1875 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,address)", p0, p1, p2, p3));
1876 	}
1877 
1878 	function log(address p0, bool p1, bool p2, uint p3) internal view {
1879 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,uint)", p0, p1, p2, p3));
1880 	}
1881 
1882 	function log(address p0, bool p1, bool p2, string memory p3) internal view {
1883 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,string)", p0, p1, p2, p3));
1884 	}
1885 
1886 	function log(address p0, bool p1, bool p2, bool p3) internal view {
1887 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,bool)", p0, p1, p2, p3));
1888 	}
1889 
1890 	function log(address p0, bool p1, bool p2, address p3) internal view {
1891 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,address)", p0, p1, p2, p3));
1892 	}
1893 
1894 	function log(address p0, bool p1, address p2, uint p3) internal view {
1895 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,uint)", p0, p1, p2, p3));
1896 	}
1897 
1898 	function log(address p0, bool p1, address p2, string memory p3) internal view {
1899 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,string)", p0, p1, p2, p3));
1900 	}
1901 
1902 	function log(address p0, bool p1, address p2, bool p3) internal view {
1903 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,bool)", p0, p1, p2, p3));
1904 	}
1905 
1906 	function log(address p0, bool p1, address p2, address p3) internal view {
1907 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,address)", p0, p1, p2, p3));
1908 	}
1909 
1910 	function log(address p0, address p1, uint p2, uint p3) internal view {
1911 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,uint)", p0, p1, p2, p3));
1912 	}
1913 
1914 	function log(address p0, address p1, uint p2, string memory p3) internal view {
1915 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,string)", p0, p1, p2, p3));
1916 	}
1917 
1918 	function log(address p0, address p1, uint p2, bool p3) internal view {
1919 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,bool)", p0, p1, p2, p3));
1920 	}
1921 
1922 	function log(address p0, address p1, uint p2, address p3) internal view {
1923 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,address)", p0, p1, p2, p3));
1924 	}
1925 
1926 	function log(address p0, address p1, string memory p2, uint p3) internal view {
1927 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,uint)", p0, p1, p2, p3));
1928 	}
1929 
1930 	function log(address p0, address p1, string memory p2, string memory p3) internal view {
1931 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,string)", p0, p1, p2, p3));
1932 	}
1933 
1934 	function log(address p0, address p1, string memory p2, bool p3) internal view {
1935 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,bool)", p0, p1, p2, p3));
1936 	}
1937 
1938 	function log(address p0, address p1, string memory p2, address p3) internal view {
1939 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,address)", p0, p1, p2, p3));
1940 	}
1941 
1942 	function log(address p0, address p1, bool p2, uint p3) internal view {
1943 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,uint)", p0, p1, p2, p3));
1944 	}
1945 
1946 	function log(address p0, address p1, bool p2, string memory p3) internal view {
1947 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,string)", p0, p1, p2, p3));
1948 	}
1949 
1950 	function log(address p0, address p1, bool p2, bool p3) internal view {
1951 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,bool)", p0, p1, p2, p3));
1952 	}
1953 
1954 	function log(address p0, address p1, bool p2, address p3) internal view {
1955 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,address)", p0, p1, p2, p3));
1956 	}
1957 
1958 	function log(address p0, address p1, address p2, uint p3) internal view {
1959 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,uint)", p0, p1, p2, p3));
1960 	}
1961 
1962 	function log(address p0, address p1, address p2, string memory p3) internal view {
1963 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,string)", p0, p1, p2, p3));
1964 	}
1965 
1966 	function log(address p0, address p1, address p2, bool p3) internal view {
1967 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,bool)", p0, p1, p2, p3));
1968 	}
1969 
1970 	function log(address p0, address p1, address p2, address p3) internal view {
1971 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,address)", p0, p1, p2, p3));
1972 	}
1973 
1974 }
1975 
1976 /**
1977  * @dev Interface of the ERC20 standard as defined in the EIP.
1978  */
1979 interface IERC20 {
1980     /**
1981      * @dev Returns the amount of tokens in existence.
1982      */
1983     function totalSupply() external view returns (uint256);
1984 
1985     /**
1986      * @dev Returns the amount of tokens owned by `account`.
1987      */
1988     function balanceOf(address account) external view returns (uint256);
1989 
1990     /**
1991      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1992      *
1993      * Returns a boolean value indicating whether the operation succeeded.
1994      *
1995      * Emits a {Transfer} event.
1996      */
1997     function transfer(address recipient, uint256 amount) external returns (bool);
1998 
1999     /**
2000      * @dev Returns the remaining number of tokens that `spender` will be
2001      * allowed to spend on behalf of `owner` through {transferFrom}. This is
2002      * zero by default.
2003      *
2004      * This value changes when {approve} or {transferFrom} are called.
2005      */
2006     function allowance(address owner, address spender) external view returns (uint256);
2007 
2008     /**
2009      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
2010      *
2011      * Returns a boolean value indicating whether the operation succeeded.
2012      *
2013      * IMPORTANT: Beware that changing an allowance with this method brings the risk
2014      * that someone may use both the old and the new allowance by unfortunate
2015      * transaction ordering. One possible solution to mitigate this race
2016      * condition is to first reduce the spender's allowance to 0 and set the
2017      * desired value afterwards:
2018      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
2019      *
2020      * Emits an {Approval} event.
2021      */
2022     function approve(address spender, uint256 amount) external returns (bool);
2023 
2024     /**
2025      * @dev Moves `amount` tokens from `sender` to `recipient` using the
2026      * allowance mechanism. `amount` is then deducted from the caller's
2027      * allowance.
2028      *
2029      * Returns a boolean value indicating whether the operation succeeded.
2030      *
2031      * Emits a {Transfer} event.
2032      */
2033     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
2034 
2035     /**
2036      * @dev Emitted when `value` tokens are moved from one account (`from`) to
2037      * another (`to`).
2038      *
2039      * Note that `value` may be zero.
2040      */
2041     event Transfer(address indexed from, address indexed to, uint256 value);
2042 
2043     /**
2044      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
2045      * a call to {approve}. `value` is the new allowance.
2046      */
2047     event Approval(address indexed owner, address indexed spender, uint256 value);
2048 }
2049 
2050 interface IUniswapV2Factory {
2051     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
2052 
2053     function feeTo() external view returns (address);
2054     function feeToSetter() external view returns (address);
2055     function migrator() external view returns (address);
2056 
2057     function getPair(address tokenA, address tokenB) external view returns (address pair);
2058     function allPairs(uint) external view returns (address pair);
2059     function allPairsLength() external view returns (uint);
2060 
2061     function createPair(address tokenA, address tokenB) external returns (address pair);
2062 
2063     function setFeeTo(address) external;
2064     function setFeeToSetter(address) external;
2065     function setMigrator(address) external;
2066 }
2067 
2068 interface IUniswapV2Router01 {
2069     function factory() external pure returns (address);
2070     function WETH() external pure returns (address);
2071 
2072     function addLiquidity(
2073         address tokenA,
2074         address tokenB,
2075         uint amountADesired,
2076         uint amountBDesired,
2077         uint amountAMin,
2078         uint amountBMin,
2079         address to,
2080         uint deadline
2081     ) external returns (uint amountA, uint amountB, uint liquidity);
2082     function addLiquidityETH(
2083         address token,
2084         uint amountTokenDesired,
2085         uint amountTokenMin,
2086         uint amountETHMin,
2087         address to,
2088         uint deadline
2089     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
2090     function removeLiquidity(
2091         address tokenA,
2092         address tokenB,
2093         uint liquidity,
2094         uint amountAMin,
2095         uint amountBMin,
2096         address to,
2097         uint deadline
2098     ) external returns (uint amountA, uint amountB);
2099     function removeLiquidityETH(
2100         address token,
2101         uint liquidity,
2102         uint amountTokenMin,
2103         uint amountETHMin,
2104         address to,
2105         uint deadline
2106     ) external returns (uint amountToken, uint amountETH);
2107     function removeLiquidityWithPermit(
2108         address tokenA,
2109         address tokenB,
2110         uint liquidity,
2111         uint amountAMin,
2112         uint amountBMin,
2113         address to,
2114         uint deadline,
2115         bool approveMax, uint8 v, bytes32 r, bytes32 s
2116     ) external returns (uint amountA, uint amountB);
2117     function removeLiquidityETHWithPermit(
2118         address token,
2119         uint liquidity,
2120         uint amountTokenMin,
2121         uint amountETHMin,
2122         address to,
2123         uint deadline,
2124         bool approveMax, uint8 v, bytes32 r, bytes32 s
2125     ) external returns (uint amountToken, uint amountETH);
2126     function swapExactTokensForTokens(
2127         uint amountIn,
2128         uint amountOutMin,
2129         address[] calldata path,
2130         address to,
2131         uint deadline
2132     ) external returns (uint[] memory amounts);
2133     function swapTokensForExactTokens(
2134         uint amountOut,
2135         uint amountInMax,
2136         address[] calldata path,
2137         address to,
2138         uint deadline
2139     ) external returns (uint[] memory amounts);
2140     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
2141         external
2142         payable
2143         returns (uint[] memory amounts);
2144     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
2145         external
2146         returns (uint[] memory amounts);
2147     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
2148         external
2149         returns (uint[] memory amounts);
2150     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
2151         external
2152         payable
2153         returns (uint[] memory amounts);
2154 
2155     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
2156     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
2157     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
2158     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
2159     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
2160 }
2161 
2162 interface IUniswapV2Router02 is IUniswapV2Router01 {
2163     function removeLiquidityETHSupportingFeeOnTransferTokens(
2164         address token,
2165         uint liquidity,
2166         uint amountTokenMin,
2167         uint amountETHMin,
2168         address to,
2169         uint deadline
2170     ) external returns (uint amountETH);
2171     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
2172         address token,
2173         uint liquidity,
2174         uint amountTokenMin,
2175         uint amountETHMin,
2176         address to,
2177         uint deadline,
2178         bool approveMax, uint8 v, bytes32 r, bytes32 s
2179     ) external returns (uint amountETH);
2180 
2181     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
2182         uint amountIn,
2183         uint amountOutMin,
2184         address[] calldata path,
2185         address to,
2186         uint deadline
2187     ) external;
2188     function swapExactETHForTokensSupportingFeeOnTransferTokens(
2189         uint amountOutMin,
2190         address[] calldata path,
2191         address to,
2192         uint deadline
2193     ) external payable;
2194     function swapExactTokensForETHSupportingFeeOnTransferTokens(
2195         uint amountIn,
2196         uint amountOutMin,
2197         address[] calldata path,
2198         address to,
2199         uint deadline
2200     ) external;
2201 }
2202 
2203 interface IUniswapV2Pair {
2204     event Approval(address indexed owner, address indexed spender, uint value);
2205     event Transfer(address indexed from, address indexed to, uint value);
2206 
2207     function name() external pure returns (string memory);
2208     function symbol() external pure returns (string memory);
2209     function decimals() external pure returns (uint8);
2210     function totalSupply() external view returns (uint);
2211     function balanceOf(address owner) external view returns (uint);
2212     function allowance(address owner, address spender) external view returns (uint);
2213 
2214     function approve(address spender, uint value) external returns (bool);
2215     function transfer(address to, uint value) external returns (bool);
2216     function transferFrom(address from, address to, uint value) external returns (bool);
2217 
2218     function DOMAIN_SEPARATOR() external view returns (bytes32);
2219     function PERMIT_TYPEHASH() external pure returns (bytes32);
2220     function nonces(address owner) external view returns (uint);
2221 
2222     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
2223 
2224     event Mint(address indexed sender, uint amount0, uint amount1);
2225     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
2226     event Swap(
2227         address indexed sender,
2228         uint amount0In,
2229         uint amount1In,
2230         uint amount0Out,
2231         uint amount1Out,
2232         address indexed to
2233     );
2234     event Sync(uint112 reserve0, uint112 reserve1);
2235 
2236     function MINIMUM_LIQUIDITY() external pure returns (uint);
2237     function factory() external view returns (address);
2238     function token0() external view returns (address);
2239     function token1() external view returns (address);
2240     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
2241     function price0CumulativeLast() external view returns (uint);
2242     function price1CumulativeLast() external view returns (uint);
2243     function kLast() external view returns (uint);
2244 
2245     function mint(address to) external returns (uint liquidity);
2246     function burn(address to) external returns (uint amount0, uint amount1);
2247     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
2248     function skim(address to) external;
2249     function sync() external;
2250 
2251     function initialize(address, address) external;
2252 }
2253 
2254 interface IWETH {
2255     function deposit() external payable;
2256     function transfer(address to, uint value) external returns (bool);
2257     function withdraw(uint) external;
2258 }
2259 
2260 /**
2261  * @dev Contract module which provides a basic access control mechanism, where
2262  * there is an account (an owner) that can be granted exclusive access to
2263  * specific functions.
2264  *
2265  * By default, the owner account will be the one that deploys the contract. This
2266  * can later be changed with {transferOwnership}.
2267  *
2268  * This module is used through inheritance. It will make available the modifier
2269  * `onlyOwner`, which can be applied to your functions to restrict their use to
2270  * the owner.
2271  */
2272 contract Ownable is Context {
2273     address private _owner;
2274 
2275     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2276 
2277     /**
2278      * @dev Initializes the contract setting the deployer as the initial owner.
2279      */
2280     constructor () internal {
2281         address msgSender = _msgSender();
2282         _owner = msgSender;
2283         emit OwnershipTransferred(address(0), msgSender);
2284     }
2285 
2286     /**
2287      * @dev Returns the address of the current owner.
2288      */
2289     function owner() public view returns (address) {
2290         return _owner;
2291     }
2292 
2293     /**
2294      * @dev Throws if called by any account other than the owner.
2295      */
2296     modifier onlyOwner() {
2297         require(_owner == _msgSender(), "Ownable: caller is not the owner");
2298         _;
2299     }
2300 
2301     /**
2302      * @dev Leaves the contract without owner. It will not be possible to call
2303      * `onlyOwner` functions anymore. Can only be called by the current owner.
2304      *
2305      * NOTE: Renouncing ownership will leave the contract without an owner,
2306      * thereby removing any functionality that is only available to the owner.
2307      */
2308     function renounceOwnership() public virtual onlyOwner {
2309         emit OwnershipTransferred(_owner, address(0));
2310         _owner = address(0);
2311     }
2312 
2313     /**
2314      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2315      * Can only be called by the current owner.
2316      */
2317     function transferOwnership(address newOwner) public virtual onlyOwner {
2318         require(newOwner != address(0), "Ownable: new owner is the zero address");
2319         emit OwnershipTransferred(_owner, newOwner);
2320         _owner = newOwner;
2321     }
2322 }
2323 
2324 /**
2325  * @dev Implementation of the {IERC20} interface.
2326  *
2327  * This implementation is agnostic to the way tokens are created. This means
2328  * that a supply mechanism has to be added in a derived contract using {_mint}.
2329  * For a generic mechanism see {ERC20PresetMinterPauser}.
2330  *
2331  * TIP: For a detailed writeup see our guide
2332  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
2333  * to implement supply mechanisms].
2334  *
2335  * We have followed general OpenZeppelin guidelines: functions revert instead
2336  * of returning `false` on failure. This behavior is nonetheless conventional
2337  * and does not conflict with the expectations of ERC20 applications.
2338  *
2339  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
2340  * This allows applications to reconstruct the allowance for all accounts just
2341  * by listening to said events. Other implementations of the EIP may not emit
2342  * these events, as it isn't required by the specification.
2343  *
2344  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
2345  * functions have been added to mitigate the well-known issues around setting
2346  * allowances. See {IERC20-approve}.
2347  */
2348 contract NBUNIERC20 is Context, INBUNIERC20, Ownable {
2349     using SafeMath for uint256;
2350     using Address for address;
2351 
2352     mapping(address => uint256) private _balances;
2353 
2354     mapping(address => mapping(address => uint256)) private _allowances;
2355 
2356     event LiquidityAddition(address indexed dst, uint value);
2357     event LPTokenClaimed(address dst, uint value);
2358 
2359     uint256 private _totalSupply;
2360 
2361     string private _name;
2362     string private _symbol;
2363     uint8 private _decimals;
2364     uint256 public constant initialSupply = 4000e18; // 10k Total Supply: 4k for LGE, Uniswap listing and LP tokens, 2k for LGE Contributors equally distributed, 2k for Degens of TCORE Community, 2k for Team
2365     uint256 public contractStartTimestamp;
2366 
2367     function initialSetup() internal {
2368         _name = "TornadoCORE";
2369         _symbol = "TCORE";
2370         _decimals = 18;
2371         _mint(address(this), initialSupply);
2372         contractStartTimestamp = block.timestamp;
2373         uniswapRouterV2 = IUniswapV2Router02(address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D));
2374         uniswapFactory = IUniswapV2Factory(address(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f));
2375         createUniswapPairMainnet();
2376     }
2377 
2378     /**
2379      * @dev Returns the name of the token.
2380      */
2381     function name() public view returns (string memory)
2382     {
2383         return _name;
2384     }
2385 
2386     /**
2387      * @dev Returns the symbol of the token, usually a shorter version of the
2388      * name.
2389      */
2390     function symbol() public view returns (string memory) {
2391         return _symbol;
2392     }
2393 
2394     /**
2395      * @dev Returns the number of decimals used to get its user representation.
2396      * For example, if `decimals` equals `2`, a balance of `505` tokens should
2397      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
2398      *
2399      * Tokens usually opt for a value of 18, imitating the relationship between
2400      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
2401      * called.
2402      *
2403      * NOTE: This information is only used for _display_ purposes: it in
2404      * no way affects any of the arithmetic of the contract, including
2405      * {IERC20-balanceOf} and {IERC20-transfer}.
2406      */
2407     function decimals() public view returns (uint8) {
2408         return _decimals;
2409     }
2410 
2411     /**
2412      * @dev See {IERC20-totalSupply}.
2413      */
2414     function totalSupply() public override view returns (uint256) {
2415         return _totalSupply;
2416     }
2417 
2418     /**
2419      * @dev See {IERC20-balanceOf}.
2420      */
2421     // function balanceOf(address account) public override returns (uint256) {
2422     //     return _balances[account];
2423     // }
2424     function balanceOf(address _owner) public override view returns (uint256) {
2425         return _balances[_owner];
2426     }
2427 
2428 
2429     IUniswapV2Router02 public uniswapRouterV2;
2430     IUniswapV2Factory public uniswapFactory;
2431 
2432 
2433     address public tokenUniswapPair;
2434 
2435     function createUniswapPairMainnet()
2436         public
2437         returns (address)
2438     {
2439         require(tokenUniswapPair == address(0), "Token: pool already created");
2440         tokenUniswapPair = uniswapFactory.createPair(
2441             address(uniswapRouterV2.WETH()),
2442             address(this)
2443         );
2444         return tokenUniswapPair;
2445     }
2446 
2447 
2448     ///  Liquidity generation logic
2449     ///  Steps - All tokens that will ever exist go to this contract
2450     ///  This contract accepts ETH as payable
2451     ///  ETH is mapped to people
2452     ///  When liquidity generation event is over, everyone can call the mint LP function,
2453     ///  Which will put all the ETH and tokens inside the Uniswap contract without any involvement
2454     ///  This LP will go into this contract
2455     ///  And will be able to proportionally be withdrawn based on ETH put in.
2456     ///  An emergency drain function allows the contract owner to drain all ETH and tokens from this contract
2457     ///  after the liquidity generation event happened, to send ETH back to contributors in case something goes wrong.
2458 
2459 
2460     string public liquidityGenerationParticipationAgreement = "I agree that the developer and affiliated parties of TCORE team are not responsible for your funds. This project is experimental, DYOR.";
2461 
2462     function getSecondsLeftInLiquidityGenerationEvent()
2463         public
2464         view
2465         returns (uint256)
2466     {
2467         require(liquidityGenerationOngoing(), "Event over");
2468         console.log("13 days since start is", contractStartTimestamp.add(13 days), "Time now is", block.timestamp);
2469         return contractStartTimestamp.add(13 days).sub(block.timestamp);
2470     }
2471 
2472     function liquidityGenerationOngoing()
2473         public
2474         view
2475         returns (bool)
2476     {
2477         console.log("13 days since start is", contractStartTimestamp.add(13 days), "Time now is", block.timestamp);
2478         console.log("liquidity generation ongoing", contractStartTimestamp.add(13 days) < block.timestamp);
2479         return contractStartTimestamp.add(13 days) > block.timestamp;
2480     }
2481 
2482     uint256 public totalLPTokensMinted;
2483     uint256 public totalETHContributed;
2484     uint256 public LPperETHUnit;
2485     bool public LPGenerationCompleted;
2486 
2487     mapping (address => uint)  public ethContributed;
2488     // Possible ways this could break addressed
2489     // 1) No agreement to terms - added require
2490     // 2) Adding liquidity after LGE is over - added require
2491     // 3) Overflow from uint - impossible there is not enough ETH available
2492     // 4) Depositing 0 - not an issue it will just add 0 totally
2493     function addLiquidity(bool agreesToTermsOutlinedInLiquidityGenerationParticipationAgreement)
2494         public
2495         payable
2496     {
2497         require(liquidityGenerationOngoing(), "Liquidity Generation Event over");
2498         require(agreesToTermsOutlinedInLiquidityGenerationParticipationAgreement, "No agreement provided");
2499         ethContributed[msg.sender] += msg.value; // Overflow protection from safemath is not neded here
2500         totalETHContributed = totalETHContributed.add(msg.value); // For front end display during LGE. This resets with definitive correct balance while calling pair.
2501         emit LiquidityAddition(msg.sender, msg.value);
2502     }
2503 
2504     // Sends all available balances and mints LP tokens
2505     // Possible ways this could break addressed
2506     // 1) Multiple calls and resetting amounts - addressed with boolean
2507     // 2) Failed WETH wrapping/unwrapping addressed with checks
2508     // 3) Failure to create LP tokens, addressed with checks
2509     // 4) Unacceptable division errors. Addressed with multiplications by 1e18
2510     // 5) Pair not set - impossible since its set in constructor
2511     function addLiquidityToUniswapTCORExWETHPair() public {
2512         require(liquidityGenerationOngoing() == false, "TCORE LGE ongoing");
2513         require(LPGenerationCompleted == false, "TCORE LGE already finished");
2514         totalETHContributed = address(this).balance;
2515         IUniswapV2Pair pair = IUniswapV2Pair(tokenUniswapPair);
2516         console.log("Balance of this", totalETHContributed / 1e18);
2517         //Wrap eth
2518         address WETH = uniswapRouterV2.WETH();
2519         IWETH(WETH).deposit{value : totalETHContributed}();
2520         require(address(this).balance == 0 , "Transfer Failed");
2521         IWETH(WETH).transfer(address(pair),totalETHContributed);
2522         emit Transfer(address(this), address(pair), _balances[address(this)]);
2523         _balances[address(pair)] = _balances[address(this)];
2524         _balances[address(this)] = 0;
2525         pair.mint(address(this));
2526         totalLPTokensMinted = pair.balanceOf(address(this));
2527         console.log("Total tokens minted",totalLPTokensMinted);
2528         require(totalLPTokensMinted != 0 , "LP creation failed");
2529         LPperETHUnit = totalLPTokensMinted.mul(1e18).div(totalETHContributed); // 1e18x for  change
2530         console.log("Total per LP token", LPperETHUnit);
2531         require(LPperETHUnit != 0 , "LP creation failed");
2532         LPGenerationCompleted = true;
2533     }
2534 
2535     // Possible ways this could break addressed
2536     // 1) Accessing before event is over and resetting eth contributed -- added require
2537     // 2) No uniswap pair - impossible at this moment because of the LPGenerationCompleted bool
2538     // 3) LP per unit is 0 - impossible checked at generation function
2539     function claimLPTokens() public {
2540         require(LPGenerationCompleted, "Event not over yet");
2541         require(ethContributed[msg.sender] > 0 , "Nothing to claim, move along tornado");
2542         IUniswapV2Pair pair = IUniswapV2Pair(tokenUniswapPair);
2543         uint256 amountLPToTransfer = ethContributed[msg.sender].mul(LPperETHUnit).div(1e18);
2544         pair.transfer(msg.sender, amountLPToTransfer); // stored as 1e18x value for change
2545         ethContributed[msg.sender] = 0;
2546         emit LPTokenClaimed(msg.sender, amountLPToTransfer);
2547     }
2548 
2549     // Emergency drain in case of bug
2550     // Adds all funds to owner to refund people
2551     // Designed to be as simple as possible
2552     function emergencyDrain72hAfterLiquidityGenerationEventIsDone() public onlyOwner {
2553         require(contractStartTimestamp.add(16 days) < block.timestamp, "Liquidity generation grace period still ongoing"); // About 72h after liquidity generation happens
2554         (bool success, ) = msg.sender.call.value(address(this).balance)("");
2555         require(success, "Transfer failed.");
2556         _balances[msg.sender] = _balances[address(this)];
2557         _balances[address(this)] = 0;
2558     }
2559 
2560     // Add mint and burn functions in case the community wants to increase or decrease the supply in the future
2561     // Minter role is controlled by TCORE governance only, developer alone cannot invoke the function
2562     
2563     mapping(address => bool) public isMinter;
2564 
2565     function setMinter(address _minter, bool _minterStatus) public onlyOwner {
2566         isMinter[_minter] = _minterStatus;
2567     }
2568 
2569     function mint(address account, uint256 amount) public {
2570         require(isMinter[msg.sender], "not a minter TCORE");
2571         _mint(account, amount);
2572     }
2573 
2574     function burn(uint256 amount) public {
2575         _burn(msg.sender, amount);
2576     }
2577 
2578     /**
2579      * @dev See {IERC20-transfer}.
2580      *
2581      * Requirements:
2582      *
2583      * - `recipient` cannot be the zero address.
2584      * - the caller must have a balance of at least `amount`.
2585      */
2586     function transfer(address recipient, uint256 amount) public virtual override returns (bool)
2587     {
2588         _transfer(_msgSender(), recipient, amount);
2589         return true;
2590     }
2591 
2592     /**
2593      * @dev See {IERC20-allowance}.
2594      */
2595     function allowance(address owner, address spender)
2596         public
2597         virtual
2598         override
2599         view
2600         returns (uint256)
2601     {
2602         return _allowances[owner][spender];
2603     }
2604 
2605     /**
2606      * @dev See {IERC20-approve}.
2607      *
2608      * Requirements:
2609      *
2610      * - `spender` cannot be the zero address.
2611      */
2612     function approve(address spender, uint256 amount)
2613         public
2614         virtual
2615         override
2616         returns (bool)
2617     {
2618         _approve(_msgSender(), spender, amount);
2619         return true;
2620     }
2621 
2622     /**
2623      * @dev See {IERC20-transferFrom}.
2624      *
2625      * Emits an {Approval} event indicating the updated allowance. This is not
2626      * required by the EIP. See the note at the beginning of {ERC20};
2627      *
2628      * Requirements:
2629      * - `sender` and `recipient` cannot be the zero address.
2630      * - `sender` must have a balance of at least `amount`.
2631      * - the caller must have allowance for ``sender``'s tokens of at least
2632      * `amount`.
2633      */
2634     function transferFrom(
2635         address sender,
2636         address recipient,
2637         uint256 amount
2638     ) public virtual override returns (bool) {
2639         _transfer(sender, recipient, amount);
2640         _approve(
2641             sender,
2642             _msgSender(),
2643             _allowances[sender][_msgSender()].sub(
2644                 amount,
2645                 "ERC20: transfer amount exceeds allowance"
2646             )
2647         );
2648         return true;
2649     }
2650 
2651     /**
2652      * @dev Atomically increases the allowance granted to `spender` by the caller.
2653      *
2654      * This is an alternative to {approve} that can be used as a mitigation for
2655      * problems described in {IERC20-approve}.
2656      *
2657      * Emits an {Approval} event indicating the updated allowance.
2658      *
2659      * Requirements:
2660      *
2661      * - `spender` cannot be the zero address.
2662      */
2663     function increaseAllowance(address spender, uint256 addedValue)
2664         public
2665         virtual
2666         returns (bool)
2667     {
2668         _approve(
2669             _msgSender(),
2670             spender,
2671             _allowances[_msgSender()][spender].add(addedValue)
2672         );
2673         return true;
2674     }
2675 
2676     /**
2677      * @dev Atomically decreases the allowance granted to `spender` by the caller.
2678      *
2679      * This is an alternative to {approve} that can be used as a mitigation for
2680      * problems described in {IERC20-approve}.
2681      *
2682      * Emits an {Approval} event indicating the updated allowance.
2683      *
2684      * Requirements:
2685      *
2686      * - `spender` cannot be the zero address.
2687      * - `spender` must have allowance for the caller of at least
2688      * `subtractedValue`.
2689      */
2690     function decreaseAllowance(address spender, uint256 subtractedValue)
2691         public
2692         virtual
2693         returns (bool)
2694     {
2695         _approve(
2696             _msgSender(),
2697             spender,
2698             _allowances[_msgSender()][spender].sub(
2699                 subtractedValue,
2700                 "ERC20: decreased allowance below zero"
2701             )
2702         );
2703         return true;
2704     }
2705 
2706     function setShouldTransferChecker(address _transferCheckerAddress)
2707         public
2708         onlyOwner
2709     {
2710         transferCheckerAddress = _transferCheckerAddress;
2711     }
2712 
2713     address public transferCheckerAddress;
2714 
2715     function setFeeDistributor(address _feeDistributor)
2716         public
2717         onlyOwner
2718     {
2719         feeDistributor = _feeDistributor;
2720     }
2721 
2722     address public feeDistributor;
2723 
2724 
2725 
2726     /**
2727      * @dev Moves tokens `amount` from `sender` to `recipient`.
2728      *
2729      * This is internal function is equivalent to {transfer}, and can be used to
2730      * e.g. implement automatic token fees, slashing mechanisms, etc.
2731      *
2732      * Emits a {Transfer} event.
2733      *
2734      * Requirements:
2735      *
2736      * - `sender` cannot be the zero address.
2737      * - `recipient` cannot be the zero address.
2738      * - `sender` must have a balance of at least `amount`.
2739      */
2740     function _transfer(
2741         address sender,
2742         address recipient,
2743         uint256 amount
2744     ) internal virtual {
2745         require(sender != address(0), "ERC20: transfer from the zero address");
2746         require(recipient != address(0), "ERC20: transfer to the zero address");
2747 
2748 
2749 
2750         _beforeTokenTransfer(sender, recipient, amount);
2751 
2752         _balances[sender] = _balances[sender].sub(
2753             amount,
2754             "ERC20: transfer amount exceeds balance"
2755         );
2756 
2757         (uint256 transferToAmount, uint256 transferToFeeDistributorAmount) = IFeeApprover(transferCheckerAddress).calculateAmountsAfterFee(sender, recipient, amount);
2758 
2759 
2760         // Addressing a broken checker contract
2761         require(transferToAmount.add(transferToFeeDistributorAmount) == amount, "Math broke, does gravity still work?");
2762 
2763         _balances[recipient] = _balances[recipient].add(transferToAmount);
2764         emit Transfer(sender, recipient, transferToAmount);
2765 
2766         if(transferToFeeDistributorAmount > 0 && feeDistributor != address(0)){
2767             _balances[feeDistributor] = _balances[feeDistributor].add(transferToFeeDistributorAmount);
2768             emit Transfer(sender, feeDistributor, transferToFeeDistributorAmount);
2769             if(feeDistributor != address(0)){
2770                 ITcoreVault(feeDistributor).addPendingRewards(transferToFeeDistributorAmount);
2771             }
2772         }
2773     }
2774 
2775     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
2776      * the total supply.
2777      *
2778      * Emits a {Transfer} event with `from` set to the zero address.
2779      *
2780      * Requirements
2781      *
2782      * - `to` cannot be the zero address.
2783      */
2784 
2785     function _mint(address account, uint256 amount) internal virtual {
2786         require(account != address(0), "ERC20: mint to the zero address");
2787 
2788         _beforeTokenTransfer(address(0), account, amount);
2789 
2790         _totalSupply = _totalSupply.add(amount);
2791         _balances[account] = _balances[account].add(amount);
2792         emit Transfer(address(0), account, amount);
2793     }
2794 
2795     /**
2796      * @dev Destroys `amount` tokens from `account`, reducing the
2797      * total supply.
2798      *
2799      * Emits a {Transfer} event with `to` set to the zero address.
2800      *
2801      * Requirements
2802      *
2803      * - `account` cannot be the zero address.
2804      * - `account` must have at least `amount` tokens.
2805      */
2806     function _burn(address account, uint256 amount) internal virtual {
2807         require(account != address(0), "ERC20: burn from the zero address");
2808 
2809         _beforeTokenTransfer(account, address(0), amount);
2810 
2811         _balances[account] = _balances[account].sub(
2812             amount,
2813             "ERC20: burn amount exceeds balance"
2814         );
2815         _totalSupply = _totalSupply.sub(amount);
2816         emit Transfer(account, address(0), amount);
2817     }
2818 
2819     /**
2820      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
2821      *
2822      * This is internal function is equivalent to `approve`, and can be used to
2823      * e.g. set automatic allowances for certain subsystems, etc.
2824      *
2825      * Emits an {Approval} event.
2826      *
2827      * Requirements:
2828      *
2829      * - `owner` cannot be the zero address.
2830      * - `spender` cannot be the zero address.
2831      */
2832     function _approve(
2833         address owner,
2834         address spender,
2835         uint256 amount
2836     ) internal virtual {
2837         require(owner != address(0), "ERC20: approve from the zero address");
2838         require(spender != address(0), "ERC20: approve to the zero address");
2839 
2840         _allowances[owner][spender] = amount;
2841         emit Approval(owner, spender, amount);
2842     }
2843 
2844     /**
2845      * @dev Sets {decimals} to a value other than the default one of 18.
2846      *
2847      * WARNING: This function should only be called from the constructor. Most
2848      * applications that interact with token contracts will not expect
2849      * {decimals} to ever change, and may work incorrectly if it does.
2850      */
2851     function _setupDecimals(uint8 decimals_) internal {
2852         _decimals = decimals_;
2853     }
2854 
2855     /**
2856      * @dev Hook that is called before any transfer of tokens. This includes
2857      * minting and burning.
2858      *
2859      * Calling conditions:
2860      *
2861      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
2862      * will be to transferred to `to`.
2863      * - when `from` is zero, `amount` tokens will be minted for `to`.
2864      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
2865      * - `from` and `to` are never both zero.
2866      *
2867      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2868      */
2869     function _beforeTokenTransfer(
2870         address from,
2871         address to,
2872         uint256 amount
2873     ) internal virtual {}
2874 }
2875 
2876 // TcoreToken with Governance.
2877 contract TCORE is NBUNIERC20 {
2878     /**
2879      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
2880      * a default value of 18.
2881      *
2882      * To select a different value for {decimals}, use {_setupDecimals}.
2883      *
2884      * All three of these values are immutable: they can only be set once during
2885      * construction.
2886      */
2887     constructor() public {
2888         initialSetup();
2889     }
2890 
2891     // Copied and modified from YAM code:
2892     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
2893     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
2894     // Which is copied and modified from COMPOUND:
2895     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
2896 
2897     mapping (address => address) internal _delegates;
2898 
2899     /// @notice A checkpoint for marking number of votes from a given block
2900     struct Checkpoint {
2901         uint32 fromBlock;
2902         uint256 votes;
2903     }
2904 
2905 
2906     /// @notice A record of votes checkpoints for each account, by index
2907     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
2908 
2909     /// @notice The number of checkpoints for each account
2910     mapping (address => uint32) public numCheckpoints;
2911 
2912     /// @notice The EIP-712 typehash for the contract's domain
2913     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
2914 
2915     /// @notice The EIP-712 typehash for the delegation struct used by the contract
2916     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
2917 
2918     /// @notice A record of states for signing / validating signatures
2919     mapping (address => uint) public nonces;
2920 
2921       /// @notice An event thats emitted when an account changes its delegate
2922     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
2923 
2924     /// @notice An event thats emitted when a delegate account's vote balance changes
2925     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
2926 
2927     /**
2928      * @notice Delegate votes from `msg.sender` to `delegatee`
2929      * @param delegator The address to get delegatee for
2930      */
2931     function delegates(address delegator)
2932         external
2933         view
2934         returns (address)
2935     {
2936         return _delegates[delegator];
2937     }
2938 
2939    /**
2940     * @notice Delegate votes from `msg.sender` to `delegatee`
2941     * @param delegatee The address to delegate votes to
2942     */
2943     function delegate(address delegatee) external {
2944         return _delegate(msg.sender, delegatee);
2945     }
2946 
2947     /**
2948      * @notice Delegates votes from signatory to `delegatee`
2949      * @param delegatee The address to delegate votes to
2950      * @param nonce The contract state required to match the signature
2951      * @param expiry The time at which to expire the signature
2952      * @param v The recovery byte of the signature
2953      * @param r Half of the ECDSA signature pair
2954      * @param s Half of the ECDSA signature pair
2955      */
2956     function delegateBySig(
2957         address delegatee,
2958         uint nonce,
2959         uint expiry,
2960         uint8 v,
2961         bytes32 r,
2962         bytes32 s
2963     )
2964         external
2965     {
2966         bytes32 domainSeparator = keccak256(
2967             abi.encode(
2968                 DOMAIN_TYPEHASH,
2969                 keccak256(bytes(name())),
2970                 getChainId(),
2971                 address(this)
2972             )
2973         );
2974 
2975         bytes32 structHash = keccak256(
2976             abi.encode(
2977                 DELEGATION_TYPEHASH,
2978                 delegatee,
2979                 nonce,
2980                 expiry
2981             )
2982         );
2983 
2984         bytes32 digest = keccak256(
2985             abi.encodePacked(
2986                 "\x19\x01",
2987                 domainSeparator,
2988                 structHash
2989             )
2990         );
2991 
2992         address signatory = ecrecover(digest, v, r, s);
2993         require(signatory != address(0), "TCORE::delegateBySig: invalid signature");
2994         require(nonce == nonces[signatory]++, "TCORE::delegateBySig: invalid nonce");
2995         require(now <= expiry, "TCORE::delegateBySig: signature expired");
2996         return _delegate(signatory, delegatee);
2997     }
2998 
2999     /**
3000      * @notice Gets the current votes balance for `account`
3001      * @param account The address to get votes balance
3002      * @return The number of current votes for `account`
3003      */
3004     function getCurrentVotes(address account)
3005         external
3006         view
3007         returns (uint256)
3008     {
3009         uint32 nCheckpoints = numCheckpoints[account];
3010         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
3011     }
3012 
3013     /**
3014      * @notice Determine the prior number of votes for an account as of a block number
3015      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
3016      * @param account The address of the account to check
3017      * @param blockNumber The block number to get the vote balance at
3018      * @return The number of votes the account had as of the given block
3019      */
3020     function getPriorVotes(address account, uint blockNumber)
3021         external
3022         view
3023         returns (uint256)
3024     {
3025         require(blockNumber < block.number, "TCORE::getPriorVotes: not yet determined");
3026 
3027         uint32 nCheckpoints = numCheckpoints[account];
3028         if (nCheckpoints == 0) {
3029             return 0;
3030         }
3031 
3032         // First check most recent balance
3033         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
3034             return checkpoints[account][nCheckpoints - 1].votes;
3035         }
3036 
3037         // Next check implicit zero balance
3038         if (checkpoints[account][0].fromBlock > blockNumber) {
3039             return 0;
3040         }
3041 
3042         uint32 lower = 0;
3043         uint32 upper = nCheckpoints - 1;
3044         while (upper > lower) {
3045             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
3046             Checkpoint memory cp = checkpoints[account][center];
3047             if (cp.fromBlock == blockNumber) {
3048                 return cp.votes;
3049             } else if (cp.fromBlock < blockNumber) {
3050                 lower = center;
3051             } else {
3052                 upper = center - 1;
3053             }
3054         }
3055         return checkpoints[account][lower].votes;
3056     }
3057 
3058     function _delegate(address delegator, address delegatee)
3059         internal
3060     {
3061         address currentDelegate = _delegates[delegator];
3062         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying TCORE tokens (not scaled);
3063         _delegates[delegator] = delegatee;
3064 
3065         emit DelegateChanged(delegator, currentDelegate, delegatee);
3066 
3067         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
3068     }
3069 
3070     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
3071         if (srcRep != dstRep && amount > 0) {
3072             if (srcRep != address(0)) {
3073                 // decrease old representative
3074                 uint32 srcRepNum = numCheckpoints[srcRep];
3075                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
3076                 uint256 srcRepNew = srcRepOld.sub(amount);
3077                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
3078             }
3079 
3080             if (dstRep != address(0)) {
3081                 // increase new representative
3082                 uint32 dstRepNum = numCheckpoints[dstRep];
3083                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
3084                 uint256 dstRepNew = dstRepOld.add(amount);
3085                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
3086             }
3087         }
3088     }
3089 
3090     function _writeCheckpoint(
3091         address delegatee,
3092         uint32 nCheckpoints,
3093         uint256 oldVotes,
3094         uint256 newVotes
3095     )
3096         internal
3097     {
3098         uint32 blockNumber = safe32(block.number, "TCORE::_writeCheckpoint: block number exceeds 32 bits");
3099 
3100         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
3101             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
3102         } else {
3103             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
3104             numCheckpoints[delegatee] = nCheckpoints + 1;
3105         }
3106 
3107         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
3108     }
3109 
3110     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
3111         require(n < 2**32, errorMessage);
3112         return uint32(n);
3113     }
3114 
3115     function getChainId() internal pure returns (uint) {
3116         uint256 chainId;
3117         assembly { chainId := chainid() }
3118         return chainId;
3119     }
3120 }