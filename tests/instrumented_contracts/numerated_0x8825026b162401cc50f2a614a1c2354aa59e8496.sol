1 pragma solidity ^0.4.23;
2 
3 
4 
5 /**
6 
7  * @title SafeMath
8 
9  * @dev Math operations with safety checks that throw on error
10 
11  */
12 
13 library SafeMath {
14 
15 
16     /**
17 
18      * @dev Multiplies two numbers, throws on overflow.
19 
20      */
21 
22     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
23 
24         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
25 
26         // benefit is lost if 'b' is also tested.
27 
28         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
29 
30         if (a == 0) {
31 
32             return 0;
33 
34         }
35 
36 
37         c = a * b;
38 
39         assert(c / a == b);
40 
41         return c;
42 
43     }
44 
45 
46     /**
47 
48      * @dev Integer division of two numbers, truncating the quotient.
49 
50      */
51 
52     function div(uint256 a, uint256 b) internal pure returns (uint256) {
53 
54         // assert(b > 0); // Solidity automatically throws when dividing by 0
55 
56         // uint256 c = a / b;
57 
58         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
59 
60         return a / b;
61 
62     }
63 
64 
65     /**
66 
67      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
68 
69      */
70 
71     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
72 
73         assert(b <= a);
74 
75         return a - b;
76 
77     }
78 
79 
80     /**
81 
82      * @dev Adds two numbers, throws on overflow.
83 
84      */
85 
86     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
87 
88         c = a + b;
89 
90         assert(c >= a);
91 
92         return c;
93 
94     }
95 
96 }
97 
98 
99 
100 /**
101 
102  * Utility library of inline functions on addresses
103 
104  */
105 
106 library AddressUtils {
107 
108 
109     /**
110 
111      * Returns whether the target address is a contract
112 
113      * @dev This function will return false if invoked during the constructor of a contract,
114 
115      *  as the code is not actually created until after the constructor finishes.
116 
117      * @param addr address to check
118 
119      * @return whether the target address is a contract
120 
121      */
122 
123     function isContract(address addr) internal view returns (bool) {
124 
125         uint256 size;
126 
127         // XXX Currently there is no better way to check if there is a contract in an address
128 
129         // than to check the size of the code at that address.
130 
131         // See https://ethereum.stackexchange.com/a/14016/36603
132 
133         // for more details about how this works.
134 
135         // TODO Check this again before the Serenity release, because all addresses will be
136 
137         // contracts then.
138 
139         // solium-disable-next-line security/no-inline-assembly
140 
141         assembly { size := extcodesize(addr) }
142 
143         return size > 0;
144 
145     }
146 
147 
148 }
149 
150 
151 
152 /**
153 
154  * @title ERC721 token receiver interface
155 
156  * @dev Interface for any contract that wants to support safeTransfers
157 
158  * from ERC721 asset contracts.
159 
160  */
161 
162 contract ERC721Receiver {
163 
164     /**
165 
166     * @dev Magic value to be returned upon successful reception of an NFT
167 
168     *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
169 
170     *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
171 
172     */
173 
174     bytes4 internal constant ERC721_RECEIVED = 0xf0b9e5ba;
175 
176 
177     /**
178 
179     * @notice Handle the receipt of an NFT
180 
181     * @dev The ERC721 smart contract calls this function on the recipient
182 
183     * after a `safetransfer`. This function MAY throw to revert and reject the
184 
185     * transfer. This function MUST use 50,000 gas or less. Return of other
186 
187     * than the magic value MUST result in the transaction being reverted.
188 
189     * Note: the contract address is always the message sender.
190 
191     * @param _from The sending address
192 
193     * @param _tokenId The NFT identifier which is being transfered
194 
195     * @param _data Additional data with no specified format
196 
197     * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
198 
199     */
200 
201     function onERC721Received(address _from, uint256 _tokenId, bytes _data) public returns(bytes4);
202 
203 }
204 
205 
206 /**
207 
208  * @title ERC165
209 
210  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
211 
212  */
213 
214 interface ERC165 {
215 
216 
217     /**
218 
219      * @notice Query if a contract implements an interface
220 
221      * @param _interfaceId The interface identifier, as specified in ERC-165
222 
223      * @dev Interface identification is specified in ERC-165. This function
224 
225      * uses less than 30,000 gas.
226 
227      */
228 
229     function supportsInterface(bytes4 _interfaceId) external view returns (bool);
230 
231 }
232 
233 
234 
235 /**
236 
237  * @title ERC721 Non-Fungible Token Standard basic interface
238 
239  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
240 
241  */
242 
243 contract ERC721Basic is ERC165 {
244 
245     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
246 
247     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
248 
249     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
250 
251 
252     function balanceOf(address _owner) public view returns (uint256 _balance);
253 
254     function ownerOf(uint256 _tokenId) public view returns (address _owner);
255 
256     function exists(uint256 _tokenId) public view returns (bool _exists);
257 
258 
259     function approve(address _to, uint256 _tokenId) public;
260 
261     function getApproved(uint256 _tokenId) public view returns (address _operator);
262 
263 
264     function setApprovalForAll(address _operator, bool _approved) public;
265 
266     function isApprovedForAll(address _owner, address _operator) public view returns (bool);
267 
268 
269     function transferFrom(address _from, address _to, uint256 _tokenId) public;
270 
271     function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;
272 
273 
274     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) public;
275 
276 }
277 
278 
279 
280 /**
281 
282  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
283 
284  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
285 
286  */
287 
288 contract ERC721Enumerable is ERC721Basic {
289 
290     function totalSupply() public view returns (uint256);
291 
292     function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256 _tokenId);
293 
294     function tokenByIndex(uint256 _index) public view returns (uint256);
295 
296 }
297 
298 
299 
300 /**
301 
302  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
303 
304  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
305 
306  */
307 
308 contract ERC721Metadata is ERC721Basic {
309 
310     function name() external view returns (string _name);
311 
312     function symbol() external view returns (string _symbol);
313 
314     function tokenURI(uint256 _tokenId) public view returns (string);
315 
316 }
317 
318 
319 
320 /**
321 
322  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
323 
324  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
325 
326  */
327 
328 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
329 
330 
331 }
332 
333 
334 
335 contract ERC721Holder is ERC721Receiver {
336 
337     function onERC721Received(address, uint256, bytes) public returns(bytes4) {
338 
339         return ERC721_RECEIVED;
340 
341     }
342 
343 }
344 
345 
346 
347 /**
348 
349  * @title SupportsInterfaceWithLookup
350 
351  * @author Matt Condon (@shrugs)
352 
353  * @dev Implements ERC165 using a lookup table.
354 
355  */
356 
357 contract SupportsInterfaceWithLookup is ERC165 {
358 
359     bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
360 
361     /**
362 
363      * 0x01ffc9a7 ===
364 
365      *   bytes4(keccak256('supportsInterface(bytes4)'))
366 
367      */
368 
369 
370     /**
371 
372      * @dev a mapping of interface id to whether or not it's supported
373 
374      */
375 
376     mapping(bytes4 => bool) internal supportedInterfaces;
377 
378 
379     /**
380 
381      * @dev A contract implementing SupportsInterfaceWithLookup
382 
383      * implement ERC165 itself
384 
385      */
386 
387     constructor() public {
388 
389         _registerInterface(InterfaceId_ERC165);
390 
391     }
392 
393 
394     /**
395 
396      * @dev implement supportsInterface(bytes4) using a lookup table
397 
398      */
399 
400     function supportsInterface(bytes4 _interfaceId) external view returns (bool) {
401 
402         return supportedInterfaces[_interfaceId];
403 
404     }
405 
406 
407     /**
408 
409      * @dev private method for registering an interface
410 
411      */
412 
413     function _registerInterface(bytes4 _interfaceId) internal {
414 
415         require(_interfaceId != 0xffffffff);
416 
417         supportedInterfaces[_interfaceId] = true;
418 
419     }
420 
421 }
422 
423 
424 
425 /**
426 
427  * @title ERC721 Non-Fungible Token Standard basic implementation
428 
429  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
430 
431  */
432 
433 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
434 
435 
436     bytes4 private constant InterfaceId_ERC721 = 0x80ac58cd;
437 
438     /*
439 
440      * 0x80ac58cd ===
441 
442      *   bytes4(keccak256('balanceOf(address)')) ^
443 
444      *   bytes4(keccak256('ownerOf(uint256)')) ^
445 
446      *   bytes4(keccak256('approve(address,uint256)')) ^
447 
448      *   bytes4(keccak256('getApproved(uint256)')) ^
449 
450      *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
451 
452      *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
453 
454      *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
455 
456      *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
457 
458      *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
459 
460      */
461 
462 
463     bytes4 private constant InterfaceId_ERC721Exists = 0x4f558e79;
464 
465     /*
466 
467      * 0x4f558e79 ===
468 
469      *   bytes4(keccak256('exists(uint256)'))
470 
471      */
472 
473 
474     using SafeMath for uint256;
475 
476     using AddressUtils for address;
477 
478 
479     // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
480 
481     // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
482 
483     bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
484 
485 
486     // Mapping from token ID to owner
487 
488     mapping (uint256 => address) internal tokenOwner;
489 
490 
491     // Mapping from token ID to approved address
492 
493     mapping (uint256 => address) internal tokenApprovals;
494 
495 
496     // Mapping from owner to number of owned token
497 
498     mapping (address => uint256) internal ownedTokensCount;
499 
500 
501     // Mapping from owner to operator approvals
502 
503     mapping (address => mapping (address => bool)) internal operatorApprovals;
504 
505 
506     /**
507 
508      * @dev Guarantees msg.sender is owner of the given token
509 
510      * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
511 
512      */
513 
514     modifier onlyOwnerOf(uint256 _tokenId) {
515 
516         require(ownerOf(_tokenId) == msg.sender);
517 
518         _;
519 
520     }
521 
522 
523     /**
524 
525      * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
526 
527      * @param _tokenId uint256 ID of the token to validate
528 
529      */
530 
531     modifier canTransfer(uint256 _tokenId) {
532 
533         require(isApprovedOrOwner(msg.sender, _tokenId));
534 
535         _;
536 
537     }
538 
539 
540     constructor() public {
541 
542         // register the supported interfaces to conform to ERC721 via ERC165
543 
544         _registerInterface(InterfaceId_ERC721);
545 
546         _registerInterface(InterfaceId_ERC721Exists);
547 
548     }
549 
550 
551     /**
552 
553      * @dev Gets the balance of the specified address
554 
555      * @param _owner address to query the balance of
556 
557      * @return uint256 representing the amount owned by the passed address
558 
559      */
560 
561     function balanceOf(address _owner) public view returns (uint256) {
562 
563         require(_owner != address(0));
564 
565         return ownedTokensCount[_owner];
566 
567     }
568 
569 
570     /**
571 
572      * @dev Gets the owner of the specified token ID
573 
574      * @param _tokenId uint256 ID of the token to query the owner of
575 
576      * @return owner address currently marked as the owner of the given token ID
577 
578      */
579 
580     function ownerOf(uint256 _tokenId) public view returns (address) {
581 
582         address owner = tokenOwner[_tokenId];
583 
584         require(owner != address(0));
585 
586         return owner;
587 
588     }
589 
590 
591     /**
592 
593      * @dev Returns whether the specified token exists
594 
595      * @param _tokenId uint256 ID of the token to query the existence of
596 
597      * @return whether the token exists
598 
599      */
600 
601     function exists(uint256 _tokenId) public view returns (bool) {
602 
603         address owner = tokenOwner[_tokenId];
604 
605         return owner != address(0);
606 
607     }
608 
609 
610     /**
611 
612      * @dev Approves another address to transfer the given token ID
613 
614      * @dev The zero address indicates there is no approved address.
615 
616      * @dev There can only be one approved address per token at a given time.
617 
618      * @dev Can only be called by the token owner or an approved operator.
619 
620      * @param _to address to be approved for the given token ID
621 
622      * @param _tokenId uint256 ID of the token to be approved
623 
624      */
625 
626     function approve(address _to, uint256 _tokenId) public {
627 
628         address owner = ownerOf(_tokenId);
629 
630         require(_to != owner);
631 
632         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
633 
634 
635         tokenApprovals[_tokenId] = _to;
636 
637         emit Approval(owner, _to, _tokenId);
638 
639     }
640 
641 
642     /**
643 
644      * @dev Gets the approved address for a token ID, or zero if no address set
645 
646      * @param _tokenId uint256 ID of the token to query the approval of
647 
648      * @return address currently approved for the given token ID
649 
650      */
651 
652     function getApproved(uint256 _tokenId) public view returns (address) {
653 
654         return tokenApprovals[_tokenId];
655 
656     }
657 
658 
659     /**
660 
661      * @dev Sets or unsets the approval of a given operator
662 
663      * @dev An operator is allowed to transfer all tokens of the sender on their behalf
664 
665      * @param _to operator address to set the approval
666 
667      * @param _approved representing the status of the approval to be set
668 
669      */
670 
671     function setApprovalForAll(address _to, bool _approved) public {
672 
673         require(_to != msg.sender);
674 
675         operatorApprovals[msg.sender][_to] = _approved;
676 
677         emit ApprovalForAll(msg.sender, _to, _approved);
678 
679     }
680 
681 
682     /**
683 
684      * @dev Tells whether an operator is approved by a given owner
685 
686      * @param _owner owner address which you want to query the approval of
687 
688      * @param _operator operator address which you want to query the approval of
689 
690      * @return bool whether the given operator is approved by the given owner
691 
692      */
693 
694     function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
695 
696         return operatorApprovals[_owner][_operator];
697 
698     }
699 
700 
701     /**
702 
703      * @dev Transfers the ownership of a given token ID to another address
704 
705      * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
706 
707      * @dev Requires the msg sender to be the owner, approved, or operator
708 
709      * @param _from current owner of the token
710 
711      * @param _to address to receive the ownership of the given token ID
712 
713      * @param _tokenId uint256 ID of the token to be transferred
714 
715     */
716 
717     function transferFrom(address _from, address _to, uint256 _tokenId) public canTransfer(_tokenId) {
718 
719         require(_from != address(0));
720 
721         require(_to != address(0));
722 
723 
724         clearApproval(_from, _tokenId);
725 
726         removeTokenFrom(_from, _tokenId);
727 
728         addTokenTo(_to, _tokenId);
729 
730 
731         emit Transfer(_from, _to, _tokenId);
732 
733     }
734 
735 
736     /**
737 
738      * @dev Safely transfers the ownership of a given token ID to another address
739 
740      * @dev If the target address is a contract, it must implement `onERC721Received`,
741 
742      *  which is called upon a safe transfer, and return the magic value
743 
744      *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
745 
746      *  the transfer is reverted.
747 
748      * @dev Requires the msg sender to be the owner, approved, or operator
749 
750      * @param _from current owner of the token
751 
752      * @param _to address to receive the ownership of the given token ID
753 
754      * @param _tokenId uint256 ID of the token to be transferred
755 
756     */
757 
758     function safeTransferFrom(address _from, address _to, uint256 _tokenId) public canTransfer(_tokenId) {
759 
760         // solium-disable-next-line arg-overflow
761 
762         safeTransferFrom(_from, _to, _tokenId, "");
763 
764     }
765 
766 
767     /**
768 
769      * @dev Safely transfers the ownership of a given token ID to another address
770 
771      * @dev If the target address is a contract, it must implement `onERC721Received`,
772 
773      *  which is called upon a safe transfer, and return the magic value
774 
775      *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
776 
777      *  the transfer is reverted.
778 
779      * @dev Requires the msg sender to be the owner, approved, or operator
780 
781      * @param _from current owner of the token
782 
783      * @param _to address to receive the ownership of the given token ID
784 
785      * @param _tokenId uint256 ID of the token to be transferred
786 
787      * @param _data bytes data to send along with a safe transfer check
788 
789      */
790 
791     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) public canTransfer(_tokenId) {
792 
793         transferFrom(_from, _to, _tokenId);
794 
795         // solium-disable-next-line arg-overflow
796 
797         require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
798 
799     }
800 
801 
802     /**
803 
804      * @dev Returns whether the given spender can transfer a given token ID
805 
806      * @param _spender address of the spender to query
807 
808      * @param _tokenId uint256 ID of the token to be transferred
809 
810      * @return bool whether the msg.sender is approved for the given token ID,
811 
812      *  is an operator of the owner, or is the owner of the token
813 
814      */
815 
816     function isApprovedOrOwner(
817 
818         address _spender,
819 
820         uint256 _tokenId
821 
822     )
823 
824         internal
825 
826         view
827 
828         returns (bool)
829 
830     {
831 
832         address owner = ownerOf(_tokenId);
833 
834         // Disable solium check because of
835 
836         // https://github.com/duaraghav8/Solium/issues/175
837 
838         // solium-disable-next-line operator-whitespace
839 
840         return (
841 
842             _spender == owner ||
843 
844             getApproved(_tokenId) == _spender ||
845 
846             isApprovedForAll(owner, _spender)
847 
848         );
849 
850     }
851 
852 
853     /**
854 
855      * @dev Internal function to mint a new token
856 
857      * @dev Reverts if the given token ID already exists
858 
859      * @param _to The address that will own the minted token
860 
861      * @param _tokenId uint256 ID of the token to be minted by the msg.sender
862 
863      */
864 
865     function _mint(address _to, uint256 _tokenId) internal {
866 
867         require(_to != address(0));
868 
869         addTokenTo(_to, _tokenId);
870 
871         emit Transfer(address(0), _to, _tokenId);
872 
873     }
874 
875 
876     /**
877 
878      * @dev Internal function to clear current approval of a given token ID
879 
880      * @dev Reverts if the given address is not indeed the owner of the token
881 
882      * @param _owner owner of the token
883 
884      * @param _tokenId uint256 ID of the token to be transferred
885 
886      */
887 
888     function clearApproval(address _owner, uint256 _tokenId) internal {
889 
890         require(ownerOf(_tokenId) == _owner);
891 
892         if (tokenApprovals[_tokenId] != address(0)) {
893 
894             tokenApprovals[_tokenId] = address(0);
895 
896             emit Approval(_owner, address(0), _tokenId);
897 
898         }
899 
900     }
901 
902 
903     /**
904 
905      * @dev Internal function to add a token ID to the list of a given address
906 
907      * @param _to address representing the new owner of the given token ID
908 
909      * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
910 
911      */
912 
913     function addTokenTo(address _to, uint256 _tokenId) internal {
914 
915         require(tokenOwner[_tokenId] == address(0));
916 
917         tokenOwner[_tokenId] = _to;
918 
919         ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
920 
921     }
922 
923 
924     /**
925 
926      * @dev Internal function to remove a token ID from the list of a given address
927 
928      * @param _from address representing the previous owner of the given token ID
929 
930      * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
931 
932      */
933 
934     function removeTokenFrom(address _from, uint256 _tokenId) internal {
935 
936         require(ownerOf(_tokenId) == _from);
937 
938         ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
939 
940         tokenOwner[_tokenId] = address(0);
941 
942     }
943 
944 
945     /**
946 
947      * @dev Internal function to invoke `onERC721Received` on a target address
948 
949      * The call is not executed if the target address is not a contract
950 
951      * @param _from address representing the previous owner of the given token ID
952 
953      * @param _to target address that will receive the tokens
954 
955      * @param _tokenId uint256 ID of the token to be transferred
956 
957      * @param _data bytes optional data to send along with the call
958 
959      * @return whether the call correctly returned the expected magic value
960 
961      */
962 
963     function checkAndCallSafeTransfer(
964 
965         address _from,
966 
967         address _to,
968 
969         uint256 _tokenId,
970 
971         bytes _data
972 
973     )
974 
975         internal
976 
977         returns (bool)
978 
979     {
980 
981         if (!_to.isContract()) {
982 
983             return true;
984 
985         }
986 
987 
988         bytes4 retval = ERC721Receiver(_to).onERC721Received(
989 
990         _from, _tokenId, _data);
991 
992         return (retval == ERC721_RECEIVED);
993 
994     }
995 
996 }
997 
998 
999 
1000 /**
1001 
1002  * @title Ownable
1003 
1004  * @dev The Ownable contract has an owner address, and provides basic authorization control
1005 
1006  * functions, this simplifies the implementation of "user permissions".
1007 
1008  */
1009 
1010  contract Ownable {
1011 
1012      address public owner;
1013 
1014      address public pendingOwner;
1015 
1016      address public manager;
1017 
1018 
1019      event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1020 
1021 
1022      /**
1023 
1024      * @dev Throws if called by any account other than the owner.
1025 
1026      */
1027 
1028      modifier onlyOwner() {
1029 
1030          require(msg.sender == owner);
1031 
1032          _;
1033 
1034      }
1035 
1036 
1037      /**
1038 
1039       * @dev Modifier throws if called by any account other than the manager.
1040 
1041       */
1042 
1043      modifier onlyManager() {
1044 
1045          require(msg.sender == manager);
1046 
1047          _;
1048 
1049      }
1050 
1051 
1052      /**
1053 
1054       * @dev Modifier throws if called by any account other than the pendingOwner.
1055 
1056       */
1057 
1058      modifier onlyPendingOwner() {
1059 
1060          require(msg.sender == pendingOwner);
1061 
1062          _;
1063 
1064      }
1065 
1066 
1067      constructor() public {
1068 
1069          owner = msg.sender;
1070 
1071      }
1072 
1073 
1074      /**
1075 
1076       * @dev Allows the current owner to set the pendingOwner address.
1077 
1078       * @param newOwner The address to transfer ownership to.
1079 
1080       */
1081 
1082      function transferOwnership(address newOwner) public onlyOwner {
1083 
1084          pendingOwner = newOwner;
1085 
1086      }
1087 
1088 
1089      /**
1090 
1091       * @dev Allows the pendingOwner address to finalize the transfer.
1092 
1093       */
1094 
1095      function claimOwnership() public onlyPendingOwner {
1096 
1097          emit OwnershipTransferred(owner, pendingOwner);
1098 
1099          owner = pendingOwner;
1100 
1101          pendingOwner = address(0);
1102 
1103      }
1104 
1105 
1106      /**
1107 
1108       * @dev Sets the manager address.
1109 
1110       * @param _manager The manager address.
1111 
1112       */
1113 
1114      function setManager(address _manager) public onlyOwner {
1115 
1116          require(_manager != address(0));
1117 
1118          manager = _manager;
1119 
1120      }
1121 
1122 
1123  }
1124 
1125 
1126 
1127 
1128 /**
1129 
1130  * @title Full ERC721 Token
1131 
1132  * This implementation includes all the required and some optional functionality of the ERC721 standard
1133 
1134  * Moreover, it includes approve all functionality using operator terminology
1135 
1136  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
1137 
1138  */
1139 
1140 contract AviationSecurityToken is SupportsInterfaceWithLookup, ERC721, ERC721BasicToken, Ownable {
1141 
1142 
1143     bytes4 private constant InterfaceId_ERC721Enumerable = 0x780e9d63;
1144 
1145     /**
1146 
1147      * 0x780e9d63 ===
1148 
1149      *   bytes4(keccak256('totalSupply()')) ^
1150 
1151      *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
1152 
1153      *   bytes4(keccak256('tokenByIndex(uint256)'))
1154 
1155      */
1156 
1157 
1158     bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
1159 
1160     /**
1161 
1162      * 0x5b5e139f ===
1163 
1164      *   bytes4(keccak256('name()')) ^
1165 
1166      *   bytes4(keccak256('symbol()')) ^
1167 
1168      *   bytes4(keccak256('tokenURI(uint256)'))
1169 
1170      */
1171 
1172 
1173     // Token name
1174 
1175     string public name_ = "AviationSecurityToken";
1176 
1177 
1178     // Token symbol
1179 
1180     string public symbol_ = "AVNS";
1181 
1182 
1183     // Mapping from owner to list of owned token IDs
1184 
1185     mapping(address => uint256[]) internal ownedTokens;
1186 
1187 
1188     // Mapping from token ID to index of the owner tokens list
1189 
1190     mapping(uint256 => uint256) internal ownedTokensIndex;
1191 
1192 
1193     // Array with all token ids, used for enumeration
1194 
1195     uint256[] internal allTokens;
1196 
1197 
1198     // Mapping from token id to position in the allTokens array
1199 
1200     mapping(uint256 => uint256) internal allTokensIndex;
1201 
1202 
1203     // Optional mapping for token URIs
1204 
1205     mapping(uint256 => string) internal tokenURIs;
1206 
1207 
1208     struct Data{
1209 
1210         string liscence;
1211 
1212         string URL;
1213 
1214     }
1215 
1216     
1217 
1218     mapping(uint256 => Data) internal tokenData;
1219 
1220     /**
1221 
1222      * @dev Constructor function
1223 
1224      */
1225 
1226     constructor() public {
1227 
1228 
1229 
1230         // register the supported interfaces to conform to ERC721 via ERC165
1231 
1232         _registerInterface(InterfaceId_ERC721Enumerable);
1233 
1234         _registerInterface(InterfaceId_ERC721Metadata);
1235 
1236     }
1237 
1238 
1239     /**
1240 
1241      * @dev External function to mint a new token
1242 
1243      * @dev Reverts if the given token ID already exists
1244 
1245      * @param _to address the beneficiary that will own the minted token
1246 
1247      */
1248 
1249     function mint(address _to, uint256 _id) external onlyManager {
1250 
1251         _mint(_to, _id);
1252 
1253     }
1254 
1255 
1256     /**
1257 
1258      * @dev Gets the token name
1259 
1260      * @return string representing the token name
1261 
1262      */
1263 
1264     function name() external view returns (string) {
1265 
1266         return name_;
1267 
1268     }
1269 
1270 
1271     /**
1272 
1273      * @dev Gets the token symbol
1274 
1275      * @return string representing the token symbol
1276 
1277      */
1278 
1279     function symbol() external view returns (string) {
1280 
1281         return symbol_;
1282 
1283     }
1284 
1285 
1286     function arrayOfTokensByAddress(address _holder) public view returns(uint256[]) {
1287 
1288         return ownedTokens[_holder];
1289 
1290     }
1291 
1292 
1293     /**
1294 
1295      * @dev Returns an URI for a given token ID
1296 
1297      * @dev Throws if the token ID does not exist. May return an empty string.
1298 
1299      * @param _tokenId uint256 ID of the token to query
1300 
1301      */
1302 
1303     function tokenURI(uint256 _tokenId) public view returns (string) {
1304 
1305         require(exists(_tokenId));
1306 
1307         return tokenURIs[_tokenId];
1308 
1309     }
1310 
1311 
1312     /**
1313 
1314      * @dev Gets the token ID at a given index of the tokens list of the requested owner
1315 
1316      * @param _owner address owning the tokens list to be accessed
1317 
1318      * @param _index uint256 representing the index to be accessed of the requested tokens list
1319 
1320      * @return uint256 token ID at the given index of the tokens list owned by the requested address
1321 
1322      */
1323 
1324     function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256) {
1325 
1326         require(_index < balanceOf(_owner));
1327 
1328         return ownedTokens[_owner][_index];
1329 
1330     }
1331 
1332 
1333     /**
1334 
1335      * @dev Gets the total amount of tokens stored by the contract
1336 
1337      * @return uint256 representing the total amount of tokens
1338 
1339      */
1340 
1341     function totalSupply() public view returns (uint256) {
1342 
1343         return allTokens.length;
1344 
1345     }
1346 
1347 
1348     /**
1349 
1350      * @dev Gets the token ID at a given index of all the tokens in this contract
1351 
1352      * @dev Reverts if the index is greater or equal to the total number of tokens
1353 
1354      * @param _index uint256 representing the index to be accessed of the tokens list
1355 
1356      * @return uint256 token ID at the given index of the tokens list
1357 
1358      */
1359 
1360     function tokenByIndex(uint256 _index) public view returns (uint256) {
1361 
1362         require(_index < totalSupply());
1363 
1364         return allTokens[_index];
1365 
1366     }
1367 
1368 
1369     /**
1370 
1371      * @dev Internal function to set the token URI for a given token
1372 
1373      * @dev Reverts if the token ID does not exist
1374 
1375      * @param _tokenId uint256 ID of the token to set its URI
1376 
1377      * @param _uri string URI to assign
1378 
1379      */
1380 
1381     function _setTokenURI(uint256 _tokenId, string _uri) internal {
1382 
1383         require(exists(_tokenId));
1384 
1385         tokenURIs[_tokenId] = _uri;
1386 
1387     }
1388 
1389 
1390     /**
1391 
1392      * @dev Internal function to add a token ID to the list of a given address
1393 
1394      * @param _to address representing the new owner of the given token ID
1395 
1396      * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
1397 
1398      */
1399 
1400     function addTokenTo(address _to, uint256 _tokenId) internal {
1401 
1402         super.addTokenTo(_to, _tokenId);
1403 
1404         uint256 length = ownedTokens[_to].length;
1405 
1406         ownedTokens[_to].push(_tokenId);
1407 
1408         ownedTokensIndex[_tokenId] = length;
1409 
1410     }
1411 
1412 
1413     /**
1414 
1415      * @dev Internal function to remove a token ID from the list of a given address
1416 
1417      * @param _from address representing the previous owner of the given token ID
1418 
1419      * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
1420 
1421      */
1422 
1423     function removeTokenFrom(address _from, uint256 _tokenId) internal {
1424 
1425         super.removeTokenFrom(_from, _tokenId);
1426 
1427 
1428         uint256 tokenIndex = ownedTokensIndex[_tokenId];
1429 
1430         uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
1431 
1432         uint256 lastToken = ownedTokens[_from][lastTokenIndex];
1433 
1434 
1435         ownedTokens[_from][tokenIndex] = lastToken;
1436 
1437         ownedTokens[_from][lastTokenIndex] = 0;
1438 
1439         // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are
1440 
1441         // going to be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are
1442 
1443         // first swapping the lastToken to the first position, and then dropping the element placed in the last
1444 
1445         // position of the list
1446 
1447 
1448         ownedTokens[_from].length--;
1449 
1450         ownedTokensIndex[_tokenId] = 0;
1451 
1452         ownedTokensIndex[lastToken] = tokenIndex;
1453 
1454     }
1455 
1456 
1457     /**
1458 
1459      * @dev Internal function to mint a new token
1460 
1461      * @dev Reverts if the given token ID already exists
1462 
1463      * @param _to address the beneficiary that will own the minted token
1464 
1465      */
1466 
1467     function _mint(address _to, uint256 _id) internal {
1468 
1469         allTokens.push(_id);
1470 
1471         allTokensIndex[_id] = _id;
1472 
1473         super._mint(_to, _id);
1474 
1475     }
1476 
1477     
1478 
1479     function addTokenData(uint _tokenId, string _liscence, string _URL) public {
1480 
1481             require(ownerOf(_tokenId) == msg.sender);
1482 
1483             tokenData[_tokenId].liscence = _liscence;
1484 
1485             tokenData[_tokenId].URL = _URL;
1486 
1487 
1488         
1489 
1490     }
1491 
1492     
1493 
1494     function getTokenData(uint _tokenId) public view returns(string Liscence, string URL){
1495 
1496         require(exists(_tokenId));
1497 
1498         Liscence = tokenData[_tokenId].liscence;
1499 
1500         URL = tokenData[_tokenId].URL;
1501 
1502     }
1503 
1504 }