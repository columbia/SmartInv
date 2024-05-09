1 // SPDX-License-Identifier: MIT
2 
3 // War Bonds by ATS. Written by NiftyLabs (https://niftylabs.dev/).
4 
5 //@@@@@ &@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@/ @@@@@ 
6 //@   @(&... ..... .. .. .. ..  ....   .... ...,...... ............. %@@@@@@@@@#..  ....... ....   ........  . .......,.  . . .... .... ......%*@   @ 
7 //&&@%@ ...   ...... .... .. . .. ... ... .. ..... .. ...  . ,@%.          .,/(,/*//@................ ..  ... .........   .  ...........  .... .@%@&& 
8 //@ @. ..@  # @      @@    @   &           @ ....... ......@.(%(.          ,/(**//(,    @@*.. . ...  . . ....@   .(      @&    @         /     ,. @ @ 
9 //@ @...@*   @./   @  .%.  /  # @  /& @   @(... . .  ..(@.    #/.         .....,,,/@ . ,@/   &@.............% .  @. #  @   ,*     @ @   ,.(   @ ..@ @ 
10 //@ @. # @@   .@   @  @@ & @  @.@  . .@     . .... .@#  *%. .  (. *&,    ..*#, ,*//@ . . . . @   @%  .. . ..#&&   (,.  @  (* @ @  #.@     @   ....@ @ 
11 //@ @. . ..   ........ ..,. . ....  .  .. ..  . .@%  @..   .. /*#,.     , */%(,,#/ @ ...  ,.  ..*,  @,.... ..... ...  ..  . . .   ..,. ...., .....@ @ 
12 //@ @..... ...@  %  .@#   @%*@(  @# @ ... .....@  #.  ..   .   / (,    ,    ,((.*./% .. /@@.  .,   @  #@... ......&.  ,  @@   (@ @@  .@ ..........@ @ 
13 //@ @. ..  . .(  @*  &@@    @ @    @%. .. . .@  @ .   ..   .   @(#(,  /   /.,#.@@.//*,,/@%.*  ..   ,.   #@. ... . @  (@  &@@    &.@    &# ...... .@ @ 
14 //@ @  .. . ..@  @   .@#@   @.@  @@  ..... @* #   .   .**@#%@(*., ....,,*.*/..,**##(#,#@#%,   ..   ,.  #  @.  .   @  .(  (@.@   &.@  ,@.  ........@ @ 
15 //@ @..   ...... ..  .. .. ...   ..... .. @  &.. ..   ..  @@&/&@/*,      / ,  ,@@% / /(& . .  ...   .  ,.@ *&. . . .. ..  .. .. ......  ... .. ...@ @ 
16 //@ @.. .. . .. . ..,##. . .  ....   ....@  .... . .  .   . % ,.  .**(@@&*,(*(&/#.  .@@. . .. ... . .  ...@  @..... .  ... ....&@&,..  ... .. . . @ @ 
17 //@ @... .......@ .  @@  * @. .    . .. @  .. .. . ...    . ./ # @   ***@&##@*,/@* ,*  . . ..   . . .... ,.@  @... .......@ @   /   & @..... .  ..@ @ 
18 //@ @...... ..@(  % *  ///  ,@.. ......@  /..  ... ...  ... .. &./*.#* .,.  ..,, & .     .  ..  ... ..,  .,.@ @,.  . . .  .  *   /&%*   # ...    .@ @ 
19 //@ @....... @.    @#@# #%&   @ . ... .@ @ ..   .   ..  .,   &%,,(@,/  ... .,.., *//**@..   ,.   ,.  ,.  .*.   @........#/ @ %(@@#.@@(    ... ... @ @ 
20 //@ @.. .  . @.  @ @@@@@/&    &.......@  / ,.  .,   ,. *%*..   ,%@,,@(@. /&,%&#/@((/,.*%,**,  &%%@   ,,   *  @ @ .   ...&#  .#@@@@@&*   ..... ... @ @ 
21 //@ @....  ...@#  *&@  #*   *@  .. .. @    ,.  .,   ,@,.#, ,*@ *,  .%  #*#@@&%#/ ..%... .&,(. / /,   ,,  ,,  @ (( . ... .,*  @@   @%    . ...  . .@ @ 
22 //@ @..  .. ....@ . *%&  . @. ....  ..@   ..,  ,,  ., (, ,/ ,. ,.**%  #*( */&%*/(,,./*. */#@ .%,%*   *,  ,., @ *#. . . ....(*  @&@  &.#.. ....  ..@ @ 
23 //@ @  ........ . . .// . ...... .  . @   ,... , . (  ,&*, *,@.,.* .*#&( ,, &@*    .., **,,,,(&,, /, .,..* * @ &............  ........  ..... ... @ @ 
24 //@ @.  , .. ...... ... .. ... .. . ..(% @* ..,  ,.&  (&*(,.@.*(@,  ,  ,,, *@@  &  , ,**,,/*#**, . .., ,.* *.* @ . .  ...  ..,.,. .  . .,, .. ....@ @ 
25 //@ @..&(*&.%.../@ %*%%( . /@.@,.%%%,..@  , .,*  .,,*.@,  ,*@ @**#@* . . ,,& ,  ./ ,( ,.*,*(#%*,.%& ,. ,,. ,@ .@ .  ..    ...... .. .   ... . . ..& @ 
26 //@ @. %#/,.&././&*,..&.#(/..#. /#./....@ @  **  .* ,.*# % ,. @*./*@,,(#&&/.(%   / .,*,,,*,%#/* *% .&( ./     @. ... .# # *(*..  . ..,   ... .. ..@ @ 
27 //@ @..%#%#(%(#*,.*,%#% (/.#%(%,.##(.. .#& @ **  ,@/.,,/,(  /. **,,@* (%..#  .     /,,,*,*.**@*/(,,# @ ,/    @.... ...**(.#//##. #,# .#*/# #.,/ ..& @ 
28 //@ @ .,, .....,.........., .....,,....../@ @/*  ,@,&/,(   . *.  &..*@*   (     , .@ ,*,,,@*/.*,,/     ./.  @  ...  .. . .. .... .. .. . .. . ..  & @ 
29 //@ &. ....   ..  ........ ..... ..... ....@  /  *#/,%        /*@.,.##,  .( *.,   @..,..*@.*/@,,(...  #,@ .@.. ....  ...,.(.%.......  ,(*#...... .& @ 
30 //@ &.... ..... ..........  .. .....   .. . @% % @.&       .@   ..*@.., # ,  %,   .     *.@.,(,#      (  @.. .  ..... . .... ...  . . ........ . .& @ 
31 //@ & .. @  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&@&&%  @... & @ 
32 //@ &.. .# %  @  @ ,@  @@ .@*@  @@  &  @ ,@  @*@  @   @  @  @@  @*@  @  % @  @ .@  @ @  @@# @  @  @@ @  &#@  ( & @( ,  @  @ (@   @@@  @ ,  & @....& @ 
33 //@ &../@@@@  @  & ,#  @@@@  /  @&  @  @  %  @@   @      @  %#  @@  @(@  @#  @@@@  @@&@@/ &  & *.   @@@  @@  . &  & ,, %  @ .@@@  /&  @    @@@@/ .& @ 
34 //@@@@@@@..%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@/,.@@@@@@@
35 
36 // File: operator-filter-registry/src/lib/Constants.sol
37 pragma solidity ^0.8.17;
38 
39 address constant CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS = 0x000000000000AAeB6D7670E522A718067333cd4E;
40 address constant CANONICAL_CORI_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
41 
42 // File: operator-filter-registry/src/IOperatorFilterRegistry.sol
43 
44 
45 pragma solidity ^0.8.13;
46 
47 interface IOperatorFilterRegistry {
48     /**
49      * @notice Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns
50      *         true if supplied registrant address is not registered.
51      */
52     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
53 
54     /**
55      * @notice Registers an address with the registry. May be called by address itself or by EIP-173 owner.
56      */
57     function register(address registrant) external;
58 
59     /**
60      * @notice Registers an address with the registry and "subscribes" to another address's filtered operators and codeHashes.
61      */
62     function registerAndSubscribe(address registrant, address subscription) external;
63 
64     /**
65      * @notice Registers an address with the registry and copies the filtered operators and codeHashes from another
66      *         address without subscribing.
67      */
68     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
69 
70     /**
71      * @notice Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.
72      *         Note that this does not remove any filtered addresses or codeHashes.
73      *         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes.
74      */
75     function unregister(address addr) external;
76 
77     /**
78      * @notice Update an operator address for a registered address - when filtered is true, the operator is filtered.
79      */
80     function updateOperator(address registrant, address operator, bool filtered) external;
81 
82     /**
83      * @notice Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates.
84      */
85     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
86 
87     /**
88      * @notice Update a codeHash for a registered address - when filtered is true, the codeHash is filtered.
89      */
90     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
91 
92     /**
93      * @notice Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates.
94      */
95     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
96 
97     /**
98      * @notice Subscribe an address to another registrant's filtered operators and codeHashes. Will remove previous
99      *         subscription if present.
100      *         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,
101      *         subscriptions will not be forwarded. Instead the former subscription's existing entries will still be
102      *         used.
103      */
104     function subscribe(address registrant, address registrantToSubscribe) external;
105 
106     /**
107      * @notice Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes.
108      */
109     function unsubscribe(address registrant, bool copyExistingEntries) external;
110 
111     /**
112      * @notice Get the subscription address of a given registrant, if any.
113      */
114     function subscriptionOf(address addr) external returns (address registrant);
115 
116     /**
117      * @notice Get the set of addresses subscribed to a given registrant.
118      *         Note that order is not guaranteed as updates are made.
119      */
120     function subscribers(address registrant) external returns (address[] memory);
121 
122     /**
123      * @notice Get the subscriber at a given index in the set of addresses subscribed to a given registrant.
124      *         Note that order is not guaranteed as updates are made.
125      */
126     function subscriberAt(address registrant, uint256 index) external returns (address);
127 
128     /**
129      * @notice Copy filtered operators and codeHashes from a different registrantToCopy to addr.
130      */
131     function copyEntriesOf(address registrant, address registrantToCopy) external;
132 
133     /**
134      * @notice Returns true if operator is filtered by a given address or its subscription.
135      */
136     function isOperatorFiltered(address registrant, address operator) external returns (bool);
137 
138     /**
139      * @notice Returns true if the hash of an address's code is filtered by a given address or its subscription.
140      */
141     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
142 
143     /**
144      * @notice Returns true if a codeHash is filtered by a given address or its subscription.
145      */
146     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
147 
148     /**
149      * @notice Returns a list of filtered operators for a given address or its subscription.
150      */
151     function filteredOperators(address addr) external returns (address[] memory);
152 
153     /**
154      * @notice Returns the set of filtered codeHashes for a given address or its subscription.
155      *         Note that order is not guaranteed as updates are made.
156      */
157     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
158 
159     /**
160      * @notice Returns the filtered operator at the given index of the set of filtered operators for a given address or
161      *         its subscription.
162      *         Note that order is not guaranteed as updates are made.
163      */
164     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
165 
166     /**
167      * @notice Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or
168      *         its subscription.
169      *         Note that order is not guaranteed as updates are made.
170      */
171     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
172 
173     /**
174      * @notice Returns true if an address has registered
175      */
176     function isRegistered(address addr) external returns (bool);
177 
178     /**
179      * @dev Convenience method to compute the code hash of an arbitrary contract
180      */
181     function codeHashOf(address addr) external returns (bytes32);
182 }
183 
184 // File: operator-filter-registry/src/UpdatableOperatorFilterer.sol
185 
186 
187 pragma solidity ^0.8.13;
188 
189 
190 /**
191  * @title  UpdatableOperatorFilterer
192  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
193  *         registrant's entries in the OperatorFilterRegistry. This contract allows the Owner to update the
194  *         OperatorFilterRegistry address via updateOperatorFilterRegistryAddress, including to the zero address,
195  *         which will bypass registry checks.
196  *         Note that OpenSea will still disable creator earnings enforcement if filtered operators begin fulfilling orders
197  *         on-chain, eg, if the registry is revoked or bypassed.
198  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
199  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
200  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
201  */
202 abstract contract UpdatableOperatorFilterer {
203     /// @dev Emitted when an operator is not allowed.
204     error OperatorNotAllowed(address operator);
205     /// @dev Emitted when someone other than the owner is trying to call an only owner function.
206     error OnlyOwner();
207 
208     event OperatorFilterRegistryAddressUpdated(address newRegistry);
209 
210     IOperatorFilterRegistry public operatorFilterRegistry;
211 
212     /// @dev The constructor that is called when the contract is being deployed.
213     constructor(address _registry, address subscriptionOrRegistrantToCopy, bool subscribe) {
214         IOperatorFilterRegistry registry = IOperatorFilterRegistry(_registry);
215         operatorFilterRegistry = registry;
216         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
217         // will not revert, but the contract will need to be registered with the registry once it is deployed in
218         // order for the modifier to filter addresses.
219         if (address(registry).code.length > 0) {
220             if (subscribe) {
221                 registry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
222             } else {
223                 if (subscriptionOrRegistrantToCopy != address(0)) {
224                     registry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
225                 } else {
226                     registry.register(address(this));
227                 }
228             }
229         }
230     }
231 
232     /**
233      * @dev A helper function to check if the operator is allowed.
234      */
235     modifier onlyAllowedOperator(address from) virtual {
236         // Allow spending tokens from addresses with balance
237         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
238         // from an EOA.
239         if (from != msg.sender) {
240             _checkFilterOperator(msg.sender);
241         }
242         _;
243     }
244 
245     /**
246      * @dev A helper function to check if the operator approval is allowed.
247      */
248     modifier onlyAllowedOperatorApproval(address operator) virtual {
249         _checkFilterOperator(operator);
250         _;
251     }
252 
253     /**
254      * @notice Update the address that the contract will make OperatorFilter checks against. When set to the zero
255      *         address, checks will be bypassed. OnlyOwner.
256      */
257     function updateOperatorFilterRegistryAddress(address newRegistry) public virtual {
258         if (msg.sender != owner()) {
259             revert OnlyOwner();
260         }
261         operatorFilterRegistry = IOperatorFilterRegistry(newRegistry);
262         emit OperatorFilterRegistryAddressUpdated(newRegistry);
263     }
264 
265     /**
266      * @dev Assume the contract has an owner, but leave specific Ownable implementation up to inheriting contract.
267      */
268     function owner() public view virtual returns (address);
269 
270     /**
271      * @dev A helper function to check if the operator is allowed.
272      */
273     function _checkFilterOperator(address operator) internal view virtual {
274         IOperatorFilterRegistry registry = operatorFilterRegistry;
275         // Check registry code length to facilitate testing in environments without a deployed registry.
276         if (address(registry) != address(0) && address(registry).code.length > 0) {
277             // under normal circumstances, this function will revert rather than return false, but inheriting contracts
278             // may specify their own OperatorFilterRegistry implementations, which may behave differently
279             if (!registry.isOperatorAllowed(address(this), operator)) {
280                 revert OperatorNotAllowed(operator);
281             }
282         }
283     }
284 }
285 
286 // File: operator-filter-registry/src/RevokableOperatorFilterer.sol
287 
288 
289 pragma solidity ^0.8.13;
290 
291 
292 
293 /**
294  * @title  RevokableOperatorFilterer
295  * @notice This contract is meant to allow contracts to permanently skip OperatorFilterRegistry checks if desired. The
296  *         Registry itself has an "unregister" function, but if the contract is ownable, the owner can re-register at
297  *         any point. As implemented, this abstract contract allows the contract owner to permanently skip the
298  *         OperatorFilterRegistry checks by calling revokeOperatorFilterRegistry. Once done, the registry
299  *         address cannot be further updated.
300  *         Note that OpenSea will still disable creator earnings enforcement if filtered operators begin fulfilling orders
301  *         on-chain, eg, if the registry is revoked or bypassed.
302  */
303 abstract contract RevokableOperatorFilterer is UpdatableOperatorFilterer {
304     /// @dev Emitted when the registry has already been revoked.
305     error RegistryHasBeenRevoked();
306     /// @dev Emitted when the initial registry address is attempted to be set to the zero address.
307     error InitialRegistryAddressCannotBeZeroAddress();
308 
309     event OperatorFilterRegistryRevoked();
310 
311     bool public isOperatorFilterRegistryRevoked;
312 
313     /// @dev The constructor that is called when the contract is being deployed.
314     constructor(address _registry, address subscriptionOrRegistrantToCopy, bool subscribe)
315         UpdatableOperatorFilterer(_registry, subscriptionOrRegistrantToCopy, subscribe)
316     {
317         // don't allow creating a contract with a permanently revoked registry
318         if (_registry == address(0)) {
319             revert InitialRegistryAddressCannotBeZeroAddress();
320         }
321     }
322 
323     /**
324      * @notice Update the address that the contract will make OperatorFilter checks against. When set to the zero
325      *         address, checks will be permanently bypassed, and the address cannot be updated again. OnlyOwner.
326      */
327     function updateOperatorFilterRegistryAddress(address newRegistry) public override {
328         if (msg.sender != owner()) {
329             revert OnlyOwner();
330         }
331         // if registry has been revoked, do not allow further updates
332         if (isOperatorFilterRegistryRevoked) {
333             revert RegistryHasBeenRevoked();
334         }
335 
336         operatorFilterRegistry = IOperatorFilterRegistry(newRegistry);
337         emit OperatorFilterRegistryAddressUpdated(newRegistry);
338     }
339 
340     /**
341      * @notice Revoke the OperatorFilterRegistry address, permanently bypassing checks. OnlyOwner.
342      */
343     function revokeOperatorFilterRegistry() public {
344         if (msg.sender != owner()) {
345             revert OnlyOwner();
346         }
347         // if registry has been revoked, do not allow further updates
348         if (isOperatorFilterRegistryRevoked) {
349             revert RegistryHasBeenRevoked();
350         }
351 
352         // set to zero address to bypass checks
353         operatorFilterRegistry = IOperatorFilterRegistry(address(0));
354         isOperatorFilterRegistryRevoked = true;
355         emit OperatorFilterRegistryRevoked();
356     }
357 }
358 
359 // File: operator-filter-registry/src/RevokableDefaultOperatorFilterer.sol
360 
361 
362 pragma solidity ^0.8.13;
363 
364 
365 /**
366  * @title  RevokableDefaultOperatorFilterer
367  * @notice Inherits from RevokableOperatorFilterer and automatically subscribes to the default OpenSea subscription.
368  *         Note that OpenSea will disable creator earnings enforcement if filtered operators begin fulfilling orders
369  *         on-chain, eg, if the registry is revoked or bypassed.
370  */
371 
372 abstract contract RevokableDefaultOperatorFilterer is RevokableOperatorFilterer {
373     /// @dev The constructor that is called when the contract is being deployed.
374     constructor()
375         RevokableOperatorFilterer(CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS, CANONICAL_CORI_SUBSCRIPTION, true)
376     {}
377 }
378 
379 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
380 
381 
382 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
383 
384 pragma solidity ^0.8.0;
385 
386 /**
387  * @dev Interface of the ERC20 standard as defined in the EIP.
388  */
389 interface IERC20 {
390     /**
391      * @dev Emitted when `value` tokens are moved from one account (`from`) to
392      * another (`to`).
393      *
394      * Note that `value` may be zero.
395      */
396     event Transfer(address indexed from, address indexed to, uint256 value);
397 
398     /**
399      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
400      * a call to {approve}. `value` is the new allowance.
401      */
402     event Approval(address indexed owner, address indexed spender, uint256 value);
403 
404     /**
405      * @dev Returns the amount of tokens in existence.
406      */
407     function totalSupply() external view returns (uint256);
408 
409     /**
410      * @dev Returns the amount of tokens owned by `account`.
411      */
412     function balanceOf(address account) external view returns (uint256);
413 
414     /**
415      * @dev Moves `amount` tokens from the caller's account to `to`.
416      *
417      * Returns a boolean value indicating whether the operation succeeded.
418      *
419      * Emits a {Transfer} event.
420      */
421     function transfer(address to, uint256 amount) external returns (bool);
422 
423     /**
424      * @dev Returns the remaining number of tokens that `spender` will be
425      * allowed to spend on behalf of `owner` through {transferFrom}. This is
426      * zero by default.
427      *
428      * This value changes when {approve} or {transferFrom} are called.
429      */
430     function allowance(address owner, address spender) external view returns (uint256);
431 
432     /**
433      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
434      *
435      * Returns a boolean value indicating whether the operation succeeded.
436      *
437      * IMPORTANT: Beware that changing an allowance with this method brings the risk
438      * that someone may use both the old and the new allowance by unfortunate
439      * transaction ordering. One possible solution to mitigate this race
440      * condition is to first reduce the spender's allowance to 0 and set the
441      * desired value afterwards:
442      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
443      *
444      * Emits an {Approval} event.
445      */
446     function approve(address spender, uint256 amount) external returns (bool);
447 
448     /**
449      * @dev Moves `amount` tokens from `from` to `to` using the
450      * allowance mechanism. `amount` is then deducted from the caller's
451      * allowance.
452      *
453      * Returns a boolean value indicating whether the operation succeeded.
454      *
455      * Emits a {Transfer} event.
456      */
457     function transferFrom(
458         address from,
459         address to,
460         uint256 amount
461     ) external returns (bool);
462 }
463 
464 // File: @openzeppelin/contracts/utils/math/Math.sol
465 
466 
467 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
468 
469 pragma solidity ^0.8.0;
470 
471 /**
472  * @dev Standard math utilities missing in the Solidity language.
473  */
474 library Math {
475     enum Rounding {
476         Down, // Toward negative infinity
477         Up, // Toward infinity
478         Zero // Toward zero
479     }
480 
481     /**
482      * @dev Returns the largest of two numbers.
483      */
484     function max(uint256 a, uint256 b) internal pure returns (uint256) {
485         return a > b ? a : b;
486     }
487 
488     /**
489      * @dev Returns the smallest of two numbers.
490      */
491     function min(uint256 a, uint256 b) internal pure returns (uint256) {
492         return a < b ? a : b;
493     }
494 
495     /**
496      * @dev Returns the average of two numbers. The result is rounded towards
497      * zero.
498      */
499     function average(uint256 a, uint256 b) internal pure returns (uint256) {
500         // (a + b) / 2 can overflow.
501         return (a & b) + (a ^ b) / 2;
502     }
503 
504     /**
505      * @dev Returns the ceiling of the division of two numbers.
506      *
507      * This differs from standard division with `/` in that it rounds up instead
508      * of rounding down.
509      */
510     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
511         // (a + b - 1) / b can overflow on addition, so we distribute.
512         return a == 0 ? 0 : (a - 1) / b + 1;
513     }
514 
515     /**
516      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
517      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
518      * with further edits by Uniswap Labs also under MIT license.
519      */
520     function mulDiv(
521         uint256 x,
522         uint256 y,
523         uint256 denominator
524     ) internal pure returns (uint256 result) {
525         unchecked {
526             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
527             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
528             // variables such that product = prod1 * 2^256 + prod0.
529             uint256 prod0; // Least significant 256 bits of the product
530             uint256 prod1; // Most significant 256 bits of the product
531             assembly {
532                 let mm := mulmod(x, y, not(0))
533                 prod0 := mul(x, y)
534                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
535             }
536 
537             // Handle non-overflow cases, 256 by 256 division.
538             if (prod1 == 0) {
539                 return prod0 / denominator;
540             }
541 
542             // Make sure the result is less than 2^256. Also prevents denominator == 0.
543             require(denominator > prod1);
544 
545             ///////////////////////////////////////////////
546             // 512 by 256 division.
547             ///////////////////////////////////////////////
548 
549             // Make division exact by subtracting the remainder from [prod1 prod0].
550             uint256 remainder;
551             assembly {
552                 // Compute remainder using mulmod.
553                 remainder := mulmod(x, y, denominator)
554 
555                 // Subtract 256 bit number from 512 bit number.
556                 prod1 := sub(prod1, gt(remainder, prod0))
557                 prod0 := sub(prod0, remainder)
558             }
559 
560             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
561             // See https://cs.stackexchange.com/q/138556/92363.
562 
563             // Does not overflow because the denominator cannot be zero at this stage in the function.
564             uint256 twos = denominator & (~denominator + 1);
565             assembly {
566                 // Divide denominator by twos.
567                 denominator := div(denominator, twos)
568 
569                 // Divide [prod1 prod0] by twos.
570                 prod0 := div(prod0, twos)
571 
572                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
573                 twos := add(div(sub(0, twos), twos), 1)
574             }
575 
576             // Shift in bits from prod1 into prod0.
577             prod0 |= prod1 * twos;
578 
579             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
580             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
581             // four bits. That is, denominator * inv = 1 mod 2^4.
582             uint256 inverse = (3 * denominator) ^ 2;
583 
584             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
585             // in modular arithmetic, doubling the correct bits in each step.
586             inverse *= 2 - denominator * inverse; // inverse mod 2^8
587             inverse *= 2 - denominator * inverse; // inverse mod 2^16
588             inverse *= 2 - denominator * inverse; // inverse mod 2^32
589             inverse *= 2 - denominator * inverse; // inverse mod 2^64
590             inverse *= 2 - denominator * inverse; // inverse mod 2^128
591             inverse *= 2 - denominator * inverse; // inverse mod 2^256
592 
593             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
594             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
595             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
596             // is no longer required.
597             result = prod0 * inverse;
598             return result;
599         }
600     }
601 
602     /**
603      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
604      */
605     function mulDiv(
606         uint256 x,
607         uint256 y,
608         uint256 denominator,
609         Rounding rounding
610     ) internal pure returns (uint256) {
611         uint256 result = mulDiv(x, y, denominator);
612         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
613             result += 1;
614         }
615         return result;
616     }
617 
618     /**
619      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
620      *
621      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
622      */
623     function sqrt(uint256 a) internal pure returns (uint256) {
624         if (a == 0) {
625             return 0;
626         }
627 
628         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
629         //
630         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
631         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
632         //
633         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
634         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
635         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
636         //
637         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
638         uint256 result = 1 << (log2(a) >> 1);
639 
640         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
641         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
642         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
643         // into the expected uint128 result.
644         unchecked {
645             result = (result + a / result) >> 1;
646             result = (result + a / result) >> 1;
647             result = (result + a / result) >> 1;
648             result = (result + a / result) >> 1;
649             result = (result + a / result) >> 1;
650             result = (result + a / result) >> 1;
651             result = (result + a / result) >> 1;
652             return min(result, a / result);
653         }
654     }
655 
656     /**
657      * @notice Calculates sqrt(a), following the selected rounding direction.
658      */
659     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
660         unchecked {
661             uint256 result = sqrt(a);
662             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
663         }
664     }
665 
666     /**
667      * @dev Return the log in base 2, rounded down, of a positive value.
668      * Returns 0 if given 0.
669      */
670     function log2(uint256 value) internal pure returns (uint256) {
671         uint256 result = 0;
672         unchecked {
673             if (value >> 128 > 0) {
674                 value >>= 128;
675                 result += 128;
676             }
677             if (value >> 64 > 0) {
678                 value >>= 64;
679                 result += 64;
680             }
681             if (value >> 32 > 0) {
682                 value >>= 32;
683                 result += 32;
684             }
685             if (value >> 16 > 0) {
686                 value >>= 16;
687                 result += 16;
688             }
689             if (value >> 8 > 0) {
690                 value >>= 8;
691                 result += 8;
692             }
693             if (value >> 4 > 0) {
694                 value >>= 4;
695                 result += 4;
696             }
697             if (value >> 2 > 0) {
698                 value >>= 2;
699                 result += 2;
700             }
701             if (value >> 1 > 0) {
702                 result += 1;
703             }
704         }
705         return result;
706     }
707 
708     /**
709      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
710      * Returns 0 if given 0.
711      */
712     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
713         unchecked {
714             uint256 result = log2(value);
715             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
716         }
717     }
718 
719     /**
720      * @dev Return the log in base 10, rounded down, of a positive value.
721      * Returns 0 if given 0.
722      */
723     function log10(uint256 value) internal pure returns (uint256) {
724         uint256 result = 0;
725         unchecked {
726             if (value >= 10**64) {
727                 value /= 10**64;
728                 result += 64;
729             }
730             if (value >= 10**32) {
731                 value /= 10**32;
732                 result += 32;
733             }
734             if (value >= 10**16) {
735                 value /= 10**16;
736                 result += 16;
737             }
738             if (value >= 10**8) {
739                 value /= 10**8;
740                 result += 8;
741             }
742             if (value >= 10**4) {
743                 value /= 10**4;
744                 result += 4;
745             }
746             if (value >= 10**2) {
747                 value /= 10**2;
748                 result += 2;
749             }
750             if (value >= 10**1) {
751                 result += 1;
752             }
753         }
754         return result;
755     }
756 
757     /**
758      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
759      * Returns 0 if given 0.
760      */
761     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
762         unchecked {
763             uint256 result = log10(value);
764             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
765         }
766     }
767 
768     /**
769      * @dev Return the log in base 256, rounded down, of a positive value.
770      * Returns 0 if given 0.
771      *
772      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
773      */
774     function log256(uint256 value) internal pure returns (uint256) {
775         uint256 result = 0;
776         unchecked {
777             if (value >> 128 > 0) {
778                 value >>= 128;
779                 result += 16;
780             }
781             if (value >> 64 > 0) {
782                 value >>= 64;
783                 result += 8;
784             }
785             if (value >> 32 > 0) {
786                 value >>= 32;
787                 result += 4;
788             }
789             if (value >> 16 > 0) {
790                 value >>= 16;
791                 result += 2;
792             }
793             if (value >> 8 > 0) {
794                 result += 1;
795             }
796         }
797         return result;
798     }
799 
800     /**
801      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
802      * Returns 0 if given 0.
803      */
804     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
805         unchecked {
806             uint256 result = log256(value);
807             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
808         }
809     }
810 }
811 
812 // File: @openzeppelin/contracts/utils/Strings.sol
813 
814 
815 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
816 
817 pragma solidity ^0.8.0;
818 
819 
820 /**
821  * @dev String operations.
822  */
823 library Strings {
824     bytes16 private constant _SYMBOLS = "0123456789abcdef";
825     uint8 private constant _ADDRESS_LENGTH = 20;
826 
827     /**
828      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
829      */
830     function toString(uint256 value) internal pure returns (string memory) {
831         unchecked {
832             uint256 length = Math.log10(value) + 1;
833             string memory buffer = new string(length);
834             uint256 ptr;
835             /// @solidity memory-safe-assembly
836             assembly {
837                 ptr := add(buffer, add(32, length))
838             }
839             while (true) {
840                 ptr--;
841                 /// @solidity memory-safe-assembly
842                 assembly {
843                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
844                 }
845                 value /= 10;
846                 if (value == 0) break;
847             }
848             return buffer;
849         }
850     }
851 
852     /**
853      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
854      */
855     function toHexString(uint256 value) internal pure returns (string memory) {
856         unchecked {
857             return toHexString(value, Math.log256(value) + 1);
858         }
859     }
860 
861     /**
862      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
863      */
864     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
865         bytes memory buffer = new bytes(2 * length + 2);
866         buffer[0] = "0";
867         buffer[1] = "x";
868         for (uint256 i = 2 * length + 1; i > 1; --i) {
869             buffer[i] = _SYMBOLS[value & 0xf];
870             value >>= 4;
871         }
872         require(value == 0, "Strings: hex length insufficient");
873         return string(buffer);
874     }
875 
876     /**
877      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
878      */
879     function toHexString(address addr) internal pure returns (string memory) {
880         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
881     }
882 }
883 
884 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
885 
886 
887 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/ECDSA.sol)
888 
889 pragma solidity ^0.8.0;
890 
891 
892 /**
893  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
894  *
895  * These functions can be used to verify that a message was signed by the holder
896  * of the private keys of a given address.
897  */
898 library ECDSA {
899     enum RecoverError {
900         NoError,
901         InvalidSignature,
902         InvalidSignatureLength,
903         InvalidSignatureS,
904         InvalidSignatureV // Deprecated in v4.8
905     }
906 
907     function _throwError(RecoverError error) private pure {
908         if (error == RecoverError.NoError) {
909             return; // no error: do nothing
910         } else if (error == RecoverError.InvalidSignature) {
911             revert("ECDSA: invalid signature");
912         } else if (error == RecoverError.InvalidSignatureLength) {
913             revert("ECDSA: invalid signature length");
914         } else if (error == RecoverError.InvalidSignatureS) {
915             revert("ECDSA: invalid signature 's' value");
916         }
917     }
918 
919     /**
920      * @dev Returns the address that signed a hashed message (`hash`) with
921      * `signature` or error string. This address can then be used for verification purposes.
922      *
923      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
924      * this function rejects them by requiring the `s` value to be in the lower
925      * half order, and the `v` value to be either 27 or 28.
926      *
927      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
928      * verification to be secure: it is possible to craft signatures that
929      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
930      * this is by receiving a hash of the original message (which may otherwise
931      * be too long), and then calling {toEthSignedMessageHash} on it.
932      *
933      * Documentation for signature generation:
934      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
935      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
936      *
937      * _Available since v4.3._
938      */
939     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
940         if (signature.length == 65) {
941             bytes32 r;
942             bytes32 s;
943             uint8 v;
944             // ecrecover takes the signature parameters, and the only way to get them
945             // currently is to use assembly.
946             /// @solidity memory-safe-assembly
947             assembly {
948                 r := mload(add(signature, 0x20))
949                 s := mload(add(signature, 0x40))
950                 v := byte(0, mload(add(signature, 0x60)))
951             }
952             return tryRecover(hash, v, r, s);
953         } else {
954             return (address(0), RecoverError.InvalidSignatureLength);
955         }
956     }
957 
958     /**
959      * @dev Returns the address that signed a hashed message (`hash`) with
960      * `signature`. This address can then be used for verification purposes.
961      *
962      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
963      * this function rejects them by requiring the `s` value to be in the lower
964      * half order, and the `v` value to be either 27 or 28.
965      *
966      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
967      * verification to be secure: it is possible to craft signatures that
968      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
969      * this is by receiving a hash of the original message (which may otherwise
970      * be too long), and then calling {toEthSignedMessageHash} on it.
971      */
972     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
973         (address recovered, RecoverError error) = tryRecover(hash, signature);
974         _throwError(error);
975         return recovered;
976     }
977 
978     /**
979      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
980      *
981      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
982      *
983      * _Available since v4.3._
984      */
985     function tryRecover(
986         bytes32 hash,
987         bytes32 r,
988         bytes32 vs
989     ) internal pure returns (address, RecoverError) {
990         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
991         uint8 v = uint8((uint256(vs) >> 255) + 27);
992         return tryRecover(hash, v, r, s);
993     }
994 
995     /**
996      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
997      *
998      * _Available since v4.2._
999      */
1000     function recover(
1001         bytes32 hash,
1002         bytes32 r,
1003         bytes32 vs
1004     ) internal pure returns (address) {
1005         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1006         _throwError(error);
1007         return recovered;
1008     }
1009 
1010     /**
1011      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1012      * `r` and `s` signature fields separately.
1013      *
1014      * _Available since v4.3._
1015      */
1016     function tryRecover(
1017         bytes32 hash,
1018         uint8 v,
1019         bytes32 r,
1020         bytes32 s
1021     ) internal pure returns (address, RecoverError) {
1022         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1023         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1024         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1025         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1026         //
1027         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1028         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1029         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1030         // these malleable signatures as well.
1031         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1032             return (address(0), RecoverError.InvalidSignatureS);
1033         }
1034 
1035         // If the signature is valid (and not malleable), return the signer address
1036         address signer = ecrecover(hash, v, r, s);
1037         if (signer == address(0)) {
1038             return (address(0), RecoverError.InvalidSignature);
1039         }
1040 
1041         return (signer, RecoverError.NoError);
1042     }
1043 
1044     /**
1045      * @dev Overload of {ECDSA-recover} that receives the `v`,
1046      * `r` and `s` signature fields separately.
1047      */
1048     function recover(
1049         bytes32 hash,
1050         uint8 v,
1051         bytes32 r,
1052         bytes32 s
1053     ) internal pure returns (address) {
1054         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1055         _throwError(error);
1056         return recovered;
1057     }
1058 
1059     /**
1060      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1061      * produces hash corresponding to the one signed with the
1062      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1063      * JSON-RPC method as part of EIP-191.
1064      *
1065      * See {recover}.
1066      */
1067     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1068         // 32 is the length in bytes of hash,
1069         // enforced by the type signature above
1070         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1071     }
1072 
1073     /**
1074      * @dev Returns an Ethereum Signed Message, created from `s`. This
1075      * produces hash corresponding to the one signed with the
1076      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1077      * JSON-RPC method as part of EIP-191.
1078      *
1079      * See {recover}.
1080      */
1081     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1082         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1083     }
1084 
1085     /**
1086      * @dev Returns an Ethereum Signed Typed Data, created from a
1087      * `domainSeparator` and a `structHash`. This produces hash corresponding
1088      * to the one signed with the
1089      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1090      * JSON-RPC method as part of EIP-712.
1091      *
1092      * See {recover}.
1093      */
1094     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1095         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1096     }
1097 }
1098 
1099 // File: @openzeppelin/contracts/utils/Context.sol
1100 
1101 
1102 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1103 
1104 pragma solidity ^0.8.0;
1105 
1106 /**
1107  * @dev Provides information about the current execution context, including the
1108  * sender of the transaction and its data. While these are generally available
1109  * via msg.sender and msg.data, they should not be accessed in such a direct
1110  * manner, since when dealing with meta-transactions the account sending and
1111  * paying for execution may not be the actual sender (as far as an application
1112  * is concerned).
1113  *
1114  * This contract is only required for intermediate, library-like contracts.
1115  */
1116 abstract contract Context {
1117     function _msgSender() internal view virtual returns (address) {
1118         return msg.sender;
1119     }
1120 
1121     function _msgData() internal view virtual returns (bytes calldata) {
1122         return msg.data;
1123     }
1124 }
1125 
1126 // File: @openzeppelin/contracts/access/Ownable.sol
1127 
1128 
1129 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1130 
1131 pragma solidity ^0.8.0;
1132 
1133 
1134 /**
1135  * @dev Contract module which provides a basic access control mechanism, where
1136  * there is an account (an owner) that can be granted exclusive access to
1137  * specific functions.
1138  *
1139  * By default, the owner account will be the one that deploys the contract. This
1140  * can later be changed with {transferOwnership}.
1141  *
1142  * This module is used through inheritance. It will make available the modifier
1143  * `onlyOwner`, which can be applied to your functions to restrict their use to
1144  * the owner.
1145  */
1146 abstract contract Ownable is Context {
1147     address private _owner;
1148 
1149     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1150 
1151     /**
1152      * @dev Initializes the contract setting the deployer as the initial owner.
1153      */
1154     constructor() {
1155         _transferOwnership(_msgSender());
1156     }
1157 
1158     /**
1159      * @dev Throws if called by any account other than the owner.
1160      */
1161     modifier onlyOwner() {
1162         _checkOwner();
1163         _;
1164     }
1165 
1166     /**
1167      * @dev Returns the address of the current owner.
1168      */
1169     function owner() public view virtual returns (address) {
1170         return _owner;
1171     }
1172 
1173     /**
1174      * @dev Throws if the sender is not the owner.
1175      */
1176     function _checkOwner() internal view virtual {
1177         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1178     }
1179 
1180     /**
1181      * @dev Leaves the contract without owner. It will not be possible to call
1182      * `onlyOwner` functions anymore. Can only be called by the current owner.
1183      *
1184      * NOTE: Renouncing ownership will leave the contract without an owner,
1185      * thereby removing any functionality that is only available to the owner.
1186      */
1187     function renounceOwnership() public virtual onlyOwner {
1188         _transferOwnership(address(0));
1189     }
1190 
1191     /**
1192      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1193      * Can only be called by the current owner.
1194      */
1195     function transferOwnership(address newOwner) public virtual onlyOwner {
1196         require(newOwner != address(0), "Ownable: new owner is the zero address");
1197         _transferOwnership(newOwner);
1198     }
1199 
1200     /**
1201      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1202      * Internal function without access restriction.
1203      */
1204     function _transferOwnership(address newOwner) internal virtual {
1205         address oldOwner = _owner;
1206         _owner = newOwner;
1207         emit OwnershipTransferred(oldOwner, newOwner);
1208     }
1209 }
1210 
1211 // File: @openzeppelin/contracts/utils/Address.sol
1212 
1213 
1214 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
1215 
1216 pragma solidity ^0.8.1;
1217 
1218 /**
1219  * @dev Collection of functions related to the address type
1220  */
1221 library Address {
1222     /**
1223      * @dev Returns true if `account` is a contract.
1224      *
1225      * [IMPORTANT]
1226      * ====
1227      * It is unsafe to assume that an address for which this function returns
1228      * false is an externally-owned account (EOA) and not a contract.
1229      *
1230      * Among others, `isContract` will return false for the following
1231      * types of addresses:
1232      *
1233      *  - an externally-owned account
1234      *  - a contract in construction
1235      *  - an address where a contract will be created
1236      *  - an address where a contract lived, but was destroyed
1237      * ====
1238      *
1239      * [IMPORTANT]
1240      * ====
1241      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1242      *
1243      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1244      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1245      * constructor.
1246      * ====
1247      */
1248     function isContract(address account) internal view returns (bool) {
1249         // This method relies on extcodesize/address.code.length, which returns 0
1250         // for contracts in construction, since the code is only stored at the end
1251         // of the constructor execution.
1252 
1253         return account.code.length > 0;
1254     }
1255 
1256     /**
1257      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1258      * `recipient`, forwarding all available gas and reverting on errors.
1259      *
1260      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1261      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1262      * imposed by `transfer`, making them unable to receive funds via
1263      * `transfer`. {sendValue} removes this limitation.
1264      *
1265      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1266      *
1267      * IMPORTANT: because control is transferred to `recipient`, care must be
1268      * taken to not create reentrancy vulnerabilities. Consider using
1269      * {ReentrancyGuard} or the
1270      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1271      */
1272     function sendValue(address payable recipient, uint256 amount) internal {
1273         require(address(this).balance >= amount, "Address: insufficient balance");
1274 
1275         (bool success, ) = recipient.call{value: amount}("");
1276         require(success, "Address: unable to send value, recipient may have reverted");
1277     }
1278 
1279     /**
1280      * @dev Performs a Solidity function call using a low level `call`. A
1281      * plain `call` is an unsafe replacement for a function call: use this
1282      * function instead.
1283      *
1284      * If `target` reverts with a revert reason, it is bubbled up by this
1285      * function (like regular Solidity function calls).
1286      *
1287      * Returns the raw returned data. To convert to the expected return value,
1288      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1289      *
1290      * Requirements:
1291      *
1292      * - `target` must be a contract.
1293      * - calling `target` with `data` must not revert.
1294      *
1295      * _Available since v3.1._
1296      */
1297     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1298         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
1299     }
1300 
1301     /**
1302      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1303      * `errorMessage` as a fallback revert reason when `target` reverts.
1304      *
1305      * _Available since v3.1._
1306      */
1307     function functionCall(
1308         address target,
1309         bytes memory data,
1310         string memory errorMessage
1311     ) internal returns (bytes memory) {
1312         return functionCallWithValue(target, data, 0, errorMessage);
1313     }
1314 
1315     /**
1316      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1317      * but also transferring `value` wei to `target`.
1318      *
1319      * Requirements:
1320      *
1321      * - the calling contract must have an ETH balance of at least `value`.
1322      * - the called Solidity function must be `payable`.
1323      *
1324      * _Available since v3.1._
1325      */
1326     function functionCallWithValue(
1327         address target,
1328         bytes memory data,
1329         uint256 value
1330     ) internal returns (bytes memory) {
1331         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1332     }
1333 
1334     /**
1335      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1336      * with `errorMessage` as a fallback revert reason when `target` reverts.
1337      *
1338      * _Available since v3.1._
1339      */
1340     function functionCallWithValue(
1341         address target,
1342         bytes memory data,
1343         uint256 value,
1344         string memory errorMessage
1345     ) internal returns (bytes memory) {
1346         require(address(this).balance >= value, "Address: insufficient balance for call");
1347         (bool success, bytes memory returndata) = target.call{value: value}(data);
1348         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1349     }
1350 
1351     /**
1352      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1353      * but performing a static call.
1354      *
1355      * _Available since v3.3._
1356      */
1357     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1358         return functionStaticCall(target, data, "Address: low-level static call failed");
1359     }
1360 
1361     /**
1362      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1363      * but performing a static call.
1364      *
1365      * _Available since v3.3._
1366      */
1367     function functionStaticCall(
1368         address target,
1369         bytes memory data,
1370         string memory errorMessage
1371     ) internal view returns (bytes memory) {
1372         (bool success, bytes memory returndata) = target.staticcall(data);
1373         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1374     }
1375 
1376     /**
1377      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1378      * but performing a delegate call.
1379      *
1380      * _Available since v3.4._
1381      */
1382     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1383         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1384     }
1385 
1386     /**
1387      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1388      * but performing a delegate call.
1389      *
1390      * _Available since v3.4._
1391      */
1392     function functionDelegateCall(
1393         address target,
1394         bytes memory data,
1395         string memory errorMessage
1396     ) internal returns (bytes memory) {
1397         (bool success, bytes memory returndata) = target.delegatecall(data);
1398         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1399     }
1400 
1401     /**
1402      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
1403      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
1404      *
1405      * _Available since v4.8._
1406      */
1407     function verifyCallResultFromTarget(
1408         address target,
1409         bool success,
1410         bytes memory returndata,
1411         string memory errorMessage
1412     ) internal view returns (bytes memory) {
1413         if (success) {
1414             if (returndata.length == 0) {
1415                 // only check isContract if the call was successful and the return data is empty
1416                 // otherwise we already know that it was a contract
1417                 require(isContract(target), "Address: call to non-contract");
1418             }
1419             return returndata;
1420         } else {
1421             _revert(returndata, errorMessage);
1422         }
1423     }
1424 
1425     /**
1426      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
1427      * revert reason or using the provided one.
1428      *
1429      * _Available since v4.3._
1430      */
1431     function verifyCallResult(
1432         bool success,
1433         bytes memory returndata,
1434         string memory errorMessage
1435     ) internal pure returns (bytes memory) {
1436         if (success) {
1437             return returndata;
1438         } else {
1439             _revert(returndata, errorMessage);
1440         }
1441     }
1442 
1443     function _revert(bytes memory returndata, string memory errorMessage) private pure {
1444         // Look for revert reason and bubble it up if present
1445         if (returndata.length > 0) {
1446             // The easiest way to bubble the revert reason is using memory via assembly
1447             /// @solidity memory-safe-assembly
1448             assembly {
1449                 let returndata_size := mload(returndata)
1450                 revert(add(32, returndata), returndata_size)
1451             }
1452         } else {
1453             revert(errorMessage);
1454         }
1455     }
1456 }
1457 
1458 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1459 
1460 
1461 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1462 
1463 pragma solidity ^0.8.0;
1464 
1465 /**
1466  * @dev Interface of the ERC165 standard, as defined in the
1467  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1468  *
1469  * Implementers can declare support of contract interfaces, which can then be
1470  * queried by others ({ERC165Checker}).
1471  *
1472  * For an implementation, see {ERC165}.
1473  */
1474 interface IERC165 {
1475     /**
1476      * @dev Returns true if this contract implements the interface defined by
1477      * `interfaceId`. See the corresponding
1478      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1479      * to learn more about how these ids are created.
1480      *
1481      * This function call must use less than 30 000 gas.
1482      */
1483     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1484 }
1485 
1486 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1487 
1488 
1489 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1490 
1491 pragma solidity ^0.8.0;
1492 
1493 
1494 /**
1495  * @dev Implementation of the {IERC165} interface.
1496  *
1497  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1498  * for the additional interface id that will be supported. For example:
1499  *
1500  * ```solidity
1501  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1502  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1503  * }
1504  * ```
1505  *
1506  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1507  */
1508 abstract contract ERC165 is IERC165 {
1509     /**
1510      * @dev See {IERC165-supportsInterface}.
1511      */
1512     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1513         return interfaceId == type(IERC165).interfaceId;
1514     }
1515 }
1516 
1517 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
1518 
1519 
1520 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
1521 
1522 pragma solidity ^0.8.0;
1523 
1524 
1525 /**
1526  * @dev _Available since v3.1._
1527  */
1528 interface IERC1155Receiver is IERC165 {
1529     /**
1530      * @dev Handles the receipt of a single ERC1155 token type. This function is
1531      * called at the end of a `safeTransferFrom` after the balance has been updated.
1532      *
1533      * NOTE: To accept the transfer, this must return
1534      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
1535      * (i.e. 0xf23a6e61, or its own function selector).
1536      *
1537      * @param operator The address which initiated the transfer (i.e. msg.sender)
1538      * @param from The address which previously owned the token
1539      * @param id The ID of the token being transferred
1540      * @param value The amount of tokens being transferred
1541      * @param data Additional data with no specified format
1542      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
1543      */
1544     function onERC1155Received(
1545         address operator,
1546         address from,
1547         uint256 id,
1548         uint256 value,
1549         bytes calldata data
1550     ) external returns (bytes4);
1551 
1552     /**
1553      * @dev Handles the receipt of a multiple ERC1155 token types. This function
1554      * is called at the end of a `safeBatchTransferFrom` after the balances have
1555      * been updated.
1556      *
1557      * NOTE: To accept the transfer(s), this must return
1558      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
1559      * (i.e. 0xbc197c81, or its own function selector).
1560      *
1561      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
1562      * @param from The address which previously owned the token
1563      * @param ids An array containing ids of each token being transferred (order and length must match values array)
1564      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
1565      * @param data Additional data with no specified format
1566      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
1567      */
1568     function onERC1155BatchReceived(
1569         address operator,
1570         address from,
1571         uint256[] calldata ids,
1572         uint256[] calldata values,
1573         bytes calldata data
1574     ) external returns (bytes4);
1575 }
1576 
1577 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
1578 
1579 
1580 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/IERC1155.sol)
1581 
1582 pragma solidity ^0.8.0;
1583 
1584 
1585 /**
1586  * @dev Required interface of an ERC1155 compliant contract, as defined in the
1587  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
1588  *
1589  * _Available since v3.1._
1590  */
1591 interface IERC1155 is IERC165 {
1592     /**
1593      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
1594      */
1595     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
1596 
1597     /**
1598      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
1599      * transfers.
1600      */
1601     event TransferBatch(
1602         address indexed operator,
1603         address indexed from,
1604         address indexed to,
1605         uint256[] ids,
1606         uint256[] values
1607     );
1608 
1609     /**
1610      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
1611      * `approved`.
1612      */
1613     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
1614 
1615     /**
1616      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
1617      *
1618      * If an {URI} event was emitted for `id`, the standard
1619      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
1620      * returned by {IERC1155MetadataURI-uri}.
1621      */
1622     event URI(string value, uint256 indexed id);
1623 
1624     /**
1625      * @dev Returns the amount of tokens of token type `id` owned by `account`.
1626      *
1627      * Requirements:
1628      *
1629      * - `account` cannot be the zero address.
1630      */
1631     function balanceOf(address account, uint256 id) external view returns (uint256);
1632 
1633     /**
1634      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
1635      *
1636      * Requirements:
1637      *
1638      * - `accounts` and `ids` must have the same length.
1639      */
1640     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
1641         external
1642         view
1643         returns (uint256[] memory);
1644 
1645     /**
1646      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
1647      *
1648      * Emits an {ApprovalForAll} event.
1649      *
1650      * Requirements:
1651      *
1652      * - `operator` cannot be the caller.
1653      */
1654     function setApprovalForAll(address operator, bool approved) external;
1655 
1656     /**
1657      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
1658      *
1659      * See {setApprovalForAll}.
1660      */
1661     function isApprovedForAll(address account, address operator) external view returns (bool);
1662 
1663     /**
1664      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1665      *
1666      * Emits a {TransferSingle} event.
1667      *
1668      * Requirements:
1669      *
1670      * - `to` cannot be the zero address.
1671      * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
1672      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1673      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1674      * acceptance magic value.
1675      */
1676     function safeTransferFrom(
1677         address from,
1678         address to,
1679         uint256 id,
1680         uint256 amount,
1681         bytes calldata data
1682     ) external;
1683 
1684     /**
1685      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
1686      *
1687      * Emits a {TransferBatch} event.
1688      *
1689      * Requirements:
1690      *
1691      * - `ids` and `amounts` must have the same length.
1692      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1693      * acceptance magic value.
1694      */
1695     function safeBatchTransferFrom(
1696         address from,
1697         address to,
1698         uint256[] calldata ids,
1699         uint256[] calldata amounts,
1700         bytes calldata data
1701     ) external;
1702 }
1703 
1704 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
1705 
1706 
1707 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
1708 
1709 pragma solidity ^0.8.0;
1710 
1711 
1712 /**
1713  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
1714  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
1715  *
1716  * _Available since v3.1._
1717  */
1718 interface IERC1155MetadataURI is IERC1155 {
1719     /**
1720      * @dev Returns the URI for token type `id`.
1721      *
1722      * If the `\{id\}` substring is present in the URI, it must be replaced by
1723      * clients with the actual token type ID.
1724      */
1725     function uri(uint256 id) external view returns (string memory);
1726 }
1727 
1728 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
1729 
1730 
1731 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC1155/ERC1155.sol)
1732 
1733 pragma solidity ^0.8.0;
1734 
1735 
1736 
1737 
1738 
1739 
1740 
1741 /**
1742  * @dev Implementation of the basic standard multi-token.
1743  * See https://eips.ethereum.org/EIPS/eip-1155
1744  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
1745  *
1746  * _Available since v3.1._
1747  */
1748 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
1749     using Address for address;
1750 
1751     // Mapping from token ID to account balances
1752     mapping(uint256 => mapping(address => uint256)) private _balances;
1753 
1754     // Mapping from account to operator approvals
1755     mapping(address => mapping(address => bool)) private _operatorApprovals;
1756 
1757     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
1758     string private _uri;
1759 
1760     /**
1761      * @dev See {_setURI}.
1762      */
1763     constructor(string memory uri_) {
1764         _setURI(uri_);
1765     }
1766 
1767     /**
1768      * @dev See {IERC165-supportsInterface}.
1769      */
1770     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1771         return
1772             interfaceId == type(IERC1155).interfaceId ||
1773             interfaceId == type(IERC1155MetadataURI).interfaceId ||
1774             super.supportsInterface(interfaceId);
1775     }
1776 
1777     /**
1778      * @dev See {IERC1155MetadataURI-uri}.
1779      *
1780      * This implementation returns the same URI for *all* token types. It relies
1781      * on the token type ID substitution mechanism
1782      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1783      *
1784      * Clients calling this function must replace the `\{id\}` substring with the
1785      * actual token type ID.
1786      */
1787     function uri(uint256) public view virtual override returns (string memory) {
1788         return _uri;
1789     }
1790 
1791     /**
1792      * @dev See {IERC1155-balanceOf}.
1793      *
1794      * Requirements:
1795      *
1796      * - `account` cannot be the zero address.
1797      */
1798     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
1799         require(account != address(0), "ERC1155: address zero is not a valid owner");
1800         return _balances[id][account];
1801     }
1802 
1803     /**
1804      * @dev See {IERC1155-balanceOfBatch}.
1805      *
1806      * Requirements:
1807      *
1808      * - `accounts` and `ids` must have the same length.
1809      */
1810     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
1811         public
1812         view
1813         virtual
1814         override
1815         returns (uint256[] memory)
1816     {
1817         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
1818 
1819         uint256[] memory batchBalances = new uint256[](accounts.length);
1820 
1821         for (uint256 i = 0; i < accounts.length; ++i) {
1822             batchBalances[i] = balanceOf(accounts[i], ids[i]);
1823         }
1824 
1825         return batchBalances;
1826     }
1827 
1828     /**
1829      * @dev See {IERC1155-setApprovalForAll}.
1830      */
1831     function setApprovalForAll(address operator, bool approved) public virtual override {
1832         _setApprovalForAll(_msgSender(), operator, approved);
1833     }
1834 
1835     /**
1836      * @dev See {IERC1155-isApprovedForAll}.
1837      */
1838     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
1839         return _operatorApprovals[account][operator];
1840     }
1841 
1842     /**
1843      * @dev See {IERC1155-safeTransferFrom}.
1844      */
1845     function safeTransferFrom(
1846         address from,
1847         address to,
1848         uint256 id,
1849         uint256 amount,
1850         bytes memory data
1851     ) public virtual override {
1852         require(
1853             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1854             "ERC1155: caller is not token owner or approved"
1855         );
1856         _safeTransferFrom(from, to, id, amount, data);
1857     }
1858 
1859     /**
1860      * @dev See {IERC1155-safeBatchTransferFrom}.
1861      */
1862     function safeBatchTransferFrom(
1863         address from,
1864         address to,
1865         uint256[] memory ids,
1866         uint256[] memory amounts,
1867         bytes memory data
1868     ) public virtual override {
1869         require(
1870             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1871             "ERC1155: caller is not token owner or approved"
1872         );
1873         _safeBatchTransferFrom(from, to, ids, amounts, data);
1874     }
1875 
1876     /**
1877      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1878      *
1879      * Emits a {TransferSingle} event.
1880      *
1881      * Requirements:
1882      *
1883      * - `to` cannot be the zero address.
1884      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1885      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1886      * acceptance magic value.
1887      */
1888     function _safeTransferFrom(
1889         address from,
1890         address to,
1891         uint256 id,
1892         uint256 amount,
1893         bytes memory data
1894     ) internal virtual {
1895         require(to != address(0), "ERC1155: transfer to the zero address");
1896 
1897         address operator = _msgSender();
1898         uint256[] memory ids = _asSingletonArray(id);
1899         uint256[] memory amounts = _asSingletonArray(amount);
1900 
1901         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1902 
1903         uint256 fromBalance = _balances[id][from];
1904         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1905         unchecked {
1906             _balances[id][from] = fromBalance - amount;
1907         }
1908         _balances[id][to] += amount;
1909 
1910         emit TransferSingle(operator, from, to, id, amount);
1911 
1912         _afterTokenTransfer(operator, from, to, ids, amounts, data);
1913 
1914         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
1915     }
1916 
1917     /**
1918      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
1919      *
1920      * Emits a {TransferBatch} event.
1921      *
1922      * Requirements:
1923      *
1924      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1925      * acceptance magic value.
1926      */
1927     function _safeBatchTransferFrom(
1928         address from,
1929         address to,
1930         uint256[] memory ids,
1931         uint256[] memory amounts,
1932         bytes memory data
1933     ) internal virtual {
1934         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1935         require(to != address(0), "ERC1155: transfer to the zero address");
1936 
1937         address operator = _msgSender();
1938 
1939         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1940 
1941         for (uint256 i = 0; i < ids.length; ++i) {
1942             uint256 id = ids[i];
1943             uint256 amount = amounts[i];
1944 
1945             uint256 fromBalance = _balances[id][from];
1946             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1947             unchecked {
1948                 _balances[id][from] = fromBalance - amount;
1949             }
1950             _balances[id][to] += amount;
1951         }
1952 
1953         emit TransferBatch(operator, from, to, ids, amounts);
1954 
1955         _afterTokenTransfer(operator, from, to, ids, amounts, data);
1956 
1957         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
1958     }
1959 
1960     /**
1961      * @dev Sets a new URI for all token types, by relying on the token type ID
1962      * substitution mechanism
1963      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1964      *
1965      * By this mechanism, any occurrence of the `\{id\}` substring in either the
1966      * URI or any of the amounts in the JSON file at said URI will be replaced by
1967      * clients with the token type ID.
1968      *
1969      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
1970      * interpreted by clients as
1971      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
1972      * for token type ID 0x4cce0.
1973      *
1974      * See {uri}.
1975      *
1976      * Because these URIs cannot be meaningfully represented by the {URI} event,
1977      * this function emits no events.
1978      */
1979     function _setURI(string memory newuri) internal virtual {
1980         _uri = newuri;
1981     }
1982 
1983     /**
1984      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
1985      *
1986      * Emits a {TransferSingle} event.
1987      *
1988      * Requirements:
1989      *
1990      * - `to` cannot be the zero address.
1991      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1992      * acceptance magic value.
1993      */
1994     function _mint(
1995         address to,
1996         uint256 id,
1997         uint256 amount,
1998         bytes memory data
1999     ) internal virtual {
2000         require(to != address(0), "ERC1155: mint to the zero address");
2001 
2002         address operator = _msgSender();
2003         uint256[] memory ids = _asSingletonArray(id);
2004         uint256[] memory amounts = _asSingletonArray(amount);
2005 
2006         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
2007 
2008         _balances[id][to] += amount;
2009         emit TransferSingle(operator, address(0), to, id, amount);
2010 
2011         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
2012 
2013         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
2014     }
2015 
2016     /**
2017      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
2018      *
2019      * Emits a {TransferBatch} event.
2020      *
2021      * Requirements:
2022      *
2023      * - `ids` and `amounts` must have the same length.
2024      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
2025      * acceptance magic value.
2026      */
2027     function _mintBatch(
2028         address to,
2029         uint256[] memory ids,
2030         uint256[] memory amounts,
2031         bytes memory data
2032     ) internal virtual {
2033         require(to != address(0), "ERC1155: mint to the zero address");
2034         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
2035 
2036         address operator = _msgSender();
2037 
2038         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
2039 
2040         for (uint256 i = 0; i < ids.length; i++) {
2041             _balances[ids[i]][to] += amounts[i];
2042         }
2043 
2044         emit TransferBatch(operator, address(0), to, ids, amounts);
2045 
2046         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
2047 
2048         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
2049     }
2050 
2051     /**
2052      * @dev Destroys `amount` tokens of token type `id` from `from`
2053      *
2054      * Emits a {TransferSingle} event.
2055      *
2056      * Requirements:
2057      *
2058      * - `from` cannot be the zero address.
2059      * - `from` must have at least `amount` tokens of token type `id`.
2060      */
2061     function _burn(
2062         address from,
2063         uint256 id,
2064         uint256 amount
2065     ) internal virtual {
2066         require(from != address(0), "ERC1155: burn from the zero address");
2067 
2068         address operator = _msgSender();
2069         uint256[] memory ids = _asSingletonArray(id);
2070         uint256[] memory amounts = _asSingletonArray(amount);
2071 
2072         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
2073 
2074         uint256 fromBalance = _balances[id][from];
2075         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
2076         unchecked {
2077             _balances[id][from] = fromBalance - amount;
2078         }
2079 
2080         emit TransferSingle(operator, from, address(0), id, amount);
2081 
2082         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
2083     }
2084 
2085     /**
2086      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
2087      *
2088      * Emits a {TransferBatch} event.
2089      *
2090      * Requirements:
2091      *
2092      * - `ids` and `amounts` must have the same length.
2093      */
2094     function _burnBatch(
2095         address from,
2096         uint256[] memory ids,
2097         uint256[] memory amounts
2098     ) internal virtual {
2099         require(from != address(0), "ERC1155: burn from the zero address");
2100         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
2101 
2102         address operator = _msgSender();
2103 
2104         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
2105 
2106         for (uint256 i = 0; i < ids.length; i++) {
2107             uint256 id = ids[i];
2108             uint256 amount = amounts[i];
2109 
2110             uint256 fromBalance = _balances[id][from];
2111             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
2112             unchecked {
2113                 _balances[id][from] = fromBalance - amount;
2114             }
2115         }
2116 
2117         emit TransferBatch(operator, from, address(0), ids, amounts);
2118 
2119         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
2120     }
2121 
2122     /**
2123      * @dev Approve `operator` to operate on all of `owner` tokens
2124      *
2125      * Emits an {ApprovalForAll} event.
2126      */
2127     function _setApprovalForAll(
2128         address owner,
2129         address operator,
2130         bool approved
2131     ) internal virtual {
2132         require(owner != operator, "ERC1155: setting approval status for self");
2133         _operatorApprovals[owner][operator] = approved;
2134         emit ApprovalForAll(owner, operator, approved);
2135     }
2136 
2137     /**
2138      * @dev Hook that is called before any token transfer. This includes minting
2139      * and burning, as well as batched variants.
2140      *
2141      * The same hook is called on both single and batched variants. For single
2142      * transfers, the length of the `ids` and `amounts` arrays will be 1.
2143      *
2144      * Calling conditions (for each `id` and `amount` pair):
2145      *
2146      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
2147      * of token type `id` will be  transferred to `to`.
2148      * - When `from` is zero, `amount` tokens of token type `id` will be minted
2149      * for `to`.
2150      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
2151      * will be burned.
2152      * - `from` and `to` are never both zero.
2153      * - `ids` and `amounts` have the same, non-zero length.
2154      *
2155      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2156      */
2157     function _beforeTokenTransfer(
2158         address operator,
2159         address from,
2160         address to,
2161         uint256[] memory ids,
2162         uint256[] memory amounts,
2163         bytes memory data
2164     ) internal virtual {}
2165 
2166     /**
2167      * @dev Hook that is called after any token transfer. This includes minting
2168      * and burning, as well as batched variants.
2169      *
2170      * The same hook is called on both single and batched variants. For single
2171      * transfers, the length of the `id` and `amount` arrays will be 1.
2172      *
2173      * Calling conditions (for each `id` and `amount` pair):
2174      *
2175      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
2176      * of token type `id` will be  transferred to `to`.
2177      * - When `from` is zero, `amount` tokens of token type `id` will be minted
2178      * for `to`.
2179      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
2180      * will be burned.
2181      * - `from` and `to` are never both zero.
2182      * - `ids` and `amounts` have the same, non-zero length.
2183      *
2184      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2185      */
2186     function _afterTokenTransfer(
2187         address operator,
2188         address from,
2189         address to,
2190         uint256[] memory ids,
2191         uint256[] memory amounts,
2192         bytes memory data
2193     ) internal virtual {}
2194 
2195     function _doSafeTransferAcceptanceCheck(
2196         address operator,
2197         address from,
2198         address to,
2199         uint256 id,
2200         uint256 amount,
2201         bytes memory data
2202     ) private {
2203         if (to.isContract()) {
2204             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
2205                 if (response != IERC1155Receiver.onERC1155Received.selector) {
2206                     revert("ERC1155: ERC1155Receiver rejected tokens");
2207                 }
2208             } catch Error(string memory reason) {
2209                 revert(reason);
2210             } catch {
2211                 revert("ERC1155: transfer to non-ERC1155Receiver implementer");
2212             }
2213         }
2214     }
2215 
2216     function _doSafeBatchTransferAcceptanceCheck(
2217         address operator,
2218         address from,
2219         address to,
2220         uint256[] memory ids,
2221         uint256[] memory amounts,
2222         bytes memory data
2223     ) private {
2224         if (to.isContract()) {
2225             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
2226                 bytes4 response
2227             ) {
2228                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
2229                     revert("ERC1155: ERC1155Receiver rejected tokens");
2230                 }
2231             } catch Error(string memory reason) {
2232                 revert(reason);
2233             } catch {
2234                 revert("ERC1155: transfer to non-ERC1155Receiver implementer");
2235             }
2236         }
2237     }
2238 
2239     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
2240         uint256[] memory array = new uint256[](1);
2241         array[0] = element;
2242 
2243         return array;
2244     }
2245 }
2246 
2247 // File: WarBonds.sol
2248 
2249 
2250 
2251 // War Bonds by ATS. Written by NiftyLabs (https://niftylabs.dev/).
2252 
2253 pragma solidity ^0.8.17;
2254 
2255 
2256 
2257 
2258 
2259 
2260 
2261 
2262 contract WarBonds is ERC1155, Ownable, RevokableDefaultOperatorFilterer {
2263 
2264     string public name_;
2265     string public symbol_; 
2266 
2267     address public erc20Address;
2268     address public adminAddress;
2269     address public signer = 0x2f2A13462f6d4aF64954ee84641D265932849b64;
2270     address private crossMint = 0xdAb1a1854214684acE522439684a145E62505233;
2271 
2272     bool public isAllowlistClaimActive = false;
2273 
2274     struct TokenData {
2275         bool buyable;
2276         uint64 supply;
2277         uint64 minted;
2278         string uri;
2279         uint256 price;
2280         uint256 erc20Price;
2281     }
2282 
2283     mapping(uint256 => bool) public validTypes;
2284     mapping(uint256 => TokenData) public idToTokenData;
2285 
2286     mapping(address => mapping(uint256 => bool)) public allowlistMinted;
2287 
2288     uint256 public paymentPerClaim = 0.0006 ether;
2289     address public paymentFeeAddress = 0xa69B6935B0F38506b81224B4612d7Ea49A4B0aCC;
2290     address public withdrawAddress = 0x3978a70Acce93153f524e8fcdcBA1E3ace0aC05B;
2291 
2292     constructor() ERC1155("WarBonds") {
2293         name_ = "ATS WARBONDS";
2294         symbol_ = "WARBONDS";     
2295     }
2296 
2297     function createToken(
2298         uint256 _id,
2299         bool _buyable,
2300         uint64 _supply,
2301         string memory _uri,
2302         uint256 _price,
2303         uint256 _erc20Price
2304     ) public onlyOwner {
2305         require(validTypes[_id] == false, "token _id already exists");
2306         validTypes[_id] = true;
2307 
2308         idToTokenData[_id] = TokenData({
2309             buyable: _buyable,
2310             supply: _supply,
2311             minted: 0,
2312             uri: _uri,
2313             price: _price,
2314             erc20Price: _erc20Price
2315         });
2316 
2317         emit URI(_uri, _id);
2318     }
2319 
2320     function changeTokenURI(uint256 _id, string memory _uri) public onlyOwner {
2321         require(validTypes[_id], "Token doesn't exist yet");
2322 
2323         TokenData storage tokenData = idToTokenData[_id];
2324 
2325         tokenData.uri = _uri;
2326 
2327         emit URI(_uri, _id);
2328     }
2329 
2330     function changeTokenBuyable(uint256 _id, bool _status) public onlyOwner {
2331         require(validTypes[_id], "Token doesn't exist yet");
2332 
2333         TokenData storage tokenData = idToTokenData[_id];
2334 
2335         tokenData.buyable = _status;
2336     }
2337 
2338     function changeTokenPrice(uint256 _id, uint256 _price) public onlyOwner {
2339         require(validTypes[_id], "Token doesn't exist yet");
2340 
2341         TokenData storage tokenData = idToTokenData[_id];
2342 
2343         tokenData.price = _price;
2344     }
2345 
2346     function changeTokenERC20Price(uint256 _id, uint256 _price) public onlyOwner {
2347         require(validTypes[_id], "Token doesn't exist yet");
2348 
2349         TokenData storage tokenData = idToTokenData[_id];
2350 
2351         tokenData.erc20Price = _price;
2352     }
2353 
2354     function changeTokenSupply(uint256 _id, uint64 _supply) public onlyOwner {
2355         require(validTypes[_id], "Token doesn't exist yet");
2356         
2357         TokenData storage tokenData = idToTokenData[_id];
2358         require(_supply >= tokenData.supply, "New supply must be greater than current supply");
2359 
2360         tokenData.supply = _supply;
2361     }
2362 
2363     function reserveToken(uint256 _id, uint256 _amount) public onlyOwner  {
2364         TokenData storage tokenData = idToTokenData[_id];
2365         
2366         require(tokenData.minted + _amount <= tokenData.supply, "Minted out");
2367 
2368         tokenData.minted += uint64(_amount);
2369         _mint(msg.sender, _id, _amount, "");
2370     }
2371 
2372     function claimTokensWithAllowlist(bytes calldata _voucher, uint256 _id, uint256 _amount) public  {
2373         TokenData storage tokenData = idToTokenData[_id];
2374         
2375         require(isAllowlistClaimActive, "Allowlist claim is off");
2376         require(tokenData.minted + _amount <= tokenData.supply, "Minted out");
2377         require(!allowlistMinted[msg.sender][_id], "Already minted");
2378 
2379         allowlistMinted[msg.sender][_id] = true;
2380 
2381         bytes32 hash = keccak256(abi.encodePacked(msg.sender, _id, _amount));
2382         require(_verifySignature(signer, hash, _voucher), "Invalid voucher");
2383 
2384         tokenData.minted += uint64(_amount);
2385         _mint(msg.sender, _id, _amount, "");
2386     }
2387 
2388     function buyTokensWithEth(uint256 _id, uint256 _amount) public payable {
2389         TokenData storage tokenData = idToTokenData[_id];
2390 
2391         require(tokenData.price > 0, "Can't buy with ETH");
2392         require(msg.value >= ((tokenData.price * _amount) + (paymentPerClaim * _amount)), "Not enough eth");
2393         require(tokenData.buyable, "Not buyable");
2394 
2395         require(tokenData.minted + _amount <= tokenData.supply, "Minted out");
2396         require(_amount > 0, "Can't buy 0");
2397 
2398         tokenData.minted += uint64(_amount);
2399 
2400         _mint(msg.sender, _id, _amount, "");
2401 
2402         _sendPaymentEth(paymentPerClaim * _amount);
2403     }
2404 
2405     function buyTokensWithCreditCard(address wallet, uint256 _id, uint256 _amount) public payable {
2406         TokenData storage tokenData = idToTokenData[_id];
2407 
2408         require(msg.sender == crossMint, "Crossmint only");
2409         require(tokenData.price > 0, "Can't buy with ETH");
2410         require(msg.value >= ((tokenData.price * _amount) + (paymentPerClaim * _amount)), "Not enough eth");
2411         require(tokenData.buyable, "Not buyable");
2412 
2413         require(tokenData.minted + _amount <= tokenData.supply, "Minted out");
2414         require(_amount > 0, "Can't buy 0");
2415 
2416         tokenData.minted += uint64(_amount);
2417 
2418         _mint(wallet, _id, _amount, "");
2419 
2420         _sendPaymentEth(paymentPerClaim * _amount);
2421     }
2422 
2423     function buyTokensWithERC20(uint256 _id, uint256 _amount) public payable {
2424         TokenData storage tokenData = idToTokenData[_id];
2425 
2426         require(tokenData.erc20Price > 0, "Can't buy with ERC20");
2427         require(tokenData.minted + _amount <= tokenData.supply, "Minted out");
2428         require(tokenData.buyable, "Not buyable");
2429 
2430         require(_amount > 0, "Can't buy 0");
2431         require(msg.value >= (paymentPerClaim*_amount), "No payment fee");
2432 
2433         IERC20(erc20Address).transferFrom(
2434             msg.sender,
2435             withdrawAddress,
2436             tokenData.erc20Price * _amount
2437         );
2438 
2439         tokenData.minted += uint64(_amount);
2440         _mint(msg.sender, _id, _amount, "");
2441 
2442         _sendPaymentEth(paymentPerClaim * _amount);
2443     }
2444 
2445     function mintBatch(
2446         uint256[] memory _ids,
2447         uint256[] memory _quantity
2448     ) external onlyOwner {
2449         _mintBatch(owner(), _ids, _quantity, "");
2450     }
2451 
2452     function burnForAddress(uint256 _id, address _address) external {
2453         require(msg.sender == adminAddress, "Invalid burner address");
2454         _burn(_address, _id, 1);
2455     }
2456 
2457     function setERC20Address(address _erc20Address) external onlyOwner {
2458         erc20Address = _erc20Address;
2459     }
2460 
2461     function setAdminAddress(address _adminAddress) external onlyOwner {
2462         adminAddress = _adminAddress;
2463     }
2464 
2465     function _verifySignature(address _signer, bytes32 _hash, bytes memory _signature) private pure returns (bool) {
2466         return _signer == ECDSA.recover(ECDSA.toEthSignedMessageHash(_hash), _signature);
2467     }
2468 
2469     function setSigner(address _signer) external onlyOwner {
2470         signer = _signer;
2471     }
2472 
2473     function setWithdrawAddress(address _address) external onlyOwner {
2474         withdrawAddress = _address;
2475     }
2476 
2477     function setPaymentFeeAddress(address _address) external onlyOwner {
2478         paymentFeeAddress = _address;
2479     }
2480 
2481     function setAllowlistClaimActive() public onlyOwner {
2482         isAllowlistClaimActive = !isAllowlistClaimActive;
2483     }
2484 
2485     function updatePaymentFee(uint256 _fee) public onlyOwner {
2486         paymentPerClaim = _fee;
2487     }
2488 
2489     function getTokenDataFor(uint256[] calldata ids) external view returns (TokenData[] memory) {
2490 
2491         TokenData[] memory tokenData = new TokenData[](ids.length);
2492         
2493         for(uint256 i = 0; i < ids.length; i++)
2494             tokenData[i] = idToTokenData[ids[i]];
2495 
2496         return tokenData;
2497     }
2498 
2499     function uri(uint256 _id) public view override returns (string memory) {
2500         require(validTypes[_id], "URI requested for invalid type");
2501 
2502         TokenData memory tokenData = idToTokenData[_id];
2503 
2504         return string(abi.encodePacked(tokenData.uri, Strings.toString(_id)));
2505     }
2506 
2507     function name() public view returns (string memory) {
2508         return name_;
2509     }
2510 
2511     function symbol() public view returns (string memory) {
2512         return symbol_;
2513     }
2514 
2515     function _sendPaymentEth(uint256 _value) internal {
2516         (bool success, ) = payable(paymentFeeAddress).call {value: _value}("");
2517         require(success);
2518     }
2519 
2520     function withdraw() public payable onlyOwner {
2521         (bool success, ) = payable(withdrawAddress).call {value: address(this).balance}("");
2522         require(success);
2523     }
2524 
2525     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
2526         super.setApprovalForAll(operator, approved);
2527     }
2528 
2529     function safeTransferFrom(address from, address to, uint256 tokenId, uint256 amount, bytes memory data)
2530         public
2531         override
2532         onlyAllowedOperator(from)
2533     {
2534         super.safeTransferFrom(from, to, tokenId, amount, data);
2535     }
2536 
2537     function safeBatchTransferFrom(
2538         address from,
2539         address to,
2540         uint256[] memory ids,
2541         uint256[] memory amounts,
2542         bytes memory data
2543     ) public virtual override onlyAllowedOperator(from) {
2544         super.safeBatchTransferFrom(from, to, ids, amounts, data);
2545     }
2546 
2547     function owner() public view override(Ownable, UpdatableOperatorFilterer) returns (address) {
2548         return Ownable.owner();
2549     }
2550 
2551 }