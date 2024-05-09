1 // SPDX-License-Identifier: MIT
2 
3 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Emitted when `value` tokens are moved from one account (`from`) to
13      * another (`to`).
14      *
15      * Note that `value` may be zero.
16      */
17     event Transfer(address indexed from, address indexed to, uint256 value);
18 
19     /**
20      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
21      * a call to {approve}. `value` is the new allowance.
22      */
23     event Approval(
24         address indexed owner,
25         address indexed spender,
26         uint256 value
27     );
28 
29     /**
30      * @dev Returns the amount of tokens in existence.
31      */
32     function totalSupply() external view returns (uint256);
33 
34     /**
35      * @dev Returns the amount of tokens owned by `account`.
36      */
37     function balanceOf(address account) external view returns (uint256);
38 
39     /**
40      * @dev Moves `amount` tokens from the caller's account to `to`.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * Emits a {Transfer} event.
45      */
46     function transfer(address to, uint256 amount) external returns (bool);
47 
48     /**
49      * @dev Returns the remaining number of tokens that `spender` will be
50      * allowed to spend on behalf of `owner` through {transferFrom}. This is
51      * zero by default.
52      *
53      * This value changes when {approve} or {transferFrom} are called.
54      */
55     function allowance(
56         address owner,
57         address spender
58     ) external view returns (uint256);
59 
60     /**
61      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * IMPORTANT: Beware that changing an allowance with this method brings the risk
66      * that someone may use both the old and the new allowance by unfortunate
67      * transaction ordering. One possible solution to mitigate this race
68      * condition is to first reduce the spender's allowance to 0 and set the
69      * desired value afterwards:
70      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
71      *
72      * Emits an {Approval} event.
73      */
74     function approve(address spender, uint256 amount) external returns (bool);
75 
76     /**
77      * @dev Moves `amount` tokens from `from` to `to` using the
78      * allowance mechanism. `amount` is then deducted from the caller's
79      * allowance.
80      *
81      * Returns a boolean value indicating whether the operation succeeded.
82      *
83      * Emits a {Transfer} event.
84      */
85     function transferFrom(
86         address from,
87         address to,
88         uint256 amount
89     ) external returns (bool);
90 }
91 
92 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
93 
94 pragma solidity ^0.8.0;
95 
96 /**
97  * @dev Provides information about the current execution context, including the
98  * sender of the transaction and its data. While these are generally available
99  * via msg.sender and msg.data, they should not be accessed in such a direct
100  * manner, since when dealing with meta-transactions the account sending and
101  * paying for execution may not be the actual sender (as far as an application
102  * is concerned).
103  *
104  * This contract is only required for intermediate, library-like contracts.
105  */
106 abstract contract Context {
107     function _msgSender() internal view virtual returns (address) {
108         return msg.sender;
109     }
110 
111     function _msgData() internal view virtual returns (bytes calldata) {
112         return msg.data;
113     }
114 }
115 
116 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
117 
118 pragma solidity ^0.8.0;
119 
120 /**
121  * @dev Contract module which provides a basic access control mechanism, where
122  * there is an account (an owner) that can be granted exclusive access to
123  * specific functions.
124  *
125  * By default, the owner account will be the one that deploys the contract. This
126  * can later be changed with {transferOwnership}.
127  *
128  * This module is used through inheritance. It will make available the modifier
129  * `onlyOwner`, which can be applied to your functions to restrict their use to
130  * the owner.
131  */
132 abstract contract Ownable is Context {
133     address private _owner;
134 
135     event OwnershipTransferred(
136         address indexed previousOwner,
137         address indexed newOwner
138     );
139 
140     /**
141      * @dev Initializes the contract setting the deployer as the initial owner.
142      */
143     constructor() {
144         _transferOwnership(_msgSender());
145     }
146 
147     /**
148      * @dev Throws if called by any account other than the owner.
149      */
150     modifier onlyOwner() {
151         _checkOwner();
152         _;
153     }
154 
155     /**
156      * @dev Returns the address of the current owner.
157      */
158     function owner() public view virtual returns (address) {
159         return _owner;
160     }
161 
162     /**
163      * @dev Throws if the sender is not the owner.
164      */
165     function _checkOwner() internal view virtual {
166         require(owner() == _msgSender(), "Ownable: caller is not the owner");
167     }
168 
169     /**
170      * @dev Leaves the contract without owner. It will not be possible to call
171      * `onlyOwner` functions. Can only be called by the current owner.
172      *
173      * NOTE: Renouncing ownership will leave the contract without an owner,
174      * thereby disabling any functionality that is only available to the owner.
175      */
176     function renounceOwnership() public virtual onlyOwner {
177         _transferOwnership(address(0));
178     }
179 
180     /**
181      * @dev Transfers ownership of the contract to a new account (`newOwner`).
182      * Can only be called by the current owner.
183      */
184     function transferOwnership(address newOwner) public virtual onlyOwner {
185         require(
186             newOwner != address(0),
187             "Ownable: new owner is the zero address"
188         );
189         _transferOwnership(newOwner);
190     }
191 
192     /**
193      * @dev Transfers ownership of the contract to a new account (`newOwner`).
194      * Internal function without access restriction.
195      */
196     function _transferOwnership(address newOwner) internal virtual {
197         address oldOwner = _owner;
198         _owner = newOwner;
199         emit OwnershipTransferred(oldOwner, newOwner);
200     }
201 }
202 
203 // OpenZeppelin Contracts (last updated v4.9.0) (utils/Address.sol)
204 
205 pragma solidity ^0.8.1;
206 
207 /**
208  * @dev Collection of functions related to the address type
209  */
210 library Address {
211     /**
212      * @dev Returns true if `account` is a contract.
213      *
214      * [IMPORTANT]
215      * ====
216      * It is unsafe to assume that an address for which this function returns
217      * false is an externally-owned account (EOA) and not a contract.
218      *
219      * Among others, `isContract` will return false for the following
220      * types of addresses:
221      *
222      *  - an externally-owned account
223      *  - a contract in construction
224      *  - an address where a contract will be created
225      *  - an address where a contract lived, but was destroyed
226      *
227      * Furthermore, `isContract` will also return true if the target contract within
228      * the same transaction is already scheduled for destruction by `SELFDESTRUCT`,
229      * which only has an effect at the end of a transaction.
230      * ====
231      *
232      * [IMPORTANT]
233      * ====
234      * You shouldn't rely on `isContract` to protect against flash loan attacks!
235      *
236      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
237      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
238      * constructor.
239      * ====
240      */
241     function isContract(address account) internal view returns (bool) {
242         // This method relies on extcodesize/address.code.length, which returns 0
243         // for contracts in construction, since the code is only stored at the end
244         // of the constructor execution.
245 
246         return account.code.length > 0;
247     }
248 
249     /**
250      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
251      * `recipient`, forwarding all available gas and reverting on errors.
252      *
253      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
254      * of certain opcodes, possibly making contracts go over the 2300 gas limit
255      * imposed by `transfer`, making them unable to receive funds via
256      * `transfer`. {sendValue} removes this limitation.
257      *
258      * https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more].
259      *
260      * IMPORTANT: because control is transferred to `recipient`, care must be
261      * taken to not create reentrancy vulnerabilities. Consider using
262      * {ReentrancyGuard} or the
263      * https://solidity.readthedocs.io/en/v0.8.0/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
264      */
265     function sendValue(address payable recipient, uint256 amount) internal {
266         require(
267             address(this).balance >= amount,
268             "Address: insufficient balance"
269         );
270 
271         (bool success, ) = recipient.call{value: amount}("");
272         require(
273             success,
274             "Address: unable to send value, recipient may have reverted"
275         );
276     }
277 
278     /**
279      * @dev Performs a Solidity function call using a low level `call`. A
280      * plain `call` is an unsafe replacement for a function call: use this
281      * function instead.
282      *
283      * If `target` reverts with a revert reason, it is bubbled up by this
284      * function (like regular Solidity function calls).
285      *
286      * Returns the raw returned data. To convert to the expected return value,
287      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
288      *
289      * Requirements:
290      *
291      * - `target` must be a contract.
292      * - calling `target` with `data` must not revert.
293      *
294      * _Available since v3.1._
295      */
296     function functionCall(
297         address target,
298         bytes memory data
299     ) internal returns (bytes memory) {
300         return
301             functionCallWithValue(
302                 target,
303                 data,
304                 0,
305                 "Address: low-level call failed"
306             );
307     }
308 
309     /**
310      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
311      * `errorMessage` as a fallback revert reason when `target` reverts.
312      *
313      * _Available since v3.1._
314      */
315     function functionCall(
316         address target,
317         bytes memory data,
318         string memory errorMessage
319     ) internal returns (bytes memory) {
320         return functionCallWithValue(target, data, 0, errorMessage);
321     }
322 
323     /**
324      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
325      * but also transferring `value` wei to `target`.
326      *
327      * Requirements:
328      *
329      * - the calling contract must have an ETH balance of at least `value`.
330      * - the called Solidity function must be `payable`.
331      *
332      * _Available since v3.1._
333      */
334     function functionCallWithValue(
335         address target,
336         bytes memory data,
337         uint256 value
338     ) internal returns (bytes memory) {
339         return
340             functionCallWithValue(
341                 target,
342                 data,
343                 value,
344                 "Address: low-level call with value failed"
345             );
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
350      * with `errorMessage` as a fallback revert reason when `target` reverts.
351      *
352      * _Available since v3.1._
353      */
354     function functionCallWithValue(
355         address target,
356         bytes memory data,
357         uint256 value,
358         string memory errorMessage
359     ) internal returns (bytes memory) {
360         require(
361             address(this).balance >= value,
362             "Address: insufficient balance for call"
363         );
364         (bool success, bytes memory returndata) = target.call{value: value}(
365             data
366         );
367         return
368             verifyCallResultFromTarget(
369                 target,
370                 success,
371                 returndata,
372                 errorMessage
373             );
374     }
375 
376     /**
377      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
378      * but performing a static call.
379      *
380      * _Available since v3.3._
381      */
382     function functionStaticCall(
383         address target,
384         bytes memory data
385     ) internal view returns (bytes memory) {
386         return
387             functionStaticCall(
388                 target,
389                 data,
390                 "Address: low-level static call failed"
391             );
392     }
393 
394     /**
395      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
396      * but performing a static call.
397      *
398      * _Available since v3.3._
399      */
400     function functionStaticCall(
401         address target,
402         bytes memory data,
403         string memory errorMessage
404     ) internal view returns (bytes memory) {
405         (bool success, bytes memory returndata) = target.staticcall(data);
406         return
407             verifyCallResultFromTarget(
408                 target,
409                 success,
410                 returndata,
411                 errorMessage
412             );
413     }
414 
415     /**
416      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
417      * but performing a delegate call.
418      *
419      * _Available since v3.4._
420      */
421     function functionDelegateCall(
422         address target,
423         bytes memory data
424     ) internal returns (bytes memory) {
425         return
426             functionDelegateCall(
427                 target,
428                 data,
429                 "Address: low-level delegate call failed"
430             );
431     }
432 
433     /**
434      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
435      * but performing a delegate call.
436      *
437      * _Available since v3.4._
438      */
439     function functionDelegateCall(
440         address target,
441         bytes memory data,
442         string memory errorMessage
443     ) internal returns (bytes memory) {
444         (bool success, bytes memory returndata) = target.delegatecall(data);
445         return
446             verifyCallResultFromTarget(
447                 target,
448                 success,
449                 returndata,
450                 errorMessage
451             );
452     }
453 
454     /**
455      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
456      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
457      *
458      * _Available since v4.8._
459      */
460     function verifyCallResultFromTarget(
461         address target,
462         bool success,
463         bytes memory returndata,
464         string memory errorMessage
465     ) internal view returns (bytes memory) {
466         if (success) {
467             if (returndata.length == 0) {
468                 // only check isContract if the call was successful and the return data is empty
469                 // otherwise we already know that it was a contract
470                 require(isContract(target), "Address: call to non-contract");
471             }
472             return returndata;
473         } else {
474             _revert(returndata, errorMessage);
475         }
476     }
477 
478     /**
479      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
480      * revert reason or using the provided one.
481      *
482      * _Available since v4.3._
483      */
484     function verifyCallResult(
485         bool success,
486         bytes memory returndata,
487         string memory errorMessage
488     ) internal pure returns (bytes memory) {
489         if (success) {
490             return returndata;
491         } else {
492             _revert(returndata, errorMessage);
493         }
494     }
495 
496     function _revert(
497         bytes memory returndata,
498         string memory errorMessage
499     ) private pure {
500         // Look for revert reason and bubble it up if present
501         if (returndata.length > 0) {
502             // The easiest way to bubble the revert reason is using memory via assembly
503             /// @solidity memory-safe-assembly
504             assembly {
505                 let returndata_size := mload(returndata)
506                 revert(add(32, returndata), returndata_size)
507             }
508         } else {
509             revert(errorMessage);
510         }
511     }
512 }
513 
514 pragma solidity 0.8.21;
515 
516 contract Staking is Ownable {
517     struct Share {
518         uint depositTime;
519         uint initialDeposit;
520         uint sumReward;
521     }
522 
523     mapping(address => Share) public shares;
524     IERC20 public stakingToken;
525     IERC20 public rewardToken;
526     uint public sumReward;
527     uint private constant PRECISION = 1e18;
528     address private _taxWallet;
529     uint public totalReward;
530     uint256 public totalDistributed;
531     bool public initialized;
532 
533     constructor() {
534         _taxWallet = _msgSender();
535     }
536 
537     function init(address _rewardToken, address _stakingToken) external {
538         require(!initialized, "alrealy initialized");
539         stakingToken = IERC20(_stakingToken);
540         rewardToken = IERC20(_rewardToken);
541         initialized = true;
542     }
543 
544     function setStakeToken(IERC20 token_) external onlyOwner {
545         stakingToken = token_;
546     }
547 
548     function setRewardToken(IERC20 token_) external onlyOwner {
549         stakingToken = token_;
550     }
551 
552     function deposit(uint amount) external {
553         require(amount > 0, "Amount must be greater than zero");
554         Share memory share = shares[_msgSender()];
555         stakingToken.transferFrom(_msgSender(), address(this), amount);
556         _payoutGainsUpdateShare(
557             _msgSender(),
558             share,
559             share.initialDeposit + amount,
560             true
561         );
562     }
563 
564     function withdraw() external {
565         Share memory share = shares[_msgSender()];
566         require(share.initialDeposit > 0, "No initial deposit");
567         require(
568             share.depositTime + 1 days < block.timestamp,
569             "withdraw after one week"
570         );
571         stakingToken.transfer(_msgSender(), share.initialDeposit);
572         _payoutGainsUpdateShare(_msgSender(), share, 0, true);
573     }
574 
575     function claim() external {
576         Share memory share = shares[_msgSender()];
577         require(share.initialDeposit > 0, "No initial deposit");
578         _payoutGainsUpdateShare(
579             _msgSender(),
580             share,
581             share.initialDeposit,
582             false
583         );
584     }
585 
586     function _payoutGainsUpdateShare(
587         address who,
588         Share memory share,
589         uint newAmount,
590         bool resetTimer
591     ) private {
592         uint gains;
593         if (share.initialDeposit != 0)
594             gains =
595                 (share.initialDeposit * (sumReward - share.sumReward)) /
596                 PRECISION;
597 
598         if (newAmount == 0) delete shares[who];
599         else if (resetTimer)
600             shares[who] = Share(block.timestamp, newAmount, sumReward);
601         else shares[who] = Share(share.depositTime, newAmount, sumReward);
602 
603         if (gains > 0) {
604             rewardToken.transfer(who, gains);
605             totalDistributed = totalDistributed + gains;
606         }
607     }
608 
609     function pending(address who) external view returns (uint) {
610         Share memory share = shares[who];
611         return
612             (share.initialDeposit * (sumReward - share.sumReward)) / PRECISION;
613     }
614 
615     function updateReward(uint256 _amount) external {
616         require(
617             _msgSender() == address(rewardToken),
618             "only accept token contract"
619         );
620 
621         uint balance = stakingToken.balanceOf(address(this));
622 
623         if (_amount == 0 || balance == 0) return;
624 
625         uint gpus = (_amount * PRECISION) / balance;
626         sumReward += gpus;
627         totalReward += _amount;
628     }
629 }