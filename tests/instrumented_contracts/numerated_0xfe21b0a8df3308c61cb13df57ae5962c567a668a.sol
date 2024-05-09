1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/math/SafeMath.sol
4 
5 pragma solidity ^0.6.0;
6 
7 /**
8  * @dev Wrappers over Solidity's arithmetic operations with added overflow
9  * checks.
10  *
11  * Arithmetic operations in Solidity wrap on overflow. This can easily result
12  * in bugs, because programmers usually assume that an overflow raises an
13  * error, which is the standard behavior in high level programming languages.
14  * `SafeMath` restores this intuition by reverting the transaction when an
15  * operation overflows.
16  *
17  * Using this library instead of the unchecked operations eliminates an entire
18  * class of bugs, so it's recommended to use it always.
19  */
20 library SafeMath {
21     /**
22      * @dev Returns the addition of two unsigned integers, reverting on
23      * overflow.
24      *
25      * Counterpart to Solidity's `+` operator.
26      *
27      * Requirements:
28      * - Addition cannot overflow.
29      */
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         require(c >= a, "SafeMath: addition overflow");
33 
34         return c;
35     }
36 
37     /**
38      * @dev Returns the subtraction of two unsigned integers, reverting on
39      * overflow (when the result is negative).
40      *
41      * Counterpart to Solidity's `-` operator.
42      *
43      * Requirements:
44      * - Subtraction cannot overflow.
45      */
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         return sub(a, b, "SafeMath: subtraction overflow");
48     }
49 
50     /**
51      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
52      * overflow (when the result is negative).
53      *
54      * Counterpart to Solidity's `-` operator.
55      *
56      * Requirements:
57      * - Subtraction cannot overflow.
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
114      */
115     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
116         // Solidity only automatically asserts when dividing by 0
117         require(b > 0, errorMessage);
118         uint256 c = a / b;
119         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
120 
121         return c;
122     }
123 
124     /**
125      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
126      * Reverts when dividing by zero.
127      *
128      * Counterpart to Solidity's `%` operator. This function uses a `revert`
129      * opcode (which leaves remaining gas untouched) while Solidity uses an
130      * invalid opcode to revert (consuming all remaining gas).
131      *
132      * Requirements:
133      * - The divisor cannot be zero.
134      */
135     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
136         return mod(a, b, "SafeMath: modulo by zero");
137     }
138 
139     /**
140      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
141      * Reverts with custom message when dividing by zero.
142      *
143      * Counterpart to Solidity's `%` operator. This function uses a `revert`
144      * opcode (which leaves remaining gas untouched) while Solidity uses an
145      * invalid opcode to revert (consuming all remaining gas).
146      *
147      * Requirements:
148      * - The divisor cannot be zero.
149      */
150     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
151         require(b != 0, errorMessage);
152         return a % b;
153     }
154 }
155 
156 // File: @openzeppelin/contracts/introspection/IERC165.sol
157 
158 pragma solidity ^0.6.0;
159 
160 /**
161  * @dev Interface of the ERC165 standard, as defined in the
162  * https://eips.ethereum.org/EIPS/eip-165[EIP].
163  *
164  * Implementers can declare support of contract interfaces, which can then be
165  * queried by others ({ERC165Checker}).
166  *
167  * For an implementation, see {ERC165}.
168  */
169 interface IERC165 {
170     /**
171      * @dev Returns true if this contract implements the interface defined by
172      * `interfaceId`. See the corresponding
173      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
174      * to learn more about how these ids are created.
175      *
176      * This function call must use less than 30 000 gas.
177      */
178     function supportsInterface(bytes4 interfaceId) external view returns (bool);
179 }
180 
181 // File: @openzeppelin/contracts/introspection/ERC165.sol
182 
183 pragma solidity ^0.6.0;
184 
185 
186 /**
187  * @dev Implementation of the {IERC165} interface.
188  *
189  * Contracts may inherit from this and call {_registerInterface} to declare
190  * their support of an interface.
191  */
192 contract ERC165 is IERC165 {
193     /*
194      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
195      */
196     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
197 
198     /**
199      * @dev Mapping of interface ids to whether or not it's supported.
200      */
201     mapping(bytes4 => bool) private _supportedInterfaces;
202 
203     constructor () internal {
204         // Derived contracts need only register support for their own interfaces,
205         // we register support for ERC165 itself here
206         _registerInterface(_INTERFACE_ID_ERC165);
207     }
208 
209     /**
210      * @dev See {IERC165-supportsInterface}.
211      *
212      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
213      */
214     function supportsInterface(bytes4 interfaceId) external view override returns (bool) {
215         return _supportedInterfaces[interfaceId];
216     }
217 
218     /**
219      * @dev Registers the contract as an implementer of the interface defined by
220      * `interfaceId`. Support of the actual ERC165 interface is automatic and
221      * registering its interface id is not required.
222      *
223      * See {IERC165-supportsInterface}.
224      *
225      * Requirements:
226      *
227      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
228      */
229     function _registerInterface(bytes4 interfaceId) internal virtual {
230         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
231         _supportedInterfaces[interfaceId] = true;
232     }
233 }
234 
235 // File: @openzeppelin/contracts/GSN/Context.sol
236 
237 pragma solidity ^0.6.0;
238 
239 /*
240  * @dev Provides information about the current execution context, including the
241  * sender of the transaction and its data. While these are generally available
242  * via msg.sender and msg.data, they should not be accessed in such a direct
243  * manner, since when dealing with GSN meta-transactions the account sending and
244  * paying for execution may not be the actual sender (as far as an application
245  * is concerned).
246  *
247  * This contract is only required for intermediate, library-like contracts.
248  */
249 contract Context {
250     // Empty internal constructor, to prevent people from mistakenly deploying
251     // an instance of this contract, which should be used via inheritance.
252     constructor () internal { }
253 
254     function _msgSender() internal view virtual returns (address payable) {
255         return msg.sender;
256     }
257 
258     function _msgData() internal view virtual returns (bytes memory) {
259         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
260         return msg.data;
261     }
262 }
263 
264 // File: contracts/interfaces/IERC721Token.sol
265 
266 /*
267 
268   Copyright 2019 ZeroEx Intl.
269 
270   Licensed under the Apache License, Version 2.0 (the "License");
271   you may not use this file except in compliance with the License.
272   You may obtain a copy of the License at
273 
274     http://www.apache.org/licenses/LICENSE-2.0
275 
276   Unless required by applicable law or agreed to in writing, software
277   distributed under the License is distributed on an "AS IS" BASIS,
278   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
279   See the License for the specific language governing permissions and
280   limitations under the License.
281 
282 */
283 
284 pragma solidity 0.6.12;
285 
286 
287 interface IERC721Token {
288 
289     /// @dev This emits when ownership of any NFT changes by any mechanism.
290     ///      This event emits when NFTs are created (`from` == 0) and destroyed
291     ///      (`to` == 0). Exception: during contract creation, any number of NFTs
292     ///      may be created and assigned without emitting Transfer. At the time of
293     ///      any transfer, the approved address for that NFT (if any) is reset to none.
294     event Transfer(
295         address indexed from,
296         address indexed to,
297         uint256 indexed tokenId
298     );
299 
300     /// @dev This emits when the approved address for an NFT is changed or
301     ///      reaffirmed. The zero address indicates there is no approved address.
302     ///      When a Transfer event emits, this also indicates that the approved
303     ///      address for that NFT (if any) is reset to none.
304     event Approval(
305         address indexed owner,
306         address indexed approved,
307         uint256 indexed tokenId
308     );
309 
310     /// @dev This emits when an operator is enabled or disabled for an owner.
311     ///      The operator can manage all NFTs of the owner.
312     event ApprovalForAll(
313         address indexed owner,
314         address indexed operator,
315         bool approved
316     );
317 
318     /// @notice Transfers the ownership of an NFT from one address to another address
319     /// @dev This works identically to the other function with an extra data parameter,
320     ///      except this function just sets data to "".
321     /// @param _from The current owner of the NFT
322     /// @param _to The new owner
323     /// @param _tokenId The NFT to transfer
324     function safeTransferFrom(
325         address _from,
326         address _to,
327         uint256 _tokenId
328     )
329     external;
330 
331     /// @notice Transfers the ownership of an NFT from one address to another address
332     /// @dev Throws unless `msg.sender` is the current owner, an authorized
333     ///      perator, or the approved address for this NFT. Throws if `_from` is
334     ///      not the current owner. Throws if `_to` is the zero address. Throws if
335     ///      `_tokenId` is not a valid NFT. When transfer is complete, this function
336     ///      checks if `_to` is a smart contract (code size > 0). If so, it calls
337     ///      `onERC721Received` on `_to` and throws if the return value is not
338     ///      `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
339     /// @param _from The current owner of the NFT
340     /// @param _to The new owner
341     /// @param _tokenId The NFT to transfer
342     /// @param _data Additional data with no specified format, sent in call to `_to`
343     function safeTransferFrom(
344         address _from,
345         address _to,
346         uint256 _tokenId,
347         bytes calldata _data
348     )
349     external;
350 
351     /// @notice Change or reaffirm the approved address for an NFT
352     /// @dev The zero address indicates there is no approved address.
353     ///      Throws unless `msg.sender` is the current NFT owner, or an authorized
354     ///      operator of the current owner.
355     /// @param _approved The new approved NFT controller
356     /// @param _tokenId The NFT to approve
357     function approve(address _approved, uint256 _tokenId)
358     external;
359 
360     /// @notice Enable or disable approval for a third party ("operator") to manage
361     ///         all of `msg.sender`'s assets
362     /// @dev Emits the ApprovalForAll event. The contract MUST allow
363     ///      multiple operators per owner.
364     /// @param _operator Address to add to the set of authorized operators
365     /// @param _approved True if the operator is approved, false to revoke approval
366     function setApprovalForAll(address _operator, bool _approved)
367     external;
368 
369     /// @notice Count all NFTs assigned to an owner
370     /// @dev NFTs assigned to the zero address are considered invalid, and this
371     ///      function throws for queries about the zero address.
372     /// @param _owner An address for whom to query the balance
373     /// @return The number of NFTs owned by `_owner`, possibly zero
374     function balanceOf(address _owner)
375     external
376     view
377     returns (uint256);
378 
379     /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
380     ///         TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
381     ///         THEY MAY BE PERMANENTLY LOST
382     /// @dev Throws unless `msg.sender` is the current owner, an authorized
383     ///      operator, or the approved address for this NFT. Throws if `_from` is
384     ///      not the current owner. Throws if `_to` is the zero address. Throws if
385     ///      `_tokenId` is not a valid NFT.
386     /// @param _from The current owner of the NFT
387     /// @param _to The new owner
388     /// @param _tokenId The NFT to transfer
389     function transferFrom(
390         address _from,
391         address _to,
392         uint256 _tokenId
393     )
394     external;
395 
396     /// @notice Find the owner of an NFT
397     /// @dev NFTs assigned to zero address are considered invalid, and queries
398     ///      about them do throw.
399     /// @param _tokenId The identifier for an NFT
400     /// @return The address of the owner of the NFT
401     function ownerOf(uint256 _tokenId)
402     external
403     view
404     returns (address);
405 
406     /// @notice Get the approved address for a single NFT
407     /// @dev Throws if `_tokenId` is not a valid NFT.
408     /// @param _tokenId The NFT to find the approved address for
409     /// @return The approved address for this NFT, or the zero address if there is none
410     function getApproved(uint256 _tokenId)
411     external
412     view
413     returns (address);
414 
415     /// @notice Query if an address is an authorized operator for another address
416     /// @param _owner The address that owns the NFTs
417     /// @param _operator The address that acts on behalf of the owner
418     /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
419     function isApprovedForAll(address _owner, address _operator)
420     external
421     view
422     returns (bool);
423 }
424 
425 // File: contracts/interfaces/IERC721Receiver.sol
426 
427 /*
428 
429   Copyright 2019 ZeroEx Intl.
430 
431   Licensed under the Apache License, Version 2.0 (the "License");
432   you may not use this file except in compliance with the License.
433   You may obtain a copy of the License at
434 
435     http://www.apache.org/licenses/LICENSE-2.0
436 
437   Unless required by applicable law or agreed to in writing, software
438   distributed under the License is distributed on an "AS IS" BASIS,
439   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
440   See the License for the specific language governing permissions and
441   limitations under the License.
442 
443 */
444 
445 pragma solidity 0.6.12;
446 
447 
448 interface IERC721Receiver {
449 
450     /// @notice Handle the receipt of an NFT
451     /// @dev The ERC721 smart contract calls this function on the recipient
452     ///  after a `transfer`. This function MAY throw to revert and reject the
453     ///  transfer. Return of other than the magic value MUST result in the
454     ///  transaction being reverted.
455     ///  Note: the contract address is always the message sender.
456     /// @param _operator The address which called `safeTransferFrom` function
457     /// @param _from The address which previously owned the token
458     /// @param _tokenId The NFT identifier which is being transferred
459     /// @param _data Additional data with no specified format
460     /// @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
461     ///  unless throwing
462     function onERC721Received(
463         address _operator,
464         address _from,
465         uint256 _tokenId,
466         bytes calldata _data
467     )
468     external
469     returns (bytes4);
470 }
471 
472 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
473 
474 pragma solidity ^0.6.0;
475 
476 /**
477  * @dev Library for managing
478  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
479  * types.
480  *
481  * Sets have the following properties:
482  *
483  * - Elements are added, removed, and checked for existence in constant time
484  * (O(1)).
485  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
486  *
487  * As of v2.5.0, only `address` sets are supported.
488  *
489  * Include with `using EnumerableSet for EnumerableSet.AddressSet;`.
490  *
491  * @author Alberto Cuesta Cañada
492  */
493 library EnumerableSet {
494 
495     struct AddressSet {
496         // Position of the value in the `values` array, plus 1 because index 0
497         // means a value is not in the set.
498         mapping (address => uint256) index;
499         address[] values;
500     }
501 
502     /**
503      * @dev Add a value to a set. O(1).
504      * Returns false if the value was already in the set.
505      */
506     function add(AddressSet storage set, address value)
507         internal
508         returns (bool)
509     {
510         if (!contains(set, value)) {
511             set.values.push(value);
512             // The element is stored at length-1, but we add 1 to all indexes
513             // and use 0 as a sentinel value
514             set.index[value] = set.values.length;
515             return true;
516         } else {
517             return false;
518         }
519     }
520 
521     /**
522      * @dev Removes a value from a set. O(1).
523      * Returns false if the value was not present in the set.
524      */
525     function remove(AddressSet storage set, address value)
526         internal
527         returns (bool)
528     {
529         if (contains(set, value)){
530             uint256 toDeleteIndex = set.index[value] - 1;
531             uint256 lastIndex = set.values.length - 1;
532 
533             // If the element we're deleting is the last one, we can just remove it without doing a swap
534             if (lastIndex != toDeleteIndex) {
535                 address lastValue = set.values[lastIndex];
536 
537                 // Move the last value to the index where the deleted value is
538                 set.values[toDeleteIndex] = lastValue;
539                 // Update the index for the moved value
540                 set.index[lastValue] = toDeleteIndex + 1; // All indexes are 1-based
541             }
542 
543             // Delete the index entry for the deleted value
544             delete set.index[value];
545 
546             // Delete the old entry for the moved value
547             set.values.pop();
548 
549             return true;
550         } else {
551             return false;
552         }
553     }
554 
555     /**
556      * @dev Returns true if the value is in the set. O(1).
557      */
558     function contains(AddressSet storage set, address value)
559         internal
560         view
561         returns (bool)
562     {
563         return set.index[value] != 0;
564     }
565 
566     /**
567      * @dev Returns an array with all values in the set. O(N).
568      * Note that there are no guarantees on the ordering of values inside the
569      * array, and it may change when more values are added or removed.
570 
571      * WARNING: This function may run out of gas on large sets: use {length} and
572      * {get} instead in these cases.
573      */
574     function enumerate(AddressSet storage set)
575         internal
576         view
577         returns (address[] memory)
578     {
579         address[] memory output = new address[](set.values.length);
580         for (uint256 i; i < set.values.length; i++){
581             output[i] = set.values[i];
582         }
583         return output;
584     }
585 
586     /**
587      * @dev Returns the number of elements on the set. O(1).
588      */
589     function length(AddressSet storage set)
590         internal
591         view
592         returns (uint256)
593     {
594         return set.values.length;
595     }
596 
597    /** @dev Returns the element stored at position `index` in the set. O(1).
598     * Note that there are no guarantees on the ordering of values inside the
599     * array, and it may change when more values are added or removed.
600     *
601     * Requirements:
602     *
603     * - `index` must be strictly less than {length}.
604     */
605     function get(AddressSet storage set, uint256 index)
606         internal
607         view
608         returns (address)
609     {
610         return set.values[index];
611     }
612 }
613 
614 // File: @openzeppelin/contracts/access/AccessControl.sol
615 
616 pragma solidity ^0.6.0;
617 
618 
619 
620 /**
621  * @dev Contract module that allows children to implement role-based access
622  * control mechanisms.
623  *
624  * Roles are referred to by their `bytes32` identifier. These should be exposed
625  * in the external API and be unique. The best way to achieve this is by
626  * using `public constant` hash digests:
627  *
628  * ```
629  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
630  * ```
631  *
632  * Roles can be used to represent a set of permissions. To restrict access to a
633  * function call, use {hasRole}:
634  *
635  * ```
636  * function foo() public {
637  *     require(hasRole(MY_ROLE, _msgSender()));
638  *     ...
639  * }
640  * ```
641  *
642  * Roles can be granted and revoked programatically by calling the `internal`
643  * {_grantRole} and {_revokeRole} functions.
644  *
645  * This can also be achieved dynamically via the `external` {grantRole} and
646  * {revokeRole} functions. Each role has an associated admin role, and only
647  * accounts that have a role's admin role can call {grantRole} and {revokeRoke}.
648  *
649  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
650  * that only accounts with this role will be able to grant or revoke other
651  * roles. More complex role relationships can be created by using
652  * {_setRoleAdmin}.
653  */
654 abstract contract AccessControl is Context {
655     using EnumerableSet for EnumerableSet.AddressSet;
656 
657     struct RoleData {
658         EnumerableSet.AddressSet members;
659         bytes32 adminRole;
660     }
661 
662     mapping (bytes32 => RoleData) private _roles;
663 
664     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
665 
666     /**
667      * @dev Emitted when `account` is granted `role`.
668      *
669      * `sender` is the account that originated the contract call:
670      *   - if using `grantRole`, it is the admin role bearer
671      *   - if using `_grantRole`, its meaning is system-dependent
672      */
673     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
674 
675     /**
676      * @dev Emitted when `account` is revoked `role`.
677      *
678      * `sender` is the account that originated the contract call:
679      *   - if using `revokeRole`, it is the admin role bearer
680      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
681      *   - if using `_renounceRole`, its meaning is system-dependent
682      */
683     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
684 
685     /**
686      * @dev Returns `true` if `account` has been granted `role`.
687      */
688     function hasRole(bytes32 role, address account) public view returns (bool) {
689         return _roles[role].members.contains(account);
690     }
691 
692     /**
693      * @dev Returns the number of accounts that have `role`. Can be used
694      * together with {getRoleMember} to enumerate all bearers of a role.
695      */
696     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
697         return _roles[role].members.length();
698     }
699 
700     /**
701      * @dev Returns one of the accounts that have `role`. `index` must be a
702      * value between 0 and {getRoleMemberCount}, non-inclusive.
703      *
704      * Role bearers are not sorted in any particular way, and their ordering may
705      * change at any point.
706      *
707      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
708      * you perform all queries on the same block. See the following
709      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
710      * for more information.
711      */
712     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
713         return _roles[role].members.get(index);
714     }
715 
716     /**
717      * @dev Returns the admin role that controls `role`. See {grantRole} and
718      * {revokeRole}.
719      *
720      * To change a role's admin, use {_setRoleAdmin}.
721      */
722     function getRoleAdmin(bytes32 role) external view returns (bytes32) {
723         return _roles[role].adminRole;
724     }
725 
726     /**
727      * @dev Grants `role` to `account`.
728      *
729      * Calls {_grantRole} internally.
730      *
731      * Requirements:
732      *
733      * - the caller must have `role`'s admin role.
734      */
735     function grantRole(bytes32 role, address account) external virtual {
736         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
737 
738         _grantRole(role, account);
739     }
740 
741     /**
742      * @dev Revokes `role` from `account`.
743      *
744      * Calls {_revokeRole} internally.
745      *
746      * Requirements:
747      *
748      * - the caller must have `role`'s admin role.
749      */
750     function revokeRole(bytes32 role, address account) external virtual {
751         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
752 
753         _revokeRole(role, account);
754     }
755 
756     /**
757      * @dev Revokes `role` from the calling account.
758      *
759      * Roles are often managed via {grantRole} and {revokeRole}: this function's
760      * purpose is to provide a mechanism for accounts to lose their privileges
761      * if they are compromised (such as when a trusted device is misplaced).
762      *
763      * Requirements:
764      *
765      * - the caller must be `account`.
766      */
767     function renounceRole(bytes32 role, address account) external virtual {
768         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
769 
770         _revokeRole(role, account);
771     }
772 
773     /**
774      * @dev Grants `role` to `account`.
775      *
776      * If `account` had not been already granted `role`, emits a {RoleGranted}
777      * event.
778      */
779     function _grantRole(bytes32 role, address account) internal virtual {
780         if (_roles[role].members.add(account)) {
781             emit RoleGranted(role, account, _msgSender());
782         }
783     }
784 
785     /**
786      * @dev Revokes `role` from `account`.
787      *
788      * If `account` had been granted `role`, emits a {RoleRevoked} event.
789      */
790     function _revokeRole(bytes32 role, address account) internal virtual {
791         if (_roles[role].members.remove(account)) {
792             emit RoleRevoked(role, account, _msgSender());
793         }
794     }
795 
796     /**
797      * @dev Sets `adminRole` as `role`'s admin role.
798      */
799     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
800         _roles[role].adminRole = adminRole;
801     }
802 }
803 
804 // File: contracts/EphimeraAccessControls.sol
805 
806 pragma solidity 0.6.12;
807 
808 
809 contract EphimeraAccessControls is AccessControl {
810     // Role definitions
811     bytes32 public constant GALLERY_ROLE = keccak256("GALLERY_ROLE");
812     bytes32 public constant CREATOR_ROLE = keccak256("CREATOR_ROLE");
813     bytes32 public constant CONTRACT_WHITELIST_ROLE = keccak256(
814         "CONTRACT_WHITELIST_ROLE"
815     );
816 
817     // Relationship mappings
818     mapping(address => mapping(address => bool)) public galleryToArtistMapping;
819     mapping(address => mapping(address => bool))
820         public artistToGalleriesMapping;
821 
822     // Events
823     event ArtistAddedToGallery(
824         address indexed gallery,
825         address indexed artist,
826         address indexed caller
827     );
828 
829     event ArtistRemovedFromGallery(
830         address indexed gallery,
831         address indexed artist,
832         address indexed caller
833     );
834 
835     event NewAdminAdded(address indexed admin);
836 
837     event AdminRemoved(address indexed admin);
838 
839     event NewArtistAdded(address indexed artist);
840 
841     event ArtistRemoved(address indexed artist);
842 
843     event NewGalleryAdded(address indexed gallery);
844 
845     event GalleryRemoved(address indexed gallery);
846 
847     constructor() public {
848         _grantRole(DEFAULT_ADMIN_ROLE, _msgSender());
849     }
850 
851     /////////////
852     // Lookups //
853     /////////////
854 
855     function hasGalleryRole(address _address) public view returns (bool) {
856         return hasRole(GALLERY_ROLE, _address);
857     }
858 
859     function hasCreatorRole(address _address) public view returns (bool) {
860         return hasRole(CREATOR_ROLE, _address);
861     }
862 
863     function hasAdminRole(address _address) public view returns (bool) {
864         return hasRole(DEFAULT_ADMIN_ROLE, _address);
865     }
866 
867     function hasContractWhitelistRole(address _address)
868         public
869         view
870         returns (bool)
871     {
872         return hasRole(CONTRACT_WHITELIST_ROLE, _address);
873     }
874 
875     function isArtistPartOfGallery(address _gallery, address _artist)
876         public
877         view
878         returns (bool)
879     {
880         return galleryToArtistMapping[_gallery][_artist];
881     }
882 
883     ///////////////
884     // Modifiers //
885     ///////////////
886 
887     modifier onlyAdminRole() {
888         require(
889             hasRole(DEFAULT_ADMIN_ROLE, _msgSender()),
890             "EphimeraAccessControls: sender must be an admin"
891         );
892         _;
893     }
894 
895     function addAdminRole(address _address) public onlyAdminRole {
896         require(
897             !hasAdminRole(_address),
898             "EphimeraAccessControls: Account already has an admin role"
899         );
900         _grantRole(DEFAULT_ADMIN_ROLE, _address);
901         emit NewAdminAdded(_address);
902     }
903 
904     function removeAdminRole(address _address) public onlyAdminRole {
905         require(
906             hasAdminRole(_address),
907             "EphimeraAccessControls: Account is not an admin"
908         );
909         _revokeRole(DEFAULT_ADMIN_ROLE, _address);
910         emit AdminRemoved(_address);
911     }
912 
913     function addContractWhitelistRole(address _address) public onlyAdminRole {
914         require(
915             !hasContractWhitelistRole(_address),
916             "EphimeraAccessControls: Address has contractWhitelist role"
917         );
918         _grantRole(CONTRACT_WHITELIST_ROLE, _address);
919     }
920 
921     function removeContractWhitelistRole(address _address)
922         public
923         onlyAdminRole
924     {
925         require(
926             hasContractWhitelistRole(_address),
927             "EphimeraAccessControls: Address must have contractWhitelist role"
928         );
929         _revokeRole(CONTRACT_WHITELIST_ROLE, _address);
930     }
931 
932     function addGalleryRole(address _address) public onlyAdminRole {
933         require(
934             !hasCreatorRole(_address),
935             "EphimeraAccessControls: Address already has creator role and cannot have gallery role at the same time"
936         );
937         require(
938             !hasGalleryRole(_address),
939             "EphimeraAccessControls: Address already has gallery role"
940         );
941 
942         _grantRole(GALLERY_ROLE, _address);
943         emit NewGalleryAdded(_address);
944     }
945 
946     function removeGalleryRole(address _address) public onlyAdminRole {
947         require(
948             hasGalleryRole(_address),
949             "EphimeraAccessControls: Address must have gallery role"
950         );
951         _revokeRole(GALLERY_ROLE, _address);
952         emit GalleryRemoved(_address);
953     }
954 
955     function addCreatorRole(address _address) public onlyAdminRole {
956         require(
957             !hasGalleryRole(_address),
958             "EphimeraAccessControls: Address already has gallery role and cannot have creator role at the same time"
959         );
960 
961         require(
962             !hasCreatorRole(_address),
963             "EphimeraAccessControls: Address already has creator role"
964         );
965 
966         _grantRole(CREATOR_ROLE, _address);
967         emit NewArtistAdded(_address);
968     }
969 
970     function removeCreatorRole(address _address) public onlyAdminRole {
971         require(
972             hasCreatorRole(_address),
973             "EphimeraAccessControls: Address must have creator role"
974         );
975         _revokeRole(CREATOR_ROLE, _address);
976         emit ArtistRemoved(_address);
977     }
978 
979     /* Allows the DEFAULT_ADMIN_ROLE that controls all roles to be overridden thereby creating hierarchies */
980     function setRoleAdmin(bytes32 _role, bytes32 _adminRole)
981         external
982         onlyAdminRole
983     {
984         _setRoleAdmin(_role, _adminRole);
985     }
986 
987     function addArtistToGallery(address _gallery, address _artist)
988         external
989         onlyAdminRole
990     {
991         require(
992             hasRole(GALLERY_ROLE, _gallery),
993             "EphimeraAccessControls: Gallery address specified does not have the gallery role"
994         );
995         require(
996             hasRole(CREATOR_ROLE, _artist),
997             "EphimeraAccessControls: Artist address specified does not have the creator role"
998         );
999         require(
1000             !isArtistPartOfGallery(_gallery, _artist),
1001             "EphimeraAccessControls: Artist cannot be added twice to one gallery"
1002         );
1003         galleryToArtistMapping[_gallery][_artist] = true;
1004         artistToGalleriesMapping[_artist][_gallery] = true;
1005 
1006         emit ArtistAddedToGallery(_gallery, _artist, _msgSender());
1007     }
1008 
1009     function removeArtistFromGallery(address _gallery, address _artist)
1010         external
1011         onlyAdminRole
1012     {
1013         require(
1014             isArtistPartOfGallery(_gallery, _artist),
1015             "EphimeraAccessControls: Artist is not part of the gallery"
1016         );
1017         galleryToArtistMapping[_gallery][_artist] = false;
1018         artistToGalleriesMapping[_artist][_gallery] = false;
1019 
1020         emit ArtistRemovedFromGallery(_gallery, _artist, _msgSender());
1021     }
1022 }
1023 
1024 // File: contracts/EphimeraToken.sol
1025 
1026 pragma solidity 0.6.12;
1027 
1028 /**
1029  * @title Ephimera Token contract (ephimera.com)
1030  * @author Ephimera 
1031  * @dev Ephimera's ERC-721 contract
1032  */
1033 contract EphimeraToken is IERC721Token, ERC165, Context {
1034     using SafeMath for uint256;
1035 
1036     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1037     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1038 
1039     // Function selector for ERC721Receiver.onERC721Received 0x150b7a02
1040     bytes4 constant internal ERC721_RECEIVED = bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));
1041 
1042     /// @dev the first token ID is 1
1043     uint256 public tokenPointer; 
1044 
1045     // Token name
1046     string public name = "Ephimera";
1047 
1048     // Token symbol
1049     string public symbol = "EPH";
1050 
1051     uint256 public totalSupply;
1052 
1053     // Mapping of tokenId => owner
1054     mapping(uint256 => address) internal owners;
1055 
1056     // Mapping of tokenId => approved address
1057     mapping(uint256 => address) internal approvals;
1058 
1059     // Mapping of owner => number of tokens owned
1060     mapping(address => uint256) internal balances;
1061 
1062     // Mapping of owner => operator => approved
1063     mapping(address => mapping(address => bool)) internal operatorApprovals;
1064 
1065     // Optional mapping for token URIs
1066     mapping(uint256 => string) internal tokenURIs;
1067 
1068     mapping(uint256 => uint256) public tokenTransferCount;
1069 
1070     EphimeraAccessControls public accessControls;
1071 
1072     constructor (EphimeraAccessControls _accessControls) public {
1073         accessControls = _accessControls;
1074 
1075         _registerInterface(_INTERFACE_ID_ERC721);
1076         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1077     }
1078 
1079     function isContract(address account) internal view returns (bool) {
1080         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
1081         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
1082         // for accounts without code, i.e. `keccak256('')`
1083         bytes32 codehash;
1084         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
1085         // solhint-disable-next-line no-inline-assembly
1086         assembly {codehash := extcodehash(account)}
1087         return (codehash != accountHash && codehash != 0x0);
1088     }
1089 
1090     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1091     private returns (bool)
1092     {
1093         if (!isContract(to)) {
1094             return true;
1095         }
1096         // solhint-disable-next-line avoid-low-level-calls
1097         (bool success, bytes memory returndata) = to.call(abi.encodeWithSelector(
1098                 IERC721Receiver(to).onERC721Received.selector,
1099                 _msgSender(),
1100                 from,
1101                 tokenId,
1102                 _data
1103             ));
1104         if (!success) {
1105             if (returndata.length > 0) {
1106                 // solhint-disable-next-line no-inline-assembly
1107                 assembly {
1108                     let returndata_size := mload(returndata)
1109                     revert(add(32, returndata), returndata_size)
1110                 }
1111             } else {
1112                 revert("ERC721: transfer to non ERC721Receiver implementer");
1113             }
1114         } else {
1115             bytes4 retval = abi.decode(returndata, (bytes4));
1116             return (retval == ERC721_RECEIVED);
1117         }
1118     }
1119 
1120     /// @notice sets URI of token metadata (e.g. IPFS hash of a token)
1121     /// @dev links an NFT to metadata URI
1122     /// @param _tokenId the identifier for an NFT 
1123     /// @param _uri data that the NFT is representing
1124     function setTokenURI(uint256 _tokenId, string calldata _uri) external {
1125         require(owners[_tokenId] != address(0), "EphimeraToken.setTokenURI: token does not exist.");
1126         require(accessControls.hasAdminRole(_msgSender()), "EphimeraToken.setTokenURI: caller is not a admin.");
1127         tokenURIs[_tokenId] = _uri;
1128     }
1129 
1130     /// @notice creates a new Ephimera art piece
1131     /// @dev mints a new NFT
1132     /// @param _to the address that the NFT is going to be issued to
1133     /// @param _uri data that the NFT is representing
1134     /// @return return an NFT id
1135     function mint(
1136         address _to,
1137         string calldata _uri
1138     ) external returns (uint256) {
1139         require(_to != address(0), "ERC721: mint to the zero address");
1140         require(accessControls.hasContractWhitelistRole(_msgSender()), "EphimeraToken.mint: caller is not whitelisted.");
1141 
1142         tokenPointer = tokenPointer.add(1);
1143         uint256 tokenId = tokenPointer;
1144 
1145         // Mint
1146         owners[tokenId] = _to;
1147         balances[_to] = balances[_to].add(1);
1148 
1149         // MetaData
1150         tokenURIs[tokenId] = _uri;
1151         totalSupply = totalSupply.add(1);
1152 
1153         tokenTransferCount[tokenId] = 1;
1154 
1155         // Single Transfer event for a single token
1156         emit Transfer(address(0), _to, tokenId);
1157 
1158         return tokenId;
1159     }
1160 
1161     /// @notice gets the data URI of a token
1162     /// @dev queries an NFT's URI
1163     /// @param _tokenId the identifier for an NFT
1164     /// @return return an NFT's tokenURI 
1165     function tokenURI(uint256 _tokenId) external view returns (string memory) {
1166         return tokenURIs[_tokenId];
1167     }
1168 
1169     /// @notice checks if an art exists
1170     /// @dev checks if an NFT exists
1171     /// @param _tokenId the identifier for an NFT 
1172     /// @return returns true if an NFT exists, else returns false
1173     function exists(uint256 _tokenId) external view returns (bool) {
1174         return owners[_tokenId] != address(0);
1175     }
1176 
1177     /// @notice allows owner and only owner of an art piece to delete it. 
1178     ///     This token will be gone forever; USE WITH CARE
1179     /// @dev owner can burn an NFT
1180     /// @param _tokenId the identifier for an NFT 
1181     function burn(uint256 _tokenId) external {
1182         require(_msgSender() == ownerOf(_tokenId), 
1183             "EphimeraToken.burn: Caller must be owner."
1184         );
1185         _burn(_tokenId);
1186     }
1187 
1188     function _burn(uint256 _tokenId)
1189     internal
1190     {
1191         address owner = owners[_tokenId];
1192         require(
1193             owner != address(0),
1194             "ERC721_ZERO_OWNER_ADDRESS"
1195         );
1196 
1197         owners[_tokenId] = address(0);
1198         balances[owner] = balances[owner].sub(1);
1199         totalSupply = totalSupply.sub(1);
1200 
1201         // clear metadata
1202         if (bytes(tokenURIs[_tokenId]).length != 0) {
1203             delete tokenURIs[_tokenId];
1204         }
1205 
1206         emit Transfer(
1207             owner,
1208             address(0),
1209             _tokenId
1210         );
1211     }
1212 
1213     /// @notice transfers the ownership of an NFT from one address to another address
1214     /// @dev wrapper function for the safeTransferFrom function below setting data to "".
1215     /// @param _from the current owner of the NFT
1216     /// @param _to the new owner
1217     /// @param _tokenId the identifier for the NFT to transfer
1218     function safeTransferFrom(address _from, address _to, uint256 _tokenId) override public {
1219         safeTransferFrom(_from, _to, _tokenId, "");
1220     }
1221 
1222     /// @notice transfers the ownership of an NFT from one address to another address
1223     /// @dev throws unless `msg.sender` is the current owner, an authorized
1224     ///      operator, or the approved address for this NFT. Throws if `_from` is
1225     ///      not the current owner. Throws if `_to` is the zero address. Throws if
1226     ///      `_tokenId` is not a valid NFT. When transfer is complete, this function
1227     ///      checks if `_to` is a smart contract (code size > 0). If so, it calls
1228     ///      `onERC721Received` on `_to` and throws if the return value is not
1229     ///      `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
1230     /// @param _from the current owner of the NFT
1231     /// @param _to the new owner
1232     /// @param _tokenId the identifier for the NFT to transfer
1233     /// @param _data additional data with no specified format; sent in call to `_to`
1234     function safeTransferFrom(
1235         address _from,
1236         address _to,
1237         uint256 _tokenId,
1238         bytes memory _data
1239     )
1240     override
1241     public
1242     {
1243         transferFrom(_from, _to, _tokenId);
1244         require(_checkOnERC721Received(_from, _to, _tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1245     }
1246 
1247     /// @notice change or reaffirm the approved address for an NFT
1248     /// @dev the zero address indicates there is no approved address.
1249     ///      Throws unless `msg.sender` is the current NFT owner, or an authorized
1250     ///      operator of the current owner.
1251     /// @param _approved the new approved NFT controller
1252     /// @param _tokenId the identifier of the NFT to approve
1253     function approve(address _approved, uint256 _tokenId)
1254     override
1255     external
1256     {
1257         address owner = ownerOf(_tokenId);
1258         require(_approved != owner, "ERC721: approval to current owner");
1259         
1260         require(
1261             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1262             "ERC721: approve caller is not owner nor approved for all"
1263         );
1264 
1265         approvals[_tokenId] = _approved;
1266         emit Approval(
1267             owner,
1268             _approved,
1269             _tokenId
1270         );
1271     }
1272 
1273     /// @notice enable or disable approval for a third party ("operator") to manage
1274     ///         all of `msg.sender`'s assets
1275     /// @dev emits the ApprovalForAll event. The contract MUST allow
1276     ///      multiple operators per owner.
1277     /// @param _operator address to add to the set of authorized operators
1278     /// @param _approved true if the operator is approved, false to revoke approval
1279     function setApprovalForAll(address _operator, bool _approved)
1280     override
1281     external
1282     {
1283         require(_operator != _msgSender(), "ERC721: approve to caller");
1284 
1285         operatorApprovals[_msgSender()][_operator] = _approved;
1286         emit ApprovalForAll(
1287             _msgSender(),
1288             _operator,
1289             _approved
1290         );
1291     }
1292 
1293     /// @notice count all NFTs assigned to an owner
1294     /// @dev NFTs assigned to the zero address are considered invalid, and this
1295     ///      function throws for queries about the zero address.
1296     /// @param _owner an address to query
1297     /// @return the number of NFTs owned by `_owner`, possibly zero
1298     function balanceOf(address _owner)
1299     override
1300     external
1301     view
1302     returns (uint256)
1303     {
1304         require(
1305             _owner != address(0),
1306             "ERC721: owner query for nonexistent token"
1307         );
1308         return balances[_owner];
1309     }
1310 
1311     /// @notice transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
1312     ///         TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
1313     ///         THEY MAY BE PERMANENTLY LOST
1314     /// @dev throws unless `msg.sender` is the current owner, an authorized
1315     ///      operator, or the approved address for this NFT. Throws if `_from` is
1316     ///      not the current owner. Throws if `_to` is the zero address. Throws if
1317     ///      `_tokenId` is not a valid NFT.
1318     /// @param _from the current owner of the NFT
1319     /// @param _to the new owner
1320     /// @param _tokenId the identifier of the NFT to transfer
1321     function transferFrom(
1322         address _from,
1323         address _to,
1324         uint256 _tokenId
1325     )
1326     override
1327     public
1328     {
1329         require(
1330             _to != address(0),
1331             "ERC721_ZERO_TO_ADDRESS"
1332         );
1333 
1334         address owner = ownerOf(_tokenId);
1335         require(
1336             _from == owner,
1337             "ERC721_OWNER_MISMATCH"
1338         );
1339 
1340         address spender = _msgSender();
1341         address approvedAddress = getApproved(_tokenId);
1342         require(
1343             spender == owner ||
1344             isApprovedForAll(owner, spender) ||
1345             approvedAddress == spender,
1346             "ERC721_INVALID_SPENDER"
1347         );
1348 
1349         if (approvedAddress != address(0)) {
1350             approvals[_tokenId] = address(0);
1351         }
1352 
1353         owners[_tokenId] = _to;
1354         balances[_from] = balances[_from].sub(1);
1355         balances[_to] = balances[_to].add(1);
1356 
1357         tokenTransferCount[_tokenId] = tokenTransferCount[_tokenId].add(1);
1358 
1359         emit Transfer(
1360             _from,
1361             _to,
1362             _tokenId
1363         );
1364     }
1365 
1366     /// @notice find the owner of an NFT
1367     /// @dev NFTs assigned to zero address are considered invalid, and queries
1368     ///      about them do throw.
1369     /// @param _tokenId the identifier for an NFT
1370     /// @return the address of the owner of the NFT
1371     function ownerOf(uint256 _tokenId)
1372     override
1373     public
1374     view
1375     returns (address)
1376     {
1377         address owner = owners[_tokenId];
1378         require(
1379             owner != address(0),
1380             "ERC721: owner query for nonexistent token"
1381         );
1382         return owner;
1383     }
1384 
1385     /// @notice get the approved address for a single NFT
1386     /// @dev throws if `_tokenId` is not a valid NFT.
1387     /// @param _tokenId the NFT to find the approved address for
1388     /// @return the approved address for this NFT, or the zero address if there is none
1389     function getApproved(uint256 _tokenId)
1390     override
1391     public
1392     view
1393     returns (address)
1394     {
1395         require(owners[_tokenId] != address(0), "ERC721: approved query for nonexistent token");
1396         return approvals[_tokenId];
1397     }
1398 
1399     /// @notice query if an address is an authorized operator for another address
1400     /// @param _owner the address that owns the NFTs
1401     /// @param _operator the address that acts on behalf of the owner
1402     /// @return true if `_operator` is an approved operator for `_owner`, false otherwise
1403     function isApprovedForAll(address _owner, address _operator)
1404     override
1405     public
1406     view
1407     returns (bool)
1408     {
1409         return operatorApprovals[_owner][_operator];
1410     }
1411 }