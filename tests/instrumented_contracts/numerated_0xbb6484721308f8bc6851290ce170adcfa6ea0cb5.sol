1 /**
2  *Submitted for verification at Etherscan.io on 2022-06-15
3 */
4 
5 // SPDX-License-Identifier: MIT LICENSE
6 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
7 
8 
9 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
10 
11 pragma solidity ^0.8.0;
12 
13 /**
14  * @dev Interface of the ERC20 standard as defined in the EIP.
15  */
16 interface IERC20 {
17     /**
18      * @dev Emitted when `value` tokens are moved from one account (`from`) to
19      * another (`to`).
20      *
21      * Note that `value` may be zero.
22      */
23     event Transfer(address indexed from, address indexed to, uint256 value);
24 
25     /**
26      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
27      * a call to {approve}. `value` is the new allowance.
28      */
29     event Approval(address indexed owner, address indexed spender, uint256 value);
30 
31     /**
32      * @dev Returns the amount of tokens in existence.
33      */
34     function totalSupply() external view returns (uint256);
35 
36     /**
37      * @dev Returns the amount of tokens owned by `account`.
38      */
39     function balanceOf(address account) external view returns (uint256);
40 
41     /**
42      * @dev Moves `amount` tokens from the caller's account to `to`.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * Emits a {Transfer} event.
47      */
48     function transfer(address to, uint256 amount) external returns (bool);
49 
50     /**
51      * @dev Returns the remaining number of tokens that `spender` will be
52      * allowed to spend on behalf of `owner` through {transferFrom}. This is
53      * zero by default.
54      *
55      * This value changes when {approve} or {transferFrom} are called.
56      */
57     function allowance(address owner, address spender) external view returns (uint256);
58 
59     /**
60      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * IMPORTANT: Beware that changing an allowance with this method brings the risk
65      * that someone may use both the old and the new allowance by unfortunate
66      * transaction ordering. One possible solution to mitigate this race
67      * condition is to first reduce the spender's allowance to 0 and set the
68      * desired value afterwards:
69      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
70      *
71      * Emits an {Approval} event.
72      */
73     function approve(address spender, uint256 amount) external returns (bool);
74 
75     /**
76      * @dev Moves `amount` tokens from `from` to `to` using the
77      * allowance mechanism. `amount` is then deducted from the caller's
78      * allowance.
79      *
80      * Returns a boolean value indicating whether the operation succeeded.
81      *
82      * Emits a {Transfer} event.
83      */
84     function transferFrom(
85         address from,
86         address to,
87         uint256 amount
88     ) external returns (bool);
89 }
90 
91 // File: @openzeppelin/contracts/utils/Context.sol
92 
93 
94 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
95 
96 pragma solidity ^0.8.0;
97 
98 /**
99  * @dev Provides information about the current execution context, including the
100  * sender of the transaction and its data. While these are generally available
101  * via msg.sender and msg.data, they should not be accessed in such a direct
102  * manner, since when dealing with meta-transactions the account sending and
103  * paying for execution may not be the actual sender (as far as an application
104  * is concerned).
105  *
106  * This contract is only required for intermediate, library-like contracts.
107  */
108 abstract contract Context {
109     function _msgSender() internal view virtual returns (address) {
110         return msg.sender;
111     }
112 
113     function _msgData() internal view virtual returns (bytes calldata) {
114         return msg.data;
115     }
116 }
117 
118 // File: @openzeppelin/contracts/access/Ownable.sol
119 
120 
121 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
122 
123 pragma solidity ^0.8.0;
124 
125 
126 /**
127  * @dev Contract module which provides a basic access control mechanism, where
128  * there is an account (an owner) that can be granted exclusive access to
129  * specific functions.
130  *
131  * By default, the owner account will be the one that deploys the contract. This
132  * can later be changed with {transferOwnership}.
133  *
134  * This module is used through inheritance. It will make available the modifier
135  * `onlyOwner`, which can be applied to your functions to restrict their use to
136  * the owner.
137  */
138 abstract contract Ownable is Context {
139     address private _owner;
140 
141     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
142 
143     /**
144      * @dev Initializes the contract setting the deployer as the initial owner.
145      */
146     constructor() {
147         _transferOwnership(_msgSender());
148     }
149 
150     /**
151      * @dev Returns the address of the current owner.
152      */
153     function owner() public view virtual returns (address) {
154         return _owner;
155     }
156 
157     /**
158      * @dev Throws if called by any account other than the owner.
159      */
160     modifier onlyOwner() {
161         require(owner() == _msgSender(), "Ownable: caller is not the owner");
162         _;
163     }
164 
165     /**
166      * @dev Leaves the contract without owner. It will not be possible to call
167      * `onlyOwner` functions anymore. Can only be called by the current owner.
168      *
169      * NOTE: Renouncing ownership will leave the contract without an owner,
170      * thereby removing any functionality that is only available to the owner.
171      */
172     function renounceOwnership() public virtual onlyOwner {
173         _transferOwnership(address(0));
174     }
175 
176     /**
177      * @dev Transfers ownership of the contract to a new account (`newOwner`).
178      * Can only be called by the current owner.
179      */
180     function transferOwnership(address newOwner) public virtual onlyOwner {
181         require(newOwner != address(0), "Ownable: new owner is the zero address");
182         _transferOwnership(newOwner);
183     }
184 
185     /**
186      * @dev Transfers ownership of the contract to a new account (`newOwner`).
187      * Internal function without access restriction.
188      */
189     function _transferOwnership(address newOwner) internal virtual {
190         address oldOwner = _owner;
191         _owner = newOwner;
192         emit OwnershipTransferred(oldOwner, newOwner);
193     }
194 }
195 
196 // File: contracts/TESTFROMHELL.sol
197 
198 
199 
200 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
201 
202 pragma solidity ^0.8.0;
203 
204 
205 
206 /**
207 
208  * @dev Interface of the ERC165 standard, as defined in the
209 
210  * https://eips.ethereum.org/EIPS/eip-165[EIP].
211 
212  *
213 
214  * Implementers can declare support of contract interfaces, which can then be
215 
216  * queried by others ({ERC165Checker}).
217 
218  *
219 
220  * For an implementation, see {ERC165}.
221 
222  */
223 
224 interface IERC165 {
225 
226     /**
227 
228      * @dev Returns true if this contract implements the interface defined by
229 
230      * `interfaceId`. See the corresponding
231 
232      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
233 
234      * to learn more about how these ids are created.
235 
236      *
237 
238      * This function call must use less than 30 000 gas.
239 
240      */
241 
242     function supportsInterface(bytes4 interfaceId) external view returns (bool);
243 
244 }
245 
246 
247 
248 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
249 
250 pragma solidity ^0.8.0;
251 
252 
253 
254 /**
255 
256  * @dev Required interface of an ERC721 compliant contract.
257 
258  */
259 
260 interface IERC721 is IERC165 {
261 
262     /**
263 
264      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
265 
266      */
267 
268     event Transfer(
269 
270         address indexed from,
271 
272         address indexed to,
273 
274         uint256 indexed tokenId
275 
276     );
277 
278 
279 
280     /**
281 
282      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
283 
284      */
285 
286     event Approval(
287 
288         address indexed owner,
289 
290         address indexed approved,
291 
292         uint256 indexed tokenId
293 
294     );
295 
296 
297 
298     /**
299 
300      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
301 
302      */
303 
304     event ApprovalForAll(
305 
306         address indexed owner,
307 
308         address indexed operator,
309 
310         bool approved
311 
312     );
313 
314 
315 
316     /**
317 
318      * @dev Returns the number of tokens in ``owner``'s account.
319 
320      */
321 
322     function balanceOf(address owner) external view returns (uint256 balance);
323 
324 
325 
326     /**
327 
328      * @dev Returns the owner of the `tokenId` token.
329 
330      *
331 
332      * Requirements:
333 
334      *
335 
336      * - `tokenId` must exist.
337 
338      */
339 
340     function ownerOf(uint256 tokenId) external view returns (address owner);
341 
342 
343 
344     /**
345 
346      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
347 
348      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
349 
350      *
351 
352      * Requirements:
353 
354      *
355 
356      * - `from` cannot be the zero address.
357 
358      * - `to` cannot be the zero address.
359 
360      * - `tokenId` token must exist and be owned by `from`.
361 
362      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
363 
364      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
365 
366      *
367 
368      * Emits a {Transfer} event.
369 
370      */
371 
372     function safeTransferFrom(
373 
374         address from,
375 
376         address to,
377 
378         uint256 tokenId
379 
380     ) external;
381 
382 
383 
384     /**
385 
386      * @dev Transfers `tokenId` token from `from` to `to`.
387 
388      *
389 
390      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
391 
392      *
393 
394      * Requirements:
395 
396      *
397 
398      * - `from` cannot be the zero address.
399 
400      * - `to` cannot be the zero address.
401 
402      * - `tokenId` token must be owned by `from`.
403 
404      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
405 
406      *
407 
408      * Emits a {Transfer} event.
409 
410      */
411 
412     function transferFrom(
413 
414         address from,
415 
416         address to,
417 
418         uint256 tokenId
419 
420     ) external;
421 
422 
423 
424     /**
425 
426      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
427 
428      * The approval is cleared when the token is transferred.
429 
430      *
431 
432      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
433 
434      *
435 
436      * Requirements:
437 
438      *
439 
440      * - The caller must own the token or be an approved operator.
441 
442      * - `tokenId` must exist.
443 
444      *
445 
446      * Emits an {Approval} event.
447 
448      */
449 
450     function approve(address to, uint256 tokenId) external;
451 
452 
453 
454     /**
455 
456      * @dev Returns the account approved for `tokenId` token.
457 
458      *
459 
460      * Requirements:
461 
462      *
463 
464      * - `tokenId` must exist.
465 
466      */
467 
468     function getApproved(uint256 tokenId)
469 
470         external
471 
472         view
473 
474         returns (address operator);
475 
476 
477 
478     /**
479 
480      * @dev Approve or remove `operator` as an operator for the caller.
481 
482      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
483 
484      *
485 
486      * Requirements:
487 
488      *
489 
490      * - The `operator` cannot be the caller.
491 
492      *
493 
494      * Emits an {ApprovalForAll} event.
495 
496      */
497 
498     function setApprovalForAll(address operator, bool _approved) external;
499 
500 
501 
502     /**
503 
504      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
505 
506      *
507 
508      * See {setApprovalForAll}
509 
510      */
511 
512     function isApprovedForAll(address owner, address operator)
513 
514         external
515 
516         view
517 
518         returns (bool);
519 
520 
521 
522     /**
523 
524      * @dev Safely transfers `tokenId` token from `from` to `to`.
525 
526      *
527 
528      * Requirements:
529 
530      *
531 
532      * - `from` cannot be the zero address.
533 
534      * - `to` cannot be the zero address.
535 
536      * - `tokenId` token must exist and be owned by `from`.
537 
538      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
539 
540      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
541 
542      *
543 
544      * Emits a {Transfer} event.
545 
546      */
547 
548     function safeTransferFrom(
549 
550         address from,
551 
552         address to,
553 
554         uint256 tokenId,
555 
556         bytes calldata data
557 
558     ) external;
559 
560 }
561 
562 
563 
564 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
565 
566 
567 
568 pragma solidity ^0.8.0;
569 
570 
571 
572 /**
573 
574  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
575 
576  * @dev See https://eips.ethereum.org/EIPS/eip-721
577 
578  */
579 
580 interface IERC721Enumerable is IERC721 {
581 
582     /**
583 
584      * @dev Returns the total amount of tokens stored by the contract.
585 
586      */
587 
588     function totalSupply() external view returns (uint256);
589 
590 
591 
592     /**
593 
594      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
595 
596      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
597 
598      */
599 
600     function tokenOfOwnerByIndex(address owner, uint256 index)
601 
602         external
603 
604         view
605 
606         returns (uint256 tokenId);
607 
608 
609 
610     /**
611 
612      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
613 
614      * Use along with {totalSupply} to enumerate all tokens.
615 
616      */
617 
618     function tokenByIndex(uint256 index) external view returns (uint256);
619 
620 }
621 
622 
623 
624 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
625 
626 
627 
628 pragma solidity ^0.8.0;
629 
630 
631 
632 /**
633 
634  * @dev Implementation of the {IERC165} interface.
635 
636  *
637 
638  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
639 
640  * for the additional interface id that will be supported. For example:
641 
642  *
643 
644  * ```solidity
645 
646  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
647 
648  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
649 
650  * }
651 
652  * ```
653 
654  *
655 
656  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
657 
658  */
659 
660 abstract contract ERC165 is IERC165 {
661 
662     /**
663 
664      * @dev See {IERC165-supportsInterface}.
665 
666      */
667 
668     function supportsInterface(bytes4 interfaceId)
669 
670         public
671 
672         view
673 
674         virtual
675 
676         override
677 
678         returns (bool)
679 
680     {
681 
682         return interfaceId == type(IERC165).interfaceId;
683 
684     }
685 
686 }
687 
688 
689 
690 // File: @openzeppelin/contracts/utils/Strings.sol
691 
692 
693 
694 pragma solidity ^0.8.0;
695 
696 
697 
698 /**
699 
700  * @dev String operations.
701 
702  */
703 
704 library Strings {
705 
706     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
707 
708 
709 
710     /**
711 
712      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
713 
714      */
715 
716     function toString(uint256 value) internal pure returns (string memory) {
717 
718         // Inspired by OraclizeAPI's implementation - MIT licence
719 
720         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
721 
722 
723 
724         if (value == 0) {
725 
726             return "0";
727 
728         }
729 
730         uint256 temp = value;
731 
732         uint256 digits;
733 
734         while (temp != 0) {
735 
736             digits++;
737 
738             temp /= 10;
739 
740         }
741 
742         bytes memory buffer = new bytes(digits);
743 
744         while (value != 0) {
745 
746             digits -= 1;
747 
748             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
749 
750             value /= 10;
751 
752         }
753 
754         return string(buffer);
755 
756     }
757 
758 
759 
760     /**
761 
762      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
763 
764      */
765 
766     function toHexString(uint256 value) internal pure returns (string memory) {
767 
768         if (value == 0) {
769 
770             return "0x00";
771 
772         }
773 
774         uint256 temp = value;
775 
776         uint256 length = 0;
777 
778         while (temp != 0) {
779 
780             length++;
781 
782             temp >>= 8;
783 
784         }
785 
786         return toHexString(value, length);
787 
788     }
789 
790 
791 
792     /**
793 
794      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
795 
796      */
797 
798     function toHexString(uint256 value, uint256 length)
799 
800         internal
801 
802         pure
803 
804         returns (string memory)
805 
806     {
807 
808         bytes memory buffer = new bytes(2 * length + 2);
809 
810         buffer[0] = "0";
811 
812         buffer[1] = "x";
813 
814         for (uint256 i = 2 * length + 1; i > 1; --i) {
815 
816             buffer[i] = _HEX_SYMBOLS[value & 0xf];
817 
818             value >>= 4;
819 
820         }
821 
822         require(value == 0, "Strings: hex length insufficient");
823 
824         return string(buffer);
825 
826     }
827 
828 }
829 
830 
831 
832 // File: @openzeppelin/contracts/utils/Address.sol
833 
834 
835 
836 pragma solidity ^0.8.0;
837 
838 
839 
840 /**
841 
842  * @dev Collection of functions related to the address type
843 
844  */
845 
846 library Address {
847 
848     /**
849 
850      * @dev Returns true if `account` is a contract.
851 
852      *
853 
854      * [IMPORTANT]
855 
856      * ====
857 
858      * It is unsafe to assume that an address for which this function returns
859 
860      * false is an externally-owned account (EOA) and not a contract.
861 
862      *
863 
864      * Among others, `isContract` will return false for the following
865 
866      * types of addresses:
867 
868      *
869 
870      *  - an externally-owned account
871 
872      *  - a contract in construction
873 
874      *  - an address where a contract will be created
875 
876      *  - an address where a contract lived, but was destroyed
877 
878      * ====
879 
880      */
881 
882     function isContract(address account) internal view returns (bool) {
883 
884         // This method relies on extcodesize, which returns 0 for contracts in
885 
886         // construction, since the code is only stored at the end of the
887 
888         // constructor execution.
889 
890 
891 
892         uint256 size;
893 
894         assembly {
895 
896             size := extcodesize(account)
897 
898         }
899 
900         return size > 0;
901 
902     }
903 
904 
905 
906     /**
907 
908      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
909 
910      * `recipient`, forwarding all available gas and reverting on errors.
911 
912      *
913 
914      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
915 
916      * of certain opcodes, possibly making contracts go over the 2300 gas limit
917 
918      * imposed by `transfer`, making them unable to receive funds via
919 
920      * `transfer`. {sendValue} removes this limitation.
921 
922      *
923 
924      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
925 
926      *
927 
928      * IMPORTANT: because control is transferred to `recipient`, care must be
929 
930      * taken to not create reentrancy vulnerabilities. Consider using
931 
932      * {ReentrancyGuard} or the
933 
934      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
935 
936      */
937 
938     function sendValue(address payable recipient, uint256 amount) internal {
939 
940         require(
941 
942             address(this).balance >= amount,
943 
944             "Address: insufficient balance"
945 
946         );
947 
948 
949 
950         (bool success, ) = recipient.call{value: amount}("");
951 
952         require(
953 
954             success,
955 
956             "Address: unable to send value, recipient may have reverted"
957 
958         );
959 
960     }
961 
962 
963 
964     /**
965 
966      * @dev Performs a Solidity function call using a low level `call`. A
967 
968      * plain `call` is an unsafe replacement for a function call: use this
969 
970      * function instead.
971 
972      *
973 
974      * If `target` reverts with a revert reason, it is bubbled up by this
975 
976      * function (like regular Solidity function calls).
977 
978      *
979 
980      * Returns the raw returned data. To convert to the expected return value,
981 
982      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
983 
984      *
985 
986      * Requirements:
987 
988      *
989 
990      * - `target` must be a contract.
991 
992      * - calling `target` with `data` must not revert.
993 
994      *
995 
996      * _Available since v3.1._
997 
998      */
999 
1000     function functionCall(address target, bytes memory data)
1001 
1002         internal
1003 
1004         returns (bytes memory)
1005 
1006     {
1007 
1008         return functionCall(target, data, "Address: low-level call failed");
1009 
1010     }
1011 
1012 
1013 
1014     /**
1015 
1016      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1017 
1018      * `errorMessage` as a fallback revert reason when `target` reverts.
1019 
1020      *
1021 
1022      * _Available since v3.1._
1023 
1024      */
1025 
1026     function functionCall(
1027 
1028         address target,
1029 
1030         bytes memory data,
1031 
1032         string memory errorMessage
1033 
1034     ) internal returns (bytes memory) {
1035 
1036         return functionCallWithValue(target, data, 0, errorMessage);
1037 
1038     }
1039 
1040 
1041 
1042     /**
1043 
1044      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1045 
1046      * but also transferring `value` wei to `target`.
1047 
1048      *
1049 
1050      * Requirements:
1051 
1052      *
1053 
1054      * - the calling contract must have an ETH balance of at least `value`.
1055 
1056      * - the called Solidity function must be `payable`.
1057 
1058      *
1059 
1060      * _Available since v3.1._
1061 
1062      */
1063 
1064     function functionCallWithValue(
1065 
1066         address target,
1067 
1068         bytes memory data,
1069 
1070         uint256 value
1071 
1072     ) internal returns (bytes memory) {
1073 
1074         return
1075 
1076             functionCallWithValue(
1077 
1078                 target,
1079 
1080                 data,
1081 
1082                 value,
1083 
1084                 "Address: low-level call with value failed"
1085 
1086             );
1087 
1088     }
1089 
1090 
1091 
1092     /**
1093 
1094      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1095 
1096      * with `errorMessage` as a fallback revert reason when `target` reverts.
1097 
1098      *
1099 
1100      * _Available since v3.1._
1101 
1102      */
1103 
1104     function functionCallWithValue(
1105 
1106         address target,
1107 
1108         bytes memory data,
1109 
1110         uint256 value,
1111 
1112         string memory errorMessage
1113 
1114     ) internal returns (bytes memory) {
1115 
1116         require(
1117 
1118             address(this).balance >= value,
1119 
1120             "Address: insufficient balance for call"
1121 
1122         );
1123 
1124         require(isContract(target), "Address: call to non-contract");
1125 
1126 
1127 
1128         (bool success, bytes memory returndata) = target.call{value: value}(
1129 
1130             data
1131 
1132         );
1133 
1134         return verifyCallResult(success, returndata, errorMessage);
1135 
1136     }
1137 
1138 
1139 
1140     /**
1141 
1142      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1143 
1144      * but performing a static call.
1145 
1146      *
1147 
1148      * _Available since v3.3._
1149 
1150      */
1151 
1152     function functionStaticCall(address target, bytes memory data)
1153 
1154         internal
1155 
1156         view
1157 
1158         returns (bytes memory)
1159 
1160     {
1161 
1162         return
1163 
1164             functionStaticCall(
1165 
1166                 target,
1167 
1168                 data,
1169 
1170                 "Address: low-level static call failed"
1171 
1172             );
1173 
1174     }
1175 
1176 
1177 
1178     /**
1179 
1180      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1181 
1182      * but performing a static call.
1183 
1184      *
1185 
1186      * _Available since v3.3._
1187 
1188      */
1189 
1190     function functionStaticCall(
1191 
1192         address target,
1193 
1194         bytes memory data,
1195 
1196         string memory errorMessage
1197 
1198     ) internal view returns (bytes memory) {
1199 
1200         require(isContract(target), "Address: static call to non-contract");
1201 
1202 
1203 
1204         (bool success, bytes memory returndata) = target.staticcall(data);
1205 
1206         return verifyCallResult(success, returndata, errorMessage);
1207 
1208     }
1209 
1210 
1211 
1212     /**
1213 
1214      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1215 
1216      * but performing a delegate call.
1217 
1218      *
1219 
1220      * _Available since v3.4._
1221 
1222      */
1223 
1224     function functionDelegateCall(address target, bytes memory data)
1225 
1226         internal
1227 
1228         returns (bytes memory)
1229 
1230     {
1231 
1232         return
1233 
1234             functionDelegateCall(
1235 
1236                 target,
1237 
1238                 data,
1239 
1240                 "Address: low-level delegate call failed"
1241 
1242             );
1243 
1244     }
1245 
1246 
1247 
1248     /**
1249 
1250      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1251 
1252      * but performing a delegate call.
1253 
1254      *
1255 
1256      * _Available since v3.4._
1257 
1258      */
1259 
1260     function functionDelegateCall(
1261 
1262         address target,
1263 
1264         bytes memory data,
1265 
1266         string memory errorMessage
1267 
1268     ) internal returns (bytes memory) {
1269 
1270         require(isContract(target), "Address: delegate call to non-contract");
1271 
1272 
1273 
1274         (bool success, bytes memory returndata) = target.delegatecall(data);
1275 
1276         return verifyCallResult(success, returndata, errorMessage);
1277 
1278     }
1279 
1280 
1281 
1282     /**
1283 
1284      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1285 
1286      * revert reason using the provided one.
1287 
1288      *
1289 
1290      * _Available since v4.3._
1291 
1292      */
1293 
1294     function verifyCallResult(
1295 
1296         bool success,
1297 
1298         bytes memory returndata,
1299 
1300         string memory errorMessage
1301 
1302     ) internal pure returns (bytes memory) {
1303 
1304         if (success) {
1305 
1306             return returndata;
1307 
1308         } else {
1309 
1310             // Look for revert reason and bubble it up if present
1311 
1312             if (returndata.length > 0) {
1313 
1314                 // The easiest way to bubble the revert reason is using memory via assembly
1315 
1316 
1317 
1318                 assembly {
1319 
1320                     let returndata_size := mload(returndata)
1321 
1322                     revert(add(32, returndata), returndata_size)
1323 
1324                 }
1325 
1326             } else {
1327 
1328                 revert(errorMessage);
1329 
1330             }
1331 
1332         }
1333 
1334     }
1335 
1336 }
1337 
1338 
1339 
1340 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1341 
1342 
1343 
1344 pragma solidity ^0.8.0;
1345 
1346 
1347 
1348 /**
1349 
1350  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1351 
1352  * @dev See https://eips.ethereum.org/EIPS/eip-721
1353 
1354  */
1355 
1356 interface IERC721Metadata is IERC721 {
1357 
1358     /**
1359 
1360      * @dev Returns the token collection name.
1361 
1362      */
1363 
1364     function name() external view returns (string memory);
1365 
1366 
1367 
1368     /**
1369 
1370      * @dev Returns the token collection symbol.
1371 
1372      */
1373 
1374     function symbol() external view returns (string memory);
1375 
1376 
1377 
1378     /**
1379 
1380      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1381 
1382      */
1383 
1384     function tokenURI(uint256 tokenId) external view returns (string memory);
1385 
1386 }
1387 
1388 
1389 
1390 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1391 
1392 
1393 
1394 pragma solidity ^0.8.0;
1395 
1396 
1397 
1398 /**
1399 
1400  * @title ERC721 token receiver interface
1401 
1402  * @dev Interface for any contract that wants to support safeTransfers
1403 
1404  * from ERC721 asset contracts.
1405 
1406  */
1407 
1408 interface IERC721Receiver {
1409 
1410     /**
1411 
1412      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1413 
1414      * by `operator` from `from`, this function is called.
1415 
1416      *
1417 
1418      * It must return its Solidity selector to confirm the token transfer.
1419 
1420      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1421 
1422      *
1423 
1424      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1425 
1426      */
1427 
1428     function onERC721Received(
1429 
1430         address operator,
1431 
1432         address from,
1433 
1434         uint256 tokenId,
1435 
1436         bytes calldata data
1437 
1438     ) external returns (bytes4);
1439 
1440 }
1441 
1442 
1443 
1444 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1445 
1446 pragma solidity ^0.8.0;
1447 
1448 
1449 
1450 
1451 /**
1452 
1453  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1454 
1455  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1456 
1457  * {ERC721Enumerable}.
1458 
1459  */
1460 
1461 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1462 
1463     using Address for address;
1464 
1465     using Strings for uint256;
1466 
1467 
1468 
1469     // Token name
1470 
1471     string private _name;
1472 
1473 
1474 
1475     // Token symbol
1476 
1477     string private _symbol;
1478 
1479 
1480 
1481     // Mapping from token ID to owner address
1482 
1483     mapping(uint256 => address) private _owners;
1484 
1485 
1486 
1487     // Mapping owner address to token count
1488 
1489     mapping(address => uint256) private _balances;
1490 
1491 
1492 
1493     // Mapping from token ID to approved address
1494 
1495     mapping(uint256 => address) private _tokenApprovals;
1496 
1497 
1498 
1499     // Mapping from owner to operator approvals
1500 
1501     mapping(address => mapping(address => bool)) private _operatorApprovals;
1502 
1503 
1504 
1505     /**
1506 
1507      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1508 
1509      */
1510 
1511     constructor(string memory name_, string memory symbol_) {
1512 
1513         _name = name_;
1514 
1515         _symbol = symbol_;
1516 
1517     }
1518 
1519 
1520 
1521     /**
1522 
1523      * @dev See {IERC165-supportsInterface}.
1524 
1525      */
1526 
1527     function supportsInterface(bytes4 interfaceId)
1528 
1529         public
1530 
1531         view
1532 
1533         virtual
1534 
1535         override(ERC165, IERC165)
1536 
1537         returns (bool)
1538 
1539     {
1540 
1541         return
1542 
1543             interfaceId == type(IERC721).interfaceId ||
1544 
1545             interfaceId == type(IERC721Metadata).interfaceId ||
1546 
1547             super.supportsInterface(interfaceId);
1548 
1549     }
1550 
1551 
1552 
1553     /**
1554 
1555      * @dev See {IERC721-balanceOf}.
1556 
1557      */
1558 
1559     function balanceOf(address owner)
1560 
1561         public
1562 
1563         view
1564 
1565         virtual
1566 
1567         override
1568 
1569         returns (uint256)
1570 
1571     {
1572 
1573         require(
1574 
1575             owner != address(0),
1576 
1577             "ERC721: balance query for the zero address"
1578 
1579         );
1580 
1581         return _balances[owner];
1582 
1583     }
1584 
1585 
1586 
1587     /**
1588 
1589      * @dev See {IERC721-ownerOf}.
1590 
1591      */
1592 
1593     function ownerOf(uint256 tokenId)
1594 
1595         public
1596 
1597         view
1598 
1599         virtual
1600 
1601         override
1602 
1603         returns (address)
1604 
1605     {
1606 
1607         address owner = _owners[tokenId];
1608 
1609         require(
1610 
1611             owner != address(0),
1612 
1613             "ERC721: owner query for nonexistent token"
1614 
1615         );
1616 
1617         return owner;
1618 
1619     }
1620 
1621 
1622 
1623     /**
1624 
1625      * @dev See {IERC721Metadata-name}.
1626 
1627      */
1628 
1629     function name() public view virtual override returns (string memory) {
1630 
1631         return _name;
1632 
1633     }
1634 
1635 
1636 
1637     /**
1638 
1639      * @dev See {IERC721Metadata-symbol}.
1640 
1641      */
1642 
1643     function symbol() public view virtual override returns (string memory) {
1644 
1645         return _symbol;
1646 
1647     }
1648 
1649 
1650 
1651     /**
1652 
1653      * @dev See {IERC721Metadata-tokenURI}.
1654 
1655      */
1656 
1657     function tokenURI(uint256 tokenId)
1658 
1659         public
1660 
1661         view
1662 
1663         virtual
1664 
1665         override
1666 
1667         returns (string memory)
1668 
1669     {
1670 
1671         require(
1672 
1673             _exists(tokenId),
1674 
1675             "ERC721Metadata: URI query for nonexistent token"
1676 
1677         );
1678 
1679 
1680 
1681         string memory baseURI = _baseURI();
1682 
1683         return
1684 
1685             bytes(baseURI).length > 0
1686 
1687                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
1688 
1689                 : "";
1690 
1691     }
1692 
1693 
1694 
1695     /**
1696 
1697      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1698 
1699      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1700 
1701      * by default, can be overriden in child contracts.
1702 
1703      */
1704 
1705     function _baseURI() internal view virtual returns (string memory) {
1706 
1707         return "";
1708 
1709     }
1710 
1711 
1712 
1713     /**
1714 
1715      * @dev See {IERC721-approve}.
1716 
1717      */
1718 
1719     function approve(address to, uint256 tokenId) public virtual override {
1720 
1721         address owner = ERC721.ownerOf(tokenId);
1722 
1723         require(to != owner, "ERC721: approval to current owner");
1724 
1725 
1726 
1727         require(
1728 
1729             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1730 
1731             "ERC721: approve caller is not owner nor approved for all"
1732 
1733         );
1734 
1735 
1736 
1737         _approve(to, tokenId);
1738 
1739     }
1740 
1741 
1742 
1743     /**
1744 
1745      * @dev See {IERC721-getApproved}.
1746 
1747      */
1748 
1749     function getApproved(uint256 tokenId)
1750 
1751         public
1752 
1753         view
1754 
1755         virtual
1756 
1757         override
1758 
1759         returns (address)
1760 
1761     {
1762 
1763         require(
1764 
1765             _exists(tokenId),
1766 
1767             "ERC721: approved query for nonexistent token"
1768 
1769         );
1770 
1771 
1772 
1773         return _tokenApprovals[tokenId];
1774 
1775     }
1776 
1777 
1778 
1779     /**
1780 
1781      * @dev See {IERC721-setApprovalForAll}.
1782 
1783      */
1784 
1785     function setApprovalForAll(address operator, bool approved)
1786 
1787         public
1788 
1789         virtual
1790 
1791         override
1792 
1793     {
1794 
1795         require(operator != _msgSender(), "ERC721: approve to caller");
1796 
1797 
1798 
1799         _operatorApprovals[_msgSender()][operator] = approved;
1800 
1801         emit ApprovalForAll(_msgSender(), operator, approved);
1802 
1803     }
1804 
1805 
1806 
1807     /**
1808 
1809      * @dev See {IERC721-isApprovedForAll}.
1810 
1811      */
1812 
1813     function isApprovedForAll(address owner, address operator)
1814 
1815         public
1816 
1817         view
1818 
1819         virtual
1820 
1821         override
1822 
1823         returns (bool)
1824 
1825     {
1826 
1827         return _operatorApprovals[owner][operator];
1828 
1829     }
1830 
1831 
1832 
1833     /**
1834 
1835      * @dev See {IERC721-transferFrom}.
1836 
1837      */
1838 
1839     function transferFrom(
1840 
1841         address from,
1842 
1843         address to,
1844 
1845         uint256 tokenId
1846 
1847     ) public virtual override {
1848 
1849         //solhint-disable-next-line max-line-length
1850 
1851         require(
1852 
1853             _isApprovedOrOwner(_msgSender(), tokenId),
1854 
1855             "ERC721: transfer caller is not owner nor approved"
1856 
1857         );
1858 
1859 
1860 
1861         _transfer(from, to, tokenId);
1862 
1863     }
1864 
1865 
1866 
1867     /**
1868 
1869      * @dev See {IERC721-safeTransferFrom}.
1870 
1871      */
1872 
1873     function safeTransferFrom(
1874 
1875         address from,
1876 
1877         address to,
1878 
1879         uint256 tokenId
1880 
1881     ) public virtual override {
1882 
1883         safeTransferFrom(from, to, tokenId, "");
1884 
1885     }
1886 
1887 
1888 
1889     /**
1890 
1891      * @dev See {IERC721-safeTransferFrom}.
1892 
1893      */
1894 
1895     function safeTransferFrom(
1896 
1897         address from,
1898 
1899         address to,
1900 
1901         uint256 tokenId,
1902 
1903         bytes memory _data
1904 
1905     ) public virtual override {
1906 
1907         require(
1908 
1909             _isApprovedOrOwner(_msgSender(), tokenId),
1910 
1911             "ERC721: transfer caller is not owner nor approved"
1912 
1913         );
1914 
1915         _safeTransfer(from, to, tokenId, _data);
1916 
1917     }
1918 
1919 
1920 
1921     /**
1922 
1923      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1924 
1925      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1926 
1927      *
1928 
1929      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1930 
1931      *
1932 
1933      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1934 
1935      * implement alternative mechanisms to perform token transfer, such as signature-based.
1936 
1937      *
1938 
1939      * Requirements:
1940 
1941      *
1942 
1943      * - `from` cannot be the zero address.
1944 
1945      * - `to` cannot be the zero address.
1946 
1947      * - `tokenId` token must exist and be owned by `from`.
1948 
1949      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1950 
1951      *
1952 
1953      * Emits a {Transfer} event.
1954 
1955      */
1956 
1957     function _safeTransfer(
1958 
1959         address from,
1960 
1961         address to,
1962 
1963         uint256 tokenId,
1964 
1965         bytes memory _data
1966 
1967     ) internal virtual {
1968 
1969         _transfer(from, to, tokenId);
1970 
1971         require(
1972 
1973             _checkOnERC721Received(from, to, tokenId, _data),
1974 
1975             "ERC721: transfer to non ERC721Receiver implementer"
1976 
1977         );
1978 
1979     }
1980 
1981 
1982 
1983     /**
1984 
1985      * @dev Returns whether `tokenId` exists.
1986 
1987      *
1988 
1989      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1990 
1991      *
1992 
1993      * Tokens start existing when they are minted (`_mint`),
1994 
1995      * and stop existing when they are burned (`_burn`).
1996 
1997      */
1998 
1999     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2000 
2001         return _owners[tokenId] != address(0);
2002 
2003     }
2004 
2005 
2006 
2007     /**
2008 
2009      * @dev Returns whether `spender` is allowed to manage `tokenId`.
2010 
2011      *
2012 
2013      * Requirements:
2014 
2015      *
2016 
2017      * - `tokenId` must exist.
2018 
2019      */
2020 
2021     function _isApprovedOrOwner(address spender, uint256 tokenId)
2022 
2023         internal
2024 
2025         view
2026 
2027         virtual
2028 
2029         returns (bool)
2030 
2031     {
2032 
2033         require(
2034 
2035             _exists(tokenId),
2036 
2037             "ERC721: operator query for nonexistent token"
2038 
2039         );
2040 
2041         address owner = ERC721.ownerOf(tokenId);
2042 
2043         return (spender == owner ||
2044 
2045             getApproved(tokenId) == spender ||
2046 
2047             isApprovedForAll(owner, spender));
2048 
2049     }
2050 
2051 
2052 
2053     /**
2054 
2055      * @dev Safely mints `tokenId` and transfers it to `to`.
2056 
2057      *
2058 
2059      * Requirements:
2060 
2061      *
2062 
2063      * - `tokenId` must not exist.
2064 
2065      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2066 
2067      *
2068 
2069      * Emits a {Transfer} event.
2070 
2071      */
2072 
2073     function _safeMint(address to, uint256 tokenId) internal virtual {
2074 
2075         _safeMint(to, tokenId, "");
2076 
2077     }
2078 
2079 
2080 
2081     /**
2082 
2083      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2084 
2085      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2086 
2087      */
2088 
2089     function _safeMint(
2090 
2091         address to,
2092 
2093         uint256 tokenId,
2094 
2095         bytes memory _data
2096 
2097     ) internal virtual {
2098 
2099         _mint(to, tokenId);
2100 
2101         require(
2102 
2103             _checkOnERC721Received(address(0), to, tokenId, _data),
2104 
2105             "ERC721: transfer to non ERC721Receiver implementer"
2106 
2107         );
2108 
2109     }
2110 
2111 
2112 
2113     /**
2114 
2115      * @dev Mints `tokenId` and transfers it to `to`.
2116 
2117      *
2118 
2119      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2120 
2121      *
2122 
2123      * Requirements:
2124 
2125      *
2126 
2127      * - `tokenId` must not exist.
2128 
2129      * - `to` cannot be the zero address.
2130 
2131      *
2132 
2133      * Emits a {Transfer} event.
2134 
2135      */
2136 
2137     function _mint(address to, uint256 tokenId) internal virtual {
2138 
2139         require(to != address(0), "ERC721: mint to the zero address");
2140 
2141         require(!_exists(tokenId), "ERC721: token already minted");
2142 
2143 
2144 
2145         _beforeTokenTransfer(address(0), to, tokenId);
2146 
2147 
2148 
2149         _balances[to] += 1;
2150 
2151         _owners[tokenId] = to;
2152 
2153 
2154 
2155         emit Transfer(address(0), to, tokenId);
2156 
2157     }
2158 
2159 
2160 
2161     /**
2162 
2163      * @dev Destroys `tokenId`.
2164 
2165      * The approval is cleared when the token is burned.
2166 
2167      *
2168 
2169      * Requirements:
2170 
2171      *
2172 
2173      * - `tokenId` must exist.
2174 
2175      *
2176 
2177      * Emits a {Transfer} event.
2178 
2179      */
2180 
2181     function _burn(uint256 tokenId) internal virtual {
2182 
2183         address owner = ERC721.ownerOf(tokenId);
2184 
2185 
2186 
2187         _beforeTokenTransfer(owner, address(0), tokenId);
2188 
2189 
2190 
2191         // Clear approvals
2192 
2193         _approve(address(0), tokenId);
2194 
2195 
2196 
2197         _balances[owner] -= 1;
2198 
2199         delete _owners[tokenId];
2200 
2201 
2202 
2203         emit Transfer(owner, address(0), tokenId);
2204 
2205     }
2206 
2207 
2208 
2209     /**
2210 
2211      * @dev Transfers `tokenId` from `from` to `to`.
2212 
2213      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2214 
2215      *
2216 
2217      * Requirements:
2218 
2219      *
2220 
2221      * - `to` cannot be the zero address.
2222 
2223      * - `tokenId` token must be owned by `from`.
2224 
2225      *
2226 
2227      * Emits a {Transfer} event.
2228 
2229      */
2230 
2231     function _transfer(
2232 
2233         address from,
2234 
2235         address to,
2236 
2237         uint256 tokenId
2238 
2239     ) internal virtual {
2240 
2241         require(
2242 
2243             ERC721.ownerOf(tokenId) == from,
2244 
2245             "ERC721: transfer of token that is not own"
2246 
2247         );
2248 
2249         require(to != address(0), "ERC721: transfer to the zero address");
2250 
2251 
2252 
2253         _beforeTokenTransfer(from, to, tokenId);
2254 
2255 
2256 
2257         // Clear approvals from the previous owner
2258 
2259         _approve(address(0), tokenId);
2260 
2261 
2262 
2263         _balances[from] -= 1;
2264 
2265         _balances[to] += 1;
2266 
2267         _owners[tokenId] = to;
2268 
2269 
2270 
2271         emit Transfer(from, to, tokenId);
2272 
2273     }
2274 
2275 
2276 
2277     /**
2278 
2279      * @dev Approve `to` to operate on `tokenId`
2280 
2281      *
2282 
2283      * Emits a {Approval} event.
2284 
2285      */
2286 
2287     function _approve(address to, uint256 tokenId) internal virtual {
2288 
2289         _tokenApprovals[tokenId] = to;
2290 
2291         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
2292 
2293     }
2294 
2295 
2296 
2297     /**
2298 
2299      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2300 
2301      * The call is not executed if the target address is not a contract.
2302 
2303      *
2304 
2305      * @param from address representing the previous owner of the given token ID
2306 
2307      * @param to target address that will receive the tokens
2308 
2309      * @param tokenId uint256 ID of the token to be transferred
2310 
2311      * @param _data bytes optional data to send along with the call
2312 
2313      * @return bool whether the call correctly returned the expected magic value
2314 
2315      */
2316 
2317     function _checkOnERC721Received(
2318 
2319         address from,
2320 
2321         address to,
2322 
2323         uint256 tokenId,
2324 
2325         bytes memory _data
2326 
2327     ) private returns (bool) {
2328 
2329         if (to.isContract()) {
2330 
2331             try
2332 
2333                 IERC721Receiver(to).onERC721Received(
2334 
2335                     _msgSender(),
2336 
2337                     from,
2338 
2339                     tokenId,
2340 
2341                     _data
2342 
2343                 )
2344 
2345             returns (bytes4 retval) {
2346 
2347                 return retval == IERC721Receiver.onERC721Received.selector;
2348 
2349             } catch (bytes memory reason) {
2350 
2351                 if (reason.length == 0) {
2352 
2353                     revert(
2354 
2355                         "ERC721: transfer to non ERC721Receiver implementer"
2356 
2357                     );
2358 
2359                 } else {
2360 
2361                     assembly {
2362 
2363                         revert(add(32, reason), mload(reason))
2364 
2365                     }
2366 
2367                 }
2368 
2369             }
2370 
2371         } else {
2372 
2373             return true;
2374 
2375         }
2376 
2377     }
2378 
2379 
2380 
2381     /**
2382 
2383      * @dev Hook that is called before any token transfer. This includes minting
2384 
2385      * and burning.
2386 
2387      *
2388 
2389      * Calling conditions:
2390 
2391      *
2392 
2393      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2394 
2395      * transferred to `to`.
2396 
2397      * - When `from` is zero, `tokenId` will be minted for `to`.
2398 
2399      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2400 
2401      * - `from` and `to` are never both zero.
2402 
2403      *
2404 
2405      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2406 
2407      */
2408 
2409     function _beforeTokenTransfer(
2410 
2411         address from,
2412 
2413         address to,
2414 
2415         uint256 tokenId
2416 
2417     ) internal virtual {}
2418 
2419 }
2420 
2421 
2422 
2423 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
2424 
2425 
2426 
2427 pragma solidity ^0.8.0;
2428 
2429 
2430 
2431 /**
2432 
2433  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
2434 
2435  * enumerability of all the token ids in the contract as well as all token ids owned by each
2436 
2437  * account.
2438 
2439  */
2440 
2441 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
2442 
2443     // Mapping from owner to list of owned token IDs
2444 
2445     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
2446 
2447 
2448 
2449     // Mapping from token ID to index of the owner tokens list
2450 
2451     mapping(uint256 => uint256) private _ownedTokensIndex;
2452 
2453 
2454 
2455     // Array with all token ids, used for enumeration
2456 
2457     uint256[] private _allTokens;
2458 
2459 
2460 
2461     // Mapping from token id to position in the allTokens array
2462 
2463     mapping(uint256 => uint256) private _allTokensIndex;
2464 
2465 
2466 
2467     /**
2468 
2469      * @dev See {IERC165-supportsInterface}.
2470 
2471      */
2472 
2473     function supportsInterface(bytes4 interfaceId)
2474 
2475         public
2476 
2477         view
2478 
2479         virtual
2480 
2481         override(IERC165, ERC721)
2482 
2483         returns (bool)
2484 
2485     {
2486 
2487         return
2488 
2489             interfaceId == type(IERC721Enumerable).interfaceId ||
2490 
2491             super.supportsInterface(interfaceId);
2492 
2493     }
2494 
2495 
2496 
2497     /**
2498 
2499      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
2500 
2501      */
2502 
2503     function tokenOfOwnerByIndex(address owner, uint256 index)
2504 
2505         public
2506 
2507         view
2508 
2509         virtual
2510 
2511         override
2512 
2513         returns (uint256)
2514 
2515     {
2516 
2517         require(
2518 
2519             index < ERC721.balanceOf(owner),
2520 
2521             "ERC721Enumerable: owner index out of bounds"
2522 
2523         );
2524 
2525         return _ownedTokens[owner][index];
2526 
2527     }
2528 
2529 
2530 
2531     /**
2532 
2533      * @dev See {IERC721Enumerable-totalSupply}.
2534 
2535      */
2536 
2537     function totalSupply() public view virtual override returns (uint256) {
2538 
2539         return _allTokens.length;
2540 
2541     }
2542 
2543 
2544 
2545     /**
2546 
2547      * @dev See {IERC721Enumerable-tokenByIndex}.
2548 
2549      */
2550 
2551     function tokenByIndex(uint256 index)
2552 
2553         public
2554 
2555         view
2556 
2557         virtual
2558 
2559         override
2560 
2561         returns (uint256)
2562 
2563     {
2564 
2565         require(
2566 
2567             index < ERC721Enumerable.totalSupply(),
2568 
2569             "ERC721Enumerable: global index out of bounds"
2570 
2571         );
2572 
2573         return _allTokens[index];
2574 
2575     }
2576 
2577 
2578 
2579     /**
2580 
2581      * @dev Hook that is called before any token transfer. This includes minting
2582 
2583      * and burning.
2584 
2585      *
2586 
2587      * Calling conditions:
2588 
2589      *
2590 
2591      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2592 
2593      * transferred to `to`.
2594 
2595      * - When `from` is zero, `tokenId` will be minted for `to`.
2596 
2597      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2598 
2599      * - `from` cannot be the zero address.
2600 
2601      * - `to` cannot be the zero address.
2602 
2603      *
2604 
2605      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2606 
2607      */
2608 
2609     function _beforeTokenTransfer(
2610 
2611         address from,
2612 
2613         address to,
2614 
2615         uint256 tokenId
2616 
2617     ) internal virtual override {
2618 
2619         super._beforeTokenTransfer(from, to, tokenId);
2620 
2621 
2622 
2623         if (from == address(0)) {
2624 
2625             _addTokenToAllTokensEnumeration(tokenId);
2626 
2627         } else if (from != to) {
2628 
2629             _removeTokenFromOwnerEnumeration(from, tokenId);
2630 
2631         }
2632 
2633         if (to == address(0)) {
2634 
2635             _removeTokenFromAllTokensEnumeration(tokenId);
2636 
2637         } else if (to != from) {
2638 
2639             _addTokenToOwnerEnumeration(to, tokenId);
2640 
2641         }
2642 
2643     }
2644 
2645 
2646 
2647     /**
2648 
2649      * @dev Private function to add a token to this extension's ownership-tracking data structures.
2650 
2651      * @param to address representing the new owner of the given token ID
2652 
2653      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
2654 
2655      */
2656 
2657     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
2658 
2659         uint256 length = ERC721.balanceOf(to);
2660 
2661         _ownedTokens[to][length] = tokenId;
2662 
2663         _ownedTokensIndex[tokenId] = length;
2664 
2665     }
2666 
2667 
2668 
2669     /**
2670 
2671      * @dev Private function to add a token to this extension's token tracking data structures.
2672 
2673      * @param tokenId uint256 ID of the token to be added to the tokens list
2674 
2675      */
2676 
2677     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
2678 
2679         _allTokensIndex[tokenId] = _allTokens.length;
2680 
2681         _allTokens.push(tokenId);
2682 
2683     }
2684 
2685 
2686 
2687     /**
2688 
2689      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
2690 
2691      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
2692 
2693      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
2694 
2695      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
2696 
2697      * @param from address representing the previous owner of the given token ID
2698 
2699      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
2700 
2701      */
2702 
2703     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
2704 
2705         private
2706 
2707     {
2708 
2709         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
2710 
2711         // then delete the last slot (swap and pop).
2712 
2713 
2714 
2715         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
2716 
2717         uint256 tokenIndex = _ownedTokensIndex[tokenId];
2718 
2719 
2720 
2721         // When the token to delete is the last token, the swap operation is unnecessary
2722 
2723         if (tokenIndex != lastTokenIndex) {
2724 
2725             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
2726 
2727 
2728 
2729             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2730 
2731             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2732 
2733         }
2734 
2735 
2736 
2737         // This also deletes the contents at the last position of the array
2738 
2739         delete _ownedTokensIndex[tokenId];
2740 
2741         delete _ownedTokens[from][lastTokenIndex];
2742 
2743     }
2744 
2745 
2746 
2747     /**
2748 
2749      * @dev Private function to remove a token from this extension's token tracking data structures.
2750 
2751      * This has O(1) time complexity, but alters the order of the _allTokens array.
2752 
2753      * @param tokenId uint256 ID of the token to be removed from the tokens list
2754 
2755      */
2756 
2757     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
2758 
2759         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
2760 
2761         // then delete the last slot (swap and pop).
2762 
2763 
2764 
2765         uint256 lastTokenIndex = _allTokens.length - 1;
2766 
2767         uint256 tokenIndex = _allTokensIndex[tokenId];
2768 
2769 
2770 
2771         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
2772 
2773         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
2774 
2775         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
2776 
2777         uint256 lastTokenId = _allTokens[lastTokenIndex];
2778 
2779 
2780 
2781         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2782 
2783         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2784 
2785 
2786 
2787         // This also deletes the contents at the last position of the array
2788 
2789         delete _allTokensIndex[tokenId];
2790 
2791         _allTokens.pop();
2792 
2793     }
2794 
2795 }
2796 
2797 pragma solidity ^0.8.0;
2798 
2799 contract BADGF is ERC721Enumerable, Ownable {
2800 
2801     struct TokenInfo {
2802         IERC20 coin;
2803         uint256 costvalue;
2804     }
2805 
2806     TokenInfo[] public AllowedCrypto;
2807     using Strings for uint256;
2808     string public baseURI;
2809     string public baseExtension = "";
2810     uint256 public cost = 0.025 ether;
2811     uint256 public maxSupplyRegular = 5150;
2812     uint256 public maxSupplyElite = 490;
2813     uint256 public maxSupplyTotal = 6000;
2814     uint256 public maxMintAmount = 7;
2815     uint256 public maxMintTotal = 20;
2816     uint256 public eliteT1total = 200;
2817     uint256 public eliteT2total = 200;
2818     uint256 public eliteT3total = 90;
2819     uint256 public eliteT1supply = 0;
2820     uint256 public eliteT2supply = 0;
2821     uint256 public eliteT3supply = 0;
2822     uint256 public eliteT1price = 140;
2823     uint256 public eliteT2price = 180;
2824     uint256 public eliteT3price = 220;
2825     bool public paused = true;
2826     bool public teamAllowedMint = true;
2827     bool public mintedLegendary = false;
2828     bool public eliteT1Enabled = false;
2829     bool public eliteT2Enabled = false;
2830     bool public eliteT3Enabled = false;
2831     mapping(address => uint256) private _mintedFreeAmount;
2832 
2833     constructor() ERC721("Bad Girlfriend Project", "BADGF") {}
2834 
2835     function addCurrency(IERC20 _coin, uint256 _costvalue)
2836         public onlyOwner {
2837         AllowedCrypto.push(
2838             TokenInfo({coin: _coin, costvalue: _costvalue})
2839         );
2840     }
2841 
2842     // internal
2843     function _baseURI() internal view virtual override returns (string memory) {
2844         return baseURI;
2845     }
2846 
2847     // public
2848     function freeMint() public {
2849         uint256 supply = totalSupply();
2850         require(!paused, "Public sale not active.");
2851         require(
2852             _mintedFreeAmount[msg.sender] < 1,
2853             "Max 1 free mint per address."
2854         );
2855         require(supply + 1 <= maxSupplyRegular, "Max supply reached.");
2856         _mintedFreeAmount[msg.sender] = 1;
2857         _safeMint(msg.sender, supply + 1);
2858     }
2859 
2860     function mint(uint256 _mintAmount) public payable {
2861         uint256 supply = totalSupply();
2862         require(!paused);
2863         require(_mintAmount > 0);
2864         require(_mintAmount <= maxMintAmount, "Max 7 NFTs per mint.");
2865         require(_mintAmount <= maxMintTotal, "Max 20 NFTs per wallet.");
2866         require(
2867             supply + _mintAmount <= maxSupplyRegular,
2868             "Max supply reached, Elite series next."
2869         );
2870         require(
2871             balanceOf(msg.sender) + _mintAmount <= maxMintTotal,
2872             "Max 20 NFTs per wallet."
2873         );
2874 
2875         if (msg.sender != owner()) {
2876             require(
2877                 msg.value == cost * _mintAmount,
2878                 "Pirce is 0.025 ether per NFT"
2879             );
2880         }
2881 
2882         for (uint256 i = 1; i <= _mintAmount; i++) {
2883             _safeMint(msg.sender, supply + i);
2884         }
2885     }
2886 
2887     function mintLegendary() public onlyOwner {
2888         uint256 supply = totalSupply();
2889         require(!mintedLegendary, "Already minted.");
2890         for (uint256 i = 1; i <= 10; i++) {
2891             _safeMint(msg.sender, supply + i);
2892         }
2893         mintedLegendary = true;
2894     }
2895 
2896     function teamMint(uint256 _mintAmount) public onlyOwner {
2897         uint256 supply = totalSupply();
2898         require(teamAllowedMint, "Team mint not allowed.");
2899         require(
2900             supply + _mintAmount <= maxSupplyTotal,
2901             "Max supply would be reached."
2902         );
2903         for (uint256 i = 1; i <= _mintAmount; i++) {
2904             _safeMint(msg.sender, supply + i);
2905         }
2906     }
2907 
2908     function mintEliteT1(uint256 _pid) public payable {
2909         TokenInfo storage tokens = AllowedCrypto[_pid];
2910         IERC20 coin;
2911         coin = tokens.coin;
2912         uint256 price;
2913         price = eliteT1price;
2914         uint256 supply = totalSupply();
2915         require(eliteT1Enabled, "Not allowed yet.");
2916         require(supply + 1 <= maxSupplyTotal, "Total supply would be reached.");
2917         require(eliteT1supply + 1 <= eliteT1total, "Elite T1 supply reached.");
2918 
2919         if (msg.sender != owner()) {
2920             require(msg.value == price, "Insufficient balance.");
2921         }
2922 
2923         coin.transferFrom(msg.sender, address(this), price);
2924         _safeMint(msg.sender, supply + 1);
2925         eliteT1supply++;
2926 
2927     }
2928 
2929     function mintEliteT2(uint256 _pid) public payable {
2930         TokenInfo storage tokens = AllowedCrypto[_pid];
2931         IERC20 coin;
2932         coin = tokens.coin;
2933         uint256 price;
2934         price = eliteT2price;
2935         uint256 supply = totalSupply();
2936         require(eliteT2Enabled, "Not allowed yet.");
2937         require(supply + 1 <= maxSupplyTotal, "Total supply would be reached.");
2938         require(eliteT2supply + 1 <= eliteT2total, "Elite T2 supply reached.");
2939 
2940         if (msg.sender != owner()) {
2941             require(msg.value == price, "Insufficient balance.");
2942         }
2943 
2944         coin.transferFrom(msg.sender, address(this), price);
2945         _safeMint(msg.sender, supply + 1);
2946         eliteT2supply++;
2947     }
2948 
2949 
2950 
2951     function mintEliteT3(uint256 _pid) public payable {
2952         TokenInfo storage tokens = AllowedCrypto[_pid];
2953         IERC20 coin;
2954         coin = tokens.coin;
2955         uint256 price;
2956         price = eliteT3price;
2957         uint256 supply = totalSupply();
2958         require(eliteT3Enabled, "Not allowed yet.");
2959         require(supply + 1 <= maxSupplyTotal, "Total supply would be reached.");
2960         require(eliteT3supply + 1 <= eliteT3total, "Elite T3 supply reached.");
2961 
2962         if (msg.sender != owner()) {
2963             require(msg.value == price, "Insufficient balance.");
2964         }
2965 
2966         coin.transferFrom(msg.sender, address(this), price);
2967         _safeMint(msg.sender, supply + 1);
2968         eliteT3supply++;
2969 
2970     }
2971 
2972 
2973 
2974     function walletOfOwner(address _owner) public view returns (uint256[] memory)  {
2975         uint256 ownerTokenCount = balanceOf(_owner);
2976         uint256[] memory tokenIds = new uint256[](ownerTokenCount);
2977         for (uint256 i; i < ownerTokenCount; i++) {
2978             tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
2979         }
2980         return tokenIds;
2981     }
2982 
2983     function tokenURI(uint256 tokenId) public view virtual override returns (string memory){
2984         require(_exists(tokenId), "Token doesn't exist.");
2985         string memory currentBaseURI = _baseURI();
2986         return
2987             bytes(currentBaseURI).length > 0
2988                 ? string(
2989                     abi.encodePacked(
2990                         currentBaseURI,
2991                         tokenId.toString(),
2992                         baseExtension
2993                     )
2994                 )
2995                 : "";
2996     }
2997 
2998     // only owner
2999     function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
3000         maxMintAmount = _newmaxMintAmount;
3001     }
3002 
3003     function setBaseURI(string memory _newBaseURI) public onlyOwner {
3004         baseURI = _newBaseURI;
3005     }
3006 
3007     function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
3008         baseExtension = _newBaseExtension;
3009     }
3010 
3011     function pause(bool _state) public onlyOwner {
3012         paused = _state;
3013     }
3014 
3015     function toggleTeamMint(bool _state) public onlyOwner {
3016         teamAllowedMint = _state;
3017     }
3018 
3019     function toggleT1Elite(bool _state) public onlyOwner {
3020         eliteT1Enabled = _state;
3021     }
3022 
3023     function toggleT2Elite(bool _state) public onlyOwner {
3024         eliteT2Enabled = _state;
3025     }
3026 
3027     function toggleT3Elite(bool _state) public onlyOwner {
3028         eliteT3Enabled = _state;
3029     }
3030 
3031     function setEliteT1price(uint256 _price) public onlyOwner {
3032         eliteT1price = _price;
3033     }
3034 
3035     function setEliteT2price(uint256 _price) public onlyOwner {
3036         eliteT2price = _price;
3037     }
3038 
3039     function setEliteT3price(uint256 _price) public onlyOwner {
3040         eliteT3price = _price;
3041     }
3042 
3043     function withdraw() public payable onlyOwner  {
3044         require(payable(msg.sender).send(address(this).balance));
3045     }
3046 
3047     function withdrawSTYX() public onlyOwner {
3048         TokenInfo storage tokens = AllowedCrypto[0];
3049         IERC20 coin;
3050         coin = tokens.coin;
3051         uint amount = IERC20(coin).balanceOf(address(this));
3052         coin.transfer(msg.sender, amount);
3053     }
3054 
3055 }