1 // Sources flattened with hardhat v2.6.0 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.2.0
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC165 standard, as defined in the
11  * https://eips.ethereum.org/EIPS/eip-165[EIP].
12  *
13  * Implementers can declare support of contract interfaces, which can then be
14  * queried by others ({ERC165Checker}).
15  *
16  * For an implementation, see {ERC165}.
17  */
18 interface IERC165 {
19     /**
20      * @dev Returns true if this contract implements the interface defined by
21      * `interfaceId`. See the corresponding
22      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
23      * to learn more about how these ids are created.
24      *
25      * This function call must use less than 30 000 gas.
26      */
27     function supportsInterface(bytes4 interfaceId) external view returns (bool);
28 }
29 
30 
31 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.2.0
32 
33 
34 pragma solidity ^0.8.0;
35 
36 /**
37  * @dev Required interface of an ERC721 compliant contract.
38  */
39 interface IERC721 is IERC165 {
40     /**
41      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
42      */
43     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
44 
45     /**
46      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
47      */
48     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
49 
50     /**
51      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
52      */
53     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
54 
55     /**
56      * @dev Returns the number of tokens in ``owner``'s account.
57      */
58     function balanceOf(address owner) external view returns (uint256 balance);
59 
60     /**
61      * @dev Returns the owner of the `tokenId` token.
62      *
63      * Requirements:
64      *
65      * - `tokenId` must exist.
66      */
67     function ownerOf(uint256 tokenId) external view returns (address owner);
68 
69     /**
70      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
71      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
72      *
73      * Requirements:
74      *
75      * - `from` cannot be the zero address.
76      * - `to` cannot be the zero address.
77      * - `tokenId` token must exist and be owned by `from`.
78      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
79      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
80      *
81      * Emits a {Transfer} event.
82      */
83     function safeTransferFrom(
84         address from,
85         address to,
86         uint256 tokenId
87     ) external;
88 
89     /**
90      * @dev Transfers `tokenId` token from `from` to `to`.
91      *
92      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
93      *
94      * Requirements:
95      *
96      * - `from` cannot be the zero address.
97      * - `to` cannot be the zero address.
98      * - `tokenId` token must be owned by `from`.
99      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
100      *
101      * Emits a {Transfer} event.
102      */
103     function transferFrom(
104         address from,
105         address to,
106         uint256 tokenId
107     ) external;
108 
109     /**
110      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
111      * The approval is cleared when the token is transferred.
112      *
113      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
114      *
115      * Requirements:
116      *
117      * - The caller must own the token or be an approved operator.
118      * - `tokenId` must exist.
119      *
120      * Emits an {Approval} event.
121      */
122     function approve(address to, uint256 tokenId) external;
123 
124     /**
125      * @dev Returns the account approved for `tokenId` token.
126      *
127      * Requirements:
128      *
129      * - `tokenId` must exist.
130      */
131     function getApproved(uint256 tokenId) external view returns (address operator);
132 
133     /**
134      * @dev Approve or remove `operator` as an operator for the caller.
135      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
136      *
137      * Requirements:
138      *
139      * - The `operator` cannot be the caller.
140      *
141      * Emits an {ApprovalForAll} event.
142      */
143     function setApprovalForAll(address operator, bool _approved) external;
144 
145     /**
146      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
147      *
148      * See {setApprovalForAll}
149      */
150     function isApprovedForAll(address owner, address operator) external view returns (bool);
151 
152     /**
153      * @dev Safely transfers `tokenId` token from `from` to `to`.
154      *
155      * Requirements:
156      *
157      * - `from` cannot be the zero address.
158      * - `to` cannot be the zero address.
159      * - `tokenId` token must exist and be owned by `from`.
160      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
161      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
162      *
163      * Emits a {Transfer} event.
164      */
165     function safeTransferFrom(
166         address from,
167         address to,
168         uint256 tokenId,
169         bytes calldata data
170     ) external;
171 }
172 
173 
174 // File contracts/nodes/IMCCNode.sol
175 
176 pragma solidity ^0.8.4;
177 
178 interface IMCCNode is IERC721 {
179   function mainToken() external view returns (address);
180 
181   function stableToken() external view returns (address);
182 
183   function tokenMintedAt(uint256 tokenId) external view returns (uint256);
184 
185   function tokenLastTransferredAt(uint256 tokenId)
186     external
187     view
188     returns (uint256);
189 
190   function pricePaidUSD18(uint256 tokenId) external view returns (uint256);
191 
192   function tokenPerDayReturn(uint256 tokenId) external view returns (uint256);
193 
194   function mint(uint256[] memory tierId, uint256[] memory amount)
195     external
196     payable;
197 }
198 
199 
200 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.2.0
201 
202 
203 pragma solidity ^0.8.0;
204 
205 /**
206  * @dev Interface of the ERC20 standard as defined in the EIP.
207  */
208 interface IERC20 {
209     /**
210      * @dev Returns the amount of tokens in existence.
211      */
212     function totalSupply() external view returns (uint256);
213 
214     /**
215      * @dev Returns the amount of tokens owned by `account`.
216      */
217     function balanceOf(address account) external view returns (uint256);
218 
219     /**
220      * @dev Moves `amount` tokens from the caller's account to `recipient`.
221      *
222      * Returns a boolean value indicating whether the operation succeeded.
223      *
224      * Emits a {Transfer} event.
225      */
226     function transfer(address recipient, uint256 amount) external returns (bool);
227 
228     /**
229      * @dev Returns the remaining number of tokens that `spender` will be
230      * allowed to spend on behalf of `owner` through {transferFrom}. This is
231      * zero by default.
232      *
233      * This value changes when {approve} or {transferFrom} are called.
234      */
235     function allowance(address owner, address spender) external view returns (uint256);
236 
237     /**
238      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
239      *
240      * Returns a boolean value indicating whether the operation succeeded.
241      *
242      * IMPORTANT: Beware that changing an allowance with this method brings the risk
243      * that someone may use both the old and the new allowance by unfortunate
244      * transaction ordering. One possible solution to mitigate this race
245      * condition is to first reduce the spender's allowance to 0 and set the
246      * desired value afterwards:
247      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
248      *
249      * Emits an {Approval} event.
250      */
251     function approve(address spender, uint256 amount) external returns (bool);
252 
253     /**
254      * @dev Moves `amount` tokens from `sender` to `recipient` using the
255      * allowance mechanism. `amount` is then deducted from the caller's
256      * allowance.
257      *
258      * Returns a boolean value indicating whether the operation succeeded.
259      *
260      * Emits a {Transfer} event.
261      */
262     function transferFrom(
263         address sender,
264         address recipient,
265         uint256 amount
266     ) external returns (bool);
267 
268     /**
269      * @dev Emitted when `value` tokens are moved from one account (`from`) to
270      * another (`to`).
271      *
272      * Note that `value` may be zero.
273      */
274     event Transfer(address indexed from, address indexed to, uint256 value);
275 
276     /**
277      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
278      * a call to {approve}. `value` is the new allowance.
279      */
280     event Approval(address indexed owner, address indexed spender, uint256 value);
281 }
282 
283 
284 // File @openzeppelin/contracts/utils/Context.sol@v4.2.0
285 
286 
287 pragma solidity ^0.8.0;
288 
289 /*
290  * @dev Provides information about the current execution context, including the
291  * sender of the transaction and its data. While these are generally available
292  * via msg.sender and msg.data, they should not be accessed in such a direct
293  * manner, since when dealing with meta-transactions the account sending and
294  * paying for execution may not be the actual sender (as far as an application
295  * is concerned).
296  *
297  * This contract is only required for intermediate, library-like contracts.
298  */
299 abstract contract Context {
300     function _msgSender() internal view virtual returns (address) {
301         return msg.sender;
302     }
303 
304     function _msgData() internal view virtual returns (bytes calldata) {
305         return msg.data;
306     }
307 }
308 
309 
310 // File @openzeppelin/contracts/access/Ownable.sol@v4.2.0
311 
312 
313 pragma solidity ^0.8.0;
314 
315 /**
316  * @dev Contract module which provides a basic access control mechanism, where
317  * there is an account (an owner) that can be granted exclusive access to
318  * specific functions.
319  *
320  * By default, the owner account will be the one that deploys the contract. This
321  * can later be changed with {transferOwnership}.
322  *
323  * This module is used through inheritance. It will make available the modifier
324  * `onlyOwner`, which can be applied to your functions to restrict their use to
325  * the owner.
326  */
327 abstract contract Ownable is Context {
328     address private _owner;
329 
330     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
331 
332     /**
333      * @dev Initializes the contract setting the deployer as the initial owner.
334      */
335     constructor() {
336         _setOwner(_msgSender());
337     }
338 
339     /**
340      * @dev Returns the address of the current owner.
341      */
342     function owner() public view virtual returns (address) {
343         return _owner;
344     }
345 
346     /**
347      * @dev Throws if called by any account other than the owner.
348      */
349     modifier onlyOwner() {
350         require(owner() == _msgSender(), "Ownable: caller is not the owner");
351         _;
352     }
353 
354     /**
355      * @dev Leaves the contract without owner. It will not be possible to call
356      * `onlyOwner` functions anymore. Can only be called by the current owner.
357      *
358      * NOTE: Renouncing ownership will leave the contract without an owner,
359      * thereby removing any functionality that is only available to the owner.
360      */
361     function renounceOwnership() public virtual onlyOwner {
362         _setOwner(address(0));
363     }
364 
365     /**
366      * @dev Transfers ownership of the contract to a new account (`newOwner`).
367      * Can only be called by the current owner.
368      */
369     function transferOwnership(address newOwner) public virtual onlyOwner {
370         require(newOwner != address(0), "Ownable: new owner is the zero address");
371         _setOwner(newOwner);
372     }
373 
374     function _setOwner(address newOwner) private {
375         address oldOwner = _owner;
376         _owner = newOwner;
377         emit OwnershipTransferred(oldOwner, newOwner);
378     }
379 }
380 
381 
382 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.2.0
383 
384 
385 pragma solidity ^0.8.0;
386 
387 // CAUTION
388 // This version of SafeMath should only be used with Solidity 0.8 or later,
389 // because it relies on the compiler's built in overflow checks.
390 
391 /**
392  * @dev Wrappers over Solidity's arithmetic operations.
393  *
394  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
395  * now has built in overflow checking.
396  */
397 library SafeMath {
398     /**
399      * @dev Returns the addition of two unsigned integers, with an overflow flag.
400      *
401      * _Available since v3.4._
402      */
403     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
404         unchecked {
405             uint256 c = a + b;
406             if (c < a) return (false, 0);
407             return (true, c);
408         }
409     }
410 
411     /**
412      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
413      *
414      * _Available since v3.4._
415      */
416     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
417         unchecked {
418             if (b > a) return (false, 0);
419             return (true, a - b);
420         }
421     }
422 
423     /**
424      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
425      *
426      * _Available since v3.4._
427      */
428     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
429         unchecked {
430             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
431             // benefit is lost if 'b' is also tested.
432             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
433             if (a == 0) return (true, 0);
434             uint256 c = a * b;
435             if (c / a != b) return (false, 0);
436             return (true, c);
437         }
438     }
439 
440     /**
441      * @dev Returns the division of two unsigned integers, with a division by zero flag.
442      *
443      * _Available since v3.4._
444      */
445     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
446         unchecked {
447             if (b == 0) return (false, 0);
448             return (true, a / b);
449         }
450     }
451 
452     /**
453      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
454      *
455      * _Available since v3.4._
456      */
457     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
458         unchecked {
459             if (b == 0) return (false, 0);
460             return (true, a % b);
461         }
462     }
463 
464     /**
465      * @dev Returns the addition of two unsigned integers, reverting on
466      * overflow.
467      *
468      * Counterpart to Solidity's `+` operator.
469      *
470      * Requirements:
471      *
472      * - Addition cannot overflow.
473      */
474     function add(uint256 a, uint256 b) internal pure returns (uint256) {
475         return a + b;
476     }
477 
478     /**
479      * @dev Returns the subtraction of two unsigned integers, reverting on
480      * overflow (when the result is negative).
481      *
482      * Counterpart to Solidity's `-` operator.
483      *
484      * Requirements:
485      *
486      * - Subtraction cannot overflow.
487      */
488     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
489         return a - b;
490     }
491 
492     /**
493      * @dev Returns the multiplication of two unsigned integers, reverting on
494      * overflow.
495      *
496      * Counterpart to Solidity's `*` operator.
497      *
498      * Requirements:
499      *
500      * - Multiplication cannot overflow.
501      */
502     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
503         return a * b;
504     }
505 
506     /**
507      * @dev Returns the integer division of two unsigned integers, reverting on
508      * division by zero. The result is rounded towards zero.
509      *
510      * Counterpart to Solidity's `/` operator.
511      *
512      * Requirements:
513      *
514      * - The divisor cannot be zero.
515      */
516     function div(uint256 a, uint256 b) internal pure returns (uint256) {
517         return a / b;
518     }
519 
520     /**
521      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
522      * reverting when dividing by zero.
523      *
524      * Counterpart to Solidity's `%` operator. This function uses a `revert`
525      * opcode (which leaves remaining gas untouched) while Solidity uses an
526      * invalid opcode to revert (consuming all remaining gas).
527      *
528      * Requirements:
529      *
530      * - The divisor cannot be zero.
531      */
532     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
533         return a % b;
534     }
535 
536     /**
537      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
538      * overflow (when the result is negative).
539      *
540      * CAUTION: This function is deprecated because it requires allocating memory for the error
541      * message unnecessarily. For custom revert reasons use {trySub}.
542      *
543      * Counterpart to Solidity's `-` operator.
544      *
545      * Requirements:
546      *
547      * - Subtraction cannot overflow.
548      */
549     function sub(
550         uint256 a,
551         uint256 b,
552         string memory errorMessage
553     ) internal pure returns (uint256) {
554         unchecked {
555             require(b <= a, errorMessage);
556             return a - b;
557         }
558     }
559 
560     /**
561      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
562      * division by zero. The result is rounded towards zero.
563      *
564      * Counterpart to Solidity's `/` operator. Note: this function uses a
565      * `revert` opcode (which leaves remaining gas untouched) while Solidity
566      * uses an invalid opcode to revert (consuming all remaining gas).
567      *
568      * Requirements:
569      *
570      * - The divisor cannot be zero.
571      */
572     function div(
573         uint256 a,
574         uint256 b,
575         string memory errorMessage
576     ) internal pure returns (uint256) {
577         unchecked {
578             require(b > 0, errorMessage);
579             return a / b;
580         }
581     }
582 
583     /**
584      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
585      * reverting with custom message when dividing by zero.
586      *
587      * CAUTION: This function is deprecated because it requires allocating memory for the error
588      * message unnecessarily. For custom revert reasons use {tryMod}.
589      *
590      * Counterpart to Solidity's `%` operator. This function uses a `revert`
591      * opcode (which leaves remaining gas untouched) while Solidity uses an
592      * invalid opcode to revert (consuming all remaining gas).
593      *
594      * Requirements:
595      *
596      * - The divisor cannot be zero.
597      */
598     function mod(
599         uint256 a,
600         uint256 b,
601         string memory errorMessage
602     ) internal pure returns (uint256) {
603         unchecked {
604             require(b > 0, errorMessage);
605             return a % b;
606         }
607     }
608 }
609 
610 
611 // File contracts/nodes/MCCNodeRewards.sol
612 
613 pragma solidity ^0.8.4;
614 
615 
616 
617 
618 contract MCCNodeRewards is Ownable {
619   using SafeMath for uint256;
620 
621   IMCCNode node;
622 
623   struct Share {
624     uint256 totalRealised;
625     uint256 lastClaim;
626   }
627 
628   mapping(uint256 => Share) public shares;
629 
630   uint256 public totalDistributed; // to be shown in UI
631 
632   uint256 public rewardFrequencySeconds = 60 * 60 * 24; // 1 day
633 
634   constructor(address _node) {
635     node = IMCCNode(_node);
636   }
637 
638   function shareholderToken() external view returns (address) {
639     return address(node);
640   }
641 
642   function dividendToken() external view returns (address) {
643     return node.mainToken();
644   }
645 
646   function claimDividend(uint256 _tokenId) public {
647     Share storage share = shares[_tokenId];
648     uint256 unpaid = getUnpaidEarnings(_tokenId);
649 
650     IERC20 mainToken = IERC20(node.mainToken());
651     require(
652       mainToken.balanceOf(address(this)) >= unpaid,
653       'not enough liquidity to distribute dividends'
654     );
655     mainToken.transfer(node.ownerOf(_tokenId), unpaid);
656 
657     totalDistributed += unpaid;
658     share.totalRealised += unpaid;
659     share.lastClaim = block.timestamp;
660   }
661 
662   function claimDividendsMulti(uint256[] memory _tokenIds) external {
663     for (uint256 _i = 0; _i < _tokenIds.length; _i++) {
664       claimDividend(_tokenIds[_i]);
665     }
666   }
667 
668   // returns the earnings by the node that have been unpaid
669   function getUnpaidEarnings(uint256 _tokenId) public view returns (uint256) {
670     Share memory share = shares[_tokenId];
671     uint256 availableClaims = _getTotalNumberClaims(_tokenId);
672     uint256 remainingClaims = share.lastClaim == 0
673       ? availableClaims
674       : block.timestamp.sub(share.lastClaim).div(rewardFrequencySeconds);
675     uint256 perDayTokens = node.tokenPerDayReturn(_tokenId);
676     return perDayTokens.mul(remainingClaims);
677   }
678 
679   function getTotalEarnings(uint256 _tokenId) external view returns (uint256) {
680     uint256 availableClaims = _getTotalNumberClaims(_tokenId);
681     uint256 perDayTokens = node.tokenPerDayReturn(_tokenId);
682     return perDayTokens.mul(availableClaims);
683   }
684 
685   function _getTotalNumberClaims(uint256 _tokenId)
686     internal
687     view
688     returns (uint256)
689   {
690     uint256 availableClaims = block
691       .timestamp
692       .sub(node.tokenMintedAt(_tokenId))
693       .div(rewardFrequencySeconds);
694     return availableClaims;
695   }
696 
697   function setRewardFrequencySeconds(uint256 _seconds) external onlyOwner {
698     rewardFrequencySeconds = _seconds;
699   }
700 
701   function withdrawTokens(address _tokenAddy, uint256 _amount)
702     external
703     onlyOwner
704   {
705     IERC20 _token = IERC20(_tokenAddy);
706     _amount = _amount > 0 ? _amount : _token.balanceOf(address(this));
707     require(_amount > 0, 'make sure there is a balance available to withdraw');
708     _token.transfer(owner(), _amount);
709   }
710 
711   function withdrawETH() external onlyOwner {
712     payable(owner()).call{ value: address(this).balance }('');
713   }
714 }