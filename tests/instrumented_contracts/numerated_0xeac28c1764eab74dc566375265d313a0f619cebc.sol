1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         return msg.data;
24     }
25 }
26 
27 // File: @openzeppelin/contracts/access/Ownable.sol
28 
29 
30 
31 pragma solidity ^0.8.0;
32 
33 
34 /**
35  * @dev Contract module which provides a basic access control mechanism, where
36  * there is an account (an owner) that can be granted exclusive access to
37  * specific functions.
38  *
39  * By default, the owner account will be the one that deploys the contract. This
40  * can later be changed with {transferOwnership}.
41  *
42  * This module is used through inheritance. It will make available the modifier
43  * `onlyOwner`, which can be applied to your functions to restrict their use to
44  * the owner.
45  */
46 abstract contract Ownable is Context {
47     address private _owner;
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51     /**
52      * @dev Initializes the contract setting the deployer as the initial owner.
53      */
54     constructor() {
55         _setOwner(_msgSender());
56     }
57 
58     /**
59      * @dev Returns the address of the current owner.
60      */
61     function owner() public view virtual returns (address) {
62         return _owner;
63     }
64 
65     /**
66      * @dev Throws if called by any account other than the owner.
67      */
68     modifier onlyOwner() {
69         require(owner() == _msgSender(), "Ownable: caller is not the owner");
70         _;
71     }
72 
73     /**
74      * @dev Leaves the contract without owner. It will not be possible to call
75      * `onlyOwner` functions anymore. Can only be called by the current owner.
76      *
77      * NOTE: Renouncing ownership will leave the contract without an owner,
78      * thereby removing any functionality that is only available to the owner.
79      */
80     function renounceOwnership() public virtual onlyOwner {
81         _setOwner(address(0));
82     }
83 
84     /**
85      * @dev Transfers ownership of the contract to a new account (`newOwner`).
86      * Can only be called by the current owner.
87      */
88     function transferOwnership(address newOwner) public virtual onlyOwner {
89         require(newOwner != address(0), "Ownable: new owner is the zero address");
90         _setOwner(newOwner);
91     }
92 
93     function _setOwner(address newOwner) private {
94         address oldOwner = _owner;
95         _owner = newOwner;
96         emit OwnershipTransferred(oldOwner, newOwner);
97     }
98 }
99 
100 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
101 
102 
103 
104 pragma solidity ^0.8.0;
105 
106 /**
107  * @dev Interface of the ERC165 standard, as defined in the
108  * https://eips.ethereum.org/EIPS/eip-165[EIP].
109  *
110  * Implementers can declare support of contract interfaces, which can then be
111  * queried by others ({ERC165Checker}).
112  *
113  * For an implementation, see {ERC165}.
114  */
115 interface IERC165 {
116     /**
117      * @dev Returns true if this contract implements the interface defined by
118      * `interfaceId`. See the corresponding
119      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
120      * to learn more about how these ids are created.
121      *
122      * This function call must use less than 30 000 gas.
123      */
124     function supportsInterface(bytes4 interfaceId) external view returns (bool);
125 }
126 
127 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
128 
129 
130 
131 pragma solidity ^0.8.0;
132 
133 
134 /**
135  * @dev Required interface of an ERC721 compliant contract.
136  */
137 interface IERC721 is IERC165 {
138     /**
139      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
140      */
141     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
142 
143     /**
144      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
145      */
146     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
147 
148     /**
149      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
150      */
151     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
152 
153     /**
154      * @dev Returns the number of tokens in ``owner``'s account.
155      */
156     function balanceOf(address owner) external view returns (uint256 balance);
157 
158     /**
159      * @dev Returns the owner of the `tokenId` token.
160      *
161      * Requirements:
162      *
163      * - `tokenId` must exist.
164      */
165     function ownerOf(uint256 tokenId) external view returns (address owner);
166 
167     /**
168      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
169      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
170      *
171      * Requirements:
172      *
173      * - `from` cannot be the zero address.
174      * - `to` cannot be the zero address.
175      * - `tokenId` token must exist and be owned by `from`.
176      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
177      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
178      *
179      * Emits a {Transfer} event.
180      */
181     function safeTransferFrom(
182         address from,
183         address to,
184         uint256 tokenId
185     ) external;
186 
187     /**
188      * @dev Transfers `tokenId` token from `from` to `to`.
189      *
190      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
191      *
192      * Requirements:
193      *
194      * - `from` cannot be the zero address.
195      * - `to` cannot be the zero address.
196      * - `tokenId` token must be owned by `from`.
197      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
198      *
199      * Emits a {Transfer} event.
200      */
201     function transferFrom(
202         address from,
203         address to,
204         uint256 tokenId
205     ) external;
206 
207     /**
208      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
209      * The approval is cleared when the token is transferred.
210      *
211      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
212      *
213      * Requirements:
214      *
215      * - The caller must own the token or be an approved operator.
216      * - `tokenId` must exist.
217      *
218      * Emits an {Approval} event.
219      */
220     function approve(address to, uint256 tokenId) external;
221 
222     /**
223      * @dev Returns the account approved for `tokenId` token.
224      *
225      * Requirements:
226      *
227      * - `tokenId` must exist.
228      */
229     function getApproved(uint256 tokenId) external view returns (address operator);
230 
231     /**
232      * @dev Approve or remove `operator` as an operator for the caller.
233      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
234      *
235      * Requirements:
236      *
237      * - The `operator` cannot be the caller.
238      *
239      * Emits an {ApprovalForAll} event.
240      */
241     function setApprovalForAll(address operator, bool _approved) external;
242 
243     /**
244      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
245      *
246      * See {setApprovalForAll}
247      */
248     function isApprovedForAll(address owner, address operator) external view returns (bool);
249 
250     /**
251      * @dev Safely transfers `tokenId` token from `from` to `to`.
252      *
253      * Requirements:
254      *
255      * - `from` cannot be the zero address.
256      * - `to` cannot be the zero address.
257      * - `tokenId` token must exist and be owned by `from`.
258      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
259      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
260      *
261      * Emits a {Transfer} event.
262      */
263     function safeTransferFrom(
264         address from,
265         address to,
266         uint256 tokenId,
267         bytes calldata data
268     ) external;
269 }
270 
271 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
272 
273 
274 
275 pragma solidity ^0.8.0;
276 
277 
278 /**
279  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
280  * @dev See https://eips.ethereum.org/EIPS/eip-721
281  */
282 interface IERC721Enumerable is IERC721 {
283     /**
284      * @dev Returns the total amount of tokens stored by the contract.
285      */
286     function totalSupply() external view returns (uint256);
287 
288     /**
289      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
290      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
291      */
292     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
293 
294     /**
295      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
296      * Use along with {totalSupply} to enumerate all tokens.
297      */
298     function tokenByIndex(uint256 index) external view returns (uint256);
299 }
300 
301 // File: contracts/Rng.sol
302 
303 //SPDX-License-Identifier: MIT
304 pragma solidity ^0.8.0;
305 
306 /**
307  * @title A pseudo random number generator
308  *
309  * @dev This is not a true random number generator because smart contracts must be deterministic (every node a transaction goes to must produce the same result).
310  *      True randomness requires an oracle which is both expensive in terms of gas and would take a critical part of the project off the chain.
311  */
312 struct Rng {
313     bytes32 state;
314 }
315 
316 /**
317  * @title A library for working with the Rng struct.
318  *
319  * @dev Rng cannot be a contract because then anyone could manipulate it by generating random numbers.
320  */
321 library RngLibrary {
322     /**
323      * Creates a new Rng.
324      */
325     function newRng() internal view returns (Rng memory) {
326         return Rng(getEntropy());
327     }
328 
329     /**
330      * Creates a pseudo-random value from the current block miner's address and sender.
331      */
332     function getEntropy() internal view returns (bytes32) {
333         return keccak256(abi.encodePacked(block.coinbase, msg.sender));
334     }
335 
336     /**
337      * Generates a random uint256.
338      */
339     function generate(Rng memory self) internal view returns (uint256) {
340         self.state = keccak256(abi.encodePacked(getEntropy(), self.state));
341         return uint256(self.state);
342     }
343 
344     /**
345      * Generates a random uint256 from min to max inclusive.
346      *
347      * @dev This function is not subject to modulo bias.
348      *      The chance that this function has to reroll is astronomically unlikely, but it can theoretically reroll forever.
349      */
350     function generate(Rng memory self, uint min, uint max) internal view returns (uint256) {
351         require(min <= max, "min > max");
352 
353         uint delta = max - min;
354 
355         if (delta == 0) {
356             return min;
357         }
358 
359         return generate(self) % (delta + 1) + min;
360     }
361 }
362 
363 // File: contracts/Rarities.sol
364 
365 
366 pragma solidity ^0.8.0;
367 
368 library Rarities {
369     function dominant() internal pure returns (uint16[8] memory ret) {
370         ret = [
371             2500,
372             2200,
373             1900,
374             1300,
375             800,
376             600,
377             400,
378             300
379         ];
380     }
381     
382     function recessive() internal pure returns (uint16[6] memory ret) {
383         ret = [
384             4000,
385             2500,
386             1500,
387             1000,
388             600,
389             400
390         ];
391     }
392     
393     function outfit() internal pure returns (uint16[27] memory ret) {
394         ret = [
395             700,
396             700,
397             700,
398             600,
399             600,
400             600,
401             600,
402             600,
403             600,
404             600,
405             600,
406             500,
407             500,
408             400,
409             400,
410             300,
411             200,
412             200,
413             100,
414             100,
415             100,
416             75,
417             50,
418             50,
419             50,
420             50,
421             25
422         ];
423     }
424     
425     function handaccessory() internal pure returns (uint16[16] memory ret) {
426         ret = [
427             5000,
428             600,
429             600,
430             600,
431             600,
432             510,
433             500,
434             500,
435             300,
436             300,
437             150,
438             100,
439             100,
440             75,
441             40,
442             25
443         ];
444     }
445     
446     function mouth() internal pure returns (uint16[22] memory ret) {
447         ret = [
448             2000,
449             1000,
450             1000,
451             1000,
452             700,
453             700,
454             700,
455             700,
456             400,
457             300,
458             300,
459             300,
460             175,
461             100,
462             100,
463             100,
464             100,
465             100,
466             75,
467             75,
468             50,
469             25
470         ];
471     }
472     
473     function eyes() internal pure returns (uint16[24] memory ret) {
474         ret = [
475             2500,
476             600,
477             600,
478             600,
479             600,
480             600,
481             600,
482             400,
483             400,
484             400,
485             400,
486             400,
487             400,
488             400,
489             400,
490             100,
491             100,
492             100,
493             100,
494             75,
495             75,
496             75,
497             50,
498             25
499         ];
500     }
501     
502     function headaccessory() internal pure returns (uint16[29] memory ret) {
503         ret = [
504             3000,
505             500,
506             500,
507             500,
508             500,
509             500,
510             500,
511             500,
512             500,
513             400,
514             300,
515             300,
516             200,
517             200,
518             200,
519             200,
520             200,
521             100,
522             100,
523             100,
524             100,
525             100,
526             100,
527             100,
528             100,
529             75,
530             50,
531             50,
532             25
533         ];
534     }
535 }
536 // File: contracts/Enums.sol
537 
538 
539 pragma solidity ^0.8.0;
540 
541 enum RerollTrait {
542     BgColor,
543     Outfit,
544     HandAccessory,
545     Mouth,
546     Eyes,
547     HeadAccessory
548 }
549 
550 enum Special {
551     NONE,
552     DEVIL,
553     GHOST,
554     HIPPIE,
555     JOKER,
556     PRISONER,
557     SQUID_GAME,
558     WHERES_WALDO,
559     HAZMAT,
560     ASTRONAUT
561 }
562 
563 enum Dominant {
564     SKELETON,
565     VAMPIRE,
566     MUMMY,
567     GHOST,
568     WITCH,
569     FRANKENSTEIN,
570     WEREWOLF,
571     PUMPKINHEAD
572 }
573 
574 enum Recessive {
575     SKELETON,
576     VAMPIRE,
577     MUMMY,
578     GHOST,
579     DEVIL,
580     KONG
581 }
582 
583 enum BgColor {
584     DARK_BLUE,
585     GRAY,
586     LIGHT_BLUE,
587     ORANGE,
588     PINK,
589     PURPLE,
590     RED,
591     TAN,
592     TEAL,
593     GREEN,
594     RAINBOW
595 }
596 
597 enum Outfit {
598     WHITE_SHORTS,
599     PINK_SHORTS,
600     GRAY_PANTS,
601     WHITE_AND_BLUE,
602     PURPLE_SHORTS,
603     PINK_AND_PURPLE,
604     BROWN_AND_WHITE,
605     BROWN_AND_BLUE,
606     BLUE_SHORTS,
607     BLUE_AND_WHITE,
608     UNDERGARMENTS,
609     LOUNGEWEAR,
610     HOBO,
611     SPORTS_JERSEY,
612     GOLD_CHAIN,
613     PAJAMAS,
614     OVERALLS,
615     SPEEDO,
616     NINJA_SUIT,
617     KARATE_UNIFORM,
618     NONE,
619     LUMBERJACK,
620     PRIEST,
621     TUX,
622     SKELETON,
623     CAMO,
624     ARMOR
625 }
626 
627 enum HandAccessory {
628     NONE,
629     BLOODY_KNIFE,
630     BOW_AND_ARROW,
631     SWORD,
632     PITCHFORK,
633     WAND,
634     SPIKED_BASEBALL_BAT,
635     ENERGY_DRINK,
636     NINJA_STARS,
637     NUNCHUCKS,
638     POOP,
639     FLAMETHROWER,
640     HOOKS,
641     WEIGHTS,
642     SKULL,
643     BRAIN
644 }
645 
646 enum Mouth {
647     NONE,
648     HAPPY,
649     MAD,
650     SMILE,
651     FANGS,
652     HAPPY_FANGS,
653     MAD_FANGS,
654     SMILE_FANGS,
655     SINGLE_TOOTH,
656     DIRTY_TEETH,
657     SMILE_DIRTY_TEETH,
658     MAD_DIRTY_TEETH,
659     BLOODY_FANGS,
660     BLACK_MASK,
661     HAPPY_BUCK_TEETH,
662     HAPPY_SINGLE_TOOTH,
663     MAD_SINGLE_TOOTH,
664     SMILE_SINGLE_TOOTH,
665     BREATHING_FIRE,
666     GOLD_GRILLS,
667     KISS,
668     SMOKING_JOINT
669 }
670 
671 enum Eyes {
672     NONE,
673     BLACK_EYE,
674     BLACKOUT,
675     BLEEDING,
676     BLOODSHOT,
677     WATERY,
678     WHITE,
679     BIGGER_BLACK_EYES,
680     BIGGER_BLEEDING,
681     BIGGER_WATERY,
682     SMALLER_BLACK_EYES,
683     SMALLER_BLEEDING,
684     SMALLER_BLOODSHOT,
685     SMALLER_WATERY,
686     SMALLER,
687     SUNGLASSES,
688     EYE_PATCH,
689     VR_HEADSET,
690     DEAD,
691     _3D_GLASSES,
692     HEART_EYES,
693     LASER_GLASSES,
694     NINJA_MASK,
695     LASER_EYES
696 }
697 
698 enum HeadAccessory {
699     NONE,
700     BUCKET_HAT,
701     FLOWER,
702     SPORTS_HEADBAND,
703     CHEF_HAT,
704     BLUE_DURAG,
705     RED_DURAG,
706     SPIKY_HAIR,
707     BONES,
708     RICE_HAT,
709     BEANIE_CAP,
710     SANTA_HAT,
711     HEAD_WOUND,
712     HEADPHONES,
713     GOLD_STUDS,
714     WIZARD_HAT,
715     LONG_HAIR,
716     AIR_PODS,
717     WHITE_PARTY_HAT,
718     BLUE_PARTY_HAT,
719     RED_PARTY_HAT,
720     GREEN_PARTY_HAT,
721     YELLOW_PARTY_HAT,
722     PURPLE_PARTY_HAT,
723     PIRATE_HAT,
724     KING_CROWN,
725     JOKER_HAT,
726     DEVIL_HORNS,
727     BRAINS
728 }
729 
730 library Enums {
731     function toString(Special v) external pure returns (string memory) {
732         if (v == Special.NONE) {
733             return "";
734         }
735     
736         if (v == Special.DEVIL) {
737             return "Devil";
738         }
739     
740         if (v == Special.GHOST) {
741             return "Ghost";
742         }
743     
744         if (v == Special.HIPPIE) {
745             return "Hippie";
746         }
747     
748         if (v == Special.JOKER) {
749             return "Society";
750         }
751     
752         if (v == Special.PRISONER) {
753             return "Prisoner";
754         }
755     
756         if (v == Special.SQUID_GAME) {
757             return "Squid Girl";
758         }
759     
760         if (v == Special.WHERES_WALDO) {
761             return "Where's Waldo?";
762         }
763     
764         if (v == Special.HAZMAT) {
765             return "Hazmat";
766         }
767     
768         if (v == Special.ASTRONAUT) {
769             return "Astronaut";
770         }
771         revert("invalid special");
772     }
773     
774     function toString(Dominant v) external pure returns (string memory) {
775         if (v == Dominant.SKELETON) {
776             return "Skeleton";
777         }
778     
779         if (v == Dominant.VAMPIRE) {
780             return "Vampire";
781         }
782     
783         if (v == Dominant.MUMMY) {
784             return "Mummy";
785         }
786     
787         if (v == Dominant.GHOST) {
788             return "Ghost";
789         }
790     
791         if (v == Dominant.WITCH) {
792             return "Witch";
793         }
794     
795         if (v == Dominant.FRANKENSTEIN) {
796             return "Frankenstein";
797         }
798     
799         if (v == Dominant.WEREWOLF) {
800             return "Werewolf";
801         }
802     
803         if (v == Dominant.PUMPKINHEAD) {
804             return "Pumpkinhead";
805         }
806         revert("invalid dominant");
807     }
808     
809     function toString(Recessive v) external pure returns (string memory) {
810         if (v == Recessive.SKELETON) {
811             return "Skeleton";
812         }
813     
814         if (v == Recessive.VAMPIRE) {
815             return "Vampire";
816         }
817     
818         if (v == Recessive.MUMMY) {
819             return "Mummy";
820         }
821     
822         if (v == Recessive.GHOST) {
823             return "Ghost";
824         }
825     
826         if (v == Recessive.DEVIL) {
827             return "Devil";
828         }
829     
830         if (v == Recessive.KONG) {
831             return "Kong";
832         }
833         revert("invalid recessive");
834     }
835     
836     function toString(BgColor v) external pure returns (string memory) {
837         if (v == BgColor.DARK_BLUE) {
838             return "Dark Blue";
839         }
840     
841         if (v == BgColor.GRAY) {
842             return "Gray";
843         }
844     
845         if (v == BgColor.LIGHT_BLUE) {
846             return "Light Blue";
847         }
848     
849         if (v == BgColor.ORANGE) {
850             return "Orange";
851         }
852     
853         if (v == BgColor.PINK) {
854             return "Pink";
855         }
856     
857         if (v == BgColor.PURPLE) {
858             return "Purple";
859         }
860     
861         if (v == BgColor.RED) {
862             return "Red";
863         }
864     
865         if (v == BgColor.TAN) {
866             return "Tan";
867         }
868     
869         if (v == BgColor.TEAL) {
870             return "Teal";
871         }
872     
873         if (v == BgColor.GREEN) {
874             return "Green";
875         }
876     
877         if (v == BgColor.RAINBOW) {
878             return "Rainbow";
879         }
880         revert("invalid bgcolor");
881     }
882     
883     function toString(Outfit v) external pure returns (string memory) {
884         if (v == Outfit.WHITE_SHORTS) {
885             return "White Shorts";
886         }
887     
888         if (v == Outfit.PINK_SHORTS) {
889             return "Pink Shorts";
890         }
891     
892         if (v == Outfit.GRAY_PANTS) {
893             return "Gray Pants";
894         }
895     
896         if (v == Outfit.WHITE_AND_BLUE) {
897             return "White and Blue";
898         }
899     
900         if (v == Outfit.PURPLE_SHORTS) {
901             return "Purple Shorts";
902         }
903     
904         if (v == Outfit.PINK_AND_PURPLE) {
905             return "Pink and Purple";
906         }
907     
908         if (v == Outfit.BROWN_AND_WHITE) {
909             return "Brown and White";
910         }
911     
912         if (v == Outfit.BROWN_AND_BLUE) {
913             return "Brown and Blue";
914         }
915     
916         if (v == Outfit.BLUE_SHORTS) {
917             return "Blue Shorts";
918         }
919     
920         if (v == Outfit.BLUE_AND_WHITE) {
921             return "Blue and White";
922         }
923     
924         if (v == Outfit.UNDERGARMENTS) {
925             return "Undergarments";
926         }
927     
928         if (v == Outfit.LOUNGEWEAR) {
929             return "Loungewear";
930         }
931     
932         if (v == Outfit.HOBO) {
933             return "Hobo";
934         }
935     
936         if (v == Outfit.SPORTS_JERSEY) {
937             return "Sports Jersey";
938         }
939     
940         if (v == Outfit.GOLD_CHAIN) {
941             return "Gold Chain";
942         }
943     
944         if (v == Outfit.PAJAMAS) {
945             return "Pajamas";
946         }
947     
948         if (v == Outfit.OVERALLS) {
949             return "Overalls";
950         }
951     
952         if (v == Outfit.SPEEDO) {
953             return "Speedo";
954         }
955     
956         if (v == Outfit.NINJA_SUIT) {
957             return "Ninja Suit";
958         }
959     
960         if (v == Outfit.KARATE_UNIFORM) {
961             return "Karate Uniform";
962         }
963     
964         if (v == Outfit.NONE) {
965             return "";
966         }
967     
968         if (v == Outfit.LUMBERJACK) {
969             return "Lumberjack";
970         }
971     
972         if (v == Outfit.PRIEST) {
973             return "Priest";
974         }
975     
976         if (v == Outfit.TUX) {
977             return "Tux";
978         }
979     
980         if (v == Outfit.SKELETON) {
981             return "Skeleton";
982         }
983     
984         if (v == Outfit.CAMO) {
985             return "Camo";
986         }
987     
988         if (v == Outfit.ARMOR) {
989             return "Armor";
990         }
991         revert("invalid outfit");
992     }
993     
994     function toString(HandAccessory v) external pure returns (string memory) {
995         if (v == HandAccessory.NONE) {
996             return "";
997         }
998     
999         if (v == HandAccessory.BLOODY_KNIFE) {
1000             return "Bloody Knife";
1001         }
1002     
1003         if (v == HandAccessory.BOW_AND_ARROW) {
1004             return "Bow and Arrow";
1005         }
1006     
1007         if (v == HandAccessory.SWORD) {
1008             return "Sword";
1009         }
1010     
1011         if (v == HandAccessory.PITCHFORK) {
1012             return "Pitchfork";
1013         }
1014     
1015         if (v == HandAccessory.WAND) {
1016             return "Wand";
1017         }
1018     
1019         if (v == HandAccessory.SPIKED_BASEBALL_BAT) {
1020             return "Spiked Baseball Bat";
1021         }
1022     
1023         if (v == HandAccessory.ENERGY_DRINK) {
1024             return "Energy Drink";
1025         }
1026     
1027         if (v == HandAccessory.NINJA_STARS) {
1028             return "Ninja Stars";
1029         }
1030     
1031         if (v == HandAccessory.NUNCHUCKS) {
1032             return "Nunchucks";
1033         }
1034     
1035         if (v == HandAccessory.POOP) {
1036             return "Poop";
1037         }
1038     
1039         if (v == HandAccessory.FLAMETHROWER) {
1040             return "Flamethrower";
1041         }
1042     
1043         if (v == HandAccessory.HOOKS) {
1044             return "Hooks";
1045         }
1046     
1047         if (v == HandAccessory.WEIGHTS) {
1048             return "Weights";
1049         }
1050     
1051         if (v == HandAccessory.SKULL) {
1052             return "Skull";
1053         }
1054     
1055         if (v == HandAccessory.BRAIN) {
1056             return "Brain";
1057         }
1058         revert("invalid handaccessory");
1059     }
1060     
1061     function toString(Mouth v) external pure returns (string memory) {
1062         if (v == Mouth.NONE) {
1063             return "";
1064         }
1065     
1066         if (v == Mouth.HAPPY) {
1067             return "Happy";
1068         }
1069     
1070         if (v == Mouth.MAD) {
1071             return "Mad";
1072         }
1073     
1074         if (v == Mouth.SMILE) {
1075             return "Smile";
1076         }
1077     
1078         if (v == Mouth.FANGS) {
1079             return "Fangs";
1080         }
1081     
1082         if (v == Mouth.HAPPY_FANGS) {
1083             return "Happy Fangs";
1084         }
1085     
1086         if (v == Mouth.MAD_FANGS) {
1087             return "Mad Fangs";
1088         }
1089     
1090         if (v == Mouth.SMILE_FANGS) {
1091             return "Smile Fangs";
1092         }
1093     
1094         if (v == Mouth.SINGLE_TOOTH) {
1095             return "Single Tooth";
1096         }
1097     
1098         if (v == Mouth.DIRTY_TEETH) {
1099             return "Dirty Teeth";
1100         }
1101     
1102         if (v == Mouth.SMILE_DIRTY_TEETH) {
1103             return "Smile Dirty Teeth";
1104         }
1105     
1106         if (v == Mouth.MAD_DIRTY_TEETH) {
1107             return "Mad Dirty Teeth";
1108         }
1109     
1110         if (v == Mouth.BLOODY_FANGS) {
1111             return "Bloody Fangs";
1112         }
1113     
1114         if (v == Mouth.BLACK_MASK) {
1115             return "Black Mask";
1116         }
1117     
1118         if (v == Mouth.HAPPY_BUCK_TEETH) {
1119             return "Happy Buck Teeth";
1120         }
1121     
1122         if (v == Mouth.HAPPY_SINGLE_TOOTH) {
1123             return "Happy Single Tooth";
1124         }
1125     
1126         if (v == Mouth.MAD_SINGLE_TOOTH) {
1127             return "Mad Single Tooth";
1128         }
1129     
1130         if (v == Mouth.SMILE_SINGLE_TOOTH) {
1131             return "Smile Single Tooth";
1132         }
1133     
1134         if (v == Mouth.BREATHING_FIRE) {
1135             return "Breathing Fire";
1136         }
1137     
1138         if (v == Mouth.GOLD_GRILLS) {
1139             return "Gold Grills";
1140         }
1141     
1142         if (v == Mouth.KISS) {
1143             return "Kiss";
1144         }
1145     
1146         if (v == Mouth.SMOKING_JOINT) {
1147             return "Smoking Joint";
1148         }
1149         revert("invalid mouth");
1150     }
1151     
1152     function toString(Eyes v) external pure returns (string memory) {
1153         if (v == Eyes.NONE) {
1154             return "";
1155         }
1156     
1157         if (v == Eyes.BLACK_EYE) {
1158             return "Black Eye";
1159         }
1160     
1161         if (v == Eyes.BLACKOUT) {
1162             return "Blackout";
1163         }
1164     
1165         if (v == Eyes.BLEEDING) {
1166             return "Bleeding";
1167         }
1168     
1169         if (v == Eyes.BLOODSHOT) {
1170             return "Bloodshot";
1171         }
1172     
1173         if (v == Eyes.WATERY) {
1174             return "Watery";
1175         }
1176     
1177         if (v == Eyes.WHITE) {
1178             return "White";
1179         }
1180     
1181         if (v == Eyes.BIGGER_BLACK_EYES) {
1182             return "Bigger Black Eyes";
1183         }
1184     
1185         if (v == Eyes.BIGGER_BLEEDING) {
1186             return "Bigger Bleeding";
1187         }
1188     
1189         if (v == Eyes.BIGGER_WATERY) {
1190             return "Bigger Watery";
1191         }
1192     
1193         if (v == Eyes.SMALLER_BLACK_EYES) {
1194             return "Smaller Black Eyes";
1195         }
1196     
1197         if (v == Eyes.SMALLER_BLEEDING) {
1198             return "Smaller Bleeding";
1199         }
1200     
1201         if (v == Eyes.SMALLER_BLOODSHOT) {
1202             return "Smaller Bloodshot";
1203         }
1204     
1205         if (v == Eyes.SMALLER_WATERY) {
1206             return "Smaller Watery";
1207         }
1208     
1209         if (v == Eyes.SMALLER) {
1210             return "Smaller";
1211         }
1212     
1213         if (v == Eyes.SUNGLASSES) {
1214             return "Sunglasses";
1215         }
1216     
1217         if (v == Eyes.EYE_PATCH) {
1218             return "Eye Patch";
1219         }
1220     
1221         if (v == Eyes.VR_HEADSET) {
1222             return "VR Headset";
1223         }
1224     
1225         if (v == Eyes.DEAD) {
1226             return "Dead";
1227         }
1228     
1229         if (v == Eyes._3D_GLASSES) {
1230             return "3D Glasses";
1231         }
1232     
1233         if (v == Eyes.HEART_EYES) {
1234             return "Heart Eyes";
1235         }
1236     
1237         if (v == Eyes.LASER_GLASSES) {
1238             return "Laser Glasses";
1239         }
1240     
1241         if (v == Eyes.NINJA_MASK) {
1242             return "Ninja Mask";
1243         }
1244     
1245         if (v == Eyes.LASER_EYES) {
1246             return "Laser Eyes";
1247         }
1248         revert("invalid eyes");
1249     }
1250     
1251     function toString(HeadAccessory v) external pure returns (string memory) {
1252         if (v == HeadAccessory.NONE) {
1253             return "";
1254         }
1255     
1256         if (v == HeadAccessory.BUCKET_HAT) {
1257             return "Bucket Hat";
1258         }
1259     
1260         if (v == HeadAccessory.FLOWER) {
1261             return "Flower";
1262         }
1263     
1264         if (v == HeadAccessory.SPORTS_HEADBAND) {
1265             return "Sports Headband";
1266         }
1267     
1268         if (v == HeadAccessory.CHEF_HAT) {
1269             return "Chef Hat";
1270         }
1271     
1272         if (v == HeadAccessory.BLUE_DURAG) {
1273             return "Blue Durag";
1274         }
1275     
1276         if (v == HeadAccessory.RED_DURAG) {
1277             return "Red Durag";
1278         }
1279     
1280         if (v == HeadAccessory.SPIKY_HAIR) {
1281             return "Spiky Hair";
1282         }
1283     
1284         if (v == HeadAccessory.BONES) {
1285             return "Bones";
1286         }
1287     
1288         if (v == HeadAccessory.RICE_HAT) {
1289             return "Rice Hat";
1290         }
1291     
1292         if (v == HeadAccessory.BEANIE_CAP) {
1293             return "Beanie Cap";
1294         }
1295     
1296         if (v == HeadAccessory.SANTA_HAT) {
1297             return "Santa Hat";
1298         }
1299     
1300         if (v == HeadAccessory.HEAD_WOUND) {
1301             return "Head Wound";
1302         }
1303     
1304         if (v == HeadAccessory.HEADPHONES) {
1305             return "Headphones";
1306         }
1307     
1308         if (v == HeadAccessory.GOLD_STUDS) {
1309             return "Gold Studs";
1310         }
1311     
1312         if (v == HeadAccessory.WIZARD_HAT) {
1313             return "Wizard Hat";
1314         }
1315     
1316         if (v == HeadAccessory.LONG_HAIR) {
1317             return "Long Hair";
1318         }
1319     
1320         if (v == HeadAccessory.AIR_PODS) {
1321             return "Air Pods";
1322         }
1323     
1324         if (v == HeadAccessory.WHITE_PARTY_HAT) {
1325             return "White Party Hat";
1326         }
1327     
1328         if (v == HeadAccessory.BLUE_PARTY_HAT) {
1329             return "Blue Party Hat";
1330         }
1331     
1332         if (v == HeadAccessory.RED_PARTY_HAT) {
1333             return "Red Party Hat";
1334         }
1335     
1336         if (v == HeadAccessory.GREEN_PARTY_HAT) {
1337             return "Green Party Hat";
1338         }
1339     
1340         if (v == HeadAccessory.YELLOW_PARTY_HAT) {
1341             return "Yellow Party Hat";
1342         }
1343     
1344         if (v == HeadAccessory.PURPLE_PARTY_HAT) {
1345             return "Purple Party Hat";
1346         }
1347     
1348         if (v == HeadAccessory.PIRATE_HAT) {
1349             return "Pirate Hat";
1350         }
1351     
1352         if (v == HeadAccessory.KING_CROWN) {
1353             return "King Crown";
1354         }
1355     
1356         if (v == HeadAccessory.JOKER_HAT) {
1357             return "Joker Hat";
1358         }
1359     
1360         if (v == HeadAccessory.DEVIL_HORNS) {
1361             return "Devil Horns";
1362         }
1363     
1364         if (v == HeadAccessory.BRAINS) {
1365             return "Brains";
1366         }
1367         revert("invalid headaccessory");
1368     }
1369 }
1370 
1371 // File: contracts/BitMonster.sol
1372 
1373 
1374 pragma solidity ^0.8.0;
1375 
1376 
1377 struct BitMonster {
1378     bool genesis;
1379     bool superYield;
1380     Special special;
1381     Dominant dominant;
1382     Recessive recessive;
1383     BgColor bgColor;
1384     Outfit outfit;
1385     HandAccessory handAccessory;
1386     Mouth mouth;
1387     Eyes eyes;
1388     HeadAccessory headAccessory;
1389 }
1390 
1391 // File: contracts/IBitMonsters.sol
1392 
1393 
1394 pragma solidity ^0.8.0;
1395 
1396 
1397 
1398 interface IBitMonsters is IERC721Enumerable {
1399     function getBitMonster(uint256 tokenId) external view returns (BitMonster memory);
1400     function setBitMonster(uint256 tokenId, BitMonster memory bm) external;
1401     function createBitMonster(BitMonster memory bm, address owner) external;
1402     function isAdmin(address addr) external view returns (bool);
1403 }
1404 // File: contracts/BitMonstersAddon.sol
1405 
1406 
1407 pragma solidity ^0.8.0;
1408 
1409 
1410 
1411 /**
1412  * @title A contract should inherit this if it provides functionality for the Bit Monsters contract.
1413  */
1414 abstract contract BitMonstersAddon is Ownable {
1415     IBitMonsters internal bitMonsters;
1416 
1417     modifier onlyAdmin() {
1418         require(bitMonsters.isAdmin(msg.sender), "admins only");
1419         _;
1420     }
1421 
1422     modifier ownsToken(uint tokenId) {
1423         require(bitMonsters.ownerOf(tokenId) == msg.sender, "you don't own this shit");
1424         _;
1425     }
1426 
1427     /**
1428      * @notice This must be called before the Brainz contract can be used.
1429      *
1430      * @dev Within the BitMonsters contract, call initializeBrainz().
1431      */
1432     function setBitMonstersContract(IBitMonsters _contract) external onlyOwner {
1433         bitMonsters = _contract;
1434     }
1435 }
1436 
1437 // File: contracts/BitMonsterGen.sol
1438 
1439 
1440 pragma solidity ^0.8.0;
1441 
1442 
1443 
1444 
1445 
1446 library BitMonsterGen {
1447     using RngLibrary for Rng;
1448 
1449     function getRandomBgColor(Rng memory rng) internal view returns (BgColor) {
1450         if (rng.generate(1, 1000) == 1) {
1451             return BgColor.RAINBOW;
1452         }
1453         return BgColor(rng.generate(0, 9));
1454     }
1455 
1456     function getRandomDominant(Rng memory rng) internal view returns (Dominant) {
1457         // all rarities are out of 10000
1458         uint rn = rng.generate(0, 9999);
1459         uint16[8] memory rarities = Rarities.dominant();
1460     
1461         for (uint i = 0; i < rarities.length; ++i) {
1462             if (rarities[i] > rn) {
1463                 return Dominant(i);
1464             }
1465             rn -= rarities[i];
1466         }
1467         revert("getRandomDominant() is fucked");
1468     } 
1469     
1470     function getRandomRecessive(Rng memory rng) internal view returns (Recessive) {
1471         // all rarities are out of 10000
1472         uint rn = rng.generate(0, 9999);
1473         uint16[6] memory rarities = Rarities.recessive();
1474     
1475         for (uint i = 0; i < rarities.length; ++i) {
1476             if (rarities[i] > rn) {
1477                 return Recessive(i);
1478             }
1479             rn -= rarities[i];
1480         }
1481         revert("getRandomRecessive() is fucked");
1482     } 
1483     
1484     function getRandomOutfit(Rng memory rng) internal view returns (Outfit) {
1485         // all rarities are out of 10000
1486         uint rn = rng.generate(0, 9999);
1487         uint16[27] memory rarities = Rarities.outfit();
1488     
1489         for (uint i = 0; i < rarities.length; ++i) {
1490             if (rarities[i] > rn) {
1491                 return Outfit(i);
1492             }
1493             rn -= rarities[i];
1494         }
1495         revert("getRandomOutfit() is fucked");
1496     } 
1497     
1498     function getRandomHandAccessory(Rng memory rng) internal view returns (HandAccessory) {
1499         // all rarities are out of 10000
1500         uint rn = rng.generate(0, 9999);
1501         uint16[16] memory rarities = Rarities.handaccessory();
1502     
1503         for (uint i = 0; i < rarities.length; ++i) {
1504             if (rarities[i] > rn) {
1505                 return HandAccessory(i);
1506             }
1507             rn -= rarities[i];
1508         }
1509         revert("getRandomHandAccessory() is fucked");
1510     } 
1511     
1512     function getRandomMouth(Rng memory rng) internal view returns (Mouth) {
1513         // all rarities are out of 10000
1514         uint rn = rng.generate(0, 9999);
1515         uint16[22] memory rarities = Rarities.mouth();
1516     
1517         for (uint i = 0; i < rarities.length; ++i) {
1518             if (rarities[i] > rn) {
1519                 return Mouth(i);
1520             }
1521             rn -= rarities[i];
1522         }
1523         revert("getRandomMouth() is fucked");
1524     } 
1525     
1526     function getRandomEyes(Rng memory rng) internal view returns (Eyes) {
1527         // all rarities are out of 10000
1528         uint rn = rng.generate(0, 9999);
1529         uint16[24] memory rarities = Rarities.eyes();
1530     
1531         for (uint i = 0; i < rarities.length; ++i) {
1532             if (rarities[i] > rn) {
1533                 return Eyes(i);
1534             }
1535             rn -= rarities[i];
1536         }
1537         revert("getRandomEyes() is fucked");
1538     } 
1539     
1540     function getRandomHeadAccessory(Rng memory rng) internal view returns (HeadAccessory) {
1541         // all rarities are out of 10000
1542         uint rn = rng.generate(0, 9999);
1543         uint16[29] memory rarities = Rarities.headaccessory();
1544     
1545         for (uint i = 0; i < rarities.length; ++i) {
1546             if (rarities[i] > rn) {
1547                 return HeadAccessory(i);
1548             }
1549             rn -= rarities[i];
1550         }
1551         revert("getRandomHeadAccessory() is fucked");
1552     } 
1553 
1554     function generateUnspecialBitMonster(Rng memory rng) internal view returns (BitMonster memory) {
1555         BitMonster memory ret = BitMonster({
1556             genesis:       true,
1557             superYield:    rng.generate(0, 99) == 0,
1558             special:       Special.NONE,
1559             dominant:      getRandomDominant(rng),
1560             recessive:     getRandomRecessive(rng),
1561             bgColor:       getRandomBgColor(rng),
1562             outfit:        getRandomOutfit(rng),
1563             handAccessory: getRandomHandAccessory(rng),
1564             mouth:         getRandomMouth(rng),
1565             eyes:          getRandomEyes(rng),
1566             headAccessory: getRandomHeadAccessory(rng)
1567         });
1568 
1569         return ret;
1570     }
1571 
1572     function generateSpecialBitMonster(Rng memory rng, bool[9] memory mintedSpecials) internal view returns (BitMonster memory) {
1573         uint available = mintedSpecials.length;
1574         for (uint i = 0; i < mintedSpecials.length; ++i) {
1575             if (mintedSpecials[i]) {
1576                 available--;
1577             }
1578         }
1579 
1580         if (available == 0) {
1581             return generateUnspecialBitMonster(rng);
1582         }
1583 
1584         uint rn = rng.generate(0, available - 1);
1585         uint special;
1586 
1587         // generate a random special index, skipping specials that do not exist
1588         for (special = 0; special < 9; ++special) {
1589             if (mintedSpecials[special]) {
1590                 continue;
1591             }
1592             if (rn == 0) {
1593                 break;
1594             }
1595             rn -= 1;
1596         }
1597 
1598         require(!mintedSpecials[special]);
1599         mintedSpecials[special] = true;
1600 
1601         return BitMonster({
1602             genesis:       true,
1603             superYield:    rng.generate(0, 4) == 0,
1604             // + 1 because 0 is None
1605             special:       Special(special + 1),
1606             dominant:      getRandomDominant(rng),
1607             recessive:     getRandomRecessive(rng),
1608             bgColor:       BgColor.DARK_BLUE,
1609             outfit:        Outfit.NONE,
1610             handAccessory: HandAccessory.NONE,
1611             mouth:         Mouth.NONE,
1612             eyes:          Eyes.NONE,
1613             headAccessory: HeadAccessory.NONE
1614         });
1615     }
1616 
1617     function rerollTrait(Rng memory rng, BitMonster memory bm, RerollTrait trait) internal view {
1618         bm.genesis = false;
1619         if (trait == RerollTrait.BgColor) {
1620             BgColor existing = bm.bgColor;
1621             while (bm.bgColor == existing) {
1622                 bm.bgColor = getRandomBgColor(rng);
1623             }
1624         }
1625         else if (trait == RerollTrait.Outfit) {
1626             Outfit existing = bm.outfit;
1627             while (bm.outfit == existing) {
1628                 bm.outfit = getRandomOutfit(rng);
1629             }
1630         }
1631         else if (trait == RerollTrait.HandAccessory) {
1632             HandAccessory existing = bm.handAccessory;
1633             while (bm.handAccessory == existing) {
1634                 bm.handAccessory = getRandomHandAccessory(rng);
1635             }
1636         }
1637         else if (trait == RerollTrait.Mouth) {
1638             Mouth existing = bm.mouth;
1639             while (bm.mouth == existing) {
1640                 bm.mouth = getRandomMouth(rng);
1641             }
1642         }
1643         else if (trait == RerollTrait.Eyes) {
1644             Eyes existing = bm.eyes;
1645             while (bm.eyes == existing) {
1646                 bm.eyes = getRandomEyes(rng);
1647             }
1648         }
1649         else if (trait == RerollTrait.HeadAccessory) {
1650             HeadAccessory existing = bm.headAccessory;
1651             while (bm.headAccessory == existing) {
1652                 bm.headAccessory = getRandomHeadAccessory(rng);
1653             }
1654         }
1655         else {
1656             revert("Invalid reroll trait");
1657         }
1658     }
1659 
1660     function rerollAll(Rng memory rng, BitMonster memory bm) internal view {
1661         bm.genesis = false;
1662         bm.bgColor = getRandomBgColor(rng);
1663         bm.outfit = getRandomOutfit(rng);
1664         bm.handAccessory = getRandomHandAccessory(rng);
1665         bm.mouth = getRandomMouth(rng);
1666         bm.eyes = getRandomEyes(rng);
1667         bm.headAccessory = getRandomHeadAccessory(rng);
1668     }
1669 }
1670 
1671 // File: @openzeppelin/contracts/utils/Address.sol
1672 
1673 
1674 
1675 pragma solidity ^0.8.0;
1676 
1677 /**
1678  * @dev Collection of functions related to the address type
1679  */
1680 library Address {
1681     /**
1682      * @dev Returns true if `account` is a contract.
1683      *
1684      * [IMPORTANT]
1685      * ====
1686      * It is unsafe to assume that an address for which this function returns
1687      * false is an externally-owned account (EOA) and not a contract.
1688      *
1689      * Among others, `isContract` will return false for the following
1690      * types of addresses:
1691      *
1692      *  - an externally-owned account
1693      *  - a contract in construction
1694      *  - an address where a contract will be created
1695      *  - an address where a contract lived, but was destroyed
1696      * ====
1697      */
1698     function isContract(address account) internal view returns (bool) {
1699         // This method relies on extcodesize, which returns 0 for contracts in
1700         // construction, since the code is only stored at the end of the
1701         // constructor execution.
1702 
1703         uint256 size;
1704         assembly {
1705             size := extcodesize(account)
1706         }
1707         return size > 0;
1708     }
1709 
1710     /**
1711      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1712      * `recipient`, forwarding all available gas and reverting on errors.
1713      *
1714      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1715      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1716      * imposed by `transfer`, making them unable to receive funds via
1717      * `transfer`. {sendValue} removes this limitation.
1718      *
1719      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1720      *
1721      * IMPORTANT: because control is transferred to `recipient`, care must be
1722      * taken to not create reentrancy vulnerabilities. Consider using
1723      * {ReentrancyGuard} or the
1724      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1725      */
1726     function sendValue(address payable recipient, uint256 amount) internal {
1727         require(address(this).balance >= amount, "Address: insufficient balance");
1728 
1729         (bool success, ) = recipient.call{value: amount}("");
1730         require(success, "Address: unable to send value, recipient may have reverted");
1731     }
1732 
1733     /**
1734      * @dev Performs a Solidity function call using a low level `call`. A
1735      * plain `call` is an unsafe replacement for a function call: use this
1736      * function instead.
1737      *
1738      * If `target` reverts with a revert reason, it is bubbled up by this
1739      * function (like regular Solidity function calls).
1740      *
1741      * Returns the raw returned data. To convert to the expected return value,
1742      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1743      *
1744      * Requirements:
1745      *
1746      * - `target` must be a contract.
1747      * - calling `target` with `data` must not revert.
1748      *
1749      * _Available since v3.1._
1750      */
1751     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1752         return functionCall(target, data, "Address: low-level call failed");
1753     }
1754 
1755     /**
1756      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1757      * `errorMessage` as a fallback revert reason when `target` reverts.
1758      *
1759      * _Available since v3.1._
1760      */
1761     function functionCall(
1762         address target,
1763         bytes memory data,
1764         string memory errorMessage
1765     ) internal returns (bytes memory) {
1766         return functionCallWithValue(target, data, 0, errorMessage);
1767     }
1768 
1769     /**
1770      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1771      * but also transferring `value` wei to `target`.
1772      *
1773      * Requirements:
1774      *
1775      * - the calling contract must have an ETH balance of at least `value`.
1776      * - the called Solidity function must be `payable`.
1777      *
1778      * _Available since v3.1._
1779      */
1780     function functionCallWithValue(
1781         address target,
1782         bytes memory data,
1783         uint256 value
1784     ) internal returns (bytes memory) {
1785         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1786     }
1787 
1788     /**
1789      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1790      * with `errorMessage` as a fallback revert reason when `target` reverts.
1791      *
1792      * _Available since v3.1._
1793      */
1794     function functionCallWithValue(
1795         address target,
1796         bytes memory data,
1797         uint256 value,
1798         string memory errorMessage
1799     ) internal returns (bytes memory) {
1800         require(address(this).balance >= value, "Address: insufficient balance for call");
1801         require(isContract(target), "Address: call to non-contract");
1802 
1803         (bool success, bytes memory returndata) = target.call{value: value}(data);
1804         return verifyCallResult(success, returndata, errorMessage);
1805     }
1806 
1807     /**
1808      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1809      * but performing a static call.
1810      *
1811      * _Available since v3.3._
1812      */
1813     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1814         return functionStaticCall(target, data, "Address: low-level static call failed");
1815     }
1816 
1817     /**
1818      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1819      * but performing a static call.
1820      *
1821      * _Available since v3.3._
1822      */
1823     function functionStaticCall(
1824         address target,
1825         bytes memory data,
1826         string memory errorMessage
1827     ) internal view returns (bytes memory) {
1828         require(isContract(target), "Address: static call to non-contract");
1829 
1830         (bool success, bytes memory returndata) = target.staticcall(data);
1831         return verifyCallResult(success, returndata, errorMessage);
1832     }
1833 
1834     /**
1835      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1836      * but performing a delegate call.
1837      *
1838      * _Available since v3.4._
1839      */
1840     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1841         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1842     }
1843 
1844     /**
1845      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1846      * but performing a delegate call.
1847      *
1848      * _Available since v3.4._
1849      */
1850     function functionDelegateCall(
1851         address target,
1852         bytes memory data,
1853         string memory errorMessage
1854     ) internal returns (bytes memory) {
1855         require(isContract(target), "Address: delegate call to non-contract");
1856 
1857         (bool success, bytes memory returndata) = target.delegatecall(data);
1858         return verifyCallResult(success, returndata, errorMessage);
1859     }
1860 
1861     /**
1862      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1863      * revert reason using the provided one.
1864      *
1865      * _Available since v4.3._
1866      */
1867     function verifyCallResult(
1868         bool success,
1869         bytes memory returndata,
1870         string memory errorMessage
1871     ) internal pure returns (bytes memory) {
1872         if (success) {
1873             return returndata;
1874         } else {
1875             // Look for revert reason and bubble it up if present
1876             if (returndata.length > 0) {
1877                 // The easiest way to bubble the revert reason is using memory via assembly
1878 
1879                 assembly {
1880                     let returndata_size := mload(returndata)
1881                     revert(add(32, returndata), returndata_size)
1882                 }
1883             } else {
1884                 revert(errorMessage);
1885             }
1886         }
1887     }
1888 }
1889 
1890 // File: contracts/Minter.sol
1891 
1892 
1893 pragma solidity ^0.8.0;
1894 
1895 
1896 
1897 
1898 
1899 
1900 
1901 /**
1902  * @title Controls who (if anyone) can mint a Bit Monster.
1903  *
1904  * @dev In web3, these are represented as 0 (NotAllowed), 1 (WhitelistOnly), and 2 (AllAllowed).
1905  */
1906 enum MintingState {
1907     NotAllowed,
1908     WhitelistOnly,
1909     AllAllowed
1910 }
1911 
1912 contract Minter is BitMonstersAddon {
1913     using RngLibrary for Rng;
1914 
1915     uint256 constant public WHITELIST_PER = 6;
1916 
1917     address payable private payHere;
1918     // 0 == "not whitelisted"
1919     // 1000 + x == "whitelisted and x whitelists left"
1920     mapping (address => uint256) public whitelist;
1921     MintingState public mintingState;
1922 
1923     bool[9] public mintedSpecials;
1924     uint private mintedSpecialsCount = 0;
1925 
1926     Rng private rng;
1927 
1928     constructor(address payable paymentAddress, address[] memory whitelistedAddrs) {
1929         payHere = paymentAddress;
1930         whitelist[paymentAddress] = WHITELIST_PER + 1000;
1931         for (uint i = 0; i < whitelistedAddrs.length; ++i) {
1932             whitelist[whitelistedAddrs[i]] = WHITELIST_PER + 1000;
1933         }
1934         rng = RngLibrary.newRng();
1935     }
1936 
1937     /**
1938      * Adds someone to the whitelist.
1939      */
1940     function addToWhitelist(address[] memory addrs) external onlyAdmin {
1941         for (uint i = 0; i < addrs.length; ++i) {
1942             if (whitelist[addrs[i]] == 0) {
1943                 whitelist[addrs[i]] = WHITELIST_PER + 1000;
1944             }
1945         }
1946     }
1947 
1948     /**
1949      * Removes someone from the whitelist.
1950      */
1951     function removeFromWhitelist(address addr) external onlyAdmin {
1952         delete whitelist[addr];
1953     }
1954 
1955     /**
1956      * Generates a random Bit Monster.
1957      *
1958      * 9/6666 bit monsters will be special, which means they're prebuilt images instead of assembled from the 6 attributes a normal Bit Monster has.
1959      * All 9 specials are guaranteed to be minted by the time all 6666 Bit Monsters are minted.
1960      * The chance of a special at each roll is roughly even, although there's a slight dip in chance in the mid-range.
1961      */
1962     function generateBitMonster(Rng memory rn, bool[9] memory ms) internal returns (BitMonster memory) {
1963         uint count = bitMonsters.totalSupply();
1964 
1965         int ub = 6666 - int(count) - 1 - (90 - int(mintedSpecialsCount) * 10);
1966         if (ub < 0) {
1967             ub = 0;
1968         }
1969 
1970         BitMonster memory m;
1971         if (rn.generate(0, uint(ub)) <= (6666 - count) / 666) {
1972             m = BitMonsterGen.generateSpecialBitMonster(rn, ms);
1973         }
1974         else {
1975             m = BitMonsterGen.generateUnspecialBitMonster(rn);
1976         }
1977 
1978         if (m.special != Special.NONE) {
1979             mintedSpecialsCount++;
1980         }
1981         rng = rn;
1982         return m;
1983     }
1984 
1985     /**
1986      * Sets the MintingState. See MintingState above.
1987      * By default, no one is allowed to mint. This function must be called before any Bit Monsters can be minted.
1988      */
1989     function setMintingState(MintingState state) external onlyAdmin {
1990         mintingState = state;
1991     }
1992 
1993     /**
1994      * Mints some Bit Monsters.
1995      *
1996      * @param count The number of Bit Monsters to mint. Must be >= 1 and <= 10.
1997      *              You must send 0.06 ETH for each Bit Monster you want to mint.
1998      */
1999     function mint(uint count) external payable {
2000         require(count >= 1 && count <= 10, "Count must be >=1 and <=10");
2001         require(!Address.isContract(msg.sender), "Contracts cannot mint");
2002         require(mintingState != MintingState.NotAllowed, "Minting is not allowed atm");
2003 
2004         if (mintingState == MintingState.WhitelistOnly) {
2005             require(whitelist[msg.sender] >= 1000 + count, "Not enough whitelisted mints");
2006             whitelist[msg.sender] -= count;
2007         }
2008 
2009         require(msg.value == count * 0.06 ether, "Send exactly 0.06 ETH for each mint");
2010 
2011         Rng memory rn = rng;
2012         bool[9] memory ms = mintedSpecials;
2013 
2014         for (uint i = 0; i < count; ++i) {
2015             bitMonsters.createBitMonster(generateBitMonster(rn, ms), msg.sender);
2016         }
2017 
2018         rng = rn;
2019         mintedSpecials = ms;
2020 
2021         Address.sendValue(payHere, msg.value);
2022     }
2023 
2024     /**
2025      * Mint for a giveaway.
2026      */
2027     function giveawayMint(address[] memory winners) external onlyAdmin {
2028         Rng memory rn = rng;
2029 
2030         for (uint i = 0; i < winners.length; ++i) {
2031             bitMonsters.createBitMonster(BitMonsterGen.generateUnspecialBitMonster(rn), winners[i]);
2032         }
2033 
2034         rng = rn;
2035     }
2036 }