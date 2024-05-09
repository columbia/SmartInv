1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity ^0.8.0;
3 
4 /**
5 *********************
6 NFT TEMPLATE CONTRACT
7 *********************
8 
9 Although this code is available for viewing on GitHub and Etherscan, the general public is NOT given a license to freely deploy smart contracts based on this code, on any blockchains.
10 
11 To prevent confusion and increase trust in the audited code bases of smart contracts we produce, we intend for there to be only ONE official Factory address on the blockchain producing these NFT smart contracts, and we are going to point a blockchain domain name at it.
12 
13 Copyright (c) Intercoin Inc. All rights reserved.
14 
15 ALLOWED USAGE.
16 
17 Provided they agree to all the conditions of this Agreement listed below, anyone is welcome to interact with the official Factory Contract at the address 0x22222e0849704b754be0A372fFcDb9B22e4D7147 to produce smart contract instances, or to interact with instances produced in this manner by others.
18 
19 Any user of software powered by this code MUST agree to the following, in order to use it. If you do not agree, refrain from using the software:
20 
21 DISCLAIMERS AND DISCLOSURES.
22 
23 Customer expressly recognizes that nearly any software may contain unforeseen bugs or other defects, due to the nature of software development. Moreover, because of the immutable nature of smart contracts, any such defects will persist in the software once it is deployed onto the blockchain. Customer therefore expressly acknowledges that any responsibility to obtain outside audits and analysis of any software produced by Developer rests solely with Customer.
24 
25 Customer understands and acknowledges that the Software is being delivered as-is, and may contain potential defects. While Developer and its staff and partners have exercised care and best efforts in an attempt to produce solid, working software products, Developer EXPRESSLY DISCLAIMS MAKING ANY GUARANTEES, REPRESENTATIONS OR WARRANTIES, EXPRESS OR IMPLIED, ABOUT THE FITNESS OF THE SOFTWARE, INCLUDING LACK OF DEFECTS, MERCHANTABILITY OR SUITABILITY FOR A PARTICULAR PURPOSE.
26 
27 Customer agrees that neither Developer nor any other party has made any representations or warranties, nor has the Customer relied on any representations or warranties, express or implied, including any implied warranty of merchantability or fitness for any particular purpose with respect to the Software. Customer acknowledges that no affirmation of fact or statement (whether written or oral) made by Developer, its representatives, or any other party outside of this Agreement with respect to the Software shall be deemed to create any express or implied warranty on the part of Developer or its representatives.
28 
29 INDEMNIFICATION.
30 
31 Customer agrees to indemnify, defend and hold Developer and its officers, directors, employees, agents and contractors harmless from any loss, cost, expense (including attorney’s fees and expenses), associated with or related to any demand, claim, liability, damages or cause of action of any kind or character (collectively referred to as “claim”), in any manner arising out of or relating to any third party demand, dispute, mediation, arbitration, litigation, or any violation or breach of any provision of this Agreement by Customer.
32 
33 NO WARRANTY.
34 
35 THE SOFTWARE IS PROVIDED “AS IS” WITHOUT WARRANTY. DEVELOPER SHALL NOT BE LIABLE FOR ANY DIRECT, INDIRECT, SPECIAL, INCIDENTAL, CONSEQUENTIAL, OR EXEMPLARY DAMAGES FOR BREACH OF THE LIMITED WARRANTY. TO THE MAXIMUM EXTENT PERMITTED BY LAW, DEVELOPER EXPRESSLY DISCLAIMS, AND CUSTOMER EXPRESSLY WAIVES, ALL OTHER WARRANTIES, WHETHER EXPRESSED, IMPLIED, OR STATUTORY, INCLUDING WITHOUT LIMITATION ALL IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE OR USE, OR ANY WARRANTY ARISING OUT OF ANY PROPOSAL, SPECIFICATION, OR SAMPLE, AS WELL AS ANY WARRANTIES THAT THE SOFTWARE (OR ANY ELEMENTS THEREOF) WILL ACHIEVE A PARTICULAR RESULT, OR WILL BE UNINTERRUPTED OR ERROR-FREE. THE TERM OF ANY IMPLIED WARRANTIES THAT CANNOT BE DISCLAIMED UNDER APPLICABLE LAW SHALL BE LIMITED TO THE DURATION OF THE FOREGOING EXPRESS WARRANTY PERIOD. SOME STATES DO NOT ALLOW THE EXCLUSION OF IMPLIED WARRANTIES AND/OR DO NOT ALLOW LIMITATIONS ON THE AMOUNT OF TIME AN IMPLIED WARRANTY LASTS, SO THE ABOVE LIMITATIONS MAY NOT APPLY TO CUSTOMER. THIS LIMITED WARRANTY GIVES CUSTOMER SPECIFIC LEGAL RIGHTS. CUSTOMER MAY HAVE OTHER RIGHTS WHICH VARY FROM STATE TO STATE. 
36 
37 LIMITATION OF LIABILITY. 
38 
39 TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE LAW, IN NO EVENT SHALL DEVELOPER BE LIABLE UNDER ANY THEORY OF LIABILITY FOR ANY CONSEQUENTIAL, INDIRECT, INCIDENTAL, SPECIAL, PUNITIVE OR EXEMPLARY DAMAGES OF ANY KIND, INCLUDING, WITHOUT LIMITATION, DAMAGES ARISING FROM LOSS OF PROFITS, REVENUE, DATA OR USE, OR FROM INTERRUPTED COMMUNICATIONS OR DAMAGED DATA, OR FROM ANY DEFECT OR ERROR OR IN CONNECTION WITH CUSTOMER'S ACQUISITION OF SUBSTITUTE GOODS OR SERVICES OR MALFUNCTION OF THE SOFTWARE, OR ANY SUCH DAMAGES ARISING FROM BREACH OF CONTRACT OR WARRANTY OR FROM NEGLIGENCE OR STRICT LIABILITY, EVEN IF DEVELOPER OR ANY OTHER PERSON HAS BEEN ADVISED OR SHOULD KNOW OF THE POSSIBILITY OF SUCH DAMAGES, AND NOTWITHSTANDING THE FAILURE OF ANY REMEDY TO ACHIEVE ITS INTENDED PURPOSE. WITHOUT LIMITING THE FOREGOING OR ANY OTHER LIMITATION OF LIABILITY HEREIN, REGARDLESS OF THE FORM OF ACTION, WHETHER FOR BREACH OF CONTRACT, WARRANTY, NEGLIGENCE, STRICT LIABILITY IN TORT OR OTHERWISE, CUSTOMER'S EXCLUSIVE REMEDY AND THE TOTAL LIABILITY OF DEVELOPER OR ANY SUPPLIER OF SERVICES TO DEVELOPER FOR ANY CLAIMS ARISING IN ANY WAY IN CONNECTION WITH OR RELATED TO THIS AGREEMENT, THE SOFTWARE, FOR ANY CAUSE WHATSOEVER, SHALL NOT EXCEED 1,000 USD.
40 
41 TRADEMARKS.
42 
43 This Agreement does not grant you any right in any trademark or logo of Developer or its affiliates.
44 
45 LINK REQUIREMENTS.
46 
47 Operators of any Websites and Apps which make use of smart contracts based on this code must conspicuously include the following phrase in their website, featuring a clickable link that takes users to nftremix.com:
48 "Visit https://nftremix.com to release your own NFT collection."
49 
50 STAKING REQUIREMENTS.
51 
52 In the future, Developer may begin requiring staking of ITR tokens in order to take further actions (such as producing series and minting tokens). Any staking requirements will first be announced on Developer's website (intercoin.org) four weeks in advance. Staking requirements will not apply to any actions already taken before they are put in place.
53 
54 CUSTOM ARRANGEMENTS.
55 
56 Reach out to us at intercoin.org if you are looking to obtain ITR tokens in bulk, remove link requirements forever, remove staking requirements forever, or get custom work done with your NFT projects.
57 
58 ENTIRE AGREEMENT
59 
60 This Agreement contains the entire agreement and understanding among the parties hereto with respect to the subject matter hereof, and supersedes all prior and contemporaneous agreements, understandings, inducements and conditions, express or implied, oral or written, of any nature whatsoever with respect to the subject matter hereof. The express terms hereof control and supersede any course of performance and/or usage of the trade inconsistent with any of the terms hereof. Provisions from previous Agreements executed between Customer and Developer., which are not expressly dealt with in this Agreement, will remain in effect.
61 
62 SUCCESSORS AND ASSIGNS
63 
64 This Agreement shall continue to apply to any successors or assigns of either party, or any corporation or other entity acquiring all or substantially all the assets and business of either party whether by operation of law or otherwise.
65 
66 ARBITRATION
67 
68 All disputes related to this agreement shall be governed by and interpreted in accordance with the laws of New York, without regard to principles of conflict of laws. The parties to this agreement will submit all disputes arising under this agreement to arbitration in New York City, New York before a single arbitrator of the American Arbitration Association (“AAA”). The arbitrator shall be selected by application of the rules of the AAA, or by mutual agreement of the parties, except that such arbitrator shall be an attorney admitted to practice law New York. No party to this agreement will challenge the jurisdiction or venue provisions as provided in this section. No party to this agreement will challenge the jurisdiction or venue provisions as provided in this section.
69 **/
70 
71 
72 // File: @openzeppelin/contracts-upgradeable/utils/structs/EnumerableSetUpgradeable.sol
73 
74 
75 // OpenZeppelin Contracts v4.4.0 (utils/structs/EnumerableSet.sol)
76 
77 pragma solidity ^0.8.0;
78 
79 /**
80  * @dev Library for managing
81  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
82  * types.
83  *
84  * Sets have the following properties:
85  *
86  * - Elements are added, removed, and checked for existence in constant time
87  * (O(1)).
88  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
89  *
90  * ```
91  * contract Example {
92  *     // Add the library methods
93  *     using EnumerableSet for EnumerableSet.AddressSet;
94  *
95  *     // Declare a set state variable
96  *     EnumerableSet.AddressSet private mySet;
97  * }
98  * ```
99  *
100  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
101  * and `uint256` (`UintSet`) are supported.
102  */
103 library EnumerableSetUpgradeable {
104     // To implement this library for multiple types with as little code
105     // repetition as possible, we write it in terms of a generic Set type with
106     // bytes32 values.
107     // The Set implementation uses private functions, and user-facing
108     // implementations (such as AddressSet) are just wrappers around the
109     // underlying Set.
110     // This means that we can only create new EnumerableSets for types that fit
111     // in bytes32.
112 
113     struct Set {
114         // Storage of set values
115         bytes32[] _values;
116         // Position of the value in the `values` array, plus 1 because index 0
117         // means a value is not in the set.
118         mapping(bytes32 => uint256) _indexes;
119     }
120 
121     /**
122      * @dev Add a value to a set. O(1).
123      *
124      * Returns true if the value was added to the set, that is if it was not
125      * already present.
126      */
127     function _add(Set storage set, bytes32 value) private returns (bool) {
128         if (!_contains(set, value)) {
129             set._values.push(value);
130             // The value is stored at length-1, but we add 1 to all indexes
131             // and use 0 as a sentinel value
132             set._indexes[value] = set._values.length;
133             return true;
134         } else {
135             return false;
136         }
137     }
138 
139     /**
140      * @dev Removes a value from a set. O(1).
141      *
142      * Returns true if the value was removed from the set, that is if it was
143      * present.
144      */
145     function _remove(Set storage set, bytes32 value) private returns (bool) {
146         // We read and store the value's index to prevent multiple reads from the same storage slot
147         uint256 valueIndex = set._indexes[value];
148 
149         if (valueIndex != 0) {
150             // Equivalent to contains(set, value)
151             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
152             // the array, and then remove the last element (sometimes called as 'swap and pop').
153             // This modifies the order of the array, as noted in {at}.
154 
155             uint256 toDeleteIndex = valueIndex - 1;
156             uint256 lastIndex = set._values.length - 1;
157 
158             if (lastIndex != toDeleteIndex) {
159                 bytes32 lastvalue = set._values[lastIndex];
160 
161                 // Move the last value to the index where the value to delete is
162                 set._values[toDeleteIndex] = lastvalue;
163                 // Update the index for the moved value
164                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
165             }
166 
167             // Delete the slot where the moved value was stored
168             set._values.pop();
169 
170             // Delete the index for the deleted slot
171             delete set._indexes[value];
172 
173             return true;
174         } else {
175             return false;
176         }
177     }
178 
179     /**
180      * @dev Returns true if the value is in the set. O(1).
181      */
182     function _contains(Set storage set, bytes32 value) private view returns (bool) {
183         return set._indexes[value] != 0;
184     }
185 
186     /**
187      * @dev Returns the number of values on the set. O(1).
188      */
189     function _length(Set storage set) private view returns (uint256) {
190         return set._values.length;
191     }
192 
193     /**
194      * @dev Returns the value stored at position `index` in the set. O(1).
195      *
196      * Note that there are no guarantees on the ordering of values inside the
197      * array, and it may change when more values are added or removed.
198      *
199      * Requirements:
200      *
201      * - `index` must be strictly less than {length}.
202      */
203     function _at(Set storage set, uint256 index) private view returns (bytes32) {
204         return set._values[index];
205     }
206 
207     /**
208      * @dev Return the entire set in an array
209      *
210      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
211      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
212      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
213      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
214      */
215     function _values(Set storage set) private view returns (bytes32[] memory) {
216         return set._values;
217     }
218 
219     // Bytes32Set
220 
221     struct Bytes32Set {
222         Set _inner;
223     }
224 
225     /**
226      * @dev Add a value to a set. O(1).
227      *
228      * Returns true if the value was added to the set, that is if it was not
229      * already present.
230      */
231     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
232         return _add(set._inner, value);
233     }
234 
235     /**
236      * @dev Removes a value from a set. O(1).
237      *
238      * Returns true if the value was removed from the set, that is if it was
239      * present.
240      */
241     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
242         return _remove(set._inner, value);
243     }
244 
245     /**
246      * @dev Returns true if the value is in the set. O(1).
247      */
248     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
249         return _contains(set._inner, value);
250     }
251 
252     /**
253      * @dev Returns the number of values in the set. O(1).
254      */
255     function length(Bytes32Set storage set) internal view returns (uint256) {
256         return _length(set._inner);
257     }
258 
259     /**
260      * @dev Returns the value stored at position `index` in the set. O(1).
261      *
262      * Note that there are no guarantees on the ordering of values inside the
263      * array, and it may change when more values are added or removed.
264      *
265      * Requirements:
266      *
267      * - `index` must be strictly less than {length}.
268      */
269     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
270         return _at(set._inner, index);
271     }
272 
273     /**
274      * @dev Return the entire set in an array
275      *
276      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
277      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
278      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
279      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
280      */
281     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
282         return _values(set._inner);
283     }
284 
285     // AddressSet
286 
287     struct AddressSet {
288         Set _inner;
289     }
290 
291     /**
292      * @dev Add a value to a set. O(1).
293      *
294      * Returns true if the value was added to the set, that is if it was not
295      * already present.
296      */
297     function add(AddressSet storage set, address value) internal returns (bool) {
298         return _add(set._inner, bytes32(uint256(uint160(value))));
299     }
300 
301     /**
302      * @dev Removes a value from a set. O(1).
303      *
304      * Returns true if the value was removed from the set, that is if it was
305      * present.
306      */
307     function remove(AddressSet storage set, address value) internal returns (bool) {
308         return _remove(set._inner, bytes32(uint256(uint160(value))));
309     }
310 
311     /**
312      * @dev Returns true if the value is in the set. O(1).
313      */
314     function contains(AddressSet storage set, address value) internal view returns (bool) {
315         return _contains(set._inner, bytes32(uint256(uint160(value))));
316     }
317 
318     /**
319      * @dev Returns the number of values in the set. O(1).
320      */
321     function length(AddressSet storage set) internal view returns (uint256) {
322         return _length(set._inner);
323     }
324 
325     /**
326      * @dev Returns the value stored at position `index` in the set. O(1).
327      *
328      * Note that there are no guarantees on the ordering of values inside the
329      * array, and it may change when more values are added or removed.
330      *
331      * Requirements:
332      *
333      * - `index` must be strictly less than {length}.
334      */
335     function at(AddressSet storage set, uint256 index) internal view returns (address) {
336         return address(uint160(uint256(_at(set._inner, index))));
337     }
338 
339     /**
340      * @dev Return the entire set in an array
341      *
342      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
343      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
344      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
345      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
346      */
347     function values(AddressSet storage set) internal view returns (address[] memory) {
348         bytes32[] memory store = _values(set._inner);
349         address[] memory result;
350 
351         assembly {
352             result := store
353         }
354 
355         return result;
356     }
357 
358     // UintSet
359 
360     struct UintSet {
361         Set _inner;
362     }
363 
364     /**
365      * @dev Add a value to a set. O(1).
366      *
367      * Returns true if the value was added to the set, that is if it was not
368      * already present.
369      */
370     function add(UintSet storage set, uint256 value) internal returns (bool) {
371         return _add(set._inner, bytes32(value));
372     }
373 
374     /**
375      * @dev Removes a value from a set. O(1).
376      *
377      * Returns true if the value was removed from the set, that is if it was
378      * present.
379      */
380     function remove(UintSet storage set, uint256 value) internal returns (bool) {
381         return _remove(set._inner, bytes32(value));
382     }
383 
384     /**
385      * @dev Returns true if the value is in the set. O(1).
386      */
387     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
388         return _contains(set._inner, bytes32(value));
389     }
390 
391     /**
392      * @dev Returns the number of values on the set. O(1).
393      */
394     function length(UintSet storage set) internal view returns (uint256) {
395         return _length(set._inner);
396     }
397 
398     /**
399      * @dev Returns the value stored at position `index` in the set. O(1).
400      *
401      * Note that there are no guarantees on the ordering of values inside the
402      * array, and it may change when more values are added or removed.
403      *
404      * Requirements:
405      *
406      * - `index` must be strictly less than {length}.
407      */
408     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
409         return uint256(_at(set._inner, index));
410     }
411 
412     /**
413      * @dev Return the entire set in an array
414      *
415      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
416      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
417      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
418      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
419      */
420     function values(UintSet storage set) internal view returns (uint256[] memory) {
421         bytes32[] memory store = _values(set._inner);
422         uint256[] memory result;
423 
424         assembly {
425             result := store
426         }
427 
428         return result;
429     }
430 }
431 
432 // File: contracts/interfaces/IFactory.sol
433 
434 
435 pragma solidity ^0.8.0;
436 
437 interface IFactory {
438     function canOverrideCostManager(address operator, address instance) external view returns (bool);
439 }
440 
441 // File: @openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol
442 
443 
444 // OpenZeppelin Contracts v4.4.0 (proxy/utils/Initializable.sol)
445 
446 pragma solidity ^0.8.0;
447 
448 /**
449  * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
450  * behind a proxy. Since a proxied contract can't have a constructor, it's common to move constructor logic to an
451  * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
452  * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
453  *
454  * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
455  * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
456  *
457  * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
458  * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
459  *
460  * [CAUTION]
461  * ====
462  * Avoid leaving a contract uninitialized.
463  *
464  * An uninitialized contract can be taken over by an attacker. This applies to both a proxy and its implementation
465  * contract, which may impact the proxy. To initialize the implementation contract, you can either invoke the
466  * initializer manually, or you can include a constructor to automatically mark it as initialized when it is deployed:
467  *
468  * [.hljs-theme-light.nopadding]
469  * ```
470  * /// @custom:oz-upgrades-unsafe-allow constructor
471  * constructor() initializer {}
472  * ```
473  * ====
474  */
475 abstract contract Initializable {
476     /**
477      * @dev Indicates that the contract has been initialized.
478      */
479     bool private _initialized;
480 
481     /**
482      * @dev Indicates that the contract is in the process of being initialized.
483      */
484     bool private _initializing;
485 
486     /**
487      * @dev Modifier to protect an initializer function from being invoked twice.
488      */
489     modifier initializer() {
490         require(_initializing || !_initialized, "Initializable: contract is already initialized");
491 
492         bool isTopLevelCall = !_initializing;
493         if (isTopLevelCall) {
494             _initializing = true;
495             _initialized = true;
496         }
497 
498         _;
499 
500         if (isTopLevelCall) {
501             _initializing = false;
502         }
503     }
504 }
505 
506 // File: @openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol
507 
508 
509 // OpenZeppelin Contracts v4.4.0 (security/ReentrancyGuard.sol)
510 
511 pragma solidity ^0.8.0;
512 
513 
514 /**
515  * @dev Contract module that helps prevent reentrant calls to a function.
516  *
517  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
518  * available, which can be applied to functions to make sure there are no nested
519  * (reentrant) calls to them.
520  *
521  * Note that because there is a single `nonReentrant` guard, functions marked as
522  * `nonReentrant` may not call one another. This can be worked around by making
523  * those functions `private`, and then adding `external` `nonReentrant` entry
524  * points to them.
525  *
526  * TIP: If you would like to learn more about reentrancy and alternative ways
527  * to protect against it, check out our blog post
528  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
529  */
530 abstract contract ReentrancyGuardUpgradeable is Initializable {
531     // Booleans are more expensive than uint256 or any type that takes up a full
532     // word because each write operation emits an extra SLOAD to first read the
533     // slot's contents, replace the bits taken up by the boolean, and then write
534     // back. This is the compiler's defense against contract upgrades and
535     // pointer aliasing, and it cannot be disabled.
536 
537     // The values being non-zero value makes deployment a bit more expensive,
538     // but in exchange the refund on every call to nonReentrant will be lower in
539     // amount. Since refunds are capped to a percentage of the total
540     // transaction's gas, it is best to keep them low in cases like this one, to
541     // increase the likelihood of the full refund coming into effect.
542     uint256 private constant _NOT_ENTERED = 1;
543     uint256 private constant _ENTERED = 2;
544 
545     uint256 private _status;
546 
547     function __ReentrancyGuard_init() internal initializer {
548         __ReentrancyGuard_init_unchained();
549     }
550 
551     function __ReentrancyGuard_init_unchained() internal initializer {
552         _status = _NOT_ENTERED;
553     }
554 
555     /**
556      * @dev Prevents a contract from calling itself, directly or indirectly.
557      * Calling a `nonReentrant` function from another `nonReentrant`
558      * function is not supported. It is possible to prevent this from happening
559      * by making the `nonReentrant` function external, and making it call a
560      * `private` function that does the actual work.
561      */
562     modifier nonReentrant() {
563         // On the first call to nonReentrant, _notEntered will be true
564         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
565 
566         // Any calls to nonReentrant after this point will fail
567         _status = _ENTERED;
568 
569         _;
570 
571         // By storing the original value once again, a refund is triggered (see
572         // https://eips.ethereum.org/EIPS/eip-2200)
573         _status = _NOT_ENTERED;
574     }
575     uint256[49] private __gap;
576 }
577 
578 // File: @openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol
579 
580 
581 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
582 
583 pragma solidity ^0.8.0;
584 
585 
586 /**
587  * @dev Provides information about the current execution context, including the
588  * sender of the transaction and its data. While these are generally available
589  * via msg.sender and msg.data, they should not be accessed in such a direct
590  * manner, since when dealing with meta-transactions the account sending and
591  * paying for execution may not be the actual sender (as far as an application
592  * is concerned).
593  *
594  * This contract is only required for intermediate, library-like contracts.
595  */
596 abstract contract ContextUpgradeable is Initializable {
597     function __Context_init() internal initializer {
598         __Context_init_unchained();
599     }
600 
601     function __Context_init_unchained() internal initializer {
602     }
603     function _msgSender() internal view virtual returns (address) {
604         return msg.sender;
605     }
606 
607     function _msgData() internal view virtual returns (bytes calldata) {
608         return msg.data;
609     }
610     uint256[50] private __gap;
611 }
612 
613 // File: @openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol
614 
615 
616 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
617 
618 pragma solidity ^0.8.0;
619 
620 
621 
622 /**
623  * @dev Contract module which provides a basic access control mechanism, where
624  * there is an account (an owner) that can be granted exclusive access to
625  * specific functions.
626  *
627  * By default, the owner account will be the one that deploys the contract. This
628  * can later be changed with {transferOwnership}.
629  *
630  * This module is used through inheritance. It will make available the modifier
631  * `onlyOwner`, which can be applied to your functions to restrict their use to
632  * the owner.
633  */
634 abstract contract OwnableUpgradeable is Initializable, ContextUpgradeable {
635     address private _owner;
636 
637     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
638 
639     /**
640      * @dev Initializes the contract setting the deployer as the initial owner.
641      */
642     function __Ownable_init() internal initializer {
643         __Context_init_unchained();
644         __Ownable_init_unchained();
645     }
646 
647     function __Ownable_init_unchained() internal initializer {
648         _transferOwnership(_msgSender());
649     }
650 
651     /**
652      * @dev Returns the address of the current owner.
653      */
654     function owner() public view virtual returns (address) {
655         return _owner;
656     }
657 
658     /**
659      * @dev Throws if called by any account other than the owner.
660      */
661     modifier onlyOwner() {
662         require(owner() == _msgSender(), "Ownable: caller is not the owner");
663         _;
664     }
665 
666     /**
667      * @dev Leaves the contract without owner. It will not be possible to call
668      * `onlyOwner` functions anymore. Can only be called by the current owner.
669      *
670      * NOTE: Renouncing ownership will leave the contract without an owner,
671      * thereby removing any functionality that is only available to the owner.
672      */
673     function renounceOwnership() public virtual onlyOwner {
674         _transferOwnership(address(0));
675     }
676 
677     /**
678      * @dev Transfers ownership of the contract to a new account (`newOwner`).
679      * Can only be called by the current owner.
680      */
681     function transferOwnership(address newOwner) public virtual onlyOwner {
682         require(newOwner != address(0), "Ownable: new owner is the zero address");
683         _transferOwnership(newOwner);
684     }
685 
686     /**
687      * @dev Transfers ownership of the contract to a new account (`newOwner`).
688      * Internal function without access restriction.
689      */
690     function _transferOwnership(address newOwner) internal virtual {
691         address oldOwner = _owner;
692         _owner = newOwner;
693         emit OwnershipTransferred(oldOwner, newOwner);
694     }
695     uint256[49] private __gap;
696 }
697 
698 // File: contracts/lib/StringsW0x.sol
699 
700 
701 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
702 
703 pragma solidity ^0.8.0;
704 
705 /**
706  * @dev String operations.
707  */
708 library StringsW0x {
709     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
710 
711     
712     /**
713      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
714      */
715     function toHexString(uint256 value) internal pure returns (string memory) {
716         if (value == 0) {
717             return "0x00";
718         }
719         uint256 temp = value;
720         int256 length = 0;
721         while (temp != 0) {
722             length++;
723             temp >>= 8;
724         }
725         return toHexString(value, length);
726     }
727 
728     /**
729      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
730      */
731     function toHexString(uint256 value, int256 length) internal pure returns (string memory) {
732         bytes memory buffer = new bytes(2 * uint256(length));
733         for (int256 i = 2 * length - 1; i > -1; --i) {
734             buffer[uint256(i)] = _HEX_SYMBOLS[value & 0xf];
735             value >>= 4;
736         }
737         require(value == 0, "Strings: hex length insufficient");
738         return string(buffer);
739     }
740 }
741 
742 // File: @openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol
743 
744 
745 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
746 
747 pragma solidity ^0.8.0;
748 
749 /**
750  * @dev Collection of functions related to the address type
751  */
752 library AddressUpgradeable {
753     /**
754      * @dev Returns true if `account` is a contract.
755      *
756      * [IMPORTANT]
757      * ====
758      * It is unsafe to assume that an address for which this function returns
759      * false is an externally-owned account (EOA) and not a contract.
760      *
761      * Among others, `isContract` will return false for the following
762      * types of addresses:
763      *
764      *  - an externally-owned account
765      *  - a contract in construction
766      *  - an address where a contract will be created
767      *  - an address where a contract lived, but was destroyed
768      * ====
769      */
770     function isContract(address account) internal view returns (bool) {
771         // This method relies on extcodesize, which returns 0 for contracts in
772         // construction, since the code is only stored at the end of the
773         // constructor execution.
774 
775         uint256 size;
776         assembly {
777             size := extcodesize(account)
778         }
779         return size > 0;
780     }
781 
782     /**
783      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
784      * `recipient`, forwarding all available gas and reverting on errors.
785      *
786      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
787      * of certain opcodes, possibly making contracts go over the 2300 gas limit
788      * imposed by `transfer`, making them unable to receive funds via
789      * `transfer`. {sendValue} removes this limitation.
790      *
791      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
792      *
793      * IMPORTANT: because control is transferred to `recipient`, care must be
794      * taken to not create reentrancy vulnerabilities. Consider using
795      * {ReentrancyGuard} or the
796      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
797      */
798     function sendValue(address payable recipient, uint256 amount) internal {
799         require(address(this).balance >= amount, "Address: insufficient balance");
800 
801         (bool success, ) = recipient.call{value: amount}("");
802         require(success, "Address: unable to send value, recipient may have reverted");
803     }
804 
805     /**
806      * @dev Performs a Solidity function call using a low level `call`. A
807      * plain `call` is an unsafe replacement for a function call: use this
808      * function instead.
809      *
810      * If `target` reverts with a revert reason, it is bubbled up by this
811      * function (like regular Solidity function calls).
812      *
813      * Returns the raw returned data. To convert to the expected return value,
814      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
815      *
816      * Requirements:
817      *
818      * - `target` must be a contract.
819      * - calling `target` with `data` must not revert.
820      *
821      * _Available since v3.1._
822      */
823     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
824         return functionCall(target, data, "Address: low-level call failed");
825     }
826 
827     /**
828      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
829      * `errorMessage` as a fallback revert reason when `target` reverts.
830      *
831      * _Available since v3.1._
832      */
833     function functionCall(
834         address target,
835         bytes memory data,
836         string memory errorMessage
837     ) internal returns (bytes memory) {
838         return functionCallWithValue(target, data, 0, errorMessage);
839     }
840 
841     /**
842      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
843      * but also transferring `value` wei to `target`.
844      *
845      * Requirements:
846      *
847      * - the calling contract must have an ETH balance of at least `value`.
848      * - the called Solidity function must be `payable`.
849      *
850      * _Available since v3.1._
851      */
852     function functionCallWithValue(
853         address target,
854         bytes memory data,
855         uint256 value
856     ) internal returns (bytes memory) {
857         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
858     }
859 
860     /**
861      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
862      * with `errorMessage` as a fallback revert reason when `target` reverts.
863      *
864      * _Available since v3.1._
865      */
866     function functionCallWithValue(
867         address target,
868         bytes memory data,
869         uint256 value,
870         string memory errorMessage
871     ) internal returns (bytes memory) {
872         require(address(this).balance >= value, "Address: insufficient balance for call");
873         require(isContract(target), "Address: call to non-contract");
874 
875         (bool success, bytes memory returndata) = target.call{value: value}(data);
876         return verifyCallResult(success, returndata, errorMessage);
877     }
878 
879     /**
880      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
881      * but performing a static call.
882      *
883      * _Available since v3.3._
884      */
885     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
886         return functionStaticCall(target, data, "Address: low-level static call failed");
887     }
888 
889     /**
890      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
891      * but performing a static call.
892      *
893      * _Available since v3.3._
894      */
895     function functionStaticCall(
896         address target,
897         bytes memory data,
898         string memory errorMessage
899     ) internal view returns (bytes memory) {
900         require(isContract(target), "Address: static call to non-contract");
901 
902         (bool success, bytes memory returndata) = target.staticcall(data);
903         return verifyCallResult(success, returndata, errorMessage);
904     }
905 
906     /**
907      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
908      * revert reason using the provided one.
909      *
910      * _Available since v4.3._
911      */
912     function verifyCallResult(
913         bool success,
914         bytes memory returndata,
915         string memory errorMessage
916     ) internal pure returns (bytes memory) {
917         if (success) {
918             return returndata;
919         } else {
920             // Look for revert reason and bubble it up if present
921             if (returndata.length > 0) {
922                 // The easiest way to bubble the revert reason is using memory via assembly
923 
924                 assembly {
925                     let returndata_size := mload(returndata)
926                     revert(add(32, returndata), returndata_size)
927                 }
928             } else {
929                 revert(errorMessage);
930             }
931         }
932     }
933 }
934 
935 // File: @openzeppelin/contracts-upgradeable/utils/introspection/IERC165Upgradeable.sol
936 
937 
938 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
939 
940 pragma solidity ^0.8.0;
941 
942 /**
943  * @dev Interface of the ERC165 standard, as defined in the
944  * https://eips.ethereum.org/EIPS/eip-165[EIP].
945  *
946  * Implementers can declare support of contract interfaces, which can then be
947  * queried by others ({ERC165Checker}).
948  *
949  * For an implementation, see {ERC165}.
950  */
951 interface IERC165Upgradeable {
952     /**
953      * @dev Returns true if this contract implements the interface defined by
954      * `interfaceId`. See the corresponding
955      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
956      * to learn more about how these ids are created.
957      *
958      * This function call must use less than 30 000 gas.
959      */
960     function supportsInterface(bytes4 interfaceId) external view returns (bool);
961 }
962 
963 // File: contracts/interfaces/ISafeHook.sol
964 
965 
966 pragma solidity ^0.8.0;
967 
968 
969 interface ISafeHook is IERC165Upgradeable {
970     function executeHook(address from, address to, uint256 tokenId) external returns(bool success);
971 }
972 // File: contracts/interfaces/ICostManager.sol
973 
974 
975 pragma solidity ^0.8.0;
976 
977 
978 interface ICostManager is IERC165Upgradeable {
979     function accountForOperation(address sender, uint256 info, uint256 param1, uint256 param2) external returns(uint256 spent, uint256 remaining);
980 }
981 
982 // File: @openzeppelin/contracts-upgradeable/utils/introspection/ERC165Upgradeable.sol
983 
984 
985 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
986 
987 pragma solidity ^0.8.0;
988 
989 
990 
991 /**
992  * @dev Implementation of the {IERC165} interface.
993  *
994  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
995  * for the additional interface id that will be supported. For example:
996  *
997  * ```solidity
998  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
999  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1000  * }
1001  * ```
1002  *
1003  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1004  */
1005 abstract contract ERC165Upgradeable is Initializable, IERC165Upgradeable {
1006     function __ERC165_init() internal initializer {
1007         __ERC165_init_unchained();
1008     }
1009 
1010     function __ERC165_init_unchained() internal initializer {
1011     }
1012     /**
1013      * @dev See {IERC165-supportsInterface}.
1014      */
1015     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1016         return interfaceId == type(IERC165Upgradeable).interfaceId;
1017     }
1018     uint256[50] private __gap;
1019 }
1020 
1021 // File: @openzeppelin/contracts-upgradeable/token/ERC721/IERC721Upgradeable.sol
1022 
1023 
1024 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)
1025 
1026 pragma solidity ^0.8.0;
1027 
1028 
1029 /**
1030  * @dev Required interface of an ERC721 compliant contract.
1031  */
1032 interface IERC721Upgradeable is IERC165Upgradeable {
1033     /**
1034      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1035      */
1036     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1037 
1038     /**
1039      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1040      */
1041     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1042 
1043     /**
1044      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1045      */
1046     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1047 
1048     /**
1049      * @dev Returns the number of tokens in ``owner``'s account.
1050      */
1051     function balanceOf(address owner) external view returns (uint256 balance);
1052 
1053     /**
1054      * @dev Returns the owner of the `tokenId` token.
1055      *
1056      * Requirements:
1057      *
1058      * - `tokenId` must exist.
1059      */
1060     function ownerOf(uint256 tokenId) external view returns (address owner);
1061 
1062     /**
1063      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1064      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1065      *
1066      * Requirements:
1067      *
1068      * - `from` cannot be the zero address.
1069      * - `to` cannot be the zero address.
1070      * - `tokenId` token must exist and be owned by `from`.
1071      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1072      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1073      *
1074      * Emits a {Transfer} event.
1075      */
1076     function safeTransferFrom(
1077         address from,
1078         address to,
1079         uint256 tokenId
1080     ) external;
1081 
1082     /**
1083      * @dev Transfers `tokenId` token from `from` to `to`.
1084      *
1085      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1086      *
1087      * Requirements:
1088      *
1089      * - `from` cannot be the zero address.
1090      * - `to` cannot be the zero address.
1091      * - `tokenId` token must be owned by `from`.
1092      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1093      *
1094      * Emits a {Transfer} event.
1095      */
1096     function transferFrom(
1097         address from,
1098         address to,
1099         uint256 tokenId
1100     ) external;
1101 
1102     /**
1103      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1104      * The approval is cleared when the token is transferred.
1105      *
1106      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1107      *
1108      * Requirements:
1109      *
1110      * - The caller must own the token or be an approved operator.
1111      * - `tokenId` must exist.
1112      *
1113      * Emits an {Approval} event.
1114      */
1115     function approve(address to, uint256 tokenId) external;
1116 
1117     /**
1118      * @dev Returns the account approved for `tokenId` token.
1119      *
1120      * Requirements:
1121      *
1122      * - `tokenId` must exist.
1123      */
1124     function getApproved(uint256 tokenId) external view returns (address operator);
1125 
1126     /**
1127      * @dev Approve or remove `operator` as an operator for the caller.
1128      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1129      *
1130      * Requirements:
1131      *
1132      * - The `operator` cannot be the caller.
1133      *
1134      * Emits an {ApprovalForAll} event.
1135      */
1136     function setApprovalForAll(address operator, bool _approved) external;
1137 
1138     /**
1139      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1140      *
1141      * See {setApprovalForAll}
1142      */
1143     function isApprovedForAll(address owner, address operator) external view returns (bool);
1144 
1145     /**
1146      * @dev Safely transfers `tokenId` token from `from` to `to`.
1147      *
1148      * Requirements:
1149      *
1150      * - `from` cannot be the zero address.
1151      * - `to` cannot be the zero address.
1152      * - `tokenId` token must exist and be owned by `from`.
1153      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1154      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1155      *
1156      * Emits a {Transfer} event.
1157      */
1158     function safeTransferFrom(
1159         address from,
1160         address to,
1161         uint256 tokenId,
1162         bytes calldata data
1163     ) external;
1164 }
1165 
1166 // File: @openzeppelin/contracts-upgradeable/token/ERC721/extensions/IERC721EnumerableUpgradeable.sol
1167 
1168 
1169 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Enumerable.sol)
1170 
1171 pragma solidity ^0.8.0;
1172 
1173 
1174 /**
1175  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1176  * @dev See https://eips.ethereum.org/EIPS/eip-721
1177  */
1178 interface IERC721EnumerableUpgradeable is IERC721Upgradeable {
1179     /**
1180      * @dev Returns the total amount of tokens stored by the contract.
1181      */
1182     function totalSupply() external view returns (uint256);
1183 
1184     /**
1185      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1186      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1187      */
1188     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1189 
1190     /**
1191      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1192      * Use along with {totalSupply} to enumerate all tokens.
1193      */
1194     function tokenByIndex(uint256 index) external view returns (uint256);
1195 }
1196 
1197 // File: @openzeppelin/contracts-upgradeable/token/ERC721/extensions/IERC721MetadataUpgradeable.sol
1198 
1199 
1200 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Metadata.sol)
1201 
1202 pragma solidity ^0.8.0;
1203 
1204 
1205 /**
1206  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1207  * @dev See https://eips.ethereum.org/EIPS/eip-721
1208  */
1209 interface IERC721MetadataUpgradeable is IERC721Upgradeable {
1210     /**
1211      * @dev Returns the token collection name.
1212      */
1213     function name() external view returns (string memory);
1214 
1215     /**
1216      * @dev Returns the token collection symbol.
1217      */
1218     function symbol() external view returns (string memory);
1219 
1220     /**
1221      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1222      */
1223     function tokenURI(uint256 tokenId) external view returns (string memory);
1224 }
1225 
1226 // File: @openzeppelin/contracts-upgradeable/token/ERC721/IERC721ReceiverUpgradeable.sol
1227 
1228 
1229 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721Receiver.sol)
1230 
1231 pragma solidity ^0.8.0;
1232 
1233 /**
1234  * @title ERC721 token receiver interface
1235  * @dev Interface for any contract that wants to support safeTransfers
1236  * from ERC721 asset contracts.
1237  */
1238 interface IERC721ReceiverUpgradeable {
1239     /**
1240      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1241      * by `operator` from `from`, this function is called.
1242      *
1243      * It must return its Solidity selector to confirm the token transfer.
1244      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1245      *
1246      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1247      */
1248     function onERC721Received(
1249         address operator,
1250         address from,
1251         uint256 tokenId,
1252         bytes calldata data
1253     ) external returns (bytes4);
1254 }
1255 
1256 // File: @openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol
1257 
1258 
1259 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
1260 
1261 pragma solidity ^0.8.0;
1262 
1263 /**
1264  * @dev Interface of the ERC20 standard as defined in the EIP.
1265  */
1266 interface IERC20Upgradeable {
1267     /**
1268      * @dev Returns the amount of tokens in existence.
1269      */
1270     function totalSupply() external view returns (uint256);
1271 
1272     /**
1273      * @dev Returns the amount of tokens owned by `account`.
1274      */
1275     function balanceOf(address account) external view returns (uint256);
1276 
1277     /**
1278      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1279      *
1280      * Returns a boolean value indicating whether the operation succeeded.
1281      *
1282      * Emits a {Transfer} event.
1283      */
1284     function transfer(address recipient, uint256 amount) external returns (bool);
1285 
1286     /**
1287      * @dev Returns the remaining number of tokens that `spender` will be
1288      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1289      * zero by default.
1290      *
1291      * This value changes when {approve} or {transferFrom} are called.
1292      */
1293     function allowance(address owner, address spender) external view returns (uint256);
1294 
1295     /**
1296      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1297      *
1298      * Returns a boolean value indicating whether the operation succeeded.
1299      *
1300      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1301      * that someone may use both the old and the new allowance by unfortunate
1302      * transaction ordering. One possible solution to mitigate this race
1303      * condition is to first reduce the spender's allowance to 0 and set the
1304      * desired value afterwards:
1305      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1306      *
1307      * Emits an {Approval} event.
1308      */
1309     function approve(address spender, uint256 amount) external returns (bool);
1310 
1311     /**
1312      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1313      * allowance mechanism. `amount` is then deducted from the caller's
1314      * allowance.
1315      *
1316      * Returns a boolean value indicating whether the operation succeeded.
1317      *
1318      * Emits a {Transfer} event.
1319      */
1320     function transferFrom(
1321         address sender,
1322         address recipient,
1323         uint256 amount
1324     ) external returns (bool);
1325 
1326     /**
1327      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1328      * another (`to`).
1329      *
1330      * Note that `value` may be zero.
1331      */
1332     event Transfer(address indexed from, address indexed to, uint256 value);
1333 
1334     /**
1335      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1336      * a call to {approve}. `value` is the new allowance.
1337      */
1338     event Approval(address indexed owner, address indexed spender, uint256 value);
1339 }
1340 
1341 // File: contracts/ERC721UpgradeableExt.sol
1342 
1343 
1344 
1345 pragma solidity ^0.8.0;
1346 
1347 
1348 
1349 
1350 
1351 
1352 
1353 
1354 
1355 
1356 
1357 
1358 abstract contract ERC721UpgradeableExt is 
1359     ERC165Upgradeable, 
1360     IERC721MetadataUpgradeable,
1361     IERC721EnumerableUpgradeable, 
1362     OwnableUpgradeable, 
1363     ReentrancyGuardUpgradeable
1364 {
1365 
1366     using AddressUpgradeable for address;
1367     using StringsW0x for uint256;
1368     
1369     // Token name
1370     string private _name;
1371 
1372     // Token symbol
1373     string private _symbol;
1374 
1375     // Contract URI
1376     string internal _contractURI;    
1377     
1378     // Address of factory that produced this instance
1379     address public factory;
1380     
1381     // Utility token, if any, to manage during operations
1382     address public costManager;
1383 
1384     address public trustedForwarder;
1385 
1386     // Mapping from token ID to owner address
1387     mapping(uint256 => address) private _owners;
1388 
1389     // Mapping owner address to token count
1390     mapping(address => uint256) private _balances;
1391 
1392     // Mapping from token ID to approved address
1393     mapping(uint256 => address) private _tokenApprovals;
1394 
1395     // Mapping from owner to operator approvals
1396     mapping(address => mapping(address => bool)) private _operatorApprovals;
1397 
1398     // Mapping from owner to list of owned token IDs
1399     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1400 
1401     // Mapping from token ID to index of the owner tokens list
1402     mapping(uint256 => uint256) private _ownedTokensIndex;
1403 
1404     // Array with all token ids, used for enumeration
1405     uint256[] private _allTokens;
1406 
1407     // Mapping from token id to position in the allTokens array
1408     mapping(uint256 => uint256) private _allTokensIndex;
1409     
1410     // Constants for shifts
1411     uint8 internal constant SERIES_SHIFT_BITS = 192; // 256 - 64
1412     uint8 internal constant OPERATION_SHIFT_BITS = 240;  // 256 - 16
1413     
1414     // Constants representing operations
1415     uint8 internal constant OPERATION_INITIALIZE = 0x0;
1416     uint8 internal constant OPERATION_SETMETADATA = 0x1;
1417     uint8 internal constant OPERATION_SETSERIESINFO = 0x2;
1418     uint8 internal constant OPERATION_SETOWNERCOMMISSION = 0x3;
1419     uint8 internal constant OPERATION_SETCOMMISSION = 0x4;
1420     uint8 internal constant OPERATION_REMOVECOMMISSION = 0x5;
1421     uint8 internal constant OPERATION_LISTFORSALE = 0x6;
1422     uint8 internal constant OPERATION_REMOVEFROMSALE = 0x7;
1423     uint8 internal constant OPERATION_MINTANDDISTRIBUTE = 0x8;
1424     uint8 internal constant OPERATION_BURN = 0x9;
1425     uint8 internal constant OPERATION_BUY = 0xA;
1426     uint8 internal constant OPERATION_TRANSFER = 0xB;
1427 
1428     address internal constant DEAD_ADDRESS = 0x000000000000000000000000000000000000dEaD;
1429 
1430     uint256 internal constant FRACTION = 100000;
1431     
1432     string public baseURI;
1433     string public suffix;
1434     
1435     mapping (uint256 => SaleInfoToken) public salesInfoToken;  // tokenId => SaleInfoToken
1436     mapping (uint256 => SeriesInfo) public seriesInfo;  // seriesId => SeriesInfo
1437     CommissionInfo public commissionInfo; // Global commission data 
1438 
1439     mapping(uint256 => uint256) public mintedCountBySeries;
1440     
1441     struct SaleInfoToken { 
1442         SaleInfo saleInfo;
1443         uint256 ownerCommissionValue;
1444         uint256 authorCommissionValue;
1445     }
1446     struct SaleInfo { 
1447         uint64 onSaleUntil; 
1448         address currency;
1449         uint256 price;
1450     }
1451 
1452     struct SeriesInfo { 
1453         address payable author;
1454         uint32 limit;
1455         SaleInfo saleInfo;
1456         CommissionData commission;
1457         string baseURI;
1458         string suffix;
1459     }
1460     
1461     struct CommissionInfo {
1462         uint64 maxValue;
1463         uint64 minValue;
1464         CommissionData ownerCommission;
1465     }
1466 
1467     struct CommissionData {
1468         uint64 value;
1469         address recipient;
1470     }
1471 
1472     event SeriesPutOnSale(
1473         uint64 indexed seriesId, 
1474         uint256 price, 
1475         address currency, 
1476         uint64 onSaleUntil
1477     );
1478 
1479     event SeriesRemovedFromSale(
1480         uint64 indexed seriesId
1481     );
1482 
1483     event TokenRemovedFromSale(
1484         uint256 indexed tokenId,
1485         address account
1486     );
1487 
1488     event TokenPutOnSale(
1489         uint256 indexed tokenId, 
1490         address indexed seller, 
1491         uint256 price, 
1492         address currency, 
1493         uint64 onSaleUntil
1494     );
1495     
1496     event TokenBought(
1497         uint256 indexed tokenId, 
1498         address indexed seller, 
1499         address indexed buyer, 
1500         address currency, 
1501         uint256 price
1502     );
1503     
1504     /********************************************************************
1505     ****** external section *********************************************
1506     *********************************************************************/
1507     
1508     /**
1509     * @dev sets the default baseURI for the whole contract
1510     * @param baseURI_ the prefix to prepend to URIs
1511     */
1512     function setBaseURI(
1513         string calldata baseURI_
1514     ) 
1515         onlyOwner
1516         external
1517     {
1518         baseURI = baseURI_;
1519         _accountForOperation(
1520             OPERATION_SETMETADATA << OPERATION_SHIFT_BITS,
1521             0x100,
1522             0
1523         );
1524     }
1525     
1526     /**
1527     * @dev sets the default URI suffix for the whole contract
1528     * @param suffix_ the suffix to append to URIs
1529     */
1530     function setSuffix(
1531         string calldata suffix_
1532     ) 
1533         onlyOwner
1534         external
1535     {
1536         suffix = suffix_;
1537         _accountForOperation(
1538             OPERATION_SETMETADATA << OPERATION_SHIFT_BITS,
1539             0x010,
1540             0
1541         );
1542     }
1543 
1544      /**
1545     * @dev sets contract URI. 
1546     * @param newContractURI new contract URI
1547     */
1548     function setContractURI(string memory newContractURI) external onlyOwner {
1549         _contractURI = newContractURI;
1550         _accountForOperation(
1551             OPERATION_SETMETADATA << OPERATION_SHIFT_BITS,
1552             0x001,
1553             0
1554         );
1555     }
1556 
1557     /**
1558     * @dev sets information for series with 'seriesId'. 
1559     * @param seriesId series ID
1560     * @param info new info to set
1561     */
1562     function setSeriesInfo(
1563         uint64 seriesId, 
1564         SeriesInfo memory info 
1565     ) 
1566         external
1567     {
1568         _requireCanManageSeries(seriesId);
1569         if (info.saleInfo.onSaleUntil > seriesInfo[seriesId].saleInfo.onSaleUntil && 
1570             info.saleInfo.onSaleUntil > block.timestamp
1571         ) {
1572             emit SeriesPutOnSale(
1573                 seriesId, 
1574                 info.saleInfo.price, 
1575                 info.saleInfo.currency, 
1576                 info.saleInfo.onSaleUntil
1577             );
1578         } else if (info.saleInfo.onSaleUntil <= block.timestamp ) {
1579             emit SeriesRemovedFromSale(seriesId);
1580         }
1581         
1582         seriesInfo[seriesId] = info;
1583 
1584         _accountForOperation(
1585             (OPERATION_SETSERIESINFO << OPERATION_SHIFT_BITS) | seriesId,
1586             uint256(uint160(info.saleInfo.currency)),
1587             info.saleInfo.price
1588         );
1589         
1590     }
1591 /**
1592     * set commission paid to contract owner
1593     * @param commission new commission info
1594     */
1595     function setOwnerCommission(
1596         CommissionInfo memory commission
1597     ) 
1598         external 
1599         onlyOwner 
1600     {
1601         commissionInfo = commission;
1602 
1603         _accountForOperation(
1604             OPERATION_SETOWNERCOMMISSION << OPERATION_SHIFT_BITS,
1605             uint256(uint160(commission.ownerCommission.recipient)),
1606             commission.ownerCommission.value
1607         );
1608 
1609     }
1610 
1611     /**
1612     * set commission for series
1613     * @param commissionData new commission data
1614     */
1615     function setCommission(
1616         uint64 seriesId, 
1617         CommissionData memory commissionData
1618     ) 
1619         external 
1620     {
1621         _requireCanManageSeries(seriesId);
1622         require(
1623             (
1624                 commissionData.value <= commissionInfo.maxValue &&
1625                 commissionData.value >= commissionInfo.minValue &&
1626                 commissionData.value + commissionInfo.ownerCommission.value < FRACTION
1627             ),
1628             "COMMISSION_INVALID"
1629         );
1630         require(commissionData.recipient != address(0), "RECIPIENT_INVALID");
1631         seriesInfo[seriesId].commission = commissionData;
1632         
1633         _accountForOperation(
1634             (OPERATION_SETCOMMISSION << OPERATION_SHIFT_BITS) | seriesId,
1635             commissionData.value,
1636             uint256(uint160(commissionData.recipient))
1637         );
1638         
1639     }
1640 
1641     /**
1642     * clear commission for series
1643     * @param seriesId seriesId
1644     */
1645     function removeCommission(
1646         uint64 seriesId
1647     ) 
1648         external 
1649     {
1650         _requireCanManageSeries(seriesId);
1651         delete seriesInfo[seriesId].commission;
1652         
1653         _accountForOperation(
1654             (OPERATION_REMOVECOMMISSION << OPERATION_SHIFT_BITS) | seriesId,
1655             0,
1656             0
1657         );
1658         
1659     }
1660 
1661     /**
1662     * @dev lists on sale NFT with defined token ID with specified terms of sale
1663     * @param tokenId token ID
1664     * @param price price for sale 
1665     * @param currency currency of sale 
1666     * @param duration duration of sale 
1667     */
1668     function listForSale(
1669         uint256 tokenId,
1670         uint256 price,
1671         address currency,
1672         uint64 duration
1673     )
1674         external 
1675     {
1676         (bool success, /*bool isExists*/, /*SaleInfo memory data*/, /*address owner*/) = getTokenSaleInfo(tokenId);
1677         
1678         _requireCanManageToken(tokenId);
1679         require(!success, "already on sale");
1680         require(duration > 0, "invalid duration");
1681 
1682         uint64 seriesId = getSeriesId(tokenId);
1683         SaleInfo memory newSaleInfo = SaleInfo({
1684             onSaleUntil: uint64(block.timestamp) + duration,
1685             currency: currency,
1686             price: price
1687         });
1688         SaleInfoToken memory saleInfoToken = SaleInfoToken({
1689             saleInfo: newSaleInfo,
1690             ownerCommissionValue: commissionInfo.ownerCommission.value,
1691             authorCommissionValue: seriesInfo[seriesId].commission.value
1692         });
1693         _setSaleInfo(tokenId, saleInfoToken);
1694 
1695         emit TokenPutOnSale(
1696             tokenId, 
1697             _msgSender(), 
1698             newSaleInfo.price, 
1699             newSaleInfo.currency, 
1700             newSaleInfo.onSaleUntil
1701         );
1702         
1703         _accountForOperation(
1704             (OPERATION_LISTFORSALE << OPERATION_SHIFT_BITS) | seriesId,
1705             uint256(uint160(currency)),
1706             price
1707         );
1708     }
1709     
1710     /**
1711     * @dev removes from sale NFT with defined token ID
1712     * @param tokenId token ID
1713     */
1714     function removeFromSale(
1715         uint256 tokenId
1716     )
1717         external 
1718     {
1719         (bool success, /*bool isExists*/, SaleInfo memory data, /*address owner*/) = getTokenSaleInfo(tokenId);
1720         require(success, "token not on sale");
1721         _requireCanManageToken(tokenId);
1722         clearOnSaleUntil(tokenId);
1723 
1724         emit TokenRemovedFromSale(tokenId, _msgSender());
1725         
1726         uint64 seriesId = getSeriesId(tokenId);
1727         _accountForOperation(
1728             (OPERATION_REMOVEFROMSALE << OPERATION_SHIFT_BITS) | seriesId,
1729             uint256(uint160(data.currency)),
1730             data.price
1731         );
1732     }
1733 
1734     /**
1735     * @dev returns the list of all NFTs owned by 'account' with limit
1736     * @param account address of account
1737     */
1738     function tokensByOwner(
1739         address account,
1740         uint32 limit
1741     ) 
1742         external
1743         view
1744         returns (uint256[] memory ret)
1745     {
1746         return _tokensByOwner(account, limit);
1747     }
1748 
1749     /**
1750     * @dev mints and distributes NFTs with specified IDs
1751     * to specified addresses
1752     * @param tokenIds list of NFT IDs t obe minted
1753     * @param addresses list of receiver addresses
1754     */
1755     function mintAndDistribute(
1756         uint256[] memory tokenIds, 
1757         address[] memory addresses
1758     )
1759         external 
1760     {
1761         uint256 len = addresses.length;
1762         require(tokenIds.length == len, "lengths should be the same");
1763         for(uint256 i = 0; i < len; i++) {
1764             _requireCanManageSeries(getSeriesId(tokenIds[i]));
1765             _mint(addresses[i], tokenIds[i]);
1766         }
1767         
1768         _accountForOperation(
1769             OPERATION_MINTANDDISTRIBUTE << OPERATION_SHIFT_BITS,
1770             len,
1771             0
1772         );
1773     }
1774     
1775     /** 
1776     * @dev sets the utility token
1777     * @param costManager_ new address of utility token, or 0
1778     */
1779     function overrideCostManager(address costManager_) external {
1780         // require factory owner or operator
1781         // otherwise needed deployer(!!not contract owner) in cases if was deployed manually
1782         require (
1783             (factory.isContract()) 
1784                 ?
1785                     IFactory(factory).canOverrideCostManager(_msgSender(), address(this))
1786                 :
1787                     factory == _msgSender()
1788             ,
1789             "cannot override"
1790         );
1791         costManager = costManager_;
1792     }
1793 
1794 
1795     /********************************************************************
1796     ****** public section ***********************************************
1797     *********************************************************************/
1798     /**
1799     * @dev tells the caller whether they can set info for a series,
1800     * manage amount of commissions for the series,
1801     * mint and distribute tokens from it, etc.
1802     * @param seriesId the id of the series being asked about
1803     */
1804     function canManageSeries(uint64 seriesId) public view returns (bool) {
1805         return owner() == _msgSender() || seriesInfo[seriesId].author == _msgSender();
1806     }
1807 
1808     /**
1809     * @dev tells the caller whether they can transfer an existing token,
1810     * list it for sale and remove it from sale.
1811     * Tokens can be managed by their owner
1812     * or approved accounts via {approve} or {setApprovalForAll}.
1813     * @param tokenId the id of the tokens being asked about
1814     */
1815     function canManageToken(uint256 tokenId) public view returns (bool) {
1816         return _canManageToken(tokenId);
1817     }
1818 
1819     /**
1820      * @dev Returns whether `tokenId` exists.
1821      * Tokens start existing when they are minted (`_mint`),
1822      * and stop existing when they are burned (`_burn`).
1823      */
1824     function tokenExists(uint256 tokenId) public view virtual returns (bool) {
1825         return _exists(tokenId);
1826     }
1827     
1828     /**
1829     * @dev buys NFT for native coin with defined id. 
1830     * mint token if it doesn't exist and transfer token
1831     * if it exists and is on sale
1832     * @param tokenId token ID to buy
1833     * @param price amount of specified native coin to pay
1834     * @param safe use safeMint and safeTransfer or not
1835     */
1836     function buy(uint256 tokenId, uint256 price, bool safe) public payable nonReentrant {
1837         (bool success, bool exists, SaleInfo memory data, address beneficiary) = getTokenSaleInfo(tokenId);
1838         require(success, "token is not on sale");
1839         require(msg.value >= data.price && price >= data.price, "insufficient amount sent");
1840         require(address(0) == data.currency, "wrong currency for sale");
1841 
1842         bool transferSuccess;
1843         uint256 left = data.price;
1844         (address[2] memory addresses, uint256[2] memory values, uint256 length) = calculateCommission(tokenId, data.price);
1845        
1846         // commissions payment
1847         for(uint256 i = 0; i < length; i++) {
1848             (transferSuccess, ) = addresses[i].call{gas: 3000, value: values[i]}(new bytes(0));
1849             require(transferSuccess, "TRANSFER_COMMISSION_FAILED");
1850             left -= values[i];
1851         }
1852         
1853         (transferSuccess, ) = beneficiary.call{gas: 3000, value: left}(new bytes(0));
1854         require(transferSuccess, "TRANSFER_TO_OWNER_FAILED");
1855 
1856         uint256 refund = msg.value - data.price;
1857 
1858         if (refund > 0) {
1859             (transferSuccess, ) = msg.sender.call{gas: 3000, value: refund}(new bytes(0));
1860             require(transferSuccess, "REFUND_FAILED");
1861         }
1862 
1863         _buy(tokenId, exists, data, beneficiary, safe);
1864         
1865         uint64 seriesId = getSeriesId(tokenId);
1866         _accountForOperation(
1867             (OPERATION_BUY << OPERATION_SHIFT_BITS) | seriesId, 
1868             0,
1869             price
1870         );
1871     }
1872 
1873     /**
1874     * @dev buys NFT for specified currency with defined id. 
1875     * mint token if it doesn't exist and transfer token
1876     * if it exists and is on sale
1877     * @param tokenId token ID to buy
1878     * @param currency address of token to pay with
1879     * @param price amount of specified token to pay
1880     * @param safe use safeMint and safeTransfer or not
1881     */
1882     function buy(uint256 tokenId, address currency, uint256 price, bool safe) public nonReentrant {
1883         (bool success, bool exists, SaleInfo memory data, address owner) = getTokenSaleInfo(tokenId);
1884         require(success, "token is not on sale");
1885         require(currency == data.currency, "wrong currency for sale");
1886         uint256 allowance = IERC20Upgradeable(data.currency).allowance(_msgSender(), address(this));
1887         require(allowance >= data.price && price >= data.price, "insufficient amount");
1888 
1889         uint256 left = data.price;
1890         (address[2] memory addresses, uint256[2] memory values, uint256 length) = calculateCommission(tokenId, data.price);
1891         // commissions payment
1892         for(uint256 i = 0; i < length; i++) {
1893             IERC20Upgradeable(data.currency).transferFrom(_msgSender(), addresses[i], values[i]);
1894             left -= values[i];
1895         }
1896 
1897         IERC20Upgradeable(data.currency).transferFrom(_msgSender(), owner, left);
1898         _buy(tokenId, exists, data, owner, safe);
1899         uint64 seriesId = getSeriesId(tokenId);
1900         _accountForOperation(
1901             (OPERATION_BUY << OPERATION_SHIFT_BITS) | seriesId,
1902             uint256(uint160(currency)),
1903             price
1904         );
1905     }
1906 
1907     /**
1908     * @dev calculate commission for `tokenId`
1909     *  if param exists equal true, then token doesn't exists yet. 
1910     *  otherwise we should use snapshot parameters: ownerCommission/authorCommission, that hold during listForSale.
1911     *  used to prevent increasing commissions
1912     * @param tokenId token ID to calculate commission
1913     * @param price amount of specified token to pay 
1914     */
1915     function calculateCommission(
1916         uint256 tokenId,
1917         uint256 price
1918     ) 
1919         internal 
1920         view 
1921         returns(
1922             address[2] memory addresses, 
1923             uint256[2] memory values,
1924             uint256 length
1925         ) 
1926     {
1927         uint64 seriesId = getSeriesId(tokenId);
1928         length = 0;
1929         uint256 sum;
1930         // contract owner commission
1931         if (commissionInfo.ownerCommission.recipient != address(0)) {
1932             uint256 oc = salesInfoToken[tokenId].ownerCommissionValue;
1933             if (commissionInfo.ownerCommission.value < oc)
1934                 oc = commissionInfo.ownerCommission.value;
1935             if (oc != 0) {
1936                 addresses[length] = commissionInfo.ownerCommission.recipient;
1937                 sum += oc;
1938                 values[length] = oc * price / FRACTION;
1939                 length++;
1940             }
1941         }
1942 
1943         // author commission
1944         if (seriesInfo[seriesId].commission.recipient != address(0)) {
1945             uint256 ac = salesInfoToken[tokenId].authorCommissionValue;
1946             if (seriesInfo[seriesId].commission.value < ac) 
1947                 ac = seriesInfo[seriesId].commission.value;
1948             if (ac != 0) {
1949                 addresses[length] = seriesInfo[seriesId].commission.recipient;
1950                 sum += ac;
1951                 values[length] = ac * price / FRACTION;
1952                 length++;
1953             }
1954         }
1955 
1956         require(sum < FRACTION, "invalid commission");
1957 
1958     }
1959 
1960     /**
1961     * @dev returns contract URI. 
1962     */
1963     function contractURI() public view returns(string memory){
1964         return _contractURI;
1965     }
1966 
1967     /**
1968      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1969      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1970      */
1971     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1972         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1973         return _ownedTokens[owner][index];
1974     }
1975 
1976     /**
1977      * @dev Returns the total amount of tokens stored by the contract.
1978      */
1979     function totalSupply() public view virtual override returns (uint256) {
1980         return _allTokens.length;
1981     }
1982 
1983     /**
1984      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1985      * Use along with {totalSupply} to enumerate all tokens.
1986      */
1987     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1988         require(index < totalSupply(), "ERC721Enumerable: global index out of bounds");
1989         return _allTokens[index];
1990     }
1991 
1992     /**
1993      * @dev See {IERC165-supportsInterface}.
1994      */
1995     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165Upgradeable, IERC165Upgradeable) returns (bool) {
1996         return
1997             interfaceId == type(IERC721Upgradeable).interfaceId ||
1998             interfaceId == type(IERC721MetadataUpgradeable).interfaceId ||
1999             interfaceId == type(IERC721EnumerableUpgradeable).interfaceId ||
2000             super.supportsInterface(interfaceId);
2001     }
2002 
2003     /**
2004      * @dev Returns the number of tokens in ``owner``'s account.
2005      */
2006     function balanceOf(address owner) public view virtual override returns (uint256) {
2007         require(owner != address(0), "ERC721: balance query for the zero address");
2008         return _balances[owner];
2009     }
2010 
2011     /**
2012      * @dev Returns the owner of the `tokenId` token.
2013      *
2014      * Requirements:
2015      *
2016      * - `tokenId` must exist.
2017      */
2018 
2019     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
2020         address owner = _ownerOf(tokenId);
2021         require(owner != address(0), "ERC721: owner query for nonexistent token");
2022         return owner;
2023     }
2024 
2025     /**
2026      * @dev Returns the token collection name.
2027      */
2028     function name() public view virtual override returns (string memory) {
2029         return _name;
2030     }
2031 
2032     /**
2033      * @dev Returns the token collection symbol.
2034      */
2035     function symbol() public view virtual override returns (string memory) {
2036         return _symbol;
2037     }
2038 
2039     /** 
2040     * @dev sets name and symbol for contract
2041     * @param newName new name 
2042     * @param newSymbol new symbol 
2043     */
2044     function setNameAndSymbol(
2045         string memory newName, 
2046         string memory newSymbol
2047     ) 
2048         public 
2049         onlyOwner 
2050     {
2051         _setNameAndSymbol(newName, newSymbol);
2052     }
2053     
2054   
2055     /**
2056      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
2057      */
2058     function tokenURI(
2059         uint256 tokenId
2060     ) 
2061         public 
2062         view 
2063         virtual 
2064         override
2065         returns (string memory) 
2066     {
2067         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
2068         string memory _tokenIdHexString = tokenId.toHexString();
2069         uint64 seriesId = getSeriesId(tokenId);
2070         string memory baseURI_ = seriesInfo[seriesId].baseURI;
2071         string memory suffix_ = seriesInfo[seriesId].suffix;
2072         if (bytes(baseURI_).length == 0) {
2073             baseURI_ = baseURI;
2074         }
2075         if (bytes(suffix_).length == 0) {
2076             suffix_ = suffix;
2077         }
2078         // If all are set, concatenate
2079         if (bytes(_tokenIdHexString).length > 0) {
2080             return string(abi.encodePacked(baseURI_, _tokenIdHexString, suffix_));
2081         }
2082         return "";
2083     }
2084 
2085     /**
2086      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
2087      * The approval is cleared when the token is transferred.
2088      *
2089      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
2090      *
2091      * Requirements:
2092      *
2093      * - The caller must own the token or be an approved operator.
2094      * - `tokenId` must exist.
2095      *
2096      * Emits an {Approval} event.
2097      */
2098     function approve(address to, uint256 tokenId) public virtual override {
2099         address owner = ownerOf(tokenId);
2100         require(to != owner, "ERC721: approval to current owner");
2101         address ms = _msgSender();
2102         require(
2103             ms == owner || isApprovedForAll(owner, ms),
2104             "ERC721: approve caller is not owner nor approved for all"
2105         );
2106 
2107         _approve(to, tokenId);
2108     }
2109 
2110     /**
2111      * @dev Returns the account approved for `tokenId` token.
2112      *
2113      * Requirements:
2114      *
2115      * - `tokenId` must exist.
2116      */
2117     function getApproved(uint256 tokenId) public view virtual override returns (address) {
2118         require(ownerOf(tokenId) != address(0), "ERC721: approved query for nonexistent token");
2119 
2120         return _tokenApprovals[tokenId];
2121     }
2122 
2123     /**
2124      * @dev Approve or remove `operator` as an operator for the caller.
2125      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
2126      *
2127      * Requirements:
2128      *
2129      * - The `operator` cannot be the caller.
2130      *
2131      * Emits an {ApprovalForAll} event.
2132      */
2133     function setApprovalForAll(address operator, bool approved) public virtual override {
2134         require(operator != _msgSender(), "ERC721: approve to caller");
2135 
2136         _operatorApprovals[_msgSender()][operator] = approved;
2137         emit ApprovalForAll(_msgSender(), operator, approved);
2138     }
2139 
2140     /**
2141      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
2142      *
2143      * See {setApprovalForAll}
2144      */
2145     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2146         return _operatorApprovals[owner][operator];
2147     }
2148 
2149     /**
2150      * @dev Transfers `tokenId` token from `from` to `to`.
2151      *
2152      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
2153      *
2154      * Requirements:
2155      *
2156      * - `from` cannot be the zero address.
2157      * - `to` cannot be the zero address.
2158      * - `tokenId` token must be owned by `from`.
2159      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
2160      *
2161      * Emits a {Transfer} event.
2162      */
2163     function transferFrom(
2164         address from,
2165         address to,
2166         uint256 tokenId
2167     ) public virtual override {
2168         //solhint-disable-next-line max-line-length
2169         _requireCanManageToken(tokenId);
2170 
2171         _transfer(from, to, tokenId);
2172     }
2173 
2174     /**
2175      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2176      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2177      *
2178      * Requirements:
2179      *
2180      * - `from` cannot be the zero address.
2181      * - `to` cannot be the zero address.
2182      * - `tokenId` token must exist and be owned by `from`.
2183      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
2184      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2185      *
2186      * Emits a {Transfer} event.
2187      */
2188     function safeTransferFrom(
2189         address from,
2190         address to,
2191         uint256 tokenId
2192     ) public virtual override {
2193         safeTransferFrom(from, to, tokenId, "");
2194     }
2195 
2196     /**
2197      * @dev Safely transfers `tokenId` token from `from` to `to`.
2198      *
2199      * Requirements:
2200      *
2201      * - `from` cannot be the zero address.
2202      * - `to` cannot be the zero address.
2203      * - `tokenId` token must exist and be owned by `from`.
2204      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
2205      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2206      *
2207      * Emits a {Transfer} event.
2208      */
2209     function safeTransferFrom(
2210         address from,
2211         address to,
2212         uint256 tokenId,
2213         bytes memory _data
2214     ) public virtual override {
2215         _requireCanManageToken(tokenId);
2216         _safeTransfer(from, to, tokenId, _data);
2217     }
2218 
2219     /**
2220      * @dev Transfers `tokenId` token from sender to `to`.
2221      *
2222      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
2223      *
2224      * Requirements:
2225      *
2226      * - `to` cannot be the zero address.
2227      * - `tokenId` token must be owned by sender.
2228      *
2229      * Emits a {Transfer} event.
2230      */
2231     function transfer(
2232         address to,
2233         uint256 tokenId
2234     ) public virtual {
2235         _requireCanManageToken(tokenId);
2236         _transfer(_msgSender(), to, tokenId);
2237     }
2238 
2239     /**
2240      * @dev Safely transfers `tokenId` token from sender to `to`.
2241      *
2242      * Requirements:
2243      *
2244      * - `to` cannot be the zero address.
2245      * - `tokenId` token must exist and be owned by sender.
2246      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2247      *
2248      * Emits a {Transfer} event.
2249      */
2250     function safeTransfer(
2251         address to,
2252         uint256 tokenId
2253     ) public virtual {
2254         _requireCanManageToken(tokenId);
2255         _safeTransfer(_msgSender(), to, tokenId, "");
2256     }
2257 
2258     /**
2259      * @dev Burns `tokenId`. See {ERC721-_burn}.
2260      *
2261      * Requirements:
2262      *
2263      * - The caller must own `tokenId` or be an approved operator.
2264      */
2265     function burn(uint256 tokenId) public virtual {
2266         //solhint-disable-next-line max-line-length
2267         _requireCanManageToken(tokenId);
2268         _burn(tokenId);
2269         
2270         _accountForOperation(
2271             OPERATION_BURN << OPERATION_SHIFT_BITS,
2272             tokenId,
2273             0
2274         );
2275     }
2276 
2277     /**
2278     * @dev returns if token is on sale or not, 
2279     * whether it exists or not,
2280     * as well as data about the sale and its owner
2281     * @param tokenId token ID 
2282     */
2283     function getTokenSaleInfo(uint256 tokenId) 
2284         public 
2285         view 
2286         returns
2287         (
2288             bool isOnSale,
2289             bool exists, 
2290             SaleInfo memory data,
2291             address owner
2292         ) 
2293     {
2294         data = salesInfoToken[tokenId].saleInfo;
2295 
2296         exists = _exists(tokenId);
2297         owner = _owners[tokenId];
2298 
2299         if (owner != address(0)) { 
2300             if (data.onSaleUntil > block.timestamp) {
2301                 isOnSale = true;
2302             } 
2303         } else {   
2304             uint64 seriesId = getSeriesId(tokenId);
2305             SeriesInfo memory seriesData = seriesInfo[seriesId];
2306             if (seriesData.saleInfo.onSaleUntil > block.timestamp) {
2307                 isOnSale = true;
2308                 data = seriesData.saleInfo;
2309                 owner = seriesData.author;
2310             }
2311         }   
2312     }
2313 
2314    /**
2315     * @dev the owner should be absolutely sure they trust the trustedForwarder
2316     * @param trustedForwarder_ must be a smart contract that was audited
2317     */
2318     function setTrustedForwarder(
2319         address trustedForwarder_
2320     )
2321         onlyOwner 
2322         public 
2323     {
2324         _setTrustedForwarder(trustedForwarder_);
2325     }
2326 
2327     
2328       
2329     /********************************************************************
2330     ****** internal section *********************************************
2331     *********************************************************************/
2332 
2333     function _msgSender(
2334     ) 
2335         internal 
2336         view 
2337         override
2338         returns (address signer) 
2339     {
2340         signer = msg.sender;
2341         if (msg.data.length >= 20 && trustedForwarder == signer) {
2342             assembly {
2343                 signer := shr(96,calldataload(sub(calldatasize(),20)))
2344             }
2345         }    
2346     }
2347 
2348     function _setTrustedForwarder(
2349         address trustedForwarder_
2350     )
2351         internal 
2352     {
2353         trustedForwarder = trustedForwarder_;
2354     }
2355 
2356     function _transferOwnership(
2357         address newOwner
2358     ) 
2359         internal 
2360         virtual 
2361         override
2362     {
2363         super._transferOwnership(newOwner);
2364         _setTrustedForwarder(address(0));
2365     }
2366 
2367     function _buy(
2368         uint256 tokenId, 
2369         bool exists, 
2370         SaleInfo memory data, 
2371         address owner, 
2372         bool safe
2373     ) 
2374         internal 
2375         virtual 
2376     {
2377         address ms = _msgSender();
2378         if (exists) {
2379             if (safe) {
2380                 _safeTransfer(owner, ms, tokenId, new bytes(0));
2381             } else {
2382                 _transfer(owner, ms, tokenId);
2383             }
2384             emit TokenBought(
2385                 tokenId, 
2386                 owner, 
2387                 ms, 
2388                 data.currency, 
2389                 data.price
2390             );
2391         } else {
2392 
2393             if (safe) {
2394                 _safeMint(ms, tokenId);
2395             } else {
2396                 _mint(ms, tokenId);
2397             }
2398             emit Transfer(owner, ms, tokenId);
2399             emit TokenBought(
2400                 tokenId, 
2401                 owner, 
2402                 ms, 
2403                 data.currency, 
2404                 data.price
2405             );
2406         }
2407          
2408     }
2409 
2410     
2411     /**
2412      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
2413      */
2414     function __ERC721_init(
2415         string memory name_, 
2416         string memory symbol_, 
2417         address costManager_, 
2418         address producedBy_
2419     ) 
2420         internal 
2421         initializer 
2422     {
2423         __Context_init();
2424         __ERC165_init();
2425         __Ownable_init();
2426         __ReentrancyGuard_init();
2427 
2428         _setNameAndSymbol(name_, symbol_);
2429         costManager = costManager_;
2430         factory = _msgSender();
2431         
2432         _accountForOperation(
2433             OPERATION_INITIALIZE << OPERATION_SHIFT_BITS,
2434             uint256(uint160(producedBy_)),
2435             0
2436         );
2437     }
2438     
2439     /**
2440      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2441      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2442      *
2443      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
2444      *
2445      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
2446      * implement alternative mechanisms to perform token transfer, such as signature-based.
2447      *
2448      * Requirements:
2449      *
2450      * - `from` cannot be the zero address.
2451      * - `to` cannot be the zero address.
2452      * - `tokenId` token must exist and be owned by `from`.
2453      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2454      *
2455      * Emits a {Transfer} event.
2456      */
2457     function _safeTransfer(
2458         address from,
2459         address to,
2460         uint256 tokenId,
2461         bytes memory _data
2462     ) internal virtual {
2463         _transfer(from, to, tokenId);
2464         require(_checkOnERC721Received(from, to, tokenId, _data), "recipient must implement ERC721Receiver interface");
2465     }
2466 
2467     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
2468         return _owners[tokenId];
2469     }
2470 
2471     /**
2472      * @dev Safely mints `tokenId` and transfers it to `to`.
2473      *
2474      * Requirements:
2475      *
2476      * - `tokenId` must not exist.
2477      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2478      *
2479      * Emits a {Transfer} event.
2480      */
2481     function _safeMint(address to, uint256 tokenId) internal virtual {
2482         _safeMint(to, tokenId, "");
2483     }
2484 
2485     /**
2486      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2487      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2488      */
2489     function _safeMint(
2490         address to,
2491         uint256 tokenId,
2492         bytes memory _data
2493     ) internal virtual {
2494         _mint(to, tokenId);
2495         require(
2496             _checkOnERC721Received(address(0), to, tokenId, _data),
2497             "ERC721: transfer to non ERC721Receiver implementer"
2498         );
2499     }
2500 
2501     /**
2502      * @dev Mints `tokenId` and transfers it to `to`.
2503      *
2504      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2505      *
2506      * Requirements:
2507      *
2508      * - `tokenId` must not exist.
2509      * - `to` cannot be the zero address.
2510      *
2511      * Emits a {Transfer} event. if flag `skipEvent` is false
2512      */
2513     function _mint(
2514         address to, 
2515         uint256 tokenId
2516     ) 
2517         internal 
2518         virtual 
2519     {
2520         require(to != address(0), "can't mint to the zero address");
2521         require(_owners[tokenId] == address(0), "token already minted");
2522 
2523         _beforeTokenTransfer(address(0), to, tokenId);
2524 
2525         _balances[to] += 1;
2526         _owners[tokenId] = to;
2527 
2528         uint64 seriesId = getSeriesId(tokenId);
2529         mintedCountBySeries[seriesId] += 1;
2530 
2531         if (seriesInfo[seriesId].limit != 0) {
2532             require(
2533                 mintedCountBySeries[seriesId] <= seriesInfo[seriesId].limit, 
2534                 "series token limit exceeded"
2535             );
2536         }
2537         
2538 
2539         emit Transfer(address(0), to, tokenId);
2540         
2541     }
2542 
2543     /**
2544      * @dev Destroys `tokenId`.
2545      * The approval is cleared when the token is burned.
2546      *
2547      * Requirements:
2548      *
2549      * - `tokenId` must exist.
2550      *
2551      * Emits a {Transfer} event.
2552      */
2553     function _burn(uint256 tokenId) internal virtual {
2554         address owner = ownerOf(tokenId);
2555 
2556         _beforeTokenTransfer(owner, address(0), tokenId);
2557 
2558         // Clear approvals
2559         _approve(address(0), tokenId);
2560 
2561         _balances[owner] -= 1;
2562         
2563         _balances[DEAD_ADDRESS] += 1;
2564         _owners[tokenId] = DEAD_ADDRESS;
2565         clearOnSaleUntil(tokenId);
2566         emit Transfer(owner, DEAD_ADDRESS, tokenId);
2567 
2568     }
2569 
2570     /**
2571      * @dev Transfers `tokenId` from `from` to `to`.
2572      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2573      *
2574      * Requirements:
2575      *
2576      * - `to` cannot be the zero address.
2577      * - `tokenId` token must be owned by `from`.
2578      *
2579      * Emits a {Transfer} event.
2580      */
2581     function _transfer(
2582         address from,
2583         address to,
2584         uint256 tokenId
2585     ) internal virtual {
2586         require(ownerOf(tokenId) == from, "token isn't owned by from address");
2587         require(to != address(0), "can't transfer to the zero address");
2588 
2589         _beforeTokenTransfer(from, to, tokenId);
2590 
2591         // Clear approvals from the previous owner
2592         _approve(address(0), tokenId);
2593 
2594         _balances[from] -= 1;
2595         _balances[to] += 1;
2596         _owners[tokenId] = to;
2597 
2598         clearOnSaleUntil(tokenId);
2599 
2600         emit Transfer(from, to, tokenId);
2601         
2602         _accountForOperation(
2603             (OPERATION_TRANSFER << OPERATION_SHIFT_BITS) | getSeriesId(tokenId),
2604             uint256(uint160(from)),
2605             uint256(uint160(to))
2606         );
2607         
2608     }
2609     
2610     /**
2611     * @dev sets sale info for the NFT with 'tokenId'
2612     * @param tokenId token ID
2613     * @param info information about sale 
2614     */
2615     function _setSaleInfo(
2616         uint256 tokenId, 
2617         SaleInfoToken memory info 
2618     ) 
2619         internal 
2620     {
2621         salesInfoToken[tokenId] = info;
2622     }
2623 
2624     /**
2625      * @dev Approve `to` to operate on `tokenId`
2626      *
2627      * Emits a {Approval} event.
2628      */
2629     function _approve(address to, uint256 tokenId) internal virtual {
2630         _tokenApprovals[tokenId] = to;
2631         emit Approval(ownerOf(tokenId), to, tokenId);
2632     }
2633     
2634     /**
2635     * @param account account
2636     * @param limit limit
2637     */
2638     function _tokensByOwner(
2639         address account,
2640         uint32 limit
2641     ) 
2642         internal
2643         view
2644         returns (uint256[] memory array)
2645     {
2646         uint256 len = balanceOf(account);
2647         if (len > 0) {
2648             len = (limit != 0 && limit < len) ? limit : len;
2649             array = new uint256[](len);
2650             for (uint256 i = 0; i < len; i++) {
2651                 array[i] = _ownedTokens[account][i];
2652             }
2653         }
2654     }
2655 
2656     function getSeriesId(
2657         uint256 tokenId
2658     )
2659         internal
2660         pure
2661         returns(uint64)
2662     {
2663         return uint64(tokenId >> SERIES_SHIFT_BITS);
2664     }
2665     
2666     /** 
2667     * @dev sets name and symbol for contract
2668     * @param newName new name 
2669     * @param newSymbol new symbol 
2670     */
2671     function _setNameAndSymbol(
2672         string memory newName, 
2673         string memory newSymbol
2674     ) 
2675         internal 
2676     {
2677         _name = newName;
2678         _symbol = newSymbol;
2679     }
2680 
2681     /**
2682      * @dev Hook that is called before any token transfer. This includes minting
2683      * and burning.
2684      *
2685      * Calling conditions:
2686      *
2687      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2688      * transferred to `to`.
2689      * - When `from` is zero, `tokenId` will be minted for `to`.
2690      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2691      * - `from` cannot be the zero address.
2692      * - `to` cannot be the zero address.
2693      *
2694      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2695      */
2696     function _beforeTokenTransfer(
2697         address from,
2698         address to,
2699         uint256 tokenId
2700     ) internal virtual {
2701 
2702         if (from == address(0)) {
2703             _addTokenToAllTokensEnumeration(tokenId);
2704         } else if (from != to) {
2705             _removeTokenFromOwnerEnumeration(from, tokenId);
2706         }
2707         if (to == address(0)) {
2708             _removeTokenFromAllTokensEnumeration(tokenId);
2709         } else if (to != from) {
2710             _addTokenToOwnerEnumeration(to, tokenId);
2711         }
2712     }
2713 
2714     function clearOnSaleUntil(uint256 tokenId) internal {
2715         if (salesInfoToken[tokenId].saleInfo.onSaleUntil > 0 ) salesInfoToken[tokenId].saleInfo.onSaleUntil = 0;
2716     }
2717 
2718     function _requireCanManageSeries(uint64 seriesId) internal view virtual {
2719         require(canManageSeries(seriesId), "you can't manage this series");
2720     }
2721              
2722     function _requireCanManageToken(uint256 tokenId) internal view virtual {
2723         
2724         require(_exists(tokenId), "token doesn't exist");
2725         require(_canManageToken(tokenId), "you can't manage this token");
2726     }
2727 
2728     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2729         return _owners[tokenId] != address(0)
2730             && _owners[tokenId] != DEAD_ADDRESS;
2731     }
2732 
2733     function _canManageToken(uint256 tokenId) internal view returns (bool) {
2734         return _ownerOf(tokenId) == _msgSender()
2735             || getApproved(tokenId) == _msgSender()
2736             || isApprovedForAll(_ownerOf(tokenId), _msgSender());
2737     }
2738     
2739 
2740     /********************************************************************
2741     ****** private section **********************************************
2742     *********************************************************************/
2743 
2744     /**
2745      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2746      * The call is not executed if the target address is not a contract.
2747      *
2748      * @param from address representing the previous owner of the given token ID
2749      * @param to target address that will receive the tokens
2750      * @param tokenId uint256 ID of the token to be transferred
2751      * @param _data bytes optional data to send along with the call
2752      * @return bool whether the call correctly returned the expected magic value
2753      */
2754     function _checkOnERC721Received(
2755         address from,
2756         address to,
2757         uint256 tokenId,
2758         bytes memory _data
2759     ) private returns (bool) {
2760         if (to.isContract()) {
2761             try IERC721ReceiverUpgradeable(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
2762                 return retval == IERC721ReceiverUpgradeable.onERC721Received.selector;
2763             } catch (bytes memory reason) {
2764                 if (reason.length == 0) {
2765                     revert("ERC721: transfer to non ERC721Receiver implementer");
2766                 } else {
2767                     assembly {
2768                         revert(add(32, reason), mload(reason))
2769                     }
2770                 }
2771             }
2772         } else {
2773             return true;
2774         }
2775     }
2776 
2777 
2778    
2779     /**
2780      * @dev Private function to add a token to this extension's ownership-tracking data structures.
2781      * @param to address representing the new owner of the given token ID
2782      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
2783      */
2784     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
2785         uint256 length = balanceOf(to);
2786         _ownedTokens[to][length] = tokenId;
2787         _ownedTokensIndex[tokenId] = length;
2788     }
2789 
2790     /**
2791      * @dev Private function to add a token to this extension's token tracking data structures.
2792      * @param tokenId uint256 ID of the token to be added to the tokens list
2793      */
2794     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
2795         _allTokensIndex[tokenId] = _allTokens.length;
2796         _allTokens.push(tokenId);
2797     }
2798 
2799     /**
2800      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
2801      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
2802      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
2803      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
2804      * @param from address representing the previous owner of the given token ID
2805      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
2806      */
2807     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
2808         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
2809         // then delete the last slot (swap and pop).
2810 
2811         uint256 lastTokenIndex = balanceOf(from) - 1;
2812         uint256 tokenIndex = _ownedTokensIndex[tokenId];
2813 
2814         // When the token to delete is the last token, the swap operation is unnecessary
2815         if (tokenIndex != lastTokenIndex) {
2816             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
2817 
2818             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2819             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2820         }
2821 
2822         // This also deletes the contents at the last position of the array
2823         delete _ownedTokensIndex[tokenId];
2824         delete _ownedTokens[from][lastTokenIndex];
2825     }
2826 
2827     /**
2828      * @dev Private function to remove a token from this extension's token tracking data structures.
2829      * This has O(1) time complexity, but alters the order of the _allTokens array.
2830      * @param tokenId uint256 ID of the token to be removed from the tokens list
2831      */
2832     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
2833         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
2834         // then delete the last slot (swap and pop).
2835 
2836         uint256 lastTokenIndex = _allTokens.length - 1;
2837         uint256 tokenIndex = _allTokensIndex[tokenId];
2838 
2839         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
2840         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
2841         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
2842         uint256 lastTokenId = _allTokens[lastTokenIndex];
2843 
2844         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2845         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2846 
2847         // This also deletes the contents at the last position of the array
2848         delete _allTokensIndex[tokenId];
2849         _allTokens.pop();
2850     }
2851     
2852     /**
2853      * @dev Private function that tells utility token contract to account for an operation
2854      * @param info uint256 The operation ID (first 8 bits), seriesId is last 8 bits
2855      * @param param1 uint256 Some more information, if any
2856      * @param param2 uint256 Some more information, if any
2857      */
2858     function _accountForOperation(uint256 info, uint256 param1, uint256 param2) private {
2859         if (costManager != address(0)) {
2860             try ICostManager(costManager).accountForOperation(
2861                 _msgSender(), info, param1, param2
2862             )
2863             returns (uint256 /*spent*/, uint256 /*remaining*/) {
2864                 // if error is not thrown, we are fine
2865             } catch Error(string memory reason) {
2866                 // This is executed in case revert() was called with a reason
2867                 revert(reason);
2868             } catch {
2869                 revert("Insufficient Utility Token: Contact Owner");
2870             }
2871         }
2872     }
2873 
2874     
2875 
2876 }
2877 
2878 // File: contracts/extensions/ERC721SafeHooksUpgradeable.sol
2879 
2880 
2881 
2882 pragma solidity ^0.8.0;
2883 
2884 
2885 
2886 
2887 /**
2888 * holds count of series hooks while token mint and buy
2889 */
2890 abstract contract ERC721SafeHooksUpgradeable is Initializable, ERC721UpgradeableExt {
2891     
2892     using EnumerableSetUpgradeable for EnumerableSetUpgradeable.AddressSet;
2893 
2894     mapping (uint256 => uint256) public hooksCountByToken; // token ID => hooks count
2895 
2896     mapping(uint256 => EnumerableSetUpgradeable.AddressSet) internal hooks;    // series ID => hooks' addresses
2897 
2898     event NewHook(uint256 seriesId, address contractAddress);
2899 
2900     /**
2901     * @dev buys NFT for ETH with defined id. 
2902     * mint token if it doesn't exist and transfer token
2903     * if it exists and is on sale
2904     * @param tokenId token ID to buy
2905     * @param price amount of specified ETH to pay
2906     * @param safe use safeMint and safeTransfer or not
2907     * @param hookCount number of hooks 
2908     */
2909     function buy(
2910         uint256 tokenId, 
2911         uint256 price, 
2912         bool safe, 
2913         uint256 hookCount
2914     ) 
2915         external
2916         payable
2917     {
2918         validateHookCount(tokenId, hookCount);    
2919         super.buy(tokenId, price, safe);
2920     }
2921     /**
2922     * @dev buys NFT for specified currency with defined id. 
2923     * mint token if it doesn't exist and transfer token
2924     * if it exists and is on sale
2925     * @param tokenId token ID to buy
2926     * @param currency address of token to pay with
2927     * @param price amount of specified token to pay
2928     * @param safe use safeMint and safeTransfer or not
2929     * @param hookCount number of hooks 
2930     */
2931     function buy(
2932         uint256 tokenId, 
2933         address currency, 
2934         uint256 price, 
2935         bool safe, 
2936         uint256 hookCount
2937     ) 
2938         external
2939     {
2940         validateHookCount(tokenId, hookCount);    
2941         super.buy(tokenId, currency, price, safe);
2942     }
2943 
2944     /**
2945     * @dev link safeHook contract to certain series
2946     * @param seriesId series ID
2947     * @param contractAddress address of SafeHook contract
2948     */
2949     function pushTokenTransferHook(
2950         uint256 seriesId, 
2951         address contractAddress
2952     )
2953         public 
2954         onlyOwner
2955     {
2956 
2957         try ISafeHook(contractAddress).supportsInterface(type(ISafeHook).interfaceId) returns (bool success) {
2958             if (success) {
2959                 hooks[seriesId].add(contractAddress);
2960             } else {
2961                 revert("wrong interface");
2962             }
2963         } catch {
2964             revert("wrong interface");
2965         }
2966 
2967         emit NewHook(seriesId, contractAddress);
2968 
2969     }
2970 
2971     /**
2972     * @dev returns the list of hooks for series with `seriesId`
2973     * @param seriesId series ID
2974     */
2975     function getHookList(
2976         uint256 seriesId
2977     ) 
2978         external 
2979         view 
2980         returns(address[] memory) 
2981     {
2982         uint256 len = hooksCount(seriesId);
2983         address[] memory allHooks = new address[](len);
2984         for (uint256 i = 0; i < hooksCount(seriesId); i++) {
2985             allHooks[i] = hooks[seriesId].at(i);
2986         }
2987         return allHooks;
2988     }
2989 
2990     /**
2991     * @dev returns count of hooks for series with `seriesId`
2992     * @param seriesId series ID
2993     */
2994     function hooksCount(
2995         uint256 seriesId
2996     ) 
2997         internal 
2998         view 
2999         returns(uint256) 
3000     {
3001         return hooks[seriesId].length();
3002     }
3003 
3004     /**
3005     * @dev validates hook count
3006     * @param tokenId token ID
3007     * @param hookCount hook count
3008     */
3009     function validateHookCount(
3010         uint256 tokenId,
3011         uint256 hookCount
3012     ) 
3013         internal 
3014         view 
3015     {
3016         uint256 seriesId = tokenId >> SERIES_SHIFT_BITS;
3017         require(hookCount == hooksCount(seriesId), "wrong hookCount");
3018     }
3019 
3020     /**
3021     * @param name_ name 
3022     * @param symbol_ symbol 
3023     */
3024     function __ERC721SafeHook_init(
3025         string memory name_, 
3026         string memory symbol_, 
3027         address costManager_,
3028         address msgSender_
3029     ) 
3030         internal 
3031         initializer 
3032     {
3033         __ERC721_init(name_, symbol_, costManager_, msgSender_);
3034     }
3035 
3036     /**
3037      * @dev Overriden function _beforeTokenTransfer with
3038      * hooks executing 
3039      */
3040     function _beforeTokenTransfer(
3041         address from,
3042         address to,
3043         uint256 tokenId
3044     ) 
3045         internal 
3046         virtual 
3047         override 
3048     {
3049         uint256 seriesId = tokenId >> SERIES_SHIFT_BITS;
3050         for (uint256 i = 0; i < hooksCountByToken[tokenId]; i++) {
3051             try ISafeHook(hooks[seriesId].at(i)).executeHook(from, to, tokenId)
3052 			returns (bool success) {
3053                 if (!success) {
3054                     revert("Transfer Not Authorized");
3055                 }
3056             } catch Error(string memory reason) {
3057                 // This is executed in case revert() was called with a reason
3058 	            revert(reason);
3059 	        } catch {
3060                 revert("Transfer Not Authorized");
3061             }
3062         }
3063 
3064         super._beforeTokenTransfer(from, to, tokenId);
3065 
3066     }
3067     /**
3068     * @dev overriden _mint function.
3069     * Here we remember count of series hooks at this moment. 
3070     * So further hooks will not apply for this token
3071     */
3072     function _mint(
3073         address to, 
3074         uint256 tokenId
3075     ) 
3076         internal 
3077         virtual 
3078         override
3079     {
3080         _storeHookCount(tokenId);
3081         super._mint(to, tokenId);
3082     }
3083 
3084     /**
3085     * @dev overriden _buy function.
3086     * Here we remember count of series hooks at this moment. 
3087     * So further hooks will not apply for this token
3088     */
3089     function _buy(
3090         uint256 tokenId, 
3091         bool exists, 
3092         SaleInfo memory data, 
3093         address owner, 
3094         bool safe
3095     ) 
3096         internal 
3097         override 
3098     {
3099         _storeHookCount(tokenId);
3100         super._buy(tokenId, exists, data, owner, safe);
3101         
3102     }
3103 
3104     /** 
3105     * @dev used to storage hooksCountByToken at this moment
3106     */
3107     function _storeHookCount(
3108         uint256 tokenId
3109     )
3110         internal
3111     {
3112         hooksCountByToken[tokenId] = hooks[tokenId >> SERIES_SHIFT_BITS].length();
3113     }
3114 }
3115 
3116 // File: contracts/presets/NFTSafeHook.sol
3117 
3118 
3119 
3120 /**
3121 Although this code is available for viewing on GitHub and Etherscan, it is NOT licensed to the general public.
3122 
3123 To prevent confusion and increase trust in the audited code bases of smart contracts we produce, we intend for there to be only ONE official Factory address on the blockchain producing these NFT smart contracts, and we are going to point a blockchain domain name at it.
3124 
3125 Copyright (c) Intercoin Inc. All rights reserved.
3126 
3127 However, the general public is welcome to use this official Factory to produce instances for their use. We may begin requiring staking of ITR tokens in order to take actions (such as producing series and minting tokens). If you are looking to obtain ITR tokens or custom work done with your NFT projects, visit intercoin.org
3128 
3129 Any user of software powered by this code must agree to the following, in order to use it. If you do not agree, refrain from using the software:
3130 
3131 DISCLAIMERS AND DISCLOSURES.
3132 
3133 Customer expressly recognizes that nearly any software may contain unforeseen bugs or other defects, due to the nature of software development. Moreover, because of the immutable nature of smart contracts, any such defects will persist in the software once it is deployed onto the blockchain. Customer therefore expressly acknowledges that no outside audits of the software have been conducted, and any responsibility to obtain such audits and analysis of any software produced by Developer rests solely with Customer.
3134 
3135 Customer understands and acknowledges that the Software is being delivered as-is, and may contain potential defects. While Developer and its staff and partners have exercised care and best efforts in an attempt to produce solid, working software products, Developer EXPRESSLY DISCLAIMS MAKING ANY GUARANTEES, REPRESENTATIONS OR WARRANTIES, EXPRESS OR IMPLIED, ABOUT THE FITNESS OF THE SOFTWARE, INCLUDING LACK OF DEFECTS, MERCHANTABILITY OR SUITABILITY FOR A PARTICULAR PURPOSE.
3136 
3137 Customer agrees that neither Developer nor any other party has made any representations or warranties, nor has the Customer relied on any representations or warranties, express or implied, including any implied warranty of merchantability or fitness for any particular purpose with respect to the Software. Customer acknowledges that no affirmation of fact or statement (whether written or oral) made by Developer, its representatives, or any other party outside of this Agreement with respect to the Software shall be deemed to create any express or implied warranty on the part of Developer or its representatives.
3138 
3139 INDEMNIFICATION.
3140 
3141 Customer agrees to indemnify, defend and hold Developer and its officers, directors, employees, agents and contractors harmless from any loss, cost, expense (including attorney’s fees and expenses), associated with or related to any demand, claim, liability, damages or cause of action of any kind or character (collectively referred to as “claim”), in any manner arising out of or relating to any third party demand, dispute, mediation, arbitration, litigation, or any violation or breach of any provision of this Agreement by Customer.
3142 
3143 NO WARRANTY.
3144 
3145 THE SOFTWARE IS PROVIDED “AS IS” WITHOUT WARRANTY. DEVELOPER SHALL NOT BE LIABLE FOR ANY DIRECT, INDIRECT, SPECIAL, INCIDENTAL, CONSEQUENTIAL, OR EXEMPLARY DAMAGES FOR BREACH OF THE LIMITED WARRANTY. TO THE MAXIMUM EXTENT PERMITTED BY LAW, DEVELOPER EXPRESSLY DISCLAIMS, AND CUSTOMER EXPRESSLY WAIVES, ALL OTHER WARRANTIES, WHETHER EXPRESSED, IMPLIED, OR STATUTORY, INCLUDING WITHOUT LIMITATION ALL IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE OR USE, OR ANY WARRANTY ARISING OUT OF ANY PROPOSAL, SPECIFICATION, OR SAMPLE, AS WELL AS ANY WARRANTIES THAT THE SOFTWARE (OR ANY ELEMENTS THEREOF) WILL ACHIEVE A PARTICULAR RESULT, OR WILL BE UNINTERRUPTED OR ERROR-FREE. THE TERM OF ANY IMPLIED WARRANTIES THAT CANNOT BE DISCLAIMED UNDER APPLICABLE LAW SHALL BE LIMITED TO THE DURATION OF THE FOREGOING EXPRESS WARRANTY PERIOD. SOME STATES DO NOT ALLOW THE EXCLUSION OF IMPLIED WARRANTIES AND/OR DO NOT ALLOW LIMITATIONS ON THE AMOUNT OF TIME AN IMPLIED WARRANTY LASTS, SO THE ABOVE LIMITATIONS MAY NOT APPLY TO CUSTOMER. THIS LIMITED WARRANTY GIVES CUSTOMER SPECIFIC LEGAL RIGHTS. CUSTOMER MAY HAVE OTHER RIGHTS WHICH VARY FROM STATE TO STATE. 
3146 
3147 LIMITATION OF LIABILITY. 
3148 
3149 TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE LAW, IN NO EVENT SHALL DEVELOPER BE LIABLE UNDER ANY THEORY OF LIABILITY FOR ANY CONSEQUENTIAL, INDIRECT, INCIDENTAL, SPECIAL, PUNITIVE OR EXEMPLARY DAMAGES OF ANY KIND, INCLUDING, WITHOUT LIMITATION, DAMAGES ARISING FROM LOSS OF PROFITS, REVENUE, DATA OR USE, OR FROM INTERRUPTED COMMUNICATIONS OR DAMAGED DATA, OR FROM ANY DEFECT OR ERROR OR IN CONNECTION WITH CUSTOMER'S ACQUISITION OF SUBSTITUTE GOODS OR SERVICES OR MALFUNCTION OF THE SOFTWARE, OR ANY SUCH DAMAGES ARISING FROM BREACH OF CONTRACT OR WARRANTY OR FROM NEGLIGENCE OR STRICT LIABILITY, EVEN IF DEVELOPER OR ANY OTHER PERSON HAS BEEN ADVISED OR SHOULD KNOW OF THE POSSIBILITY OF SUCH DAMAGES, AND NOTWITHSTANDING THE FAILURE OF ANY REMEDY TO ACHIEVE ITS INTENDED PURPOSE. WITHOUT LIMITING THE FOREGOING OR ANY OTHER LIMITATION OF LIABILITY HEREIN, REGARDLESS OF THE FORM OF ACTION, WHETHER FOR BREACH OF CONTRACT, WARRANTY, NEGLIGENCE, STRICT LIABILITY IN TORT OR OTHERWISE, CUSTOMER'S EXCLUSIVE REMEDY AND THE TOTAL LIABILITY OF DEVELOPER OR ANY SUPPLIER OF SERVICES TO DEVELOPER FOR ANY CLAIMS ARISING IN ANY WAY IN CONNECTION WITH OR RELATED TO THIS AGREEMENT, THE SOFTWARE, FOR ANY CAUSE WHATSOEVER, SHALL NOT EXCEED 1,000 USD.
3150 
3151 ENTIRE AGREEMENT
3152 
3153 This Agreement contains the entire agreement and understanding among the parties hereto with respect to the subject matter hereof, and supersedes all prior and contemporaneous agreements, understandings, inducements and conditions, express or implied, oral or written, of any nature whatsoever with respect to the subject matter hereof. The express terms hereof control and supersede any course of performance and/or usage of the trade inconsistent with any of the terms hereof. Provisions from previous Agreements executed between Customer and Developer., which are not expressly dealt with in this Agreement, will remain in effect.
3154 
3155 SUCCESSORS AND ASSIGNS
3156 
3157 This Agreement shall continue to apply to any successors or assigns of either party, or any corporation or other entity acquiring all or substantially all the assets and business of either party whether by operation of law or otherwise.
3158 
3159 ARBITRATION
3160 
3161 All disputes related to this agreement shall be governed by and interpreted in accordance with the laws of New York, without regard to principles of conflict of laws. The parties to this agreement will submit all disputes arising under this agreement to arbitration in New York City, New York before a single arbitrator of the American Arbitration Association (“AAA”). The arbitrator shall be selected by application of the rules of the AAA, or by mutual agreement of the parties, except that such arbitrator shall be an attorney admitted to practice law New York. No party to this agreement will challenge the jurisdiction or venue provisions as provided in this section. No party to this agreement will challenge the jurisdiction or venue provisions as provided in this section.
3162 **/
3163 
3164 pragma solidity ^0.8.0;
3165 pragma abicoder v2;
3166 
3167 /**
3168 * NFT with safe hooks support
3169 */
3170 contract NFTSafeHook is ERC721SafeHooksUpgradeable {
3171 
3172     /**
3173     * @notice initializes contract
3174     */
3175     function initialize(
3176         string memory name_, 
3177         string memory symbol_, 
3178         string memory contractURI_,
3179         address costManager_,
3180         address producedBy_
3181     ) 
3182         public 
3183         initializer 
3184     {
3185         __Ownable_init();
3186         __ReentrancyGuard_init();
3187         __ERC721SafeHook_init(name_, symbol_, costManager_, producedBy_);
3188         _contractURI = contractURI_;
3189 
3190     }
3191 }