1 // File: @openzeppelin\contracts\token\ERC721\IERC721Receiver.sol
2 
3 // SPDX-License-Identifier: MIT
4 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721Receiver.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @title ERC721 token receiver interface
10  * @dev Interface for any contract that wants to support safeTransfers
11  * from ERC721 asset contracts.
12  */
13 interface IERC721Receiver {
14     /**
15      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
16      * by `operator` from `from`, this function is called.
17      *
18      * It must return its Solidity selector to confirm the token transfer.
19      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
20      *
21      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
22      */
23     function onERC721Received(
24         address operator,
25         address from,
26         uint256 tokenId,
27         bytes calldata data
28     ) external returns (bytes4);
29 }
30 
31 // File: node_modules\@openzeppelin\contracts\utils\introspection\IERC165.sol
32 
33 
34 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
35 
36 pragma solidity ^0.8.0;
37 
38 /**
39  * @dev Interface of the ERC165 standard, as defined in the
40  * https://eips.ethereum.org/EIPS/eip-165[EIP].
41  *
42  * Implementers can declare support of contract interfaces, which can then be
43  * queried by others ({ERC165Checker}).
44  *
45  * For an implementation, see {ERC165}.
46  */
47 interface IERC165 {
48     /**
49      * @dev Returns true if this contract implements the interface defined by
50      * `interfaceId`. See the corresponding
51      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
52      * to learn more about how these ids are created.
53      *
54      * This function call must use less than 30 000 gas.
55      */
56     function supportsInterface(bytes4 interfaceId) external view returns (bool);
57 }
58 
59 // File: @openzeppelin\contracts\token\ERC721\IERC721.sol
60 
61 
62 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)
63 
64 pragma solidity ^0.8.0;
65 
66 
67 /**
68  * @dev Required interface of an ERC721 compliant contract.
69  */
70 interface IERC721 is IERC165 {
71     /**
72      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
73      */
74     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
75 
76     /**
77      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
78      */
79     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
80 
81     /**
82      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
83      */
84     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
85 
86     /**
87      * @dev Returns the number of tokens in ``owner``'s account.
88      */
89     function balanceOf(address owner) external view returns (uint256 balance);
90 
91     /**
92      * @dev Returns the owner of the `tokenId` token.
93      *
94      * Requirements:
95      *
96      * - `tokenId` must exist.
97      */
98     function ownerOf(uint256 tokenId) external view returns (address owner);
99 
100     /**
101      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
102      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
103      *
104      * Requirements:
105      *
106      * - `from` cannot be the zero address.
107      * - `to` cannot be the zero address.
108      * - `tokenId` token must exist and be owned by `from`.
109      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
110      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
111      *
112      * Emits a {Transfer} event.
113      */
114     function safeTransferFrom(
115         address from,
116         address to,
117         uint256 tokenId
118     ) external;
119 
120     /**
121      * @dev Transfers `tokenId` token from `from` to `to`.
122      *
123      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
124      *
125      * Requirements:
126      *
127      * - `from` cannot be the zero address.
128      * - `to` cannot be the zero address.
129      * - `tokenId` token must be owned by `from`.
130      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
131      *
132      * Emits a {Transfer} event.
133      */
134     function transferFrom(
135         address from,
136         address to,
137         uint256 tokenId
138     ) external;
139 
140     /**
141      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
142      * The approval is cleared when the token is transferred.
143      *
144      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
145      *
146      * Requirements:
147      *
148      * - The caller must own the token or be an approved operator.
149      * - `tokenId` must exist.
150      *
151      * Emits an {Approval} event.
152      */
153     function approve(address to, uint256 tokenId) external;
154 
155     /**
156      * @dev Returns the account approved for `tokenId` token.
157      *
158      * Requirements:
159      *
160      * - `tokenId` must exist.
161      */
162     function getApproved(uint256 tokenId) external view returns (address operator);
163 
164     /**
165      * @dev Approve or remove `operator` as an operator for the caller.
166      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
167      *
168      * Requirements:
169      *
170      * - The `operator` cannot be the caller.
171      *
172      * Emits an {ApprovalForAll} event.
173      */
174     function setApprovalForAll(address operator, bool _approved) external;
175 
176     /**
177      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
178      *
179      * See {setApprovalForAll}
180      */
181     function isApprovedForAll(address owner, address operator) external view returns (bool);
182 
183     /**
184      * @dev Safely transfers `tokenId` token from `from` to `to`.
185      *
186      * Requirements:
187      *
188      * - `from` cannot be the zero address.
189      * - `to` cannot be the zero address.
190      * - `tokenId` token must exist and be owned by `from`.
191      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
192      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
193      *
194      * Emits a {Transfer} event.
195      */
196     function safeTransferFrom(
197         address from,
198         address to,
199         uint256 tokenId,
200         bytes calldata data
201     ) external;
202 }
203 
204 // File: contracts\lib\IMintableERC20.sol
205 
206 
207 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
208 
209 pragma solidity ^0.8.0;
210 
211 /**
212  * @dev Interface of the ERC20 standard as defined in the EIP.
213  */
214 interface IMintableERC20 {
215     function mint(address to, uint256 amount) external;
216     /**
217      * @dev Returns the amount of tokens in existence.
218      */
219     function totalSupply() external view returns (uint256);
220 
221     /**
222      * @dev Returns the amount of tokens owned by `account`.
223      */
224     function balanceOf(address account) external view returns (uint256);
225 
226     /**
227      * @dev Moves `amount` tokens from the caller's account to `recipient`.
228      *
229      * Returns a boolean value indicating whether the operation succeeded.
230      *
231      * Emits a {Transfer} event.
232      */
233     function transfer(address recipient, uint256 amount) external returns (bool);
234 
235     /**
236      * @dev Returns the remaining number of tokens that `spender` will be
237      * allowed to spend on behalf of `owner` through {transferFrom}. This is
238      * zero by default.
239      *
240      * This value changes when {approve} or {transferFrom} are called.
241      */
242     function allowance(address owner, address spender) external view returns (uint256);
243 
244     /**
245      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
246      *
247      * Returns a boolean value indicating whether the operation succeeded.
248      *
249      * IMPORTANT: Beware that changing an allowance with this method brings the risk
250      * that someone may use both the old and the new allowance by unfortunate
251      * transaction ordering. One possible solution to mitigate this race
252      * condition is to first reduce the spender's allowance to 0 and set the
253      * desired value afterwards:
254      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
255      *
256      * Emits an {Approval} event.
257      */
258     function approve(address spender, uint256 amount) external returns (bool);
259 
260     /**
261      * @dev Moves `amount` tokens from `sender` to `recipient` using the
262      * allowance mechanism. `amount` is then deducted from the caller's
263      * allowance.
264      *
265      * Returns a boolean value indicating whether the operation succeeded.
266      *
267      * Emits a {Transfer} event.
268      */
269     function transferFrom(
270         address sender,
271         address recipient,
272         uint256 amount
273     ) external returns (bool);
274 
275     /**
276      * @dev Emitted when `value` tokens are moved from one account (`from`) to
277      * another (`to`).
278      *
279      * Note that `value` may be zero.
280      */
281     event Transfer(address indexed from, address indexed to, uint256 value);
282 
283     /**
284      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
285      * a call to {approve}. `value` is the new allowance.
286      */
287     event Approval(address indexed owner, address indexed spender, uint256 value);
288 }
289 
290 // File: node_modules\@openzeppelin\contracts\utils\Context.sol
291 
292 
293 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
294 
295 pragma solidity ^0.8.0;
296 
297 /**
298  * @dev Provides information about the current execution context, including the
299  * sender of the transaction and its data. While these are generally available
300  * via msg.sender and msg.data, they should not be accessed in such a direct
301  * manner, since when dealing with meta-transactions the account sending and
302  * paying for execution may not be the actual sender (as far as an application
303  * is concerned).
304  *
305  * This contract is only required for intermediate, library-like contracts.
306  */
307 abstract contract Context {
308     function _msgSender() internal view virtual returns (address) {
309         return msg.sender;
310     }
311 
312     function _msgData() internal view virtual returns (bytes calldata) {
313         return msg.data;
314     }
315 }
316 
317 // File: @openzeppelin\contracts\access\Ownable.sol
318 
319 
320 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
321 
322 pragma solidity ^0.8.0;
323 
324 
325 /**
326  * @dev Contract module which provides a basic access control mechanism, where
327  * there is an account (an owner) that can be granted exclusive access to
328  * specific functions.
329  *
330  * By default, the owner account will be the one that deploys the contract. This
331  * can later be changed with {transferOwnership}.
332  *
333  * This module is used through inheritance. It will make available the modifier
334  * `onlyOwner`, which can be applied to your functions to restrict their use to
335  * the owner.
336  */
337 abstract contract Ownable is Context {
338     address private _owner;
339 
340     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
341 
342     /**
343      * @dev Initializes the contract setting the deployer as the initial owner.
344      */
345     constructor() {
346         _transferOwnership(_msgSender());
347     }
348 
349     /**
350      * @dev Returns the address of the current owner.
351      */
352     function owner() public view virtual returns (address) {
353         return _owner;
354     }
355 
356     /**
357      * @dev Throws if called by any account other than the owner.
358      */
359     modifier onlyOwner() {
360         require(owner() == _msgSender(), "Ownable: caller is not the owner");
361         _;
362     }
363 
364     /**
365      * @dev Leaves the contract without owner. It will not be possible to call
366      * `onlyOwner` functions anymore. Can only be called by the current owner.
367      *
368      * NOTE: Renouncing ownership will leave the contract without an owner,
369      * thereby removing any functionality that is only available to the owner.
370      */
371     function renounceOwnership() public virtual onlyOwner {
372         _transferOwnership(address(0));
373     }
374 
375     /**
376      * @dev Transfers ownership of the contract to a new account (`newOwner`).
377      * Can only be called by the current owner.
378      */
379     function transferOwnership(address newOwner) public virtual onlyOwner {
380         require(newOwner != address(0), "Ownable: new owner is the zero address");
381         _transferOwnership(newOwner);
382     }
383 
384     /**
385      * @dev Transfers ownership of the contract to a new account (`newOwner`).
386      * Internal function without access restriction.
387      */
388     function _transferOwnership(address newOwner) internal virtual {
389         address oldOwner = _owner;
390         _owner = newOwner;
391         emit OwnershipTransferred(oldOwner, newOwner);
392     }
393 }
394 
395 // File: @openzeppelin\contracts\utils\math\SafeMath.sol
396 
397 
398 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
399 
400 pragma solidity ^0.8.0;
401 
402 // CAUTION
403 // This version of SafeMath should only be used with Solidity 0.8 or later,
404 // because it relies on the compiler's built in overflow checks.
405 
406 /**
407  * @dev Wrappers over Solidity's arithmetic operations.
408  *
409  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
410  * now has built in overflow checking.
411  */
412 library SafeMath {
413     /**
414      * @dev Returns the addition of two unsigned integers, with an overflow flag.
415      *
416      * _Available since v3.4._
417      */
418     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
419         unchecked {
420             uint256 c = a + b;
421             if (c < a) return (false, 0);
422             return (true, c);
423         }
424     }
425 
426     /**
427      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
428      *
429      * _Available since v3.4._
430      */
431     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
432         unchecked {
433             if (b > a) return (false, 0);
434             return (true, a - b);
435         }
436     }
437 
438     /**
439      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
440      *
441      * _Available since v3.4._
442      */
443     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
444         unchecked {
445             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
446             // benefit is lost if 'b' is also tested.
447             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
448             if (a == 0) return (true, 0);
449             uint256 c = a * b;
450             if (c / a != b) return (false, 0);
451             return (true, c);
452         }
453     }
454 
455     /**
456      * @dev Returns the division of two unsigned integers, with a division by zero flag.
457      *
458      * _Available since v3.4._
459      */
460     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
461         unchecked {
462             if (b == 0) return (false, 0);
463             return (true, a / b);
464         }
465     }
466 
467     /**
468      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
469      *
470      * _Available since v3.4._
471      */
472     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
473         unchecked {
474             if (b == 0) return (false, 0);
475             return (true, a % b);
476         }
477     }
478 
479     /**
480      * @dev Returns the addition of two unsigned integers, reverting on
481      * overflow.
482      *
483      * Counterpart to Solidity's `+` operator.
484      *
485      * Requirements:
486      *
487      * - Addition cannot overflow.
488      */
489     function add(uint256 a, uint256 b) internal pure returns (uint256) {
490         return a + b;
491     }
492 
493     /**
494      * @dev Returns the subtraction of two unsigned integers, reverting on
495      * overflow (when the result is negative).
496      *
497      * Counterpart to Solidity's `-` operator.
498      *
499      * Requirements:
500      *
501      * - Subtraction cannot overflow.
502      */
503     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
504         return a - b;
505     }
506 
507     /**
508      * @dev Returns the multiplication of two unsigned integers, reverting on
509      * overflow.
510      *
511      * Counterpart to Solidity's `*` operator.
512      *
513      * Requirements:
514      *
515      * - Multiplication cannot overflow.
516      */
517     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
518         return a * b;
519     }
520 
521     /**
522      * @dev Returns the integer division of two unsigned integers, reverting on
523      * division by zero. The result is rounded towards zero.
524      *
525      * Counterpart to Solidity's `/` operator.
526      *
527      * Requirements:
528      *
529      * - The divisor cannot be zero.
530      */
531     function div(uint256 a, uint256 b) internal pure returns (uint256) {
532         return a / b;
533     }
534 
535     /**
536      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
537      * reverting when dividing by zero.
538      *
539      * Counterpart to Solidity's `%` operator. This function uses a `revert`
540      * opcode (which leaves remaining gas untouched) while Solidity uses an
541      * invalid opcode to revert (consuming all remaining gas).
542      *
543      * Requirements:
544      *
545      * - The divisor cannot be zero.
546      */
547     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
548         return a % b;
549     }
550 
551     /**
552      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
553      * overflow (when the result is negative).
554      *
555      * CAUTION: This function is deprecated because it requires allocating memory for the error
556      * message unnecessarily. For custom revert reasons use {trySub}.
557      *
558      * Counterpart to Solidity's `-` operator.
559      *
560      * Requirements:
561      *
562      * - Subtraction cannot overflow.
563      */
564     function sub(
565         uint256 a,
566         uint256 b,
567         string memory errorMessage
568     ) internal pure returns (uint256) {
569         unchecked {
570             require(b <= a, errorMessage);
571             return a - b;
572         }
573     }
574 
575     /**
576      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
577      * division by zero. The result is rounded towards zero.
578      *
579      * Counterpart to Solidity's `/` operator. Note: this function uses a
580      * `revert` opcode (which leaves remaining gas untouched) while Solidity
581      * uses an invalid opcode to revert (consuming all remaining gas).
582      *
583      * Requirements:
584      *
585      * - The divisor cannot be zero.
586      */
587     function div(
588         uint256 a,
589         uint256 b,
590         string memory errorMessage
591     ) internal pure returns (uint256) {
592         unchecked {
593             require(b > 0, errorMessage);
594             return a / b;
595         }
596     }
597 
598     /**
599      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
600      * reverting with custom message when dividing by zero.
601      *
602      * CAUTION: This function is deprecated because it requires allocating memory for the error
603      * message unnecessarily. For custom revert reasons use {tryMod}.
604      *
605      * Counterpart to Solidity's `%` operator. This function uses a `revert`
606      * opcode (which leaves remaining gas untouched) while Solidity uses an
607      * invalid opcode to revert (consuming all remaining gas).
608      *
609      * Requirements:
610      *
611      * - The divisor cannot be zero.
612      */
613     function mod(
614         uint256 a,
615         uint256 b,
616         string memory errorMessage
617     ) internal pure returns (uint256) {
618         unchecked {
619             require(b > 0, errorMessage);
620             return a % b;
621         }
622     }
623 }
624 
625 // File: contracts\ConsoleStake.sol
626 
627 
628 
629 pragma solidity ^0.8.0;
630 
631 
632 
633 
634 
635 
636 contract ConsoleStake is IERC721Receiver, Ownable {
637   using SafeMath for uint256;
638 
639   uint256 constant SECINDAY = 86400;
640   
641   IMintableERC20 public gameToken;
642   IERC721 public consoleToken;
643 
644   // struct to store a stake's token, owner, and earning values
645   struct Stake {
646     uint256 lastClaim;
647     address owner;
648   }
649 
650   // maps tokenId to stake
651   mapping(uint256 => Stake) public stakes; 
652 
653   event TokenStaked(address owner, uint256 tokenId);
654   event TokenUnStaked(address owner, uint256 tokenId);
655   event GameClaimed(uint256 tokenId, uint256 earned);
656   
657   constructor(IMintableERC20 _gameToken, IERC721 _consoleToken) { 
658     gameToken = _gameToken;
659     consoleToken = _consoleToken;
660   }
661 
662   function stakeConsoles(uint16[] calldata tokenIds) external {
663     for (uint i = 0; i < tokenIds.length; i++) {
664       require(consoleToken.ownerOf(tokenIds[i]) == _msgSender(), "not_token_owner");
665       consoleToken.transferFrom(_msgSender(), address(this), tokenIds[i]);
666       _stakeConsole(_msgSender(), tokenIds[i]);
667     }
668   }
669 
670   function unstakeConsoles(uint16[] calldata tokenIds) external {
671     for (uint i = 0; i < tokenIds.length; i++) { 
672       require(stakes[tokenIds[i]].owner == _msgSender(), "not_token_owner");
673       consoleToken.transferFrom(address(this), _msgSender(), tokenIds[i]);
674       _unstakeConsole(_msgSender(), tokenIds[i]);
675     }
676   }
677 
678   function claim(uint16[] calldata tokenIds) external {
679     uint256 amount = 0;
680     for (uint i = 0; i < tokenIds.length; i++) {
681       require(stakes[tokenIds[i]].owner == _msgSender(), "not_token_owner");
682       amount = amount.add(_claim(tokenIds[i]));
683     }
684 
685     // transfer Game token reward
686     if (amount > 0) {
687       gameToken.mint(msg.sender, amount * 10 ** 18);
688     }
689   }
690 
691   function onERC721Received(
692     address,
693     address from,
694     uint256,
695     bytes calldata
696   ) external pure override returns (bytes4) {
697     require(from == address(0x0), "Cannot send tokens to Barn directly");
698     return IERC721Receiver.onERC721Received.selector;
699   }
700 
701   function _stakeConsole(address account, uint256 tokenId) internal {
702     stakes[tokenId] = Stake({
703       lastClaim: block.timestamp,
704       owner: account
705     });
706     emit TokenStaked(account, tokenId);
707   }
708 
709   function _unstakeConsole(address account, uint256 tokenId) internal {
710     delete stakes[tokenId];
711     emit TokenUnStaked(account, tokenId);
712   }
713 
714   /**
715     update last claim time for stake, returns amount of Game token be rewarded
716    */
717   function _claim(uint16 tokenId) internal returns (uint256){
718     Stake storage stake = stakes[tokenId];
719     uint256 amount = block.timestamp.sub(stake.lastClaim).div(SECINDAY);
720     if (amount > 0) {
721       stake.lastClaim = stake.lastClaim.add(amount.mul(SECINDAY));
722       emit GameClaimed(tokenId, amount);
723     }
724     return amount;
725   }
726 }