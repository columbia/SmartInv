1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/access/Ownable.sol
29 
30 
31 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
32 
33 pragma solidity ^0.8.0;
34 
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * By default, the owner account will be the one that deploys the contract. This
42  * can later be changed with {transferOwnership}.
43  *
44  * This module is used through inheritance. It will make available the modifier
45  * `onlyOwner`, which can be applied to your functions to restrict their use to
46  * the owner.
47  */
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor() {
57         _transferOwnership(_msgSender());
58     }
59 
60     /**
61      * @dev Throws if called by any account other than the owner.
62      */
63     modifier onlyOwner() {
64         _checkOwner();
65         _;
66     }
67 
68     /**
69      * @dev Returns the address of the current owner.
70      */
71     function owner() public view virtual returns (address) {
72         return _owner;
73     }
74 
75     /**
76      * @dev Throws if the sender is not the owner.
77      */
78     function _checkOwner() internal view virtual {
79         require(owner() == _msgSender(), "Ownable: caller is not the owner");
80     }
81 
82     /**
83      * @dev Leaves the contract without owner. It will not be possible to call
84      * `onlyOwner` functions anymore. Can only be called by the current owner.
85      *
86      * NOTE: Renouncing ownership will leave the contract without an owner,
87      * thereby removing any functionality that is only available to the owner.
88      */
89     function renounceOwnership() public virtual onlyOwner {
90         _transferOwnership(address(0));
91     }
92 
93     /**
94      * @dev Transfers ownership of the contract to a new account (`newOwner`).
95      * Can only be called by the current owner.
96      */
97     function transferOwnership(address newOwner) public virtual onlyOwner {
98         require(newOwner != address(0), "Ownable: new owner is the zero address");
99         _transferOwnership(newOwner);
100     }
101 
102     /**
103      * @dev Transfers ownership of the contract to a new account (`newOwner`).
104      * Internal function without access restriction.
105      */
106     function _transferOwnership(address newOwner) internal virtual {
107         address oldOwner = _owner;
108         _owner = newOwner;
109         emit OwnershipTransferred(oldOwner, newOwner);
110     }
111 }
112 
113 // File: contracts/BulkMamStake.sol
114 
115 
116 pragma solidity ^0.8.6;
117 
118 
119 
120 
121 interface IERC20 {
122     /**
123      * @dev Emitted when `value` tokens are moved from one account (`from`) to
124      * another (`to`).
125      *
126      * Note that `value` may be zero.
127      */
128     event Transfer(address indexed from, address indexed to, uint256 value);
129 
130     /**
131      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
132      * a call to {approve}. `value` is the new allowance.
133      */
134     event Approval(address indexed owner, address indexed spender, uint256 value);
135 
136     /**
137      * @dev Returns the amount of tokens in existence.
138      */
139     function totalSupply() external view returns (uint256);
140 
141     /**
142      * @dev Returns the amount of tokens owned by `account`.
143      */
144     function balanceOf(address account) external view returns (uint256);
145 
146     /**
147      * @dev Moves `amount` tokens from the caller's account to `to`.
148      *
149      * Returns a boolean value indicating whether the operation succeeded.
150      *
151      * Emits a {Transfer} event.
152      */
153     function transfer(address to, uint256 amount) external returns (bool);
154 
155     /**
156      * @dev Returns the remaining number of tokens that `spender` will be
157      * allowed to spend on behalf of `owner` through {transferFrom}. This is
158      * zero by default.
159      *
160      * This value changes when {approve} or {transferFrom} are called.
161      */
162     function allowance(address owner, address spender) external view returns (uint256);
163 
164     /**
165      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
166      *
167      * Returns a boolean value indicating whether the operation succeeded.
168      *
169      * IMPORTANT: Beware that changing an allowance with this method brings the risk
170      * that someone may use both the old and the new allowance by unfortunate
171      * transaction ordering. One possible solution to mitigate this race
172      * condition is to first reduce the spender's allowance to 0 and set the
173      * desired value afterwards:
174      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
175      *
176      * Emits an {Approval} event.
177      */
178     function approve(address spender, uint256 amount) external returns (bool);
179 
180     /**
181      * @dev Moves `amount` tokens from `from` to `to` using the
182      * allowance mechanism. `amount` is then deducted from the caller's
183      * allowance.
184      *
185      * Returns a boolean value indicating whether the operation succeeded.
186      *
187      * Emits a {Transfer} event.
188      */
189     function transferFrom(
190         address from,
191         address to,
192         uint256 amount
193     ) external returns (bool);
194 }
195 
196 interface IERC165 {
197     /**
198      * @dev Returns true if this contract implements the interface defined by
199      * `interfaceId`. See the corresponding
200      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
201      * to learn more about how these ids are created.
202      *
203      * This function call must use less than 30 000 gas.
204      */
205     function supportsInterface(bytes4 interfaceId) external view returns (bool);
206 }
207 
208 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
209 
210 
211 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
212 
213 pragma solidity ^0.8.0;
214 
215 
216 /**
217  * @dev Required interface of an ERC721 compliant contract.
218  */
219 interface IERC721 is IERC165 {
220     /**
221      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
222      */
223     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
224 
225     /**
226      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
227      */
228     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
229 
230     /**
231      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
232      */
233     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
234 
235     /**
236      * @dev Returns the number of tokens in ``owner``'s account.
237      */
238     function balanceOf(address owner) external view returns (uint256 balance);
239 
240     /**
241      * @dev Returns the owner of the `tokenId` token.
242      *
243      * Requirements:
244      *
245      * - `tokenId` must exist.
246      */
247     function ownerOf(uint256 tokenId) external view returns (address owner);
248 
249     /**
250      * @dev Safely transfers `tokenId` token from `from` to `to`.
251      *
252      * Requirements:
253      *
254      * - `from` cannot be the zero address.
255      * - `to` cannot be the zero address.
256      * - `tokenId` token must exist and be owned by `from`.
257      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
258      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
259      *
260      * Emits a {Transfer} event.
261      */
262     function safeTransferFrom(
263         address from,
264         address to,
265         uint256 tokenId,
266         bytes calldata data
267     ) external;
268 
269     /**
270      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
271      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
272      *
273      * Requirements:
274      *
275      * - `from` cannot be the zero address.
276      * - `to` cannot be the zero address.
277      * - `tokenId` token must exist and be owned by `from`.
278      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
279      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
280      *
281      * Emits a {Transfer} event.
282      */
283     function safeTransferFrom(
284         address from,
285         address to,
286         uint256 tokenId
287     ) external;
288 
289     /**
290      * @dev Transfers `tokenId` token from `from` to `to`.
291      *
292      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
293      *
294      * Requirements:
295      *
296      * - `from` cannot be the zero address.
297      * - `to` cannot be the zero address.
298      * - `tokenId` token must be owned by `from`.
299      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
300      *
301      * Emits a {Transfer} event.
302      */
303     function transferFrom(
304         address from,
305         address to,
306         uint256 tokenId
307     ) external;
308 
309     /**
310      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
311      * The approval is cleared when the token is transferred.
312      *
313      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
314      *
315      * Requirements:
316      *
317      * - The caller must own the token or be an approved operator.
318      * - `tokenId` must exist.
319      *
320      * Emits an {Approval} event.
321      */
322     function approve(address to, uint256 tokenId) external;
323 
324     /**
325      * @dev Approve or remove `operator` as an operator for the caller.
326      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
327      *
328      * Requirements:
329      *
330      * - The `operator` cannot be the caller.
331      *
332      * Emits an {ApprovalForAll} event.
333      */
334     function setApprovalForAll(address operator, bool _approved) external;
335 
336     /**
337      * @dev Returns the account approved for `tokenId` token.
338      *
339      * Requirements:
340      *
341      * - `tokenId` must exist.
342      */
343     function getApproved(uint256 tokenId) external view returns (address operator);
344 
345     /**
346      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
347      *
348      * See {setApprovalForAll}
349      */
350     function isApprovedForAll(address owner, address operator) external view returns (bool);
351 }
352 
353 
354 
355 
356 
357 
358 interface IERC721Receiver {
359     /**
360      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
361      * by `operator` from `from`, this function is called.
362      *
363      * It must return its Solidity selector to confirm the token transfer.
364      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
365      *
366      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
367      */
368     function onERC721Received(
369         address operator,
370         address from,
371         uint256 tokenId,
372         bytes calldata data
373     ) external returns (bytes4);
374 }
375 
376 
377 
378 library SafeMath {
379     /**
380      * @dev Returns the addition of two unsigned integers, with an overflow flag.
381      *
382      * _Available since v3.4._
383      */
384     function tryAdd(uint256 a, uint256 b)
385         internal
386         pure
387         returns (bool, uint256)
388     {
389         unchecked {
390             uint256 c = a + b;
391             if (c < a) return (false, 0);
392             return (true, c);
393         }
394     }
395 
396     /**
397      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
398      *
399      * _Available since v3.4._
400      */
401     function trySub(uint256 a, uint256 b)
402         internal
403         pure
404         returns (bool, uint256)
405     {
406         unchecked {
407             if (b > a) return (false, 0);
408             return (true, a - b);
409         }
410     }
411 
412     /**
413      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
414      *
415      * _Available since v3.4._
416      */
417     function tryMul(uint256 a, uint256 b)
418         internal
419         pure
420         returns (bool, uint256)
421     {
422         unchecked {
423             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
424             // benefit is lost if 'b' is also tested.
425             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
426             if (a == 0) return (true, 0);
427             uint256 c = a * b;
428             if (c / a != b) return (false, 0);
429             return (true, c);
430         }
431     }
432 
433     /**
434      * @dev Returns the division of two unsigned integers, with a division by zero flag.
435      *
436      * _Available since v3.4._
437      */
438     function tryDiv(uint256 a, uint256 b)
439         internal
440         pure
441         returns (bool, uint256)
442     {
443         unchecked {
444             if (b == 0) return (false, 0);
445             return (true, a / b);
446         }
447     }
448 
449     /**
450      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
451      *
452      * _Available since v3.4._
453      */
454     function tryMod(uint256 a, uint256 b)
455         internal
456         pure
457         returns (bool, uint256)
458     {
459         unchecked {
460             if (b == 0) return (false, 0);
461             return (true, a % b);
462         }
463     }
464 
465     /**
466      * @dev Returns the addition of two unsigned integers, reverting on
467      * overflow.
468      *
469      * Counterpart to Solidity's `+` operator.
470      *
471      * Requirements:
472      *
473      * - Addition cannot overflow.
474      */
475     function add(uint256 a, uint256 b) internal pure returns (uint256) {
476         return a + b;
477     }
478 
479     /**
480      * @dev Returns the subtraction of two unsigned integers, reverting on
481      * overflow (when the result is negative).
482      *
483      * Counterpart to Solidity's `-` operator.
484      *
485      * Requirements:
486      *
487      * - Subtraction cannot overflow.
488      */
489     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
490         return a - b;
491     }
492 
493     /**
494      * @dev Returns the multiplication of two unsigned integers, reverting on
495      * overflow.
496      *
497      * Counterpart to Solidity's `*` operator.
498      *
499      * Requirements:
500      *
501      * - Multiplication cannot overflow.
502      */
503     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
504         return a * b;
505     }
506 
507     /**
508      * @dev Returns the integer division of two unsigned integers, reverting on
509      * division by zero. The result is rounded towards zero.
510      *
511      * Counterpart to Solidity's `/` operator.
512      *
513      * Requirements:
514      *
515      * - The divisor cannot be zero.
516      */
517     function div(uint256 a, uint256 b) internal pure returns (uint256) {
518         return a / b;
519     }
520 
521     /**
522      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
523      * reverting when dividing by zero.
524      *
525      * Counterpart to Solidity's `%` operator. This function uses a `revert`
526      * opcode (which leaves remaining gas untouched) while Solidity uses an
527      * invalid opcode to revert (consuming all remaining gas).
528      *
529      * Requirements:
530      *
531      * - The divisor cannot be zero.
532      */
533     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
534         return a % b;
535     }
536 
537     /**
538      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
539      * overflow (when the result is negative).
540      *
541      * CAUTION: This function is deprecated because it requires allocating memory for the error
542      * message unnecessarily. For custom revert reasons use {trySub}.
543      *
544      * Counterpart to Solidity's `-` operator.
545      *
546      * Requirements:
547      *
548      * - Subtraction cannot overflow.
549      */
550     function sub(
551         uint256 a,
552         uint256 b,
553         string memory errorMessage
554     ) internal pure returns (uint256) {
555         unchecked {
556             require(b <= a, errorMessage);
557             return a - b;
558         }
559     }
560 
561     /**
562      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
563      * division by zero. The result is rounded towards zero.
564      *
565      * Counterpart to Solidity's `/` operator. Note: this function uses a
566      * `revert` opcode (which leaves remaining gas untouched) while Solidity
567      * uses an invalid opcode to revert (consuming all remaining gas).
568      *
569      * Requirements:
570      *
571      * - The divisor cannot be zero.
572      */
573     function div(
574         uint256 a,
575         uint256 b,
576         string memory errorMessage
577     ) internal pure returns (uint256) {
578         unchecked {
579             require(b > 0, errorMessage);
580             return a / b;
581         }
582     }
583 
584     /**
585      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
586      * reverting with custom message when dividing by zero.
587      *
588      * CAUTION: This function is deprecated because it requires allocating memory for the error
589      * message unnecessarily. For custom revert reasons use {tryMod}.
590      *
591      * Counterpart to Solidity's `%` operator. This function uses a `revert`
592      * opcode (which leaves remaining gas untouched) while Solidity uses an
593      * invalid opcode to revert (consuming all remaining gas).
594      *
595      * Requirements:
596      *
597      * - The divisor cannot be zero.
598      */
599     function mod(
600         uint256 a,
601         uint256 b,
602         string memory errorMessage
603     ) internal pure returns (uint256) {
604         unchecked {
605             require(b > 0, errorMessage);
606             return a % b;
607         }
608     }
609 }
610 
611 abstract contract ReentrancyGuard {
612     uint256 private constant _NOT_ENTERED = 1;
613     uint256 private constant _ENTERED = 2;
614 
615     uint256 private _status;
616 
617     constructor() {
618         _status = _NOT_ENTERED;
619     }
620 
621     modifier nonReentrant() {
622         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
623         _status = _ENTERED;
624 
625         _;
626         _status = _NOT_ENTERED;
627     }
628 }
629 
630 contract BulkMamStake is Ownable, IERC721Receiver, ReentrancyGuard {
631     using SafeMath for uint256;
632 
633 
634     IERC721 public mam;
635     IERC721 public mutant;
636 
637     IERC20 public token;
638 
639 
640     struct MamStaker {
641         
642         uint16[] ids;
643         uint16 numberMamStaked;
644         uint16[] remainingIds;
645         uint256 tokenStakedAt;
646         bool daily;
647         address owner;
648           
649         
650     }
651 
652     struct MutantStaker {
653         
654         uint16[] ids;
655         uint16 numberMutantStaked;
656         uint16[] remainingIds;
657         uint256 tokenStakedAt;
658         bool daily;
659         address owner;
660        
661         
662     }
663 
664     mapping(address => MamStaker) public mamstaker;
665     mapping(address => MutantStaker) public mutantstaker;
666    
667     
668 
669 
670     uint256 public dayRate = 5;
671     uint256 public period = 45; //number of days
672     
673 
674 
675     
676     uint16 public mamStaked;
677     uint16 public mutantStaked;
678     uint256 public amountPaid;
679    
680 
681     bool public lockingPeriodEnforced = true;
682     bool public escapeHatchOpen = false;
683     
684 
685 
686     event MamStaked(address indexed, uint256, uint16[]);
687     event MutantStaked(address indexed, uint256, uint16[]);
688     event MamUnstaked(address indexed, uint256);
689     event MutantUnstaked(address indexed, uint256);
690     event Payout(address indexed, uint256);
691 
692     //mamids
693     //legendary, top10% 
694 
695     //mutantids
696     //only legendarys
697 
698     constructor(address _mam, address _mutant, address _token)  {
699         mam = IERC721(_mam);
700         mutant = IERC721(_mutant);
701 
702         token = IERC20(_token);
703         
704 
705     }
706 
707     
708 
709     function onERC721Received(address, address, uint256, bytes calldata) external pure returns (bytes4) {
710         return IERC721Receiver.onERC721Received.selector;
711     }
712 
713     
714 
715     function mamStake(uint16 quantity, uint16[] memory tokenIds) external {
716 
717         mamstaker[msg.sender].tokenStakedAt = block.timestamp;
718         mamstaker[msg.sender].numberMamStaked+= quantity;
719         mamstaker[msg.sender].owner = msg.sender;
720         mamstaker[msg.sender].daily = false;
721         
722           
723         mamStaked+=quantity;
724         
725         for(uint8 i; i < tokenIds.length; i++) {
726             mamstaker[msg.sender].ids.push(tokenIds[i]);
727             mam.safeTransferFrom(msg.sender, address(this), tokenIds[i]);
728         }
729 
730         
731         emit MamStaked(msg.sender, quantity, tokenIds);
732     }
733 
734     
735     
736     function mutantStake(uint16 quantity, uint16[] memory tokenIds) external {
737        mutantstaker[msg.sender].tokenStakedAt = block.timestamp;
738         mutantstaker[msg.sender].numberMutantStaked+= quantity;
739         mutantstaker[msg.sender].owner = msg.sender;
740         mutantstaker[msg.sender].daily = false;
741         
742         
743         
744         mutantStaked+=quantity;
745         
746         for(uint8 i; i < tokenIds.length; i++) {
747             mutantstaker[msg.sender].ids.push(tokenIds[i]);
748             mutant.safeTransferFrom(msg.sender, address(this), tokenIds[i]);
749         }
750 
751         
752         emit MutantStaked(msg.sender, quantity, tokenIds);
753     }
754 
755     function calculateTime(address _owner, uint8 _type) public view returns (uint256) {
756         uint256 timeElapsed;
757         if(_type == 2) {
758             timeElapsed = block.timestamp - mutantstaker[_owner].tokenStakedAt;
759         } else {
760            timeElapsed = block.timestamp - mamstaker[_owner].tokenStakedAt;
761         }
762         
763         return timeElapsed;
764         
765     }
766 
767 
768     function calculateMamTokens(address _owner) external view returns (uint256) {
769         uint256 payout;
770        
771         uint256 time = calculateTime(_owner, 1);
772         
773         
774         payout = dayRate * time * mamstaker[_owner].numberMamStaked * 10;
775         
776         uint256 totalPayout = payout *10**18;
777         return totalPayout.div(86400);
778             
779         
780        
781     }
782 
783     function calculateMutantTokens(address _owner) external view returns (uint256) {
784          uint256 payout;
785        
786         uint256 time = calculateTime(_owner, 2);
787         
788         
789         payout = dayRate * time * mutantstaker[_owner].numberMutantStaked *  20;
790         
791         uint256 totalPayout = payout *10**18;
792         return totalPayout.div(86400);
793             
794        
795     }
796 
797     function unstakeMamById(address _owner, uint16 tokenId) external nonReentrant {
798         require(mamstaker[_owner].owner == msg.sender, "Can't unstake someone else's nfts");
799         
800         uint256 time = calculateTime(_owner, 1);
801         
802         uint256 payout;
803 
804          if(!mamstaker[_owner].daily && lockingPeriodEnforced) {
805                 require(time >= period*86400, "Staking period has not ended");
806             }
807         
808 
809         for(uint8 i; i < mamstaker[_owner].ids.length; i++) {
810             if(mamstaker[_owner].ids[i] == tokenId) {
811                 mam.transferFrom(address(this), msg.sender, tokenId);
812                 delete mamstaker[_owner].ids[i];
813                  
814             } 
815            
816         }
817         payout = dayRate * time * 10;
818 
819         uint256 totalPayout = payout *10**18;
820         uint256 totalPayoutPS = totalPayout.div(86400);
821         amountPaid+= totalPayoutPS;
822               
823         token.transfer(msg.sender, totalPayoutPS);
824                 
825         mamStaked--;
826         mamstaker[_owner].daily = true;
827         mamstaker[_owner].tokenStakedAt = block.timestamp;
828         mamstaker[_owner].numberMamStaked--;
829             
830         emit MamUnstaked(msg.sender, totalPayout);
831        
832     }
833 
834     function payoutMam(address _owner) external nonReentrant {
835         
836         
837         uint256 time = calculateTime(_owner, 1);
838         
839         uint256 payout = dayRate * time * mamstaker[_owner].numberMamStaked * 10;
840 
841          if(!mamstaker[_owner].daily && lockingPeriodEnforced) {
842                 require(time >= period*86400, "Staking period has not ended");
843             }
844         
845         uint256 totalPayout = payout *10**18;
846         uint256 totalPayoutPS = totalPayout.div(86400);
847         amountPaid+= totalPayoutPS;
848               
849         token.transfer(_owner, totalPayoutPS);
850                 
851        
852         mamstaker[_owner].daily = true;
853         mamstaker[_owner].tokenStakedAt = block.timestamp;
854 
855         emit Payout(_owner, totalPayout);
856             
857        
858     }
859 
860     
861 
862     function unstakeMam(address _owner) external nonReentrant {
863         require(mamstaker[_owner].owner == msg.sender, "Can't unstake someone else's nfts");
864         
865          uint256 time = calculateTime(_owner, 1);
866         
867         uint256 payout = dayRate * time * mamstaker[_owner].numberMamStaked * 10;
868 
869          if(!mamstaker[_owner].daily && lockingPeriodEnforced) {
870                 require(time >= period*86400, "Staking period has not ended");
871             }
872           
873 
874         for(uint8 i; i< mamstaker[_owner].ids.length; i++) {
875             if(mamstaker[_owner].ids[i] != 0) {
876                 mamstaker[_owner].remainingIds.push(mamstaker[_owner].ids[i]);
877             
878             }
879         }
880 
881         for(uint8 i; i < mamstaker[_owner].remainingIds.length; i++) {
882             
883                  mam.transferFrom(address(this), msg.sender, mamstaker[_owner].remainingIds[i]);
884             
885            
886         }
887          uint256 totalPayout = payout *10**18;
888         uint256 totalPayoutPS = totalPayout.div(86400);
889         amountPaid+= totalPayoutPS;
890               
891         token.transfer(msg.sender, totalPayoutPS);
892         
893         mamStaked-=mamstaker[_owner].numberMamStaked;
894             
895         delete mamstaker[_owner];
896             
897         emit MamUnstaked(msg.sender, totalPayoutPS);
898      
899     }
900 
901 
902 
903     function unstakeMutantById(address _owner, uint16 tokenId) external nonReentrant {
904         require(mutantstaker[_owner].owner == msg.sender, "Can't unstake someone else's nfts");
905         
906         uint256 time = calculateTime(_owner, 2);
907         
908         uint256 payout;
909 
910          if(!mutantstaker[_owner].daily && lockingPeriodEnforced) {
911                 require(time >= period*86400, "Staking period has not ended");
912             }
913         
914 
915         for(uint8 i; i < mutantstaker[_owner].ids.length; i++) {
916             if(mutantstaker[_owner].ids[i] == tokenId) {
917                 mutant.transferFrom(address(this), msg.sender, tokenId);
918                 delete mutantstaker[_owner].ids[i];
919                  
920             }
921            
922         }
923         payout = dayRate * time * 20;
924 
925         uint256 totalPayout = payout *10**18;
926         uint256 totalPayoutPS = totalPayout.div(86400);
927         amountPaid+= totalPayoutPS;
928               
929         token.transfer(msg.sender, totalPayoutPS);
930                 
931         mutantStaked--;
932         mutantstaker[_owner].daily = true;
933         mutantstaker[_owner].tokenStakedAt = block.timestamp;
934         mutantstaker[_owner].numberMutantStaked--;
935             
936         emit MutantUnstaked(msg.sender, totalPayout);
937        
938     }
939 
940 
941     function payoutMutant(address _owner) external nonReentrant {
942         
943         
944         uint256 time = calculateTime(_owner, 2);
945         
946         uint256 payout = dayRate * time * mutantstaker[_owner].numberMutantStaked * 20;
947 
948          if(!mutantstaker[_owner].daily && lockingPeriodEnforced) {
949                 require(time >= period*86400, "Staking period has not ended");
950             }
951         
952         uint256 totalPayout = payout *10**18;
953         uint256 totalPayoutPS = totalPayout.div(86400);
954         amountPaid+= totalPayoutPS;
955               
956         token.transfer(_owner, totalPayoutPS);
957                 
958        
959         mutantstaker[_owner].daily = true;
960         mutantstaker[_owner].tokenStakedAt = block.timestamp;
961 
962         emit Payout(_owner, totalPayout);
963             
964        
965     }
966 
967 
968 
969     function unstakeMutant(address _owner) external {
970         require(mutantstaker[_owner].owner == msg.sender, "Can't unstake someone else's nfts");
971         
972         uint256 time = calculateTime(_owner, 2);
973         
974         uint256 payout;
975 
976          if(!mutantstaker[_owner].daily && lockingPeriodEnforced) {
977                 require(time >= period*86400, "Staking period has not ended");
978             }
979             
980         
981        for(uint8 i; i< mutantstaker[_owner].ids.length; i++) {
982             if(mutantstaker[_owner].ids[i] != 0) {
983                 mutantstaker[_owner].remainingIds.push(mutantstaker[_owner].ids[i]);
984             
985             }
986         }
987 
988         for(uint8 i; i < mutantstaker[_owner].remainingIds.length; i++) {
989             
990                  mutant.transferFrom(address(this), msg.sender, mutantstaker[_owner].remainingIds[i]);
991             
992            
993         }
994 
995         payout = dayRate * time * mutantstaker[_owner].numberMutantStaked * 20;
996 
997 
998         uint256 totalPayout = payout *10**18;
999         uint256 totalPayoutPS = totalPayout.div(86400);
1000         amountPaid+= totalPayoutPS;
1001 
1002         
1003         token.transfer(msg.sender, totalPayoutPS);
1004             
1005              
1006         mutantStaked-=mutantstaker[_owner].numberMutantStaked;
1007             
1008         delete mutantstaker[_owner];
1009             
1010         
1011 
1012         emit MutantUnstaked(msg.sender, totalPayoutPS);
1013         
1014     
1015     }
1016         
1017 
1018    
1019   
1020   
1021   function setNFTAddress(address _newMamToken, address _newMutantToken) external onlyOwner {
1022       mam = IERC721(_newMamToken);
1023       mutant = IERC721(_newMutantToken);
1024   }
1025 
1026   function setTokenAddress(address _newToken) external onlyOwner {
1027       token = IERC20(_newToken);
1028   }
1029 
1030   function setDayRate(uint256 _newRate) external onlyOwner {
1031       dayRate = _newRate;
1032   }
1033 
1034   function enforceLockingPeriod(bool _state) external onlyOwner {
1035       lockingPeriodEnforced = _state;
1036   }
1037 
1038    /* This function can be triggered if for some reason holders are unable to 
1039       unstake their nfts.*/
1040   function openEscapeHatch(bool _state) external onlyOwner {
1041      escapeHatchOpen = _state;
1042 
1043   }
1044 
1045   function escapeHatchWithdrawal(address _owner, uint8 _type, uint16[] calldata _ids) external {
1046       require(escapeHatchOpen, "Escape hatch is closed");
1047       if(_type == 2) {
1048           require(mutantstaker[_owner].owner == msg.sender, "Can't unstake someone else's nft");
1049           for(uint8 i; i < _ids.length; i++) {
1050               mutant.transferFrom(address(this), _owner, _ids[i]);
1051           }
1052       } else {
1053           require(mamstaker[_owner].owner == msg.sender, "Can't unstake someone else's nft");
1054           for(uint8 j; j < _ids.length; j++) {
1055               mam.transferFrom(address(this), _owner, _ids[j]);
1056           }
1057       }
1058   }
1059 
1060 
1061     function setPeriod(uint256 _time) external onlyOwner {
1062         period = _time;
1063     }
1064 
1065     function totalStaked() external view returns (uint16){
1066         return mamStaked + mutantStaked;
1067 
1068     }
1069 
1070     function getEligibility(address _owner, uint8 _type) external view returns(bool) {
1071         bool eligible;
1072         if(_type == 2) {
1073             eligible = mutantstaker[_owner].daily;
1074 
1075         } else {
1076             eligible = mamstaker[_owner].daily;
1077         }
1078         return eligible;
1079     }
1080 
1081     function setRewardEligible(address _owner, uint8 _type, bool _state) external onlyOwner {
1082         if(_type == 2) {
1083             mutantstaker[_owner].daily = _state;
1084 
1085         } else {
1086             mamstaker[_owner].daily = _state;
1087         }
1088     }
1089    
1090   
1091 
1092   function getNumberMamStaked(address _owner) external view returns (uint256){
1093       return mamstaker[_owner].numberMamStaked;
1094   }
1095 
1096   function getNumberMutantStaked(address _owner) external view returns (uint256){
1097       return mutantstaker[_owner].numberMutantStaked;
1098   }
1099 
1100   
1101   function getMamIds(address _owner) external view returns (uint16[] memory){
1102       return mamstaker[_owner].ids;
1103   }
1104 
1105   function getMutantIds(address _owner) external view returns (uint16[] memory){
1106       return mutantstaker[_owner].ids;
1107   }
1108 
1109     function emergencyTokenWithdraw() external onlyOwner {
1110         uint256 balance = token.balanceOf(address(this));
1111         token.transfer(msg.sender, balance );
1112     }
1113 
1114     //This is to remove the native currency of the network (e.g. ETH, BNB, MATIC, etc.)
1115     function emergencyWithdraw() public onlyOwner nonReentrant {
1116         // This will payout the owner the contract balance.
1117         // Do not remove this otherwise you will not be able to withdraw the funds.
1118         // =============================================================================
1119         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1120         require(os);
1121         // =============================================================================
1122     }
1123 
1124      receive() external payable {}
1125     
1126 
1127 
1128    
1129 }