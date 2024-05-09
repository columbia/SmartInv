1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Strings.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev String operations.
11  */
12 library Strings {
13     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
14 
15     /**
16      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
17      */
18     function toString(uint256 value) internal pure returns (string memory) {
19         // Inspired by OraclizeAPI's implementation - MIT licence
20         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
21 
22         if (value == 0) {
23             return "0";
24         }
25         uint256 temp = value;
26         uint256 digits;
27         while (temp != 0) {
28             digits++;
29             temp /= 10;
30         }
31         bytes memory buffer = new bytes(digits);
32         while (value != 0) {
33             digits -= 1;
34             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
35             value /= 10;
36         }
37         return string(buffer);
38     }
39 
40     /**
41      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
42      */
43     function toHexString(uint256 value) internal pure returns (string memory) {
44         if (value == 0) {
45             return "0x00";
46         }
47         uint256 temp = value;
48         uint256 length = 0;
49         while (temp != 0) {
50             length++;
51             temp >>= 8;
52         }
53         return toHexString(value, length);
54     }
55 
56     /**
57      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
58      */
59     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
60         bytes memory buffer = new bytes(2 * length + 2);
61         buffer[0] = "0";
62         buffer[1] = "x";
63         for (uint256 i = 2 * length + 1; i > 1; --i) {
64             buffer[i] = _HEX_SYMBOLS[value & 0xf];
65             value >>= 4;
66         }
67         require(value == 0, "Strings: hex length insufficient");
68         return string(buffer);
69     }
70 }
71 
72 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
73 
74 
75 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
76 
77 pragma solidity ^0.8.0;
78 
79 /**
80  * @dev Interface of the ERC20 standard as defined in the EIP.
81  */
82 interface IERC20 {
83     /**
84      * @dev Returns the amount of tokens in existence.
85      */
86     function totalSupply() external view returns (uint256);
87 
88     /**
89      * @dev Returns the amount of tokens owned by `account`.
90      */
91     function balanceOf(address account) external view returns (uint256);
92 
93     /**
94      * @dev Moves `amount` tokens from the caller's account to `recipient`.
95      *
96      * Returns a boolean value indicating whether the operation succeeded.
97      *
98      * Emits a {Transfer} event.
99      */
100     function transfer(address recipient, uint256 amount) external returns (bool);
101 
102     /**
103      * @dev Returns the remaining number of tokens that `spender` will be
104      * allowed to spend on behalf of `owner` through {transferFrom}. This is
105      * zero by default.
106      *
107      * This value changes when {approve} or {transferFrom} are called.
108      */
109     function allowance(address owner, address spender) external view returns (uint256);
110 
111     /**
112      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
113      *
114      * Returns a boolean value indicating whether the operation succeeded.
115      *
116      * IMPORTANT: Beware that changing an allowance with this method brings the risk
117      * that someone may use both the old and the new allowance by unfortunate
118      * transaction ordering. One possible solution to mitigate this race
119      * condition is to first reduce the spender's allowance to 0 and set the
120      * desired value afterwards:
121      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
122      *
123      * Emits an {Approval} event.
124      */
125     function approve(address spender, uint256 amount) external returns (bool);
126 
127     /**
128      * @dev Moves `amount` tokens from `sender` to `recipient` using the
129      * allowance mechanism. `amount` is then deducted from the caller's
130      * allowance.
131      *
132      * Returns a boolean value indicating whether the operation succeeded.
133      *
134      * Emits a {Transfer} event.
135      */
136     function transferFrom(
137         address sender,
138         address recipient,
139         uint256 amount
140     ) external returns (bool);
141 
142     /**
143      * @dev Emitted when `value` tokens are moved from one account (`from`) to
144      * another (`to`).
145      *
146      * Note that `value` may be zero.
147      */
148     event Transfer(address indexed from, address indexed to, uint256 value);
149 
150     /**
151      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
152      * a call to {approve}. `value` is the new allowance.
153      */
154     event Approval(address indexed owner, address indexed spender, uint256 value);
155 }
156 
157 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
158 
159 
160 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
161 
162 pragma solidity ^0.8.0;
163 
164 
165 /**
166  * @dev Interface for the optional metadata functions from the ERC20 standard.
167  *
168  * _Available since v4.1._
169  */
170 interface IERC20Metadata is IERC20 {
171     /**
172      * @dev Returns the name of the token.
173      */
174     function name() external view returns (string memory);
175 
176     /**
177      * @dev Returns the symbol of the token.
178      */
179     function symbol() external view returns (string memory);
180 
181     /**
182      * @dev Returns the decimals places of the token.
183      */
184     function decimals() external view returns (uint8);
185 }
186 
187 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
188 
189 
190 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
191 
192 pragma solidity ^0.8.0;
193 
194 /**
195  * @dev Contract module that helps prevent reentrant calls to a function.
196  *
197  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
198  * available, which can be applied to functions to make sure there are no nested
199  * (reentrant) calls to them.
200  *
201  * Note that because there is a single `nonReentrant` guard, functions marked as
202  * `nonReentrant` may not call one another. This can be worked around by making
203  * those functions `private`, and then adding `external` `nonReentrant` entry
204  * points to them.
205  *
206  * TIP: If you would like to learn more about reentrancy and alternative ways
207  * to protect against it, check out our blog post
208  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
209  */
210 abstract contract ReentrancyGuard {
211     // Booleans are more expensive than uint256 or any type that takes up a full
212     // word because each write operation emits an extra SLOAD to first read the
213     // slot's contents, replace the bits taken up by the boolean, and then write
214     // back. This is the compiler's defense against contract upgrades and
215     // pointer aliasing, and it cannot be disabled.
216 
217     // The values being non-zero value makes deployment a bit more expensive,
218     // but in exchange the refund on every call to nonReentrant will be lower in
219     // amount. Since refunds are capped to a percentage of the total
220     // transaction's gas, it is best to keep them low in cases like this one, to
221     // increase the likelihood of the full refund coming into effect.
222     uint256 private constant _NOT_ENTERED = 1;
223     uint256 private constant _ENTERED = 2;
224 
225     uint256 private _status;
226 
227     constructor() {
228         _status = _NOT_ENTERED;
229     }
230 
231     /**
232      * @dev Prevents a contract from calling itself, directly or indirectly.
233      * Calling a `nonReentrant` function from another `nonReentrant`
234      * function is not supported. It is possible to prevent this from happening
235      * by making the `nonReentrant` function external, and making it call a
236      * `private` function that does the actual work.
237      */
238     modifier nonReentrant() {
239         // On the first call to nonReentrant, _notEntered will be true
240         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
241 
242         // Any calls to nonReentrant after this point will fail
243         _status = _ENTERED;
244 
245         _;
246 
247         // By storing the original value once again, a refund is triggered (see
248         // https://eips.ethereum.org/EIPS/eip-2200)
249         _status = _NOT_ENTERED;
250     }
251 }
252 
253 // File: contracts/lib/Constants.sol
254 
255 
256 pragma solidity ^0.8.13;
257 
258 address constant CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS = 0x000000000000AAeB6D7670E522A718067333cd4E;
259 address constant CANONICAL_CORI_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
260 // File: contracts/IOperatorFilterRegistry.sol
261 
262 
263 pragma solidity ^0.8.13;
264 
265 interface IOperatorFilterRegistry {
266     /**
267      * @notice Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns
268      *         true if supplied registrant address is not registered.
269      */
270     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
271 
272     /**
273      * @notice Registers an address with the registry. May be called by address itself or by EIP-173 owner.
274      */
275     function register(address registrant) external;
276 
277     /**
278      * @notice Registers an address with the registry and "subscribes" to another address's filtered operators and codeHashes.
279      */
280     function registerAndSubscribe(address registrant, address subscription) external;
281 
282     /**
283      * @notice Registers an address with the registry and copies the filtered operators and codeHashes from another
284      *         address without subscribing.
285      */
286     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
287 
288     /**
289      * @notice Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.
290      *         Note that this does not remove any filtered addresses or codeHashes.
291      *         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes.
292      */
293     function unregister(address addr) external;
294 
295     /**
296      * @notice Update an operator address for a registered address - when filtered is true, the operator is filtered.
297      */
298     function updateOperator(address registrant, address operator, bool filtered) external;
299 
300     /**
301      * @notice Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates.
302      */
303     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
304 
305     /**
306      * @notice Update a codeHash for a registered address - when filtered is true, the codeHash is filtered.
307      */
308     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
309 
310     /**
311      * @notice Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates.
312      */
313     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
314 
315     /**
316      * @notice Subscribe an address to another registrant's filtered operators and codeHashes. Will remove previous
317      *         subscription if present.
318      *         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,
319      *         subscriptions will not be forwarded. Instead the former subscription's existing entries will still be
320      *         used.
321      */
322     function subscribe(address registrant, address registrantToSubscribe) external;
323 
324     /**
325      * @notice Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes.
326      */
327     function unsubscribe(address registrant, bool copyExistingEntries) external;
328 
329     /**
330      * @notice Get the subscription address of a given registrant, if any.
331      */
332     function subscriptionOf(address addr) external returns (address registrant);
333 
334     /**
335      * @notice Get the set of addresses subscribed to a given registrant.
336      *         Note that order is not guaranteed as updates are made.
337      */
338     function subscribers(address registrant) external returns (address[] memory);
339 
340     /**
341      * @notice Get the subscriber at a given index in the set of addresses subscribed to a given registrant.
342      *         Note that order is not guaranteed as updates are made.
343      */
344     function subscriberAt(address registrant, uint256 index) external returns (address);
345 
346     /**
347      * @notice Copy filtered operators and codeHashes from a different registrantToCopy to addr.
348      */
349     function copyEntriesOf(address registrant, address registrantToCopy) external;
350 
351     /**
352      * @notice Returns true if operator is filtered by a given address or its subscription.
353      */
354     function isOperatorFiltered(address registrant, address operator) external returns (bool);
355 
356     /**
357      * @notice Returns true if the hash of an address's code is filtered by a given address or its subscription.
358      */
359     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
360 
361     /**
362      * @notice Returns true if a codeHash is filtered by a given address or its subscription.
363      */
364     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
365 
366     /**
367      * @notice Returns a list of filtered operators for a given address or its subscription.
368      */
369     function filteredOperators(address addr) external returns (address[] memory);
370 
371     /**
372      * @notice Returns the set of filtered codeHashes for a given address or its subscription.
373      *         Note that order is not guaranteed as updates are made.
374      */
375     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
376 
377     /**
378      * @notice Returns the filtered operator at the given index of the set of filtered operators for a given address or
379      *         its subscription.
380      *         Note that order is not guaranteed as updates are made.
381      */
382     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
383 
384     /**
385      * @notice Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or
386      *         its subscription.
387      *         Note that order is not guaranteed as updates are made.
388      */
389     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
390 
391     /**
392      * @notice Returns true if an address has registered
393      */
394     function isRegistered(address addr) external returns (bool);
395 
396     /**
397      * @dev Convenience method to compute the code hash of an arbitrary contract
398      */
399     function codeHashOf(address addr) external returns (bytes32);
400 }
401 // File: contracts/OperatorFilterer.sol
402 
403 
404 pragma solidity ^0.8.13;
405 
406 
407 /**
408  * @title  OperatorFilterer
409  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
410  *         registrant's entries in the OperatorFilterRegistry.
411  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
412  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
413  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
414  *         Please note that if your token contract does not provide an owner with EIP-173, it must provide
415  *         administration methods on the contract itself to interact with the registry otherwise the subscription
416  *         will be locked to the options set during construction.
417  */
418 
419 abstract contract OperatorFilterer {
420     /// @dev Emitted when an operator is not allowed.
421     error OperatorNotAllowed(address operator);
422 
423     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
424         IOperatorFilterRegistry(CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS);
425 
426     /// @dev The constructor that is called when the contract is being deployed.
427     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
428         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
429         // will not revert, but the contract will need to be registered with the registry once it is deployed in
430         // order for the modifier to filter addresses.
431         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
432             if (subscribe) {
433                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
434             } else {
435                 if (subscriptionOrRegistrantToCopy != address(0)) {
436                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
437                 } else {
438                     OPERATOR_FILTER_REGISTRY.register(address(this));
439                 }
440             }
441         }
442     }
443 
444     /**
445      * @dev A helper function to check if an operator is allowed.
446      */
447     modifier onlyAllowedOperator(address from) virtual {
448         // Allow spending tokens from addresses with balance
449         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
450         // from an EOA.
451         if (from != msg.sender) {
452             _checkFilterOperator(msg.sender);
453         }
454         _;
455     }
456 
457     /**
458      * @dev A helper function to check if an operator approval is allowed.
459      */
460     modifier onlyAllowedOperatorApproval(address operator) virtual {
461         _checkFilterOperator(operator);
462         _;
463     }
464 
465     /**
466      * @dev A helper function to check if an operator is allowed.
467      */
468     function _checkFilterOperator(address operator) internal view virtual {
469         // Check registry code length to facilitate testing in environments without a deployed registry.
470         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
471             // under normal circumstances, this function will revert rather than return false, but inheriting contracts
472             // may specify their own OperatorFilterRegistry implementations, which may behave differently
473             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
474                 revert OperatorNotAllowed(operator);
475             }
476         }
477     }
478 }
479 // File: contracts/DefaultOperatorFilterer.sol
480 
481 
482 pragma solidity ^0.8.13;
483 
484 
485 /**
486  * @title  DefaultOperatorFilterer
487  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
488  * @dev    Please note that if your token contract does not provide an owner with EIP-173, it must provide
489  *         administration methods on the contract itself to interact with the registry otherwise the subscription
490  *         will be locked to the options set during construction.
491  */
492 
493 abstract contract DefaultOperatorFilterer is OperatorFilterer {
494     /// @dev The constructor that is called when the contract is being deployed.
495     constructor() OperatorFilterer(CANONICAL_CORI_SUBSCRIPTION, true) {}
496 }
497 // File: @openzeppelin/contracts/utils/Context.sol
498 
499 
500 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
501 
502 pragma solidity ^0.8.0;
503 
504 /**
505  * @dev Provides information about the current execution context, including the
506  * sender of the transaction and its data. While these are generally available
507  * via msg.sender and msg.data, they should not be accessed in such a direct
508  * manner, since when dealing with meta-transactions the account sending and
509  * paying for execution may not be the actual sender (as far as an application
510  * is concerned).
511  *
512  * This contract is only required for intermediate, library-like contracts.
513  */
514 abstract contract Context {
515     function _msgSender() internal view virtual returns (address) {
516         return msg.sender;
517     }
518 
519     function _msgData() internal view virtual returns (bytes calldata) {
520         return msg.data;
521     }
522 }
523 
524 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
525 
526 
527 // OpenZeppelin Contracts v4.4.1 (token/ERC20/ERC20.sol)
528 
529 pragma solidity ^0.8.0;
530 
531 
532 
533 
534 /**
535  * @dev Implementation of the {IERC20} interface.
536  *
537  * This implementation is agnostic to the way tokens are created. This means
538  * that a supply mechanism has to be added in a derived contract using {_mint}.
539  * For a generic mechanism see {ERC20PresetMinterPauser}.
540  *
541  * TIP: For a detailed writeup see our guide
542  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
543  * to implement supply mechanisms].
544  *
545  * We have followed general OpenZeppelin Contracts guidelines: functions revert
546  * instead returning `false` on failure. This behavior is nonetheless
547  * conventional and does not conflict with the expectations of ERC20
548  * applications.
549  *
550  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
551  * This allows applications to reconstruct the allowance for all accounts just
552  * by listening to said events. Other implementations of the EIP may not emit
553  * these events, as it isn't required by the specification.
554  *
555  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
556  * functions have been added to mitigate the well-known issues around setting
557  * allowances. See {IERC20-approve}.
558  */
559 contract ERC20 is Context, IERC20, IERC20Metadata {
560     mapping(address => uint256) private _balances;
561 
562     mapping(address => mapping(address => uint256)) private _allowances;
563 
564     uint256 private _totalSupply;
565 
566     string private _name;
567     string private _symbol;
568 
569     /**
570      * @dev Sets the values for {name} and {symbol}.
571      *
572      * The default value of {decimals} is 18. To select a different value for
573      * {decimals} you should overload it.
574      *
575      * All two of these values are immutable: they can only be set once during
576      * construction.
577      */
578     constructor(string memory name_, string memory symbol_) {
579         _name = name_;
580         _symbol = symbol_;
581     }
582 
583     /**
584      * @dev Returns the name of the token.
585      */
586     function name() public view virtual override returns (string memory) {
587         return _name;
588     }
589 
590     /**
591      * @dev Returns the symbol of the token, usually a shorter version of the
592      * name.
593      */
594     function symbol() public view virtual override returns (string memory) {
595         return _symbol;
596     }
597 
598     /**
599      * @dev Returns the number of decimals used to get its user representation.
600      * For example, if `decimals` equals `2`, a balance of `505` tokens should
601      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
602      *
603      * Tokens usually opt for a value of 18, imitating the relationship between
604      * Ether and Wei. This is the value {ERC20} uses, unless this function is
605      * overridden;
606      *
607      * NOTE: This information is only used for _display_ purposes: it in
608      * no way affects any of the arithmetic of the contract, including
609      * {IERC20-balanceOf} and {IERC20-transfer}.
610      */
611     function decimals() public view virtual override returns (uint8) {
612         return 18;
613     }
614 
615     /**
616      * @dev See {IERC20-totalSupply}.
617      */
618     function totalSupply() public view virtual override returns (uint256) {
619         return _totalSupply;
620     }
621 
622     /**
623      * @dev See {IERC20-balanceOf}.
624      */
625     function balanceOf(address account) public view virtual override returns (uint256) {
626         return _balances[account];
627     }
628 
629     /**
630      * @dev See {IERC20-transfer}.
631      *
632      * Requirements:
633      *
634      * - `recipient` cannot be the zero address.
635      * - the caller must have a balance of at least `amount`.
636      */
637     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
638         _transfer(_msgSender(), recipient, amount);
639         return true;
640     }
641 
642     /**
643      * @dev See {IERC20-allowance}.
644      */
645     function allowance(address owner, address spender) public view virtual override returns (uint256) {
646         return _allowances[owner][spender];
647     }
648 
649     /**
650      * @dev See {IERC20-approve}.
651      *
652      * Requirements:
653      *
654      * - `spender` cannot be the zero address.
655      */
656     function approve(address spender, uint256 amount) public virtual override returns (bool) {
657         _approve(_msgSender(), spender, amount);
658         return true;
659     }
660 
661     /**
662      * @dev See {IERC20-transferFrom}.
663      *
664      * Emits an {Approval} event indicating the updated allowance. This is not
665      * required by the EIP. See the note at the beginning of {ERC20}.
666      *
667      * Requirements:
668      *
669      * - `sender` and `recipient` cannot be the zero address.
670      * - `sender` must have a balance of at least `amount`.
671      * - the caller must have allowance for ``sender``'s tokens of at least
672      * `amount`.
673      */
674     function transferFrom(
675         address sender,
676         address recipient,
677         uint256 amount
678     ) public virtual override returns (bool) {
679         _transfer(sender, recipient, amount);
680 
681         uint256 currentAllowance = _allowances[sender][_msgSender()];
682         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
683         unchecked {
684             _approve(sender, _msgSender(), currentAllowance - amount);
685         }
686 
687         return true;
688     }
689 
690     /**
691      * @dev Atomically increases the allowance granted to `spender` by the caller.
692      *
693      * This is an alternative to {approve} that can be used as a mitigation for
694      * problems described in {IERC20-approve}.
695      *
696      * Emits an {Approval} event indicating the updated allowance.
697      *
698      * Requirements:
699      *
700      * - `spender` cannot be the zero address.
701      */
702     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
703         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
704         return true;
705     }
706 
707     /**
708      * @dev Atomically decreases the allowance granted to `spender` by the caller.
709      *
710      * This is an alternative to {approve} that can be used as a mitigation for
711      * problems described in {IERC20-approve}.
712      *
713      * Emits an {Approval} event indicating the updated allowance.
714      *
715      * Requirements:
716      *
717      * - `spender` cannot be the zero address.
718      * - `spender` must have allowance for the caller of at least
719      * `subtractedValue`.
720      */
721     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
722         uint256 currentAllowance = _allowances[_msgSender()][spender];
723         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
724         unchecked {
725             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
726         }
727 
728         return true;
729     }
730 
731     /**
732      * @dev Moves `amount` of tokens from `sender` to `recipient`.
733      *
734      * This internal function is equivalent to {transfer}, and can be used to
735      * e.g. implement automatic token fees, slashing mechanisms, etc.
736      *
737      * Emits a {Transfer} event.
738      *
739      * Requirements:
740      *
741      * - `sender` cannot be the zero address.
742      * - `recipient` cannot be the zero address.
743      * - `sender` must have a balance of at least `amount`.
744      */
745     function _transfer(
746         address sender,
747         address recipient,
748         uint256 amount
749     ) internal virtual {
750         require(sender != address(0), "ERC20: transfer from the zero address");
751         require(recipient != address(0), "ERC20: transfer to the zero address");
752 
753         _beforeTokenTransfer(sender, recipient, amount);
754 
755         uint256 senderBalance = _balances[sender];
756         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
757         unchecked {
758             _balances[sender] = senderBalance - amount;
759         }
760         _balances[recipient] += amount;
761 
762         emit Transfer(sender, recipient, amount);
763 
764         _afterTokenTransfer(sender, recipient, amount);
765     }
766 
767     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
768      * the total supply.
769      *
770      * Emits a {Transfer} event with `from` set to the zero address.
771      *
772      * Requirements:
773      *
774      * - `account` cannot be the zero address.
775      */
776     function _mint(address account, uint256 amount) internal virtual {
777         require(account != address(0), "ERC20: mint to the zero address");
778 
779         _beforeTokenTransfer(address(0), account, amount);
780 
781         _totalSupply += amount;
782         _balances[account] += amount;
783         emit Transfer(address(0), account, amount);
784 
785         _afterTokenTransfer(address(0), account, amount);
786     }
787 
788     /**
789      * @dev Destroys `amount` tokens from `account`, reducing the
790      * total supply.
791      *
792      * Emits a {Transfer} event with `to` set to the zero address.
793      *
794      * Requirements:
795      *
796      * - `account` cannot be the zero address.
797      * - `account` must have at least `amount` tokens.
798      */
799     function _burn(address account, uint256 amount) internal virtual {
800         require(account != address(0), "ERC20: burn from the zero address");
801 
802         _beforeTokenTransfer(account, address(0), amount);
803 
804         uint256 accountBalance = _balances[account];
805         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
806         unchecked {
807             _balances[account] = accountBalance - amount;
808         }
809         _totalSupply -= amount;
810 
811         emit Transfer(account, address(0), amount);
812 
813         _afterTokenTransfer(account, address(0), amount);
814     }
815 
816     /**
817      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
818      *
819      * This internal function is equivalent to `approve`, and can be used to
820      * e.g. set automatic allowances for certain subsystems, etc.
821      *
822      * Emits an {Approval} event.
823      *
824      * Requirements:
825      *
826      * - `owner` cannot be the zero address.
827      * - `spender` cannot be the zero address.
828      */
829     function _approve(
830         address owner,
831         address spender,
832         uint256 amount
833     ) internal virtual {
834         require(owner != address(0), "ERC20: approve from the zero address");
835         require(spender != address(0), "ERC20: approve to the zero address");
836 
837         _allowances[owner][spender] = amount;
838         emit Approval(owner, spender, amount);
839     }
840 
841     /**
842      * @dev Hook that is called before any transfer of tokens. This includes
843      * minting and burning.
844      *
845      * Calling conditions:
846      *
847      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
848      * will be transferred to `to`.
849      * - when `from` is zero, `amount` tokens will be minted for `to`.
850      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
851      * - `from` and `to` are never both zero.
852      *
853      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
854      */
855     function _beforeTokenTransfer(
856         address from,
857         address to,
858         uint256 amount
859     ) internal virtual {}
860 
861     /**
862      * @dev Hook that is called after any transfer of tokens. This includes
863      * minting and burning.
864      *
865      * Calling conditions:
866      *
867      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
868      * has been transferred to `to`.
869      * - when `from` is zero, `amount` tokens have been minted for `to`.
870      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
871      * - `from` and `to` are never both zero.
872      *
873      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
874      */
875     function _afterTokenTransfer(
876         address from,
877         address to,
878         uint256 amount
879     ) internal virtual {}
880 }
881 
882 // File: @openzeppelin/contracts/access/Ownable.sol
883 
884 
885 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
886 
887 pragma solidity ^0.8.0;
888 
889 
890 /**
891  * @dev Contract module which provides a basic access control mechanism, where
892  * there is an account (an owner) that can be granted exclusive access to
893  * specific functions.
894  *
895  * By default, the owner account will be the one that deploys the contract. This
896  * can later be changed with {transferOwnership}.
897  *
898  * This module is used through inheritance. It will make available the modifier
899  * `onlyOwner`, which can be applied to your functions to restrict their use to
900  * the owner.
901  */
902 abstract contract Ownable is Context {
903     address private _owner;
904 
905     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
906 
907     /**
908      * @dev Initializes the contract setting the deployer as the initial owner.
909      */
910     constructor() {
911         _transferOwnership(_msgSender());
912     }
913 
914     /**
915      * @dev Throws if called by any account other than the owner.
916      */
917     modifier onlyOwner() {
918         _checkOwner();
919         _;
920     }
921 
922     /**
923      * @dev Returns the address of the current owner.
924      */
925     function owner() public view virtual returns (address) {
926         return _owner;
927     }
928 
929     /**
930      * @dev Throws if the sender is not the owner.
931      */
932     function _checkOwner() internal view virtual {
933         require(owner() == _msgSender(), "Ownable: caller is not the owner");
934     }
935 
936     /**
937      * @dev Leaves the contract without owner. It will not be possible to call
938      * `onlyOwner` functions anymore. Can only be called by the current owner.
939      *
940      * NOTE: Renouncing ownership will leave the contract without an owner,
941      * thereby removing any functionality that is only available to the owner.
942      */
943     function renounceOwnership() public virtual onlyOwner {
944         _transferOwnership(address(0));
945     }
946 
947     /**
948      * @dev Transfers ownership of the contract to a new account (`newOwner`).
949      * Can only be called by the current owner.
950      */
951     function transferOwnership(address newOwner) public virtual onlyOwner {
952         require(newOwner != address(0), "Ownable: new owner is the zero address");
953         _transferOwnership(newOwner);
954     }
955 
956     /**
957      * @dev Transfers ownership of the contract to a new account (`newOwner`).
958      * Internal function without access restriction.
959      */
960     function _transferOwnership(address newOwner) internal virtual {
961         address oldOwner = _owner;
962         _owner = newOwner;
963         emit OwnershipTransferred(oldOwner, newOwner);
964     }
965 }
966 
967 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
968 
969 
970 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
971 
972 pragma solidity ^0.8.0;
973 
974 /**
975  * @dev Interface of the ERC165 standard, as defined in the
976  * https://eips.ethereum.org/EIPS/eip-165[EIP].
977  *
978  * Implementers can declare support of contract interfaces, which can then be
979  * queried by others ({ERC165Checker}).
980  *
981  * For an implementation, see {ERC165}.
982  */
983 interface IERC165 {
984     /**
985      * @dev Returns true if this contract implements the interface defined by
986      * `interfaceId`. See the corresponding
987      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
988      * to learn more about how these ids are created.
989      *
990      * This function call must use less than 30 000 gas.
991      */
992     function supportsInterface(bytes4 interfaceId) external view returns (bool);
993 }
994 
995 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
996 
997 
998 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
999 
1000 pragma solidity ^0.8.0;
1001 
1002 
1003 /**
1004  * @dev Implementation of the {IERC165} interface.
1005  *
1006  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1007  * for the additional interface id that will be supported. For example:
1008  *
1009  * ```solidity
1010  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1011  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1012  * }
1013  * ```
1014  *
1015  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1016  */
1017 abstract contract ERC165 is IERC165 {
1018     /**
1019      * @dev See {IERC165-supportsInterface}.
1020      */
1021     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1022         return interfaceId == type(IERC165).interfaceId;
1023     }
1024 }
1025 
1026 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
1027 
1028 
1029 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
1030 
1031 pragma solidity ^0.8.0;
1032 
1033 
1034 /**
1035  * @dev Interface for the NFT Royalty Standard.
1036  *
1037  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
1038  * support for royalty payments across all NFT marketplaces and ecosystem participants.
1039  *
1040  * _Available since v4.5._
1041  */
1042 interface IERC2981 is IERC165 {
1043     /**
1044      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
1045      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
1046      */
1047     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1048         external
1049         view
1050         returns (address receiver, uint256 royaltyAmount);
1051 }
1052 
1053 // File: @openzeppelin/contracts/token/common/ERC2981.sol
1054 
1055 
1056 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
1057 
1058 pragma solidity ^0.8.0;
1059 
1060 
1061 
1062 /**
1063  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
1064  *
1065  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
1066  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
1067  *
1068  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
1069  * fee is specified in basis points by default.
1070  *
1071  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
1072  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
1073  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
1074  *
1075  * _Available since v4.5._
1076  */
1077 abstract contract ERC2981 is IERC2981, ERC165 {
1078     struct RoyaltyInfo {
1079         address receiver;
1080         uint96 royaltyFraction;
1081     }
1082 
1083     RoyaltyInfo private _defaultRoyaltyInfo;
1084     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
1085 
1086     /**
1087      * @dev See {IERC165-supportsInterface}.
1088      */
1089     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
1090         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
1091     }
1092 
1093     /**
1094      * @inheritdoc IERC2981
1095      */
1096     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
1097         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
1098 
1099         if (royalty.receiver == address(0)) {
1100             royalty = _defaultRoyaltyInfo;
1101         }
1102 
1103         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
1104 
1105         return (royalty.receiver, royaltyAmount);
1106     }
1107 
1108     /**
1109      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
1110      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
1111      * override.
1112      */
1113     function _feeDenominator() internal pure virtual returns (uint96) {
1114         return 10000;
1115     }
1116 
1117     /**
1118      * @dev Sets the royalty information that all ids in this contract will default to.
1119      *
1120      * Requirements:
1121      *
1122      * - `receiver` cannot be the zero address.
1123      * - `feeNumerator` cannot be greater than the fee denominator.
1124      */
1125     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
1126         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1127         require(receiver != address(0), "ERC2981: invalid receiver");
1128 
1129         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
1130     }
1131 
1132     /**
1133      * @dev Removes default royalty information.
1134      */
1135     function _deleteDefaultRoyalty() internal virtual {
1136         delete _defaultRoyaltyInfo;
1137     }
1138 
1139     /**
1140      * @dev Sets the royalty information for a specific token id, overriding the global default.
1141      *
1142      * Requirements:
1143      *
1144      * - `receiver` cannot be the zero address.
1145      * - `feeNumerator` cannot be greater than the fee denominator.
1146      */
1147     function _setTokenRoyalty(
1148         uint256 tokenId,
1149         address receiver,
1150         uint96 feeNumerator
1151     ) internal virtual {
1152         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1153         require(receiver != address(0), "ERC2981: Invalid parameters");
1154 
1155         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
1156     }
1157 
1158     /**
1159      * @dev Resets royalty information for the token id back to the global default.
1160      */
1161     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
1162         delete _tokenRoyaltyInfo[tokenId];
1163     }
1164 }
1165 
1166 // File: contracts/IERC721A.sol
1167 
1168 
1169 // ERC721A Contracts v4.2.3
1170 // Creator: Chiru Labs
1171 
1172 pragma solidity ^0.8.4;
1173 
1174 /**
1175  * @dev Interface of ERC721A.
1176  */
1177 interface IERC721A {
1178     /**
1179      * The caller must own the token or be an approved operator.
1180      */
1181     error ApprovalCallerNotOwnerNorApproved();
1182 
1183     /**
1184      * The token does not exist.
1185      */
1186     error ApprovalQueryForNonexistentToken();
1187 
1188     /**
1189      * Cannot query the balance for the zero address.
1190      */
1191     error BalanceQueryForZeroAddress();
1192 
1193     /**
1194      * Cannot mint to the zero address.
1195      */
1196     error MintToZeroAddress();
1197 
1198     /**
1199      * The quantity of tokens minted must be more than zero.
1200      */
1201     error MintZeroQuantity();
1202 
1203     /**
1204      * The token does not exist.
1205      */
1206     error OwnerQueryForNonexistentToken();
1207 
1208     /**
1209      * The caller must own the token or be an approved operator.
1210      */
1211     error TransferCallerNotOwnerNorApproved();
1212 
1213     /**
1214      * The token must be owned by `from`.
1215      */
1216     error TransferFromIncorrectOwner();
1217 
1218     /**
1219      * Cannot safely transfer to a contract that does not implement the
1220      * ERC721Receiver interface.
1221      */
1222     error TransferToNonERC721ReceiverImplementer();
1223 
1224     /**
1225      * Cannot transfer to the zero address.
1226      */
1227     error TransferToZeroAddress();
1228 
1229     /**
1230      * The token does not exist.
1231      */
1232     error URIQueryForNonexistentToken();
1233 
1234     /**
1235      * The `quantity` minted with ERC2309 exceeds the safety limit.
1236      */
1237     error MintERC2309QuantityExceedsLimit();
1238 
1239     /**
1240      * The `extraData` cannot be set on an unintialized ownership slot.
1241      */
1242     error OwnershipNotInitializedForExtraData();
1243 
1244     // =============================================================
1245     //                            STRUCTS
1246     // =============================================================
1247 
1248     struct TokenOwnership {
1249         // The address of the owner.
1250         address addr;
1251         // Stores the start time of ownership with minimal overhead for tokenomics.
1252         uint64 startTimestamp;
1253         // Whether the token has been burned.
1254         bool burned;
1255         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
1256         uint24 extraData;
1257     }
1258 
1259     // =============================================================
1260     //                         TOKEN COUNTERS
1261     // =============================================================
1262 
1263     /**
1264      * @dev Returns the total number of tokens in existence.
1265      * Burned tokens will reduce the count.
1266      * To get the total number of tokens minted, please see {_totalMinted}.
1267      */
1268     function totalSupply() external view returns (uint256);
1269 
1270     // =============================================================
1271     //                            IERC165
1272     // =============================================================
1273 
1274     /**
1275      * @dev Returns true if this contract implements the interface defined by
1276      * `interfaceId`. See the corresponding
1277      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1278      * to learn more about how these ids are created.
1279      *
1280      * This function call must use less than 30000 gas.
1281      */
1282     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1283 
1284     // =============================================================
1285     //                            IERC721
1286     // =============================================================
1287 
1288     /**
1289      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1290      */
1291     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1292 
1293     /**
1294      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1295      */
1296     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1297 
1298     /**
1299      * @dev Emitted when `owner` enables or disables
1300      * (`approved`) `operator` to manage all of its assets.
1301      */
1302     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1303 
1304     /**
1305      * @dev Returns the number of tokens in `owner`'s account.
1306      */
1307     function balanceOf(address owner) external view returns (uint256 balance);
1308 
1309     /**
1310      * @dev Returns the owner of the `tokenId` token.
1311      *
1312      * Requirements:
1313      *
1314      * - `tokenId` must exist.
1315      */
1316     function ownerOf(uint256 tokenId) external view returns (address owner);
1317 
1318     /**
1319      * @dev Safely transfers `tokenId` token from `from` to `to`,
1320      * checking first that contract recipients are aware of the ERC721 protocol
1321      * to prevent tokens from being forever locked.
1322      *
1323      * Requirements:
1324      *
1325      * - `from` cannot be the zero address.
1326      * - `to` cannot be the zero address.
1327      * - `tokenId` token must exist and be owned by `from`.
1328      * - If the caller is not `from`, it must be have been allowed to move
1329      * this token by either {approve} or {setApprovalForAll}.
1330      * - If `to` refers to a smart contract, it must implement
1331      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1332      *
1333      * Emits a {Transfer} event.
1334      */
1335     function safeTransferFrom(
1336         address from,
1337         address to,
1338         uint256 tokenId,
1339         bytes calldata data
1340     ) external payable;
1341 
1342     /**
1343      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1344      */
1345     function safeTransferFrom(
1346         address from,
1347         address to,
1348         uint256 tokenId
1349     ) external payable;
1350 
1351     /**
1352      * @dev Transfers `tokenId` from `from` to `to`.
1353      *
1354      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
1355      * whenever possible.
1356      *
1357      * Requirements:
1358      *
1359      * - `from` cannot be the zero address.
1360      * - `to` cannot be the zero address.
1361      * - `tokenId` token must be owned by `from`.
1362      * - If the caller is not `from`, it must be approved to move this token
1363      * by either {approve} or {setApprovalForAll}.
1364      *
1365      * Emits a {Transfer} event.
1366      */
1367     function transferFrom(
1368         address from,
1369         address to,
1370         uint256 tokenId
1371     ) external payable;
1372 
1373     /**
1374      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1375      * The approval is cleared when the token is transferred.
1376      *
1377      * Only a single account can be approved at a time, so approving the
1378      * zero address clears previous approvals.
1379      *
1380      * Requirements:
1381      *
1382      * - The caller must own the token or be an approved operator.
1383      * - `tokenId` must exist.
1384      *
1385      * Emits an {Approval} event.
1386      */
1387     function approve(address to, uint256 tokenId) external payable;
1388 
1389     /**
1390      * @dev Approve or remove `operator` as an operator for the caller.
1391      * Operators can call {transferFrom} or {safeTransferFrom}
1392      * for any token owned by the caller.
1393      *
1394      * Requirements:
1395      *
1396      * - The `operator` cannot be the caller.
1397      *
1398      * Emits an {ApprovalForAll} event.
1399      */
1400     function setApprovalForAll(address operator, bool _approved) external;
1401 
1402     /**
1403      * @dev Returns the account approved for `tokenId` token.
1404      *
1405      * Requirements:
1406      *
1407      * - `tokenId` must exist.
1408      */
1409     function getApproved(uint256 tokenId) external view returns (address operator);
1410 
1411     /**
1412      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1413      *
1414      * See {setApprovalForAll}.
1415      */
1416     function isApprovedForAll(address owner, address operator) external view returns (bool);
1417 
1418     // =============================================================
1419     //                        IERC721Metadata
1420     // =============================================================
1421 
1422     /**
1423      * @dev Returns the token collection name.
1424      */
1425     function name() external view returns (string memory);
1426 
1427     /**
1428      * @dev Returns the token collection symbol.
1429      */
1430     function symbol() external view returns (string memory);
1431 
1432     /**
1433      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1434      */
1435     function tokenURI(uint256 tokenId) external view returns (string memory);
1436 
1437     // =============================================================
1438     //                           IERC2309
1439     // =============================================================
1440 
1441     /**
1442      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1443      * (inclusive) is transferred from `from` to `to`, as defined in the
1444      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1445      *
1446      * See {_mintERC2309} for more details.
1447      */
1448     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1449 }
1450 // File: contracts/ERC721A.sol
1451 
1452 
1453 // ERC721A Contracts v4.2.3
1454 // Creator: Chiru Labs
1455 
1456 pragma solidity ^0.8.4;
1457 
1458 
1459 /**
1460  * @dev Interface of ERC721 token receiver.
1461  */
1462 interface ERC721A__IERC721Receiver {
1463     function onERC721Received(
1464         address operator,
1465         address from,
1466         uint256 tokenId,
1467         bytes calldata data
1468     ) external returns (bytes4);
1469 }
1470 
1471 /**
1472  * @title ERC721A
1473  *
1474  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1475  * Non-Fungible Token Standard, including the Metadata extension.
1476  * Optimized for lower gas during batch mints.
1477  *
1478  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1479  * starting from `_startTokenId()`.
1480  *
1481  * Assumptions:
1482  *
1483  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1484  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1485  */
1486 contract ERC721A is IERC721A {
1487     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1488     struct TokenApprovalRef {
1489         address value;
1490     }
1491 
1492     // =============================================================
1493     //                           CONSTANTS
1494     // =============================================================
1495 
1496     // Mask of an entry in packed address data.
1497     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1498 
1499     // The bit position of `numberMinted` in packed address data.
1500     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1501 
1502     // The bit position of `numberBurned` in packed address data.
1503     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1504 
1505     // The bit position of `aux` in packed address data.
1506     uint256 private constant _BITPOS_AUX = 192;
1507 
1508     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1509     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1510 
1511     // The bit position of `startTimestamp` in packed ownership.
1512     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1513 
1514     // The bit mask of the `burned` bit in packed ownership.
1515     uint256 private constant _BITMASK_BURNED = 1 << 224;
1516 
1517     // The bit position of the `nextInitialized` bit in packed ownership.
1518     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1519 
1520     // The bit mask of the `nextInitialized` bit in packed ownership.
1521     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1522 
1523     // The bit position of `extraData` in packed ownership.
1524     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1525 
1526     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1527     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1528 
1529     // The mask of the lower 160 bits for addresses.
1530     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1531 
1532     // The maximum `quantity` that can be minted with {_mintERC2309}.
1533     // This limit is to prevent overflows on the address data entries.
1534     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1535     // is required to cause an overflow, which is unrealistic.
1536     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1537 
1538     // The `Transfer` event signature is given by:
1539     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1540     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1541         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1542 
1543     // =============================================================
1544     //                            STORAGE
1545     // =============================================================
1546 
1547     // The next token ID to be minted.
1548     uint256 private _currentIndex;
1549 
1550     // The number of tokens burned.
1551     uint256 private _burnCounter;
1552 
1553     // Token name
1554     string private _name;
1555 
1556     // Token symbol
1557     string private _symbol;
1558 
1559     // Mapping from token ID to ownership details
1560     // An empty struct value does not necessarily mean the token is unowned.
1561     // See {_packedOwnershipOf} implementation for details.
1562     //
1563     // Bits Layout:
1564     // - [0..159]   `addr`
1565     // - [160..223] `startTimestamp`
1566     // - [224]      `burned`
1567     // - [225]      `nextInitialized`
1568     // - [232..255] `extraData`
1569     mapping(uint256 => uint256) private _packedOwnerships;
1570 
1571     // Mapping owner address to address data.
1572     //
1573     // Bits Layout:
1574     // - [0..63]    `balance`
1575     // - [64..127]  `numberMinted`
1576     // - [128..191] `numberBurned`
1577     // - [192..255] `aux`
1578     mapping(address => uint256) private _packedAddressData;
1579 
1580     // Mapping from token ID to approved address.
1581     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1582 
1583     // Mapping from owner to operator approvals
1584     mapping(address => mapping(address => bool)) private _operatorApprovals;
1585 
1586     // =============================================================
1587     //                          CONSTRUCTOR
1588     // =============================================================
1589 
1590     constructor(string memory name_, string memory symbol_) {
1591         _name = name_;
1592         _symbol = symbol_;
1593         _currentIndex = _startTokenId();
1594     }
1595 
1596     // =============================================================
1597     //                   TOKEN COUNTING OPERATIONS
1598     // =============================================================
1599 
1600     /**
1601      * @dev Returns the starting token ID.
1602      * To change the starting token ID, please override this function.
1603      */
1604     function _startTokenId() internal view virtual returns (uint256) {
1605         return 0;
1606     }
1607 
1608     /**
1609      * @dev Returns the next token ID to be minted.
1610      */
1611     function _nextTokenId() internal view virtual returns (uint256) {
1612         return _currentIndex;
1613     }
1614 
1615     /**
1616      * @dev Returns the total number of tokens in existence.
1617      * Burned tokens will reduce the count.
1618      * To get the total number of tokens minted, please see {_totalMinted}.
1619      */
1620     function totalSupply() public view virtual override returns (uint256) {
1621         // Counter underflow is impossible as _burnCounter cannot be incremented
1622         // more than `_currentIndex - _startTokenId()` times.
1623         unchecked {
1624             return _currentIndex - _burnCounter - _startTokenId();
1625         }
1626     }
1627 
1628     /**
1629      * @dev Returns the total amount of tokens minted in the contract.
1630      */
1631     function _totalMinted() internal view virtual returns (uint256) {
1632         // Counter underflow is impossible as `_currentIndex` does not decrement,
1633         // and it is initialized to `_startTokenId()`.
1634         unchecked {
1635             return _currentIndex - _startTokenId();
1636         }
1637     }
1638 
1639     /**
1640      * @dev Returns the total number of tokens burned.
1641      */
1642     function _totalBurned() internal view virtual returns (uint256) {
1643         return _burnCounter;
1644     }
1645 
1646     // =============================================================
1647     //                    ADDRESS DATA OPERATIONS
1648     // =============================================================
1649 
1650     /**
1651      * @dev Returns the number of tokens in `owner`'s account.
1652      */
1653     function balanceOf(address owner) public view virtual override returns (uint256) {
1654         if (owner == address(0)) _revert(BalanceQueryForZeroAddress.selector);
1655         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1656     }
1657 
1658     /**
1659      * Returns the number of tokens minted by `owner`.
1660      */
1661     function _numberMinted(address owner) internal view returns (uint256) {
1662         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1663     }
1664 
1665     /**
1666      * Returns the number of tokens burned by or on behalf of `owner`.
1667      */
1668     function _numberBurned(address owner) internal view returns (uint256) {
1669         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1670     }
1671 
1672     /**
1673      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1674      */
1675     function _getAux(address owner) internal view returns (uint64) {
1676         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1677     }
1678 
1679     /**
1680      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1681      * If there are multiple variables, please pack them into a uint64.
1682      */
1683     function _setAux(address owner, uint64 aux) internal virtual {
1684         uint256 packed = _packedAddressData[owner];
1685         uint256 auxCasted;
1686         // Cast `aux` with assembly to avoid redundant masking.
1687         assembly {
1688             auxCasted := aux
1689         }
1690         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1691         _packedAddressData[owner] = packed;
1692     }
1693 
1694     // =============================================================
1695     //                            IERC165
1696     // =============================================================
1697 
1698     /**
1699      * @dev Returns true if this contract implements the interface defined by
1700      * `interfaceId`. See the corresponding
1701      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1702      * to learn more about how these ids are created.
1703      *
1704      * This function call must use less than 30000 gas.
1705      */
1706     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1707         // The interface IDs are constants representing the first 4 bytes
1708         // of the XOR of all function selectors in the interface.
1709         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1710         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1711         return
1712             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1713             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1714             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1715     }
1716 
1717     // =============================================================
1718     //                        IERC721Metadata
1719     // =============================================================
1720 
1721     /**
1722      * @dev Returns the token collection name.
1723      */
1724     function name() public view virtual override returns (string memory) {
1725         return _name;
1726     }
1727 
1728     /**
1729      * @dev Returns the token collection symbol.
1730      */
1731     function symbol() public view virtual override returns (string memory) {
1732         return _symbol;
1733     }
1734 
1735     /**
1736      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1737      */
1738     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1739         if (!_exists(tokenId)) _revert(URIQueryForNonexistentToken.selector);
1740 
1741         string memory baseURI = _baseURI();
1742         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1743     }
1744 
1745     /**
1746      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1747      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1748      * by default, it can be overridden in child contracts.
1749      */
1750     function _baseURI() internal view virtual returns (string memory) {
1751         return '';
1752     }
1753 
1754     // =============================================================
1755     //                     OWNERSHIPS OPERATIONS
1756     // =============================================================
1757 
1758     /**
1759      * @dev Returns the owner of the `tokenId` token.
1760      *
1761      * Requirements:
1762      *
1763      * - `tokenId` must exist.
1764      */
1765     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1766         return address(uint160(_packedOwnershipOf(tokenId)));
1767     }
1768 
1769     /**
1770      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1771      * It gradually moves to O(1) as tokens get transferred around over time.
1772      */
1773     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1774         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1775     }
1776 
1777     /**
1778      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1779      */
1780     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1781         return _unpackedOwnership(_packedOwnerships[index]);
1782     }
1783 
1784     /**
1785      * @dev Returns whether the ownership slot at `index` is initialized.
1786      * An uninitialized slot does not necessarily mean that the slot has no owner.
1787      */
1788     function _ownershipIsInitialized(uint256 index) internal view virtual returns (bool) {
1789         return _packedOwnerships[index] != 0;
1790     }
1791 
1792     /**
1793      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1794      */
1795     function _initializeOwnershipAt(uint256 index) internal virtual {
1796         if (_packedOwnerships[index] == 0) {
1797             _packedOwnerships[index] = _packedOwnershipOf(index);
1798         }
1799     }
1800 
1801     /**
1802      * Returns the packed ownership data of `tokenId`.
1803      */
1804     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256 packed) {
1805         if (_startTokenId() <= tokenId) {
1806             packed = _packedOwnerships[tokenId];
1807             // If the data at the starting slot does not exist, start the scan.
1808             if (packed == 0) {
1809                 if (tokenId >= _currentIndex) _revert(OwnerQueryForNonexistentToken.selector);
1810                 // Invariant:
1811                 // There will always be an initialized ownership slot
1812                 // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1813                 // before an unintialized ownership slot
1814                 // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1815                 // Hence, `tokenId` will not underflow.
1816                 //
1817                 // We can directly compare the packed value.
1818                 // If the address is zero, packed will be zero.
1819                 for (;;) {
1820                     unchecked {
1821                         packed = _packedOwnerships[--tokenId];
1822                     }
1823                     if (packed == 0) continue;
1824                     if (packed & _BITMASK_BURNED == 0) return packed;
1825                     // Otherwise, the token is burned, and we must revert.
1826                     // This handles the case of batch burned tokens, where only the burned bit
1827                     // of the starting slot is set, and remaining slots are left uninitialized.
1828                     _revert(OwnerQueryForNonexistentToken.selector);
1829                 }
1830             }
1831             // Otherwise, the data exists and we can skip the scan.
1832             // This is possible because we have already achieved the target condition.
1833             // This saves 2143 gas on transfers of initialized tokens.
1834             // If the token is not burned, return `packed`. Otherwise, revert.
1835             if (packed & _BITMASK_BURNED == 0) return packed;
1836         }
1837         _revert(OwnerQueryForNonexistentToken.selector);
1838     }
1839 
1840     /**
1841      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1842      */
1843     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1844         ownership.addr = address(uint160(packed));
1845         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1846         ownership.burned = packed & _BITMASK_BURNED != 0;
1847         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1848     }
1849 
1850     /**
1851      * @dev Packs ownership data into a single uint256.
1852      */
1853     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1854         assembly {
1855             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1856             owner := and(owner, _BITMASK_ADDRESS)
1857             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1858             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1859         }
1860     }
1861 
1862     /**
1863      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1864      */
1865     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1866         // For branchless setting of the `nextInitialized` flag.
1867         assembly {
1868             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1869             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1870         }
1871     }
1872 
1873     // =============================================================
1874     //                      APPROVAL OPERATIONS
1875     // =============================================================
1876 
1877     /**
1878      * @dev Gives permission to `to` to transfer `tokenId` token to another account. See {ERC721A-_approve}.
1879      *
1880      * Requirements:
1881      *
1882      * - The caller must own the token or be an approved operator.
1883      */
1884     function approve(address to, uint256 tokenId) public payable virtual override {
1885         _approve(to, tokenId, true);
1886     }
1887 
1888     /**
1889      * @dev Returns the account approved for `tokenId` token.
1890      *
1891      * Requirements:
1892      *
1893      * - `tokenId` must exist.
1894      */
1895     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1896         if (!_exists(tokenId)) _revert(ApprovalQueryForNonexistentToken.selector);
1897 
1898         return _tokenApprovals[tokenId].value;
1899     }
1900 
1901     /**
1902      * @dev Approve or remove `operator` as an operator for the caller.
1903      * Operators can call {transferFrom} or {safeTransferFrom}
1904      * for any token owned by the caller.
1905      *
1906      * Requirements:
1907      *
1908      * - The `operator` cannot be the caller.
1909      *
1910      * Emits an {ApprovalForAll} event.
1911      */
1912     function setApprovalForAll(address operator, bool approved) public virtual override {
1913         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1914         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1915     }
1916 
1917     /**
1918      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1919      *
1920      * See {setApprovalForAll}.
1921      */
1922     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1923         return _operatorApprovals[owner][operator];
1924     }
1925 
1926     /**
1927      * @dev Returns whether `tokenId` exists.
1928      *
1929      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1930      *
1931      * Tokens start existing when they are minted. See {_mint}.
1932      */
1933     function _exists(uint256 tokenId) internal view virtual returns (bool result) {
1934         if (_startTokenId() <= tokenId) {
1935             if (tokenId < _currentIndex) {
1936                 uint256 packed;
1937                 while ((packed = _packedOwnerships[tokenId]) == 0) --tokenId;
1938                 result = packed & _BITMASK_BURNED == 0;
1939             }
1940         }
1941     }
1942 
1943     /**
1944      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1945      */
1946     function _isSenderApprovedOrOwner(
1947         address approvedAddress,
1948         address owner,
1949         address msgSender
1950     ) private pure returns (bool result) {
1951         assembly {
1952             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1953             owner := and(owner, _BITMASK_ADDRESS)
1954             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1955             msgSender := and(msgSender, _BITMASK_ADDRESS)
1956             // `msgSender == owner || msgSender == approvedAddress`.
1957             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1958         }
1959     }
1960 
1961     /**
1962      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1963      */
1964     function _getApprovedSlotAndAddress(uint256 tokenId)
1965         private
1966         view
1967         returns (uint256 approvedAddressSlot, address approvedAddress)
1968     {
1969         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1970         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1971         assembly {
1972             approvedAddressSlot := tokenApproval.slot
1973             approvedAddress := sload(approvedAddressSlot)
1974         }
1975     }
1976 
1977     // =============================================================
1978     //                      TRANSFER OPERATIONS
1979     // =============================================================
1980 
1981     /**
1982      * @dev Transfers `tokenId` from `from` to `to`.
1983      *
1984      * Requirements:
1985      *
1986      * - `from` cannot be the zero address.
1987      * - `to` cannot be the zero address.
1988      * - `tokenId` token must be owned by `from`.
1989      * - If the caller is not `from`, it must be approved to move this token
1990      * by either {approve} or {setApprovalForAll}.
1991      *
1992      * Emits a {Transfer} event.
1993      */
1994     function transferFrom(
1995         address from,
1996         address to,
1997         uint256 tokenId
1998     ) public payable virtual override {
1999         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2000 
2001         // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
2002         from = address(uint160(uint256(uint160(from)) & _BITMASK_ADDRESS));
2003 
2004         if (address(uint160(prevOwnershipPacked)) != from) _revert(TransferFromIncorrectOwner.selector);
2005 
2006         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2007 
2008         // The nested ifs save around 20+ gas over a compound boolean condition.
2009         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2010             if (!isApprovedForAll(from, _msgSenderERC721A())) _revert(TransferCallerNotOwnerNorApproved.selector);
2011 
2012         _beforeTokenTransfers(from, to, tokenId, 1);
2013 
2014         // Clear approvals from the previous owner.
2015         assembly {
2016             if approvedAddress {
2017                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2018                 sstore(approvedAddressSlot, 0)
2019             }
2020         }
2021 
2022         // Underflow of the sender's balance is impossible because we check for
2023         // ownership above and the recipient's balance can't realistically overflow.
2024         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2025         unchecked {
2026             // We can directly increment and decrement the balances.
2027             --_packedAddressData[from]; // Updates: `balance -= 1`.
2028             ++_packedAddressData[to]; // Updates: `balance += 1`.
2029 
2030             // Updates:
2031             // - `address` to the next owner.
2032             // - `startTimestamp` to the timestamp of transfering.
2033             // - `burned` to `false`.
2034             // - `nextInitialized` to `true`.
2035             _packedOwnerships[tokenId] = _packOwnershipData(
2036                 to,
2037                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
2038             );
2039 
2040             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2041             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2042                 uint256 nextTokenId = tokenId + 1;
2043                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2044                 if (_packedOwnerships[nextTokenId] == 0) {
2045                     // If the next slot is within bounds.
2046                     if (nextTokenId != _currentIndex) {
2047                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2048                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2049                     }
2050                 }
2051             }
2052         }
2053 
2054         // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
2055         uint256 toMasked = uint256(uint160(to)) & _BITMASK_ADDRESS;
2056         assembly {
2057             // Emit the `Transfer` event.
2058             log4(
2059                 0, // Start of data (0, since no data).
2060                 0, // End of data (0, since no data).
2061                 _TRANSFER_EVENT_SIGNATURE, // Signature.
2062                 from, // `from`.
2063                 toMasked, // `to`.
2064                 tokenId // `tokenId`.
2065             )
2066         }
2067         if (toMasked == 0) _revert(TransferToZeroAddress.selector);
2068 
2069         _afterTokenTransfers(from, to, tokenId, 1);
2070     }
2071 
2072     /**
2073      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
2074      */
2075     function safeTransferFrom(
2076         address from,
2077         address to,
2078         uint256 tokenId
2079     ) public payable virtual override {
2080         safeTransferFrom(from, to, tokenId, '');
2081     }
2082 
2083     /**
2084      * @dev Safely transfers `tokenId` token from `from` to `to`.
2085      *
2086      * Requirements:
2087      *
2088      * - `from` cannot be the zero address.
2089      * - `to` cannot be the zero address.
2090      * - `tokenId` token must exist and be owned by `from`.
2091      * - If the caller is not `from`, it must be approved to move this token
2092      * by either {approve} or {setApprovalForAll}.
2093      * - If `to` refers to a smart contract, it must implement
2094      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2095      *
2096      * Emits a {Transfer} event.
2097      */
2098     function safeTransferFrom(
2099         address from,
2100         address to,
2101         uint256 tokenId,
2102         bytes memory _data
2103     ) public payable virtual override {
2104         transferFrom(from, to, tokenId);
2105         if (to.code.length != 0)
2106             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
2107                 _revert(TransferToNonERC721ReceiverImplementer.selector);
2108             }
2109     }
2110 
2111     /**
2112      * @dev Hook that is called before a set of serially-ordered token IDs
2113      * are about to be transferred. This includes minting.
2114      * And also called before burning one token.
2115      *
2116      * `startTokenId` - the first token ID to be transferred.
2117      * `quantity` - the amount to be transferred.
2118      *
2119      * Calling conditions:
2120      *
2121      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2122      * transferred to `to`.
2123      * - When `from` is zero, `tokenId` will be minted for `to`.
2124      * - When `to` is zero, `tokenId` will be burned by `from`.
2125      * - `from` and `to` are never both zero.
2126      */
2127     function _beforeTokenTransfers(
2128         address from,
2129         address to,
2130         uint256 startTokenId,
2131         uint256 quantity
2132     ) internal virtual {}
2133 
2134     /**
2135      * @dev Hook that is called after a set of serially-ordered token IDs
2136      * have been transferred. This includes minting.
2137      * And also called after one token has been burned.
2138      *
2139      * `startTokenId` - the first token ID to be transferred.
2140      * `quantity` - the amount to be transferred.
2141      *
2142      * Calling conditions:
2143      *
2144      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2145      * transferred to `to`.
2146      * - When `from` is zero, `tokenId` has been minted for `to`.
2147      * - When `to` is zero, `tokenId` has been burned by `from`.
2148      * - `from` and `to` are never both zero.
2149      */
2150     function _afterTokenTransfers(
2151         address from,
2152         address to,
2153         uint256 startTokenId,
2154         uint256 quantity
2155     ) internal virtual {}
2156 
2157     /**
2158      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2159      *
2160      * `from` - Previous owner of the given token ID.
2161      * `to` - Target address that will receive the token.
2162      * `tokenId` - Token ID to be transferred.
2163      * `_data` - Optional data to send along with the call.
2164      *
2165      * Returns whether the call correctly returned the expected magic value.
2166      */
2167     function _checkContractOnERC721Received(
2168         address from,
2169         address to,
2170         uint256 tokenId,
2171         bytes memory _data
2172     ) private returns (bool) {
2173         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
2174             bytes4 retval
2175         ) {
2176             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
2177         } catch (bytes memory reason) {
2178             if (reason.length == 0) {
2179                 _revert(TransferToNonERC721ReceiverImplementer.selector);
2180             }
2181             assembly {
2182                 revert(add(32, reason), mload(reason))
2183             }
2184         }
2185     }
2186 
2187     // =============================================================
2188     //                        MINT OPERATIONS
2189     // =============================================================
2190 
2191     /**
2192      * @dev Mints `quantity` tokens and transfers them to `to`.
2193      *
2194      * Requirements:
2195      *
2196      * - `to` cannot be the zero address.
2197      * - `quantity` must be greater than 0.
2198      *
2199      * Emits a {Transfer} event for each mint.
2200      */
2201     function _mint(address to, uint256 quantity) internal virtual {
2202         uint256 startTokenId = _currentIndex;
2203         if (quantity == 0) _revert(MintZeroQuantity.selector);
2204 
2205         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2206 
2207         // Overflows are incredibly unrealistic.
2208         // `balance` and `numberMinted` have a maximum limit of 2**64.
2209         // `tokenId` has a maximum limit of 2**256.
2210         unchecked {
2211             // Updates:
2212             // - `address` to the owner.
2213             // - `startTimestamp` to the timestamp of minting.
2214             // - `burned` to `false`.
2215             // - `nextInitialized` to `quantity == 1`.
2216             _packedOwnerships[startTokenId] = _packOwnershipData(
2217                 to,
2218                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2219             );
2220 
2221             // Updates:
2222             // - `balance += quantity`.
2223             // - `numberMinted += quantity`.
2224             //
2225             // We can directly add to the `balance` and `numberMinted`.
2226             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2227 
2228             // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
2229             uint256 toMasked = uint256(uint160(to)) & _BITMASK_ADDRESS;
2230 
2231             if (toMasked == 0) _revert(MintToZeroAddress.selector);
2232 
2233             uint256 end = startTokenId + quantity;
2234             uint256 tokenId = startTokenId;
2235 
2236             do {
2237                 assembly {
2238                     // Emit the `Transfer` event.
2239                     log4(
2240                         0, // Start of data (0, since no data).
2241                         0, // End of data (0, since no data).
2242                         _TRANSFER_EVENT_SIGNATURE, // Signature.
2243                         0, // `address(0)`.
2244                         toMasked, // `to`.
2245                         tokenId // `tokenId`.
2246                     )
2247                 }
2248                 // The `!=` check ensures that large values of `quantity`
2249                 // that overflows uint256 will make the loop run out of gas.
2250             } while (++tokenId != end);
2251 
2252             _currentIndex = end;
2253         }
2254         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2255     }
2256 
2257     /**
2258      * @dev Mints `quantity` tokens and transfers them to `to`.
2259      *
2260      * This function is intended for efficient minting only during contract creation.
2261      *
2262      * It emits only one {ConsecutiveTransfer} as defined in
2263      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
2264      * instead of a sequence of {Transfer} event(s).
2265      *
2266      * Calling this function outside of contract creation WILL make your contract
2267      * non-compliant with the ERC721 standard.
2268      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
2269      * {ConsecutiveTransfer} event is only permissible during contract creation.
2270      *
2271      * Requirements:
2272      *
2273      * - `to` cannot be the zero address.
2274      * - `quantity` must be greater than 0.
2275      *
2276      * Emits a {ConsecutiveTransfer} event.
2277      */
2278     function _mintERC2309(address to, uint256 quantity) internal virtual {
2279         uint256 startTokenId = _currentIndex;
2280         if (to == address(0)) _revert(MintToZeroAddress.selector);
2281         if (quantity == 0) _revert(MintZeroQuantity.selector);
2282         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) _revert(MintERC2309QuantityExceedsLimit.selector);
2283 
2284         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2285 
2286         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
2287         unchecked {
2288             // Updates:
2289             // - `balance += quantity`.
2290             // - `numberMinted += quantity`.
2291             //
2292             // We can directly add to the `balance` and `numberMinted`.
2293             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2294 
2295             // Updates:
2296             // - `address` to the owner.
2297             // - `startTimestamp` to the timestamp of minting.
2298             // - `burned` to `false`.
2299             // - `nextInitialized` to `quantity == 1`.
2300             _packedOwnerships[startTokenId] = _packOwnershipData(
2301                 to,
2302                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2303             );
2304 
2305             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
2306 
2307             _currentIndex = startTokenId + quantity;
2308         }
2309         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2310     }
2311 
2312     /**
2313      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2314      *
2315      * Requirements:
2316      *
2317      * - If `to` refers to a smart contract, it must implement
2318      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2319      * - `quantity` must be greater than 0.
2320      *
2321      * See {_mint}.
2322      *
2323      * Emits a {Transfer} event for each mint.
2324      */
2325     function _safeMint(
2326         address to,
2327         uint256 quantity,
2328         bytes memory _data
2329     ) internal virtual {
2330         _mint(to, quantity);
2331 
2332         unchecked {
2333             if (to.code.length != 0) {
2334                 uint256 end = _currentIndex;
2335                 uint256 index = end - quantity;
2336                 do {
2337                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2338                         _revert(TransferToNonERC721ReceiverImplementer.selector);
2339                     }
2340                 } while (index < end);
2341                 // Reentrancy protection.
2342                 if (_currentIndex != end) _revert(bytes4(0));
2343             }
2344         }
2345     }
2346 
2347     /**
2348      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2349      */
2350     function _safeMint(address to, uint256 quantity) internal virtual {
2351         _safeMint(to, quantity, '');
2352     }
2353 
2354     // =============================================================
2355     //                       APPROVAL OPERATIONS
2356     // =============================================================
2357 
2358     /**
2359      * @dev Equivalent to `_approve(to, tokenId, false)`.
2360      */
2361     function _approve(address to, uint256 tokenId) internal virtual {
2362         _approve(to, tokenId, false);
2363     }
2364 
2365     /**
2366      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
2367      * The approval is cleared when the token is transferred.
2368      *
2369      * Only a single account can be approved at a time, so approving the
2370      * zero address clears previous approvals.
2371      *
2372      * Requirements:
2373      *
2374      * - `tokenId` must exist.
2375      *
2376      * Emits an {Approval} event.
2377      */
2378     function _approve(
2379         address to,
2380         uint256 tokenId,
2381         bool approvalCheck
2382     ) internal virtual {
2383         address owner = ownerOf(tokenId);
2384 
2385         if (approvalCheck && _msgSenderERC721A() != owner)
2386             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
2387                 _revert(ApprovalCallerNotOwnerNorApproved.selector);
2388             }
2389 
2390         _tokenApprovals[tokenId].value = to;
2391         emit Approval(owner, to, tokenId);
2392     }
2393 
2394     // =============================================================
2395     //                        BURN OPERATIONS
2396     // =============================================================
2397 
2398     /**
2399      * @dev Equivalent to `_burn(tokenId, false)`.
2400      */
2401     function _burn(uint256 tokenId) internal virtual {
2402         _burn(tokenId, false);
2403     }
2404 
2405     /**
2406      * @dev Destroys `tokenId`.
2407      * The approval is cleared when the token is burned.
2408      *
2409      * Requirements:
2410      *
2411      * - `tokenId` must exist.
2412      *
2413      * Emits a {Transfer} event.
2414      */
2415     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2416         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2417 
2418         address from = address(uint160(prevOwnershipPacked));
2419 
2420         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2421 
2422         if (approvalCheck) {
2423             // The nested ifs save around 20+ gas over a compound boolean condition.
2424             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2425                 if (!isApprovedForAll(from, _msgSenderERC721A())) _revert(TransferCallerNotOwnerNorApproved.selector);
2426         }
2427 
2428         _beforeTokenTransfers(from, address(0), tokenId, 1);
2429 
2430         // Clear approvals from the previous owner.
2431         assembly {
2432             if approvedAddress {
2433                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2434                 sstore(approvedAddressSlot, 0)
2435             }
2436         }
2437 
2438         // Underflow of the sender's balance is impossible because we check for
2439         // ownership above and the recipient's balance can't realistically overflow.
2440         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2441         unchecked {
2442             // Updates:
2443             // - `balance -= 1`.
2444             // - `numberBurned += 1`.
2445             //
2446             // We can directly decrement the balance, and increment the number burned.
2447             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2448             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2449 
2450             // Updates:
2451             // - `address` to the last owner.
2452             // - `startTimestamp` to the timestamp of burning.
2453             // - `burned` to `true`.
2454             // - `nextInitialized` to `true`.
2455             _packedOwnerships[tokenId] = _packOwnershipData(
2456                 from,
2457                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2458             );
2459 
2460             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2461             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2462                 uint256 nextTokenId = tokenId + 1;
2463                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2464                 if (_packedOwnerships[nextTokenId] == 0) {
2465                     // If the next slot is within bounds.
2466                     if (nextTokenId != _currentIndex) {
2467                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2468                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2469                     }
2470                 }
2471             }
2472         }
2473 
2474         emit Transfer(from, address(0), tokenId);
2475         _afterTokenTransfers(from, address(0), tokenId, 1);
2476 
2477         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2478         unchecked {
2479             _burnCounter++;
2480         }
2481     }
2482 
2483     // =============================================================
2484     //                     EXTRA DATA OPERATIONS
2485     // =============================================================
2486 
2487     /**
2488      * @dev Directly sets the extra data for the ownership data `index`.
2489      */
2490     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2491         uint256 packed = _packedOwnerships[index];
2492         if (packed == 0) _revert(OwnershipNotInitializedForExtraData.selector);
2493         uint256 extraDataCasted;
2494         // Cast `extraData` with assembly to avoid redundant masking.
2495         assembly {
2496             extraDataCasted := extraData
2497         }
2498         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2499         _packedOwnerships[index] = packed;
2500     }
2501 
2502     /**
2503      * @dev Called during each token transfer to set the 24bit `extraData` field.
2504      * Intended to be overridden by the cosumer contract.
2505      *
2506      * `previousExtraData` - the value of `extraData` before transfer.
2507      *
2508      * Calling conditions:
2509      *
2510      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2511      * transferred to `to`.
2512      * - When `from` is zero, `tokenId` will be minted for `to`.
2513      * - When `to` is zero, `tokenId` will be burned by `from`.
2514      * - `from` and `to` are never both zero.
2515      */
2516     function _extraData(
2517         address from,
2518         address to,
2519         uint24 previousExtraData
2520     ) internal view virtual returns (uint24) {}
2521 
2522     /**
2523      * @dev Returns the next extra data for the packed ownership data.
2524      * The returned result is shifted into position.
2525      */
2526     function _nextExtraData(
2527         address from,
2528         address to,
2529         uint256 prevOwnershipPacked
2530     ) private view returns (uint256) {
2531         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2532         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2533     }
2534 
2535     // =============================================================
2536     //                       OTHER OPERATIONS
2537     // =============================================================
2538 
2539     /**
2540      * @dev Returns the message sender (defaults to `msg.sender`).
2541      *
2542      * If you are writing GSN compatible contracts, you need to override this function.
2543      */
2544     function _msgSenderERC721A() internal view virtual returns (address) {
2545         return msg.sender;
2546     }
2547 
2548     /**
2549      * @dev Converts a uint256 to its ASCII string decimal representation.
2550      */
2551     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2552         assembly {
2553             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2554             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2555             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2556             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2557             let m := add(mload(0x40), 0xa0)
2558             // Update the free memory pointer to allocate.
2559             mstore(0x40, m)
2560             // Assign the `str` to the end.
2561             str := sub(m, 0x20)
2562             // Zeroize the slot after the string.
2563             mstore(str, 0)
2564 
2565             // Cache the end of the memory to calculate the length later.
2566             let end := str
2567 
2568             // We write the string from rightmost digit to leftmost digit.
2569             // The following is essentially a do-while loop that also handles the zero case.
2570             // prettier-ignore
2571             for { let temp := value } 1 {} {
2572                 str := sub(str, 1)
2573                 // Write the character to the pointer.
2574                 // The ASCII index of the '0' character is 48.
2575                 mstore8(str, add(48, mod(temp, 10)))
2576                 // Keep dividing `temp` until zero.
2577                 temp := div(temp, 10)
2578                 // prettier-ignore
2579                 if iszero(temp) { break }
2580             }
2581 
2582             let length := sub(end, str)
2583             // Move the pointer 32 bytes leftwards to make room for the length.
2584             str := sub(str, 0x20)
2585             // Store the length.
2586             mstore(str, length)
2587         }
2588     }
2589 
2590     /**
2591      * @dev For more efficient reverts.
2592      */
2593     function _revert(bytes4 errorSelector) internal pure {
2594         assembly {
2595             mstore(0x00, errorSelector)
2596             revert(0x00, 0x04)
2597         }
2598     }
2599 }
2600 // File: contracts/GENCoin.sol
2601 
2602 
2603 pragma solidity ^0.8.11;
2604 
2605 
2606 
2607 
2608 
2609 
2610 
2611 
2612 
2613 contract GENCoin is ERC721A, ERC2981, Ownable, DefaultOperatorFilterer, ReentrancyGuard {
2614 
2615     IERC20 public paymentCurrency;
2616     uint256 public maxSupply = 4222;
2617     uint256 public limit = 2;
2618     uint256 public price = 2600000000 ether; // 2.6 billion
2619     bool public mintEnabled;
2620     bool public revealed;
2621     string public hiddenURI;
2622     string public baseURI;
2623 
2624     mapping(address => uint256) mintedWallets;
2625 
2626     constructor(address _currency, address payable _royaltyReceiver) ERC721A("GEN Coin", "GEN") {
2627         paymentCurrency = IERC20(_currency);
2628         setDefaultRoyalty(_royaltyReceiver, 500); // 5% default royalty
2629     }
2630 
2631     function mint(uint256 numberOfTokens) external nonReentrant {
2632         uint256 amount = numberOfTokens * price;
2633         require(mintEnabled, "Mint disabled");
2634         require(totalSupply() + numberOfTokens <= maxSupply, "We're sold out!");
2635         require(mintedWallets[msg.sender] + numberOfTokens <= limit, "Too many per wallet");
2636 
2637         paymentCurrency.transferFrom(msg.sender, address(this), amount);
2638         mintedWallets[msg.sender] += numberOfTokens;
2639         _mint(msg.sender, numberOfTokens);
2640     }
2641 
2642     function adminMint(address to, uint256 numberOfTokens) external onlyOwner nonReentrant {
2643         require(totalSupply() + numberOfTokens <= maxSupply, "We're sold out!");
2644 
2645         _mint(to, numberOfTokens);
2646     }
2647 
2648     function setMaxSupply(uint256 _maxSupply) external onlyOwner {
2649         maxSupply = _maxSupply;
2650     }
2651 
2652     function setLimit(uint256 _limit) external onlyOwner {
2653         limit = _limit;
2654     }
2655 
2656     function setPrice(uint256 _price) external onlyOwner {
2657         price = _price;
2658     }
2659 
2660     function toggleMinting() external onlyOwner {
2661         mintEnabled = !mintEnabled;
2662     }
2663 
2664     function toggleRevealed() external onlyOwner {
2665         revealed = !revealed;
2666     }
2667 
2668     function setHiddenURI(string calldata hiddenURI_) external onlyOwner {
2669         hiddenURI = hiddenURI_;
2670     }
2671 
2672     function setBaseURI(string calldata baseURI_) external onlyOwner {
2673         baseURI = baseURI_;
2674     }
2675 
2676     function _baseURI() internal view virtual override returns (string memory) {
2677         return baseURI;
2678     }
2679 
2680     function tokenURI(uint256 tokenId) public view override returns (string memory) {
2681         require(_exists(tokenId), "GEN does not exist");
2682 
2683         if (revealed) {
2684             return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, Strings.toString(tokenId))) : "";
2685         }
2686 
2687         return hiddenURI;
2688     }
2689 
2690     function withdrawCurrency() external onlyOwner nonReentrant {
2691         uint256 balance = paymentCurrency.balanceOf(address(this));
2692         require(balance > 0, "No payment tokens to withdraw!");
2693         paymentCurrency.transfer(owner(), balance);
2694     }
2695 
2696     function withdrawEth() external onlyOwner nonReentrant {
2697         (bool success, ) = msg.sender.call{value: address(this).balance}("");
2698         require(success, "Withdraw eth failed!");
2699     }
2700 
2701     function getMintedAmount(address _address) public view returns (uint256) {
2702         return mintedWallets[_address];
2703     }
2704 
2705     // =========================================================================
2706     //                           Operator filtering
2707     // =========================================================================
2708 
2709     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
2710         super.setApprovalForAll(operator, approved);
2711     }
2712 
2713     function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
2714         super.approve(operator, tokenId);
2715     }
2716 
2717     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
2718         super.transferFrom(from, to, tokenId);
2719     }
2720 
2721     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
2722         super.safeTransferFrom(from, to, tokenId);
2723     }
2724 
2725     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2726         public
2727         payable
2728         override
2729         onlyAllowedOperator(from)
2730     {
2731         super.safeTransferFrom(from, to, tokenId, data);
2732     }
2733 
2734     // =========================================================================
2735     //                                 ERC2891
2736     // =========================================================================
2737 
2738     function setDefaultRoyalty(address receiver, uint96 feeNumerator) public onlyOwner {
2739         _setDefaultRoyalty(receiver, feeNumerator);
2740     }
2741 
2742     function deleteDefaultRoyalty() public onlyOwner {
2743         _deleteDefaultRoyalty();
2744     }
2745 
2746     // =========================================================================
2747     //                                  ERC165
2748     // =========================================================================
2749 
2750     function supportsInterface(bytes4 interfaceId) public view virtual override (ERC2981, ERC721A) returns (bool) {
2751         return super.supportsInterface(interfaceId);
2752     }
2753 }