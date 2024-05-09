1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.7.0;
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, reverting on
21      * overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      * - Addition cannot overflow.
27      */
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31 
32         return c;
33     }
34 
35     /**
36      * @dev Returns the subtraction of two unsigned integers, reverting on
37      * overflow (when the result is negative).
38      *
39      * Counterpart to Solidity's `-` operator.
40      *
41      * Requirements:
42      * - Subtraction cannot overflow.
43      */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         return sub(a, b, "SafeMath: subtraction overflow");
46     }
47 
48     /**
49      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
50      * overflow (when the result is negative).
51      *
52      * Counterpart to Solidity's `-` operator.
53      *
54      * Requirements:
55      * - Subtraction cannot overflow.
56      *
57      * _Available since v2.4.0._
58      */
59     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
60         require(b <= a, errorMessage);
61         uint256 c = a - b;
62 
63         return c;
64     }
65 
66     /**
67      * @dev Returns the multiplication of two unsigned integers, reverting on
68      * overflow.
69      *
70      * Counterpart to Solidity's `*` operator.
71      *
72      * Requirements:
73      * - Multiplication cannot overflow.
74      */
75     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
76         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
77         // benefit is lost if 'b' is also tested.
78         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
79         if (a == 0) {
80             return 0;
81         }
82 
83         uint256 c = a * b;
84         require(c / a == b, "SafeMath: multiplication overflow");
85 
86         return c;
87     }
88 
89     /**
90      * @dev Returns the integer division of two unsigned integers. Reverts on
91      * division by zero. The result is rounded towards zero.
92      *
93      * Counterpart to Solidity's `/` operator. Note: this function uses a
94      * `revert` opcode (which leaves remaining gas untouched) while Solidity
95      * uses an invalid opcode to revert (consuming all remaining gas).
96      *
97      * Requirements:
98      * - The divisor cannot be zero.
99      */
100     function div(uint256 a, uint256 b) internal pure returns (uint256) {
101         return div(a, b, "SafeMath: division by zero");
102     }
103 
104     /**
105      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
106      * division by zero. The result is rounded towards zero.
107      *
108      * Counterpart to Solidity's `/` operator. Note: this function uses a
109      * `revert` opcode (which leaves remaining gas untouched) while Solidity
110      * uses an invalid opcode to revert (consuming all remaining gas).
111      *
112      * Requirements:
113      * - The divisor cannot be zero.
114      *
115      * _Available since v2.4.0._
116      */
117     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
118         // Solidity only automatically asserts when dividing by 0
119         require(b > 0, errorMessage);
120         uint256 c = a / b;
121         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
122 
123         return c;
124     }
125 
126     /**
127      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
128      * Reverts when dividing by zero.
129      *
130      * Counterpart to Solidity's `%` operator. This function uses a `revert`
131      * opcode (which leaves remaining gas untouched) while Solidity uses an
132      * invalid opcode to revert (consuming all remaining gas).
133      *
134      * Requirements:
135      * - The divisor cannot be zero.
136      */
137     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
138         return mod(a, b, "SafeMath: modulo by zero");
139     }
140 
141     /**
142      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
143      * Reverts with custom message when dividing by zero.
144      *
145      * Counterpart to Solidity's `%` operator. This function uses a `revert`
146      * opcode (which leaves remaining gas untouched) while Solidity uses an
147      * invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      * - The divisor cannot be zero.
151      *
152      * _Available since v2.4.0._
153      */
154     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
155         require(b != 0, errorMessage);
156         return a % b;
157     }
158 }
159 
160 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
161 
162 /**
163  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
164  * the optional functions; to access them see {ERC20Detailed}.
165  */
166 interface IERC20 {
167     /**
168      * @dev Returns the amount of tokens in existence.
169      */
170     function totalSupply() external view returns (uint256);
171 
172     /**
173      * @dev Returns the amount of tokens owned by `account`.
174      */
175     function balanceOf(address account) external view returns (uint256);
176 
177     /**
178      * @dev Moves `amount` tokens from the caller's account to `recipient`.
179      *
180      * Returns a boolean value indicating whether the operation succeeded.
181      *
182      * Emits a {Transfer} event.
183      */
184     function transfer(address recipient, uint256 amount) external returns (bool);
185     /**
186      * @dev Returns the remaining number of tokens that `spender` will be
187      * allowed to spend on behalf of `owner` through {transferFrom}. This is
188      * zero by default.
189      *
190      * This value changes when {approve} or {transferFrom} are called.
191      */
192     function allowance(address owner, address spender) external view returns (uint256);
193 
194     /**
195      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
196      *
197      * Returns a boolean value indicating whether the operation succeeded.
198      *
199      * IMPORTANT: Beware that changing an allowance with this method brings the risk
200      * that someone may use both the old and the new allowance by unfortunate
201      * transaction ordering. One possible solution to mitigate this race
202      * condition is to first reduce the spender's allowance to 0 and set the
203      * desired value afterwards:
204      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
205      *
206      * Emits an {Approval} event.
207      */
208     function approve(address spender, uint256 amount) external returns (bool);
209 
210     /**
211      * @dev Moves `amount` tokens from `sender` to `recipient` using the
212      * allowance mechanism. `amount` is then deducted from the caller's
213      * allowance.
214      *
215      * Returns a boolean value indicating whether the operation succeeded.
216      *
217      * Emits a {Transfer} event.
218      */
219     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
220 
221     /**
222      * @dev Emitted when `value` tokens are moved from one account (`from`) to
223      * another (`to`).
224      *
225      * Note that `value` may be zero.
226      */
227     event Transfer(address indexed from, address indexed to, uint256 value);
228 
229     /**
230      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
231      * a call to {approve}. `value` is the new allowance.
232      */
233     event Approval(address indexed owner, address indexed spender, uint256 value);
234 }
235 
236 
237 // File: @openzeppelin/contracts/utils/Address.sol
238 
239 /**
240  * @dev Collection of functions related to the address type
241  */
242 library Address {
243     /**
244      * @dev Returns true if `account` is a contract.
245      *
246      * [IMPORTANT]
247      * ====
248      * It is unsafe to assume that an address for which this function returns
249      * false is an externally-owned account (EOA) and not a contract.
250      *
251      * Among others, `isContract` will return false for the following
252      * types of addresses:
253      *
254      *  - an externally-owned account
255      *  - a contract in construction
256      *  - an address where a contract will be created
257      *  - an address where a contract lived, but was destroyed
258      * ====
259      */
260     function isContract(address account) internal view returns (bool) {
261         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
262         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
263         // for accounts without code, i.e. `keccak256('')`
264         bytes32 codehash;
265         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
266         // solhint-disable-next-line no-inline-assembly
267         assembly { codehash := extcodehash(account) }
268         return (codehash != accountHash && codehash != 0x0);
269     }
270 
271     /**
272      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
273      * `recipient`, forwarding all available gas and reverting on errors.
274      *
275      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
276      * of certain opcodes, possibly making contracts go over the 2300 gas limit
277      * imposed by `transfer`, making them unable to receive funds via
278      * `transfer`. {sendValue} removes this limitation.
279      *
280      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
281      *
282      * IMPORTANT: because control is transferred to `recipient`, care must be
283      * taken to not create reentrancy vulnerabilities. Consider using
284      * {ReentrancyGuard} or the
285      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
286      */
287     function sendValue(address payable recipient, uint256 amount) internal {
288         require(address(this).balance >= amount, "Address: insufficient balance");
289 
290         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
291         (bool success, ) = recipient.call{ value: amount }("");
292         require(success, "Address: unable to send value, recipient may have reverted");
293     }
294 
295     /**
296      * @dev Performs a Solidity function call using a low level `call`. A
297      * plain`call` is an unsafe replacement for a function call: use this
298      * function instead.
299      *
300      * If `target` reverts with a revert reason, it is bubbled up by this
301      * function (like regular Solidity function calls).
302      *
303      * Returns the raw returned data. To convert to the expected return value,
304      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
305      *
306      * Requirements:
307      *
308      * - `target` must be a contract.
309      * - calling `target` with `data` must not revert.
310      *
311      * _Available since v3.1._
312      */
313     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
314       return functionCall(target, data, "Address: low-level call failed");
315     }
316 
317     /**
318      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
319      * `errorMessage` as a fallback revert reason when `target` reverts.
320      *
321      * _Available since v3.1._
322      */
323     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
324         return _functionCallWithValue(target, data, 0, errorMessage);
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
329      * but also transferring `value` wei to `target`.
330      *
331      * Requirements:
332      *
333      * - the calling contract must have an ETH balance of at least `value`.
334      * - the called Solidity function must be `payable`.
335      *
336      * _Available since v3.1._
337      */
338     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
339         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
340     }
341 
342     /**
343      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
344      * with `errorMessage` as a fallback revert reason when `target` reverts.
345      *
346      * _Available since v3.1._
347      */
348     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
349         require(address(this).balance >= value, "Address: insufficient balance for call");
350         return _functionCallWithValue(target, data, value, errorMessage);
351     }
352 
353     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
354         require(isContract(target), "Address: call to non-contract");
355 
356         // solhint-disable-next-line avoid-low-level-calls
357         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
358         if (success) {
359             return returndata;
360         } else {
361             // Look for revert reason and bubble it up if present
362             if (returndata.length > 0) {
363                 // The easiest way to bubble the revert reason is using memory via assembly
364 
365                 // solhint-disable-next-line no-inline-assembly
366                 assembly {
367                     let returndata_size := mload(returndata)
368                     revert(add(32, returndata), returndata_size)
369                 }
370             } else {
371                 revert(errorMessage);
372             }
373         }
374     }
375 }
376 
377 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
378 
379 /**
380  * @title SafeERC20
381  * @dev Wrappers around ERC20 operations that throw on failure (when the token
382  * contract returns false). Tokens that return no value (and instead revert or
383  * throw on failure) are also supported, non-reverting calls are assumed to be
384  * successful.
385  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
386  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
387  */
388 library SafeERC20 {
389     using SafeMath for uint256;
390     using Address for address;
391 
392     function safeTransfer(IERC20 token, address to, uint256 value) internal {
393         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
394     }
395 
396     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
397         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
398     }
399 
400     function safeApprove(IERC20 token, address spender, uint256 value) internal {
401         // safeApprove should only be called when setting an initial allowance,
402         // or when resetting it to zero. To increase and decrease it, use
403         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
404         // solhint-disable-next-line max-line-length
405         require((value == 0) || (token.allowance(address(this), spender) == 0),
406             "SafeERC20: approve from non-zero to non-zero allowance"
407         );
408         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
409     }
410 
411     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
412         uint256 newAllowance = token.allowance(address(this), spender).add(value);
413         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
414     }
415 
416     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
417         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
418         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
419     }
420 
421     /**
422      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
423      * on the return value: the return value is optional (but if data is returned, it must not be false).
424      * @param token The token targeted by the call.
425      * @param data The call data (encoded using abi.encode or one of its variants).
426      */
427     function callOptionalReturn(IERC20 token, bytes memory data) private {
428         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
429         // we're implementing it ourselves.
430 
431         // A Solidity high level call has three parts:
432         //  1. The target address is checked to verify it contains contract code
433         //  2. The call itself is made, and success asserted
434         //  3. The return value is decoded, which in turn checks the size of the returned data.
435         // solhint-disable-next-line max-line-length
436         require(address(token).isContract(), "SafeERC20: call to non-contract");
437 
438         // solhint-disable-next-line avoid-low-level-calls
439         (bool success, bytes memory returndata) = address(token).call(data);
440         require(success, "SafeERC20: low-level call failed");
441 
442         if (returndata.length > 0) { // Return data is optional
443             // solhint-disable-next-line max-line-length
444             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
445         }
446     }
447 }
448 
449 
450 contract DONDIRewardCenter {
451     using SafeERC20 for IERC20;
452 
453     IERC20 public dondi = IERC20(0x45Ed25A237B6AB95cE69aF7555CF8D7A2FfEE67c);
454     
455     address public fundAddress = address(0x32Ddc840B06D15f16713DEfbE29187c060641214);
456     uint256 public cardCost = 500 * 10**18;
457     uint32 public cardSupply = 0;
458     address gov;
459 
460     mapping(uint32 => address) private cardOwners;
461     mapping(address => uint32[]) private ownCardIds;
462     
463     constructor () {
464         gov = msg.sender;
465     }
466 
467     modifier onlyGov() {
468         require(msg.sender == gov);
469         _;
470     }
471 
472     function transferOwnership(address owner)
473         external
474         onlyGov
475     {
476         gov = owner;
477     }
478     
479     function setFundAddress(address newFundAddress)
480         external
481         onlyGov
482     {
483         fundAddress = newFundAddress;
484     }
485     
486     function setCardCost(uint256 newCardCost)
487         external
488         onlyGov
489     {
490         cardCost = newCardCost;
491     }
492 
493     function buyCard(uint32 cardId)
494         external
495     {
496         require(cardId < cardSupply, "Card Not Exist!");
497         require(cardOwners[cardId] == address(0), "Already Sold!");
498         dondi.safeTransferFrom(msg.sender, fundAddress, cardCost);
499         cardOwners[cardId] = msg.sender;
500         ownCardIds[msg.sender].push(cardId);
501     }
502 
503     function getSalableCardIds()
504         external
505         view
506         returns(uint32[] memory, uint32)
507     {
508         uint32[] memory cardIds = new uint32[](cardSupply);
509         uint32 i;
510         uint32 length = 0;
511         for (i = 0; i < cardSupply; i++) {
512             if (cardOwners[i] == address(0)) {
513                 cardIds[length] = i;
514                 length++;
515             }
516         }
517         return (cardIds, length);
518     }
519     
520     function setCardSupply(uint32 newSupply)
521         external
522         onlyGov
523     {
524         cardSupply = newSupply;
525     }
526 
527     function getOwnCardIds(address cardOwner)
528         external
529         view
530         returns (uint32[] memory, uint32)
531     {
532         return (ownCardIds[cardOwner], uint32(ownCardIds[cardOwner].length));
533     }
534 
535     function getCardOwner(uint32 cardId)
536         external
537         view
538         returns (address)
539     {
540         return cardOwners[cardId];
541     }
542 }
543 
544 contract DONDINewRewardCenter {
545     using SafeERC20 for IERC20;
546 
547     IERC20 public dondi = IERC20(0x45Ed25A237B6AB95cE69aF7555CF8D7A2FfEE67c);
548 
549     DONDIRewardCenter oldRewardCenter = DONDIRewardCenter(0x67F4c17aBd728084F0386E9Ac54b9e9D8bC145aB);
550     
551     address payable public fundAddress = 0x32Ddc840B06D15f16713DEfbE29187c060641214;
552     uint256 public cardDondiCost = 2500 * 10 ** 18;
553     uint256 public cardEthPartCost = 25 * 10 ** 15;
554     uint256 public cardEthEntireCost = 25 * 10 ** 16;
555 
556     uint32 private cardSupply = 0;
557     address gov;
558 
559     mapping(uint32 => address) private cardOwners;
560     mapping(address => uint32[]) private ownCardIds;
561     
562     constructor () {
563         gov = msg.sender;
564     }
565 
566     modifier onlyGov() {
567         require(msg.sender == gov);
568         _;
569     }
570 
571     function getCardSupply()
572         external
573         view
574         returns (uint32)
575     {
576         return oldRewardCenter.cardSupply() + cardSupply;
577     }
578 
579     function transferOwnership(address owner)
580         external
581         onlyGov
582     {
583         gov = owner;
584     }
585     
586     function setFundAddress(address payable newFundAddress)
587         external
588         onlyGov
589     {
590         fundAddress = newFundAddress;
591     }
592     
593     function setCardCost(uint256 newDondiCost, uint256 newEthPartCost, uint256 newEthEntireCost)
594         external
595         onlyGov
596     {
597         cardDondiCost = newDondiCost;
598         cardEthPartCost = newEthPartCost;
599         cardEthEntireCost = newEthEntireCost;
600     }
601 
602     function buyCard(uint32 cardId, uint plan) // plan 0 : dondi + ETH, plan 1 : ETH
603         external
604         payable
605     {
606         require(plan < 2, "Wrong plan number!");
607         require(cardId < cardSupply + oldRewardCenter.cardSupply(), "Card Not Exist!");
608         require(cardId >= oldRewardCenter.cardSupply(), "Already Sold!");
609         cardId -= oldRewardCenter.cardSupply();
610         require(cardOwners[cardId] == address(0), "Already Sold!");
611         if (plan == 0) {
612             require(msg.value == cardEthPartCost, "Wrong ETH Cost!");
613             dondi.safeTransferFrom(msg.sender, fundAddress, cardDondiCost);
614             if (!fundAddress.send(cardEthPartCost)) {
615                 fundAddress.transfer(cardEthPartCost);
616             }
617         } else {
618             require(msg.value == cardEthEntireCost, "Wrong ETH Cost!");
619             if (!fundAddress.send(cardEthEntireCost)) {
620                 fundAddress.transfer(cardEthEntireCost);
621             }
622         }
623         cardOwners[cardId] = msg.sender;
624         ownCardIds[msg.sender].push(cardId + oldRewardCenter.cardSupply());
625     }
626 
627     function getSalableCardIds()
628         external
629         view
630         returns(uint32[] memory, uint32)
631     {
632         (uint32[] memory oldCardIds, uint32 oldLength) = oldRewardCenter.getSalableCardIds();
633         uint32[] memory cardIds = new uint32[](cardSupply + oldLength);
634         uint32 i;
635         for (i = 0; i < oldLength; i++) {
636             cardIds[i] = oldCardIds[i];
637         }
638         uint32 length = oldLength;
639         for (i = 0; i < cardSupply; i++) {
640             if (cardOwners[i] == address(0)) {
641                 cardIds[length] = oldRewardCenter.cardSupply() + i;
642                 length++;
643             }
644         }
645         return (cardIds, length);
646     }
647     
648     function setCardSupply(uint32 newSupply)
649         external
650         onlyGov
651     {
652         require(newSupply >= oldRewardCenter.cardSupply(), "too less card!");
653         cardSupply = newSupply - oldRewardCenter.cardSupply();
654     }
655 
656     function getOwnCardIds(address cardOwner)
657         external
658         view
659         returns (uint32[] memory, uint32)
660     {
661         (uint32[] memory cardIds, uint32 length) = oldRewardCenter.getOwnCardIds(cardOwner);
662         uint32[] memory newCardIds = new uint32[](length + ownCardIds[cardOwner].length);
663         uint i;
664         for (i = 0; i < length; i++) {
665             newCardIds[i] = cardIds[i];
666         }
667         for (i = 0; i < ownCardIds[cardOwner].length; i++) {
668             newCardIds[length] = ownCardIds[cardOwner][i];
669             length++;
670         }
671         return (newCardIds, length);
672     }
673 
674     function getCardOwner(uint32 cardId)
675         external
676         view
677         returns (address)
678     {
679         if (cardId < oldRewardCenter.cardSupply()) {
680             return oldRewardCenter.getCardOwner(cardId);
681         } else {
682             return cardOwners[cardId - oldRewardCenter.cardSupply()];
683         }
684     }
685 }