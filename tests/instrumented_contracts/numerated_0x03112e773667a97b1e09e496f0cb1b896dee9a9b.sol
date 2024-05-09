1 // File: @openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
5 
6 pragma solidity ^0.8.1;
7 
8 /**
9  * @dev Collection of functions related to the address type
10  */
11 library AddressUpgradeable {
12     /**
13      * @dev Returns true if `account` is a contract.
14      *
15      * [IMPORTANT]
16      * ====
17      * It is unsafe to assume that an address for which this function returns
18      * false is an externally-owned account (EOA) and not a contract.
19      *
20      * Among others, `isContract` will return false for the following
21      * types of addresses:
22      *
23      *  - an externally-owned account
24      *  - a contract in construction
25      *  - an address where a contract will be created
26      *  - an address where a contract lived, but was destroyed
27      * ====
28      *
29      * [IMPORTANT]
30      * ====
31      * You shouldn't rely on `isContract` to protect against flash loan attacks!
32      *
33      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
34      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
35      * constructor.
36      * ====
37      */
38     function isContract(address account) internal view returns (bool) {
39         // This method relies on extcodesize/address.code.length, which returns 0
40         // for contracts in construction, since the code is only stored at the end
41         // of the constructor execution.
42 
43         return account.code.length > 0;
44     }
45 
46     /**
47      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
48      * `recipient`, forwarding all available gas and reverting on errors.
49      *
50      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
51      * of certain opcodes, possibly making contracts go over the 2300 gas limit
52      * imposed by `transfer`, making them unable to receive funds via
53      * `transfer`. {sendValue} removes this limitation.
54      *
55      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
56      *
57      * IMPORTANT: because control is transferred to `recipient`, care must be
58      * taken to not create reentrancy vulnerabilities. Consider using
59      * {ReentrancyGuard} or the
60      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
61      */
62     function sendValue(address payable recipient, uint256 amount) internal {
63         require(address(this).balance >= amount, "Address: insufficient balance");
64 
65         (bool success, ) = recipient.call{value: amount}("");
66         require(success, "Address: unable to send value, recipient may have reverted");
67     }
68 
69     /**
70      * @dev Performs a Solidity function call using a low level `call`. A
71      * plain `call` is an unsafe replacement for a function call: use this
72      * function instead.
73      *
74      * If `target` reverts with a revert reason, it is bubbled up by this
75      * function (like regular Solidity function calls).
76      *
77      * Returns the raw returned data. To convert to the expected return value,
78      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
79      *
80      * Requirements:
81      *
82      * - `target` must be a contract.
83      * - calling `target` with `data` must not revert.
84      *
85      * _Available since v3.1._
86      */
87     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
88         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
89     }
90 
91     /**
92      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
93      * `errorMessage` as a fallback revert reason when `target` reverts.
94      *
95      * _Available since v3.1._
96      */
97     function functionCall(
98         address target,
99         bytes memory data,
100         string memory errorMessage
101     ) internal returns (bytes memory) {
102         return functionCallWithValue(target, data, 0, errorMessage);
103     }
104 
105     /**
106      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
107      * but also transferring `value` wei to `target`.
108      *
109      * Requirements:
110      *
111      * - the calling contract must have an ETH balance of at least `value`.
112      * - the called Solidity function must be `payable`.
113      *
114      * _Available since v3.1._
115      */
116     function functionCallWithValue(
117         address target,
118         bytes memory data,
119         uint256 value
120     ) internal returns (bytes memory) {
121         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
122     }
123 
124     /**
125      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
126      * with `errorMessage` as a fallback revert reason when `target` reverts.
127      *
128      * _Available since v3.1._
129      */
130     function functionCallWithValue(
131         address target,
132         bytes memory data,
133         uint256 value,
134         string memory errorMessage
135     ) internal returns (bytes memory) {
136         require(address(this).balance >= value, "Address: insufficient balance for call");
137         (bool success, bytes memory returndata) = target.call{value: value}(data);
138         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
139     }
140 
141     /**
142      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
143      * but performing a static call.
144      *
145      * _Available since v3.3._
146      */
147     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
148         return functionStaticCall(target, data, "Address: low-level static call failed");
149     }
150 
151     /**
152      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
153      * but performing a static call.
154      *
155      * _Available since v3.3._
156      */
157     function functionStaticCall(
158         address target,
159         bytes memory data,
160         string memory errorMessage
161     ) internal view returns (bytes memory) {
162         (bool success, bytes memory returndata) = target.staticcall(data);
163         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
164     }
165 
166     /**
167      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
168      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
169      *
170      * _Available since v4.8._
171      */
172     function verifyCallResultFromTarget(
173         address target,
174         bool success,
175         bytes memory returndata,
176         string memory errorMessage
177     ) internal view returns (bytes memory) {
178         if (success) {
179             if (returndata.length == 0) {
180                 // only check isContract if the call was successful and the return data is empty
181                 // otherwise we already know that it was a contract
182                 require(isContract(target), "Address: call to non-contract");
183             }
184             return returndata;
185         } else {
186             _revert(returndata, errorMessage);
187         }
188     }
189 
190     /**
191      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
192      * revert reason or using the provided one.
193      *
194      * _Available since v4.3._
195      */
196     function verifyCallResult(
197         bool success,
198         bytes memory returndata,
199         string memory errorMessage
200     ) internal pure returns (bytes memory) {
201         if (success) {
202             return returndata;
203         } else {
204             _revert(returndata, errorMessage);
205         }
206     }
207 
208     function _revert(bytes memory returndata, string memory errorMessage) private pure {
209         // Look for revert reason and bubble it up if present
210         if (returndata.length > 0) {
211             // The easiest way to bubble the revert reason is using memory via assembly
212             /// @solidity memory-safe-assembly
213             assembly {
214                 let returndata_size := mload(returndata)
215                 revert(add(32, returndata), returndata_size)
216             }
217         } else {
218             revert(errorMessage);
219         }
220     }
221 }
222 
223 // File: @openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol
224 
225 
226 // OpenZeppelin Contracts (last updated v4.8.1) (proxy/utils/Initializable.sol)
227 
228 pragma solidity ^0.8.2;
229 
230 
231 /**
232  * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
233  * behind a proxy. Since proxied contracts do not make use of a constructor, it's common to move constructor logic to an
234  * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
235  * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
236  *
237  * The initialization functions use a version number. Once a version number is used, it is consumed and cannot be
238  * reused. This mechanism prevents re-execution of each "step" but allows the creation of new initialization steps in
239  * case an upgrade adds a module that needs to be initialized.
240  *
241  * For example:
242  *
243  * [.hljs-theme-light.nopadding]
244  * ```
245  * contract MyToken is ERC20Upgradeable {
246  *     function initialize() initializer public {
247  *         __ERC20_init("MyToken", "MTK");
248  *     }
249  * }
250  * contract MyTokenV2 is MyToken, ERC20PermitUpgradeable {
251  *     function initializeV2() reinitializer(2) public {
252  *         __ERC20Permit_init("MyToken");
253  *     }
254  * }
255  * ```
256  *
257  * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
258  * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
259  *
260  * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
261  * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
262  *
263  * [CAUTION]
264  * ====
265  * Avoid leaving a contract uninitialized.
266  *
267  * An uninitialized contract can be taken over by an attacker. This applies to both a proxy and its implementation
268  * contract, which may impact the proxy. To prevent the implementation contract from being used, you should invoke
269  * the {_disableInitializers} function in the constructor to automatically lock it when it is deployed:
270  *
271  * [.hljs-theme-light.nopadding]
272  * ```
273  * /// @custom:oz-upgrades-unsafe-allow constructor
274  * constructor() {
275  *     _disableInitializers();
276  * }
277  * ```
278  * ====
279  */
280 abstract contract Initializable {
281     /**
282      * @dev Indicates that the contract has been initialized.
283      * @custom:oz-retyped-from bool
284      */
285     uint8 private _initialized;
286 
287     /**
288      * @dev Indicates that the contract is in the process of being initialized.
289      */
290     bool private _initializing;
291 
292     /**
293      * @dev Triggered when the contract has been initialized or reinitialized.
294      */
295     event Initialized(uint8 version);
296 
297     /**
298      * @dev A modifier that defines a protected initializer function that can be invoked at most once. In its scope,
299      * `onlyInitializing` functions can be used to initialize parent contracts.
300      *
301      * Similar to `reinitializer(1)`, except that functions marked with `initializer` can be nested in the context of a
302      * constructor.
303      *
304      * Emits an {Initialized} event.
305      */
306     modifier initializer() {
307         bool isTopLevelCall = !_initializing;
308         require(
309             (isTopLevelCall && _initialized < 1) || (!AddressUpgradeable.isContract(address(this)) && _initialized == 1),
310             "Initializable: contract is already initialized"
311         );
312         _initialized = 1;
313         if (isTopLevelCall) {
314             _initializing = true;
315         }
316         _;
317         if (isTopLevelCall) {
318             _initializing = false;
319             emit Initialized(1);
320         }
321     }
322 
323     /**
324      * @dev A modifier that defines a protected reinitializer function that can be invoked at most once, and only if the
325      * contract hasn't been initialized to a greater version before. In its scope, `onlyInitializing` functions can be
326      * used to initialize parent contracts.
327      *
328      * A reinitializer may be used after the original initialization step. This is essential to configure modules that
329      * are added through upgrades and that require initialization.
330      *
331      * When `version` is 1, this modifier is similar to `initializer`, except that functions marked with `reinitializer`
332      * cannot be nested. If one is invoked in the context of another, execution will revert.
333      *
334      * Note that versions can jump in increments greater than 1; this implies that if multiple reinitializers coexist in
335      * a contract, executing them in the right order is up to the developer or operator.
336      *
337      * WARNING: setting the version to 255 will prevent any future reinitialization.
338      *
339      * Emits an {Initialized} event.
340      */
341     modifier reinitializer(uint8 version) {
342         require(!_initializing && _initialized < version, "Initializable: contract is already initialized");
343         _initialized = version;
344         _initializing = true;
345         _;
346         _initializing = false;
347         emit Initialized(version);
348     }
349 
350     /**
351      * @dev Modifier to protect an initialization function so that it can only be invoked by functions with the
352      * {initializer} and {reinitializer} modifiers, directly or indirectly.
353      */
354     modifier onlyInitializing() {
355         require(_initializing, "Initializable: contract is not initializing");
356         _;
357     }
358 
359     /**
360      * @dev Locks the contract, preventing any future reinitialization. This cannot be part of an initializer call.
361      * Calling this in the constructor of a contract will prevent that contract from being initialized or reinitialized
362      * to any version. It is recommended to use this to lock implementation contracts that are designed to be called
363      * through proxies.
364      *
365      * Emits an {Initialized} event the first time it is successfully executed.
366      */
367     function _disableInitializers() internal virtual {
368         require(!_initializing, "Initializable: contract is initializing");
369         if (_initialized < type(uint8).max) {
370             _initialized = type(uint8).max;
371             emit Initialized(type(uint8).max);
372         }
373     }
374 
375     /**
376      * @dev Returns the highest version that has been initialized. See {reinitializer}.
377      */
378     function _getInitializedVersion() internal view returns (uint8) {
379         return _initialized;
380     }
381 
382     /**
383      * @dev Returns `true` if the contract is currently initializing. See {onlyInitializing}.
384      */
385     function _isInitializing() internal view returns (bool) {
386         return _initializing;
387     }
388 }
389 
390 // File: @openzeppelin/contracts/utils/Counters.sol
391 
392 
393 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
394 
395 pragma solidity ^0.8.0;
396 
397 /**
398  * @title Counters
399  * @author Matt Condon (@shrugs)
400  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
401  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
402  *
403  * Include with `using Counters for Counters.Counter;`
404  */
405 library Counters {
406     struct Counter {
407         // This variable should never be directly accessed by users of the library: interactions must be restricted to
408         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
409         // this feature: see https://github.com/ethereum/solidity/issues/4637
410         uint256 _value; // default: 0
411     }
412 
413     function current(Counter storage counter) internal view returns (uint256) {
414         return counter._value;
415     }
416 
417     function increment(Counter storage counter) internal {
418         unchecked {
419             counter._value += 1;
420         }
421     }
422 
423     function decrement(Counter storage counter) internal {
424         uint256 value = counter._value;
425         require(value > 0, "Counter: decrement overflow");
426         unchecked {
427             counter._value = value - 1;
428         }
429     }
430 
431     function reset(Counter storage counter) internal {
432         counter._value = 0;
433     }
434 }
435 
436 // File: @openzeppelin/contracts/utils/Context.sol
437 
438 
439 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
440 
441 pragma solidity ^0.8.0;
442 
443 /**
444  * @dev Provides information about the current execution context, including the
445  * sender of the transaction and its data. While these are generally available
446  * via msg.sender and msg.data, they should not be accessed in such a direct
447  * manner, since when dealing with meta-transactions the account sending and
448  * paying for execution may not be the actual sender (as far as an application
449  * is concerned).
450  *
451  * This contract is only required for intermediate, library-like contracts.
452  */
453 abstract contract Context {
454     function _msgSender() internal view virtual returns (address) {
455         return msg.sender;
456     }
457 
458     function _msgData() internal view virtual returns (bytes calldata) {
459         return msg.data;
460     }
461 }
462 
463 // File: @openzeppelin/contracts/access/Ownable.sol
464 
465 
466 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
467 
468 pragma solidity ^0.8.0;
469 
470 
471 /**
472  * @dev Contract module which provides a basic access control mechanism, where
473  * there is an account (an owner) that can be granted exclusive access to
474  * specific functions.
475  *
476  * By default, the owner account will be the one that deploys the contract. This
477  * can later be changed with {transferOwnership}.
478  *
479  * This module is used through inheritance. It will make available the modifier
480  * `onlyOwner`, which can be applied to your functions to restrict their use to
481  * the owner.
482  */
483 abstract contract Ownable is Context {
484     address private _owner;
485 
486     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
487 
488     /**
489      * @dev Initializes the contract setting the deployer as the initial owner.
490      */
491     constructor() {
492         _transferOwnership(_msgSender());
493     }
494 
495     /**
496      * @dev Throws if called by any account other than the owner.
497      */
498     modifier onlyOwner() {
499         _checkOwner();
500         _;
501     }
502 
503     /**
504      * @dev Returns the address of the current owner.
505      */
506     function owner() public view virtual returns (address) {
507         return _owner;
508     }
509 
510     /**
511      * @dev Throws if the sender is not the owner.
512      */
513     function _checkOwner() internal view virtual {
514         require(owner() == _msgSender(), "Ownable: caller is not the owner");
515     }
516 
517     /**
518      * @dev Leaves the contract without owner. It will not be possible to call
519      * `onlyOwner` functions anymore. Can only be called by the current owner.
520      *
521      * NOTE: Renouncing ownership will leave the contract without an owner,
522      * thereby removing any functionality that is only available to the owner.
523      */
524     function renounceOwnership() public virtual onlyOwner {
525         _transferOwnership(address(0));
526     }
527 
528     /**
529      * @dev Transfers ownership of the contract to a new account (`newOwner`).
530      * Can only be called by the current owner.
531      */
532     function transferOwnership(address newOwner) public virtual onlyOwner {
533         require(newOwner != address(0), "Ownable: new owner is the zero address");
534         _transferOwnership(newOwner);
535     }
536 
537     /**
538      * @dev Transfers ownership of the contract to a new account (`newOwner`).
539      * Internal function without access restriction.
540      */
541     function _transferOwnership(address newOwner) internal virtual {
542         address oldOwner = _owner;
543         _owner = newOwner;
544         emit OwnershipTransferred(oldOwner, newOwner);
545     }
546 }
547 
548 // File: test_opt/Raffle_Final3.sol
549 
550 
551 /**
552 * @title Whoopdoop Raffle
553 * @author Captain Unknown
554 */
555 pragma solidity ^0.8.19.0;
556 
557 
558 
559 
560 interface IERC20{
561     function balanceOf(address _owner) external view returns (uint256 balance);
562     function transfer(address _to, uint256 _value) external returns (bool success);
563     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
564 }
565 
566 interface IERC721 {
567     function balanceOf(address owner) external view returns (uint256 balance);
568     function transferFrom(address from, address to, uint256 tokenId) external;
569     function safeTransferFrom(address from, address to, uint256 tokenId) external;
570 }
571 
572 contract WhoopDoopRaffle is Ownable, Initializable {
573     using Counters for Counters.Counter;
574     Counters.Counter public currentRaffleId;
575 
576     struct Entry {
577         uint32 lowerBound;
578         uint32 upperBound;
579         address wallet;
580     }
581 
582     struct Prize {
583         address NFTContract;
584         uint32 NFTTokenId;
585     }
586     
587     struct Raffle {
588         uint32 raffleId;
589         uint128 ethPrice;
590         uint128 doopPrice;
591         uint64 endTime;
592         uint32 entriesCount;
593         bool payableWithDoop;
594         bool hasEnded;
595         address winner;
596         Prize rafflePrize;
597     }
598 
599     // Context
600     address public immutable EAPass;
601     address public immutable WDCollection;
602     address public immutable doopToken;
603     uint8 public immutable maxTicketCount;
604 
605     mapping (address => bool) private admin;
606     mapping (uint256 => Raffle) public OnGoingRaffles;
607     mapping (uint256 => Entry[]) public Entries;
608 
609     event RaffleStarted(uint256 indexed raffleId, uint256 price, uint256 endTime, Prize rafflePrize);
610     event Winner(uint256 indexed raffleId, address winner);
611 
612     constructor(address _EAPass, address _WDCollection, address _doopToken, uint8 _maxTicketCount) {
613         EAPass = _EAPass;
614         WDCollection = _WDCollection;
615         doopToken = _doopToken; 
616         maxTicketCount = _maxTicketCount;
617         _disableInitializers();
618     }
619 
620     function startRaffle(uint128 _priceInEth, uint128 _doopPrice, bool _payableWithDoop, uint64 _duration, address _prizeNFTContract, uint32 _prizeNFTTokenId) public {
621         require(admin[msg.sender]);
622         uint64 _endTime = uint64(block.timestamp) + _duration;
623         
624         Raffle memory newRaffle = Raffle({
625             raffleId: uint32(currentRaffleId.current()),
626             ethPrice: _priceInEth,
627             doopPrice: _doopPrice,
628             endTime: _endTime,
629             entriesCount: 0,
630             payableWithDoop: _payableWithDoop,
631             hasEnded: false,
632             winner: address(0),
633             rafflePrize: Prize({
634                 NFTContract: _prizeNFTContract,
635                 NFTTokenId: _prizeNFTTokenId
636             })
637         });
638         OnGoingRaffles[currentRaffleId.current()] = newRaffle;
639         currentRaffleId.increment();
640         
641         IERC721(_prizeNFTContract).transferFrom(msg.sender, address(this), _prizeNFTTokenId);
642         
643         emit RaffleStarted(newRaffle.raffleId, _payableWithDoop ? _doopPrice : _priceInEth, newRaffle.endTime, newRaffle.rafflePrize);
644     }
645 
646     function buyTicket(uint32 _RaffleId, uint32 ticketCount) public payable {
647         isIdValid(_RaffleId);
648         Raffle storage raffle = OnGoingRaffles[_RaffleId];
649 
650         require(block.timestamp < raffle.endTime);
651         require(!raffle.hasEnded);
652         require(ticketCount > 0);
653         require(ticketCount <= maxTicketCount);
654 
655         if (raffle.payableWithDoop) {
656             require(IERC20(doopToken).transferFrom(msg.sender, address(this), raffle.doopPrice * ticketCount));
657         } else {
658             require(raffle.ethPrice * ticketCount == msg.value);
659         }
660 
661         if (isHolderOf(msg.sender, EAPass)) {
662             ticketCount *= 5;
663         } else if (isHolderOf(msg.sender, WDCollection)) {
664             ticketCount *= 3;
665         }
666         
667         Entry[] storage raffleEntries = Entries[_RaffleId];
668         Entry memory lastEntry = raffleEntries.length > 0 ? raffleEntries[raffleEntries.length - 1] : Entry(0, 0, address(0));
669         if (lastEntry.wallet == msg.sender) {
670             raffleEntries[raffleEntries.length - 1].upperBound += ticketCount;
671         } else {
672             uint32 newUpperBound = lastEntry.upperBound + ticketCount;
673             raffleEntries.push(Entry(lastEntry.upperBound + 1, newUpperBound, msg.sender));
674         }
675         raffle.entriesCount += ticketCount;
676     }
677     
678     function endRaffle(uint32 _RaffleId, uint256 seed) public {
679         require(msg.sender == owner() || admin[msg.sender]);
680         
681         Raffle storage raffle = OnGoingRaffles[_RaffleId];
682         isIdValid(_RaffleId);
683         require(raffle.entriesCount > 0);
684         require(block.timestamp >= raffle.endTime);
685         require(!raffle.hasEnded);
686         raffle.hasEnded = true;
687 
688         if (raffle.entriesCount == 0) {
689             IERC721(raffle.rafflePrize.NFTContract).safeTransferFrom(address(this), owner(), raffle.rafflePrize.NFTTokenId);
690             emit Winner(_RaffleId, address(0));
691         } else {
692             Entry[] storage raffleEntries = Entries[_RaffleId];
693             uint256 winnerIndex = seed % raffle.entriesCount;
694             
695             uint256 left = 0;
696             uint256 right = raffleEntries.length - 1;
697             while (left < right) {
698                 uint256 mid = (left + right) / 2;
699                 
700                 if (winnerIndex < raffleEntries[mid].lowerBound) {
701                     right = mid - 1;
702                 } else if (winnerIndex >= raffleEntries[mid].upperBound) {
703                     left = mid + 1;
704                 } else {
705                     left = mid;
706                     break;
707                 }
708             }
709             
710             address winner = raffleEntries[left].wallet;
711             raffle.winner = winner;
712 
713             IERC721(raffle.rafflePrize.NFTContract).safeTransferFrom(address(this), raffle.winner, raffle.rafflePrize.NFTTokenId);
714             emit Winner(_RaffleId, winner);
715         }
716     }
717 
718     // Read functions
719     function raffleExists(uint32 _RaffleId) public view returns (bool) {
720         return _RaffleId < currentRaffleId.current();
721     }
722 
723     function getTotalParticipants(uint256 _RaffleId) public view returns (uint256) {
724         return Entries[_RaffleId].length;
725     }
726 
727     function getOngoingRaffles() public view returns (uint256[] memory) {
728         uint256[] memory raffleIds = new uint256[](currentRaffleId.current());
729         uint256 count = 0;
730         for (uint256 i = 0; i < currentRaffleId.current(); i++) {
731             if (!OnGoingRaffles[i].hasEnded) {
732                 raffleIds[count] = i;
733                 count++;
734             }
735         }
736         uint256[] memory result = new uint256[](count);
737         for (uint256 i = 0; i < count; i++) {
738             result[i] = raffleIds[i];
739         }
740         return result;
741     }
742 
743     function getEndedRaffles() public view returns (uint256[] memory) {
744         uint256[] memory raffleIds = new uint256[](currentRaffleId.current());
745         uint256 count = 0;
746         for (uint256 i = 0; i < currentRaffleId.current(); i++) {
747             if (OnGoingRaffles[i].hasEnded) {
748                 raffleIds[count] = i;
749                 count++;
750             }
751         }
752         uint256[] memory result = new uint256[](count);
753         for (uint256 i = 0; i < count; i++) {
754             result[i] = raffleIds[i];
755         }
756         return result;
757     }
758 
759     function isHolderOf(address user, address NFT) private view returns(bool) {
760         return IERC721(NFT).balanceOf(user) > 0;
761     }
762 
763     function isIdValid(uint32 _RaffleId) internal view {
764         require(raffleExists(_RaffleId));
765     }
766 
767     // Utilities
768     function withdrawAll() public payable onlyOwner {
769         require(address(this).balance > 0 || IERC20(doopToken).balanceOf(address(this)) > 0);
770         IERC20(doopToken).transfer(msg.sender, IERC20(doopToken).balanceOf(address(this)));
771         payable(msg.sender).transfer(address(this).balance);
772     }
773 
774     function withdrawEth(uint256 amount) public payable onlyOwner {
775         require(address(this).balance >= amount);
776         payable(msg.sender).transfer(amount);
777     }
778 
779     function withdrawDoop(uint256 amount) public payable onlyOwner {
780         require(IERC20(doopToken).balanceOf(address(this)) >= amount);
781         IERC20(doopToken).transfer(msg.sender, amount);
782     }
783 
784     function addAdmin(address _admin) public onlyOwner {
785         admin[_admin] = true;
786     }
787 
788     function removeAdmin(address _admin) public onlyOwner {
789         admin[_admin] = false;
790     }
791 }