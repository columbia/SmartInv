1 // SPDX-License-Identifier: MIT
2 
3 // ((/*,                                                                    ,*((/,.
4 // &&@@&&%#/*.                                                        .*(#&&@@@@%. 
5 // &&@@@@@@@&%(.                                                    ,#%&@@@@@@@@%. 
6 // &&@@@@@@@@@&&(,                                                ,#&@@@@@@@@@@@%. 
7 // &&@@@@@@@@@@@&&/.                                            .(&&@@@@@@@@@@@@%. 
8 // %&@@@@@@@@@@@@@&(,                                          *#&@@@@@@@@@@@@@@%. 
9 // #&@@@@@@@@@@@@@@&#*                                       .*#@@@@@@@@@@@@@@@&#. 
10 // #&@@@@@@@@@@@@@@@@#.                                      ,%&@@@@@@@@@@@@@@@&#. 
11 // #&@@@@@@@@@@@@@@@@%(,                                    ,(&@@@@@@@@@@@@@@@@&#. 
12 // #&@@@@@@@@@@@@@@@@&&/                                   .(%&@@@@@@@@@@@@@@@@&#. 
13 // #%@@@@@@@@@@@@@@@@@@(.               ,(/,.              .#&@@@@@@@@@@@@@@@@@&#. 
14 // (%@@@@@@@@@@@@@@@@@@#*.            ./%&&&/.            .*%@@@@@@@@@@@@@@@@@@%(. 
15 // (%@@@@@@@@@@@@@@@@@@#*.           *#&@@@@&%*.          .*%@@@@@@@@@@@@@@@@@@%(. 
16 // (%@@@@@@@@@@@@@@@@@@#/.         ./#@@@@@@@@%(.         ./%@@@@@@@@@@@@@@@@@@%(. 
17 // (%@@@@@@@@@@@@@@@@@@#/.        ./&@@@@@@@@@@&(*        ,/%@@@@@@@@@@@@@@@@@@%(. 
18 // (%@@@@@@@@@@@@@@@@@@%/.       ,#&@@@@@@@@@@@@&#,.      ,/%@@@@@@@@@@@@@@@@@@%(. 
19 // /%@@@@@@@@@@@@@@@@@@#/.      *(&@@@@@@@@@@@@@@&&*      ./%@@@@@@@@@@@@@@@@@&%(. 
20 // /%@@@@@@@@@@@@@@@@@@#/.     .(&@@@@@@@@@@@@@@@@@#*.    ,/%@@@@@@@@@@@@@@@@@&#/. 
21 // ,#@@@@@@@@@@@@@@@@@@#/.    ./%@@@@@@@@@@@@@@@@@@&#,    ,/%@@@@@@@@@@@@@@@@@&(,  
22 //  /%&@@@@@@@@@@@@@@@@#/.    *#&@@@@@@@@@@@@@@@@@@@&*    ,/%@@@@@@@@@@@@@@@@&%*   
23 //  .*#&@@@@@@@@@@@@@@@#/.    /&&@@@@@@@@@@@@@@@@@@@&/.   ,/%@@@@@@@@@@@@@@@@#*.   
24 //    ,(&@@@@@@@@@@@@@@#/.    /@@@@@@@@@@@@@@@@@@@@@&(,   ,/%@@@@@@@@@@@@@@%(,     
25 //     .*(&&@@@@@@@@@@@#/.    /&&@@@@@@@@@@@@@@@@@@@&/,   ,/%@@@@@@@@@@@&%/,       
26 //        ./%&@@@@@@@@@#/.    *#&@@@@@@@@@@@@@@@@@@@%*    ,/%@@@@@@@@@&%*          
27 //           ,/#%&&@@@@#/.     ,#&@@@@@@@@@@@@@@@@@#/.    ,/%@@@@&&%(/,            
28 //               ./#&@@%/.      ,/&@@@@@@@@@@@@@@%(,      ,/%@@%#*.                
29 //                   .,,,         ,/%&@@@@@@@@&%(*        .,,,.                    
30 //                                   ,/%&@@@%(*.                                   
31 //  .,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,**((/*,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
32 //                                                                                                                                                                                                                                                                                                            
33 //                                                                                             
34 
35 pragma solidity ^0.8.0;
36 
37 // Sources flattened with hardhat v2.6.4 https://hardhat.org
38 
39 // File @openzeppelin/contracts/utils/Context.sol@v4.2.0
40 
41 /*
42  * @dev Provides information about the current execution context, including the
43  * sender of the transaction and its data. While these are generally available
44  * via msg.sender and msg.data, they should not be accessed in such a direct
45  * manner, since when dealing with meta-transactions the account sending and
46  * paying for execution may not be the actual sender (as far as an application
47  * is concerned).
48  *
49  * This contract is only required for intermediate, library-like contracts.
50  */
51 abstract contract Context {
52     function _msgSender() internal view virtual returns (address) {
53         return msg.sender;
54     }
55 
56     function _msgData() internal view virtual returns (bytes calldata) {
57         return msg.data;
58     }
59 }
60 
61 
62 // File @openzeppelin/contracts/access/Ownable.sol@v4.2.0
63 
64 
65 pragma solidity ^0.8.0;
66 
67 /**
68  * @dev Contract module which provides a basic access control mechanism, where
69  * there is an account (an owner) that can be granted exclusive access to
70  * specific functions.
71  *
72  * By default, the owner account will be the one that deploys the contract. This
73  * can later be changed with {transferOwnership}.
74  *
75  * This module is used through inheritance. It will make available the modifier
76  * `onlyOwner`, which can be applied to your functions to restrict their use to
77  * the owner.
78  */
79 abstract contract Ownable is Context {
80     address private _owner;
81 
82     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
83 
84     /**
85      * @dev Initializes the contract setting the deployer as the initial owner.
86      */
87     constructor() {
88         _setOwner(_msgSender());
89     }
90 
91     /**
92      * @dev Returns the address of the current owner.
93      */
94     function owner() public view virtual returns (address) {
95         return _owner;
96     }
97 
98     /**
99      * @dev Throws if called by any account other than the owner.
100      */
101     modifier onlyOwner() {
102         require(owner() == _msgSender(), "Ownable: caller is not the owner");
103         _;
104     }
105 
106     /**
107      * @dev Leaves the contract without owner. It will not be possible to call
108      * `onlyOwner` functions anymore. Can only be called by the current owner.
109      *
110      * NOTE: Renouncing ownership will leave the contract without an owner,
111      * thereby removing any functionality that is only available to the owner.
112      */
113     function renounceOwnership() public virtual onlyOwner {
114         _setOwner(address(0));
115     }
116 
117     /**
118      * @dev Transfers ownership of the contract to a new account (`newOwner`).
119      * Can only be called by the current owner.
120      */
121     function transferOwnership(address newOwner) public virtual onlyOwner {
122         require(newOwner != address(0), "Ownable: new owner is the zero address");
123         _setOwner(newOwner);
124     }
125 
126     function _setOwner(address newOwner) private {
127         address oldOwner = _owner;
128         _owner = newOwner;
129         emit OwnershipTransferred(oldOwner, newOwner);
130     }
131 }
132 
133 
134 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.2.0
135 
136 
137 pragma solidity ^0.8.0;
138 
139 /**
140  * @dev Interface of the ERC20 standard as defined in the EIP.
141  */
142 interface IERC20 {
143     /**
144      * @dev Returns the amount of tokens in existence.
145      */
146     function totalSupply() external view returns (uint256);
147 
148     /**
149      * @dev Returns the amount of tokens owned by `account`.
150      */
151     function balanceOf(address account) external view returns (uint256);
152 
153     /**
154      * @dev Moves `amount` tokens from the caller's account to `recipient`.
155      *
156      * Returns a boolean value indicating whether the operation succeeded.
157      *
158      * Emits a {Transfer} event.
159      */
160     function transfer(address recipient, uint256 amount) external returns (bool);
161 
162     /**
163      * @dev Returns the remaining number of tokens that `spender` will be
164      * allowed to spend on behalf of `owner` through {transferFrom}. This is
165      * zero by default.
166      *
167      * This value changes when {approve} or {transferFrom} are called.
168      */
169     function allowance(address owner, address spender) external view returns (uint256);
170 
171     /**
172      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
173      *
174      * Returns a boolean value indicating whether the operation succeeded.
175      *
176      * IMPORTANT: Beware that changing an allowance with this method brings the risk
177      * that someone may use both the old and the new allowance by unfortunate
178      * transaction ordering. One possible solution to mitigate this race
179      * condition is to first reduce the spender's allowance to 0 and set the
180      * desired value afterwards:
181      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
182      *
183      * Emits an {Approval} event.
184      */
185     function approve(address spender, uint256 amount) external returns (bool);
186 
187     /**
188      * @dev Moves `amount` tokens from `sender` to `recipient` using the
189      * allowance mechanism. `amount` is then deducted from the caller's
190      * allowance.
191      *
192      * Returns a boolean value indicating whether the operation succeeded.
193      *
194      * Emits a {Transfer} event.
195      */
196     function transferFrom(
197         address sender,
198         address recipient,
199         uint256 amount
200     ) external returns (bool);
201 
202     /**
203      * @dev Emitted when `value` tokens are moved from one account (`from`) to
204      * another (`to`).
205      *
206      * Note that `value` may be zero.
207      */
208     event Transfer(address indexed from, address indexed to, uint256 value);
209 
210     /**
211      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
212      * a call to {approve}. `value` is the new allowance.
213      */
214     event Approval(address indexed owner, address indexed spender, uint256 value);
215 }
216 
217 
218 // File contracts/libraries/TransferHelper.sol
219 
220 pragma solidity ^0.8.0;
221 
222 interface IERC20NoReturn {
223     function transfer(address recipient, uint256 amount) external;
224 
225     function transferFrom(
226         address sender,
227         address recipient,
228         uint256 amount
229     ) external;
230 }
231 
232 // helper methods for interacting with ERC20 tokens that do not consistently return boolean
233 library TransferHelper {
234     function safeTransfer(IERC20 token, address to, uint value) internal {
235         try IERC20NoReturn(address(token)).transfer(to, value) {
236 
237         } catch Error(string memory reason) {
238             // catch failing revert() and require()
239             revert(reason);
240         } catch  {
241             revert("TransferHelper: transfer failed");
242         }
243     }
244 
245     function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {
246         try IERC20NoReturn(address(token)).transferFrom(from, to, value) {
247 
248         } catch Error(string memory reason) {
249             // catch failing revert() and require()
250             revert(reason);
251         } catch {
252             revert("TransferHelper: transferFrom failed");
253         }
254     }
255 }
256 
257 
258 // File contracts/interface/IWETH.sol
259 
260 
261 pragma solidity ^0.8.0;
262 
263 
264 interface IWETH {
265     function deposit() external payable;
266     function transfer(address to, uint value) external returns (bool);
267     function withdraw(uint) external;
268 }
269 
270 
271 // File contracts/interface/IWardenPreTrade2.sol
272 
273 pragma solidity ^0.8.0;
274 
275 interface IWardenPreTrade2 {
276     function preTradeAndFee(
277         IERC20      _src,
278         IERC20      _dest,
279         uint256     _srcAmount,
280         address     _trader,
281         address     _receiver,
282         uint256     _partnerId,
283         uint256     _metaData
284     )
285         external
286         returns (
287             uint256[] memory _fees,
288             address[] memory _collectors
289         );
290 }
291 
292 
293 // File @openzeppelin/contracts/utils/Address.sol@v4.2.0
294 
295 
296 pragma solidity ^0.8.0;
297 
298 /**
299  * @dev Collection of functions related to the address type
300  */
301 library Address {
302     /**
303      * @dev Returns true if `account` is a contract.
304      *
305      * [IMPORTANT]
306      * ====
307      * It is unsafe to assume that an address for which this function returns
308      * false is an externally-owned account (EOA) and not a contract.
309      *
310      * Among others, `isContract` will return false for the following
311      * types of addresses:
312      *
313      *  - an externally-owned account
314      *  - a contract in construction
315      *  - an address where a contract will be created
316      *  - an address where a contract lived, but was destroyed
317      * ====
318      */
319     function isContract(address account) internal view returns (bool) {
320         // This method relies on extcodesize, which returns 0 for contracts in
321         // construction, since the code is only stored at the end of the
322         // constructor execution.
323 
324         uint256 size;
325         assembly {
326             size := extcodesize(account)
327         }
328         return size > 0;
329     }
330 
331     /**
332      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
333      * `recipient`, forwarding all available gas and reverting on errors.
334      *
335      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
336      * of certain opcodes, possibly making contracts go over the 2300 gas limit
337      * imposed by `transfer`, making them unable to receive funds via
338      * `transfer`. {sendValue} removes this limitation.
339      *
340      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
341      *
342      * IMPORTANT: because control is transferred to `recipient`, care must be
343      * taken to not create reentrancy vulnerabilities. Consider using
344      * {ReentrancyGuard} or the
345      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
346      */
347     function sendValue(address payable recipient, uint256 amount) internal {
348         require(address(this).balance >= amount, "Address: insufficient balance");
349 
350         (bool success, ) = recipient.call{value: amount}("");
351         require(success, "Address: unable to send value, recipient may have reverted");
352     }
353 
354     /**
355      * @dev Performs a Solidity function call using a low level `call`. A
356      * plain `call` is an unsafe replacement for a function call: use this
357      * function instead.
358      *
359      * If `target` reverts with a revert reason, it is bubbled up by this
360      * function (like regular Solidity function calls).
361      *
362      * Returns the raw returned data. To convert to the expected return value,
363      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
364      *
365      * Requirements:
366      *
367      * - `target` must be a contract.
368      * - calling `target` with `data` must not revert.
369      *
370      * _Available since v3.1._
371      */
372     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
373         return functionCall(target, data, "Address: low-level call failed");
374     }
375 
376     /**
377      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
378      * `errorMessage` as a fallback revert reason when `target` reverts.
379      *
380      * _Available since v3.1._
381      */
382     function functionCall(
383         address target,
384         bytes memory data,
385         string memory errorMessage
386     ) internal returns (bytes memory) {
387         return functionCallWithValue(target, data, 0, errorMessage);
388     }
389 
390     /**
391      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
392      * but also transferring `value` wei to `target`.
393      *
394      * Requirements:
395      *
396      * - the calling contract must have an ETH balance of at least `value`.
397      * - the called Solidity function must be `payable`.
398      *
399      * _Available since v3.1._
400      */
401     function functionCallWithValue(
402         address target,
403         bytes memory data,
404         uint256 value
405     ) internal returns (bytes memory) {
406         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
407     }
408 
409     /**
410      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
411      * with `errorMessage` as a fallback revert reason when `target` reverts.
412      *
413      * _Available since v3.1._
414      */
415     function functionCallWithValue(
416         address target,
417         bytes memory data,
418         uint256 value,
419         string memory errorMessage
420     ) internal returns (bytes memory) {
421         require(address(this).balance >= value, "Address: insufficient balance for call");
422         require(isContract(target), "Address: call to non-contract");
423 
424         (bool success, bytes memory returndata) = target.call{value: value}(data);
425         return _verifyCallResult(success, returndata, errorMessage);
426     }
427 
428     /**
429      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
430      * but performing a static call.
431      *
432      * _Available since v3.3._
433      */
434     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
435         return functionStaticCall(target, data, "Address: low-level static call failed");
436     }
437 
438     /**
439      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
440      * but performing a static call.
441      *
442      * _Available since v3.3._
443      */
444     function functionStaticCall(
445         address target,
446         bytes memory data,
447         string memory errorMessage
448     ) internal view returns (bytes memory) {
449         require(isContract(target), "Address: static call to non-contract");
450 
451         (bool success, bytes memory returndata) = target.staticcall(data);
452         return _verifyCallResult(success, returndata, errorMessage);
453     }
454 
455     /**
456      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
457      * but performing a delegate call.
458      *
459      * _Available since v3.4._
460      */
461     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
462         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
463     }
464 
465     /**
466      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
467      * but performing a delegate call.
468      *
469      * _Available since v3.4._
470      */
471     function functionDelegateCall(
472         address target,
473         bytes memory data,
474         string memory errorMessage
475     ) internal returns (bytes memory) {
476         require(isContract(target), "Address: delegate call to non-contract");
477 
478         (bool success, bytes memory returndata) = target.delegatecall(data);
479         return _verifyCallResult(success, returndata, errorMessage);
480     }
481 
482     function _verifyCallResult(
483         bool success,
484         bytes memory returndata,
485         string memory errorMessage
486     ) private pure returns (bytes memory) {
487         if (success) {
488             return returndata;
489         } else {
490             // Look for revert reason and bubble it up if present
491             if (returndata.length > 0) {
492                 // The easiest way to bubble the revert reason is using memory via assembly
493 
494                 assembly {
495                     let returndata_size := mload(returndata)
496                     revert(add(32, returndata), returndata_size)
497                 }
498             } else {
499                 revert(errorMessage);
500             }
501         }
502     }
503 }
504 
505 
506 // File @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol@v4.2.0
507 
508 
509 pragma solidity ^0.8.0;
510 
511 
512 /**
513  * @title SafeERC20
514  * @dev Wrappers around ERC20 operations that throw on failure (when the token
515  * contract returns false). Tokens that return no value (and instead revert or
516  * throw on failure) are also supported, non-reverting calls are assumed to be
517  * successful.
518  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
519  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
520  */
521 library SafeERC20 {
522     using Address for address;
523 
524     function safeTransfer(
525         IERC20 token,
526         address to,
527         uint256 value
528     ) internal {
529         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
530     }
531 
532     function safeTransferFrom(
533         IERC20 token,
534         address from,
535         address to,
536         uint256 value
537     ) internal {
538         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
539     }
540 
541     /**
542      * @dev Deprecated. This function has issues similar to the ones found in
543      * {IERC20-approve}, and its usage is discouraged.
544      *
545      * Whenever possible, use {safeIncreaseAllowance} and
546      * {safeDecreaseAllowance} instead.
547      */
548     function safeApprove(
549         IERC20 token,
550         address spender,
551         uint256 value
552     ) internal {
553         // safeApprove should only be called when setting an initial allowance,
554         // or when resetting it to zero. To increase and decrease it, use
555         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
556         require(
557             (value == 0) || (token.allowance(address(this), spender) == 0),
558             "SafeERC20: approve from non-zero to non-zero allowance"
559         );
560         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
561     }
562 
563     function safeIncreaseAllowance(
564         IERC20 token,
565         address spender,
566         uint256 value
567     ) internal {
568         uint256 newAllowance = token.allowance(address(this), spender) + value;
569         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
570     }
571 
572     function safeDecreaseAllowance(
573         IERC20 token,
574         address spender,
575         uint256 value
576     ) internal {
577         unchecked {
578             uint256 oldAllowance = token.allowance(address(this), spender);
579             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
580             uint256 newAllowance = oldAllowance - value;
581             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
582         }
583     }
584 
585     /**
586      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
587      * on the return value: the return value is optional (but if data is returned, it must not be false).
588      * @param token The token targeted by the call.
589      * @param data The call data (encoded using abi.encode or one of its variants).
590      */
591     function _callOptionalReturn(IERC20 token, bytes memory data) private {
592         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
593         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
594         // the target address contains contract code and also asserts for success in the low-level call.
595 
596         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
597         if (returndata.length > 0) {
598             // Return data is optional
599             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
600         }
601     }
602 }
603 
604 
605 // File contracts/interface/IWardenSwap2.sol
606 
607 pragma solidity ^0.8.0;
608 
609 interface IWardenSwap2 {
610     function trade(
611         bytes calldata  _data,
612         IERC20      _src,
613         uint256     _srcAmount,
614         uint256     _originalSrcAmount,
615         IERC20      _dest,
616         address     _receiver,
617         address     _trader,
618         uint256     _partnerId,
619         uint256     _metaData
620     )
621         external;
622     
623     function tradeSplit(
624         bytes calldata  _data,
625         uint256[] calldata _volumes,
626         IERC20      _src,
627         uint256     _totalSrcAmount,
628         uint256     _originalSrcAmount,
629         IERC20      _dest,
630         address     _receiver,
631         address     _trader,
632         uint256     _partnerId,
633         uint256     _metaData
634     )
635         external;
636 }
637 
638 
639 // File contracts/swap/WardenRouterV2.sol
640 
641 pragma solidity ^0.8.0;
642 
643 
644 
645 
646 
647 contract WardenRouterV2 is Ownable {
648     using TransferHelper for IERC20;
649     
650     IWardenPreTrade2 public preTrade;
651 
652     IWETH public immutable weth;
653     IERC20 private constant ETHER_ERC20 = IERC20(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
654     
655     event UpdatedWardenPreTrade(
656         IWardenPreTrade2 indexed preTrade
657     );
658 
659     /**
660     * @dev When fee is collected by WardenSwap for a trade, this event will be emitted
661     * @param token Collected token
662     * @param wallet Collector address
663     * @param amount Amount of fee collected
664     */
665     event ProtocolFee(
666         IERC20  indexed   token,
667         address indexed   wallet,
668         uint256           amount
669     );
670 
671     /**
672     * @dev When fee is collected by WardenSwap's partners for a trade, this event will be emitted
673     * @param partnerId Partner ID
674     * @param token Collected token
675     * @param wallet Collector address
676     * @param amount Amount of fee collected
677     */
678     event PartnerFee(
679         uint256 indexed   partnerId,
680         IERC20  indexed   token,
681         address indexed   wallet,
682         uint256           amount
683     );
684 
685     /**
686     * @dev When the new trade occurs (and success), this event will be emitted.
687     * @param srcAsset Source token
688     * @param srcAmount Amount of source token
689     * @param destAsset Destination token
690     * @param destAmount Amount of destination token
691     * @param trader User address
692     */
693     event Trade(
694         address indexed srcAsset,
695         uint256         srcAmount,
696         address indexed destAsset,
697         uint256         destAmount,
698         address indexed trader,
699         address         receiver,
700         bool            hasSplitted
701     );
702 
703     constructor(
704         IWardenPreTrade2 _preTrade,
705         IWETH _weth
706     ) {
707         preTrade = _preTrade;
708         weth = _weth;
709         
710         emit UpdatedWardenPreTrade(_preTrade);
711     }
712 
713     function updateWardenPreTrade(
714         IWardenPreTrade2 _preTrade
715     )
716         external
717         onlyOwner
718     {
719         preTrade = _preTrade;
720         emit UpdatedWardenPreTrade(_preTrade);
721     }
722 
723     /**
724     * @dev Performs a trade with single volume
725     * @param _swap Warden Swap contract
726     * @param _data Warden Swap payload
727     * @param _deposits Source token receiver
728     * @param _src Source token
729     * @param _srcAmount Amount of source tokens
730     * @param _dest Destination token
731     * @param _minDestAmount Minimum of destination token amount
732     * @param _receiver Destination token receiver
733     * @param _partnerId Partner id for fee sharing / Referral
734     * @param _metaData Reserved for upcoming features
735     * @return _destAmount Amount of actual destination tokens
736     */
737     function swap(
738         IWardenSwap2    _swap,
739         bytes calldata  _data,
740         address     _deposits,
741         IERC20      _src,
742         uint256     _srcAmount,
743         IERC20      _dest,
744         uint256     _minDestAmount,
745         address     _receiver,
746         uint256     _partnerId,
747         uint256     _metaData
748     )
749         external
750         payable
751         returns(uint256 _destAmount)
752     {
753         if (_receiver == address(0)) {
754             _receiver = msg.sender;
755         }
756 
757         // Collect fee
758         uint256 newSrcAmount = _preTradeAndCollectFee(
759             _src,
760             _dest,
761             _srcAmount,
762             msg.sender,
763             _receiver,
764             _partnerId,
765             _metaData
766         );
767 
768         // Wrap ETH
769         if (ETHER_ERC20 == _src) {
770             require(msg.value == _srcAmount, "WardenRouter::swap: Ether source amount mismatched");
771             weth.deposit{value: newSrcAmount}();
772             
773             // Transfer user tokens to target
774             IERC20(address(weth)).safeTransfer(_deposits, newSrcAmount);
775         } else {
776             // Transfer user tokens to target
777             _src.safeTransferFrom(msg.sender, _deposits, newSrcAmount);
778         }
779 
780         bytes memory payload = abi.encodeWithSelector(IWardenSwap2.trade.selector,
781             _data,
782             _src,
783             newSrcAmount,
784             _srcAmount,
785             _dest,
786             _receiver,
787             msg.sender,
788             _partnerId,
789             _metaData
790         );
791 
792         _destAmount = _internalSwap(
793             _swap,
794             payload,
795             _dest,
796             _minDestAmount,
797             _receiver
798         );
799         emit Trade(address(_src), _srcAmount, address(_dest), _destAmount, msg.sender, _receiver, false);
800     }
801 
802     /**
803     * @dev Performs a trade by splitting volumes
804     * @param _swap Warden Swap contract
805     * @param _data Warden Swap payload
806     * @param _deposits Source token receivers
807     * @param _volumes Volume percentages
808     * @param _src Source token
809     * @param _totalSrcAmount Amount of source tokens
810     * @param _dest Destination token
811     * @param _minDestAmount Minimum of destination token amount
812     * @param _receiver Destination token receiver
813     * @param _partnerId Partner id for fee sharing / Referral
814     * @param _metaData Reserved for upcoming features
815     * @return _destAmount Amount of actual destination tokens
816     */
817     function swapSplit(
818         IWardenSwap2    _swap,
819         bytes calldata  _data,
820         address[] memory _deposits,
821         uint256[] memory _volumes,
822         IERC20      _src,
823         uint256     _totalSrcAmount,
824         IERC20      _dest,
825         uint256     _minDestAmount,
826         address     _receiver,
827         uint256     _partnerId,
828         uint256     _metaData
829     )
830         external
831         payable
832         returns(uint256 _destAmount)
833     {
834         if (_receiver == address(0)) {
835             _receiver = msg.sender;
836         }
837 
838         // Collect fee
839         uint256 newTotalSrcAmount = _preTradeAndCollectFee(
840             _src,
841             _dest,
842             _totalSrcAmount,
843             msg.sender,
844             _receiver,
845             _partnerId,
846             _metaData
847         );
848 
849         // Wrap ETH
850         if (ETHER_ERC20 == _src) {
851             require(msg.value == _totalSrcAmount, "WardenRouter::swapSplit: Ether source amount mismatched");
852             weth.deposit{value: newTotalSrcAmount}();
853         }
854 
855         // Transfer user tokens to targets
856         _depositVolumes(
857             newTotalSrcAmount,
858             _deposits,
859             _volumes,
860             _src
861         );
862         
863 
864         bytes memory payload = abi.encodeWithSelector(IWardenSwap2.tradeSplit.selector,
865             _data,
866             _volumes,
867             _src,
868             newTotalSrcAmount,
869             _totalSrcAmount,
870             _dest,
871             _receiver,
872             msg.sender,
873             _partnerId,
874             _metaData
875         );
876 
877         _destAmount = _internalSwap(
878             _swap,
879             payload,
880             _dest,
881             _minDestAmount,
882             _receiver
883         );
884         emit Trade(address(_src), _totalSrcAmount, address(_dest), _destAmount, msg.sender, _receiver, true);
885     }
886 
887     function _depositVolumes(
888         uint256 newTotalSrcAmount,
889         address[] memory _deposits,
890         uint256[] memory _volumes,
891         IERC20           _src
892     )
893         private
894     {
895         {
896             uint256 amountRemain = newTotalSrcAmount;
897             for (uint i = 0; i < _deposits.length; i++) {
898                 uint256 amountForThisRound;
899                 if (i == _deposits.length - 1) {
900                     amountForThisRound = amountRemain;
901                 } else {
902                     amountForThisRound = newTotalSrcAmount * _volumes[i] / 100;
903                     amountRemain = amountRemain - amountForThisRound;
904                 }
905             
906                 if (ETHER_ERC20 == _src) {
907                     IERC20(address(weth)).safeTransfer(_deposits[i], amountForThisRound);
908                 } else {
909                     _src.safeTransferFrom(msg.sender, _deposits[i], amountForThisRound);
910                 }
911             }
912         }
913     }
914 
915     function _internalSwap(
916         IWardenSwap2 _swap,
917         bytes memory _payload,
918         IERC20       _dest,
919         uint256      _minDestAmount,
920         address      _receiver
921     )
922         private
923         returns (uint256 _destAmount)
924     {
925         // Record dest asset for later consistency check.
926         uint256 destAmountBefore = ETHER_ERC20 == _dest ? _receiver.balance : _dest.balanceOf(_receiver);
927 
928         {
929             // solhint-disable-next-line avoid-low-level-calls
930             (bool success, bytes memory result) = address(_swap).call(_payload);
931             if (!success) {
932                 // Next 5 lines from https://ethereum.stackexchange.com/a/83577
933                 if (result.length < 68) revert();
934                 assembly {
935                     result := add(result, 0x04)
936                 }
937                 revert(abi.decode(result, (string)));
938             }
939         }
940 
941         _destAmount = ETHER_ERC20 == _dest ? _receiver.balance - destAmountBefore : _dest.balanceOf(_receiver) - destAmountBefore;
942 
943         // Throw exception if destination amount doesn't meet user requirement.
944         require(_destAmount >= _minDestAmount, "WardenRouter::_internalSwap: destination amount is too low.");
945     }
946 
947     function _preTradeAndCollectFee(
948         IERC20      _src,
949         IERC20      _dest,
950         uint256     _srcAmount,
951         address     _trader,
952         address     _receiver,
953         uint256     _partnerId,
954         uint256     _metaData
955     )
956         private
957         returns (uint256 _newSrcAmount)
958     {
959         // Collect fee
960         (uint256[] memory fees, address[] memory feeWallets) = preTrade.preTradeAndFee(
961             _src,
962             _dest,
963             _srcAmount,
964             _trader,
965             _receiver,
966             _partnerId,
967             _metaData
968         );
969         _newSrcAmount = _srcAmount;
970         if (fees.length > 0) {
971             if (fees[0] > 0) {
972                 _collectFee(
973                     _trader,
974                     _src,
975                     fees[0],
976                     feeWallets[0]
977                 );
978                 _newSrcAmount -= fees[0];
979             }
980             if (fees.length == 2 && fees[1] > 0) {
981                 _partnerFee(
982                     _trader,
983                     _partnerId, // partner id
984                     _src,
985                     fees[1],
986                     feeWallets[1]
987                 );
988                 _newSrcAmount -= fees[1];
989             }
990         }
991     }
992     
993     function _collectFee(
994         address _trader,
995         IERC20  _token,
996         uint256 _fee,
997         address _feeWallet
998     )
999         private
1000     {
1001         if (ETHER_ERC20 == _token) {
1002             (bool success, ) = payable(_feeWallet).call{value: _fee}(""); // Send ether to fee collector
1003             require(success, "WardenRouter::_collectFee: Transfer fee of ether failed.");
1004         } else {
1005             _token.safeTransferFrom(_trader, _feeWallet, _fee); // Send token to fee collector
1006         }
1007         emit ProtocolFee(_token, _feeWallet, _fee);
1008     }
1009 
1010     function _partnerFee(
1011         address _trader,
1012         uint256 _partnerId,
1013         IERC20  _token,
1014         uint256 _fee,
1015         address _feeWallet
1016     )
1017         private
1018     {
1019         if (ETHER_ERC20 == _token) {
1020             (bool success, ) = payable(_feeWallet).call{value: _fee}(""); // Send back ether to partner
1021             require(success, "WardenRouter::_partnerFee: Transfer fee of ether failed.");
1022         } else {
1023             _token.safeTransferFrom(_trader, _feeWallet, _fee);
1024         }
1025         emit PartnerFee(_partnerId, _token, _feeWallet, _fee);
1026     }
1027 
1028     /**
1029     * @dev Performs a trade ETH -> WETH
1030     * @param _receiver Receiver address
1031     * @return _destAmount Amount of actual destination tokens
1032     */
1033     function tradeEthToWeth(
1034         address     _receiver
1035     )
1036         external
1037         payable
1038         returns(uint256 _destAmount)
1039     {
1040         if (_receiver == address(0)) {
1041             _receiver = msg.sender;
1042         }
1043 
1044         weth.deposit{value: msg.value}();
1045         IERC20(address(weth)).safeTransfer(_receiver, msg.value);
1046         _destAmount = msg.value;
1047         emit Trade(address(ETHER_ERC20), msg.value, address(weth), _destAmount, msg.sender, _receiver, false);
1048     }
1049     
1050     /**
1051     * @dev Performs a trade WETH -> ETH
1052     * @param _srcAmount Amount of source tokens
1053     * @param _receiver Receiver address
1054     * @return _destAmount Amount of actual destination tokens
1055     */
1056     function tradeWethToEth(
1057         uint256     _srcAmount,
1058         address     _receiver
1059     )
1060         external
1061         returns(uint256 _destAmount)
1062     {
1063         if (_receiver == address(0)) {
1064             _receiver = msg.sender;
1065         }
1066 
1067         IERC20(address(weth)).safeTransferFrom(msg.sender, address(this), _srcAmount);
1068         weth.withdraw(_srcAmount);
1069         (bool success, ) = _receiver.call{value: _srcAmount}(""); // Send back ether to receiver
1070         require(success, "WardenRouter::tradeWethToEth: Transfer ether back to receiver failed.");
1071         _destAmount = _srcAmount;
1072         emit Trade(address(weth), _srcAmount, address(ETHER_ERC20), _destAmount, msg.sender, _receiver, false);
1073     }
1074 
1075     // Receive ETH in case of trade WETH -> ETH
1076     receive() external payable {
1077         require(msg.sender == address(weth), "WardenRouter: Receive Ether only from WETH");
1078     }
1079 
1080     // In case of an expected and unexpected event that has some token amounts remain in this contract, owner can call to collect them.
1081     function collectRemainingToken(
1082         IERC20  _token,
1083         uint256 _amount
1084     )
1085       external
1086       onlyOwner
1087     {
1088         _token.safeTransfer(msg.sender, _amount);
1089     }
1090 
1091     // In case of an expected and unexpected event that has some ether amounts remain in this contract, owner can call to collect them.
1092     function collectRemainingEther(
1093         uint256 _amount
1094     )
1095       external
1096       onlyOwner
1097     {
1098         (bool success, ) = msg.sender.call{value: _amount}(""); // Send back ether to sender
1099         require(success, "WardenRouter::collectRemainingEther: Transfer ether back to caller failed.");
1100     }
1101 }