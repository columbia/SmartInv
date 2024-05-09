1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 interface IERC721Receiver {
6     /**
7      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
8      * by `operator` from `from`, this function is called.
9      *
10      * It must return its Solidity selector to confirm the token transfer.
11      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
12      *
13      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
14      */
15     function onERC721Received(
16         address operator,
17         address from,
18         uint256 tokenId,
19         bytes calldata data
20     ) external returns (bytes4);
21 }
22 
23 interface IERC165 {
24     /**
25      * @dev Returns true if this contract implements the interface defined by
26      * `interfaceId`. See the corresponding
27      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
28      * to learn more about how these ids are created.
29      *
30      * This function call must use less than 30 000 gas.
31      */
32     function supportsInterface(bytes4 interfaceId) external view returns (bool);
33 }
34 
35 interface IERC721 is IERC165 {
36     /**
37      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
38      */
39     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
40 
41     /**
42      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
43      */
44     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
45 
46     /**
47      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
48      */
49     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
50 
51     /**
52      * @dev Returns the number of tokens in ``owner``'s account.
53      */
54     function balanceOf(address owner) external view returns (uint256 balance);
55 
56     /**
57      * @dev Returns the owner of the `tokenId` token.
58      *
59      * Requirements:
60      *
61      * - `tokenId` must exist.
62      */
63     function ownerOf(uint256 tokenId) external view returns (address owner);
64 
65     /**
66      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
67      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
68      *
69      * Requirements:
70      *
71      * - `from` cannot be the zero address.
72      * - `to` cannot be the zero address.
73      * - `tokenId` token must exist and be owned by `from`.
74      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
75      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
76      *
77      * Emits a {Transfer} event.
78      */
79     function safeTransferFrom(
80         address from,
81         address to,
82         uint256 tokenId
83     ) external;
84 
85     /**
86      * @dev Transfers `tokenId` token from `from` to `to`.
87      *
88      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
89      *
90      * Requirements:
91      *
92      * - `from` cannot be the zero address.
93      * - `to` cannot be the zero address.
94      * - `tokenId` token must be owned by `from`.
95      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
96      *
97      * Emits a {Transfer} event.
98      */
99     function transferFrom(
100         address from,
101         address to,
102         uint256 tokenId
103     ) external;
104 
105     /**
106      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
107      * The approval is cleared when the token is transferred.
108      *
109      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
110      *
111      * Requirements:
112      *
113      * - The caller must own the token or be an approved operator.
114      * - `tokenId` must exist.
115      *
116      * Emits an {Approval} event.
117      */
118     function approve(address to, uint256 tokenId) external;
119 
120     /**
121      * @dev Returns the account approved for `tokenId` token.
122      *
123      * Requirements:
124      *
125      * - `tokenId` must exist.
126      */
127     function getApproved(uint256 tokenId) external view returns (address operator);
128 
129     /**
130      * @dev Approve or remove `operator` as an operator for the caller.
131      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
132      *
133      * Requirements:
134      *
135      * - The `operator` cannot be the caller.
136      *
137      * Emits an {ApprovalForAll} event.
138      */
139     function setApprovalForAll(address operator, bool _approved) external;
140 
141     /**
142      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
143      *
144      * See {setApprovalForAll}
145      */
146     function isApprovedForAll(address owner, address operator) external view returns (bool);
147 
148     /**
149      * @dev Safely transfers `tokenId` token from `from` to `to`.
150      *
151      * Requirements:
152      *
153      * - `from` cannot be the zero address.
154      * - `to` cannot be the zero address.
155      * - `tokenId` token must exist and be owned by `from`.
156      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
157      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
158      *
159      * Emits a {Transfer} event.
160      */
161     function safeTransferFrom(
162         address from,
163         address to,
164         uint256 tokenId,
165         bytes calldata data
166     ) external;
167 }
168 
169 library Math {
170     /**
171      * @dev Returns the largest of two numbers.
172      */
173     function max(uint256 a, uint256 b) internal pure returns (uint256) {
174         return a >= b ? a : b;
175     }
176 
177     /**
178      * @dev Returns the smallest of two numbers.
179      */
180     function min(uint256 a, uint256 b) internal pure returns (uint256) {
181         return a < b ? a : b;
182     }
183 
184     /**
185      * @dev Returns the average of two numbers. The result is rounded towards
186      * zero.
187      */
188     function average(uint256 a, uint256 b) internal pure returns (uint256) {
189         // (a + b) / 2 can overflow.
190         return (a & b) + (a ^ b) / 2;
191     }
192 
193     /**
194      * @dev Returns the ceiling of the division of two numbers.
195      *
196      * This differs from standard division with `/` in that it rounds up instead
197      * of rounding down.
198      */
199     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
200         // (a + b - 1) / b can overflow on addition, so we distribute.
201         return a / b + (a % b == 0 ? 0 : 1);
202     }
203 }
204 
205 library EnumerableSet {
206     // To implement this library for multiple types with as little code
207     // repetition as possible, we write it in terms of a generic Set type with
208     // bytes32 values.
209     // The Set implementation uses private functions, and user-facing
210     // implementations (such as AddressSet) are just wrappers around the
211     // underlying Set.
212     // This means that we can only create new EnumerableSets for types that fit
213     // in bytes32.
214 
215     struct Set {
216         // Storage of set values
217         bytes32[] _values;
218         // Position of the value in the `values` array, plus 1 because index 0
219         // means a value is not in the set.
220         mapping(bytes32 => uint256) _indexes;
221     }
222 
223     /**
224      * @dev Add a value to a set. O(1).
225      *
226      * Returns true if the value was added to the set, that is if it was not
227      * already present.
228      */
229     function _add(Set storage set, bytes32 value) private returns (bool) {
230         if (!_contains(set, value)) {
231             set._values.push(value);
232             // The value is stored at length-1, but we add 1 to all indexes
233             // and use 0 as a sentinel value
234             set._indexes[value] = set._values.length;
235             return true;
236         } else {
237             return false;
238         }
239     }
240 
241     /**
242      * @dev Removes a value from a set. O(1).
243      *
244      * Returns true if the value was removed from the set, that is if it was
245      * present.
246      */
247     function _remove(Set storage set, bytes32 value) private returns (bool) {
248         // We read and store the value's index to prevent multiple reads from the same storage slot
249         uint256 valueIndex = set._indexes[value];
250 
251         if (valueIndex != 0) {
252             // Equivalent to contains(set, value)
253             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
254             // the array, and then remove the last element (sometimes called as 'swap and pop').
255             // This modifies the order of the array, as noted in {at}.
256 
257             uint256 toDeleteIndex = valueIndex - 1;
258             uint256 lastIndex = set._values.length - 1;
259 
260             if (lastIndex != toDeleteIndex) {
261                 bytes32 lastvalue = set._values[lastIndex];
262 
263                 // Move the last value to the index where the value to delete is
264                 set._values[toDeleteIndex] = lastvalue;
265                 // Update the index for the moved value
266                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
267             }
268 
269             // Delete the slot where the moved value was stored
270             set._values.pop();
271 
272             // Delete the index for the deleted slot
273             delete set._indexes[value];
274 
275             return true;
276         } else {
277             return false;
278         }
279     }
280 
281     /**
282      * @dev Returns true if the value is in the set. O(1).
283      */
284     function _contains(Set storage set, bytes32 value) private view returns (bool) {
285         return set._indexes[value] != 0;
286     }
287 
288     /**
289      * @dev Returns the number of values on the set. O(1).
290      */
291     function _length(Set storage set) private view returns (uint256) {
292         return set._values.length;
293     }
294 
295     /**
296      * @dev Returns the value stored at position `index` in the set. O(1).
297      *
298      * Note that there are no guarantees on the ordering of values inside the
299      * array, and it may change when more values are added or removed.
300      *
301      * Requirements:
302      *
303      * - `index` must be strictly less than {length}.
304      */
305     function _at(Set storage set, uint256 index) private view returns (bytes32) {
306         return set._values[index];
307     }
308 
309     /**
310      * @dev Return the entire set in an array
311      *
312      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
313      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
314      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
315      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
316      */
317     function _values(Set storage set) private view returns (bytes32[] memory) {
318         return set._values;
319     }
320 
321     // Bytes32Set
322 
323     struct Bytes32Set {
324         Set _inner;
325     }
326 
327     /**
328      * @dev Add a value to a set. O(1).
329      *
330      * Returns true if the value was added to the set, that is if it was not
331      * already present.
332      */
333     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
334         return _add(set._inner, value);
335     }
336 
337     /**
338      * @dev Removes a value from a set. O(1).
339      *
340      * Returns true if the value was removed from the set, that is if it was
341      * present.
342      */
343     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
344         return _remove(set._inner, value);
345     }
346 
347     /**
348      * @dev Returns true if the value is in the set. O(1).
349      */
350     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
351         return _contains(set._inner, value);
352     }
353 
354     /**
355      * @dev Returns the number of values in the set. O(1).
356      */
357     function length(Bytes32Set storage set) internal view returns (uint256) {
358         return _length(set._inner);
359     }
360 
361     /**
362      * @dev Returns the value stored at position `index` in the set. O(1).
363      *
364      * Note that there are no guarantees on the ordering of values inside the
365      * array, and it may change when more values are added or removed.
366      *
367      * Requirements:
368      *
369      * - `index` must be strictly less than {length}.
370      */
371     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
372         return _at(set._inner, index);
373     }
374 
375     /**
376      * @dev Return the entire set in an array
377      *
378      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
379      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
380      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
381      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
382      */
383     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
384         return _values(set._inner);
385     }
386 
387     // AddressSet
388 
389     struct AddressSet {
390         Set _inner;
391     }
392 
393     /**
394      * @dev Add a value to a set. O(1).
395      *
396      * Returns true if the value was added to the set, that is if it was not
397      * already present.
398      */
399     function add(AddressSet storage set, address value) internal returns (bool) {
400         return _add(set._inner, bytes32(uint256(uint160(value))));
401     }
402 
403     /**
404      * @dev Removes a value from a set. O(1).
405      *
406      * Returns true if the value was removed from the set, that is if it was
407      * present.
408      */
409     function remove(AddressSet storage set, address value) internal returns (bool) {
410         return _remove(set._inner, bytes32(uint256(uint160(value))));
411     }
412 
413     /**
414      * @dev Returns true if the value is in the set. O(1).
415      */
416     function contains(AddressSet storage set, address value) internal view returns (bool) {
417         return _contains(set._inner, bytes32(uint256(uint160(value))));
418     }
419 
420     /**
421      * @dev Returns the number of values in the set. O(1).
422      */
423     function length(AddressSet storage set) internal view returns (uint256) {
424         return _length(set._inner);
425     }
426 
427     /**
428      * @dev Returns the value stored at position `index` in the set. O(1).
429      *
430      * Note that there are no guarantees on the ordering of values inside the
431      * array, and it may change when more values are added or removed.
432      *
433      * Requirements:
434      *
435      * - `index` must be strictly less than {length}.
436      */
437     function at(AddressSet storage set, uint256 index) internal view returns (address) {
438         return address(uint160(uint256(_at(set._inner, index))));
439     }
440 
441     /**
442      * @dev Return the entire set in an array
443      *
444      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
445      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
446      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
447      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
448      */
449     function values(AddressSet storage set) internal view returns (address[] memory) {
450         bytes32[] memory store = _values(set._inner);
451         address[] memory result;
452 
453         assembly {
454             result := store
455         }
456 
457         return result;
458     }
459 
460     // UintSet
461 
462     struct UintSet {
463         Set _inner;
464     }
465 
466     /**
467      * @dev Add a value to a set. O(1).
468      *
469      * Returns true if the value was added to the set, that is if it was not
470      * already present.
471      */
472     function add(UintSet storage set, uint256 value) internal returns (bool) {
473         return _add(set._inner, bytes32(value));
474     }
475 
476     /**
477      * @dev Removes a value from a set. O(1).
478      *
479      * Returns true if the value was removed from the set, that is if it was
480      * present.
481      */
482     function remove(UintSet storage set, uint256 value) internal returns (bool) {
483         return _remove(set._inner, bytes32(value));
484     }
485 
486     /**
487      * @dev Returns true if the value is in the set. O(1).
488      */
489     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
490         return _contains(set._inner, bytes32(value));
491     }
492 
493     /**
494      * @dev Returns the number of values on the set. O(1).
495      */
496     function length(UintSet storage set) internal view returns (uint256) {
497         return _length(set._inner);
498     }
499 
500     /**
501      * @dev Returns the value stored at position `index` in the set. O(1).
502      *
503      * Note that there are no guarantees on the ordering of values inside the
504      * array, and it may change when more values are added or removed.
505      *
506      * Requirements:
507      *
508      * - `index` must be strictly less than {length}.
509      */
510     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
511         return uint256(_at(set._inner, index));
512     }
513 
514     /**
515      * @dev Return the entire set in an array
516      *
517      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
518      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
519      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
520      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
521      */
522     function values(UintSet storage set) internal view returns (uint256[] memory) {
523         bytes32[] memory store = _values(set._inner);
524         uint256[] memory result;
525 
526         assembly {
527             result := store
528         }
529 
530         return result;
531     }
532 }
533 
534 abstract contract Context {
535     function _msgSender() internal view virtual returns (address) {
536         return msg.sender;
537     }
538 
539     function _msgData() internal view virtual returns (bytes calldata) {
540         return msg.data;
541     }
542 }
543 
544 abstract contract Ownable is Context {
545     address private _owner;
546 
547     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
548 
549     /**
550      * @dev Initializes the contract setting the deployer as the initial owner.
551      */
552     constructor() {
553         _setOwner(_msgSender());
554     }
555 
556     /**
557      * @dev Returns the address of the current owner.
558      */
559     function owner() public view virtual returns (address) {
560         return _owner;
561     }
562 
563     /**
564      * @dev Throws if called by any account other than the owner.
565      */
566     modifier onlyOwner() {
567         require(owner() == _msgSender(), "Ownable: caller is not the owner");
568         _;
569     }
570 
571     /**
572      * @dev Leaves the contract without owner. It will not be possible to call
573      * `onlyOwner` functions anymore. Can only be called by the current owner.
574      *
575      * NOTE: Renouncing ownership will leave the contract without an owner,
576      * thereby removing any functionality that is only available to the owner.
577      */
578     function renounceOwnership() public virtual onlyOwner {
579         _setOwner(address(0));
580     }
581 
582     /**
583      * @dev Transfers ownership of the contract to a new account (`newOwner`).
584      * Can only be called by the current owner.
585      */
586     function transferOwnership(address newOwner) public virtual onlyOwner {
587         require(newOwner != address(0), "Ownable: new owner is the zero address");
588         _setOwner(newOwner);
589     }
590 
591     function _setOwner(address newOwner) private {
592         address oldOwner = _owner;
593         _owner = newOwner;
594         emit OwnershipTransferred(oldOwner, newOwner);
595     }
596 }
597 
598 interface IPIXL {
599     function whitelist_mint(address account, uint256 amount) external;
600 }
601 
602 contract StakeSeals is IERC721Receiver, Ownable {
603     using EnumerableSet for EnumerableSet.UintSet;
604 
605     address public ERC20_CONTRACT;
606     address public ERC721_CONTRACT;
607     uint256 public EXPIRATION; //expiry block number (avg 15s per block)
608 
609     mapping(address => EnumerableSet.UintSet) private _deposits;
610     mapping(address => mapping(uint256 => uint256)) public depositBlocks;
611     mapping (uint256 => uint256) public tokenRarity;
612     uint256[7] public rewardRate;   
613     bool started;
614 
615     constructor(
616         address _erc20,
617         address _erc721,
618         uint256 _expiration
619     ) {
620         ERC20_CONTRACT = _erc20;
621         ERC721_CONTRACT = _erc721;
622         EXPIRATION = block.number + _expiration;
623         // number of tokens Per day
624         rewardRate = [50, 60, 75, 100, 150, 500, 0];
625         started = false;
626     }
627 
628     function setRate(uint256 _rarity, uint256 _rate) public onlyOwner() {
629         rewardRate[_rarity] = _rate;
630     }
631 
632     function setRarity(uint256 _tokenId, uint256 _rarity) public onlyOwner() {
633         tokenRarity[_tokenId] = _rarity;
634     }
635 
636     function setBatchRarity(uint256[] memory _tokenIds, uint256 _rarity) public onlyOwner() {
637         for (uint256 i; i < _tokenIds.length; i++) {
638             uint256 tokenId = _tokenIds[i];
639             tokenRarity[tokenId] = _rarity;
640         }
641     }
642 
643     function setExpiration(uint256 _expiration) public onlyOwner() {
644         EXPIRATION = _expiration;
645     }
646 
647     
648     function toggleStart() public onlyOwner() {
649         started = !started;
650     }
651 
652     function setTokenAddress(address _tokenAddress) public onlyOwner() {
653         // Used to change rewards token if needed
654         ERC20_CONTRACT = _tokenAddress;
655     }
656 
657     function onERC721Received(
658         address,
659         address,
660         uint256,
661         bytes calldata
662     ) external pure override returns (bytes4) {
663         return IERC721Receiver.onERC721Received.selector;
664     }
665 
666     function depositsOf(address account)
667         external
668         view
669         returns (uint256[] memory)
670     {
671         EnumerableSet.UintSet storage depositSet = _deposits[account];
672         uint256[] memory tokenIds = new uint256[](depositSet.length());
673 
674         for (uint256 i; i < depositSet.length(); i++) {
675             tokenIds[i] = depositSet.at(i);
676         }
677 
678         return tokenIds;
679     }
680 
681     function findRate(uint256 tokenId)
682         public
683         view
684         returns (uint256 rate) 
685     {
686         uint256 rarity = tokenRarity[tokenId];
687         uint256 perDay = rewardRate[rarity];
688         
689         // 6000 blocks per day
690         // perDay / 6000 = reward per block
691 
692         rate = (perDay * 1e18) / 6000;
693         
694         return rate;
695     }
696 
697     function calculateRewards(address account, uint256[] memory tokenIds)
698         public
699         view
700         returns (uint256[] memory rewards)
701     {
702         rewards = new uint256[](tokenIds.length);
703 
704         for (uint256 i; i < tokenIds.length; i++) {
705             uint256 tokenId = tokenIds[i];
706             uint256 rate = findRate(tokenId);
707             rewards[i] =
708                 rate *
709                 (_deposits[account].contains(tokenId) ? 1 : 0) *
710                 (Math.min(block.number, EXPIRATION) -
711                     depositBlocks[account][tokenId]);
712         }
713     }
714 
715     function claimRewards(uint256[] calldata tokenIds) public {
716         uint256 reward;
717         uint256 curblock = Math.min(block.number, EXPIRATION);
718 
719         uint256[] memory rewards = calculateRewards(msg.sender, tokenIds);
720 
721         for (uint256 i; i < tokenIds.length; i++) {
722             reward += rewards[i];
723             depositBlocks[msg.sender][tokenIds[i]] = curblock;
724         }
725 
726         if (reward > 0) {
727             IPIXL(ERC20_CONTRACT).whitelist_mint(msg.sender, reward);
728         }
729     }
730 
731     function deposit(uint256[] calldata tokenIds) external {
732         require(started, 'StakeSeals: Staking contract not started yet');
733 
734         claimRewards(tokenIds);
735         
736 
737         for (uint256 i; i < tokenIds.length; i++) {
738             IERC721(ERC721_CONTRACT).safeTransferFrom(
739                 msg.sender,
740                 address(this),
741                 tokenIds[i],
742                 ''
743             );
744             _deposits[msg.sender].add(tokenIds[i]);
745         }
746     }
747 
748     function admin_deposit(uint256[] calldata tokenIds) onlyOwner() external {
749         claimRewards(tokenIds);
750         
751 
752         for (uint256 i; i < tokenIds.length; i++) {
753             IERC721(ERC721_CONTRACT).safeTransferFrom(
754                 msg.sender,
755                 address(this),
756                 tokenIds[i],
757                 ''
758             );
759             _deposits[msg.sender].add(tokenIds[i]);
760         }
761     }
762 
763     function withdraw(uint256[] calldata tokenIds) external {
764         claimRewards(tokenIds);
765 
766         for (uint256 i; i < tokenIds.length; i++) {
767             require(
768                 _deposits[msg.sender].contains(tokenIds[i]),
769                 'StakeSeals: Token not deposited'
770             );
771 
772             _deposits[msg.sender].remove(tokenIds[i]);
773 
774             IERC721(ERC721_CONTRACT).safeTransferFrom(
775                 address(this),
776                 msg.sender,
777                 tokenIds[i],
778                 ''
779             );
780         }
781     }
782 }