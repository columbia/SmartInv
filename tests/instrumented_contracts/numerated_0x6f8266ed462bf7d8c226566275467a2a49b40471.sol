1 /**
2  *Submitted for verification at Etherscan.io on 2021-08-19
3 */
4 
5 // SPDX-License-Identifier: MIT
6 // File: @openzeppelin/contracts/proxy/Proxy.sol
7 
8 pragma solidity >=0.6.0 <0.8.0;
9 
10 /**
11  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
12  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
13  * be specified by overriding the virtual {_implementation} function.
14  *
15  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
16  * different contract through the {_delegate} function.
17  *
18  * The success and return data of the delegated call will be returned back to the caller of the proxy.
19  */
20 abstract contract Proxy {
21     /**
22      * @dev Delegates the current call to `implementation`.
23      *
24      * This function does not return to its internall call site, it will return directly to the external caller.
25      */
26     function _delegate(address implementation) internal virtual {
27         // solhint-disable-next-line no-inline-assembly
28         assembly {
29             // Copy msg.data. We take full control of memory in this inline assembly
30             // block because it will not return to Solidity code. We overwrite the
31             // Solidity scratch pad at memory position 0.
32             calldatacopy(0, 0, calldatasize())
33 
34             // Call the implementation.
35             // out and outsize are 0 because we don't know the size yet.
36             let result := delegatecall(
37                 gas(),
38                 implementation,
39                 0,
40                 calldatasize(),
41                 0,
42                 0
43             )
44 
45             // Copy the returned data.
46             returndatacopy(0, 0, returndatasize())
47 
48             switch result
49             // delegatecall returns 0 on error.
50             case 0 {
51                 revert(0, returndatasize())
52             }
53             default {
54                 return(0, returndatasize())
55             }
56         }
57     }
58 
59     /**
60      * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
61      * and {_fallback} should delegate.
62      */
63     function _implementation() internal view virtual returns (address);
64 
65     /**
66      * @dev Delegates the current call to the address returned by `_implementation()`.
67      *
68      * This function does not return to its internall call site, it will return directly to the external caller.
69      */
70     function _fallback() internal virtual {
71         _beforeFallback();
72         _delegate(_implementation());
73     }
74 
75     /**
76      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
77      * function in the contract matches the call data.
78      */
79     fallback() external payable virtual {
80         _fallback();
81     }
82 
83     /**
84      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
85      * is empty.
86      */
87     receive() external payable virtual {
88         _fallback();
89     }
90 
91     /**
92      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
93      * call, or as part of the Solidity `fallback` or `receive` functions.
94      *
95      * If overriden should call `super._beforeFallback()`.
96      */
97     function _beforeFallback() internal virtual {}
98 }
99 
100 // File: @openzeppelin/contracts/utils/Address.sol
101 
102 pragma solidity >=0.6.2 <0.8.0;
103 
104 /**
105  * @dev Collection of functions related to the address type
106  */
107 library Address {
108     /**
109      * @dev Returns true if `account` is a contract.
110      *
111      * [IMPORTANT]
112      * ====
113      * It is unsafe to assume that an address for which this function returns
114      * false is an externally-owned account (EOA) and not a contract.
115      *
116      * Among others, `isContract` will return false for the following
117      * types of addresses:
118      *
119      *  - an externally-owned account
120      *  - a contract in construction
121      *  - an address where a contract will be created
122      *  - an address where a contract lived, but was destroyed
123      * ====
124      */
125     function isContract(address account) internal view returns (bool) {
126         // This method relies on extcodesize, which returns 0 for contracts in
127         // construction, since the code is only stored at the end of the
128         // constructor execution.
129 
130         uint256 size;
131         // solhint-disable-next-line no-inline-assembly
132         assembly {
133             size := extcodesize(account)
134         }
135         return size > 0;
136     }
137 
138     /**
139      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
140      * `recipient`, forwarding all available gas and reverting on errors.
141      *
142      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
143      * of certain opcodes, possibly making contracts go over the 2300 gas limit
144      * imposed by `transfer`, making them unable to receive funds via
145      * `transfer`. {sendValue} removes this limitation.
146      *
147      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
148      *
149      * IMPORTANT: because control is transferred to `recipient`, care must be
150      * taken to not create reentrancy vulnerabilities. Consider using
151      * {ReentrancyGuard} or the
152      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
153      */
154     function sendValue(address payable recipient, uint256 amount) internal {
155         require(
156             address(this).balance >= amount,
157             "Address: insufficient balance"
158         );
159 
160         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
161         (bool success, ) = recipient.call{ value: amount }("");
162         require(
163             success,
164             "Address: unable to send value, recipient may have reverted"
165         );
166     }
167 
168     /**
169      * @dev Performs a Solidity function call using a low level `call`. A
170      * plain`call` is an unsafe replacement for a function call: use this
171      * function instead.
172      *
173      * If `target` reverts with a revert reason, it is bubbled up by this
174      * function (like regular Solidity function calls).
175      *
176      * Returns the raw returned data. To convert to the expected return value,
177      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
178      *
179      * Requirements:
180      *
181      * - `target` must be a contract.
182      * - calling `target` with `data` must not revert.
183      *
184      * _Available since v3.1._
185      */
186     function functionCall(address target, bytes memory data)
187         internal
188         returns (bytes memory)
189     {
190         return functionCall(target, data, "Address: low-level call failed");
191     }
192 
193     /**
194      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
195      * `errorMessage` as a fallback revert reason when `target` reverts.
196      *
197      * _Available since v3.1._
198      */
199     function functionCall(
200         address target,
201         bytes memory data,
202         string memory errorMessage
203     ) internal returns (bytes memory) {
204         return functionCallWithValue(target, data, 0, errorMessage);
205     }
206 
207     /**
208      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
209      * but also transferring `value` wei to `target`.
210      *
211      * Requirements:
212      *
213      * - the calling contract must have an ETH balance of at least `value`.
214      * - the called Solidity function must be `payable`.
215      *
216      * _Available since v3.1._
217      */
218     function functionCallWithValue(
219         address target,
220         bytes memory data,
221         uint256 value
222     ) internal returns (bytes memory) {
223         return
224             functionCallWithValue(
225                 target,
226                 data,
227                 value,
228                 "Address: low-level call with value failed"
229             );
230     }
231 
232     /**
233      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
234      * with `errorMessage` as a fallback revert reason when `target` reverts.
235      *
236      * _Available since v3.1._
237      */
238     function functionCallWithValue(
239         address target,
240         bytes memory data,
241         uint256 value,
242         string memory errorMessage
243     ) internal returns (bytes memory) {
244         require(
245             address(this).balance >= value,
246             "Address: insufficient balance for call"
247         );
248         require(isContract(target), "Address: call to non-contract");
249 
250         // solhint-disable-next-line avoid-low-level-calls
251         (bool success, bytes memory returndata) = target.call{ value: value }(
252             data
253         );
254         return _verifyCallResult(success, returndata, errorMessage);
255     }
256 
257     /**
258      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
259      * but performing a static call.
260      *
261      * _Available since v3.3._
262      */
263     function functionStaticCall(address target, bytes memory data)
264         internal
265         view
266         returns (bytes memory)
267     {
268         return
269             functionStaticCall(
270                 target,
271                 data,
272                 "Address: low-level static call failed"
273             );
274     }
275 
276     /**
277      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
278      * but performing a static call.
279      *
280      * _Available since v3.3._
281      */
282     function functionStaticCall(
283         address target,
284         bytes memory data,
285         string memory errorMessage
286     ) internal view returns (bytes memory) {
287         require(isContract(target), "Address: static call to non-contract");
288 
289         // solhint-disable-next-line avoid-low-level-calls
290         (bool success, bytes memory returndata) = target.staticcall(data);
291         return _verifyCallResult(success, returndata, errorMessage);
292     }
293 
294     /**
295      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
296      * but performing a delegate call.
297      *
298      * _Available since v3.4._
299      */
300     function functionDelegateCall(address target, bytes memory data)
301         internal
302         returns (bytes memory)
303     {
304         return
305             functionDelegateCall(
306                 target,
307                 data,
308                 "Address: low-level delegate call failed"
309             );
310     }
311 
312     /**
313      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
314      * but performing a delegate call.
315      *
316      * _Available since v3.4._
317      */
318     function functionDelegateCall(
319         address target,
320         bytes memory data,
321         string memory errorMessage
322     ) internal returns (bytes memory) {
323         require(isContract(target), "Address: delegate call to non-contract");
324 
325         // solhint-disable-next-line avoid-low-level-calls
326         (bool success, bytes memory returndata) = target.delegatecall(data);
327         return _verifyCallResult(success, returndata, errorMessage);
328     }
329 
330     function _verifyCallResult(
331         bool success,
332         bytes memory returndata,
333         string memory errorMessage
334     ) private pure returns (bytes memory) {
335         if (success) {
336             return returndata;
337         } else {
338             // Look for revert reason and bubble it up if present
339             if (returndata.length > 0) {
340                 // The easiest way to bubble the revert reason is using memory via assembly
341 
342                 // solhint-disable-next-line no-inline-assembly
343                 assembly {
344                     let returndata_size := mload(returndata)
345                     revert(add(32, returndata), returndata_size)
346                 }
347             } else {
348                 revert(errorMessage);
349             }
350         }
351     }
352 }
353 
354 // File: @openzeppelin/contracts/proxy/IBeacon.sol
355 
356 pragma solidity >=0.6.0 <0.8.0;
357 
358 /**
359  * @dev This is the interface that {BeaconProxy} expects of its beacon.
360  */
361 interface IBeacon {
362     /**
363      * @dev Must return an address that can be used as a delegate call target.
364      *
365      * {BeaconProxy} will check that this address is a contract.
366      */
367     function implementation() external view returns (address);
368 }
369 
370 // File: @openzeppelin/contracts/proxy/BeaconProxy.sol
371 
372 pragma solidity >=0.6.0 <0.8.0;
373 
374 /**
375  * @dev This contract implements a proxy that gets the implementation address for each call from a {UpgradeableBeacon}.
376  *
377  * The beacon address is stored in storage slot `uint256(keccak256('eip1967.proxy.beacon')) - 1`, so that it doesn't
378  * conflict with the storage layout of the implementation behind the proxy.
379  *
380  * _Available since v3.4._
381  */
382 contract BeaconProxy is Proxy {
383     /**
384      * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
385      * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
386      */
387     bytes32 private constant _BEACON_SLOT =
388         0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
389 
390     /**
391      * @dev Initializes the proxy with `beacon`.
392      *
393      * If `data` is nonempty, it's used as data in a delegate call to the implementation returned by the beacon. This
394      * will typically be an encoded function call, and allows initializating the storage of the proxy like a Solidity
395      * constructor.
396      *
397      * Requirements:
398      *
399      * - `beacon` must be a contract with the interface {IBeacon}.
400      */
401     constructor(address beacon, bytes memory data) public payable {
402         assert(
403             _BEACON_SLOT ==
404                 bytes32(uint256(keccak256("eip1967.proxy.beacon")) - 1)
405         );
406         _setBeacon(beacon, data);
407     }
408 
409     /**
410      * @dev Returns the current beacon address.
411      */
412     function _beacon() internal view virtual returns (address beacon) {
413         bytes32 slot = _BEACON_SLOT;
414         // solhint-disable-next-line no-inline-assembly
415         assembly {
416             beacon := sload(slot)
417         }
418     }
419 
420     /**
421      * @dev Returns the current implementation address of the associated beacon.
422      */
423     function _implementation()
424         internal
425         view
426         virtual
427         override
428         returns (address)
429     {
430         return IBeacon(_beacon()).implementation();
431     }
432 
433     /**
434      * @dev Changes the proxy to use a new beacon.
435      *
436      * If `data` is nonempty, it's used as data in a delegate call to the implementation returned by the beacon.
437      *
438      * Requirements:
439      *
440      * - `beacon` must be a contract.
441      * - The implementation returned by `beacon` must be a contract.
442      */
443     function _setBeacon(address beacon, bytes memory data) internal virtual {
444         require(
445             Address.isContract(beacon),
446             "BeaconProxy: beacon is not a contract"
447         );
448         require(
449             Address.isContract(IBeacon(beacon).implementation()),
450             "BeaconProxy: beacon implementation is not a contract"
451         );
452         bytes32 slot = _BEACON_SLOT;
453 
454         // solhint-disable-next-line no-inline-assembly
455         assembly {
456             sstore(slot, beacon)
457         }
458 
459         if (data.length > 0) {
460             Address.functionDelegateCall(
461                 _implementation(),
462                 data,
463                 "BeaconProxy: function call failed"
464             );
465         }
466     }
467 }
468 
469 // File: @openzeppelin/contracts/utils/Context.sol
470 
471 pragma solidity >=0.6.0 <0.8.0;
472 
473 /*
474  * @dev Provides information about the current execution context, including the
475  * sender of the transaction and its data. While these are generally available
476  * via msg.sender and msg.data, they should not be accessed in such a direct
477  * manner, since when dealing with GSN meta-transactions the account sending and
478  * paying for execution may not be the actual sender (as far as an application
479  * is concerned).
480  *
481  * This contract is only required for intermediate, library-like contracts.
482  */
483 abstract contract Context {
484     function _msgSender() internal view virtual returns (address payable) {
485         return msg.sender;
486     }
487 
488     function _msgData() internal view virtual returns (bytes memory) {
489         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
490         return msg.data;
491     }
492 }
493 
494 // File: @openzeppelin/contracts/access/Ownable.sol
495 
496 pragma solidity >=0.6.0 <0.8.0;
497 
498 /**
499  * @dev Contract module which provides a basic access control mechanism, where
500  * there is an account (an owner) that can be granted exclusive access to
501  * specific functions.
502  *
503  * By default, the owner account will be the one that deploys the contract. This
504  * can later be changed with {transferOwnership}.
505  *
506  * This module is used through inheritance. It will make available the modifier
507  * `onlyOwner`, which can be applied to your functions to restrict their use to
508  * the owner.
509  */
510 abstract contract Ownable is Context {
511     address private _owner;
512 
513     event OwnershipTransferred(
514         address indexed previousOwner,
515         address indexed newOwner
516     );
517 
518     /**
519      * @dev Initializes the contract setting the deployer as the initial owner.
520      */
521     constructor() internal {
522         address msgSender = _msgSender();
523         _owner = msgSender;
524         emit OwnershipTransferred(address(0), msgSender);
525     }
526 
527     /**
528      * @dev Returns the address of the current owner.
529      */
530     function owner() public view virtual returns (address) {
531         return _owner;
532     }
533 
534     /**
535      * @dev Throws if called by any account other than the owner.
536      */
537     modifier onlyOwner() {
538         require(owner() == _msgSender(), "Ownable: caller is not the owner");
539         _;
540     }
541 
542     /**
543      * @dev Leaves the contract without owner. It will not be possible to call
544      * `onlyOwner` functions anymore. Can only be called by the current owner.
545      *
546      * NOTE: Renouncing ownership will leave the contract without an owner,
547      * thereby removing any functionality that is only available to the owner.
548      */
549     function renounceOwnership() public virtual onlyOwner {
550         emit OwnershipTransferred(_owner, address(0));
551         _owner = address(0);
552     }
553 
554     /**
555      * @dev Transfers ownership of the contract to a new account (`newOwner`).
556      * Can only be called by the current owner.
557      */
558     function transferOwnership(address newOwner) public virtual onlyOwner {
559         require(
560             newOwner != address(0),
561             "Ownable: new owner is the zero address"
562         );
563         emit OwnershipTransferred(_owner, newOwner);
564         _owner = newOwner;
565     }
566 }
567 
568 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
569 
570 pragma solidity >=0.6.0 <0.8.0;
571 
572 /**
573  * @dev Interface of the ERC20 standard as defined in the EIP.
574  */
575 interface IERC20 {
576     /**
577      * @dev Returns the amount of tokens in existence.
578      */
579     function totalSupply() external view returns (uint256);
580 
581     /**
582      * @dev Returns the amount of tokens owned by `account`.
583      */
584     function balanceOf(address account) external view returns (uint256);
585 
586     /**
587      * @dev Moves `amount` tokens from the caller's account to `recipient`.
588      *
589      * Returns a boolean value indicating whether the operation succeeded.
590      *
591      * Emits a {Transfer} event.
592      */
593     function transfer(address recipient, uint256 amount)
594         external
595         returns (bool);
596 
597     /**
598      * @dev Returns the remaining number of tokens that `spender` will be
599      * allowed to spend on behalf of `owner` through {transferFrom}. This is
600      * zero by default.
601      *
602      * This value changes when {approve} or {transferFrom} are called.
603      */
604     function allowance(address owner, address spender)
605         external
606         view
607         returns (uint256);
608 
609     /**
610      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
611      *
612      * Returns a boolean value indicating whether the operation succeeded.
613      *
614      * IMPORTANT: Beware that changing an allowance with this method brings the risk
615      * that someone may use both the old and the new allowance by unfortunate
616      * transaction ordering. One possible solution to mitigate this race
617      * condition is to first reduce the spender's allowance to 0 and set the
618      * desired value afterwards:
619      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
620      *
621      * Emits an {Approval} event.
622      */
623     function approve(address spender, uint256 amount) external returns (bool);
624 
625     /**
626      * @dev Moves `amount` tokens from `sender` to `recipient` using the
627      * allowance mechanism. `amount` is then deducted from the caller's
628      * allowance.
629      *
630      * Returns a boolean value indicating whether the operation succeeded.
631      *
632      * Emits a {Transfer} event.
633      */
634     function transferFrom(
635         address sender,
636         address recipient,
637         uint256 amount
638     ) external returns (bool);
639 
640     /**
641      * @dev Emitted when `value` tokens are moved from one account (`from`) to
642      * another (`to`).
643      *
644      * Note that `value` may be zero.
645      */
646     event Transfer(address indexed from, address indexed to, uint256 value);
647 
648     /**
649      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
650      * a call to {approve}. `value` is the new allowance.
651      */
652     event Approval(
653         address indexed owner,
654         address indexed spender,
655         uint256 value
656     );
657 }
658 
659 // File: @openzeppelin/contracts/math/SafeMath.sol
660 
661 pragma solidity >=0.6.0 <0.8.0;
662 
663 /**
664  * @dev Wrappers over Solidity's arithmetic operations with added overflow
665  * checks.
666  *
667  * Arithmetic operations in Solidity wrap on overflow. This can easily result
668  * in bugs, because programmers usually assume that an overflow raises an
669  * error, which is the standard behavior in high level programming languages.
670  * `SafeMath` restores this intuition by reverting the transaction when an
671  * operation overflows.
672  *
673  * Using this library instead of the unchecked operations eliminates an entire
674  * class of bugs, so it's recommended to use it always.
675  */
676 library SafeMath {
677     /**
678      * @dev Returns the addition of two unsigned integers, with an overflow flag.
679      *
680      * _Available since v3.4._
681      */
682     function tryAdd(uint256 a, uint256 b)
683         internal
684         pure
685         returns (bool, uint256)
686     {
687         uint256 c = a + b;
688         if (c < a) return (false, 0);
689         return (true, c);
690     }
691 
692     /**
693      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
694      *
695      * _Available since v3.4._
696      */
697     function trySub(uint256 a, uint256 b)
698         internal
699         pure
700         returns (bool, uint256)
701     {
702         if (b > a) return (false, 0);
703         return (true, a - b);
704     }
705 
706     /**
707      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
708      *
709      * _Available since v3.4._
710      */
711     function tryMul(uint256 a, uint256 b)
712         internal
713         pure
714         returns (bool, uint256)
715     {
716         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
717         // benefit is lost if 'b' is also tested.
718         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
719         if (a == 0) return (true, 0);
720         uint256 c = a * b;
721         if (c / a != b) return (false, 0);
722         return (true, c);
723     }
724 
725     /**
726      * @dev Returns the division of two unsigned integers, with a division by zero flag.
727      *
728      * _Available since v3.4._
729      */
730     function tryDiv(uint256 a, uint256 b)
731         internal
732         pure
733         returns (bool, uint256)
734     {
735         if (b == 0) return (false, 0);
736         return (true, a / b);
737     }
738 
739     /**
740      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
741      *
742      * _Available since v3.4._
743      */
744     function tryMod(uint256 a, uint256 b)
745         internal
746         pure
747         returns (bool, uint256)
748     {
749         if (b == 0) return (false, 0);
750         return (true, a % b);
751     }
752 
753     /**
754      * @dev Returns the addition of two unsigned integers, reverting on
755      * overflow.
756      *
757      * Counterpart to Solidity's `+` operator.
758      *
759      * Requirements:
760      *
761      * - Addition cannot overflow.
762      */
763     function add(uint256 a, uint256 b) internal pure returns (uint256) {
764         uint256 c = a + b;
765         require(c >= a, "SafeMath: addition overflow");
766         return c;
767     }
768 
769     /**
770      * @dev Returns the subtraction of two unsigned integers, reverting on
771      * overflow (when the result is negative).
772      *
773      * Counterpart to Solidity's `-` operator.
774      *
775      * Requirements:
776      *
777      * - Subtraction cannot overflow.
778      */
779     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
780         require(b <= a, "SafeMath: subtraction overflow");
781         return a - b;
782     }
783 
784     /**
785      * @dev Returns the multiplication of two unsigned integers, reverting on
786      * overflow.
787      *
788      * Counterpart to Solidity's `*` operator.
789      *
790      * Requirements:
791      *
792      * - Multiplication cannot overflow.
793      */
794     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
795         if (a == 0) return 0;
796         uint256 c = a * b;
797         require(c / a == b, "SafeMath: multiplication overflow");
798         return c;
799     }
800 
801     /**
802      * @dev Returns the integer division of two unsigned integers, reverting on
803      * division by zero. The result is rounded towards zero.
804      *
805      * Counterpart to Solidity's `/` operator. Note: this function uses a
806      * `revert` opcode (which leaves remaining gas untouched) while Solidity
807      * uses an invalid opcode to revert (consuming all remaining gas).
808      *
809      * Requirements:
810      *
811      * - The divisor cannot be zero.
812      */
813     function div(uint256 a, uint256 b) internal pure returns (uint256) {
814         require(b > 0, "SafeMath: division by zero");
815         return a / b;
816     }
817 
818     /**
819      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
820      * reverting when dividing by zero.
821      *
822      * Counterpart to Solidity's `%` operator. This function uses a `revert`
823      * opcode (which leaves remaining gas untouched) while Solidity uses an
824      * invalid opcode to revert (consuming all remaining gas).
825      *
826      * Requirements:
827      *
828      * - The divisor cannot be zero.
829      */
830     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
831         require(b > 0, "SafeMath: modulo by zero");
832         return a % b;
833     }
834 
835     /**
836      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
837      * overflow (when the result is negative).
838      *
839      * CAUTION: This function is deprecated because it requires allocating memory for the error
840      * message unnecessarily. For custom revert reasons use {trySub}.
841      *
842      * Counterpart to Solidity's `-` operator.
843      *
844      * Requirements:
845      *
846      * - Subtraction cannot overflow.
847      */
848     function sub(
849         uint256 a,
850         uint256 b,
851         string memory errorMessage
852     ) internal pure returns (uint256) {
853         require(b <= a, errorMessage);
854         return a - b;
855     }
856 
857     /**
858      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
859      * division by zero. The result is rounded towards zero.
860      *
861      * CAUTION: This function is deprecated because it requires allocating memory for the error
862      * message unnecessarily. For custom revert reasons use {tryDiv}.
863      *
864      * Counterpart to Solidity's `/` operator. Note: this function uses a
865      * `revert` opcode (which leaves remaining gas untouched) while Solidity
866      * uses an invalid opcode to revert (consuming all remaining gas).
867      *
868      * Requirements:
869      *
870      * - The divisor cannot be zero.
871      */
872     function div(
873         uint256 a,
874         uint256 b,
875         string memory errorMessage
876     ) internal pure returns (uint256) {
877         require(b > 0, errorMessage);
878         return a / b;
879     }
880 
881     /**
882      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
883      * reverting with custom message when dividing by zero.
884      *
885      * CAUTION: This function is deprecated because it requires allocating memory for the error
886      * message unnecessarily. For custom revert reasons use {tryMod}.
887      *
888      * Counterpart to Solidity's `%` operator. This function uses a `revert`
889      * opcode (which leaves remaining gas untouched) while Solidity uses an
890      * invalid opcode to revert (consuming all remaining gas).
891      *
892      * Requirements:
893      *
894      * - The divisor cannot be zero.
895      */
896     function mod(
897         uint256 a,
898         uint256 b,
899         string memory errorMessage
900     ) internal pure returns (uint256) {
901         require(b > 0, errorMessage);
902         return a % b;
903     }
904 }
905 
906 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
907 
908 pragma solidity >=0.6.0 <0.8.0;
909 
910 /**
911  * @dev Implementation of the {IERC20} interface.
912  *
913  * This implementation is agnostic to the way tokens are created. This means
914  * that a supply mechanism has to be added in a derived contract using {_mint}.
915  * For a generic mechanism see {ERC20PresetMinterPauser}.
916  *
917  * TIP: For a detailed writeup see our guide
918  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
919  * to implement supply mechanisms].
920  *
921  * We have followed general OpenZeppelin guidelines: functions revert instead
922  * of returning `false` on failure. This behavior is nonetheless conventional
923  * and does not conflict with the expectations of ERC20 applications.
924  *
925  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
926  * This allows applications to reconstruct the allowance for all accounts just
927  * by listening to said events. Other implementations of the EIP may not emit
928  * these events, as it isn't required by the specification.
929  *
930  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
931  * functions have been added to mitigate the well-known issues around setting
932  * allowances. See {IERC20-approve}.
933  */
934 contract ERC20 is Context, IERC20 {
935     using SafeMath for uint256;
936 
937     mapping(address => uint256) private _balances;
938 
939     mapping(address => mapping(address => uint256)) private _allowances;
940 
941     uint256 private _totalSupply;
942 
943     string private _name;
944     string private _symbol;
945     uint8 private _decimals;
946 
947     /**
948      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
949      * a default value of 18.
950      *
951      * To select a different value for {decimals}, use {_setupDecimals}.
952      *
953      * All three of these values are immutable: they can only be set once during
954      * construction.
955      */
956     constructor(string memory name_, string memory symbol_) public {
957         _name = name_;
958         _symbol = symbol_;
959         _decimals = 18;
960     }
961 
962     /**
963      * @dev Returns the name of the token.
964      */
965     function name() public view virtual returns (string memory) {
966         return _name;
967     }
968 
969     /**
970      * @dev Returns the symbol of the token, usually a shorter version of the
971      * name.
972      */
973     function symbol() public view virtual returns (string memory) {
974         return _symbol;
975     }
976 
977     /**
978      * @dev Returns the number of decimals used to get its user representation.
979      * For example, if `decimals` equals `2`, a balance of `505` tokens should
980      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
981      *
982      * Tokens usually opt for a value of 18, imitating the relationship between
983      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
984      * called.
985      *
986      * NOTE: This information is only used for _display_ purposes: it in
987      * no way affects any of the arithmetic of the contract, including
988      * {IERC20-balanceOf} and {IERC20-transfer}.
989      */
990     function decimals() public view virtual returns (uint8) {
991         return _decimals;
992     }
993 
994     /**
995      * @dev See {IERC20-totalSupply}.
996      */
997     function totalSupply() public view virtual override returns (uint256) {
998         return _totalSupply;
999     }
1000 
1001     /**
1002      * @dev See {IERC20-balanceOf}.
1003      */
1004     function balanceOf(address account)
1005         public
1006         view
1007         virtual
1008         override
1009         returns (uint256)
1010     {
1011         return _balances[account];
1012     }
1013 
1014     /**
1015      * @dev See {IERC20-transfer}.
1016      *
1017      * Requirements:
1018      *
1019      * - `recipient` cannot be the zero address.
1020      * - the caller must have a balance of at least `amount`.
1021      */
1022     function transfer(address recipient, uint256 amount)
1023         public
1024         virtual
1025         override
1026         returns (bool)
1027     {
1028         _transfer(_msgSender(), recipient, amount);
1029         return true;
1030     }
1031 
1032     /**
1033      * @dev See {IERC20-allowance}.
1034      */
1035     function allowance(address owner, address spender)
1036         public
1037         view
1038         virtual
1039         override
1040         returns (uint256)
1041     {
1042         return _allowances[owner][spender];
1043     }
1044 
1045     /**
1046      * @dev See {IERC20-approve}.
1047      *
1048      * Requirements:
1049      *
1050      * - `spender` cannot be the zero address.
1051      */
1052     function approve(address spender, uint256 amount)
1053         public
1054         virtual
1055         override
1056         returns (bool)
1057     {
1058         _approve(_msgSender(), spender, amount);
1059         return true;
1060     }
1061 
1062     /**
1063      * @dev See {IERC20-transferFrom}.
1064      *
1065      * Emits an {Approval} event indicating the updated allowance. This is not
1066      * required by the EIP. See the note at the beginning of {ERC20}.
1067      *
1068      * Requirements:
1069      *
1070      * - `sender` and `recipient` cannot be the zero address.
1071      * - `sender` must have a balance of at least `amount`.
1072      * - the caller must have allowance for ``sender``'s tokens of at least
1073      * `amount`.
1074      */
1075     function transferFrom(
1076         address sender,
1077         address recipient,
1078         uint256 amount
1079     ) public virtual override returns (bool) {
1080         _transfer(sender, recipient, amount);
1081         _approve(
1082             sender,
1083             _msgSender(),
1084             _allowances[sender][_msgSender()].sub(
1085                 amount,
1086                 "ERC20: transfer amount exceeds allowance"
1087             )
1088         );
1089         return true;
1090     }
1091 
1092     /**
1093      * @dev Atomically increases the allowance granted to `spender` by the caller.
1094      *
1095      * This is an alternative to {approve} that can be used as a mitigation for
1096      * problems described in {IERC20-approve}.
1097      *
1098      * Emits an {Approval} event indicating the updated allowance.
1099      *
1100      * Requirements:
1101      *
1102      * - `spender` cannot be the zero address.
1103      */
1104     function increaseAllowance(address spender, uint256 addedValue)
1105         public
1106         virtual
1107         returns (bool)
1108     {
1109         _approve(
1110             _msgSender(),
1111             spender,
1112             _allowances[_msgSender()][spender].add(addedValue)
1113         );
1114         return true;
1115     }
1116 
1117     /**
1118      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1119      *
1120      * This is an alternative to {approve} that can be used as a mitigation for
1121      * problems described in {IERC20-approve}.
1122      *
1123      * Emits an {Approval} event indicating the updated allowance.
1124      *
1125      * Requirements:
1126      *
1127      * - `spender` cannot be the zero address.
1128      * - `spender` must have allowance for the caller of at least
1129      * `subtractedValue`.
1130      */
1131     function decreaseAllowance(address spender, uint256 subtractedValue)
1132         public
1133         virtual
1134         returns (bool)
1135     {
1136         _approve(
1137             _msgSender(),
1138             spender,
1139             _allowances[_msgSender()][spender].sub(
1140                 subtractedValue,
1141                 "ERC20: decreased allowance below zero"
1142             )
1143         );
1144         return true;
1145     }
1146 
1147     /**
1148      * @dev Moves tokens `amount` from `sender` to `recipient`.
1149      *
1150      * This is internal function is equivalent to {transfer}, and can be used to
1151      * e.g. implement automatic token fees, slashing mechanisms, etc.
1152      *
1153      * Emits a {Transfer} event.
1154      *
1155      * Requirements:
1156      *
1157      * - `sender` cannot be the zero address.
1158      * - `recipient` cannot be the zero address.
1159      * - `sender` must have a balance of at least `amount`.
1160      */
1161     function _transfer(
1162         address sender,
1163         address recipient,
1164         uint256 amount
1165     ) internal virtual {
1166         require(sender != address(0), "ERC20: transfer from the zero address");
1167         require(recipient != address(0), "ERC20: transfer to the zero address");
1168 
1169         _beforeTokenTransfer(sender, recipient, amount);
1170 
1171         _balances[sender] = _balances[sender].sub(
1172             amount,
1173             "ERC20: transfer amount exceeds balance"
1174         );
1175         _balances[recipient] = _balances[recipient].add(amount);
1176         emit Transfer(sender, recipient, amount);
1177     }
1178 
1179     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1180      * the total supply.
1181      *
1182      * Emits a {Transfer} event with `from` set to the zero address.
1183      *
1184      * Requirements:
1185      *
1186      * - `to` cannot be the zero address.
1187      */
1188     function _mint(address account, uint256 amount) internal virtual {
1189         require(account != address(0), "ERC20: mint to the zero address");
1190 
1191         _beforeTokenTransfer(address(0), account, amount);
1192 
1193         _totalSupply = _totalSupply.add(amount);
1194         _balances[account] = _balances[account].add(amount);
1195         emit Transfer(address(0), account, amount);
1196     }
1197 
1198     /**
1199      * @dev Destroys `amount` tokens from `account`, reducing the
1200      * total supply.
1201      *
1202      * Emits a {Transfer} event with `to` set to the zero address.
1203      *
1204      * Requirements:
1205      *
1206      * - `account` cannot be the zero address.
1207      * - `account` must have at least `amount` tokens.
1208      */
1209     function _burn(address account, uint256 amount) internal virtual {
1210         require(account != address(0), "ERC20: burn from the zero address");
1211 
1212         _beforeTokenTransfer(account, address(0), amount);
1213 
1214         _balances[account] = _balances[account].sub(
1215             amount,
1216             "ERC20: burn amount exceeds balance"
1217         );
1218         _totalSupply = _totalSupply.sub(amount);
1219         emit Transfer(account, address(0), amount);
1220     }
1221 
1222     /**
1223      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1224      *
1225      * This internal function is equivalent to `approve`, and can be used to
1226      * e.g. set automatic allowances for certain subsystems, etc.
1227      *
1228      * Emits an {Approval} event.
1229      *
1230      * Requirements:
1231      *
1232      * - `owner` cannot be the zero address.
1233      * - `spender` cannot be the zero address.
1234      */
1235     function _approve(
1236         address owner,
1237         address spender,
1238         uint256 amount
1239     ) internal virtual {
1240         require(owner != address(0), "ERC20: approve from the zero address");
1241         require(spender != address(0), "ERC20: approve to the zero address");
1242 
1243         _allowances[owner][spender] = amount;
1244         emit Approval(owner, spender, amount);
1245     }
1246 
1247     /**
1248      * @dev Sets {decimals} to a value other than the default one of 18.
1249      *
1250      * WARNING: This function should only be called from the constructor. Most
1251      * applications that interact with token contracts will not expect
1252      * {decimals} to ever change, and may work incorrectly if it does.
1253      */
1254     function _setupDecimals(uint8 decimals_) internal virtual {
1255         _decimals = decimals_;
1256     }
1257 
1258     /**
1259      * @dev Hook that is called before any transfer of tokens. This includes
1260      * minting and burning.
1261      *
1262      * Calling conditions:
1263      *
1264      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1265      * will be to transferred to `to`.
1266      * - when `from` is zero, `amount` tokens will be minted for `to`.
1267      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1268      * - `from` and `to` are never both zero.
1269      *
1270      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1271      */
1272     function _beforeTokenTransfer(
1273         address from,
1274         address to,
1275         uint256 amount
1276     ) internal virtual {}
1277 }
1278 
1279 // File: contracts/interfaces/ILiquidVestingToken.sol
1280 
1281 pragma solidity =0.7.6;
1282 
1283 interface ILiquidVestingToken {
1284     enum AddType {
1285         MerkleTree,
1286         Airdrop
1287     }
1288 
1289     function initialize(
1290         string memory _name,
1291         string memory _symbol,
1292         uint8 _decimals,
1293         address _owner,
1294         address _factory,
1295         address _redeemToken,
1296         uint256 _activationTimestamp,
1297         uint256 _redeemTimestamp,
1298         AddType _type
1299     ) external;
1300 
1301     function overrideFee(uint256 _newFee) external;
1302 
1303     function addRecipient(address _recipient, uint256 _amount) external;
1304 
1305     function addRecipients(
1306         address[] memory _recipients,
1307         uint256[] memory _amounts
1308     ) external;
1309 
1310     function addMerkleRoot(
1311         bytes32 _merkleRoot,
1312         uint256 _totalAmount,
1313         uint8 _v,
1314         bytes32 _r,
1315         bytes32 _s
1316     ) external;
1317 
1318     function claimTokensByMerkleProof(
1319         bytes32[] memory _proof,
1320         uint256 _rootId,
1321         address _recipient,
1322         uint256 _amount
1323     ) external;
1324 
1325     function claimProjectTokensByFeeCollector() external;
1326 
1327     function redeem(address _recipient, uint256 _amount) external;
1328 }
1329 
1330 // File: contracts/interfaces/ILiquidVestingTokenFactory.sol
1331 
1332 pragma solidity =0.7.6;
1333 pragma abicoder v2;
1334 
1335 interface ILiquidVestingTokenFactory {
1336     function merkleRootSigner() external view returns (address);
1337 
1338     function feeCollector() external view returns (address);
1339 
1340     function fee() external view returns (uint256);
1341 
1342     function getMinFee() external pure returns (uint256);
1343 
1344     function getMaxFee() external pure returns (uint256);
1345 
1346     function setMerkleRootSigner(address _newMerkleRootSigner) external;
1347 
1348     function setFeeCollector(address _newFeeCollector) external;
1349 
1350     function setFee(uint256 _fee) external;
1351 
1352     function implementation() external view returns (address);
1353 
1354     function createLiquidVestingToken(
1355         string[] memory name,
1356         string[] memory symbol,
1357         address redeemToken,
1358         uint256[] memory activationTimestamp,
1359         uint256[] memory redeemTimestamp,
1360         ILiquidVestingToken.AddType addRecipientsType
1361     ) external;
1362 }
1363 
1364 // File: contracts/LiquidVestingTokenFactory.sol
1365 
1366 pragma solidity =0.7.6;
1367 
1368 /**
1369  * @title LiquidVestingTokenFactory
1370  * @dev The LiquidVestingTokenFactory contract can be used to create
1371  * vesting contracts for any ERC20 token.
1372  */
1373 contract LiquidVestingTokenFactory is Ownable, ILiquidVestingTokenFactory {
1374     uint256 public constant MIN_FEE = 0;
1375     uint256 public constant MAX_FEE = 5000;
1376 
1377     address private tokenImplementation;
1378     address public override merkleRootSigner;
1379     address public override feeCollector;
1380     uint256 public override fee;
1381 
1382     event VestingTokenCreated(
1383         address indexed redeemToken,
1384         address vestingToken
1385     );
1386 
1387     mapping(address => address[]) public vestingTokensByOriginalToken;
1388 
1389     /**
1390      * @dev Creates a vesting token factory contract.
1391      * @param _tokenImplementation Address of LiquidVestingToken contract implementation.
1392      * @param _merkleRootSigner Address of Merkle root signer.
1393      * @param _feeCollector Address of fee collector.
1394      * @param _fee Fee value.
1395      */
1396     constructor(
1397         address _tokenImplementation,
1398         address _merkleRootSigner,
1399         address _feeCollector,
1400         uint256 _fee
1401     ) {
1402         require(
1403             Address.isContract(_tokenImplementation),
1404             "Implementation is not a contract"
1405         );
1406         require(
1407             _merkleRootSigner != address(0),
1408             "Merkle root signer cannot be zero address"
1409         );
1410         require(
1411             _feeCollector != address(0),
1412             "Fee collector cannot be zero address"
1413         );
1414         require(_fee >= MIN_FEE && _fee <= MAX_FEE, "Fee goes beyond rank");
1415 
1416         merkleRootSigner = _merkleRootSigner;
1417         feeCollector = _feeCollector;
1418         fee = _fee;
1419         tokenImplementation = _tokenImplementation;
1420     }
1421 
1422     /**
1423      * @dev Set address of Merkle root signer.
1424      * @param _newMerkleRootSigner Address of signer.
1425      */
1426     function setMerkleRootSigner(address _newMerkleRootSigner)
1427         external
1428         override
1429         onlyOwner
1430     {
1431         require(
1432             _newMerkleRootSigner != address(0),
1433             "Merkle root signer cannot be zero address"
1434         );
1435 
1436         merkleRootSigner = _newMerkleRootSigner;
1437     }
1438 
1439     /**
1440      * @dev Set address of fee collector.
1441      * @param _newFeeCollector Address of fee collector.
1442      */
1443     function setFeeCollector(address _newFeeCollector)
1444         external
1445         override
1446         onlyOwner
1447     {
1448         require(
1449             _newFeeCollector != address(0),
1450             "Fee collector cannot be zero address"
1451         );
1452 
1453         feeCollector = _newFeeCollector;
1454     }
1455 
1456     /**
1457      * @dev Set a new fee in range 0% - 5%.
1458      * For example, if a fee is 5% it should be 5000 (5 * 10**3).
1459      * @param _fee Amount of fee.
1460      */
1461     function setFee(uint256 _fee) external override {
1462         require(_msgSender() == feeCollector, "Caller is not fee collector");
1463         require(_fee >= MIN_FEE && _fee <= MAX_FEE, "Fee goes beyond rank");
1464 
1465         fee = _fee;
1466     }
1467 
1468     /**
1469      * @dev Get implementation of LiquidVestingToken contract.
1470      */
1471     function implementation() external view override returns (address) {
1472         return tokenImplementation;
1473     }
1474 
1475     /**
1476      * @dev Get min fee value.
1477      */
1478     function getMinFee() external pure override returns (uint256) {
1479         return MIN_FEE;
1480     }
1481 
1482     /**
1483      * @dev Get max fee value.
1484      */
1485     function getMaxFee() external pure override returns (uint256) {
1486         return MAX_FEE;
1487     }
1488 
1489     /**
1490      * @dev Creates new LiquidVestingToken contracts.
1491      * @param name Array of token names.
1492      * @param symbol Array of token symbols.
1493      * @param redeemToken Address of redeem token that will be locked by vesting period.
1494      * @param activationTimestamp Array of timestamps that allow starting transfers of vesting tokens.
1495      * @param redeemTimestamp Array of timestamps that allow redeeming tokens.
1496      * @param addRecipientsType Type of saving recipients of vesting tokens.
1497      */
1498     function createLiquidVestingToken(
1499         string[] memory name,
1500         string[] memory symbol,
1501         address redeemToken,
1502         uint256[] memory activationTimestamp,
1503         uint256[] memory redeemTimestamp,
1504         ILiquidVestingToken.AddType addRecipientsType
1505     ) public override {
1506         require(
1507             redeemToken != address(0),
1508             "Company token cannot be zero address"
1509         );
1510         require(
1511             name.length == symbol.length &&
1512                 name.length == activationTimestamp.length &&
1513                 name.length == redeemTimestamp.length,
1514             "Arrays length should be same"
1515         );
1516 
1517         uint8 decimals = ERC20(redeemToken).decimals();
1518         for (uint256 i = 0; i < name.length; i++) {
1519             require(
1520                 activationTimestamp[i] <= redeemTimestamp[i],
1521                 "activationTimestamp cannot be more than redeemTimestamp"
1522             );
1523 
1524             BeaconProxy token = new BeaconProxy(address(this), "");
1525             ILiquidVestingToken(address(token)).initialize(
1526                 name[i],
1527                 symbol[i],
1528                 decimals,
1529                 _msgSender(),
1530                 address(this),
1531                 redeemToken,
1532                 activationTimestamp[i],
1533                 redeemTimestamp[i],
1534                 addRecipientsType
1535             );
1536 
1537             vestingTokensByOriginalToken[redeemToken].push(address(token));
1538             emit VestingTokenCreated(redeemToken, address(token));
1539         }
1540     }
1541 }