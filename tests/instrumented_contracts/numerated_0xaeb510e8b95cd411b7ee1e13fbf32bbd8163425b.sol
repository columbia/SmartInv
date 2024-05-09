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
113 // File: contracts/mamstaking.sol
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
643         uint256 numberMamStaked;
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
655         uint256 numberMutantStaked;
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
666     mapping(address => bool) public blacklistedUsers;
667    
668     
669 
670 
671     uint256 public dayRate = 1;
672     uint256 public period = 45; //number of days
673     
674 
675 
676     
677     uint256 public mamStaked;
678     uint256 public mutantStaked;
679     uint256 public amountPaid;
680     uint256 public decimals = 18;
681    
682 
683     bool public lockingPeriodEnforced = true;
684     bool public escapeHatchOpen = false;
685     
686 
687 
688     event MamStaked(address indexed, uint256, uint16[]);
689     event MutantStaked(address indexed, uint256, uint16[]);
690     event MamUnstaked(address indexed, uint256);
691     event MutantUnstaked(address indexed, uint256);
692     event Payout(address indexed, uint256);
693     event DayRateChange(uint256);
694     event PeriodChange(uint256);
695 
696     //mamids
697     //legendary, top10% 
698 
699     //mutantids
700     //only legendarys
701 
702     constructor(address _mam, address _mutant, address _token)  {
703         mam = IERC721(_mam);
704         mutant = IERC721(_mutant);
705 
706         token = IERC20(_token);
707         
708 
709     }
710 
711     
712 
713     function onERC721Received(address, address, uint256, bytes calldata) external pure returns (bytes4) {
714         return IERC721Receiver.onERC721Received.selector;
715     }
716 
717     
718 
719     function mamStake(uint16[] memory tokenIds) external {
720         require(!blacklistedUsers[msg.sender], "User is blacklisted");
721         uint256 quantity = tokenIds.length;
722         mamstaker[msg.sender].tokenStakedAt = block.timestamp;
723         mamstaker[msg.sender].numberMamStaked+= quantity;
724         mamstaker[msg.sender].owner = msg.sender;
725         mamstaker[msg.sender].daily = false;
726         
727           
728         mamStaked+=quantity;
729         
730         for(uint8 i; i < tokenIds.length; i++) {
731             mamstaker[msg.sender].ids.push(tokenIds[i]);
732             mam.safeTransferFrom(msg.sender, address(this), tokenIds[i]);
733         }
734 
735         
736         emit MamStaked(msg.sender, quantity, tokenIds);
737     }
738 
739     
740     
741     function mutantStake(uint16[] memory tokenIds) external {
742         require(!blacklistedUsers[msg.sender], "User is blacklisted");
743         uint256 quantity = tokenIds.length;
744        mutantstaker[msg.sender].tokenStakedAt = block.timestamp;
745         mutantstaker[msg.sender].numberMutantStaked+= quantity;
746         mutantstaker[msg.sender].owner = msg.sender;
747         mutantstaker[msg.sender].daily = false;
748         
749         
750         
751         mutantStaked+=quantity;
752         
753         for(uint8 i; i < tokenIds.length; i++) {
754             mutantstaker[msg.sender].ids.push(tokenIds[i]);
755             mutant.safeTransferFrom(msg.sender, address(this), tokenIds[i]);
756         }
757 
758         
759         emit MutantStaked(msg.sender, quantity, tokenIds);
760     }
761 
762     function calculateTime(address _owner, uint8 _type) public view returns (uint256) {
763         uint256 timeElapsed;
764         if(_type == 2) {
765             timeElapsed = block.timestamp - mutantstaker[_owner].tokenStakedAt;
766         } else {
767            timeElapsed = block.timestamp - mamstaker[_owner].tokenStakedAt;
768         }
769         
770         return timeElapsed;
771         
772     }
773 
774 
775     function calculateMamTokens(address _owner) external view returns (uint256) {
776         uint256 payout;
777        
778         uint256 time = calculateTime(_owner, 1);
779         
780         
781         payout = dayRate * time * mamstaker[_owner].numberMamStaked * 10;
782         
783         uint256 totalPayout = payout *(10**decimals);
784         return totalPayout.div(86400);
785             
786         
787        
788     }
789 
790     function calculateMutantTokens(address _owner) external view returns (uint256) {
791          uint256 payout;
792        
793         uint256 time = calculateTime(_owner, 2);
794         
795         
796         payout = dayRate * time * mutantstaker[_owner].numberMutantStaked *  20;
797         
798         uint256 totalPayout = payout *(10**decimals);
799         return totalPayout.div(86400);
800             
801        
802     }
803 
804     function unstakeMamById(address _owner, uint16 tokenId) external nonReentrant {
805         require(!blacklistedUsers[msg.sender], "User is blacklisted");
806         require(mamstaker[_owner].owner == msg.sender, "Can't unstake someone else's nfts");
807         require(tokenId != 0, "tokenId cannot be zero");
808 
809         bool exists = false;
810         uint256 time = calculateTime(_owner, 1);
811         
812         uint256 payout;
813 
814          if(!mamstaker[_owner].daily && lockingPeriodEnforced) {
815                 require(time >= period*86400, "Staking period has not ended");
816             }
817         
818 
819         for(uint8 i; i < mamstaker[_owner].ids.length; i++) {
820             if(mamstaker[_owner].ids[i] == tokenId) {
821                 mam.transferFrom(address(this), msg.sender, tokenId);
822                 delete mamstaker[_owner].ids[i];
823                exists = true; 
824                  
825             } 
826            
827         }
828         if(exists) {
829             
830             mamStaked--;
831             mamstaker[_owner].numberMamStaked--;
832                 
833         payout = dayRate * time * 10;
834 
835         uint256 totalPayout = payout *(10**decimals);
836         uint256 totalPayoutPS = totalPayout.div(86400);
837         amountPaid+= totalPayoutPS;
838               
839         token.transfer(msg.sender, totalPayoutPS);
840                 
841         
842         mamstaker[_owner].daily = true;
843         mamstaker[_owner].tokenStakedAt = block.timestamp;
844 
845         emit MamUnstaked(msg.sender, totalPayout);
846         } else {
847             revert("tokenId not staked or nonexistent");
848         }
849 
850         
851         
852             
853         
854        
855     }
856 
857     function payoutMam(address _owner) external nonReentrant {
858         require(!blacklistedUsers[msg.sender], "User is blacklisted");
859         require(mamstaker[_owner].owner == msg.sender, "Can't initiate someone else's payout");
860         
861         
862         uint256 time = calculateTime(_owner, 1);
863         
864         uint256 payout = dayRate * time * mamstaker[_owner].numberMamStaked * 10;
865 
866          if(!mamstaker[_owner].daily && lockingPeriodEnforced) {
867                 require(time >= period*86400, "Staking period has not ended");
868             }
869         
870         uint256 totalPayout = payout *(10**decimals);
871         uint256 totalPayoutPS = totalPayout.div(86400);
872         amountPaid+= totalPayoutPS;
873               
874         token.transfer(_owner, totalPayoutPS);
875                 
876        
877         mamstaker[_owner].daily = true;
878         mamstaker[_owner].tokenStakedAt = block.timestamp;
879 
880         emit Payout(_owner, totalPayout);
881             
882        
883     }
884 
885     
886 
887     function unstakeMam(address _owner) external nonReentrant {
888         require(!blacklistedUsers[msg.sender], "User is blacklisted");
889         require(mamstaker[_owner].owner == msg.sender, "Can't unstake someone else's nfts");
890         
891          uint256 time = calculateTime(_owner, 1);
892         
893         uint256 payout = dayRate * time * mamstaker[_owner].numberMamStaked * 10;
894 
895          if(!mamstaker[_owner].daily && lockingPeriodEnforced) {
896                 require(time >= period*86400, "Staking period has not ended");
897             }
898           
899 
900         for(uint8 i; i< mamstaker[_owner].ids.length; i++) {
901             if(mamstaker[_owner].ids[i] != 0) {
902                 mamstaker[_owner].remainingIds.push(mamstaker[_owner].ids[i]);
903             
904             }
905         }
906 
907         for(uint8 i; i < mamstaker[_owner].remainingIds.length; i++) {
908             
909                  mam.transferFrom(address(this), msg.sender, mamstaker[_owner].remainingIds[i]);
910             
911            
912         }
913          uint256 totalPayout = payout *(10**decimals);
914         uint256 totalPayoutPS = totalPayout.div(86400);
915         amountPaid+= totalPayoutPS;
916               
917         token.transfer(msg.sender, totalPayoutPS);
918         
919         mamStaked-=mamstaker[_owner].numberMamStaked;
920             
921         delete mamstaker[_owner];
922             
923         emit MamUnstaked(msg.sender, totalPayoutPS);
924      
925     }
926 
927 
928 
929     function unstakeMutantById(address _owner, uint16 tokenId) external nonReentrant {
930         require(!blacklistedUsers[msg.sender], "User is blacklisted");
931         require(mutantstaker[_owner].owner == msg.sender, "Can't unstake someone else's nfts");
932         require(tokenId != 0, "tokenId cannot be zero");
933         
934         uint256 time = calculateTime(_owner, 2);
935         bool exists = false;
936         
937         uint256 payout;
938 
939          if(!mutantstaker[_owner].daily && lockingPeriodEnforced) {
940                 require(time >= period*86400, "Staking period has not ended");
941             }
942         
943 
944         for(uint8 i; i < mutantstaker[_owner].ids.length; i++) {
945             if(mutantstaker[_owner].ids[i] == tokenId) {
946                 mutant.transferFrom(address(this), msg.sender, tokenId);
947                 delete mutantstaker[_owner].ids[i];
948                 exists = true;
949                  
950             }
951            
952         }
953 
954         if(exists) {
955             mutantStaked--;
956             mutantstaker[_owner].numberMutantStaked--;
957             payout = dayRate * time * 20;
958 
959         uint256 totalPayout = payout *(10**decimals);
960         uint256 totalPayoutPS = totalPayout.div(86400);
961         amountPaid+= totalPayoutPS;
962               
963         token.transfer(msg.sender, totalPayoutPS);
964                 
965         
966         mutantstaker[_owner].daily = true;
967         mutantstaker[_owner].tokenStakedAt = block.timestamp;
968         
969             
970         emit MutantUnstaked(msg.sender, totalPayout);
971         } else {
972             revert("tokenId not staked or nonexistent");
973         }
974         
975        
976     }
977 
978 
979     function payoutMutant(address _owner) external nonReentrant {
980         require(!blacklistedUsers[msg.sender], "User is blacklisted");
981         require(mutantstaker[_owner].owner == msg.sender, "Can't initiate someone else's payout");
982         
983         
984         uint256 time = calculateTime(_owner, 2);
985         
986         uint256 payout = dayRate * time * mutantstaker[_owner].numberMutantStaked * 20;
987 
988          if(!mutantstaker[_owner].daily && lockingPeriodEnforced) {
989                 require(time >= period*86400, "Staking period has not ended");
990             }
991         
992         uint256 totalPayout = payout *(10**decimals);
993         uint256 totalPayoutPS = totalPayout.div(86400);
994         amountPaid+= totalPayoutPS;
995               
996         token.transfer(_owner, totalPayoutPS);
997                 
998        
999         mutantstaker[_owner].daily = true;
1000         mutantstaker[_owner].tokenStakedAt = block.timestamp;
1001 
1002         emit Payout(_owner, totalPayout);
1003             
1004        
1005     }
1006 
1007 
1008 
1009     function unstakeMutant(address _owner) external {
1010         require(!blacklistedUsers[msg.sender], "User is blacklisted");
1011         require(mutantstaker[_owner].owner == msg.sender, "Can't unstake someone else's nfts");
1012         
1013         uint256 time = calculateTime(_owner, 2);
1014         
1015         uint256 payout;
1016 
1017          if(!mutantstaker[_owner].daily && lockingPeriodEnforced) {
1018                 require(time >= period*86400, "Staking period has not ended");
1019             }
1020             
1021         
1022        for(uint8 i; i< mutantstaker[_owner].ids.length; i++) {
1023             if(mutantstaker[_owner].ids[i] != 0) {
1024                 mutantstaker[_owner].remainingIds.push(mutantstaker[_owner].ids[i]);
1025             
1026             }
1027         }
1028 
1029         for(uint8 i; i < mutantstaker[_owner].remainingIds.length; i++) {
1030             
1031                  mutant.transferFrom(address(this), msg.sender, mutantstaker[_owner].remainingIds[i]);
1032             
1033            
1034         }
1035 
1036         payout = dayRate * time * mutantstaker[_owner].numberMutantStaked * 20;
1037 
1038 
1039         uint256 totalPayout = payout *(10**decimals);
1040         uint256 totalPayoutPS = totalPayout.div(86400);
1041         amountPaid+= totalPayoutPS;
1042 
1043         
1044         token.transfer(msg.sender, totalPayoutPS);
1045             
1046              
1047         mutantStaked-=mutantstaker[_owner].numberMutantStaked;
1048             
1049         delete mutantstaker[_owner];
1050             
1051         
1052 
1053         emit MutantUnstaked(msg.sender, totalPayoutPS);
1054         
1055     
1056     }
1057         
1058 
1059    
1060   
1061   
1062   function setNFTAddress(address _newMamToken, address _newMutantToken) external onlyOwner {
1063       require(_newMamToken != address(0) && _newMutantToken != address(0), "Address invalid");
1064       mam = IERC721(_newMamToken);
1065       mutant = IERC721(_newMutantToken);
1066   }
1067 
1068   function setTokenAddress(address _newToken) external onlyOwner {
1069       token = IERC20(_newToken);
1070   }
1071 
1072   function setDayRate(uint256 _newRate) external onlyOwner {
1073       require(_newRate != 0, "rate cannot be zero");
1074       dayRate = _newRate;
1075       emit DayRateChange(_newRate);
1076   }
1077 
1078   
1079   function enforceLockingPeriod(bool _state) external onlyOwner {
1080       lockingPeriodEnforced = _state;
1081   }
1082 
1083    /* This function can be triggered if for some reason holders are unable to 
1084       unstake their nfts.*/
1085   function openEscapeHatch(bool _state) external onlyOwner {
1086      escapeHatchOpen = _state;
1087 
1088   }
1089   /* EscapeHatchWithdrawal should only be called as a last resort if the contract is hacked or compromised
1090   * in any way. It is designed to allow the user to withdraw NFTs by id at minimum cost and without regard
1091   * for updating states or any other actions that would cause the function to be more expensive. Only use
1092   * this function if you do not plan on using this contract any further. 
1093   *Note: escapeHatchOpen must first be set to true by the owner.
1094   *@param _owner - user address
1095   *@param _type - 1: mam 2: mutant
1096   *@param _ids - array containing tokenIds belonging to user
1097   */
1098 
1099   function escapeHatchWithdrawal(address _owner, uint8 _type, uint16[] calldata _ids) external {
1100       require(escapeHatchOpen, "Escape hatch is closed");
1101       if(_type == 2) {
1102           require(mutantstaker[_owner].owner == msg.sender, "Can't unstake someone else's nft");
1103           for(uint8 i; i < _ids.length; i++) {
1104               mutant.transferFrom(address(this), _owner, _ids[i]);
1105               
1106           }
1107       } else {
1108           require(mamstaker[_owner].owner == msg.sender, "Can't unstake someone else's nft");
1109           for(uint8 j; j < _ids.length; j++) {
1110               mam.transferFrom(address(this), _owner, _ids[j]);
1111               
1112           }
1113       }
1114   }
1115 
1116 
1117     function setPeriod(uint256 _time) external onlyOwner {
1118         period = _time;
1119         emit PeriodChange(_time);
1120     }
1121 
1122     function totalStaked() external view returns (uint256){
1123         return mamStaked + mutantStaked;
1124 
1125     }
1126 
1127     function getEligibility(address _owner, uint8 _type) external view returns(bool) {
1128         bool eligible;
1129         if(_type == 2) {
1130             eligible = mutantstaker[_owner].daily;
1131 
1132         } else {
1133             eligible = mamstaker[_owner].daily;
1134         }
1135         return eligible;
1136     }
1137 
1138     function setRewardEligible(address _owner, uint8 _type, bool _state) external onlyOwner {
1139         if(_type == 2) {
1140             mutantstaker[_owner].daily = _state;
1141 
1142         } else {
1143             mamstaker[_owner].daily = _state;
1144         }
1145     }
1146    
1147   
1148 
1149   function getNumberMamStaked(address _owner) external view returns (uint256){
1150       return mamstaker[_owner].numberMamStaked;
1151   }
1152 
1153   function getNumberMutantStaked(address _owner) external view returns (uint256){
1154       return mutantstaker[_owner].numberMutantStaked;
1155   }
1156 
1157   
1158   function getMamIds(address _owner) external view returns (uint16[] memory){
1159       return mamstaker[_owner].ids;
1160   }
1161 
1162   function getMutantIds(address _owner) external view returns (uint16[] memory){
1163       return mutantstaker[_owner].ids;
1164   }
1165 
1166   function blacklistUser(address _owner) external onlyOwner {
1167       blacklistedUsers[_owner] = true;
1168   }
1169 
1170   function removeFromBlacklist(address _owner) external onlyOwner {
1171       blacklistedUsers[_owner] = false;
1172   }
1173 
1174     function emergencyTokenWithdraw() external onlyOwner {
1175         uint256 balance = token.balanceOf(address(this));
1176         token.transfer(msg.sender, balance );
1177     }
1178 
1179     //This is to remove the native currency of the network (e.g. ETH, BNB, MATIC, etc.)
1180     function emergencyWithdraw() public onlyOwner nonReentrant {
1181         // This will payout the owner the contract balance.
1182         // Do not remove this otherwise you will not be able to withdraw the funds.
1183         // =============================================================================
1184         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1185         require(os);
1186         // =============================================================================
1187     }
1188 
1189      receive() external payable {}
1190     
1191 
1192 
1193    
1194 }