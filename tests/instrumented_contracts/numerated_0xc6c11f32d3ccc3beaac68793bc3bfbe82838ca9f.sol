1 /*                           HTTPS://SYNCBOND.COM                         HTTPS://APP.SYNCBOND.COM
2 ███████╗██╗░░░██╗███╗░░░██╗░██████╗░░░░██████╗░░██████╗░██╗░░░░██╗███████╗██████╗░███████╗██████╗░
3 ██╔════╝╚██╗░██╔╝████╗░░██║██╔════╝░░░░██╔══██╗██╔═══██╗██║░░░░██║██╔════╝██╔══██╗██╔════╝██╔══██╗
4 ███████╗░╚████╔╝░██╔██╗░██║██║░░░░░░░░░██████╔╝██║░░░██║██║░█╗░██║█████╗░░██████╔╝█████╗░░██║░░██║
5 ╚════██║░░╚██╔╝░░██║╚██╗██║██║░░░░░░░░░██╔═══╝░██║░░░██║██║███╗██║██╔══╝░░██╔══██╗██╔══╝░░██║░░██║
6 ███████║░░░██║░░░██║░╚████║╚██████╗░░░░██║░░░░░╚██████╔╝╚███╔███╔╝███████╗██║░░██║███████╗██████╔╝
7 ╚══════╝░░░╚═╝░░░╚═╝░░╚═══╝░╚═════╝░░░░╚═╝░░░░░░╚═════╝░░╚══╝╚══╝░╚══════╝╚═╝░░╚═╝╚══════╝╚═════╝░
8 ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
9 ░██████╗██████╗░██╗░░░██╗██████╗░████████╗░██████╗░██████╗░░██████╗░███╗░░░██╗██████╗░███████╗░░░░
10 ██╔════╝██╔══██╗╚██╗░██╔╝██╔══██╗╚══██╔══╝██╔═══██╗██╔══██╗██╔═══██╗████╗░░██║██╔══██╗██╔════╝░░░░
11 ██║░░░░░██████╔╝░╚████╔╝░██████╔╝░░░██║░░░██║░░░██║██████╔╝██║░░░██║██╔██╗░██║██║░░██║███████╗░░░░
12 ██║░░░░░██╔══██╗░░╚██╔╝░░██╔═══╝░░░░██║░░░██║░░░██║██╔══██╗██║░░░██║██║╚██╗██║██║░░██║╚════██║░░░░
13 ╚██████╗██║░░██║░░░██║░░░██║░░░░░░░░██║░░░╚██████╔╝██████╔╝╚██████╔╝██║░╚████║██████╔╝███████║░░░░
14 ░╚═════╝╚═╝░░╚═╝░░░╚═╝░░░╚═╝░░░░░░░░╚═╝░░░░╚═════╝░╚═════╝░░╚═════╝░╚═╝░░╚═══╝╚═════╝░╚══════╝░░░░
15 */
16 pragma solidity ^0.6.0;
17 
18 /**
19  * @dev Interface of the ERC165 standard, as defined in the
20  * https://eips.ethereum.org/EIPS/eip-165[EIP].
21  *
22  * Implementers can declare support of contract interfaces, which can then be
23  * queried by others ({ERC165Checker}).
24  *
25  * For an implementation, see {ERC165}.
26  */
27 interface IERC165 {
28     /**
29      * @dev Returns true if this contract implements the interface defined by
30      * `interfaceId`. See the corresponding
31      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
32      * to learn more about how these ids are created.
33      *
34      * This function call must use less than 30 000 gas.
35      */
36     function supportsInterface(bytes4 interfaceId) external view returns (bool);
37 }
38 
39 
40 
41 interface ApproveAndCallFallBack {
42     function receiveApproval(address from, uint256 tokens, address token, bytes calldata data) external;
43 }
44 
45 
46 
47 
48 /**
49  * @dev Wrappers over Solidity's arithmetic operations with added overflow
50  * checks.
51  *
52  * Arithmetic operations in Solidity wrap on overflow. This can easily result
53  * in bugs, because programmers usually assume that an overflow raises an
54  * error, which is the standard behavior in high level programming languages.
55  * `SafeMath` restores this intuition by reverting the transaction when an
56  * operation overflows.
57  *
58  * Using this library instead of the unchecked operations eliminates an entire
59  * class of bugs, so it's recommended to use it always.
60  */
61 library SafeMath {
62     /**
63      * @dev Returns the addition of two unsigned integers, reverting on
64      * overflow.
65      *
66      * Counterpart to Solidity's `+` operator.
67      *
68      * Requirements:
69      *
70      * - Addition cannot overflow.
71      */
72     function add(uint256 a, uint256 b) internal pure returns (uint256) {
73         uint256 c = a + b;
74         require(c >= a, "SafeMath: addition overflow");
75 
76         return c;
77     }
78 
79     /**
80      * @dev Returns the subtraction of two unsigned integers, reverting on
81      * overflow (when the result is negative).
82      *
83      * Counterpart to Solidity's `-` operator.
84      *
85      * Requirements:
86      *
87      * - Subtraction cannot overflow.
88      */
89     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
90         return sub(a, b, "SafeMath: subtraction overflow");
91     }
92 
93     /**
94      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
95      * overflow (when the result is negative).
96      *
97      * Counterpart to Solidity's `-` operator.
98      *
99      * Requirements:
100      *
101      * - Subtraction cannot overflow.
102      */
103     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
104         require(b <= a, errorMessage);
105         uint256 c = a - b;
106 
107         return c;
108     }
109 
110     /**
111      * @dev Returns the multiplication of two unsigned integers, reverting on
112      * overflow.
113      *
114      * Counterpart to Solidity's `*` operator.
115      *
116      * Requirements:
117      *
118      * - Multiplication cannot overflow.
119      */
120     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
121         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
122         // benefit is lost if 'b' is also tested.
123         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
124         if (a == 0) {
125             return 0;
126         }
127 
128         uint256 c = a * b;
129         require(c / a == b, "SafeMath: multiplication overflow");
130 
131         return c;
132     }
133 
134     /**
135      * @dev Returns the integer division of two unsigned integers. Reverts on
136      * division by zero. The result is rounded towards zero.
137      *
138      * Counterpart to Solidity's `/` operator. Note: this function uses a
139      * `revert` opcode (which leaves remaining gas untouched) while Solidity
140      * uses an invalid opcode to revert (consuming all remaining gas).
141      *
142      * Requirements:
143      *
144      * - The divisor cannot be zero.
145      */
146     function div(uint256 a, uint256 b) internal pure returns (uint256) {
147         return div(a, b, "SafeMath: division by zero");
148     }
149 
150     /**
151      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
152      * division by zero. The result is rounded towards zero.
153      *
154      * Counterpart to Solidity's `/` operator. Note: this function uses a
155      * `revert` opcode (which leaves remaining gas untouched) while Solidity
156      * uses an invalid opcode to revert (consuming all remaining gas).
157      *
158      * Requirements:
159      *
160      * - The divisor cannot be zero.
161      */
162     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
163         require(b > 0, errorMessage);
164         uint256 c = a / b;
165         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
166 
167         return c;
168     }
169 
170     /**
171      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
172      * Reverts when dividing by zero.
173      *
174      * Counterpart to Solidity's `%` operator. This function uses a `revert`
175      * opcode (which leaves remaining gas untouched) while Solidity uses an
176      * invalid opcode to revert (consuming all remaining gas).
177      *
178      * Requirements:
179      *
180      * - The divisor cannot be zero.
181      */
182     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
183         return mod(a, b, "SafeMath: modulo by zero");
184     }
185 
186     /**
187      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
188      * Reverts with custom message when dividing by zero.
189      *
190      * Counterpart to Solidity's `%` operator. This function uses a `revert`
191      * opcode (which leaves remaining gas untouched) while Solidity uses an
192      * invalid opcode to revert (consuming all remaining gas).
193      *
194      * Requirements:
195      *
196      * - The divisor cannot be zero.
197      */
198     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
199         require(b != 0, errorMessage);
200         return a % b;
201     }
202 }
203 
204 
205 
206 
207 /**
208  * @dev Interface of the ERC20 standard as defined in the EIP.
209  */
210 interface IERC20 {
211     /**
212      * @dev Returns the amount of tokens in existence.
213      */
214     function totalSupply() external view returns (uint256);
215 
216     /**
217      * @dev Returns the amount of tokens owned by `account`.
218      */
219     function balanceOf(address account) external view returns (uint256);
220 
221     /**
222      * @dev Moves `amount` tokens from the caller's account to `recipient`.
223      *
224      * Returns a boolean value indicating whether the operation succeeded.
225      *
226      * Emits a {Transfer} event.
227      */
228     function transfer(address recipient, uint256 amount) external returns (bool);
229 
230     /**
231      * @dev Returns the remaining number of tokens that `spender` will be
232      * allowed to spend on behalf of `owner` through {transferFrom}. This is
233      * zero by default.
234      *
235      * This value changes when {approve} or {transferFrom} are called.
236      */
237     function allowance(address owner, address spender) external view returns (uint256);
238 
239     /**
240      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
241      *
242      * Returns a boolean value indicating whether the operation succeeded.
243      *
244      * IMPORTANT: Beware that changing an allowance with this method brings the risk
245      * that someone may use both the old and the new allowance by unfortunate
246      * transaction ordering. One possible solution to mitigate this race
247      * condition is to first reduce the spender's allowance to 0 and set the
248      * desired value afterwards:
249      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
250      *
251      * Emits an {Approval} event.
252      */
253     function approve(address spender, uint256 amount) external returns (bool);
254 
255     /**
256      * @dev Moves `amount` tokens from `sender` to `recipient` using the
257      * allowance mechanism. `amount` is then deducted from the caller's
258      * allowance.
259      *
260      * Returns a boolean value indicating whether the operation succeeded.
261      *
262      * Emits a {Transfer} event.
263      */
264     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
265 
266     /**
267      * @dev Emitted when `value` tokens are moved from one account (`from`) to
268      * another (`to`).
269      *
270      * Note that `value` may be zero.
271      */
272     event Transfer(address indexed from, address indexed to, uint256 value);
273 
274     /**
275      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
276      * a call to {approve}. `value` is the new allowance.
277      */
278     event Approval(address indexed owner, address indexed spender, uint256 value);
279 }
280 
281 
282 
283 
284 /*
285  * @dev Provides information about the current execution context, including the
286  * sender of the transaction and its data. While these are generally available
287  * via msg.sender and msg.data, they should not be accessed in such a direct
288  * manner, since when dealing with GSN meta-transactions the account sending and
289  * paying for execution may not be the actual sender (as far as an application
290  * is concerned).
291  *
292  * This contract is only required for intermediate, library-like contracts.
293  */
294 abstract contract Context {
295     function _msgSender() internal view virtual returns (address payable) {
296         return msg.sender;
297     }
298 
299     function _msgData() internal view virtual returns (bytes memory) {
300         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
301         return msg.data;
302     }
303 }
304 
305 
306 
307 
308 /**
309  * @dev String operations.
310  */
311 library Strings {
312     /**
313      * @dev Converts a `uint256` to its ASCII `string` representation.
314      */
315     function toString(uint256 value) internal pure returns (string memory) {
316         // Inspired by OraclizeAPI's implementation - MIT licence
317         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
318 
319         if (value == 0) {
320             return "0";
321         }
322         uint256 temp = value;
323         uint256 digits;
324         while (temp != 0) {
325             digits++;
326             temp /= 10;
327         }
328         bytes memory buffer = new bytes(digits);
329         uint256 index = digits - 1;
330         temp = value;
331         while (temp != 0) {
332             buffer[index--] = byte(uint8(48 + temp % 10));
333             temp /= 10;
334         }
335         return string(buffer);
336     }
337 }
338 
339 
340 library SquareRoot {
341   function sqrt(uint y) internal pure returns (uint z) {
342         if (y > 3) {
343             z = y;
344             uint x = y / 2 + 1;
345             while (x < z) {
346                 z = x;
347                 x = (y / x + x) / 2;
348             }
349         } else if (y != 0) {
350             z = 1;
351         }
352     }
353 }
354 
355 
356 /*
357   https://ethereum.stackexchange.com/a/8447
358 */
359 library AddressStrings {
360   function toString(address x) internal pure returns (string memory) {
361       bytes memory s = new bytes(40);
362       for (uint i = 0; i < 20; i++) {
363           byte b = byte(uint8(uint(x) / (2**(8*(19 - i)))));
364           byte hi = byte(uint8(b) / 16);
365           byte lo = byte(uint8(b) - 16 * uint8(hi));
366           s[2*i] = char(hi);
367           s[2*i+1] = char(lo);
368       }
369       return string(s);
370   }
371 
372   function char(byte b) internal pure returns (byte c) {
373       if (uint8(b) < 10) return byte(uint8(b) + 0x30);
374       else return byte(uint8(b) + 0x57);
375   }
376 }
377 
378 
379 interface Oracle{
380   function liquidityValues(address token) external view returns(uint);//returns usd value of token (consider usd an 18 decimal stablecoin), or 0 if not listed
381   function syncValue() external view returns(uint);//returns usd value of SYNC
382 }
383 
384 
385 
386 
387 
388 
389 
390 
391 
392 
393 
394 
395 
396 
397 /**
398  * @dev Required interface of an ERC721 compliant contract.
399  */
400 interface IERC721 is IERC165 {
401     /**
402      * @dev Emitted when `tokenId` token is transfered from `from` to `to`.
403      */
404     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
405 
406     /**
407      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
408      */
409     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
410 
411     /**
412      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
413      */
414     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
415 
416     /**
417      * @dev Returns the number of tokens in ``owner``'s account.
418      */
419     function balanceOf(address owner) external view returns (uint256 balance);
420 
421     /**
422      * @dev Returns the owner of the `tokenId` token.
423      *
424      * Requirements:
425      *
426      * - `tokenId` must exist.
427      */
428     function ownerOf(uint256 tokenId) external view returns (address owner);
429 
430     /**
431      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
432      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
433      *
434      * Requirements:
435      *
436      * - `from` cannot be the zero address.
437      * - `to` cannot be the zero address.
438      * - `tokenId` token must exist and be owned by `from`.
439      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
440      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
441      *
442      * Emits a {Transfer} event.
443      */
444     function safeTransferFrom(address from, address to, uint256 tokenId) external;
445 
446     /**
447      * @dev Transfers `tokenId` token from `from` to `to`.
448      *
449      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
450      *
451      * Requirements:
452      *
453      * - `from` cannot be the zero address.
454      * - `to` cannot be the zero address.
455      * - `tokenId` token must be owned by `from`.
456      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
457      *
458      * Emits a {Transfer} event.
459      */
460     function transferFrom(address from, address to, uint256 tokenId) external;
461 
462     /**
463      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
464      * The approval is cleared when the token is transferred.
465      *
466      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
467      *
468      * Requirements:
469      *
470      * - The caller must own the token or be an approved operator.
471      * - `tokenId` must exist.
472      *
473      * Emits an {Approval} event.
474      */
475     function approve(address to, uint256 tokenId) external;
476 
477     /**
478      * @dev Returns the account approved for `tokenId` token.
479      *
480      * Requirements:
481      *
482      * - `tokenId` must exist.
483      */
484     function getApproved(uint256 tokenId) external view returns (address operator);
485 
486     /**
487      * @dev Approve or remove `operator` as an operator for the caller.
488      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
489      *
490      * Requirements:
491      *
492      * - The `operator` cannot be the caller.
493      *
494      * Emits an {ApprovalForAll} event.
495      */
496     function setApprovalForAll(address operator, bool _approved) external;
497 
498     /**
499      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
500      *
501      * See {setApprovalForAll}
502      */
503     function isApprovedForAll(address owner, address operator) external view returns (bool);
504 
505     /**
506       * @dev Safely transfers `tokenId` token from `from` to `to`.
507       *
508       * Requirements:
509       *
510      * - `from` cannot be the zero address.
511      * - `to` cannot be the zero address.
512       * - `tokenId` token must exist and be owned by `from`.
513       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
514       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
515       *
516       * Emits a {Transfer} event.
517       */
518     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
519 }
520 
521 
522 
523 
524 
525 
526 
527 /**
528  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
529  * @dev See https://eips.ethereum.org/EIPS/eip-721
530  */
531 interface IERC721Metadata is IERC721 {
532 
533     /**
534      * @dev Returns the token collection name.
535      */
536     function name() external view returns (string memory);
537 
538     /**
539      * @dev Returns the token collection symbol.
540      */
541     function symbol() external view returns (string memory);
542 
543     /**
544      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
545      */
546     function tokenURI(uint256 tokenId) external view returns (string memory);
547 }
548 
549 
550 
551 
552 
553 
554 
555 /**
556  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
557  * @dev See https://eips.ethereum.org/EIPS/eip-721
558  */
559 interface IERC721Enumerable is IERC721 {
560 
561     /**
562      * @dev Returns the total amount of tokens stored by the contract.
563      */
564     function totalSupply() external view returns (uint256);
565 
566     /**
567      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
568      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
569      */
570     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
571 
572     /**
573      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
574      * Use along with {totalSupply} to enumerate all tokens.
575      */
576     function tokenByIndex(uint256 index) external view returns (uint256);
577 }
578 
579 
580 
581 
582 
583 /**
584  * @title ERC721 token receiver interface
585  * @dev Interface for any contract that wants to support safeTransfers
586  * from ERC721 asset contracts.
587  */
588 interface IERC721Receiver {
589     /**
590      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
591      * by `operator` from `from`, this function is called.
592      *
593      * It must return its Solidity selector to confirm the token transfer.
594      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
595      *
596      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
597      */
598     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data)
599     external returns (bytes4);
600 }
601 
602 
603 
604 
605 
606 
607 
608 /**
609  * @dev Implementation of the {IERC165} interface.
610  *
611  * Contracts may inherit from this and call {_registerInterface} to declare
612  * their support of an interface.
613  */
614 contract ERC165 is IERC165 {
615     /*
616      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
617      */
618     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
619 
620     /**
621      * @dev Mapping of interface ids to whether or not it's supported.
622      */
623     mapping(bytes4 => bool) private _supportedInterfaces;
624 
625     constructor () internal {
626         // Derived contracts need only register support for their own interfaces,
627         // we register support for ERC165 itself here
628         _registerInterface(_INTERFACE_ID_ERC165);
629     }
630 
631     /**
632      * @dev See {IERC165-supportsInterface}.
633      *
634      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
635      */
636     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
637         return _supportedInterfaces[interfaceId];
638     }
639 
640     /**
641      * @dev Registers the contract as an implementer of the interface defined by
642      * `interfaceId`. Support of the actual ERC165 interface is automatic and
643      * registering its interface id is not required.
644      *
645      * See {IERC165-supportsInterface}.
646      *
647      * Requirements:
648      *
649      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
650      */
651     function _registerInterface(bytes4 interfaceId) internal virtual {
652         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
653         _supportedInterfaces[interfaceId] = true;
654     }
655 }
656 
657 
658 
659 
660 
661 
662 /**
663  * @dev Collection of functions related to the address type
664  */
665 library Address {
666     /**
667      * @dev Returns true if `account` is a contract.
668      *
669      * [IMPORTANT]
670      * ====
671      * It is unsafe to assume that an address for which this function returns
672      * false is an externally-owned account (EOA) and not a contract.
673      *
674      * Among others, `isContract` will return false for the following
675      * types of addresses:
676      *
677      *  - an externally-owned account
678      *  - a contract in construction
679      *  - an address where a contract will be created
680      *  - an address where a contract lived, but was destroyed
681      * ====
682      */
683     function isContract(address account) internal view returns (bool) {
684         // This method relies in extcodesize, which returns 0 for contracts in
685         // construction, since the code is only stored at the end of the
686         // constructor execution.
687 
688         uint256 size;
689         // solhint-disable-next-line no-inline-assembly
690         assembly { size := extcodesize(account) }
691         return size > 0;
692     }
693 
694     /**
695      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
696      * `recipient`, forwarding all available gas and reverting on errors.
697      *
698      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
699      * of certain opcodes, possibly making contracts go over the 2300 gas limit
700      * imposed by `transfer`, making them unable to receive funds via
701      * `transfer`. {sendValue} removes this limitation.
702      *
703      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
704      *
705      * IMPORTANT: because control is transferred to `recipient`, care must be
706      * taken to not create reentrancy vulnerabilities. Consider using
707      * {ReentrancyGuard} or the
708      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
709      */
710     function sendValue(address payable recipient, uint256 amount) internal {
711         require(address(this).balance >= amount, "Address: insufficient balance");
712 
713         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
714         (bool success, ) = recipient.call{ value: amount }("");
715         require(success, "Address: unable to send value, recipient may have reverted");
716     }
717 
718     /**
719      * @dev Performs a Solidity function call using a low level `call`. A
720      * plain`call` is an unsafe replacement for a function call: use this
721      * function instead.
722      *
723      * If `target` reverts with a revert reason, it is bubbled up by this
724      * function (like regular Solidity function calls).
725      *
726      * Returns the raw returned data. To convert to the expected return value,
727      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
728      *
729      * Requirements:
730      *
731      * - `target` must be a contract.
732      * - calling `target` with `data` must not revert.
733      *
734      * _Available since v3.1._
735      */
736     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
737       return functionCall(target, data, "Address: low-level call failed");
738     }
739 
740     /**
741      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
742      * `errorMessage` as a fallback revert reason when `target` reverts.
743      *
744      * _Available since v3.1._
745      */
746     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
747         return _functionCallWithValue(target, data, 0, errorMessage);
748     }
749 
750     /**
751      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
752      * but also transferring `value` wei to `target`.
753      *
754      * Requirements:
755      *
756      * - the calling contract must have an ETH balance of at least `value`.
757      * - the called Solidity function must be `payable`.
758      *
759      * _Available since v3.1._
760      */
761     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
762         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
763     }
764 
765     /**
766      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
767      * with `errorMessage` as a fallback revert reason when `target` reverts.
768      *
769      * _Available since v3.1._
770      */
771     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
772         require(address(this).balance >= value, "Address: insufficient balance for call");
773         return _functionCallWithValue(target, data, value, errorMessage);
774     }
775 
776     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
777         require(isContract(target), "Address: call to non-contract");
778 
779         // solhint-disable-next-line avoid-low-level-calls
780         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
781         if (success) {
782             return returndata;
783         } else {
784             // Look for revert reason and bubble it up if present
785             if (returndata.length > 0) {
786                 // The easiest way to bubble the revert reason is using memory via assembly
787 
788                 // solhint-disable-next-line no-inline-assembly
789                 assembly {
790                     let returndata_size := mload(returndata)
791                     revert(add(32, returndata), returndata_size)
792                 }
793             } else {
794                 revert(errorMessage);
795             }
796         }
797     }
798 }
799 
800 
801 
802 
803 
804 /**
805  * @dev Library for managing
806  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
807  * types.
808  *
809  * Sets have the following properties:
810  *
811  * - Elements are added, removed, and checked for existence in constant time
812  * (O(1)).
813  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
814  *
815  * ```
816  * contract Example {
817  *     // Add the library methods
818  *     using EnumerableSet for EnumerableSet.AddressSet;
819  *
820  *     // Declare a set state variable
821  *     EnumerableSet.AddressSet private mySet;
822  * }
823  * ```
824  *
825  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
826  * (`UintSet`) are supported.
827  */
828 library EnumerableSet {
829     // To implement this library for multiple types with as little code
830     // repetition as possible, we write it in terms of a generic Set type with
831     // bytes32 values.
832     // The Set implementation uses private functions, and user-facing
833     // implementations (such as AddressSet) are just wrappers around the
834     // underlying Set.
835     // This means that we can only create new EnumerableSets for types that fit
836     // in bytes32.
837 
838     struct Set {
839         // Storage of set values
840         bytes32[] _values;
841 
842         // Position of the value in the `values` array, plus 1 because index 0
843         // means a value is not in the set.
844         mapping (bytes32 => uint256) _indexes;
845     }
846 
847     /**
848      * @dev Add a value to a set. O(1).
849      *
850      * Returns true if the value was added to the set, that is if it was not
851      * already present.
852      */
853     function _add(Set storage set, bytes32 value) private returns (bool) {
854         if (!_contains(set, value)) {
855             set._values.push(value);
856             // The value is stored at length-1, but we add 1 to all indexes
857             // and use 0 as a sentinel value
858             set._indexes[value] = set._values.length;
859             return true;
860         } else {
861             return false;
862         }
863     }
864 
865     /**
866      * @dev Removes a value from a set. O(1).
867      *
868      * Returns true if the value was removed from the set, that is if it was
869      * present.
870      */
871     function _remove(Set storage set, bytes32 value) private returns (bool) {
872         // We read and store the value's index to prevent multiple reads from the same storage slot
873         uint256 valueIndex = set._indexes[value];
874 
875         if (valueIndex != 0) { // Equivalent to contains(set, value)
876             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
877             // the array, and then remove the last element (sometimes called as 'swap and pop').
878             // This modifies the order of the array, as noted in {at}.
879 
880             uint256 toDeleteIndex = valueIndex - 1;
881             uint256 lastIndex = set._values.length - 1;
882 
883             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
884             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
885 
886             bytes32 lastvalue = set._values[lastIndex];
887 
888             // Move the last value to the index where the value to delete is
889             set._values[toDeleteIndex] = lastvalue;
890             // Update the index for the moved value
891             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
892 
893             // Delete the slot where the moved value was stored
894             set._values.pop();
895 
896             // Delete the index for the deleted slot
897             delete set._indexes[value];
898 
899             return true;
900         } else {
901             return false;
902         }
903     }
904 
905     /**
906      * @dev Returns true if the value is in the set. O(1).
907      */
908     function _contains(Set storage set, bytes32 value) private view returns (bool) {
909         return set._indexes[value] != 0;
910     }
911 
912     /**
913      * @dev Returns the number of values on the set. O(1).
914      */
915     function _length(Set storage set) private view returns (uint256) {
916         return set._values.length;
917     }
918 
919    /**
920     * @dev Returns the value stored at position `index` in the set. O(1).
921     *
922     * Note that there are no guarantees on the ordering of values inside the
923     * array, and it may change when more values are added or removed.
924     *
925     * Requirements:
926     *
927     * - `index` must be strictly less than {length}.
928     */
929     function _at(Set storage set, uint256 index) private view returns (bytes32) {
930         require(set._values.length > index, "EnumerableSet: index out of bounds");
931         return set._values[index];
932     }
933 
934     // AddressSet
935 
936     struct AddressSet {
937         Set _inner;
938     }
939 
940     /**
941      * @dev Add a value to a set. O(1).
942      *
943      * Returns true if the value was added to the set, that is if it was not
944      * already present.
945      */
946     function add(AddressSet storage set, address value) internal returns (bool) {
947         return _add(set._inner, bytes32(uint256(value)));
948     }
949 
950     /**
951      * @dev Removes a value from a set. O(1).
952      *
953      * Returns true if the value was removed from the set, that is if it was
954      * present.
955      */
956     function remove(AddressSet storage set, address value) internal returns (bool) {
957         return _remove(set._inner, bytes32(uint256(value)));
958     }
959 
960     /**
961      * @dev Returns true if the value is in the set. O(1).
962      */
963     function contains(AddressSet storage set, address value) internal view returns (bool) {
964         return _contains(set._inner, bytes32(uint256(value)));
965     }
966 
967     /**
968      * @dev Returns the number of values in the set. O(1).
969      */
970     function length(AddressSet storage set) internal view returns (uint256) {
971         return _length(set._inner);
972     }
973 
974    /**
975     * @dev Returns the value stored at position `index` in the set. O(1).
976     *
977     * Note that there are no guarantees on the ordering of values inside the
978     * array, and it may change when more values are added or removed.
979     *
980     * Requirements:
981     *
982     * - `index` must be strictly less than {length}.
983     */
984     function at(AddressSet storage set, uint256 index) internal view returns (address) {
985         return address(uint256(_at(set._inner, index)));
986     }
987 
988 
989     // UintSet
990 
991     struct UintSet {
992         Set _inner;
993     }
994 
995     /**
996      * @dev Add a value to a set. O(1).
997      *
998      * Returns true if the value was added to the set, that is if it was not
999      * already present.
1000      */
1001     function add(UintSet storage set, uint256 value) internal returns (bool) {
1002         return _add(set._inner, bytes32(value));
1003     }
1004 
1005     /**
1006      * @dev Removes a value from a set. O(1).
1007      *
1008      * Returns true if the value was removed from the set, that is if it was
1009      * present.
1010      */
1011     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1012         return _remove(set._inner, bytes32(value));
1013     }
1014 
1015     /**
1016      * @dev Returns true if the value is in the set. O(1).
1017      */
1018     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1019         return _contains(set._inner, bytes32(value));
1020     }
1021 
1022     /**
1023      * @dev Returns the number of values on the set. O(1).
1024      */
1025     function length(UintSet storage set) internal view returns (uint256) {
1026         return _length(set._inner);
1027     }
1028 
1029    /**
1030     * @dev Returns the value stored at position `index` in the set. O(1).
1031     *
1032     * Note that there are no guarantees on the ordering of values inside the
1033     * array, and it may change when more values are added or removed.
1034     *
1035     * Requirements:
1036     *
1037     * - `index` must be strictly less than {length}.
1038     */
1039     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1040         return uint256(_at(set._inner, index));
1041     }
1042 }
1043 
1044 
1045 
1046 
1047 
1048 /**
1049  * @dev Library for managing an enumerable variant of Solidity's
1050  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1051  * type.
1052  *
1053  * Maps have the following properties:
1054  *
1055  * - Entries are added, removed, and checked for existence in constant time
1056  * (O(1)).
1057  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1058  *
1059  * ```
1060  * contract Example {
1061  *     // Add the library methods
1062  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1063  *
1064  *     // Declare a set state variable
1065  *     EnumerableMap.UintToAddressMap private myMap;
1066  * }
1067  * ```
1068  *
1069  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1070  * supported.
1071  */
1072 library EnumerableMap {
1073     // To implement this library for multiple types with as little code
1074     // repetition as possible, we write it in terms of a generic Map type with
1075     // bytes32 keys and values.
1076     // The Map implementation uses private functions, and user-facing
1077     // implementations (such as Uint256ToAddressMap) are just wrappers around
1078     // the underlying Map.
1079     // This means that we can only create new EnumerableMaps for types that fit
1080     // in bytes32.
1081 
1082     struct MapEntry {
1083         bytes32 _key;
1084         bytes32 _value;
1085     }
1086 
1087     struct Map {
1088         // Storage of map keys and values
1089         MapEntry[] _entries;
1090 
1091         // Position of the entry defined by a key in the `entries` array, plus 1
1092         // because index 0 means a key is not in the map.
1093         mapping (bytes32 => uint256) _indexes;
1094     }
1095 
1096     /**
1097      * @dev Adds a key-value pair to a map, or updates the value for an existing
1098      * key. O(1).
1099      *
1100      * Returns true if the key was added to the map, that is if it was not
1101      * already present.
1102      */
1103     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1104         // We read and store the key's index to prevent multiple reads from the same storage slot
1105         uint256 keyIndex = map._indexes[key];
1106 
1107         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1108             map._entries.push(MapEntry({ _key: key, _value: value }));
1109             // The entry is stored at length-1, but we add 1 to all indexes
1110             // and use 0 as a sentinel value
1111             map._indexes[key] = map._entries.length;
1112             return true;
1113         } else {
1114             map._entries[keyIndex - 1]._value = value;
1115             return false;
1116         }
1117     }
1118 
1119     /**
1120      * @dev Removes a key-value pair from a map. O(1).
1121      *
1122      * Returns true if the key was removed from the map, that is if it was present.
1123      */
1124     function _remove(Map storage map, bytes32 key) private returns (bool) {
1125         // We read and store the key's index to prevent multiple reads from the same storage slot
1126         uint256 keyIndex = map._indexes[key];
1127 
1128         if (keyIndex != 0) { // Equivalent to contains(map, key)
1129             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1130             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1131             // This modifies the order of the array, as noted in {at}.
1132 
1133             uint256 toDeleteIndex = keyIndex - 1;
1134             uint256 lastIndex = map._entries.length - 1;
1135 
1136             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1137             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1138 
1139             MapEntry storage lastEntry = map._entries[lastIndex];
1140 
1141             // Move the last entry to the index where the entry to delete is
1142             map._entries[toDeleteIndex] = lastEntry;
1143             // Update the index for the moved entry
1144             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1145 
1146             // Delete the slot where the moved entry was stored
1147             map._entries.pop();
1148 
1149             // Delete the index for the deleted slot
1150             delete map._indexes[key];
1151 
1152             return true;
1153         } else {
1154             return false;
1155         }
1156     }
1157 
1158     /**
1159      * @dev Returns true if the key is in the map. O(1).
1160      */
1161     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1162         return map._indexes[key] != 0;
1163     }
1164 
1165     /**
1166      * @dev Returns the number of key-value pairs in the map. O(1).
1167      */
1168     function _length(Map storage map) private view returns (uint256) {
1169         return map._entries.length;
1170     }
1171 
1172    /**
1173     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1174     *
1175     * Note that there are no guarantees on the ordering of entries inside the
1176     * array, and it may change when more entries are added or removed.
1177     *
1178     * Requirements:
1179     *
1180     * - `index` must be strictly less than {length}.
1181     */
1182     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1183         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1184 
1185         MapEntry storage entry = map._entries[index];
1186         return (entry._key, entry._value);
1187     }
1188 
1189     /**
1190      * @dev Returns the value associated with `key`.  O(1).
1191      *
1192      * Requirements:
1193      *
1194      * - `key` must be in the map.
1195      */
1196     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1197         return _get(map, key, "EnumerableMap: nonexistent key");
1198     }
1199 
1200     /**
1201      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1202      */
1203     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1204         uint256 keyIndex = map._indexes[key];
1205         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1206         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1207     }
1208 
1209     // UintToAddressMap
1210 
1211     struct UintToAddressMap {
1212         Map _inner;
1213     }
1214 
1215     /**
1216      * @dev Adds a key-value pair to a map, or updates the value for an existing
1217      * key. O(1).
1218      *
1219      * Returns true if the key was added to the map, that is if it was not
1220      * already present.
1221      */
1222     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1223         return _set(map._inner, bytes32(key), bytes32(uint256(value)));
1224     }
1225 
1226     /**
1227      * @dev Removes a value from a set. O(1).
1228      *
1229      * Returns true if the key was removed from the map, that is if it was present.
1230      */
1231     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1232         return _remove(map._inner, bytes32(key));
1233     }
1234 
1235     /**
1236      * @dev Returns true if the key is in the map. O(1).
1237      */
1238     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1239         return _contains(map._inner, bytes32(key));
1240     }
1241 
1242     /**
1243      * @dev Returns the number of elements in the map. O(1).
1244      */
1245     function length(UintToAddressMap storage map) internal view returns (uint256) {
1246         return _length(map._inner);
1247     }
1248 
1249    /**
1250     * @dev Returns the element stored at position `index` in the set. O(1).
1251     * Note that there are no guarantees on the ordering of values inside the
1252     * array, and it may change when more values are added or removed.
1253     *
1254     * Requirements:
1255     *
1256     * - `index` must be strictly less than {length}.
1257     */
1258     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1259         (bytes32 key, bytes32 value) = _at(map._inner, index);
1260         return (uint256(key), address(uint256(value)));
1261     }
1262 
1263     /**
1264      * @dev Returns the value associated with `key`.  O(1).
1265      *
1266      * Requirements:
1267      *
1268      * - `key` must be in the map.
1269      */
1270     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1271         return address(uint256(_get(map._inner, bytes32(key))));
1272     }
1273 
1274     /**
1275      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1276      */
1277     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1278         return address(uint256(_get(map._inner, bytes32(key), errorMessage)));
1279     }
1280 }
1281 
1282 
1283 
1284 /**
1285  * @title ERC721 Non-Fungible Token Standard basic implementation
1286  * @dev see https://eips.ethereum.org/EIPS/eip-721
1287  */
1288 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1289     using SafeMath for uint256;
1290     using Address for address;
1291     using EnumerableSet for EnumerableSet.UintSet;
1292     using EnumerableMap for EnumerableMap.UintToAddressMap;
1293     using Strings for uint256;
1294 
1295     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1296     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1297     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1298 
1299     // Mapping from holder address to their (enumerable) set of owned tokens
1300     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1301 
1302     // Enumerable mapping from token ids to their owners
1303     EnumerableMap.UintToAddressMap private _tokenOwners;
1304 
1305     // Mapping from token ID to approved address
1306     mapping (uint256 => address) private _tokenApprovals;
1307 
1308     // Mapping from owner to operator approvals
1309     mapping (address => mapping (address => bool)) private _operatorApprovals;
1310 
1311     // Token name
1312     string private _name;
1313 
1314     // Token symbol
1315     string private _symbol;
1316 
1317     // Optional mapping for token URIs
1318     mapping (uint256 => string) private _tokenURIs;
1319 
1320     // Base URI
1321     string private _baseURI;
1322 
1323     /*
1324      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1325      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1326      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1327      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1328      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1329      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1330      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1331      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1332      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1333      *
1334      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1335      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1336      */
1337     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1338 
1339     /*
1340      *     bytes4(keccak256('name()')) == 0x06fdde03
1341      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1342      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1343      *
1344      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1345      */
1346     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1347 
1348     /*
1349      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1350      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1351      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1352      *
1353      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1354      */
1355     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1356 
1357     /**
1358      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1359      */
1360     constructor (string memory name, string memory symbol) public {
1361         _name = name;
1362         _symbol = symbol;
1363 
1364         // register the supported interfaces to conform to ERC721 via ERC165
1365         _registerInterface(_INTERFACE_ID_ERC721);
1366         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1367         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1368     }
1369 
1370     /**
1371      * @dev See {IERC721-balanceOf}.
1372      */
1373     function balanceOf(address owner) public view override returns (uint256) {
1374         require(owner != address(0), "ERC721: balance query for the zero address");
1375 
1376         return _holderTokens[owner].length();
1377     }
1378 
1379     /**
1380      * @dev See {IERC721-ownerOf}.
1381      */
1382     function ownerOf(uint256 tokenId) public view override returns (address) {
1383         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1384     }
1385 
1386     /**
1387      * @dev See {IERC721Metadata-name}.
1388      */
1389     function name() public view override returns (string memory) {
1390         return _name;
1391     }
1392 
1393     /**
1394      * @dev See {IERC721Metadata-symbol}.
1395      */
1396     function symbol() public view override returns (string memory) {
1397         return _symbol;
1398     }
1399 
1400     /**
1401      * @dev See {IERC721Metadata-tokenURI}.
1402      */
1403     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1404     }
1405 
1406     /**
1407     * @dev Returns the base URI set via {_setBaseURI}. This will be
1408     * automatically added as a prefix in {tokenURI} to each token's URI, or
1409     * to the token ID if no specific URI is set for that token ID.
1410     */
1411     function baseURI() public view returns (string memory) {
1412         return _baseURI;
1413     }
1414 
1415     /**
1416      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1417      */
1418     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1419         return _holderTokens[owner].at(index);
1420     }
1421 
1422     /**
1423      * @dev See {IERC721Enumerable-totalSupply}.
1424      */
1425     function totalSupply() public view override returns (uint256) {
1426         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1427         return _tokenOwners.length();
1428     }
1429 
1430     /**
1431      * @dev See {IERC721Enumerable-tokenByIndex}.
1432      */
1433     function tokenByIndex(uint256 index) public view override returns (uint256) {
1434         (uint256 tokenId, ) = _tokenOwners.at(index);
1435         return tokenId;
1436     }
1437 
1438     /**
1439      * @dev See {IERC721-approve}.
1440      */
1441     function approve(address to, uint256 tokenId) public virtual override {
1442         address owner = ownerOf(tokenId);
1443         require(to != owner, "ERC721: approval to current owner");
1444 
1445         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1446             "ERC721: approve caller is not owner nor approved for all"
1447         );
1448 
1449         _approve(to, tokenId);
1450     }
1451 
1452     /**
1453      * @dev See {IERC721-getApproved}.
1454      */
1455     function getApproved(uint256 tokenId) public view override returns (address) {
1456         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1457 
1458         return _tokenApprovals[tokenId];
1459     }
1460 
1461     /**
1462      * @dev See {IERC721-setApprovalForAll}.
1463      */
1464     function setApprovalForAll(address operator, bool approved) public virtual override {
1465         require(operator != _msgSender(), "ERC721: approve to caller");
1466 
1467         _operatorApprovals[_msgSender()][operator] = approved;
1468         emit ApprovalForAll(_msgSender(), operator, approved);
1469     }
1470 
1471     /**
1472      * @dev See {IERC721-isApprovedForAll}.
1473      */
1474     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
1475         return _operatorApprovals[owner][operator];
1476     }
1477 
1478     /**
1479      * @dev See {IERC721-transferFrom}.
1480      */
1481     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1482         //solhint-disable-next-line max-line-length
1483         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1484 
1485         _transfer(from, to, tokenId);
1486     }
1487 
1488     /**
1489      * @dev See {IERC721-safeTransferFrom}.
1490      */
1491     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1492         safeTransferFrom(from, to, tokenId, "");
1493     }
1494 
1495     /**
1496      * @dev See {IERC721-safeTransferFrom}.
1497      */
1498     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1499         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1500         _safeTransfer(from, to, tokenId, _data);
1501     }
1502 
1503     /**
1504      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1505      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1506      *
1507      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1508      *
1509      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1510      * implement alternative mecanisms to perform token transfer, such as signature-based.
1511      *
1512      * Requirements:
1513      *
1514      * - `from` cannot be the zero address.
1515      * - `to` cannot be the zero address.
1516      * - `tokenId` token must exist and be owned by `from`.
1517      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1518      *
1519      * Emits a {Transfer} event.
1520      */
1521     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1522         _transfer(from, to, tokenId);
1523         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1524     }
1525 
1526     /**
1527      * @dev Returns whether `tokenId` exists.
1528      *
1529      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1530      *
1531      * Tokens start existing when they are minted (`_mint`),
1532      * and stop existing when they are burned (`_burn`).
1533      */
1534     function _exists(uint256 tokenId) internal view returns (bool) {
1535         return _tokenOwners.contains(tokenId);
1536     }
1537 
1538     /**
1539      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1540      *
1541      * Requirements:
1542      *
1543      * - `tokenId` must exist.
1544      */
1545     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
1546         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1547         address owner = ownerOf(tokenId);
1548         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1549     }
1550 
1551     /**
1552      * @dev Safely mints `tokenId` and transfers it to `to`.
1553      *
1554      * Requirements:
1555      d*
1556      * - `tokenId` must not exist.
1557      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1558      *
1559      * Emits a {Transfer} event.
1560      */
1561     function _safeMint(address to, uint256 tokenId) internal virtual {
1562         _safeMint(to, tokenId, "");
1563     }
1564 
1565     /**
1566      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1567      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1568      */
1569     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1570         _mint(to, tokenId);
1571         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1572     }
1573 
1574     /**
1575      * @dev Mints `tokenId` and transfers it to `to`.
1576      *
1577      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1578      *
1579      * Requirements:
1580      *
1581      * - `tokenId` must not exist.
1582      * - `to` cannot be the zero address.
1583      *
1584      * Emits a {Transfer} event.
1585      */
1586     function _mint(address to, uint256 tokenId) internal virtual {
1587         require(to != address(0), "ERC721: mint to the zero address");
1588         require(!_exists(tokenId), "ERC721: token already minted");
1589 
1590         _beforeTokenTransfer(address(0), to, tokenId);
1591 
1592         _holderTokens[to].add(tokenId);
1593 
1594         _tokenOwners.set(tokenId, to);
1595 
1596         emit Transfer(address(0), to, tokenId);
1597     }
1598 
1599     /**
1600      * @dev Destroys `tokenId`.
1601      * The approval is cleared when the token is burned.
1602      *
1603      * Requirements:
1604      *
1605      * - `tokenId` must exist.
1606      *
1607      * Emits a {Transfer} event.
1608      */
1609     function _burn(uint256 tokenId) internal virtual {
1610         address owner = ownerOf(tokenId);
1611 
1612         _beforeTokenTransfer(owner, address(0), tokenId);
1613 
1614         // Clear approvals
1615         _approve(address(0), tokenId);
1616 
1617         // Clear metadata (if any)
1618         if (bytes(_tokenURIs[tokenId]).length != 0) {
1619             delete _tokenURIs[tokenId];
1620         }
1621 
1622         _holderTokens[owner].remove(tokenId);
1623 
1624         _tokenOwners.remove(tokenId);
1625 
1626         emit Transfer(owner, address(0), tokenId);
1627     }
1628 
1629     /**
1630      * @dev Transfers `tokenId` from `from` to `to`.
1631      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1632      *
1633      * Requirements:
1634      *
1635      * - `to` cannot be the zero address.
1636      * - `tokenId` token must be owned by `from`.
1637      *
1638      * Emits a {Transfer} event.
1639      */
1640     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1641         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1642         require(to != address(0), "ERC721: transfer to the zero address");
1643 
1644         _beforeTokenTransfer(from, to, tokenId);
1645 
1646         // Clear approvals from the previous owner
1647         _approve(address(0), tokenId);
1648 
1649         _holderTokens[from].remove(tokenId);
1650         _holderTokens[to].add(tokenId);
1651 
1652         _tokenOwners.set(tokenId, to);
1653 
1654         emit Transfer(from, to, tokenId);
1655     }
1656 
1657     /**
1658      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1659      *
1660      * Requirements:
1661      *
1662      * - `tokenId` must exist.
1663      */
1664     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1665         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1666         _tokenURIs[tokenId] = _tokenURI;
1667     }
1668 
1669     /**
1670      * @dev Internal function to set the base URI for all token IDs. It is
1671      * automatically added as a prefix to the value returned in {tokenURI},
1672      * or to the token ID if {tokenURI} is empty.
1673      */
1674     function _setBaseURI(string memory baseURI_) internal virtual {
1675         _baseURI = baseURI_;
1676     }
1677 
1678     /**
1679      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1680      * The call is not executed if the target address is not a contract.
1681      *
1682      * @param from address representing the previous owner of the given token ID
1683      * @param to target address that will receive the tokens
1684      * @param tokenId uint256 ID of the token to be transferred
1685      * @param _data bytes optional data to send along with the call
1686      * @return bool whether the call correctly returned the expected magic value
1687      */
1688     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1689         private returns (bool)
1690     {
1691         if (!to.isContract()) {
1692             return true;
1693         }
1694         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1695             IERC721Receiver(to).onERC721Received.selector,
1696             _msgSender(),
1697             from,
1698             tokenId,
1699             _data
1700         ), "ERC721: transfer to non ERC721Receiver implementer");
1701         bytes4 retval = abi.decode(returndata, (bytes4));
1702         return (retval == _ERC721_RECEIVED);
1703     }
1704 
1705     function _approve(address to, uint256 tokenId) private {
1706         _tokenApprovals[tokenId] = to;
1707         emit Approval(ownerOf(tokenId), to, tokenId);
1708     }
1709 
1710     /**
1711      * @dev Hook that is called before any token transfer. This includes minting
1712      * and burning.
1713      *
1714      * Calling conditions:
1715      *
1716      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1717      * transferred to `to`.
1718      * - When `from` is zero, `tokenId` will be minted for `to`.
1719      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1720      * - `from` cannot be the zero address.
1721      * - `to` cannot be the zero address.
1722      *
1723      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1724      */
1725     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1726 }
1727 
1728 
1729 
1730 
1731 
1732 
1733 /**
1734  * @dev Standard math utilities missing in the Solidity language.
1735  */
1736 library Math {
1737     /**
1738      * @dev Returns the largest of two numbers.
1739      */
1740     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1741         return a >= b ? a : b;
1742     }
1743 
1744     /**
1745      * @dev Returns the smallest of two numbers.
1746      */
1747     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1748         return a < b ? a : b;
1749     }
1750 
1751     /**
1752      * @dev Returns the average of two numbers. The result is rounded towards
1753      * zero.
1754      */
1755     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1756         // (a + b) / 2 can overflow, so we distribute
1757         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
1758     }
1759 }
1760 
1761 
1762 
1763 
1764 
1765 
1766 /**
1767  * @dev Contract module which provides a basic access control mechanism, where
1768  * there is an account (an owner) that can be granted exclusive access to
1769  * specific functions.
1770  *
1771  * By default, the owner account will be the one that deploys the contract. This
1772  * can later be changed with {transferOwnership}.
1773  *
1774  * This module is used through inheritance. It will make available the modifier
1775  * `onlyOwner`, which can be applied to your functions to restrict their use to
1776  * the owner.
1777  */
1778 contract Ownable is Context {
1779     address private _owner;
1780 
1781     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1782 
1783     /**
1784      * @dev Initializes the contract setting the deployer as the initial owner.
1785      */
1786     constructor () internal {
1787         address msgSender = _msgSender();
1788         _owner = msgSender;
1789         emit OwnershipTransferred(address(0), msgSender);
1790     }
1791 
1792     /**
1793      * @dev Returns the address of the current owner.
1794      */
1795     function owner() public view returns (address) {
1796         return _owner;
1797     }
1798 
1799     /**
1800      * @dev Throws if called by any account other than the owner.
1801      */
1802     modifier onlyOwner() {
1803         require(_owner == _msgSender(), "Ownable: caller is not the owner");
1804         _;
1805     }
1806 
1807     /**
1808      * @dev Leaves the contract without owner. It will not be possible to call
1809      * `onlyOwner` functions anymore. Can only be called by the current owner.
1810      *
1811      * NOTE: Renouncing ownership will leave the contract without an owner,
1812      * thereby removing any functionality that is only available to the owner.
1813      */
1814     function renounceOwnership() public virtual onlyOwner {
1815         emit OwnershipTransferred(_owner, address(0));
1816         _owner = address(0);
1817     }
1818 
1819     /**
1820      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1821      * Can only be called by the current owner.
1822      */
1823     function transferOwnership(address newOwner) public virtual onlyOwner {
1824         require(newOwner != address(0), "Ownable: new owner is the zero address");
1825         emit OwnershipTransferred(_owner, newOwner);
1826         _owner = newOwner;
1827     }
1828 }
1829 
1830 
1831 
1832 
1833 
1834 
1835 
1836 
1837 
1838 
1839 
1840 contract Sync is IERC20, Ownable {
1841   using SafeMath for uint256;
1842 
1843   mapping (address => uint256) private balances;
1844   mapping (address => mapping (address => uint256)) private allowed;
1845   string public constant name  = "SYNC";
1846   string public constant symbol = "SYNC";
1847   uint8 public constant decimals = 18;
1848   uint256 _totalSupply = 16000000 * (10 ** 18); // 16 million supply
1849 
1850   mapping (address => bool) public mintContracts;
1851 
1852   modifier isMintContract() {
1853     require(mintContracts[msg.sender],"calling address is not allowed to mint");
1854     _;
1855   }
1856 
1857   constructor() public Ownable(){
1858     balances[msg.sender] = _totalSupply;
1859     emit Transfer(address(0), msg.sender, _totalSupply);
1860   }
1861 
1862   function setMintAccess(address account, bool canMint) public onlyOwner {
1863     mintContracts[account]=canMint;
1864   }
1865 
1866   function _mint(address account, uint256 amount) public isMintContract {
1867     require(account != address(0), "ERC20: mint to the zero address");
1868     _totalSupply = _totalSupply.add(amount);
1869     balances[account] = balances[account].add(amount);
1870     emit Transfer(address(0), account, amount);
1871   }
1872 
1873   function totalSupply() public view override returns (uint256) {
1874     return _totalSupply;
1875   }
1876 
1877   function balanceOf(address user) public view override returns (uint256) {
1878     return balances[user];
1879   }
1880 
1881   function allowance(address user, address spender) public view override returns (uint256) {
1882     return allowed[user][spender];
1883   }
1884 
1885   function transfer(address to, uint256 value) public override returns (bool) {
1886     require(value <= balances[msg.sender],"insufficient balance");
1887     require(to != address(0),"cannot send to zero address");
1888 
1889     balances[msg.sender] = balances[msg.sender].sub(value);
1890     balances[to] = balances[to].add(value);
1891 
1892     emit Transfer(msg.sender, to, value);
1893     return true;
1894   }
1895 
1896   function approve(address spender, uint256 value) public override returns (bool) {
1897     require(spender != address(0),"cannot approve the zero address");
1898     allowed[msg.sender][spender] = value;
1899     emit Approval(msg.sender, spender, value);
1900     return true;
1901   }
1902 
1903   function approveAndCall(address spender, uint256 tokens, bytes calldata data) external returns (bool) {
1904         allowed[msg.sender][spender] = tokens;
1905         emit Approval(msg.sender, spender, tokens);
1906         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
1907         return true;
1908     }
1909 
1910   function transferFrom(address from, address to, uint256 value) public override returns (bool) {
1911     require(value <= balances[from],"insufficient balance");
1912     require(value <= allowed[from][msg.sender],"insufficient allowance");
1913     require(to != address(0),"cannot send to the zero address");
1914 
1915     balances[from] = balances[from].sub(value);
1916     balances[to] = balances[to].add(value);
1917 
1918     allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
1919 
1920     emit Transfer(from, to, value);
1921     return true;
1922   }
1923 
1924   function burn(uint256 amount) external {
1925     require(amount != 0,"must burn more than zero");
1926     require(amount <= balances[msg.sender],"insufficient balance");
1927     _totalSupply = _totalSupply.sub(amount);
1928     balances[msg.sender] = balances[msg.sender].sub(amount);
1929     emit Transfer(msg.sender, address(0), amount);
1930   }
1931 
1932 }
1933 
1934 
1935 
1936 
1937 contract CBOND is ERC721, Ownable {
1938   using SafeMath for uint256;
1939   using Strings for uint256;
1940   using AddressStrings for address;
1941 
1942   event Created(address token,uint256 syncAmount,uint256 tokenAmount,uint256 syncPrice,uint256 tokenPrice,uint256 tokenId);
1943   event Matured(address token,uint256 syncReturned,uint256 tokenAmount,uint256 tokenId);
1944   event DivsPaid(address token,uint256 syncReturned,uint256 tokenId);
1945 
1946   //read only counter values
1947   uint256 public totalCBONDS=0;//Total number of Cbonds created.
1948   uint256 public totalQuarterlyCBONDS=0;//Total number of quarterly Cbonds created.
1949   uint256 public totalCBONDSCashedout=0;//Total number of Cbonds that have been matured.
1950   uint256 public totalSYNCLocked=0;//Total amount of Sync locked in Cbonds.
1951   mapping(address => uint256) public totalLiquidityLockedByPair;//Total amount of tokens locked in Cbonds of the given liquidity token.
1952 
1953   //values contained in individual CBONDs, by token id
1954   mapping(uint256 => address) public lAddrById;//The address of the liquidity token used to create the given Cbond.
1955   mapping(uint256 => uint256) public lTokenPriceById;//The relative price of the liquidity token at the time the given Cbond was created.
1956   mapping(uint256 => uint256) public lTokenAmountById;//The amount of liquidity tokens initially deposited into the given Cbond.
1957   mapping(uint256 => uint256) public syncPriceById;//The relative price of Sync at the time the given Cbond was created.
1958   mapping(uint256 => uint256) public syncAmountById;//The amount of Sync initially deposited into the given Cbond.
1959   mapping(uint256 => uint256) public syncInterestById;//The amount of Sync interest on the initially deposited Sync awarded by the given Cbond. For quarterly Cbonds, this variable will represent only the interest of a single quarter.
1960   mapping(uint256 => uint256) public syncRewardedOnMaturity;//The amount of Sync returned to the user on maturation of the given Cbond.
1961   mapping(uint256 => uint256) public timestampById;//The time the given Cbond was created.
1962   mapping(uint256 => bool) public gradualDivsById;//Whether the given Cbond awards dividends quarterly.
1963   mapping(uint256 => uint256) public lastDivsCashoutById;//For Quarterly Cbonds, this variable represents the last cashout timestamp.
1964   mapping(uint256 => uint256) public totalDivsCashoutById;//For Quarterly Cbonds, the total dividends cashed out to date. Frontend use only, not used for calculations within the contract.
1965   mapping(uint256 => uint256) public termLengthById;//Length of term in seconds for the given Cbond.
1966 
1967   //constant and pseudo-constant (never changed after constructor) values
1968   uint256 constant public PERCENTAGE_PRECISION=10000;//Divide percentages by this to get the real multiplier.
1969   uint256 constant public INCENTIVE_MAX_PERCENT=220;//2.2%, the maximum value the liquidity incentive rate can be.
1970   uint256 constant public MAX_SYNC_GLOBAL=100000 * (10 ** 18);//Maximum Sync in a Cbond. Cbonds with higher amounts of Sync cannot be created.
1971   uint256 constant public QUARTER_LENGTH=90 days;//The length of a quarter, the interval of time between quarterly dividends.
1972   uint256 public STARTING_TIME=block.timestamp;//The time the contract was deployed.
1973   uint256 constant public BASE_INTEREST_RATE_START=220;//2.2%, starting value for base interest rate.
1974   uint256 constant public MINIMUM_BASE_INTEREST_RATE=10;//0.1%, the minimum value base interest rate can be.
1975   uint256 constant public MAXIMUM_BASE_INTEREST_RATE=4500;//45%, the maximum value base interest rate can be.
1976   uint256[] public LUCKY_EXTRAS=[500,1000];//Bonus interest awarded to user on creating lucky and extra lucky Cbonds.
1977   uint256 public YEAR_LENGTH=360 days;//Time length of approximately 1 year
1978   uint256[] public TERM_DURATIONS=[90 days,180 days,360 days,720 days,1080 days];//Possible term durations for Cbonds, index values corresponding to the following variables:
1979   uint256[] public DURATION_MODIFIERS=[825,1650,3300,6600,10000];//The percentage values used as duration modifiers for the given term lengths.
1980   uint256[] public DURATION_CALC_LOOPS=[0,0,3,7,11];//Number of loops for the duration rate formula approximation function, for the given term duration.
1981   mapping(uint256 => uint256) public INDEX_BY_DURATION;//Mapping of term durations to index values, as relates to the above variables.
1982   uint256 public RISK_FACTOR = 5;//Constant used in duration rate calculation
1983 
1984   //Index variables for tracking
1985   uint256 public lastDaySyncSupplyUpdated=0;//The previously recorded day on which the supply of Sync was last recorded into syncSupplyByDay.
1986   uint256 public currentDaySyncSupplyUpdated=0;//The day on which the supply of Sync was last recorded into syncSupplyByDay.
1987   mapping(address => mapping(uint256 => uint256)) public cbondsHeldByUser;//Mapping of cbond ids held by user. The second mapping is a list, length given by cbondsHeldByUserCursor.
1988   mapping(address => uint256) public cbondsHeldByUserCursor;//The number of Cbonds held by the given user.
1989   mapping(address => uint256) public lastDayTokenSupplyUpdated;//The previously recorded day on which the supply of the given token was last recorded into liqTokenTotalsByDay.
1990   mapping(address => uint256) public currentDayTokenSupplyUpdated;//The day on which the supply of the given token was last recorded into liqTokenTotalsByDay.
1991   mapping(uint256 => uint256) public syncSupplyByDay;//The recorded total supply of the Sync token for the given day. This value is written once and thereafter cannot be changed for a given day.
1992   mapping(uint256 => uint256) public interestRateByDay;//The recorded base interest rate for the given day. This value is written once and thereafter cannot be changed for a given day, and is recorded simultaneously with syncSupplyByDay.
1993   mapping(address => mapping(uint256 => uint256)) public liqTokenTotalsByDay;//The recorded total for the given liquidity token on the given day. This value is written once and thereafter cannot be changed for a given token/day.
1994   uint256 public _currentTokenId = 0;//Variable for tracking next NFT identifier.
1995 
1996   //Read only tracking variables (not used within the smart contract)
1997   mapping(uint256 => uint256) public cbondsMaturingByDay;//Mapping of days to number of cbonds maturing that day.
1998 
1999   //admin adjustable values
2000   mapping(address => bool) public tokenAccepted;//Whether a given liquidity token has been approved for use by admins. Cbonds can only be created using tokens listed here.
2001   uint256 public syncMinimum = 25 * (10 ** 18);//Cbonds cannot be created unless at least this amount of Sync is being included in them.
2002   bool public luckyEnabled = true;//Whether it is possible to create Lucky Cbonds
2003 
2004   //external contracts
2005   Oracle public priceChecker;//Used to determine the ratio in price between Sync and a given liquidity token. The value returned should not significantly affect user incentives and does not need to be guaranteed not to be exploitable by the user. Contract can be replaced by admin.
2006   Sync syncToken;//The Sync token contract. Sync is contained in every Cbond and is minted to provide interest on Cbonds.
2007 
2008   constructor(Oracle o,Sync s) public Ownable() ERC721("CBOND","CBOND"){
2009     priceChecker=o;
2010     syncToken=s;
2011     syncSupplyByDay[0]=syncToken.totalSupply();
2012     interestRateByDay[0]=BASE_INTEREST_RATE_START;
2013     _setBaseURI("api.syncbond.com");
2014     for(uint256 i=0;i<TERM_DURATIONS.length;i++){
2015       INDEX_BY_DURATION[TERM_DURATIONS[i]]=i;
2016     }
2017   }
2018 
2019   /*
2020     Admin functions
2021   */
2022 
2023   /*
2024     Admin function to set the base URI for metadata access.
2025   */
2026   function setBaseURI(string calldata baseURI_) external onlyOwner{
2027     _setBaseURI(baseURI_);
2028   }
2029 
2030   /*
2031     Admin function to set liquidity tokens which may be used to create Cbonds.
2032   */
2033   function setLiquidityTokenAccepted(address token,bool accepted) external onlyOwner{
2034     tokenAccepted[token]=accepted;
2035   }
2036 
2037   /*
2038     Admin function to set liquidity tokens which may be used to create Cbonds.
2039   */
2040   function setLiquidityTokenAcceptedMulti(address[] calldata tokens,bool accepted) external onlyOwner{
2041     for(uint256 i=0;i<tokens.length;i++){
2042       tokenAccepted[tokens[i]]=accepted;
2043     }
2044   }
2045 
2046   /*
2047     Admin function to reduce the minimum amount of Sync that can be used to create a Cbond.
2048   */
2049   function setSyncMinimum(uint256 newMinimum) public onlyOwner{
2050     require(newMinimum<syncMinimum,"increasing minimum sync required is not permitted");
2051     syncMinimum=newMinimum;
2052   }
2053 
2054   /*
2055     Admin function to change the price oracle.
2056   */
2057   function setPriceOracle(Oracle o) external onlyOwner{
2058     priceChecker=o;
2059   }
2060 
2061   /*
2062     Admin function to toggle on/off the lucky bonus.
2063   */
2064   function toggleLuckyBonus(bool enabled) external onlyOwner{
2065     luckyEnabled=enabled;
2066   }
2067 
2068   /*
2069     Admin function for updating the daily Sync total supply and token supply for various tokens, for use in case of low activity.
2070   */
2071   function recordSyncAndTokens(address[] calldata tokens) external onlyOwner{
2072     recordSyncSupply();
2073     for(uint256 i=0;i<tokens.length;i++){
2074       recordTokenSupply(tokens[i]);
2075     }
2076   }
2077 
2078   /*
2079     Retrieves available dividends for the given token. Dividends accrue every 3 months.
2080   */
2081   function cashOutDivs(uint256 tokenId) external{
2082     require(msg.sender==ownerOf(tokenId),"only token owner can call this");
2083     require(gradualDivsById[tokenId],"must be in quarterly dividends mode");
2084 
2085     //record current Sync supply and liquidity token supply for the day if needed
2086     recordSyncSupply();
2087     recordTokenSupply(lAddrById[tokenId]);
2088 
2089     //reward user with appropriate amount. If none is due it will provide an amount of 0 tokens.
2090     uint256 divs=dividendsOf(tokenId);
2091     syncToken._mint(msg.sender,divs);
2092 
2093     //register the timestamp of this transaction so future div payouts can be accurately calculated
2094     lastDivsCashoutById[tokenId]=block.timestamp;
2095 
2096     //update read variables
2097     totalDivsCashoutById[tokenId]=totalDivsCashoutById[tokenId].add(divs);
2098 
2099     emit DivsPaid(lAddrById[tokenId],divs,tokenId);
2100   }
2101 
2102   /*
2103     Returns liquidity tokens, mints Sync to pay back initial amount plus rewards.
2104   */
2105   function matureCBOND(uint256 tokenId) public{
2106     require(msg.sender==ownerOf(tokenId),"only token owner can call this");
2107     require(block.timestamp>termLengthById[tokenId].add(timestampById[tokenId]),"cbond term not yet completed");
2108 
2109     //record current Sync supply and liquidity token supply for the day if needed
2110     recordSyncSupply();
2111     recordTokenSupply(lAddrById[tokenId]);
2112 
2113     //amount of sync provided to user is initially deposited amount plus interest
2114     uint256 syncRetrieved=syncRewardedOnMaturity[tokenId];
2115 
2116     //provide user with their Sync tokens and their initially deposited liquidity tokens
2117     uint256 beforeMint=syncToken.balanceOf(msg.sender);
2118     syncToken._mint(msg.sender,syncRetrieved);
2119     require(IERC20(lAddrById[tokenId]).transfer(msg.sender,lTokenAmountById[tokenId]),"transfer must succeed");
2120 
2121     //update read only counter
2122     totalCBONDSCashedout=totalCBONDSCashedout.add(1);
2123     emit Matured(lAddrById[tokenId],syncRetrieved,lTokenAmountById[tokenId],tokenId);
2124 
2125     //burn the nft
2126     _burn(tokenId);
2127   }
2128 
2129   /*
2130     Public function for creating a new Cbond.
2131   */
2132   function createCBOND(address liquidityToken,uint256 amount,uint256 syncMaximum,uint256 secondsInTerm,bool gradualDivs) external returns(uint256){
2133     return _createCBOND(liquidityToken,amount,syncMaximum,secondsInTerm,gradualDivs,msg.sender);
2134   }
2135 
2136   /*
2137     Function for creating a new Cbond. User specifies a liquidity token and an amount, this is transferred from their account to this contract, along with a corresponding amount of Sync (transaction reverts if this is greater than the user provided maximum at the time of execution). A permitted term length is also provided, and whether the Cbond should provide gradual divs (Quarterly variety Cbond).
2138   */
2139   function _createCBOND(address liquidityToken,uint256 amount,uint256 syncMaximum,uint256 secondsInTerm,bool gradualDivs,address sender) private returns(uint256){
2140     require(tokenAccepted[liquidityToken],"liquidity token must be on the list of approved tokens");
2141 
2142     //record current Sync supply and liquidity token supply for the day if needed
2143     recordSyncSupply();
2144     recordTokenSupply(liquidityToken);
2145 
2146     //determine amount of Sync required, given the amount of liquidity tokens specified, and transfer that amount from the user
2147     uint256 liquidityValue=priceChecker.liquidityValues(liquidityToken);
2148     uint256 syncValue=priceChecker.syncValue();
2149     //Since syncRequired is the exact amount of Sync that will be transferred from the user, integer division truncations propagating to other values derived from this one is the correct behavior.
2150     uint256 syncRequired=liquidityValue.mul(amount).div(syncValue);
2151     require(syncRequired>=syncMinimum,"input tokens too few, sync transferred must be above the minimum");
2152     require(syncRequired<=syncMaximum,"price changed too much since transaction submitted");
2153     require(syncRequired<=MAX_SYNC_GLOBAL,"CBOND amount too large");
2154     syncToken.transferFrom(sender,address(this),syncRequired);
2155     require(IERC20(liquidityToken).transferFrom(sender,address(this),amount),"transfer must succeed");
2156 
2157     //burn sync tokens provided
2158     syncToken.burn(syncRequired);
2159 
2160     //get the token id of the new NFT
2161     uint256 tokenId=_getNextTokenId();
2162 
2163     //set all nft variables
2164     lAddrById[tokenId]=liquidityToken;
2165     syncPriceById[tokenId]=syncValue;
2166     syncAmountById[tokenId]=syncRequired;
2167     lTokenPriceById[tokenId]=liquidityValue;
2168     lTokenAmountById[tokenId]=amount;
2169     timestampById[tokenId]=block.timestamp;
2170     lastDivsCashoutById[tokenId]=block.timestamp;
2171     gradualDivsById[tokenId]=gradualDivs;
2172     termLengthById[tokenId]=secondsInTerm;
2173 
2174     //set the interest rate and final maturity withdraw amount
2175     setInterestRate(tokenId,syncRequired,liquidityToken,secondsInTerm,gradualDivs);
2176 
2177     //update global counters
2178     cbondsMaturingByDay[getDay(block.timestamp.add(secondsInTerm))]=cbondsMaturingByDay[getDay(block.timestamp.add(secondsInTerm))].add(1);
2179     cbondsHeldByUser[sender][cbondsHeldByUserCursor[sender]]=tokenId;
2180     cbondsHeldByUserCursor[sender]=cbondsHeldByUserCursor[sender].add(1);
2181     totalCBONDS=totalCBONDS.add(1);
2182     totalSYNCLocked=totalSYNCLocked.add(syncRequired);
2183     totalLiquidityLockedByPair[liquidityToken]=totalLiquidityLockedByPair[liquidityToken].add(amount);
2184 
2185     //create NFT
2186     _safeMint(sender,tokenId);
2187     _incrementTokenId();
2188 
2189     //submit event
2190      emit Created(liquidityToken,syncRequired,amount,syncValue,liquidityValue,tokenId);
2191      return tokenId;
2192   }
2193 
2194   /*
2195     Creates a metadata string from a token id. Should not be used onchain.
2196   */
2197   function putTogetherMetadataString(uint256 tokenId) public view returns(string memory){
2198     //TODO: add the rest of the variables, separate with appropriate url variable separators for ease of use
2199     string memory isDivs=gradualDivsById[tokenId]?"true":"false";
2200     return string(abi.encodePacked("/?tokenId=",tokenId.toString(),"&lAddr=",lAddrById[tokenId].toString(),"&syncPrice=", syncPriceById[tokenId].toString(),"&syncAmount=",syncAmountById[tokenId].toString(),"&mPayout=",syncRewardedOnMaturity[tokenId].toString(),"&lPrice=",lTokenPriceById[tokenId].toString(),"&lAmount=",lTokenAmountById[tokenId].toString(),"&startTime=",timestampById[tokenId].toString(),"&isDivs=",isDivs,"&termLength=",termLengthById[tokenId].toString(),"&divsNow=",dividendsOf(tokenId).toString()));
2201   }
2202 
2203   /**
2204    * @dev See {IERC721Metadata-tokenURI}.
2205    */
2206   function tokenURI(uint256 tokenId) public view override returns (string memory) {
2207       require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
2208 
2209       //this line altered from
2210       //string memory _tokenURI = _tokenURIs[tokenId];
2211       //use of gas to manipulate strings can be avoided by putting them together at time of retrieval rather than in the token creation transaction.
2212       string memory _tokenURI = putTogetherMetadataString(tokenId);
2213 
2214       // If there is no base URI, return the token URI.
2215       if (bytes(baseURI()).length == 0) {
2216           return _tokenURI;
2217       }
2218       // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
2219       if (bytes(_tokenURI).length > 0) {
2220           return string(abi.encodePacked(baseURI(), _tokenURI));
2221       }
2222       // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
2223       return string(abi.encodePacked(baseURI(), tokenId.toString()));
2224   }
2225 
2226   /*
2227     Increments a counter used to produce the identifier for the next token to be created.
2228   */
2229   function _incrementTokenId() private  {
2230     _currentTokenId=_currentTokenId.add(1);
2231   }
2232 
2233   /*
2234     view functions
2235   */
2236 
2237   /*
2238     Returns the next unused token identifier.
2239   */
2240   function _getNextTokenId() private view returns (uint256) {
2241     return _currentTokenId.add(1);
2242   }
2243 
2244   /*
2245     Convenience function to get the current block time directly from the contract.
2246   */
2247   function getTime() public view returns(uint256){
2248     return block.timestamp;
2249   }
2250 
2251   /*
2252     Returns the current dividends owed to the given token, payable to its current owner.
2253   */
2254   function dividendsOf(uint256 tokenId) public view returns(uint256){
2255     //determine the number of periods worth of divs the token owner is owed, by subtracting the current period by the period when divs were last withdrawn.
2256     require(lastDivsCashoutById[tokenId]>=timestampById[tokenId],"dof1");
2257     uint256 lastCashoutInPeriod=lastDivsCashoutById[tokenId].sub(timestampById[tokenId]).div(QUARTER_LENGTH);//0 - first quarter, 1 - second, etc. This variable also represents the number of quarters previously cashed out
2258     require(block.timestamp>=timestampById[tokenId],"dof2");
2259     uint256 currentCashoutInPeriod=block.timestamp.sub(timestampById[tokenId]).div(QUARTER_LENGTH);
2260     require(currentCashoutInPeriod>=lastCashoutInPeriod,"dof3");
2261     uint256 periodsToCashout=currentCashoutInPeriod.sub(lastCashoutInPeriod);
2262 
2263     //only accrue divs before the maturation date. The final div payment will be paid as part of the matureCBOND transaction, so set the maximum number of periods to cash out be one less than the ultimate total.
2264     if(currentCashoutInPeriod>=termLengthById[tokenId].div(90 days)){
2265       //possible for lastCashout period to be greater due to being able to cash out after CBOND has ended (which records lastCashout as being after that date, despite only paying out for earlier periods). In this case, set periodsToCashout to 0 and ultimately return 0, there are no divs left.
2266       if(lastCashoutInPeriod>termLengthById[tokenId].div(90 days).sub(1)){
2267         periodsToCashout=0;
2268       }
2269       else{
2270         periodsToCashout=termLengthById[tokenId].div(90 days).sub(1).sub(lastCashoutInPeriod);
2271       }
2272 
2273     }
2274     //multiply the number of periods to pay out with the amount of divs owed for one period. Note: if this is a Quarterly Cbond, syncInterestById will have been recorded as the interest per quarter, rather than the total interest for the Cbond, as with a normal Cbond.
2275     uint quarterlyDividend=syncInterestById[tokenId];
2276     return periodsToCashout.mul(syncAmountById[tokenId]).mul(quarterlyDividend).div(PERCENTAGE_PRECISION);
2277   }
2278 
2279   /*
2280     Returns the amount of Sync needed to create a Cbond with the given amount of the given liquidity token. Consults the price oracle for the appropriate ratio.
2281   */
2282   function getSyncRequiredForCreation(IERC20 liquidityToken,uint256 amount) external view returns(uint256){
2283     return  priceChecker.liquidityValues(address(liquidityToken)).mul(amount).div(priceChecker.syncValue());
2284   }
2285 
2286   /*
2287     Set the sync rewarded on maturity and interest rate for the given CBOND
2288   */
2289   function setInterestRate(uint256 tokenId,uint256 syncRequired,address liquidityToken,uint256 secondsInTerm,bool gradualDivs) private{
2290     (uint256 lastSupply,uint256 currentSupply,uint256 lastTSupply,uint256 currentTSupply,uint256 lastInterestRate)=getSuppliesNow(liquidityToken);
2291     (uint256 interestRate,uint256 totalReturn)=getCbondTotalReturn(tokenId,syncRequired,liquidityToken,secondsInTerm,gradualDivs);
2292     syncRewardedOnMaturity[tokenId]=totalReturn;
2293     syncInterestById[tokenId]=interestRate;
2294     if(gradualDivs){
2295       require(secondsInTerm>=TERM_DURATIONS[2],"dividend bearing CBONDs must be at least 1 year duration");
2296       totalQuarterlyCBONDS=totalQuarterlyCBONDS.add(1);
2297     }
2298   }
2299 
2300   /*
2301     Following two functions work immediately after all the Cbond variables except the interest rate have been set, will be inaccurate other times. To be used as part of Cbond creation.
2302   */
2303 
2304   /*
2305     Gets the amount of Sync for the given Cbond to return on maturity.
2306   */
2307   function getCbondTotalReturn(uint256 tokenId,uint256 syncAmount,address liqAddr,uint256 duration,bool isDivs) public view returns(uint256 interestRate,uint256 totalReturn){
2308     // This is an integer math translation of P*(1+I) where P is principle I is interest rate. The new, equivalent formula is P*(c+I*c)/c where c is a constant of amount PERCENTAGE_PRECISION.
2309 
2310     interestRate=getCbondInterestRateNow(liqAddr, duration,getLuckyExtra(tokenId),isDivs);
2311     totalReturn = syncAmount.mul(PERCENTAGE_PRECISION.add(interestRate)).div(PERCENTAGE_PRECISION);
2312   }
2313 
2314   /*
2315     Gets the interest rate for a Cbond given its relevant properties.
2316   */
2317   function getCbondInterestRateNow(
2318     address liqAddr,
2319     uint256 duration,
2320     uint256 luckyExtra,
2321     bool quarterly) public view returns(uint256){
2322 
2323     return getCbondInterestRate(
2324       duration,
2325       liqTokenTotalsByDay[liqAddr][lastDayTokenSupplyUpdated[liqAddr]],
2326       liqTokenTotalsByDay[liqAddr][getDay(block.timestamp)],
2327       syncSupplyByDay[lastDaySyncSupplyUpdated],
2328       syncSupplyByDay[getDay(block.timestamp)],
2329       interestRateByDay[lastDaySyncSupplyUpdated],
2330       luckyExtra,
2331       quarterly);
2332   }
2333 
2334   /*
2335     This returns the Cbond interest rate. Divide by PERCENTAGE_PRECISION to get the real rate.
2336   */
2337   function getCbondInterestRate(
2338     uint256 duration,
2339     uint256 liqTotalLast,
2340     uint256 liqTotalCurrent,
2341     uint256 syncTotalLast,
2342     uint256 syncTotalCurrent,
2343     uint256 lastBaseInterestRate,
2344     uint256 luckyExtra,
2345     bool quarterly) public view returns(uint256){
2346 
2347     uint256 liquidityPairIncentiveRate=getLiquidityPairIncentiveRate(liqTotalCurrent,liqTotalLast);
2348     uint256 baseInterestRate=getBaseInterestRate(lastBaseInterestRate,syncTotalCurrent,syncTotalLast);
2349     if(!quarterly){
2350       return getDurationRate(duration,baseInterestRate.add(liquidityPairIncentiveRate).add(luckyExtra));
2351     }
2352     else{
2353       uint numYears=duration.div(YEAR_LENGTH);
2354       require(numYears>0,"invalid duration");//Quarterly Cbonds must have a duration 1 year or longer.
2355       uint numQuarters=duration.div(QUARTER_LENGTH);
2356       uint termModifier=RISK_FACTOR.mul(numYears.mul(4).sub(1));
2357       //Interest rate is the sum of base interest rate, liquidity incentive rate, and risk/term based modifier. Because this is the Quarterly Cbond rate, we also divide by the number of quarters in the Cbond, to set the recorded rate to the amount withdrawable per quarter.
2358       return baseInterestRate.add(liquidityPairIncentiveRate).add(luckyExtra).add(termModifier);
2359     }
2360   }
2361 
2362   /*
2363     This returns the Lucky Extra bonus of the given Cbond. This is based on whether the id of the Cbond ends in two or three 7's, and whether admins have disabled this feature.
2364   */
2365   function getLuckyExtra(uint256 tokenId) public view returns(uint256){
2366     if(luckyEnabled){
2367       if(tokenId.mod(100)==77){
2368         return LUCKY_EXTRAS[0];
2369       }
2370       if(tokenId.mod(1000)==777){
2371         return LUCKY_EXTRAS[1];
2372       }
2373     }
2374     return 0;
2375   }
2376 
2377   /*
2378     New implementation of duration modifier. Approximation of intended formula.
2379   */
2380   function getDurationRate(uint duration, uint baseInterestRate) public view returns(uint){
2381         require(duration==TERM_DURATIONS[0] || duration==TERM_DURATIONS[1] || duration==TERM_DURATIONS[2] || duration==TERM_DURATIONS[3] || duration==TERM_DURATIONS[4],"Invalid CBOND term length provided");
2382 
2383         if(duration==TERM_DURATIONS[0]){
2384           return baseInterestRate;
2385         }
2386         if(duration==TERM_DURATIONS[1]){
2387             uint preExponential = PERCENTAGE_PRECISION.add(baseInterestRate).add(RISK_FACTOR);
2388             uint exponential = preExponential.mul(preExponential).div(PERCENTAGE_PRECISION);
2389             return exponential.sub(PERCENTAGE_PRECISION);
2390         }
2391         if(duration==TERM_DURATIONS[2]){//1 year
2392             uint preExponential = PERCENTAGE_PRECISION.add(baseInterestRate).add(RISK_FACTOR.mul(3));
2393             uint exponential = preExponential.mul(preExponential).div(PERCENTAGE_PRECISION);
2394             for (uint8 i=0;i<2;i++) {
2395                 exponential = exponential.mul(preExponential).div(PERCENTAGE_PRECISION);
2396             }
2397             return exponential.sub(PERCENTAGE_PRECISION);
2398         }
2399         if(duration==TERM_DURATIONS[3]){//2 years
2400             uint preExponential = PERCENTAGE_PRECISION.add(baseInterestRate).add(RISK_FACTOR.mul(7));
2401             uint exponential = preExponential.mul(preExponential).div(PERCENTAGE_PRECISION);
2402             for (uint8 i=0;i<6;i++) {
2403                 exponential = exponential.mul(preExponential).div(PERCENTAGE_PRECISION);
2404             }
2405             return exponential.sub(PERCENTAGE_PRECISION);
2406         }
2407         if(duration==TERM_DURATIONS[4]){//3 years
2408             uint preExponential = PERCENTAGE_PRECISION.add(baseInterestRate).add(RISK_FACTOR.mul(11));
2409             uint exponential = preExponential.mul(preExponential).div(PERCENTAGE_PRECISION);
2410             for (uint8 i=0;i<10;i++) {
2411                 exponential = exponential.mul(preExponential).div(PERCENTAGE_PRECISION);
2412             }
2413             return exponential.sub(PERCENTAGE_PRECISION);
2414         }
2415     }
2416 
2417   /*
2418     Returns the liquidity pair incentive rate. To use, multiply by a value then divide result by PERCENTAGE_PRECISION
2419   */
2420   function getLiquidityPairIncentiveRate(uint256 totalToday,uint256 totalYesterday) public view returns(uint256){
2421     //instead of reverting due to division by zero, if tokens in this contract go to zero give the max bonus
2422     if(totalToday==0){
2423       return INCENTIVE_MAX_PERCENT;
2424     }
2425     return Math.min(INCENTIVE_MAX_PERCENT,INCENTIVE_MAX_PERCENT.mul(totalYesterday).div(totalToday));
2426   }
2427 
2428   /*
2429     Returns the base interest rate, derived from the previous day interest rate, the current Sync total supply, and the previous day Sync total supply.
2430   */
2431   function getBaseInterestRate(uint256 lastdayInterestRate,uint256 syncSupplyToday,uint256 syncSupplyLast) public pure returns(uint256){
2432     return Math.min(MAXIMUM_BASE_INTEREST_RATE,Math.max(MINIMUM_BASE_INTEREST_RATE,lastdayInterestRate.mul(syncSupplyToday).div(syncSupplyLast)));
2433   }
2434 
2435   /*
2436     Returns the interest rate a Cbond with the given parameters would end up with if it were created.
2437   */
2438   function getCbondInterestRateIfUpdated(address liqAddr,uint256 duration,uint256 luckyExtra,bool quarterly) public view returns(uint256){
2439     (uint256 lastSupply,uint256 currentSupply,uint256 lastTSupply,uint256 currentTSupply,uint256 lastInterestRate)=getSuppliesIfUpdated(liqAddr);
2440     return getCbondInterestRate(duration,lastTSupply,currentTSupply,lastSupply,currentSupply,lastInterestRate,luckyExtra,quarterly);
2441   }
2442 
2443   /*
2444     Convenience function for frontend use which returns current and previous recorded Sync total supply, and tokens held for the provided token.
2445   */
2446   function getSuppliesNow(address tokenAddr) public view returns(uint256 lastSupply,uint256 currentSupply,uint256 lastTSupply,uint256 currentTSupply,uint256 lastInterestRate){
2447     currentSupply=syncSupplyByDay[currentDaySyncSupplyUpdated];
2448     lastSupply=syncSupplyByDay[lastDaySyncSupplyUpdated];
2449     lastInterestRate=interestRateByDay[lastDaySyncSupplyUpdated];
2450     currentTSupply=liqTokenTotalsByDay[tokenAddr][currentDayTokenSupplyUpdated[tokenAddr]];
2451     lastTSupply=liqTokenTotalsByDay[tokenAddr][lastDayTokenSupplyUpdated[tokenAddr]];
2452   }
2453 
2454   /*
2455     Gets what the Sync and liquidity token current and last supplies would become, if updated now. Intended for frontend use.
2456   */
2457   function getSuppliesIfUpdated(address tokenAddr) public view returns(uint256 lastSupply,uint256 currentSupply,uint256 lastTSupply,uint256 currentTSupply,uint256 lastInterestRate){
2458     uint256 day=getDay(block.timestamp);
2459     if(liqTokenTotalsByDay[tokenAddr][getDay(block.timestamp)]==0){
2460       currentTSupply=IERC20(tokenAddr).balanceOf(address(this));
2461       lastTSupply=liqTokenTotalsByDay[tokenAddr][currentDayTokenSupplyUpdated[tokenAddr]];
2462     }
2463     else{
2464       currentTSupply=liqTokenTotalsByDay[tokenAddr][currentDayTokenSupplyUpdated[tokenAddr]];
2465       lastTSupply=liqTokenTotalsByDay[tokenAddr][lastDayTokenSupplyUpdated[tokenAddr]];
2466     }
2467     if(syncSupplyByDay[day]==0){
2468       currentSupply=syncToken.totalSupply();
2469       lastSupply=syncSupplyByDay[currentDaySyncSupplyUpdated];
2470       //TODO: interest rate
2471       lastInterestRate=interestRateByDay[currentDaySyncSupplyUpdated];
2472     }
2473     else{
2474       currentSupply=syncSupplyByDay[currentDaySyncSupplyUpdated];
2475       lastSupply=syncSupplyByDay[lastDaySyncSupplyUpdated];
2476       lastInterestRate=interestRateByDay[lastDaySyncSupplyUpdated];
2477     }
2478   }
2479 
2480   /*
2481     Function for recording the Sync total supply and base interest rate by day. Records only at the first time it is called in a given day (see getDay).
2482   */
2483   function recordSyncSupply() public{
2484     if(syncSupplyByDay[getDay(block.timestamp)]==0){
2485       uint256 day=getDay(block.timestamp);
2486       syncSupplyByDay[day]=syncToken.totalSupply();
2487       lastDaySyncSupplyUpdated=currentDaySyncSupplyUpdated;
2488       currentDaySyncSupplyUpdated=day;
2489 
2490       //interest rate
2491       interestRateByDay[day]=getBaseInterestRate(interestRateByDay[lastDaySyncSupplyUpdated],syncSupplyByDay[day],syncSupplyByDay[lastDaySyncSupplyUpdated]);
2492     }
2493   }
2494 
2495   /*
2496     Records the current amount of the given token held by this contract for the current day. Like recordSyncSupply, only records the first time it is called in a day.
2497   */
2498   function recordTokenSupply(address tokenAddr) private{
2499     if(liqTokenTotalsByDay[tokenAddr][getDay(block.timestamp)]==0){
2500       uint256 day=getDay(block.timestamp);
2501       liqTokenTotalsByDay[tokenAddr][day]=IERC20(tokenAddr).balanceOf(address(this));
2502       lastDayTokenSupplyUpdated[tokenAddr]=currentDayTokenSupplyUpdated[tokenAddr];
2503       currentDayTokenSupplyUpdated[tokenAddr]=day;
2504     }
2505   }
2506 
2507   /*
2508     Gets the current day since the contract began. Starts at 1.
2509   */
2510   function getDay(uint256 timestamp) public view returns(uint256){
2511     return timestamp.sub(STARTING_TIME).div(24 hours).add(1);
2512   }
2513 
2514   /*
2515     Gets the current day since the contract began, at the current block time.
2516   */
2517   function getDayNow() public view returns(uint256){
2518     return getDay(block.timestamp);
2519   }
2520 }