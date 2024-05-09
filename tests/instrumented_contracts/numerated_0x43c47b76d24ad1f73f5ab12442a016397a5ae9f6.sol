1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.4;
3 
4 /**
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes calldata) {
20         return msg.data;
21     }
22 }
23 
24 /**
25  * @dev Contract module which provides a basic access control mechanism, where
26  * there is an account (an owner) that can be granted exclusive access to
27  * specific functions.
28  *
29  * By default, the owner account will be the one that deploys the contract. This
30  * can later be changed with {transferOwnership}.
31  *
32  * This module is used through inheritance. It will make available the modifier
33  * `onlyOwner`, which can be applied to your functions to restrict their use to
34  * the owner.
35  */
36 abstract contract Ownable is Context {
37     address private _owner;
38 
39     event OwnershipTransferred(
40         address indexed previousOwner,
41         address indexed newOwner
42     );
43 
44     /**
45      * @dev Initializes the contract setting the deployer as the initial owner.
46      */
47     constructor() {
48         _transferOwnership(_msgSender());
49     }
50 
51     /**
52      * @dev Returns the address of the current owner.
53      */
54     function owner() public view virtual returns (address) {
55         return _owner;
56     }
57 
58     /**
59      * @dev Throws if called by any account other than the owner.
60      */
61     modifier onlyOwner() {
62         require(owner() == _msgSender(), "Ownable: caller is not the owner");
63         _;
64     }
65 
66     /**
67      * @dev Leaves the contract without owner. It will not be possible to call
68      * `onlyOwner` functions anymore. Can only be called by the current owner.
69      *
70      * NOTE: Renouncing ownership will leave the contract without an owner,
71      * thereby removing any functionality that is only available to the owner.
72      */
73     function renounceOwnership() public virtual onlyOwner {
74         _transferOwnership(address(0));
75     }
76 
77     /**
78      * @dev Transfers ownership of the contract to a new account (`newOwner`).
79      * Can only be called by the current owner.
80      */
81     function transferOwnership(address newOwner) public virtual onlyOwner {
82         require(
83             newOwner != address(0),
84             "Ownable: new owner is the zero address"
85         );
86         _transferOwnership(newOwner);
87     }
88 
89     /**
90      * @dev Transfers ownership of the contract to a new account (`newOwner`).
91      * Internal function without access restriction.
92      */
93     function _transferOwnership(address newOwner) internal virtual {
94         address oldOwner = _owner;
95         _owner = newOwner;
96         emit OwnershipTransferred(oldOwner, newOwner);
97     }
98 }
99 
100 interface IERC20 {
101 
102     /**
103      * @dev Returns the amount of tokens in existence.
104      */
105     function totalSupply() external view returns (uint256);
106 
107     /**
108      * @dev Returns the amount of tokens owned by `account`.
109      */
110     function balanceOf(address account) external view returns (uint256);
111 
112     /**
113      * @dev Moves `amount` tokens from the caller's account to `recipient`.
114      *
115      * Returns a boolean value indicating whether the operation succeeded.
116      *
117      * Emits a {Transfer} event.
118      */
119     function transfer(
120         address recipient,
121         uint256 amount
122     ) external returns (bool);
123 
124     /**
125      * @dev Returns the remaining number of tokens that `spender` will be
126      * allowed to spend on behalf of `owner` through {transferFrom}. This is
127      * zero by default.
128      *
129      * This value changes when {approve} or {transferFrom} are called.
130      */
131     function allowance(
132         address owner,
133         address spender
134     ) external view returns (uint256);
135 
136     /**
137      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
138      *
139      * Returns a boolean value indicating whether the operation succeeded.
140      *
141      * IMPORTANT: Beware that changing an allowance with this method brings the risk
142      * that someone may use both the old and the new allowance by unfortunate
143      * transaction ordering. One possible solution to mitigate this race
144      * condition is to first reduce the spender's allowance to 0 and set the
145      * desired value afterwards:
146      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
147      *
148      * Emits an {Approval} event.
149      */
150     function approve(address spender, uint256 amount) external returns (bool);
151 
152     /**
153      * @dev Moves `amount` tokens from `sender` to `recipient` using the
154      * allowance mechanism. `amount` is then deducted from the caller's
155      * allowance.
156      *
157      * Returns a boolean value indicating whether the operation succeeded.
158      *
159      * Emits a {Transfer} event.
160      */
161     function transferFrom(
162         address sender,
163         address recipient,
164         uint256 amount
165     ) external returns (bool);
166 
167     /**
168      * @dev Emitted when `value` tokens are moved from one account (`from`) to
169      * another (`to`).
170      *
171      * Note that `value` may be zero.
172      */
173     event Transfer(address indexed from, address indexed to, uint256 value);
174 
175     /**
176      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
177      * a call to {approve}. `value` is the new allowance.
178      */
179     event Approval(
180         address indexed owner,
181         address indexed spender,
182         uint256 value
183     );
184 }
185 /**
186  * @dev Collection of functions related to the address type
187  */
188 library Address {
189     /**
190      * @dev Returns true if `account` is a contract.
191      *
192      * [IMPORTANT]
193      * ====
194      * It is unsafe to assume that an address for which this function returns
195      * false is an externally-owned account (EOA) and not a contract.
196      *
197      * Among others, `isContract` will return false for the following
198      * types of addresses:
199      *
200      *  - an externally-owned account
201      *  - a contract in construction
202      *  - an address where a contract will be created
203      *  - an address where a contract lived, but was destroyed
204      * ====
205      */
206     function isContract(address account) internal view returns (bool) {
207         // This method relies on extcodesize, which returns 0 for contracts in
208         // construction, since the code is only stored at the end of the
209         // constructor execution.
210 
211         uint256 size;
212         assembly {
213             size := extcodesize(account)
214         }
215         return size > 0;
216     }
217 
218     /**
219      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
220      * `recipient`, forwarding all available gas and reverting on errors.
221      *
222      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
223      * of certain opcodes, possibly making contracts go over the 2300 gas limit
224      * imposed by `transfer`, making them unable to receive funds via
225      * `transfer`. {sendValue} removes this limitation.
226      *
227      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
228      *
229      * IMPORTANT: because control is transferred to `recipient`, care must be
230      * taken to not create reentrancy vulnerabilities. Consider using
231      * {ReentrancyGuard} or the
232      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
233      */
234     function sendValue(address payable recipient, uint256 amount) internal {
235         require(
236             address(this).balance >= amount,
237             "Address: insufficient balance"
238         );
239 
240         (bool success, ) = recipient.call{value: amount}("");
241         require(
242             success,
243             "Address: unable to send value, recipient may have reverted"
244         );
245     }
246 
247     /**
248      * @dev Performs a Solidity function call using a low level `call`. A
249      * plain `call` is an unsafe replacement for a function call: use this
250      * function instead.
251      *
252      * If `target` reverts with a revert reason, it is bubbled up by this
253      * function (like regular Solidity function calls).
254      *
255      * Returns the raw returned data. To convert to the expected return value,
256      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
257      *
258      * Requirements:
259      *
260      * - `target` must be a contract.
261      * - calling `target` with `data` must not revert.
262      *
263      * _Available since v3.1._
264      */
265     function functionCall(
266         address target,
267         bytes memory data
268     ) internal returns (bytes memory) {
269         return functionCall(target, data, "Address: low-level call failed");
270     }
271 
272     /**
273      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
274      * `errorMessage` as a fallback revert reason when `target` reverts.
275      *
276      * _Available since v3.1._
277      */
278     function functionCall(
279         address target,
280         bytes memory data,
281         string memory errorMessage
282     ) internal returns (bytes memory) {
283         return functionCallWithValue(target, data, 0, errorMessage);
284     }
285 
286     /**
287      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
288      * but also transferring `value` wei to `target`.
289      *
290      * Requirements:
291      *
292      * - the calling contract must have an ETH balance of at least `value`.
293      * - the called Solidity function must be `payable`.
294      *
295      * _Available since v3.1._
296      */
297     function functionCallWithValue(
298         address target,
299         bytes memory data,
300         uint256 value
301     ) internal returns (bytes memory) {
302         return
303             functionCallWithValue(
304                 target,
305                 data,
306                 value,
307                 "Address: low-level call with value failed"
308             );
309     }
310 
311     /**
312      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
313      * with `errorMessage` as a fallback revert reason when `target` reverts.
314      *
315      * _Available since v3.1._
316      */
317     function functionCallWithValue(
318         address target,
319         bytes memory data,
320         uint256 value,
321         string memory errorMessage
322     ) internal returns (bytes memory) {
323         require(
324             address(this).balance >= value,
325             "Address: insufficient balance for call"
326         );
327         require(isContract(target), "Address: call to non-contract");
328 
329         (bool success, bytes memory returndata) = target.call{value: value}(
330             data
331         );
332         return verifyCallResult(success, returndata, errorMessage);
333     }
334 
335     /**
336      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
337      * but performing a static call.
338      *
339      * _Available since v3.3._
340      */
341     function functionStaticCall(
342         address target,
343         bytes memory data
344     ) internal view returns (bytes memory) {
345         return
346             functionStaticCall(
347                 target,
348                 data,
349                 "Address: low-level static call failed"
350             );
351     }
352 
353     /**
354      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
355      * but performing a static call.
356      *
357      * _Available since v3.3._
358      */
359     function functionStaticCall(
360         address target,
361         bytes memory data,
362         string memory errorMessage
363     ) internal view returns (bytes memory) {
364         require(isContract(target), "Address: static call to non-contract");
365 
366         (bool success, bytes memory returndata) = target.staticcall(data);
367         return verifyCallResult(success, returndata, errorMessage);
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
372      * but performing a delegate call.
373      *
374      * _Available since v3.4._
375      */
376     function functionDelegateCall(
377         address target,
378         bytes memory data
379     ) internal returns (bytes memory) {
380         return
381             functionDelegateCall(
382                 target,
383                 data,
384                 "Address: low-level delegate call failed"
385             );
386     }
387 
388     /**
389      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
390      * but performing a delegate call.
391      *
392      * _Available since v3.4._
393      */
394     function functionDelegateCall(
395         address target,
396         bytes memory data,
397         string memory errorMessage
398     ) internal returns (bytes memory) {
399         require(isContract(target), "Address: delegate call to non-contract");
400 
401         (bool success, bytes memory returndata) = target.delegatecall(data);
402         return verifyCallResult(success, returndata, errorMessage);
403     }
404 
405     /**
406      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
407      * revert reason using the provided one.
408      *
409      * _Available since v4.3._
410      */
411     function verifyCallResult(
412         bool success,
413         bytes memory returndata,
414         string memory errorMessage
415     ) internal pure returns (bytes memory) {
416         if (success) {
417             return returndata;
418         } else {
419             // Look for revert reason and bubble it up if present
420             if (returndata.length > 0) {
421                 // The easiest way to bubble the revert reason is using memory via assembly
422 
423                 assembly {
424                     let returndata_size := mload(returndata)
425                     revert(add(32, returndata), returndata_size)
426                 }
427             } else {
428                 revert(errorMessage);
429             }
430         }
431     }
432 }
433 
434 /**
435  * @title SafeERC20
436  * @dev Wrappers around ERC20 operations that throw on failure (when the token
437  * contract returns false). Tokens that return no value (and instead revert or
438  * throw on failure) are also supported, non-reverting calls are assumed to be
439  * successful.
440  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
441  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
442  */
443 library SafeERC20 {
444     using Address for address;
445 
446     function safeTransfer(IERC20 token, address to, uint256 value) internal {
447         _callOptionalReturn(
448             token,
449             abi.encodeWithSelector(token.transfer.selector, to, value)
450         );
451     }
452 
453     function safeTransferFrom(
454         IERC20 token,
455         address from,
456         address to,
457         uint256 value
458     ) internal {
459         _callOptionalReturn(
460             token,
461             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
462         );
463     }
464 
465     /**
466      * @dev Deprecated. This function has issues similar to the ones found in
467      * {IERC20-approve}, and its usage is discouraged.
468      *
469      * Whenever possible, use {safeIncreaseAllowance} and
470      * {safeDecreaseAllowance} instead.
471      */
472     function safeApprove(
473         IERC20 token,
474         address spender,
475         uint256 value
476     ) internal {
477         // safeApprove should only be called when setting an initial allowance,
478         // or when resetting it to zero. To increase and decrease it, use
479         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
480         require(
481             (value == 0) || (token.allowance(address(this), spender) == 0),
482             "SafeERC20: approve from non-zero to non-zero allowance"
483         );
484         _callOptionalReturn(
485             token,
486             abi.encodeWithSelector(token.approve.selector, spender, value)
487         );
488     }
489 
490     function safeIncreaseAllowance(
491         IERC20 token,
492         address spender,
493         uint256 value
494     ) internal {
495         uint256 newAllowance = token.allowance(address(this), spender) + value;
496         _callOptionalReturn(
497             token,
498             abi.encodeWithSelector(
499                 token.approve.selector,
500                 spender,
501                 newAllowance
502             )
503         );
504     }
505 
506     function safeDecreaseAllowance(
507         IERC20 token,
508         address spender,
509         uint256 value
510     ) internal {
511         unchecked {
512             uint256 oldAllowance = token.allowance(address(this), spender);
513             require(
514                 oldAllowance >= value,
515                 "SafeERC20: decreased allowance below zero"
516             );
517             uint256 newAllowance = oldAllowance - value;
518             _callOptionalReturn(
519                 token,
520                 abi.encodeWithSelector(
521                     token.approve.selector,
522                     spender,
523                     newAllowance
524                 )
525             );
526         }
527     }
528 
529     /**
530      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
531      * on the return value: the return value is optional (but if data is returned, it must not be false).
532      * @param token The token targeted by the call.
533      * @param data The call data (encoded using abi.encode or one of its variants).
534      */
535     function _callOptionalReturn(IERC20 token, bytes memory data) private {
536         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
537         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
538         // the target address contains contract code and also asserts for success in the low-level call.
539 
540         bytes memory returndata = address(token).functionCall(
541             data,
542             "SafeERC20: low-level call failed"
543         );
544         if (returndata.length > 0) {
545             // Return data is optional
546             require(
547                 abi.decode(returndata, (bool)),
548                 "SafeERC20: ERC20 operation did not succeed"
549             );
550         }
551     }
552 }
553 
554 library MovrErrors {
555     string internal constant ADDRESS_0_PROVIDED = "ADDRESS_0_PROVIDED";
556     string internal constant EMPTY_INPUT = "EMPTY_INPUT";
557     string internal constant LENGTH_MISMATCH = "LENGTH_MISMATCH";
558     string internal constant INVALID_VALUE = "INVALID_VALUE";
559     string internal constant INVALID_AMT = "INVALID_AMT";
560 
561     string internal constant IMPL_NOT_FOUND = "IMPL_NOT_FOUND";
562     string internal constant ROUTE_NOT_FOUND = "ROUTE_NOT_FOUND";
563     string internal constant IMPL_NOT_ALLOWED = "IMPL_NOT_ALLOWED";
564     string internal constant ROUTE_NOT_ALLOWED = "ROUTE_NOT_ALLOWED";
565     string internal constant INVALID_CHAIN_DATA = "INVALID_CHAIN_DATA";
566     string internal constant CHAIN_NOT_SUPPORTED = "CHAIN_NOT_SUPPORTED";
567     string internal constant TOKEN_NOT_SUPPORTED = "TOKEN_NOT_SUPPORTED";
568     string internal constant NOT_IMPLEMENTED = "NOT_IMPLEMENTED";
569     string internal constant INVALID_SENDER = "INVALID_SENDER";
570     string internal constant INVALID_BRIDGE_ID = "INVALID_BRIDGE_ID";
571     string internal constant MIDDLEWARE_ACTION_FAILED =
572         "MIDDLEWARE_ACTION_FAILED";
573     string internal constant VALUE_SHOULD_BE_ZERO = "VALUE_SHOULD_BE_ZERO";
574     string internal constant VALUE_SHOULD_NOT_BE_ZERO =
575         "VALUE_SHOULD_NOT_BE_ZERO";
576     string internal constant VALUE_NOT_ENOUGH = "VALUE_NOT_ENOUGH";
577     string internal constant VALUE_NOT_EQUAL_TO_AMOUNT =
578         "VALUE_NOT_EQUAL_TO_AMOUNT";
579 }
580 
581 // import "./helpers/errors.sol";
582 
583 /**
584 @title Abstract Implementation Contract.
585 @notice All Bridge Implementation will follow this interface.
586 */
587 abstract contract ImplBase is Ownable {
588     using SafeERC20 for IERC20;
589     address public registry;
590     address public constant NATIVE_TOKEN_ADDRESS =
591         address(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
592     event UpdateRegistryAddress(address indexed registryAddress);
593 
594     constructor(address _registry) Ownable() {
595         registry = _registry;
596     }
597 
598     modifier onlyRegistry() {
599         require(msg.sender == registry, MovrErrors.INVALID_SENDER);
600         _;
601     }
602 
603     function updateRegistryAddress(address newRegistry) external onlyOwner {
604         registry = newRegistry;
605         emit UpdateRegistryAddress(newRegistry);
606     }
607 
608     function rescueFunds(
609         address token,
610         address userAddress,
611         uint256 amount
612     ) external onlyOwner {
613         IERC20(token).safeTransfer(userAddress, amount);
614     }
615 
616     function outboundTransferTo(
617         uint256 _amount,
618         address _from,
619         address _receiverAddress,
620         address _token,
621         uint256 _toChainId,
622         bytes memory _extraData
623     ) external payable virtual;
624 }
625 
626 /**
627 // @title Abstract Contract for middleware services.
628 // @notice All middleware services will follow this interface.
629 */
630 abstract contract MiddlewareImplBase is Ownable {
631     using SafeERC20 for IERC20;
632     address public immutable registry;
633 
634     /// @notice only registry address is required.
635     constructor(address _registry) Ownable() {
636         registry = _registry;
637     }
638 
639     modifier onlyRegistry() {
640         require(msg.sender == registry, MovrErrors.INVALID_SENDER);
641         _;
642     }
643 
644     function performAction(
645         address from,
646         address fromToken,
647         uint256 amount,
648         address receiverAddress,
649         bytes memory data
650     ) external payable virtual returns (uint256);
651 
652     function rescueFunds(
653         address token,
654         address userAddress,
655         uint256 amount
656     ) external onlyOwner {
657         IERC20(token).safeTransfer(userAddress, amount);
658     }
659 }
660 
661 /**
662 // @title Movr Regisrtry Contract.
663 // @notice This is the main contract that is called using fund movr.
664 // This contains all the bridge and middleware ids.
665 // RouteIds signify which bridge to be used.
666 // Middleware Id signifies which aggregator will be used for swapping if required.
667 */
668 contract Registry is Ownable {
669     using SafeERC20 for IERC20;
670     address private constant NATIVE_TOKEN_ADDRESS =
671         address(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
672 
673     ///@notice RouteData stores information for a route
674     struct RouteData {
675         address route;
676         bool isEnabled;
677         bool isMiddleware;
678     }
679     RouteData[] public routes;
680     modifier onlyExistingRoute(uint256 _routeId) {
681         require(
682             routes[_routeId].route != address(0),
683             MovrErrors.ROUTE_NOT_FOUND
684         );
685         _;
686     }
687 
688     constructor(address _owner) Ownable() {
689         // first route is for direct bridging
690         routes.push(RouteData(NATIVE_TOKEN_ADDRESS, true, true));
691         transferOwnership(_owner);
692     }
693 
694     // Function to receive Ether. msg.data must be empty
695     receive() external payable {}
696 
697     //
698     // Events
699     //
700     event NewRouteAdded(
701         uint256 routeID,
702         address route,
703         bool isEnabled,
704         bool isMiddleware
705     );
706     event RouteDisabled(uint256 routeID);
707     event ExecutionCompleted(
708         uint256 middlewareID,
709         uint256 bridgeID,
710         uint256 inputAmount
711     );
712 
713     /**
714     // @param id route id of middleware to be used
715     // @param optionalNativeAmount is the amount of native asset that the route requires
716     // @param inputToken token address which will be swapped to
717     // BridgeRequest inputToken
718     // @param data to be used by middleware
719     */
720     struct MiddlewareRequest {
721         uint256 id;
722         uint256 optionalNativeAmount;
723         address inputToken;
724         bytes data;
725     }
726 
727     /**
728     // @param id route id of bridge to be used
729     // @param optionalNativeAmount optinal native amount, to be used
730     // when bridge needs native token along with ERC20
731     // @param inputToken token addresss which will be bridged
732     // @param data bridgeData to be used by bridge
733     */
734     struct BridgeRequest {
735         uint256 id;
736         uint256 optionalNativeAmount;
737         address inputToken;
738         bytes data;
739     }
740 
741     /**
742     // @param receiverAddress Recipient address to recieve funds on destination chain
743     // @param toChainId Destination ChainId
744     // @param amount amount to be swapped if middlewareId is 0  it will be
745     // the amount to be bridged
746     // @param middlewareRequest middleware Requestdata
747     // @param bridgeRequest bridge request data
748     */
749     struct UserRequest {
750         address receiverAddress;
751         uint256 toChainId;
752         uint256 amount;
753         MiddlewareRequest middlewareRequest;
754         BridgeRequest bridgeRequest;
755     }
756 
757     /**
758     // @notice function responsible for calling the respective implementation
759     // depending on the bridge to be used
760     // If the middlewareId is 0 then no swap is required,
761     // we can directly bridge the source token to wherever required,
762     // else, we first call the Swap Impl Base for swapping to the required
763     // token and then start the bridging
764     // @dev It is required for isMiddleWare to be true for route 0 as it is a special case
765     // @param _userRequest calldata follows the input data struct
766     */
767     function outboundTransferTo(
768         UserRequest calldata _userRequest
769     ) external payable {
770         require(_userRequest.amount != 0, MovrErrors.INVALID_AMT);
771 
772         // make sure bridge ID is not 0
773         require(
774             _userRequest.bridgeRequest.id != 0,
775             MovrErrors.INVALID_BRIDGE_ID
776         );
777 
778         // make sure bridge input is provided
779         require(
780             _userRequest.bridgeRequest.inputToken != address(0),
781             MovrErrors.ADDRESS_0_PROVIDED
782         );
783 
784         // load middleware info and validate
785         RouteData memory middlewareInfo = routes[
786             _userRequest.middlewareRequest.id
787         ];
788         require(
789             middlewareInfo.route != address(0) &&
790                 middlewareInfo.isEnabled &&
791                 middlewareInfo.isMiddleware,
792             MovrErrors.ROUTE_NOT_ALLOWED
793         );
794 
795         // load bridge info and validate
796         RouteData memory bridgeInfo = routes[_userRequest.bridgeRequest.id];
797         require(
798             bridgeInfo.route != address(0) &&
799                 bridgeInfo.isEnabled &&
800                 !bridgeInfo.isMiddleware,
801             MovrErrors.ROUTE_NOT_ALLOWED
802         );
803 
804         emit ExecutionCompleted(
805             _userRequest.middlewareRequest.id,
806             _userRequest.bridgeRequest.id,
807             _userRequest.amount
808         );
809 
810         // if middlewareID is 0 it means we dont want to perform a action before bridging
811         // and directly want to move for bridging
812         if (_userRequest.middlewareRequest.id == 0) {
813             // perform the bridging
814             ImplBase(bridgeInfo.route).outboundTransferTo{value: msg.value}(
815                 _userRequest.amount,
816                 msg.sender,
817                 _userRequest.receiverAddress,
818                 _userRequest.bridgeRequest.inputToken,
819                 _userRequest.toChainId,
820                 _userRequest.bridgeRequest.data
821             );
822             return;
823         }
824 
825         // we first perform an action using the middleware
826         // we determine if the input asset is a native asset, if yes we pass
827         // the amount as value, else we pass the optionalNativeAmount
828         uint256 _amountOut = MiddlewareImplBase(middlewareInfo.route)
829             .performAction{
830             value: _userRequest.middlewareRequest.inputToken ==
831                 NATIVE_TOKEN_ADDRESS
832                 ? _userRequest.amount +
833                     _userRequest.middlewareRequest.optionalNativeAmount
834                 : _userRequest.middlewareRequest.optionalNativeAmount
835         }(
836             msg.sender,
837             _userRequest.middlewareRequest.inputToken,
838             _userRequest.amount,
839             address(this),
840             _userRequest.middlewareRequest.data
841         );
842 
843         // we mutate this variable if the input asset to bridge Impl is NATIVE
844         uint256 nativeInput = _userRequest.bridgeRequest.optionalNativeAmount;
845 
846         // if the input asset is ERC20, we need to grant the bridge implementation approval
847         if (_userRequest.bridgeRequest.inputToken != NATIVE_TOKEN_ADDRESS) {
848             IERC20(_userRequest.bridgeRequest.inputToken).safeIncreaseAllowance(
849                 bridgeInfo.route,
850                 _amountOut
851             );
852         } else {
853             // if the input asset is native we need to set it as value
854             nativeInput =
855                 _amountOut +
856                 _userRequest.bridgeRequest.optionalNativeAmount;
857         }
858 
859         // send off to bridge
860         ImplBase(bridgeInfo.route).outboundTransferTo{value: nativeInput}(
861             _amountOut,
862             address(this),
863             _userRequest.receiverAddress,
864             _userRequest.bridgeRequest.inputToken,
865             _userRequest.toChainId,
866             _userRequest.bridgeRequest.data
867         );
868     }
869 
870     //
871     // Route management functions
872     //
873 
874     /// @notice add routes to the registry.
875     function addRoutes(
876         RouteData[] calldata _routes
877     ) external onlyOwner returns (uint256[] memory) {
878         require(_routes.length != 0, MovrErrors.EMPTY_INPUT);
879         uint256[] memory _routeIds = new uint256[](_routes.length);
880         for (uint256 i = 0; i < _routes.length; i++) {
881             require(
882                 _routes[i].route != address(0),
883                 MovrErrors.ADDRESS_0_PROVIDED
884             );
885             routes.push(_routes[i]);
886             _routeIds[i] = routes.length - 1;
887             emit NewRouteAdded(
888                 i,
889                 _routes[i].route,
890                 _routes[i].isEnabled,
891                 _routes[i].isMiddleware
892             );
893         }
894 
895         return _routeIds;
896     }
897 
898     ///@notice disables the route  if required.
899     function disableRoute(
900         uint256 _routeId
901     ) external onlyOwner onlyExistingRoute(_routeId) {
902         routes[_routeId].isEnabled = false;
903         emit RouteDisabled(_routeId);
904     }
905 
906     function rescueFunds(
907         address _token,
908         address _receiverAddress,
909         uint256 _amount
910     ) external onlyOwner {
911         IERC20(_token).safeTransfer(_receiverAddress, _amount);
912     }
913 }