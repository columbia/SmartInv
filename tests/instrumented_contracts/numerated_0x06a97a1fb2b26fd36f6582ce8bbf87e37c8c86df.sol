1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.8;
3 
4 /**
5  * @dev Contract module that helps prevent reentrant calls to a function.
6  *
7  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
8  * available, which can be applied to functions to make sure there are no nested
9  * (reentrant) calls to them.
10  *
11  * Note that because there is a single `nonReentrant` guard, functions marked as
12  * `nonReentrant` may not call one another. This can be worked around by making
13  * those functions `private`, and then adding `external` `nonReentrant` entry
14  * points to them.
15  *
16  * TIP: If you would like to learn more about reentrancy and alternative ways
17  * to protect against it, check out our blog post
18  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
19  */
20 abstract contract ReentrancyGuard {
21     // Booleans are more expensive than uint256 or any type that takes up a full
22     // word because each write operation emits an extra SLOAD to first read the
23     // slot's contents, replace the bits taken up by the boolean, and then write
24     // back. This is the compiler's defense against contract upgrades and
25     // pointer aliasing, and it cannot be disabled.
26 
27     // The values being non-zero value makes deployment a bit more expensive,
28     // but in exchange the refund on every call to nonReentrant will be lower in
29     // amount. Since refunds are capped to a percentage of the total
30     // transaction's gas, it is best to keep them low in cases like this one, to
31     // increase the likelihood of the full refund coming into effect.
32     uint256 private constant _NOT_ENTERED = 1;
33     uint256 private constant _ENTERED = 2;
34 
35     uint256 private _status;
36 
37     constructor() {
38         _status = _NOT_ENTERED;
39     }
40 
41     /**
42      * @dev Prevents a contract from calling itself, directly or indirectly.
43      * Calling a `nonReentrant` function from another `nonReentrant`
44      * function is not supported. It is possible to prevent this from happening
45      * by making the `nonReentrant` function external, and making it call a
46      * `private` function that does the actual work.
47      */
48     modifier nonReentrant() {
49         // On the first call to nonReentrant, _notEntered will be true
50         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
51 
52         // Any calls to nonReentrant after this point will fail
53         _status = _ENTERED;
54 
55         _;
56 
57         // By storing the original value once again, a refund is triggered (see
58         // https://eips.ethereum.org/EIPS/eip-2200)
59         _status = _NOT_ENTERED;
60     }
61 }
62 
63 /**
64  * @title Counters
65  * @author Matt Condon (@shrugs)
66  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
67  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
68  *
69  * Include with `using Counters for Counters.Counter;`
70  */
71 library Counters {
72     struct Counter {
73         // This variable should never be directly accessed by users of the library: interactions must be restricted to
74         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
75         // this feature: see https://github.com/ethereum/solidity/issues/4637
76         uint256 _value; // default: 0
77     }
78 
79     function current(Counter storage counter) internal view returns (uint256) {
80         return counter._value;
81     }
82 
83     function increment(Counter storage counter) internal {
84         unchecked {
85             counter._value += 1;
86         }
87     }
88 
89     function decrement(Counter storage counter) internal {
90         uint256 value = counter._value;
91         require(value > 0, "Counter: decrement overflow");
92         unchecked {
93             counter._value = value - 1;
94         }
95     }
96 
97     function reset(Counter storage counter) internal {
98         counter._value = 0;
99     }
100 }
101 
102 /**
103  * @dev Provides information about the current execution context, including the
104  * sender of the transaction and its data. While these are generally available
105  * via msg.sender and msg.data, they should not be accessed in such a direct
106  * manner, since when dealing with meta-transactions the account sending and
107  * paying for execution may not be the actual sender (as far as an application
108  * is concerned).
109  *
110  * This contract is only required for intermediate, library-like contracts.
111  */
112 abstract contract Context {
113     function _msgSender() internal view virtual returns (address) {
114         return msg.sender;
115     }
116 
117     function _msgData() internal view virtual returns (bytes calldata) {
118         return msg.data;
119     }
120 }
121 
122 // CAUTION
123 // This version of SafeMath should only be used with Solidity 0.8 or later,
124 // because it relies on the compiler's built in overflow checks.
125 
126 /**
127  * @dev Wrappers over Solidity's arithmetic operations.
128  *
129  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
130  * now has built in overflow checking.
131  */
132 library SafeMath {
133     /**
134      * @dev Returns the addition of two unsigned integers, with an overflow flag.
135      *
136      * _Available since v3.4._
137      */
138     function tryAdd(uint256 a, uint256 b)
139         internal
140         pure
141         returns (bool, uint256)
142     {
143         unchecked {
144             uint256 c = a + b;
145             if (c < a) return (false, 0);
146             return (true, c);
147         }
148     }
149 
150     /**
151      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
152      *
153      * _Available since v3.4._
154      */
155     function trySub(uint256 a, uint256 b)
156         internal
157         pure
158         returns (bool, uint256)
159     {
160         unchecked {
161             if (b > a) return (false, 0);
162             return (true, a - b);
163         }
164     }
165 
166     /**
167      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
168      *
169      * _Available since v3.4._
170      */
171     function tryMul(uint256 a, uint256 b)
172         internal
173         pure
174         returns (bool, uint256)
175     {
176         unchecked {
177             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
178             // benefit is lost if 'b' is also tested.
179             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
180             if (a == 0) return (true, 0);
181             uint256 c = a * b;
182             if (c / a != b) return (false, 0);
183             return (true, c);
184         }
185     }
186 
187     /**
188      * @dev Returns the division of two unsigned integers, with a division by zero flag.
189      *
190      * _Available since v3.4._
191      */
192     function tryDiv(uint256 a, uint256 b)
193         internal
194         pure
195         returns (bool, uint256)
196     {
197         unchecked {
198             if (b == 0) return (false, 0);
199             return (true, a / b);
200         }
201     }
202 
203     /**
204      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
205      *
206      * _Available since v3.4._
207      */
208     function tryMod(uint256 a, uint256 b)
209         internal
210         pure
211         returns (bool, uint256)
212     {
213         unchecked {
214             if (b == 0) return (false, 0);
215             return (true, a % b);
216         }
217     }
218 
219     /**
220      * @dev Returns the addition of two unsigned integers, reverting on
221      * overflow.
222      *
223      * Counterpart to Solidity's `+` operator.
224      *
225      * Requirements:
226      *
227      * - Addition cannot overflow.
228      */
229     function add(uint256 a, uint256 b) internal pure returns (uint256) {
230         return a + b;
231     }
232 
233     /**
234      * @dev Returns the subtraction of two unsigned integers, reverting on
235      * overflow (when the result is negative).
236      *
237      * Counterpart to Solidity's `-` operator.
238      *
239      * Requirements:
240      *
241      * - Subtraction cannot overflow.
242      */
243     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
244         return a - b;
245     }
246 
247     /**
248      * @dev Returns the multiplication of two unsigned integers, reverting on
249      * overflow.
250      *
251      * Counterpart to Solidity's `*` operator.
252      *
253      * Requirements:
254      *
255      * - Multiplication cannot overflow.
256      */
257     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
258         return a * b;
259     }
260 
261     /**
262      * @dev Returns the integer division of two unsigned integers, reverting on
263      * division by zero. The result is rounded towards zero.
264      *
265      * Counterpart to Solidity's `/` operator.
266      *
267      * Requirements:
268      *
269      * - The divisor cannot be zero.
270      */
271     function div(uint256 a, uint256 b) internal pure returns (uint256) {
272         return a / b;
273     }
274 
275     /**
276      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
277      * reverting when dividing by zero.
278      *
279      * Counterpart to Solidity's `%` operator. This function uses a `revert`
280      * opcode (which leaves remaining gas untouched) while Solidity uses an
281      * invalid opcode to revert (consuming all remaining gas).
282      *
283      * Requirements:
284      *
285      * - The divisor cannot be zero.
286      */
287     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
288         return a % b;
289     }
290 
291     /**
292      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
293      * overflow (when the result is negative).
294      *
295      * CAUTION: This function is deprecated because it requires allocating memory for the error
296      * message unnecessarily. For custom revert reasons use {trySub}.
297      *
298      * Counterpart to Solidity's `-` operator.
299      *
300      * Requirements:
301      *
302      * - Subtraction cannot overflow.
303      */
304     function sub(
305         uint256 a,
306         uint256 b,
307         string memory errorMessage
308     ) internal pure returns (uint256) {
309         unchecked {
310             require(b <= a, errorMessage);
311             return a - b;
312         }
313     }
314 
315     /**
316      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
317      * division by zero. The result is rounded towards zero.
318      *
319      * Counterpart to Solidity's `/` operator. Note: this function uses a
320      * `revert` opcode (which leaves remaining gas untouched) while Solidity
321      * uses an invalid opcode to revert (consuming all remaining gas).
322      *
323      * Requirements:
324      *
325      * - The divisor cannot be zero.
326      */
327     function div(
328         uint256 a,
329         uint256 b,
330         string memory errorMessage
331     ) internal pure returns (uint256) {
332         unchecked {
333             require(b > 0, errorMessage);
334             return a / b;
335         }
336     }
337 
338     /**
339      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
340      * reverting with custom message when dividing by zero.
341      *
342      * CAUTION: This function is deprecated because it requires allocating memory for the error
343      * message unnecessarily. For custom revert reasons use {tryMod}.
344      *
345      * Counterpart to Solidity's `%` operator. This function uses a `revert`
346      * opcode (which leaves remaining gas untouched) while Solidity uses an
347      * invalid opcode to revert (consuming all remaining gas).
348      *
349      * Requirements:
350      *
351      * - The divisor cannot be zero.
352      */
353     function mod(
354         uint256 a,
355         uint256 b,
356         string memory errorMessage
357     ) internal pure returns (uint256) {
358         unchecked {
359             require(b > 0, errorMessage);
360             return a % b;
361         }
362     }
363 }
364 
365 /**
366  * @dev Interface of the ERC20 standard as defined in the EIP.
367  */
368 interface IERC20 {
369     /**
370      * @dev Returns the amount of tokens in existence.
371      */
372     function totalSupply() external view returns (uint256);
373 
374     /**
375      * @dev Returns the amount of tokens owned by `account`.
376      */
377     function balanceOf(address account) external view returns (uint256);
378 
379     /**
380      * @dev Moves `amount` tokens from the caller's account to `recipient`.
381      *
382      * Returns a boolean value indicating whether the operation succeeded.
383      *
384      * Emits a {Transfer} event.
385      */
386     function transfer(address recipient, uint256 amount)
387         external
388         returns (bool);
389 
390     /**
391      * @dev Returns the remaining number of tokens that `spender` will be
392      * allowed to spend on behalf of `owner` through {transferFrom}. This is
393      * zero by default.
394      *
395      * This value changes when {approve} or {transferFrom} are called.
396      */
397     function allowance(address owner, address spender)
398         external
399         view
400         returns (uint256);
401 
402     /**
403      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
404      *
405      * Returns a boolean value indicating whether the operation succeeded.
406      *
407      * IMPORTANT: Beware that changing an allowance with this method brings the risk
408      * that someone may use both the old and the new allowance by unfortunate
409      * transaction ordering. One possible solution to mitigate this race
410      * condition is to first reduce the spender's allowance to 0 and set the
411      * desired value afterwards:
412      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
413      *
414      * Emits an {Approval} event.
415      */
416     function approve(address spender, uint256 amount) external returns (bool);
417 
418     /**
419      * @dev Moves `amount` tokens from `sender` to `recipient` using the
420      * allowance mechanism. `amount` is then deducted from the caller's
421      * allowance.
422      *
423      * Returns a boolean value indicating whether the operation succeeded.
424      *
425      * Emits a {Transfer} event.
426      */
427     function transferFrom(
428         address sender,
429         address recipient,
430         uint256 amount
431     ) external returns (bool);
432 
433     /**
434      * @dev Emitted when `value` tokens are moved from one account (`from`) to
435      * another (`to`).
436      *
437      * Note that `value` may be zero.
438      */
439     event Transfer(address indexed from, address indexed to, uint256 value);
440 
441     /**
442      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
443      * a call to {approve}. `value` is the new allowance.
444      */
445     event Approval(
446         address indexed owner,
447         address indexed spender,
448         uint256 value
449     );
450 }
451 
452 /**
453  * @dev Interface of the ERC165 standard, as defined in the
454  * https://eips.ethereum.org/EIPS/eip-165[EIP].
455  *
456  * Implementers can declare support of contract interfaces, which can then be
457  * queried by others ({ERC165Checker}).
458  *
459  * For an implementation, see {ERC165}.
460  */
461 interface IERC165 {
462     /**
463      * @dev Returns true if this contract implements the interface defined by
464      * `interfaceId`. See the corresponding
465      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
466      * to learn more about how these ids are created.
467      *
468      * This function call must use less than 30 000 gas.
469      */
470     function supportsInterface(bytes4 interfaceId) external view returns (bool);
471 }
472 
473 /**
474  * @dev Required interface of an ERC721 compliant contract.
475  */
476 interface IERC721 is IERC165 {
477     /**
478      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
479      */
480     event Transfer(
481         address indexed from,
482         address indexed to,
483         uint256 indexed tokenId
484     );
485 
486     /**
487      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
488      */
489     event Approval(
490         address indexed owner,
491         address indexed approved,
492         uint256 indexed tokenId
493     );
494 
495     /**
496      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
497      */
498     event ApprovalForAll(
499         address indexed owner,
500         address indexed operator,
501         bool approved
502     );
503 
504     /**
505      * @dev Returns the number of tokens in ``owner``'s account.
506      */
507     function balanceOf(address owner) external view returns (uint256 balance);
508 
509     /**
510      * @dev Returns the owner of the `tokenId` token.
511      *
512      * Requirements:
513      *
514      * - `tokenId` must exist.
515      */
516     function ownerOf(uint256 tokenId) external view returns (address owner);
517 
518     /**
519      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
520      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
521      *
522      * Requirements:
523      *
524      * - `from` cannot be the zero address.
525      * - `to` cannot be the zero address.
526      * - `tokenId` token must exist and be owned by `from`.
527      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
528      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
529      *
530      * Emits a {Transfer} event.
531      */
532     function safeTransferFrom(
533         address from,
534         address to,
535         uint256 tokenId
536     ) external;
537 
538     /**
539      * @dev Transfers `tokenId` token from `from` to `to`.
540      *
541      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
542      *
543      * Requirements:
544      *
545      * - `from` cannot be the zero address.
546      * - `to` cannot be the zero address.
547      * - `tokenId` token must be owned by `from`.
548      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
549      *
550      * Emits a {Transfer} event.
551      */
552     function transferFrom(
553         address from,
554         address to,
555         uint256 tokenId
556     ) external;
557 
558     /**
559      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
560      * The approval is cleared when the token is transferred.
561      *
562      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
563      *
564      * Requirements:
565      *
566      * - The caller must own the token or be an approved operator.
567      * - `tokenId` must exist.
568      *
569      * Emits an {Approval} event.
570      */
571     function approve(address to, uint256 tokenId) external;
572 
573     /**
574      * @dev Returns the account approved for `tokenId` token.
575      *
576      * Requirements:
577      *
578      * - `tokenId` must exist.
579      */
580     function getApproved(uint256 tokenId)
581         external
582         view
583         returns (address operator);
584 
585     /**
586      * @dev Approve or remove `operator` as an operator for the caller.
587      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
588      *
589      * Requirements:
590      *
591      * - The `operator` cannot be the caller.
592      *
593      * Emits an {ApprovalForAll} event.
594      */
595     function setApprovalForAll(address operator, bool _approved) external;
596 
597     /**
598      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
599      *
600      * See {setApprovalForAll}
601      */
602     function isApprovedForAll(address owner, address operator)
603         external
604         view
605         returns (bool);
606 
607     /**
608      * @dev Safely transfers `tokenId` token from `from` to `to`.
609      *
610      * Requirements:
611      *
612      * - `from` cannot be the zero address.
613      * - `to` cannot be the zero address.
614      * - `tokenId` token must exist and be owned by `from`.
615      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
616      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
617      *
618      * Emits a {Transfer} event.
619      */
620     function safeTransferFrom(
621         address from,
622         address to,
623         uint256 tokenId,
624         bytes calldata data
625     ) external;
626 }
627 
628 interface MonfterNFT {
629     function safeMint(address) external;
630 }
631 
632 contract MonfterSOSMinter is Context, ReentrancyGuard {
633     using Counters for Counters.Counter;
634     using SafeMath for uint256;
635 
636     IERC20 public sosToken;
637     MonfterNFT public monfterNft;
638 
639     uint256 public MIN_MON_HOLD = 10000000e18;
640     uint256 public MAX_FREE_MINT = 721;
641 
642     uint256 public sosHolderMint;
643     mapping(address => uint256) public mintLog;
644 
645     event Mint(address indexed account);
646 
647     constructor(IERC20 _sosToken, MonfterNFT _monfterNft) {
648         sosToken = _sosToken;
649         monfterNft = _monfterNft;
650     }
651 
652     function beforeMint() internal view {
653         require(
654             sosToken.balanceOf(_msgSender()) >= MIN_MON_HOLD,
655             "invalid token amount"
656         );
657         require(sosHolderMint.add(1) <= MAX_FREE_MINT, "mint end");
658         require(mintLog[_msgSender()] <= 0, "already mint");
659     }
660 
661     function afterMint() internal {
662         sosHolderMint = sosHolderMint.add(1);
663         mintLog[_msgSender()] += 1;
664     }
665 
666     function preMintLeft() public view returns (uint256) {
667         return MAX_FREE_MINT.sub(sosHolderMint);
668     }
669 
670     function freeMint() public nonReentrant {
671         beforeMint();
672 
673         monfterNft.safeMint(_msgSender());
674 
675         afterMint();
676 
677         emit Mint(_msgSender());
678     }
679 }