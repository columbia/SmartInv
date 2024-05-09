1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 /**
27  * @dev Interface of the ERC165 standard, as defined in the
28  * https://eips.ethereum.org/EIPS/eip-165[EIP].
29  *
30  * Implementers can declare support of contract interfaces, which can then be
31  * queried by others ({ERC165Checker}).
32  *
33  * For an implementation, see {ERC165}.
34  */
35 interface IERC165 {
36     /**
37      * @dev Returns true if this contract implements the interface defined by
38      * `interfaceId`. See the corresponding
39      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
40      * to learn more about how these ids are created.
41      *
42      * This function call must use less than 30 000 gas.
43      */
44     function supportsInterface(bytes4 interfaceId) external view returns (bool);
45 }
46 
47 /**
48  * @dev Implementation of the {IERC165} interface.
49  *
50  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
51  * for the additional interface id that will be supported. For example:
52  *
53  * ```solidity
54  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
55  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
56  * }
57  * ```
58  *
59  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
60  */
61 abstract contract ERC165 is IERC165 {
62     /**
63      * @dev See {IERC165-supportsInterface}.
64      */
65     function supportsInterface(bytes4 interfaceId)
66         public
67         view
68         virtual
69         override
70         returns (bool)
71     {
72         return interfaceId == type(IERC165).interfaceId;
73     }
74 }
75 
76 /**
77  * @dev External interface of AccessControl declared to support ERC165 detection.
78  */
79 interface IAccessControl {
80     function hasRole(bytes32 role, address account)
81         external
82         view
83         returns (bool);
84 
85     function getRoleAdmin(bytes32 role) external view returns (bytes32);
86 
87     function grantRole(bytes32 role, address account) external;
88 
89     function revokeRole(bytes32 role, address account) external;
90 
91     function renounceRole(bytes32 role, address account) external;
92 }
93 
94 /**
95  * @dev Contract module that allows children to implement role-based access
96  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
97  * members except through off-chain means by accessing the contract event logs. Some
98  * applications may benefit from on-chain enumerability, for those cases see
99  * {AccessControlEnumerable}.
100  *
101  * Roles are referred to by their `bytes32` identifier. These should be exposed
102  * in the external API and be unique. The best way to achieve this is by
103  * using `public constant` hash digests:
104  *
105  * ```
106  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
107  * ```
108  *
109  * Roles can be used to represent a set of permissions. To restrict access to a
110  * function call, use {hasRole}:
111  *
112  * ```
113  * function foo() public {
114  *     require(hasRole(MY_ROLE, msg.sender));
115  *     ...
116  * }
117  * ```
118  *
119  * Roles can be granted and revoked dynamically via the {grantRole} and
120  * {revokeRole} functions. Each role has an associated admin role, and only
121  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
122  *
123  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
124  * that only accounts with this role will be able to grant or revoke other
125  * roles. More complex role relationships can be created by using
126  * {_setRoleAdmin}.
127  *
128  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
129  * grant and revoke this role. Extra precautions should be taken to secure
130  * accounts that have been granted it.
131  */
132 abstract contract AccessControl is Context, IAccessControl, ERC165 {
133     struct RoleData {
134         mapping(address => bool) members;
135         bytes32 adminRole;
136     }
137 
138     mapping(bytes32 => RoleData) private _roles;
139 
140     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
141 
142     /**
143      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
144      *
145      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
146      * {RoleAdminChanged} not being emitted signaling this.
147      *
148      * _Available since v3.1._
149      */
150     event RoleAdminChanged(
151         bytes32 indexed role,
152         bytes32 indexed previousAdminRole,
153         bytes32 indexed newAdminRole
154     );
155 
156     /**
157      * @dev Emitted when `account` is granted `role`.
158      *
159      * `sender` is the account that originated the contract call, an admin role
160      * bearer except when using {_setupRole}.
161      */
162     event RoleGranted(
163         bytes32 indexed role,
164         address indexed account,
165         address indexed sender
166     );
167 
168     /**
169      * @dev Emitted when `account` is revoked `role`.
170      *
171      * `sender` is the account that originated the contract call:
172      *   - if using `revokeRole`, it is the admin role bearer
173      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
174      */
175     event RoleRevoked(
176         bytes32 indexed role,
177         address indexed account,
178         address indexed sender
179     );
180 
181     /**
182      * @dev See {IERC165-supportsInterface}.
183      */
184     function supportsInterface(bytes4 interfaceId)
185         public
186         view
187         virtual
188         override
189         returns (bool)
190     {
191         return
192             interfaceId == type(IAccessControl).interfaceId ||
193             super.supportsInterface(interfaceId);
194     }
195 
196     /**
197      * @dev Returns `true` if `account` has been granted `role`.
198      */
199     function hasRole(bytes32 role, address account)
200         public
201         view
202         override
203         returns (bool)
204     {
205         return _roles[role].members[account];
206     }
207 
208     /**
209      * @dev Returns the admin role that controls `role`. See {grantRole} and
210      * {revokeRole}.
211      *
212      * To change a role's admin, use {_setRoleAdmin}.
213      */
214     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
215         return _roles[role].adminRole;
216     }
217 
218     /**
219      * @dev Grants `role` to `account`.
220      *
221      * If `account` had not been already granted `role`, emits a {RoleGranted}
222      * event.
223      *
224      * Requirements:
225      *
226      * - the caller must have ``role``'s admin role.
227      */
228     function grantRole(bytes32 role, address account) public virtual override {
229         require(
230             hasRole(getRoleAdmin(role), _msgSender()),
231             "AccessControl: sender must be an admin to grant"
232         );
233 
234         _grantRole(role, account);
235     }
236 
237     /**
238      * @dev Revokes `role` from `account`.
239      *
240      * If `account` had been granted `role`, emits a {RoleRevoked} event.
241      *
242      * Requirements:
243      *
244      * - the caller must have ``role``'s admin role.
245      */
246     function revokeRole(bytes32 role, address account) public virtual override {
247         require(
248             hasRole(getRoleAdmin(role), _msgSender()),
249             "AccessControl: sender must be an admin to revoke"
250         );
251 
252         _revokeRole(role, account);
253     }
254 
255     /**
256      * @dev Revokes `role` from the calling account.
257      *
258      * Roles are often managed via {grantRole} and {revokeRole}: this function's
259      * purpose is to provide a mechanism for accounts to lose their privileges
260      * if they are compromised (such as when a trusted device is misplaced).
261      *
262      * If the calling account had been granted `role`, emits a {RoleRevoked}
263      * event.
264      *
265      * Requirements:
266      *
267      * - the caller must be `account`.
268      */
269     function renounceRole(bytes32 role, address account)
270         public
271         virtual
272         override
273     {
274         require(
275             account == _msgSender(),
276             "AccessControl: can only renounce roles for self"
277         );
278 
279         _revokeRole(role, account);
280     }
281 
282     /**
283      * @dev Grants `role` to `account`.
284      *
285      * If `account` had not been already granted `role`, emits a {RoleGranted}
286      * event. Note that unlike {grantRole}, this function doesn't perform any
287      * checks on the calling account.
288      *
289      * [WARNING]
290      * ====
291      * This function should only be called from the constructor when setting
292      * up the initial roles for the system.
293      *
294      * Using this function in any other way is effectively circumventing the admin
295      * system imposed by {AccessControl}.
296      * ====
297      */
298     function _setupRole(bytes32 role, address account) internal virtual {
299         _grantRole(role, account);
300     }
301 
302     /**
303      * @dev Sets `adminRole` as ``role``'s admin role.
304      *
305      * Emits a {RoleAdminChanged} event.
306      */
307     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
308         emit RoleAdminChanged(role, getRoleAdmin(role), adminRole);
309         _roles[role].adminRole = adminRole;
310     }
311 
312     function _grantRole(bytes32 role, address account) private {
313         if (!hasRole(role, account)) {
314             _roles[role].members[account] = true;
315             emit RoleGranted(role, account, _msgSender());
316         }
317     }
318 
319     function _revokeRole(bytes32 role, address account) private {
320         if (hasRole(role, account)) {
321             _roles[role].members[account] = false;
322             emit RoleRevoked(role, account, _msgSender());
323         }
324     }
325 }
326 
327 interface ISatoshiART1155 {
328     event TransferSingle(
329         address indexed operator,
330         address indexed from,
331         address indexed to,
332         uint256 id,
333         uint256 value
334     );
335     event TransferBatch(
336         address indexed operator,
337         address indexed from,
338         address indexed to,
339         uint256[] ids,
340         uint256[] values
341     );
342     event ApprovalForAll(
343         address indexed account,
344         address indexed operator,
345         bool approved
346     );
347     event URI(string value, uint256 indexed id);
348 
349     function balanceOf(address account, uint256 id)
350         external
351         view
352         returns (uint256);
353 
354     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
355         external
356         view
357         returns (uint256[] memory);
358 
359     function setApprovalForAll(address operator, bool approved) external;
360 
361     function isApprovedForAll(address account, address operator)
362         external
363         view
364         returns (bool);
365 
366     function safeTransferFrom(
367         address from,
368         address to,
369         uint256 id,
370         uint256 amount,
371         bytes calldata data
372     ) external;
373 
374     function safeBatchTransferFrom(
375         address from,
376         address to,
377         uint256[] calldata ids,
378         uint256[] calldata amounts,
379         bytes calldata data
380     ) external;
381 
382     function tokenCreator(uint256 _id) external view returns (address);
383 
384     function tokenRoyalty(uint256 _id) external view returns (uint256);
385 }
386 
387 contract SatoshiART1155Marketplace is AccessControl {
388     struct Listing {
389         bytes1 status; // 0x00 onHold 0x01 onSale 0x02 isAuction
390         uint256 price;
391         uint256 startTime;
392         uint256 endTime;
393         uint256 commission;
394         bool isDropOfTheDay;
395         address highestBidder;
396         uint256 highestBid;
397     }
398 
399     mapping(uint256 => mapping(address => Listing)) private _listings;
400     ISatoshiART1155 public satoshiART1155;
401     mapping(address => uint256) private _outstandingPayments;
402     uint256 private _defaultCommission;
403     uint256 private _defaultAuctionCommission;
404     bytes32 public constant DROP_OF_THE_DAY_CREATOR_ROLE =
405         keccak256("DROP_OF_THE_DAY_CREATOR_ROLE");
406     address private _commissionReceiver;
407 
408     event PurchaseConfirmed(uint256 tokenId, address itemOwner, address buyer);
409     event PaymentWithdrawed(uint256 amount);
410     event HighestBidIncreased(
411         uint256 tokenId,
412         address itemOwner,
413         address bidder,
414         uint256 amount
415     );
416     event AuctionEnded(
417         uint256 tokenId,
418         address itemOwner,
419         address winner,
420         uint256 amount
421     );
422 
423     constructor(address satoshiART1155Address) {
424         satoshiART1155 = ISatoshiART1155(satoshiART1155Address);
425         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
426         _defaultCommission = 250;
427         _defaultAuctionCommission = 250;
428         _commissionReceiver = msg.sender;
429     }
430 
431     function commissionReceiver() external view returns (address) {
432         return _commissionReceiver;
433     }
434 
435     function setCommissionReceiver(address user) external returns (bool) {
436         require(
437             hasRole(DEFAULT_ADMIN_ROLE, msg.sender),
438             "Caller is not an admin"
439         );
440         _commissionReceiver = user;
441 
442         return true;
443     }
444 
445     function defaultCommission() external view returns (uint256) {
446         return _defaultCommission;
447     }
448 
449     function defaultAuctionCommission() external view returns (uint256) {
450         return _defaultAuctionCommission;
451     }
452 
453     function setDefaultCommission(uint256 commission) external returns (bool) {
454         require(
455             hasRole(DEFAULT_ADMIN_ROLE, msg.sender),
456             "Caller is not an admin"
457         );
458         require(commission <= 3000, "commission is too high");
459         _defaultCommission = commission;
460 
461         return true;
462     }
463 
464     function setDefaultAuctionCommission(uint256 commission)
465         external
466         returns (bool)
467     {
468         require(
469             hasRole(DEFAULT_ADMIN_ROLE, msg.sender),
470             "Caller is not an admin"
471         );
472         require(commission <= 3000, "commission is too high");
473         _defaultAuctionCommission = commission;
474 
475         return true;
476     }
477 
478     function setListing(
479         uint256 tokenId,
480         bytes1 status,
481         uint256 price,
482         uint256 startTime,
483         uint256 endTime,
484         uint256 dropOfTheDayCommission,
485         bool isDropOfTheDay
486     ) external {
487         require(
488             satoshiART1155.balanceOf(msg.sender, tokenId) >= 1,
489             "Set listing: you are trying to sell more than you have"
490         );
491 
492         if (status == 0x00) {
493             require(
494                 _listings[tokenId][msg.sender].highestBidder == address(0),
495                 "Set listing: bid already exists"
496             );
497 
498             _listings[tokenId][msg.sender] = Listing({
499                 status: status,
500                 price: 0,
501                 startTime: 0,
502                 endTime: 0,
503                 commission: 0,
504                 isDropOfTheDay: false,
505                 highestBidder: address(0),
506                 highestBid: 0
507             });
508         } else if (isDropOfTheDay) {
509             require(
510                 hasRole(DROP_OF_THE_DAY_CREATOR_ROLE, msg.sender),
511                 "Set listing: Caller is not a drop of the day creator"
512             );
513             require(
514                 _listings[tokenId][msg.sender].status == 0x00,
515                 "Set listing: token not on hold"
516             );
517             require(
518                 dropOfTheDayCommission <= 3000,
519                 "Set drop of the day listing: commission is too high"
520             );
521             require(
522                 block.timestamp < startTime && startTime < endTime,
523                 "endTime should be greater than startTime. startTime should be greater than current time"
524             );
525 
526             _listings[tokenId][msg.sender] = Listing({
527                 status: status,
528                 price: price,
529                 startTime: startTime,
530                 endTime: endTime,
531                 commission: dropOfTheDayCommission,
532                 isDropOfTheDay: isDropOfTheDay,
533                 highestBidder: address(0),
534                 highestBid: 0
535             });
536         } else if (status == 0x01) {
537             require(
538                 _listings[tokenId][msg.sender].status == 0x00,
539                 "Set listing: token not on hold"
540             );
541 
542             _listings[tokenId][msg.sender] = Listing({
543                 status: status,
544                 price: price,
545                 startTime: 0,
546                 endTime: 0,
547                 commission: _defaultCommission,
548                 isDropOfTheDay: false,
549                 highestBidder: address(0),
550                 highestBid: 0
551             });
552         } else if (status == 0x02) {
553             require(
554                 _listings[tokenId][msg.sender].status == 0x00,
555                 "Set listing: token not on hold"
556             );
557             require(
558                 block.timestamp < startTime && startTime < endTime,
559                 "endTime should be greater than startTime. startTime should be greater than current time"
560             );
561 
562             _listings[tokenId][msg.sender] = Listing({
563                 status: status,
564                 price: price,
565                 startTime: startTime,
566                 endTime: endTime,
567                 commission: _defaultAuctionCommission,
568                 isDropOfTheDay: false,
569                 highestBidder: address(0),
570                 highestBid: 0
571             });
572         }
573     }
574 
575     function listingOf(address account, uint256 tokenId)
576         external
577         view
578         returns (
579             bytes1,
580             uint256,
581             uint256,
582             uint256,
583             uint256,
584             bool,
585             address,
586             uint256
587         )
588     {
589         require(
590             account != address(0),
591             "ERC1155: listing query for the zero address"
592         );
593 
594         Listing memory l = _listings[tokenId][account];
595         return (
596             l.status,
597             l.price,
598             l.startTime,
599             l.endTime,
600             l.commission,
601             l.isDropOfTheDay,
602             l.highestBidder,
603             l.highestBid
604         );
605     }
606 
607     function buy(uint256 tokenId, address itemOwner)
608         external
609         payable
610         returns (bool)
611     {
612         require(
613             _listings[tokenId][itemOwner].status == 0x01,
614             "buy: token not listed for sale"
615         );
616         require(
617             satoshiART1155.balanceOf(itemOwner, tokenId) >= 1,
618             "buy: trying to buy more than owned"
619         );
620         require(
621             msg.value >= _listings[tokenId][itemOwner].price,
622             "buy: not enough fund"
623         );
624 
625         if (_listings[tokenId][itemOwner].isDropOfTheDay) {
626             require(
627                 block.timestamp >= _listings[tokenId][itemOwner].startTime &&
628                     block.timestamp <= _listings[tokenId][itemOwner].endTime,
629                 "buy (Drop of the day): drop of the day has ended/not started"
630             );
631         }
632 
633         uint256 commision =
634             (msg.value * _listings[tokenId][itemOwner].commission) / 10000;
635         uint256 royalty =
636             (msg.value * satoshiART1155.tokenRoyalty(tokenId)) / 10000;
637 
638         _listings[tokenId][itemOwner] = Listing({
639             status: 0x00,
640             price: 0,
641             startTime: 0,
642             endTime: 0,
643             commission: 0,
644             isDropOfTheDay: false,
645             highestBidder: address(0),
646             highestBid: 0
647         });
648         emit PurchaseConfirmed(tokenId, itemOwner, msg.sender);
649 
650         satoshiART1155.safeTransferFrom(
651             itemOwner,
652             msg.sender,
653             tokenId,
654             satoshiART1155.balanceOf(itemOwner, tokenId),
655             ""
656         );
657 
658         _outstandingPayments[satoshiART1155.tokenCreator(tokenId)] =
659             _outstandingPayments[satoshiART1155.tokenCreator(tokenId)] +
660             royalty;
661         _outstandingPayments[_commissionReceiver] =
662             _outstandingPayments[_commissionReceiver] +
663             commision;
664         _outstandingPayments[itemOwner] =
665             _outstandingPayments[itemOwner] +
666             (msg.value - commision - royalty);
667 
668         return true;
669     }
670 
671     function withdrawPayment() external returns (bool) {
672         uint256 amount = _outstandingPayments[msg.sender];
673         if (amount > 0) {
674             _outstandingPayments[msg.sender] = 0;
675 
676             if (!payable(msg.sender).send(amount)) {
677                 _outstandingPayments[msg.sender] = amount;
678                 return false;
679             }
680         }
681         emit PaymentWithdrawed(amount);
682         return true;
683     }
684 
685     function outstandingPayment(address user) external view returns (uint256) {
686         return _outstandingPayments[user];
687     }
688 
689     //Auction
690     function bid(uint256 tokenId, address itemOwner) external payable {
691         require(
692             _listings[tokenId][itemOwner].status == 0x02,
693             "Item not listed for auction."
694         );
695         require(
696             block.timestamp <= _listings[tokenId][itemOwner].endTime &&
697                 block.timestamp >= _listings[tokenId][itemOwner].startTime,
698             "Auction not started/already ended."
699         );
700         require(
701             msg.value > _listings[tokenId][itemOwner].highestBid,
702             "There already is a higher bid."
703         );
704 
705         if (_listings[tokenId][itemOwner].highestBid != 0) {
706             _outstandingPayments[
707                 _listings[tokenId][itemOwner].highestBidder
708             ] += _listings[tokenId][itemOwner].highestBid;
709         }
710         _listings[tokenId][itemOwner].highestBidder = msg.sender;
711         _listings[tokenId][itemOwner].highestBid = msg.value;
712         emit HighestBidIncreased(tokenId, itemOwner, msg.sender, msg.value);
713     }
714 
715     // Withdraw a bid that was overbid.
716     // use withdrawPayment()
717 
718     /// End the auction and send the highest bid
719     /// to the beneficiary.
720     function auctionEnd(uint256 tokenId, address itemOwner) external {
721         require(
722             _listings[tokenId][itemOwner].status == 0x02,
723             "Auction end: item is not for auction"
724         );
725         require(
726             block.timestamp > _listings[tokenId][itemOwner].endTime,
727             "Auction end: auction not yet ended."
728         );
729 
730         uint256 commision =
731             (_listings[tokenId][itemOwner].highestBid *
732                 _listings[tokenId][itemOwner].commission) / 10000;
733 
734         uint256 royalty =
735             (_listings[tokenId][itemOwner].highestBid *
736                 satoshiART1155.tokenRoyalty(tokenId)) / 10000;
737 
738         _listings[tokenId][itemOwner] = Listing({
739             status: 0x00,
740             price: 0,
741             startTime: 0,
742             endTime: 0,
743             commission: 0,
744             isDropOfTheDay: false,
745             highestBidder: _listings[tokenId][itemOwner].highestBidder,
746             highestBid: _listings[tokenId][itemOwner].highestBid
747         });
748         emit AuctionEnded(
749             tokenId,
750             itemOwner,
751             _listings[tokenId][itemOwner].highestBidder,
752             _listings[tokenId][itemOwner].highestBid
753         );
754 
755         satoshiART1155.safeTransferFrom(
756             itemOwner,
757             _listings[tokenId][itemOwner].highestBidder,
758             tokenId,
759             1,
760             ""
761         );
762 
763         _outstandingPayments[satoshiART1155.tokenCreator(tokenId)] =
764             _outstandingPayments[satoshiART1155.tokenCreator(tokenId)] +
765             royalty;
766         _outstandingPayments[_commissionReceiver] =
767             _outstandingPayments[_commissionReceiver] +
768             commision;
769         _outstandingPayments[itemOwner] =
770             _outstandingPayments[itemOwner] +
771             (_listings[tokenId][itemOwner].highestBid - commision - royalty);
772     }
773 
774     function setDropOfTheDayAuctionEndTime(uint256 tokenId, uint256 newEndTime)
775         external
776     {
777         require(
778             hasRole(DROP_OF_THE_DAY_CREATOR_ROLE, msg.sender),
779             "Set drop of the day auction end time: caller is not drop of the day creator."
780         );
781         require(
782             _listings[tokenId][msg.sender].status == 0x02,
783             "Item is not in auction"
784         );
785         require(
786             _listings[tokenId][msg.sender].isDropOfTheDay,
787             "Set drop of the day auction end time: item is not for drop of the day."
788         );
789         require(
790             _listings[tokenId][msg.sender].endTime < newEndTime,
791             "newEndTime not greater than current endTime."
792         );
793         _listings[tokenId][msg.sender].endTime = newEndTime;
794     }
795 
796     function transfer(uint256 tokenId, address receiver) external {
797         require(
798             satoshiART1155.balanceOf(msg.sender, tokenId) >= 1,
799             "Do not have enough token to transfer."
800         );
801         require(
802             _listings[tokenId][msg.sender].status == 0x00,
803             "Token not on hold"
804         );
805 
806         satoshiART1155.safeTransferFrom(
807             msg.sender,
808             receiver,
809             tokenId,
810             satoshiART1155.balanceOf(msg.sender, tokenId),
811             ""
812         );
813     }
814 }